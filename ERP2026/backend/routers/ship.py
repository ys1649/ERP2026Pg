from datetime import date as date_type

from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel
from typing import Optional

from database import get_conn
from services.numbering import next_code
from services.inventory import insert_transaction, delete_transactions_and_recalc, TRN_SHP, DEFAULT_INV
from services.accounting import insert_journal, insert_journal_line, chk_dc_balance, delete_journal
from services.sysparam import get_sys_param

router = APIRouter()

STATUS_UNBOOK = 0
STATUS_CONFIRM = 1

CREATOR = "WYS"  # 尚無登入系統，比照其他模組先固定值


class ShipLine(BaseModel):
    prd_no: str
    smd_unit_price: float
    smd_qty: float
    smd_prd_name: Optional[str] = None


class ShipCreate(BaseModel):
    cum_no: str
    epy_no: str
    car_no: Optional[str] = None
    smt_inv_no: Optional[str] = None
    smt_date: str
    smt_destination: Optional[str] = None
    smt_tax: float = 0
    smt_deliver1: Optional[str] = None
    smt_deliver2: Optional[str] = None
    smt_desc: Optional[str] = None
    lines: list[ShipLine]


class QuickCollectRequest(BaseModel):
    arr_date: str
    cash: float = 0
    check: float = 0
    discount: float = 0


def row_to_dict(cur, row):
    return dict(zip([d[0].lower() for d in cur.description], row))


def _lock_ship(cur, smt_no: str) -> dict:
    cur.execute("SELECT * FROM TBL_SHIP WHERE SMT_NO=%(no)s FOR UPDATE", {"no": smt_no})
    row = cur.fetchone()
    if not row:
        raise HTTPException(404, "出貨單不存在")
    return row_to_dict(cur, row)


def _get_lines(cur, smt_no: str) -> list:
    cur.execute(
        """SELECT D.SMT_NO,D.SMD_SEQNO,D.PRD_NO,D.INV_NO,D.SMD_PRD_NAME,
                  D.SMD_UNIT_PRICE,D.SMD_QTY,D.SMD_COST,
                  P.PRD_NAME,P.PRD_UNIT,P.PRD_ONHAND
           FROM TBL_SHIP_DT D
           LEFT JOIN TBL_PRODUCT P ON P.PRD_NO=D.PRD_NO
           WHERE D.SMT_NO=%(no)s ORDER BY D.SMD_SEQNO""",
        {"no": smt_no},
    )
    return [row_to_dict(cur, r) for r in cur.fetchall()]


def _check_period(sp: dict, smt_date):
    period_start = sp["spr_period_start"]
    if hasattr(smt_date, "date"):
        smt_date_d = smt_date.date()
    else:
        smt_date_d = smt_date
    if hasattr(period_start, "date"):
        period_start = period_start.date()
    if smt_date_d < period_start:
        raise HTTPException(400, f"異動日期不可早於結帳日 {period_start}")


def _check_year(sp: dict, smt_date):
    if smt_date.year < sp["spr_acnt_year"]:
        raise HTTPException(400, "不可修改小於本會計年度的傳票")


SORTABLE_COLUMNS = {
    "smt_no": "M.SMT_NO",
    "smt_date": "M.SMT_DATE",
    "cum_no": "M.CUM_NO",
    "cum_name": "C.CUM_NAME",
    "epy_name": "E.EPY_NAME",
    "smt_inv_no": "M.SMT_INV_NO",
    "smt_amount": "(M.SMT_TOTAL+M.SMT_TAX)",
    "smt_not_clean": "M.SMT_NOT_CLEAN",
    "smt_status": "M.SMT_STATUS",
}


def _parse_sort(sort: Optional[str]) -> str:
    """把前端表格欄位排序（如 "smt_date:desc,cum_no:asc"）轉成 ORDER BY 子句，僅接受白名單欄位。"""
    if not sort:
        return "M.SMT_DATE DESC, M.SMT_NO DESC"
    parts = []
    for item in sort.split(","):
        field, _, direction = item.partition(":")
        col = SORTABLE_COLUMNS.get(field.strip())
        if not col:
            continue
        parts.append(f"{col} {'DESC' if direction.strip() == 'desc' else 'ASC'}")
    return ", ".join(parts) if parts else "M.SMT_DATE DESC, M.SMT_NO DESC"


@router.get("")
def list_ships(
    q: Optional[str] = Query(None),
    status: Optional[int] = Query(None),
    date_from: Optional[str] = Query(None),
    date_to: Optional[str] = Query(None),
    cum_no: Optional[str] = Query(None),
    epy_no: Optional[str] = Query(None),
    smt_no: Optional[str] = Query(None),
    smt_inv_no: Optional[str] = Query(None),
    prd_no: Optional[str] = Query(None),
    sort: Optional[str] = Query(None),
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=500),
):
    with get_conn() as conn:
        cur = conn.cursor()
        where = ["1=1"]
        params: dict = {}
        if q and q.strip():
            where.append(
                "(UPPER(M.SMT_NO) LIKE UPPER(%(q1)s) OR UPPER(M.CUM_NO) LIKE UPPER(%(q2)s)"
                " OR UPPER(C.CUM_NAME) LIKE UPPER(%(q3)s) OR UPPER(M.SMT_INV_NO) LIKE UPPER(%(q4)s))"
            )
            pq = f"%{q.strip()}%"
            params.update({"q1": pq, "q2": pq, "q3": pq, "q4": pq})
        if status is not None:
            where.append("M.SMT_STATUS=%(status)s")
            params["status"] = status
        if date_from:
            where.append("M.SMT_DATE>=%(date_from)s")
            params["date_from"] = date_from
        if date_to:
            where.append("M.SMT_DATE<%(date_to)s::date + 1")
            params["date_to"] = date_to
        if cum_no:
            where.append("M.CUM_NO=%(cum_no)s")
            params["cum_no"] = cum_no
        if epy_no:
            where.append("M.EPY_NO=%(epy_no)s")
            params["epy_no"] = epy_no
        if smt_no:
            where.append("UPPER(M.SMT_NO) LIKE UPPER(%(smt_no)s)")
            params["smt_no"] = f"%{smt_no}%"
        if smt_inv_no:
            where.append("UPPER(M.SMT_INV_NO) LIKE UPPER(%(smt_inv_no)s)")
            params["smt_inv_no"] = f"%{smt_inv_no}%"
        if prd_no:
            where.append("EXISTS (SELECT 1 FROM TBL_SHIP_DT D WHERE D.SMT_NO=M.SMT_NO AND D.PRD_NO=%(prd_no)s)")
            params["prd_no"] = prd_no
        where_sql = " AND ".join(where)
        order_sql = _parse_sort(sort)

        cur.execute(
            f"""SELECT COUNT(*) FROM TBL_SHIP M
                LEFT JOIN TBL_CUSTOMER C ON C.CUM_NO=M.CUM_NO
                WHERE {where_sql}""",
            params,
        )
        total = cur.fetchone()[0]

        offset = (page - 1) * page_size
        cur.execute(
            f"""SELECT M.SMT_NO,M.CUM_NO,C.CUM_NAME,M.EPY_NO,E.EPY_NAME,M.SMT_DATE,
                       M.SMT_STATUS,M.SMT_INV_NO,M.SMT_TOTAL,M.SMT_TAX,
                       (M.SMT_TOTAL+M.SMT_TAX) AS SMT_AMOUNT,M.SMT_NOT_CLEAN
                FROM TBL_SHIP M
                LEFT JOIN TBL_CUSTOMER C ON C.CUM_NO=M.CUM_NO
                LEFT JOIN TBL_EMPLOYE E ON E.EPY_NO=M.EPY_NO
                WHERE {where_sql}
                ORDER BY {order_sql}
                OFFSET %(offset)s ROWS FETCH NEXT %(lim)s ROWS ONLY""",
            {**params, "offset": offset, "lim": page_size},
        )
        rows = [row_to_dict(cur, r) for r in cur.fetchall()]
        return {"total": total, "page": page, "page_size": page_size, "data": rows}


@router.get("/price")
def get_price(cum_no: str, prd_no: str):
    """比照 GetCusHisPrice：該客戶上次購買此產品的單價，否則用產品目前售價。"""
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """SELECT D.SMD_UNIT_PRICE FROM TBL_SHIP M
               INNER JOIN TBL_SHIP_DT D ON M.SMT_NO=D.SMT_NO
               WHERE M.CUM_NO=%(cum)s AND D.PRD_NO=%(prd)s
               ORDER BY M.SMT_DATE DESC LIMIT 1""",
            {"cum": cum_no, "prd": prd_no},
        )
        row = cur.fetchone()
        if row:
            return {"price": float(row[0])}
        cur.execute("SELECT PRD_SALE_PRICE FROM TBL_PRODUCT WHERE PRD_NO=%(prd)s", {"prd": prd_no})
        row = cur.fetchone()
        return {"price": float(row[0]) if row else 0}


@router.get("/history/{cum_no}")
def get_history(cum_no: str, exclude: Optional[str] = None):
    """該客戶歷史出貨紀錄。TBL_HIS_SHIP 目前無資料（舊系統實際上沒在用歸檔機制），直接查 TBL_SHIP。"""
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """SELECT M.SMT_NO,M.SMT_DATE,M.SMT_INV_NO,M.SMT_TOTAL,M.SMT_TAX,M.SMT_STATUS,
                      M.SMT_NOT_CLEAN,M.SMT_DESC,M.SMT_COST,M.EPY_NO,E.EPY_NAME
               FROM TBL_SHIP M
               LEFT JOIN TBL_EMPLOYE E ON E.EPY_NO=M.EPY_NO
               WHERE M.CUM_NO=%(cum)s AND M.SMT_NO<>COALESCE(%(exclude)s,'')
               ORDER BY M.SMT_DATE DESC, M.SMT_NO DESC LIMIT 200""",
            {"cum": cum_no, "exclude": exclude},
        )
        return [row_to_dict(cur, r) for r in cur.fetchall()]


@router.get("/{smt_no}")
def get_ship(smt_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """SELECT M.*,C.CUM_NAME,E.EPY_NAME,
                      D1.EPY_NAME AS DELIVER1_NAME, D2.EPY_NAME AS DELIVER2_NAME,
                      CAR.CAR_LICENSE_NO
               FROM TBL_SHIP M
               LEFT JOIN TBL_CUSTOMER C ON C.CUM_NO=M.CUM_NO
               LEFT JOIN TBL_EMPLOYE E ON E.EPY_NO=M.EPY_NO
               LEFT JOIN TBL_EMPLOYE D1 ON D1.EPY_NO=M.SMT_DELIVER1
               LEFT JOIN TBL_EMPLOYE D2 ON D2.EPY_NO=M.SMT_DELIVER2
               LEFT JOIN TBL_CAR CAR ON CAR.CAR_NO=M.CAR_NO
               WHERE M.SMT_NO=%(no)s""",
            {"no": smt_no},
        )
        row = cur.fetchone()
        if not row:
            raise HTTPException(404, "出貨單不存在")
        header = row_to_dict(cur, row)
        header["lines"] = _get_lines(cur, smt_no)
        return header


@router.post("", status_code=201)
def create_ship(data: ShipCreate):
    if not data.lines:
        raise HTTPException(400, "至少需要一筆品項")
    with get_conn() as conn:
        cur = conn.cursor()
        sp = get_sys_param(cur)
        smt_date = data.smt_date
        _check_period(sp, date_type.fromisoformat(smt_date))

        total = sum(l.smd_qty * l.smd_unit_price for l in data.lines)
        smt_no = next_code(cur, "TBL_SHIP", "SMT_NO", date_type.fromisoformat(smt_date))

        cur.execute(
            """INSERT INTO TBL_SHIP
                   (SMT_NO,CUM_NO,EPY_NO,CAR_NO,SMT_STATUS,SMT_INV_NO,SMT_DATE,
                    SMT_DESTINATION,SMT_TOTAL,SMT_TAX,SMT_NOT_CLEAN,SMT_COST,
                    SMT_DELIVER1,SMT_DELIVER2,SMT_DESC,SMT_CREATOR)
               VALUES (%(no)s,%(cum)s,%(epy)s,%(car)s,%(status)s,%(inv)s,%(date)s,
                       %(dest)s,%(total)s,%(tax)s,0,0,
                       %(d1)s,%(d2)s,%(desc)s,%(creator)s)""",
            {
                "no": smt_no, "cum": data.cum_no, "epy": data.epy_no, "car": data.car_no,
                "status": STATUS_UNBOOK, "inv": data.smt_inv_no, "date": smt_date,
                "dest": data.smt_destination, "total": total, "tax": data.smt_tax,
                "d1": data.smt_deliver1, "d2": data.smt_deliver2, "desc": data.smt_desc,
                "creator": CREATOR,
            },
        )
        _insert_lines(cur, smt_no, data.lines)
        return {"message": "新增成功", "smt_no": smt_no}


def _insert_lines(cur, smt_no: str, lines: list[ShipLine]):
    for i, line in enumerate(lines, start=1):
        cur.execute(
            """INSERT INTO TBL_SHIP_DT
                   (SMT_NO,SMD_SEQNO,PRD_NO,INV_NO,SMD_PRD_NAME,SMD_UNIT_PRICE,SMD_QTY,SMD_COST)
               VALUES (%(no)s,%(seq)s,%(prd)s,%(inv)s,%(name)s,%(price)s,%(qty)s,0)""",
            {
                "no": smt_no, "seq": i, "prd": line.prd_no, "inv": DEFAULT_INV,
                "name": line.smd_prd_name, "price": line.smd_unit_price, "qty": line.smd_qty,
            },
        )


@router.put("/{smt_no}")
def update_ship(smt_no: str, data: ShipCreate):
    if not data.lines:
        raise HTTPException(400, "至少需要一筆品項")
    with get_conn() as conn:
        cur = conn.cursor()
        header = _lock_ship(cur, smt_no)
        if header["smt_status"] != STATUS_UNBOOK:
            raise HTTPException(400, "只有未確認的出貨單可以修改")
        sp = get_sys_param(cur)
        _check_period(sp, date_type.fromisoformat(data.smt_date))

        total = sum(l.smd_qty * l.smd_unit_price for l in data.lines)
        cur.execute(
            """UPDATE TBL_SHIP SET
                   CUM_NO=%(cum)s,EPY_NO=%(epy)s,CAR_NO=%(car)s,SMT_INV_NO=%(inv)s,
                   SMT_DATE=%(date)s,SMT_DESTINATION=%(dest)s,SMT_TOTAL=%(total)s,SMT_TAX=%(tax)s,
                   SMT_DELIVER1=%(d1)s,SMT_DELIVER2=%(d2)s,SMT_DESC=%(desc)s,SMT_CREATOR=%(creator)s
               WHERE SMT_NO=%(no)s""",
            {
                "cum": data.cum_no, "epy": data.epy_no, "car": data.car_no, "inv": data.smt_inv_no,
                "date": data.smt_date, "dest": data.smt_destination, "total": total, "tax": data.smt_tax,
                "d1": data.smt_deliver1, "d2": data.smt_deliver2, "desc": data.smt_desc,
                "creator": CREATOR, "no": smt_no,
            },
        )
        cur.execute("DELETE FROM TBL_SHIP_DT WHERE SMT_NO=%(no)s", {"no": smt_no})
        _insert_lines(cur, smt_no, data.lines)
        return {"message": "更新成功"}


@router.delete("/{smt_no}")
def delete_ship(smt_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        header = _lock_ship(cur, smt_no)
        if header["smt_status"] != STATUS_UNBOOK:
            raise HTTPException(400, "只有未確認的出貨單可以刪除")
        amount = header["smt_total"] + header["smt_tax"]
        if header["smt_not_clean"] != amount:
            raise HTTPException(400, "應收帳款已有收款記錄，不可刪除")

        lines = _get_lines(cur, smt_no)
        affected = [(l["prd_no"], header["smt_date"]) for l in lines]
        delete_transactions_and_recalc(cur, TRN_SHP, smt_no, affected)
        cur.execute("DELETE FROM TBL_SHIP_DT WHERE SMT_NO=%(no)s", {"no": smt_no})
        cur.execute("DELETE FROM TBL_SHIP WHERE SMT_NO=%(no)s", {"no": smt_no})
        return {"message": "刪除成功"}


@router.post("/{smt_no}/book")
def book_ship(smt_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        header = _lock_ship(cur, smt_no)
        if header["smt_status"] != STATUS_UNBOOK:
            raise HTTPException(400, "出貨單狀態已變更，請重新整理")
        sp = get_sys_param(cur)
        _check_year(sp, header["smt_date"])

        cur.execute("UPDATE TBL_SHIP SET SMT_STATUS=%(s)s WHERE SMT_NO=%(no)s",
                    {"s": STATUS_CONFIRM, "no": smt_no})

        lines = _get_lines(cur, smt_no)
        for line in lines:
            cur.execute("SELECT PRD_IS_DUMMY, PRD_DUM_COST_RATE FROM TBL_PRODUCT WHERE PRD_NO=%(p)s",
                        {"p": line["prd_no"]})
            is_dummy, dum_rate = cur.fetchone()
            if is_dummy:
                cur.execute(
                    "UPDATE TBL_SHIP_DT SET SMD_COST=%(c)s WHERE SMT_NO=%(no)s AND SMD_SEQNO=%(seq)s",
                    {"c": float(line["smd_unit_price"]) * float(dum_rate), "no": smt_no, "seq": line["smd_seqno"]},
                )
            else:
                insert_transaction(
                    cur, line["prd_no"], DEFAULT_INV, TRN_SHP, smt_no, line["smd_seqno"],
                    header["smt_date"], -float(line["smd_qty"]), 0,
                    period_start=sp["spr_period_start"],
                )

        cur.execute(
            "UPDATE TBL_SHIP SET SMT_COST=(SELECT COALESCE(SUM(SMD_QTY*SMD_COST),0) FROM TBL_SHIP_DT WHERE SMT_NO=%(no)s) WHERE SMT_NO=%(no)s",
            {"no": smt_no},
        )

        amount = header["smt_total"] + header["smt_tax"]
        cur.execute("SELECT COALESCE(SUM(ARD_AMOUNT+ARD_DISCOUNT),0) FROM TBL_AR_RECV_DT WHERE SMT_NO=%(no)s", {"no": smt_no})
        received = cur.fetchone()[0]
        not_clean = amount - received
        cur.execute("UPDATE TBL_SHIP SET SMT_NOT_CLEAN=%(nc)s WHERE SMT_NO=%(no)s", {"nc": not_clean, "no": smt_no})

        _insert_ship_account(cur, smt_no, header, lines)
        return {"message": "確認成功"}


def _insert_ship_account(cur, smt_no: str, header: dict, lines: list):
    sp = get_sys_param(cur)
    sale_revenue = sale_return = sale_discount = 0.0
    for line in lines:
        qty = float(line["smd_qty"])
        unit_price = float(line["smd_unit_price"])
        subtotal = qty * unit_price
        if subtotal > 0:
            sale_revenue += subtotal
        elif qty < 0:
            sale_return += subtotal
        elif unit_price < 0:
            sale_discount += subtotal

    cur.execute("SELECT CUM_NAME, CUM_ACNT_AR FROM TBL_CUSTOMER WHERE CUM_NO=%(c)s", {"c": header["cum_no"]})
    cum_name, cum_acnt_ar = cur.fetchone()

    jnl_no = next_code(cur, "TBL_ACNT_JOURNAL", "JNL_NO", header["smt_date"])
    desc = f"傳票過帳作業:{cum_name}:{smt_no}"
    insert_journal(cur, jnl_no, header["smt_date"], desc, 1, CREATOR)

    desc2 = f"銷貨:{smt_no}:{cum_name}"
    amount = header["smt_total"] + header["smt_tax"]
    seq = 1
    insert_journal_line(cur, jnl_no, seq, cum_acnt_ar, amount, desc2); seq += 1
    insert_journal_line(cur, jnl_no, seq, sp["spr_acnt_sale_revenue"], -sale_revenue, desc2); seq += 1
    if header["smt_tax"]:
        insert_journal_line(cur, jnl_no, seq, sp["spr_acnt_sale_tax"], -float(header["smt_tax"]), desc2); seq += 1
    if sale_return:
        insert_journal_line(cur, jnl_no, seq, sp["spr_acnt_sale_return"], -sale_return, desc2); seq += 1
    if sale_discount:
        insert_journal_line(cur, jnl_no, seq, sp["spr_acnt_sale_discount"], -sale_discount, desc2); seq += 1

    cur.execute("UPDATE TBL_SHIP SET JNL_NO=%(j)s WHERE SMT_NO=%(no)s", {"j": jnl_no, "no": smt_no})
    chk_dc_balance(cur, jnl_no)


@router.post("/{smt_no}/unbook")
def unbook_ship(smt_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        header = _lock_ship(cur, smt_no)
        if header["smt_status"] != STATUS_CONFIRM:
            raise HTTPException(400, "出貨單狀態已變更，請重新整理")
        sp = get_sys_param(cur)
        _check_year(sp, header["smt_date"])

        cur.execute("SELECT COUNT(*) FROM TBL_AR_RECV_DT WHERE SMT_NO=%(no)s", {"no": smt_no})
        if cur.fetchone()[0] > 0:
            raise HTTPException(400, "應收帳款已有收款記錄，不可取消確認")

        cur.execute(
            "UPDATE TBL_SHIP SET SMT_STATUS=%(s)s, SMT_COST=0, JNL_NO=NULL WHERE SMT_NO=%(no)s",
            {"s": STATUS_UNBOOK, "no": smt_no},
        )
        lines = _get_lines(cur, smt_no)
        affected = [(l["prd_no"], header["smt_date"]) for l in lines]
        delete_transactions_and_recalc(cur, TRN_SHP, smt_no, affected)
        delete_journal(cur, header["jnl_no"])
        return {"message": "取消確認成功"}


@router.post("/{smt_no}/quick-collect")
def quick_collect(smt_no: str, data: QuickCollectRequest):
    with get_conn() as conn:
        cur = conn.cursor()
        header = _lock_ship(cur, smt_no)
        if header["smt_status"] != STATUS_CONFIRM:
            raise HTTPException(400, "出貨單尚未確認，不可收款")
        not_clean = float(header["smt_not_clean"])
        if not_clean == 0:
            raise HTTPException(400, "應收帳款已結清")

        arr_date = date_type.fromisoformat(data.arr_date)
        if arr_date < header["smt_date"].date():
            raise HTTPException(400, "收款日期不可早於出貨日期")

        cash, check, discount = data.cash, data.check, data.discount
        total_collect = cash + check + discount
        if total_collect == 0:
            raise HTTPException(400, "收款金額不可為0")
        balance = not_clean - total_collect
        if balance < 0:
            raise HTTPException(400, "收款金額過多")

        cum_no = header["cum_no"]
        cur.execute("SELECT CUM_NAME FROM TBL_CUSTOMER WHERE CUM_NO=%(c)s", {"c": cum_no})
        cum_name = cur.fetchone()[0]

        arr_no = next_code(cur, "TBL_AR_RECV", "ARR_NO", arr_date)
        desc = f"系統傳輸--快速收款作業 {cum_name}(收款編號:{arr_no})"
        cur.execute(
            """INSERT INTO TBL_AR_RECV (ARR_NO,CUM_NO,ARR_DATE,ARR_CASH,ARR_CHECK,
                    ARR_FROM_ADVANCE,ARR_TO_ADVANCE,ARR_DESC,ARR_CREATOR)
               VALUES (%(no)s,%(cum)s,%(date)s,%(cash)s,%(check)s,0,0,%(desc)s,%(creator)s)""",
            {"no": arr_no, "cum": cum_no, "date": arr_date, "cash": cash, "check": check,
             "desc": desc, "creator": CREATOR},
        )
        cur.execute(
            """INSERT INTO TBL_AR_RECV_DT (ARR_NO,ARD_SEQNO,SMT_NO,ARD_AMOUNT,ARD_DISCOUNT)
               VALUES (%(no)s,1,%(smt)s,%(amt)s,%(disc)s)""",
            {"no": arr_no, "smt": smt_no, "amt": cash + check, "disc": discount},
        )
        cur.execute(
            """UPDATE TBL_SHIP SET SMT_NOT_CLEAN=(SMT_TOTAL+SMT_TAX) -
                   (SELECT COALESCE(SUM(ARD_AMOUNT+ARD_DISCOUNT),0) FROM TBL_AR_RECV_DT WHERE SMT_NO=%(no)s)
               WHERE SMT_NO=%(no)s""",
            {"no": smt_no},
        )

        sp = get_sys_param(cur)
        cur.execute("SELECT CUM_ACNT_ADVANCE, CUM_ACNT_AR FROM TBL_CUSTOMER WHERE CUM_NO=%(c)s", {"c": cum_no})
        cum_acnt_advance, cum_acnt_ar = cur.fetchone()
        jnl_no = next_code(cur, "TBL_ACNT_JOURNAL", "JNL_NO", arr_date)
        insert_journal(cur, jnl_no, arr_date, desc, 1, CREATOR)
        seq = 1
        acnt_sum = cash + check + discount
        desc1 = f"收款:{arr_no}:{cum_name}"
        if cash:
            insert_journal_line(cur, jnl_no, seq, sp["spr_acnt_cash"], cash, desc1); seq += 1
        if check:
            insert_journal_line(cur, jnl_no, seq, sp["spr_acnt_cus_check"], check, desc1); seq += 1
        if discount:
            insert_journal_line(cur, jnl_no, seq, sp["spr_acnt_sale_discount"], discount, desc1); seq += 1
        if acnt_sum:
            insert_journal_line(cur, jnl_no, seq, cum_acnt_ar, -acnt_sum, desc1); seq += 1
        cur.execute("UPDATE TBL_AR_RECV SET JNL_NO=%(j)s WHERE ARR_NO=%(no)s", {"j": jnl_no, "no": arr_no})
        chk_dc_balance(cur, jnl_no)

        return {"message": "收款成功", "arr_no": arr_no}

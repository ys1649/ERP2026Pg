from datetime import date as date_type

from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel
from typing import Optional

from database import get_conn
from services.numbering import next_code
from services.inventory import insert_transaction, delete_transactions_and_recalc, TRN_RCV, DEFAULT_INV
from services.accounting import insert_journal, insert_journal_line, chk_dc_balance, delete_journal
from services.sysparam import get_sys_param

router = APIRouter()

STATUS_UNBOOK = 0
STATUS_CONFIRM = 1

CREATOR = "WYS"  # 尚無登入系統，比照其他模組先固定值


class PoRecvLine(BaseModel):
    prd_no: str
    rcd_unit_price: float
    rcd_qty: float
    rcd_prd_name: Optional[str] = None


class PoRecvCreate(BaseModel):
    sup_no: str
    rcv_inv_no: Optional[str] = None
    rcv_date: str
    rcv_tax: float = 0
    rcv_desc: Optional[str] = None
    lines: list[PoRecvLine]


class QuickPayRequest(BaseModel):
    pay_date: str
    cash: float = 0
    check: float = 0
    discount: float = 0


def row_to_dict(cur, row):
    return dict(zip([d[0].lower() for d in cur.description], row))


def _lock_po_recv(cur, rcv_no: str) -> dict:
    cur.execute("SELECT * FROM TBL_PO_RECV WHERE RCV_NO=%(no)s FOR UPDATE", {"no": rcv_no})
    row = cur.fetchone()
    if not row:
        raise HTTPException(404, "進貨單不存在")
    return row_to_dict(cur, row)


def _get_lines(cur, rcv_no: str) -> list:
    cur.execute(
        """SELECT D.RCV_NO,D.RCD_SEQNO,D.PRD_NO,D.INV_NO,D.RCD_PRD_NAME,
                  D.RCD_UNIT_PRICE,D.RCD_QTY,
                  P.PRD_NAME,P.PRD_UNIT,P.PRD_ONHAND,P.PRD_IS_DUMMY
           FROM TBL_PO_RECV_DT D
           LEFT JOIN TBL_PRODUCT P ON P.PRD_NO=D.PRD_NO
           WHERE D.RCV_NO=%(no)s ORDER BY D.RCD_SEQNO""",
        {"no": rcv_no},
    )
    return [row_to_dict(cur, r) for r in cur.fetchall()]


def _check_period(sp: dict, rcv_date):
    period_start = sp["spr_period_start"]
    if hasattr(rcv_date, "date"):
        rcv_date_d = rcv_date.date()
    else:
        rcv_date_d = rcv_date
    if hasattr(period_start, "date"):
        period_start = period_start.date()
    if rcv_date_d < period_start:
        raise HTTPException(400, f"異動日期不可早於結帳日 {period_start}")


def _check_year(sp: dict, rcv_date):
    if rcv_date.year < sp["spr_acnt_year"]:
        raise HTTPException(400, "不可修改小於本會計年度的傳票")


SORTABLE_COLUMNS = {
    "rcv_no": "M.RCV_NO",
    "rcv_date": "M.RCV_DATE",
    "sup_no": "M.SUP_NO",
    "sup_name": "S.SUP_NAME",
    "rcv_inv_no": "M.RCV_INV_NO",
    "rcv_amount": "(M.RCV_TOTAL+M.RCV_TAX)",
    "rcv_not_clean": "M.RCV_NOT_CLEAN",
    "rcv_status": "M.RCV_STATUS",
}


def _parse_sort(sort: Optional[str]) -> str:
    if not sort:
        return "M.RCV_DATE DESC, M.RCV_NO DESC"
    parts = []
    for item in sort.split(","):
        field, _, direction = item.partition(":")
        col = SORTABLE_COLUMNS.get(field.strip())
        if not col:
            continue
        parts.append(f"{col} {'DESC' if direction.strip() == 'desc' else 'ASC'}")
    return ", ".join(parts) if parts else "M.RCV_DATE DESC, M.RCV_NO DESC"


@router.get("")
def list_po_recvs(
    q: Optional[str] = Query(None),
    status: Optional[int] = Query(None),
    date_from: Optional[str] = Query(None),
    date_to: Optional[str] = Query(None),
    sup_no: Optional[str] = Query(None),
    rcv_no: Optional[str] = Query(None),
    rcv_inv_no: Optional[str] = Query(None),
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
                "(UPPER(M.RCV_NO) LIKE UPPER(%(q1)s) OR UPPER(M.SUP_NO) LIKE UPPER(%(q2)s)"
                " OR UPPER(S.SUP_NAME) LIKE UPPER(%(q3)s) OR UPPER(M.RCV_INV_NO) LIKE UPPER(%(q4)s))"
            )
            pq = f"%{q.strip()}%"
            params.update({"q1": pq, "q2": pq, "q3": pq, "q4": pq})
        if status is not None:
            where.append("M.RCV_STATUS=%(status)s")
            params["status"] = status
        if date_from:
            where.append("M.RCV_DATE>=%(date_from)s")
            params["date_from"] = date_from
        if date_to:
            where.append("M.RCV_DATE<%(date_to)s::date + 1")
            params["date_to"] = date_to
        if sup_no:
            where.append("M.SUP_NO=%(sup_no)s")
            params["sup_no"] = sup_no
        if rcv_no:
            where.append("UPPER(M.RCV_NO) LIKE UPPER(%(rcv_no)s)")
            params["rcv_no"] = f"%{rcv_no}%"
        if rcv_inv_no:
            where.append("UPPER(M.RCV_INV_NO) LIKE UPPER(%(rcv_inv_no)s)")
            params["rcv_inv_no"] = f"%{rcv_inv_no}%"
        if prd_no:
            where.append("EXISTS (SELECT 1 FROM TBL_PO_RECV_DT D WHERE D.RCV_NO=M.RCV_NO AND D.PRD_NO=%(prd_no)s)")
            params["prd_no"] = prd_no
        where_sql = " AND ".join(where)
        order_sql = _parse_sort(sort)

        cur.execute(
            f"""SELECT COUNT(*) FROM TBL_PO_RECV M
                LEFT JOIN TBL_SUPPLIER S ON S.SUP_NO=M.SUP_NO
                WHERE {where_sql}""",
            params,
        )
        total = cur.fetchone()[0]

        offset = (page - 1) * page_size
        cur.execute(
            f"""SELECT M.RCV_NO,M.SUP_NO,S.SUP_NAME,M.RCV_DATE,
                       M.RCV_STATUS,M.RCV_INV_NO,M.RCV_TOTAL,M.RCV_TAX,
                       (M.RCV_TOTAL+M.RCV_TAX) AS RCV_AMOUNT,M.RCV_NOT_CLEAN
                FROM TBL_PO_RECV M
                LEFT JOIN TBL_SUPPLIER S ON S.SUP_NO=M.SUP_NO
                WHERE {where_sql}
                ORDER BY {order_sql}
                OFFSET %(offset)s ROWS FETCH NEXT %(lim)s ROWS ONLY""",
            {**params, "offset": offset, "lim": page_size},
        )
        rows = [row_to_dict(cur, r) for r in cur.fetchall()]
        return {"total": total, "page": page, "page_size": page_size, "data": rows}


@router.get("/price")
def get_price(sup_no: str, prd_no: str):
    """比照 GetSupHisPrice：該廠商上次進貨此產品的單價；查無歷史紀錄則回傳 0（舊系統無後備價格）。"""
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """SELECT D.RCD_UNIT_PRICE FROM TBL_PO_RECV M
               INNER JOIN TBL_PO_RECV_DT D ON M.RCV_NO=D.RCV_NO
               WHERE M.SUP_NO=%(sup)s AND D.PRD_NO=%(prd)s
               ORDER BY M.RCV_DATE DESC LIMIT 1""",
            {"sup": sup_no, "prd": prd_no},
        )
        row = cur.fetchone()
        return {"price": float(row[0]) if row else 0}


@router.get("/history/{sup_no}")
def get_history(sup_no: str, exclude: Optional[str] = None):
    """該廠商歷史進貨紀錄。TBL_HIS_PO_RECV 目前無資料寫入（舊系統該段程式碼已被註解），直接查 TBL_PO_RECV。"""
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """SELECT M.RCV_NO,M.RCV_DATE,M.RCV_INV_NO,M.RCV_TOTAL,M.RCV_TAX,M.RCV_STATUS,
                      M.RCV_NOT_CLEAN,M.RCV_DESC
               FROM TBL_PO_RECV M
               WHERE M.SUP_NO=%(sup)s AND M.RCV_NO<>COALESCE(%(exclude)s,'')
               ORDER BY M.RCV_DATE DESC, M.RCV_NO DESC LIMIT 200""",
            {"sup": sup_no, "exclude": exclude},
        )
        return [row_to_dict(cur, r) for r in cur.fetchall()]


@router.get("/{rcv_no}")
def get_po_recv(rcv_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """SELECT M.*,S.SUP_NAME
               FROM TBL_PO_RECV M
               LEFT JOIN TBL_SUPPLIER S ON S.SUP_NO=M.SUP_NO
               WHERE M.RCV_NO=%(no)s""",
            {"no": rcv_no},
        )
        row = cur.fetchone()
        if not row:
            raise HTTPException(404, "進貨單不存在")
        header = row_to_dict(cur, row)
        header["lines"] = _get_lines(cur, rcv_no)
        return header


def _calc_total(lines: list[PoRecvLine]) -> float:
    return sum(l.rcd_qty * l.rcd_unit_price for l in lines)


@router.post("", status_code=201)
def create_po_recv(data: PoRecvCreate):
    if not data.lines:
        raise HTTPException(400, "至少需要一筆品項")
    with get_conn() as conn:
        cur = conn.cursor()
        sp = get_sys_param(cur)
        rcv_date = data.rcv_date
        _check_period(sp, date_type.fromisoformat(rcv_date))

        total = _calc_total(data.lines)
        rcv_no = next_code(cur, "TBL_PO_RECV", "RCV_NO", date_type.fromisoformat(rcv_date))

        cur.execute(
            """INSERT INTO TBL_PO_RECV
                   (RCV_NO,SUP_NO,RCV_STATUS,RCV_INV_NO,RCV_DATE,
                    RCV_TOTAL,RCV_TAX,RCV_NOT_CLEAN,RCV_DESC,RCV_CREATOR)
               VALUES (%(no)s,%(sup)s,%(status)s,%(inv)s,%(date)s,
                       %(total)s,%(tax)s,0,%(desc)s,%(creator)s)""",
            {
                "no": rcv_no, "sup": data.sup_no, "status": STATUS_UNBOOK, "inv": data.rcv_inv_no,
                "date": rcv_date, "total": total, "tax": data.rcv_tax, "desc": data.rcv_desc,
                "creator": CREATOR,
            },
        )
        _insert_lines(cur, rcv_no, data.lines)
        return {"message": "新增成功", "rcv_no": rcv_no}


def _insert_lines(cur, rcv_no: str, lines: list[PoRecvLine]):
    for i, line in enumerate(lines, start=1):
        cur.execute(
            """INSERT INTO TBL_PO_RECV_DT
                   (RCV_NO,RCD_SEQNO,PRD_NO,INV_NO,RCD_PRD_NAME,RCD_UNIT_PRICE,RCD_QTY)
               VALUES (%(no)s,%(seq)s,%(prd)s,%(inv)s,%(name)s,%(price)s,%(qty)s)""",
            {
                "no": rcv_no, "seq": i, "prd": line.prd_no, "inv": DEFAULT_INV,
                "name": line.rcd_prd_name, "price": line.rcd_unit_price, "qty": line.rcd_qty,
            },
        )


@router.put("/{rcv_no}")
def update_po_recv(rcv_no: str, data: PoRecvCreate):
    if not data.lines:
        raise HTTPException(400, "至少需要一筆品項")
    with get_conn() as conn:
        cur = conn.cursor()
        header = _lock_po_recv(cur, rcv_no)
        if header["rcv_status"] != STATUS_UNBOOK:
            raise HTTPException(400, "只有未確認的進貨單可以修改")
        sp = get_sys_param(cur)
        _check_period(sp, date_type.fromisoformat(data.rcv_date))

        total = _calc_total(data.lines)
        cur.execute(
            """UPDATE TBL_PO_RECV SET
                   SUP_NO=%(sup)s,RCV_INV_NO=%(inv)s,RCV_DATE=%(date)s,
                   RCV_TOTAL=%(total)s,RCV_TAX=%(tax)s,RCV_DESC=%(desc)s,RCV_CREATOR=%(creator)s
               WHERE RCV_NO=%(no)s""",
            {
                "sup": data.sup_no, "inv": data.rcv_inv_no, "date": data.rcv_date,
                "total": total, "tax": data.rcv_tax, "desc": data.rcv_desc,
                "creator": CREATOR, "no": rcv_no,
            },
        )
        cur.execute("DELETE FROM TBL_PO_RECV_DT WHERE RCV_NO=%(no)s", {"no": rcv_no})
        _insert_lines(cur, rcv_no, data.lines)
        return {"message": "更新成功"}


@router.delete("/{rcv_no}")
def delete_po_recv(rcv_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        header = _lock_po_recv(cur, rcv_no)
        if header["rcv_status"] != STATUS_UNBOOK:
            raise HTTPException(400, "只有未確認的進貨單可以刪除")
        amount = header["rcv_total"] + header["rcv_tax"]
        if header["rcv_not_clean"] != amount:
            raise HTTPException(400, "廠商已有付款記錄，不可刪除")

        lines = _get_lines(cur, rcv_no)
        affected = [(l["prd_no"], header["rcv_date"]) for l in lines if not l["prd_is_dummy"]]
        delete_transactions_and_recalc(cur, TRN_RCV, rcv_no, affected)
        cur.execute("DELETE FROM TBL_PO_RECV_DT WHERE RCV_NO=%(no)s", {"no": rcv_no})
        cur.execute("DELETE FROM TBL_PO_RECV WHERE RCV_NO=%(no)s", {"no": rcv_no})
        return {"message": "刪除成功"}


@router.post("/{rcv_no}/book")
def book_po_recv(rcv_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        header = _lock_po_recv(cur, rcv_no)
        if header["rcv_status"] != STATUS_UNBOOK:
            raise HTTPException(400, "進貨單狀態已變更，請重新整理")
        sp = get_sys_param(cur)
        _check_year(sp, header["rcv_date"])

        cur.execute("UPDATE TBL_PO_RECV SET RCV_STATUS=%(s)s WHERE RCV_NO=%(no)s",
                    {"s": STATUS_CONFIRM, "no": rcv_no})

        lines = _get_lines(cur, rcv_no)
        for line in lines:
            if line["prd_is_dummy"]:
                # 虛擬商品：不記庫存交易，也沒有成本欄位可寫回（比照舊系統 InsertInv_Transaction 完全跳過）
                continue
            insert_transaction(
                cur, line["prd_no"], DEFAULT_INV, TRN_RCV, rcv_no, line["rcd_seqno"],
                header["rcv_date"], float(line["rcd_qty"]), float(line["rcd_unit_price"]),
                period_start=sp["spr_period_start"],
            )

        amount = header["rcv_total"] + header["rcv_tax"]
        cur.execute("SELECT COALESCE(SUM(PAD_AMOUNT+PAD_DISCOUNT),0) FROM TBL_AP_PAY_DT WHERE RCV_NO=%(no)s", {"no": rcv_no})
        paid = cur.fetchone()[0]
        not_clean = amount - paid
        cur.execute("UPDATE TBL_PO_RECV SET RCV_NOT_CLEAN=%(nc)s WHERE RCV_NO=%(no)s", {"nc": not_clean, "no": rcv_no})

        _insert_po_recv_account(cur, rcv_no, header, lines)
        return {"message": "確認成功"}


def _insert_po_recv_account(cur, rcv_no: str, header: dict, lines: list):
    sp = get_sys_param(cur)
    purchase_amount = purchase_return = purchase_discount = 0.0
    for line in lines:
        qty = float(line["rcd_qty"])
        unit_price = float(line["rcd_unit_price"])
        subtotal = qty * unit_price
        if subtotal > 0:
            purchase_amount += subtotal
        elif qty < 0:
            purchase_return += subtotal
        elif unit_price < 0:
            purchase_discount += subtotal

    cur.execute("SELECT SUP_NAME, SUP_ACNT_AP FROM TBL_SUPPLIER WHERE SUP_NO=%(s)s", {"s": header["sup_no"]})
    sup_name, sup_acnt_ap = cur.fetchone()

    jnl_no = next_code(cur, "TBL_ACNT_JOURNAL", "JNL_NO", header["rcv_date"])
    desc = f"傳票過帳作業:{sup_name}:{rcv_no}"
    insert_journal(cur, jnl_no, header["rcv_date"], desc, 1, CREATOR)

    desc2 = f"進貨:{rcv_no}:{sup_name}"
    amount = header["rcv_total"] + header["rcv_tax"]
    seq = 1
    insert_journal_line(cur, jnl_no, seq, sp["spr_acnt_purchase"], purchase_amount, desc2); seq += 1
    if header["rcv_tax"]:
        insert_journal_line(cur, jnl_no, seq, sp["spr_acnt_pur_tax"], float(header["rcv_tax"]), desc2); seq += 1
    if purchase_return:
        insert_journal_line(cur, jnl_no, seq, sp["spr_acnt_pur_return"], purchase_return, desc2); seq += 1
    if purchase_discount:
        insert_journal_line(cur, jnl_no, seq, sp["spr_acnt_pur_discount"], purchase_discount, desc2); seq += 1
    insert_journal_line(cur, jnl_no, seq, sup_acnt_ap, -amount, desc2); seq += 1

    cur.execute("UPDATE TBL_PO_RECV SET JNL_NO=%(j)s WHERE RCV_NO=%(no)s", {"j": jnl_no, "no": rcv_no})
    chk_dc_balance(cur, jnl_no)


@router.post("/{rcv_no}/unbook")
def unbook_po_recv(rcv_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        header = _lock_po_recv(cur, rcv_no)
        if header["rcv_status"] != STATUS_CONFIRM:
            raise HTTPException(400, "進貨單狀態已變更，請重新整理")
        sp = get_sys_param(cur)
        _check_year(sp, header["rcv_date"])

        cur.execute("SELECT COUNT(*) FROM TBL_AP_PAY_DT WHERE RCV_NO=%(no)s", {"no": rcv_no})
        if cur.fetchone()[0] > 0:
            raise HTTPException(400, "廠商已有付款記錄，不可取消確認")

        cur.execute(
            "UPDATE TBL_PO_RECV SET RCV_STATUS=%(s)s, JNL_NO=NULL WHERE RCV_NO=%(no)s",
            {"s": STATUS_UNBOOK, "no": rcv_no},
        )
        lines = _get_lines(cur, rcv_no)
        affected = [(l["prd_no"], header["rcv_date"]) for l in lines if not l["prd_is_dummy"]]
        delete_transactions_and_recalc(cur, TRN_RCV, rcv_no, affected)
        delete_journal(cur, header["jnl_no"])
        return {"message": "取消確認成功"}


@router.post("/{rcv_no}/quick-pay")
def quick_pay(rcv_no: str, data: QuickPayRequest):
    with get_conn() as conn:
        cur = conn.cursor()
        header = _lock_po_recv(cur, rcv_no)
        if header["rcv_status"] != STATUS_CONFIRM:
            raise HTTPException(400, "進貨單尚未確認，不可付款")
        not_clean = float(header["rcv_not_clean"])
        if not_clean == 0:
            raise HTTPException(400, "應付帳款已結清")

        pay_date = date_type.fromisoformat(data.pay_date)
        if pay_date < header["rcv_date"].date():
            raise HTTPException(400, "付款日期不可早於進貨日期")

        cash, check, discount = data.cash, data.check, data.discount
        total_pay = cash + check + discount
        if total_pay == 0:
            raise HTTPException(400, "付款金額不可為0")
        balance = not_clean - total_pay
        if balance < 0:
            raise HTTPException(400, "付款金額過多")

        sup_no = header["sup_no"]
        cur.execute("SELECT SUP_NAME FROM TBL_SUPPLIER WHERE SUP_NO=%(s)s", {"s": sup_no})
        sup_name = cur.fetchone()[0]

        pay_no = next_code(cur, "TBL_AP_PAY", "PAY_NO", pay_date)
        cur.execute(
            """INSERT INTO TBL_AP_PAY (PAY_NO,SUP_NO,PAY_DATE,PAY_CASH,PAY_CHECK,
                    PAY_FROM_ADVANCE,PAY_TO_ADVANCE,PAY_DESC,PAY_CREATOR)
               VALUES (%(no)s,%(sup)s,%(date)s,%(cash)s,%(check)s,0,0,%(desc)s,%(creator)s)""",
            {"no": pay_no, "sup": sup_no, "date": pay_date, "cash": cash, "check": check,
             "desc": "快速匯款付款", "creator": CREATOR},
        )
        cur.execute(
            """INSERT INTO TBL_AP_PAY_DT (PAY_NO,PAD_SEQNO,RCV_NO,PAD_AMOUNT,PAD_DISCOUNT)
               VALUES (%(no)s,1,%(rcv)s,%(amt)s,%(disc)s)""",
            {"no": pay_no, "rcv": rcv_no, "amt": cash + check, "disc": discount},
        )
        cur.execute(
            """UPDATE TBL_PO_RECV SET RCV_NOT_CLEAN=(RCV_TOTAL+RCV_TAX) -
                   (SELECT COALESCE(SUM(PAD_AMOUNT+PAD_DISCOUNT),0) FROM TBL_AP_PAY_DT WHERE RCV_NO=%(no)s)
               WHERE RCV_NO=%(no)s""",
            {"no": rcv_no},
        )

        sp = get_sys_param(cur)
        cur.execute("SELECT SUP_ACNT_AP FROM TBL_SUPPLIER WHERE SUP_NO=%(s)s", {"s": sup_no})
        (sup_acnt_ap,) = cur.fetchone()
        jnl_no = next_code(cur, "TBL_ACNT_JOURNAL", "JNL_NO", pay_date)
        desc = f"系統傳輸--快速付款作業 {sup_name}(付款編號:{pay_no})"
        insert_journal(cur, jnl_no, pay_date, desc, 1, CREATOR)
        seq = 1
        acnt_sum = cash + check + discount
        desc1 = f"付款:{pay_no}:{sup_name}"
        if cash:
            insert_journal_line(cur, jnl_no, seq, sp["spr_acnt_cash"], -cash, desc1); seq += 1
        if check:
            insert_journal_line(cur, jnl_no, seq, sp["spr_acnt_sup_check"], -check, desc1); seq += 1
        if discount:
            insert_journal_line(cur, jnl_no, seq, sp["spr_acnt_pur_discount"], -discount, desc1); seq += 1
        if acnt_sum:
            insert_journal_line(cur, jnl_no, seq, sup_acnt_ap, acnt_sum, desc1); seq += 1
        cur.execute("UPDATE TBL_AP_PAY SET JNL_NO=%(j)s WHERE PAY_NO=%(no)s", {"j": jnl_no, "no": pay_no})
        chk_dc_balance(cur, jnl_no)

        return {"message": "付款成功", "pay_no": pay_no}

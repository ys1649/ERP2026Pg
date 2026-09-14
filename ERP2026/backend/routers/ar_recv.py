from datetime import date as date_type

from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel
from typing import Optional

from database import get_conn
from services.numbering import next_code
from services.accounting import insert_journal, insert_journal_line, chk_dc_balance, delete_journal
from services.sysparam import get_sys_param

router = APIRouter()

CREATOR = "WYS"  # 尚無登入系統，比照其他模組先固定值


class ArRecvLine(BaseModel):
    smt_no: str
    ard_amount: float = 0
    ard_discount: float = 0


class ArRecvCreate(BaseModel):
    cum_no: str
    arr_date: str
    arr_cash: float = 0
    arr_check: float = 0
    arr_from_advance: float = 0
    arr_to_advance: float = 0
    arr_desc: Optional[str] = None
    lines: list[ArRecvLine]


def row_to_dict(cur, row):
    return dict(zip([d[0].lower() for d in cur.description], row))


def _check_year(sp: dict, arr_date):
    if arr_date.year < sp["spr_acnt_year"]:
        raise HTTPException(400, "收款日期小於本會計年度，不可異動")


def _update_ar_not_clean(cur, smt_no: str):
    cur.execute(
        """UPDATE TBL_SHIP SET SMT_NOT_CLEAN=(SMT_TOTAL+SMT_TAX) -
               (SELECT COALESCE(SUM(ARD_AMOUNT+ARD_DISCOUNT),0) FROM TBL_AR_RECV_DT WHERE SMT_NO=%(no)s)
           WHERE SMT_NO=%(no)s""",
        {"no": smt_no},
    )


def _update_cum_advance_amount(cur, cum_no: str):
    cur.execute(
        """UPDATE TBL_CUSTOMER SET CUM_ADVANCE_AMOUNT=
               (SELECT COALESCE(SUM(ARR_TO_ADVANCE-ARR_FROM_ADVANCE),0) FROM TBL_AR_RECV WHERE CUM_NO=%(c)s)
           WHERE CUM_NO=%(c)s""",
        {"c": cum_no},
    )


SORTABLE_COLUMNS = {
    "arr_no": "M.ARR_NO",
    "arr_date": "M.ARR_DATE",
    "cum_no": "M.CUM_NO",
    "cum_name": "C.CUM_NAME",
}


def _parse_sort(sort: Optional[str]) -> str:
    if not sort:
        return "M.ARR_DATE DESC, M.ARR_NO DESC"
    parts = []
    for item in sort.split(","):
        field, _, direction = item.partition(":")
        col = SORTABLE_COLUMNS.get(field.strip())
        if not col:
            continue
        parts.append(f"{col} {'DESC' if direction.strip() == 'desc' else 'ASC'}")
    return ", ".join(parts) if parts else "M.ARR_DATE DESC, M.ARR_NO DESC"


@router.get("")
def list_ar_recvs(
    q: Optional[str] = Query(None),
    date_from: Optional[str] = Query(None),
    date_to: Optional[str] = Query(None),
    cum_no: Optional[str] = Query(None),
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
                "(UPPER(M.ARR_NO) LIKE UPPER(%(q1)s) OR UPPER(M.CUM_NO) LIKE UPPER(%(q2)s)"
                " OR UPPER(C.CUM_NAME) LIKE UPPER(%(q3)s))"
            )
            pq = f"%{q.strip()}%"
            params.update({"q1": pq, "q2": pq, "q3": pq})
        if date_from:
            where.append("M.ARR_DATE>=%(date_from)s")
            params["date_from"] = date_from
        if date_to:
            where.append("M.ARR_DATE<%(date_to)s::date + 1")
            params["date_to"] = date_to
        if cum_no:
            where.append("M.CUM_NO=%(cum_no)s")
            params["cum_no"] = cum_no
        where_sql = " AND ".join(where)
        order_sql = _parse_sort(sort)

        cur.execute(
            f"""SELECT COUNT(*) FROM TBL_AR_RECV M
                LEFT JOIN TBL_CUSTOMER C ON C.CUM_NO=M.CUM_NO
                WHERE {where_sql}""",
            params,
        )
        total = cur.fetchone()[0]

        offset = (page - 1) * page_size
        cur.execute(
            f"""SELECT M.ARR_NO,M.CUM_NO,C.CUM_NAME,M.ARR_DATE,
                       M.ARR_CASH,M.ARR_CHECK,M.ARR_FROM_ADVANCE,M.ARR_TO_ADVANCE,
                       (M.ARR_CASH+M.ARR_CHECK+M.ARR_FROM_ADVANCE-M.ARR_TO_ADVANCE) AS ARR_TOTAL
                FROM TBL_AR_RECV M
                LEFT JOIN TBL_CUSTOMER C ON C.CUM_NO=M.CUM_NO
                WHERE {where_sql}
                ORDER BY {order_sql}
                OFFSET %(offset)s ROWS FETCH NEXT %(lim)s ROWS ONLY""",
            {**params, "offset": offset, "lim": page_size},
        )
        rows = [row_to_dict(cur, r) for r in cur.fetchall()]
        return {"total": total, "page": page, "page_size": page_size, "data": rows}


@router.get("/candidates")
def get_candidates(cum_no: str, arr_date: str, exclude: Optional[str] = None):
    """比照 InsertClientDT：該客戶在收款日期以前、已確認且未結清的出貨單清單。
    exclude 為目前收款單自己的 ARR_NO——修改資料不存在（本模組沒有 Edit），保留參數僅供一致性。"""
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """SELECT SMT_NO,SMT_DATE,SMT_INV_NO,(SMT_TOTAL+SMT_TAX) AS SMT_AMOUNT,SMT_NOT_CLEAN
               FROM TBL_SHIP
               WHERE CUM_NO=%(cum)s AND SMT_DATE<=%(date)s AND SMT_NOT_CLEAN<>0 AND SMT_STATUS=1
               ORDER BY SMT_DATE, SMT_NO""",
            {"cum": cum_no, "date": arr_date},
        )
        return [row_to_dict(cur, r) for r in cur.fetchall()]


@router.get("/{arr_no}")
def get_ar_recv(arr_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """SELECT M.*,C.CUM_NAME
               FROM TBL_AR_RECV M
               LEFT JOIN TBL_CUSTOMER C ON C.CUM_NO=M.CUM_NO
               WHERE M.ARR_NO=%(no)s""",
            {"no": arr_no},
        )
        row = cur.fetchone()
        if not row:
            raise HTTPException(404, "收款單不存在")
        header = row_to_dict(cur, row)
        cur.execute(
            """SELECT A.ARR_NO,A.ARD_SEQNO,A.SMT_NO,A.ARD_AMOUNT,A.ARD_DISCOUNT,
                      B.SMT_DATE,B.SMT_INV_NO,(B.SMT_TOTAL+B.SMT_TAX) AS SMT_AMOUNT,B.SMT_NOT_CLEAN
               FROM TBL_AR_RECV_DT A
               INNER JOIN TBL_SHIP B ON A.SMT_NO=B.SMT_NO
               WHERE A.ARR_NO=%(no)s ORDER BY A.ARD_SEQNO""",
            {"no": arr_no},
        )
        header["lines"] = [row_to_dict(cur, r) for r in cur.fetchall()]
        return header


def _check_all_validate(cur, data: ArRecvCreate):
    """比照 CheckAllValidate：現金+票據+動用預收-轉預收 必須等於明細金額(不含折讓)加總；
    且每筆分配金額+折讓不可超過(或低於，負數時)該張出貨單的未清餘額。"""
    rev_sum = data.arr_cash + data.arr_check + data.arr_from_advance - data.arr_to_advance
    amount_sum = sum(l.ard_amount for l in data.lines)
    if round(rev_sum - amount_sum, 4) != 0:
        raise HTTPException(400, "尚有沖帳餘額，收款金額與分配金額不相符")

    for l in data.lines:
        cur.execute("SELECT SMT_NOT_CLEAN FROM TBL_SHIP WHERE SMT_NO=%(no)s", {"no": l.smt_no})
        row = cur.fetchone()
        if not row:
            raise HTTPException(400, f"出貨單不存在: {l.smt_no}")
        not_clean = float(row[0])
        total = l.ard_amount + l.ard_discount
        if not_clean > 0:
            if total > not_clean:
                raise HTTPException(400, f"出貨單 {l.smt_no} 沖帳金額過多")
        else:
            if total < not_clean:
                raise HTTPException(400, f"出貨單 {l.smt_no} 沖帳金額過多")


@router.post("", status_code=201)
def create_ar_recv(data: ArRecvCreate):
    with get_conn() as conn:
        cur = conn.cursor()
        sp = get_sys_param(cur)
        arr_date = date_type.fromisoformat(data.arr_date)
        _check_year(sp, arr_date)
        _check_all_validate(cur, data)

        cur.execute("SELECT CUM_NAME, CUM_ACNT_ADVANCE, CUM_ACNT_AR FROM TBL_CUSTOMER WHERE CUM_NO=%(c)s", {"c": data.cum_no})
        row = cur.fetchone()
        if not row:
            raise HTTPException(400, "客戶不存在")
        cum_name, cum_acnt_advance, cum_acnt_ar = row

        arr_no = next_code(cur, "TBL_AR_RECV", "ARR_NO", arr_date)
        cur.execute(
            """INSERT INTO TBL_AR_RECV (ARR_NO,CUM_NO,ARR_DATE,ARR_CASH,ARR_CHECK,
                    ARR_FROM_ADVANCE,ARR_TO_ADVANCE,ARR_DESC,ARR_CREATOR)
               VALUES (%(no)s,%(cum)s,%(date)s,%(cash)s,%(check)s,%(fa)s,%(ta)s,%(desc)s,%(creator)s)""",
            {
                "no": arr_no, "cum": data.cum_no, "date": arr_date, "cash": data.arr_cash, "check": data.arr_check,
                "fa": data.arr_from_advance, "ta": data.arr_to_advance, "desc": data.arr_desc, "creator": CREATOR,
            },
        )
        _update_cum_advance_amount(cur, data.cum_no)

        acnt_discount = 0.0
        seqno = 0
        for l in data.lines:
            if l.ard_amount == 0 and l.ard_discount == 0:
                continue
            seqno += 1
            cur.execute(
                """INSERT INTO TBL_AR_RECV_DT (ARR_NO,ARD_SEQNO,SMT_NO,ARD_AMOUNT,ARD_DISCOUNT)
                   VALUES (%(no)s,%(seq)s,%(smt)s,%(amt)s,%(disc)s)""",
                {"no": arr_no, "seq": seqno, "smt": l.smt_no, "amt": l.ard_amount, "disc": l.ard_discount},
            )
            _update_ar_not_clean(cur, l.smt_no)
            acnt_discount += l.ard_discount

        jnl_no = next_code(cur, "TBL_ACNT_JOURNAL", "JNL_NO", arr_date)
        desc = f"傳票過帳作業:{cum_name}:{arr_no}"
        insert_journal(cur, jnl_no, arr_date, desc, 1, CREATOR)

        desc1 = f"收款:{arr_no}:{cum_name}"
        seq = 1
        acnt_sum = data.arr_cash + data.arr_check + data.arr_from_advance + acnt_discount - data.arr_to_advance
        if data.arr_cash:
            insert_journal_line(cur, jnl_no, seq, sp["spr_acnt_cash"], data.arr_cash, desc1); seq += 1
        if data.arr_check:
            insert_journal_line(cur, jnl_no, seq, sp["spr_acnt_cus_check"], data.arr_check, desc1); seq += 1
        if acnt_discount:
            insert_journal_line(cur, jnl_no, seq, sp["spr_acnt_sale_discount"], acnt_discount, desc1); seq += 1
        if data.arr_from_advance:
            insert_journal_line(cur, jnl_no, seq, cum_acnt_advance, data.arr_from_advance, desc1); seq += 1
        if data.arr_to_advance:
            insert_journal_line(cur, jnl_no, seq, cum_acnt_advance, -data.arr_to_advance, desc1); seq += 1
        insert_journal_line(cur, jnl_no, seq, cum_acnt_ar, -acnt_sum, desc1)

        cur.execute("UPDATE TBL_AR_RECV SET JNL_NO=%(j)s WHERE ARR_NO=%(no)s", {"j": jnl_no, "no": arr_no})
        chk_dc_balance(cur, jnl_no)

        return {"message": "新增成功", "arr_no": arr_no}


@router.delete("/{arr_no}")
def delete_ar_recv(arr_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute("SELECT ARR_DATE, CUM_NO, JNL_NO FROM TBL_AR_RECV WHERE ARR_NO=%(no)s", {"no": arr_no})
        row = cur.fetchone()
        if not row:
            raise HTTPException(404, "收款單不存在")
        arr_date, cum_no, jnl_no = row
        sp = get_sys_param(cur)
        _check_year(sp, arr_date)

        cur.execute("SELECT DISTINCT SMT_NO FROM TBL_AR_RECV_DT WHERE ARR_NO=%(no)s", {"no": arr_no})
        smt_nos = [r[0] for r in cur.fetchall()]

        cur.execute("DELETE FROM TBL_AR_RECV_DT WHERE ARR_NO=%(no)s", {"no": arr_no})
        for smt_no in smt_nos:
            _update_ar_not_clean(cur, smt_no)

        cur.execute("DELETE FROM TBL_AR_RECV WHERE ARR_NO=%(no)s", {"no": arr_no})
        _update_cum_advance_amount(cur, cum_no)

        delete_journal(cur, jnl_no)
        return {"message": "刪除成功"}

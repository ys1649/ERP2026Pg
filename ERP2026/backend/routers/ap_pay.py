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


class ApPayLine(BaseModel):
    rcv_no: str
    pad_amount: float = 0
    pad_discount: float = 0


class ApPayCreate(BaseModel):
    sup_no: str
    pay_date: str
    pay_cash: float = 0
    pay_check: float = 0
    pay_from_advance: float = 0
    pay_to_advance: float = 0
    pay_desc: Optional[str] = None
    lines: list[ApPayLine]


def row_to_dict(cur, row):
    return dict(zip([d[0].lower() for d in cur.description], row))


def _check_year(sp: dict, pay_date):
    if pay_date.year < sp["spr_acnt_year"]:
        raise HTTPException(400, "付款日期小於本會計年度，不可異動")


def _update_ap_not_clean(cur, rcv_no: str):
    cur.execute(
        """UPDATE TBL_PO_RECV SET RCV_NOT_CLEAN=(RCV_TOTAL+RCV_TAX) -
               (SELECT COALESCE(SUM(PAD_AMOUNT+PAD_DISCOUNT),0) FROM TBL_AP_PAY_DT WHERE RCV_NO=%(no)s)
           WHERE RCV_NO=%(no)s""",
        {"no": rcv_no},
    )


def _update_sup_advance_amount(cur, sup_no: str):
    cur.execute(
        """UPDATE TBL_SUPPLIER SET SUP_ADVANCE_AMOUNT=
               (SELECT COALESCE(SUM(PAY_TO_ADVANCE-PAY_FROM_ADVANCE),0) FROM TBL_AP_PAY WHERE SUP_NO=%(s)s)
           WHERE SUP_NO=%(s)s""",
        {"s": sup_no},
    )


SORTABLE_COLUMNS = {
    "pay_no": "M.PAY_NO",
    "pay_date": "M.PAY_DATE",
    "sup_no": "M.SUP_NO",
    "sup_name": "S.SUP_NAME",
}


def _parse_sort(sort: Optional[str]) -> str:
    if not sort:
        return "M.PAY_DATE DESC, M.PAY_NO DESC"
    parts = []
    for item in sort.split(","):
        field, _, direction = item.partition(":")
        col = SORTABLE_COLUMNS.get(field.strip())
        if not col:
            continue
        parts.append(f"{col} {'DESC' if direction.strip() == 'desc' else 'ASC'}")
    return ", ".join(parts) if parts else "M.PAY_DATE DESC, M.PAY_NO DESC"


@router.get("")
def list_ap_pays(
    q: Optional[str] = Query(None),
    date_from: Optional[str] = Query(None),
    date_to: Optional[str] = Query(None),
    sup_no: Optional[str] = Query(None),
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
                "(UPPER(M.PAY_NO) LIKE UPPER(%(q1)s) OR UPPER(M.SUP_NO) LIKE UPPER(%(q2)s)"
                " OR UPPER(S.SUP_NAME) LIKE UPPER(%(q3)s))"
            )
            pq = f"%{q.strip()}%"
            params.update({"q1": pq, "q2": pq, "q3": pq})
        if date_from:
            where.append("M.PAY_DATE>=%(date_from)s")
            params["date_from"] = date_from
        if date_to:
            where.append("M.PAY_DATE<%(date_to)s::date + 1")
            params["date_to"] = date_to
        if sup_no:
            where.append("M.SUP_NO=%(sup_no)s")
            params["sup_no"] = sup_no
        where_sql = " AND ".join(where)
        order_sql = _parse_sort(sort)

        cur.execute(
            f"""SELECT COUNT(*) FROM TBL_AP_PAY M
                LEFT JOIN TBL_SUPPLIER S ON S.SUP_NO=M.SUP_NO
                WHERE {where_sql}""",
            params,
        )
        total = cur.fetchone()[0]

        offset = (page - 1) * page_size
        cur.execute(
            f"""SELECT M.PAY_NO,M.SUP_NO,S.SUP_NAME,M.PAY_DATE,
                       M.PAY_CASH,M.PAY_CHECK,M.PAY_FROM_ADVANCE,M.PAY_TO_ADVANCE,
                       (M.PAY_CASH+M.PAY_CHECK+M.PAY_FROM_ADVANCE-M.PAY_TO_ADVANCE) AS PAY_TOTAL
                FROM TBL_AP_PAY M
                LEFT JOIN TBL_SUPPLIER S ON S.SUP_NO=M.SUP_NO
                WHERE {where_sql}
                ORDER BY {order_sql}
                OFFSET %(offset)s ROWS FETCH NEXT %(lim)s ROWS ONLY""",
            {**params, "offset": offset, "lim": page_size},
        )
        rows = [row_to_dict(cur, r) for r in cur.fetchall()]
        return {"total": total, "page": page, "page_size": page_size, "data": rows}


@router.get("/candidates")
def get_candidates(sup_no: str, pay_date: str):
    """比照 InsertClientDT：該廠商在付款日期以前、已確認且未結清的進貨單清單。"""
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """SELECT RCV_NO,RCV_DATE,RCV_INV_NO,(RCV_TOTAL+RCV_TAX) AS RCV_AMOUNT,RCV_NOT_CLEAN
               FROM TBL_PO_RECV
               WHERE SUP_NO=%(sup)s AND RCV_DATE<=%(date)s AND RCV_NOT_CLEAN<>0 AND RCV_STATUS=1
               ORDER BY RCV_DATE, RCV_NO""",
            {"sup": sup_no, "date": pay_date},
        )
        return [row_to_dict(cur, r) for r in cur.fetchall()]


@router.get("/{pay_no}")
def get_ap_pay(pay_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """SELECT M.*,S.SUP_NAME
               FROM TBL_AP_PAY M
               LEFT JOIN TBL_SUPPLIER S ON S.SUP_NO=M.SUP_NO
               WHERE M.PAY_NO=%(no)s""",
            {"no": pay_no},
        )
        row = cur.fetchone()
        if not row:
            raise HTTPException(404, "付款單不存在")
        header = row_to_dict(cur, row)
        cur.execute(
            """SELECT A.PAY_NO,A.PAD_SEQNO,A.RCV_NO,A.PAD_AMOUNT,A.PAD_DISCOUNT,
                      B.RCV_DATE,B.RCV_INV_NO,(B.RCV_TOTAL+B.RCV_TAX) AS RCV_AMOUNT,B.RCV_NOT_CLEAN
               FROM TBL_AP_PAY_DT A
               INNER JOIN TBL_PO_RECV B ON A.RCV_NO=B.RCV_NO
               WHERE A.PAY_NO=%(no)s ORDER BY A.PAD_SEQNO""",
            {"no": pay_no},
        )
        header["lines"] = [row_to_dict(cur, r) for r in cur.fetchall()]
        return header


def _check_all_validate(cur, data: ApPayCreate, sup_advance_amount: float):
    """比照 CheckAllValidate + Client_MastPAY_FROM_ADVANCEValidate。"""
    if data.pay_from_advance > sup_advance_amount:
        raise HTTPException(400, "動用預付款金額超過廠商目前預付款餘額")

    rev_sum = data.pay_cash + data.pay_check + data.pay_from_advance - data.pay_to_advance
    amount_sum = sum(l.pad_amount for l in data.lines)
    if round(rev_sum - amount_sum, 4) != 0:
        raise HTTPException(400, "尚有代收款餘額，付款金額與分配金額不相符")

    for l in data.lines:
        cur.execute("SELECT RCV_NOT_CLEAN FROM TBL_PO_RECV WHERE RCV_NO=%(no)s", {"no": l.rcv_no})
        row = cur.fetchone()
        if not row:
            raise HTTPException(400, f"進貨單不存在: {l.rcv_no}")
        not_clean = float(row[0])
        total = l.pad_amount + l.pad_discount
        if not_clean > 0:
            if total > not_clean:
                raise HTTPException(400, f"進貨單 {l.rcv_no} 沖帳金額過多")
        else:
            if total < not_clean:
                raise HTTPException(400, f"進貨單 {l.rcv_no} 沖帳金額過多")


@router.post("", status_code=201)
def create_ap_pay(data: ApPayCreate):
    with get_conn() as conn:
        cur = conn.cursor()
        sp = get_sys_param(cur)
        pay_date = date_type.fromisoformat(data.pay_date)
        _check_year(sp, pay_date)

        cur.execute("SELECT SUP_NAME, SUP_ACNT_ADVANCE, SUP_ACNT_AP, SUP_ADVANCE_AMOUNT FROM TBL_SUPPLIER WHERE SUP_NO=%(s)s", {"s": data.sup_no})
        row = cur.fetchone()
        if not row:
            raise HTTPException(400, "廠商不存在")
        sup_name, sup_acnt_advance, sup_acnt_ap, sup_advance_amount = row
        _check_all_validate(cur, data, float(sup_advance_amount))

        pay_no = next_code(cur, "TBL_AP_PAY", "PAY_NO", pay_date)
        cur.execute(
            """INSERT INTO TBL_AP_PAY (PAY_NO,SUP_NO,PAY_DATE,PAY_CASH,PAY_CHECK,
                    PAY_FROM_ADVANCE,PAY_TO_ADVANCE,PAY_DESC,PAY_CREATOR)
               VALUES (%(no)s,%(sup)s,%(date)s,%(cash)s,%(check)s,%(fa)s,%(ta)s,%(desc)s,%(creator)s)""",
            {
                "no": pay_no, "sup": data.sup_no, "date": pay_date, "cash": data.pay_cash, "check": data.pay_check,
                "fa": data.pay_from_advance, "ta": data.pay_to_advance, "desc": data.pay_desc, "creator": CREATOR,
            },
        )
        _update_sup_advance_amount(cur, data.sup_no)

        acnt_discount = 0.0
        seqno = 0
        for l in data.lines:
            if l.pad_amount == 0 and l.pad_discount == 0:
                continue
            seqno += 1
            cur.execute(
                """INSERT INTO TBL_AP_PAY_DT (PAY_NO,PAD_SEQNO,RCV_NO,PAD_AMOUNT,PAD_DISCOUNT)
                   VALUES (%(no)s,%(seq)s,%(rcv)s,%(amt)s,%(disc)s)""",
                {"no": pay_no, "seq": seqno, "rcv": l.rcv_no, "amt": l.pad_amount, "disc": l.pad_discount},
            )
            _update_ap_not_clean(cur, l.rcv_no)
            acnt_discount += l.pad_discount

        jnl_no = next_code(cur, "TBL_ACNT_JOURNAL", "JNL_NO", pay_date)
        desc = f"傳票過帳作業:{sup_name}:{pay_no}"
        insert_journal(cur, jnl_no, pay_date, desc, 1, CREATOR)

        desc1 = f"付款:{pay_no}:{sup_name}"
        seq = 1
        acnt_sum = data.pay_cash + data.pay_check + data.pay_from_advance + acnt_discount - data.pay_to_advance
        if data.pay_cash:
            insert_journal_line(cur, jnl_no, seq, sp["spr_acnt_cash"], -data.pay_cash, desc1); seq += 1
        if data.pay_check:
            insert_journal_line(cur, jnl_no, seq, sp["spr_acnt_sup_check"], -data.pay_check, desc1); seq += 1
        if acnt_discount:
            insert_journal_line(cur, jnl_no, seq, sp["spr_acnt_pur_discount"], -acnt_discount, desc1); seq += 1
        if data.pay_from_advance:
            insert_journal_line(cur, jnl_no, seq, sup_acnt_advance, -data.pay_from_advance, desc1); seq += 1
        if data.pay_to_advance:
            insert_journal_line(cur, jnl_no, seq, sup_acnt_advance, data.pay_to_advance, desc1); seq += 1
        insert_journal_line(cur, jnl_no, seq, sup_acnt_ap, acnt_sum, desc1)

        cur.execute("UPDATE TBL_AP_PAY SET JNL_NO=%(j)s WHERE PAY_NO=%(no)s", {"j": jnl_no, "no": pay_no})
        chk_dc_balance(cur, jnl_no)

        return {"message": "新增成功", "pay_no": pay_no}


@router.delete("/{pay_no}")
def delete_ap_pay(pay_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute("SELECT PAY_DATE, SUP_NO, JNL_NO FROM TBL_AP_PAY WHERE PAY_NO=%(no)s", {"no": pay_no})
        row = cur.fetchone()
        if not row:
            raise HTTPException(404, "付款單不存在")
        pay_date, sup_no, jnl_no = row
        sp = get_sys_param(cur)
        _check_year(sp, pay_date)

        cur.execute("SELECT DISTINCT RCV_NO FROM TBL_AP_PAY_DT WHERE PAY_NO=%(no)s", {"no": pay_no})
        rcv_nos = [r[0] for r in cur.fetchall()]

        cur.execute("DELETE FROM TBL_AP_PAY_DT WHERE PAY_NO=%(no)s", {"no": pay_no})
        for rcv_no in rcv_nos:
            _update_ap_not_clean(cur, rcv_no)

        cur.execute("DELETE FROM TBL_AP_PAY WHERE PAY_NO=%(no)s", {"no": pay_no})
        _update_sup_advance_amount(cur, sup_no)

        delete_journal(cur, jnl_no)
        return {"message": "刪除成功"}

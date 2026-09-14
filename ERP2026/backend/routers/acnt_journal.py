from datetime import date as date_type

from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel
from typing import Optional

from database import get_conn
from services.numbering import next_code
from services.sysparam import get_sys_param

router = APIRouter()

CREATOR = "WYS"  # 尚無登入系統，比照其他模組先固定值
BILL_TYPE_MANUAL = 0  # 手動傳票（0=手動 / 1=交易單據自動過帳 / 2=年度結轉，比照 erp_public.pas 慣例）


class JournalLine(BaseModel):
    act_no: str
    jnd_amount: float
    jnd_desc: Optional[str] = None


class JournalCreate(BaseModel):
    jnl_date: str
    jnl_desc: Optional[str] = None
    lines: list[JournalLine]


def row_to_dict(cur, row):
    return dict(zip([d[0].lower() for d in cur.description], row))


def _check_year(sp: dict, jnl_date):
    if jnl_date.year < sp["spr_acnt_year"]:
        raise HTTPException(400, "不得修改小於本會計年度的傳票")


def _validate_lines(cur, lines: list[JournalLine]):
    """比照 Form_Journal.chkDetail：借貸合計必須為 0、科目必須存在、金額不可為0。"""
    balance = sum(l.jnd_amount for l in lines)
    if round(balance, 4) != 0:
        raise HTTPException(400, f"借貸不平衡，差額={balance}")
    for l in lines:
        if l.jnd_amount == 0:
            raise HTTPException(400, "明細金額不可為0")
        cur.execute("SELECT 1 FROM TBL_ACNT_ACCOUNT WHERE ACT_NO=%(a)s", {"a": l.act_no})
        if not cur.fetchone():
            raise HTTPException(400, f"科目編號不存在: {l.act_no}")


def _insert_lines(cur, jnl_no: str, lines: list[JournalLine]):
    for i, line in enumerate(lines, start=1):
        cur.execute(
            """INSERT INTO TBL_ACNT_JOURNAL_DT (JNL_NO,JND_SEQNO,ACT_NO,JND_AMOUNT,JND_DESC)
               VALUES (%(no)s,%(seq)s,%(act)s,%(amt)s,%(desc)s)""",
            {"no": jnl_no, "seq": i, "act": line.act_no, "amt": line.jnd_amount, "desc": line.jnd_desc},
        )


SORTABLE_COLUMNS = {
    "jnl_no": "M.JNL_NO",
    "jnl_date": "M.JNL_DATE",
    "jnl_desc": "M.JNL_DESC",
}


def _parse_sort(sort: Optional[str]) -> str:
    if not sort:
        return "M.JNL_DATE DESC, M.JNL_NO DESC"
    parts = []
    for item in sort.split(","):
        field, _, direction = item.partition(":")
        col = SORTABLE_COLUMNS.get(field.strip())
        if not col:
            continue
        parts.append(f"{col} {'DESC' if direction.strip() == 'desc' else 'ASC'}")
    return ", ".join(parts) if parts else "M.JNL_DATE DESC, M.JNL_NO DESC"


@router.get("")
def list_journals(
    q: Optional[str] = Query(None),
    date_from: Optional[str] = Query(None),
    date_to: Optional[str] = Query(None),
    act_no: Optional[str] = Query(None),
    bill_type: Optional[int] = Query(None),
    sort: Optional[str] = Query(None),
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=500),
):
    with get_conn() as conn:
        cur = conn.cursor()
        where = ["1=1"]
        params: dict = {}
        if q and q.strip():
            where.append("(UPPER(M.JNL_NO) LIKE UPPER(%(q1)s) OR UPPER(M.JNL_DESC) LIKE UPPER(%(q2)s))")
            pq = f"%{q.strip()}%"
            params.update({"q1": pq, "q2": pq})
        if date_from:
            where.append("M.JNL_DATE>=%(date_from)s")
            params["date_from"] = date_from
        if date_to:
            where.append("M.JNL_DATE<%(date_to)s::date + 1")
            params["date_to"] = date_to
        if act_no:
            where.append("EXISTS (SELECT 1 FROM TBL_ACNT_JOURNAL_DT D WHERE D.JNL_NO=M.JNL_NO AND D.ACT_NO=%(act_no)s)")
            params["act_no"] = act_no
        if bill_type is not None:
            where.append("M.JNL_BILL_TYPE=%(bill_type)s")
            params["bill_type"] = bill_type
        where_sql = " AND ".join(where)
        order_sql = _parse_sort(sort)

        cur.execute(f"SELECT COUNT(*) FROM TBL_ACNT_JOURNAL M WHERE {where_sql}", params)
        total = cur.fetchone()[0]

        offset = (page - 1) * page_size
        cur.execute(
            f"""SELECT M.JNL_NO,M.JNL_DATE,M.JNL_DESC,M.JNL_BILL_TYPE,M.JNL_CREATOR,
                       (SELECT COALESCE(SUM(D.JND_AMOUNT),0) FROM TBL_ACNT_JOURNAL_DT D
                        WHERE D.JNL_NO=M.JNL_NO AND D.JND_AMOUNT>0) AS JNL_DEBIT_TOTAL
                FROM TBL_ACNT_JOURNAL M
                WHERE {where_sql}
                ORDER BY {order_sql}
                OFFSET %(offset)s ROWS FETCH NEXT %(lim)s ROWS ONLY""",
            {**params, "offset": offset, "lim": page_size},
        )
        rows = [row_to_dict(cur, r) for r in cur.fetchall()]
        return {"total": total, "page": page, "page_size": page_size, "data": rows}


@router.get("/{jnl_no}")
def get_journal(jnl_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute("SELECT * FROM TBL_ACNT_JOURNAL WHERE JNL_NO=%(no)s", {"no": jnl_no})
        row = cur.fetchone()
        if not row:
            raise HTTPException(404, "傳票不存在")
        header = row_to_dict(cur, row)
        cur.execute(
            """SELECT D.JNL_NO,D.JND_SEQNO,D.ACT_NO,A.ACT_NAME,D.JND_AMOUNT,D.JND_DESC
               FROM TBL_ACNT_JOURNAL_DT D
               LEFT JOIN TBL_ACNT_ACCOUNT A ON A.ACT_NO=D.ACT_NO
               WHERE D.JNL_NO=%(no)s ORDER BY D.JND_SEQNO""",
            {"no": jnl_no},
        )
        header["lines"] = [row_to_dict(cur, r) for r in cur.fetchall()]
        return header


@router.post("", status_code=201)
def create_journal(data: JournalCreate):
    with get_conn() as conn:
        cur = conn.cursor()
        sp = get_sys_param(cur)
        jnl_date = date_type.fromisoformat(data.jnl_date)
        _check_year(sp, jnl_date)
        _validate_lines(cur, data.lines)

        jnl_no = next_code(cur, "TBL_ACNT_JOURNAL", "JNL_NO", jnl_date)
        cur.execute(
            """INSERT INTO TBL_ACNT_JOURNAL (JNL_NO,JNL_DATE,JNL_DESC,JNL_BILL_TYPE,JNL_CREATOR)
               VALUES (%(no)s,%(date)s,%(desc)s,%(bt)s,%(creator)s)""",
            {"no": jnl_no, "date": jnl_date, "desc": data.jnl_desc, "bt": BILL_TYPE_MANUAL, "creator": CREATOR},
        )
        _insert_lines(cur, jnl_no, data.lines)
        return {"message": "新增成功", "jnl_no": jnl_no}


@router.put("/{jnl_no}")
def update_journal(jnl_no: str, data: JournalCreate):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute("SELECT JNL_DATE FROM TBL_ACNT_JOURNAL WHERE JNL_NO=%(no)s", {"no": jnl_no})
        row = cur.fetchone()
        if not row:
            raise HTTPException(404, "傳票不存在")
        sp = get_sys_param(cur)
        _check_year(sp, row[0])
        jnl_date = date_type.fromisoformat(data.jnl_date)
        _check_year(sp, jnl_date)
        _validate_lines(cur, data.lines)

        cur.execute(
            "UPDATE TBL_ACNT_JOURNAL SET JNL_DATE=%(date)s,JNL_DESC=%(desc)s WHERE JNL_NO=%(no)s",
            {"date": jnl_date, "desc": data.jnl_desc, "no": jnl_no},
        )
        cur.execute("DELETE FROM TBL_ACNT_JOURNAL_DT WHERE JNL_NO=%(no)s", {"no": jnl_no})
        _insert_lines(cur, jnl_no, data.lines)
        return {"message": "更新成功"}


@router.delete("/{jnl_no}")
def delete_journal(jnl_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute("SELECT JNL_DATE FROM TBL_ACNT_JOURNAL WHERE JNL_NO=%(no)s", {"no": jnl_no})
        row = cur.fetchone()
        if not row:
            raise HTTPException(404, "傳票不存在")
        sp = get_sys_param(cur)
        _check_year(sp, row[0])

        cur.execute("DELETE FROM TBL_ACNT_JOURNAL_DT WHERE JNL_NO=%(no)s", {"no": jnl_no})
        cur.execute("DELETE FROM TBL_ACNT_JOURNAL WHERE JNL_NO=%(no)s", {"no": jnl_no})
        return {"message": "刪除成功"}

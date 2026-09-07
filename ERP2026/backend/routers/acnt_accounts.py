import re

from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel, field_validator
from typing import Optional
from psycopg.errors import UniqueViolation
from database import get_conn

router = APIRouter()

# 比照 Delphi6ERP form_account.pas 的 ChkValidNo：4 碼數字（大科目）或 9 碼「4 碼數字.4 碼數字」（子科目）
ACT_NO_PATTERN = re.compile(r"^\d{4}$|^\d{4}\.\d{4}$")
ACT_NO_MSG = "科目編號必須是 4 碼數字（如 1111），或 9 碼「4 碼數字.4 碼數字」（如 1111.0001）"


class AcntAccountCreate(BaseModel):
    act_no: str
    typ_no: str
    act_name: str
    act_category_reverse: bool = False
    act_category_cash: bool = False
    act_desc: Optional[str] = None

    @field_validator("act_no")
    @classmethod
    def validate_act_no(cls, v):
        if not ACT_NO_PATTERN.match(v):
            raise ValueError(ACT_NO_MSG)
        return v


class AcntAccountUpdate(BaseModel):
    typ_no: str
    act_name: str
    act_category_reverse: bool = False
    act_category_cash: bool = False
    act_desc: Optional[str] = None


def row_to_dict(cur, row):
    return dict(zip([d[0].lower() for d in cur.description], row))


@router.get("")
def list_acnt_accounts(
    q: Optional[str] = Query(None, description="搜尋科目編號/名稱"),
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=10000),
):
    with get_conn() as conn:
        cur = conn.cursor()
        where = ""
        params: dict = {}
        if q and q.strip():
            where = """WHERE UPPER(ACT_NO) LIKE UPPER(%(q1)s)
                          OR UPPER(ACT_NAME) LIKE UPPER(%(q2)s)"""
            pq = f"%{q.strip()}%"
            params = {"q1": pq, "q2": pq}

        cur.execute(f"SELECT COUNT(*) FROM TBL_ACNT_ACCOUNT {where}", params)
        total = cur.fetchone()[0]

        offset = (page - 1) * page_size
        cur.execute(
            f"""SELECT M.ACT_NO,M.TYP_NO,T.TYP_NAME,M.ACT_NAME,
                       M.ACT_CATEGORY_REVERSE,M.ACT_CATEGORY_CASH,
                       M.ACT_DESC,M.ACT_CREATOR
                FROM TBL_ACNT_ACCOUNT M
                LEFT JOIN TBL_ACNT_TYPE T ON T.TYP_NO=M.TYP_NO
                {where}
               ORDER BY M.ACT_NO
               OFFSET %(offset)s ROWS FETCH NEXT %(lim)s ROWS ONLY""",
            {**params, "offset": offset, "lim": page_size},
        )
        rows = [row_to_dict(cur, r) for r in cur.fetchall()]
        return {"total": total, "page": page, "page_size": page_size, "data": rows}


@router.get("/types")
def list_acnt_types():
    """會計科目類別下拉選單資料來源。"""
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """SELECT TYP_NO,TYP_NAME,TYP_MAJOR_TYPE
               FROM TBL_ACNT_TYPE ORDER BY TYP_NO"""
        )
        return [row_to_dict(cur, r) for r in cur.fetchall()]


@router.get("/{act_no}")
def get_acnt_account(act_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """SELECT ACT_NO,TYP_NO,ACT_NAME,ACT_CATEGORY_REVERSE,
                      ACT_CATEGORY_CASH,ACT_DESC,ACT_CREATOR
               FROM TBL_ACNT_ACCOUNT WHERE ACT_NO=%(id)s""",
            {"id": act_no},
        )
        row = cur.fetchone()
        if not row:
            raise HTTPException(404, "會計科目不存在")
        return row_to_dict(cur, row)


@router.post("", status_code=201)
def create_acnt_account(data: AcntAccountCreate):
    with get_conn() as conn:
        cur = conn.cursor()
        try:
            cur.execute(
                """INSERT INTO TBL_ACNT_ACCOUNT
                       (ACT_NO,TYP_NO,ACT_NAME,ACT_CATEGORY_REVERSE,
                        ACT_CATEGORY_CASH,ACT_DESC,ACT_CREATOR)
                   VALUES(%(act_no)s,%(typ_no)s,%(act_name)s,%(act_category_reverse)s,
                          %(act_category_cash)s,%(act_desc)s,'WYS')""",
                data.model_dump(),
            )
        except UniqueViolation:
            raise HTTPException(409, "會計科目編號已存在")
        return {"message": "新增成功", "act_no": data.act_no}


@router.put("/{act_no}")
def update_acnt_account(act_no: str, data: AcntAccountUpdate):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """UPDATE TBL_ACNT_ACCOUNT SET
                   TYP_NO=%(typ_no)s,ACT_NAME=%(act_name)s,
                   ACT_CATEGORY_REVERSE=%(act_category_reverse)s,
                   ACT_CATEGORY_CASH=%(act_category_cash)s,ACT_DESC=%(act_desc)s
               WHERE ACT_NO=%(act_no)s""",
            {**data.model_dump(), "act_no": act_no},
        )
        if cur.rowcount == 0:
            raise HTTPException(404, "會計科目不存在")
        return {"message": "更新成功"}


@router.delete("/{act_no}")
def delete_acnt_account(act_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute("DELETE FROM TBL_ACNT_ACCOUNT WHERE ACT_NO=%(id)s", {"id": act_no})
        if cur.rowcount == 0:
            raise HTTPException(404, "會計科目不存在")
        return {"message": "刪除成功"}

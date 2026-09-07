from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel
from typing import Optional
from psycopg.errors import UniqueViolation
from database import get_conn

router = APIRouter()


class CustomerCreate(BaseModel):
    cum_no: str
    cum_name: str
    cum_president: Optional[str] = None
    cum_contant: Optional[str] = None
    cum_cont_title: Optional[str] = None
    cum_tel1: Optional[str] = None
    cum_tel2: Optional[str] = None
    cum_fax: Optional[str] = None
    cum_uniform_no: Optional[str] = None
    cum_inv_addr: Optional[str] = None
    cum_addr: Optional[str] = None
    cum_zip_code: Optional[str] = None
    cum_advance_amount: float = 0
    cum_desc: Optional[str] = None
    cum_acnt_ar: str = "1141"
    cum_acnt_advance: str = "2261"
    cum_inv_rate: float = 0.05


class RenumberRequest(BaseModel):
    new_no: str


class CustomerUpdate(BaseModel):
    cum_name: str
    cum_president: Optional[str] = None
    cum_contant: Optional[str] = None
    cum_cont_title: Optional[str] = None
    cum_tel1: Optional[str] = None
    cum_tel2: Optional[str] = None
    cum_fax: Optional[str] = None
    cum_uniform_no: Optional[str] = None
    cum_inv_addr: Optional[str] = None
    cum_addr: Optional[str] = None
    cum_zip_code: Optional[str] = None
    cum_advance_amount: float = 0
    cum_desc: Optional[str] = None
    cum_acnt_ar: str = "1141"
    cum_acnt_advance: str = "2261"
    cum_inv_rate: float = 0.05


def row_to_dict(cur, row):
    return dict(zip([d[0].lower() for d in cur.description], row))


@router.get("")
def list_customers(
    q: Optional[str] = Query(None, description="搜尋客戶編號/名稱/統編"),
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=10000),
):
    with get_conn() as conn:
        cur = conn.cursor()
        where = ""
        params: dict = {}
        if q and q.strip():
            where = """WHERE UPPER(CUM_NO) LIKE UPPER(%(q1)s)
                          OR UPPER(CUM_NAME) LIKE UPPER(%(q2)s)
                          OR CUM_UNIFORM_NO LIKE %(q3)s"""
            pq = f"%{q.strip()}%"
            params = {"q1": pq, "q2": pq, "q3": pq}

        cur.execute(f"SELECT COUNT(*) FROM TBL_CUSTOMER {where}", params)
        total = cur.fetchone()[0]

        offset = (page - 1) * page_size
        cur.execute(
            f"""SELECT CUM_NO,CUM_NAME,CUM_PRESIDENT,CUM_CONTANT,CUM_CONT_TITLE,
                       CUM_TEL1,CUM_TEL2,CUM_FAX,CUM_UNIFORM_NO,
                       CUM_INV_ADDR,CUM_ADDR,CUM_ZIP_CODE,
                       CUM_ADVANCE_AMOUNT,CUM_DESC,CUM_CREATOR,
                       CUM_ACNT_AR,CUM_ACNT_ADVANCE,CUM_INV_RATE
                FROM TBL_CUSTOMER {where}
               ORDER BY CUM_NO
               OFFSET %(offset)s ROWS FETCH NEXT %(lim)s ROWS ONLY""",
            {**params, "offset": offset, "lim": page_size},
        )
        rows = [row_to_dict(cur, r) for r in cur.fetchall()]
        return {"total": total, "page": page, "page_size": page_size, "data": rows}


@router.get("/report-data")
def report_data(q: Optional[str] = Query(None)):
    """Stimulsoft JSON data source — returns customer list with Chinese column aliases."""
    with get_conn() as conn:
        cur = conn.cursor()
        where = ""
        params: dict = {}
        if q and q.strip():
            where = "WHERE UPPER(CUM_NAME) LIKE UPPER(%(q)s)"
            params = {"q": f"%{q.strip()}%"}

        cur.execute(
            f"""SELECT CUM_NO        AS "客戶編號",
                       CUM_NAME      AS "客戶名稱",
                       CUM_PRESIDENT AS "負責人",
                       CUM_CONTANT   AS "聯絡人",
                       CUM_CONT_TITLE AS "聯絡人職稱",
                       CUM_TEL1      AS "電話",
                       CUM_FAX       AS "傳真",
                       CUM_UNIFORM_NO AS "統一編號",
                       CUM_ZIP_CODE  AS "郵遞區號",
                       CUM_ADDR      AS "公司地址",
                       CUM_INV_ADDR  AS "發票地址",
                       CUM_INV_RATE  AS "稅率",
                       CUM_ADVANCE_AMOUNT AS "預收款餘額",
                       CUM_ACNT_AR   AS "應收帳款科目",
                       CUM_DESC      AS "說明"
                  FROM TBL_CUSTOMER {where}
                 ORDER BY CUM_NO""",
            params,
        )
        cols = [d[0] for d in cur.description]
        return [dict(zip(cols, r)) for r in cur.fetchall()]


@router.get("/{cum_no}")
def get_customer(cum_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """SELECT CUM_NO,CUM_NAME,CUM_PRESIDENT,CUM_CONTANT,CUM_CONT_TITLE,
                      CUM_TEL1,CUM_TEL2,CUM_FAX,CUM_UNIFORM_NO,
                      CUM_INV_ADDR,CUM_ADDR,CUM_ZIP_CODE,
                      CUM_ADVANCE_AMOUNT,CUM_DESC,CUM_CREATOR,
                      CUM_ACNT_AR,CUM_ACNT_ADVANCE,CUM_INV_RATE
               FROM TBL_CUSTOMER WHERE CUM_NO=%(id)s""",
            {"id": cum_no},
        )
        row = cur.fetchone()
        if not row:
            raise HTTPException(404, "客戶不存在")
        return row_to_dict(cur, row)


@router.post("", status_code=201)
def create_customer(data: CustomerCreate):
    with get_conn() as conn:
        cur = conn.cursor()
        try:
            cur.execute(
                """INSERT INTO TBL_CUSTOMER
                       (CUM_NO,CUM_NAME,CUM_PRESIDENT,CUM_CONTANT,CUM_CONT_TITLE,
                        CUM_TEL1,CUM_TEL2,CUM_FAX,CUM_UNIFORM_NO,
                        CUM_INV_ADDR,CUM_ADDR,CUM_ZIP_CODE,
                        CUM_ADVANCE_AMOUNT,CUM_DESC,CUM_CREATOR,
                        CUM_ACNT_AR,CUM_ACNT_ADVANCE,CUM_INV_RATE)
                   VALUES(%(cum_no)s,%(cum_name)s,%(cum_president)s,%(cum_contant)s,%(cum_cont_title)s,
                          %(cum_tel1)s,%(cum_tel2)s,%(cum_fax)s,%(cum_uniform_no)s,
                          %(cum_inv_addr)s,%(cum_addr)s,%(cum_zip_code)s,
                          %(cum_advance_amount)s,%(cum_desc)s,'WYS',
                          %(cum_acnt_ar)s,%(cum_acnt_advance)s,%(cum_inv_rate)s)""",
                data.model_dump(),
            )
        except UniqueViolation:
            raise HTTPException(409, "客戶編號已存在")
        return {"message": "新增成功", "cum_no": data.cum_no}


@router.put("/{cum_no}")
def update_customer(cum_no: str, data: CustomerUpdate):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """UPDATE TBL_CUSTOMER SET
                   CUM_NAME=%(cum_name)s,CUM_PRESIDENT=%(cum_president)s,
                   CUM_CONTANT=%(cum_contant)s,CUM_CONT_TITLE=%(cum_cont_title)s,
                   CUM_TEL1=%(cum_tel1)s,CUM_TEL2=%(cum_tel2)s,CUM_FAX=%(cum_fax)s,
                   CUM_UNIFORM_NO=%(cum_uniform_no)s,CUM_INV_ADDR=%(cum_inv_addr)s,
                   CUM_ADDR=%(cum_addr)s,CUM_ZIP_CODE=%(cum_zip_code)s,
                   CUM_ADVANCE_AMOUNT=%(cum_advance_amount)s,CUM_DESC=%(cum_desc)s,
                   CUM_ACNT_AR=%(cum_acnt_ar)s,CUM_ACNT_ADVANCE=%(cum_acnt_advance)s,
                   CUM_INV_RATE=%(cum_inv_rate)s
               WHERE CUM_NO=%(cum_no)s""",
            {**data.model_dump(), "cum_no": cum_no},
        )
        if cur.rowcount == 0:
            raise HTTPException(404, "客戶不存在")
        return {"message": "更新成功"}


@router.delete("/{cum_no}")
def delete_customer(cum_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute("DELETE FROM TBL_CUSTOMER WHERE CUM_NO=%(id)s", {"id": cum_no})
        if cur.rowcount == 0:
            raise HTTPException(404, "客戶不存在")
        return {"message": "刪除成功"}


@router.put("/{cum_no}/renumber")
def renumber_customer(cum_no: str, data: RenumberRequest):
    """比照 Delphi6ERP FORM_CUSTOMER.pas 的 Modify_NO：新編號複製一筆主檔，
    串連更新 TBL_SHIP/TBL_HIS_SHIP/TBL_AR_RECV 的 CUM_NO，再刪除舊編號。"""
    new_no = data.new_no.strip()
    if not new_no:
        raise HTTPException(400, "新編號不可為空白")
    with get_conn() as conn:
        cur = conn.cursor()
        try:
            cur.execute(
                """INSERT INTO TBL_CUSTOMER
                       (CUM_NO,CUM_NAME,CUM_PRESIDENT,CUM_CONTANT,CUM_CONT_TITLE,
                        CUM_TEL1,CUM_TEL2,CUM_FAX,CUM_UNIFORM_NO,
                        CUM_INV_ADDR,CUM_ADDR,CUM_ZIP_CODE,
                        CUM_ADVANCE_AMOUNT,CUM_DESC,CUM_CREATOR,
                        CUM_ACNT_AR,CUM_ACNT_ADVANCE,CUM_INV_RATE)
                   SELECT %(new_no)s,CUM_NAME,CUM_PRESIDENT,CUM_CONTANT,CUM_CONT_TITLE,
                          CUM_TEL1,CUM_TEL2,CUM_FAX,CUM_UNIFORM_NO,
                          CUM_INV_ADDR,CUM_ADDR,CUM_ZIP_CODE,
                          CUM_ADVANCE_AMOUNT,CUM_DESC,CUM_CREATOR,
                          CUM_ACNT_AR,CUM_ACNT_ADVANCE,CUM_INV_RATE
                     FROM TBL_CUSTOMER WHERE CUM_NO=%(old_no)s""",
                {"new_no": new_no, "old_no": cum_no},
            )
        except UniqueViolation:
            raise HTTPException(409, "新編號已存在")
        if cur.rowcount == 0:
            raise HTTPException(404, "客戶不存在")

        cur.execute("UPDATE TBL_SHIP SET CUM_NO=%(new_no)s WHERE CUM_NO=%(old_no)s",
                    {"new_no": new_no, "old_no": cum_no})
        cur.execute("UPDATE TBL_HIS_SHIP SET CUM_NO=%(new_no)s WHERE CUM_NO=%(old_no)s",
                    {"new_no": new_no, "old_no": cum_no})
        cur.execute("UPDATE TBL_AR_RECV SET CUM_NO=%(new_no)s WHERE CUM_NO=%(old_no)s",
                    {"new_no": new_no, "old_no": cum_no})
        cur.execute("DELETE FROM TBL_CUSTOMER WHERE CUM_NO=%(old_no)s", {"old_no": cum_no})
        return {"message": "編號變更成功", "new_no": new_no}

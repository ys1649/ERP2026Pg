from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel
from typing import Optional
from psycopg.errors import UniqueViolation
from database import get_conn

router = APIRouter()


class SupplierCreate(BaseModel):
    sup_no: str
    sup_name: str
    sup_president: Optional[str] = None
    sup_contant: Optional[str] = None
    sup_cont_title: Optional[str] = None
    sup_tel1: Optional[str] = None
    sup_tel2: Optional[str] = None
    sup_fax: Optional[str] = None
    sup_uniform_no: Optional[str] = None
    sup_inv_addr: Optional[str] = None
    sup_addr: Optional[str] = None
    sup_zip_code: Optional[str] = None
    sup_advance_amount: float = 0
    sup_desc: Optional[str] = None
    sup_acnt_ap: str = "2141"
    sup_acnt_advance: str = "1261"


class RenumberRequest(BaseModel):
    new_no: str


class SupplierUpdate(BaseModel):
    sup_name: str
    sup_president: Optional[str] = None
    sup_contant: Optional[str] = None
    sup_cont_title: Optional[str] = None
    sup_tel1: Optional[str] = None
    sup_tel2: Optional[str] = None
    sup_fax: Optional[str] = None
    sup_uniform_no: Optional[str] = None
    sup_inv_addr: Optional[str] = None
    sup_addr: Optional[str] = None
    sup_zip_code: Optional[str] = None
    sup_advance_amount: float = 0
    sup_desc: Optional[str] = None
    sup_acnt_ap: str = "2141"
    sup_acnt_advance: str = "1261"


def row_to_dict(cur, row):
    return dict(zip([d[0].lower() for d in cur.description], row))


@router.get("")
def list_suppliers(
    q: Optional[str] = Query(None, description="搜尋廠商編號/名稱/統編"),
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=10000),
):
    with get_conn() as conn:
        cur = conn.cursor()
        where = ""
        params: dict = {}
        if q and q.strip():
            where = """WHERE UPPER(SUP_NO) LIKE UPPER(%(q1)s)
                          OR UPPER(SUP_NAME) LIKE UPPER(%(q2)s)
                          OR SUP_UNIFORM_NO LIKE %(q3)s"""
            pq = f"%{q.strip()}%"
            params = {"q1": pq, "q2": pq, "q3": pq}

        cur.execute(f"SELECT COUNT(*) FROM TBL_SUPPLIER {where}", params)
        total = cur.fetchone()[0]

        offset = (page - 1) * page_size
        cur.execute(
            f"""SELECT SUP_NO,SUP_NAME,SUP_PRESIDENT,SUP_CONTANT,SUP_CONT_TITLE,
                       SUP_TEL1,SUP_TEL2,SUP_FAX,SUP_UNIFORM_NO,
                       SUP_INV_ADDR,SUP_ADDR,SUP_ZIP_CODE,
                       SUP_ADVANCE_AMOUNT,SUP_DESC,SUP_CREATOR,
                       SUP_ACNT_AP,SUP_ACNT_ADVANCE
                FROM TBL_SUPPLIER {where}
               ORDER BY SUP_NO
               OFFSET %(offset)s ROWS FETCH NEXT %(lim)s ROWS ONLY""",
            {**params, "offset": offset, "lim": page_size},
        )
        rows = [row_to_dict(cur, r) for r in cur.fetchall()]
        return {"total": total, "page": page, "page_size": page_size, "data": rows}


@router.get("/{sup_no}")
def get_supplier(sup_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """SELECT SUP_NO,SUP_NAME,SUP_PRESIDENT,SUP_CONTANT,SUP_CONT_TITLE,
                      SUP_TEL1,SUP_TEL2,SUP_FAX,SUP_UNIFORM_NO,
                      SUP_INV_ADDR,SUP_ADDR,SUP_ZIP_CODE,
                      SUP_ADVANCE_AMOUNT,SUP_DESC,SUP_CREATOR,
                      SUP_ACNT_AP,SUP_ACNT_ADVANCE
               FROM TBL_SUPPLIER WHERE SUP_NO=%(id)s""",
            {"id": sup_no},
        )
        row = cur.fetchone()
        if not row:
            raise HTTPException(404, "廠商不存在")
        return row_to_dict(cur, row)


@router.post("", status_code=201)
def create_supplier(data: SupplierCreate):
    with get_conn() as conn:
        cur = conn.cursor()
        try:
            cur.execute(
                """INSERT INTO TBL_SUPPLIER
                       (SUP_NO,SUP_NAME,SUP_PRESIDENT,SUP_CONTANT,SUP_CONT_TITLE,
                        SUP_TEL1,SUP_TEL2,SUP_FAX,SUP_UNIFORM_NO,
                        SUP_INV_ADDR,SUP_ADDR,SUP_ZIP_CODE,
                        SUP_ADVANCE_AMOUNT,SUP_DESC,SUP_CREATOR,
                        SUP_ACNT_AP,SUP_ACNT_ADVANCE)
                   VALUES(%(sup_no)s,%(sup_name)s,%(sup_president)s,%(sup_contant)s,%(sup_cont_title)s,
                          %(sup_tel1)s,%(sup_tel2)s,%(sup_fax)s,%(sup_uniform_no)s,
                          %(sup_inv_addr)s,%(sup_addr)s,%(sup_zip_code)s,
                          %(sup_advance_amount)s,%(sup_desc)s,'WYS',
                          %(sup_acnt_ap)s,%(sup_acnt_advance)s)""",
                data.model_dump(),
            )
        except UniqueViolation:
            raise HTTPException(409, "廠商編號已存在")
        return {"message": "新增成功", "sup_no": data.sup_no}


@router.put("/{sup_no}")
def update_supplier(sup_no: str, data: SupplierUpdate):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """UPDATE TBL_SUPPLIER SET
                   SUP_NAME=%(sup_name)s,SUP_PRESIDENT=%(sup_president)s,
                   SUP_CONTANT=%(sup_contant)s,SUP_CONT_TITLE=%(sup_cont_title)s,
                   SUP_TEL1=%(sup_tel1)s,SUP_TEL2=%(sup_tel2)s,SUP_FAX=%(sup_fax)s,
                   SUP_UNIFORM_NO=%(sup_uniform_no)s,SUP_INV_ADDR=%(sup_inv_addr)s,
                   SUP_ADDR=%(sup_addr)s,SUP_ZIP_CODE=%(sup_zip_code)s,
                   SUP_ADVANCE_AMOUNT=%(sup_advance_amount)s,SUP_DESC=%(sup_desc)s,
                   SUP_ACNT_AP=%(sup_acnt_ap)s,SUP_ACNT_ADVANCE=%(sup_acnt_advance)s
               WHERE SUP_NO=%(sup_no)s""",
            {**data.model_dump(), "sup_no": sup_no},
        )
        if cur.rowcount == 0:
            raise HTTPException(404, "廠商不存在")
        return {"message": "更新成功"}


@router.delete("/{sup_no}")
def delete_supplier(sup_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute("DELETE FROM TBL_SUPPLIER WHERE SUP_NO=%(id)s", {"id": sup_no})
        if cur.rowcount == 0:
            raise HTTPException(404, "廠商不存在")
        return {"message": "刪除成功"}


@router.put("/{sup_no}/renumber")
def renumber_supplier(sup_no: str, data: RenumberRequest):
    """比照 Delphi6ERP Form_Supplier.pas 的 Modify_NO：新編號複製一筆主檔，
    串連更新 TBL_PO_RECV/TBL_HIS_PO_RECV/TBL_AP_PAY 的 SUP_NO，再刪除舊編號。"""
    new_no = data.new_no.strip()
    if not new_no:
        raise HTTPException(400, "新編號不可為空白")
    with get_conn() as conn:
        cur = conn.cursor()
        try:
            cur.execute(
                """INSERT INTO TBL_SUPPLIER
                       (SUP_NO,SUP_NAME,SUP_PRESIDENT,SUP_CONTANT,SUP_CONT_TITLE,
                        SUP_TEL1,SUP_TEL2,SUP_FAX,SUP_UNIFORM_NO,
                        SUP_INV_ADDR,SUP_ADDR,SUP_ZIP_CODE,
                        SUP_ADVANCE_AMOUNT,SUP_DESC,SUP_CREATOR,
                        SUP_ACNT_AP,SUP_ACNT_ADVANCE)
                   SELECT %(new_no)s,SUP_NAME,SUP_PRESIDENT,SUP_CONTANT,SUP_CONT_TITLE,
                          SUP_TEL1,SUP_TEL2,SUP_FAX,SUP_UNIFORM_NO,
                          SUP_INV_ADDR,SUP_ADDR,SUP_ZIP_CODE,
                          SUP_ADVANCE_AMOUNT,SUP_DESC,SUP_CREATOR,
                          SUP_ACNT_AP,SUP_ACNT_ADVANCE
                     FROM TBL_SUPPLIER WHERE SUP_NO=%(old_no)s""",
                {"new_no": new_no, "old_no": sup_no},
            )
        except UniqueViolation:
            raise HTTPException(409, "新編號已存在")
        if cur.rowcount == 0:
            raise HTTPException(404, "廠商不存在")

        cur.execute("UPDATE TBL_PO_RECV SET SUP_NO=%(new_no)s WHERE SUP_NO=%(old_no)s",
                    {"new_no": new_no, "old_no": sup_no})
        cur.execute("UPDATE TBL_HIS_PO_RECV SET SUP_NO=%(new_no)s WHERE SUP_NO=%(old_no)s",
                    {"new_no": new_no, "old_no": sup_no})
        cur.execute("UPDATE TBL_AP_PAY SET SUP_NO=%(new_no)s WHERE SUP_NO=%(old_no)s",
                    {"new_no": new_no, "old_no": sup_no})
        cur.execute("DELETE FROM TBL_SUPPLIER WHERE SUP_NO=%(old_no)s", {"old_no": sup_no})
        return {"message": "編號變更成功", "new_no": new_no}

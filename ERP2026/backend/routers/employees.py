from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel
from typing import Optional
from psycopg.errors import UniqueViolation
from database import get_conn

router = APIRouter()


class EmployeeCreate(BaseModel):
    epy_no: str
    epy_name: str
    epy_password: Optional[str] = None
    epy_tel1: Optional[str] = None
    epy_tel2: Optional[str] = None
    epy_addr: Optional[str] = None
    epy_is_can_login: bool = True
    epy_desc: Optional[str] = None


class RenumberRequest(BaseModel):
    new_no: str


class EmployeeUpdate(BaseModel):
    epy_name: str
    epy_password: Optional[str] = None
    epy_tel1: Optional[str] = None
    epy_tel2: Optional[str] = None
    epy_addr: Optional[str] = None
    epy_is_can_login: bool = True
    epy_desc: Optional[str] = None


def row_to_dict(cur, row):
    return dict(zip([d[0].lower() for d in cur.description], row))


@router.get("")
def list_employees(
    q: Optional[str] = Query(None, description="搜尋員工編號/姓名"),
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=10000),
):
    with get_conn() as conn:
        cur = conn.cursor()
        where = ""
        params: dict = {}
        if q and q.strip():
            where = """WHERE UPPER(EPY_NO) LIKE UPPER(%(q1)s)
                          OR UPPER(EPY_NAME) LIKE UPPER(%(q2)s)"""
            pq = f"%{q.strip()}%"
            params = {"q1": pq, "q2": pq}

        cur.execute(f"SELECT COUNT(*) FROM TBL_EMPLOYE {where}", params)
        total = cur.fetchone()[0]

        offset = (page - 1) * page_size
        cur.execute(
            f"""SELECT EPY_NO,EPY_NAME,EPY_PASSWORD,EPY_TEL1,EPY_TEL2,EPY_ADDR,
                       EPY_IS_CAN_LOGIN,EPY_DESC,EPY_CREATOR
                FROM TBL_EMPLOYE {where}
               ORDER BY EPY_NO
               OFFSET %(offset)s ROWS FETCH NEXT %(lim)s ROWS ONLY""",
            {**params, "offset": offset, "lim": page_size},
        )
        rows = [row_to_dict(cur, r) for r in cur.fetchall()]
        return {"total": total, "page": page, "page_size": page_size, "data": rows}


@router.get("/{epy_no}")
def get_employee(epy_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """SELECT EPY_NO,EPY_NAME,EPY_PASSWORD,EPY_TEL1,EPY_TEL2,EPY_ADDR,
                      EPY_IS_CAN_LOGIN,EPY_DESC,EPY_CREATOR
               FROM TBL_EMPLOYE WHERE EPY_NO=%(id)s""",
            {"id": epy_no},
        )
        row = cur.fetchone()
        if not row:
            raise HTTPException(404, "員工不存在")
        return row_to_dict(cur, row)


@router.post("", status_code=201)
def create_employee(data: EmployeeCreate):
    with get_conn() as conn:
        cur = conn.cursor()
        try:
            cur.execute(
                """INSERT INTO TBL_EMPLOYE
                       (EPY_NO,EPY_NAME,EPY_PASSWORD,EPY_TEL1,EPY_TEL2,EPY_ADDR,
                        EPY_IS_CAN_LOGIN,EPY_DESC,EPY_CREATOR)
                   VALUES(%(epy_no)s,%(epy_name)s,%(epy_password)s,%(epy_tel1)s,%(epy_tel2)s,%(epy_addr)s,
                          %(epy_is_can_login)s,%(epy_desc)s,'WYS')""",
                data.model_dump(),
            )
        except UniqueViolation:
            raise HTTPException(409, "員工編號已存在")
        return {"message": "新增成功", "epy_no": data.epy_no}


@router.put("/{epy_no}")
def update_employee(epy_no: str, data: EmployeeUpdate):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """UPDATE TBL_EMPLOYE SET
                   EPY_NAME=%(epy_name)s,EPY_PASSWORD=%(epy_password)s,
                   EPY_TEL1=%(epy_tel1)s,EPY_TEL2=%(epy_tel2)s,EPY_ADDR=%(epy_addr)s,
                   EPY_IS_CAN_LOGIN=%(epy_is_can_login)s,EPY_DESC=%(epy_desc)s
               WHERE EPY_NO=%(epy_no)s""",
            {**data.model_dump(), "epy_no": epy_no},
        )
        if cur.rowcount == 0:
            raise HTTPException(404, "員工不存在")
        return {"message": "更新成功"}


@router.delete("/{epy_no}")
def delete_employee(epy_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute("DELETE FROM TBL_EMPLOYE WHERE EPY_NO=%(id)s", {"id": epy_no})
        if cur.rowcount == 0:
            raise HTTPException(404, "員工不存在")
        return {"message": "刪除成功"}


@router.put("/{epy_no}/renumber")
def renumber_employee(epy_no: str, data: RenumberRequest):
    """比照 Delphi6ERP form_employee.pas 的 Modify_NO：新編號複製一筆主檔，
    串連更新 TBL_SHIP 的 EPY_NO/SMT_DELIVER1/SMT_DELIVER2，再刪除舊編號。"""
    new_no = data.new_no.strip()
    if not new_no:
        raise HTTPException(400, "新編號不可為空白")
    with get_conn() as conn:
        cur = conn.cursor()
        try:
            cur.execute(
                """INSERT INTO TBL_EMPLOYE
                       (EPY_NO,EPY_NAME,EPY_PASSWORD,EPY_TEL1,EPY_TEL2,EPY_ADDR,
                        EPY_IS_CAN_LOGIN,EPY_DESC,EPY_CREATOR)
                   SELECT %(new_no)s,EPY_NAME,EPY_PASSWORD,EPY_TEL1,EPY_TEL2,EPY_ADDR,
                          EPY_IS_CAN_LOGIN,EPY_DESC,EPY_CREATOR
                     FROM TBL_EMPLOYE WHERE EPY_NO=%(old_no)s""",
                {"new_no": new_no, "old_no": epy_no},
            )
        except UniqueViolation:
            raise HTTPException(409, "新編號已存在")
        if cur.rowcount == 0:
            raise HTTPException(404, "員工不存在")

        cur.execute("UPDATE TBL_SHIP SET EPY_NO=%(new_no)s WHERE EPY_NO=%(old_no)s",
                    {"new_no": new_no, "old_no": epy_no})
        cur.execute("UPDATE TBL_SHIP SET SMT_DELIVER1=%(new_no)s WHERE SMT_DELIVER1=%(old_no)s",
                    {"new_no": new_no, "old_no": epy_no})
        cur.execute("UPDATE TBL_SHIP SET SMT_DELIVER2=%(new_no)s WHERE SMT_DELIVER2=%(old_no)s",
                    {"new_no": new_no, "old_no": epy_no})
        cur.execute("DELETE FROM TBL_EMPLOYE WHERE EPY_NO=%(old_no)s", {"old_no": epy_no})
        return {"message": "編號變更成功", "new_no": new_no}

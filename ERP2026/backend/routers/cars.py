from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel
from typing import Optional
from psycopg.errors import UniqueViolation
from database import get_conn

router = APIRouter()


class CarCreate(BaseModel):
    car_no: str
    car_brand: Optional[str] = None
    car_license_no: Optional[str] = None
    car_date1: Optional[str] = None
    car_desc: Optional[str] = None


class RenumberRequest(BaseModel):
    new_no: str


class CarUpdate(BaseModel):
    car_brand: Optional[str] = None
    car_license_no: Optional[str] = None
    car_date1: Optional[str] = None
    car_desc: Optional[str] = None


def row_to_dict(cur, row):
    return dict(zip([d[0].lower() for d in cur.description], row))


@router.get("")
def list_cars(
    q: Optional[str] = Query(None, description="搜尋車輛編號/廠牌/車牌"),
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=10000),
):
    with get_conn() as conn:
        cur = conn.cursor()
        where = ""
        params: dict = {}
        if q and q.strip():
            where = """WHERE UPPER(CAR_NO) LIKE UPPER(%(q1)s)
                          OR UPPER(CAR_BRAND) LIKE UPPER(%(q2)s)
                          OR UPPER(CAR_LICENSE_NO) LIKE UPPER(%(q3)s)"""
            pq = f"%{q.strip()}%"
            params = {"q1": pq, "q2": pq, "q3": pq}

        cur.execute(f"SELECT COUNT(*) FROM TBL_CAR {where}", params)
        total = cur.fetchone()[0]

        offset = (page - 1) * page_size
        cur.execute(
            f"""SELECT CAR_NO,CAR_BRAND,CAR_LICENSE_NO,CAR_DATE1,CAR_DESC,CAR_CREATOR
                FROM TBL_CAR {where}
               ORDER BY CAR_NO
               OFFSET %(offset)s ROWS FETCH NEXT %(lim)s ROWS ONLY""",
            {**params, "offset": offset, "lim": page_size},
        )
        rows = [row_to_dict(cur, r) for r in cur.fetchall()]
        return {"total": total, "page": page, "page_size": page_size, "data": rows}


@router.get("/{car_no}")
def get_car(car_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """SELECT CAR_NO,CAR_BRAND,CAR_LICENSE_NO,CAR_DATE1,CAR_DESC,CAR_CREATOR
               FROM TBL_CAR WHERE CAR_NO=%(id)s""",
            {"id": car_no},
        )
        row = cur.fetchone()
        if not row:
            raise HTTPException(404, "車輛不存在")
        return row_to_dict(cur, row)


@router.post("", status_code=201)
def create_car(data: CarCreate):
    with get_conn() as conn:
        cur = conn.cursor()
        try:
            cur.execute(
                """INSERT INTO TBL_CAR
                       (CAR_NO,CAR_BRAND,CAR_LICENSE_NO,CAR_DATE1,CAR_DESC,CAR_CREATOR)
                   VALUES(%(car_no)s,%(car_brand)s,%(car_license_no)s,%(car_date1)s,%(car_desc)s,'WYS')""",
                data.model_dump(),
            )
        except UniqueViolation:
            raise HTTPException(409, "車輛編號已存在")
        return {"message": "新增成功", "car_no": data.car_no}


@router.put("/{car_no}")
def update_car(car_no: str, data: CarUpdate):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """UPDATE TBL_CAR SET
                   CAR_BRAND=%(car_brand)s,CAR_LICENSE_NO=%(car_license_no)s,
                   CAR_DATE1=%(car_date1)s,CAR_DESC=%(car_desc)s
               WHERE CAR_NO=%(car_no)s""",
            {**data.model_dump(), "car_no": car_no},
        )
        if cur.rowcount == 0:
            raise HTTPException(404, "車輛不存在")
        return {"message": "更新成功"}


@router.delete("/{car_no}")
def delete_car(car_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute("DELETE FROM TBL_CAR WHERE CAR_NO=%(id)s", {"id": car_no})
        if cur.rowcount == 0:
            raise HTTPException(404, "車輛不存在")
        return {"message": "刪除成功"}


@router.put("/{car_no}/renumber")
def renumber_car(car_no: str, data: RenumberRequest):
    """比照 Delphi6ERP Form_Car.pas 的 Modify_NO：新編號複製一筆主檔，
    串連更新 TBL_SHIP 的 CAR_NO，再刪除舊編號。"""
    new_no = data.new_no.strip()
    if not new_no:
        raise HTTPException(400, "新編號不可為空白")
    with get_conn() as conn:
        cur = conn.cursor()
        try:
            cur.execute(
                """INSERT INTO TBL_CAR
                       (CAR_NO,CAR_BRAND,CAR_LICENSE_NO,CAR_DATE1,CAR_DESC,CAR_CREATOR)
                   SELECT %(new_no)s,CAR_BRAND,CAR_LICENSE_NO,CAR_DATE1,CAR_DESC,CAR_CREATOR
                     FROM TBL_CAR WHERE CAR_NO=%(old_no)s""",
                {"new_no": new_no, "old_no": car_no},
            )
        except UniqueViolation:
            raise HTTPException(409, "新編號已存在")
        if cur.rowcount == 0:
            raise HTTPException(404, "車輛不存在")

        cur.execute("UPDATE TBL_SHIP SET CAR_NO=%(new_no)s WHERE CAR_NO=%(old_no)s",
                    {"new_no": new_no, "old_no": car_no})
        cur.execute("DELETE FROM TBL_CAR WHERE CAR_NO=%(old_no)s", {"old_no": car_no})
        return {"message": "編號變更成功", "new_no": new_no}

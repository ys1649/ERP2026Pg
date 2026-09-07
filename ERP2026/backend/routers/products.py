from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel
from typing import Optional
from psycopg.errors import UniqueViolation
from database import get_conn

router = APIRouter()


class ProductCreate(BaseModel):
    prd_no: str
    prd_name: str
    prd_unit: Optional[str] = None
    prd_sale_price: float = 0
    prd_safe_qty: float = 0
    prd_desc: Optional[str] = None
    prd_is_dummy: bool = False
    prd_dum_cost_rate: float = 0
    prd_ext_cost_ratio: float = 0.1


class RenumberRequest(BaseModel):
    new_no: str


class ProductUpdate(BaseModel):
    prd_name: str
    prd_unit: Optional[str] = None
    prd_sale_price: float = 0
    prd_safe_qty: float = 0
    prd_desc: Optional[str] = None
    prd_is_dummy: bool = False
    prd_dum_cost_rate: float = 0
    prd_ext_cost_ratio: float = 0.1


def row_to_dict(cur, row):
    return dict(zip([d[0].lower() for d in cur.description], row))


@router.get("")
def list_products(
    q: Optional[str] = Query(None, description="搜尋產品編號/名稱"),
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=10000),
):
    with get_conn() as conn:
        cur = conn.cursor()
        where = ""
        params: dict = {}
        if q and q.strip():
            where = """WHERE UPPER(PRD_NO) LIKE UPPER(%(q1)s)
                          OR UPPER(PRD_NAME) LIKE UPPER(%(q2)s)"""
            pq = f"%{q.strip()}%"
            params = {"q1": pq, "q2": pq}

        cur.execute(f"SELECT COUNT(*) FROM TBL_PRODUCT {where}", params)
        total = cur.fetchone()[0]

        offset = (page - 1) * page_size
        cur.execute(
            f"""SELECT PRD_NO,PRD_NAME,PRD_UNIT,PRD_SALE_PRICE,PRD_SAFE_QTY,
                       PRD_ONHAND,PRD_CUR_COST,PRD_DESC,PRD_IS_DUMMY,
                       PRD_DUM_COST_RATE,PRD_EXT_COST_RATIO,PRD_CREATOR
                FROM TBL_PRODUCT {where}
               ORDER BY PRD_NO
               OFFSET %(offset)s ROWS FETCH NEXT %(lim)s ROWS ONLY""",
            {**params, "offset": offset, "lim": page_size},
        )
        rows = [row_to_dict(cur, r) for r in cur.fetchall()]
        return {"total": total, "page": page, "page_size": page_size, "data": rows}


@router.get("/{prd_no}")
def get_product(prd_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """SELECT PRD_NO,PRD_NAME,PRD_UNIT,PRD_SALE_PRICE,PRD_SAFE_QTY,
                      PRD_ONHAND,PRD_CUR_COST,PRD_DESC,PRD_IS_DUMMY,
                      PRD_DUM_COST_RATE,PRD_EXT_COST_RATIO,PRD_CREATOR
               FROM TBL_PRODUCT WHERE PRD_NO=%(id)s""",
            {"id": prd_no},
        )
        row = cur.fetchone()
        if not row:
            raise HTTPException(404, "產品不存在")
        return row_to_dict(cur, row)


@router.post("", status_code=201)
def create_product(data: ProductCreate):
    with get_conn() as conn:
        cur = conn.cursor()
        try:
            cur.execute(
                """INSERT INTO TBL_PRODUCT
                       (PRD_NO,PRD_NAME,PRD_UNIT,PRD_SALE_PRICE,PRD_SAFE_QTY,
                        PRD_ONHAND,PRD_CUR_COST,PRD_DESC,PRD_IS_DUMMY,
                        PRD_DUM_COST_RATE,PRD_EXT_COST_RATIO,PRD_CREATOR)
                   VALUES(%(prd_no)s,%(prd_name)s,%(prd_unit)s,%(prd_sale_price)s,%(prd_safe_qty)s,
                          0,0,%(prd_desc)s,%(prd_is_dummy)s,
                          %(prd_dum_cost_rate)s,%(prd_ext_cost_ratio)s,'WYS')""",
                data.model_dump(),
            )
        except UniqueViolation:
            raise HTTPException(409, "產品編號已存在")
        return {"message": "新增成功", "prd_no": data.prd_no}


@router.put("/{prd_no}")
def update_product(prd_no: str, data: ProductUpdate):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """UPDATE TBL_PRODUCT SET
                   PRD_NAME=%(prd_name)s,PRD_UNIT=%(prd_unit)s,
                   PRD_SALE_PRICE=%(prd_sale_price)s,PRD_SAFE_QTY=%(prd_safe_qty)s,
                   PRD_DESC=%(prd_desc)s,PRD_IS_DUMMY=%(prd_is_dummy)s,
                   PRD_DUM_COST_RATE=%(prd_dum_cost_rate)s,PRD_EXT_COST_RATIO=%(prd_ext_cost_ratio)s
               WHERE PRD_NO=%(prd_no)s""",
            {**data.model_dump(), "prd_no": prd_no},
        )
        if cur.rowcount == 0:
            raise HTTPException(404, "產品不存在")
        return {"message": "更新成功"}


@router.delete("/{prd_no}")
def delete_product(prd_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute("DELETE FROM TBL_PRODUCT WHERE PRD_NO=%(id)s", {"id": prd_no})
        if cur.rowcount == 0:
            raise HTTPException(404, "產品不存在")
        return {"message": "刪除成功"}


@router.put("/{prd_no}/renumber")
def renumber_product(prd_no: str, data: RenumberRequest):
    """比照 Delphi6ERP form_product.pas 的 Modify_NO：新編號複製一筆主檔，
    串連更新出貨/進貨/庫存調整/庫存/成本流水帳等 7 張明細表的 PRD_NO，再刪除舊編號。"""
    new_no = data.new_no.strip()
    if not new_no:
        raise HTTPException(400, "新編號不可為空白")
    with get_conn() as conn:
        cur = conn.cursor()
        try:
            cur.execute(
                """INSERT INTO TBL_PRODUCT
                       (PRD_NO,PRD_NAME,PRD_UNIT,PRD_SALE_PRICE,PRD_SAFE_QTY,
                        PRD_ONHAND,PRD_CUR_COST,PRD_DESC,PRD_IS_DUMMY,
                        PRD_DUM_COST_RATE,PRD_EXT_COST_RATIO,PRD_CREATOR)
                   SELECT %(new_no)s,PRD_NAME,PRD_UNIT,PRD_SALE_PRICE,PRD_SAFE_QTY,
                          PRD_ONHAND,PRD_CUR_COST,PRD_DESC,PRD_IS_DUMMY,
                          PRD_DUM_COST_RATE,PRD_EXT_COST_RATIO,PRD_CREATOR
                     FROM TBL_PRODUCT WHERE PRD_NO=%(old_no)s""",
                {"new_no": new_no, "old_no": prd_no},
            )
        except UniqueViolation:
            raise HTTPException(409, "新編號已存在")
        if cur.rowcount == 0:
            raise HTTPException(404, "產品不存在")

        for tbl in (
            "TBL_SHIP_DT", "TBL_HIS_SHIP_DT", "TBL_PO_RECV_DT", "TBL_HIS_PO_RECV_DT",
            "TBL_INV_ADJ_DT", "TBL_INV_ONHAND", "TBL_TRANSACTION",
        ):
            cur.execute(f"UPDATE {tbl} SET PRD_NO=%(new_no)s WHERE PRD_NO=%(old_no)s",
                        {"new_no": new_no, "old_no": prd_no})

        cur.execute("DELETE FROM TBL_PRODUCT WHERE PRD_NO=%(old_no)s", {"old_no": prd_no})
        return {"message": "編號變更成功", "new_no": new_no}

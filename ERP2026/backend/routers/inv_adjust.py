from datetime import date as date_type

from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel
from typing import Optional

from database import get_conn
from services.numbering import next_code
from services.inventory import insert_transaction, delete_transactions_and_recalc, TRN_ADJ, DEFAULT_INV
from services.sysparam import get_sys_param

router = APIRouter()

STATUS_UNBOOK = 0
STATUS_CONFIRM = 1

CREATOR = "WYS"  # 尚無登入系統，比照其他模組先固定值


class InvAdjLine(BaseModel):
    prd_no: str
    add_qty: float
    add_cost: float = 0


class InvAdjCreate(BaseModel):
    adj_date: str
    adj_desc: Optional[str] = None
    lines: list[InvAdjLine]


def row_to_dict(cur, row):
    return dict(zip([d[0].lower() for d in cur.description], row))


def _lock_inv_adj(cur, adj_no: str) -> dict:
    cur.execute("SELECT * FROM TBL_INV_ADJ WHERE ADJ_NO=%(no)s FOR UPDATE", {"no": adj_no})
    row = cur.fetchone()
    if not row:
        raise HTTPException(404, "庫存調整單不存在")
    return row_to_dict(cur, row)


def _get_lines(cur, adj_no: str) -> list:
    cur.execute(
        """SELECT D.ADJ_NO,D.ADD_SEQNO,D.PRD_NO,D.INV_NO,D.ADD_QTY,D.ADD_COST,
                  P.PRD_NAME,P.PRD_UNIT,P.PRD_ONHAND
           FROM TBL_INV_ADJ_DT D
           LEFT JOIN TBL_PRODUCT P ON P.PRD_NO=D.PRD_NO
           WHERE D.ADJ_NO=%(no)s ORDER BY D.ADD_SEQNO""",
        {"no": adj_no},
    )
    return [row_to_dict(cur, r) for r in cur.fetchall()]


def _check_period(sp: dict, adj_date):
    period_start = sp["spr_period_start"]
    if hasattr(adj_date, "date"):
        adj_date_d = adj_date.date()
    else:
        adj_date_d = adj_date
    if hasattr(period_start, "date"):
        period_start = period_start.date()
    if adj_date_d < period_start:
        raise HTTPException(400, f"異動日期不可早於結帳日 {period_start}")


SORTABLE_COLUMNS = {
    "adj_no": "M.ADJ_NO",
    "adj_date": "M.ADJ_DATE",
    "adj_status": "M.ADJ_STATUS",
}


def _parse_sort(sort: Optional[str]) -> str:
    if not sort:
        return "M.ADJ_DATE DESC, M.ADJ_NO DESC"
    parts = []
    for item in sort.split(","):
        field, _, direction = item.partition(":")
        col = SORTABLE_COLUMNS.get(field.strip())
        if not col:
            continue
        parts.append(f"{col} {'DESC' if direction.strip() == 'desc' else 'ASC'}")
    return ", ".join(parts) if parts else "M.ADJ_DATE DESC, M.ADJ_NO DESC"


@router.get("")
def list_inv_adjs(
    q: Optional[str] = Query(None),
    status: Optional[int] = Query(None),
    date_from: Optional[str] = Query(None),
    date_to: Optional[str] = Query(None),
    sort: Optional[str] = Query(None),
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=500),
):
    with get_conn() as conn:
        cur = conn.cursor()
        where = ["1=1"]
        params: dict = {}
        if q and q.strip():
            where.append("(UPPER(M.ADJ_NO) LIKE UPPER(%(q1)s) OR UPPER(M.ADJ_DESC) LIKE UPPER(%(q2)s))")
            pq = f"%{q.strip()}%"
            params.update({"q1": pq, "q2": pq})
        if status is not None:
            where.append("M.ADJ_STATUS=%(status)s")
            params["status"] = status
        if date_from:
            where.append("M.ADJ_DATE>=%(date_from)s")
            params["date_from"] = date_from
        if date_to:
            where.append("M.ADJ_DATE<%(date_to)s::date + 1")
            params["date_to"] = date_to
        where_sql = " AND ".join(where)
        order_sql = _parse_sort(sort)

        cur.execute(f"SELECT COUNT(*) FROM TBL_INV_ADJ M WHERE {where_sql}", params)
        total = cur.fetchone()[0]

        offset = (page - 1) * page_size
        cur.execute(
            f"""SELECT M.ADJ_NO,M.ADJ_DATE,M.ADJ_STATUS,M.ADJ_DESC,M.ADJ_CREATOR,
                       (SELECT COUNT(*) FROM TBL_INV_ADJ_DT D WHERE D.ADJ_NO=M.ADJ_NO) AS LINE_COUNT
                FROM TBL_INV_ADJ M
                WHERE {where_sql}
                ORDER BY {order_sql}
                OFFSET %(offset)s ROWS FETCH NEXT %(lim)s ROWS ONLY""",
            {**params, "offset": offset, "lim": page_size},
        )
        rows = [row_to_dict(cur, r) for r in cur.fetchall()]
        return {"total": total, "page": page, "page_size": page_size, "data": rows}


@router.get("/price")
def get_current_cost(prd_no: str):
    """比照 GetPrdCurrCost：新增明細列時預帶的預設成本 = 該產品目前的移動平均成本。"""
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute("SELECT PRD_CUR_COST FROM TBL_PRODUCT WHERE PRD_NO=%(p)s", {"p": prd_no})
        row = cur.fetchone()
        return {"price": float(row[0]) if row else 0}


@router.get("/{adj_no}")
def get_inv_adj(adj_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute("SELECT * FROM TBL_INV_ADJ WHERE ADJ_NO=%(no)s", {"no": adj_no})
        row = cur.fetchone()
        if not row:
            raise HTTPException(404, "庫存調整單不存在")
        header = row_to_dict(cur, row)
        header["lines"] = _get_lines(cur, adj_no)
        return header


def _chk_detail(lines: list[InvAdjLine]):
    if not lines:
        raise HTTPException(400, "至少需要一筆品項")
    for l in lines:
        if l.add_qty == 0:
            raise HTTPException(400, "此數量不可為0")


def _insert_lines(cur, adj_no: str, lines: list[InvAdjLine]):
    for i, line in enumerate(lines, start=1):
        cur.execute(
            """INSERT INTO TBL_INV_ADJ_DT (ADJ_NO,ADD_SEQNO,PRD_NO,INV_NO,ADD_QTY,ADD_COST)
               VALUES (%(no)s,%(seq)s,%(prd)s,%(inv)s,%(qty)s,%(cost)s)""",
            {"no": adj_no, "seq": i, "prd": line.prd_no, "inv": DEFAULT_INV, "qty": line.add_qty, "cost": line.add_cost},
        )


@router.post("", status_code=201)
def create_inv_adj(data: InvAdjCreate):
    _chk_detail(data.lines)
    with get_conn() as conn:
        cur = conn.cursor()
        sp = get_sys_param(cur)
        adj_date = data.adj_date
        _check_period(sp, date_type.fromisoformat(adj_date))

        adj_no = next_code(cur, "TBL_INV_ADJ", "ADJ_NO", date_type.fromisoformat(adj_date))
        cur.execute(
            """INSERT INTO TBL_INV_ADJ (ADJ_NO,ADJ_STATUS,ADJ_DATE,ADJ_DESC,ADJ_CREATOR)
               VALUES (%(no)s,%(status)s,%(date)s,%(desc)s,%(creator)s)""",
            {"no": adj_no, "status": STATUS_UNBOOK, "date": adj_date, "desc": data.adj_desc, "creator": CREATOR},
        )
        _insert_lines(cur, adj_no, data.lines)
        return {"message": "新增成功", "adj_no": adj_no}


@router.put("/{adj_no}")
def update_inv_adj(adj_no: str, data: InvAdjCreate):
    _chk_detail(data.lines)
    with get_conn() as conn:
        cur = conn.cursor()
        header = _lock_inv_adj(cur, adj_no)
        if header["adj_status"] != STATUS_UNBOOK:
            raise HTTPException(400, "只有未確認的調整單可以修改")
        sp = get_sys_param(cur)
        _check_period(sp, date_type.fromisoformat(data.adj_date))

        cur.execute(
            "UPDATE TBL_INV_ADJ SET ADJ_DATE=%(date)s,ADJ_DESC=%(desc)s,ADJ_CREATOR=%(creator)s WHERE ADJ_NO=%(no)s",
            {"date": data.adj_date, "desc": data.adj_desc, "creator": CREATOR, "no": adj_no},
        )
        cur.execute("DELETE FROM TBL_INV_ADJ_DT WHERE ADJ_NO=%(no)s", {"no": adj_no})
        _insert_lines(cur, adj_no, data.lines)
        return {"message": "更新成功"}


@router.delete("/{adj_no}")
def delete_inv_adj(adj_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        header = _lock_inv_adj(cur, adj_no)
        if header["adj_status"] != STATUS_UNBOOK:
            raise HTTPException(400, "只有未確認的調整單可以刪除")

        lines = _get_lines(cur, adj_no)
        affected = [(l["prd_no"], header["adj_date"]) for l in lines]
        delete_transactions_and_recalc(cur, TRN_ADJ, adj_no, affected)
        cur.execute("DELETE FROM TBL_INV_ADJ_DT WHERE ADJ_NO=%(no)s", {"no": adj_no})
        cur.execute("DELETE FROM TBL_INV_ADJ WHERE ADJ_NO=%(no)s", {"no": adj_no})
        return {"message": "刪除成功"}


@router.post("/{adj_no}/book")
def book_inv_adj(adj_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        header = _lock_inv_adj(cur, adj_no)
        if header["adj_status"] != STATUS_UNBOOK:
            raise HTTPException(400, "調整單狀態已變更，請重新整理")
        sp = get_sys_param(cur)

        cur.execute("UPDATE TBL_INV_ADJ SET ADJ_STATUS=%(s)s WHERE ADJ_NO=%(no)s",
                    {"s": STATUS_CONFIRM, "no": adj_no})

        lines = _get_lines(cur, adj_no)
        for line in lines:
            # 比照舊系統 InsertInv_Transaction：不檢查虛擬商品，所有品項一律記庫存交易
            insert_transaction(
                cur, line["prd_no"], DEFAULT_INV, TRN_ADJ, adj_no, line["add_seqno"],
                header["adj_date"], float(line["add_qty"]), float(line["add_cost"]),
                period_start=sp["spr_period_start"],
            )
        return {"message": "確認成功"}


@router.post("/{adj_no}/unbook")
def unbook_inv_adj(adj_no: str):
    with get_conn() as conn:
        cur = conn.cursor()
        header = _lock_inv_adj(cur, adj_no)
        if header["adj_status"] != STATUS_CONFIRM:
            raise HTTPException(400, "調整單狀態已變更，請重新整理")

        cur.execute("UPDATE TBL_INV_ADJ SET ADJ_STATUS=%(s)s WHERE ADJ_NO=%(no)s",
                    {"s": STATUS_UNBOOK, "no": adj_no})
        lines = _get_lines(cur, adj_no)
        affected = [(l["prd_no"], header["adj_date"]) for l in lines]
        delete_transactions_and_recalc(cur, TRN_ADJ, adj_no, affected)
        return {"message": "取消確認成功"}

import json
import logging
from datetime import datetime

from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel
from typing import Optional
from database import get_conn

router = APIRouter()
logger = logging.getLogger(__name__)

# 跟 Delphi6ERP 舊系統（Form_Query.pas / Form_SysRepFldDefEdit.pas）用同一套詞彙，
# 方便日後直接把 MSSQL 的 TBLSYSREPORT/TBLSYSREPORTFIELD 資料原樣複製過來、不用值轉換。
CONTROL_TYPES = {"Edit", "Date", "ListItem", "SQL"}
QUERY_TYPES = {"Single", "Range", "MultiSelect"}
DATA_TYPES = {"String", "Numberic", "Date"}


class SysReportCreate(BaseModel):
    srp_code: str
    srp_name: str
    srp_description: Optional[str] = None
    srp_select: str
    srp_where: Optional[str] = None
    srp_groupby: Optional[str] = None
    srp_orderby: Optional[str] = None


class SysReportUpdate(SysReportCreate):
    pass


class SysReportCopyRequest(BaseModel):
    srp_code: str
    srp_name: str


class ReportFileUpdate(BaseModel):
    srp_reportfile: str


class SysReportFieldCreate(BaseModel):
    srf_fieldname: str
    srf_tablealias: Optional[str] = None
    srf_dispname: str
    srf_disporder: int = 0
    srf_datatype: str = "String"
    srf_controltype: str = "Edit"
    srf_querytype: str = "Single"
    srf_ismustcriteria: bool = False
    srf_iswhere: bool = True
    srf_issort: bool = False
    srf_sortdec: bool = False
    srf_list_value: Optional[str] = None
    srf_list_sql: Optional[str] = None
    srf_list_returnfield: Optional[str] = None
    srf_list_fielddisp: Optional[str] = None


class SysReportFieldUpdate(SysReportFieldCreate):
    pass


def row_to_dict(cur, row):
    return dict(zip([d[0].lower() for d in cur.description], row))


def _qualified_col(f):
    alias = (f.get("srf_tablealias") or "").strip()
    return f"{alias}.{f['srf_fieldname']}" if alias else f["srf_fieldname"]


def _validate_select_sql(sql: str, label: str = "SRP_SELECT") -> str:
    s = (sql or "").strip().rstrip(";").strip()
    if not s:
        raise HTTPException(400, f"{label} 不可為空")
    if not s.lower().startswith("select"):
        raise HTTPException(400, f"{label} 僅允許 SELECT 查詢")
    if ";" in s:
        raise HTTPException(400, f"{label} 不可包含多重陳述式")
    return s


def _validate_field_vocab(data):
    if data.srf_controltype not in CONTROL_TYPES:
        raise HTTPException(400, f"SRF_CONTROLTYPE 必須是 {sorted(CONTROL_TYPES)} 其中之一")
    if data.srf_querytype not in QUERY_TYPES:
        raise HTTPException(400, f"SRF_QUERYTYPE 必須是 {sorted(QUERY_TYPES)} 其中之一")
    if data.srf_datatype not in DATA_TYPES:
        raise HTTPException(400, f"SRF_DATATYPE 必須是 {sorted(DATA_TYPES)} 其中之一")
    if data.srf_controltype == "ListItem" and not (data.srf_list_value or "").strip():
        raise HTTPException(400, "[選項列表] 控制項類別為 ListItem 時不可留空")
    if data.srf_controltype == "SQL":
        if not (data.srf_list_sql or "").strip():
            raise HTTPException(400, "[選項SQL] 控制項類別為 SQL 時不可留空")
        if not (data.srf_list_fielddisp or "").strip():
            raise HTTPException(400, "[選項顯示欄位] 控制項類別為 SQL 時不可留空")
        if not (data.srf_list_returnfield or "").strip():
            raise HTTPException(400, "[選項傳回欄位] 控制項類別為 SQL 時不可留空")
    if data.srf_querytype == "MultiSelect" and data.srf_controltype != "SQL":
        raise HTTPException(400, "MultiSelect 查詢型態只能搭配 SQL 控制項類別")


# ── 系統報表主檔 ──────────────────────────────────────────────


@router.get("")
def list_reports(q: Optional[str] = Query(None, description="搜尋報表編號/名稱")):
    """查詢主檔，不分頁，回傳全部符合的資料。"""
    with get_conn() as conn:
        cur = conn.cursor()
        where = ""
        params: dict = {}
        if q and q.strip():
            where = "WHERE UPPER(SRP_CODE) LIKE UPPER(%(q1)s) OR UPPER(SRP_NAME) LIKE UPPER(%(q2)s)"
            pq = f"%{q.strip()}%"
            params = {"q1": pq, "q2": pq}

        cur.execute(
            f"""SELECT SRP_ID,SRP_CODE,SRP_NAME,SRP_DESCRIPTION,SRP_SELECT,SRP_WHERE,SRP_GROUPBY,SRP_ORDERBY
                  FROM TBLSYSREPORT {where}
                 ORDER BY SRP_CODE""",
            params,
        )
        rows = [row_to_dict(cur, r) for r in cur.fetchall()]
        return {"total": len(rows), "data": rows}


@router.get("/{srp_id}")
def get_report(srp_id: int):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """SELECT SRP_ID,SRP_CODE,SRP_NAME,SRP_DESCRIPTION,SRP_SELECT,SRP_WHERE,SRP_GROUPBY,SRP_ORDERBY
                 FROM TBLSYSREPORT WHERE SRP_ID=%(id)s""",
            {"id": srp_id},
        )
        row = cur.fetchone()
        if not row:
            raise HTTPException(404, "系統報表不存在")
        return row_to_dict(cur, row)


@router.post("", status_code=201)
def create_report(data: SysReportCreate):
    _validate_select_sql(data.srp_select)
    with get_conn() as conn:
        cur = conn.cursor()
        # SRP_ID 跟舊系統一樣是應用程式自己配號的一般欄位（不是 DB identity/serial）
        cur.execute("SELECT COALESCE(MAX(SRP_ID), 0) + 1 FROM TBLSYSREPORT")
        next_id = cur.fetchone()[0]
        try:
            cur.execute(
                """INSERT INTO TBLSYSREPORT (SRP_ID,SRP_CODE,SRP_NAME,SRP_DESCRIPTION,SRP_SELECT,SRP_WHERE,SRP_GROUPBY,SRP_ORDERBY)
                   VALUES (%(srp_id)s,%(srp_code)s,%(srp_name)s,%(srp_description)s,%(srp_select)s,%(srp_where)s,%(srp_groupby)s,%(srp_orderby)s)""",
                {**data.model_dump(), "srp_id": next_id},
            )
        except Exception as e:
            if "ak_srp_code" in str(e).lower() or "srp_code" in str(e).lower():
                raise HTTPException(409, "報表編號已存在")
            raise
        return {"message": "新增成功", "srp_id": next_id}


@router.put("/{srp_id}")
def update_report(srp_id: int, data: SysReportUpdate):
    _validate_select_sql(data.srp_select)
    with get_conn() as conn:
        cur = conn.cursor()
        try:
            cur.execute(
                """UPDATE TBLSYSREPORT SET SRP_CODE=%(srp_code)s,SRP_NAME=%(srp_name)s,
                       SRP_DESCRIPTION=%(srp_description)s,SRP_SELECT=%(srp_select)s,
                       SRP_WHERE=%(srp_where)s,SRP_GROUPBY=%(srp_groupby)s,SRP_ORDERBY=%(srp_orderby)s
                   WHERE SRP_ID=%(srp_id)s""",
                {**data.model_dump(), "srp_id": srp_id},
            )
        except Exception as e:
            if "ak_srp_code" in str(e).lower() or "srp_code" in str(e).lower():
                raise HTTPException(409, "報表編號已存在")
            raise
        if cur.rowcount == 0:
            raise HTTPException(404, "系統報表不存在")
        return {"message": "更新成功"}


@router.delete("/{srp_id}")
def delete_report(srp_id: int):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute("DELETE FROM TBLSYSREPORTFIELD WHERE SRP_ID=%(id)s", {"id": srp_id})
        cur.execute("DELETE FROM TBLSYSREPORT WHERE SRP_ID=%(id)s", {"id": srp_id})
        if cur.rowcount == 0:
            raise HTTPException(404, "系統報表不存在")
        return {"message": "刪除成功"}


@router.post("/{srp_id}/copy", status_code=201)
def copy_report(srp_id: int, data: SysReportCopyRequest):
    """複製主檔（含 SRP_REPORTFILE 版面）與底下所有查詢欄位，SRP_CODE/SRP_NAME 另外指定。"""
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """SELECT SRP_DESCRIPTION,SRP_SELECT,SRP_WHERE,SRP_GROUPBY,SRP_ORDERBY,SRP_REPORTFILE
                 FROM TBLSYSREPORT WHERE SRP_ID=%(id)s""",
            {"id": srp_id},
        )
        row = cur.fetchone()
        if not row:
            raise HTTPException(404, "系統報表不存在")
        description, select_sql, where_sql, groupby_sql, orderby_sql, reportfile = row

        cur.execute("SELECT COALESCE(MAX(SRP_ID), 0) + 1 FROM TBLSYSREPORT")
        next_id = cur.fetchone()[0]
        try:
            cur.execute(
                """INSERT INTO TBLSYSREPORT
                       (SRP_ID,SRP_CODE,SRP_NAME,SRP_DESCRIPTION,SRP_SELECT,SRP_WHERE,SRP_GROUPBY,SRP_ORDERBY,SRP_REPORTFILE)
                   VALUES (%(srp_id)s,%(srp_code)s,%(srp_name)s,%(srp_description)s,%(srp_select)s,%(srp_where)s,%(srp_groupby)s,%(srp_orderby)s,%(srp_reportfile)s)""",
                {
                    "srp_id": next_id,
                    "srp_code": data.srp_code,
                    "srp_name": data.srp_name,
                    "srp_description": description,
                    "srp_select": select_sql,
                    "srp_where": where_sql,
                    "srp_groupby": groupby_sql,
                    "srp_orderby": orderby_sql,
                    "srp_reportfile": reportfile,
                },
            )
        except Exception as e:
            if "ak_srp_code" in str(e).lower() or "srp_code" in str(e).lower():
                raise HTTPException(409, "報表編號已存在")
            raise

        cur.execute(
            """INSERT INTO TBLSYSREPORTFIELD
                   (SRP_ID,SRF_SEQNO,SRF_FIELDNAME,SRF_TABLEALIAS,SRF_DISPNAME,SRF_DISPORDER,
                    SRF_DATATYPE,SRF_CONTROLTYPE,SRF_QUERYTYPE,SRF_ISMUSTCRITERIA,SRF_ISWHERE,
                    SRF_ISSORT,SRF_SORTDEC,SRF_LIST_VALUE,SRF_LIST_SQL,SRF_LIST_RETURNFIELD,SRF_LIST_FIELDDISP)
               SELECT %(new_id)s,SRF_SEQNO,SRF_FIELDNAME,SRF_TABLEALIAS,SRF_DISPNAME,SRF_DISPORDER,
                      SRF_DATATYPE,SRF_CONTROLTYPE,SRF_QUERYTYPE,SRF_ISMUSTCRITERIA,SRF_ISWHERE,
                      SRF_ISSORT,SRF_SORTDEC,SRF_LIST_VALUE,SRF_LIST_SQL,SRF_LIST_RETURNFIELD,SRF_LIST_FIELDDISP
                 FROM TBLSYSREPORTFIELD WHERE SRP_ID=%(old_id)s""",
            {"new_id": next_id, "old_id": srp_id},
        )
        return {"message": "複製成功", "srp_id": next_id}


# ── 報表 Layout（Stimulsoft Designer）─────────────────────────


@router.get("/{srp_id}/reportfile")
def get_report_file(srp_id: int):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute("SELECT SRP_REPORTFILE FROM TBLSYSREPORT WHERE SRP_ID=%(id)s", {"id": srp_id})
        row = cur.fetchone()
        if not row:
            raise HTTPException(404, "系統報表不存在")
        return {"srp_reportfile": row[0]}


@router.put("/{srp_id}/reportfile")
def save_report_file(srp_id: int, data: ReportFileUpdate):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            "UPDATE TBLSYSREPORT SET SRP_REPORTFILE=%(v)s WHERE SRP_ID=%(id)s",
            {"v": data.srp_reportfile, "id": srp_id},
        )
        if cur.rowcount == 0:
            raise HTTPException(404, "系統報表不存在")
        return {"message": "版面已儲存"}


# ── 從 SRP_SELECT 挑欄位（給新增查詢欄位時的「選欄位」按鈕用）───


def _pg_type_to_datatype(type_code: int) -> str:
    if type_code in (1082, 1083, 1114, 1184):  # date, time, timestamp, timestamptz
        return "Date"
    if type_code in (16, 20, 21, 23, 700, 701, 790, 1700):  # bool/int2/int4/int8/float4/float8/money/numeric
        return "Numberic"
    return "String"


@router.get("/{srp_id}/select-columns")
def get_select_columns(srp_id: int):
    """執行 SRP_SELECT + WHERE(強制 1=2) + GROUPBY + ORDERBY，列出真正可選的欄位，供新增查詢欄位時挑選。"""
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            "SELECT SRP_SELECT,SRP_WHERE,SRP_GROUPBY,SRP_ORDERBY FROM TBLSYSREPORT WHERE SRP_ID=%(id)s",
            {"id": srp_id},
        )
        row = cur.fetchone()
        if not row:
            raise HTTPException(404, "系統報表不存在")
        select_sql, where_sql, groupby_sql, orderby_sql = row
        select_sql = _validate_select_sql(select_sql)

        # SRP_WHERE 跟 run_query 的 _join_where 一樣，存的就是完整的 WHERE 子句
        # （目前資料庫裡有值的都是「WHERE ...」開頭），這裡只是把它硬包 1=2 讓查詢
        # 不撈資料、只拿欄位結構，所以要先把開頭的 WHERE 拿掉才能重新包一層括號，
        # 不然會變成 "WHERE (WHERE ...)" 直接語法錯誤。
        where_cond = (where_sql or "").strip()
        if where_cond[:5].upper() == "WHERE":
            where_cond = where_cond[5:].strip()
        forced_where = f"WHERE ({where_cond}) AND 1=2" if where_cond else "WHERE 1=2"
        sql = f"{select_sql} {forced_where} {groupby_sql or ''} {orderby_sql or ''}"
        try:
            cur.execute(sql)
        except Exception as e:
            raise HTTPException(400, f"SRP_SELECT 執行失敗: {e}")
        return [
            {"field_name": d[0], "datatype": _pg_type_to_datatype(d.type_code)}
            for d in cur.description
        ]


# ── 系統報表查詢欄位 ────────────────────────────────────────


@router.get("/{srp_id}/fields")
def list_fields(srp_id: int):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """SELECT SRP_ID,SRF_SEQNO,SRF_FIELDNAME,SRF_TABLEALIAS,SRF_DISPNAME,SRF_DISPORDER,
                      SRF_DATATYPE,SRF_CONTROLTYPE,SRF_QUERYTYPE,SRF_ISMUSTCRITERIA,SRF_ISWHERE,
                      SRF_ISSORT,SRF_SORTDEC,SRF_LIST_VALUE,SRF_LIST_SQL,SRF_LIST_RETURNFIELD,SRF_LIST_FIELDDISP
                 FROM TBLSYSREPORTFIELD WHERE SRP_ID=%(id)s ORDER BY SRF_DISPORDER,SRF_SEQNO""",
            {"id": srp_id},
        )
        return [row_to_dict(cur, r) for r in cur.fetchall()]


@router.post("/{srp_id}/fields", status_code=201)
def create_field(srp_id: int, data: SysReportFieldCreate):
    _validate_field_vocab(data)
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute("SELECT 1 FROM TBLSYSREPORT WHERE SRP_ID=%(id)s", {"id": srp_id})
        if not cur.fetchone():
            raise HTTPException(404, "系統報表不存在")
        cur.execute(
            "SELECT COALESCE(MAX(SRF_SEQNO), 0) + 1 FROM TBLSYSREPORTFIELD WHERE SRP_ID=%(id)s",
            {"id": srp_id},
        )
        next_seqno = cur.fetchone()[0]
        cur.execute(
            """INSERT INTO TBLSYSREPORTFIELD
                   (SRP_ID,SRF_SEQNO,SRF_FIELDNAME,SRF_TABLEALIAS,SRF_DISPNAME,SRF_DISPORDER,
                    SRF_DATATYPE,SRF_CONTROLTYPE,SRF_QUERYTYPE,SRF_ISMUSTCRITERIA,SRF_ISWHERE,
                    SRF_ISSORT,SRF_SORTDEC,SRF_LIST_VALUE,SRF_LIST_SQL,SRF_LIST_RETURNFIELD,SRF_LIST_FIELDDISP)
               VALUES (%(srp_id)s,%(srf_seqno)s,%(srf_fieldname)s,%(srf_tablealias)s,%(srf_dispname)s,%(srf_disporder)s,
                       %(srf_datatype)s,%(srf_controltype)s,%(srf_querytype)s,%(srf_ismustcriteria)s,%(srf_iswhere)s,
                       %(srf_issort)s,%(srf_sortdec)s,%(srf_list_value)s,%(srf_list_sql)s,%(srf_list_returnfield)s,%(srf_list_fielddisp)s)""",
            {**data.model_dump(), "srp_id": srp_id, "srf_seqno": next_seqno},
        )
        return {"message": "新增成功", "srf_seqno": next_seqno}


@router.put("/{srp_id}/fields/{srf_seqno}")
def update_field(srp_id: int, srf_seqno: int, data: SysReportFieldUpdate):
    _validate_field_vocab(data)
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """UPDATE TBLSYSREPORTFIELD SET
                   SRF_FIELDNAME=%(srf_fieldname)s,SRF_TABLEALIAS=%(srf_tablealias)s,SRF_DISPNAME=%(srf_dispname)s,
                   SRF_DISPORDER=%(srf_disporder)s,SRF_DATATYPE=%(srf_datatype)s,SRF_CONTROLTYPE=%(srf_controltype)s,
                   SRF_QUERYTYPE=%(srf_querytype)s,SRF_ISMUSTCRITERIA=%(srf_ismustcriteria)s,SRF_ISWHERE=%(srf_iswhere)s,
                   SRF_ISSORT=%(srf_issort)s,SRF_SORTDEC=%(srf_sortdec)s,SRF_LIST_VALUE=%(srf_list_value)s,
                   SRF_LIST_SQL=%(srf_list_sql)s,SRF_LIST_RETURNFIELD=%(srf_list_returnfield)s,SRF_LIST_FIELDDISP=%(srf_list_fielddisp)s
               WHERE SRF_SEQNO=%(srf_seqno)s AND SRP_ID=%(srp_id)s""",
            {**data.model_dump(), "srf_seqno": srf_seqno, "srp_id": srp_id},
        )
        if cur.rowcount == 0:
            raise HTTPException(404, "查詢欄位不存在")
        return {"message": "更新成功"}


@router.delete("/{srp_id}/fields/{srf_seqno}")
def delete_field(srp_id: int, srf_seqno: int):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            "DELETE FROM TBLSYSREPORTFIELD WHERE SRF_SEQNO=%(srf_seqno)s AND SRP_ID=%(srp_id)s",
            {"srf_seqno": srf_seqno, "srp_id": srp_id},
        )
        if cur.rowcount == 0:
            raise HTTPException(404, "查詢欄位不存在")
        return {"message": "刪除成功"}


# ── SQL 型控制項的挑選資料（Single / MultiSelect 共用）─────────


@router.get("/{srp_id}/fields/{srf_seqno}/lookup-data")
def get_field_lookup_data(srp_id: int, srf_seqno: int, q: Optional[str] = Query(None)):
    """執行該查詢欄位的 SRF_LIST_SQL，回傳挑選用資料列 + 欄位標題（SRF_LIST_FIELDDISP 逗號分隔，跟 SQL 選出欄位依序對應）。"""
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """SELECT SRF_LIST_SQL, SRF_LIST_RETURNFIELD, SRF_LIST_FIELDDISP
                 FROM TBLSYSREPORTFIELD WHERE SRP_ID=%(srp_id)s AND SRF_SEQNO=%(srf_seqno)s""",
            {"srp_id": srp_id, "srf_seqno": srf_seqno},
        )
        row = cur.fetchone()
        if not row:
            raise HTTPException(404, "查詢欄位不存在")
        list_sql, return_field, list_fielddisp = row
        if not list_sql:
            raise HTTPException(400, "此查詢欄位未設定 SRF_LIST_SQL")
        list_sql = _validate_select_sql(list_sql, "SRF_LIST_SQL")

        where = ""
        params: dict = {}
        if q and q.strip():
            probe_cur = conn.cursor()
            try:
                probe_cur.execute(f"SELECT * FROM ({list_sql}) BASE_Q WHERE 1=0")
            except Exception as e:
                raise HTTPException(400, f"SRF_LIST_SQL 執行失敗: {e}")
            searchable = [d[0] for d in probe_cur.description]
            conds = " OR ".join(f"UPPER(CAST({c} AS TEXT)) LIKE UPPER(%(q)s)" for c in searchable)
            where = f"WHERE {conds}"
            params["q"] = f"%{q.strip()}%"

        try:
            cur.execute(f"SELECT * FROM ({list_sql}) BASE_Q {where}", params)
        except Exception as e:
            raise HTTPException(400, f"SRF_LIST_SQL 執行失敗: {e}")

        actual_cols = [d[0] for d in cur.description]
        captions = [c.strip() for c in (list_fielddisp or "").split(",") if c.strip()]
        columns = [
            {"key": col, "label": captions[i] if i < len(captions) else col}
            for i, col in enumerate(actual_cols)
        ]
        rows = [dict(zip(actual_cols, r)) for r in cur.fetchall()]

        # SRF_LIST_RETURNFIELD 是使用者手動打的欄位名稱，大小寫不一定跟 Postgres
        # 實際欄位（一律小寫）一致，這裡比照 data_dict.py 的做法用小寫比對找出真正的欄位。
        col_lookup = {c.lower(): c for c in actual_cols}
        resolved_return_field = col_lookup.get((return_field or "").lower())
        if not resolved_return_field:
            raise HTTPException(
                400, f"SRF_LIST_RETURNFIELD='{return_field}' 在 SRF_LIST_SQL 選出的欄位裡找不到"
            )
        return {"columns": columns, "return_field": resolved_return_field, "rows": rows}


# ── 系統報表查詢（動態組 SQL，比照舊系統做法）──────────────────


@router.get("/{srp_id}/query-meta")
def get_query_meta(srp_id: int):
    """提供【系統報表查詢】元件所需的定義：主檔資訊 + 查詢欄位 + 依 SRF_ISSORT 算出的預設排序清單。"""
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            """SELECT SRP_ID,SRP_CODE,SRP_NAME,SRP_DESCRIPTION
                 FROM TBLSYSREPORT WHERE SRP_ID=%(id)s""",
            {"id": srp_id},
        )
        row = cur.fetchone()
        if not row:
            raise HTTPException(404, "系統報表不存在")
        meta = row_to_dict(cur, row)

        cur.execute(
            """SELECT SRP_ID,SRF_SEQNO,SRF_FIELDNAME,SRF_TABLEALIAS,SRF_DISPNAME,SRF_DISPORDER,
                      SRF_DATATYPE,SRF_CONTROLTYPE,SRF_QUERYTYPE,SRF_ISMUSTCRITERIA,SRF_ISWHERE,
                      SRF_ISSORT,SRF_SORTDEC,SRF_LIST_VALUE,SRF_LIST_SQL,SRF_LIST_RETURNFIELD,SRF_LIST_FIELDDISP
                 FROM TBLSYSREPORTFIELD WHERE SRP_ID=%(id)s ORDER BY SRF_DISPORDER,SRF_SEQNO""",
            {"id": srp_id},
        )
        all_fields = [row_to_dict(cur, r) for r in cur.fetchall()]
        meta["fields"] = [f for f in all_fields if f["srf_iswhere"]]
        meta["orderby_default"] = [
            {"field": _qualified_col(f), "disp": f["srf_dispname"],
             "dir": "DESC" if f["srf_sortdec"] else "ASC"}
            for f in all_fields if f["srf_issort"]
        ]
        return meta


def _convert_value(v, datatype: str):
    if v is None or v == "":
        return None
    if datatype == "Date":
        try:
            return datetime.strptime(str(v)[:10], "%Y-%m-%d").date()
        except ValueError:
            return v
    if datatype == "Numberic":
        try:
            return float(v)
        except ValueError:
            return v
    return v


def _join_where(main_where: Optional[str], extra: str) -> str:
    main_where = (main_where or "").strip()
    extra = (extra or "").strip()
    if not main_where:
        return f"WHERE {extra}" if extra else ""
    return f"{main_where} AND {extra}" if extra else main_where


def _join_order(main_order: Optional[str], extra: str) -> str:
    main_order = (main_order or "").strip()
    extra = (extra or "").strip()
    if not main_order:
        return f"ORDER BY {extra}" if extra else ""
    return f"{main_order}, {extra}" if extra else main_order


@router.get("/{srp_id}/query")
def run_query(
    srp_id: int,
    criteria: Optional[str] = Query(None, description="JSON 陣列：[{srf_seqno,value|value_from,value_to|values}]"),
    orderby: Optional[str] = Query(None, description="JSON 陣列：[{field,dir}]"),
    limit: Optional[int] = Query(None, ge=1, le=1000, description="限制回傳筆數，供 Designer 抓欄位結構/預覽用"),
):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(
            "SELECT SRP_SELECT,SRP_WHERE,SRP_GROUPBY,SRP_ORDERBY FROM TBLSYSREPORT WHERE SRP_ID=%(id)s",
            {"id": srp_id},
        )
        row = cur.fetchone()
        if not row:
            raise HTTPException(404, "系統報表不存在")
        select_sql, base_where, groupby_sql, base_orderby = row
        select_sql = _validate_select_sql(select_sql)

        cur.execute(
            """SELECT SRF_SEQNO,SRF_FIELDNAME,SRF_TABLEALIAS,SRF_DISPNAME,SRF_DATATYPE,
                      SRF_QUERYTYPE,SRF_ISMUSTCRITERIA,SRF_ISWHERE
                 FROM TBLSYSREPORTFIELD WHERE SRP_ID=%(id)s AND SRF_ISWHERE=true""",
            {"id": srp_id},
        )
        fields = [row_to_dict(cur, r) for r in cur.fetchall()]

        try:
            criteria_list = json.loads(criteria) if criteria else []
        except json.JSONDecodeError:
            raise HTTPException(400, "criteria 格式錯誤")
        criteria_map = {int(c["srf_seqno"]): c for c in criteria_list}

        binds: dict = {}
        where_fragments: list = []
        for f in fields:
            c = criteria_map.get(f["srf_seqno"], {})
            col = _qualified_col(f)
            must = bool(f["srf_ismustcriteria"])
            pname = f"p{f['srf_seqno']}"

            if f["srf_querytype"] == "Range":
                v_from = _convert_value(c.get("value_from"), f["srf_datatype"])
                v_to = _convert_value(c.get("value_to"), f["srf_datatype"])
                if must and v_from is None and v_to is None:
                    raise HTTPException(400, f"{f['srf_dispname']} 為必要欄位")
                if v_from is not None and v_to is not None:
                    where_fragments.append(f"{col} BETWEEN %({pname}_f)s AND %({pname}_t)s")
                    binds[f"{pname}_f"] = v_from
                    binds[f"{pname}_t"] = v_to
                elif v_from is not None:
                    where_fragments.append(f"{col} >= %({pname}_f)s")
                    binds[f"{pname}_f"] = v_from
                elif v_to is not None:
                    where_fragments.append(f"{col} <= %({pname}_t)s")
                    binds[f"{pname}_t"] = v_to

            elif f["srf_querytype"] == "MultiSelect":
                values = c.get("values") or []
                if must and not values:
                    raise HTTPException(400, f"{f['srf_dispname']} 為必要欄位")
                if values:
                    keys = []
                    for i, v in enumerate(values):
                        k = f"{pname}_{i}"
                        binds[k] = _convert_value(v, f["srf_datatype"])
                        keys.append(f"%({k})s")
                    where_fragments.append(f"{col} IN ({', '.join(keys)})")

            else:  # Single
                v = _convert_value(c.get("value"), f["srf_datatype"])
                if must and v is None:
                    raise HTTPException(400, f"{f['srf_dispname']} 為必要欄位")
                if v is not None:
                    op = "LIKE" if f["srf_datatype"] == "String" else "="
                    where_fragments.append(f"{col} {op} %({pname})s")
                    binds[pname] = v

        main_where = _join_where(base_where, " AND ".join(where_fragments))

        try:
            orderby_list = json.loads(orderby) if orderby else []
        except json.JSONDecodeError:
            raise HTTPException(400, "orderby 格式錯誤")
        order_clause = ", ".join(
            f"{o['field']} {o.get('dir', 'ASC').upper() if o.get('dir', 'ASC').upper() in ('ASC', 'DESC') else 'ASC'}"
            for o in orderby_list
        )
        main_order = _join_order(base_orderby, order_clause)

        final_sql = f"{select_sql} {main_where} {groupby_sql or ''} {main_order}"
        if limit:
            final_sql += " LIMIT %(_limit)s"
            binds["_limit"] = limit
        logger.info("系統報表查詢 SRP_ID=%s 最終 SQL: %s", srp_id, final_sql)

        try:
            cur.execute(final_sql, binds)
        except Exception as e:
            logger.error("系統報表查詢 SRP_ID=%s SQL 執行失敗: %s\nSQL: %s", srp_id, e, final_sql)
            raise HTTPException(400, f"報表查詢執行失敗: {e}")
        cols = [d[0] for d in cur.description]
        return [dict(zip(cols, r)) for r in cur.fetchall()]

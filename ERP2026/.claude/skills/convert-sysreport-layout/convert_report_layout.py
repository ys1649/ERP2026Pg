"""
把 Delphi6ERP（MSSQL）TBLSYSREPORT.SRP_REPORTFILE 裡的 ReportBuilder 二進位版面，
轉成 ERP2026（Postgres）Stimulsoft JSON 版面草稿，寫回 tblsysreport.srp_reportfile。

不是逐像素照搬，是把「band 階層／欄位綁定／分組／小計」這些邏輯骨架轉過去，
給 Stimulsoft Designer 一個已經有欄位可以微調的草稿，取代從空白畫布開始設計。
細節（間距、粗體、多欄清單、內嵌圖表）轉不過去的地方會列在 warnings 裡，
需要人工在 Designer 補。完整背景、已知限制見 SKILL.md。

用法：
    python convert_report_layout.py                       # 轉全部「還沒有版面」的報表
    python convert_report_layout.py FM_CUM_001 MG_AR_002   # 只轉指定的 SRP_CODE
    python convert_report_layout.py --force FM_ACNT_001    # 連已經有版面（含人工設計過）的也覆蓋
    python convert_report_layout.py --force                # 全部重轉，含已有版面的（codes 留空 + --force）

PostgreSQL 連線資訊直接讀 backend/database.py，不寫死 dbname——後端指到哪個
資料庫（例如暫時測試用的 erp2），這支就跟著寫到哪個，不用手動同步，避免
「轉好了但後端看的是另一個庫」這種踩坑。
"""
import argparse
import json
import sys
from pathlib import Path

import psycopg
import pymssql

sys.path.insert(0, str(Path(__file__).resolve().parents[3] / "backend"))
import database as backend_database  # noqa: E402

from dfm_parser import parse_dfm, DFMParseError
from rb_to_stimulsoft import convert_report

MSSQL_CONNINFO = dict(
    server="tnvtrsap01", user="erp", password="erp", database="erp", timeout=10,
    charset="CP950",
)
PG_CONNINFO = dict(
    host=backend_database.HOST, port=backend_database.PORT, dbname=backend_database.DBNAME,
    user=backend_database.USER, password=backend_database.PASSWORD,
)


def normalize_where(where_sql):
    """SRP_WHERE 存的是完整子句（目前資料庫裡的值都是 'WHERE ...' 開頭），這裡要
    把開頭的 WHERE 拿掉才能重新包一層括號組成 'WHERE (...) AND 1=2' 探測用查詢，
    不然會變成 'WHERE (WHERE ...)' 直接語法錯誤——跟 sysreport.py 的
    get_select_columns 曾經踩過的是同一個坑。"""
    w = (where_sql or "").strip()
    if not w:
        return None
    if w[:5].upper() == "WHERE":
        w = w[5:].strip()
    return w


def probe_root_columns(pg_cur, select_sql, where_sql, groupby_sql, orderby_sql):
    """執行 SRP_SELECT + WHERE(強制 1=2) + GROUPBY + ORDERBY，只拿欄位名稱/型別，
    不撈實際資料列——跟 backend 的 get_select_columns 端點同一套做法。"""
    where_cond = normalize_where(where_sql)
    forced_where = f"WHERE ({where_cond}) AND 1=2" if where_cond else "WHERE 1=2"
    sql = f"{select_sql} {forced_where} {groupby_sql or ''} {orderby_sql or ''}"
    pg_cur.execute(sql)
    return [(d[0], d.type_code) for d in pg_cur.description]


def convert_one(ms_cur, pg_conn, srp_code):
    """回傳 (status, detail, n_warnings)。status 是下面幾種之一：
    OK / PARSE_FAILED / PARSE_INCOMPLETE / NO_PG_ROW / SELECT_FAILED / CONVERT_FAILED / SAVE_FAILED"""
    pg_cur = pg_conn.cursor()

    ms_cur.execute(
        "SELECT SRP_ID, SRP_NAME, SRP_REPORTFILE FROM TBLSYSREPORT WHERE SRP_CODE=%s",
        (srp_code,),
    )
    row = ms_cur.fetchone()
    if not row or row[2] is None:
        return "NO_PG_ROW", "MSSQL 找不到這份報表或沒有版面（SRP_REPORTFILE 是空的）", 0
    _srp_id, srp_name, data = row

    try:
        root, r = parse_dfm(data)
        leftover = len(data) - r.pos
        if leftover > 2:
            return "PARSE_INCOMPLETE", f"leftover={leftover} bytes，解析可能中途走偏", 0
    except DFMParseError as e:
        return "PARSE_FAILED", str(e), 0

    pg_cur.execute(
        "SELECT srp_id, srp_select, srp_where, srp_groupby, srp_orderby "
        "FROM tblsysreport WHERE srp_code=%s",
        (srp_code,),
    )
    pg_row = pg_cur.fetchone()
    if not pg_row:
        return "NO_PG_ROW", "Postgres 找不到對應 srp_code（先跑 import-sysreport skill）", 0
    pg_srp_id, select_sql, where_sql, groupby_sql, orderby_sql = pg_row

    try:
        root_columns = probe_root_columns(pg_cur, select_sql, where_sql, groupby_sql, orderby_sql)
    except Exception as e:
        pg_conn.rollback()
        return "SELECT_FAILED", str(e)[:300], 0

    try:
        report, warnings = convert_report(root, srp_code, srp_name, root_columns)
    except Exception as e:
        return "CONVERT_FAILED", str(e)[:300], 0

    out_json = json.dumps(report, ensure_ascii=False)
    try:
        pg_cur.execute(
            "UPDATE tblsysreport SET srp_reportfile=%s WHERE srp_id=%s", (out_json, pg_srp_id)
        )
        pg_conn.commit()
    except Exception as e:
        pg_conn.rollback()
        return "SAVE_FAILED", str(e)[:300], 0

    return "OK", f"{len(out_json)} bytes", len(warnings)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("codes", nargs="*", help="只轉這些 SRP_CODE；留空代表全部")
    ap.add_argument("--force", action="store_true",
                     help="已經有 srp_reportfile（含人工設計過）的也覆蓋，預設會跳過保護")
    args = ap.parse_args()

    print(f"目標 PostgreSQL 資料庫：{PG_CONNINFO['dbname']}（跟 backend/database.py 一致）")
    ms_conn = pymssql.connect(**MSSQL_CONNINFO)
    ms_cur = ms_conn.cursor()
    pg_conn = psycopg.connect(**PG_CONNINFO)
    pg_cur = pg_conn.cursor()

    if args.codes:
        target_codes = args.codes
    else:
        ms_cur.execute("SELECT SRP_CODE FROM TBLSYSREPORT WHERE SRP_REPORTFILE IS NOT NULL ORDER BY SRP_CODE")
        target_codes = [r[0] for r in ms_cur.fetchall()]

    if not args.force:
        pg_cur.execute("SELECT srp_code FROM tblsysreport WHERE srp_reportfile IS NOT NULL")
        already_designed = {r[0] for r in pg_cur.fetchall()}
    else:
        already_designed = set()

    results = []
    for code in target_codes:
        if code in already_designed:
            results.append((code, "SKIPPED", "已有版面，用 --force 才會覆蓋", 0))
            continue
        status, detail, nwarn = convert_one(ms_cur, pg_conn, code)
        results.append((code, status, detail, nwarn))

    by_status = {}
    for code, status, detail, nwarn in results:
        by_status.setdefault(status, []).append((code, detail, nwarn))

    order = ["OK", "SKIPPED", "PARSE_FAILED", "PARSE_INCOMPLETE", "SELECT_FAILED", "CONVERT_FAILED", "SAVE_FAILED", "NO_PG_ROW"]
    for status in order:
        items = by_status.get(status, [])
        if not items:
            continue
        print(f"\n--- {status} ({len(items)}) ---")
        for code, detail, nwarn in items:
            w = f" [{nwarn} warnings]" if nwarn else ""
            print(f"  {code:25s} {detail}{w}")

    ms_conn.close()
    pg_conn.close()

    if by_status.get("PARSE_FAILED") or by_status.get("CONVERT_FAILED"):
        sys.exit(1)


if __name__ == "__main__":
    main()

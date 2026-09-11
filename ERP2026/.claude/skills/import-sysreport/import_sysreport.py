"""
將 Delphi6ERP（MSSQL）的 TBLSYSREPORT / TBLSYSREPORTFIELD 報表定義資料，
原樣搬進 PostgreSQL（erp）對應的表。

兩邊表結構現在完全一致（動態組 SQL 的查詢引擎，見 backend/routers/sysreport.py），
所以是單純的全量複製，不需要欄位對照/轉換。

**不會複製 SRP_REPORTFILE（報表版面）**：MSSQL 存的是 ReportBuilder 二進位格式，
跟新系統的 Stimulsoft JSON 不相容，複製了也沒用，留空讓使用者在「系統報表管理」
用 Stimulsoft Designer 重新設計。

跟 backend/routers/mssql_migrate.py（「MSSQL 資料轉入 PostgreSQL」網頁功能）無關，
那個功能明確排除這兩張表，這支是專門補這兩張表的獨立工具。

PostgreSQL 連線資訊直接讀 backend/database.py，不寫死 dbname——後端指到哪個
資料庫（例如暫時測試用的 erp2），這支就跟著寫到哪個，不用手動同步。

用法：
    python import_sysreport.py
"""
import sys
from pathlib import Path

import psycopg
import pymssql

sys.path.insert(0, str(Path(__file__).resolve().parents[3] / "backend"))
import database as backend_database  # noqa: E402

MSSQL_CONNINFO = dict(
    server="tnvtrsap01", user="erp", password="erp", database="erp", timeout=10,
    charset="CP950",  # 中文欄位是 Big5 非 Unicode collation，預設編碼會讀成亂碼
)
PG_CONNINFO = dict(
    host=backend_database.HOST, port=backend_database.PORT, dbname=backend_database.DBNAME,
    user=backend_database.USER, password=backend_database.PASSWORD,
)

REPORT_COLS = ["SRP_ID", "SRP_CODE", "SRP_NAME", "SRP_DESCRIPTION", "SRP_SELECT", "SRP_WHERE", "SRP_GROUPBY", "SRP_ORDERBY"]

FIELD_COLS = [
    "SRP_ID", "SRF_SEQNO", "SRF_FIELDNAME", "SRF_TABLEALIAS", "SRF_DISPNAME", "SRF_DISPORDER",
    "SRF_DATATYPE", "SRF_CONTROLTYPE", "SRF_QUERYTYPE", "SRF_ISMUSTCRITERIA", "SRF_ISWHERE",
    "SRF_ISSORT", "SRF_SORTDEC", "SRF_LIST_VALUE", "SRF_LIST_SQL", "SRF_LIST_RETURNFIELD", "SRF_LIST_FIELDDISP",
]
FIELD_BIT_COLS = {"SRF_ISMUSTCRITERIA", "SRF_ISWHERE", "SRF_ISSORT", "SRF_SORTDEC"}


def main():
    print(f"目標 PostgreSQL 資料庫：{PG_CONNINFO['dbname']}（跟 backend/database.py 一致）")
    ms_conn = pymssql.connect(**MSSQL_CONNINFO)
    ms_cur = ms_conn.cursor()

    with psycopg.connect(**PG_CONNINFO) as pg_conn:
        pg_cur = pg_conn.cursor()
        pg_cur.execute("TRUNCATE TABLE tblsysreportfield, tblsysreport RESTART IDENTITY")

        ms_cur.execute(f"SELECT {', '.join(REPORT_COLS)} FROM TBLSYSREPORT")
        reports = ms_cur.fetchall()
        insert_cols = ", ".join(c.lower() for c in REPORT_COLS)
        placeholders = ", ".join(["%s"] * len(REPORT_COLS))
        if reports:
            pg_cur.executemany(
                f"INSERT INTO tblsysreport ({insert_cols}) VALUES ({placeholders})", reports
            )
        print(f"TBLSYSREPORT -> tblsysreport: {len(reports)} rows")

        ms_cur.execute(f"SELECT {', '.join(FIELD_COLS)} FROM TBLSYSREPORTFIELD")
        fields = ms_cur.fetchall()
        bit_idx = [i for i, c in enumerate(FIELD_COLS) if c in FIELD_BIT_COLS]
        converted = [
            tuple(bool(v) if i in bit_idx and v is not None else v for i, v in enumerate(row))
            for row in fields
        ]
        insert_cols = ", ".join(c.lower() for c in FIELD_COLS)
        placeholders = ", ".join(["%s"] * len(FIELD_COLS))
        if converted:
            pg_cur.executemany(
                f"INSERT INTO tblsysreportfield ({insert_cols}) VALUES ({placeholders})", converted
            )
        print(f"TBLSYSREPORTFIELD -> tblsysreportfield: {len(fields)} rows")

        pg_conn.commit()

    ms_cur.close()
    ms_conn.close()
    print("Done. SRP_REPORTFILE 沒有複製，每份報表要在「系統報表管理」重新設計版面。")


if __name__ == "__main__":
    main()

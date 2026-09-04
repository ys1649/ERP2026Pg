"""
將 Oracle (erp2026) 的資料 clone 到 PostgreSQL (erp)。
可重複執行：每次執行前會先 TRUNCATE 目標表，再從 Oracle 全量複製。

TBL_CUSTOMER/TBL_SUPPLIER/TBL_PRODUCT/TBL_EMPLOYE 已改用 migrate_mssql_to_pg.py
從 Delphi6ERP（MSSQL）搬入真實業務資料，Oracle 那邊只是當初的測試資料，已從這支
腳本移除。TBLSYSREPORT/TBLSYSREPORTFIELD 的 schema 後來也改成跟 Delphi6ERP 舊系統
一致（見 backend/routers/sysreport.py），Oracle 端已經是完全不同的舊欄位結構，
沒辦法再對應，改用 .claude/skills/import-sysreport/import_sysreport.py 從 MSSQL 匯入，
已從這支腳本移除。現在只處理 TBLDD/TBL_DDFIELD 這 2 張表（資料字典，還是 Oracle
測試資料）。

用法：
    python migrate_oracle_to_pg.py
"""
import oracledb
import psycopg

ORACLE_DSN = "JNVB2BWEB01.cminl.oa:1521/orcl.cminl.oa"
ORACLE_USER = "erp2026"
ORACLE_PASSWORD = "erp2026"

PG_CONNINFO = dict(host="localhost", dbname="erp", user="erpuser", password="erpuser")

oracledb.defaults.fetch_lobs = False  # CLOB 直接讀成 str，不用另外處理 LOB handle

# 依 FK 相依順序排列（父表在前）：(oracle_table, pg_table, [(col, transform), ...])
# transform: None=原樣複製, "bool"=Oracle 0/1 轉 Postgres boolean,
#            "lower"=轉小寫（DDD_FIELD 是拿來對應 Postgres 查詢結果的欄位名，
#            Postgres 對未加雙引號的識別字一律會轉小寫，所以定義也要用小寫才對得上）
TABLES = [
    ("TBLDD", "tbldd", [
        ("DDM_NO", None), ("DDM_NAME", None), ("DDM_SQL", None),
        ("IS_MULTI_SELECTED", None), ("RET_VAL_FIELD", "lower"),
    ]),
    ("TBL_DDFIELD", "tbl_ddfield", [
        ("DDD_ID", None), ("DDM_NO", None), ("DDD_FIELD", "lower"), ("DDD_FIELD_DISP", None),
    ]),
]

SERIAL_COLUMNS = {
    "tbl_ddfield": "ddd_id",
}


def convert(value, transform):
    if transform == "bool":
        return None if value is None else bool(value)
    if transform == "lower":
        return None if value is None else value.lower()
    return value


def main():
    ora_conn = oracledb.connect(user=ORACLE_USER, password=ORACLE_PASSWORD, dsn=ORACLE_DSN)
    pg_conn = psycopg.connect(**PG_CONNINFO)
    ora_cur = ora_conn.cursor()
    pg_cur = pg_conn.cursor()

    pg_table_names = ", ".join(pg for _, pg, _ in TABLES)
    pg_cur.execute(f"TRUNCATE TABLE {pg_table_names} RESTART IDENTITY")

    for oracle_table, pg_table, columns in TABLES:
        col_names = [c for c, _ in columns]
        ora_cur.execute(f"SELECT {', '.join(col_names)} FROM {oracle_table}")
        rows = ora_cur.fetchall()

        pg_cols = [c.lower() for c, _ in columns]
        placeholders = ["%s"] * len(columns)
        insert_sql = (
            f"INSERT INTO {pg_table} ({', '.join(pg_cols)}) "
            f"VALUES ({', '.join(placeholders)})"
        )

        converted_rows = [
            tuple(convert(v, t) for v, (_, t) in zip(row, columns))
            for row in rows
        ]
        if converted_rows:
            pg_cur.executemany(insert_sql, converted_rows)

        if pg_table in SERIAL_COLUMNS:
            col = SERIAL_COLUMNS[pg_table]
            pg_cur.execute(
                f"SELECT setval(pg_get_serial_sequence('{pg_table}', '{col}'), "
                f"COALESCE((SELECT MAX({col}) FROM {pg_table}), 1), "
                f"(SELECT MAX({col}) FROM {pg_table}) IS NOT NULL)"
            )

        print(f"{oracle_table} -> {pg_table}: {len(rows)} rows")

    pg_conn.commit()
    ora_cur.close()
    pg_cur.close()
    ora_conn.close()
    pg_conn.close()
    print("Done.")


if __name__ == "__main__":
    main()

"""
將 Delphi6ERP（MSSQL）的 29 張業務資料表結構 + 資料，全量搬到 PostgreSQL（erp）。

不會動的表（新系統的報表引擎，MSSQL 端沒有對應的相容結構，之後另外處理）：
    tbldd, tbl_ddfield, tblsysreport, tblsysreportfield

可重複執行：每次執行前會把目標的 29 張表 DROP 掉重建（含 PK/FK/COMMENT），
再從 MSSQL 全量複製資料。欄位/資料表註解取自 PowerDesigner PDM
（backend/scripts/pdm_comments.json，由 ERP.pdm 解析出的中文欄位名）。

用法：
    python migrate_mssql_to_pg.py
"""
import json
import re
from pathlib import Path

import pymssql
import psycopg

MSSQL_CONNINFO = dict(
    server="tnvtrsap01", user="erp", password="erp", database="erp", timeout=10,
    charset="CP950",  # 資料庫的中文欄位是 Big5 非 Unicode collation，預設編碼會讀成亂碼
)
PG_CONNINFO = dict(host="localhost", port=5432, dbname="erp", user="erpuser", password="erpuser")

EXCLUDED_TABLES = {"TBLSYSREPORT", "TBLSYSREPORTFIELD"}  # 新系統報表引擎自己的表，不動

COMMENTS = json.loads((Path(__file__).parent / "pdm_comments.json").read_text(encoding="utf-8"))


def pg_type(data_type, char_len, num_prec, num_scale, is_identity):
    if is_identity:
        return "serial"
    data_type = data_type.lower()
    if data_type == "varchar":
        return f"varchar({char_len})"
    if data_type == "money":
        return "numeric(18,4)"  # 不用 money，跟這次 ERP2026 遷移的既有慣例一致
    if data_type == "datetime":
        return "timestamp"
    if data_type == "bit":
        return "boolean"
    if data_type == "numeric":
        return f"numeric({num_prec},{num_scale})"
    if data_type == "int":
        return "integer"
    if data_type == "float":
        return "double precision"
    raise ValueError(f"未知型態: {data_type}")


def clean_default(raw, data_type):
    if raw is None:
        return None
    v = raw.strip()
    while v.startswith("(") and v.endswith(")"):
        v = v[1:-1].strip()
    if data_type.lower() == "bit":
        return "true" if v == "1" else "false"
    return v


def introspect(cur):
    cur.execute("""
        SELECT c.TABLE_NAME, c.COLUMN_NAME, c.ORDINAL_POSITION, c.DATA_TYPE,
               c.CHARACTER_MAXIMUM_LENGTH, c.NUMERIC_PRECISION, c.NUMERIC_SCALE,
               c.IS_NULLABLE, c.COLUMN_DEFAULT,
               COLUMNPROPERTY(object_id(c.TABLE_NAME), c.COLUMN_NAME, 'IsIdentity') as is_identity
        FROM INFORMATION_SCHEMA.COLUMNS c
        JOIN INFORMATION_SCHEMA.TABLES t ON t.TABLE_NAME = c.TABLE_NAME
        WHERE t.TABLE_TYPE = 'BASE TABLE'
        ORDER BY c.TABLE_NAME, c.ORDINAL_POSITION
    """)
    columns = {}
    for (table, col, pos, dtype, clen, nprec, nscale, nullable, default, is_identity) in cur.fetchall():
        if table in EXCLUDED_TABLES:
            continue
        columns.setdefault(table, []).append(dict(
            name=col, dtype=dtype, clen=clen, nprec=nprec, nscale=nscale,
            nullable=(nullable == "YES"), default=default, is_identity=bool(is_identity),
        ))

    cur.execute("""
        SELECT tc.TABLE_NAME, kcu.COLUMN_NAME
        FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
        JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
        WHERE tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
        ORDER BY tc.TABLE_NAME, kcu.ORDINAL_POSITION
    """)
    pks = {}
    for table, col in cur.fetchall():
        if table in EXCLUDED_TABLES:
            continue
        pks.setdefault(table, []).append(col)

    cur.execute("""
        SELECT tp.name AS parent_table, cp.name AS parent_column,
               tr.name AS ref_table, cr.name AS ref_column, fk.name AS fk_name
        FROM sys.foreign_keys fk
        JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
        JOIN sys.tables tp ON fkc.parent_object_id = tp.object_id
        JOIN sys.columns cp ON fkc.parent_object_id = cp.object_id AND fkc.parent_column_id = cp.column_id
        JOIN sys.tables tr ON fkc.referenced_object_id = tr.object_id
        JOIN sys.columns cr ON fkc.referenced_object_id = cr.object_id AND fkc.referenced_column_id = cr.column_id
        ORDER BY tp.name
    """)
    fks = []
    for parent_table, parent_col, ref_table, ref_col, fk_name in cur.fetchall():
        if parent_table in EXCLUDED_TABLES or ref_table in EXCLUDED_TABLES:
            continue
        fks.append(dict(table=parent_table, column=parent_col, ref_table=ref_table, ref_column=ref_col, name=fk_name))

    return columns, pks, fks


def topo_order(tables, fks):
    deps = {t: set() for t in tables}
    for fk in fks:
        if fk["table"] != fk["ref_table"]:
            deps[fk["table"]].add(fk["ref_table"])
    ordered = []
    seen = set()

    def visit(t):
        if t in seen:
            return
        seen.add(t)
        for dep in deps.get(t, ()):
            visit(dep)
        ordered.append(t)

    for t in tables:
        visit(t)
    return ordered


def build_ddl(columns, pks, fks, order):
    stmts = []
    stmts.append(f"DROP TABLE IF EXISTS {', '.join(t.lower() for t in order)} CASCADE;")

    for table in order:
        cols = columns[table]
        lines = []
        for c in cols:
            col_sql = f'    "{c["name"].lower()}" {pg_type(c["dtype"], c["clen"], c["nprec"], c["nscale"], c["is_identity"])}'
            if not c["nullable"] and not c["is_identity"]:
                col_sql += " NOT NULL"
            default = clean_default(c["default"], c["dtype"])
            if default is not None:
                col_sql += f" DEFAULT {default}"
            lines.append(col_sql)
        if table in pks:
            pk_cols = ", ".join(f'"{c.lower()}"' for c in pks[table])
            lines.append(f'    CONSTRAINT pk_{table.lower()} PRIMARY KEY ({pk_cols})')
        stmts.append(f'CREATE TABLE {table.lower()} (\n' + ",\n".join(lines) + "\n);")

        table_comment = COMMENTS.get(table, {}).get("name", "")
        if table_comment and table_comment != table:
            stmts.append(f"COMMENT ON TABLE {table.lower()} IS '{table_comment}';")
        col_comments = COMMENTS.get(table, {}).get("columns", {})
        for c in cols:
            label = col_comments.get(c["name"], "")
            if label and label != c["name"]:
                stmts.append(f'COMMENT ON COLUMN {table.lower()}."{c["name"].lower()}" IS \'{label}\';')

    for fk in fks:
        stmts.append(
            f'ALTER TABLE {fk["table"].lower()} ADD CONSTRAINT {fk["name"].lower()} '
            f'FOREIGN KEY ("{fk["column"].lower()}") REFERENCES {fk["ref_table"].lower()} ("{fk["ref_column"].lower()}");'
        )

    return "\n\n".join(stmts) + "\n"


def migrate_data(mssql_cur, pg_cur, columns, order):
    for table in order:
        cols = columns[table]
        col_names = [c["name"] for c in cols]
        mssql_cur.execute(f"SELECT {', '.join(col_names)} FROM {table}")
        rows = mssql_cur.fetchall()

        pg_cols = [f'"{c.lower()}"' for c in col_names]
        placeholders = ", ".join(["%s"] * len(col_names))
        insert_sql = f'INSERT INTO {table.lower()} ({", ".join(pg_cols)}) VALUES ({placeholders})'

        converted = [
            tuple(bool(v) if c["dtype"].lower() == "bit" and v is not None else v for v, c in zip(row, cols))
            for row in rows
        ]
        if converted:
            pg_cur.executemany(insert_sql, converted)

        identity_cols = [c["name"] for c in cols if c["is_identity"]]
        if identity_cols:
            col = identity_cols[0].lower()
            pg_cur.execute(
                f"SELECT setval(pg_get_serial_sequence('{table.lower()}', '{col}'), "
                f"COALESCE((SELECT MAX({col}) FROM {table.lower()}), 1), "
                f"(SELECT MAX({col}) FROM {table.lower()}) IS NOT NULL)"
            )
        print(f"{table} -> {table.lower()}: {len(rows)} rows")


def main():
    mssql_conn = pymssql.connect(**MSSQL_CONNINFO)
    mssql_cur = mssql_conn.cursor()
    columns, pks, fks = introspect(mssql_cur)

    order = topo_order(list(columns.keys()), fks)
    ddl = build_ddl(columns, pks, fks, order)

    ddl_path = Path(__file__).parent / "ddl_from_mssql.sql"
    ddl_path.write_text(ddl, encoding="utf-8")
    print(f"DDL written to {ddl_path} ({len(order)} tables)")

    pg_conn = psycopg.connect(**PG_CONNINFO)
    pg_cur = pg_conn.cursor()
    pg_cur.execute(ddl)
    pg_conn.commit()
    print("DDL applied to PostgreSQL.")

    migrate_data(mssql_cur, pg_cur, columns, order)
    pg_conn.commit()

    mssql_cur.close()
    mssql_conn.close()
    pg_cur.close()
    pg_conn.close()
    print("Done.")


if __name__ == "__main__":
    main()

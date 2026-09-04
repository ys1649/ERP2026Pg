from typing import Optional

import pymssql
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from database import get_conn

router = APIRouter()

# 新系統自己的報表引擎表，永遠不從舊 MSSQL 系統覆蓋
EXCLUDED_TABLES = {"tbldd", "tbl_ddfield", "tblsysreport", "tblsysreportfield"}


class MssqlConnRequest(BaseModel):
    server: str
    port: Optional[int] = 1433
    database: str
    user: str
    password: str


def _mssql_connect(req: MssqlConnRequest):
    server = req.server if not req.port else f"{req.server}:{req.port}"
    try:
        return pymssql.connect(
            server=server, user=req.user, password=req.password, database=req.database,
            charset="CP950", timeout=15, login_timeout=10,
        )
    except Exception as e:
        raise HTTPException(400, f"MSSQL 連線失敗: {e}")


def _matched_tables(ms_tables: set[str]) -> list[str]:
    with get_conn() as pg_conn:
        cur = pg_conn.cursor()
        cur.execute("SELECT table_name FROM information_schema.tables WHERE table_schema='public'")
        pg_tables = {r[0] for r in cur.fetchall()}
    return sorted(t for t in ms_tables if t.lower() in pg_tables and t.lower() not in EXCLUDED_TABLES)


@router.post("/test")
def test_connection(req: MssqlConnRequest):
    """驗證 MSSQL 連線資訊，回傳可以搬移的資料表清單（跟目前 PostgreSQL 同名的表）。"""
    conn = _mssql_connect(req)
    cur = conn.cursor()
    cur.execute("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'")
    ms_tables = {r[0] for r in cur.fetchall()}
    conn.close()

    matched = _matched_tables(ms_tables)
    return {
        "message": "連線成功",
        "mssql_table_count": len(ms_tables),
        "matched_tables": matched,
    }


@router.post("/run")
def run_migration(req: MssqlConnRequest):
    """
    把 MSSQL 裡跟 PostgreSQL 同名的資料表資料全量搬過來（TRUNCATE 目標表後匯入）。
    不動 DDL——目標表結構要先用 PowerDesigner 之類的工具建好。
    tbldd/tbl_ddfield/tblsysreport/tblsysreportfield（新系統的報表引擎表）永遠不搬。
    """
    ms_conn = _mssql_connect(req)
    ms_cur = ms_conn.cursor()

    ms_cur.execute("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'")
    ms_tables = {r[0] for r in ms_cur.fetchall()}

    ms_cur.execute("""
        SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, ORDINAL_POSITION
        FROM INFORMATION_SCHEMA.COLUMNS
        ORDER BY TABLE_NAME, ORDINAL_POSITION
    """)
    ms_columns: dict[str, list[str]] = {}
    ms_bit_cols: dict[str, set[str]] = {}
    for table, col, dtype, _pos in ms_cur.fetchall():
        ms_columns.setdefault(table, []).append(col)
        if dtype.lower() == "bit":
            ms_bit_cols.setdefault(table, set()).add(col)

    with get_conn() as pg_conn:
        pg_cur = pg_conn.cursor()

        pg_cur.execute("SELECT table_name FROM information_schema.tables WHERE table_schema='public'")
        pg_table_set = {r[0] for r in pg_cur.fetchall()}

        target_tables = [t for t in ms_tables if t.lower() in pg_table_set and t.lower() not in EXCLUDED_TABLES]
        if not target_tables:
            raise HTTPException(400, "MSSQL 與 PostgreSQL 之間沒有找到任何同名的資料表可以搬移")
        ms_to_pg = {t: t.lower() for t in target_tables}
        target_lower = sorted(ms_to_pg.values())

        pg_cur.execute("""
            SELECT table_name, column_name FROM information_schema.columns
            WHERE table_schema='public' ORDER BY table_name, ordinal_position
        """)
        pg_columns: dict[str, list[str]] = {}
        for table, col in pg_cur.fetchall():
            pg_columns.setdefault(table, []).append(col)

        # 依 PostgreSQL 自己的 FK 關聯排出父表在前的順序（目標端 schema 才是準的）
        pg_cur.execute("""
            SELECT tc.table_name, ccu.table_name
            FROM information_schema.table_constraints tc
            JOIN information_schema.constraint_column_usage ccu ON tc.constraint_name = ccu.constraint_name
            WHERE tc.constraint_type='FOREIGN KEY' AND tc.table_schema='public'
        """)
        deps: dict[str, set[str]] = {t: set() for t in target_lower}
        for child, parent in pg_cur.fetchall():
            if child in deps and parent in deps and child != parent:
                deps[child].add(parent)

        order: list[str] = []
        seen: set[str] = set()

        def visit(t: str):
            if t in seen:
                return
            seen.add(t)
            for dep in deps.get(t, ()):
                visit(dep)
            order.append(t)

        for t in target_lower:
            visit(t)

        pg_cur.execute(f"TRUNCATE TABLE {', '.join(order)} RESTART IDENTITY")

        pg_to_ms = {v: k for k, v in ms_to_pg.items()}
        results = []
        for pg_table in order:
            ms_table = pg_to_ms[pg_table]
            ms_cols = ms_columns.get(ms_table, [])
            pg_cols = {c.lower() for c in pg_columns.get(pg_table, [])}
            common_cols = [c for c in ms_cols if c.lower() in pg_cols]
            skipped_cols = [c for c in ms_cols if c.lower() not in pg_cols]

            if not common_cols:
                results.append({"table": pg_table, "rows": 0, "note": "沒有相符欄位，已跳過"})
                continue

            bit_cols = ms_bit_cols.get(ms_table, set())
            ms_cur.execute(f"SELECT {', '.join(common_cols)} FROM {ms_table}")
            rows = ms_cur.fetchall()

            insert_cols = ", ".join(f'"{c.lower()}"' for c in common_cols)
            placeholders = ", ".join(["%s"] * len(common_cols))
            insert_sql = f'INSERT INTO {pg_table} ({insert_cols}) VALUES ({placeholders})'

            converted = [
                tuple(bool(v) if c in bit_cols and v is not None else v for v, c in zip(row, common_cols))
                for row in rows
            ]
            if converted:
                pg_cur.executemany(insert_sql, converted)

            for c in common_cols:
                col_lower = c.lower()
                pg_cur.execute("SELECT pg_get_serial_sequence(%s, %s)", (pg_table, col_lower))
                seq = pg_cur.fetchone()[0]
                if seq:
                    pg_cur.execute(
                        f'SELECT setval(%s, COALESCE((SELECT MAX("{col_lower}") FROM {pg_table}), 1), '
                        f'(SELECT MAX("{col_lower}") FROM {pg_table}) IS NOT NULL)',
                        (seq,),
                    )

            entry = {"table": pg_table, "rows": len(rows)}
            if skipped_cols:
                entry["note"] = f"欄位未對應已跳過: {', '.join(skipped_cols)}"
            results.append(entry)

    ms_conn.close()
    return {"message": "搬移完成", "tables": results}

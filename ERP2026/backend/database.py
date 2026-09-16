from contextlib import contextmanager

import psycopg

HOST = "localhost"
PORT = 5432
DBNAME = "erp"
USER = "erpuser"
PASSWORD = "erpuser"


@contextmanager
def get_conn():
    conn = psycopg.connect(host=HOST, port=PORT, dbname=DBNAME, user=USER, password=PASSWORD)
    try:
        yield conn
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()

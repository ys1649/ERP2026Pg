"""讀取 TBL_SYS_PARAM，比照 Delphi6ERP erp_public.pas 的 ReadSysParam。"""


def get_sys_param(cur) -> dict:
    cur.execute("SELECT * FROM TBL_SYS_PARAM")
    row = cur.fetchone()
    cols = [d[0].lower() for d in cur.description]
    return dict(zip(cols, row))

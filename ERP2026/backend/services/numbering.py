def next_code(cur, table: str, column: str, date, serial_len: int = 4, lead_str: str = "") -> str:
    """比照 Delphi6ERP DBUty.pas 的 GetNumbericCode：LeadStr + yyyymmdd + 補零序號，
    序號在同一天內連續遞增（取當天最大值 +1）。"""
    date_str = date.strftime("%Y%m%d")
    prefix = lead_str + date_str
    prefix_len = len(prefix)
    cur.execute(
        f"SELECT MAX({column}) FROM {table} WHERE LEFT({column}, %(len)s) = %(prefix)s",
        {"len": prefix_len, "prefix": prefix},
    )
    row = cur.fetchone()
    max_code = row[0] if row else None
    if not max_code:
        serial = 1
    else:
        serial = int(max_code[prefix_len:]) + 1
    return f"{prefix}{serial:0{serial_len}d}"

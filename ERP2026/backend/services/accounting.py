"""總帳過帳輔助函式，比照 Delphi6ERP erp_public.pas 的 InsertAccount/ArRecvToAccount/ChkDCBalance。"""


def insert_journal(cur, jnl_no: str, jnl_date, desc: str, bill_type: int, creator: str) -> None:
    cur.execute(
        """INSERT INTO TBL_ACNT_JOURNAL (JNL_NO,JNL_DATE,JNL_DESC,JNL_BILL_TYPE,JNL_CREATOR)
           VALUES (%(no)s,%(date)s,%(desc)s,%(bt)s,%(creator)s)""",
        {"no": jnl_no, "date": jnl_date, "desc": desc, "bt": bill_type, "creator": creator},
    )


def insert_journal_line(cur, jnl_no: str, seqno: int, act_no: str, amount, desc: str) -> None:
    cur.execute(
        """INSERT INTO TBL_ACNT_JOURNAL_DT (JNL_NO,JND_SEQNO,ACT_NO,JND_AMOUNT,JND_DESC)
           VALUES (%(no)s,%(seq)s,%(act)s,%(amt)s,%(desc)s)""",
        {"no": jnl_no, "seq": seqno, "act": act_no, "amt": amount, "desc": desc},
    )


def chk_dc_balance(cur, jnl_no: str) -> None:
    cur.execute("SELECT COALESCE(SUM(JND_AMOUNT),0) FROM TBL_ACNT_JOURNAL_DT WHERE JNL_NO=%(no)s", {"no": jnl_no})
    total = cur.fetchone()[0]
    if total != 0:
        raise ValueError(f"傳票借貸不平衡，傳票編號={jnl_no}，差額={total}")


def delete_journal(cur, jnl_no: str) -> None:
    if not jnl_no:
        return
    cur.execute("DELETE FROM TBL_ACNT_JOURNAL_DT WHERE JNL_NO=%(no)s", {"no": jnl_no})
    cur.execute("DELETE FROM TBL_ACNT_JOURNAL WHERE JNL_NO=%(no)s", {"no": jnl_no})

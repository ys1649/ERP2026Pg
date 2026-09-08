"""移動平均成本引擎，比照 Delphi6ERP erp_public.pas 的 InsertTransaction/UpdateTransaction。"""

TRN_INIT = 0
TRN_RCV = 1   # 進貨
TRN_SHP = 2   # 出貨（含銷退，數量可為負）
TRN_ADJ = 3   # 庫存調整

DEFAULT_INV = "DEFAULT"


def update_transaction(cur, prd_no: str, trn_datetime) -> None:
    """從 trn_datetime 這個時間點開始，重新計算該產品往後所有交易的結存量/移動平均成本，
    並回寫 TBL_PRODUCT 的現有庫存量/現行成本。"""
    cur.execute(
        """SELECT MAX(TRN_DATETIME) FROM TBL_TRANSACTION
           WHERE PRD_NO=%(prd_no)s AND TRN_DATETIME<%(dt)s""",
        {"prd_no": prd_no, "dt": trn_datetime},
    )
    prev_dt = cur.fetchone()[0]
    if prev_dt is None:
        pre_qty, pre_cost = 0, 0
    else:
        cur.execute(
            """SELECT TRN_ONHAND, TRN_AVG_COST FROM TBL_TRANSACTION
               WHERE PRD_NO=%(prd_no)s AND TRN_DATETIME=%(dt)s
               ORDER BY TRN_ID DESC LIMIT 1""",
            {"prd_no": prd_no, "dt": prev_dt},
        )
        pre_qty, pre_cost = cur.fetchone()

    onhand, avg_cost = pre_qty, pre_cost

    cur.execute(
        """SELECT TRN_ID, TRN_QTY, TRN_TYPE, TRN_COST, TRN_SRC_NO, TRN_SRC_SEQNO
           FROM TBL_TRANSACTION
           WHERE PRD_NO=%(prd_no)s AND TRN_DATETIME>=%(dt)s
           ORDER BY TRN_DATETIME, TRN_TYPE, TRN_ID""",
        {"prd_no": prd_no, "dt": trn_datetime},
    )
    rows = cur.fetchall()
    for trn_id, trn_qty, trn_type, trn_cost, trn_src_no, trn_src_seqno in rows:
        if (trn_type in (TRN_ADJ, TRN_RCV)) and trn_qty > 0:
            # 進貨或正向調整：用進貨成本併入平均成本
            onhand = pre_qty + trn_qty
            new_cost = trn_cost
            avg_cost = 0 if onhand == 0 else ((pre_qty * pre_cost) + (trn_qty * new_cost)) / onhand
            cur.execute(
                "UPDATE TBL_TRANSACTION SET TRN_ONHAND=%(oh)s, TRN_AVG_COST=%(ac)s WHERE TRN_ID=%(id)s",
                {"oh": onhand, "ac": avg_cost, "id": trn_id},
            )
        else:
            # 出貨/銷退/負向調整：成本用前一筆的移動平均成本（不改變平均成本）
            onhand = pre_qty + trn_qty
            new_cost = pre_cost
            avg_cost = new_cost
            cur.execute(
                "UPDATE TBL_TRANSACTION SET TRN_ONHAND=%(oh)s, TRN_AVG_COST=%(ac)s, TRN_COST=%(c)s WHERE TRN_ID=%(id)s",
                {"oh": onhand, "ac": avg_cost, "c": new_cost, "id": trn_id},
            )
            if trn_type == TRN_SHP:
                cur.execute(
                    """UPDATE TBL_SHIP_DT SET SMD_COST=%(c)s
                       WHERE SMT_NO=%(no)s AND SMD_SEQNO=%(seq)s""",
                    {"c": new_cost, "no": trn_src_no, "seq": trn_src_seqno},
                )
        pre_qty, pre_cost = onhand, avg_cost

    cur.execute(
        "UPDATE TBL_PRODUCT SET PRD_ONHAND=%(oh)s, PRD_CUR_COST=%(c)s WHERE PRD_NO=%(prd_no)s",
        {"oh": onhand, "c": avg_cost, "prd_no": prd_no},
    )


def insert_transaction(cur, prd_no: str, inv_no: str, trn_type: int, trn_src_no: str,
                        trn_src_seqno, trn_datetime, trn_qty, trn_cost=0,
                        period_start=None, update=True) -> None:
    if period_start is not None and trn_datetime < period_start:
        raise ValueError(f"異動日期早於結帳日 {period_start}，不可異動")
    cur.execute(
        """INSERT INTO TBL_TRANSACTION
               (PRD_NO,INV_NO,TRN_TYPE,TRN_SRC_NO,TRN_SRC_SEQNO,
                TRN_DATETIME,TRN_QTY,TRN_COST,TRN_ONHAND,TRN_AVG_COST)
           VALUES (%(prd_no)s,%(inv_no)s,%(trn_type)s,%(src_no)s,%(src_seqno)s,
                   %(dt)s,%(qty)s,%(cost)s,0,0)""",
        {
            "prd_no": prd_no, "inv_no": inv_no, "trn_type": trn_type,
            "src_no": trn_src_no, "src_seqno": trn_src_seqno,
            "dt": trn_datetime, "qty": trn_qty, "cost": trn_cost,
        },
    )
    if update:
        update_transaction(cur, prd_no, trn_datetime)


def delete_transactions_and_recalc(cur, trn_type: int, trn_src_no: str, affected: list) -> None:
    """affected: [(prd_no, trn_datetime), ...] 刪除後要重算的產品/起算時間點。"""
    cur.execute(
        "DELETE FROM TBL_TRANSACTION WHERE TRN_TYPE=%(t)s AND TRN_SRC_NO=%(no)s",
        {"t": trn_type, "no": trn_src_no},
    )
    for prd_no, trn_datetime in affected:
        update_transaction(cur, prd_no, trn_datetime)

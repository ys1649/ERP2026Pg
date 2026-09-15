"""借用「系統報表」的 SQL 執行 + Stimulsoft Report Designer 機制，但不透過 TBLSYSREPORTFIELD
的通用查詢欄位/查詢畫面——資產負債表（以及之後同類的財務報表）改用專屬的查詢畫面跟專屬 API，
SQL 逐字比照 Delphi6ERP Form_Acnt_Asset.pas 的原始寫法（只把 MSSQL 語法換成 PostgreSQL），
不套用其他系統報表已經簡化過的 GROUP BY/CASE 改寫版本。
"""
import logging
from datetime import date as date_type, timedelta

from fastapi import APIRouter, HTTPException, Query

from database import get_conn
from services.sysparam import get_sys_param

router = APIRouter()
logger = logging.getLogger(__name__)


def row_to_dict(cur, row):
    return dict(zip([d[0].lower() for d in cur.description], row))


def _scalar_sum(cur, dt_from, dt_end_next, typ_major_type: str) -> float:
    """比照 Form_Acnt_Asset.pas 的三段彙總子查詢（sum_asset/sum_liability/sum_equity 之一）。"""
    sql = """SELECT SUM(A.JND_AMOUNT) AMOUNT
FROM
( SELECT B.JNL_NO,B.JND_SEQNO,B.ACT_NO,B.JND_AMOUNT
  FROM TBL_ACNT_JOURNAL A
    INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO
  WHERE A.JNL_DATE >= %(dt_from)s
    AND A.JNL_DATE <  %(dt_end_next)s
) A
INNER JOIN TBL_ACNT_ACCOUNT C ON A.ACT_NO=C.ACT_NO
INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO
WHERE D.TYP_MAJOR_TYPE=%(typ)s"""
    params = {"dt_from": dt_from, "dt_end_next": dt_end_next, "typ": typ_major_type}
    logged_sql = f"-- 資產負債表：{typ_major_type} 總額查詢 SQL（傳票日期 {dt_from} ~ {dt_end_next}，不含 {dt_end_next} 當天）\n" + sql
    for k, v in params.items():
        logged_sql = logged_sql.replace(f"%({k})s", f"'{v}'")
    logger.info(logged_sql)
    cur.execute(sql, params)
    row = cur.fetchone()
    return float(row[0]) if row and row[0] is not None else 0.0


def _scalar_sum_equity(cur, dt_from, dt_end_next) -> float:
    """比照 Form_Acnt_Asset.pas 的 sum_equity：業主權益本身 + 非資產負債權益的科目合成一筆 PROFIT。"""
    sql = """SELECT SUM(A.JND_AMOUNT) AMOUNT
FROM
( SELECT B.JNL_NO,B.JND_SEQNO,B.ACT_NO,B.JND_AMOUNT
  FROM TBL_ACNT_JOURNAL A
    INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO
    INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO
    INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO
  WHERE A.JNL_DATE >= %(dt_from)s
    AND A.JNL_DATE <  %(dt_end_next)s
    AND D.TYP_MAJOR_TYPE='業主權益'
  UNION
  SELECT 'PROFIT',-1,'3353' ACT_NO
        ,SUM(B.JND_AMOUNT) AMOUNT
  FROM TBL_ACNT_JOURNAL A
    INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO
    INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO
    INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO
  WHERE A.JNL_DATE >= %(dt_from)s
    AND A.JNL_DATE <  %(dt_end_next)s
    AND D.TYP_MAJOR_TYPE NOT IN ('資產','負債','業主權益')
) A"""
    params = {"dt_from": dt_from, "dt_end_next": dt_end_next}
    logged_sql = f"-- 資產負債表：業主權益總額查詢 SQL（傳票日期 {dt_from} ~ {dt_end_next}，不含 {dt_end_next} 當天）\n" + sql
    for k, v in params.items():
        logged_sql = logged_sql.replace(f"%({k})s", f"'{v}'")
    logger.info(logged_sql)
    cur.execute(sql, params)
    row = cur.fetchone()
    return float(row[0]) if row and row[0] is not None else 0.0


@router.get("/asset")
def get_asset_report(dt_end: str = Query(..., description="傳票截止日期 YYYY-MM-DD")):
    """資產負債表。傳票起始日期比照舊系統自動推算：目前會計年度(TBL_SYS_PARAM.SPR_ACNT_YEAR)/1/1。"""
    with get_conn() as conn:
        cur = conn.cursor()
        sp = get_sys_param(cur)
        dt_end_d = date_type.fromisoformat(dt_end)
        dt_from = date_type(sp["spr_acnt_year"], 1, 1)
        dt_end_next = dt_end_d + timedelta(days=1)

        sum_asset = _scalar_sum(cur, dt_from, dt_end_next, "資產")
        sum_liability = _scalar_sum(cur, dt_from, dt_end_next, "負債")
        sum_equity = _scalar_sum_equity(cur, dt_from, dt_end_next)

        # 比照 Form_Acnt_Asset.pas setSQL：sum_asset/sum_liability/sum_equity 是用 floattostr()
        # 直接字串接進主查詢的常數（不是子查詢），這裡原樣保留這個「先算常數再組字串」的寫法。
        # 分母加 NULLIF(...,0) 是唯一的行為差異：同一大類底下如果剛好互相抵銷淨額為 0（例如同屬
        # 資產的兩個科目互轉，各自都非零但加總剛好等於 0），舊系統的 RATE 公式在 MSSQL 下會直接
        # 「Divide by zero」讓整份報表掛掉；這裡改成該筆 RATE 顯示 NULL（其餘資料照常顯示），
        # 不讓一個邊界情況擋掉整份報表的輸出。
        sql = f"""--======================== 資產 ==============================================
SELECT '資產' GRP,A.TYP_MAJOR_TYPE,A.TYP_NO,TYP_NAME,A.ACT_NO,A.ACT_NAME,A.AMOUNT
      ,(A.AMOUNT/NULLIF({sum_asset},0)) * 100 RATE
FROM
( SELECT D.TYP_MAJOR_TYPE,D.TYP_NO,D.TYP_NAME,SUBSTRING(C.ACT_NO,1,4) ACT_NO,C.ACT_NAME
        ,SUM(A.JND_AMOUNT) AMOUNT
  FROM
  ( SELECT B.JNL_NO,B.JND_SEQNO,B.ACT_NO,B.JND_AMOUNT
    FROM TBL_ACNT_JOURNAL A
      INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO
    WHERE A.JNL_DATE >= %(dt_from)s
      AND A.JNL_DATE <  %(dt_end_next)s
  ) A
  INNER JOIN TBL_ACNT_ACCOUNT C ON A.ACT_NO=C.ACT_NO
  INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO
  WHERE D.TYP_MAJOR_TYPE='資產'
  GROUP BY D.TYP_MAJOR_TYPE,D.TYP_NO,D.TYP_NAME,SUBSTRING(C.ACT_NO,1,4),C.ACT_NAME
  HAVING SUM(A.JND_AMOUNT)<>0
) A

UNION

--======================== 負債 ==============================================
SELECT '負債及業主權益' GRP,A.TYP_MAJOR_TYPE,A.TYP_NO,TYP_NAME,A.ACT_NO,A.ACT_NAME,A.AMOUNT*-1
      ,(A.AMOUNT/NULLIF({sum_liability},0)) * 100 RATE
FROM
( SELECT D.TYP_MAJOR_TYPE,D.TYP_NO,D.TYP_NAME,SUBSTRING(C.ACT_NO,1,4) ACT_NO,C.ACT_NAME
        ,SUM(A.JND_AMOUNT) AMOUNT
  FROM
  ( SELECT B.JNL_NO,B.JND_SEQNO,B.ACT_NO,B.JND_AMOUNT
    FROM TBL_ACNT_JOURNAL A
      INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO
    WHERE A.JNL_DATE >= %(dt_from)s
      AND A.JNL_DATE <  %(dt_end_next)s
  ) A
  INNER JOIN TBL_ACNT_ACCOUNT C ON A.ACT_NO=C.ACT_NO
  INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO
  WHERE D.TYP_MAJOR_TYPE='負債'
  GROUP BY D.TYP_MAJOR_TYPE,D.TYP_NO,D.TYP_NAME,SUBSTRING(C.ACT_NO,1,4),C.ACT_NAME
  HAVING SUM(A.JND_AMOUNT)<>0
) A

UNION

--======================== 業主權益 ==============================================
SELECT '負債及業主權益' GRP,A.TYP_MAJOR_TYPE,A.TYP_NO,TYP_NAME,A.ACT_NO,A.ACT_NAME,A.AMOUNT*-1
      ,(A.AMOUNT/NULLIF({sum_equity},0)) * 100 RATE
FROM
( SELECT D.TYP_MAJOR_TYPE,D.TYP_NO,D.TYP_NAME,SUBSTRING(C.ACT_NO,1,4) ACT_NO,C.ACT_NAME
        ,SUM(A.JND_AMOUNT) AMOUNT
  FROM
  ( SELECT B.JNL_NO,B.JND_SEQNO,B.ACT_NO,B.JND_AMOUNT
    FROM TBL_ACNT_JOURNAL A
      INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO
    WHERE A.JNL_DATE >= %(dt_from)s
      AND A.JNL_DATE <  %(dt_end_next)s
    UNION
    SELECT 'PROFIT',-1,'3353' ACT_NO
          ,COALESCE(SUM(B.JND_AMOUNT),0) AMOUNT
    FROM TBL_ACNT_JOURNAL A
      INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO
      INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO
      INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO
    WHERE A.JNL_DATE >= %(dt_from)s
      AND A.JNL_DATE <  %(dt_end_next)s
      AND D.TYP_MAJOR_TYPE NOT IN ('資產','負債','業主權益')
  ) A
  INNER JOIN TBL_ACNT_ACCOUNT C ON A.ACT_NO=C.ACT_NO
  INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO
  WHERE D.TYP_MAJOR_TYPE='業主權益'
  GROUP BY D.TYP_MAJOR_TYPE,D.TYP_NO,D.TYP_NAME,SUBSTRING(C.ACT_NO,1,4),C.ACT_NAME
  HAVING SUM(A.JND_AMOUNT)<>0
) A

ORDER BY TYP_NO,ACT_NO"""

        params = {"dt_from": dt_from, "dt_end_next": dt_end_next}
        logged_sql = (
            f"-- 資產負債表查詢 SQL（傳票日期 {dt_from} ~ {dt_end_d}，"
            f"sum_asset={sum_asset}, sum_liability={sum_liability}, sum_equity={sum_equity}）\n"
            + sql
        )
        for k, v in params.items():
            logged_sql = logged_sql.replace(f"%({k})s", f"'{v}'")
        logger.info(logged_sql)

        try:
            cur.execute(sql, params)
        except Exception as e:
            logger.error("資產負債表 SQL 執行失敗: %s\nSQL:\n%s", e, logged_sql)
            raise HTTPException(400, f"資產負債表查詢執行失敗: {e}")
        rows = [row_to_dict(cur, r) for r in cur.fetchall()]
        return {
            "dt_from": dt_from.isoformat(),
            "dt_end": dt_end_d.isoformat(),
            "cor_name": sp.get("spr_cor_name"),
            "sum_asset": sum_asset,
            "sum_liability": sum_liability,
            "sum_equity": sum_equity,
            "sql": logged_sql,
            "rows": rows,
        }


# 損益表 5 大類：主查詢裡各分類 SubTotal/AMOUNT 是否乘 -1 並不統一（逐字比照 Form_AcntIncomeStament.pas
# 的 Button1Click），跟 GetRptSummary() 算「毛利/淨利/稅前損益/本期損益」用的 5 個總額一律乘 -1
# 是兩回事、不是同一組數字：主查詢顯示的分類小計，收入類/營業外收支類要乘 -1 轉成慣用的正數顯示
# （這兩類科目在傳票上習慣記成負數），成本/費用/所得稅類本來就是正數不必轉；GetRptSummary() 那 5個
# 總額不管哪一類一律乘 -1，只是為了配合「毛利=TotalRevenue+TotalCost」這種用加法累計的算法——換句話說
# GetRptSummary 算出來的 TotalCost，其實是「主查詢顯示的成本小計」的相反數，用加法累計才會等於
# 「收入-成本」。這是舊系統原本就分成兩套算法，不是筆誤，兩邊都要照抄、不能因為「看起來重複」就
# 自作主張統一成一種。
INCOME_CATEGORIES = [
    (1, "營業收入", -1),
    (2, "營業成本", 1),
    (3, "營業費用", 1),
    (4, "營業外收入及費用", -1),
    (5, "所得稅費用(或利益)", 1),
]


def _income_total_sum(cur, dt_from, dt_to_next, typ_major_type: str) -> float:
    """比照 Form_AcntIncomeStament.pas 的 GetRptSummary：5 個分類的合計一律 SUM(JND_AMOUNT)*-1，
    只用來算損益表逐層累計小計（毛利/淨利/稅前損益/本期損益），不是報表內文的分類小計。"""
    sql = """SELECT SUM(B.JND_AMOUNT) * -1 C_JND_AMOUNT
FROM TBL_ACNT_JOURNAL A
  INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO
  INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO
  INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO
WHERE D.TYP_MAJOR_TYPE = %(typ)s
  AND A.JNL_DATE >= %(dt_from)s
  AND A.JNL_DATE <  %(dt_to_next)s"""
    cur.execute(sql, {"typ": typ_major_type, "dt_from": dt_from, "dt_to_next": dt_to_next})
    row = cur.fetchone()
    return float(row[0]) if row and row[0] is not None else 0.0


@router.get("/income-defaults")
def get_income_report_defaults():
    """查詢畫面預設值：傳票起始日期=會計年度(TBL_SYS_PARAM.SPR_ACNT_YEAR)/1/1，
    傳票終止日期=系統日期（這是使用者這次明確要的預設值，跟舊系統 init() 兩個日期都預設今天不同，
    不是照抄舊系統，是使用者這次額外指定的行為）。"""
    with get_conn() as conn:
        cur = conn.cursor()
        sp = get_sys_param(cur)
        return {
            "dt_from": date_type(sp["spr_acnt_year"], 1, 1).isoformat(),
            "dt_to": date_type.today().isoformat(),
        }


def _income_block_sql(sn: int, typ_major_type: str, sign: int) -> str:
    mul = " * -1" if sign == -1 else ""
    return f"""SELECT {sn} SN,A.TYP_MAJOR_TYPE,A.ACT_NAME,A.ACT_NO,A.SubTotal
      ,CASE B.AMOUNT WHEN 0 THEN 0 ELSE (A.SubTotal/B.amount)*100 END AS RATE
      ,S.SPR_COR_NAME
FROM
( SELECT D.TYP_MAJOR_TYPE,C.ACT_NAME,C.ACT_NO
        ,SUM(B.JND_AMOUNT){mul} SubTotal
  FROM TBL_ACNT_JOURNAL A
    INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO
    INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO
    INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO
  WHERE D.TYP_MAJOR_TYPE = '{typ_major_type}'
    AND A.JNL_DATE >= %(dt_from)s
    AND A.JNL_DATE <  %(dt_to_next)s
  GROUP BY D.TYP_MAJOR_TYPE,C.ACT_NAME,C.ACT_NO
) A,
( SELECT D.TYP_MAJOR_TYPE
        ,SUM(B.JND_AMOUNT){mul} AMOUNT
  FROM TBL_ACNT_JOURNAL A
    INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO
    INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO
    INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO
  WHERE D.TYP_MAJOR_TYPE = '{typ_major_type}'
    AND A.JNL_DATE >= %(dt_from)s
    AND A.JNL_DATE <  %(dt_to_next)s
  GROUP BY D.TYP_MAJOR_TYPE
) B
,TBL_SYS_PARAM S"""


@router.get("/income")
def get_income_report(
    dt_from: str = Query(..., description="傳票起始日期 YYYY-MM-DD"),
    dt_to: str = Query(..., description="傳票終止日期 YYYY-MM-DD"),
):
    """損益表。SQL 逐字比照 Form_AcntIncomeStament.pas 的 Button1Click，只把 MSSQL 語法換成
    PostgreSQL：RATE 欄位別名從 MSSQL 前綴寫法 `RATE=CASE...END` 改成標準後綴寫法
    `CASE...END AS RATE`；A,B,TBL_SYS_PARAM S 之間用逗號隱含 CROSS JOIN 原樣保留（Postgres
    也支援，且 B/S 兩邊每個分類都固定只回一列，所以等同真正的 JOIN，不是漏寫條件）。"""
    with get_conn() as conn:
        cur = conn.cursor()
        dt_from_d = date_type.fromisoformat(dt_from)
        dt_to_d = date_type.fromisoformat(dt_to)
        dt_to_next = dt_to_d + timedelta(days=1)
        params = {"dt_from": dt_from_d, "dt_to_next": dt_to_next}

        totals = {
            typ: _income_total_sum(cur, dt_from_d, dt_to_next, typ)
            for _, typ, _ in INCOME_CATEGORIES
        }
        total_revenue = totals["營業收入"]
        total_cost = totals["營業成本"]
        total_expense = totals["營業費用"]
        total_noop = totals["營業外收入及費用"]
        total_tax = totals["所得稅費用(或利益)"]
        gross_profit = total_revenue + total_cost
        net_profit = gross_profit + total_expense
        pretax_profit = net_profit + total_noop
        current_profit = pretax_profit + total_tax

        sql = "\nUNION\n".join(_income_block_sql(sn, typ, sign) for sn, typ, sign in INCOME_CATEGORIES)
        sql += "\nORDER BY SN,ACT_NO"

        logged_sql = (
            f"-- 損益表查詢 SQL（傳票日期 {dt_from_d} ~ {dt_to_d}，"
            f"毛利={gross_profit}, 淨利={net_profit}, 稅前損益={pretax_profit}, 本期損益={current_profit}）\n"
            + sql
        )
        for k, v in params.items():
            logged_sql = logged_sql.replace(f"%({k})s", f"'{v}'")
        logger.info(logged_sql)

        try:
            cur.execute(sql, params)
        except Exception as e:
            logger.error("損益表 SQL 執行失敗: %s\nSQL:\n%s", e, logged_sql)
            raise HTTPException(400, f"損益表查詢執行失敗: {e}")
        rows = [row_to_dict(cur, r) for r in cur.fetchall()]
        return {
            "dt_from": dt_from_d.isoformat(),
            "dt_to": dt_to_d.isoformat(),
            "dt_range": f"{dt_from_d.isoformat()} ~ {dt_to_d.isoformat()}",
            "gross_profit": gross_profit,
            "net_profit": net_profit,
            "pretax_profit": pretax_profit,
            "current_profit": current_profit,
            "sql": logged_sql,
            "rows": rows,
        }


@router.get("/balance-defaults")
def get_balance_report_defaults():
    """查詢畫面預設值。比照 Form_AcntBalance.pas 的 init()：dt1.Date 預設是
    會計年度(TBL_SYS_PARAM.SPR_ACNT_YEAR)/12/31。"""
    with get_conn() as conn:
        cur = conn.cursor()
        sp = get_sys_param(cur)
        return {"dt_end": date_type(sp["spr_acnt_year"], 12, 31).isoformat()}


@router.get("/balance")
def get_balance_report(dt_end: str = Query(..., description="查詢截止日期 YYYY-MM-DD")):
    """科目餘額表。SQL 逐字比照 Form_AcntBalance.pas 的 setSQL：全歷史累計到查詢截止日（沒有
    起始日限制），排除年度結轉傳票（JNL_BILL_TYPE=2）。"""
    with get_conn() as conn:
        cur = conn.cursor()
        sp = get_sys_param(cur)
        dt_end_d = date_type.fromisoformat(dt_end)
        dt_end_next = dt_end_d + timedelta(days=1)

        sql = """SELECT D.TYP_MAJOR_TYPE,D.TYP_NO,D.TYP_NAME,B.ACT_NO,C.ACT_NAME
      ,SUM(B.JND_AMOUNT) BALANCE
FROM TBL_ACNT_JOURNAL A
INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO
INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO
INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO
WHERE A.JNL_BILL_TYPE <> 2
  AND A.JNL_DATE < %(dt_end_next)s
GROUP BY D.TYP_MAJOR_TYPE,D.TYP_NO,D.TYP_NAME,B.ACT_NO,C.ACT_NAME
ORDER BY D.TYP_NO,B.ACT_NO"""

        params = {"dt_end_next": dt_end_next}
        logged_sql = f"-- 科目餘額表查詢 SQL（查詢截止日期 {dt_end_d}，全歷史累計，排除年度結轉傳票 JNL_BILL_TYPE=2）\n" + sql
        for k, v in params.items():
            logged_sql = logged_sql.replace(f"%({k})s", f"'{v}'")
        logger.info(logged_sql)

        try:
            cur.execute(sql, params)
        except Exception as e:
            logger.error("科目餘額表 SQL 執行失敗: %s\nSQL:\n%s", e, logged_sql)
            raise HTTPException(400, f"科目餘額表查詢執行失敗: {e}")
        rows = [row_to_dict(cur, r) for r in cur.fetchall()]
        return {
            "dt_end": dt_end_d.isoformat(),
            "cor_name": sp.get("spr_cor_name"),
            "sql": logged_sql,
            "rows": rows,
        }


@router.get("/daily-defaults")
def get_daily_report_defaults():
    """查詢畫面預設值。比照 Form_AcntDaily.pas 的 init()：dt1=會計年度/01/01，dt2=會計年度/12/31。"""
    with get_conn() as conn:
        cur = conn.cursor()
        sp = get_sys_param(cur)
        year = sp["spr_acnt_year"]
        return {
            "dt_from": date_type(year, 1, 1).isoformat(),
            "dt_to": date_type(year, 12, 31).isoformat(),
        }


@router.get("/daily")
def get_daily_report(
    dt_from: str = Query(..., description="傳票起始日期 YYYY-MM-DD"),
    dt_to: str = Query(..., description="傳票終止日期 YYYY-MM-DD"),
):
    """日記帳。SQL 逐字比照 Form_AcntDaily.pas：實際 SQL 樣板寫死在 qryReport 的 .dfm 設計期
    SQL（setSQL() 只是對這段樣板字串做日期常數取代，不是重新組 SQL），只把 MSSQL 語法換成
    PostgreSQL：CONVERT(DATETIME,FLOOR(CONVERT(FLOAT,...))) 去掉時間部分改用 ::date 轉型；
    沒有排除年度結轉傳票（JNL_BILL_TYPE<>2）的條件——這跟其他幾張報表不同，是舊系統原本就有
    的差異（日記帳本來就要列出所有傳票，包含年度結轉），不是漏寫，原樣保留不統一。"""
    with get_conn() as conn:
        cur = conn.cursor()
        sp = get_sys_param(cur)
        dt_from_d = date_type.fromisoformat(dt_from)
        dt_to_d = date_type.fromisoformat(dt_to)
        dt_to_next = dt_to_d + timedelta(days=1)

        sql = """SELECT A.JNL_DATE::date JNL_DATE
      ,A.JNL_NO
      ,B.ACT_NO,B.JND_DESC
      ,CASE WHEN B.JND_AMOUNT>=0 THEN '借' ELSE '貸' END DC
      ,CASE WHEN B.JND_AMOUNT>=0 THEN C.ACT_NAME ELSE '　　'||C.ACT_NAME END ACT_NAME
      ,CASE WHEN B.JND_AMOUNT>=0 THEN B.JND_AMOUNT ELSE B.JND_AMOUNT*-1 END JND_AMOUNT
FROM TBL_ACNT_JOURNAL A
INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO
INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO
WHERE A.JNL_DATE >= %(dt_from)s
  AND A.JNL_DATE <  %(dt_to_next)s
ORDER BY A.JNL_DATE,A.JNL_NO,B.JND_SEQNO"""

        params = {"dt_from": dt_from_d, "dt_to_next": dt_to_next}
        logged_sql = f"-- 日記帳查詢 SQL（傳票日期 {dt_from_d} ~ {dt_to_d}）\n" + sql
        for k, v in params.items():
            logged_sql = logged_sql.replace(f"%({k})s", f"'{v}'")
        logger.info(logged_sql)

        try:
            cur.execute(sql, params)
        except Exception as e:
            logger.error("日記帳 SQL 執行失敗: %s\nSQL:\n%s", e, logged_sql)
            raise HTTPException(400, f"日記帳查詢執行失敗: {e}")
        rows = [row_to_dict(cur, r) for r in cur.fetchall()]
        for r in rows:
            r["jnl_date"] = r["jnl_date"].isoformat() if r["jnl_date"] else None
        return {
            "dt_from": dt_from_d.isoformat(),
            "dt_to": dt_to_d.isoformat(),
            "dt_range": f"{dt_from_d.isoformat()} ~ {dt_to_d.isoformat()}",
            "cor_name": sp.get("spr_cor_name"),
            "sql": logged_sql,
            "rows": rows,
        }


@router.get("/trial-defaults")
def get_trial_report_defaults():
    """試算表查詢畫面預設值。比照 Form_AcntTrialBalance.pas 的 init()：dtFrom/dtTo 都預設系統日期
    （這跟損益表被使用者要求改成 acnt_year/1/1 不同，試算表沒有被要求改，照抄舊系統原本的行為）。"""
    today = date_type.today().isoformat()
    return {"dt_from": today, "dt_to": today}


@router.get("/trial")
def get_trial_report(
    dt_from: str = Query(..., description="傳票起始日期 YYYY-MM-DD"),
    dt_to: str = Query(..., description="傳票終止日期 YYYY-MM-DD"),
):
    """試算表。SQL 逐字比照 Form_AcntTrialBalance.pas 的 setSQL：區間淨發生額依正負分借貸兩欄
    （**不是**期初+本期+期末四欄式，這是舊系統原本的實際邏輯，不是簡化）。沒有排除年度結轉傳票，
    也是舊系統原本就有的行為。"""
    with get_conn() as conn:
        cur = conn.cursor()
        sp = get_sys_param(cur)
        dt_from_d = date_type.fromisoformat(dt_from)
        dt_to_d = date_type.fromisoformat(dt_to)
        dt_to_next = dt_to_d + timedelta(days=1)

        sql = """SELECT B.ACT_NO,C.ACT_NAME,SUM(B.JND_AMOUNT) DEBIT,0 CREDIT,SUM(B.JND_AMOUNT) AMOUNT
FROM TBL_ACNT_JOURNAL A
INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO
INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO
WHERE A.JNL_DATE >= %(dt_from)s
  AND A.JNL_DATE <  %(dt_to_next)s
GROUP BY B.ACT_NO,C.ACT_NAME
HAVING SUM(B.JND_AMOUNT)>=0
UNION
SELECT B.ACT_NO,C.ACT_NAME,0 DEBIT,-SUM(B.JND_AMOUNT) CREDIT,SUM(B.JND_AMOUNT) AMOUNT
FROM TBL_ACNT_JOURNAL A
INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO
INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO
WHERE A.JNL_DATE >= %(dt_from)s
  AND A.JNL_DATE <  %(dt_to_next)s
GROUP BY B.ACT_NO,C.ACT_NAME
HAVING SUM(B.JND_AMOUNT)<0"""

        params = {"dt_from": dt_from_d, "dt_to_next": dt_to_next}
        logged_sql = f"-- 試算表查詢 SQL（傳票日期 {dt_from_d} ~ {dt_to_d}）\n" + sql
        for k, v in params.items():
            logged_sql = logged_sql.replace(f"%({k})s", f"'{v}'")
        logger.info(logged_sql)

        try:
            cur.execute(sql, params)
        except Exception as e:
            logger.error("試算表 SQL 執行失敗: %s\nSQL:\n%s", e, logged_sql)
            raise HTTPException(400, f"試算表查詢執行失敗: {e}")
        rows = [row_to_dict(cur, r) for r in cur.fetchall()]
        return {
            "dt_from": dt_from_d.isoformat(),
            "dt_to": dt_to_d.isoformat(),
            "dt_range": f"{dt_from_d.isoformat()} ~ {dt_to_d.isoformat()}",
            "cor_name": sp.get("spr_cor_name"),
            "sql": logged_sql,
            "rows": rows,
        }


@router.get("/cash-defaults")
def get_cash_report_defaults():
    """查詢畫面預設值。比照 From_AcntCash.pas 的 init()：dt1=會計年度/1/1，dt2=會計年度/12/31。"""
    with get_conn() as conn:
        cur = conn.cursor()
        sp = get_sys_param(cur)
        year = sp["spr_acnt_year"]
        return {
            "dt_from": date_type(year, 1, 1).isoformat(),
            "dt_to": date_type(year, 12, 31).isoformat(),
        }


@router.get("/cash")
def get_cash_report(
    dt_from: str = Query(..., description="傳票起始日期 YYYY-MM-DD"),
    dt_to: str = Query(..., description="傳票終止日期 YYYY-MM-DD"),
):
    """現金簿。科目寫死 1111（庫存現金），SQL 逐字比照 From_AcntCash.pas 的 qryReport 設計期 SQL +
    setSQL() 事後 append 的 WHERE/ORDER BY（原始 SQL 本身沒有 ORDER BY，是 setSQL 另外接上去的）。
    「期初金額」是合成的一列：從當年 1/1 到查詢起日（不含）之間的所有交易加總，再加上
    TBL_ACNT_INIT 這張表存的年度期初餘額，兩者相加當作查詢起日當下的累計餘額基礎。
    「餘額」欄位（ppDBCalc1，ResetGroup=ppGroup1）在舊系統是 ReportBuilder 逐列往下累加的
    running total，Stimulsoft 沒有對等的「逐列累加」欄位機制，改成在 SQL 端用 SUM() OVER
    (...ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) window function 算好再回傳同一個
    數字，這是平台差異的等效實作，不是改變數字或邏輯。"""
    with get_conn() as conn:
        cur = conn.cursor()
        sp = get_sys_param(cur)
        dt_from_d = date_type.fromisoformat(dt_from)
        dt_to_d = date_type.fromisoformat(dt_to)
        dt_to_next = dt_to_d + timedelta(days=1)
        dt_year_start = date_type(dt_from_d.year, 1, 1)
        dt_year_str = str(dt_from_d.year)

        sql = """SELECT A.JNL_DATE,A.JNL_NO,A.JND_SEQNO,A.JND_DESC,A.ACT_NO,B.ACT_NAME,A.AMOUNT
      ,CASE WHEN A.AMOUNT>=0 THEN A.AMOUNT ELSE 0 END DEBIT
      ,CASE WHEN A.AMOUNT<0 THEN -A.AMOUNT ELSE 0 END CREDIT
      ,SUM(A.AMOUNT) OVER (ORDER BY A.JNL_DATE,A.JNL_NO,A.JND_SEQNO
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) BALANCE
FROM
( SELECT A.JNL_DATE,A.JNL_NO,B.JND_SEQNO,B.ACT_NO,B.JND_DESC,B.JND_AMOUNT AMOUNT
  FROM TBL_ACNT_JOURNAL A
  INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO
  WHERE A.JNL_DATE >= %(dt_from)s
    AND A.JNL_DATE <  %(dt_to_next)s
  UNION
  SELECT %(dt_from)s JNL_DATE
        ,'@@INIT' JNL_NO
        ,0 JND_SEQNO
        ,ACT_NO
        ,'期初金額' JND_DESC
        ,SUM(AMOUNT) AMOUNT
  FROM
  ( SELECT A.JNL_NO,B.JND_SEQNO,B.ACT_NO,B.JND_AMOUNT AMOUNT
    FROM TBL_ACNT_JOURNAL A
    INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO
    WHERE A.JNL_DATE >= %(dt_year_start)s
      AND A.JNL_DATE <  %(dt_from)s
    UNION
    SELECT '@@',0,A.ACT_NO,INI_AMOUNT AMOUNT
    FROM TBL_ACNT_INIT A
    WHERE A.INI_YEAR = %(dt_year_str)s
  ) A
  GROUP BY ACT_NO
) A INNER JOIN TBL_ACNT_ACCOUNT B ON A.ACT_NO=B.ACT_NO
WHERE A.ACT_NO = '1111'
ORDER BY A.ACT_NO,A.JNL_DATE,A.JNL_NO,A.JND_SEQNO"""

        params = {
            "dt_from": dt_from_d, "dt_to_next": dt_to_next,
            "dt_year_start": dt_year_start, "dt_year_str": dt_year_str,
        }
        logged_sql = f"-- 現金簿查詢 SQL（科目 1111，傳票日期 {dt_from_d} ~ {dt_to_d}）\n" + sql
        for k, v in params.items():
            logged_sql = logged_sql.replace(f"%({k})s", f"'{v}'")
        logger.info(logged_sql)

        try:
            cur.execute(sql, params)
        except Exception as e:
            logger.error("現金簿 SQL 執行失敗: %s\nSQL:\n%s", e, logged_sql)
            raise HTTPException(400, f"現金簿查詢執行失敗: {e}")
        rows = [row_to_dict(cur, r) for r in cur.fetchall()]
        for r in rows:
            r["jnl_date"] = r["jnl_date"].isoformat() if r["jnl_date"] else None
        return {
            "dt_from": dt_from_d.isoformat(),
            "dt_to": dt_to_d.isoformat(),
            "dt_range": f"{dt_from_d.isoformat()} ~ {dt_to_d.isoformat()}",
            "cor_name": sp.get("spr_cor_name"),
            "sql": logged_sql,
            "rows": rows,
        }


@router.get("/detail-defaults")
def get_detail_report_defaults():
    """查詢畫面預設值。比照 Form_AcntDetail.pas 的 SetupQueryForm：日期範圍預設會計年度 1/1~12/31。"""
    with get_conn() as conn:
        cur = conn.cursor()
        sp = get_sys_param(cur)
        year = sp["spr_acnt_year"]
        return {
            "dt_from": date_type(year, 1, 1).isoformat(),
            "dt_to": date_type(year, 12, 31).isoformat(),
        }


@router.get("/detail")
def get_detail_report(
    dt_from: str = Query(..., description="傳票起始日期 YYYY-MM-DD"),
    dt_to: str = Query(..., description="傳票終止日期 YYYY-MM-DD"),
    act_no_from: str | None = Query(None, description="科目編號起（選填）"),
    act_no_to: str | None = Query(None, description="科目編號迄（選填）"),
):
    """明細分類帳。SQL 逐字比照 Form_AcntDetail.pas 的 setSQL：依科目分組，每組各自的「期初金額」
    是合成的一列——從有史以來到查詢起日（不含）之間該科目的所有交易加總（不像現金簿還要另外加
    TBL_ACNT_INIT，這裡單純只加總歷史交易，兩份報表的期初金額算法本來就不一樣，不是筆誤）。
    有排除年度結轉傳票（JNL_BILL_TYPE<>2）。「餘額」欄位在舊系統是 ReportBuilder 逐列往下累加、
    换科目歸零重算的 running total（ResetGroup=ppGroup1），比照現金簿的做法，改成在 SQL 端用
    SUM() OVER (PARTITION BY ACT_NO ORDER BY ...) window function 算好回傳。

    科目篩選簡化成單一區間欄位（舊系統原本是區間/單選/多選三選一的通用查詢畫面欄位，這裡改用
    專屬查詢畫面，只留最常用的區間篩選，多選/單選沒有搬——單選/多選都可以用「起=迄=同一個科目」
    的區間表示，只有「不連續挑多個科目」這種情境沒有對應做法，影響有限）。"""
    with get_conn() as conn:
        cur = conn.cursor()
        sp = get_sys_param(cur)
        dt_from_d = date_type.fromisoformat(dt_from)
        dt_to_d = date_type.fromisoformat(dt_to)
        dt_to_next = dt_to_d + timedelta(days=1)

        sql = """SELECT A.JNL_DATE,A.JNL_NO,A.JND_SEQNO,A.JND_DESC,A.ACT_NO,B.ACT_NAME,A.AMOUNT
      ,CASE WHEN A.AMOUNT>=0 THEN A.AMOUNT ELSE 0 END DEBIT
      ,CASE WHEN A.AMOUNT<0 THEN -A.AMOUNT ELSE 0 END CREDIT
      ,SUM(A.AMOUNT) OVER (PARTITION BY A.ACT_NO ORDER BY A.JNL_DATE,A.JNL_NO,A.JND_SEQNO
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) BALANCE
FROM
( SELECT A.JNL_DATE,A.JNL_NO,B.JND_SEQNO,B.ACT_NO,B.JND_DESC,B.JND_AMOUNT AMOUNT
  FROM TBL_ACNT_JOURNAL A
  INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO
  WHERE A.JNL_DATE >= %(dt_from)s
    AND A.JNL_DATE <  %(dt_to_next)s
    AND A.JNL_BILL_TYPE <> 2
  UNION
  SELECT %(dt_from)s JNL_DATE
        ,'@@INIT' JNL_NO
        ,0 JND_SEQNO
        ,ACT_NO
        ,'期初金額' JND_DESC
        ,SUM(AMOUNT) AMOUNT
  FROM
  ( SELECT A.JNL_NO,B.JND_SEQNO,B.ACT_NO,B.JND_AMOUNT AMOUNT
    FROM TBL_ACNT_JOURNAL A
    INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO
    WHERE A.JNL_DATE < %(dt_from)s
      AND A.JNL_BILL_TYPE <> 2
  ) A
  GROUP BY ACT_NO
) A INNER JOIN TBL_ACNT_ACCOUNT B ON A.ACT_NO=B.ACT_NO"""

        params = {"dt_from": dt_from_d, "dt_to_next": dt_to_next}
        if act_no_from and act_no_to:
            sql += "\nWHERE A.ACT_NO BETWEEN %(act_no_from)s AND %(act_no_to)s"
            params["act_no_from"] = act_no_from
            params["act_no_to"] = act_no_to
        sql += "\nORDER BY A.ACT_NO,A.JNL_DATE,A.JNL_NO,A.JND_SEQNO"

        logged_sql = f"-- 明細分類帳查詢 SQL（傳票日期 {dt_from_d} ~ {dt_to_d}，科目 {act_no_from or '(全部)'} ~ {act_no_to or '(全部)'}）\n" + sql
        for k, v in params.items():
            logged_sql = logged_sql.replace(f"%({k})s", f"'{v}'")
        logger.info(logged_sql)

        try:
            cur.execute(sql, params)
        except Exception as e:
            logger.error("明細分類帳 SQL 執行失敗: %s\nSQL:\n%s", e, logged_sql)
            raise HTTPException(400, f"明細分類帳查詢執行失敗: {e}")
        rows = [row_to_dict(cur, r) for r in cur.fetchall()]
        for r in rows:
            r["jnl_date"] = r["jnl_date"].isoformat() if r["jnl_date"] else None
        return {
            "dt_from": dt_from_d.isoformat(),
            "dt_to": dt_to_d.isoformat(),
            "dt_range": f"{dt_from_d.isoformat()} ~ {dt_to_d.isoformat()}",
            "cor_name": sp.get("spr_cor_name"),
            "sql": logged_sql,
            "rows": rows,
        }

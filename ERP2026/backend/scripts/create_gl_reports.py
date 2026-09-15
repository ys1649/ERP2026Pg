"""建立會計總帳 7 張報表的系統報表定義（TBLSYSREPORT/TBLSYSREPORTFIELD）。

比照 Delphi6ERP 對應模組（Form_AcntBalance.pas/Form_AcntDaily.pas/Form_AcntTrialBalance.pas/
Form_AcntCash.pas/Form_AcntDetail.pas/Form_AcntIncomeStament.pas/Form_Acnt_Asset.pas）的實際計算邏輯。

跟系統報表引擎既有的「SELECT + 動態WHERE + GROUPBY + ORDERBY」字串拼接機制相容，不需要修改
sysreport.py 本身：
- 科目餘額表/日記帳/試算表/損益表/資產負債表：一般 GROUP BY 查詢，動態 WHERE 在 GROUP BY 之前
  套用，過帳日期區間可以直接當一般查詢欄位。
- 現金簿/明細分類帳：需要「期初（含以前所有交易）+ 逐筆累計餘額」，用視窗函數在未過濾的資料上
  先算好累計餘額，包一層子查詢後，動態 WHERE 對子查詢外層過濾日期區間——這樣累計餘額仍然正確
  反映期初以前的所有異動，不需要额外的「期初餘額」合成列。

可重複執行（會先刪除同 SRP_CODE 的舊定義再重建）。
"""
import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from database import get_conn  # noqa: E402


def _build_income_srp_select() -> str:
    """比照 Form_AcntIncomeStament.pas 的 Button1Click，5 大類 UNION 起來的完整 SQL，用最精簡的
    寫法（不留排版空白）組字串，因為 TBLSYSREPORT.SRP_SELECT 欄位只有 varchar(4000)，5 段 UNION
    展開後很容易超過。"""
    categories = [
        (1, "營業收入", "*-1"),
        (2, "營業成本", ""),
        (3, "營業費用", ""),
        (4, "營業外收入及費用", "*-1"),
        (5, "所得稅費用(或利益)", ""),
    ]
    blocks = []
    for sn, typ, mul in categories:
        blocks.append(
            f"SELECT {sn} SN,A.TYP_MAJOR_TYPE,A.ACT_NAME,A.ACT_NO,A.SubTotal"
            ",CASE B.AMOUNT WHEN 0 THEN 0 ELSE (A.SubTotal/B.amount)*100 END AS RATE"
            ",S.SPR_COR_NAME FROM"
            f" (SELECT D.TYP_MAJOR_TYPE,C.ACT_NAME,C.ACT_NO,SUM(B.JND_AMOUNT){mul} SubTotal"
            " FROM TBL_ACNT_JOURNAL A"
            " JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO"
            " JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO"
            " JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO"
            f" WHERE D.TYP_MAJOR_TYPE='{typ}'"
            " GROUP BY D.TYP_MAJOR_TYPE,C.ACT_NAME,C.ACT_NO) A,"
            f" (SELECT D.TYP_MAJOR_TYPE,SUM(B.JND_AMOUNT){mul} AMOUNT"
            " FROM TBL_ACNT_JOURNAL A"
            " JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO"
            " JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO"
            " JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO"
            f" WHERE D.TYP_MAJOR_TYPE='{typ}'"
            " GROUP BY D.TYP_MAJOR_TYPE) B,TBL_SYS_PARAM S"
        )
    return " UNION ".join(blocks) + " ORDER BY SN,ACT_NO"


REPORTS = [
    {
        "srp_code": "GL_BALANCE",
        "srp_name": "科目餘額表",
        "srp_description": "比照 Form_AcntBalance.pas：全歷史累計到查詢截止日，排除年度結轉傳票(JNL_BILL_TYPE=2)",
        "srp_select": (
            "SELECT T.TYP_MAJOR_TYPE, T.TYP_NO, T.TYP_NAME, C.ACT_NO, C.ACT_NAME, SUM(D.JND_AMOUNT) AS BALANCE "
            "FROM TBL_ACNT_JOURNAL_DT D "
            "JOIN TBL_ACNT_JOURNAL M ON M.JNL_NO=D.JNL_NO "
            "JOIN TBL_ACNT_ACCOUNT C ON C.ACT_NO=D.ACT_NO "
            "JOIN TBL_ACNT_TYPE T ON T.TYP_NO=C.TYP_NO"
        ),
        "srp_where": "WHERE M.JNL_BILL_TYPE<>2",
        "srp_groupby": "GROUP BY T.TYP_MAJOR_TYPE, T.TYP_NO, T.TYP_NAME, C.ACT_NO, C.ACT_NAME",
        "srp_orderby": "ORDER BY T.TYP_NO, C.ACT_NO",
        "fields": [
            {"srf_fieldname": "JNL_DATE", "srf_tablealias": "M", "srf_dispname": "查詢日期(訖)",
             "srf_datatype": "Date", "srf_querytype": "Range", "srf_disporder": 1},
        ],
    },
    {
        "srp_code": "GL_DAILY",
        "srp_name": "日記帳",
        "srp_description": "比照 Form_AcntDaily.pas：傳票明細清單，借貸方拆兩欄，無彙總",
        "srp_select": (
            "SELECT M.JNL_DATE, M.JNL_NO, D.ACT_NO, D.JND_DESC, "
            "CASE WHEN D.JND_AMOUNT>=0 THEN '借' ELSE '貸' END AS DC, "
            "CASE WHEN D.JND_AMOUNT>=0 THEN C.ACT_NAME ELSE '　　'||C.ACT_NAME END AS ACT_NAME, "
            "CASE WHEN D.JND_AMOUNT>=0 THEN D.JND_AMOUNT ELSE D.JND_AMOUNT*-1 END AS JND_AMOUNT "
            "FROM TBL_ACNT_JOURNAL M "
            "JOIN TBL_ACNT_JOURNAL_DT D ON M.JNL_NO=D.JNL_NO "
            "JOIN TBL_ACNT_ACCOUNT C ON D.ACT_NO=C.ACT_NO"
        ),
        "srp_where": None,
        "srp_groupby": None,
        "srp_orderby": "ORDER BY M.JNL_DATE, M.JNL_NO, D.JND_SEQNO",
        "fields": [
            {"srf_fieldname": "JNL_DATE", "srf_tablealias": "M", "srf_dispname": "傳票日期",
             "srf_datatype": "Date", "srf_querytype": "Range", "srf_disporder": 1},
        ],
    },
    {
        "srp_code": "GL_TRIAL",
        "srp_name": "試算表",
        "srp_description": (
            "比照 Form_AcntTrialBalance.pas：區間淨發生額，依正負分借貸兩欄——"
            "**不是**期初+本期+期末四欄式，這是舊系統原本的實際邏輯，使用者已確認照抄"
        ),
        "srp_select": (
            "SELECT C.ACT_NO, C.ACT_NAME, "
            "CASE WHEN SUM(D.JND_AMOUNT)>=0 THEN SUM(D.JND_AMOUNT) ELSE 0 END AS DEBIT, "
            "CASE WHEN SUM(D.JND_AMOUNT)<0 THEN -SUM(D.JND_AMOUNT) ELSE 0 END AS CREDIT, "
            "SUM(D.JND_AMOUNT) AS AMOUNT "
            "FROM TBL_ACNT_JOURNAL_DT D "
            "JOIN TBL_ACNT_JOURNAL M ON M.JNL_NO=D.JNL_NO "
            "JOIN TBL_ACNT_ACCOUNT C ON C.ACT_NO=D.ACT_NO"
        ),
        "srp_where": None,
        "srp_groupby": "GROUP BY C.ACT_NO, C.ACT_NAME",
        "srp_orderby": "ORDER BY C.ACT_NO",
        "fields": [
            {"srf_fieldname": "JNL_DATE", "srf_tablealias": "M", "srf_dispname": "查詢日期區間",
             "srf_datatype": "Date", "srf_querytype": "Range", "srf_disporder": 1},
        ],
    },
    {
        "srp_code": "GL_CASH",
        "srp_name": "現金簿",
        "srp_description": (
            "比照 Form_AcntCash.pas：科目寫死 1111（現金），累計餘額用視窗函數算在未過濾資料上"
            "（等同含期初餘額），排除年度結轉傳票"
        ),
        "srp_select": (
            "SELECT * FROM ("
            "SELECT M.JNL_DATE, M.JNL_NO, D.JND_SEQNO, D.JND_DESC, "
            "CASE WHEN D.JND_AMOUNT>=0 THEN D.JND_AMOUNT END AS DEBIT, "
            "CASE WHEN D.JND_AMOUNT<0 THEN -D.JND_AMOUNT END AS CREDIT, "
            "SUM(D.JND_AMOUNT) OVER (ORDER BY M.JNL_DATE, M.JNL_NO, D.JND_SEQNO "
            "ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS BALANCE, "
            "COALESCE(SUM(D.JND_AMOUNT) OVER (ORDER BY M.JNL_DATE, M.JNL_NO, D.JND_SEQNO "
            "ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING), 0) AS BALANCE_BEFORE "
            "FROM TBL_ACNT_JOURNAL_DT D "
            "JOIN TBL_ACNT_JOURNAL M ON M.JNL_NO=D.JNL_NO "
            "WHERE D.ACT_NO='1111' AND M.JNL_BILL_TYPE<>2"
            ") T"
        ),
        "srp_where": None,
        "srp_groupby": None,
        "srp_orderby": "ORDER BY T.JNL_DATE, T.JNL_NO, T.JND_SEQNO",
        "fields": [
            {"srf_fieldname": "JNL_DATE", "srf_tablealias": "T", "srf_dispname": "查詢日期區間",
             "srf_datatype": "Date", "srf_querytype": "Range", "srf_disporder": 1},
        ],
    },
    {
        "srp_code": "GL_DETAIL",
        "srp_name": "明細分類帳",
        "srp_description": (
            "比照 Form_AcntDetail.pas：依科目分組，累計餘額用視窗函數（PARTITION BY 科目）算在"
            "未過濾資料上，排除年度結轉傳票。科目篩選簡化成單一區間欄位（舊系統原本區間/單選/多選"
            "三選一，多選部分未搬）"
        ),
        "srp_select": (
            "SELECT * FROM ("
            "SELECT C.ACT_NO, C.ACT_NAME, M.JNL_DATE, M.JNL_NO, D.JND_SEQNO, D.JND_DESC, "
            "CASE WHEN D.JND_AMOUNT>=0 THEN D.JND_AMOUNT END AS DEBIT, "
            "CASE WHEN D.JND_AMOUNT<0 THEN -D.JND_AMOUNT END AS CREDIT, "
            "SUM(D.JND_AMOUNT) OVER (PARTITION BY C.ACT_NO ORDER BY M.JNL_DATE, M.JNL_NO, D.JND_SEQNO "
            "ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS BALANCE, "
            "COALESCE(SUM(D.JND_AMOUNT) OVER (PARTITION BY C.ACT_NO ORDER BY M.JNL_DATE, M.JNL_NO, D.JND_SEQNO "
            "ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING), 0) AS BALANCE_BEFORE "
            "FROM TBL_ACNT_JOURNAL_DT D "
            "JOIN TBL_ACNT_JOURNAL M ON M.JNL_NO=D.JNL_NO "
            "JOIN TBL_ACNT_ACCOUNT C ON C.ACT_NO=D.ACT_NO "
            "WHERE M.JNL_BILL_TYPE<>2"
            ") T"
        ),
        "srp_where": None,
        "srp_groupby": None,
        "srp_orderby": "ORDER BY T.ACT_NO, T.JNL_DATE, T.JNL_NO, T.JND_SEQNO",
        "fields": [
            {"srf_fieldname": "JNL_DATE", "srf_tablealias": "T", "srf_dispname": "查詢日期區間",
             "srf_datatype": "Date", "srf_querytype": "Range", "srf_disporder": 1},
            {"srf_fieldname": "ACT_NO", "srf_tablealias": "T", "srf_dispname": "科目範圍",
             "srf_datatype": "String", "srf_querytype": "Range", "srf_disporder": 2},
        ],
    },
    {
        "srp_code": "GL_INCOME",
        "srp_name": "損益表",
        "srp_description": (
            "比照 Form_AcntIncomeStament.pas 的 Button1Click 逐字轉成 PostgreSQL 語法（不使用系統"
            "報表通用查詢欄位/查詢畫面，改走專屬 /api/gl-reports/income + 專屬查詢畫面）。這裡的"
            "SRP_SELECT 只給 Report Designer 排版預覽用，日期範圍沒有套用（真正查詢在後端 API 組"
            "傳票起訖日期參數），完整 SQL 一律不拆 WHERE/GROUPBY/ORDERBY，整段放在 SRP_SELECT"
        ),
        "srp_select": _build_income_srp_select(),
        "srp_where": None,
        "srp_groupby": None,
        "srp_orderby": None,
        "fields": [],
    },
    {
        "srp_code": "GL_ASSET",
        "srp_name": "資產負債表",
        "srp_description": (
            "比照 Form_Acnt_Asset.pas：GRP 分「資產」/「負債及業主權益」；科目併到母科目層級"
            "(SUBSTRING 4碼)；HAVING 濾零餘額；RATE 除以各自大類總額；本期損益(3353)合成列。"
            "查詢日期改成起訖都讓使用者輸入（原本起日自動推算，數字算法不變）"
        ),
        "srp_select": (
            "SELECT "
            "CASE WHEN T.TYP_MAJOR_TYPE='資產' THEN '資產' ELSE '負債及業主權益' END AS GRP, "
            "CASE WHEN T.TYP_MAJOR_TYPE IN ('資產','負債','業主權益') THEN T.TYP_MAJOR_TYPE ELSE '業主權益' END AS TYP_MAJOR_TYPE, "
            "CASE WHEN T.TYP_MAJOR_TYPE IN ('資產','負債','業主權益') THEN T.TYP_NO ELSE '99' END AS TYP_NO, "
            "CASE WHEN T.TYP_MAJOR_TYPE IN ('資產','負債','業主權益') THEN T.TYP_NAME ELSE '本期損益' END AS TYP_NAME, "
            "CASE WHEN T.TYP_MAJOR_TYPE IN ('資產','負債','業主權益') THEN SUBSTRING(C.ACT_NO,1,4) ELSE '3353' END AS ACT_NO, "
            "CASE WHEN T.TYP_MAJOR_TYPE IN ('資產','負債','業主權益') THEN C.ACT_NAME ELSE '本期損益' END AS ACT_NAME, "
            "(CASE WHEN (CASE WHEN T.TYP_MAJOR_TYPE='資產' THEN '資產' ELSE '負債及業主權益' END)='資產' "
            "THEN SUM(D.JND_AMOUNT) ELSE -SUM(D.JND_AMOUNT) END) AS AMOUNT, "
            "(CASE WHEN (CASE WHEN T.TYP_MAJOR_TYPE='資產' THEN '資產' ELSE '負債及業主權益' END)='資產' "
            "THEN SUM(D.JND_AMOUNT) ELSE -SUM(D.JND_AMOUNT) END) "
            "/ NULLIF(SUM(CASE WHEN (CASE WHEN T.TYP_MAJOR_TYPE='資產' THEN '資產' ELSE '負債及業主權益' END)='資產' "
            "THEN SUM(D.JND_AMOUNT) ELSE -SUM(D.JND_AMOUNT) END) "
            "OVER (PARTITION BY CASE WHEN T.TYP_MAJOR_TYPE IN ('資產','負債','業主權益') THEN T.TYP_MAJOR_TYPE ELSE '業主權益' END), 0) * 100 AS RATE "
            "FROM TBL_ACNT_JOURNAL_DT D "
            "JOIN TBL_ACNT_JOURNAL M ON M.JNL_NO=D.JNL_NO "
            "JOIN TBL_ACNT_ACCOUNT C ON C.ACT_NO=D.ACT_NO "
            "JOIN TBL_ACNT_TYPE T ON T.TYP_NO=C.TYP_NO"
        ),
        "srp_where": None,
        "srp_groupby": (
            "GROUP BY "
            "CASE WHEN T.TYP_MAJOR_TYPE='資產' THEN '資產' ELSE '負債及業主權益' END, "
            "CASE WHEN T.TYP_MAJOR_TYPE IN ('資產','負債','業主權益') THEN T.TYP_MAJOR_TYPE ELSE '業主權益' END, "
            "CASE WHEN T.TYP_MAJOR_TYPE IN ('資產','負債','業主權益') THEN T.TYP_NO ELSE '99' END, "
            "CASE WHEN T.TYP_MAJOR_TYPE IN ('資產','負債','業主權益') THEN T.TYP_NAME ELSE '本期損益' END, "
            "CASE WHEN T.TYP_MAJOR_TYPE IN ('資產','負債','業主權益') THEN SUBSTRING(C.ACT_NO,1,4) ELSE '3353' END, "
            "CASE WHEN T.TYP_MAJOR_TYPE IN ('資產','負債','業主權益') THEN C.ACT_NAME ELSE '本期損益' END "
            "HAVING SUM(D.JND_AMOUNT)<>0"
        ),
        "srp_orderby": "ORDER BY TYP_NO, ACT_NO",
        "fields": [
            {"srf_fieldname": "JNL_DATE", "srf_tablealias": "M", "srf_dispname": "查詢日期區間",
             "srf_datatype": "Date", "srf_querytype": "Range", "srf_disporder": 1},
        ],
    },
]


def main():
    """比照真正的「移轉腳本」慣例：SRP_ID 一律沿用既有的（找不到才配新號），
    這樣其他地方（menuConfig.js 的 /report/view/{srp_id} 連結）才能安心寫死 ID。"""
    with get_conn() as conn:
        cur = conn.cursor()
        for rpt in REPORTS:
            cur.execute("SELECT SRP_ID FROM TBLSYSREPORT WHERE SRP_CODE=%(c)s", {"c": rpt["srp_code"]})
            existing = cur.fetchone()
            if existing:
                srp_id = existing[0]
                cur.execute("DELETE FROM TBLSYSREPORTFIELD WHERE SRP_ID=%(id)s", {"id": srp_id})
                cur.execute(
                    """UPDATE TBLSYSREPORT SET SRP_NAME=%(name)s,SRP_DESCRIPTION=%(desc)s,
                           SRP_SELECT=%(select)s,SRP_WHERE=%(where)s,SRP_GROUPBY=%(groupby)s,SRP_ORDERBY=%(orderby)s
                       WHERE SRP_ID=%(id)s""",
                    {
                        "id": srp_id, "name": rpt["srp_name"], "desc": rpt["srp_description"],
                        "select": rpt["srp_select"], "where": rpt["srp_where"],
                        "groupby": rpt["srp_groupby"], "orderby": rpt["srp_orderby"],
                    },
                )
                print(f"[{rpt['srp_code']}] 更新既有定義 SRP_ID={srp_id}（ID 不變）")
            else:
                cur.execute("SELECT COALESCE(MAX(SRP_ID),0)+1 FROM TBLSYSREPORT")
                srp_id = cur.fetchone()[0]
                cur.execute(
                    """INSERT INTO TBLSYSREPORT
                           (SRP_ID,SRP_CODE,SRP_NAME,SRP_DESCRIPTION,SRP_SELECT,SRP_WHERE,SRP_GROUPBY,SRP_ORDERBY)
                       VALUES (%(id)s,%(code)s,%(name)s,%(desc)s,%(select)s,%(where)s,%(groupby)s,%(orderby)s)""",
                    {
                        "id": srp_id, "code": rpt["srp_code"], "name": rpt["srp_name"],
                        "desc": rpt["srp_description"], "select": rpt["srp_select"],
                        "where": rpt["srp_where"], "groupby": rpt["srp_groupby"], "orderby": rpt["srp_orderby"],
                    },
                )
                print(f"[{rpt['srp_code']}] 新建定義 SRP_ID={srp_id}")
            for i, f in enumerate(rpt["fields"], start=1):
                controltype = "Date" if f["srf_datatype"] == "Date" else "Edit"
                cur.execute(
                    """INSERT INTO TBLSYSREPORTFIELD
                           (SRP_ID,SRF_SEQNO,SRF_FIELDNAME,SRF_TABLEALIAS,SRF_DISPNAME,SRF_DISPORDER,
                            SRF_DATATYPE,SRF_CONTROLTYPE,SRF_QUERYTYPE,SRF_ISMUSTCRITERIA,SRF_ISWHERE,
                            SRF_ISSORT,SRF_SORTDEC)
                       VALUES (%(srp_id)s,%(seq)s,%(fieldname)s,%(alias)s,%(dispname)s,%(disporder)s,
                               %(datatype)s,%(controltype)s,'Range',false,true,false,false)""",
                    {
                        "srp_id": srp_id, "seq": i, "fieldname": f["srf_fieldname"],
                        "alias": f["srf_tablealias"], "dispname": f["srf_dispname"],
                        "disporder": f["srf_disporder"], "datatype": f["srf_datatype"],
                        "controltype": controltype,
                    },
                )
            print(f"[{rpt['srp_code']}] 建立完成 SRP_ID={srp_id}，{len(rpt['fields'])} 個查詢欄位")


if __name__ == "__main__":
    main()

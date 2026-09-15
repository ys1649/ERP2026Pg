"""手動重建 From_AcntCash.dfm 的 ppReport 版面，寫回 GL_CASH（SRP_ID=66）的 SRP_REPORTFILE。
做法跟其他報表的 build_gl_*_layout.py 一樣。這份報表的特殊之處：

- ppGroup1（BreakName=ACT_NO, NewPage=True）在舊系統理論上支援多科目分頁，但 setSQL() 事後
  在 WHERE 硬加了 ACT_NO='1111'，永遠只會有一個科目、一個分組，NewPage 在這裡沒有實際效果，
  不需要處理（跟日記帳「每天強制換頁」那種真的會被觸發的情況不同）。
- GroupHeaderBand1 有實際內容（科目編號+科目名稱置頂），GroupFooterBand 是空的。
- ppDBCalc1（餘額欄）在舊系統是放在 Detail band 裡的「逐列累加」running total
  （ResetGroup=ppGroup1），Stimulsoft 沒有等效的「逐列累加」欄位機制，改成在後端 SQL 用
  SUM() OVER (...ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 算好、當成一般查詢欄位
  （balance）回傳，版面這裡就是單純 DBText 繫結，不是 DBCalc。

可重複執行。
"""
import sys
import os
import json

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", ".claude", "skills", "convert-sysreport-layout"))

from database import get_conn  # noqa: E402
from rb_to_stimulsoft import convert_report  # noqa: E402

SRP_ID = 66


def band(cls, name, mm_height, children):
    return {"class": cls, "name": name, "props": {"mmHeight": mm_height}, "children": children}


def leaf(cls, name, props):
    return {"class": cls, "name": name, "props": props, "children": []}


def label(name, caption, left, top, width, height=5080, size=12, bold=False, align=None):
    props = {
        "Caption": caption, "mmLeft": left, "mmTop": top, "mmWidth": width, "mmHeight": height,
        "Font.Size": size, "Font.Color": "clBlack",
    }
    if bold:
        props["Font.Style"] = "[fsBold]"
    if align:
        props["TextAlignment"] = align
    return leaf("TppLabel", name, props)


def dbtext(name, field, left, top, width, height=4233, size=10, bold=False, align=None,
           display_format=None, pipeline="ppDBPipeline1"):
    props = {
        "DataField": field, "DataPipelineName": pipeline,
        "mmLeft": left, "mmTop": top, "mmWidth": width, "mmHeight": height,
        "Font.Size": size, "Font.Color": "clBlack",
    }
    if bold:
        props["Font.Style"] = "[fsBold]"
    if align:
        props["TextAlignment"] = align
    if display_format:
        props["DisplayFormat"] = display_format
    return leaf("TppDBText", name, props)


def line(name, top, height=1852, left=0, width=203200):
    return leaf("TppLine", name, {"mmLeft": left, "mmTop": top, "mmWidth": width, "mmHeight": height})


def sysvar(name, vartype, left, top, width, height=5080, size=12):
    return leaf("TppSystemVariable", name, {
        "VarType": vartype, "mmLeft": left, "mmTop": top, "mmWidth": width, "mmHeight": height,
        "Font.Size": size, "Font.Color": "clBlack",
    })


def build_tree():
    header = band("TppHeaderBand", "HeaderBand1", 44450, [
        dbtext("LblCorName", "cor_name", 794, 11113, 201084, size=12, align="taCentered", pipeline="plTemplate"),
        label("Label8", "製表日期：", 9790, 21696, 21167),
        sysvar("SystemVariable1", "vtPageNo", 32279, 21696, 24871),
        label("Label9", "頁數：", 159015, 21696, 12700),
        sysvar("SystemVariable2", "vtPageSetDesc", 172773, 21696, 23283),
        line("Line2", 34660),
        label("Label1", "現金簿", 92076, 21696, 12700, align="taCentered"),
        label("Label5", "傳票期間：", 9790, 28310, 21167),
        dbtext("LblPeriod", "dt_range", 32279, 28310, 23283, size=12, pipeline="plTemplate"),
        label("Label2", "日期", 9790, 36777, 8467, align="taCentered"),
        label("Label3", "餘額", 187855, 36777, 8467, align="taCentered"),
        label("Label6", "借方金額", 129646, 36777, 16933),
        label("Label7", "貸方金額", 154517, 36777, 16933),
        label("Label4", "摘要", 70115, 36777, 8467, align="taRightJustified"),
        label("Label10", "傳票編號", 33602, 36777, 16933),
        line("Line1", 41010, height=2117),
    ])

    detail = band("TppDetailBand", "DetailBand1", 6615, [
        dbtext("DBText3", "jnl_date", 9790, 1323, 20902, display_format="YYYY/MM/DD"),
        dbtext("DBText5", "jnl_no", 33602, 1323, 27517),
        dbtext("DBText7", "jnd_desc", 64029, 1323, 59267),
        dbtext("DBText4", "debit", 124619, 1323, 21960, align="taRightJustified", display_format="#,0;-#,0"),
        dbtext("DBText6", "credit", 149490, 1323, 21960, align="taRightJustified", display_format="#,0;-#,0"),
        dbtext("DBCalc1", "balance", 174361, 1323, 21960, align="taRightJustified", display_format="#,0;-#,0"),
    ])

    footer = band("TppFooterBand", "FooterBand1", 13229, [])

    group1_header = band("TppGroupHeaderBand", "GroupHeaderBand1", 9260, [
        dbtext("DBText1", "act_no", 9790, 3440, 20902, size=12, bold=True),
        dbtext("DBText2", "act_name", 33602, 3440, 51065, size=12, bold=True),
        line("Line3", 7142, height=2117),
    ])
    group1_footer = band("TppGroupFooterBand", "GroupFooterBand1", 0, [])
    group1 = {"class": "TppGroup", "name": "Group1", "props": {"BreakName": "ACT_NO"},
              "children": [group1_header, group1_footer]}

    root = {
        "class": "TppReport", "name": "ppReport",
        "props": {
            "PrinterSetup.mmPaperWidth": 215900, "PrinterSetup.mmPaperHeight": 279401,
            "PrinterSetup.mmMarginLeft": 6350, "PrinterSetup.mmMarginRight": 6350,
        },
        "children": [header, detail, footer, group1],
    }
    return root


NUMBER_FORMAT_PATCHES = {
    "DBText4": "{root.debit.ToString(\"N0\")}",
    "DBText6": "{root.credit.ToString(\"N0\")}",
    "DBCalc1": "{root.balance.ToString(\"N0\")}",
}


def apply_number_formats(report):
    patched = 0
    for band_ in report["Pages"]["0"]["Components"].values():
        for comp in band_.get("Components", {}).values():
            new_value = NUMBER_FORMAT_PATCHES.get(comp.get("Name"))
            if new_value:
                comp["Text"]["Value"] = new_value
                comp["Type"] = "Expression"
                patched += 1
    return patched


def main():
    root_columns = [
        ("jnl_date", 1114), ("jnl_no", 25), ("jnd_seqno", 23), ("jnd_desc", 25),
        ("act_no", 25), ("act_name", 25), ("amount", 701),
        ("debit", 701), ("credit", 701), ("balance", 701),
    ]
    report, warnings = convert_report(build_tree(), "GL_CASH", "現金簿", root_columns)

    srpmeta_cols = report["Dictionary"]["DataSources"]["0"]["Columns"]

    def add_srpmeta_col(name):
        idx = str(len(srpmeta_cols))
        srpmeta_cols[idx] = {"Name": name, "NameInSource": name, "Alias": name, "Type": "System.String"}

    add_srpmeta_col("dt_range")
    add_srpmeta_col("cor_name")

    patched = apply_number_formats(report)
    print(f"補上數字格式：{patched} 個欄位")

    if warnings:
        print("警告：")
        for w in warnings:
            print(" -", w)

    report_json = json.dumps(report, ensure_ascii=False)
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute("UPDATE TBLSYSREPORT SET SRP_REPORTFILE=%(rf)s WHERE SRP_ID=%(id)s",
                    {"rf": report_json, "id": SRP_ID})
        if cur.rowcount == 0:
            raise SystemExit(f"SRP_ID={SRP_ID} 不存在")
    print(f"已寫入 SRP_ID={SRP_ID} 的 SRP_REPORTFILE（{len(report_json)} 字元）")


if __name__ == "__main__":
    main()

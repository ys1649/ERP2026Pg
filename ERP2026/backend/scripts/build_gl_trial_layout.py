"""手動重建 Form_AcntTrialBalance.dfm 的 ppReport 版面，寫回 GL_TRIAL（SRP_ID=65）的
SRP_REPORTFILE。做法跟其他報表的 build_gl_*_layout.py 一樣。這份報表的特殊之處：

- 有一個 ppSummaryBand1（BandType=7，報表層級的總計，不是分組小計），裡面的 DBCalc1/2/3
  分別是 DEBIT/CREDIT/AMOUNT 三個欄位的總和，AMOUNT 總和就是「借貸差額」（帳本平衡的話應該是
  0）。rb_to_stimulsoft.py 把 TppSummaryBand 當成跟 TppFooterBand 一樣處理（同樣轉成
  Stimulsoft 的頁尾類 band），DBCalc 產生的 {Sum(root.欄位)} 運算式本身沒有綁定特定分組，
  放在報表最外層的頁尾自然就是整份報表的總計，不需要額外的 ResetGroup 設定。

可重複執行。
"""
import sys
import os
import json

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", ".claude", "skills", "convert-sysreport-layout"))

from database import get_conn  # noqa: E402
from rb_to_stimulsoft import convert_report  # noqa: E402

SRP_ID = 65


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


def dbcalc(name, field, left, top, width, height=4233, size=10, bold=False,
           display_format=None, pipeline="ppDBPipeline1"):
    """報表層級總計，不屬於任何分組，所以不帶 ResetGroup（rb_to_stimulsoft.py 產生的
    {Sum(root.field)} 運算式本身就是不分組的整份報表總和）。"""
    props = {
        "DataField": field, "DataPipelineName": pipeline, "DBCalcType": "dcSum",
        "mmLeft": left, "mmTop": top, "mmWidth": width, "mmHeight": height,
        "Font.Size": size, "Font.Color": "clBlack", "TextAlignment": "taRightJustified",
    }
    if bold:
        props["Font.Style"] = "[fsBold]"
    if display_format:
        props["DisplayFormat"] = display_format
    return leaf("TppDBCalc", name, props)


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
        label("Label1", "試算表", 92076, 21696, 12700, align="taCentered"),
        label("Label5", "查詢期間：", 9790, 28310, 21167),
        dbtext("LblRange", "dt_range", 32279, 28310, 163513, size=12, pipeline="plTemplate"),
        label("Label10", "科目編號", 13229, 37306, 16933),
        label("Label4", "科目名稱", 49477, 37042, 16933, align="taRightJustified"),
        label("Label6", "借方餘額", 129646, 36777, 16933),
        label("Label7", "貸方餘額", 168275, 37306, 16933),
        line("Line1", 41010, height=2117),
    ])

    detail = band("TppDetailBand", "DetailBand1", 6615, [
        dbtext("DBText5", "act_no", 13229, 1323, 27517),
        dbtext("DBText7", "act_name", 49477, 1323, 59267),
        dbtext("DBText4", "debit", 117475, 1323, 29104, align="taRightJustified", display_format="#,0.000"),
        dbtext("DBText6", "credit", 156104, 1323, 29104, align="taRightJustified", display_format="#,0.000"),
    ])

    footer = band("TppFooterBand", "FooterBand1", 3704, [])

    summary = band("TppSummaryBand", "SummaryBand1", 24871, [
        line("Line3", 1323, height=3969),
        label("Label2", "合計", 94456, 4233, 19050, size=10),
        dbcalc("DBCalc1", "debit", 117475, 4233, 29104, display_format="#,0.000"),
        dbcalc("DBCalc2", "credit", 156104, 4233, 29104, display_format="#,0.000"),
        line("Line4", 16404, height=2117, left=87313, width=103717),
        label("Label3", "借貸差額", 94456, 19050, 19050, size=10),
        dbcalc("DBCalc3", "amount", 117475, 19050, 29104, display_format="#,0.000"),
    ])

    root = {
        "class": "TppReport", "name": "ppReport",
        "props": {
            "PrinterSetup.mmPaperWidth": 215900, "PrinterSetup.mmPaperHeight": 279401,
            "PrinterSetup.mmMarginLeft": 6350, "PrinterSetup.mmMarginRight": 6350,
        },
        "children": [header, detail, footer, summary],
    }
    return root


NUMBER_FORMAT_PATCHES = {
    "DBText4": "{root.debit.ToString(\"N3\")}",
    "DBText6": "{root.credit.ToString(\"N3\")}",
    "DBCalc1": "{Sum(root.debit).ToString(\"N3\")}",
    "DBCalc2": "{Sum(root.credit).ToString(\"N3\")}",
    "DBCalc3": "{Sum(root.amount).ToString(\"N3\")}",
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
        ("act_no", 25), ("act_name", 25), ("debit", 701), ("credit", 701), ("amount", 701),
    ]
    report, warnings = convert_report(build_tree(), "GL_TRIAL", "試算表", root_columns)

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

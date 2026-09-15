"""手動重建 Form_AcntBalance.dfm 的 ppReport 版面，轉成 rb_to_stimulsoft.convert_report() 吃的
{class,name,props,children} 樹，寫回 GL_BALANCE（SRP_ID=63）的 SRP_REPORTFILE。做法跟
build_gl_asset_layout.py/build_gl_income_layout.py 完全一樣。這份報表最簡單：沒有分組、沒有
小計，單純一個 Detail band 列出科目類別/科目編號/科目名稱/餘額。

可重複執行。
"""
import sys
import os
import json

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", ".claude", "skills", "convert-sysreport-layout"))

from database import get_conn  # noqa: E402
from rb_to_stimulsoft import convert_report  # noqa: E402

SRP_ID = 63


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
        label("Label1", "科目餘額表", 87843, 21696, 21167, align="taCentered"),
        label("Label5", "終止期間：", 9790, 28310, 21167),
        # 原本 ppLblPeriod 是 Pascal 在 setSQL 裡填 dt1.Text 的靜態 Label，這裡改綁 srpmeta.dt_end。
        # 前端把值格式化成「2025年12月31日」這種中文日期字串再傳進來，不是 ISO 格式——
        # Stimulsoft 的 DataSet.readJson() 只要值長得像日期（連中線、斜線都算）就會自動轉成
        # 內部 DateTime（還牽扯到時區換算，會跟原始輸入差一天），中文日期格式不會命中它內建的
        # 日期格式清單，能穩定維持字串型別，所以這裡直接綁裸欄位。
        dbtext("LblPeriod", "dt_end", 32279, 28310, 43392, size=12, pipeline="plTemplate"),
        line("Line2", 34660),
        label("Label101", "科目類別", 9525, 37042, 16933),
        label("Label10", "科目編號", 59002, 37306, 16933),
        label("Label4", "科目名稱", 95250, 37042, 16933, align="taRightJustified"),
        label("Label6", "餘額", 181505, 37042, 8467),
        line("Line1", 41010, height=2117),
    ])

    detail = band("TppDetailBand", "DetailBand1", 6615, [
        dbtext("DBText1", "typ_name", 8996, 1323, 48683),
        dbtext("DBText5", "act_no", 59002, 1588, 27517),
        dbtext("DBText7", "act_name", 95250, 1588, 59267),
        dbtext("DBText4", "balance", 160867, 1588, 29104, align="taRightJustified", display_format="#,0.000"),
    ])

    footer = band("TppFooterBand", "FooterBand1", 3704, [])

    root = {
        "class": "TppReport", "name": "ppReport",
        "props": {
            "PrinterSetup.mmPaperWidth": 215900, "PrinterSetup.mmPaperHeight": 279401,
            "PrinterSetup.mmMarginLeft": 6350, "PrinterSetup.mmMarginRight": 6350,
        },
        "children": [header, detail, footer],
    }
    return root


# rb_to_stimulsoft.py 不認得 DisplayFormat 屬性，比照其他報表的做法，對 BALANCE 欄位補上
# C# 數字格式字串（.ToString(...)），直接後製修改產生好的 JSON。BALANCE 是唯一的金額欄位，
# 舊系統本身就是 3 位小數（'#,0.000'），不是常見的 0 位小數，原樣保留。
NUMBER_FORMAT_PATCHES = {
    "DBText4": "{root.balance.ToString(\"N3\")}",
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
        ("typ_major_type", 25), ("typ_no", 25), ("typ_name", 25),
        ("act_no", 25), ("act_name", 25), ("balance", 701),
    ]
    report, warnings = convert_report(build_tree(), "GL_BALANCE", "科目餘額表", root_columns)

    srpmeta_cols = report["Dictionary"]["DataSources"]["0"]["Columns"]

    def add_srpmeta_col(name):
        idx = str(len(srpmeta_cols))
        srpmeta_cols[idx] = {"Name": name, "NameInSource": name, "Alias": name, "Type": "System.String"}

    add_srpmeta_col("dt_end")
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

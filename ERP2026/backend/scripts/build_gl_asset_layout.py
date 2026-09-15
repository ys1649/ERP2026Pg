"""手動重建 Form_Acnt_Asset.dfm 的 ppReport 版面（逐一從 .dfm 原始碼抄出精確的 mmLeft/mmTop/
mmWidth/mmHeight/Caption/DataField 等屬性），轉成一棵 dfm_parser.py 風格的 {class,name,props,
children} 樹，餵給 convert-sysreport-layout skill 現成、已驗證過的 rb_to_stimulsoft.convert_report()
去產生 Stimulsoft JSON，寫回 GL_ASSET（SRP_ID=69）的 SRP_REPORTFILE。

之所以不直接跑 convert-sysreport-layout 整支 skill：那支是從 MSSQL TBLSYSREPORT.SRP_REPORTFILE
（二進位 image blob）反解析，GL_ASSET 是這次新建的報表，MSSQL 那邊根本沒有這筆資料，沒有 blob可解。
但 Form_Acnt_Asset.pas 本身是「設計期」的 .dfm（文字格式，直接宣告 ppReport 元件樹），所以資訊本來
就在，只是要手動抄出來、不是寫一個通用文字 DFM parser（這份 DFM 一次性讀完就有全部數值了）。

可重複執行。
"""
import sys
import os
import json

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", ".claude", "skills", "convert-sysreport-layout"))

from database import get_conn  # noqa: E402
from rb_to_stimulsoft import convert_report  # noqa: E402

SRP_ID = 69


def band(cls, name, mm_height, children):
    return {"class": cls, "name": name, "props": {"mmHeight": mm_height}, "children": children}


def leaf(cls, name, props):
    return {"class": cls, "name": name, "props": props, "children": []}


def label(name, caption, left, top, width, height=5080, size=12, bold=False, align=None, transparent=True):
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


def dbcalc(name, field, left, top, width, reset_group, height=4233, size=10, bold=False,
           display_format=None, pipeline="ppDBPipeline1"):
    props = {
        "DataField": field, "DataPipelineName": pipeline, "DBCalcType": "dcSum",
        "mmLeft": left, "mmTop": top, "mmWidth": width, "mmHeight": height,
        "Font.Size": size, "Font.Color": "clBlack", "TextAlignment": "taRightJustified",
        "ResetGroup": reset_group,
    }
    if bold:
        props["Font.Style"] = "[fsBold]"
    if display_format:
        props["DisplayFormat"] = display_format
    return leaf("TppDBCalc", name, props)


def line(name, top, height=1852):
    return leaf("TppLine", name, {"mmLeft": 0, "mmTop": top, "mmWidth": 203200, "mmHeight": height})


def sysvar(name, vartype, left, top, width, height=5080, size=12):
    return leaf("TppSystemVariable", name, {
        "VarType": vartype, "mmLeft": left, "mmTop": top, "mmWidth": width, "mmHeight": height,
        "Font.Size": size, "Font.Color": "clBlack",
    })


def build_tree():
    header = band("TppHeaderBand", "HeaderBand1", 43127, [
        # 公司名稱（原本 ppLblCorName 在 Panel1 裡是靜態文字，這裡改綁 srpmeta.cor_name 顯示實際公司名稱）
        dbtext("LblCorName", "cor_name", 794, 11113, 201084, size=12, align="taCentered", pipeline="plTemplate"),
        label("Label5", "傳票截止日期：", 9790, 22225, 25400),
        # 原本 ppLblEndDate 是 Pascal 在 setSQL 裡動態填字串，這裡改綁 srpmeta.dt_end。
        # 前端（AssetLiabilityStatement.jsx）把值格式化成「2025年12月31日」這種中文日期字串
        # 再傳進來，不是傳 ISO 格式（"2025-12-31"）——Stimulsoft 的 DataSet.readJson() 不管
        # Dictionary 宣告的欄位型別是什麼，只要值長得像日期（連中線、斜線都算）就會自動轉成
        # 內部 DateTime（還牽扯到時區換算，會跟原始輸入差一天），中文日期格式不會命中它內建的
        # 日期格式清單，能穩定維持原本的字串不被亂轉型，所以這裡直接綁裸欄位，不需要
        # .ToString(...) 額外格式化。
        # 寬度從原本的 21167（原本裝西式數字日期 "2026/9/15" 剛好夠）放寬到 42000——
        # 中文日期字串「2026年09月15日」比原本的格式長，原寬度會被裁切
        dbtext("LblEndDate", "dt_end", 35983, 22225, 42000, size=12, pipeline="plTemplate"),
        label("Label8", "製表日期：", 9790, 28046, 21167),
        sysvar("SystemVariable1", "vtPageNo", 35983, 28046, 21167),
        label("Label9", "頁數：", 159015, 28046, 12700),
        sysvar("SystemVariable2", "vtPageSetDesc", 172773, 28046, 23283),
        line("Line2", 33867),
        label("Label1", "資產負債表", 87842, 28046, 21167, align="taCentered"),
        label("Label2", "類別名稱", 16669, 37571, 16933, align="taCentered"),
        label("Label3", "本期金額", 143934, 37571, 16933, align="taCentered"),
        label("Label4", "百分比", 169069, 37571, 12700, align="taCentered"),
        line("Line1", 39158, height=3969),
    ])

    detail = band("TppDetailBand", "DetailBand1", 6615, [
        dbtext("DBText3", "typ_name", 37835, 529, 42069),
        dbtext("DBText4", "act_name", 82286, 529, 43656),
        dbtext("DBText5", "amount", 126471, 529, 36777, align="taRightJustified", display_format="#,0;-#,0"),
        dbtext("DBText6", "rate", 166952, 529, 17198, align="taRightJustified", display_format="0.000 \\%"),
    ])

    footer = band("TppFooterBand", "FooterBand1", 13229, [])

    group1_header = band("TppGroupHeaderBand", "GroupHeaderBand1", 7408, [
        dbtext("DBText1", "grp", 16140, 1588, 54504, size=12, bold=True),
    ])
    group1_footer = band("TppGroupFooterBand", "GroupFooterBand1", 12965, [
        dbcalc("DBCalc2", "amount", 126471, 2646, 36777, reset_group="ppGroup1", display_format="#,0;-#,0"),
        dbtext("DBText8", "grp", 16140, 2646, 37835, size=12, bold=True),
        label("Label7", "合計", 117211, 2646, 8551, size=12, bold=True),
        line("Line3", 7938, height=1588),
    ])
    group1 = {
        "class": "TppGroup", "name": "Group1",
        "props": {"BreakName": "GRP"},
        "children": [group1_header, group1_footer],
    }

    group2_header = band("TppGroupHeaderBand", "GroupHeaderBand2", 7673, [
        dbtext("DBText2", "typ_major_type", 23019, 794, 47096),
    ])
    group2_footer = band("TppGroupFooterBand", "GroupFooterBand2", 13758, [
        dbcalc("DBCalc1", "amount", 126471, 3440, 36777, reset_group="ppGroup2", display_format="#,0;-#,0"),
        dbtext("DBText7", "typ_major_type", 82021, 3440, 33338, bold=True, align="taRightJustified"),
        label("Label6", "小計", 115888, 3440, 7197, bold=True),
        line("Line5", 1588, height=1588),
        dbcalc("DBCalc3", "rate", 166952, 3175, 17198, reset_group="ppGroup2", display_format="0 \\%"),
    ])
    group2 = {
        "class": "TppGroup", "name": "Group2",
        "props": {"BreakName": "TYP_MAJOR_TYPE"},
        "children": [group2_header, group2_footer],
    }

    root = {
        "class": "TppReport", "name": "ppReport",
        "props": {
            "PrinterSetup.mmPaperWidth": 215900, "PrinterSetup.mmPaperHeight": 279401,
            "PrinterSetup.mmMarginLeft": 6350, "PrinterSetup.mmMarginRight": 6350,
        },
        "children": [header, detail, footer, group1, group2],
    }
    return root


# rb_to_stimulsoft.py 目前不認得 DisplayFormat 屬性（轉換出來的 Text.Value 一律是裸的
# {root.欄位}，沒有千分位/百分比符號）——這裡比照它自己對日期欄位的做法（.ToString(...) 包一層
# Type=Expression），對金額/百分比欄位補上對應的 C# 數字格式字串，直接後製修改產生好的 JSON，
# 不去動共用的 rb_to_stimulsoft.py（那支要顧到其餘 52+ 份報表，不想因為這次的需求動到它）。
NUMBER_FORMAT_PATCHES = {
    # component Name -> (欄位, 格式化後的 Text.Value)
    "DBText5": "{root.amount.ToString(\"N0\")}",
    "DBText6": "{root.rate.ToString(\"N3\")} %",
    "DBCalc1": "{Sum(root.amount).ToString(\"N0\")}",
    "DBCalc2": "{Sum(root.amount).ToString(\"N0\")}",
    "DBCalc3": "{Sum(root.rate).ToString(\"N0\")} %",
}


def apply_number_formats(report):
    patched = 0
    for band in report["Pages"]["0"]["Components"].values():
        for comp in band.get("Components", {}).values():
            new_value = NUMBER_FORMAT_PATCHES.get(comp.get("Name"))
            if new_value:
                comp["Text"]["Value"] = new_value
                comp["Type"] = "Expression"
                patched += 1
    return patched


# rb_to_stimulsoft.py 產生的 StiGroupHeaderBand 沒有指定 SortDirection，Stimulsoft 的預設值是
# Ascending——會依「群組 Condition 欄位的值本身」（這裡是 {root.grp}/{root.typ_major_type}的文字）
# 重新排序群組，而不是照資料來源（SQL）傳回的列順序分組。這份報表的分組順序必須完全比照 SQL 的
# ORDER BY TYP_NO,ACT_NO（先「資產」、後「負債及業主權益」），但「負債及業主權益」的 Unicode
# 開頭（負=U+8CA0）小於「資產」（資=U+8CC7），Ascending 排序會把它排到前面，導致跟 SQL 順序相反。
# 用 Designer 現場修改 sortDirection 屬性、重新序列化 JSON，確認對應的 JSON 屬性是
# "SortDirection": "None"（此時 Stimulsoft 不會重新排序，直接照資料來源的列順序分組）。
GROUP_HEADER_BAND_NAMES = ["GroupHeaderBand1", "GroupHeaderBand2"]


def apply_group_no_sort(report):
    patched = 0
    for band in report["Pages"]["0"]["Components"].values():
        if band.get("Name") in GROUP_HEADER_BAND_NAMES:
            band["SortDirection"] = "None"
            patched += 1
    return patched


def main():
    root_columns = [
        ("grp", 25), ("typ_major_type", 25), ("typ_no", 25), ("typ_name", 25),
        ("act_no", 25), ("act_name", 25), ("amount", 701), ("rate", 701),
    ]
    report, warnings = convert_report(build_tree(), "GL_ASSET", "資產負債表", root_columns)

    # srpmeta 這次額外綁了 cor_name/dt_end 兩個欄位（比照舊系統 ppLblCorName/ppLblEndDate 在
    # Pascal setSQL() 裡動態填值的行為），convert_report() 目前只知道固定 4 欄，這裡手動補上。
    srpmeta_cols = report["Dictionary"]["DataSources"]["0"]["Columns"]
    next_idx = str(len(srpmeta_cols))
    srpmeta_cols[next_idx] = {"Name": "cor_name", "NameInSource": "cor_name", "Alias": "cor_name", "Type": "System.String"}
    srpmeta_cols[str(len(srpmeta_cols))] = {"Name": "dt_end", "NameInSource": "dt_end", "Alias": "dt_end", "Type": "System.String"}

    patched = apply_number_formats(report)
    print(f"補上數字格式（千分位/百分比）：{patched} 個欄位")

    sort_patched = apply_group_no_sort(report)
    print(f"關閉群組自動排序（SortDirection=None，改依 SQL 傳回順序分組）：{sort_patched} 個群組")

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

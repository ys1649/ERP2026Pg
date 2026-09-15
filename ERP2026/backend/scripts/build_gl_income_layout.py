"""手動重建 Form_AcntIncomeStament.dfm 的 ppReport 版面（逐一從 .dfm 原始碼抄出精確的 mmLeft/mmTop/
mmWidth/mmHeight/Caption/DataField 等屬性），轉成 dfm_parser.py 風格的 {class,name,props,children}
樹，餵給 convert-sysreport-layout skill 現成、已驗證過的 rb_to_stimulsoft.convert_report() 去產生
Stimulsoft JSON，寫回 GL_INCOME（SRP_ID=68）的 SRP_REPORTFILE。做法跟 build_gl_asset_layout.py
（資產負債表）完全一樣，這裡不重複解釋原因，只列這份報表特有的差異：

- 只有一層分組（ppGroup1，BreakName=TYP_MAJOR_TYPE），不像資產負債表有兩層。
- 舊系統在 ppGroupFooterBand1BeforeGenerate 事件裡，依「這個分類是不是成本/費用/營業外收支/所得稅」
  動態決定要不要顯示 Lbl1（毛利/淨利/稅前損益/本期損益 等文字）+Lbl2（累計金額），Stimulsoft 版面
  沒有等效的「BeforeGenerate 事件」機制，改成在 Lbl1/Lbl2 的 Text 綁一個依 {root.typ_major_type}
  判斷的巢狀三元運算式（已在瀏覽器 Console 用 Stimulsoft.Base.StiCSharpScriptParser 實測支援
  三元運算子），Lbl2 引用的 4 個累計金額（毛利/淨利/稅前損益/本期損益）是後端 /api/gl-reports/income
  每次查詢當下算出來的，透過 srpmeta DataSource 帶進來（比照資產負債表的 cor_name/dt_end 做法）。
  簡化取捨：原本「非累計小計分類要整段隱藏（Visible=false）」的行為簡化成「該分類 Lbl1/Lbl2 文字
  留空」，分隔線 LineLong 一律顯示（不會誤導財務數字，純粹排版差異，跟 SortDirection 這種會讓
  數字順序錯誤的問題性質不同）。
- StiGroupHeaderBand 的 SortDirection 直接設成 None（資產負債表是事後才發現這個屬性預設
  Ascending 會讓分組跟 SQL 的 ORDER BY 不一致，這裡從一開始就設定，不必再犯一次）。

可重複執行。
"""
import sys
import os
import json

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", ".claude", "skills", "convert-sysreport-layout"))

from database import get_conn  # noqa: E402
from rb_to_stimulsoft import convert_report  # noqa: E402

SRP_ID = 68


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


def line(name, top, height=1852, left=0, width=197379):
    return leaf("TppLine", name, {"mmLeft": left, "mmTop": top, "mmWidth": width, "mmHeight": height})


def sysvar(name, vartype, left, top, width, height=5080, size=12):
    return leaf("TppSystemVariable", name, {
        "VarType": vartype, "mmLeft": left, "mmTop": top, "mmWidth": width, "mmHeight": height,
        "Font.Size": size, "Font.Color": "clBlack",
    })


def build_tree():
    header = band("TppHeaderBand", "HeaderBand1", 43127, [
        label("Label5", "查詢區間：", 14288, 22225, 21167),
        # 原本 ppDtRange 是 Pascal 在 Button1Click 裡動態組字串填的靜態 Label，這裡改綁 srpmeta.dt_range
        dbtext("LblDtRange", "dt_range", 35983, 22225, 14817, size=12, pipeline="plTemplate"),
        label("Label8", "製表日期：", 14288, 28046, 21167),
        sysvar("SystemVariable1", "vtPageNo", 35983, 28046, 21167),
        label("Label9", "頁數：", 159015, 28046, 12700),
        sysvar("SystemVariable2", "vtPageSetDesc", 172773, 28046, 23283),
        line("Line2", 33867, width=197379),
        dbtext("DBText4", "spr_cor_name", 0, 7938, 197115, size=12, align="taCentered"),
        label("Label1", "損益表", 92075, 28046, 12700, align="taCentered"),
        label("Label2", "類別名稱", 16669, 37571, 16933, align="taCentered"),
        label("Label3", "本期金額", 120915, 37571, 16933, align="taCentered"),
        label("Label4", "百分比", 155575, 37571, 12700, align="taCentered"),
        line("Line1", 39158, height=3969, width=197379),
    ])

    detail = band("TppDetailBand", "DetailBand1", 6615, [
        dbtext("DBText2", "act_name", 33602, 794, 57944),
        dbtext("DBText3", "subtotal", 108744, 794, 29104, align="taRightJustified", display_format="#,0;-#,0"),
        dbtext("DBText5", "rate", 151077, 794, 17198, align="taRightJustified", display_format="0.00 %"),
    ])

    footer = band("TppFooterBand", "FooterBand1", 13229, [])

    group1_header = band("TppGroupHeaderBand", "GroupHeaderBand1", 10054, [
        dbtext("DBText1", "typ_major_type", 16140, 5821, 50800),
    ])
    group1_footer = band("TppGroupFooterBand", "GroupFooterBand1", 11113, [
        line("Line3", 265, height=1058, left=108215, width=74083),
        dbcalc("DBCalc1", "subtotal", 108744, 1058, 29104, reset_group="ppGroup1", display_format="#,0;-#,0"),
        dbtext("DBText6", "typ_major_type", 43921, 1058, 50800, align="taRightJustified"),
        label("Label6", "合計：", 95515, 1058, 10583, size=10, align="taRightJustified"),
        dbcalc("DBCalc2", "rate", 139171, 1058, 29104, reset_group="ppGroup1", display_format="0 %"),
        line("LineLong", 5821, height=2381, width=197379),
        label("Lbl1", "Lbl1", 16140, 6879, 51065, bold=True, size=10),
        label("Lbl2", "Lbl2", 108215, 6879, 29633, bold=True, size=10, align="taRightJustified"),
    ])
    group1 = {"class": "TppGroup", "name": "Group1", "props": {"BreakName": "TYP_MAJOR_TYPE"},
              "children": [group1_header, group1_footer]}

    root = {
        "class": "TppReport", "name": "ppReport",
        "props": {
            "PrinterSetup.mmPaperWidth": 210079, "PrinterSetup.mmPaperHeight": 297127,
            "PrinterSetup.mmMarginLeft": 6350, "PrinterSetup.mmMarginRight": 6350,
        },
        "children": [header, detail, footer, group1],
    }
    return root


# rb_to_stimulsoft.py 目前不認得 DisplayFormat 屬性，比照 build_gl_asset_layout.py 的做法，對
# 金額/百分比欄位補上 C# 數字格式字串（.ToString(...)），直接後製修改產生好的 JSON。
NUMBER_FORMAT_PATCHES = {
    "DBText3": "{root.subtotal.ToString(\"N0\")}",
    "DBText5": "{root.rate.ToString(\"N2\")} %",
    "DBCalc1": "{Sum(root.subtotal).ToString(\"N0\")}",
    "DBCalc2": "{Sum(root.rate).ToString(\"N0\")} %",
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


# 比照資產負債表事後發現的教訓：StiGroupHeaderBand.SortDirection 預設 Ascending 會依群組欄位的
# 文字值重新排序，而不是照 SQL 傳回的列順序分組。這裡只有一層分組（依 TYP_MAJOR_TYPE），且 SQL 的
# SN/ACT_NO 排序已經保證營業收入→成本→費用→營業外收支→所得稅的正確順序，一開始就關閉自動排序。
GROUP_HEADER_BAND_NAMES = ["GroupHeaderBand1"]


def apply_group_no_sort(report):
    patched = 0
    for band_ in report["Pages"]["0"]["Components"].values():
        if band_.get("Name") in GROUP_HEADER_BAND_NAMES:
            band_["SortDirection"] = "None"
            patched += 1
    return patched


# 比照 Form_AcntIncomeStament.pas 的 ppGroupFooterBand1BeforeGenerate：只有「營業成本/營業費用/
# 營業外收入及費用/所得稅費用(或利益)」這 4 個分類的頁尾才顯示累計小計文字+金額（分別對應
# 毛利/淨利/稅前損益/本期損益），「營業收入」分類不顯示。4 個累計金額本身是查詢當下才算得出來的
# （後端 /api/gl-reports/income 回傳），這裡用巢狀三元運算式依目前分組的 {root.typ_major_type}
# 去選對應的 srpmeta 欄位，已在瀏覽器用 Stimulsoft.Base.StiCSharpScriptParser 實測確認三元運算子
# （C# 語法 cond ? a : b）可以正常解析執行。
_TYP_COST, _TYP_EXPENSE, _TYP_NOOP, _TYP_TAX = "營業成本", "營業費用", "營業外收入及費用", "所得稅費用(或利益)"


def _nested_ternary(pairs, else_value):
    expr = else_value
    for cond_value, result in reversed(pairs):
        expr = f'(root.typ_major_type == "{cond_value}") ? {result} : ({expr})'
    return expr


LBL1_EXPR = _nested_ternary(
    [(_TYP_COST, '"毛利"'), (_TYP_EXPENSE, '"淨利"'), (_TYP_NOOP, '"稅前損益"'), (_TYP_TAX, '"本期損益"')],
    '""',
)
LBL2_EXPR = _nested_ternary(
    [
        (_TYP_COST, 'srpmeta.gross_profit.ToString("N0")'),
        (_TYP_EXPENSE, 'srpmeta.net_profit.ToString("N0")'),
        (_TYP_NOOP, 'srpmeta.pretax_profit.ToString("N0")'),
        (_TYP_TAX, 'srpmeta.current_profit.ToString("N0")'),
    ],
    '""',
)

RUNNING_TOTAL_PATCHES = {
    "Lbl1": "{" + LBL1_EXPR + "}",
    "Lbl2": "{" + LBL2_EXPR + "}",
}


def apply_running_totals(report):
    patched = 0
    for band_ in report["Pages"]["0"]["Components"].values():
        for comp in band_.get("Components", {}).values():
            new_value = RUNNING_TOTAL_PATCHES.get(comp.get("Name"))
            if new_value:
                comp["Text"]["Value"] = new_value
                comp["Type"] = "Expression"
                patched += 1
    return patched


def main():
    root_columns = [
        ("sn", 25), ("typ_major_type", 25), ("act_name", 25), ("act_no", 25),
        ("subtotal", 701), ("rate", 701), ("spr_cor_name", 25),
    ]
    report, warnings = convert_report(build_tree(), "GL_INCOME", "損益表", root_columns)

    srpmeta_cols = report["Dictionary"]["DataSources"]["0"]["Columns"]

    def add_srpmeta_col(name, dtype="System.String"):
        idx = str(len(srpmeta_cols))
        srpmeta_cols[idx] = {"Name": name, "NameInSource": name, "Alias": name, "Type": dtype}

    add_srpmeta_col("dt_range")
    add_srpmeta_col("gross_profit", "System.Double")
    add_srpmeta_col("net_profit", "System.Double")
    add_srpmeta_col("pretax_profit", "System.Double")
    add_srpmeta_col("current_profit", "System.Double")

    patched_fmt = apply_number_formats(report)
    print(f"補上數字格式（千分位/百分比）：{patched_fmt} 個欄位")

    patched_sort = apply_group_no_sort(report)
    print(f"關閉群組自動排序（SortDirection=None，改依 SQL 傳回順序分組）：{patched_sort} 個群組")

    patched_total = apply_running_totals(report)
    print(f"補上毛利/淨利/稅前損益/本期損益累計小計運算式：{patched_total} 個欄位")

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

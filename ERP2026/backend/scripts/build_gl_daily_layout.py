"""手動重建 Form_AcntDaily.dfm 的 ppReport 版面，寫回 GL_DAILY（SRP_ID=64）的 SRP_REPORTFILE。
做法跟其他報表的 build_gl_*_layout.py 一樣。這份報表的特殊之處：

- ppGroup1（BreakName=JNL_DATE）的 GroupHeaderBand/GroupFooterBand 都是空的（mmHeight=0，
  沒有任何子元件），這個分組唯一的作用是 TppGroup.NewPage=True——每次 JNL_DATE 換值就強制
  換頁（一天一頁），不是拿來顯示分組標題或小計。Stimulsoft 對應的屬性是
  StiGroupHeaderBand.StartNewPage（用瀏覽器對 GL_ASSET 的 Designer 即時設定屬性後重新序列化
  JSON，實測確認 JSON 屬性名稱是 "StartNewPage": true），一樣用後製 patch 加上去（rb_to_stimulsoft.py
  本身不支援）。
- 沒有排除年度結轉傳票（JNL_BILL_TYPE<>2），這是舊系統原本的行為，日記帳本來就要列出全部傳票。

可重複執行。
"""
import sys
import os
import json

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", ".claude", "skills", "convert-sysreport-layout"))

from database import get_conn  # noqa: E402
from rb_to_stimulsoft import convert_report  # noqa: E402

SRP_ID = 64


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
        label("Label1", "日記帳", 92076, 21696, 12700, align="taCentered"),
        label("Label5", "傳票期間：", 9790, 28310, 21167),
        # 原本 ppLblPeriod 是 Pascal 在 setSQL 裡填 dateFrom+' ~ '+dateTo 的靜態 Label，
        # 這裡改綁 srpmeta.dt_range（"2025-01-01 ~ 2025-12-31" 這種複合字串，不會被 Stimulsoft
        # 誤判成日期自動轉型，可以直接裸綁不用額外處理，跟損益表的 dt_range 同樣道理）
        dbtext("LblPeriod", "dt_range", 32279, 28310, 23283, size=12, pipeline="plTemplate"),
        line("Line2", 34660),
        label("Label2", "日期", 10583, 37835, 7144, size=10, align="taCentered"),
        label("Label10", "傳票編號", 33602, 37835, 14288, size=10),
        label("Label3", "借貸", 60854, 37835, 7144, size=10, align="taRightJustified"),
        label("Label101", "科目編號", 69850, 37835, 14288, size=10),
        label("Label102", "科目名稱", 88106, 37835, 14288, size=10),
        label("Label4", "摘要", 123296, 37835, 7144, size=10, align="taRightJustified"),
        label("Label7", "金額", 191030, 37835, 7144, size=10),
        line("Line1", 41010, height=2117),
    ])

    detail = band("TppDetailBand", "DetailBand1", 6615, [
        dbtext("DBText3", "jnl_date", 9790, 1323, 20902),
        dbtext("DBText5", "jnl_no", 33602, 1323, 25400),
        dbtext("DBText1", "dc", 62971, 1323, 5027),
        dbtext("DBText2", "act_no", 69850, 1323, 17198),
        dbtext("DBText4", "act_name", 88106, 1323, 33602),
        dbtext("DBText7", "jnd_desc", 123296, 1323, 53975),
        dbtext("DBText6", "jnd_amount", 178594, 1323, 20638, align="taRightJustified", display_format="#,0;-#,0"),
    ])

    footer = band("TppFooterBand", "FooterBand1", 13229, [])

    # mmHeight 原本應該是 0（舊系統這兩個 band 完全沒有內容，NewPage=True 是 TppGroup 容器
    # 自己的屬性，跟 band 本身的高度無關）。但 Stimulsoft 沒有獨立的「Group」容器物件，
    # StartNewPage 屬性只能掛在 GroupHeaderBand 本身，實測發現高度=0 的 band 會被 Stimulsoft
    # 的渲染引擎直接跳過、StartNewPage 完全不會生效——這是平台差異，不是邏輯差異，所以给一個
    # 幾乎看不出來的最小高度（1 單位 = 0.01mm）讓 band 不被跳過，藉此換頁功能可以正常運作。
    group1_header = band("TppGroupHeaderBand", "GroupHeaderBand1", 1, [])
    group1_footer = band("TppGroupFooterBand", "GroupFooterBand1", 0, [])
    group1 = {"class": "TppGroup", "name": "Group1", "props": {"BreakName": "JNL_DATE"},
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
    "DBText6": "{root.jnd_amount.ToString(\"N0\")}",
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


GROUP_HEADER_BAND_NAMES = ["GroupHeaderBand1"]


def apply_group_no_sort(report):
    patched = 0
    for band_ in report["Pages"]["0"]["Components"].values():
        if band_.get("Name") in GROUP_HEADER_BAND_NAMES:
            band_["SortDirection"] = "None"
            patched += 1
    return patched


# 比照 Form_AcntDaily.pas 的 ppGroup1（BreakName=JNL_DATE, NewPage=True）：JNL_DATE 換值就強制
# 換頁，不是顯示分組標題/小計。JSON 屬性名稱 "StartNewPage" 是實測 Stimulsoft Designer 得出的
# （rb_to_stimulsoft.py 本身不支援，這裡跟 SortDirection 一樣用後製 patch 補上）。
def apply_group_new_page(report):
    patched = 0
    for band_ in report["Pages"]["0"]["Components"].values():
        if band_.get("Name") in GROUP_HEADER_BAND_NAMES:
            band_["StartNewPage"] = True
            patched += 1
    return patched


def main():
    root_columns = [
        ("jnl_date", 1082), ("jnl_no", 25), ("act_no", 25), ("jnd_desc", 25),
        ("dc", 25), ("act_name", 25), ("jnd_amount", 701),
    ]
    report, warnings = convert_report(build_tree(), "GL_DAILY", "日記帳", root_columns)

    srpmeta_cols = report["Dictionary"]["DataSources"]["0"]["Columns"]

    def add_srpmeta_col(name):
        idx = str(len(srpmeta_cols))
        srpmeta_cols[idx] = {"Name": name, "NameInSource": name, "Alias": name, "Type": "System.String"}

    add_srpmeta_col("dt_range")
    add_srpmeta_col("cor_name")

    patched_fmt = apply_number_formats(report)
    print(f"補上數字格式：{patched_fmt} 個欄位")

    patched_sort = apply_group_no_sort(report)
    print(f"關閉群組自動排序：{patched_sort} 個群組")

    patched_page = apply_group_new_page(report)
    print(f"套用 StartNewPage（每天換頁）：{patched_page} 個群組")

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

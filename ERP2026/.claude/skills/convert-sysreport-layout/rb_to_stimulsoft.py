"""
Best-effort converter: parsed ReportBuilder (RB) binary-DFM tree (see
dfm_parser.py) -> Stimulsoft JSON report definition.

Schema reverse-engineered from real hand-converted reports already saved in
Postgres (ZZ_FM_SHIP_RPT01: single-level group; AA-MG_AR_002_COPY: 2-level
nested group), then verified by round-tripping actual converter output
through Stimulsoft's own Designer (load -> "Check for Issues" -> Preview
with live data). See SKILL.md for what's covered and what isn't.

This produces a first-draft scaffold for the Designer, not a pixel-perfect
port -- band structure, field bindings, grouping and aggregates carry over;
exact spacing/fonts/styling do not, and a handful of RB component types
(charts, multi-column bands) have no Stimulsoft equivalent and are skipped
with a warning rather than guessed at.
"""
import uuid
import time

UNIT_SCALE = 10000.0  # RB mm-properties are in 1/1000 mm; Stimulsoft "Centimeters" unit

# Postgres type OIDs that should be treated as date/timestamp-valued for the
# "strip time, show YYYY/MM/DD" rule below.
DATE_TYPE_CODES = (1082, 1083, 1114, 1184)  # date, time, timestamp, timestamptz


def guid():
    return uuid.uuid4().hex


def cm(rb_value):
    return round((rb_value or 0) / UNIT_SCALE, 4)


def now_ms():
    return int(time.time() * 1000)


# RB TppSystemVariable.VarType -> Stimulsoft system-variable expression.
# Add entries here as new VarType values show up in未對應 warnings.
SYSVAR_MAP = {
    "vtPageNo": "{PageNumber}",
    "vtPageCount": "{TotalPageCount}",
    "vtPageSetDesc": "{PageNofM}",
}

DATE_FORMAT_EXPR = '.ToString("yyyy/MM/dd")'


def props_dict(obj):
    return dict(obj["props"])


def font_str(props):
    size = props.get("Font.Size", 10)
    return f";{size};;"


def color_str(props, key="Font.Color"):
    c = props.get(key, "clBlack")
    return "Black" if c == "clBlack" else str(c).replace("cl", "")


def align_str(props):
    ta = props.get("TextAlignment")
    if ta == "taRightJustified":
        return "Right"
    if ta == "taCentered":
        return "Center"
    return None


def field_expr(src, field, date_fields):
    """Build the '{source.field}' binding expression, formatting date/timestamp
    columns as YYYY/MM/DD (time-of-day dropped) per house style -- the legacy
    RB reports carried an inconsistent mix of DisplayFormat settings (some
    with a time part, most without one at all), so this is driven by the
    actual Postgres column type instead of trusting SRP_REPORTFILE's own
    (often-absent) DisplayFormat property."""
    if src == "root" and field in date_fields:
        return f"{{{src}.{field}{DATE_FORMAT_EXPR}}}"
    return f"{{{src}.{field}}}"


def convert_control(obj, warnings, date_fields=frozenset()):
    cls = obj["class"]
    p = props_dict(obj)
    left, top = cm(p.get("mmLeft", 0)), cm(p.get("mmTop", 0))
    width, height = cm(p.get("mmWidth", 20)), cm(p.get("mmHeight", 5))
    rect = f"{left},{top},{width},{height}"

    if cls == "TppLabel":
        # 真人在 Designer 手動輸入的文字，存出來的 JSON 一律帶 Type=Expression
        # （即使值只是純文字），比照辦理。
        comp = {
            "Ident": "StiText", "Name": obj["name"], "Guid": guid(),
            "ClientRectangle": rect,
            "Interaction": {"Ident": "StiInteraction"},
            "Text": {"Value": p.get("Caption", "")},
            "Type": "Expression",
            "Font": font_str(p),
            "Border": ";;;;;;;solid:" + color_str(p),
            "Brush": "solid:",
            "TextBrush": "solid:" + color_str(p),
        }
    elif cls == "TppDBText":
        pipeline = p.get("DataPipelineName") or p.get("DataPipeline")
        src = "srpmeta" if pipeline == "plTemplate" else "root"
        field = (p.get("DataField") or "").lower()
        is_date = src == "root" and field in date_fields
        comp = {
            "Ident": "StiText", "Name": obj["name"], "Guid": guid(),
            "ClientRectangle": rect,
            "Interaction": {"Ident": "StiInteraction"},
            "Text": {"Value": field_expr(src, field, date_fields)},
            "Font": font_str(p),
            "Border": ";;;;;;;solid:" + color_str(p),
            "Brush": "solid:",
            "TextBrush": "solid:" + color_str(p),
        }
        # 拖曳單一欄位進版面時 Stimulsoft 不會寫 Type；只有值裡帶了方法呼叫
        # （這裡是 .ToString(...) 日期格式化）才需要標成 Expression，不然
        # Stimulsoft 會整串當欄位名查不到，退回印出該值預設的落落長日期時間字串。
        if is_date:
            comp["Type"] = "Expression"
    elif cls == "TppDBCalc":
        field = (p.get("DataField") or "").lower()
        calc_type = p.get("DBCalcType", "dcSum")
        if calc_type == "dcCount" or not field:
            expr = "{Count(root)}"
        elif field in date_fields:
            func = {"dcMax": "Max", "dcMin": "Min"}.get(calc_type, "Max")
            expr = f"{{{func}(root.{field}){DATE_FORMAT_EXPR}}}"
        else:
            func = {"dcSum": "Sum", "dcAvg": "Avg", "dcMax": "Max", "dcMin": "Min"}.get(calc_type, "Sum")
            expr = f"{{{func}(root.{field})}}"
        comp = {
            "Ident": "StiText", "Name": obj["name"], "Guid": guid(),
            "ClientRectangle": rect,
            "Interaction": {"Ident": "StiInteraction"},
            "Text": {"Value": expr},
            "Type": "Expression",
            "Font": font_str(p),
            "Border": ";;;;;;;solid:" + color_str(p),
            "Brush": "solid:",
            "TextBrush": "solid:" + color_str(p),
        }
    elif cls == "TppSystemVariable":
        vartype = p.get("VarType") or "vtPageNo"  # RB 預設值不會寫進屬性樹
        expr = SYSVAR_MAP.get(vartype)
        if expr is None:
            warnings.append(f"TppSystemVariable {obj['name']} VarType={vartype!r} 沒有對應，先留空白")
            expr = ""
        comp = {
            "Ident": "StiText", "Name": obj["name"], "Guid": guid(),
            "ClientRectangle": rect,
            "Interaction": {"Ident": "StiInteraction"},
            "Text": {"Value": expr},
            "Type": "Expression",
            "Font": font_str(p),
            "Border": ";;;;;;;solid:" + color_str(p),
            "Brush": "solid:",
            "TextBrush": "solid:" + color_str(p),
        }
    elif cls == "TppLine":
        comp = {
            "Ident": "StiHorizontalLinePrimitive", "Name": obj["name"], "Guid": guid(),
            "ClientRectangle": rect,
            "Interaction": {"Ident": "StiInteraction"},
            "Size": 2, "StartCap": ";;;", "EndCap": ";;;",
        }
    else:
        warnings.append(f"未知元件類型 {cls}（{obj['name']}），略過")
        return None

    align = align_str(p)
    if align:
        comp["HorAlignment"] = align
    return comp


def convert_band_children(band_obj, warnings, date_fields=frozenset()):
    comps = {}
    idx = 0
    for child in band_obj["children"]:
        c = convert_control(child, warnings, date_fields=date_fields)
        if c is not None:
            comps[str(idx)] = c
            idx += 1
    return comps


def make_band(ident, name, y, height, interaction_kind, warnings, band_obj=None,
              condition=None, data_source=None, content_width=19, date_fields=frozenset()):
    band = {
        "Ident": ident, "Name": name, "Guid": guid(),
        "CanGrow": True,
        "ClientRectangle": f"0,{round(y,4)},{content_width},{round(height,4)}",
        "Interaction": {"Ident": interaction_kind},
        "Border": ";;;;;;;solid:Black",
        "Brush": "solid:",
    }
    if condition is not None:
        band["Condition"] = {"Value": condition}
    if data_source is not None:
        band["DataSourceName"] = data_source
    if band_obj is not None:
        children = convert_band_children(band_obj, warnings, date_fields=date_fields)
        if children:
            band["Components"] = children
    return band


def pg_type_to_dotnet(code):
    if code in DATE_TYPE_CODES:
        return "System.DateTime"
    if code in (1700, 700, 701, 790):
        return "System.Decimal"
    if code in (23, 21):
        return "System.Int32"
    if code == 20:
        return "System.Int64"
    if code == 16:
        return "System.Boolean"
    return "System.String"


def convert_report(root, report_code, report_name, root_columns):
    """
    root: parsed RB tree root (the TppReport object) from dfm_parser.parse_dfm
    root_columns: list of (name, pg_type_code) for the 'root' query result
                  (i.e. what SRP_SELECT/WHERE/GROUPBY/ORDERBY actually
                  returns) -- used both for Dictionary.DataSources and to
                  decide which field bindings get the date-only format.
    """
    warnings = []
    p = props_dict(root)
    children = root["children"]
    date_fields = {name.lower() for name, code in root_columns if code in DATE_TYPE_CODES}

    header_bands = [c for c in children if c["class"] in ("TppHeaderBand", "TppTitleBand")]
    detail_bands = [c for c in children if c["class"] == "TppDetailBand"]
    footer_bands = [c for c in children if c["class"] in ("TppFooterBand", "TppSummaryBand")]
    groups = [c for c in children if c["class"] == "TppGroup"]
    unhandled = [c for c in children if c["class"] not in
                 ("TppHeaderBand", "TppTitleBand", "TppDetailBand", "TppFooterBand",
                  "TppSummaryBand", "TppGroup")]
    for u in unhandled:
        warnings.append(f"ppReport 底下未處理的子物件類型 {u['class']}（{u['name']}），整段略過"
                         f"（多欄清單/圖表等元件沒有 Stimulsoft 對應，需要人工重畫）")

    if not detail_bands:
        raise ValueError("找不到 TppDetailBand，無法建立 StiDataBand")
    detail_band_obj = detail_bands[0]

    paper_width = cm(p.get("PrinterSetup.mmPaperWidth", 215900))
    paper_height = cm(p.get("PrinterSetup.mmPaperHeight", 279401))
    margin_left = cm(p.get("PrinterSetup.mmMarginLeft", 6350))
    margin_right = cm(p.get("PrinterSetup.mmMarginRight", 6350))
    content_width = round(paper_width - margin_left - margin_right, 4)

    sequence = []  # list of dicts to become Page.Components entries, in final order
    y = 0.0

    for hb in header_bands:
        h = cm(props_dict(hb).get("mmHeight", 0))
        ident = "StiReportTitleBand" if hb["class"] == "TppTitleBand" else "StiPageHeaderBand"
        band = make_band(ident, hb["name"], y, h, "StiInteraction", warnings, band_obj=hb,
                          content_width=content_width, date_fields=date_fields)
        sequence.append(band)
        y += h

    for g in groups:
        gp = props_dict(g)
        break_field = (gp.get("BreakName") or "").lower()
        gh = next((c for c in g["children"] if c["class"] == "TppGroupHeaderBand"), None)
        if gh is None:
            warnings.append(f"TppGroup {g['name']} 沒有 GroupHeaderBand，略過")
            continue
        h = cm(props_dict(gh).get("mmHeight", 0))
        band = make_band("StiGroupHeaderBand", gh["name"], y, h, "StiBandInteraction",
                          warnings, band_obj=gh, condition=f"{{root.{break_field}}}",
                          content_width=content_width, date_fields=date_fields)
        sequence.append(band)
        y += h

    dp = props_dict(detail_band_obj)
    dh = cm(dp.get("mmHeight", 0))
    data_band = make_band("StiDataBand", detail_band_obj["name"], y, dh, "StiBandInteraction",
                           warnings, band_obj=detail_band_obj, data_source="root",
                           content_width=content_width, date_fields=date_fields)
    sequence.append(data_band)
    y += dh

    for g in reversed(groups):
        gf = next((c for c in g["children"] if c["class"] == "TppGroupFooterBand"), None)
        if gf is None:
            continue
        h = cm(props_dict(gf).get("mmHeight", 0))
        band = make_band("StiGroupFooterBand", gf["name"], y, h, "StiInteraction",
                          warnings, band_obj=gf, content_width=content_width, date_fields=date_fields)
        sequence.append(band)
        y += h

    for fb in footer_bands:
        h = cm(props_dict(fb).get("mmHeight", 0))
        band = make_band("StiFooterBand", fb["name"], y, h, "StiInteraction",
                          warnings, band_obj=fb, content_width=content_width, date_fields=date_fields)
        sequence.append(band)
        y += h

    page_components = {str(i): b for i, b in enumerate(sequence)}

    root_cols = {
        str(i): {"Name": name, "NameInSource": name, "Alias": name,
                 "Type": pg_type_to_dotnet(code)}
        for i, (name, code) in enumerate(root_columns)
    }
    srpmeta_cols = {
        str(i): {"Name": n, "NameInSource": n, "Alias": n, "Type": "System.String"}
        for i, n in enumerate(["srp_id", "srp_code", "srp_name", "srp_description"])
    }

    report = {
        "ReportVersion": "2026.3.3",
        "ReportGuid": guid(),
        "ReportName": "Report",
        "ReportAlias": "Report",
        "ReportCreated": f"/Date({now_ms()}+0800)/",
        "ReportChanged": f"/Date({now_ms()}+0800)/",
        "EngineVersion": "EngineV2",
        "ReportUnit": "Centimeters",
        "ScriptLanguage": "CSharp",
        "UsePlatformDependentScript": False,
        "CalculationMode": "Interpretation",
        "Dictionary": {
            # NameInSource 一定要填：get_select_columns 那個 bug 修好之前踩過一次，
            # Stimulsoft Designer 的「Check for Issues」會擋成紅字錯誤、報表印不出來。
            "DataSources": {
                "0": {"Ident": "StiDataTableSource", "Name": "srpmeta", "NameInSource": "srpmeta",
                      "Alias": "srpmeta", "Columns": srpmeta_cols},
                "1": {"Ident": "StiDataTableSource", "Name": "root", "NameInSource": "root",
                      "Alias": "root", "Columns": root_cols},
            }
        },
        "Pages": {
            "0": {
                "Ident": "StiPage", "Name": "Page1", "Guid": guid(),
                "Interaction": {"Ident": "StiInteraction"},
                "Border": ";;;;;;;solid:Black", "Brush": "solid:",
                "Components": page_components,
                "PageWidth": paper_width,
                "PageHeight": paper_height,
            }
        },
    }
    return report, warnings

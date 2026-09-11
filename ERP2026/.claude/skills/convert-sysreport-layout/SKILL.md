---
name: convert-sysreport-layout
description: 把 Delphi6ERP（MSSQL）TBLSYSREPORT.SRP_REPORTFILE 裡的 ReportBuilder 二進位報表版面，轉成 ERP2026（Postgres）Stimulsoft JSON 版面草稿，寫回 tblsysreport.srp_reportfile。給 Stimulsoft Designer 一個已經有欄位/分組/小計的草稿可以微調，取代從空白畫布重新設計。跟 import-sysreport skill 是互補關係：那支只搬 TBLSYSREPORT/TBLSYSREPORTFIELD 的資料欄位，明確排除 SRP_REPORTFILE；這支專門補 SRP_REPORTFILE。
---

# 轉換系統報表版面（ReportBuilder → Stimulsoft）

## 背景

Delphi6ERP 的 `TBLSYSREPORT.SRP_REPORTFILE`（MSSQL `image` 欄位）存的是
ReportBuilder（Digital Metaphors）report 版面，格式是 Delphi 標準的二進位
component-stream（`TPF0` 簽章，跟 `.dfm` 檔同一套格式，只是流的是
`TppReport` 元件樹而不是 `TForm`）。ERP2026 的 Stimulsoft Designer 完全是
不同引擎、不同 JSON schema，兩邊沒有官方轉換工具，`import-sysreport` skill
特地跳過這個欄位、留給使用者在 Designer 逐一重畫。

這支 skill 就是把「重畫」這件事自動化到可用的程度：解析 RB 二進位樹，把
band 階層／欄位綁定／分組／聚合小計這些邏輯骨架，轉成觀察真人在 Designer
畫過的報表（`ZZ_FM_SHIP_RPT01`、`AA-MG_AR_002_COPY`）反推出來的 Stimulsoft
JSON schema。**不是逐像素照搬**——版面間距、粗體之類的細節轉不過去，是給
使用者一個「已經有欄位可以微調」的草稿，不是最終成品。

## 執行方式

```bash
cd ERP2026/.claude/skills/convert-sysreport-layout
python convert_report_layout.py                       # 轉全部「還沒有版面」的報表
python convert_report_layout.py FM_CUM_001 MG_AR_002   # 只轉指定的 SRP_CODE
python convert_report_layout.py --force FM_ACNT_001    # 連已經有版面（含人工設計過）的也覆蓋
python convert_report_layout.py --force                # 全部重轉，含已有版面的（codes 留空 + --force）
```

**目標 PostgreSQL 資料庫是動態讀 `backend/database.py` 的 `DBNAME`，不是寫死的**——後端指到哪個庫（例如暫時測試用的 `erp2`），這支就跟著寫到哪個，執行時第一行會印出實際連的是哪個資料庫，跑之前可以先確認一下跟預期的是不是同一個。

跑完會列出每份報表的結果分類（OK / SKIPPED / PARSE_FAILED / SELECT_FAILED
/ CONVERT_FAILED / ...），OK 的旁邊會附警告數，警告內容像「某元件沒有對應、
略過」這種，代表那個部分需要人工在 Designer 補。

**預設會保護已經有版面的報表，不覆蓋**（不管是這支 skill 轉過的還是使用者
手動在 Designer 畫過的）——加 `--force` 才會覆蓋。

## 這支腳本做了什麼

1. `dfm_parser.py`：把 `SRP_REPORTFILE` 的二進位 `TPF0` 串流解析成
   `{class, name, props, children}` 的元件樹（沒有寫回功能，純讀取）。
2. `rb_to_stimulsoft.py`：把解析出來的樹轉成 Stimulsoft JSON——band 對應
   （`TppHeaderBand→StiPageHeaderBand`、`TppDetailBand→StiDataBand`、
   `TppGroup`→一對 `StiGroupHeaderBand`/`StiGroupFooterBand`，巢狀分組用
   `Page.Components` 裡的**攤平但有序**排列表示，順序＝外層 Header→內層
   Header→Data→內層 Footer→外層 Footer，這個順序規則是實際用 Stimulsoft
   Designer 手動加分組、存檔後回讀 JSON 才確認的，不是文件查來的）。
3. `convert_report_layout.py`：串連 MSSQL（讀 `SRP_REPORTFILE`）跟
   Postgres（讀 `SRP_SELECT`/`WHERE`/`GROUPBY`/`ORDERBY`，執行一次
   `WHERE 1=2` 探測查詢拿真正的欄位名稱/型別），呼叫上面兩支模組，把結果
   寫回 `tblsysreport.srp_reportfile`。

## 使用者這次特別要求的三點，都已經處理

1. **整套 RB→Stimulsoft 轉換**（本 skill 的主體）。
2. **`vtPageSetDesc`（頁數說明系統變數）對應到 Stimulsoft 的
   `{PageNofM}`**（`rb_to_stimulsoft.py` 的 `SYSVAR_MAP`）。
3. **所有日期／時間戳欄位一律去掉時間、只顯示 `YYYY/MM/DD`**：根據 Postgres
   實際欄位型別（`date`/`timestamp`/`timestamptz`，不是看 RB 的
   `DisplayFormat`——那個常常沒填，填了也不一致）判斷是不是日期欄位，是的
   話把綁定表達式從 `{root.smt_date}` 改成
   `{root.smt_date.ToString("yyyy/MM/dd")}`。

## 一個容易踩的坑：`.ToString(...)` 一定要配 `"Type": "Expression"`

這是這次修這支 skill 時，用瀏覽器實測抓出來的真實 bug，不是憑空猜的：

- 直接在 Stimulsoft JSON 裡寫 `{root.smt_date.ToString("yyyy/MM/dd")}`
  但沒加 `"Type": "Expression"`，Designer/Viewer 會**整串當欄位名去查**，
  查不到就默默 fallback 印出該值的預設 `ToString()`（長格式，含「上午」
  之類的時間字樣），不會報錯，很難發現。
- 拿一份已經在 Stimulsoft Designer 裡手動把某個日期欄位的 Text Format
  設成 Custom「yyyy/MM/dd」、存檔後的真實 JSON 來比對，Stimulsoft 自己
  也是把 `Text.Value` 改寫成同樣的 `.ToString("yyyy/MM/dd")` 語法，**外加
  `"Type": "Expression"`**——這就是正確答案的來源，不是我们瞎猜的格式。
- 所以 `rb_to_stimulsoft.py` 裡任何值不是單純 `{src.field}`（呼叫了
  `.ToString(...)`、`Sum(...)`、`Count(...)`、系統變數巨集，或是
  `TppLabel` 的純文字說明）都會加上 `"Type": "Expression"`；只有單純拖曳
  單一欄位進版面（`{root.某欄位}`，不做任何轉換）才不用加，這跟真人在
  Designer 操作出來的 JSON 一致。
- **驗證方式也記下來**：靠肉眼看 Stimulsoft Preview 的縮圖截圖常常判斷
  錯誤（186 頁的大報表 Preview 產生要 20~30 秒，太早截圖會看到還沒轉好
  的舊畫面，容易誤判成「沒修好」）——保險做法是耐心等到 Viewer 工具列的
  頁碼/縮放控制項都出現，代表真的渲染完了才截圖比對。

## 元件對應表

| RB 元件 | Stimulsoft | 備註 |
|---|---|---|
| `TppHeaderBand` | `StiPageHeaderBand` | |
| `TppTitleBand` | `StiReportTitleBand` | |
| `TppDetailBand` | `StiDataBand`，`DataSourceName="root"` | |
| `TppFooterBand` / `TppSummaryBand` | `StiFooterBand` | |
| `TppGroup` | 一對 `StiGroupHeaderBand`（`Condition={root.<BreakName小寫>}`）+ `StiGroupFooterBand` | 巢狀分組＝多對，外層在前 |
| `TppLabel`（靜態文字） | `StiText`，`Type: Expression` | |
| `TppDBText`（欄位綁定） | `StiText`，`{root.欄位}` 或帶日期格式化 | `DataPipeline=plTemplate` 時綁 `srpmeta`（報表主檔自身欄位） |
| `TppDBCalc`（小計/合計） | `StiText`，`{Sum(...)}`/`{Count(root)}`/`{Max(...)}`/`{Min(...)}`，`Type: Expression` | `DBCalcType` 對應到 Stimulsoft 聚合函式 |
| `TppSystemVariable` | `StiText`，`{PageNumber}`/`{TotalPageCount}`/`{PageNofM}`，`Type: Expression` | 只認得這 3 種 VarType，其他的留空白＋警告 |
| `TppLine` | `StiHorizontalLinePrimitive` | |

## 已知限制（沒有 Stimulsoft 對應，遇到會跳過＋警告，需要人工重畫）

- `TppDPTeeChart`（內嵌 TeeChart 圖表）：完整 52 份報表裡有 6 份用到
  （`ST_RPT_04~07` 系列），Stimulsoft 有自己的 `StiChart` 但結構完全不同，
  只能在 Designer 手動重畫圖表元件；表格資料本身照常轉換，圖表被跳過。
- `TppColumnHeaderBand`/`TppColumnFooterBand`（多欄清單版面）：10 份報表
  用到，Stimulsoft 沒有對應的「欄」band 概念，需要人工改用
  `Report.Columns` 設定或重新排版。
- 字型粗體（`Font.Style=[fsBold]`）目前沒有轉。
- `~COND1` 這類舊系統在列印時才動態代換成查詢條件文字的佔位符，照字面
  搬過去，沒有解析代換邏輯。

## 執行前提

- MSSQL（`tnvtrsap01`/`erp`）可連線；Postgres `tblsysreport` 已經有對應
  `srp_code` 的資料列（先跑過 `import-sysreport` skill）
- 需要 `psycopg[binary]`、`pymssql`（跟 `backend/requirements.txt` 一致）
- `SRP_SELECT`/`SRP_WHERE` 必須是合法的 PostgreSQL 語法才能探測出欄位
  名稱/型別；還是 T-SQL 語法的報表會回報 `SELECT_FAILED`，先把 SQL 改成
  PostgreSQL 語法（`||` 取代字串 `+`、`EXTRACT`/`TO_CHAR` 取代
  `DATEPART`/`CONVERT`、boolean 欄位不能跟整數比較等等），再重跑這支

## 轉完之後

每份報表還是要進「系統報表管理」→「設計」用 Stimulsoft Designer 開一次，
確認版面/字型/間距沒問題（尤其是有警告的那幾份），再存檔定案。查詢條件、
排序欄位這些跟版面無關的功能，`import-sysreport` 搬完資料就已經能用，不
用等版面畫完。

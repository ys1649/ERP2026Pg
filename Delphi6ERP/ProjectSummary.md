# Delphi6ERP 專案說明

進銷存 + 會計總帳 ERP 系統。Delphi 6（Win32 桌面應用）+ ADO + Microsoft SQL Server。

本文件涵蓋：系統架構、功能模組清單、核心商業邏輯、動態報表引擎、資料庫結構、共用元件、開發環境需求，以及目前已知的技術債。

---

## 1. 系統架構

### 1.1 執行檔佈局：單一 EXE，多個「假 DLL」資料夾

`ERP/Program.DLL/` 底下每個子資料夾（`SHIP`、`CUSTOMER`、`ACNT_JOURNAL`…）都各自帶一個獨立的 `.dpr`，可以單獨開啟編譯——這是給開發者單獨測試某一個表單用的。

但**正式主程式只有一個**：[`ERP/Program.DLL/MAINALL/ERP_Main.dpr`](ERP/Program.DLL/MAINALL/ERP_Main.dpr)。它的 `uses` 子句用相對路徑把每個模組資料夾底下的 `.pas` 原始碼全部直接列進來，是**靜態編譯連結成單一 `ERP_Main.exe`**，不是在執行期用 `LoadLibrary` 載入一堆 `.dll`。

`SysReport.DLL` 這個頂層資料夾也是同樣狀況——它的所有單元（`SysReport_Head.pas`、`form_SysReportQuery.pas`…）同樣被 `ERP_Main.dpr` 直接以原始碼形式包含進主程式。`SysReport_Head.pas` 裡還留著一段被註解掉的 `stdcall` procedure type（`TsrPrintFormReport`），是早期「報表引擎真的做成獨立 DLL、動態載入」架構的遺跡，現在已經不是這樣運作。

`ERP/Program.DLL/MAIN`、`Demo`、`test` 底下也各有一份 `ERP_Main.dpr`，是不同建置版本（示範版/測試版），不是正式版所在。

> 換句話說：「`XXX.DLL`」只是歷史留下的資料夾命名慣例，不代表執行期真的是動態連結庫。真正在執行期以獨立 `.bpl`/`.dll` 存在的，只有 Delphi/第三方元件的執行期套件（見 §7）。

### 1.2 主視窗 + 動態子視窗模式

`TFM_Main`（[`FORM_Main.pas`](ERP/Program.DLL/MAINALL/FORM_Main.pas)）是唯一常駐的主視窗，不是傳統 MDI。每個功能模組表單透過共用方法開啟：

```pascal
procedure TFM_Main.ExecuteFunction(Tfm: TFormErpClass; cmd: integer);
```

- `cmd = 0`：**單例快取**——用 `FormList: TStringList`（key = classname）記住已開過的視窗實例，第二次點選同一功能只是把既有視窗顯示出來，不會重新建立。
- `cmd = 1`：**Modal 對話框**——每次都新建、`ShowModal` 完就釋放。

主選單有三組是**資料庫驅動、執行期動態產生**的（不是寫死在 `.dfm`）：`init` 裡呼叫 `AddSysReport_ToMenu` 三次，分別依 `TBLSYSREPORT.SRP_CODE` 前綴 `FM%`／`MG%`／`ST%` 撈出資料列，動態掛到「表單報表」「管理報表」「統計報表」三個子選單下，點擊後統一導到 `ShowSysReportQuery`（見 §4）。

### 1.3 共用基底類別

- **`TForm_ERP`**（[`FORM_ERP_BASE.pas`](ERP/Program.DLL/UTY/FORM_ERP_BASE.pas)）：所有業務表單的共同基底，帶 `sysinfo: TSysInfo` 與抽象 `init` 方法；`CloseQuery` 用的是 VCL `TForm` 內建方法。
- **`TSysInfo`**（[`erp_public.pas`](ERP/Program.DLL/UTY/erp_public.pas)）：登入者資訊 + 系統參數（稅率、小數位數、備份路徑、當前會計年度、各種預設會計科目代碼等），`FormCreate` 時建立、`ReadSysParam` 讀入，全域傳遞給每個子表單。

### 1.4 主檔/明細檔資料存取模式

交易單據類表單（銷貨、進貨、收款、付款、庫存調整…）統一用 **`TClientDataSet` + `TDataSetProvider`**（Delphi Briefcase Model／MIDAS 模式）做主檔（`Client_Mast`）/明細（`Client_dt`）：資料先抓進記憶體端的 ClientDataSet，畫面編輯完再統一 `ApplyUpdates` 送回資料庫，而不是直接綁 live `TADOQuery`。

### 1.5 資料庫連線

- `ADODB.TADOConnection`，Provider 為 `SQLOLEDB.1`，連到 MSSQL。
- 連線字串存在各模組資料夾下的 `ERP.INI`（純文字，`GetAdoConnectionString` 讀取）。
- 登入驗證：`SysLoginCheckUser`（比對 `TBL_EMPLOYE.EPY_PASSWORD`）—— **內建一組硬編碼萬用帳密 `WYS`/`WYSEN`**，繞過資料庫直接放行（見 §8 已知問題）。

---

## 2. 功能模組清單

依主選單分類（中文名稱取自 [`FORM_Main.dfm`](ERP/Program.DLL/MAINALL/FORM_Main.dfm) 實際 Caption）：

### 基本資料
| 選單名稱 | 資料夾 | 主表單 | 對應主資料表 |
|---|---|---|---|
| 客戶基本資料設定 | `CUSTOMER` | `FORM_CUSTOMER.pas` | `TBL_CUSTOMER` |
| 廠商基本資料設定 | `SUPPLIER` | `Form_Supplier.pas` | `TBL_SUPPLIER` |
| 產品基本資料設定 | `PRODUCT` | `form_product.pas` | `TBL_PRODUCT` |
| 員工基本資料設定 | `EMPLOYEE` | `form_employee.pas` | `TBL_EMPLOYE` |
| 車輛基本資料設定 | `CAR` | `Form_Car.pas` | `TBL_CAR`（配送車輛，供出貨單指派司機/車輛用） |
| 會計科目設定 | `ACNT_ACCOUNT` | `form_account.pas` | `TBL_ACNT_ACCOUNT`、`TBL_ACNT_TYPE` |

### 交易單據
| 選單名稱 | 資料夾 | 主表單 | 說明 |
|---|---|---|---|
| 銷退貨單管理（銷退貨） | `SHIP` | `form_ship.pas` | 出貨/銷貨、銷貨退回單，含列印（見 §4）、快速收款 `form_QuickCollect.pas`、歷史查詢 `FORM_ship_HISTORY.pas` |
| 進退貨單管理（進退貨） | `PO_RECV` | `Form_PoRecv.pas` | 採購進貨、進貨退出單，快速付款 `form_porecv_QuickPay.pas`、歷史查詢 `FORM_porecv_HISTORY.pas` |
| 銷貨收款作業（收款） | `AR_RECV` | `FORM_AR_RECV.pas` | 應收帳款收款登打，沖銷出貨單，自動過帳到總帳 |
| 進貨付款作業（付款） | `AP_PAY` | `FORM_AP_PAY.pas` | 應付帳款付款登打，沖銷進貨單，自動過帳到總帳 |
| 庫房調整單 | `INV_ADJUST` | `form_InvAdjust.pas` | 庫存盤點/損溢調整，瀏覽 `form_InvAdjBrowse.pas` |
| 庫存交易重整 | `ResetInvTransaction` | `Form_ResetInvTran.pas` | 重新計算/重建 `TBL_TRANSACTION` 移動平均成本序列（資料異常修復工具） |

### 財務會計
| 選單名稱 | 資料夾 | 主表單 | 說明 |
|---|---|---|---|
| 傳票維護 | `ACNT_JOURNAL` | `Form_Journal.pas` | 手動會計傳票（借貸分錄）新增/查詢，`Form_Journal_Browse.pas`、`FORM_Journal_Print.pas` |
| 會計年度結轉 | `ACNT_CHANGE_YEAR` | `Form_AcntChgYear.pas` | 年度結帳、轉入下一會計年度 |
| 資產負債表 | `ACNT_RPT_ASSET` | `Form_Acnt_Asset.pas` | |
| 科目餘額表 | `ACNT_RPT_BALANCE` | `Form_AcntBalance.pas` | |
| 現金簿 | `ACNT_RPT_CASH` | `Form_AcntCash.pas` | |
| 日記帳 | `ACNT_RPT_DAILY` | `Form_AcntDaily.pas` | |
| 明細分類帳 | `ACNT_RPT_DETAIL` | `Form_AcntDetail.pas` | |
| 損益表 | `ACNT_RPT_INCOME_STAEMENT` | `Form_AcntIncomeStament.pas` | |
| 試算表 | `ACNT_RPT_TrialBalance` | `Form_AcntTrialBalance.pas` | |

### 系統設定
| 選單名稱 | 資料夾 | 主表單 | 說明 |
|---|---|---|---|
| 系統設定 | `SYS_PARAM` | `Form_SysParam.pas` | 稅率、小數位數、預設科目代碼等全域參數（`TBL_SYS_PARAM`） |
| 資料備份 | `Data_Backup` | `Form_backup.pas` | 呼叫外部備份指令（`SPR_BKUP_CMD`/`SPR_BKUP_PARA`，通常是 DB 層 backup 工具） |
| 資料還原 | `Data_Restore` | `form_DataRestore.pas` | 還原前會強制先跑一次備份（見 [FORM_Main.pas](ERP/Program.DLL/MAINALL/FORM_Main.pas:207)） |

### 表單報表／管理報表／統計報表
不是固定表單，是**資料庫驅動**的動態報表清單（見 §1.2、§4），報表定義存在 `TBLSYSREPORT`，代碼前綴 `FM%`（表單報表）/`MG%`（管理報表）/`ST%`（統計報表）分類掛入對應子選單。

---

## 3. 核心商業邏輯（[`erp_public.pas`](ERP/Program.DLL/UTY/erp_public.pas)）

全系統共用的商業規則集中在這個單元，不是散在各表單裡：

### 3.1 移動平均成本法庫存

```pascal
procedure InsertTransaction(...);   // 寫入一筆庫存交易
procedure UpdateTransaction(...);   // 重算該產品此時間點之後的結存量/平均成本
```

- 每筆進貨/出貨/調整都寫入 `TBL_TRANSACTION`（`TRN_TYPE`：進貨/銷貨/調整）。
- `UpdateTransaction` 依時間序重算：**進貨或正向調整**時，新平均成本 = `(前結存量×前成本 + 本次數量×本次成本) / 新結存量`；**銷貨或負向調整**則沿用前一筆的平均成本（不影響均價）。
- 同時回寫 `TBL_PRODUCT.PRD_ONHAND`（結存量）與 `PRD_CUR_COST`（現行平均成本）。
- 若異動時間早於系統設定的 `SPR_PERIOD_START`（結帳日），直接丟例外擋掉。

### 3.2 收付款自動過帳

```pascal
procedure ArRecvToAccount(...);  // 收款單 → 會計傳票
procedure ApPayToAccount(...);   // 付款單 → 會計傳票
```

依現金/票據/折讓/預收(付)款沖轉等欄位，自動組成一張借貸平衡的傳票寫入 `TBL_ACNT_JOURNAL` + `TBL_ACNT_JOURNAL_DT`，寫完呼叫 `ChkDCBalance` 檢查借貸合計是否為 0，不平衡就拋例外。

---

## 4. 動態報表引擎（`SysReport.DLL`）

系統裡大量的「表單列印」「統計/管理報表」都不是寫死的 Delphi 報表，而是**資料庫定義驅動**的通用引擎，以出貨單列印為例，完整呼叫鏈：

```
Tfm_ship.ActPrintExecute                          (form_ship.pas)
  └─ PrintFormReport(adodc, RptCode, Where, Order, mode)   (form_SysReportQuery.pas)
       └─ Tfm_SysReportQuery.ShowSysReport
            1. 依 RptCode 查 TBLSYSREPORT，取出：
               SRP_SELECT / SRP_WHERE / SRP_GROUPBY / SRP_ORDERBY / SRP_REPORTFILE(版面Blob)
            2. MainWhere := JoinWhere(SRP_WHERE, 呼叫端傳入的 Where)   -- AND 接起來
            3. MainOrder := JoinOrder(SRP_ORDERBY, 呼叫端傳入的 Order) -- 逗號接起來
            4. sql := RunMultiSql(adodc, SRP_SELECT)  -- 分號分段執行，最後一段當 SELECT
            5. QryReportData.SQL.Text := sql + MainWhere + group + MainOrder
            6. ppReport.Template.LoadFromStream(SRP_REPORTFILE) 後用 Report Builder 列印/預覽/匯出
```

- 報表版面用 **ReportBuilder**（`ppXXX` 系列元件）製作，樣板整份存成 Blob（`SRP_REPORTFILE`）存在資料庫裡，不是散在檔案系統。
- 查詢條件表單（`Form_Query.pas`）依 `TBLSYSREPORTFIELD` 動態產生輸入欄位，讓使用者自訂篩選條件，組出 `sqlWhere`/`sqlOrder` 傳回呼叫端。
- 除錯技巧：`ShowSysReport` 內有 `debug(QryReportData.SQL.Text)`，最終真正執行的 SQL 會寫到 `%TEMP%\DebugICD.SQL`。
- 匯出功能（PDF/Excel/HTML/RTF…）靠第三方套件 **ExtraDev**（`TExtraOptions`/`xtradev.bpl`）擴充 ReportBuilder 原生的匯出裝置。

---

## 5. 資料庫結構摘要

主要業務資料表（`TBL_*`，完整 DDL 見 [`ERP/SA/Create_All_ERP_TABLE.sql`](ERP/SA/Create_All_ERP_TABLE.sql)）：

| 分類 | 資料表 |
|---|---|
| 基本資料 | `TBL_CUSTOMER`、`TBL_SUPPLIER`、`TBL_PRODUCT`、`TBL_EMPLOYE`、`TBL_CAR`、`TBL_SYS_PARAM` |
| 銷貨 | `TBL_SHIP`、`TBL_SHIP_DT`、`TBL_HIS_SHIP`、`TBL_HIS_SHIP_DT`（歷史封存） |
| 採購 | `TBL_PO_RECV`、`TBL_PO_RECV_DT`、`TBL_HIS_PO_RECV`、`TBL_HIS_PO_RECV_DT` |
| 收付款 | `TBL_AR_RECV`、`TBL_AR_RECV_DT`、`TBL_AP_PAY`、`TBL_AP_PAY_DT` |
| 庫存 | `TBL_INVENTORY`、`TBL_INV_ADJ`、`TBL_INV_ADJ_DT`、`TBL_INV_ONHAND`、`TBL_TRANSACTION`（移動平均成本流水帳） |
| 會計總帳 | `TBL_ACNT_ACCOUNT`、`TBL_ACNT_TYPE`、`TBL_ACNT_JOURNAL`、`TBL_ACNT_JOURNAL_DT`、`TBL_ACNT_INIT` |
| 報表引擎（獨立 schema） | `TBLSYSREPORT`、`TBLSYSREPORTFIELD`（定義見 [`SysReport.DLL/sa/`](SysReport.DLL/sa)） |

`TBL_SHIP`/`TBL_PO_RECV` 都有對應的 `TBL_HIS_*` 歷史表，推測是確認/結案後的單據會搬移或複製過去做封存，避免主表資料量過大。

---

## 6. 共用元件 / 工具庫

| 位置 | 用途 |
|---|---|
| `Utility/Uty.pas` | 全域字串/型別/SQL 輔助函式（`SqlStr`、`SqlNum`、`StrDivide`、`debug`…）、全域常數（`CR`、`TAB`、色彩常數） |
| `Utility/DBUty.pas` | 資料庫層輔助（`TblLookup`、`GetNumbericCode` 自動編號產生器、連線字串讀取…） |
| `Utility/RecChoice/` | `TWRecChoice` 彈出式選取清單元件——`erp_public.pas` 裡一大票 `SelectXxxNO`（選客戶/選供應商/選產品/選車輛/選員工…）都是靠它做「查詢挑選」彈窗，是全系統共用的資料選取 UI 模式 |
| `Utility/FormSearch/` | 表單搜尋輔助元件 |
| `ERP/Program.DLL/UTY/erp_public.pas` | 見 §3，跨模組商業邏輯 |
| `ERP/Program.DLL/UTY/FORM_ERP_BASE.pas` | 見 §1.3，表單基底類別 |

---

## 7. 開發環境需求

- **Delphi 6**（含 Update Pack），編譯目標 Win32。
- **ReportBuilder 6.6**（Digital Metaphors）—— `rb*66` 系列套件，`ppXXX` 元件，報表引擎核心。
- **ExtraDev**（`xtradev.bpl`，第三方 ReportBuilder 匯出裝置擴充套件，含 PDF/Excel/HTML/RTF 匯出）——原始碼在本機另有備份於 `C:\Program Files (x86)\EXTRADEV\DELPHI6\SOURCE\`，不隨本專案原始碼庫附帶。
- **COM Type Library 匯入單元**：`MSXML2_TLB.pas`、`MSScriptControl_TLB.pas`（對應 `msxml*.dll`／`msscript.ocx`）——這兩個檔案**不隨專案帶著走**，每台開發機都要用 Delphi `Project > Import Type Library` 各自匯入一次。
- 其他第三方執行期套件（見 `ERP_Main.dof` 的 `Packages=` 清單）：`dxEdtrD6`/`dxcomnd6`/`dxGrEdD6`/`dxExELD6`/`dxELibD6` 等（Grid/編輯控制項，疑似 Developer Express 舊版 VCL 套件）、`EQTLD6`/`ECQDBCD6`/`EQDBTLD6`/`EQGridD6`（Grid 相關套件）、`ip3000*` 系列（用途待確認）、`wwDBGrid`/`wwdbdatetimepicker` 等（Woll2Woll InfoPower，資料格線/日期選取控制項）、`RzButton`/`RzPanel`/`RzToolbar`（Raize Components，UI 控制項外觀套件）。
- **MSSQL Server**，連線用 ADO（`SQLOLEDB.1` provider）。

---

## 8. 已知問題 / 技術債

這些是這次盤點過程中實際發現、值得留意的地方：

1. **原始碼為 Big5 編碼**：字串/註解含中文，用 UTF-8 開啟會顯示亂碼，屬正常現象非檔案損毀。
2. **硬編碼萬用帳密**：`SysLoginCheckUser`（`erp_public.pas`）裡寫死 `WYS`/`WYSEN` 可繞過資料庫驗證直接登入，建議正式環境移除或至少限制使用場景。
3. **`ERP.INI`/`SysReport.INI` 明碼密碼**：多份設定檔含明碼 DB 帳密（`Password=erp` 等），且目前**已依專案擁有者決定納入 git 版控**——若未來要把這個 repo 推到任何遠端（GitHub/GitLab…），務必先評估是否要改用不含密碼的範本檔，否則密碼會永久留在 commit 歷史裡。
4. **`.dpr` 內第三方單元路徑寫死**：`ERP_Main.dpr` 對 `MSXML2_TLB`/`MSScriptControl_TLB` 用絕對路徑 `C:\Program Files\Borland\Delphi6\Imports\...`（缺少 64 位元 Windows 的 `(x86)`），在新機器上要對應調整或改走 Library Path 搜尋，不能直接假設路徑存在。
5. **`xtradev.bpl` 版本相依脆弱**：這個 2001 年編譯的第三方套件跟著 ReportBuilder 的 `ppFilDev` 版本綁死，換一台機器裝的 ReportBuilder 版本稍有差異就會出現 "compiled with a different version" 編譯錯誤，需要用原始碼（`C:\Program Files (x86)\EXTRADEV\DELPHI6\SOURCE\xtradev.dpk`）針對當前機器重編。
6. **`*.dll` 資料夾命名陷阱**：`Program.DLL`、`SysReport.DLL` 這兩個資料夾名稱本身以 `.DLL` 結尾，撰寫 `.gitignore`／任何自動化腳本時，用萬用字元 `*.dll` 在 Windows（大小寫不敏感）下會誤傷這兩個目錄，本專案 `.gitignore` 已用 `!ERP/Program.DLL/`、`!SysReport.DLL/` 特別排除。

---

## 9. 版控狀態

專案已於本機初始化 git（見 [`.gitignore`](.gitignore)）：
- **納入版控**：所有 `.pas`/`.dfm`/`.dpr`/`.dof`/`.sql`/`.pdm` 等原始碼與文件、`ERP.INI`/`SysReport.INI`（依專案擁有者決定，見 §8 第 3 點）。
- **排除**：編譯產物（`.dcu`/`.exe`/`.dll`/`.bpl`/`.dcp`/`.map`/`.drc`）、Delphi IDE 自動備份與狀態檔（`.~*`/`.dsk`/`.ddp`/`__history/`）。

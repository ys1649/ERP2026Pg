# ERP2026 進銷存系統 — 開發文件

> 最後更新：2026-09-04（29 張業務表改由 Delphi6ERP／MSSQL 搬入真實資料；系統報表模組改成跟 Delphi6ERP 一樣的動態組 SQL 引擎，詳見〈資料庫〉〈系統報表模組〉章節）

---

## 目錄

1. [系統概覽](#系統概覽)
2. [技術堆疊](#技術堆疊)
3. [目錄結構](#目錄結構)
4. [資料庫](#資料庫)
5. [後端 FastAPI](#後端-fastapi)
6. [前端 React + Vite](#前端-react--vite)
7. [資料字典與可重用 Lookup 元件](#資料字典與可重用-lookup-元件)
8. [系統報表模組](#系統報表模組)
9. [Stimulsoft 報表設計器](#stimulsoft-報表設計器)
10. [啟動方式](#啟動方式)
11. [移植到新電腦](#移植到新電腦)
12. [已完成功能](#已完成功能)
13. [待開發功能](#待開發功能)

---

## 系統概覽

進銷存 + 財務總帳系統，前後端分離架構。

> **這個專案的功能是從舊的 Delphi6ERP 桌面版系統移轉過來的**，不是從零設計。
> 舊專案原始碼在 `D:\ERP2026Pg\Delphi6ERP`，正式主程式是
> [`ERP\Program.DLL\MAINALL\ERP_Main.dpr`](Delphi6ERP/ERP/Program.DLL/MAINALL/ERP_Main.dpr)
> （Delphi 6 + MSSQL；`Program.DLL`/`SysReport.DLL` 只是資料夾命名慣例，實際是靜態編譯連結成單一
> exe，不是真的動態載入 DLL）。舊專案根目錄的 [`ProjectSummary.md`](Delphi6ERP/ProjectSummary.md)
> 有完整的架構/模組/商業邏輯/已知問題盤點，**之後開發任何交易單據/總帳/報表相關功能前，
> 應該先去讀舊專案對應模組的原始碼跟這份文件**，不要憑空重新設計——資料表結構、業務規則
> （移動平均成本法、收付款自動過帳邏輯等）都要跟舊系統的實際行為對齊，畢竟資料庫裡的真實
> 資料就是照舊系統的資料模型跑出來的。系統報表模組（見〈系統報表模組〉章節）已經是這樣做的
> 範例：刻意比照舊系統 `SysReport.DLL` 的動態組 SQL 方式重寫，而不是延用 ERP2026 原本自創的設計。

- **前端**：React 19 SPA，透過 Vite dev server（port 5173）提供
- **後端**：FastAPI REST API（port 8000），前端以 Vite proxy 轉發 `/api` 請求
- **資料庫**：PostgreSQL 16（本機，`erp` 資料庫）；29 張業務表的真實資料來自 Delphi6ERP（舊桌面版系統，MSSQL），資料字典 2 張表沿用 Oracle 測試資料，系統報表 2 張表也從 Delphi6ERP（MSSQL）搬入（詳見〈資料庫〉章節）
- **報表**：Stimulsoft Reports.JS（嵌入式報表設計器 + 預覽列印）

---

## 技術堆疊

### 後端

| 套件 | 版本 | 用途 |
|------|------|------|
| fastapi | 0.141.1 | REST API 框架 |
| uvicorn | 0.32.0 | ASGI 伺服器 |
| pydantic | 2.13.4 | 資料驗證 |
| psycopg[binary] | 3.3.5 | PostgreSQL DB 驅動 |
| pymssql | 2.4.0 | MSSQL DB 驅動（只有搬移工具在用，見〈資料庫〉章節） |
| python-multipart | 0.0.12 | Form 資料解析 |

### 前端

| 套件 | 版本 | 用途 |
|------|------|------|
| react | 19.x | UI 框架 |
| vite | 8.x | 開發伺服器 / 打包工具 |
| antd | 6.x | UI 元件庫（繁體中文 zh_TW） |
| axios | 最新 | HTTP 用戶端 |
| stimulsoft-reports-js | 2026.3.2 | 報表設計器（需另購授權） |

---

## 目錄結構

```
ERP2026/
├── backend/
│   ├── main.py              # FastAPI 入口，CORS、路由註冊
│   ├── database.py          # PostgreSQL 連線 context manager
│   ├── requirements.txt     # Python 套件清單
│   ├── scripts/
│   │   ├── migrate_oracle_to_pg.py  # Oracle → PostgreSQL 一次性資料 clone（只剩 TBLDD/TBL_DDFIELD 兩張表，其餘已改用 MSSQL 來源）
│   │   ├── migrate_mssql_to_pg.py   # ★ Delphi6ERP（MSSQL）→ PostgreSQL 一次性搬 29 張業務表（含 DDL 產生 + 中文欄位註解）
│   │   ├── pdm_comments.json        # 從 PowerDesigner ERP.pdm 解析出的中文欄位名，migrate_mssql_to_pg.py 用來產生 COMMENT ON
│   │   └── ddl_from_mssql.sql       # migrate_mssql_to_pg.py 執行時自動產生的 DDL 存檔（供參考/除錯，非手動維護）
│   └── routers/
│       ├── customers.py     # 客戶主檔 CRUD + report-data API
│       ├── reports.py       # 報表檔案列表 + 下載 API（no-cache）
│       ├── data_dict.py     # 資料字典主檔/欄位 CRUD + Lookup meta/data API
│       ├── sysreport.py     # 系統報表主檔/欄位 CRUD + 動態查詢引擎（比照 Delphi6ERP 動態組 WHERE/ORDER BY）+ 版面讀寫
│       └── mssql_migrate.py # ★「MSSQL 資料轉入 PostgreSQL」網頁功能：使用者輸入 MSSQL 連線資訊，只搬資料不動 DDL，排除 4 張報表引擎表
│
├── .claude/
│   └── skills/
│       └── import-sysreport/
│           ├── SKILL.md              # Skill 說明
│           └── import_sysreport.py   # ★ 把 Delphi6ERP（MSSQL）的 TBLSYSREPORT/TBLSYSREPORTFIELD 原樣搬進 PostgreSQL（兩邊 schema 已完全一致）
│
├── Report/
│   └── Customer/            # 客戶報表範本目錄（*.mrt）
│       ├── 客戶清冊.mrt
│       └── 客戶編號對照表.mrt
│
├── frontend/
│   ├── index.html           # 入口 HTML（含 Stimulsoft script 標籤）
│   ├── vite.config.js       # Vite 設定（proxy /api → localhost:8000）
│   ├── package.json
│   ├── scripts/
│   │   └── copy-stimulsoft.js   # 將 Stimulsoft JS 複製到 public/
│   ├── public/
│   │   └── stimulsoft/          # Stimulsoft JS 執行檔（由 copy-stimulsoft.js 產生）
│   │       ├── stimulsoft.reports.js
│   │       ├── stimulsoft.viewer.js
│   │       └── stimulsoft.designer.js
│   └── src/
│       ├── main.jsx             # React 入口，ConfigProvider zh_TW + BrowserRouter
│       ├── App.jsx              # 路由表（Routes/Route），依 menuConfig 自動產生各功能項目路由
│       ├── menuConfig.js        # ★ 全系統功能目錄結構（分類/項目/路徑/icon/ready），首頁與側邊選單共用同一份資料
│       ├── style.css            # 全域樣式
│       ├── api/
│       │   ├── customers.js     # customerApi（axios）
│       │   ├── reports.js       # reportApi：listCustomer / customerReportUrl（含 cache-buster）
│       │   ├── datadict.js      # dataDictApi：主檔/欄位 CRUD、meta、data
│       │   ├── sysreport.js     # sysReportApi：主檔/欄位 CRUD、selectColumns、fieldLookupData、query-meta、runQuery
│       │   └── mssqlMigrate.js  # mssqlMigrateApi：test / run（「MSSQL 資料轉入 PostgreSQL」頁面用）
│       ├── lib/
│       │   └── ddLookup.jsx     # ★ DDLookup.getDDLookup(ddmNo)：呼叫式 Promise API，動態掛載/卸載
│       ├── theme.js             # antd ConfigProvider 的 locale/theme 設定（main.jsx 與 ddLookup.jsx 共用）
│       ├── layouts/
│       │   └── MainLayout.jsx   # ★ 側邊導覽選單 + Header 麵包屑 + Outlet，所有頁面的共用外層
│       ├── pages/
│       │   ├── Home.jsx             # ★ 首頁：依 menuConfig 分類顯示各功能入口卡片（含 Home.css）
│       │   ├── Placeholder.jsx      # ★ 尚未開發功能的預留頁面（依目前路徑自動顯示標題/分類）
│       │   ├── CustomerMaster.jsx   # 客戶主檔維護頁面
│       │   ├── DataDictMaster.jsx   # 資料字典維護頁面（主檔 + 欄位定義）
│       │   ├── SysReportMaster.jsx  # 系統報表定義維護頁面
│       │   └── MssqlMigrate.jsx     # ★「MSSQL 資料轉入 PostgreSQL」頁面（系統設定分類下）
│       └── components/
│           ├── CustomerFormModal.jsx      # 新增/編輯客戶 Modal
│           ├── CustomerReport.jsx         # Stimulsoft 報表設計器/預覽 Modal（localStorage 版面）
│           ├── CustomerReportPreview.jsx  # Stimulsoft 純預覽 Modal（載入 .mrt 檔）
│           ├── DataDictFormModal.jsx      # 新增/編輯資料字典主檔 Modal
│           ├── DataDictFieldFormModal.jsx # 新增/編輯資料字典欄位 Modal
│           ├── DataDictLookup.jsx         # ★ 可重用 Lookup 元件（JSX 掛用）
│           ├── DDLookupEdit.jsx          # ★ 輸入框：打字下拉選單 + 搜尋鈕開 Modal，displayField 決定顯示欄位
│           ├── SysReportFormModal.jsx     # 新增/編輯系統報表主檔表單（SRP_SELECT/WHERE/GROUPBY/ORDERBY 四段輸入）
│           ├── SysReportFieldMaintModal.jsx # 查詢欄位維護畫面（Grid Modal，rowKey 為 srf_seqno）
│           ├── SysReportFieldFormModal.jsx  # 新增/編輯單筆查詢欄位表單（比照 Delphi6ERP 詞彙 + 「從 SRP_SELECT 選欄位」挑選器）
│           ├── SysReportFieldPicker.jsx     # ★ SRF_CONTROLTYPE=SQL 查詢欄位的挑選視窗（單選/多選，執行 SRF_LIST_SQL）
│           ├── SysReportDesigner.jsx      # Stimulsoft Designer Modal，版面存 DB（SRP_REPORTFILE）
│           └── SysReportQuery.jsx        # ★ 可重用【系統報表查詢】元件 + Modal 包裝
```

> 原始 ERP2026 專案還有 `.claude/skills/run-master-seed/`（灌 Oracle 測試資料用），此份 ERP2026Pg 副本沒有複製過來（見〈重新產生測試資料〉小節）。

---

## 資料庫

### 連線資訊

```
Host:     localhost
Port:     5432
Database: erp
User:     erpuser
Password: erpuser
```

> Role `erpuser` 是 `erp` 資料庫的 owner。PostgreSQL 15+ 預設會把 `public` schema 的 `CREATE` 權限從 `PUBLIC` 收回，
> 新建資料庫後需額外執行一次 `ALTER SCHEMA public OWNER TO erpuser;`（用 superuser 連線執行），`erpuser` 才能建表。

### 資料表 Owner

資料表由 PowerDesigner PDM 產生 DDL 後手動建立（不是後端程式或 Claude 自動建的）。目前共 33 張：

| 分類 | 資料表 | 資料來源 |
|--------|------|---------|
| 基本資料（4） | `tbl_customer`／`tbl_supplier`／`tbl_product`／`tbl_employe` | **Delphi6ERP（MSSQL）真實資料**，見〈搬移 Delphi6ERP 業務資料〉 |
| 交易/庫存/總帳（21） | `tbl_ship`／`tbl_ship_dt`／`tbl_po_recv`／`tbl_po_recv_dt`／`tbl_ar_recv`／`tbl_ar_recv_dt`／`tbl_ap_pay`／`tbl_ap_pay_dt`／`tbl_inv_adj`／`tbl_inv_adj_dt`／`tbl_inventory`／`tbl_inv_onhand`／`tbl_transaction`／`tbl_car`／`tbl_acnt_account`／`tbl_acnt_type`／`tbl_acnt_journal`／`tbl_acnt_journal_dt`／`tbl_acnt_init`／`tbl_sys_param`／`tbl_his_ship`／`tbl_his_ship_dt`／`tbl_his_po_recv`／`tbl_his_po_recv_dt`／`tbl_fld_for_edit` | 同上，**Delphi6ERP（MSSQL）真實資料**（後端目前還沒有對應的功能頁面，屬於〈待開發功能〉） |
| 資料字典（2） | `tbldd`／`tbl_ddfield` | Oracle 測試資料（`migrate_oracle_to_pg.py`），已上線使用中 |
| 系統報表引擎（2） | `tblsysreport`／`tblsysreportfield` | **Delphi6ERP（MSSQL）真實資料**（52 份報表、144 個查詢欄位），透過 `.claude/skills/import-sysreport` 匯入 |

> Postgres 對沒加雙引號的識別字一律會摺疊成小寫，所以資料表/欄位名稱在 DB 裡實際都是小寫（`tbl_customer`、`cum_no`…），
> 即使 DDL／SQL 語句裡寫大寫（`SELECT P.PRD_NO`）也查得到資料，只是查詢「結果」的欄位名稱一律會是小寫。

### 搬移 Delphi6ERP 業務資料（`migrate_mssql_to_pg.py`）

29 張業務表（基本資料 + 交易/庫存/總帳）的真實資料來自公司原有的桌面版系統
**Delphi6ERP**（Delphi 6 + MSSQL，原始碼在 `D:\ERP2026Pg\Delphi6ERP`）。
`backend/scripts/migrate_mssql_to_pg.py` 會連線 MSSQL、動態 introspect 出這些表的
欄位/型態/PK/FK，**自動產生 DDL（含中文欄位註解）** 並 `DROP + CREATE` 目標表，
再全量複製資料：

```bash
cd ERP2026/backend/scripts
python migrate_mssql_to_pg.py
```

- MSSQL 連線寫死在腳本內：`tnvtrsap01` / `erp`（帳密 `erp`/`erp`）
- **不會動** `tbldd`／`tbl_ddfield`／`tblsysreport`／`tblsysreportfield` 這 4 張表（新系統自己的報表引擎，MSSQL 沒有相容的結構）
- 型態轉換：`money`→`numeric(18,4)`（不用 `money`，理由同下）、`bit`→`boolean`、`identity`→`serial`、`datetime`→`timestamp`（不能用 `date`，好幾個欄位真的存了非午夜的時間，見下方註解）
- 中文欄位註解（`COMMENT ON TABLE/COLUMN`）取自 PowerDesigner 的 `ERP.pdm`（`pdm_comments.json` 是解析結果，不用手動維護）
- 中文資料是 Big5（`charset='CP950'`）非 Unicode collation，pymssql 預設編碼會讀成亂碼，連線時要指定 charset
- 執行後會產生 `backend/scripts/ddl_from_mssql.sql` 存檔，方便查看實際套用的 DDL

> **這支腳本會 `DROP TABLE` 重建** 29 張表，跟只搬資料的 `mssql_migrate.py`／`import-sysreport` 不一樣，
> 重跑之前確認沒有手動改過這些表的結構（例如把 `money` 改成 `numeric` 之類的調整，會被蓋掉）。

### MSSQL 資料轉入 PostgreSQL（`/system/mssql-migrate` 網頁功能）

給日後其他站點的 Delphi6ERP／MSSQL 資料庫做「系統導入」用的正式功能（不是開發用的一次性腳本）：

- 後端：`backend/routers/mssql_migrate.py`（`POST /api/mssql-migrate/test`、`POST /api/mssql-migrate/run`）
- 前端：`frontend/src/pages/MssqlMigrate.jsx`（系統設定 → MSSQL 資料轉入）
- **跟 `migrate_mssql_to_pg.py` 的關鍵差異：這個功能只搬資料，不動 DDL**——目標 Postgres 表要先用 PowerDesigner 之類的工具建好，程式只會 `TRUNCATE` 跟 MSSQL 同名的表再匯入，動態抓「MSSQL 有、Postgres 也有」的同名表跟欄位交集，`tbldd`/`tbl_ddfield`/`tblsysreport`/`tblsysreportfield` 永遠排除
- MSSQL 連線資訊由使用者在畫面上輸入（伺服器/連接埠/資料庫/帳密），不落地儲存；PostgreSQL 端固定用系統既有連線設定
- 「開始搬移」有二次確認 Modal，因為會 TRUNCATE 覆蓋現有資料

### 匯入系統報表定義（`.claude/skills/import-sysreport`）

`tblsysreport`／`tblsysreportfield` 現在的 schema 跟 Delphi6ERP 完全一致（見〈系統報表模組〉），
所以是單純資料複製，不需要欄位轉換，獨立於上面兩個工具之外（它們都明確排除這兩張表）：

```bash
cd ERP2026/.claude/skills/import-sysreport
python import_sysreport.py
```

- 全量複製 MSSQL 的 52 份報表主檔 + 144 個查詢欄位定義
- **不會複製 `SRP_REPORTFILE`**（報表版面）：MSSQL 存的是 ReportBuilder 二進位格式，
  跟 Stimulsoft JSON 不相容，留空讓使用者在「系統報表管理」逐一用 Designer 重新設計
- 已知資料問題：MSSQL 原始資料裡 `FM_ACNT_001`（會計科目一覽表）的 `ACT_NO` 查詢欄位，
  `SRF_LIST_SQL` 誤寫成 `SELECT ACT_NO,ACT_NAME FROM TBL_CUSTOMER`（應為 `TBL_ACNT_ACCOUNT`），
  這是 MSSQL 來源本身的資料錯誤（其餘 67 個 SQL 型查詢欄位都正常），目前只在 Postgres
  端手動改過，重跑這支 skill 會把錯誤資料蓋回來，還沒決定要不要把這個修正寫進腳本裡。

#### TBLDD（資料字典主檔）

| 欄位 | 說明 |
|------|------|
| DDM_NO | PK，資料字典編號，其他畫面用這個編號指定要用哪個資料字典 |
| DDM_NAME | 資料字典名稱，即 Lookup 視窗標題 |
| DDM_SQL | 資料來源 SQL（僅允許單一 SELECT 查詢，後端會檔） |
| RET_VAL_FIELD | 選取後回傳的欄位名稱，需對應 DDM_SQL 查詢出的欄位 |
| IS_MULTI_SELECTED | 是否允許多選（`Y`/`N`） |

#### TBL_DDFIELD（資料字典欄位定義）

| 欄位 | 說明 |
|------|------|
| DDD_ID | PK，`SERIAL` |
| DDM_NO | FK → TBLDD.DDM_NO |
| DDD_FIELD | 欄位名稱，需對應 DDM_SQL 查詢出的欄位（可用「自動產生欄位定義」帶出） |
| DDD_FIELD_DISP | 欄位顯示名稱，Lookup 表格的欄位標題 |

### 重新產生資料字典測試資料

```bash
cd ERP2026/.claude/skills/run-master-seed
python seed300.py
```

此腳本為冪等操作（先刪後插），可重複執行。

> **注意**：`seed300.py` 是灌 Oracle 端測試資料用的，這個專案（ERP2026Pg）沒有複製 `.claude/skills/run-master-seed/` 過來，無法直接執行；而且現在也只剩 `tbldd`/`tbl_ddfield`
> 這 2 張表還在用 Oracle 測試資料（其餘 29+2 張表都已改成 Delphi6ERP／MSSQL 真實資料）。
> 要重灌 `tbldd`/`tbl_ddfield` 就重跑 `migrate_oracle_to_pg.py`（見上方）。

---

## 後端 FastAPI

### 啟動

```bash
cd ERP2026/backend
pip install -r requirements.txt
python -m uvicorn main:app --reload --port 8000
```

### API 路由總覽

#### 客戶主檔（`/api/customers`）

| Method | 路徑 | 說明 |
|--------|------|------|
| GET | `/api/customers` | 分頁查詢（支援關鍵字搜尋） |
| GET | `/api/customers/report-data` | Stimulsoft 資料來源（中文欄位名稱） |
| GET | `/api/customers/{cum_no}` | 取得單筆客戶 |
| POST | `/api/customers` | 新增客戶（201） |
| PUT | `/api/customers/{cum_no}` | 更新客戶 |
| DELETE | `/api/customers/{cum_no}` | 刪除客戶 |

#### 報表檔案（`/api/reports`）

| Method | 路徑 | 說明 |
|--------|------|------|
| GET | `/api/reports/customer` | 列出 `Report/Customer/*.mrt` 的檔名（不含副檔名） |
| GET | `/api/reports/customer/{filename}` | 下載單一 `.mrt` 檔（`Cache-Control: no-store`） |

#### 資料字典（`/api/datadict`）

| Method | 路徑 | 說明 |
|--------|------|------|
| GET | `/api/datadict` | 分頁查詢主檔（關鍵字比對編號/名稱） |
| GET | `/api/datadict/{ddm_no}` | 取得單筆主檔 |
| POST | `/api/datadict` | 新增主檔（201，DDM_SQL 需為單一 SELECT） |
| PUT | `/api/datadict/{ddm_no}` | 更新主檔 |
| DELETE | `/api/datadict/{ddm_no}` | 刪除主檔（會先刪除底下的欄位定義） |
| GET | `/api/datadict/{ddm_no}/fields` | 取得欄位定義清單 |
| POST | `/api/datadict/{ddm_no}/fields` | 新增欄位定義 |
| PUT | `/api/datadict/{ddm_no}/fields/{ddd_id}` | 更新欄位定義 |
| DELETE | `/api/datadict/{ddm_no}/fields/{ddd_id}` | 刪除欄位定義 |
| POST | `/api/datadict/{ddm_no}/fields/auto-generate` | 依 DDM_SQL 欄位結構自動產生欄位定義（保留已存在欄位的顯示名稱） |
| GET | `/api/datadict/{ddm_no}/meta` | 供 Lookup 元件用：主檔資訊 + 欄位定義清單 |
| GET | `/api/datadict/{ddm_no}/data?q=` | 執行 DDM_SQL 取得 Lookup 資料，`q` 可跨所有已定義欄位做關鍵字過濾（不分頁，回傳全部符合的資料） |

#### 系統報表（`/api/sysreport`，動態查詢引擎細節見〈系統報表模組〉）

| Method | 路徑 | 說明 |
|--------|------|------|
| GET | `/api/sysreport` | 分頁查詢主檔（關鍵字比對編號/名稱） |
| GET | `/api/sysreport/{srp_id}` | 取得單筆主檔 |
| POST | `/api/sysreport` | 新增主檔（201，SRP_SELECT 需為單一 SELECT，SRP_CODE 唯一） |
| PUT | `/api/sysreport/{srp_id}` | 更新主檔 |
| DELETE | `/api/sysreport/{srp_id}` | 刪除主檔（會先刪除底下的查詢欄位） |
| GET | `/api/sysreport/{srp_id}/reportfile` | 取得報表版面 JSON（`SRP_REPORTFILE`） |
| PUT | `/api/sysreport/{srp_id}/reportfile` | 儲存報表版面 JSON |
| GET | `/api/sysreport/{srp_id}/select-columns` | 執行 `SRP_SELECT+WHERE(強制1=2)+GROUPBY+ORDERBY` 列出真實可選欄位，供新增查詢欄位時的「選欄位」picker 用 |
| GET | `/api/sysreport/{srp_id}/fields` | 取得查詢欄位清單 |
| POST | `/api/sysreport/{srp_id}/fields` | 新增查詢欄位（`SRF_SEQNO` 由後端算 `MAX+1`，非使用者輸入） |
| PUT | `/api/sysreport/{srp_id}/fields/{srf_seqno}` | 更新查詢欄位（複合鍵，路徑用 `srf_seqno` 不是代理鍵） |
| DELETE | `/api/sysreport/{srp_id}/fields/{srf_seqno}` | 刪除查詢欄位 |
| GET | `/api/sysreport/{srp_id}/fields/{srf_seqno}/lookup-data?q=` | 執行該欄位的 `SRF_LIST_SQL`，回傳挑選視窗用的資料列 + 欄位標題（`SRF_CONTROLTYPE=SQL` 專用） |
| GET | `/api/sysreport/{srp_id}/query-meta` | 供【系統報表查詢】元件用：主檔資訊 + 查詢欄位（`SRF_ISWHERE=true`）+ 依 `SRF_ISSORT` 算出的預設排序清單 |
| GET | `/api/sysreport/{srp_id}/query?criteria=&orderby=` | 動態組 `SELECT+WHERE+GROUPBY+ORDER BY` 並執行（`criteria`/`orderby` 為 URL-encoded JSON），回傳資料列 |

#### MSSQL 資料轉入（`/api/mssql-migrate`，見〈資料庫〉章節）

| Method | 路徑 | 說明 |
|--------|------|------|
| POST | `/api/mssql-migrate/test` | 驗證 MSSQL 連線資訊，回傳跟 PostgreSQL 同名可搬移的表清單 |
| POST | `/api/mssql-migrate/run` | TRUNCATE 目標同名表後從 MSSQL 全量匯入，回傳每張表的搬移筆數 |

### 查詢參數（GET /api/customers）

| 參數 | 說明 |
|------|------|
| `q` | 關鍵字，比對 CUM_NO / CUM_NAME / CUM_UNIFORM_NO |
| `page` | 頁碼（預設 1） |
| `page_size` | 每頁筆數（預設 20，最大 500） |

---

## 前端 React + Vite

### 啟動

```bash
cd ERP2026/frontend
npm install
npm run dev
```

瀏覽器開啟：`http://localhost:5173`

### Vite Proxy

`/api/*` 請求自動轉發到 `http://localhost:8000`，開發時不需處理 CORS。

```js
// vite.config.js
proxy: { '/api': { target: 'http://localhost:8000', changeOrigin: true } }
```

### 已實作頁面 / 元件

| 檔案 | 說明 |
|------|------|
| `pages/CustomerMaster.jsx` | 客戶主檔維護（查詢、分頁、新增、編輯、刪除、列印選單） |
| `components/CustomerFormModal.jsx` | 新增 / 編輯客戶表單（基本、聯絡、財務資料） |
| `components/CustomerReport.jsx` | Stimulsoft 報表 Modal（設計版面 Tab + 預覽列印 Tab，版面存 localStorage） |
| `components/CustomerReportPreview.jsx` | Stimulsoft 純預覽 Modal（直接載入 `.mrt` 檔，每次強制重新整理） |
| `pages/DataDictMaster.jsx` | 資料字典維護（主檔 + 欄位定義雙表格、自動產生欄位定義、測試 Lookup） |
| `components/DataDictFormModal.jsx` | 新增 / 編輯資料字典主檔表單 |
| `components/DataDictFieldFormModal.jsx` | 新增 / 編輯資料字典欄位表單 |
| `components/DataDictLookup.jsx` | ★ 可重用 Lookup 元件，其他頁面需要「選值」時直接掛用（詳見下一節） |
| `components/DDLookupEdit.jsx` | ★ 打字下拉選單（單選）+ 搜尋鈕開完整 Modal（可多選），`displayField` 決定畫面顯示欄位、`value` 仍是 `RET_VAL_FIELD` |
| `lib/ddLookup.jsx` | ★ `DDLookup.getDDLookup(ddmNo)`：呼叫式 Lookup，不用寫 `<DataDictLookup>` JSX，回傳 Promise |
| `api/customers.js` | customerApi（list / get / create / update / remove / reportDataUrl） |
| `api/reports.js` | reportApi（listCustomer / customerReportUrl，URL 含 `?_=timestamp` cache-buster） |
| `api/datadict.js` | dataDictApi（主檔/欄位 CRUD、autoGenerateFields、getMeta、getData） |
| `pages/MssqlMigrate.jsx` | 「MSSQL 資料轉入 PostgreSQL」頁面：連線資訊表單、測試連線、二次確認後執行搬移、結果表格 |
| `api/mssqlMigrate.js` | mssqlMigrateApi（test / run，5 分鐘 timeout） |

---

## 資料字典與可重用 Lookup 元件

「資料字典」是一個可設定的 Table Lookup 元件來源：先在**資料字典維護**頁面（分頁「資料字典維護」）定義好一筆資料字典，之後任何頁面只要知道它的 `DDM_NO`，就能直接掛上 `<DataDictLookup>` 元件做選值查詢，不用另外寫 Modal / API。

### 運作原理

- **TBLDD**（主檔）：定義 Lookup 的資料來源 SQL、回傳欄位、是否多選。
- **TBL_DDFIELD**（欄位定義）：定義 Lookup 表格要顯示哪些欄位、標題是什麼；可用「自動產生欄位定義」依 DDM_SQL 的欄位結構自動帶出（已存在的欄位會保留原顯示名稱）。
- `DataDictLookup` 元件在開啟時呼叫 `GET /api/datadict/{ddm_no}/meta` 取得表格欄位與設定，呼叫 `GET /api/datadict/{ddm_no}/data?q=` 取得（可依關鍵字過濾的）資料列；使用者選取後，元件依 `RET_VAL_FIELD` 從選取列中取值，以 **JSON Array** 回傳（單選也是陣列，只是長度為 1）。

> **⚠️ `RET_VAL_FIELD` / `DDD_FIELD` 大小寫踩坑（PostgreSQL 遷移後才會遇到）**：
> `GET /api/datadict/{ddm_no}/data` 回傳的每個欄位 key，就是該欄位在 `TBL_DDFIELD.DDD_FIELD` 存的原始大小寫字串（後端已做大小寫不敏感比對，抓值時不受 Postgres 欄位一律小寫的影響）。
> 但前端 `r[retField]`（`DataDictLookup.jsx` 的 `rowKey`／回傳值）、`row[displayField]`（`DDLookupEdit` 的顯示欄位）都是**區分大小寫**的 JS 屬性存取。
> 所以新增資料字典時，**`RET_VAL_FIELD` 與呼叫端傳入的 `displayField` 大小寫必須跟對應的 `DDD_FIELD` 完全一致**，不然畫面會出現「打勾一筆變全選」（`rowKey` 全部解析成 `undefined`）或欄位空白等詭異現象。目前 `TBL_CUSTOMER`／`TBLDD` 兩個字典統一用小寫；`TBL_PRODUCT` 統一用大寫，兩種都可以，重點是同一個字典裡要一致。

### 新增一個資料字典（前置作業）

1. 到「資料字典維護」頁面點「新增資料字典」，填 `DDM_NO`（其他頁面程式碼要用到）、`DDM_NAME`（Lookup 標題）、`DDM_SQL`（單一 SELECT 查詢）、`RET_VAL_FIELD`（回傳欄位）、是否多選。
2. 選取剛新增的那筆，點「自動產生欄位定義」，系統會依 SQL 欄位結構自動列出欄位；可再逐一「編輯」欄位把顯示名稱改成中文。
3. 點該筆的「測試」按鈕，用 `DataDictLookup` 本尊確認搜尋、選取、回傳值都符合預期。

### 在其他頁面使用 `<DataDictLookup>`

```jsx
import { useState } from 'react'
import { Input, Button, Space } from 'antd'
import DataDictLookup from '../components/DataDictLookup'

function SalesOrderForm() {
  const [lookupOpen, setLookupOpen] = useState(false)
  const [cumNo, setCumNo] = useState('')

  return (
    <>
      <Space.Compact style={{ width: '100%' }}>
        <Input value={cumNo} readOnly placeholder="客戶編號" />
        <Button onClick={() => setLookupOpen(true)}>選擇</Button>
      </Space.Compact>

      <DataDictLookup
        ddmNo="TBL_CUSTOMER"                 // 對應 TBLDD.DDM_NO
        open={lookupOpen}
        onCancel={() => setLookupOpen(false)}
        onConfirm={(values) => {
          setCumNo(values[0])                // 單選：取第一筆；多選則整個陣列都要
          setLookupOpen(false)
        }}
      />
    </>
  )
}
```

#### Props

| Prop | 型別 | 說明 |
|------|------|------|
| `ddmNo` | string | 要使用的資料字典編號（`TBLDD.DDM_NO`），需已在資料字典維護頁面建立並定義好欄位 |
| `open` | boolean | 是否顯示 Modal |
| `onCancel` | () => void | 取消 / 關閉時呼叫 |
| `onConfirm` | (values, rows) => void | 按下「確認」時呼叫：`values` 為選取列的 `RET_VAL_FIELD` 值陣列（JSON Array，單選也是陣列）；`rows` 為選取的完整資料列，需要其他欄位（例如同時要客戶名稱）可從這裡取 |

> 元件內部已處理搜尋框、欄位標題（依 `TBL_DDFIELD`）、單選/多選（依 `TBLDD.IS_MULTI_SELECTED`），呼叫端只需要管開關狀態與拿回傳值即可。

### 呼叫式用法：`DDLookup.getDDLookup(ddmNo)`

不想在頁面上寫 `<DataDictLookup>` JSX、管 `open` state 的話，可以改用 `frontend/src/lib/ddLookup.jsx` 匯出的 `DDLookup`。呼叫後會動態把 Modal 掛到 `document.body`，使用者操作完再自動卸載，回傳一個 Promise：

```jsx
import { DDLookup } from '../lib/ddLookup'

async function handlePickCustomer() {
  const result = await DDLookup.getDDLookup('TBL_CUSTOMER')
  if (!result) return                 // 使用者取消，resolve 為 null
  setCumNo(result.values[0])          // RET_VAL_FIELD 值陣列
  setCumName(result.rows[0]?.CUM_NAME) // 完整選取列，可取其他欄位
}
```

- `result === null`：使用者取消（X / 取消鈕 / 點遮罩 / Esc 都算）。
- `result === { values, rows }`：確認選取，`values`/`rows` 內容與 `<DataDictLookup>` 的 `onConfirm(values, rows)` 完全一致。
- 因為動態掛載的是**獨立的 React root**，`ddLookup.jsx` 內部會自己包一層跟 `main.jsx` 相同的 `<ConfigProvider>`（設定集中在 `frontend/src/theme.js`，兩處共用，避免改主題漏改一處）。
- 連續呼叫多次會各自獨立掛載、各自 resolve，antd Modal 原生處理堆疊 z-index，不需要排隊機制。

### 輸入框元件：`<DDLookupEdit>`

大部分表單欄位（客戶編號、產品編號⋯）都會用到資料字典選值，`frontend/src/components/DDLookupEdit.jsx` 把常見的兩種選值方式包在同一個元件裡，一行接上：

```jsx
import { useState } from 'react'
import DDLookupEdit from '../components/DDLookupEdit'

function SalesOrderForm() {
  const [cumNo, setCumNo] = useState('')       // 綁定用的值，永遠是 RET_VAL_FIELD（例如 CUM_NO）
  const [cumName, setCumName] = useState('')   // 畫面顯示用文字，由 displayField 決定內容

  return (
    <DDLookupEdit
      ddmNo="TBL_CUSTOMER"
      displayField="CUM_NAME"                  // 選填：畫面顯示客戶名稱而非編號，需為該字典 TBL_DDFIELD.DDD_FIELD 之一
      value={cumName}                          // 顯示用的 state 要跟著 displayField 走
      onChange={(values, rows, displayText) => {
        setCumNo(values.join(', '))            // 真正要存的值：RET_VAL_FIELD（不受 displayField 影響）
        setCumName(displayText)                // 畫面顯示文字：元件已依 displayField 算好
      }}
      placeholder="客戶編號"
    />
  )
}
```

**兩種選值方式並存**：
1. **直接輸入文字**：邊打字邊向後端查（`GET /api/datadict/{ddm_no}/data?q=`，debounce 300ms），下方即時出現符合條件的下拉選單，點選其一——這個方式**一次只能選一筆**，適合快速輸入已知編號。
2. **點右邊搜尋按鈕**：開啟完整的 `DDLookup` Modal，可瀏覽、搜尋、多選（依資料字典的 `IS_MULTI_SELECTED` 設定）——多選情境一定要用這個方式，打字下拉選單不支援多選。

不管走哪個路徑，最終都是呼叫 `onChange(values, rows, displayText)`：

- **`values`/`rows`**：永遠是 `TBLDD.RET_VAL_FIELD` 對應的值與完整選取列，**單選或多選完全由資料字典本身的 `IS_MULTI_SELECTED` 決定**，`DDLookupEdit` 不會替呼叫端做任何截斷（單選時陣列長度自然是 1），要怎麼儲存由呼叫端自己決定。
- **`displayText`**：選填的 `displayField` 決定選取後畫面上要顯示哪個欄位（需對應該字典 `TBL_DDFIELD.DDD_FIELD` 之一，找不到會 `console.warn` 並退回顯示 `RET_VAL_FIELD`）；多筆選取時自動用 `, ` 接起來。沒給 `displayField` 就跟以前一樣顯示 `RET_VAL_FIELD` 的值。

Props：`ddmNo`（必填）、`displayField`（選填，畫面顯示欄位）、`value`（顯示字串）、`onChange(values, rows, displayText)`、`placeholder`、`disabled`、`style`。

---

## 系統報表模組

「系統報表」允許使用者自行定義報表的資料來源 SQL、查詢條件欄位、排序欄位，並透過 Stimulsoft Designer 設計報表版面，最後產生一個可重用的查詢畫面，不需要為每張報表另外寫程式。

**這個模組的 schema 跟查詢引擎，刻意改成跟舊系統 Delphi6ERP 的 `SysReport.DLL` 完全一樣的動態組 SQL 方式**（不是自創設計）——原因跟做法見下方〈與 Delphi6ERP 的對應關係〉。

### 資料表

- **TBLSYSREPORT**（系統報表主檔）：`SRP_ID`（PK，一般 `integer`、非 identity，由後端算 `MAX+1` 配號）、`SRP_CODE`（**唯一**）、`SRP_NAME`、`SRP_DESCRIPTION`、`SRP_SELECT`（NOT NULL，單一 SELECT）、`SRP_WHERE`（選填，**要含 `WHERE` 關鍵字本身**）、`SRP_GROUPBY`（選填，要含 `GROUP BY`）、`SRP_ORDERBY`（選填，要含 `ORDER BY`）、`SRP_REPORTFILE`（Stimulsoft 版面 JSON）。
- **TBLSYSREPORTFIELD**（系統報表查詢欄位）：複合主鍵 `(SRP_ID, SRF_SEQNO)`（`SRF_SEQNO` 同樣由後端算 `MAX+1`）、`SRF_FIELDNAME`/`SRF_TABLEALIAS`（實際欄位名稱+別名，要跟 `SRP_SELECT` 裡的別名對得上，例如 `SELECT A.* FROM TBL_CUSTOMER A` 這裡別名填 `A`）、`SRF_DISPNAME`、`SRF_DISPORDER`、`SRF_DATATYPE`（`String`/`Numberic`/`Date`，`Numberic` 的拼法故意跟舊系統一致，見下）、`SRF_CONTROLTYPE`（`Edit`/`Date`/`ListItem`/`SQL`）、`SRF_QUERYTYPE`（`Single`/`Range`/`MultiSelect`，`MultiSelect` 只能搭配 `SQL` 控制項）、`SRF_ISMUSTCRITERIA`/`SRF_ISWHERE`/`SRF_ISSORT`/`SRF_SORTDEC`（boolean，一個欄位可以同時是查詢條件又是排序欄位）、`SRF_LIST_VALUE`（`ListItem` 用，逗號分隔選項）、`SRF_LIST_SQL`/`SRF_LIST_RETURNFIELD`/`SRF_LIST_FIELDDISP`（`SQL` 控制項用，見下）。

### 與 Delphi6ERP 的對應關係

上面這套 schema／詞彙**刻意逐一比照** Delphi6ERP 的 `SysReport.DLL`（`Form_Query.pas`/`Form_SysReportQuery.pas`/`Form_SysRepFldDefEdit.pas`），不是巧合也不是新設計。原因：

1. 舊系統的查詢條件**不是靠 `:param` 佔位符替換**寫死的 SQL，而是系統依每個查詢欄位的 `SRF_TABLEALIAS.SRF_FIELDNAME` 動態組出 WHERE 片段（`欄位 = 值`／`BETWEEN`／`IN`），一個個 `AND` 接到 `SRP_WHERE` 後面——這套機制天生就支援 `MultiSelect`（IN 清單），比舊版 ERP2026 自創的「作者手寫完整 SQL + `:param`」設計更彈性，也更貼近舊系統 52 份報表定義的實際寫法。
2. `TBLSYSREPORT`/`TBLSYSREPORTFIELD` 的 schema 現在跟 MSSQL 端**完全一致**，代表舊系統的報表定義可以直接原樣複製過來用（`.claude/skills/import-sysreport`），不需要任何欄位轉換/對照表。

**動態組 SQL 的實際規則**（`backend/routers/sysreport.py` 的 `run_query`）：

- 對每個 `SRF_ISWHERE=true` 的欄位，依 `SRF_QUERYTYPE` 組 WHERE 片段，**只有使用者真的有輸入值才會加進 WHERE**（不像舊版 ERP2026 需要 `DEFAULT_VAL`/NULL-safe 寫法處理留空）：
  - `Single`：字串型（`SRF_DATATYPE=String`）用 `LIKE`（**不自動加 `%` 萬用字元**，要比對包含關係得自己在輸入值前後打 `%`，這點刻意比照舊系統原行為）；其餘用 `=`
  - `Range`：兩邊都填用 `BETWEEN`，只填一邊用 `>=`/`<=`（支援單邊，同舊系統）
  - `MultiSelect`：組 `IN (...)`，前端對應的挑選視窗是 `SysReportFieldPicker.jsx`
  - 所有值一律走 psycopg 參數化綁定（`%(pN)s`），不是舊系統原本的字串拼接（那是真的會有 injection 風險，這裡刻意不照抄）
- 排序：從 `SRF_ISSORT=true` 的欄位依 `SRF_DISPORDER`/`SRF_SORTDEC` 算出預設排序清單（`query-meta` 回傳的 `orderby_default`），使用者在查詢畫面調整過的清單會覆蓋預設值
- 最終 SQL＝`SRP_SELECT + (SRP_WHERE 動態接 AND 條件) + SRP_GROUPBY + (SRP_ORDERBY 動態接排序)`
- **`SRF_CONTROLTYPE=SQL` 的欄位**（單選或多選）挑選視窗資料來自它自己的 `SRF_LIST_SQL`（不是共用資料字典 `TBLDD`，這是刻意的設計決定——比照舊系統「每個欄位各自帶內嵌 lookup」的做法，因為 `TBLSYSREPORTFIELD` 已經不再有 `DDM_NO` 欄位）：`SRF_LIST_SQL` 選出的欄位依序對應 `SRF_LIST_FIELDDISP`（逗號分隔的顯示標題），`SRF_LIST_RETURNFIELD` 是使用者選取後真正拿去查詢的欄位（後端會比對大小寫解析成 Postgres 實際欄位名，理由同〈資料字典〉小節的踩坑）
- 「新增查詢欄位」表單有「從 SRP_SELECT 選欄位」的挑選器（`GET /api/sysreport/{srp_id}/select-columns`），執行 `SRP_SELECT+WHERE(強制1=2)+GROUPBY+ORDERBY` 拿到真實欄位清單＋自動推斷的 `SRF_DATATYPE`，比舊版 ERP2026「正則掃描 `:param` 一次全部產生」的自動產生機制更貼近舊系統一次挑一個欄位的做法

### 前端元件

| 檔案 | 說明 |
|------|------|
| `pages/SysReportMaster.jsx` | 系統報表定義維護頁面（主檔 CRUD + 查詢欄位/設計/測試按鈕） |
| `components/SysReportFormModal.jsx` | 新增 / 編輯系統報表主檔表單（`SRP_SELECT`/`WHERE`/`GROUPBY`/`ORDERBY` 四個輸入框） |
| `components/SysReportFieldMaintModal.jsx` | 查詢欄位維護畫面（Grid Modal，rowKey 為 `srf_seqno`） |
| `components/SysReportFieldFormModal.jsx` | 新增 / 編輯單筆查詢欄位表單，含「從 SRP_SELECT 選欄位」下拉選單、依 `SRF_CONTROLTYPE`/`SRF_QUERYTYPE` 動態顯示 `ListItem`/`SQL` 相關輸入框 |
| `components/SysReportFieldPicker.jsx` | ★ `SRF_CONTROLTYPE=SQL` 查詢欄位的挑選視窗，執行該欄位的 `SRF_LIST_SQL`，依 `SRF_QUERYTYPE` 決定單選（radio）或多選（checkbox），概念上很像 `DataDictLookup` 但資料來源是欄位自己的 SQL 不是共用 `TBLDD` |
| `components/SysReportDesigner.jsx` | Stimulsoft Designer Modal，版面讀寫 `SRP_REPORTFILE`；開啟時呼叫 `runQuery`（無查詢條件）灌入實際資料，DataSource 會自動列出所有真實欄位，不用等使用者先查詢過 |
| `components/SysReportQuery.jsx` | ★ 可重用【系統報表查詢】元件。`SysReportQuery`（`forwardRef`）依查詢欄位定義動態產生輸入控制項、排序清單可上下調整；預覽動作透過 `useImperativeHandle` 暴露 `preview()` 供外部呼叫，實際渲染在另一個獨立的全螢幕 Modal（`width/height=100vw/100vh`，無標題列/底部命令列）。`SysReportQueryModal` 是外層 Modal 包裝，底部只有「預覽」按鈕（無「關閉」，靠標題列右上角 X 關閉），透過 ref 觸發 `SysReportQuery` 的 `preview()` |
| `api/sysreport.js` | sysReportApi（主檔/欄位 CRUD、selectColumns、fieldLookupData、query-meta、runQuery） |

---

## Stimulsoft 報表設計器

### 授權

- 商品：**Stimulsoft Reports.JS — Single Developer License**
- 費用：約 $800 USD（首次），續約 $400 USD/年（可不續約繼續用舊版）
- 購買：https://www.stimulsoft.com/en/online-store/purchase#js
- 客戶端（End User）使用報表：**免 Royalty**，不限客戶數量

### 安裝步驟

```bash
cd ERP2026/frontend
npm install
```

`stimulsoft-reports-js` 已列在 `package.json` dependencies，且 `postinstall` 腳本會自動執行 `copy-stimulsoft.js`，`npm install` 完成後即會自動產生以下 JS 檔：
- `stimulsoft.reports.js`
- `stimulsoft.viewer.js`
- `stimulsoft.designer.js`

`index.html` 已設定好 `<script>` 標籤，無需手動修改。

### 報表資料來源

- URL：`http://localhost:5173/api/customers/report-data`
- 格式：JSON 陣列，欄位名稱為中文（客戶編號、客戶名稱⋯）
- 資料表來源欄位名稱（`NameInSource`）：`Customers.root`

### 報表範本管理

| 模式 | 範本來源 | 說明 |
|------|---------|------|
| 報表設計（`CustomerReport`） | 瀏覽器 `localStorage`（key: `erp_customer_report_tpl`） | 可即時設計並儲存版面 |
| 預覽列印（`CustomerReportPreview`） | `Report/Customer/*.mrt` 檔案 | 透過 `/api/reports/customer/{filename}` 下載，每次強制從磁碟讀取（no-cache） |

### 新增報表

將設計好的 `.mrt` 檔案放入 `Report/Customer/` 目錄，頁面【列印】選單會自動出現對應的 Menu Item，無需修改程式碼。

### 注意事項

- `.mrt` 檔案若有相同 `ReportGuid`，`CustomerReportPreview` 在載入時會自動覆寫 GUID 以避免 Stimulsoft 內部快取干擾。
- 後端 `/api/reports/customer/{filename}` 回應加掛 `Cache-Control: no-store`，前端 URL 另附 `?_={timestamp}` 雙重防快取。
- **`report.regData(name, alias, data, synchronize)` 的第 4 個參數很重要**：只餵資料不帶 `synchronize=true`，Designer 左側 Dictionary 的 Data Sources 底下只會出現連線節點、展開不出任何欄位（要靠使用者手動走 Actions → Select Data 精靈才會加進欄位）；帶 `true` 才會立刻把欄位同步進 Dictionary，Designer 一開啟就看得到完整欄位清單。`SysReportDesigner.jsx` 在「尚未存過版面」時用這個方式帶入 SQL 查出的欄位；`CustomerReportPreview.jsx` / `SysReportQuery.jsx` 的預覽情境因為版面已經設計好、資料結構早就存在報表裡，只是要灌入實際資料做渲染，所以不需要這個參數。
- **`StiViewerOptions.appearance.fullScreenMode` 會影響版面配置，不是單純的顯示模式開關**：設為 `false`（多個既有範例的預設值）時，Viewer 會在工具列上方多保留一段空白區域；把 Viewer 容器做成整頁滿版（如 `SysReportQuery.jsx` 的全螢幕預覽 Modal）時要設成 `true`，那段空白才會消失，並建議同時明確給 `viewerOptions.width = '100%'` / `height = '100%'`。
- **`fullScreenMode=true` 時 Stimulsoft 會用 `position: fixed` + 極高的 `z-index`（原始碼內看到 `1000000`）蓋滿整個瀏覽器視窗**，這代表在 Viewer 容器內用一般的 `position:absolute` + `z-index` 疊加自訂按鈕（例如自訂的關閉鈕）會被蓋住，且怎麼調高 z-index 都沒用，因為 Stimulsoft 的覆蓋層很可能是另外掛在 `<body>` 下的獨立堆疊環境。解法是用 React `createPortal` 把自訂按鈕直接掛到 `document.body`，`position: fixed` 且 `z-index` 設得比 Stimulsoft 用的還高（`SysReportQuery.jsx` 目前用 `2000000`）。

---

## 啟動方式

需開兩個終端機：

**終端機 1 — 後端**

```bash
cd D:\ERP2026Pg\ERP2026\backend
python -m uvicorn main:app --reload --port 8000
```

**終端機 2 — 前端**

```bash
cd D:\ERP2026Pg\ERP2026\frontend
npm run dev
```

**瀏覽器**：開啟 `http://localhost:5173`

---

## 移植到新電腦

### 前置需求

| 軟體 | 版本需求 | 備註 |
|------|---------|------|
| Python | 3.10+ | 建議 3.12 或 3.13 |
| Node.js | 18+ | 建議 22.x |
| npm | 隨 Node.js | — |
| PostgreSQL | 16+ | 本機安裝，需自行建立 `erp` 資料庫與 `erpuser` role（見下） |

### 步驟

```bash
# 1. 複製專案目錄到新電腦
# （直接複製整個 ERP2026 資料夾）

# 2. 建立 PostgreSQL 資料庫與 role（用 psql 或 pgAdmin 執行）
```
```sql
CREATE ROLE erpuser WITH LOGIN PASSWORD 'erpuser';
CREATE DATABASE erp WITH OWNER = erpuser ENCODING = 'UTF8' CONNECTION LIMIT = -1;
-- PostgreSQL 15+ 預設會收回 public schema 的 CREATE 權限，需額外執行：
\c erp
ALTER SCHEMA public OWNER TO erpuser;
```
```bash
# 3. 用 PowerDesigner PDM（SA/ 目錄下）產生 DDL 並建表，或用既有資料庫的 pg_dump 還原

# 4. 安裝後端套件
cd ERP2026/backend
pip install -r requirements.txt

# 5. 安裝前端套件（postinstall 會自動複製 Stimulsoft JS 到 public/stimulsoft/）
cd ../frontend
npm install

# 6. 啟動（參考上方啟動方式）
```

> **注意**：`frontend/node_modules/` 和 `frontend/public/stimulsoft/` 不需要複製，
> 執行 `npm install` 後會自動重建。

---

## 已完成功能

- [x] 首頁與導覽架構（`react-router-dom`）
  - [x] `menuConfig.js`：定義 ERP2026 完整功能目錄（基本資料維護 / 交易單據維護 / 管理報表 / 會計總帳系統 / 成本作業 / 系統設定，共 6 大類 22 個功能項目）
  - [x] `MainLayout.jsx`：左側可收合導覽選單 + Header 麵包屑，所有頁面共用
  - [x] `Home.jsx`：首頁依分類顯示功能入口卡片，已開發項目標示「可使用」，未開發標示「開發中」
  - [x] `Placeholder.jsx`：尚未開發功能的統一預留頁面，依路徑自動帶出標題與分類
  - [x] 既有 3 個頁面掛回對應路徑：客戶主檔 → `/basic/customer`；資料字典維護 → `/system/datadict`（系統設定下獨立項目）；系統報表定義 → `/system/report`（對應「系統報表管理」）
- [x] PostgreSQL 16 遷移（原為 Oracle 19C）
  - [x] 後端 DB 驅動由 `oracledb` 換成 `psycopg[binary]`，連線資訊改為本機 `erp` 資料庫（`database.py`）
  - [x] 各 router SQL 語法轉換：具名 bind `:name` → `%(name)s`、`RETURNING ... INTO` OUT bind → `RETURNING` + `fetchone()`、Oracle unique 例外判斷（`ORA-00001`）→ `psycopg.errors.UniqueViolation`、`TO_CHAR()` → `CAST(... AS TEXT)`、無別名 inline view 補上別名（Postgres 強制要求）
  - [x] `backend/scripts/migrate_oracle_to_pg.py`：Oracle → PostgreSQL 一次性資料 clone（可重複執行）
  - [x] 金額欄位改用 `NUMERIC(18,4)`（原規劃過渡用 `money` 型態＋自訂 psycopg loader，後改為統一用 NUMERIC 更單純）
  - [x] 修正資料字典 `DDD_FIELD`／`RET_VAL_FIELD` 大小寫對應問題（見〈資料字典與可重用 Lookup 元件〉小節）
- [x] Delphi6ERP（MSSQL）業務資料遷移
  - [x] `backend/scripts/migrate_mssql_to_pg.py`：動態 introspect MSSQL 29 張業務表，自動產生 DDL（含 `ERP.pdm` 中文欄位註解）+ 全量複製資料，可重複執行
  - [x] 抓到並修正中文欄位 Big5（CP950）編碼問題（pymssql 預設編碼會讀成亂碼）
  - [x] 金額/日期型態決策：`money`→`NUMERIC(18,4)`、`datetime`→`timestamp`（保留時間精度，部分欄位如 `tbl_ar_recv.arr_date` 100% 都有非午夜時間）
  - [x] 「MSSQL 資料轉入 PostgreSQL」網頁功能（`/system/mssql-migrate`）：給日後其他站點系統導入用，使用者輸入 MSSQL 連線資訊、系統固定用既有 PostgreSQL 連線，只搬資料不動 DDL
  - [x] `.claude/skills/import-sysreport`：TBLSYSREPORT/TBLSYSREPORTFIELD 從 MSSQL 原樣匯入（52 份報表、144 個查詢欄位）
- [x] 客戶主檔維護頁面
  - [x] 關鍵字查詢（編號 / 名稱 / 統一編號）
  - [x] 分頁顯示（20 筆/頁，可調整）
  - [x] 新增客戶（表單驗證、重複編號檢查）
  - [x] 編輯客戶（表單預填）
  - [x] 刪除客戶（Popconfirm 確認）
  - [x] 列印選單（Dropdown，自動掃描 `Report/Customer/*.mrt`）
  - [x] 報表預覽列印（`CustomerReportPreview`，載入 `.mrt` 檔，強制 no-cache）
  - [x] 報表設計器（`CustomerReport`，Stimulsoft Designer + Viewer，版面存 localStorage）
  - [x] 報表資料來源 API（`/api/customers/report-data`）
  - [x] 報表檔案 API（`/api/reports/customer`，列表 + 下載，no-cache headers）
- [x] 資料字典模組（TBLDD / TBL_DDFIELD）
  - [x] 資料字典維護頁面（主檔 + 欄位定義雙表格，新增/編輯/刪除）
  - [x] 自動產生欄位定義（依 DDM_SQL 欄位結構）
  - [x] 可重用 `DataDictLookup` 元件（搜尋、單/多選、JSON Array 回傳）
  - [x] 主檔 DDM_SQL 僅允許單一 SELECT（後端檢查，防止多重語句）
  - [x] 呼叫式 `DDLookup.getDDLookup(ddmNo)`（Promise API，動態掛載/卸載，不用寫 JSX）
  - [x] `DDLookupEdit` 元件（打字下拉選單快速選 + 搜尋鈕開完整 Modal 可多選，一行接上資料字典）
  - [x] `DDLookupEdit` 支援 `displayField`：畫面顯示指定欄位、底層值仍是 `RET_VAL_FIELD`
- [x] 系統報表模組（TBLSYSREPORT / TBLSYSREPORTFIELD，schema 與動態查詢引擎已改成跟 Delphi6ERP 一致，見〈系統報表模組〉章節）
  - [x] 系統報表定義維護頁面（主檔新增/編輯/刪除、查詢欄位、設計、測試）
  - [x] 查詢欄位維護畫面（Modal Grid，複合鍵 `(srp_id, srf_seqno)`）+「從 SRP_SELECT 選欄位」挑選器（比照舊系統一次挑一個欄位）
  - [x] 動態組 WHERE/ORDER BY（比照 Delphi6ERP：Single→`=`/`LIKE`、Range→`BETWEEN`或單邊、**MultiSelect→`IN`**，全部參數化綁定不字串拼接）
  - [x] `SysReportFieldPicker`：`SRF_CONTROLTYPE=SQL` 查詢欄位的單選/多選挑選視窗，執行欄位自己的 `SRF_LIST_SQL`
  - [x] Stimulsoft Designer 版面設計，版面存 `TBLSYSREPORT.SRP_REPORTFILE`，開啟時自動帶入查詢結果讓 DataSource 立即可用
  - [x] 實測驗證：MSSQL 匯入的真實報表定義（`FM_CUM_001` 客戶編號速查表，含 Single/MultiSelect/Range 三種查詢欄位）在新引擎下正確執行

---

## 待開發功能

> 以下功能的**資料庫表跟真實資料已經在 `erp` 裡了**（Delphi6ERP／MSSQL 遷移過來的 29 張業務表，見〈資料庫〉章節），
> 缺的是後端 API 與前端頁面。

- [ ] 供應商主檔維護頁面（`tbl_supplier`，`/basic/supplier`）
- [ ] 產品主檔維護頁面（`tbl_product`，`/basic/product`）
- [ ] 員工資料管理（`tbl_employe`，`/basic/employee`）
- [ ] 交易單據維護（訂單 / 出貨單 `tbl_ship`／`tbl_ship_dt` / 進貨單 `tbl_po_recv`／`tbl_po_recv_dt` / 應收 `tbl_ar_recv` / 應付 `tbl_ap_pay` / 雜收發單據，見 `menuConfig.js` 的 `trade` 分類）
- [ ] 管理報表（應付/應收帳款統計表、明細表，見 `report` 分類；`ST_RPT_*`/`MG_*` 等對應報表定義已從 Delphi6ERP 匯入 `tblsysreport`，可以直接用系統報表模組承接，不一定要另外寫頁面）
- [ ] 會計總帳系統（傳票維護 `tbl_acnt_journal`／`tbl_acnt_journal_dt`、損益表、資產負債表、現金流量表，見 `gl` 分類；會計科目 `tbl_acnt_account`／`tbl_acnt_type` 資料已就緒）
- [ ] 成本作業（期間維護，見 `cost` 分類；庫存移動平均成本流水帳 `tbl_transaction` 資料已就緒，重算邏輯要參考 Delphi6ERP `erp_public.pas` 的 `InsertTransaction`/`UpdateTransaction` 重新實作，注意併發寫入下的成本重算正確性）
- [ ] 系統設定其餘項目（功能權限管理、系統資料設定、系統備份與還原，見 `system` 分類）
- [ ] 使用者登入 / 權限控管（Delphi6ERP 原本有硬編碼萬用密碼 `WYS`/`WYSEN` 後門，新系統設計登入機制時不要沿用）
- [ ] 52 份系統報表逐一在 Stimulsoft Designer 重新設計版面（`SRP_REPORTFILE` 目前都是 NULL，ReportBuilder 版面無法自動轉換，見〈匯入系統報表定義〉小節）
- [ ] Docker 部署設定

> 上述功能項目的路徑、圖示、分類已在 `frontend/src/menuConfig.js` 中定義好，開發對應頁面時只需：1) 建立頁面元件、2) 在 `App.jsx` 的 `readyComponents` 對照表加上該路徑對應的元件、3) 將 `menuConfig.js` 該項目加上 `ready: true`。

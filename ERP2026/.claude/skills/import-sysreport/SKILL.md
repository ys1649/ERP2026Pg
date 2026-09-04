---
name: import-sysreport
description: 將 Delphi6ERP（MSSQL）的 TBLSYSREPORT／TBLSYSREPORTFIELD 系統報表定義資料，原樣搬進 PostgreSQL（erp）。兩邊表結構已經完全一致，純資料複製，不搬報表版面（ReportBuilder blob 跟 Stimulsoft 不相容）。跟「MSSQL 資料轉入 PostgreSQL」網頁功能無關，那個功能明確排除這兩張表。
---

# 匯入系統報表定義（TBLSYSREPORT / TBLSYSREPORTFIELD）

## 用途

Delphi6ERP（舊系統，MSSQL）跟 ERP2026（新系統，PostgreSQL）的 `TBLSYSREPORT`／
`TBLSYSREPORTFIELD` 現在是完全相同的表結構（動態組 SQL 的查詢引擎，見
`backend/routers/sysreport.py`），所以可以直接把 MSSQL 的資料原樣複製過去，
不需要任何欄位對照或型態轉換。

## 執行方式

```bash
cd ERP2026/.claude/skills/import-sysreport
python import_sysreport.py
```

腳本可重複執行：每次執行前會先 `TRUNCATE` 目標的 `tblsysreport`／
`tblsysreportfield`，再從 MSSQL 全量複製進去。

## 這支腳本做了什麼

- 連線 MSSQL（Delphi6ERP，`tnvtrsap01`/`erp`，帳密 `erp`/`erp`），連線
  PostgreSQL（本機 `erp`，帳密 `erpuser`/`erpuser`）
- 全量複製 `TBLSYSREPORT`（52 份報表主檔）跟 `TBLSYSREPORTFIELD`（144 個查詢
  欄位定義）
- **不會複製 `SRP_REPORTFILE`（報表版面）**：MSSQL 存的是 ReportBuilder
  二進位格式，跟新系統的 Stimulsoft JSON 完全不相容，複製過去也沒用，留空
  讓使用者之後在「系統報表管理」用 Stimulsoft Designer 逐一重新設計
- MSSQL 的 `bit` 欄位（`SRF_ISMUSTCRITERIA`／`SRF_ISWHERE`／`SRF_ISSORT`／
  `SRF_SORTDEC`）轉成 PostgreSQL `boolean`
- 中文欄位用 Big5（CP950）編碼讀取，避免亂碼

## 執行前提

- MSSQL（`tnvtrsap01`/`erp`）可連線
- PostgreSQL 的 `tblsysreport`／`tblsysreportfield` 已經建好，結構要跟
  MSSQL 一致（複合鍵 `(srp_id, srf_seqno)`、`SRF_FIELDNAME`/`SRF_TABLEALIAS`/
  `SRF_QUERYTYPE` 等欄位齊全）
- 需要 `psycopg[binary]`、`pymssql`（跟 `backend/requirements.txt` 一致）

## 注意

搬完之後，`SRP_SQL`/`ORDERBY_LIST` 這類舊版新系統的欄位已經不存在了，直接
用 `SRP_SELECT`/`SRP_WHERE`/`SRP_GROUPBY`/`SRP_ORDERBY` 執行查詢即可。每份
報表要進「系統報表管理」→「設計」，用 Stimulsoft Designer 重新畫版面才能
預覽/列印；查詢條件、排序欄位、MultiSelect 挑選視窗都已經可以直接使用，
不用等版面畫完。

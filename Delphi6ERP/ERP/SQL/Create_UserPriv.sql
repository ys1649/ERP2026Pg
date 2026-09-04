/* ================================================================
   User 權限管理 - 新增資料表
   對應規劃文件：ProjectSummary.md / 權限管理 table 規劃討論

   權限指派模式：直接指派給 User（TBL_EMPLOYE.EPY_NO），不建角色/群組層
   權限粒度    ：二元（有這一列資料 = 有權限，沒有 = 沒有權限）
   ================================================================ */

/* ============================================================ */
/*   Table: TBL_SYS_FUNCTION                                    */
/*   系統功能目錄（對應 FORM_Main.dfm 主選單樹狀結構，              */
/*   資料庫原本沒有這張目錄表，這裡補上）                            */
/* ============================================================ */
create table TBL_SYS_FUNCTION
(
    FUN_CODE        varchar(30)   not null,   -- 大類節點用自訂代碼(GRP_xxx)；功能項目直接沿用 Delphi Action 名稱(actXxx)
    FUN_PARENT_CODE varchar(30)   null    ,   -- 大類節點為 NULL；功能項目指向所屬大類的 FUN_CODE
    FUN_NAME        varchar(80)   not null,   -- 顯示名稱
    FUN_SEQNO       int           not null,   -- 顯示順序
                                               -- 群組/功能項不另存欄位區分：FUN_PARENT_CODE IS NULL 即為大類群組
    FUN_IS_ACTIVE   bit           not null
        default 1,                           -- 停用後不再出現在指派清單，但保留歷史權限資料
    FUN_DESC        varchar(200)  null    ,
    constraint PK_TBL_SYS_FUNCTION primary key (FUN_CODE),
    constraint FK_FUN_PARENT foreign key (FUN_PARENT_CODE)
        references TBL_SYS_FUNCTION (FUN_CODE)
)
go

/* ============================================================ */
/*   Table: TBL_EPY_FUNCTION_PRIV                                */
/*   員工可用系統功能對應                                          */
/* ============================================================ */
create table TBL_EPY_FUNCTION_PRIV
(
    EPY_NO          varchar(20)   not null,
    FUN_CODE        varchar(30)   not null,
    PRV_GRANT_DATE  datetime      null    ,   -- 授權時間（稽核用，可選）
    PRV_GRANT_BY    varchar(20)   null    ,   -- 授權人 EPY_NO（稽核用，可選）
    constraint PK_TBL_EPY_FUNCTION_PRIV primary key (EPY_NO, FUN_CODE),
    constraint FK_EFP_EPY foreign key (EPY_NO)
        references TBL_EMPLOYE (EPY_NO),
    constraint FK_EFP_FUN foreign key (FUN_CODE)
        references TBL_SYS_FUNCTION (FUN_CODE)
)
go

/* ============================================================ */
/*   Table: TBL_EPY_REPORT_PRIV                                  */
/*   員工可用系統報表對應（報表目錄沿用既有 TBLSYSREPORT，          */
/*   不新建報表目錄表）                                            */
/* ============================================================ */
create table TBL_EPY_REPORT_PRIV
(
    EPY_NO          varchar(20)   not null,
    SRP_ID          int           not null,
    PRV_GRANT_DATE  datetime      null    ,
    PRV_GRANT_BY    varchar(20)   null    ,
    constraint PK_TBL_EPY_REPORT_PRIV primary key (EPY_NO, SRP_ID),
    constraint FK_ERP_EPY foreign key (EPY_NO)
        references TBL_EMPLOYE (EPY_NO),
    constraint FK_ERP_SRP foreign key (SRP_ID)
        references TBLSYSREPORT (SRP_ID)
)
go


/* ================================================================
   種子資料：TBL_SYS_FUNCTION
   4 個大類 + 24 個功能項，對應 FORM_Main.dfm 的 MainMenu1 實際結構
   ================================================================ */

/* -------- 大類 -------- */
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('GRP_BASE',  null, '基本資料',   10)
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('GRP_TRANS', null, '交易單據',   20)
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('GRP_ACNT',  null, '財務會計',   30)
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('GRP_SYS',   null, '系統設定',   40)

/* -------- 基本資料 -------- */
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('actCustomer',     'GRP_BASE', '客戶基本資料設定', 10)
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('actSupplier',     'GRP_BASE', '廠商基本資料設定', 20)
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('actProduct',      'GRP_BASE', '產品基本資料設定', 30)
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('actEmploye',      'GRP_BASE', '員工基本資料設定', 40)
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('actCar',          'GRP_BASE', '車輛基本資料設定', 50)
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('actACNT_ACCOUNT', 'GRP_BASE', '會計科目設定',     60)

/* -------- 交易單據 -------- */
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('actShip',    'GRP_TRANS', '銷退貨單管理', 10)
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('actPO_Recv', 'GRP_TRANS', '進退貨單管理', 20)
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('actAR_Recv', 'GRP_TRANS', '銷貨收款作業', 30)
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('actAP_Pay',  'GRP_TRANS', '進貨付款作業', 40)
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('actAdjust',  'GRP_TRANS', '庫房調整單',   50)

/* -------- 財務會計 -------- */
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('actACNT_JOURNAL',           'GRP_ACNT', '傳票維護',   10)
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('actACNT_RPT_DAILY',         'GRP_ACNT', '日記帳',     20)
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('actACNT_RPT_DETAIL',        'GRP_ACNT', '明細分類帳', 30)
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('actACNT_RPT_TB',            'GRP_ACNT', '試算表',     40)
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('actACNT_RPT_INCOME_STAEMENT','GRP_ACNT', '損益表',     50)
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('actACNT_RPT_ASSET',         'GRP_ACNT', '資產負債表', 60)
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('actACNT_RPT_CASH',          'GRP_ACNT', '現金簿',     70)
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('actACNT_RPT_BALANCE',       'GRP_ACNT', '科目餘額表', 80)

/* -------- 系統設定 -------- */
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('actData_Backup',          'GRP_SYS', '資料備份',     10)
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('actData_Restore',         'GRP_SYS', '資料還原',     20)
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('actSYS_PARAM',            'GRP_SYS', '系統設定',     30)
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('actResetInvTransaction',  'GRP_SYS', '庫存交易重整', 40)
insert into TBL_SYS_FUNCTION (FUN_CODE, FUN_PARENT_CODE, FUN_NAME, FUN_SEQNO) values ('actACNT_CHANGE_YEAR',     'GRP_SYS', '會計年度結轉', 50)
go

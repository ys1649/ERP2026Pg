/* ============================================================ */
/*   Database name:  ERP                                        */
/*   DBMS name:      Microsoft SQL Server 6.x                   */
/*   Created on:     2004/02/20  11:49                          */
/* ============================================================ */

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_ACNT_INIT')
            and   name  = 'TBL_ACNT_INIT_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_ACNT_INIT.TBL_ACNT_INIT_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_ACNT_INIT')
            and   type = 'U')
   drop table TBL_ACNT_INIT
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_ACNT_JOURNAL_DT')
            and   name  = 'TBL_ACNT_JOURNAL_DT_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_ACNT_JOURNAL_DT.TBL_ACNT_JOURNAL_DT_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_ACNT_JOURNAL_DT')
            and   type = 'U')
   drop table TBL_ACNT_JOURNAL_DT
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_HIS_PO_RECV_DT')
            and   name  = 'TBL_HIS_PO_RECV_DT_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_HIS_PO_RECV_DT.TBL_HIS_PO_RECV_DT_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_HIS_PO_RECV_DT')
            and   type = 'U')
   drop table TBL_HIS_PO_RECV_DT
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_HIS_SHIP_DT')
            and   name  = 'TBL_HIS_SHIP_DT_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_HIS_SHIP_DT.TBL_HIS_SHIP_DT_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_HIS_SHIP_DT')
            and   type = 'U')
   drop table TBL_HIS_SHIP_DT
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_INV_ADJ_DT')
            and   name  = 'TBL_INV_ADJ_DT_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_INV_ADJ_DT.TBL_INV_ADJ_DT_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_INV_ADJ_DT')
            and   type = 'U')
   drop table TBL_INV_ADJ_DT
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_AP_PAY_DT')
            and   name  = 'TBL_AP_PAY_DT_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_AP_PAY_DT.TBL_AP_PAY_DT_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_AP_PAY_DT')
            and   type = 'U')
   drop table TBL_AP_PAY_DT
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_AR_RECV_DT')
            and   name  = 'TBL_AR_RECV_DT_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_AR_RECV_DT.TBL_AR_RECV_DT_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_AR_RECV_DT')
            and   type = 'U')
   drop table TBL_AR_RECV_DT
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_TRANSACTION')
            and   name  = 'TBL_TRANSACTION_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_TRANSACTION.TBL_TRANSACTION_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_TRANSACTION')
            and   type = 'U')
   drop table TBL_TRANSACTION
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_PO_RECV_DT')
            and   name  = 'TBL_PO_RECV_DT_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_PO_RECV_DT.TBL_PO_RECV_DT_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_PO_RECV_DT')
            and   type = 'U')
   drop table TBL_PO_RECV_DT
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_SHIP_DT')
            and   name  = 'TBL_SHIP_DT_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_SHIP_DT.TBL_SHIP_DT_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_SHIP_DT')
            and   type = 'U')
   drop table TBL_SHIP_DT
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_ACNT_ACCOUNT')
            and   name  = 'TBL_ACNT_ACCOUNT_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_ACNT_ACCOUNT.TBL_ACNT_ACCOUNT_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_ACNT_ACCOUNT')
            and   type = 'U')
   drop table TBL_ACNT_ACCOUNT
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_INV_ONHAND')
            and   name  = 'TBL_INV_ONHAND_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_INV_ONHAND.TBL_INV_ONHAND_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_INV_ONHAND')
            and   type = 'U')
   drop table TBL_INV_ONHAND
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_HIS_SHIP')
            and   name  = 'TBL_HIS_SHIP_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_HIS_SHIP.TBL_HIS_SHIP_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_HIS_SHIP')
            and   type = 'U')
   drop table TBL_HIS_SHIP
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_SHIP')
            and   name  = 'TBL_SHIP_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_SHIP.TBL_SHIP_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_SHIP')
            and   type = 'U')
   drop table TBL_SHIP
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_HIS_PO_RECV')
            and   name  = 'TBL_HIS_PO_RECV_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_HIS_PO_RECV.TBL_HIS_PO_RECV_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_HIS_PO_RECV')
            and   type = 'U')
   drop table TBL_HIS_PO_RECV
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_AP_PAY')
            and   name  = 'TBL_AP_PAY_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_AP_PAY.TBL_AP_PAY_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_AP_PAY')
            and   type = 'U')
   drop table TBL_AP_PAY
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_PO_RECV')
            and   name  = 'TBL_PO_RECV_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_PO_RECV.TBL_PO_RECV_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_PO_RECV')
            and   type = 'U')
   drop table TBL_PO_RECV
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_AR_RECV')
            and   name  = 'TBL_AR_RECV_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_AR_RECV.TBL_AR_RECV_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_AR_RECV')
            and   type = 'U')
   drop table TBL_AR_RECV
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_ACNT_JOURNAL')
            and   name  = 'TBL_ACNT_JOURNAL_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_ACNT_JOURNAL.TBL_ACNT_JOURNAL_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_ACNT_JOURNAL')
            and   type = 'U')
   drop table TBL_ACNT_JOURNAL
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_ACNT_TYPE')
            and   name  = 'TBL_ACNT_TYPE_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_ACNT_TYPE.TBL_ACNT_TYPE_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_ACNT_TYPE')
            and   type = 'U')
   drop table TBL_ACNT_TYPE
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_INV_ADJ')
            and   name  = 'TBL_INV_ADJ_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_INV_ADJ.TBL_INV_ADJ_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_INV_ADJ')
            and   type = 'U')
   drop table TBL_INV_ADJ
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_INVENTORY')
            and   name  = 'TBL_INVENTORY_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_INVENTORY.TBL_INVENTORY_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_INVENTORY')
            and   type = 'U')
   drop table TBL_INVENTORY
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_EMPLOYE')
            and   name  = 'TBL_EMPLOYE_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_EMPLOYE.TBL_EMPLOYE_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_EMPLOYE')
            and   type = 'U')
   drop table TBL_EMPLOYE
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_PRODUCT')
            and   name  = 'TBL_PRODUCT_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_PRODUCT.TBL_PRODUCT_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_PRODUCT')
            and   type = 'U')
   drop table TBL_PRODUCT
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_SUPPLIER')
            and   name  = 'TBL_SUPPLIER_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_SUPPLIER.TBL_SUPPLIER_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_SUPPLIER')
            and   type = 'U')
   drop table TBL_SUPPLIER
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_CUSTOMER')
            and   name  = 'TBL_CUSTOMER_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_CUSTOMER.TBL_CUSTOMER_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_CUSTOMER')
            and   type = 'U')
   drop table TBL_CUSTOMER
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_SYS_PARAM')
            and   name  = 'TBL_SYS_PARAM_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_SYS_PARAM.TBL_SYS_PARAM_PK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_SYS_PARAM')
            and   type = 'U')
   drop table TBL_SYS_PARAM
go

/* ============================================================ */
/*   Table: TBL_SYS_PARAM                                       */
/* ============================================================ */
create table TBL_SYS_PARAM
(
    SPR_PERIOD_START       datetime              not null,
    SPR_COR_NAME           varchar(80)           null    ,
    SPR_TEL                varchar(30)           null    ,
    SPR_FAX                varchar(30)           null    ,
    SPR_ADDR               varchar(200)          null    ,
    SPR_TAX_RATE           numeric(18,4)         not null,
    SPR_QTY_DECIMAL        numeric               null    ,
    SPR_AMOUNT_UNIT_DOT    numeric               null    ,
    SPR_AMOUNT_DOT         numeric               null    ,
    SPR_BKUP_CMD           varchar(250)          null    ,
    SPR_BKUP_PARA          varchar(250)          null    ,
    SPR_BKUP_PATH          varchar(250)          null    ,
    SPR_PRD_COST_RATE      numeric(18,4)         not null
        default 0.05,
    SPR_BONUS_SALE_RATE    numeric(18,4)         not null
        default 0.01,
    SPR_BONUS_PROFIT_RATE  numeric(18,4)         not null
        default 0.15,
    SPR_ACNT_YEAR          numeric               not null
        default 2004,
    constraint PK_TBL_SYS_PARAM primary key (SPR_PERIOD_START)
)
go

INSERT INTO TBL_SYS_PARAM(SPR_PERIOD_START, SPR_COR_NAME, SPR_TEL, SPR_FAX
, SPR_ADDR, SPR_TAX_RATE
, SPR_QTY_DECIMAL, SPR_AMOUNT_UNIT_DOT, SPR_AMOUNT_DOT
, SPR_BKUP_CMD, SPR_BKUP_PARA, SPR_BKUP_PATH)
VALUES('01/01/1980','ERP DISTRIBUTION','TEL','FAX'
,'ADDR',0.05
,1,2,0
,'WINRAR','A','.')

GO

/* ============================================================ */
/*   Table: TBL_CUSTOMER                                        */
/* ============================================================ */
create table TBL_CUSTOMER
(
    CUM_NO                 varchar(20)           not null,
    CUM_NAME               varchar(80)           not null,
    CUM_PRESIDENT          varchar(20)           null    ,
    CUM_CONTANT            varchar(20)           null    ,
    CUM_CONT_TITLE         varchar(20)           null    ,
    CUM_TEL1               varchar(30)           null    ,
    CUM_TEL2               varchar(30)           null    ,
    CUM_FAX                varchar(30)           null    ,
    CUM_UNIFORM_NO         varchar(20)           null    ,
    CUM_INV_ADDR           varchar(200)          null    ,
    CUM_ADDR               varchar(200)          null    ,
    CUM_ZIP_CODE           varchar(6)            null    ,
    CUM_ADVANCE_AMOUNT     money                 not null,
    CUM_DESC               varchar(200)          null    ,
    CUM_CREATOR            varchar(20)           null    ,
    constraint PK_TBL_CUSTOMER primary key (CUM_NO)
)
go

/* ============================================================ */
/*   Table: TBL_SUPPLIER                                        */
/* ============================================================ */
create table TBL_SUPPLIER
(
    SUP_NO                 varchar(20)           not null,
    SUP_NAME               varchar(80)           not null,
    SUP_PRESIDENT          varchar(20)           null    ,
    SUP_CONTANT            varchar(20)           null    ,
    SUP_CONT_TITLE         varchar(20)           null    ,
    SUP_TEL1               varchar(30)           null    ,
    SUP_TEL2               varchar(30)           null    ,
    SUP_FAX                varchar(30)           null    ,
    SUP_UNIFORM_NO         varchar(20)           null    ,
    SUP_INV_ADDR           varchar(200)          null    ,
    SUP_ADDR               varchar(200)          null    ,
    SUP_ZIP_CODE           varchar(6)            null    ,
    SUP_ADVANCE_AMOUNT     money                 not null,
    SUP_DESC               varchar(200)          null    ,
    SUP_CREATOR            varchar(20)           null    ,
    constraint PK_TBL_SUPPLIER primary key (SUP_NO)
)
go

/* ============================================================ */
/*   Table: TBL_PRODUCT                                         */
/* ============================================================ */
create table TBL_PRODUCT
(
    PRD_NO                 varchar(20)           not null,
    PRD_NAME               varchar(80)           not null,
    PRD_UNIT               varchar(6)            null    ,
    PRD_SALE_PRICE         money                 not null,
    PRD_SAFE_QTY           numeric(18,4)         not null,
    PRD_ONHAND             numeric(18,4)         not null,
    PRD_CUR_COST           money                 not null,
    PRD_DESC               varchar(200)          null    ,
    PRD_IS_DUMMY           bit                   not null
        default 0,
    PRD_DUM_COST_RATE      numeric(18,4)         not null,
    PRD_EXT_COST_RATIO     numeric(18,4)         not null,
    PRD_CREATOR            varchar(20)           null    ,
    constraint PK_TBL_PRODUCT primary key (PRD_NO)
)
go

/* ============================================================ */
/*   Table: TBL_EMPLOYE                                         */
/* ============================================================ */
create table TBL_EMPLOYE
(
    EPY_NO                 varchar(20)           not null,
    EPY_NAME               varchar(20)           not null,
    EPY_PASSWORD           varchar(20)           null    ,
    EPY_TEL1               varchar(30)           null    ,
    EPY_TEL2               varchar(30)           null    ,
    EPY_ADDR               varchar(200)          null    ,
    EPY_IS_CAN_LOGIN       bit                   not null,
    EPY_DESC               varchar(200)          null    ,
    EPY_CREATOR            varchar(20)           null    ,
    constraint PK_TBL_EMPLOYE primary key (EPY_NO)
)
go

INSERT INTO TBL_EMPLOYE(EPY_NO, EPY_NAME, EPY_IS_CAN_LOGIN
, EPY_DESC, EPY_CREATOR)
VALUES('WYS','ADMINISTRATOR',1,'SYSTEM ADMINISTRATOR','DEFAULT')

/* ============================================================ */
/*   Table: TBL_INVENTORY                                       */
/* ============================================================ */
create table TBL_INVENTORY
(
    INV_NO                 varchar(20)           not null,
    INV_NAME               varchar(80)           not null,
    INV_DESC               varchar(200)          null    ,
    INV_CREATOR            varchar(20)           null    ,
    constraint PK_TBL_INVENTORY primary key (INV_NO)
)
go

INSERT INTO TBL_INVENTORY(INV_NO, INV_NAME, INV_DESC, INV_CREATOR)
VALUES('DEFAULT','Default Inventory','System Default','系統自動產生')

/* ============================================================ */
/*   Table: TBL_INV_ADJ                                         */
/* ============================================================ */
create table TBL_INV_ADJ
(
    ADJ_NO                 varchar(20)           not null,
    ADJ_STATUS             numeric               not null,
    ADJ_DATE               datetime              not null,
    ADJ_DESC               varchar(200)          null    ,
    ADJ_CREATOR            varchar(20)           null    ,
    constraint PK_TBL_INV_ADJ primary key (ADJ_NO)
)
go

/* ============================================================ */
/*   Table: TBL_ACNT_TYPE                                       */
/* ============================================================ */
create table TBL_ACNT_TYPE
(
    TYP_NO                 varchar(20)           not null,
    TYP_NAME               varchar(80)           null    ,
    TYPE_DESC              varchar(200)          null    ,
    constraint PK_TBL_ACNT_TYPE primary key (TYP_NO)
)
go


INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '11', '流動資產', '');

INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '13', '基金及長期投資', '');

INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '14', '固定資產', '');

INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '16', '遞耗資產', '');

INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '17', '無形資產', '');


INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '18', '其他資產', '');


INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '21', '流動負債', '');


INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '23', '長期負債', '');


INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '28', '其他負債', '');


INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '31', '資本', '');


INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '32', '資本公積', '');


INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '33', '保留盈餘(或累積虧損)', '');


INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '34', '權益調整', '');


INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '35', '庫藏股', '');


INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '36', '少數股權', '');

INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '41', '銷貨收入', '');


INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '46', '勞務收入', '');


INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '47', '業務收入', '');


INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '48', '其他營業收入', '');


INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '51', '銷貨成本', '');


INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '56', '勞務成本', '');


INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '57', '業務成本', '');


INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '58', '其他營業成本', '');


INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '61', '推銷費用(營業費用)', '');

INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '62', '管理及總務費用(管理費用)', '');


INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '63', '研究發展費用', '');


INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '71', '營業外收入', '');


INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '75', '營業外費用', '');


INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYPE_DESC)
VALUES( '81', '所得稅費用(或利益)', '');

/* ============================================================ */
/*   Table: TBL_ACNT_JOURNAL                                    */
/* ============================================================ */
create table TBL_ACNT_JOURNAL
(
    JNL_NO                 varchar(20)           not null,
    JNL_DATE               datetime              null    ,
    JNL_DESC               varchar(200)          null    ,
    JNL_BILL_TYPE          numeric               not null,
    JNL_CREATOR            varchar(20)           null    ,
    constraint PK_TBL_ACNT_JOURNAL primary key (JNL_NO)
)
go

/* ============================================================ */
/*   Table: TBL_AR_RECV                                         */
/* ============================================================ */
create table TBL_AR_RECV
(
    ARR_NO                 varchar(20)           not null,
    CUM_NO                 varchar(20)           not null,
    ARR_DATE               datetime              not null,
    ARR_CASH               money                 not null,
    ARR_CHECK              money                 not null,
    ARR_FROM_ADVANCE       money                 not null,
    ARR_TO_ADVANCE         money                 not null,
    ARR_DESC               varchar(200)          null    ,
    ARR_CREATOR            varchar(20)           null    ,
    constraint PK_TBL_AR_RECV primary key (ARR_NO)
)
go

/* ============================================================ */
/*   Table: TBL_PO_RECV                                         */
/* ============================================================ */
create table TBL_PO_RECV
(
    RCV_NO                 varchar(20)           not null,
    SUP_NO                 varchar(20)           not null,
    RCV_STATUS             numeric               not null,
    RCV_DATE               datetime              not null,
    RCV_INV_NO             varchar(20)           null    ,
    RCV_TOTAL              money                 not null,
    RCV_TAX                money                 not null,
    RCV_NOT_CLEAN          money                 not null,
    RCV_DESC               varchar(200)          null    ,
    RCV_CREATOR            varchar(20)           null    ,
    constraint PK_TBL_PO_RECV primary key (RCV_NO)
)
go

/* ============================================================ */
/*   Table: TBL_AP_PAY                                          */
/* ============================================================ */
create table TBL_AP_PAY
(
    PAY_NO                 varchar(20)           not null,
    SUP_NO                 varchar(20)           not null,
    PAY_DATE               datetime              not null,
    PAY_CASH               money                 not null,
    PAY_CHECK              money                 not null,
    PAY_FROM_ADVANCE       money                 not null,
    PAY_TO_ADVANCE         money                 not null,
    PAY_DESC               varchar(200)          null    ,
    PAY_CREATOR            varchar(20)           null    ,
    constraint PK_TBL_AP_PAY primary key (PAY_NO)
)
go

/* ============================================================ */
/*   Table: TBL_HIS_PO_RECV                                     */
/* ============================================================ */
create table TBL_HIS_PO_RECV
(
    HRCV_NO                varchar(20)           not null,
    SUP_NO                 varchar(20)           not null,
    HRCV_DATE              datetime              not null,
    HRCV_INV_NO            varchar(20)           null    ,
    HRCV_TOTAL             money                 not null,
    HRCV_TAX               money                 not null,
    HRCV_DESC              varchar(200)          null    ,
    HRCV_CREATOR           varchar(20)           null    ,
    constraint PK_TBL_HIS_PO_RECV primary key (HRCV_NO)
)
go

/* ============================================================ */
/*   Table: TBL_SHIP                                            */
/* ============================================================ */
create table TBL_SHIP
(
    SMT_NO                 varchar(20)           not null,
    CUM_NO                 varchar(20)           not null,
    EPY_NO                 varchar(20)           not null,
    SMT_STATUS             numeric               not null,
    SMT_INV_NO             varchar(20)           null    ,
    SMT_DATE               datetime              not null,
    SMT_DESTINATION        varchar(200)          null    ,
    SMT_TOTAL              money                 not null,
    SMT_TAX                money                 not null,
    SMT_NOT_CLEAN          money                 not null,
    SMT_COST               money                 not null,
    SMT_DESC               varchar(200)          null    ,
    SMT_CREATOR            varchar(20)           null    ,
    constraint PK_TBL_SHIP primary key (SMT_NO)
)
go

/* ============================================================ */
/*   Table: TBL_HIS_SHIP                                        */
/* ============================================================ */
create table TBL_HIS_SHIP
(
    HSMT_NO                varchar(20)           not null,
    CUM_NO                 varchar(20)           not null,
    EPY_NO                 varchar(20)           not null,
    HSMT_INV_NO            varchar(20)           null    ,
    HSMT_DATE              datetime              not null,
    HSMT_DESTINATION       varchar(200)          null    ,
    HSMT_TOTAL             money                 not null,
    HSMT_TAX               money                 not null,
    HSMT_COST              money                 not null,
    HSMT_DESC              varchar(200)          null    ,
    HSMT_CREATOR           varchar(20)           null    ,
    constraint PK_TBL_HIS_SHIP primary key (HSMT_NO)
)
go

/* ============================================================ */
/*   Table: TBL_INV_ONHAND                                      */
/* ============================================================ */
create table TBL_INV_ONHAND
(
    INV_NO                 varchar(20)           not null,
    PRD_NO                 varchar(20)           not null,
    IOH_QTY                numeric(18,4)         not null,
    constraint PK_TBL_INV_ONHAND primary key (INV_NO, PRD_NO)
)
go

/* ============================================================ */
/*   Table: TBL_ACNT_ACCOUNT                                    */
/* ============================================================ */
create table TBL_ACNT_ACCOUNT
(
    ACT_NO                 varchar(20)           not null,
    TYP_NO                 varchar(20)           not null,
    ACT_NAME               varchar(80)           null    ,
    ACT_CATEGORY_REVERSE   bit                   not null
        default 0,
    ACT_CATEGORY_CASH      bit                   not null
        default 0,
    ACT_DESC               varchar(200)          null    ,
    constraint PK_TBL_ACNT_ACCOUNT primary key (ACT_NO)
)
go

/* ============================================================ */
/*   Table: TBL_SHIP_DT                                         */
/* ============================================================ */
create table TBL_SHIP_DT
(
    SMT_NO                 varchar(20)           not null,
    SMD_SEQNO              numeric               not null,
    PRD_NO                 varchar(20)           not null,
    INV_NO                 varchar(20)           not null,
    SMD_PRD_NAME           varchar(80)           null    ,
    SMD_UNIT_PRICE         money                 not null,
    SMD_QTY                numeric(18,4)         not null,
    SMD_COST               money                 not null,
    constraint PK_TBL_SHIP_DT primary key (SMT_NO, SMD_SEQNO)
)
go

/* ============================================================ */
/*   Table: TBL_PO_RECV_DT                                      */
/* ============================================================ */
create table TBL_PO_RECV_DT
(
    RCV_NO                 varchar(20)           not null,
    RCD_SEQNO              numeric               not null,
    PRD_NO                 varchar(20)           not null,
    INV_NO                 varchar(20)           not null,
    RCD_PRD_NAME           varchar(80)           null    ,
    RCD_QTY                numeric(18,4)         not null,
    RCD_UNIT_PRICE         money                 not null,
    constraint PK_TBL_PO_RECV_DT primary key (RCV_NO, RCD_SEQNO)
)
go

/* ============================================================ */
/*   Table: TBL_TRANSACTION                                     */
/* ============================================================ */
create table TBL_TRANSACTION
(
    TRN_ID                 numeric               identity,
    PRD_NO                 varchar(20)           not null,
    INV_NO                 varchar(20)           not null,
    TRN_TYPE               numeric               not null,
    TRN_SRC_NO             varchar(20)           null    ,
    TRN_SRC_SEQNO          numeric               null    ,
    TRN_DATETIME           datetime              not null,
    TRN_QTY                numeric(18,4)         not null,
    TRN_COST               money                 not null,
    TRN_ONHAND             numeric(18,4)         not null,
    TRN_AVG_COST           money                 not null,
    constraint PK_TBL_TRANSACTION primary key (TRN_ID)
)
go

/* ============================================================ */
/*   Table: TBL_AR_RECV_DT                                      */
/* ============================================================ */
create table TBL_AR_RECV_DT
(
    ARR_NO                 varchar(20)           not null,
    ARD_SEQNO              numeric               not null,
    SMT_NO                 varchar(20)           not null,
    ARD_AMOUNT             money                 not null,
    ARD_DISCOUNT           money                 not null,
    constraint PK_TBL_AR_RECV_DT primary key (ARR_NO, ARD_SEQNO)
)
go

/* ============================================================ */
/*   Table: TBL_AP_PAY_DT                                       */
/* ============================================================ */
create table TBL_AP_PAY_DT
(
    PAY_NO                 varchar(20)           not null,
    PAD_SEQNO              numeric               not null,
    RCV_NO                 varchar(20)           not null,
    PAD_AMOUNT             money                 not null,
    PAD_DISCOUNT           money                 not null,
    constraint PK_TBL_AP_PAY_DT primary key (PAY_NO, PAD_SEQNO)
)
go

/* ============================================================ */
/*   Table: TBL_INV_ADJ_DT                                      */
/* ============================================================ */
create table TBL_INV_ADJ_DT
(
    ADJ_NO                 varchar(20)           not null,
    ADD_SEQNO              numeric               not null,
    PRD_NO                 varchar(20)           not null,
    ADD_QTY                numeric(18,4)         not null,
    ADD_COST               money                 not null,
    INV_NO                 varchar(20)           not null,
    constraint PK_TBL_INV_ADJ_DT primary key (ADJ_NO, ADD_SEQNO)
)
go

/* ============================================================ */
/*   Table: TBL_HIS_SHIP_DT                                     */
/* ============================================================ */
create table TBL_HIS_SHIP_DT
(
    HSMT_NO                varchar(20)           not null,
    HSMD_SEQNO             numeric               not null,
    PRD_NO                 varchar(20)           not null,
    INV_NO                 varchar(20)           not null,
    HSMD_PRD_NAME          varchar(80)           null    ,
    HSMD_UNIT_PRICE        money                 not null,
    HSMD_QTY               numeric(18,4)         not null,
    HSMD_COST              money                 not null,
    constraint PK_TBL_HIS_SHIP_DT primary key (HSMT_NO, HSMD_SEQNO)
)
go

/* ============================================================ */
/*   Table: TBL_HIS_PO_RECV_DT                                  */
/* ============================================================ */
create table TBL_HIS_PO_RECV_DT
(
    HRCV_NO                varchar(20)           not null,
    HRCD_SEQNO             numeric               not null,
    PRD_NO                 varchar(20)           not null,
    INV_NO                 varchar(20)           not null,
    HRCD_PRD_NAME          varchar(80)           null    ,
    HRCD_QTY               numeric(18,4)         not null,
    HRCD_UNIT_PRICE        money                 not null,
    constraint PK_TBL_HIS_PO_RECV_DT primary key (HRCV_NO, HRCD_SEQNO)
)
go

/* ============================================================ */
/*   Table: TBL_ACNT_JOURNAL_DT                                 */
/* ============================================================ */
create table TBL_ACNT_JOURNAL_DT
(
    JNL_NO                 varchar(20)           not null,
    JND_SEQNO              numeric               not null,
    JND_AMOUNT             money                 not null,
    JND_DESC               varchar(200)          null    ,
    constraint PK_TBL_ACNT_JOURNAL_DT primary key (JNL_NO, JND_SEQNO)
)
go

/* ============================================================ */
/*   Table: TBL_ACNT_INIT                                       */
/* ============================================================ */
create table TBL_ACNT_INIT
(
    INI_YEAR               varchar(20)           not null,
    ACT_NO                 varchar(20)           not null,
    INI_AMOUNT             money                 not null,
    constraint PK_TBL_ACNT_INIT primary key (INI_YEAR, ACT_NO)
)
go

alter table TBL_AR_RECV
    add constraint FK_TBL_AR_R_REF_7833_TBL_CUST foreign key  (CUM_NO)
       references TBL_CUSTOMER (CUM_NO)
go

alter table TBL_PO_RECV
    add constraint FK_TBL_PO_R_REF_7839_TBL_SUPP foreign key  (SUP_NO)
       references TBL_SUPPLIER (SUP_NO)
go

alter table TBL_AP_PAY
    add constraint FK_TBL_AP_P_REF_7842_TBL_SUPP foreign key  (SUP_NO)
       references TBL_SUPPLIER (SUP_NO)
go

alter table TBL_HIS_PO_RECV
    add constraint FK_TBL_HIS__REF_7845_TBL_SUPP foreign key  (SUP_NO)
       references TBL_SUPPLIER (SUP_NO)
go

alter table TBL_SHIP
    add constraint FK_TBL_SHIP_REF_7830_TBL_CUST foreign key  (CUM_NO)
       references TBL_CUSTOMER (CUM_NO)
go

alter table TBL_SHIP
    add constraint FK_TBL_SHIP_REF_7869_TBL_EMPL foreign key  (EPY_NO)
       references TBL_EMPLOYE (EPY_NO)
go

alter table TBL_HIS_SHIP
    add constraint FK_TBL_HIS__REF_7836_TBL_CUST foreign key  (CUM_NO)
       references TBL_CUSTOMER (CUM_NO)
go

alter table TBL_HIS_SHIP
    add constraint FK_TBL_HIS__REF_7872_TBL_EMPL foreign key  (EPY_NO)
       references TBL_EMPLOYE (EPY_NO)
go

alter table TBL_INV_ONHAND
    add constraint FK_TBL_INV__REF_7854_TBL_PROD foreign key  (PRD_NO)
       references TBL_PRODUCT (PRD_NO)
go

alter table TBL_INV_ONHAND
    add constraint FK_TBL_INV__REF_7893_TBL_INVE foreign key  (INV_NO)
       references TBL_INVENTORY (INV_NO)
go

alter table TBL_ACNT_ACCOUNT
    add constraint FK_TBL_ACNT_REF_7956_TBL_ACNT foreign key  (TYP_NO)
       references TBL_ACNT_TYPE (TYP_NO)
go

alter table TBL_SHIP_DT
    add constraint FK_TBL_SHIP_REF_7848_TBL_PROD foreign key  (PRD_NO)
       references TBL_PRODUCT (PRD_NO)
go

alter table TBL_SHIP_DT
    add constraint FK_TBL_SHIP_REF_7875_TBL_SHIP foreign key  (SMT_NO)
       references TBL_SHIP (SMT_NO)
go

alter table TBL_SHIP_DT
    add constraint FK_TBL_SHIP_REF_7887_TBL_INVE foreign key  (INV_NO)
       references TBL_INVENTORY (INV_NO)
go

alter table TBL_SHIP_DT
    add constraint FK_TBL_SHIP_REF_7908_TBL_INV_ foreign key  (INV_NO, PRD_NO)
       references TBL_INV_ONHAND (INV_NO, PRD_NO)
go

alter table TBL_PO_RECV_DT
    add constraint FK_TBL_PO_R_REF_7851_TBL_PROD foreign key  (PRD_NO)
       references TBL_PRODUCT (PRD_NO)
go

alter table TBL_PO_RECV_DT
    add constraint FK_TBL_PO_R_REF_7881_TBL_PO_R foreign key  (RCV_NO)
       references TBL_PO_RECV (RCV_NO)
go

alter table TBL_PO_RECV_DT
    add constraint FK_TBL_PO_R_REF_7890_TBL_INVE foreign key  (INV_NO)
       references TBL_INVENTORY (INV_NO)
go

alter table TBL_PO_RECV_DT
    add constraint FK_TBL_PO_R_REF_7913_TBL_INV_ foreign key  (INV_NO, PRD_NO)
       references TBL_INV_ONHAND (INV_NO, PRD_NO)
go

alter table TBL_TRANSACTION
    add constraint FK_TBL_TRAN_REF_7918_TBL_INV_ foreign key  (INV_NO, PRD_NO)
       references TBL_INV_ONHAND (INV_NO, PRD_NO)
go

alter table TBL_AR_RECV_DT
    add constraint FK_TBL_AR_R_REF_7878_TBL_SHIP foreign key  (SMT_NO)
       references TBL_SHIP (SMT_NO)
go

alter table TBL_AR_RECV_DT
    add constraint FK_TBL_AR_R_REF_7938_TBL_AR_R foreign key  (ARR_NO)
       references TBL_AR_RECV (ARR_NO)
go

alter table TBL_AP_PAY_DT
    add constraint FK_TBL_AP_P_REF_7884_TBL_PO_R foreign key  (RCV_NO)
       references TBL_PO_RECV (RCV_NO)
go

alter table TBL_AP_PAY_DT
    add constraint FK_TBL_AP_P_REF_7941_TBL_AP_P foreign key  (PAY_NO)
       references TBL_AP_PAY (PAY_NO)
go

alter table TBL_INV_ADJ_DT
    add constraint FK_TBL_INV__REF_7923_TBL_INV_ foreign key  (INV_NO, PRD_NO)
       references TBL_INV_ONHAND (INV_NO, PRD_NO)
go

alter table TBL_INV_ADJ_DT
    add constraint FK_TBL_INV__REF_7944_TBL_INV_ foreign key  (ADJ_NO)
       references TBL_INV_ADJ (ADJ_NO)
go

alter table TBL_HIS_SHIP_DT
    add constraint FK_TBL_HIS__REF_7928_TBL_INV_ foreign key  (INV_NO, PRD_NO)
       references TBL_INV_ONHAND (INV_NO, PRD_NO)
go

alter table TBL_HIS_SHIP_DT
    add constraint FK_TBL_HIS__REF_7947_TBL_HIS_ foreign key  (HSMT_NO)
       references TBL_HIS_SHIP (HSMT_NO)
go

alter table TBL_HIS_PO_RECV_DT
    add constraint FK_TBL_HIS__REF_7933_TBL_INV_ foreign key  (INV_NO, PRD_NO)
       references TBL_INV_ONHAND (INV_NO, PRD_NO)
go

alter table TBL_HIS_PO_RECV_DT
    add constraint FK_TBL_HIS__REF_7950_TBL_HIS_ foreign key  (HRCV_NO)
       references TBL_HIS_PO_RECV (HRCV_NO)
go

alter table TBL_ACNT_JOURNAL_DT
    add constraint FK_TBL_ACNT_REF_7959_TBL_ACNT foreign key  (JNL_NO)
       references TBL_ACNT_JOURNAL (JNL_NO)
go

alter table TBL_ACNT_INIT
    add constraint FK_TBL_ACNT_REF_7953_TBL_ACNT foreign key  (ACT_NO)
       references TBL_ACNT_ACCOUNT (ACT_NO)
go


/* ============================================================ */
/*   Database name:  ACCOUNT                                    */
/*   DBMS name:      Microsoft SQL Server 6.x                   */
/*   Created on:     2004/05/09  11:55                          */
/* ============================================================ */

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_ACNT_INIT')
            and   type = 'U')
   drop table TBL_ACNT_INIT
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_ACNT_JOURNAL_DT')
            and   type = 'U')
   drop table TBL_ACNT_JOURNAL_DT
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_ACNT_ACCOUNT')
            and   type = 'U')
   drop table TBL_ACNT_ACCOUNT
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_ACNT_JOURNAL')
            and   type = 'U')
   drop table TBL_ACNT_JOURNAL
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_ACNT_TYPE')
            and   type = 'U')
   drop table TBL_ACNT_TYPE
go

/* ============================================================ */
/*   Table: TBL_ACNT_TYPE                                       */
/* ============================================================ */
create table TBL_ACNT_TYPE
(
    TYP_NO                varchar(20)           not null,
    TYP_NAME              varchar(80)           null    ,
    TYP_MAJOR_TYPE        varchar(80)           null    ,
    TYPE_DESC             varchar(200)          null    ,
    constraint PK_TBL_ACNT_TYPE primary key (TYP_NO)
)
go

INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '11', '流動資產', '資產');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '13', '基金及長期投資', '資產');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '14', '固定資產', '資產');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '16', '遞耗資產', '資產');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '17', '無形資產', '資產');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '18', '其他資產', '資產');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '21', '流動負債', '負債');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '23', '長期負債', '負債');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '28', '其他負債', '負債');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '31', '資本', '業主權益');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '32', '資本公積', '業主權益');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '33', '保留盈餘(或累積虧損)', '業主權益');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '34', '權益調整', '業主權益');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '35', '庫藏股', '業主權益');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '36', '少數股權', '業主權益');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '41', '銷貨收入', '營業收入');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '46', '勞務收入', '營業收入');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '47', '業務收入', '營業收入');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '48', '其他營業收入', '營業收入');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '51', '銷貨成本', '營業成本');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '56', '勞務成本', '營業成本');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '57', '業務成本', '營業成本');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '58', '其他營業成本', '營業成本');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '61', '推銷費用(營業費用)', '營業費用');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '62', '管理及總務費用(管理費用)', '營業費用');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '63', '研究發展費用', '營業費用');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '71', '營業外收入', '營業外收入及費用');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '75', '營業外費用', '營業外收入及費用');
INSERT INTO TBL_ACNT_TYPE(TYP_NO, TYP_NAME, TYP_MAJOR_TYPE) VALUES( '81', '所得稅費用(或利益)', '所得稅費用(或利益)');

/* ============================================================ */
/*   Table: TBL_ACNT_JOURNAL                                    */
/* ============================================================ */
create table TBL_ACNT_JOURNAL
(
    JNL_NO                varchar(20)           not null,
    JNL_DATE              datetime              null    ,
    JNL_DESC              varchar(200)          null    ,
    JNL_BILL_TYPE         numeric               not null,
    JNL_CREATOR           varchar(20)           null    ,
    constraint PK_TBL_ACNT_JOURNAL primary key (JNL_NO)
)
go

/* ============================================================ */
/*   Table: TBL_ACNT_ACCOUNT                                    */
/* ============================================================ */
create table TBL_ACNT_ACCOUNT
(
    ACT_NO                varchar(20)           not null,
    TYP_NO                varchar(20)           not null,
    ACT_NAME              varchar(80)           null    ,
    ACT_CATEGORY_REVERSE  bit                   not null
        default 0,
    ACT_CATEGORY_CASH     bit                   not null
        default 0,
    ACT_CREATOR           varchar(20)           null    ,
    ACT_DESC              varchar(200)          null    ,
    constraint PK_TBL_ACNT_ACCOUNT primary key (ACT_NO)
)
go

/* ============================================================ */
/*   Table: TBL_ACNT_JOURNAL_DT                                 */
/* ============================================================ */
create table TBL_ACNT_JOURNAL_DT
(
    JNL_NO                varchar(20)           not null,
    JND_SEQNO             numeric               not null,
    ACT_NO                varchar(20)           not null,
    JND_AMOUNT            money                 not null,
    JND_DESC              varchar(200)          null    ,
    constraint PK_TBL_ACNT_JOURNAL_DT primary key (JNL_NO, JND_SEQNO)
)
go

/* ============================================================ */
/*   Table: TBL_ACNT_INIT                                       */
/* ============================================================ */
create table TBL_ACNT_INIT
(
    INI_YEAR              varchar(20)           not null,
    ACT_NO                varchar(20)           not null,
    INI_AMOUNT            money                 not null,
    constraint PK_TBL_ACNT_INIT primary key (INI_YEAR, ACT_NO)
)
go

alter table TBL_ACNT_ACCOUNT
    add constraint FK_TBL_ACNT_REF_2110_TBL_ACNT foreign key  (TYP_NO)
       references TBL_ACNT_TYPE (TYP_NO)
go

alter table TBL_ACNT_JOURNAL_DT
    add constraint FK_TBL_ACNT_REF_2113_TBL_ACNT foreign key  (JNL_NO)
       references TBL_ACNT_JOURNAL (JNL_NO)
go

alter table TBL_ACNT_JOURNAL_DT
    add constraint FK_TBL_ACNT_REF_2104_TBL_ACNT foreign key  (ACT_NO)
       references TBL_ACNT_ACCOUNT (ACT_NO)
go

alter table TBL_ACNT_INIT
    add constraint FK_TBL_ACNT_REF_2107_TBL_ACNT foreign key  (ACT_NO)
       references TBL_ACNT_ACCOUNT (ACT_NO)
go


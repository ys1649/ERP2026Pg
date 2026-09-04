/*==============================================================*/
/* Database name:  MODEL_129                                    */
/* DBMS name:      Microsoft SQL Server 2000                    */
/* Created on:     2005/5/29 ¤W¤È 11:02:33                        */
/*==============================================================*/


alter table TBL_SHIP
   drop constraint FK_TBL_SHIP_REF_2311_TBL_EMPL
go

alter table TBL_SHIP
   drop constraint FK_TBL_SHIP_REF_4731_TBL_CAR
go

alter table TBL_SHIP
   drop constraint FK_TBL_SHIP_REF_CUM_S_TBL_CUST
go

alter table TBL_SHIP_DT
   drop constraint FK_TBL_SHIP_REF_2314_TBL_SHIP
go

alter table TBL_SHIP_DT
   drop constraint FK_TBL_SHIP_REF_INV_S_TBL_INVE
go

alter table TBL_SHIP_DT
   drop constraint FK_TBL_SHIP_REF_PRD_S_TBL_PROD
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_SHIP')
            and   name  = 'REF_2311_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_SHIP.REF_2311_PK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_SHIP')
            and   name  = 'REF_CUM_SMT_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_SHIP.REF_CUM_SMT_PK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_SHIP_DT')
            and   name  = 'REF_2314_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_SHIP_DT.REF_2314_PK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_SHIP_DT')
            and   name  = 'REF_INV_SMD_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_SHIP_DT.REF_INV_SMD_PK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TBL_SHIP_DT')
            and   name  = 'REF_PRD_SMD_PK'
            and   indid > 0
            and   indid < 255)
   drop index TBL_SHIP_DT.REF_PRD_SMD_PK
go

if exists(select 1 from systypes where name='DM_ADDR')
   execute sp_droptype DM_ADDR
go

if exists(select 1 from systypes where name='DM_BOOLEAN')
   execute sp_droptype DM_BOOLEAN
go

if exists(select 1 from systypes where name='DM_CHAR')
   execute sp_droptype DM_CHAR
go

if exists(select 1 from systypes where name='DM_DATE')
   execute sp_droptype DM_DATE
go

if exists(select 1 from systypes where name='DM_DESCRIPTION')
   execute sp_droptype DM_DESCRIPTION
go

if exists(select 1 from systypes where name='DM_ID')
   execute sp_droptype DM_ID
go

if exists(select 1 from systypes where name='DM_JOB_TITLE')
   execute sp_droptype DM_JOB_TITLE
go

if exists(select 1 from systypes where name='DM_MONEY')
   execute sp_droptype DM_MONEY
go

if exists(select 1 from systypes where name='DM_NAME_COMPANY')
   execute sp_droptype DM_NAME_COMPANY
go

if exists(select 1 from systypes where name='DM_NAME_HUMAN')
   execute sp_droptype DM_NAME_HUMAN
go

if exists(select 1 from systypes where name='DM_NAME_PROD')
   execute sp_droptype DM_NAME_PROD
go

if exists(select 1 from systypes where name='DM_NUMBER')
   execute sp_droptype DM_NUMBER
go

if exists(select 1 from systypes where name='DM_PHONE')
   execute sp_droptype DM_PHONE
go

if exists(select 1 from systypes where name='DM_QTY')
   execute sp_droptype DM_QTY
go

if exists(select 1 from systypes where name='DM_QTY_INT')
   execute sp_droptype DM_QTY_INT
go

if exists(select 1 from systypes where name='DM_RATIO')
   execute sp_droptype DM_RATIO
go

if exists(select 1 from systypes where name='DM_SEQNO')
   execute sp_droptype DM_SEQNO
go

if exists(select 1 from systypes where name='DM_UNIT')
   execute sp_droptype DM_UNIT
go

if exists(select 1 from systypes where name='DM_VARCHAR')
   execute sp_droptype DM_VARCHAR
go

if exists(select 1 from systypes where name='DM_ZIP_CODE')
   execute sp_droptype DM_ZIP_CODE
go

if exists (select 1
   from  sysobjects where type = 'D'
   and name = 'D_0'
   )
   drop default D_0
go

/*==============================================================*/
/* Default: D_0                                                 */
/*==============================================================*/
create default D_0
    as 0
go

/*==============================================================*/
/* Table: TBL_SHIP                                              */
/*==============================================================*/
create table TBL_SHIP (
   SMT_NO               varchar(20)          not null,
   CUM_NO               varchar(20)          not null,
   EPY_NO               varchar(20)          not null,
   CAR_NO               varchar(20)          null,
   JNL_NO               varchar(20)          null,
   SMT_STATUS           numeric              not null,
   SMT_INV_NO           varchar(20)          null,
   SMT_DATE             datetime             not null,
   SMT_DESTINATION      varchar(200)         null,
   SMT_TOTAL            money                not null,
   SMT_TAX              money                not null,
   SMT_NOT_CLEAN        money                not null,
   SMT_COST             money                not null,
   SMT_DELIVER1         varchar(20)          null,
   SMT_DELIVER2         varchar(20)          null,
   SMT_DESC             varchar(200)         null,
   SMT_CREATOR          varchar(20)          null,
   SMT_TR_FLAG          bit                  not null default 0,
   constraint PK_TBL_SHIP primary key  (SMT_NO)
)
go

/*==============================================================*/
/* Index: REF_CUM_SMT_PK                                        */
/*==============================================================*/
create   index REF_CUM_SMT_PK on TBL_SHIP (
CUM_NO ASC
)
go

/*==============================================================*/
/* Index: REF_2311_PK                                           */
/*==============================================================*/
create   index REF_2311_PK on TBL_SHIP (
EPY_NO ASC
)
go

/*==============================================================*/
/* Table: TBL_SHIP_DT                                           */
/*==============================================================*/
create table TBL_SHIP_DT (
   SMT_NO               varchar(20)          not null,
   SMD_SEQNO            numeric              not null,
   PRD_NO               varchar(20)          not null,
   INV_NO               varchar(20)          not null,
   SMD_PRD_NAME         varchar(80)          null,
   SMD_UNIT_PRICE       money                not null,
   SMD_QTY              numeric(18,4)        not null,
   SMD_COST             money                not null,
   constraint PK_TBL_SHIP_DT primary key  (SMT_NO, SMD_SEQNO)
)
go

/*==============================================================*/
/* Index: REF_PRD_SMD_PK                                        */
/*==============================================================*/
create   index REF_PRD_SMD_PK on TBL_SHIP_DT (
PRD_NO ASC
)
go

/*==============================================================*/
/* Index: REF_2314_PK                                           */
/*==============================================================*/
create   index REF_2314_PK on TBL_SHIP_DT (
SMT_NO ASC
)
go

/*==============================================================*/
/* Index: REF_INV_SMD_PK                                        */
/*==============================================================*/
create   index REF_INV_SMD_PK on TBL_SHIP_DT (
INV_NO ASC
)
go

alter table TBL_SHIP
   add constraint FK_TBL_SHIP_REF_2311_TBL_EMPL foreign key (EPY_NO)
      references TBL_EMPLOYE (EPY_NO)
go

alter table TBL_SHIP
   add constraint FK_TBL_SHIP_REF_4731_TBL_CAR foreign key (CAR_NO)
      references TBL_CAR (CAR_NO)
go

alter table TBL_SHIP
   add constraint FK_TBL_SHIP_REF_CUM_S_TBL_CUST foreign key (CUM_NO)
      references TBL_CUSTOMER (CUM_NO)
go

alter table TBL_SHIP_DT
   add constraint FK_TBL_SHIP_REF_2314_TBL_SHIP foreign key (SMT_NO)
      references TBL_SHIP (SMT_NO)
go

alter table TBL_SHIP_DT
   add constraint FK_TBL_SHIP_REF_INV_S_TBL_INVE foreign key (INV_NO)
      references TBL_INVENTORY (INV_NO)
go

alter table TBL_SHIP_DT
   add constraint FK_TBL_SHIP_REF_PRD_S_TBL_PROD foreign key (PRD_NO)
      references TBL_PRODUCT (PRD_NO)
go


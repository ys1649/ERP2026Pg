/* ============================================================ */
/*   Database name:  SYSREPORT                                  */
/*   DBMS name:      Microsoft SQL Server 6.x                   */
/*   Created on:     2004/02/20  13:42                          */
/* ============================================================ */

if exists (select 1
            from  sysobjects
           where  id = object_id('TBLSYSREPORTFIELD')
            and   type = 'U')
   drop table TBLSYSREPORTFIELD
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBLSYSREPORT')
            and   type = 'U')
   drop table TBLSYSREPORT
go

/* ============================================================ */
/*   Table: TBLSYSREPORT                                        */
/* ============================================================ */
create table TBLSYSREPORT
(
    SRP_ID                int                   not null,
    SRP_CODE              varchar(20)           not null,
    SRP_NAME              varchar(80)           not null,
    SRP_DESCRIPTION       varchar(255)          null    ,
    SRP_SELECT            text                  not null,
    SRP_WHERE             text                  null    ,
    SRP_GROUPBY           text                  null    ,
    SRP_ORDERBY           text                  null    ,
    SRP_PRESCRIPT         text                  null    ,
    SRP_POSTSCRIPT        text                  null    ,
    SRP_REPORTFILE        image                 null    ,
    constraint PK_TBLSYSREPORT primary key (SRP_ID),
    constraint AK_SRP_CODE_TBLSYSRE unique (SRP_CODE)
)
go

/* ============================================================ */
/*   Table: TBLSYSREPORTFIELD                                   */
/* ============================================================ */
create table TBLSYSREPORTFIELD
(
    SRP_ID                int                   not null,
    SRF_SEQNO             int                   not null,
    SRF_FIELDNAME         varchar(80)           not null,
    SRF_DISPNAME          varchar(80)           not null,
    SRF_TABLEALIAS        varchar(80)           not null,
    SRF_DISPORDER         int                   not null,
    SRF_DATATYPE          varchar(20)           null    ,
    SRF_CONTROLTYPE       varchar(20)           not null,
    SRF_QUERYTYPE         varchar(20)           not null,
    SRF_ISMUSTCRITERIA    bit                   not null,
    SRF_ISWHERE           bit                   not null,
    SRF_ISSORT            bit                   not null,
    SRF_SORTDEC           bit                   null    ,
    SRF_LIST_VALUE        text                  null    ,
    SRF_LIST_SQL          text                  null    ,
    SRF_LIST_RETURNFIELD  varchar(80)           null    ,
    SRF_LIST_FIELDDISP    text                  null    ,
    constraint PK_TBLSYSREPORTFIELD primary key (SRP_ID, SRF_SEQNO)
)
go

alter table TBLSYSREPORTFIELD
    add constraint FK_TBLSYSRE_REF_1772_TBLSYSRE foreign key  (SRP_ID)
       references TBLSYSREPORT (SRP_ID)
go


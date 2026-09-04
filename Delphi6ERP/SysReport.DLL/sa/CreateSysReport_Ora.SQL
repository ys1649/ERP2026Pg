-- ============================================================
--   Database name:  SYSREPORT                                 
--   DBMS name:      ORACLE Version 8                          
--   Created on:     2002/9/27  04:46 ¤U¤È '—                  
-- ============================================================

drop table TBLSYSREPORTFIELD cascade constraints
/

drop table TBLSYSREPORT cascade constraints
/

-- ============================================================
--   Table: TBLSYSREPORT                                       
-- ============================================================
create table TBLSYSREPORT
(
    SRP_ID                INTEGER                not null,
    SRP_CODE              VARCHAR2(20)           not null,
    SRP_NAME              VARCHAR2(80)           not null,
    SRP_DESCRIPTION       VARCHAR2(255)          null    ,
    SRP_SELECT            VARCHAR2(4000)         not null,
    SRP_WHERE             VARCHAR2(4000)         null    ,
    SRP_GROUPBY           VARCHAR2(4000)         null    ,
    SRP_ORDERBY           VARCHAR2(4000)         null    ,
    SRP_PRESCRIPT         VARCHAR2(4000)         null    ,
    SRP_POSTSCRIPT        VARCHAR2(4000)         null    ,
    SRP_REPORTFILE        LONG RAW               null    ,
    constraint PK_TBLSYSREPORT primary key (SRP_ID),
    constraint AK_SRP_CODE_TBLSYSRE unique (SRP_CODE)
)
/

-- ============================================================
--   Table: TBLSYSREPORTFIELD                                  
-- ============================================================
create table TBLSYSREPORTFIELD
(
    SRP_ID                INTEGER                not null,
    SRF_SEQNO             INTEGER                not null,
    SRF_FIELDNAME         VARCHAR2(80)           not null,
    SRF_DISPNAME          VARCHAR2(80)           not null,
    SRF_TABLEALIAS        VARCHAR2(80)           not null,
    SRF_DISPORDER         INTEGER                not null,
    SRF_DATATYPE          VARCHAR2(20)           null    ,
    SRF_CONTROLTYPE       VARCHAR2(20)           not null,
    SRF_QUERYTYPE         VARCHAR2(20)           not null,
    SRF_ISMUSTCRITERIA    NUMBER(1)              not null,
    SRF_ISWHERE           NUMBER(1)              not null,
    SRF_ISSORT            NUMBER(1)              not null,
    SRF_SORTDEC           NUMBER(1)              null    ,
    SRF_LIST_VALUE        VARCHAR2(4000)         null    ,
    SRF_LIST_SQL          VARCHAR2(4000)         null    ,
    SRF_LIST_RETURNFIELD  VARCHAR2(80)           null    ,
    SRF_LIST_FIELDDISP    VARCHAR2(4000)         null    ,
    constraint PK_TBLSYSREPORTFIELD primary key (SRP_ID, SRF_SEQNO)
)
/

alter table TBLSYSREPORTFIELD
    add constraint FK_TBLSYSRE_REF_1828_TBLSYSRE foreign key  (SRP_ID)
       references TBLSYSREPORT (SRP_ID)
/


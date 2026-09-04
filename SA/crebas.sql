/*==============================================================*/
/* DBMS name:      PostgreSQL 8                                 */
/* Created on:     2026/9/3 下午 03:38:40                         */
/*==============================================================*/


drop table TBLDD cascade;

drop table TBLSYSREPORT cascade;

drop table TBLSYSREPORTFIELD cascade;

drop table TBL_DDFIELD cascade;

/*==============================================================*/
/* Table: TBLDD                                                 */
/*==============================================================*/
create table TBLDD (
   DDM_NO               VARCHAR(80)          not null,
   DDM_NAME             VARCHAR(80)          not null,
   DDM_SQL              VARCHAR(4000)        null,
   IS_MULTI_SELECTED    CHAR(10)             null,
   RET_VAL_FIELD        VARCHAR(80)          null,
   constraint PK_TBLDD primary key (DDM_NO)
);

comment on table TBLDD is
'資料字典主檔
資料字典主檔用查詢主檔欄位時，出現Loopup 畫面讓 USER 快速篩選資料';

comment on column TBLDD.DDM_NO is
'資料字典主檔編號';

comment on column TBLDD.DDM_NAME is
'資料字典主檔名稱';

comment on column TBLDD.DDM_SQL is
'定義資料字典的來源資料 SQL';

comment on column TBLDD.IS_MULTI_SELECTED is
'是否允許多選';

comment on column TBLDD.RET_VAL_FIELD is
'user 選擇後，返回值的欄位名稱，
不管是否多選，回傳值都是 JSON ARRAY 格式';

/*==============================================================*/
/* Table: TBLSYSREPORT                                          */
/*==============================================================*/
create table TBLSYSREPORT (
   SRP_ID               INT4                 not null,
   SRP_CODE             VARCHAR(20)          not null,
   SRP_NAME             VARCHAR(80)          not null,
   SRP_DESCRIPTION      VARCHAR(255)         null,
   SRP_SELECT           VARCHAR(4000)        not null,
   SRP_WHERE            VARCHAR(4000)        null,
   SRP_GROUPBY          VARCHAR(4000)        null,
   SRP_ORDERBY          VARCHAR(4000)        null,
   SRP_REPORTFILE       TEXT                 null,
   constraint PK_TBLSYSREPORT primary key (SRP_ID),
   constraint AK_SRP_CODE_TBLSYSRE unique (SRP_CODE)
);

/*==============================================================*/
/* Table: TBLSYSREPORTFIELD                                     */
/*==============================================================*/
create table TBLSYSREPORTFIELD (
   SRP_ID               INT4                 not null,
   SRF_SEQNO            INT4                 not null,
   SRF_FIELDNAME        VARCHAR(80)          not null,
   SRF_DISPNAME         VARCHAR(80)          not null,
   SRF_TABLEALIAS       VARCHAR(80)          not null,
   SRF_DISPORDER        INT4                 not null,
   SRF_DATATYPE         VARCHAR(20)          null,
   SRF_CONTROLTYPE      VARCHAR(20)          not null,
   SRF_QUERYTYPE        VARCHAR(20)          not null,
   SRF_ISMUSTCRITERIA   BOOL                 not null,
   SRF_ISWHERE          BOOL                 not null,
   SRF_ISSORT           BOOL                 not null,
   SRF_SORTDEC          BOOL                 null,
   SRF_LIST_VALUE       VARCHAR(4000)        null,
   SRF_LIST_SQL         VARCHAR(4000)        null,
   SRF_LIST_RETURNFIELD VARCHAR(80)          null,
   SRF_LIST_FIELDDISP   VARCHAR(4000)        null,
   constraint PK_TBLSYSREPORTFIELD primary key (SRP_ID, SRF_SEQNO),
   constraint FK_TBLSYSRE_REF_1800_TBLSYSRE foreign key (SRP_ID)
      references TBLSYSREPORT (SRP_ID)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Table: TBL_DDFIELD                                           */
/*==============================================================*/
create table TBL_DDFIELD (
   DDD_ID               SERIAL               not null,
   DDM_NO               VARCHAR(80)          null,
   DDD_FIELD            VARCHAR(80)          null,
   DDD_FIELD_DISP       VARCHAR(80)          null,
   constraint PK_TBL_DDFIELD primary key (DDD_ID),
   constraint AK_KEY_2_TBL_DDFI unique (DDM_NO, DDD_FIELD_DISP),
   constraint FK_TBL_DDFI_REFERENCE_TBLDD foreign key (DDM_NO)
      references TBLDD (DDM_NO)
      on delete restrict on update restrict
);

comment on table TBL_DDFIELD is
'資料字典欄位定義';

comment on column TBL_DDFIELD.DDM_NO is
'資料字典主檔編號';

comment on column TBL_DDFIELD.DDD_FIELD is
'欄位名稱';

comment on column TBL_DDFIELD.DDD_FIELD_DISP is
'欄位顯示';


insert into TBLDD (DDM_NO, DDM_NAME, DDM_SQL, IS_MULTI_SELECTED, RET_VAL_FIELD)
values ('TBLDD', '資料字典', 'SELECT A.DDM_NO,A.DDM_NAME
FROM TBLDD A
ORDER BY A.DDM_NO', 'N         ', 'DDM_NO');



insert into TBL_DDFIELD (DDD_ID, DDM_NO, DDD_FIELD, DDD_FIELD_DISP)
values (2, 'TBLDD', 'DDM_NAME', '資料字典名稱');

insert into TBL_DDFIELD (DDD_ID, DDM_NO, DDD_FIELD, DDD_FIELD_DISP)
values (1, 'TBLDD', 'DDM_NO', '資料字典編號');

COMMIT;


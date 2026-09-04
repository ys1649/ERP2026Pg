/*==============================================================*/
/* Database name:  MODEL_129                                    */
/* DBMS name:      ORACLE Version 9i2                           */
/* Created on:     2006/1/7 下午 04:15:23                         */
/*==============================================================*/


alter table TBL_ACNT_ACCOUNT
   drop constraint FK_TBL_ACNT_REF_2110_TBL_ACNT;

alter table TBL_ACNT_INIT
   drop constraint FK_TBL_ACNT_REF_2107_TBL_ACNT;

alter table TBL_ACNT_JOURNAL_DT
   drop constraint FK_TBL_ACNT_REF_2104_TBL_ACNT;

alter table TBL_ACNT_JOURNAL_DT
   drop constraint FK_TBL_ACNT_REF_2113_TBL_ACNT;

alter table TBL_AP_PAY
   drop constraint FK_TBL_AP_P_REF_SUP_P_TBL_SUPP;

alter table TBL_AP_PAY_DT
   drop constraint FK_TBL_AP_P_REF_2323_TBL_PO_R;

alter table TBL_AP_PAY_DT
   drop constraint FK_TBL_AP_P_REF_2340_TBL_AP_P;

alter table TBL_AR_RECV
   drop constraint FK_TBL_AR_R_REF_CUM_R_TBL_CUST;

alter table TBL_AR_RECV_DT
   drop constraint FK_TBL_AR_R_REF_2317_TBL_SHIP;

alter table TBL_AR_RECV_DT
   drop constraint FK_TBL_AR_R_REF_2337_TBL_AR_R;

alter table TBL_HIS_PO_RECV
   drop constraint FK_TBL_HIS__REF_5400_TBL_SUPP;

alter table TBL_HIS_PO_RECV_DT
   drop constraint FK_TBL_HIS__REF_5380_TBL_HIS_;

alter table TBL_HIS_PO_RECV_DT
   drop constraint FK_TBL_HIS__REF_5404_TBL_PROD;

alter table TBL_HIS_PO_RECV_DT
   drop constraint FK_TBL_HIS__REF_5520_TBL_INVE;

alter table TBL_HIS_SHIP
   drop constraint FK_TBL_HIS__REF_5388_TBL_CUST;

alter table TBL_HIS_SHIP
   drop constraint FK_TBL_HIS__REF_5392_TBL_EMPL;

alter table TBL_HIS_SHIP_DT
   drop constraint FK_TBL_HIS__REF_5376_TBL_HIS_;

alter table TBL_HIS_SHIP_DT
   drop constraint FK_TBL_HIS__REF_5396_TBL_PROD;

alter table TBL_HIS_SHIP_DT
   drop constraint FK_TBL_HIS__REF_5516_TBL_INVE;

alter table TBL_INV_ADJ_DT
   drop constraint FK_TBL_INV__REF_2343_TBL_INV_;

alter table TBL_INV_ADJ_DT
   drop constraint FK_TBL_INV__REF_6272_TBL_INVE;

alter table TBL_INV_ADJ_DT
   drop constraint FK_TBL_INV__REF_PRD_A_TBL_PROD;

alter table TBL_INV_ONHAND
   drop constraint FK_TBL_INV__REF_4575_TBL_PROD;

alter table TBL_INV_ONHAND
   drop constraint FK_TBL_INV__REF_INV_I_TBL_INVE;

alter table TBL_PO_RECV
   drop constraint FK_TBL_PO_R_REF_SUP_R_TBL_SUPP;

alter table TBL_PO_RECV_DT
   drop constraint FK_TBL_PO_R_REF_2320_TBL_PO_R;

alter table TBL_PO_RECV_DT
   drop constraint FK_TBL_PO_R_REF_INV_R_TBL_INVE;

alter table TBL_PO_RECV_DT
   drop constraint FK_TBL_PO_R_REF_PRD_R_TBL_PROD;

alter table TBL_SHIP
   drop constraint FK_TBL_SHIP_REF_2311_TBL_EMPL;

alter table TBL_SHIP
   drop constraint FK_TBL_SHIP_REF_4731_TBL_CAR;

alter table TBL_SHIP
   drop constraint FK_TBL_SHIP_REF_CUM_S_TBL_CUST;

alter table TBL_SHIP_DT
   drop constraint FK_TBL_SHIP_REF_2314_TBL_SHIP;

alter table TBL_SHIP_DT
   drop constraint FK_TBL_SHIP_REF_INV_S_TBL_INVE;

alter table TBL_SHIP_DT
   drop constraint FK_TBL_SHIP_REF_PRD_S_TBL_PROD;

alter table TBL_TRANSACTION
   drop constraint FK_TBL_TRAN_REF_INV_T_TBL_INVE;

alter table TBL_TRANSACTION
   drop constraint FK_TBL_TRAN_REF_PRD_T_TBL_PROD;

drop index REF_SUP_PAY_PK;

drop index REF_2323_PK;

drop index REF_2340_PK;

drop index REF_CUM_RCV_PK;

drop index REF_2317_PK;

drop index REF_2337_PK;

drop index REF_5400_PK;

drop index REF_5380_PK;

drop index REF_5404_PK;

drop index REF_5388_PK;

drop index REF_5392_PK;

drop index REF_5376_PK;

drop index REF_5396_PK;

drop index REF_2343_PK;

drop index REF_PRD_ADD_PK;

drop index REF_4575_PK;

drop index REF_INV_IOH_PK;

drop index REF_SUP_RCV_PK;

drop index REF_2320_PK;

drop index REF_INV_RCD_PK;

drop index REF_PRD_RCD_PK;

drop index REF_2311_PK;

drop index REF_CUM_SMT_PK;

drop index REF_2314_PK;

drop index REF_INV_SMD_PK;

drop index REF_PRD_SMD_PK;

drop index REF_INV_TRN_PK;

drop index REF_PRD_TRN_PK;

drop table TBL_ACNT_ACCOUNT cascade constraints;

drop table TBL_ACNT_INIT cascade constraints;

drop table TBL_ACNT_JOURNAL cascade constraints;

drop table TBL_ACNT_JOURNAL_DT cascade constraints;

drop table TBL_ACNT_TYPE cascade constraints;

drop table TBL_AP_PAY cascade constraints;

drop table TBL_AP_PAY_DT cascade constraints;

drop table TBL_AR_RECV cascade constraints;

drop table TBL_AR_RECV_DT cascade constraints;

drop table TBL_CAR cascade constraints;

drop table TBL_CUSTOMER cascade constraints;

drop table TBL_EMPLOYE cascade constraints;

drop table TBL_FLD_FOR_EDIT cascade constraints;

drop table TBL_HIS_PO_RECV cascade constraints;

drop table TBL_HIS_PO_RECV_DT cascade constraints;

drop table TBL_HIS_SHIP cascade constraints;

drop table TBL_HIS_SHIP_DT cascade constraints;

drop table TBL_INVENTORY cascade constraints;

drop table TBL_INV_ADJ cascade constraints;

drop table TBL_INV_ADJ_DT cascade constraints;

drop table TBL_INV_ONHAND cascade constraints;

drop table TBL_PO_RECV cascade constraints;

drop table TBL_PO_RECV_DT cascade constraints;

drop table TBL_PRODUCT cascade constraints;

drop table TBL_SHIP cascade constraints;

drop table TBL_SHIP_DT cascade constraints;

drop table TBL_SUPPLIER cascade constraints;

drop table TBL_SYS_PARAM cascade constraints;

drop table TBL_TRANSACTION cascade constraints;

/*==============================================================*/
/* Table: TBL_ACNT_ACCOUNT                                      */
/*==============================================================*/
create table TBL_ACNT_ACCOUNT  (
   ACT_NO               VARCHAR2(20)                    not null,
   TYP_NO               VARCHAR2(20)                    not null,
   ACT_NAME             VARCHAR2(80),
   ACT_CATEGORY_REVERSE SMALLINT                       default 0 not null,
   ACT_CATEGORY_CASH    SMALLINT                       default 0 not null,
   ACT_CREATOR          VARCHAR2(20),
   ACT_DESC             VARCHAR2(200),
   constraint PK_TBL_ACNT_ACCOUNT primary key (ACT_NO)
);

/*==============================================================*/
/* Table: TBL_ACNT_INIT                                         */
/*==============================================================*/
create table TBL_ACNT_INIT  (
   INI_YEAR             VARCHAR2(20)                    not null,
   ACT_NO               VARCHAR2(20)                    not null,
   INI_AMOUNT           NUMBER(8,2)                     not null,
   constraint PK_TBL_ACNT_INIT primary key (INI_YEAR, ACT_NO)
);

/*==============================================================*/
/* Table: TBL_ACNT_JOURNAL                                      */
/*==============================================================*/
create table TBL_ACNT_JOURNAL  (
   JNL_NO               VARCHAR2(20)                    not null,
   JNL_DATE             DATE,
   JNL_DESC             VARCHAR2(200),
   JNL_BILL_TYPE        NUMBER                          not null,
   JNL_CREATOR          VARCHAR2(20),
   constraint PK_TBL_ACNT_JOURNAL primary key (JNL_NO)
);

/*==============================================================*/
/* Table: TBL_ACNT_JOURNAL_DT                                   */
/*==============================================================*/
create table TBL_ACNT_JOURNAL_DT  (
   JNL_NO               VARCHAR2(20)                    not null,
   JND_SEQNO            NUMBER                          not null,
   ACT_NO               VARCHAR2(20)                    not null,
   JND_AMOUNT           NUMBER(8,2)                     not null,
   JND_DESC             VARCHAR2(200),
   constraint PK_TBL_ACNT_JOURNAL_DT primary key (JNL_NO, JND_SEQNO)
);

/*==============================================================*/
/* Table: TBL_ACNT_TYPE                                         */
/*==============================================================*/
create table TBL_ACNT_TYPE  (
   TYP_NO               VARCHAR2(20)                    not null,
   TYP_NAME             VARCHAR2(80),
   TYP_MAJOR_TYPE       VARCHAR2(80),
   TYPE_DESC            VARCHAR2(200),
   constraint PK_TBL_ACNT_TYPE primary key (TYP_NO)
);

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
/*==============================================================*/
/* Table: TBL_AP_PAY                                            */
/*==============================================================*/
create table TBL_AP_PAY  (
   PAY_NO               VARCHAR2(20)                    not null,
   SUP_NO               VARCHAR2(20)                    not null,
   JNL_NO               VARCHAR2(20),
   PAY_DATE             DATE                            not null,
   PAY_CASH             NUMBER(8,2)                     not null,
   PAY_CHECK            NUMBER(8,2)                     not null,
   PAY_FROM_ADVANCE     NUMBER(8,2)                     not null,
   PAY_TO_ADVANCE       NUMBER(8,2)                     not null,
   PAY_DESC             VARCHAR2(200),
   PAY_CREATOR          VARCHAR2(20),
   PAY_TR_FLAG          SMALLINT                       default 0 not null,
   constraint PK_TBL_AP_PAY primary key (PAY_NO)
);

/*==============================================================*/
/* Index: REF_SUP_PAY_PK                                        */
/*==============================================================*/
create index REF_SUP_PAY_PK on TBL_AP_PAY (
   SUP_NO ASC
);

/*==============================================================*/
/* Table: TBL_AP_PAY_DT                                         */
/*==============================================================*/
create table TBL_AP_PAY_DT  (
   PAY_NO               VARCHAR2(20)                    not null,
   PAD_SEQNO            NUMBER                          not null,
   RCV_NO               VARCHAR2(20)                    not null,
   PAD_AMOUNT           NUMBER(8,2)                     not null,
   PAD_DISCOUNT         NUMBER(8,2)                     not null,
   constraint PK_TBL_AP_PAY_DT primary key (PAY_NO, PAD_SEQNO)
);

/*==============================================================*/
/* Index: REF_2323_PK                                           */
/*==============================================================*/
create index REF_2323_PK on TBL_AP_PAY_DT (
   RCV_NO ASC
);

/*==============================================================*/
/* Index: REF_2340_PK                                           */
/*==============================================================*/
create index REF_2340_PK on TBL_AP_PAY_DT (
   PAY_NO ASC
);

/*==============================================================*/
/* Table: TBL_AR_RECV                                           */
/*==============================================================*/
create table TBL_AR_RECV  (
   ARR_NO               VARCHAR2(20)                    not null,
   CUM_NO               VARCHAR2(20)                    not null,
   JNL_NO               VARCHAR2(20),
   ARR_DATE             DATE                            not null,
   ARR_CASH             NUMBER(8,2)                     not null,
   ARR_CHECK            NUMBER(8,2)                     not null,
   ARR_FROM_ADVANCE     NUMBER(8,2)                     not null,
   ARR_TO_ADVANCE       NUMBER(8,2)                     not null,
   ARR_DESC             VARCHAR2(200),
   ARR_CREATOR          VARCHAR2(20),
   ARR_TR_FLAG          SMALLINT                       default 0 not null,
   constraint PK_TBL_AR_RECV primary key (ARR_NO)
);

/*==============================================================*/
/* Index: REF_CUM_RCV_PK                                        */
/*==============================================================*/
create index REF_CUM_RCV_PK on TBL_AR_RECV (
   CUM_NO ASC
);

/*==============================================================*/
/* Table: TBL_AR_RECV_DT                                        */
/*==============================================================*/
create table TBL_AR_RECV_DT  (
   ARR_NO               VARCHAR2(20)                    not null,
   ARD_SEQNO            NUMBER                          not null,
   SMT_NO               VARCHAR2(20)                    not null,
   ARD_AMOUNT           NUMBER(8,2)                     not null,
   ARD_DISCOUNT         NUMBER(8,2)                     not null,
   constraint PK_TBL_AR_RECV_DT primary key (ARR_NO, ARD_SEQNO)
);

/*==============================================================*/
/* Index: REF_2317_PK                                           */
/*==============================================================*/
create index REF_2317_PK on TBL_AR_RECV_DT (
   SMT_NO ASC
);

/*==============================================================*/
/* Index: REF_2337_PK                                           */
/*==============================================================*/
create index REF_2337_PK on TBL_AR_RECV_DT (
   ARR_NO ASC
);

/*==============================================================*/
/* Table: TBL_CAR                                               */
/*==============================================================*/
create table TBL_CAR  (
   CAR_NO               VARCHAR2(20)                    not null,
   CAR_BRAND            VARCHAR2(80),
   CAR_LICENSE_NO       VARCHAR2(80),
   CAR_DATE1            DATE,
   CAR_CREATOR          VARCHAR2(20),
   CAR_DESC             VARCHAR2(200),
   constraint PK_TBL_CAR primary key (CAR_NO)
);

/*==============================================================*/
/* Table: TBL_CUSTOMER                                          */
/*==============================================================*/
create table TBL_CUSTOMER  (
   CUM_NO               VARCHAR2(20)                    not null,
   CUM_NAME             VARCHAR2(80)                    not null,
   CUM_PRESIDENT        VARCHAR2(20),
   CUM_CONTANT          VARCHAR2(20),
   CUM_CONT_TITLE       VARCHAR2(20),
   CUM_TEL1             VARCHAR2(30),
   CUM_TEL2             VARCHAR2(30),
   CUM_FAX              VARCHAR2(30),
   CUM_UNIFORM_NO       VARCHAR2(20),
   CUM_INV_ADDR         VARCHAR2(200),
   CUM_ADDR             VARCHAR2(200),
   CUM_ZIP_CODE         VARCHAR2(6),
   CUM_ADVANCE_AMOUNT   NUMBER(8,2)                     not null,
   CUM_DESC             VARCHAR2(200),
   CUM_CREATOR          VARCHAR2(20),
   CUM_ACNT_AR          VARCHAR2(20)                   default '1141' not null,
   CUM_ACNT_ADVANCE     VARCHAR2(20)                   default '2261' not null,
   CUM_INV_RATE         NUMBER(18,4)                   default 0 not null,
   constraint PK_TBL_CUSTOMER primary key (CUM_NO)
);

/*==============================================================*/
/* Table: TBL_EMPLOYE                                           */
/*==============================================================*/
create table TBL_EMPLOYE  (
   EPY_NO               VARCHAR2(20)                    not null,
   EPY_NAME             VARCHAR2(20)                    not null,
   EPY_PASSWORD         VARCHAR2(20),
   EPY_TEL1             VARCHAR2(30),
   EPY_TEL2             VARCHAR2(30),
   EPY_ADDR             VARCHAR2(200),
   EPY_IS_CAN_LOGIN     SMALLINT                       default 0 not null,
   EPY_DESC             VARCHAR2(200),
   EPY_CREATOR          VARCHAR2(20),
   constraint PK_TBL_EMPLOYE primary key (EPY_NO)
);

INSERT INTO TBL_EMPLOYE(EPY_NO, EPY_NAME, EPY_IS_CAN_LOGIN
, EPY_DESC, EPY_CREATOR)
VALUES('WYS','ADMINISTRATOR',1,'SYSTEM ADMINISTRATOR','DEFAULT');
COMMIT;
/*==============================================================*/
/* Table: TBL_FLD_FOR_EDIT                                      */
/*==============================================================*/
create table TBL_FLD_FOR_EDIT  (
   FLD_DUMMY_PK         NUMBER                          not null,
   FLD_STRING           VARCHAR2(255),
   FLD_INT              INTEGER,
   FLD_BOOLEAN          SMALLINT,
   FLD_FLOAT            FLOAT,
   constraint PK_TBL_FLD_FOR_EDIT primary key (FLD_DUMMY_PK)
);

INSERT INTO TBL_FLD_FOR_EDIT (FLD_DUMMY_PK) VALUES (0);
COMMIT;
/*==============================================================*/
/* Table: TBL_HIS_PO_RECV                                       */
/*==============================================================*/
create table TBL_HIS_PO_RECV  (
   HRCV_NO              VARCHAR2(20)                    not null,
   SUP_NO               VARCHAR2(20)                    not null,
   HRCV_DATE            DATE                            not null,
   HRCV_INV_NO          VARCHAR2(20),
   HRCV_TOTAL           NUMBER(8,2)                     not null,
   HRCV_TAX             NUMBER(8,2)                     not null,
   HRCV_DESC            VARCHAR2(200),
   HRCV_CREATOR         VARCHAR2(20),
   constraint PK_TBL_HIS_PO_RECV primary key (HRCV_NO)
);

/*==============================================================*/
/* Index: REF_5400_PK                                           */
/*==============================================================*/
create index REF_5400_PK on TBL_HIS_PO_RECV (
   SUP_NO ASC
);

/*==============================================================*/
/* Table: TBL_HIS_PO_RECV_DT                                    */
/*==============================================================*/
create table TBL_HIS_PO_RECV_DT  (
   HRCV_NO              VARCHAR2(20)                    not null,
   HRCD_SEQNO           NUMBER                          not null,
   PRD_NO               VARCHAR2(20)                    not null,
   INV_NO               VARCHAR2(20)                    not null,
   HRCD_PRD_NAME        VARCHAR2(80),
   HRCD_QTY             NUMBER(18,4)                    not null,
   HRCD_UNIT_PRICE      NUMBER(8,2)                     not null,
   constraint PK_TBL_HIS_PO_RECV_DT primary key (HRCV_NO, HRCD_SEQNO)
);

/*==============================================================*/
/* Index: REF_5380_PK                                           */
/*==============================================================*/
create index REF_5380_PK on TBL_HIS_PO_RECV_DT (
   HRCV_NO ASC
);

/*==============================================================*/
/* Index: REF_5404_PK                                           */
/*==============================================================*/
create index REF_5404_PK on TBL_HIS_PO_RECV_DT (
   PRD_NO ASC
);

/*==============================================================*/
/* Table: TBL_HIS_SHIP                                          */
/*==============================================================*/
create table TBL_HIS_SHIP  (
   HSMT_NO              VARCHAR2(20)                    not null,
   CUM_NO               VARCHAR2(20)                    not null,
   EPY_NO               VARCHAR2(20)                    not null,
   HSMT_INV_NO          VARCHAR2(20),
   HSMT_DATE            DATE                            not null,
   HSMT_DESTINATION     VARCHAR2(200),
   HSMT_TOTAL           NUMBER(8,2)                     not null,
   HSMT_TAX             NUMBER(8,2)                     not null,
   HSMT_COST            NUMBER(8,2)                     not null,
   HSMT_DESC            VARCHAR2(200),
   HSMT_CREATOR         VARCHAR2(20),
   constraint PK_TBL_HIS_SHIP primary key (HSMT_NO)
);

/*==============================================================*/
/* Index: REF_5388_PK                                           */
/*==============================================================*/
create index REF_5388_PK on TBL_HIS_SHIP (
   CUM_NO ASC
);

/*==============================================================*/
/* Index: REF_5392_PK                                           */
/*==============================================================*/
create index REF_5392_PK on TBL_HIS_SHIP (
   EPY_NO ASC
);

/*==============================================================*/
/* Table: TBL_HIS_SHIP_DT                                       */
/*==============================================================*/
create table TBL_HIS_SHIP_DT  (
   HSMT_NO              VARCHAR2(20)                    not null,
   HSMD_SEQNO           NUMBER                          not null,
   PRD_NO               VARCHAR2(20)                    not null,
   INV_NO               VARCHAR2(20)                    not null,
   HSMD_PRD_NAME        VARCHAR2(80),
   HSMD_UNIT_PRICE      NUMBER(8,2)                     not null,
   HSMD_QTY             NUMBER(18,4)                    not null,
   HSMD_COST            NUMBER(8,2)                     not null,
   constraint PK_TBL_HIS_SHIP_DT primary key (HSMT_NO, HSMD_SEQNO)
);

/*==============================================================*/
/* Index: REF_5376_PK                                           */
/*==============================================================*/
create index REF_5376_PK on TBL_HIS_SHIP_DT (
   HSMT_NO ASC
);

/*==============================================================*/
/* Index: REF_5396_PK                                           */
/*==============================================================*/
create index REF_5396_PK on TBL_HIS_SHIP_DT (
   PRD_NO ASC
);

/*==============================================================*/
/* Table: TBL_INVENTORY                                         */
/*==============================================================*/
create table TBL_INVENTORY  (
   INV_NO               VARCHAR2(20)                    not null,
   INV_NAME             VARCHAR2(80)                    not null,
   INV_DESC             VARCHAR2(200),
   INV_CREATOR          VARCHAR2(20),
   constraint PK_TBL_INVENTORY primary key (INV_NO)
);

INSERT INTO TBL_INVENTORY(INV_NO, INV_NAME, INV_DESC, INV_CREATOR)
VALUES('DEFAULT','Default Inventory','System Default','系統自動產生');
COMMIT;
/*==============================================================*/
/* Table: TBL_INV_ADJ                                           */
/*==============================================================*/
create table TBL_INV_ADJ  (
   ADJ_NO               VARCHAR2(20)                    not null,
   ADJ_STATUS           NUMBER                          not null,
   ADJ_DATE             DATE                            not null,
   ADJ_DESC             VARCHAR2(200),
   ADJ_CREATOR          VARCHAR2(20),
   ADJ_TR_FLAG          SMALLINT                       default 0 not null,
   constraint PK_TBL_INV_ADJ primary key (ADJ_NO)
);

/*==============================================================*/
/* Table: TBL_INV_ADJ_DT                                        */
/*==============================================================*/
create table TBL_INV_ADJ_DT  (
   ADJ_NO               VARCHAR2(20)                    not null,
   ADD_SEQNO            NUMBER                          not null,
   PRD_NO               VARCHAR2(20)                    not null,
   ADD_QTY              NUMBER(18,4)                    not null,
   ADD_COST             NUMBER(8,2)                     not null,
   INV_NO               VARCHAR2(20)                    not null,
   constraint PK_TBL_INV_ADJ_DT primary key (ADJ_NO, ADD_SEQNO)
);

/*==============================================================*/
/* Index: REF_2343_PK                                           */
/*==============================================================*/
create index REF_2343_PK on TBL_INV_ADJ_DT (
   ADJ_NO ASC
);

/*==============================================================*/
/* Index: REF_PRD_ADD_PK                                        */
/*==============================================================*/
create index REF_PRD_ADD_PK on TBL_INV_ADJ_DT (
   PRD_NO ASC
);

/*==============================================================*/
/* Table: TBL_INV_ONHAND                                        */
/*==============================================================*/
create table TBL_INV_ONHAND  (
   INV_NO               VARCHAR2(20)                    not null,
   PRD_NO               VARCHAR2(20)                    not null,
   IOH_QTY              NUMBER(18,4)                    not null,
   constraint PK_TBL_INV_ONHAND primary key (INV_NO, PRD_NO)
);

/*==============================================================*/
/* Index: REF_INV_IOH_PK                                        */
/*==============================================================*/
create index REF_INV_IOH_PK on TBL_INV_ONHAND (
   INV_NO ASC
);

/*==============================================================*/
/* Index: REF_4575_PK                                           */
/*==============================================================*/
create index REF_4575_PK on TBL_INV_ONHAND (
   PRD_NO ASC
);

/*==============================================================*/
/* Table: TBL_PO_RECV                                           */
/*==============================================================*/
create table TBL_PO_RECV  (
   RCV_NO               VARCHAR2(20)                    not null,
   SUP_NO               VARCHAR2(20)                    not null,
   JNL_NO               VARCHAR2(20),
   RCV_STATUS           NUMBER                          not null,
   RCV_DATE             DATE                            not null,
   RCV_INV_NO           VARCHAR2(20),
   RCV_TOTAL            NUMBER(8,2)                     not null,
   RCV_TAX              NUMBER(8,2)                     not null,
   RCV_NOT_CLEAN        NUMBER(8,2)                     not null,
   RCV_DESC             VARCHAR2(200),
   RCV_CREATOR          VARCHAR2(20),
   RCV_TR_FLAG          SMALLINT                       default 0 not null,
   constraint PK_TBL_PO_RECV primary key (RCV_NO)
);

/*==============================================================*/
/* Index: REF_SUP_RCV_PK                                        */
/*==============================================================*/
create index REF_SUP_RCV_PK on TBL_PO_RECV (
   SUP_NO ASC
);

/*==============================================================*/
/* Table: TBL_PO_RECV_DT                                        */
/*==============================================================*/
create table TBL_PO_RECV_DT  (
   RCV_NO               VARCHAR2(20)                    not null,
   RCD_SEQNO            NUMBER                          not null,
   PRD_NO               VARCHAR2(20)                    not null,
   INV_NO               VARCHAR2(20)                    not null,
   RCD_PRD_NAME         VARCHAR2(80),
   RCD_QTY              NUMBER(18,4)                    not null,
   RCD_UNIT_PRICE       NUMBER(8,2)                     not null,
   constraint PK_TBL_PO_RECV_DT primary key (RCV_NO, RCD_SEQNO)
);

/*==============================================================*/
/* Index: REF_PRD_RCD_PK                                        */
/*==============================================================*/
create index REF_PRD_RCD_PK on TBL_PO_RECV_DT (
   PRD_NO ASC
);

/*==============================================================*/
/* Index: REF_2320_PK                                           */
/*==============================================================*/
create index REF_2320_PK on TBL_PO_RECV_DT (
   RCV_NO ASC
);

/*==============================================================*/
/* Index: REF_INV_RCD_PK                                        */
/*==============================================================*/
create index REF_INV_RCD_PK on TBL_PO_RECV_DT (
   INV_NO ASC
);

/*==============================================================*/
/* Table: TBL_PRODUCT                                           */
/*==============================================================*/
create table TBL_PRODUCT  (
   PRD_NO               VARCHAR2(20)                    not null,
   PRD_NAME             VARCHAR2(80)                    not null,
   PRD_UNIT             VARCHAR2(6),
   PRD_SALE_PRICE       NUMBER(8,2)                     not null,
   PRD_SAFE_QTY         NUMBER(18,4)                    not null,
   PRD_ONHAND           NUMBER(18,4)                    not null,
   PRD_CUR_COST         NUMBER(8,2)                     not null,
   PRD_DESC             VARCHAR2(200),
   PRD_IS_DUMMY         SMALLINT                       default 0 not null,
   PRD_DUM_COST_RATE    NUMBER(18,4)                    not null,
   PRD_EXT_COST_RATIO   NUMBER(18,4)                    not null,
   PRD_CREATOR          VARCHAR2(20),
   constraint PK_TBL_PRODUCT primary key (PRD_NO)
);

/*==============================================================*/
/* Table: TBL_SHIP                                              */
/*==============================================================*/
create table TBL_SHIP  (
   SMT_NO               VARCHAR2(20)                    not null,
   CUM_NO               VARCHAR2(20)                    not null,
   EPY_NO               VARCHAR2(20)                    not null,
   CAR_NO               VARCHAR2(20),
   JNL_NO               VARCHAR2(20),
   SMT_STATUS           NUMBER                          not null,
   SMT_INV_NO           VARCHAR2(20),
   SMT_DATE             DATE                            not null,
   SMT_DESTINATION      VARCHAR2(200),
   SMT_TOTAL            NUMBER(8,2)                     not null,
   SMT_TAX              NUMBER(8,2)                     not null,
   SMT_NOT_CLEAN        NUMBER(8,2)                     not null,
   SMT_COST             NUMBER(8,2)                     not null,
   SMT_DELIVER1         VARCHAR2(20),
   SMT_DELIVER2         VARCHAR2(20),
   SMT_DESC             VARCHAR2(200),
   SMT_CREATOR          VARCHAR2(20),
   SMT_TR_FLAG          SMALLINT                       default 0 not null,
   constraint PK_TBL_SHIP primary key (SMT_NO)
);

/*==============================================================*/
/* Index: REF_CUM_SMT_PK                                        */
/*==============================================================*/
create index REF_CUM_SMT_PK on TBL_SHIP (
   CUM_NO ASC
);

/*==============================================================*/
/* Index: REF_2311_PK                                           */
/*==============================================================*/
create index REF_2311_PK on TBL_SHIP (
   EPY_NO ASC
);

/*==============================================================*/
/* Table: TBL_SHIP_DT                                           */
/*==============================================================*/
create table TBL_SHIP_DT  (
   SMT_NO               VARCHAR2(20)                    not null,
   SMD_SEQNO            NUMBER                          not null,
   PRD_NO               VARCHAR2(20)                    not null,
   INV_NO               VARCHAR2(20)                    not null,
   SMD_PRD_NAME         VARCHAR2(80),
   SMD_UNIT_PRICE       NUMBER(8,2)                     not null,
   SMD_QTY              NUMBER(18,4)                    not null,
   SMD_COST             NUMBER(8,2)                     not null,
   constraint PK_TBL_SHIP_DT primary key (SMT_NO, SMD_SEQNO)
);

/*==============================================================*/
/* Index: REF_PRD_SMD_PK                                        */
/*==============================================================*/
create index REF_PRD_SMD_PK on TBL_SHIP_DT (
   PRD_NO ASC
);

/*==============================================================*/
/* Index: REF_2314_PK                                           */
/*==============================================================*/
create index REF_2314_PK on TBL_SHIP_DT (
   SMT_NO ASC
);

/*==============================================================*/
/* Index: REF_INV_SMD_PK                                        */
/*==============================================================*/
create index REF_INV_SMD_PK on TBL_SHIP_DT (
   INV_NO ASC
);

/*==============================================================*/
/* Table: TBL_SUPPLIER                                          */
/*==============================================================*/
create table TBL_SUPPLIER  (
   SUP_NO               VARCHAR2(20)                    not null,
   SUP_NAME             VARCHAR2(80)                    not null,
   SUP_PRESIDENT        VARCHAR2(20),
   SUP_CONTANT          VARCHAR2(20),
   SUP_CONT_TITLE       VARCHAR2(20),
   SUP_TEL1             VARCHAR2(30),
   SUP_TEL2             VARCHAR2(30),
   SUP_FAX              VARCHAR2(30),
   SUP_UNIFORM_NO       VARCHAR2(20),
   SUP_INV_ADDR         VARCHAR2(200),
   SUP_ADDR             VARCHAR2(200),
   SUP_ZIP_CODE         VARCHAR2(6),
   SUP_ADVANCE_AMOUNT   NUMBER(8,2)                     not null,
   SUP_DESC             VARCHAR2(200),
   SUP_CREATOR          VARCHAR2(20),
   SUP_ACNT_AP          VARCHAR2(20)                   default '2141' not null,
   SUP_ACNT_ADVANCE     VARCHAR2(20)                   default '1261' not null,
   constraint PK_TBL_SUPPLIER primary key (SUP_NO)
);

/*==============================================================*/
/* Table: TBL_SYS_PARAM                                         */
/*==============================================================*/
create table TBL_SYS_PARAM  (
   SPR_PERIOD_START     DATE                            not null,
   SPR_COR_NAME         VARCHAR2(80),
   SPR_TEL              VARCHAR2(30),
   SPR_FAX              VARCHAR2(30),
   SPR_ADDR             VARCHAR2(200),
   SPR_TAX_RATE         NUMBER(18,4)                    not null,
   SPR_QTY_DECIMAL      NUMBER,
   SPR_AMOUNT_UNIT_DOT  NUMBER,
   SPR_AMOUNT_DOT       NUMBER,
   SPR_BKUP_CMD         VARCHAR2(250),
   SPR_BKUP_PARA        VARCHAR2(250),
   SPR_BKUP_PATH        VARCHAR2(250),
   SPR_PRD_COST_RATE    NUMBER(18,4)                   default 0.05 not null,
   SPR_BONUS_SALE_RATE  NUMBER(18,4)                   default 0.01 not null,
   SPR_BONUS_PROFIT_RATE NUMBER(18,4)                   default 0.15 not null,
   SPR_ACNT_YEAR        NUMBER                         default 2004 not null,
   SPR_ACNT_SALE_REVENUE VARCHAR2(20)                   default '4111' not null,
   SPR_ACNT_SALE_RETURN VARCHAR2(20)                   default '4171' not null,
   SPR_ACNT_SALE_DISCOUNT VARCHAR2(20)                   default '4191' not null,
   SPR_ACNT_SALE_TAX    VARCHAR2(20)                   default '2281',
   SPR_ACNT_PURCHASE    VARCHAR2(20)                   default '5121' not null,
   SPR_ACNT_PUR_DISCOUNT VARCHAR2(20)                   default '5124' not null,
   SPR_ACNT_PUR_RETURN  VARCHAR2(20)                   default '5123' not null,
   SPR_ACNT_PUR_TAX     VARCHAR2(20)                   default '1281',
   SPR_ACNT_CASH        VARCHAR2(20)                   default '1111' not null,
   SPR_ACNT_CUS_CHECK   VARCHAR2(20)                   default '1131' not null,
   SPR_ACNT_SUP_CHECK   VARCHAR2(20)                   default '2131' not null,
   constraint PK_TBL_SYS_PARAM primary key (SPR_PERIOD_START)
);

INSERT INTO TBL_SYS_PARAM(SPR_PERIOD_START, SPR_COR_NAME, SPR_TEL, SPR_FAX
, SPR_ADDR, SPR_TAX_RATE
, SPR_QTY_DECIMAL, SPR_AMOUNT_UNIT_DOT, SPR_AMOUNT_DOT
, SPR_BKUP_CMD, SPR_BKUP_PARA, SPR_BKUP_PATH)
VALUES(TO_DATE('01/01/1980','MM/DD/YYYY'),'ERP DISTRIBUTION','TEL','FAX'
,'ADDR',0.05
,1,2,0
,'WINRAR','A','.');
COMMIT;
/*==============================================================*/
/* Table: TBL_TRANSACTION                                       */
/*==============================================================*/
create table TBL_TRANSACTION  (
   TRN_ID               NUMBER(6)                       not null,
   PRD_NO               VARCHAR2(20)                    not null,
   INV_NO               VARCHAR2(20)                    not null,
   TRN_TYPE             NUMBER                          not null,
   TRN_SRC_NO           VARCHAR2(20),
   TRN_SRC_SEQNO        NUMBER,
   TRN_DATETIME         DATE                            not null,
   TRN_QTY              NUMBER(18,4)                    not null,
   TRN_COST             NUMBER(8,2)                     not null,
   TRN_ONHAND           NUMBER(18,4)                    not null,
   TRN_AVG_COST         NUMBER(8,2)                     not null,
   constraint PK_TBL_TRANSACTION primary key (TRN_ID)
);

/*==============================================================*/
/* Index: REF_INV_TRN_PK                                        */
/*==============================================================*/
create index REF_INV_TRN_PK on TBL_TRANSACTION (
   INV_NO ASC
);

/*==============================================================*/
/* Index: REF_PRD_TRN_PK                                        */
/*==============================================================*/
create index REF_PRD_TRN_PK on TBL_TRANSACTION (
   PRD_NO ASC
);

alter table TBL_ACNT_ACCOUNT
   add constraint FK_TBL_ACNT_REF_2110_TBL_ACNT foreign key (TYP_NO)
      references TBL_ACNT_TYPE (TYP_NO);

alter table TBL_ACNT_INIT
   add constraint FK_TBL_ACNT_REF_2107_TBL_ACNT foreign key (ACT_NO)
      references TBL_ACNT_ACCOUNT (ACT_NO);

alter table TBL_ACNT_JOURNAL_DT
   add constraint FK_TBL_ACNT_REF_2104_TBL_ACNT foreign key (ACT_NO)
      references TBL_ACNT_ACCOUNT (ACT_NO);

alter table TBL_ACNT_JOURNAL_DT
   add constraint FK_TBL_ACNT_REF_2113_TBL_ACNT foreign key (JNL_NO)
      references TBL_ACNT_JOURNAL (JNL_NO);

alter table TBL_AP_PAY
   add constraint FK_TBL_AP_P_REF_SUP_P_TBL_SUPP foreign key (SUP_NO)
      references TBL_SUPPLIER (SUP_NO);

alter table TBL_AP_PAY_DT
   add constraint FK_TBL_AP_P_REF_2323_TBL_PO_R foreign key (RCV_NO)
      references TBL_PO_RECV (RCV_NO);

alter table TBL_AP_PAY_DT
   add constraint FK_TBL_AP_P_REF_2340_TBL_AP_P foreign key (PAY_NO)
      references TBL_AP_PAY (PAY_NO);

alter table TBL_AR_RECV
   add constraint FK_TBL_AR_R_REF_CUM_R_TBL_CUST foreign key (CUM_NO)
      references TBL_CUSTOMER (CUM_NO);

alter table TBL_AR_RECV_DT
   add constraint FK_TBL_AR_R_REF_2317_TBL_SHIP foreign key (SMT_NO)
      references TBL_SHIP (SMT_NO);

alter table TBL_AR_RECV_DT
   add constraint FK_TBL_AR_R_REF_2337_TBL_AR_R foreign key (ARR_NO)
      references TBL_AR_RECV (ARR_NO);

alter table TBL_HIS_PO_RECV
   add constraint FK_TBL_HIS__REF_5400_TBL_SUPP foreign key (SUP_NO)
      references TBL_SUPPLIER (SUP_NO);

alter table TBL_HIS_PO_RECV_DT
   add constraint FK_TBL_HIS__REF_5380_TBL_HIS_ foreign key (HRCV_NO)
      references TBL_HIS_PO_RECV (HRCV_NO);

alter table TBL_HIS_PO_RECV_DT
   add constraint FK_TBL_HIS__REF_5404_TBL_PROD foreign key (PRD_NO)
      references TBL_PRODUCT (PRD_NO);

alter table TBL_HIS_PO_RECV_DT
   add constraint FK_TBL_HIS__REF_5520_TBL_INVE foreign key (INV_NO)
      references TBL_INVENTORY (INV_NO);

alter table TBL_HIS_SHIP
   add constraint FK_TBL_HIS__REF_5388_TBL_CUST foreign key (CUM_NO)
      references TBL_CUSTOMER (CUM_NO);

alter table TBL_HIS_SHIP
   add constraint FK_TBL_HIS__REF_5392_TBL_EMPL foreign key (EPY_NO)
      references TBL_EMPLOYE (EPY_NO);

alter table TBL_HIS_SHIP_DT
   add constraint FK_TBL_HIS__REF_5376_TBL_HIS_ foreign key (HSMT_NO)
      references TBL_HIS_SHIP (HSMT_NO);

alter table TBL_HIS_SHIP_DT
   add constraint FK_TBL_HIS__REF_5396_TBL_PROD foreign key (PRD_NO)
      references TBL_PRODUCT (PRD_NO);

alter table TBL_HIS_SHIP_DT
   add constraint FK_TBL_HIS__REF_5516_TBL_INVE foreign key (INV_NO)
      references TBL_INVENTORY (INV_NO);

alter table TBL_INV_ADJ_DT
   add constraint FK_TBL_INV__REF_2343_TBL_INV_ foreign key (ADJ_NO)
      references TBL_INV_ADJ (ADJ_NO);

alter table TBL_INV_ADJ_DT
   add constraint FK_TBL_INV__REF_6272_TBL_INVE foreign key (INV_NO)
      references TBL_INVENTORY (INV_NO);

alter table TBL_INV_ADJ_DT
   add constraint FK_TBL_INV__REF_PRD_A_TBL_PROD foreign key (PRD_NO)
      references TBL_PRODUCT (PRD_NO);

alter table TBL_INV_ONHAND
   add constraint FK_TBL_INV__REF_4575_TBL_PROD foreign key (PRD_NO)
      references TBL_PRODUCT (PRD_NO);

alter table TBL_INV_ONHAND
   add constraint FK_TBL_INV__REF_INV_I_TBL_INVE foreign key (INV_NO)
      references TBL_INVENTORY (INV_NO);

alter table TBL_PO_RECV
   add constraint FK_TBL_PO_R_REF_SUP_R_TBL_SUPP foreign key (SUP_NO)
      references TBL_SUPPLIER (SUP_NO);

alter table TBL_PO_RECV_DT
   add constraint FK_TBL_PO_R_REF_2320_TBL_PO_R foreign key (RCV_NO)
      references TBL_PO_RECV (RCV_NO);

alter table TBL_PO_RECV_DT
   add constraint FK_TBL_PO_R_REF_INV_R_TBL_INVE foreign key (INV_NO)
      references TBL_INVENTORY (INV_NO);

alter table TBL_PO_RECV_DT
   add constraint FK_TBL_PO_R_REF_PRD_R_TBL_PROD foreign key (PRD_NO)
      references TBL_PRODUCT (PRD_NO);

alter table TBL_SHIP
   add constraint FK_TBL_SHIP_REF_2311_TBL_EMPL foreign key (EPY_NO)
      references TBL_EMPLOYE (EPY_NO);

alter table TBL_SHIP
   add constraint FK_TBL_SHIP_REF_4731_TBL_CAR foreign key (CAR_NO)
      references TBL_CAR (CAR_NO);

alter table TBL_SHIP
   add constraint FK_TBL_SHIP_REF_CUM_S_TBL_CUST foreign key (CUM_NO)
      references TBL_CUSTOMER (CUM_NO);

alter table TBL_SHIP_DT
   add constraint FK_TBL_SHIP_REF_2314_TBL_SHIP foreign key (SMT_NO)
      references TBL_SHIP (SMT_NO);

alter table TBL_SHIP_DT
   add constraint FK_TBL_SHIP_REF_INV_S_TBL_INVE foreign key (INV_NO)
      references TBL_INVENTORY (INV_NO);

alter table TBL_SHIP_DT
   add constraint FK_TBL_SHIP_REF_PRD_S_TBL_PROD foreign key (PRD_NO)
      references TBL_PRODUCT (PRD_NO);

alter table TBL_TRANSACTION
   add constraint FK_TBL_TRAN_REF_INV_T_TBL_INVE foreign key (INV_NO)
      references TBL_INVENTORY (INV_NO);

alter table TBL_TRANSACTION
   add constraint FK_TBL_TRAN_REF_PRD_T_TBL_PROD foreign key (PRD_NO)
      references TBL_PRODUCT (PRD_NO);


/*==============================================================*/
/* Database name:  SYSREPORT                                    */
/* DBMS name:      ORACLE Version 8 (Deprecated)                */
/* Created on:     2026/8/24 下午 04:19:58                        */
/*==============================================================*/


ALTER TABLE TBLSYSREPORTFIELD
   DROP CONSTRAINT FK_TBLSYSRE_REFERENCE_TBLDD;

ALTER TABLE TBLSYSREPORTFIELD
   DROP CONSTRAINT FK_TBLSYSRE_REFERENCE_TBLSYSRE;

ALTER TABLE TBL_DDFIELD
   DROP CONSTRAINT FK_TBL_DDFI_REFERENCE_TBLDD;

DROP TABLE TBLDD CASCADE CONSTRAINTS;

DROP TABLE TBLSYSREPORT CASCADE CONSTRAINTS;

DROP TABLE TBLSYSREPORTFIELD CASCADE CONSTRAINTS;

DROP TABLE TBL_DDFIELD CASCADE CONSTRAINTS;

DROP SEQUENCE S_SRP_ID;

CREATE SEQUENCE S_SRP_ID;

/*==============================================================*/
/* Table: TBLDD                                                 */
/*==============================================================*/
CREATE TABLE TBLDD  (
   DDM_NO               VARCHAR2(80)                     NOT NULL,
   DDM_NAME             VARCHAR2(80)                     NOT NULL,
   DDM_SQL              VARCHAR2(4000),
   IS_MULTI_SELECTED    CHAR(10),
   RET_VAL_FIELD        VARCHAR2(80),
   CONSTRAINT PK_TBLDD PRIMARY KEY (DDM_NO)
);

COMMENT ON TABLE TBLDD IS
'資料字典主檔
資料字典主檔用查詢主檔欄位時，出現Loopup 畫面讓 USER 快速篩選資料';

COMMENT ON COLUMN TBLDD.DDM_NO IS
'資料字典主檔編號';

COMMENT ON COLUMN TBLDD.DDM_NAME IS
'資料字典主檔名稱';

COMMENT ON COLUMN TBLDD.DDM_SQL IS
'定義資料字典的來源資料 SQL';

COMMENT ON COLUMN TBLDD.IS_MULTI_SELECTED IS
'是否允許多選';

COMMENT ON COLUMN TBLDD.RET_VAL_FIELD IS
'user 選擇後，返回值的欄位名稱，
不管是否多選，回傳值都是 JSON ARRAY 格式';

/*==============================================================*/
/* Table: TBLSYSREPORT                                          */
/*==============================================================*/
CREATE TABLE TBLSYSREPORT  (
   SRP_ID               NUMBER(9)                      DEFAULT S_SRP_ID.NEXTVAL  NOT NULL,
   SRP_CODE             VARCHAR2(80)                     NOT NULL,
   SRP_NAME             VARCHAR2(80)                     NOT NULL,
   SRP_DESCRIPTION      VARCHAR2(255),
   SRP_SQL              VARCHAR2(4000)                   NOT NULL,
   SRP_REPORTFILE       CLOB,
   ORDERBY_LIST         VARCHAR2(255),
   CONSTRAINT PK_TBLSYSREPORT PRIMARY KEY (SRP_ID)
);

COMMENT ON COLUMN TBLSYSREPORT.SRP_CODE IS
'報表編號';

COMMENT ON COLUMN TBLSYSREPORT.SRP_NAME IS
'報表名稱';

COMMENT ON COLUMN TBLSYSREPORT.SRP_DESCRIPTION IS
'報表說明';

COMMENT ON COLUMN TBLSYSREPORT.SRP_SQL IS
'SQL TEXT';

COMMENT ON COLUMN TBLSYSREPORT.SRP_REPORTFILE IS
'報表 Layout 格式內容';

COMMENT ON COLUMN TBLSYSREPORT.ORDERBY_LIST IS
'排序欄位清單，JSON 逗號分隔，報表查詢畫面時，會出現排序清單內，USER 可以上下移動排列順序並ˇ指定遞增、遞減
JSON 以陣列表示，每個陣列2-3個元素
元素1=欄位名稱
元素2=欄位顯示名稱
元素3 (可省略)=ASC 或 DESC  遞增或遞減，預設=ASC
格式如下:
[CUM_NO,客戶編號,DESC],
[CUM_NAME,客戶名稱]


';

/*==============================================================*/
/* Table: TBLSYSREPORTFIELD                                     */
/*==============================================================*/
CREATE TABLE TBLSYSREPORTFIELD  (
   SRF_ID               NUMBER(9)                      DEFAULT S_SRF_ID.NEXTVAL  NOT NULL,
   SRP_ID               NUMBER(9)                        NOT NULL,
   QUERYNAME            VARCHAR2(80)                     NOT NULL,
   QUERYNAME2           VARCHAR2(80),
   SRF_DISPNAME         VARCHAR2(80)                     NOT NULL,
   SRF_DATATYPE         VARCHAR2(20),
   SRF_CONTROLTYPE      VARCHAR2(20)                     NOT NULL,
   SRF_ISMUSTCRITERIA   NUMBER(1)                        NOT NULL,
   SRF_LIST_VALUE       VARCHAR2(4000),
   DDM_NO               VARCHAR2(80),
   DEFAULT_VAL          VARCHAR2(80),
   SORTORDER            NUMBER(9)                        NOT NULL,
   CONSTRAINT PK_TBLSYSREPORTFIELD PRIMARY KEY (SRF_ID)
);

COMMENT ON COLUMN TBLSYSREPORTFIELD.QUERYNAME IS
'查詢變數名稱
除了 between to 以外的所有的查詢變數都放在這裡

';

COMMENT ON COLUMN TBLSYSREPORTFIELD.QUERYNAME2 IS
'查詢變數名稱2，
只放 between to 的查詢變數，其他種類的查詢子句都放在 QUERYNAME，
如果不是 BETWEEN 的查詢方式，此欄位=NULL



';

COMMENT ON COLUMN TBLSYSREPORTFIELD.SRF_DISPNAME IS
'查詢畫面顯示名稱';

COMMENT ON COLUMN TBLSYSREPORTFIELD.SRF_DATATYPE IS
'資料型態
TEXT,NUMBER,BOOLEAN，
當 資料型態= BOOLEAN時，轉換成 SQL 語法時，BOOLEAN 會轉成 1 跟 0';

COMMENT ON COLUMN TBLSYSREPORTFIELD.SRF_CONTROLTYPE IS
'控制項類別，有下面幾種:
TEXT:對應產生 TEXT 輸入框
DATE:對應產生 DateTime picker 輸入框
NUMBER:對應產生 數字(包含小數) 輸入框
BOOLEAN:顯示 CHECKBOX ，SQL VALUE 自動轉成 0 或 1
LIST:搭配 SRF_LIST_VALUE，產生 DropList 
DDLookupEdit:對應產生 DDLookupEdit 控制項，必須指定 DDM_NO 

所有控制項旁邊都有一個  打叉的清除 icon，可將該控制項內容清除為 null
';

COMMENT ON COLUMN TBLSYSREPORTFIELD.SRF_ISMUSTCRITERIA IS
'是否為必要條件，
若是必要條件，則 user 必須輸入，不允許空白';

COMMENT ON COLUMN TBLSYSREPORTFIELD.SRF_LIST_VALUE IS
'選項列表，當控制項類別是LIST時，這個欄位存放逗號分隔的選項內容';

COMMENT ON COLUMN TBLSYSREPORTFIELD.DDM_NO IS
'DDM_NO:存放 DDLookupEdit 的 DDM_NO
當控制項類別=DDLookupEdit，此欄位放置資料字典主檔編號 DDM_NO';

COMMENT ON COLUMN TBLSYSREPORTFIELD.DEFAULT_VAL IS
'預設值，當該查詢欄位 user 未輸入時，以預設值取代';

COMMENT ON COLUMN TBLSYSREPORTFIELD.SORTORDER IS
'查詢欄位的排列順序';


INSERT INTO TBLSYSREPORT (SRP_CODE, SRP_NAME, SRP_DESCRIPTION, SRP_SQL, ORDERBY_LIST)
VALUES ('M_Customer', '客戶清單', NULL, 'SELECT A.*
FROM TBL_CUSTOMER A
WHERE A.CUM_NO LIKE :CUM_NO
  AND A.CUM_NAME LIKE :CUM_NAME
', '[CUM_NO,客戶編號],[CUM_NAME,客戶名稱,DESC]');



INSERT INTO TBLSYSREPORTFIELD (SRP_ID, QUERYNAME, QUERYNAME2, SRF_DISPNAME, SRF_DATATYPE, SRF_CONTROLTYPE, SRF_ISMUSTCRITERIA, SRF_LIST_VALUE, DDM_NO, DEFAULT_VAL, SORTORDER)
VALUES (1, 'CUM_NO', NULL, '客戶編號', 'TEXT', 'TEXT', 0, NULL, NULL, '%', 1);

INSERT INTO TBLSYSREPORTFIELD (SRP_ID, QUERYNAME, QUERYNAME2, SRF_DISPNAME, SRF_DATATYPE, SRF_CONTROLTYPE, SRF_ISMUSTCRITERIA, SRF_LIST_VALUE, DDM_NO, DEFAULT_VAL, SORTORDER)
VALUES (1, 'CUM_NAME', NULL, '客戶名稱', 'TEXT', 'TEXT', 0, NULL, NULL, '%', 2);

COMMIT;

/*==============================================================*/
/* Table: TBL_DDFIELD                                           */
/*==============================================================*/
CREATE TABLE TBL_DDFIELD  (
   DDD_ID               NUMBER(9)                      DEFAULT S_DDD_ID.NEXTVAL  NOT NULL,
   DDM_NO               VARCHAR2(80),
   DDD_FIELD            VARCHAR2(80),
   DDD_FIELD_DISP       VARCHAR2(80),
   CONSTRAINT PK_TBL_DDFIELD PRIMARY KEY (DDD_ID),
   CONSTRAINT AK_KEY_2_TBL_DDFI UNIQUE (DDM_NO, DDD_FIELD_DISP)
);

COMMENT ON TABLE TBL_DDFIELD IS
'資料字典欄位定義';

COMMENT ON COLUMN TBL_DDFIELD.DDM_NO IS
'資料字典主檔編號';

COMMENT ON COLUMN TBL_DDFIELD.DDD_FIELD IS
'欄位名稱';

COMMENT ON COLUMN TBL_DDFIELD.DDD_FIELD_DISP IS
'欄位顯示';


INSERT INTO TBLDD (DDM_NO, DDM_NAME, DDM_SQL, IS_MULTI_SELECTED, RET_VAL_FIELD)
VALUES ('TBLDD', '資料字典', 'SELECT A.DDM_NO,A.DDM_NAME
FROM TBLDD A
ORDER BY A.DDM_NO', 'N         ', 'DDM_NO');



INSERT INTO TBL_DDFIELD (DDD_ID, DDM_NO, DDD_FIELD, DDD_FIELD_DISP)
VALUES (2, 'TBLDD', 'DDM_NAME', '資料字典名稱');

INSERT INTO TBL_DDFIELD (DDD_ID, DDM_NO, DDD_FIELD, DDD_FIELD_DISP)
VALUES (1, 'TBLDD', 'DDM_NO', '資料字典編號');

COMMIT;

ALTER TABLE TBLSYSREPORTFIELD
   ADD CONSTRAINT FK_TBLSYSRE_REFERENCE_TBLDD FOREIGN KEY (DDM_NO)
      REFERENCES TBLDD (DDM_NO);

ALTER TABLE TBLSYSREPORTFIELD
   ADD CONSTRAINT FK_TBLSYSRE_REFERENCE_TBLSYSRE FOREIGN KEY (SRP_ID)
      REFERENCES TBLSYSREPORT (SRP_ID);

ALTER TABLE TBL_DDFIELD
   ADD CONSTRAINT FK_TBL_DDFI_REFERENCE_TBLDD FOREIGN KEY (DDM_NO)
      REFERENCES TBLDD (DDM_NO);


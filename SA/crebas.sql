/*==============================================================*/
/* DBMS name:      PostgreSQL 8                                 */
/* Created on:     2026/9/16 下午 03:07:37                        */
/*==============================================================*/


drop table TBLDD cascade;

drop table TBLSYSREPORT cascade;

drop table TBLSYSREPORTFIELD cascade;

drop table TBL_ACNT_ACCOUNT cascade;

drop table TBL_ACNT_INIT cascade;

drop table TBL_ACNT_JOURNAL cascade;

drop table TBL_ACNT_JOURNAL_DT cascade;

drop table TBL_ACNT_TYPE cascade;

drop table TBL_AP_PAY cascade;

drop table TBL_AP_PAY_DT cascade;

drop table TBL_AR_RECV cascade;

drop table TBL_AR_RECV_DT cascade;

drop table TBL_CAR cascade;

drop table TBL_CUSTOMER cascade;

drop table TBL_DDFIELD cascade;

drop table TBL_EMPLOYE cascade;

drop table TBL_HIS_PO_RECV cascade;

drop table TBL_HIS_PO_RECV_DT cascade;

drop table TBL_HIS_SHIP cascade;

drop table TBL_HIS_SHIP_DT cascade;

drop table TBL_INVENTORY cascade;

drop table TBL_INV_ADJ cascade;

drop table TBL_INV_ADJ_DT cascade;

drop table TBL_INV_ONHAND cascade;

drop table TBL_PO_RECV cascade;

drop table TBL_PO_RECV_DT cascade;

drop table TBL_PRODUCT cascade;

drop table TBL_SHIP cascade;

drop table TBL_SHIP_DT cascade;

drop table TBL_SUPPLIER cascade;

drop table TBL_SYS_PARAM cascade;

drop table TBL_TRANSACTION cascade;

/*==============================================================*/
/* Table: TBLDD                                                 */
/*==============================================================*/
create table TBLDD (
   DDM_NO               VARCHAR(80)          not null,
   DDM_NAME             VARCHAR(80)          not null,
   DDM_SQL              TEXT                 null,
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
   SRP_SELECT           TEXT                 not null,
   SRP_WHERE            TEXT                 null,
   SRP_GROUPBY          TEXT                 null,
   SRP_ORDERBY          TEXT                 null,
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
   SRF_TABLEALIAS       VARCHAR(80)          null,
   SRF_DISPORDER        INT4                 not null,
   SRF_DATATYPE         VARCHAR(20)          null,
   SRF_CONTROLTYPE      VARCHAR(20)          not null,
   SRF_QUERYTYPE        VARCHAR(20)          not null,
   SRF_ISMUSTCRITERIA   BOOL                 not null,
   SRF_ISWHERE          BOOL                 not null,
   SRF_ISSORT           BOOL                 not null,
   SRF_SORTDEC          BOOL                 null,
   SRF_LIST_VALUE       TEXT                 null,
   SRF_LIST_SQL         TEXT                 null,
   SRF_LIST_RETURNFIELD VARCHAR(80)          null,
   SRF_LIST_FIELDDISP   TEXT                 null,
   constraint PK_TBLSYSREPORTFIELD primary key (SRP_ID, SRF_SEQNO),
   constraint FK_TBLSYSRE_REF_1800_TBLSYSRE foreign key (SRP_ID)
      references TBLSYSREPORT (SRP_ID)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Table: TBL_ACNT_TYPE                                         */
/*==============================================================*/
create table TBL_ACNT_TYPE (
   TYP_NO               VARCHAR(20)          not null,
   TYP_NAME             VARCHAR(80)          null,
   TYP_MAJOR_TYPE       VARCHAR(80)          null,
   TYPE_DESC            VARCHAR(200)         null,
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
/* Table: TBL_ACNT_ACCOUNT                                      */
/*==============================================================*/
create table TBL_ACNT_ACCOUNT (
   ACT_NO               VARCHAR(20)          not null,
   TYP_NO               VARCHAR(20)          not null,
   ACT_NAME             VARCHAR(80)          null,
   ACT_CATEGORY_REVERSE BOOL                 not null default false,
   ACT_CATEGORY_CASH    BOOL                 not null default false,
   ACT_CREATOR          VARCHAR(20)          null,
   ACT_DESC             VARCHAR(200)         null,
   constraint PK_TBL_ACNT_ACCOUNT primary key (ACT_NO),
   constraint FK_TBL_ACNT_REF_2110_TBL_ACNT foreign key (TYP_NO)
      references TBL_ACNT_TYPE (TYP_NO)
      on delete restrict on update restrict
);

INSERT INTO "public"."tbl_acnt_account" VALUES ('1112', '11', '零用金/週轉金', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1113', '11', '銀行存款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1116', '11', '在途現金', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1117', '11', '約當現金', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1118', '11', '其他現金及 約當現金', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1121', '11', '短期投資 —股票', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1122', '11', '短期投資 —短期票券', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1123', '11', '短期投資 —政府債券', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1124', '11', '短期投資 —受益憑證', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1125', '11', '短期投資 —公司債', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1128', '11', '短期投資 —其他', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1129', '11', '備抵短期投資跌價損失', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1131', '11', '應收票據', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1132', '11', '應收票據貼現', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1137', '11', '應收票據 —關係人', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1138', '11', '其他應收票據', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1139', '11', '備抵呆帳 －應收票據', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1141', '11', '應收帳款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1142', '11', '應收分期帳款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1147', '11', '應收帳款 —關係人', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1149', '11', '備抵呆帳 －應收帳款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1181', '11', '應收出售遠匯款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1182', '11', '應收遠匯款 —外幣', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1183', '11', '買賣遠匯折價', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1184', '11', '應收收益', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1185', '11', '應收退稅款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1187', '11', '其他應收款 — 關係人', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1188', '11', '其他應收款 — 其他', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1189', '11', '備抵呆帳 — 其他應收款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1211', '11', '商品存貨', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1212', '11', '寄銷商品', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1213', '11', '在途商品', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1219', '11', '備抵存貨跌價損失', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1221', '11', '製成品', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1222', '11', '寄銷製成品', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1223', '11', '副產品', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1224', '11', '在製品', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1225', '11', '委外加工', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1226', '11', '原料', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1227', '11', '物料', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1228', '11', '在途原物料', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1229', '11', '備抵存貨跌價損失', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1251', '11', '預付薪資', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1252', '11', '預付租金', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1253', '11', '預付保險費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1254', '11', '用品盤存', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1255', '11', '預付所得稅', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1258', '11', '其他預付費用', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1261', '11', '預付貨款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1268', '11', '其他預付款項', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1281', '11', '進項稅額', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1282', '11', '留抵稅額', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1283', '11', '暫付款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1284', '11', '代付款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1285', '11', '員工借支', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1286', '11', '存出保證金', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1287', '11', '受限制存款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1291', '11', '遞延所得稅資產', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1292', '11', '遞延兌換損失', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1293', '11', '業主(股東)往來', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1294', '11', '同業往來', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1298', '11', '其他流動資產—其他', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1311', '13', '償債基金', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1312', '13', '改良及擴充基金', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1313', '13', '意外損失準備基金', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1314', '13', '退休基金', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1318', '13', '其他基金', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1321', '13', '長期股權投資', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1322', '13', '長期債券投資', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1323', '13', '長期不動產投資', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1324', '13', '人壽保險現金解約價值', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1328', '13', '其他長期投資', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1329', '13', '備抵長期投資跌價損失', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1411', '14', '土地', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1418', '14', '土地—重估增值', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1421', '14', '土地改良物', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1428', '14', '土地改良物 —重估增值', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1429', '14', '累積折舊 —土地改良物', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1431', '14', '房屋及建物', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1438', '14', '房屋及建物 —重估增值', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1439', '14', '累積折舊 —房屋及建物', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1441', '14', '機(器)具', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1448', '14', '機(器)具 —重估增值', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1449', '14', '累積折舊 —機(器)具', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1511', '14', '租賃資產', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1519', '14', '累積折舊 —租賃資產', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1521', '14', '租賃權益改良', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1529', '14', '累積折舊— 租賃權益改良', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1561', '14', '未完工程', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1562', '14', '預付購置設備款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1581', '14', '雜項固定資產', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1588', '14', '雜項固定資產—重估增值', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1589', '14', '累積折舊— 雜項固定資產', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1611', '16', '天然資源', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1618', '16', '天然資源 —重估增值', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1619', '16', '累積折耗 —天然資源', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1711', '17', '商標權', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1721', '17', '專利權', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1731', '17', '特許權', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1741', '17', '著作權', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1751', '17', '電腦軟體', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1761', '17', '商譽', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1771', '17', '開辦費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1781', '17', '遞延退休金成本', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1782', '17', '租賃權益改良', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1788', '17', '其他無形資產—其他', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1811', '18', '債券發行成本', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1812', '18', '長期預付租金', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1813', '18', '長期預付保險費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1814', '18', '遞延所得稅資產', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1815', '18', '預付退休金', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1818', '18', '其他遞延資產', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1821', '18', '閒置資產', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1841', '18', '長期應收票據', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1842', '18', '長期應收帳款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1843', '18', '催收帳款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1847', '18', '長期應收票據及款項與催收帳款—關係人', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1848', '18', '其他長期應收款項', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1849', '18', '備抵呆帳—長期應收票據及款項與催收帳款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1851', '18', '出租資產', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1858', '18', '出租資產 —重估增值', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1859', '18', '累積折舊 —出租資產', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1861', '18', '存出保證金', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1881', '18', '受限制存款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1888', '18', '雜項資產 —其他', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2111', '21', '銀行透支', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2112', '21', '銀行借款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2114', '21', '短期借款 —業主', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2115', '21', '短期借款 —員工', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2117', '21', '短期借款 —關係人', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2118', '21', '短期借款 —其他', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2121', '21', '應付商業本票', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2122', '21', '銀行承兌匯票', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2128', '21', '其他應付短期票券', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2129', '21', '應付短期票券折價', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2131', '21', '應付票據', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2137', '21', '應付票據 —關係人', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2138', '21', '其他應付票據', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2141', '21', '應付帳款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2147', '21', '應付帳款 —關係人', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2161', '21', '應付所得稅', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2171', '21', '應付薪工', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2172', '21', '應付租金', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2173', '21', '應付利息', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2174', '21', '應付營業稅', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2175', '21', '應付稅捐 —其他', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2178', '21', '其他應付費用', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2181', '21', '應付購入遠匯款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2182', '21', '應付遠匯款 —外幣', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2183', '21', '買賣遠匯溢價', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2184', '21', '應付土地房屋款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2185', '21', '應付設備款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2187', '21', '其他應付款 —關係人', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2191', '21', '應付股利', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2192', '21', '應付紅利', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2193', '21', '應付董監事酬勞', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2198', '21', '其他應付款 —其他', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2261', '21', '預收貨款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2262', '21', '預收收入', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2268', '21', '其他預收款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2271', '21', '一年或一營業週期內到期公司債', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2272', '21', '一年或一營業週期內到期長期借款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2273', '21', '一年或一營業週期內到期長期應付票據及款項', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2277', '21', '一年或一營業週期內到期長期應付票據及款項—關係人', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2278', '21', '其他一年或一營業週期內到期長期負債', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2281', '21', '銷項稅額', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2283', '21', '暫收款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2284', '21', '代收款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2285', '21', '估計售後服務/保固負債', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2291', '21', '遞延所得稅負債', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2292', '21', '遞延兌換利益', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2293', '21', '業主(股東)往來', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2294', '21', '同業往來', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2298', '21', '其他流動負債—其他', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2311', '23', '應付公司債', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2319', '23', '應付公司債溢(折)價', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2321', '23', '長期銀行借款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2324', '23', '長期借款 —業主', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2325', '23', '長期借款 —員工', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2327', '23', '長期借款 —關係人', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2328', '23', '長期借款 —其他', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2331', '23', '長期應付票據', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2332', '23', '長期應付帳款', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2333', '23', '長期應付租賃負債', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2337', '23', '長期應付票據及款項 —關係人', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2338', '23', '其他長期應付款項', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2341', '23', '估計應付土地增值稅', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2351', '23', '應計退休金負債', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2388', '23', '其他長期負債—其他', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2811', '28', '遞延收入', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2814', '28', '遞延所得稅負債', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2818', '28', '其他遞延負債', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2861', '28', '存入保證金', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('2888', '28', '雜項負債 —其他', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3111', '31', '普通股股本', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3112', '31', '特別股股本', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3113', '31', '預收股本', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3114', '31', '待分配股票股利', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3115', '31', '資本', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3211', '32', '普通股股票溢價', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3212', '32', '特別股股票溢價', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3231', '32', '資產重估增值準備', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3241', '32', '處分資產溢價公積', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3251', '32', '合併公積', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3261', '32', '受贈公積', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3281', '32', '權益法長期股權投資資本公積', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3282', '32', '資本公積— 庫藏股票交易', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3311', '33', '法定盈餘公積', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3321', '33', '意外損失準備', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3322', '33', '改良擴充準備', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3323', '33', '償債準備', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3328', '33', '其他特別盈餘公積', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3351', '33', '累積盈虧', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3352', '33', '前期損益調整', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3353', '33', '本期損益', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3411', '34', '長期股權投資未實現跌價損失', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3421', '34', '累積換算調整數', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3431', '34', '未認列為退休金成本之淨損失', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3511', '35', '庫藏股', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('3611', '36', '少數股權', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('4111', '41', '銷貨收入', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('4112', '41', '分期付款銷貨收入', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('4171', '41', '銷貨退回', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('4191', '41', '銷貨折讓', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('4611', '46', '勞務收入', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('4711', '47', '業務收入', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('4888', '48', '其他營業收入—其他', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5111', '51', '銷貨成本', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5112', '51', '分期付款銷貨成本', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5121', '51', '進貨', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5122', '51', '進貨費用', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5123', '51', '進貨退出', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5124', '51', '進貨折讓', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5131', '51', '進料', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5132', '51', '進料費用', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5133', '51', '進料退出', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5134', '51', '進料折讓', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5141', '51', '直接人工', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5151', '51', '間接人工', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5152', '51', '租金支出', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5153', '51', '文具用品', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5154', '51', '旅費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5155', '51', '運費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5156', '51', '郵電費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5157', '51', '修繕費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5158', '51', '包裝費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5161', '51', '水電瓦斯費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5162', '51', '保險費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5163', '51', '加工費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5166', '51', '稅捐', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5168', '51', '折舊', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5169', '51', '各項耗竭及攤提', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5172', '51', '伙食費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5173', '51', '職工福利', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5176', '51', '訓練費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5177', '51', '間接材料', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5188', '51', '其他製造費用', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5611', '56', '勞務成本', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5711', '57', '業務成本', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('5888', '58', '其他營業成本—其他', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6151', '61', '薪資支出', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6152', '61', '租金支出', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6153', '61', '文具用品', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6154', '61', '旅費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6155', '61', '運費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6156', '61', '郵電費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6157', '61', '修繕費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6159', '61', '廣告費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6161', '61', '水電瓦斯費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6162', '61', '保險費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6164', '61', '交際費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6165', '61', '捐贈', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6166', '61', '稅捐', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6167', '61', '呆帳損失', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6168', '61', '折舊', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6169', '61', '各項耗竭及攤提', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6172', '61', '伙食費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6173', '61', '職工福利', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6175', '61', '佣金支出', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6176', '61', '訓練費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6188', '61', '其他推銷費用', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6251', '62', '薪資支出', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6252', '62', '租金支出', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6253', '62', '文具用品', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6254', '62', '旅費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6255', '62', '運費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6256', '62', '郵電費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6257', '62', '修繕費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6259', '62', '廣告費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6261', '62', '水電瓦斯費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6262', '62', '保險費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6264', '62', '交際費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6265', '62', '捐贈', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6266', '62', '稅捐', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6267', '62', '呆帳損失', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6268', '62', '折舊', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6269', '62', '各項耗竭及攤提', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6271', '62', '外銷損失', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6272', '62', '伙食費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6273', '62', '職工福利', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6274', '62', '研究發展費用', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6275', '62', '佣金支出', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6276', '62', '訓練費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6278', '62', '勞務費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6288', '62', '其他管理及總務費用', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6351', '63', '薪資支出', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6352', '63', '租金支出', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6353', '63', '文具用品', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6354', '63', '旅費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6355', '63', '運費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6356', '63', '郵電費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6357', '63', '修繕費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6361', '63', '水電瓦斯費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6362', '63', '保險費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6364', '63', '交際費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6366', '63', '稅捐', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6368', '63', '折舊', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6369', '63', '各項耗竭及攤提', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6372', '63', '伙食費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6373', '63', '職工福利', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6376', '63', '訓練費', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('6378', '63', '其他研究發展費用', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7111', '71', '利息收入', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7121', '71', '權益法認列之投資收益', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7122', '71', '股利收入', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7123', '71', '短期投資市價回升利益', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7131', '71', '兌換利益', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7141', '71', '處分投資收益', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7151', '71', '處分資產溢價收入', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7481', '71', '捐贈收入', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7482', '71', '租金收入', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7483', '71', '佣金收入', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7484', '71', '出售下腳及廢料收入', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7485', '71', '存貨盤盈', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7486', '71', '存貨跌價回升利益', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7487', '71', '壞帳轉回利益', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7488', '71', '其他營業外收入—其他', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7511', '75', '利息費用', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7521', '75', '權益法認列之投資損失', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7523', '75', '短期投資未實現跌價損失', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7531', '75', '兌換損失', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7541', '75', '處分投資損失', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7551', '75', '處分資產損失', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7881', '75', '停工損失', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7882', '75', '災害損失', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7885', '75', '存貨盤損', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7886', '75', '存貨跌價及呆滯損失', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('7888', '75', '其他營業外費用—其他', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('8111', '81', '所得稅費用（或利益）', 'f', 'f', NULL, NULL);
INSERT INTO "public"."tbl_acnt_account" VALUES ('1111', '11', '庫存現金', 'f', 'f', NULL, NULL);

/*==============================================================*/
/* Table: TBL_ACNT_INIT                                         */
/*==============================================================*/
create table TBL_ACNT_INIT (
   INI_YEAR             VARCHAR(20)          not null,
   ACT_NO               VARCHAR(20)          not null,
   INI_AMOUNT           NUMERIC(18,4)        not null,
   constraint PK_TBL_ACNT_INIT primary key (INI_YEAR, ACT_NO),
   constraint FK_TBL_ACNT_REF_2107_TBL_ACNT foreign key (ACT_NO)
      references TBL_ACNT_ACCOUNT (ACT_NO)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Table: TBL_ACNT_JOURNAL                                      */
/*==============================================================*/
create table TBL_ACNT_JOURNAL (
   JNL_NO               VARCHAR(20)          not null,
   JNL_DATE             TIMESTAMP            null,
   JNL_DESC             VARCHAR(200)         null,
   JNL_BILL_TYPE        INT4                 not null,
   JNL_CREATOR          VARCHAR(20)          null,
   constraint PK_TBL_ACNT_JOURNAL primary key (JNL_NO)
);

comment on column TBL_ACNT_JOURNAL.JNL_BILL_TYPE is
'0 = 一般單據
1 = 庫存系統傳輸單據
2 = 年度結轉系統自動產生單據';

/*==============================================================*/
/* Table: TBL_ACNT_JOURNAL_DT                                   */
/*==============================================================*/
create table TBL_ACNT_JOURNAL_DT (
   JNL_NO               VARCHAR(20)          not null,
   JND_SEQNO            INT4                 not null,
   ACT_NO               VARCHAR(20)          not null,
   JND_AMOUNT           NUMERIC(18,4)        not null,
   JND_DESC             VARCHAR(200)         null,
   constraint PK_TBL_ACNT_JOURNAL_DT primary key (JNL_NO, JND_SEQNO),
   constraint FK_TBL_ACNT_REF_2104_TBL_ACNT foreign key (ACT_NO)
      references TBL_ACNT_ACCOUNT (ACT_NO)
      on delete restrict on update restrict,
   constraint FK_TBL_ACNT_REF_2113_TBL_ACNT foreign key (JNL_NO)
      references TBL_ACNT_JOURNAL (JNL_NO)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Table: TBL_SUPPLIER                                          */
/*==============================================================*/
create table TBL_SUPPLIER (
   SUP_NO               VARCHAR(20)          not null,
   SUP_NAME             VARCHAR(80)          not null,
   SUP_PRESIDENT        VARCHAR(20)          null,
   SUP_CONTANT          VARCHAR(20)          null,
   SUP_CONT_TITLE       VARCHAR(20)          null,
   SUP_TEL1             VARCHAR(30)          null,
   SUP_TEL2             VARCHAR(30)          null,
   SUP_FAX              VARCHAR(30)          null,
   SUP_UNIFORM_NO       VARCHAR(20)          null,
   SUP_INV_ADDR         VARCHAR(200)         null,
   SUP_ADDR             VARCHAR(200)         null,
   SUP_ZIP_CODE         VARCHAR(6)           null,
   SUP_ADVANCE_AMOUNT   NUMERIC(18,4)        not null,
   SUP_DESC             VARCHAR(200)         null,
   SUP_CREATOR          VARCHAR(20)          null,
   SUP_ACNT_AP          VARCHAR(20)          not null default '2141',
   SUP_ACNT_ADVANCE     VARCHAR(20)          not null default '1261',
   constraint PK_TBL_SUPPLIER primary key (SUP_NO)
);

comment on table TBL_SUPPLIER is
'供應商主檔';

/*==============================================================*/
/* Table: TBL_AP_PAY                                            */
/*==============================================================*/
create table TBL_AP_PAY (
   PAY_NO               VARCHAR(20)          not null,
   SUP_NO               VARCHAR(20)          not null,
   JNL_NO               VARCHAR(20)          null,
   PAY_DATE             TIMESTAMP            not null,
   PAY_CASH             NUMERIC(18,4)        not null,
   PAY_CHECK            NUMERIC(18,4)        not null,
   PAY_FROM_ADVANCE     NUMERIC(18,4)        not null,
   PAY_TO_ADVANCE       NUMERIC(18,4)        not null,
   PAY_DESC             VARCHAR(200)         null,
   PAY_CREATOR          VARCHAR(20)          null,
   PAY_TR_FLAG          BOOL                 not null default false,
   constraint PK_TBL_AP_PAY primary key (PAY_NO),
   constraint FK_TBL_AP_P_REF_SUP_P_TBL_SUPP foreign key (SUP_NO)
      references TBL_SUPPLIER (SUP_NO)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: REF_SUP_PAY_PK                                        */
/*==============================================================*/
create  index REF_SUP_PAY_PK on TBL_AP_PAY (
SUP_NO
);

/*==============================================================*/
/* Table: TBL_PO_RECV                                           */
/*==============================================================*/
create table TBL_PO_RECV (
   RCV_NO               VARCHAR(20)          not null,
   SUP_NO               VARCHAR(20)          not null,
   JNL_NO               VARCHAR(20)          null,
   RCV_STATUS           INT4                 not null,
   RCV_DATE             TIMESTAMP            not null,
   RCV_INV_NO           VARCHAR(20)          null,
   RCV_TOTAL            NUMERIC(18,4)        not null,
   RCV_TAX              NUMERIC(18,4)        not null,
   RCV_NOT_CLEAN        NUMERIC(18,4)        not null,
   RCV_DESC             VARCHAR(200)         null,
   RCV_CREATOR          VARCHAR(20)          null,
   RCV_TR_FLAG          BOOL                 not null default false,
   constraint PK_TBL_PO_RECV primary key (RCV_NO),
   constraint FK_TBL_PO_R_REF_SUP_R_TBL_SUPP foreign key (SUP_NO)
      references TBL_SUPPLIER (SUP_NO)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Table: TBL_AP_PAY_DT                                         */
/*==============================================================*/
create table TBL_AP_PAY_DT (
   PAY_NO               VARCHAR(20)          not null,
   PAD_SEQNO            INT4                 not null,
   RCV_NO               VARCHAR(20)          not null,
   PAD_AMOUNT           NUMERIC(18,4)        not null,
   PAD_DISCOUNT         NUMERIC(18,4)        not null,
   constraint PK_TBL_AP_PAY_DT primary key (PAY_NO, PAD_SEQNO),
   constraint FK_TBL_AP_P_REF_2323_TBL_PO_R foreign key (RCV_NO)
      references TBL_PO_RECV (RCV_NO)
      on delete restrict on update restrict,
   constraint FK_TBL_AP_P_REF_2340_TBL_AP_P foreign key (PAY_NO)
      references TBL_AP_PAY (PAY_NO)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: REF_2323_PK                                           */
/*==============================================================*/
create  index REF_2323_PK on TBL_AP_PAY_DT (
RCV_NO
);

/*==============================================================*/
/* Index: REF_2340_PK                                           */
/*==============================================================*/
create  index REF_2340_PK on TBL_AP_PAY_DT (
PAY_NO
);

/*==============================================================*/
/* Table: TBL_CUSTOMER                                          */
/*==============================================================*/
create table TBL_CUSTOMER (
   CUM_NO               VARCHAR(20)          not null,
   CUM_NAME             VARCHAR(80)          not null,
   CUM_PRESIDENT        VARCHAR(20)          null,
   CUM_CONTANT          VARCHAR(20)          null,
   CUM_CONT_TITLE       VARCHAR(20)          null,
   CUM_TEL1             VARCHAR(30)          null,
   CUM_TEL2             VARCHAR(30)          null,
   CUM_FAX              VARCHAR(30)          null,
   CUM_UNIFORM_NO       VARCHAR(20)          null,
   CUM_INV_ADDR         VARCHAR(200)         null,
   CUM_ADDR             VARCHAR(200)         null,
   CUM_ZIP_CODE         VARCHAR(6)           null,
   CUM_ADVANCE_AMOUNT   NUMERIC(18,4)        not null,
   CUM_DESC             VARCHAR(200)         null,
   CUM_CREATOR          VARCHAR(20)          null,
   CUM_ACNT_AR          VARCHAR(20)          not null default '1141',
   CUM_ACNT_ADVANCE     VARCHAR(20)          not null default '2261',
   CUM_INV_RATE         NUMERIC(18,4)        not null default 0,
   constraint PK_TBL_CUSTOMER primary key (CUM_NO)
);

comment on table TBL_CUSTOMER is
'客戶主檔';

/*==============================================================*/
/* Table: TBL_AR_RECV                                           */
/*==============================================================*/
create table TBL_AR_RECV (
   ARR_NO               VARCHAR(20)          not null,
   CUM_NO               VARCHAR(20)          not null,
   JNL_NO               VARCHAR(20)          null,
   ARR_DATE             TIMESTAMP            not null,
   ARR_CASH             NUMERIC(18,4)        not null,
   ARR_CHECK            NUMERIC(18,4)        not null,
   ARR_FROM_ADVANCE     NUMERIC(18,4)        not null,
   ARR_TO_ADVANCE       NUMERIC(18,4)        not null,
   ARR_DESC             VARCHAR(200)         null,
   ARR_CREATOR          VARCHAR(20)          null,
   ARR_TR_FLAG          BOOL                 not null default false,
   constraint PK_TBL_AR_RECV primary key (ARR_NO),
   constraint FK_TBL_AR_R_REF_CUM_R_TBL_CUST foreign key (CUM_NO)
      references TBL_CUSTOMER (CUM_NO)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: REF_CUM_RCV_PK                                        */
/*==============================================================*/
create  index REF_CUM_RCV_PK on TBL_AR_RECV (
CUM_NO
);

/*==============================================================*/
/* Table: TBL_EMPLOYE                                           */
/*==============================================================*/
create table TBL_EMPLOYE (
   EPY_NO               VARCHAR(20)          not null,
   EPY_NAME             VARCHAR(20)          not null,
   EPY_PASSWORD         VARCHAR(20)          null,
   EPY_TEL1             VARCHAR(30)          null,
   EPY_TEL2             VARCHAR(30)          null,
   EPY_ADDR             VARCHAR(200)         null,
   EPY_IS_CAN_LOGIN     BOOL                 not null default TRUE,
   EPY_DESC             VARCHAR(200)         null,
   EPY_CREATOR          VARCHAR(20)          null,
   constraint PK_TBL_EMPLOYE primary key (EPY_NO)
);

INSERT INTO TBL_EMPLOYE(EPY_NO, EPY_NAME
, EPY_DESC, EPY_CREATOR)
VALUES('WYS','ADMINISTRATOR','SYSTEM ADMINISTRATOR','DEFAULT');

/*==============================================================*/
/* Table: TBL_CAR                                               */
/*==============================================================*/
create table TBL_CAR (
   CAR_NO               VARCHAR(20)          not null,
   CAR_BRAND            VARCHAR(80)          null,
   CAR_LICENSE_NO       VARCHAR(80)          null,
   CAR_DATE1            TIMESTAMP            null,
   CAR_CREATOR          VARCHAR(20)          null,
   CAR_DESC             VARCHAR(200)         null,
   constraint PK_TBL_CAR primary key (CAR_NO)
);

/*==============================================================*/
/* Table: TBL_SHIP                                              */
/*==============================================================*/
create table TBL_SHIP (
   SMT_NO               VARCHAR(20)          not null,
   CUM_NO               VARCHAR(20)          not null,
   EPY_NO               VARCHAR(20)          not null,
   CAR_NO               VARCHAR(20)          null,
   JNL_NO               VARCHAR(20)          null,
   SMT_STATUS           INT4                 not null,
   SMT_INV_NO           VARCHAR(20)          null,
   SMT_DATE             TIMESTAMP            not null,
   SMT_DESTINATION      VARCHAR(200)         null,
   SMT_TOTAL            NUMERIC(18,4)        not null,
   SMT_TAX              NUMERIC(18,4)        not null,
   SMT_NOT_CLEAN        NUMERIC(18,4)        not null,
   SMT_COST             NUMERIC(18,4)        not null,
   SMT_DELIVER1         VARCHAR(20)          null,
   SMT_DELIVER2         VARCHAR(20)          null,
   SMT_DESC             VARCHAR(200)         null,
   SMT_CREATOR          VARCHAR(20)          null,
   SMT_TR_FLAG          BOOL                 not null default false,
   constraint PK_TBL_SHIP primary key (SMT_NO),
   constraint FK_TBL_SHIP_REF_CUM_S_TBL_CUST foreign key (CUM_NO)
      references TBL_CUSTOMER (CUM_NO)
      on delete restrict on update restrict,
   constraint FK_TBL_SHIP_REF_2311_TBL_EMPL foreign key (EPY_NO)
      references TBL_EMPLOYE (EPY_NO)
      on delete restrict on update restrict,
   constraint FK_TBL_SHIP_REF_4731_TBL_CAR foreign key (CAR_NO)
      references TBL_CAR (CAR_NO)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Table: TBL_AR_RECV_DT                                        */
/*==============================================================*/
create table TBL_AR_RECV_DT (
   ARR_NO               VARCHAR(20)          not null,
   ARD_SEQNO            INT4                 not null,
   SMT_NO               VARCHAR(20)          not null,
   ARD_AMOUNT           NUMERIC(18,4)        not null,
   ARD_DISCOUNT         NUMERIC(18,4)        not null,
   constraint PK_TBL_AR_RECV_DT primary key (ARR_NO, ARD_SEQNO),
   constraint FK_TBL_AR_R_REF_2317_TBL_SHIP foreign key (SMT_NO)
      references TBL_SHIP (SMT_NO)
      on delete restrict on update restrict,
   constraint FK_TBL_AR_R_REF_2337_TBL_AR_R foreign key (ARR_NO)
      references TBL_AR_RECV (ARR_NO)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: REF_2317_PK                                           */
/*==============================================================*/
create  index REF_2317_PK on TBL_AR_RECV_DT (
SMT_NO
);

/*==============================================================*/
/* Index: REF_2337_PK                                           */
/*==============================================================*/
create  index REF_2337_PK on TBL_AR_RECV_DT (
ARR_NO
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

/*==============================================================*/
/* Table: TBL_HIS_PO_RECV                                       */
/*==============================================================*/
create table TBL_HIS_PO_RECV (
   HRCV_NO              VARCHAR(20)          not null,
   SUP_NO               VARCHAR(20)          not null,
   HRCV_DATE            TIMESTAMP            not null,
   HRCV_INV_NO          VARCHAR(20)          null,
   HRCV_TOTAL           NUMERIC(18,4)        not null,
   HRCV_TAX             NUMERIC(18,4)        not null,
   HRCV_DESC            VARCHAR(200)         null,
   HRCV_CREATOR         VARCHAR(20)          null,
   constraint PK_TBL_HIS_PO_RECV primary key (HRCV_NO),
   constraint FK_TBL_HIS__REF_5400_TBL_SUPP foreign key (SUP_NO)
      references TBL_SUPPLIER (SUP_NO)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: REF_5400_PK                                           */
/*==============================================================*/
create  index REF_5400_PK on TBL_HIS_PO_RECV (
SUP_NO
);

/*==============================================================*/
/* Table: TBL_PRODUCT                                           */
/*==============================================================*/
create table TBL_PRODUCT (
   PRD_NO               VARCHAR(20)          not null,
   PRD_NAME             VARCHAR(80)          not null,
   PRD_UNIT             VARCHAR(6)           null,
   PRD_SALE_PRICE       NUMERIC(18,4)        not null,
   PRD_SAFE_QTY         NUMERIC(18,4)        not null,
   PRD_ONHAND           NUMERIC(18,4)        not null,
   PRD_CUR_COST         NUMERIC(18,4)        not null,
   PRD_DESC             VARCHAR(200)         null,
   PRD_IS_DUMMY         BOOL                 not null default FALSE,
   PRD_DUM_COST_RATE    NUMERIC(18,4)        not null,
   PRD_EXT_COST_RATIO   NUMERIC(18,4)        not null,
   PRD_CREATOR          VARCHAR(20)          null,
   constraint PK_TBL_PRODUCT primary key (PRD_NO)
);

comment on table TBL_PRODUCT is
'產品主檔';

/*==============================================================*/
/* Table: TBL_INVENTORY                                         */
/*==============================================================*/
create table TBL_INVENTORY (
   INV_NO               VARCHAR(20)          not null,
   INV_NAME             VARCHAR(80)          not null,
   INV_DESC             VARCHAR(200)         null,
   INV_CREATOR          VARCHAR(20)          null,
   constraint PK_TBL_INVENTORY primary key (INV_NO)
);

INSERT INTO TBL_INVENTORY(INV_NO, INV_NAME, INV_DESC, INV_CREATOR)
VALUES('DEFAULT','Default Inventory','System Default','系統自動產生');

/*==============================================================*/
/* Table: TBL_HIS_PO_RECV_DT                                    */
/*==============================================================*/
create table TBL_HIS_PO_RECV_DT (
   HRCV_NO              VARCHAR(20)          not null,
   HRCD_SEQNO           INT4                 not null,
   PRD_NO               VARCHAR(20)          not null,
   INV_NO               VARCHAR(20)          not null,
   HRCD_PRD_NAME        VARCHAR(80)          null,
   HRCD_QTY             NUMERIC(18,4)        not null,
   HRCD_UNIT_PRICE      NUMERIC(18,4)        not null,
   constraint PK_TBL_HIS_PO_RECV_DT primary key (HRCV_NO, HRCD_SEQNO),
   constraint FK_TBL_HIS__REF_5380_TBL_HIS_ foreign key (HRCV_NO)
      references TBL_HIS_PO_RECV (HRCV_NO)
      on delete restrict on update restrict,
   constraint FK_TBL_HIS__REF_5404_TBL_PROD foreign key (PRD_NO)
      references TBL_PRODUCT (PRD_NO)
      on delete restrict on update restrict,
   constraint FK_TBL_HIS__REF_5520_TBL_INVE foreign key (INV_NO)
      references TBL_INVENTORY (INV_NO)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: REF_5380_PK                                           */
/*==============================================================*/
create  index REF_5380_PK on TBL_HIS_PO_RECV_DT (
HRCV_NO
);

/*==============================================================*/
/* Index: REF_5404_PK                                           */
/*==============================================================*/
create  index REF_5404_PK on TBL_HIS_PO_RECV_DT (
PRD_NO
);

/*==============================================================*/
/* Table: TBL_HIS_SHIP                                          */
/*==============================================================*/
create table TBL_HIS_SHIP (
   HSMT_NO              VARCHAR(20)          not null,
   CUM_NO               VARCHAR(20)          not null,
   EPY_NO               VARCHAR(20)          not null,
   HSMT_INV_NO          VARCHAR(20)          null,
   HSMT_DATE            TIMESTAMP            not null,
   HSMT_DESTINATION     VARCHAR(200)         null,
   HSMT_TOTAL           NUMERIC(18,4)        not null,
   HSMT_TAX             NUMERIC(18,4)        not null,
   HSMT_COST            NUMERIC(18,4)        not null,
   HSMT_DESC            VARCHAR(200)         null,
   HSMT_CREATOR         VARCHAR(20)          null,
   constraint PK_TBL_HIS_SHIP primary key (HSMT_NO),
   constraint FK_TBL_HIS__REF_5388_TBL_CUST foreign key (CUM_NO)
      references TBL_CUSTOMER (CUM_NO)
      on delete restrict on update restrict,
   constraint FK_TBL_HIS__REF_5392_TBL_EMPL foreign key (EPY_NO)
      references TBL_EMPLOYE (EPY_NO)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: REF_5388_PK                                           */
/*==============================================================*/
create  index REF_5388_PK on TBL_HIS_SHIP (
CUM_NO
);

/*==============================================================*/
/* Index: REF_5392_PK                                           */
/*==============================================================*/
create  index REF_5392_PK on TBL_HIS_SHIP (
EPY_NO
);

/*==============================================================*/
/* Table: TBL_HIS_SHIP_DT                                       */
/*==============================================================*/
create table TBL_HIS_SHIP_DT (
   HSMT_NO              VARCHAR(20)          not null,
   HSMD_SEQNO           INT4                 not null,
   PRD_NO               VARCHAR(20)          not null,
   INV_NO               VARCHAR(20)          not null,
   HSMD_PRD_NAME        VARCHAR(80)          null,
   HSMD_UNIT_PRICE      NUMERIC(18,4)        not null,
   HSMD_QTY             NUMERIC(18,4)        not null,
   HSMD_COST            NUMERIC(18,4)        not null,
   constraint PK_TBL_HIS_SHIP_DT primary key (HSMT_NO, HSMD_SEQNO),
   constraint FK_TBL_HIS__REF_5376_TBL_HIS_ foreign key (HSMT_NO)
      references TBL_HIS_SHIP (HSMT_NO)
      on delete restrict on update restrict,
   constraint FK_TBL_HIS__REF_5396_TBL_PROD foreign key (PRD_NO)
      references TBL_PRODUCT (PRD_NO)
      on delete restrict on update restrict,
   constraint FK_TBL_HIS__REF_5516_TBL_INVE foreign key (INV_NO)
      references TBL_INVENTORY (INV_NO)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: REF_5376_PK                                           */
/*==============================================================*/
create  index REF_5376_PK on TBL_HIS_SHIP_DT (
HSMT_NO
);

/*==============================================================*/
/* Index: REF_5396_PK                                           */
/*==============================================================*/
create  index REF_5396_PK on TBL_HIS_SHIP_DT (
PRD_NO
);

/*==============================================================*/
/* Table: TBL_INV_ADJ                                           */
/*==============================================================*/
create table TBL_INV_ADJ (
   ADJ_NO               VARCHAR(20)          not null,
   ADJ_STATUS           INT4                 not null,
   ADJ_DATE             TIMESTAMP            not null,
   ADJ_DESC             VARCHAR(200)         null,
   ADJ_CREATOR          VARCHAR(20)          null,
   ADJ_TR_FLAG          BOOL                 not null default false,
   constraint PK_TBL_INV_ADJ primary key (ADJ_NO)
);

/*==============================================================*/
/* Table: TBL_INV_ADJ_DT                                        */
/*==============================================================*/
create table TBL_INV_ADJ_DT (
   ADJ_NO               VARCHAR(20)          not null,
   ADD_SEQNO            INT4                 not null,
   PRD_NO               VARCHAR(20)          not null,
   ADD_QTY              NUMERIC(18,4)        not null,
   ADD_COST             NUMERIC(18,4)        not null,
   INV_NO               VARCHAR(20)          not null,
   constraint PK_TBL_INV_ADJ_DT primary key (ADJ_NO, ADD_SEQNO),
   constraint FK_TBL_INV__REF_2343_TBL_INV_ foreign key (ADJ_NO)
      references TBL_INV_ADJ (ADJ_NO)
      on delete restrict on update restrict,
   constraint FK_TBL_INV__REF_PRD_A_TBL_PROD foreign key (PRD_NO)
      references TBL_PRODUCT (PRD_NO)
      on delete restrict on update restrict,
   constraint FK_TBL_INV__REF_6272_TBL_INVE foreign key (INV_NO)
      references TBL_INVENTORY (INV_NO)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: REF_2343_PK                                           */
/*==============================================================*/
create  index REF_2343_PK on TBL_INV_ADJ_DT (
ADJ_NO
);

/*==============================================================*/
/* Index: REF_PRD_ADD_PK                                        */
/*==============================================================*/
create  index REF_PRD_ADD_PK on TBL_INV_ADJ_DT (
PRD_NO
);

/*==============================================================*/
/* Table: TBL_INV_ONHAND                                        */
/*==============================================================*/
create table TBL_INV_ONHAND (
   INV_NO               VARCHAR(20)          not null,
   PRD_NO               VARCHAR(20)          not null,
   IOH_QTY              NUMERIC(18,4)        not null,
   constraint PK_TBL_INV_ONHAND primary key (INV_NO, PRD_NO),
   constraint FK_TBL_INV__REF_INV_I_TBL_INVE foreign key (INV_NO)
      references TBL_INVENTORY (INV_NO)
      on delete restrict on update restrict,
   constraint FK_TBL_INV__REF_4575_TBL_PROD foreign key (PRD_NO)
      references TBL_PRODUCT (PRD_NO)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: REF_INV_IOH_PK                                        */
/*==============================================================*/
create  index REF_INV_IOH_PK on TBL_INV_ONHAND (
INV_NO
);

/*==============================================================*/
/* Index: REF_4575_PK                                           */
/*==============================================================*/
create  index REF_4575_PK on TBL_INV_ONHAND (
PRD_NO
);

/*==============================================================*/
/* Index: REF_SUP_RCV_PK                                        */
/*==============================================================*/
create  index REF_SUP_RCV_PK on TBL_PO_RECV (
SUP_NO
);

/*==============================================================*/
/* Table: TBL_PO_RECV_DT                                        */
/*==============================================================*/
create table TBL_PO_RECV_DT (
   RCV_NO               VARCHAR(20)          not null,
   RCD_SEQNO            INT4                 not null,
   PRD_NO               VARCHAR(20)          not null,
   INV_NO               VARCHAR(20)          not null,
   RCD_PRD_NAME         VARCHAR(80)          null,
   RCD_QTY              NUMERIC(18,4)        not null,
   RCD_UNIT_PRICE       NUMERIC(18,4)        not null,
   constraint PK_TBL_PO_RECV_DT primary key (RCV_NO, RCD_SEQNO),
   constraint FK_TBL_PO_R_REF_PRD_R_TBL_PROD foreign key (PRD_NO)
      references TBL_PRODUCT (PRD_NO)
      on delete restrict on update restrict,
   constraint FK_TBL_PO_R_REF_2320_TBL_PO_R foreign key (RCV_NO)
      references TBL_PO_RECV (RCV_NO)
      on delete restrict on update restrict,
   constraint FK_TBL_PO_R_REF_INV_R_TBL_INVE foreign key (INV_NO)
      references TBL_INVENTORY (INV_NO)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: REF_PRD_RCD_PK                                        */
/*==============================================================*/
create  index REF_PRD_RCD_PK on TBL_PO_RECV_DT (
PRD_NO
);

/*==============================================================*/
/* Index: REF_2320_PK                                           */
/*==============================================================*/
create  index REF_2320_PK on TBL_PO_RECV_DT (
RCV_NO
);

/*==============================================================*/
/* Index: REF_INV_RCD_PK                                        */
/*==============================================================*/
create  index REF_INV_RCD_PK on TBL_PO_RECV_DT (
INV_NO
);

/*==============================================================*/
/* Index: REF_CUM_SMT_PK                                        */
/*==============================================================*/
create  index REF_CUM_SMT_PK on TBL_SHIP (
CUM_NO
);

/*==============================================================*/
/* Index: REF_2311_PK                                           */
/*==============================================================*/
create  index REF_2311_PK on TBL_SHIP (
EPY_NO
);

/*==============================================================*/
/* Table: TBL_SHIP_DT                                           */
/*==============================================================*/
create table TBL_SHIP_DT (
   SMT_NO               VARCHAR(20)          not null,
   SMD_SEQNO            INT4                 not null,
   PRD_NO               VARCHAR(20)          not null,
   INV_NO               VARCHAR(20)          not null,
   SMD_PRD_NAME         VARCHAR(80)          null,
   SMD_UNIT_PRICE       NUMERIC(18,4)        not null,
   SMD_QTY              NUMERIC(18,4)        not null,
   SMD_COST             NUMERIC(18,4)        not null,
   constraint PK_TBL_SHIP_DT primary key (SMT_NO, SMD_SEQNO),
   constraint FK_TBL_SHIP_REF_PRD_S_TBL_PROD foreign key (PRD_NO)
      references TBL_PRODUCT (PRD_NO)
      on delete restrict on update restrict,
   constraint FK_TBL_SHIP_REF_2314_TBL_SHIP foreign key (SMT_NO)
      references TBL_SHIP (SMT_NO)
      on delete restrict on update restrict,
   constraint FK_TBL_SHIP_REF_INV_S_TBL_INVE foreign key (INV_NO)
      references TBL_INVENTORY (INV_NO)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: REF_PRD_SMD_PK                                        */
/*==============================================================*/
create  index REF_PRD_SMD_PK on TBL_SHIP_DT (
PRD_NO
);

/*==============================================================*/
/* Index: REF_2314_PK                                           */
/*==============================================================*/
create  index REF_2314_PK on TBL_SHIP_DT (
SMT_NO
);

/*==============================================================*/
/* Index: REF_INV_SMD_PK                                        */
/*==============================================================*/
create  index REF_INV_SMD_PK on TBL_SHIP_DT (
INV_NO
);

/*==============================================================*/
/* Table: TBL_SYS_PARAM                                         */
/*==============================================================*/
create table TBL_SYS_PARAM (
   SPR_PERIOD_START     TIMESTAMP            not null,
   SPR_COR_NAME         VARCHAR(80)          null,
   SPR_TEL              VARCHAR(30)          null,
   SPR_FAX              VARCHAR(30)          null,
   SPR_ADDR             VARCHAR(200)         null,
   SPR_TAX_RATE         NUMERIC(18,4)        not null,
   SPR_QTY_DECIMAL      INT4                 null,
   SPR_AMOUNT_UNIT_DOT  INT4                 null,
   SPR_AMOUNT_DOT       INT4                 null,
   SPR_BKUP_CMD         VARCHAR(250)         null,
   SPR_BKUP_PARA        VARCHAR(250)         null,
   SPR_BKUP_PATH        VARCHAR(250)         null,
   SPR_PRD_COST_RATE    NUMERIC(18,4)        not null default 0.05,
   SPR_BONUS_SALE_RATE  NUMERIC(18,4)        not null default 0.01,
   SPR_BONUS_PROFIT_RATE NUMERIC(18,4)        not null default 0.15,
   SPR_ACNT_YEAR        INT4                 not null default 2025,
   SPR_ACNT_SALE_REVENUE VARCHAR(20)          not null default '4111',
   SPR_ACNT_SALE_RETURN VARCHAR(20)          not null default '4171',
   SPR_ACNT_SALE_DISCOUNT VARCHAR(20)          not null default '4191',
   SPR_ACNT_SALE_TAX    VARCHAR(20)          null default '2281',
   SPR_ACNT_PURCHASE    VARCHAR(20)          not null default '5121',
   SPR_ACNT_PUR_DISCOUNT VARCHAR(20)          not null default '5124',
   SPR_ACNT_PUR_RETURN  VARCHAR(20)          not null default '5123',
   SPR_ACNT_PUR_TAX     VARCHAR(20)          null default '1281',
   SPR_ACNT_CASH        VARCHAR(20)          not null default '1111',
   SPR_ACNT_CUS_CHECK   VARCHAR(20)          not null default '1131',
   SPR_ACNT_SUP_CHECK   VARCHAR(20)          not null default '2131',
   constraint PK_TBL_SYS_PARAM primary key (SPR_PERIOD_START)
);

INSERT INTO TBL_SYS_PARAM(SPR_PERIOD_START, SPR_COR_NAME, SPR_TEL, SPR_FAX
, SPR_ADDR, SPR_TAX_RATE
, SPR_QTY_DECIMAL, SPR_AMOUNT_UNIT_DOT, SPR_AMOUNT_DOT
, SPR_BKUP_CMD, SPR_BKUP_PARA, SPR_BKUP_PATH)
VALUES('2000-01-01','ERP DISTRIBUTION','TEL','FAX'
,'ADDR',0.05
,1,2,0
,'WINRAR','A','.');

/*==============================================================*/
/* Table: TBL_TRANSACTION                                       */
/*==============================================================*/
create table TBL_TRANSACTION (
   TRN_ID               SERIAL               not null,
   PRD_NO               VARCHAR(20)          not null,
   INV_NO               VARCHAR(20)          not null,
   TRN_TYPE             INT4                 not null,
   TRN_SRC_NO           VARCHAR(20)          null,
   TRN_SRC_SEQNO        INT4                 null,
   TRN_DATETIME         TIMESTAMP            not null,
   TRN_QTY              NUMERIC(18,4)        not null,
   TRN_COST             NUMERIC(18,4)        not null,
   TRN_ONHAND           NUMERIC(18,4)        not null,
   TRN_AVG_COST         NUMERIC(18,4)        not null,
   constraint PK_TBL_TRANSACTION primary key (TRN_ID),
   constraint FK_TBL_TRAN_REF_INV_T_TBL_INVE foreign key (INV_NO)
      references TBL_INVENTORY (INV_NO)
      on delete restrict on update restrict,
   constraint FK_TBL_TRAN_REF_PRD_T_TBL_PROD foreign key (PRD_NO)
      references TBL_PRODUCT (PRD_NO)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: REF_INV_TRN_PK                                        */
/*==============================================================*/
create  index REF_INV_TRN_PK on TBL_TRANSACTION (
INV_NO
);

/*==============================================================*/
/* Index: REF_PRD_TRN_PK                                        */
/*==============================================================*/
create  index REF_PRD_TRN_PK on TBL_TRANSACTION (
PRD_NO
);


DROP TABLE IF EXISTS tbl_acnt_type, tbl_acnt_account, tbl_acnt_init, tbl_acnt_journal, tbl_acnt_journal_dt, tbl_supplier, tbl_ap_pay, tbl_po_recv, tbl_ap_pay_dt, tbl_customer, tbl_ar_recv, tbl_car, tbl_employe, tbl_ship, tbl_ar_recv_dt, tbl_fld_for_edit, tbl_his_po_recv, tbl_inventory, tbl_product, tbl_his_po_recv_dt, tbl_his_ship, tbl_his_ship_dt, tbl_inv_adj, tbl_inv_adj_dt, tbl_inv_onhand, tbl_po_recv_dt, tbl_ship_dt, tbl_sys_param, tbl_transaction CASCADE;

CREATE TABLE tbl_acnt_type (
    "typ_no" varchar(20) NOT NULL,
    "typ_name" varchar(80),
    "typ_major_type" varchar(80),
    "type_desc" varchar(200),
    CONSTRAINT pk_tbl_acnt_type PRIMARY KEY ("typ_no")
);

COMMENT ON TABLE tbl_acnt_type IS '科目類別主檔';

COMMENT ON COLUMN tbl_acnt_type."typ_no" IS '類別編號';

COMMENT ON COLUMN tbl_acnt_type."typ_name" IS '類別名稱';

COMMENT ON COLUMN tbl_acnt_type."typ_major_type" IS '主類別名稱';

COMMENT ON COLUMN tbl_acnt_type."type_desc" IS '說明';

CREATE TABLE tbl_acnt_account (
    "act_no" varchar(20) NOT NULL,
    "typ_no" varchar(20) NOT NULL,
    "act_name" varchar(80),
    "act_category_reverse" boolean NOT NULL DEFAULT false,
    "act_category_cash" boolean NOT NULL DEFAULT false,
    "act_creator" varchar(20),
    "act_desc" varchar(200),
    CONSTRAINT pk_tbl_acnt_account PRIMARY KEY ("act_no")
);

COMMENT ON TABLE tbl_acnt_account IS '會計科目主檔';

COMMENT ON COLUMN tbl_acnt_account."act_no" IS '科目編號';

COMMENT ON COLUMN tbl_acnt_account."typ_no" IS '類別編號';

COMMENT ON COLUMN tbl_acnt_account."act_name" IS '科目名稱';

COMMENT ON COLUMN tbl_acnt_account."act_category_reverse" IS '類別_立沖科目';

COMMENT ON COLUMN tbl_acnt_account."act_category_cash" IS '類別_現金流量科目科目';

COMMENT ON COLUMN tbl_acnt_account."act_creator" IS '建檔人員';

COMMENT ON COLUMN tbl_acnt_account."act_desc" IS '說明';

CREATE TABLE tbl_acnt_init (
    "ini_year" varchar(20) NOT NULL,
    "act_no" varchar(20) NOT NULL,
    "ini_amount" numeric(18,4) NOT NULL,
    CONSTRAINT pk_tbl_acnt_init PRIMARY KEY ("ini_year", "act_no")
);

COMMENT ON TABLE tbl_acnt_init IS '科目年度期初值';

COMMENT ON COLUMN tbl_acnt_init."ini_year" IS '西元年度';

COMMENT ON COLUMN tbl_acnt_init."act_no" IS '科目編號';

COMMENT ON COLUMN tbl_acnt_init."ini_amount" IS '期初金額';

CREATE TABLE tbl_acnt_journal (
    "jnl_no" varchar(20) NOT NULL,
    "jnl_date" timestamp,
    "jnl_desc" varchar(200),
    "jnl_bill_type" numeric(18,0) NOT NULL,
    "jnl_creator" varchar(20),
    CONSTRAINT pk_tbl_acnt_journal PRIMARY KEY ("jnl_no")
);

COMMENT ON TABLE tbl_acnt_journal IS '分錄主檔';

COMMENT ON COLUMN tbl_acnt_journal."jnl_no" IS '單據編號';

COMMENT ON COLUMN tbl_acnt_journal."jnl_date" IS '單據日期';

COMMENT ON COLUMN tbl_acnt_journal."jnl_desc" IS '備註';

COMMENT ON COLUMN tbl_acnt_journal."jnl_bill_type" IS '單據類別';

COMMENT ON COLUMN tbl_acnt_journal."jnl_creator" IS '建檔人員';

CREATE TABLE tbl_acnt_journal_dt (
    "jnl_no" varchar(20) NOT NULL,
    "jnd_seqno" numeric(18,0) NOT NULL,
    "act_no" varchar(20) NOT NULL,
    "jnd_amount" numeric(18,4) NOT NULL,
    "jnd_desc" varchar(200),
    CONSTRAINT pk_tbl_acnt_journal_dt PRIMARY KEY ("jnl_no", "jnd_seqno")
);

COMMENT ON TABLE tbl_acnt_journal_dt IS '分錄明細';

COMMENT ON COLUMN tbl_acnt_journal_dt."jnl_no" IS '單據編號';

COMMENT ON COLUMN tbl_acnt_journal_dt."jnd_seqno" IS '單據序號';

COMMENT ON COLUMN tbl_acnt_journal_dt."act_no" IS '科目編號';

COMMENT ON COLUMN tbl_acnt_journal_dt."jnd_amount" IS '金額';

COMMENT ON COLUMN tbl_acnt_journal_dt."jnd_desc" IS '摘要';

CREATE TABLE tbl_supplier (
    "sup_no" varchar(20) NOT NULL,
    "sup_name" varchar(80) NOT NULL,
    "sup_president" varchar(20),
    "sup_contant" varchar(20),
    "sup_cont_title" varchar(20),
    "sup_tel1" varchar(30),
    "sup_tel2" varchar(30),
    "sup_fax" varchar(30),
    "sup_uniform_no" varchar(20),
    "sup_inv_addr" varchar(200),
    "sup_addr" varchar(200),
    "sup_zip_code" varchar(6),
    "sup_advance_amount" numeric(18,4) NOT NULL,
    "sup_desc" varchar(200),
    "sup_creator" varchar(20),
    "sup_acnt_ap" varchar(20) NOT NULL DEFAULT '2141',
    "sup_acnt_advance" varchar(20) NOT NULL DEFAULT '1261',
    CONSTRAINT pk_tbl_supplier PRIMARY KEY ("sup_no")
);

COMMENT ON TABLE tbl_supplier IS '供應商主檔';

COMMENT ON COLUMN tbl_supplier."sup_no" IS '廠商編號';

COMMENT ON COLUMN tbl_supplier."sup_name" IS '廠商名稱';

COMMENT ON COLUMN tbl_supplier."sup_president" IS '負責人';

COMMENT ON COLUMN tbl_supplier."sup_contant" IS '聯絡人';

COMMENT ON COLUMN tbl_supplier."sup_cont_title" IS '聯絡人職稱';

COMMENT ON COLUMN tbl_supplier."sup_tel1" IS '電話1';

COMMENT ON COLUMN tbl_supplier."sup_tel2" IS '電話2';

COMMENT ON COLUMN tbl_supplier."sup_fax" IS '傳真';

COMMENT ON COLUMN tbl_supplier."sup_uniform_no" IS '統一編號';

COMMENT ON COLUMN tbl_supplier."sup_inv_addr" IS '發票地址';

COMMENT ON COLUMN tbl_supplier."sup_addr" IS '公司地址';

COMMENT ON COLUMN tbl_supplier."sup_zip_code" IS '郵遞區號';

COMMENT ON COLUMN tbl_supplier."sup_advance_amount" IS '預付款餘額';

COMMENT ON COLUMN tbl_supplier."sup_desc" IS '說明';

COMMENT ON COLUMN tbl_supplier."sup_creator" IS '建檔人員';

COMMENT ON COLUMN tbl_supplier."sup_acnt_ap" IS '應付帳款科目';

COMMENT ON COLUMN tbl_supplier."sup_acnt_advance" IS '預付款科目';

CREATE TABLE tbl_ap_pay (
    "pay_no" varchar(20) NOT NULL,
    "sup_no" varchar(20) NOT NULL,
    "jnl_no" varchar(20),
    "pay_date" timestamp NOT NULL,
    "pay_cash" numeric(18,4) NOT NULL,
    "pay_check" numeric(18,4) NOT NULL,
    "pay_from_advance" numeric(18,4) NOT NULL,
    "pay_to_advance" numeric(18,4) NOT NULL,
    "pay_desc" varchar(200),
    "pay_creator" varchar(20),
    "pay_tr_flag" boolean NOT NULL DEFAULT false,
    CONSTRAINT pk_tbl_ap_pay PRIMARY KEY ("pay_no")
);

COMMENT ON TABLE tbl_ap_pay IS '付款單主檔';

COMMENT ON COLUMN tbl_ap_pay."pay_no" IS '付款單編號';

COMMENT ON COLUMN tbl_ap_pay."sup_no" IS '廠商編號';

COMMENT ON COLUMN tbl_ap_pay."jnl_no" IS '會計單據編號';

COMMENT ON COLUMN tbl_ap_pay."pay_date" IS '付款單日期';

COMMENT ON COLUMN tbl_ap_pay."pay_cash" IS '付出現金';

COMMENT ON COLUMN tbl_ap_pay."pay_check" IS '付出票據';

COMMENT ON COLUMN tbl_ap_pay."pay_from_advance" IS '取用預付款';

COMMENT ON COLUMN tbl_ap_pay."pay_to_advance" IS '累入預付款';

COMMENT ON COLUMN tbl_ap_pay."pay_desc" IS '說明';

COMMENT ON COLUMN tbl_ap_pay."pay_creator" IS '建檔人員';

COMMENT ON COLUMN tbl_ap_pay."pay_tr_flag" IS '傳輸記錄';

CREATE TABLE tbl_po_recv (
    "rcv_no" varchar(20) NOT NULL,
    "sup_no" varchar(20) NOT NULL,
    "jnl_no" varchar(20),
    "rcv_status" numeric(18,0) NOT NULL,
    "rcv_date" timestamp NOT NULL,
    "rcv_inv_no" varchar(20),
    "rcv_total" numeric(18,4) NOT NULL,
    "rcv_tax" numeric(18,4) NOT NULL,
    "rcv_not_clean" numeric(18,4) NOT NULL,
    "rcv_desc" varchar(200),
    "rcv_creator" varchar(20),
    "rcv_tr_flag" boolean NOT NULL DEFAULT false,
    CONSTRAINT pk_tbl_po_recv PRIMARY KEY ("rcv_no")
);

COMMENT ON TABLE tbl_po_recv IS '進貨單主檔';

COMMENT ON COLUMN tbl_po_recv."rcv_no" IS '進貨單編號';

COMMENT ON COLUMN tbl_po_recv."sup_no" IS '廠商編號';

COMMENT ON COLUMN tbl_po_recv."jnl_no" IS '會計單據編號';

COMMENT ON COLUMN tbl_po_recv."rcv_status" IS '單據狀態';

COMMENT ON COLUMN tbl_po_recv."rcv_date" IS '進貨日期';

COMMENT ON COLUMN tbl_po_recv."rcv_inv_no" IS '發票號碼';

COMMENT ON COLUMN tbl_po_recv."rcv_total" IS '未稅合計';

COMMENT ON COLUMN tbl_po_recv."rcv_tax" IS '稅額';

COMMENT ON COLUMN tbl_po_recv."rcv_not_clean" IS '未付款';

COMMENT ON COLUMN tbl_po_recv."rcv_desc" IS '說明';

COMMENT ON COLUMN tbl_po_recv."rcv_creator" IS '建檔人員';

COMMENT ON COLUMN tbl_po_recv."rcv_tr_flag" IS '傳輸記錄';

CREATE TABLE tbl_ap_pay_dt (
    "pay_no" varchar(20) NOT NULL,
    "pad_seqno" numeric(18,0) NOT NULL,
    "rcv_no" varchar(20) NOT NULL,
    "pad_amount" numeric(18,4) NOT NULL,
    "pad_discount" numeric(18,4) NOT NULL,
    CONSTRAINT pk_tbl_ap_pay_dt PRIMARY KEY ("pay_no", "pad_seqno")
);

COMMENT ON TABLE tbl_ap_pay_dt IS '付款單明細';

COMMENT ON COLUMN tbl_ap_pay_dt."pay_no" IS '付款單編號';

COMMENT ON COLUMN tbl_ap_pay_dt."pad_seqno" IS '序號';

COMMENT ON COLUMN tbl_ap_pay_dt."rcv_no" IS '進貨單編號';

COMMENT ON COLUMN tbl_ap_pay_dt."pad_amount" IS '沖帳金額';

COMMENT ON COLUMN tbl_ap_pay_dt."pad_discount" IS '折讓金額';

CREATE TABLE tbl_customer (
    "cum_no" varchar(20) NOT NULL,
    "cum_name" varchar(80) NOT NULL,
    "cum_president" varchar(20),
    "cum_contant" varchar(20),
    "cum_cont_title" varchar(20),
    "cum_tel1" varchar(30),
    "cum_tel2" varchar(30),
    "cum_fax" varchar(30),
    "cum_uniform_no" varchar(20),
    "cum_inv_addr" varchar(200),
    "cum_addr" varchar(200),
    "cum_zip_code" varchar(6),
    "cum_advance_amount" numeric(18,4) NOT NULL,
    "cum_desc" varchar(200),
    "cum_creator" varchar(20),
    "cum_acnt_ar" varchar(20) NOT NULL DEFAULT '1141',
    "cum_acnt_advance" varchar(20) NOT NULL DEFAULT '2261',
    "cum_inv_rate" numeric(18,4) NOT NULL DEFAULT 0,
    CONSTRAINT pk_tbl_customer PRIMARY KEY ("cum_no")
);

COMMENT ON TABLE tbl_customer IS '客戶主檔';

COMMENT ON COLUMN tbl_customer."cum_no" IS '客戶編號';

COMMENT ON COLUMN tbl_customer."cum_name" IS '客戶名稱';

COMMENT ON COLUMN tbl_customer."cum_president" IS '負責人';

COMMENT ON COLUMN tbl_customer."cum_contant" IS '聯絡人';

COMMENT ON COLUMN tbl_customer."cum_cont_title" IS '聯絡人職稱';

COMMENT ON COLUMN tbl_customer."cum_tel1" IS '電話1';

COMMENT ON COLUMN tbl_customer."cum_tel2" IS '電話2';

COMMENT ON COLUMN tbl_customer."cum_fax" IS '傳真';

COMMENT ON COLUMN tbl_customer."cum_uniform_no" IS '統一編號';

COMMENT ON COLUMN tbl_customer."cum_inv_addr" IS '發票地址';

COMMENT ON COLUMN tbl_customer."cum_addr" IS '公司地址';

COMMENT ON COLUMN tbl_customer."cum_zip_code" IS '郵遞區號';

COMMENT ON COLUMN tbl_customer."cum_advance_amount" IS '預收款餘額';

COMMENT ON COLUMN tbl_customer."cum_desc" IS '說明';

COMMENT ON COLUMN tbl_customer."cum_creator" IS '建檔人員';

COMMENT ON COLUMN tbl_customer."cum_acnt_ar" IS '應收帳款科目';

COMMENT ON COLUMN tbl_customer."cum_acnt_advance" IS '預收款科目';

COMMENT ON COLUMN tbl_customer."cum_inv_rate" IS '發票比率';

CREATE TABLE tbl_ar_recv (
    "arr_no" varchar(20) NOT NULL,
    "cum_no" varchar(20) NOT NULL,
    "jnl_no" varchar(20),
    "arr_date" timestamp NOT NULL,
    "arr_cash" numeric(18,4) NOT NULL,
    "arr_check" numeric(18,4) NOT NULL,
    "arr_from_advance" numeric(18,4) NOT NULL,
    "arr_to_advance" numeric(18,4) NOT NULL,
    "arr_desc" varchar(200),
    "arr_creator" varchar(20),
    "arr_tr_flag" boolean NOT NULL DEFAULT false,
    CONSTRAINT pk_tbl_ar_recv PRIMARY KEY ("arr_no")
);

COMMENT ON TABLE tbl_ar_recv IS '收款單主檔';

COMMENT ON COLUMN tbl_ar_recv."arr_no" IS '收款單編號';

COMMENT ON COLUMN tbl_ar_recv."cum_no" IS '客戶編號';

COMMENT ON COLUMN tbl_ar_recv."jnl_no" IS '會計單據編號';

COMMENT ON COLUMN tbl_ar_recv."arr_date" IS '收款日期';

COMMENT ON COLUMN tbl_ar_recv."arr_cash" IS '收取現金';

COMMENT ON COLUMN tbl_ar_recv."arr_check" IS '收取票據';

COMMENT ON COLUMN tbl_ar_recv."arr_from_advance" IS '取用預收款';

COMMENT ON COLUMN tbl_ar_recv."arr_to_advance" IS '累入預收款';

COMMENT ON COLUMN tbl_ar_recv."arr_desc" IS '說明';

COMMENT ON COLUMN tbl_ar_recv."arr_creator" IS '建檔人員';

COMMENT ON COLUMN tbl_ar_recv."arr_tr_flag" IS '傳輸記錄';

CREATE TABLE tbl_car (
    "car_no" varchar(20) NOT NULL,
    "car_brand" varchar(80),
    "car_license_no" varchar(80),
    "car_date1" timestamp,
    "car_creator" varchar(20),
    "car_desc" varchar(200),
    CONSTRAINT pk_tbl_car PRIMARY KEY ("car_no")
);

COMMENT ON TABLE tbl_car IS '車輛主檔';

COMMENT ON COLUMN tbl_car."car_no" IS '車輛編號';

COMMENT ON COLUMN tbl_car."car_brand" IS '廠牌形式';

COMMENT ON COLUMN tbl_car."car_license_no" IS '牌照號碼';

COMMENT ON COLUMN tbl_car."car_date1" IS '出廠年月';

COMMENT ON COLUMN tbl_car."car_creator" IS '建檔人員';

COMMENT ON COLUMN tbl_car."car_desc" IS '說明';

CREATE TABLE tbl_employe (
    "epy_no" varchar(20) NOT NULL,
    "epy_name" varchar(20) NOT NULL,
    "epy_password" varchar(20),
    "epy_tel1" varchar(30),
    "epy_tel2" varchar(30),
    "epy_addr" varchar(200),
    "epy_is_can_login" boolean NOT NULL DEFAULT false,
    "epy_desc" varchar(200),
    "epy_creator" varchar(20),
    CONSTRAINT pk_tbl_employe PRIMARY KEY ("epy_no")
);

COMMENT ON TABLE tbl_employe IS '員工主檔';

COMMENT ON COLUMN tbl_employe."epy_no" IS '員工編號';

COMMENT ON COLUMN tbl_employe."epy_name" IS '員工姓名';

COMMENT ON COLUMN tbl_employe."epy_password" IS '密碼';

COMMENT ON COLUMN tbl_employe."epy_tel1" IS '電話1';

COMMENT ON COLUMN tbl_employe."epy_tel2" IS '電話2';

COMMENT ON COLUMN tbl_employe."epy_addr" IS '住址';

COMMENT ON COLUMN tbl_employe."epy_is_can_login" IS '是否可登入系統';

COMMENT ON COLUMN tbl_employe."epy_desc" IS '說明';

COMMENT ON COLUMN tbl_employe."epy_creator" IS '建檔人員';

CREATE TABLE tbl_ship (
    "smt_no" varchar(20) NOT NULL,
    "cum_no" varchar(20) NOT NULL,
    "epy_no" varchar(20) NOT NULL,
    "car_no" varchar(20),
    "jnl_no" varchar(20),
    "smt_status" numeric(18,0) NOT NULL,
    "smt_inv_no" varchar(20),
    "smt_date" timestamp NOT NULL,
    "smt_destination" varchar(200),
    "smt_total" numeric(18,4) NOT NULL,
    "smt_tax" numeric(18,4) NOT NULL,
    "smt_not_clean" numeric(18,4) NOT NULL,
    "smt_cost" numeric(18,4) NOT NULL,
    "smt_deliver1" varchar(20),
    "smt_deliver2" varchar(20),
    "smt_desc" varchar(200),
    "smt_creator" varchar(20),
    "smt_tr_flag" boolean NOT NULL DEFAULT false,
    CONSTRAINT pk_tbl_ship PRIMARY KEY ("smt_no")
);

COMMENT ON TABLE tbl_ship IS '銷貨單主檔';

COMMENT ON COLUMN tbl_ship."smt_no" IS '銷貨單編號';

COMMENT ON COLUMN tbl_ship."cum_no" IS '客戶編號';

COMMENT ON COLUMN tbl_ship."epy_no" IS '業務員編號';

COMMENT ON COLUMN tbl_ship."car_no" IS '車輛編號';

COMMENT ON COLUMN tbl_ship."jnl_no" IS '會計單據編號';

COMMENT ON COLUMN tbl_ship."smt_status" IS '單據狀態';

COMMENT ON COLUMN tbl_ship."smt_inv_no" IS '發票號碼';

COMMENT ON COLUMN tbl_ship."smt_date" IS '銷貨日期';

COMMENT ON COLUMN tbl_ship."smt_destination" IS '送貨地址';

COMMENT ON COLUMN tbl_ship."smt_total" IS '未稅合計';

COMMENT ON COLUMN tbl_ship."smt_tax" IS '稅額';

COMMENT ON COLUMN tbl_ship."smt_not_clean" IS '未收款';

COMMENT ON COLUMN tbl_ship."smt_cost" IS '成本合計';

COMMENT ON COLUMN tbl_ship."smt_deliver1" IS '送貨員1';

COMMENT ON COLUMN tbl_ship."smt_deliver2" IS '送貨員2';

COMMENT ON COLUMN tbl_ship."smt_desc" IS '說明';

COMMENT ON COLUMN tbl_ship."smt_creator" IS '建檔人員';

COMMENT ON COLUMN tbl_ship."smt_tr_flag" IS '傳輸記錄';

CREATE TABLE tbl_ar_recv_dt (
    "arr_no" varchar(20) NOT NULL,
    "ard_seqno" numeric(18,0) NOT NULL,
    "smt_no" varchar(20) NOT NULL,
    "ard_amount" numeric(18,4) NOT NULL,
    "ard_discount" numeric(18,4) NOT NULL,
    CONSTRAINT pk_tbl_ar_recv_dt PRIMARY KEY ("arr_no", "ard_seqno")
);

COMMENT ON TABLE tbl_ar_recv_dt IS '收款單明細';

COMMENT ON COLUMN tbl_ar_recv_dt."arr_no" IS '收款單編號';

COMMENT ON COLUMN tbl_ar_recv_dt."ard_seqno" IS '序號';

COMMENT ON COLUMN tbl_ar_recv_dt."smt_no" IS '銷貨單編號';

COMMENT ON COLUMN tbl_ar_recv_dt."ard_amount" IS '沖帳金額';

COMMENT ON COLUMN tbl_ar_recv_dt."ard_discount" IS '折讓金額';

CREATE TABLE tbl_fld_for_edit (
    "fld_dummy_pk" numeric(18,0) NOT NULL,
    "fld_string" varchar(255),
    "fld_int" integer,
    "fld_boolean" boolean,
    "fld_float" double precision,
    CONSTRAINT pk_tbl_fld_for_edit PRIMARY KEY ("fld_dummy_pk")
);

CREATE TABLE tbl_his_po_recv (
    "hrcv_no" varchar(20) NOT NULL,
    "sup_no" varchar(20) NOT NULL,
    "hrcv_date" timestamp NOT NULL,
    "hrcv_inv_no" varchar(20),
    "hrcv_total" numeric(18,4) NOT NULL,
    "hrcv_tax" numeric(18,4) NOT NULL,
    "hrcv_desc" varchar(200),
    "hrcv_creator" varchar(20),
    CONSTRAINT pk_tbl_his_po_recv PRIMARY KEY ("hrcv_no")
);

COMMENT ON TABLE tbl_his_po_recv IS '歷史進貨單主檔';

COMMENT ON COLUMN tbl_his_po_recv."hrcv_no" IS '進貨單編號';

COMMENT ON COLUMN tbl_his_po_recv."sup_no" IS '廠商編號';

COMMENT ON COLUMN tbl_his_po_recv."hrcv_date" IS '進貨日期';

COMMENT ON COLUMN tbl_his_po_recv."hrcv_inv_no" IS '發票號碼';

COMMENT ON COLUMN tbl_his_po_recv."hrcv_total" IS '未稅合計';

COMMENT ON COLUMN tbl_his_po_recv."hrcv_tax" IS '稅額';

COMMENT ON COLUMN tbl_his_po_recv."hrcv_desc" IS '說明';

COMMENT ON COLUMN tbl_his_po_recv."hrcv_creator" IS '建檔人員';

CREATE TABLE tbl_inventory (
    "inv_no" varchar(20) NOT NULL,
    "inv_name" varchar(80) NOT NULL,
    "inv_desc" varchar(200),
    "inv_creator" varchar(20),
    CONSTRAINT pk_tbl_inventory PRIMARY KEY ("inv_no")
);

COMMENT ON TABLE tbl_inventory IS '庫房主檔';

COMMENT ON COLUMN tbl_inventory."inv_no" IS '庫房編號';

COMMENT ON COLUMN tbl_inventory."inv_name" IS '庫房名稱';

COMMENT ON COLUMN tbl_inventory."inv_desc" IS '說明';

COMMENT ON COLUMN tbl_inventory."inv_creator" IS '建檔人員';

CREATE TABLE tbl_product (
    "prd_no" varchar(20) NOT NULL,
    "prd_name" varchar(80) NOT NULL,
    "prd_unit" varchar(6),
    "prd_sale_price" numeric(18,4) NOT NULL,
    "prd_safe_qty" numeric(18,4) NOT NULL,
    "prd_onhand" numeric(18,4) NOT NULL,
    "prd_cur_cost" numeric(18,4) NOT NULL,
    "prd_desc" varchar(200),
    "prd_is_dummy" boolean NOT NULL DEFAULT false,
    "prd_dum_cost_rate" numeric(18,4) NOT NULL,
    "prd_ext_cost_ratio" numeric(18,4) NOT NULL,
    "prd_creator" varchar(20),
    CONSTRAINT pk_tbl_product PRIMARY KEY ("prd_no")
);

COMMENT ON TABLE tbl_product IS '產品主檔';

COMMENT ON COLUMN tbl_product."prd_no" IS '產品編號';

COMMENT ON COLUMN tbl_product."prd_name" IS '產品名稱';

COMMENT ON COLUMN tbl_product."prd_unit" IS '單位';

COMMENT ON COLUMN tbl_product."prd_sale_price" IS '建議售價';

COMMENT ON COLUMN tbl_product."prd_safe_qty" IS '安全存量';

COMMENT ON COLUMN tbl_product."prd_onhand" IS '全部庫存現有數量';

COMMENT ON COLUMN tbl_product."prd_cur_cost" IS '現行成本';

COMMENT ON COLUMN tbl_product."prd_desc" IS '說明';

COMMENT ON COLUMN tbl_product."prd_is_dummy" IS '是否為虛擬料品';

COMMENT ON COLUMN tbl_product."prd_dum_cost_rate" IS '虛擬料品成本比率';

COMMENT ON COLUMN tbl_product."prd_ext_cost_ratio" IS '額外管銷成本比率(家具業)';

COMMENT ON COLUMN tbl_product."prd_creator" IS '建檔人員';

CREATE TABLE tbl_his_po_recv_dt (
    "hrcv_no" varchar(20) NOT NULL,
    "hrcd_seqno" numeric(18,0) NOT NULL,
    "prd_no" varchar(20) NOT NULL,
    "inv_no" varchar(20) NOT NULL,
    "hrcd_prd_name" varchar(80),
    "hrcd_qty" numeric(18,4) NOT NULL,
    "hrcd_unit_price" numeric(18,4) NOT NULL,
    CONSTRAINT pk_tbl_his_po_recv_dt PRIMARY KEY ("hrcv_no", "hrcd_seqno")
);

COMMENT ON TABLE tbl_his_po_recv_dt IS '歷史進貨單明細';

COMMENT ON COLUMN tbl_his_po_recv_dt."hrcv_no" IS '進貨單編號';

COMMENT ON COLUMN tbl_his_po_recv_dt."hrcd_seqno" IS '進貨單序號';

COMMENT ON COLUMN tbl_his_po_recv_dt."prd_no" IS '產品編號';

COMMENT ON COLUMN tbl_his_po_recv_dt."inv_no" IS '庫房編號';

COMMENT ON COLUMN tbl_his_po_recv_dt."hrcd_prd_name" IS '產品名稱';

COMMENT ON COLUMN tbl_his_po_recv_dt."hrcd_qty" IS '數量';

COMMENT ON COLUMN tbl_his_po_recv_dt."hrcd_unit_price" IS '單價';

CREATE TABLE tbl_his_ship (
    "hsmt_no" varchar(20) NOT NULL,
    "cum_no" varchar(20) NOT NULL,
    "epy_no" varchar(20) NOT NULL,
    "hsmt_inv_no" varchar(20),
    "hsmt_date" timestamp NOT NULL,
    "hsmt_destination" varchar(200),
    "hsmt_total" numeric(18,4) NOT NULL,
    "hsmt_tax" numeric(18,4) NOT NULL,
    "hsmt_cost" numeric(18,4) NOT NULL,
    "hsmt_desc" varchar(200),
    "hsmt_creator" varchar(20),
    CONSTRAINT pk_tbl_his_ship PRIMARY KEY ("hsmt_no")
);

COMMENT ON TABLE tbl_his_ship IS '歷史銷貨單主檔';

COMMENT ON COLUMN tbl_his_ship."hsmt_no" IS '憑證編號';

COMMENT ON COLUMN tbl_his_ship."cum_no" IS '客戶編號';

COMMENT ON COLUMN tbl_his_ship."epy_no" IS '業務員編號';

COMMENT ON COLUMN tbl_his_ship."hsmt_inv_no" IS '發票號碼';

COMMENT ON COLUMN tbl_his_ship."hsmt_date" IS '銷貨日期';

COMMENT ON COLUMN tbl_his_ship."hsmt_destination" IS '送貨地址';

COMMENT ON COLUMN tbl_his_ship."hsmt_total" IS '未稅合計';

COMMENT ON COLUMN tbl_his_ship."hsmt_tax" IS '稅額';

COMMENT ON COLUMN tbl_his_ship."hsmt_cost" IS '成本合計';

COMMENT ON COLUMN tbl_his_ship."hsmt_desc" IS '說明';

COMMENT ON COLUMN tbl_his_ship."hsmt_creator" IS '建檔人員';

CREATE TABLE tbl_his_ship_dt (
    "hsmt_no" varchar(20) NOT NULL,
    "hsmd_seqno" numeric(18,0) NOT NULL,
    "prd_no" varchar(20) NOT NULL,
    "inv_no" varchar(20) NOT NULL,
    "hsmd_prd_name" varchar(80),
    "hsmd_unit_price" numeric(18,4) NOT NULL,
    "hsmd_qty" numeric(18,4) NOT NULL,
    "hsmd_cost" numeric(18,4) NOT NULL,
    CONSTRAINT pk_tbl_his_ship_dt PRIMARY KEY ("hsmt_no", "hsmd_seqno")
);

COMMENT ON TABLE tbl_his_ship_dt IS '歷史銷貨單明細';

COMMENT ON COLUMN tbl_his_ship_dt."hsmt_no" IS '憑證編號';

COMMENT ON COLUMN tbl_his_ship_dt."hsmd_seqno" IS '銷貨單序號';

COMMENT ON COLUMN tbl_his_ship_dt."prd_no" IS '產品編號';

COMMENT ON COLUMN tbl_his_ship_dt."inv_no" IS '庫房編號';

COMMENT ON COLUMN tbl_his_ship_dt."hsmd_prd_name" IS '品名';

COMMENT ON COLUMN tbl_his_ship_dt."hsmd_unit_price" IS '單價';

COMMENT ON COLUMN tbl_his_ship_dt."hsmd_qty" IS '數量';

COMMENT ON COLUMN tbl_his_ship_dt."hsmd_cost" IS '成本';

CREATE TABLE tbl_inv_adj (
    "adj_no" varchar(20) NOT NULL,
    "adj_status" numeric(18,0) NOT NULL,
    "adj_date" timestamp NOT NULL,
    "adj_desc" varchar(200),
    "adj_creator" varchar(20),
    "adj_tr_flag" boolean NOT NULL DEFAULT false,
    CONSTRAINT pk_tbl_inv_adj PRIMARY KEY ("adj_no")
);

COMMENT ON TABLE tbl_inv_adj IS '庫房調整單';

COMMENT ON COLUMN tbl_inv_adj."adj_no" IS '調整單編號';

COMMENT ON COLUMN tbl_inv_adj."adj_status" IS '單據狀態';

COMMENT ON COLUMN tbl_inv_adj."adj_date" IS '調整日期';

COMMENT ON COLUMN tbl_inv_adj."adj_desc" IS '說明';

COMMENT ON COLUMN tbl_inv_adj."adj_creator" IS '建檔人員';

COMMENT ON COLUMN tbl_inv_adj."adj_tr_flag" IS '傳輸記錄';

CREATE TABLE tbl_inv_adj_dt (
    "adj_no" varchar(20) NOT NULL,
    "add_seqno" numeric(18,0) NOT NULL,
    "prd_no" varchar(20) NOT NULL,
    "add_qty" numeric(18,4) NOT NULL,
    "add_cost" numeric(18,4) NOT NULL,
    "inv_no" varchar(20) NOT NULL,
    CONSTRAINT pk_tbl_inv_adj_dt PRIMARY KEY ("adj_no", "add_seqno")
);

COMMENT ON TABLE tbl_inv_adj_dt IS '庫房調整單明細';

COMMENT ON COLUMN tbl_inv_adj_dt."adj_no" IS '調整單編號';

COMMENT ON COLUMN tbl_inv_adj_dt."add_seqno" IS '序號';

COMMENT ON COLUMN tbl_inv_adj_dt."prd_no" IS '產品編號';

COMMENT ON COLUMN tbl_inv_adj_dt."add_qty" IS '數量';

COMMENT ON COLUMN tbl_inv_adj_dt."add_cost" IS '成本';

COMMENT ON COLUMN tbl_inv_adj_dt."inv_no" IS '庫房編號';

CREATE TABLE tbl_inv_onhand (
    "inv_no" varchar(20) NOT NULL,
    "prd_no" varchar(20) NOT NULL,
    "ioh_qty" numeric(18,4) NOT NULL,
    CONSTRAINT pk_tbl_inv_onhand PRIMARY KEY ("inv_no", "prd_no")
);

COMMENT ON TABLE tbl_inv_onhand IS '庫房現有量檔';

COMMENT ON COLUMN tbl_inv_onhand."inv_no" IS '庫房編號';

COMMENT ON COLUMN tbl_inv_onhand."prd_no" IS '產品編號';

COMMENT ON COLUMN tbl_inv_onhand."ioh_qty" IS '現有數量';

CREATE TABLE tbl_po_recv_dt (
    "rcv_no" varchar(20) NOT NULL,
    "rcd_seqno" numeric(18,0) NOT NULL,
    "prd_no" varchar(20) NOT NULL,
    "inv_no" varchar(20) NOT NULL,
    "rcd_prd_name" varchar(80),
    "rcd_qty" numeric(18,4) NOT NULL,
    "rcd_unit_price" numeric(18,4) NOT NULL,
    CONSTRAINT pk_tbl_po_recv_dt PRIMARY KEY ("rcv_no", "rcd_seqno")
);

COMMENT ON TABLE tbl_po_recv_dt IS '進貨單明細';

COMMENT ON COLUMN tbl_po_recv_dt."rcv_no" IS '進貨單編號';

COMMENT ON COLUMN tbl_po_recv_dt."rcd_seqno" IS '進貨單序號';

COMMENT ON COLUMN tbl_po_recv_dt."prd_no" IS '產品編號';

COMMENT ON COLUMN tbl_po_recv_dt."inv_no" IS '庫房編號';

COMMENT ON COLUMN tbl_po_recv_dt."rcd_prd_name" IS '產品名稱';

COMMENT ON COLUMN tbl_po_recv_dt."rcd_qty" IS '數量';

COMMENT ON COLUMN tbl_po_recv_dt."rcd_unit_price" IS '單價';

CREATE TABLE tbl_ship_dt (
    "smt_no" varchar(20) NOT NULL,
    "smd_seqno" numeric(18,0) NOT NULL,
    "prd_no" varchar(20) NOT NULL,
    "inv_no" varchar(20) NOT NULL,
    "smd_prd_name" varchar(80),
    "smd_unit_price" numeric(18,4) NOT NULL,
    "smd_qty" numeric(18,4) NOT NULL,
    "smd_cost" numeric(18,4) NOT NULL,
    CONSTRAINT pk_tbl_ship_dt PRIMARY KEY ("smt_no", "smd_seqno")
);

COMMENT ON TABLE tbl_ship_dt IS '銷貨單明細';

COMMENT ON COLUMN tbl_ship_dt."smt_no" IS '銷貨單編號';

COMMENT ON COLUMN tbl_ship_dt."smd_seqno" IS '銷貨單序號';

COMMENT ON COLUMN tbl_ship_dt."prd_no" IS '產品編號';

COMMENT ON COLUMN tbl_ship_dt."inv_no" IS '庫房編號';

COMMENT ON COLUMN tbl_ship_dt."smd_prd_name" IS '品名';

COMMENT ON COLUMN tbl_ship_dt."smd_unit_price" IS '單價';

COMMENT ON COLUMN tbl_ship_dt."smd_qty" IS '數量';

COMMENT ON COLUMN tbl_ship_dt."smd_cost" IS '成本';

CREATE TABLE tbl_sys_param (
    "spr_period_start" timestamp NOT NULL,
    "spr_cor_name" varchar(80),
    "spr_tel" varchar(30),
    "spr_fax" varchar(30),
    "spr_addr" varchar(200),
    "spr_tax_rate" numeric(18,4) NOT NULL,
    "spr_qty_decimal" numeric(18,0),
    "spr_amount_unit_dot" numeric(18,0),
    "spr_amount_dot" numeric(18,0),
    "spr_bkup_cmd" varchar(250),
    "spr_bkup_para" varchar(250),
    "spr_bkup_path" varchar(250),
    "spr_prd_cost_rate" numeric(18,4) NOT NULL DEFAULT 0.05,
    "spr_bonus_sale_rate" numeric(18,4) NOT NULL DEFAULT 0.01,
    "spr_bonus_profit_rate" numeric(18,4) NOT NULL DEFAULT 0.15,
    "spr_acnt_year" numeric(18,0) NOT NULL DEFAULT 2004,
    "spr_acnt_sale_revenue" varchar(20) NOT NULL DEFAULT '4111',
    "spr_acnt_sale_return" varchar(20) NOT NULL DEFAULT '4171',
    "spr_acnt_sale_discount" varchar(20) NOT NULL DEFAULT '4191',
    "spr_acnt_sale_tax" varchar(20) DEFAULT '2281',
    "spr_acnt_purchase" varchar(20) NOT NULL DEFAULT '5121',
    "spr_acnt_pur_discount" varchar(20) NOT NULL DEFAULT '5124',
    "spr_acnt_pur_return" varchar(20) NOT NULL DEFAULT '5123',
    "spr_acnt_pur_tax" varchar(20) DEFAULT '1281',
    "spr_acnt_cash" varchar(20) NOT NULL DEFAULT '1111',
    "spr_acnt_cus_check" varchar(20) NOT NULL DEFAULT '1131',
    "spr_acnt_sup_check" varchar(20) NOT NULL DEFAULT '2131',
    CONSTRAINT pk_tbl_sys_param PRIMARY KEY ("spr_period_start")
);

COMMENT ON TABLE tbl_sys_param IS '系統參數';

COMMENT ON COLUMN tbl_sys_param."spr_period_start" IS '成本期間起始日期';

COMMENT ON COLUMN tbl_sys_param."spr_cor_name" IS '公司名稱';

COMMENT ON COLUMN tbl_sys_param."spr_tel" IS '電話';

COMMENT ON COLUMN tbl_sys_param."spr_fax" IS '傳真';

COMMENT ON COLUMN tbl_sys_param."spr_addr" IS '地址';

COMMENT ON COLUMN tbl_sys_param."spr_tax_rate" IS '稅率';

COMMENT ON COLUMN tbl_sys_param."spr_qty_decimal" IS '數量顯示小數點';

COMMENT ON COLUMN tbl_sys_param."spr_amount_unit_dot" IS '金額單價顯示小數點';

COMMENT ON COLUMN tbl_sys_param."spr_amount_dot" IS '金額顯示小數點';

COMMENT ON COLUMN tbl_sys_param."spr_bkup_cmd" IS '系統備份指令';

COMMENT ON COLUMN tbl_sys_param."spr_bkup_para" IS '系統備份參數';

COMMENT ON COLUMN tbl_sys_param."spr_bkup_path" IS '系統備份路徑';

COMMENT ON COLUMN tbl_sys_param."spr_prd_cost_rate" IS '產品管銷成本預設值(傢俱)';

COMMENT ON COLUMN tbl_sys_param."spr_bonus_sale_rate" IS '業績獎金比率(傢俱)';

COMMENT ON COLUMN tbl_sys_param."spr_bonus_profit_rate" IS '利潤獎金比率(傢俱)';

COMMENT ON COLUMN tbl_sys_param."spr_acnt_year" IS '會計年度';

COMMENT ON COLUMN tbl_sys_param."spr_acnt_sale_revenue" IS '銷貨收入科目';

COMMENT ON COLUMN tbl_sys_param."spr_acnt_sale_return" IS '銷貨退回科目';

COMMENT ON COLUMN tbl_sys_param."spr_acnt_sale_discount" IS '銷貨折讓科目';

COMMENT ON COLUMN tbl_sys_param."spr_acnt_sale_tax" IS '銷項稅額';

COMMENT ON COLUMN tbl_sys_param."spr_acnt_purchase" IS '進貨科目';

COMMENT ON COLUMN tbl_sys_param."spr_acnt_pur_discount" IS '進貨折讓科目';

COMMENT ON COLUMN tbl_sys_param."spr_acnt_pur_return" IS '進貨退出科目';

COMMENT ON COLUMN tbl_sys_param."spr_acnt_pur_tax" IS '進項稅額';

COMMENT ON COLUMN tbl_sys_param."spr_acnt_cash" IS '現金科目';

COMMENT ON COLUMN tbl_sys_param."spr_acnt_cus_check" IS '應收票據';

COMMENT ON COLUMN tbl_sys_param."spr_acnt_sup_check" IS '應付票據';

CREATE TABLE tbl_transaction (
    "trn_id" serial,
    "prd_no" varchar(20) NOT NULL,
    "inv_no" varchar(20) NOT NULL,
    "trn_type" numeric(18,0) NOT NULL,
    "trn_src_no" varchar(20),
    "trn_src_seqno" numeric(18,0),
    "trn_datetime" timestamp NOT NULL,
    "trn_qty" numeric(18,4) NOT NULL,
    "trn_cost" numeric(18,4) NOT NULL,
    "trn_onhand" numeric(18,4) NOT NULL,
    "trn_avg_cost" numeric(18,4) NOT NULL,
    CONSTRAINT pk_tbl_transaction PRIMARY KEY ("trn_id")
);

COMMENT ON TABLE tbl_transaction IS '庫房交易檔';

COMMENT ON COLUMN tbl_transaction."trn_id" IS '交易內碼';

COMMENT ON COLUMN tbl_transaction."prd_no" IS '產品編號';

COMMENT ON COLUMN tbl_transaction."inv_no" IS '庫房編號';

COMMENT ON COLUMN tbl_transaction."trn_type" IS '交易類別';

COMMENT ON COLUMN tbl_transaction."trn_src_no" IS '交易來源編號';

COMMENT ON COLUMN tbl_transaction."trn_src_seqno" IS '交易來源序號';

COMMENT ON COLUMN tbl_transaction."trn_datetime" IS '交易日期時間';

COMMENT ON COLUMN tbl_transaction."trn_qty" IS '交易數量';

COMMENT ON COLUMN tbl_transaction."trn_cost" IS '交易成本';

COMMENT ON COLUMN tbl_transaction."trn_onhand" IS '存貨數量';

COMMENT ON COLUMN tbl_transaction."trn_avg_cost" IS '移動平均成本';

ALTER TABLE tbl_acnt_account ADD CONSTRAINT fk_tbl_acnt_ref_2110_tbl_acnt FOREIGN KEY ("typ_no") REFERENCES tbl_acnt_type ("typ_no");

ALTER TABLE tbl_acnt_init ADD CONSTRAINT fk_tbl_acnt_ref_2107_tbl_acnt FOREIGN KEY ("act_no") REFERENCES tbl_acnt_account ("act_no");

ALTER TABLE tbl_acnt_journal_dt ADD CONSTRAINT fk_tbl_acnt_ref_2113_tbl_acnt FOREIGN KEY ("jnl_no") REFERENCES tbl_acnt_journal ("jnl_no");

ALTER TABLE tbl_acnt_journal_dt ADD CONSTRAINT fk_tbl_acnt_ref_2104_tbl_acnt FOREIGN KEY ("act_no") REFERENCES tbl_acnt_account ("act_no");

ALTER TABLE tbl_ap_pay ADD CONSTRAINT fk_tbl_ap_p_ref_sup_p_tbl_supp FOREIGN KEY ("sup_no") REFERENCES tbl_supplier ("sup_no");

ALTER TABLE tbl_ap_pay_dt ADD CONSTRAINT fk_tbl_ap_p_ref_2340_tbl_ap_p FOREIGN KEY ("pay_no") REFERENCES tbl_ap_pay ("pay_no");

ALTER TABLE tbl_ap_pay_dt ADD CONSTRAINT fk_tbl_ap_p_ref_2323_tbl_po_r FOREIGN KEY ("rcv_no") REFERENCES tbl_po_recv ("rcv_no");

ALTER TABLE tbl_ar_recv ADD CONSTRAINT fk_tbl_ar_r_ref_cum_r_tbl_cust FOREIGN KEY ("cum_no") REFERENCES tbl_customer ("cum_no");

ALTER TABLE tbl_ar_recv_dt ADD CONSTRAINT fk_tbl_ar_r_ref_2337_tbl_ar_r FOREIGN KEY ("arr_no") REFERENCES tbl_ar_recv ("arr_no");

ALTER TABLE tbl_ar_recv_dt ADD CONSTRAINT fk_tbl_ar_r_ref_2317_tbl_ship FOREIGN KEY ("smt_no") REFERENCES tbl_ship ("smt_no");

ALTER TABLE tbl_his_po_recv ADD CONSTRAINT fk_tbl_his__ref_5400_tbl_supp FOREIGN KEY ("sup_no") REFERENCES tbl_supplier ("sup_no");

ALTER TABLE tbl_his_po_recv_dt ADD CONSTRAINT fk_tbl_his__ref_5404_tbl_prod FOREIGN KEY ("prd_no") REFERENCES tbl_product ("prd_no");

ALTER TABLE tbl_his_po_recv_dt ADD CONSTRAINT fk_tbl_his__ref_5380_tbl_his_ FOREIGN KEY ("hrcv_no") REFERENCES tbl_his_po_recv ("hrcv_no");

ALTER TABLE tbl_his_po_recv_dt ADD CONSTRAINT fk_tbl_his__ref_5520_tbl_inve FOREIGN KEY ("inv_no") REFERENCES tbl_inventory ("inv_no");

ALTER TABLE tbl_his_ship ADD CONSTRAINT fk_tbl_his__ref_5388_tbl_cust FOREIGN KEY ("cum_no") REFERENCES tbl_customer ("cum_no");

ALTER TABLE tbl_his_ship ADD CONSTRAINT fk_tbl_his__ref_5392_tbl_empl FOREIGN KEY ("epy_no") REFERENCES tbl_employe ("epy_no");

ALTER TABLE tbl_his_ship_dt ADD CONSTRAINT fk_tbl_his__ref_5396_tbl_prod FOREIGN KEY ("prd_no") REFERENCES tbl_product ("prd_no");

ALTER TABLE tbl_his_ship_dt ADD CONSTRAINT fk_tbl_his__ref_5516_tbl_inve FOREIGN KEY ("inv_no") REFERENCES tbl_inventory ("inv_no");

ALTER TABLE tbl_his_ship_dt ADD CONSTRAINT fk_tbl_his__ref_5376_tbl_his_ FOREIGN KEY ("hsmt_no") REFERENCES tbl_his_ship ("hsmt_no");

ALTER TABLE tbl_inv_adj_dt ADD CONSTRAINT fk_tbl_inv__ref_2343_tbl_inv_ FOREIGN KEY ("adj_no") REFERENCES tbl_inv_adj ("adj_no");

ALTER TABLE tbl_inv_adj_dt ADD CONSTRAINT fk_tbl_inv__ref_prd_a_tbl_prod FOREIGN KEY ("prd_no") REFERENCES tbl_product ("prd_no");

ALTER TABLE tbl_inv_adj_dt ADD CONSTRAINT fk_tbl_inv__ref_6272_tbl_inve FOREIGN KEY ("inv_no") REFERENCES tbl_inventory ("inv_no");

ALTER TABLE tbl_inv_onhand ADD CONSTRAINT fk_tbl_inv__ref_4575_tbl_prod FOREIGN KEY ("prd_no") REFERENCES tbl_product ("prd_no");

ALTER TABLE tbl_inv_onhand ADD CONSTRAINT fk_tbl_inv__ref_inv_i_tbl_inve FOREIGN KEY ("inv_no") REFERENCES tbl_inventory ("inv_no");

ALTER TABLE tbl_po_recv ADD CONSTRAINT fk_tbl_po_r_ref_sup_r_tbl_supp FOREIGN KEY ("sup_no") REFERENCES tbl_supplier ("sup_no");

ALTER TABLE tbl_po_recv_dt ADD CONSTRAINT fk_tbl_po_r_ref_prd_r_tbl_prod FOREIGN KEY ("prd_no") REFERENCES tbl_product ("prd_no");

ALTER TABLE tbl_po_recv_dt ADD CONSTRAINT fk_tbl_po_r_ref_inv_r_tbl_inve FOREIGN KEY ("inv_no") REFERENCES tbl_inventory ("inv_no");

ALTER TABLE tbl_po_recv_dt ADD CONSTRAINT fk_tbl_po_r_ref_2320_tbl_po_r FOREIGN KEY ("rcv_no") REFERENCES tbl_po_recv ("rcv_no");

ALTER TABLE tbl_ship ADD CONSTRAINT fk_tbl_ship_ref_4731_tbl_car FOREIGN KEY ("car_no") REFERENCES tbl_car ("car_no");

ALTER TABLE tbl_ship ADD CONSTRAINT fk_tbl_ship_ref_cum_s_tbl_cust FOREIGN KEY ("cum_no") REFERENCES tbl_customer ("cum_no");

ALTER TABLE tbl_ship ADD CONSTRAINT fk_tbl_ship_ref_2311_tbl_empl FOREIGN KEY ("epy_no") REFERENCES tbl_employe ("epy_no");

ALTER TABLE tbl_ship_dt ADD CONSTRAINT fk_tbl_ship_ref_prd_s_tbl_prod FOREIGN KEY ("prd_no") REFERENCES tbl_product ("prd_no");

ALTER TABLE tbl_ship_dt ADD CONSTRAINT fk_tbl_ship_ref_inv_s_tbl_inve FOREIGN KEY ("inv_no") REFERENCES tbl_inventory ("inv_no");

ALTER TABLE tbl_ship_dt ADD CONSTRAINT fk_tbl_ship_ref_2314_tbl_ship FOREIGN KEY ("smt_no") REFERENCES tbl_ship ("smt_no");

ALTER TABLE tbl_transaction ADD CONSTRAINT fk_tbl_tran_ref_inv_t_tbl_inve FOREIGN KEY ("inv_no") REFERENCES tbl_inventory ("inv_no");

ALTER TABLE tbl_transaction ADD CONSTRAINT fk_tbl_tran_ref_prd_t_tbl_prod FOREIGN KEY ("prd_no") REFERENCES tbl_product ("prd_no");

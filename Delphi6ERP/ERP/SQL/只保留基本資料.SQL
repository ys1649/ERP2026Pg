
delete from TBL_INV_ADJ_DT;
delete from TBL_INV_ADJ;

delete from TBL_AP_PAY_DT;
delete from TBL_AP_PAY;

delete from TBL_AR_RECV_DT;
delete from TBL_AR_RECV;

delete from TBL_PO_RECV_DT;
delete from TBL_PO_RECV;

delete from TBL_SHIP_DT;
delete from TBL_SHIP;

delete from TBL_HIS_SHIP_DT;
delete from TBL_HIS_SHIP;

delete from TBL_HIS_PO_RECV_DT;
delete from TBL_HIS_PO_RECV;

delete from TBL_TRANSACTION;
delete from TBL_INV_ONHAND;


delete from TBL_ACNT_INIT;
delete from TBL_ACNT_JOURNAL;
delete from TBL_ACNT_JOURNAL_DT;

--delete from TBL_ACNT_ACCOUNT;
--Delete from TBL_ACNT_TYPE;
--delete from TBL_INVENTORY;
--delete from TBL_SUPPLIER;
--delete from TBL_PRODUCT;
--delete from TBL_CUSTOMER;
--delete from TBL_FLD_FOR_EDIT;
--DELETE FROM TBL_CAR;

--delete from TBL_EMPLOYE where EPY_NO <> 'WYS';
--delete from TBL_SYS_PARAM;
UPDATE TBL_SYS_PARAM SET SPR_ACNT_YEAR=2005;
sqlcmd -S TNVTRSAP01 -U erp -P erp -d erp -i Create_SysReport_SQL.sql
sqlcmd -S TNVTRSAP01 -U erp -P erp -d erp -i Create_All_ERP_TABLE.sql
sqlcmd -S TNVTRSAP01 -U erp -P erp -d erp -i InsertAccount.sql
pause
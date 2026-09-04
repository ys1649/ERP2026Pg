/* ============================================================ */
/*   Database name:  ERP                                        */
/*   DBMS name:      Microsoft SQL Server 6.x                   */
/*   Created on:     2002/12/17  10:43 ¤U¤È¨ú“                  */
/* ============================================================ */

sp_rename "TBL_HIS_PO_RECV_DT.RCD_SEQNO", HRCD_SEQNO
go

sp_rename "TBL_HIS_PO_RECV_DT.RCD_PRD_NAME", HRCD_PRD_NAME
go

sp_rename "TBL_HIS_PO_RECV_DT.RCD_QTY", HRCD_QTY
go

sp_rename "TBL_HIS_PO_RECV_DT.RCD_UNIT_PRICE", HRCD_UNIT_PRICE
go

commit
go


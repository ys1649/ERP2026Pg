/* ============================================================ */
/*   Database name:  ERP                                        */
/*   DBMS name:      Microsoft SQL Server 6.x                   */
/*   Created on:     2004/02/19  15:09                          */
/* ============================================================ */

alter table TBL_SYS_PARAM
    add     SPR_ACNT_YEAR          numeric               not null
        default 2004
go

commit
go


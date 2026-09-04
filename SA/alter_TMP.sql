/* ============================================================ */
/*   Database name:  MODEL_129                                  */
/*   DBMS name:      Microsoft SQL Server 6.x                   */
/*   Created on:     2005/3/15  13:17                           */
/* ============================================================ */

alter table TBL_CAR
    add     CAR_CREATOR             varchar(20)           null    
go

commit
go


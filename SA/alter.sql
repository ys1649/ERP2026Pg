/* ============================================================ */
/*   Database name:  MODEL_129                                  */
/*   DBMS name:      Microsoft SQL Server 6.x                   */
/*   Created on:     2005/3/15  17:51                           */
/* ============================================================ */

create table TBL_CAR
(
    CAR_NO                  varchar(20)           not null,
    CAR_BRAND               varchar(80)           null    ,
    CAR_LICENSE_NO          varchar(80)           null    ,
    CAR_DATE1               datetime              null    ,
    CAR_CREATOR             varchar(20)           null    ,
    CAR_DESC                varchar(200)          null    ,
    constraint PK_TBL_CAR primary key (CAR_NO)
)
go

alter table TBL_SHIP
    add     CAR_NO                  varchar(20)           null    
go

alter table TBL_SHIP
    add constraint FK_TBL_SHIP_REF_4731_TBL_CAR foreign key  (CAR_NO)
       references TBL_CAR (CAR_NO)
go

commit
go


alter table TBL_SYS_PARAM
    add     SPR_ACNT_YEAR          numeric               not null
        default 2004
go

alter table TBL_INV_ADJ
    add     ADJ_TR_FLAG            bit                   not null
        default 0
go

alter table TBL_AR_RECV
    add     ARR_TR_FLAG            bit                   not null
        default 0
go

alter table TBL_AP_PAY
    add     PAY_TR_FLAG            bit                   not null
        default 0
go

alter table TBL_PO_RECV
    add     RCV_TR_FLAG            bit                   not null
        default 0
go

alter table TBL_SHIP
    add     SMT_TR_FLAG            bit                   not null
        default 0
go

/* ============================================================ */
/*   Database name:  MODEL_129                                  */
/*   DBMS name:      Microsoft SQL Server 6.x                   */
/*   Created on:     2004/03/13  10:12                          */
/* ============================================================ */

if exists (select 1
            from  sysobjects
           where  id = object_id('tmp_TBL_ACNT_JOURNAL_DT')
            and   type = 'U')
   drop table tmp_TBL_ACNT_JOURNAL_DT
go

create table tmp_TBL_ACNT_JOURNAL_DT
(
    JNL_NO                 varchar(20)           not null,
    JND_SEQNO              numeric               not null,
    ACT_NO                 varchar(20)           not null,
    JND_DC                 numeric               not null,
    JND_AMOUNT             money                 not null,
    JND_DESC               varchar(200)          null    
)
go

insert into tmp_TBL_ACNT_JOURNAL_DT (JNL_NO, JND_SEQNO, ACT_NO, JND_DC, JND_AMOUNT, JND_DESC)
select JNL_NO, JND_SEQNO, ACT_NO, JND_DC, JND_AMOUNT, JND_DESC
from TBL_ACNT_JOURNAL_DT
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TBL_ACNT_JOURNAL_DT')
            and   type = 'U')
   drop table TBL_ACNT_JOURNAL_DT
go

create table TBL_ACNT_JOURNAL_DT
(
    JNL_NO                 varchar(20)           not null,
    JND_SEQNO              numeric               not null,
    ACT_NO                 varchar(20)           not null,
    JND_DC                 char(1)               not null,
    JND_AMOUNT             money                 not null,
    JND_DESC               varchar(200)          null    ,
    constraint PK_TBL_ACNT_JOURNAL_DT primary key (JNL_NO, JND_SEQNO)
)
go

insert into TBL_ACNT_JOURNAL_DT (JNL_NO, JND_SEQNO, ACT_NO, JND_DC, JND_AMOUNT, JND_DESC)
select JNL_NO, JND_SEQNO, ACT_NO, JND_DC, JND_AMOUNT, JND_DESC
from tmp_TBL_ACNT_JOURNAL_DT
go

if exists (select 1
            from  sysobjects
           where  id = object_id('tmp_TBL_ACNT_JOURNAL_DT')
            and   type = 'U')
   drop table tmp_TBL_ACNT_JOURNAL_DT
go

alter table TBL_ACNT_JOURNAL_DT
    add constraint FK_TBL_ACNT_REF_2113_TBL_ACNT foreign key  (JNL_NO)
       references TBL_ACNT_JOURNAL (JNL_NO)
go

alter table TBL_ACNT_JOURNAL_DT
    add constraint FK_TBL_ACNT_REF_2104_TBL_ACNT foreign key  (ACT_NO)
       references TBL_ACNT_ACCOUNT (ACT_NO)
go

commit
go


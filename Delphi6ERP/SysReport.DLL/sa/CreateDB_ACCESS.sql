drop table TBLSYSREPORTFIELD;

drop table TBLSYSREPORT;

create table TBLSYSREPORT
(
    SRP_ID                Long                  not null,
    SRP_CODE              Text(20)              not null,
    SRP_NAME              Text(80)              not null,
    SRP_DESCRIPTION       Text(255)             null    ,
    SRP_SELECT            Memo                  not null,
    SRP_WHERE             Memo                  null    ,
    SRP_GROUPBY           Memo                  null    ,
    SRP_ORDERBY           Memo                  null    ,
    SRP_PRESCRIPT         Memo                  null    ,
    SRP_POSTSCRIPT        Memo                  null    ,
    SRP_REPORTFILE        LongBinary            null    ,
    constraint AK_SRP_CODE_TBLSYSREPORT unique (SRP_CODE)
);

create table TBLSYSREPORTFIELD
(
    SRP_ID                Long                  not null,
    SRF_SEQNO             Long                  not null,
    SRF_FIELDNAME         Text(80)              not null,
    SRF_DISPNAME          Text(80)              not null,
    SRF_TABLEALIAS        Text(80)              not null,
    SRF_DISPORDER         Long                  not null,
    SRF_DATATYPE          Text(20)              null    ,
    SRF_CONTROLTYPE       Text(20)              not null,
    SRF_QUERYTYPE         Text(20)              not null,
    SRF_ISMUSTCRITERIA    YesNo                 not null,
    SRF_ISWHERE           YesNo                 not null,
    SRF_ISSORT            YesNo                 not null,
    SRF_SORTDEC           YesNo                 null    ,
    SRF_LIST_VALUE        Memo                  null    ,
    SRF_LIST_SQL          Memo                  null    ,
    SRF_LIST_RETURNFIELD  Text(80)              null    ,
    SRF_LIST_FIELDDISP    Memo                  null    
);

alter table TBLSYSREPORTFIELD
    add constraint FK_TBLSYSREPORTFIELD_REF_1800_ foreign key  (SRP_ID)
       references TBLSYSREPORT (SRP_ID);


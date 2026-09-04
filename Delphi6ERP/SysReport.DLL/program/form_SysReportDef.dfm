object fm_SysReportDef: Tfm_SysReportDef
  Left = 70
  Top = 49
  Width = 665
  Height = 484
  Caption = #22577#34920#35373#35336
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #32048#26126#39636
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 16
  object DBGrid1: TDBGrid
    Left = 0
    Top = 41
    Width = 657
    Height = 356
    Align = alClient
    DataSource = dsSysReport
    TabOrder = 0
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = #32048#26126#39636
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'SRP_ID'
        Width = 56
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SRP_CODE'
        Width = 123
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SRP_NAME'
        Width = 160
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SRP_DESCRIPTION'
        Width = 157
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SRP_PRESCRIPT'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SRP_SELECT'
        Width = 130
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SRP_WHERE'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SRP_GROUPBY'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SRP_ORDERBY'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SRP_POSTSCRIPT'
        Visible = True
      end>
  end
  object DBNavigator1: TDBNavigator
    Left = 0
    Top = 397
    Width = 657
    Height = 25
    DataSource = dsSysReport
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbRefresh]
    Align = alBottom
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 422
    Width = 657
    Height = 35
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 2
    object BtnAppend: TButton
      Left = 8
      Top = 4
      Width = 60
      Height = 25
      Caption = #26032#22686
      TabOrder = 0
      OnClick = BtnAppendClick
    end
    object BtnModify: TButton
      Left = 72
      Top = 4
      Width = 60
      Height = 25
      Caption = #20462#25913
      TabOrder = 1
      OnClick = BtnModifyClick
    end
    object BtnDelete: TButton
      Left = 140
      Top = 4
      Width = 60
      Height = 25
      Caption = #21034#38500
      TabOrder = 2
      OnClick = BtnDeleteClick
    end
    object BtnFieldDef: TButton
      Left = 432
      Top = 4
      Width = 117
      Height = 25
      Caption = #26597#35426#27396#20301#23450#32681
      TabOrder = 3
      OnClick = BtnFieldDefClick
    end
    object BtnRepDesign: TButton
      Left = 556
      Top = 4
      Width = 89
      Height = 25
      Caption = #22577#34920#35373#35336
      TabOrder = 4
      OnClick = BtnRepDesignClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 657
    Height = 41
    Align = alTop
    BevelOuter = bvLowered
    TabOrder = 3
    object BtnExport: TButton
      Left = 16
      Top = 8
      Width = 75
      Height = 25
      Caption = #21295#20986
      TabOrder = 0
      OnClick = BtnExportClick
    end
    object BtnImport: TButton
      Left = 96
      Top = 8
      Width = 75
      Height = 25
      Caption = #21295#20837
      TabOrder = 1
      OnClick = BtnImportClick
    end
    object Button1: TButton
      Left = 264
      Top = 8
      Width = 75
      Height = 25
      Caption = #35079#35069#22577#34920
      TabOrder = 2
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 572
      Top = 8
      Width = 75
      Height = 25
      Caption = #28204#35430
      TabOrder = 3
      OnClick = Button2Click
    end
  end
  object lbSQL_CreateAccess: TListBox
    Left = 608
    Top = 92
    Width = 33
    Height = 29
    Enabled = False
    ItemHeight = 16
    Items.Strings = (
      'create table TBLSYSREPORT'
      '('
      '    SRP_ID                Long                  not null,'
      '    SRP_CODE              Text(20)              not null,'
      '    SRP_NAME              Text(80)              not null,'
      '    SRP_DESCRIPTION       Text(255)             null    ,'
      '    SRP_SELECT            Memo                  not null,'
      '    SRP_WHERE             Memo                  null    ,'
      '    SRP_GROUPBY           Memo                  null    ,'
      '    SRP_ORDERBY           Memo                  null    ,'
      '    SRP_PRESCRIPT         Memo                  null    ,'
      '    SRP_POSTSCRIPT        Memo                  null    ,'
      '    SRP_REPORTFILE        LongBinary            null    ,'
      '    constraint AK_SRP_CODE_TBLSYSREPORT unique (SRP_CODE)'
      ');'
      ''
      'create table TBLSYSREPORTFIELD'
      '('
      '    SRP_ID                Long                  not null,'
      '    SRF_SEQNO             Long                  not null,'
      '    SRF_FIELDNAME         Text(80)              not null,'
      '    SRF_DISPNAME          Text(80)              not null,'
      '    SRF_TABLEALIAS        Text(80)              not null,'
      '    SRF_DISPORDER         Long                  not null,'
      '    SRF_DATATYPE          Text(20)              null    ,'
      '    SRF_CONTROLTYPE       Text(20)              not null,'
      '    SRF_QUERYTYPE         Text(20)              not null,'
      '    SRF_ISMUSTCRITERIA    YesNo                 not null,'
      '    SRF_ISWHERE           YesNo                 not null,'
      '    SRF_ISSORT            YesNo                 not null,'
      '    SRF_SORTDEC           YesNo                 null    ,'
      '    SRF_LIST_VALUE        Memo                  null    ,'
      '    SRF_LIST_SQL          Memo                  null    ,'
      '    SRF_LIST_RETURNFIELD  Text(80)              null    ,'
      '    SRF_LIST_FIELDDISP    Memo                  null    '
      ');'
      ''
      'alter table TBLSYSREPORTFIELD'
      
        '    add constraint FK_TBLSYSREPORTFIELD_REF_1800_ foreign key  (' +
        'SRP_ID)'
      '       references TBLSYSREPORT (SRP_ID);'
      '')
    TabOrder = 4
    Visible = False
  end
  object lbSQL_CreateSQL: TListBox
    Left = 608
    Top = 124
    Width = 33
    Height = 29
    Enabled = False
    ItemHeight = 16
    Items.Strings = (
      'create table TBLSYSREPORT'
      '('
      '    SRP_ID                int                   not null,'
      '    SRP_CODE              varchar(20)           not null,'
      '    SRP_NAME              varchar(80)           not null,'
      '    SRP_DESCRIPTION       varchar(255)          null    ,'
      '    SRP_SELECT            text                  not null,'
      '    SRP_WHERE             text                  null    ,'
      '    SRP_GROUPBY           text                  null    ,'
      '    SRP_ORDERBY           text                  null    ,'
      '    SRP_PRESCRIPT         text                  null    ,'
      '    SRP_POSTSCRIPT        text                  null    ,'
      '    SRP_REPORTFILE        image                 null    ,'
      '    constraint PK_TBLSYSREPORT primary key (SRP_ID),'
      '    constraint AK_SRP_CODE_TBLSYSRE unique (SRP_CODE)'
      ');'
      'create table TBLSYSREPORTFIELD'
      '('
      '    SRP_ID                int                   not null,'
      '    SRF_SEQNO             int                   not null,'
      '    SRF_FIELDNAME         varchar(80)           not null,'
      '    SRF_DISPNAME          varchar(80)           not null,'
      '    SRF_TABLEALIAS        varchar(80)           not null,'
      '    SRF_DISPORDER         int                   not null,'
      '    SRF_DATATYPE          varchar(20)           null    ,'
      '    SRF_CONTROLTYPE       varchar(20)           not null,'
      '    SRF_QUERYTYPE         varchar(20)           not null,'
      '    SRF_ISMUSTCRITERIA    bit                   not null,'
      '    SRF_ISWHERE           bit                   not null,'
      '    SRF_ISSORT            bit                   not null,'
      '    SRF_SORTDEC           bit                   null    ,'
      '    SRF_LIST_VALUE        text                  null    ,'
      '    SRF_LIST_SQL          text                  null    ,'
      '    SRF_LIST_RETURNFIELD  varchar(80)           null    ,'
      '    SRF_LIST_FIELDDISP    text                  null    ,'
      
        '    constraint PK_TBLSYSREPORTFIELD primary key (SRP_ID, SRF_SEQ' +
        'NO)'
      ');'
      ''
      'alter table TBLSYSREPORTFIELD'
      
        '    add constraint FK_TBLSYSRE_REF_1800_TBLSYSRE foreign key  (S' +
        'RP_ID)'
      '       references TBLSYSREPORT (SRP_ID);'
      ''
      ''
      '')
    TabOrder = 5
    Visible = False
  end
  object lbSQL_CreateOracle: TListBox
    Left = 608
    Top = 156
    Width = 33
    Height = 29
    Enabled = False
    ItemHeight = 16
    Items.Strings = (
      'create table TBLSYSREPORT'
      '('
      '    SRP_ID                INTEGER                not null,'
      '    SRP_CODE              VARCHAR2(20)           not null,'
      '    SRP_NAME              VARCHAR2(80)           not null,'
      '    SRP_DESCRIPTION       VARCHAR2(255)          null    ,'
      '    SRP_SELECT            VARCHAR2(4000)         not null,'
      '    SRP_WHERE             VARCHAR2(4000)         null    ,'
      '    SRP_GROUPBY           VARCHAR2(4000)         null    ,'
      '    SRP_ORDERBY           VARCHAR2(4000)         null    ,'
      '    SRP_PRESCRIPT         VARCHAR2(4000)         null    ,'
      '    SRP_POSTSCRIPT        VARCHAR2(4000)         null    ,'
      '    SRP_REPORTFILE        LONG RAW               null    ,'
      '    constraint PK_TBLSYSREPORT primary key (SRP_ID),'
      '    constraint AK_SRP_CODE_TBLSYSRE unique (SRP_CODE)'
      ');'
      'create table TBLSYSREPORTFIELD'
      '('
      '    SRP_ID                INTEGER                not null,'
      '    SRF_SEQNO             INTEGER                not null,'
      '    SRF_FIELDNAME         VARCHAR2(80)           not null,'
      '    SRF_DISPNAME          VARCHAR2(80)           not null,'
      '    SRF_TABLEALIAS        VARCHAR2(80)           not null,'
      '    SRF_DISPORDER         INTEGER                not null,'
      '    SRF_DATATYPE          VARCHAR2(20)           null    ,'
      '    SRF_CONTROLTYPE       VARCHAR2(20)           not null,'
      '    SRF_QUERYTYPE         VARCHAR2(20)           not null,'
      '    SRF_ISMUSTCRITERIA    NUMBER(1)              not null,'
      '    SRF_ISWHERE           NUMBER(1)              not null,'
      '    SRF_ISSORT            NUMBER(1)              not null,'
      '    SRF_SORTDEC           NUMBER(1)              null    ,'
      '    SRF_LIST_VALUE        VARCHAR2(4000)         null    ,'
      '    SRF_LIST_SQL          VARCHAR2(4000)         null    ,'
      '    SRF_LIST_RETURNFIELD  VARCHAR2(80)           null    ,'
      '    SRF_LIST_FIELDDISP    VARCHAR2(4000)         null    ,'
      
        '    constraint PK_TBLSYSREPORTFIELD primary key (SRP_ID, SRF_SEQ' +
        'NO)'
      ');'
      'alter table TBLSYSREPORTFIELD'
      
        '    add constraint FK_TBLSYSRE_REF_1828_TBLSYSRE foreign key  (S' +
        'RP_ID)'
      '       references TBLSYSREPORT (SRP_ID);'
      ''
      ''
      '')
    TabOrder = 6
    Visible = False
  end
  object qrySysReport: TADOQuery
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT SRP_ID ,SRP_CODE ,SRP_NAME ,SRP_DESCRIPTION,'
      'SRP_SELECT ,SRP_WHERE ,SRP_GROUPBY ,SRP_ORDERBY,'
      'SRP_PRESCRIPT ,SRP_POSTSCRIPT'
      'FROM TBLSYSREPORT'
      'ORDER BY SRP_CODE')
    Left = 16
    Top = 120
  end
  object dsSysReport: TDataSource
    AutoEdit = False
    DataSet = qrySysReport
    Left = 48
    Top = 120
  end
  object QryTemplate: TADOQuery
    Parameters = <>
    Left = 24
    Top = 252
  end
  object QryReportData: TADOQuery
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM TBLTRANSACTION')
    Left = 24
    Top = 288
  end
  object dsTemplate: TDataSource
    DataSet = QryTemplate
    Left = 60
    Top = 252
  end
  object dsReportData: TDataSource
    DataSet = QryReportData
    Left = 60
    Top = 288
  end
  object plTemplate: TppDBPipeline
    DataSource = dsTemplate
    UserName = 'plTemplate'
    Left = 96
    Top = 252
  end
  object plReportData: TppDBPipeline
    DataSource = dsReportData
    RangeEndCount = 5
    UserName = 'plReportData'
    Left = 96
    Top = 288
    object plReportDatappField1: TppField
      Alignment = taRightJustify
      FieldAlias = 'TRN_ID'
      FieldName = 'TRN_ID'
      FieldLength = 0
      DataType = dtInteger
      DisplayWidth = 0
      Position = 0
    end
    object plReportDatappField2: TppField
      FieldAlias = 'TRN_CODE'
      FieldName = 'TRN_CODE'
      FieldLength = 20
      DisplayWidth = 20
      Position = 1
    end
    object plReportDatappField3: TppField
      FieldAlias = 'TRN_TYPE'
      FieldName = 'TRN_TYPE'
      FieldLength = 20
      DisplayWidth = 20
      Position = 2
    end
    object plReportDatappField4: TppField
      FieldAlias = 'USR_CODE'
      FieldName = 'USR_CODE'
      FieldLength = 20
      DisplayWidth = 20
      Position = 3
    end
    object plReportDatappField5: TppField
      FieldAlias = 'TRN_DATETIME'
      FieldName = 'TRN_DATETIME'
      FieldLength = 0
      DataType = dtDateTime
      DisplayWidth = 18
      Position = 4
    end
    object plReportDatappField6: TppField
      FieldAlias = 'TRN_STATUS'
      FieldName = 'TRN_STATUS'
      FieldLength = 20
      DisplayWidth = 20
      Position = 5
    end
    object plReportDatappField7: TppField
      FieldAlias = 'TRN_MEMO'
      FieldName = 'TRN_MEMO'
      FieldLength = 160
      DisplayWidth = 160
      Position = 6
    end
  end
  object ppReport: TppReport
    AutoStop = False
    DataPipeline = plReportData
    PrinterSetup.BinName = 'Default'
    PrinterSetup.DocumentName = 'Report'
    PrinterSetup.PaperName = 'Letter'
    PrinterSetup.PrinterName = 'Default'
    PrinterSetup.mmMarginBottom = 6350
    PrinterSetup.mmMarginLeft = 6350
    PrinterSetup.mmMarginRight = 6350
    PrinterSetup.mmMarginTop = 6350
    PrinterSetup.mmPaperHeight = 279401
    PrinterSetup.mmPaperWidth = 215900
    PrinterSetup.PaperSize = 1
    Template.DatabaseSettings.DataPipeline = plTemplate
    Template.SaveTo = stDatabase
    AllowPrintToFile = True
    DeviceType = 'Screen'
    Left = 132
    Top = 288
    Version = '6.02'
    mmColumnWidth = 0
    DataPipelineName = 'plReportData'
    object ppHeaderBand1: TppHeaderBand
      mmBottomOffset = 0
      mmHeight = 11642
      mmPrintPosition = 0
    end
    object ppDetailBand1: TppDetailBand
      mmBottomOffset = 0
      mmHeight = 12700
      mmPrintPosition = 0
    end
    object ppFooterBand1: TppFooterBand
      mmBottomOffset = 0
      mmHeight = 13229
      mmPrintPosition = 0
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'XML'
    FileName = 'TBLSYSREPORT.XML'
    Filter = 'TBLSYSREPORT.XML|TBLSYSREPORT.XML'
    Options = [ofReadOnly, ofHideReadOnly, ofEnableSizing]
    Left = 180
    Top = 8
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'xml'
    FileName = 'TBLSYSREPORT.XML'
    Filter = 'TBLSYSREPORT.XML|TBLSYSREPORT.XML'
    Left = 220
    Top = 8
  end
  object ppDesigner: TppDesigner
    Caption = 'ReportBuilder'
    DataSettings.SessionType = 'BDESession'
    DataSettings.AllowEditSQL = False
    DataSettings.SQLType = sqBDELocal
    Position = poScreenCenter
    Report = ppReport
    IniStorageType = 'IniFile'
    IniStorageName = '($WINSYS)\RBuilder.ini'
    WindowHeight = 400
    WindowLeft = 100
    WindowTop = 50
    WindowWidth = 600
    Left = 164
    Top = 288
  end
end

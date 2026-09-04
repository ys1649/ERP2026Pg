object fm_FormReport: Tfm_FormReport
  Left = 299
  Top = 196
  Width = 557
  Height = 326
  Caption = #34920#21934#22577#34920
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 266
    Width = 549
    Height = 33
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 0
    object BtnPreview: TButton
      Left = 4
      Top = 4
      Width = 75
      Height = 25
      Caption = #38928#35261
      TabOrder = 0
      OnClick = BtnPreviewClick
    end
    object BtnExportExcel: TButton
      Left = 84
      Top = 4
      Width = 85
      Height = 25
      Caption = #21295#20986'Excel'
      TabOrder = 1
      Visible = False
    end
    object BtnClose: TButton
      Left = 468
      Top = 4
      Width = 75
      Height = 25
      Caption = #38626#38283
      TabOrder = 2
      OnClick = BtnCloseClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 549
    Height = 33
    Align = alTop
    BevelOuter = bvLowered
    TabOrder = 1
    object btnNew: TButton
      Left = 4
      Top = 4
      Width = 65
      Height = 25
      Caption = #26032#22686
      TabOrder = 0
      OnClick = btnNewClick
    end
    object btnCopy: TButton
      Left = 74
      Top = 4
      Width = 65
      Height = 25
      Caption = #35079#35069
      TabOrder = 1
      OnClick = btnCopyClick
    end
    object btnDelete: TButton
      Left = 215
      Top = 4
      Width = 65
      Height = 25
      Caption = #21034#38500
      TabOrder = 2
      OnClick = btnDeleteClick
    end
    object btnDesign: TButton
      Left = 468
      Top = 4
      Width = 75
      Height = 25
      Caption = #35373#35336#22577#34920
      TabOrder = 3
      OnClick = btnDesignClick
    end
    object btnRename: TButton
      Left = 145
      Top = 4
      Width = 65
      Height = 25
      Caption = #26356#21517
      TabOrder = 4
      OnClick = btnRenameClick
    end
    object btnExport: TButton
      Left = 286
      Top = 4
      Width = 65
      Height = 25
      Caption = #21295#20986
      TabOrder = 5
      OnClick = btnExportClick
    end
    object BtnImport: TButton
      Left = 356
      Top = 4
      Width = 65
      Height = 25
      Caption = #21295#20837
      TabOrder = 6
      OnClick = BtnImportClick
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 33
    Width = 549
    Height = 233
    Align = alClient
    DataSource = dsFormReport
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'FRP_REPORTNAME'
        Visible = True
      end>
  end
  object QryReportData: TADOQuery
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM TBLTRANSACTION')
    Left = 320
    Top = 208
  end
  object dsReportData: TDataSource
    DataSet = QryReportData
    Left = 356
    Top = 208
  end
  object plReportData: TppDBPipeline
    DataSource = dsReportData
    RangeEndCount = 5
    UserName = 'plReportData'
    Left = 392
    Top = 208
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
    DeviceType = 'ExcelFile'
    OnPreviewFormCreate = ppReportPreviewFormCreate
    Left = 428
    Top = 208
    Version = '6.02'
    mmColumnWidth = 0
    DataPipelineName = 'plReportData'
    object ppHeaderBand1: TppHeaderBand
      mmBottomOffset = 0
      mmHeight = 11377
      mmPrintPosition = 0
    end
    object ppDetailBand1: TppDetailBand
      mmBottomOffset = 0
      mmHeight = 10583
      mmPrintPosition = 0
    end
    object ppFooterBand1: TppFooterBand
      mmBottomOffset = 0
      mmHeight = 13229
      mmPrintPosition = 0
    end
  end
  object QryTemplate: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 320
    Top = 172
  end
  object dsTemplate: TDataSource
    DataSet = QryTemplate
    Left = 356
    Top = 172
  end
  object plTemplate: TppDBPipeline
    DataSource = dsTemplate
    UserName = 'plTemplate'
    Left = 392
    Top = 172
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'XLS'
    Filter = 'Excel File|*.xls'
    Left = 464
    Top = 172
  end
  object ExtraOptions1: TExtraOptions
    HTML.BackLink = '&lt&lt'
    HTML.ForwardLink = '&gt&gt'
    HTML.ShowLinks = True
    HTML.UseTextFileName = False
    HTML.ZoomableImages = False
    HTML.PixelFormat = pf8bit
    HTML.Visible = True
    CSS2.BackLink = '&lt&lt'
    CSS2.ForwardLink = '&gt&gt'
    CSS2.ShowLinks = True
    CSS2.UseTextFileName = False
    CSS2.ZoomableImages = False
    CSS2.Visible = True
    CSS2.PixelFormat = pf8bit
    RTF.Visible = True
    Lotus.Visible = True
    Quattro.Visible = True
    Excel.Visible = True
    Graphic.PixelFormat = pf8bit
    Graphic.UseTextFileName = False
    Graphic.Visible = True
    PDF.Creator = 'TExtraDevices'
    PDF.Author = 'TExtraDevices'
    PDF.FastCompression = False
    PDF.CompressImages = True
    PDF.ScaleImages = True
    PDF.Visible = True
    Left = 500
    Top = 208
  end
  object qryFormReport: TADOQuery
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT *'
      'FROM TBLFORMREPORT A'
      'WHERE A.FRP_FORMNAME='#39#39
      #9'AND A.FRP_REPORTNAME='#39#39)
    Left = 320
    Top = 136
    object qryFormReportFRP_FORMNAME: TStringField
      FieldName = 'FRP_FORMNAME'
      Size = 80
    end
    object qryFormReportFRP_REPORTNAME: TStringField
      DisplayLabel = #22577#34920#21517#31281
      FieldName = 'FRP_REPORTNAME'
      Size = 80
    end
    object qryFormReportFRP_REPORTFILE: TBlobField
      FieldName = 'FRP_REPORTFILE'
    end
    object qryFormReportFRP_SYSDEFAULT: TBooleanField
      FieldName = 'FRP_SYSDEFAULT'
    end
  end
  object dsFormReport: TDataSource
    AutoEdit = False
    DataSet = qryFormReport
    Left = 356
    Top = 136
  end
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=erp;Persist Security Info=True;User' +
      ' ID=erp;Initial Catalog=ERP_STONE;Data Source=(local)'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 268
    Top = 136
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
    Left = 464
    Top = 208
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'XML'
    FileName = 'TBLFORMREPORT.XML'
    Filter = 'TBLFORMREPORT.XML|TBLFORMREPORT.XML'
    Options = [ofReadOnly, ofHideReadOnly, ofEnableSizing]
    Left = 40
    Top = 64
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'xml'
    FileName = 'TBLFORMREPORT.XML'
    Filter = 'TBLFORMREPORT.XML|TBLFORMREPORT.XML'
    Left = 80
    Top = 64
  end
end

object fm_SysReportQuery: Tfm_SysReportQuery
  Left = 253
  Top = 210
  Width = 276
  Height = 129
  Caption = 'fm_SysReportQuery'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  WindowState = wsMaximized
  PixelsPerInch = 96
  TextHeight = 13
  object QryReportData: TADOQuery
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM TBLTRANSACTION')
    Left = 12
    Top = 44
  end
  object dsReportData: TDataSource
    DataSet = QryReportData
    Left = 48
    Top = 44
  end
  object plReportData: TppDBPipeline
    DataSource = dsReportData
    RangeEndCount = 5
    UserName = 'plReportData'
    Left = 84
    Top = 44
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
    Left = 120
    Top = 44
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
    Parameters = <>
    Left = 12
    Top = 8
  end
  object dsTemplate: TDataSource
    DataSet = QryTemplate
    Left = 48
    Top = 8
  end
  object plTemplate: TppDBPipeline
    DataSource = dsTemplate
    UserName = 'plTemplate'
    Left = 84
    Top = 8
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'XLS'
    Filter = 'Excel File|*.xls'
    Left = 156
    Top = 8
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
    Left = 156
    Top = 48
  end
end

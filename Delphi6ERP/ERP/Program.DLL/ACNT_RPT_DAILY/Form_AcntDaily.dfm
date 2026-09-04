object Fm_AcntDaily: TFm_AcntDaily
  Left = 441
  Top = 374
  Width = 554
  Height = 166
  Caption = #26085#35352#24115
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = #32048#26126#39636
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 19
  object Label1: TLabel
    Left = 4
    Top = 36
    Width = 120
    Height = 19
    Caption = #20659#31080#25130#27490#26085#26399
  end
  object Label2: TLabel
    Left = 308
    Top = 36
    Width = 20
    Height = 19
    Caption = #65374
  end
  object dt1: TwwDBDateTimePicker
    Left = 128
    Top = 32
    Width = 173
    Height = 27
    CalendarAttributes.Font.Charset = DEFAULT_CHARSET
    CalendarAttributes.Font.Color = clWindowText
    CalendarAttributes.Font.Height = -11
    CalendarAttributes.Font.Name = 'MS Sans Serif'
    CalendarAttributes.Font.Style = []
    Epoch = 1950
    ShowButton = True
    TabOrder = 0
  end
  object Button1: TButton
    Left = 232
    Top = 88
    Width = 75
    Height = 25
    Caption = #38928#35261
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 328
    Top = 88
    Width = 75
    Height = 25
    Caption = #38626#38283
    TabOrder = 2
    OnClick = Button2Click
  end
  object dt2: TwwDBDateTimePicker
    Left = 336
    Top = 32
    Width = 173
    Height = 27
    CalendarAttributes.Font.Charset = DEFAULT_CHARSET
    CalendarAttributes.Font.Color = clWindowText
    CalendarAttributes.Font.Height = -11
    CalendarAttributes.Font.Name = 'MS Sans Serif'
    CalendarAttributes.Font.Style = []
    Epoch = 1950
    ShowButton = True
    TabOrder = 3
  end
  object qryReport: TADOQuery
    CursorType = ctStatic
    ParamCheck = False
    Parameters = <>
    SQL.Strings = (
      'SELECT'
      'CONVERT (DATETIME,FLOOR(CONVERT(FLOAT,A.JNL_DATE))) JNL_DATE'
      ',A.JNL_NO'
      ',B.ACT_NO,B.JND_DESC'
      ', DC = CASE '
      #9#9'WHEN B.JND_AMOUNT >=0 THEN '#39#20511#39
      #9#9'ELSE '#39#36024#39
      #9'END'#9
      ','#9'ACT_NAME = CASE '
      #9#9'WHEN B.JND_AMOUNT >=0 THEN C.ACT_NAME'
      #9#9'ELSE '#39#12288#12288#39'+C.ACT_NAME'
      #9'END'
      ', JND_AMOUNT = CASE '
      #9#9'WHEN B.JND_AMOUNT >=0 THEN B.JND_AMOUNT'
      #9#9'ELSE B.JND_AMOUNT * -1'
      #9'END'
      'FROM TBL_ACNT_JOURNAL A'
      'INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO'
      'INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO'
      'WHERE A.JNL_DATE >='#39'01/01/2003'#39
      #9'AND A.JNL_DATE <'#39'01/01/2004'#39
      'ORDER BY A.JNL_DATE,A.JNL_NO,B.JND_SEQNO')
  end
  object dsReport: TDataSource
    DataSet = qryReport
    Left = 32
  end
  object ppDBPipeline1: TppDBPipeline
    DataSource = dsReport
    UserName = 'DBPipeline1'
    Left = 64
    object ppDBPipeline1ppField1: TppField
      FieldAlias = 'JNL_DATE'
      FieldName = 'JNL_DATE'
      FieldLength = 0
      DataType = dtDateTime
      DisplayWidth = 0
      Position = 0
    end
    object ppDBPipeline1ppField2: TppField
      FieldAlias = 'JNL_NO'
      FieldName = 'JNL_NO'
      FieldLength = 20
      DisplayWidth = 20
      Position = 1
    end
    object ppDBPipeline1ppField3: TppField
      FieldAlias = 'ACT_NO'
      FieldName = 'ACT_NO'
      FieldLength = 20
      DisplayWidth = 20
      Position = 2
    end
    object ppDBPipeline1ppField4: TppField
      FieldAlias = 'JND_DESC'
      FieldName = 'JND_DESC'
      FieldLength = 200
      DisplayWidth = 200
      Position = 3
    end
    object ppDBPipeline1ppField5: TppField
      FieldAlias = 'DC'
      FieldName = 'DC'
      FieldLength = 2
      DisplayWidth = 2
      Position = 4
    end
    object ppDBPipeline1ppField6: TppField
      FieldAlias = 'ACT_NAME'
      FieldName = 'ACT_NAME'
      FieldLength = 84
      DisplayWidth = 84
      Position = 5
    end
    object ppDBPipeline1ppField7: TppField
      Alignment = taRightJustify
      FieldAlias = 'JND_AMOUNT'
      FieldName = 'JND_AMOUNT'
      FieldLength = 4
      DataType = dtDouble
      DisplayWidth = 20
      Position = 6
    end
  end
  object ppReport: TppReport
    AutoStop = False
    DataPipeline = ppDBPipeline1
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
    DeviceType = 'Screen'
    OnPreviewFormCreate = ppReportPreviewFormCreate
    Left = 96
    Version = '6.02'
    mmColumnWidth = 0
    DataPipelineName = 'ppDBPipeline1'
    object ppHeaderBand1: TppHeaderBand
      mmBottomOffset = 0
      mmHeight = 44450
      mmPrintPosition = 0
      object ppLabel8: TppLabel
        UserName = 'Label8'
        Caption = #35069#34920#26085#26399#65306
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 12
        Font.Style = []
        Transparent = True
        mmHeight = 5080
        mmLeft = 9790
        mmTop = 21696
        mmWidth = 21167
        BandType = 0
      end
      object ppSystemVariable1: TppSystemVariable
        UserName = 'SystemVariable1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 12
        Font.Style = []
        Transparent = True
        mmHeight = 5027
        mmLeft = 32279
        mmTop = 21696
        mmWidth = 24871
        BandType = 0
      end
      object ppLabel9: TppLabel
        UserName = 'Label9'
        Caption = #38913#25976#65306
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 12
        Font.Style = []
        Transparent = True
        mmHeight = 5027
        mmLeft = 159015
        mmTop = 21696
        mmWidth = 12700
        BandType = 0
      end
      object ppSystemVariable2: TppSystemVariable
        UserName = 'SystemVariable2'
        VarType = vtPageSetDesc
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 12
        Font.Style = []
        Transparent = True
        mmHeight = 5027
        mmLeft = 172773
        mmTop = 21696
        mmWidth = 23283
        BandType = 0
      end
      object ppLine2: TppLine
        UserName = 'Line2'
        ParentWidth = True
        Position = lpBottom
        Weight = 0.75
        mmHeight = 1852
        mmLeft = 0
        mmTop = 34660
        mmWidth = 203200
        BandType = 0
      end
      object ppLabel1: TppLabel
        UserName = 'Label1'
        Caption = #26085#35352#24115
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 12
        Font.Style = []
        TextAlignment = taCentered
        Transparent = True
        mmHeight = 5080
        mmLeft = 92076
        mmTop = 21696
        mmWidth = 12700
        BandType = 0
      end
      object ppLabel2: TppLabel
        UserName = 'Label2'
        Caption = #26085#26399
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 10
        Font.Style = []
        TextAlignment = taCentered
        Transparent = True
        mmHeight = 4233
        mmLeft = 10583
        mmTop = 37835
        mmWidth = 7144
        BandType = 0
      end
      object ppLine1: TppLine
        UserName = 'Line1'
        ParentWidth = True
        Position = lpBottom
        Weight = 0.75
        mmHeight = 2117
        mmLeft = 0
        mmTop = 41010
        mmWidth = 203200
        BandType = 0
      end
      object ppLabel5: TppLabel
        UserName = 'Label5'
        Caption = #20659#31080#26399#38291#65306
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 12
        Font.Style = []
        Transparent = True
        mmHeight = 5027
        mmLeft = 9790
        mmTop = 28310
        mmWidth = 21167
        BandType = 0
      end
      object ppLblPeriod: TppLabel
        UserName = 'LblPeriod'
        Caption = 'ppLblPeriod'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 12
        Font.Style = []
        Transparent = True
        mmHeight = 5080
        mmLeft = 32279
        mmTop = 28310
        mmWidth = 23283
        BandType = 0
      end
      object ppLblCorName: TppLabel
        UserName = 'LblCorName'
        AutoSize = False
        Caption = 'LblCorName'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 12
        Font.Style = []
        TextAlignment = taCentered
        Transparent = True
        mmHeight = 5080
        mmLeft = 794
        mmTop = 11113
        mmWidth = 201084
        BandType = 0
      end
      object ppLabel7: TppLabel
        UserName = 'Label7'
        Caption = #37329#38989
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4233
        mmLeft = 191030
        mmTop = 37835
        mmWidth = 7144
        BandType = 0
      end
      object ppLabel4: TppLabel
        UserName = 'Label4'
        Caption = #25688#35201
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 10
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 4233
        mmLeft = 123296
        mmTop = 37835
        mmWidth = 7144
        BandType = 0
      end
      object ppLabel10: TppLabel
        UserName = 'Label10'
        Caption = #20659#31080#32232#34399
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4233
        mmLeft = 33602
        mmTop = 37835
        mmWidth = 14288
        BandType = 0
      end
      object ppLabel3: TppLabel
        UserName = 'Label3'
        Caption = #20511#36024
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 10
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 4233
        mmLeft = 60854
        mmTop = 37835
        mmWidth = 7144
        BandType = 0
      end
      object ppLabel6: TppLabel
        UserName = 'Label101'
        Caption = #31185#30446#32232#34399
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4233
        mmLeft = 69850
        mmTop = 37835
        mmWidth = 14288
        BandType = 0
      end
      object ppLabel11: TppLabel
        UserName = 'Label102'
        Caption = #31185#30446#21517#31281
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4233
        mmLeft = 88106
        mmTop = 37835
        mmWidth = 14288
        BandType = 0
      end
    end
    object ppDetailBand1: TppDetailBand
      mmBottomOffset = 0
      mmHeight = 6615
      mmPrintPosition = 0
      object ppDBText3: TppDBText
        UserName = 'DBText3'
        DataField = 'JNL_DATE'
        DataPipeline = ppDBPipeline1
        DisplayFormat = 'YYYY/MM/DD'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 10
        Font.Style = []
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 4233
        mmLeft = 9790
        mmTop = 1323
        mmWidth = 20902
        BandType = 4
      end
      object ppDBText5: TppDBText
        UserName = 'DBText5'
        DataField = 'JNL_NO'
        DataPipeline = ppDBPipeline1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 10
        Font.Style = []
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 4233
        mmLeft = 33602
        mmTop = 1323
        mmWidth = 25400
        BandType = 4
      end
      object ppDBText7: TppDBText
        UserName = 'DBText7'
        DataField = 'JND_DESC'
        DataPipeline = ppDBPipeline1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 10
        Font.Style = []
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 4233
        mmLeft = 123296
        mmTop = 1323
        mmWidth = 53975
        BandType = 4
      end
      object ppDBText1: TppDBText
        UserName = 'DBText1'
        DataField = 'DC'
        DataPipeline = ppDBPipeline1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 10
        Font.Style = []
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 4233
        mmLeft = 62971
        mmTop = 1323
        mmWidth = 5027
        BandType = 4
      end
      object ppDBText2: TppDBText
        UserName = 'DBText2'
        DataField = 'ACT_NO'
        DataPipeline = ppDBPipeline1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 10
        Font.Style = []
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 4233
        mmLeft = 69850
        mmTop = 1323
        mmWidth = 17198
        BandType = 4
      end
      object ppDBText4: TppDBText
        UserName = 'DBText4'
        DataField = 'ACT_NAME'
        DataPipeline = ppDBPipeline1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 10
        Font.Style = []
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 4233
        mmLeft = 88106
        mmTop = 1323
        mmWidth = 33602
        BandType = 4
      end
      object ppDBText6: TppDBText
        UserName = 'DBText6'
        DataField = 'JND_AMOUNT'
        DataPipeline = ppDBPipeline1
        DisplayFormat = '#,0;-#,0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 10
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 4233
        mmLeft = 178594
        mmTop = 1323
        mmWidth = 20638
        BandType = 4
      end
    end
    object ppFooterBand1: TppFooterBand
      mmBottomOffset = 0
      mmHeight = 13229
      mmPrintPosition = 0
    end
    object ppGroup1: TppGroup
      BreakName = 'JNL_DATE'
      DataPipeline = ppDBPipeline1
      NewPage = True
      UserName = 'Group1'
      mmNewColumnThreshold = 0
      mmNewPageThreshold = 0
      DataPipelineName = 'ppDBPipeline1'
      object ppGroupHeaderBand1: TppGroupHeaderBand
        mmBottomOffset = 0
        mmHeight = 0
        mmPrintPosition = 0
      end
      object ppGroupFooterBand1: TppGroupFooterBand
        mmBottomOffset = 0
        mmHeight = 0
        mmPrintPosition = 0
      end
    end
  end
  object qry: TADOQuery
    Parameters = <>
    Left = 128
  end
end

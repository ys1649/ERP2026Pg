object Fm_AcntDetail: TFm_AcntDetail
  Left = 505
  Top = 307
  Width = 414
  Height = 287
  Caption = #26126#32048#20998#39006#24115
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
  object qryReport: TADOQuery
    CursorType = ctStatic
    ParamCheck = False
    Parameters = <>
    SQL.Strings = (
      '--========================================================='
      '--'#9'DateFrom='#39'04/01/2003'#39
      '--'#9'DateTo'#9'='#39'06/01/2003'#39
      '--========================================================='
      
        'SELECT A.JNL_DATE,A.JNL_NO,A.JND_SEQNO,JND_DESC,A.ACT_NO,ACT_NAM' +
        'E,AMOUNT'
      #9#9#9','#39'DEBIT'#39'= CASE'
      #9#9#9#9#9#9#9#9'WHEN AMOUNT>=0 THEN AMOUNT'
      #9#9#9#9#9#9#9#9'ELSE 0'
      #9#9#9#9#9#9#9'END'
      #9#9#9','#39'CREDIT'#39'= CASE'
      #9#9#9#9#9#9#9#9'WHEN AMOUNT<0 THEN -AMOUNT'
      #9#9#9#9#9#9#9#9'ELSE 0'
      #9#9#9#9#9#9#9'END'
      ''
      'FROM'
      
        '('#9'SELECT A.JNL_DATE,A.JNL_NO,B.JND_SEQNO,B.ACT_NO,B.JND_DESC,B.J' +
        'ND_AMOUNT AMOUNT'
      #9'FROM TBL_ACNT_JOURNAL A'
      #9'INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO'
      #9'WHERE A.JNL_DATE >= '#39'04/01/2003'#39
      #9#9'AND A.JNL_DATE < '#39'06/01/2003'#39
      #9'UNION'
      #9'SELECT '#39'04/01/2003'#39' JNL_DATE'
      #9#9#9#9','#39'@@INIT'#39' JNL_NO'
      #9#9#9#9',0 JND_SEQNO'
      #9#9#9#9',ACT_NO'
      #9#9#9#9','#39#26399#21021#37329#38989#39' JND_DESC'
      #9#9#9#9',SUM(AMOUNT) AMOUNT'
      #9'FROM'
      #9'('#9'SELECT A.JNL_NO,B.JND_SEQNO,B.ACT_NO,B.JND_AMOUNT AMOUNT'
      #9#9'FROM TBL_ACNT_JOURNAL A'
      #9#9'INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO'
      
        #9#9'WHERE A.JNL_DATE >= '#39'01/01/'#39'+CAST(YEAR('#39'04/01/2003'#39') AS VARCHA' +
        'R)'
      #9#9#9'AND A.JNL_DATE < '#39'04/01/2003'#39
      #9') A'
      #9'GROUP BY A.ACT_NO'
      ') A INNER JOIN TBL_ACNT_ACCOUNT B ON A.ACT_NO=B.ACT_NO'
      ''
      ' '
      ' ')
    Left = 8
    Top = 8
  end
  object dsReport: TDataSource
    DataSet = qryReport
    Left = 76
    Top = 8
  end
  object ppDBPipeline1: TppDBPipeline
    DataSource = dsReport
    UserName = 'DBPipeline1'
    Left = 152
    Top = 12
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
      Alignment = taRightJustify
      FieldAlias = 'JND_SEQNO'
      FieldName = 'JND_SEQNO'
      FieldLength = 0
      DataType = dtDouble
      DisplayWidth = 19
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
      FieldAlias = 'ACT_NO'
      FieldName = 'ACT_NO'
      FieldLength = 20
      DisplayWidth = 20
      Position = 4
    end
    object ppDBPipeline1ppField6: TppField
      FieldAlias = 'ACT_NAME'
      FieldName = 'ACT_NAME'
      FieldLength = 80
      DisplayWidth = 80
      Position = 5
    end
    object ppDBPipeline1ppField7: TppField
      Alignment = taRightJustify
      FieldAlias = 'AMOUNT'
      FieldName = 'AMOUNT'
      FieldLength = 4
      DataType = dtDouble
      DisplayWidth = 20
      Position = 6
    end
    object ppDBPipeline1ppField8: TppField
      Alignment = taRightJustify
      FieldAlias = 'DEBIT'
      FieldName = 'DEBIT'
      FieldLength = 4
      DataType = dtDouble
      DisplayWidth = 20
      Position = 7
    end
    object ppDBPipeline1ppField9: TppField
      Alignment = taRightJustify
      FieldAlias = 'CREDIT'
      FieldName = 'CREDIT'
      FieldLength = 4
      DataType = dtDouble
      DisplayWidth = 20
      Position = 8
    end
  end
  object ppReport: TppReport
    AutoStop = False
    DataPipeline = ppDBPipeline1
    PrinterSetup.BinName = 'Default'
    PrinterSetup.DocumentName = 'Report'
    PrinterSetup.PaperName = 'Letter 8.5 x 11 '#33521#21515
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
    Left = 228
    Top = 12
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
        Caption = #26126#32048#20998#39006#24115
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 12
        Font.Style = []
        TextAlignment = taCentered
        Transparent = True
        mmHeight = 5027
        mmLeft = 87842
        mmTop = 21696
        mmWidth = 21167
        BandType = 0
      end
      object ppLabel2: TppLabel
        UserName = 'Label2'
        Caption = #26085#26399
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 12
        Font.Style = []
        TextAlignment = taCentered
        Transparent = True
        mmHeight = 5027
        mmLeft = 9790
        mmTop = 36777
        mmWidth = 8467
        BandType = 0
      end
      object ppLabel3: TppLabel
        UserName = 'Label3'
        Caption = #39192#38989
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 12
        Font.Style = []
        TextAlignment = taCentered
        Transparent = True
        mmHeight = 5027
        mmLeft = 187855
        mmTop = 36777
        mmWidth = 8467
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
      object ppLabel6: TppLabel
        UserName = 'Label6'
        Caption = #20511#26041#37329#38989
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 12
        Font.Style = []
        Transparent = True
        mmHeight = 5027
        mmLeft = 129646
        mmTop = 36777
        mmWidth = 16933
        BandType = 0
      end
      object ppLabel7: TppLabel
        UserName = 'Label7'
        Caption = #36024#26041#37329#38989
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 12
        Font.Style = []
        Transparent = True
        mmHeight = 5027
        mmLeft = 154517
        mmTop = 36777
        mmWidth = 16933
        BandType = 0
      end
      object ppLabel4: TppLabel
        UserName = 'Label4'
        Caption = #25688#35201
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 12
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 5027
        mmLeft = 70115
        mmTop = 36777
        mmWidth = 8467
        BandType = 0
      end
      object ppLabel10: TppLabel
        UserName = 'Label10'
        Caption = #20659#31080#32232#34399
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 12
        Font.Style = []
        Transparent = True
        mmHeight = 5027
        mmLeft = 33602
        mmTop = 36777
        mmWidth = 16933
        BandType = 0
      end
    end
    object ppDetailBand1: TppDetailBand
      mmBottomOffset = 0
      mmHeight = 6615
      mmPrintPosition = 0
      object ppDBText4: TppDBText
        UserName = 'DBText4'
        DataField = 'DEBIT'
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
        mmLeft = 124619
        mmTop = 1323
        mmWidth = 21960
        BandType = 4
      end
      object ppDBText6: TppDBText
        UserName = 'DBText6'
        DataField = 'CREDIT'
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
        mmLeft = 149490
        mmTop = 1323
        mmWidth = 21960
        BandType = 4
      end
      object ppDBCalc1: TppDBCalc
        UserName = 'DBCalc1'
        DataField = 'AMOUNT'
        DataPipeline = ppDBPipeline1
        DisplayFormat = '#,0;-#,0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = #32048#26126#39636
        Font.Size = 10
        Font.Style = []
        ResetGroup = ppGroup1
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 4233
        mmLeft = 174361
        mmTop = 1323
        mmWidth = 21960
        BandType = 4
      end
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
        mmWidth = 27517
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
        mmLeft = 64029
        mmTop = 1323
        mmWidth = 59267
        BandType = 4
      end
    end
    object ppFooterBand1: TppFooterBand
      mmBottomOffset = 0
      mmHeight = 13229
      mmPrintPosition = 0
    end
    object ppGroup1: TppGroup
      BreakName = 'ACT_NO'
      DataPipeline = ppDBPipeline1
      NewPage = True
      UserName = 'Group1'
      mmNewColumnThreshold = 0
      mmNewPageThreshold = 0
      DataPipelineName = 'ppDBPipeline1'
      object ppGroupHeaderBand1: TppGroupHeaderBand
        mmBottomOffset = 0
        mmHeight = 9260
        mmPrintPosition = 0
        object ppDBText1: TppDBText
          UserName = 'DBText1'
          DataField = 'ACT_NO'
          DataPipeline = ppDBPipeline1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = #32048#26126#39636
          Font.Size = 12
          Font.Style = [fsBold]
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 5027
          mmLeft = 9790
          mmTop = 3440
          mmWidth = 20902
          BandType = 3
          GroupNo = 0
        end
        object ppDBText2: TppDBText
          UserName = 'DBText2'
          DataField = 'ACT_NAME'
          DataPipeline = ppDBPipeline1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = #32048#26126#39636
          Font.Size = 12
          Font.Style = [fsBold]
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 5027
          mmLeft = 33602
          mmTop = 3440
          mmWidth = 51065
          BandType = 3
          GroupNo = 0
        end
        object ppLine3: TppLine
          UserName = 'Line3'
          ParentWidth = True
          Position = lpBottom
          Weight = 0.75
          mmHeight = 2117
          mmLeft = 0
          mmTop = 7142
          mmWidth = 203200
          BandType = 3
          GroupNo = 0
        end
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
    Left = 280
    Top = 12
  end
end

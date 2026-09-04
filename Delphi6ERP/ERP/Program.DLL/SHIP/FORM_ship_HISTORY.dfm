object FM_ship_HISTORY: TFM_ship_HISTORY
  Left = 68
  Top = 70
  Width = 710
  Height = 487
  Caption = #23458#25142#20132#26131#27511#21490
  Color = clBtnFace
  Font.Charset = CHINESEBIG5_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #32048#26126#39636
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 0
    Top = 248
    Width = 702
    Height = 10
    Cursor = crVSplit
    Align = alBottom
    Beveled = True
    Color = clBtnFace
    ParentColor = False
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 258
    Width = 702
    Height = 162
    Align = alBottom
    Caption = #37559#36008#21934#26126#32048
    TabOrder = 0
    object Grid_DT: TdxDBGrid
      Left = 2
      Top = 17
      Width = 698
      Height = 123
      TabStop = False
      Bands = <
        item
        end>
      DefaultLayout = True
      HeaderPanelRowCount = 1
      KeyField = 'HSMD_SEQNO'
      SummaryGroups = <>
      SummarySeparator = ', '
      Align = alClient
      Color = clTeal
      Font.Charset = CHINESEBIG5_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = #32048#26126#39636
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      BandFont.Charset = CHINESEBIG5_CHARSET
      BandFont.Color = clWindowText
      BandFont.Height = -15
      BandFont.Name = #32048#26126#39636
      BandFont.Style = []
      DataSource = ds_DT
      Filter.Criteria = {00000000}
      HeaderFont.Charset = CHINESEBIG5_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -15
      HeaderFont.Name = #32048#26126#39636
      HeaderFont.Style = []
      OptionsDB = [edgoCancelOnExit, edgoCanNavigation, edgoConfirmDelete, edgoUseBookmarks]
      PreviewFont.Charset = DEFAULT_CHARSET
      PreviewFont.Color = clBlue
      PreviewFont.Height = -15
      PreviewFont.Name = #32048#26126#39636
      PreviewFont.Style = []
      OnCustomDraw = Grid_DTCustomDraw
      object Grid_DTHSMD_SEQNO: TdxDBGridMaskColumn
        Width = 38
        BandIndex = 0
        RowIndex = 0
        FieldName = 'HSMD_SEQNO'
      end
      object Grid_DTPRD_NO: TdxDBGridMaskColumn
        Width = 131
        BandIndex = 0
        RowIndex = 0
        FieldName = 'PRD_NO'
      end
      object Grid_DTHSMD_PRD_NAME: TdxDBGridMaskColumn
        Width = 169
        BandIndex = 0
        RowIndex = 0
        FieldName = 'HSMD_PRD_NAME'
      end
      object Grid_DTHSMD_UNIT_PRICE: TdxDBGridMaskColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'HSMD_UNIT_PRICE'
      end
      object Grid_DTHSMD_QTY: TdxDBGridMaskColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'HSMD_QTY'
      end
      object Grid_DTC_Sub_Total: TdxDBGridColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'C_Sub_Total'
      end
      object Grid_DTHSMD_COST: TdxDBGridMaskColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'HSMD_COST'
      end
    end
    object Panel3: TPanel
      Left = 2
      Top = 140
      Width = 698
      Height = 20
      Align = alBottom
      BevelInner = bvSpace
      BevelOuter = bvLowered
      TabOrder = 1
      object DBNavigator3: TDBNavigator
        Left = 2
        Top = 2
        Width = 183
        Height = 18
        DataSource = ds_DT
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
        Align = alLeft
        TabOrder = 0
      end
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 0
    Width = 702
    Height = 248
    Align = alClient
    Caption = #37559#36008#21934#20027#27284
    TabOrder = 1
    object grid_Mast: TdxDBGrid
      Left = 2
      Top = 53
      Width = 698
      Height = 169
      Bands = <
        item
        end>
      DefaultLayout = True
      HeaderPanelRowCount = 1
      KeyField = 'HSMT_NO'
      SummaryGroups = <>
      SummarySeparator = ', '
      Align = alClient
      Color = clTeal
      Font.Charset = CHINESEBIG5_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = #32048#26126#39636
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      BandFont.Charset = CHINESEBIG5_CHARSET
      BandFont.Color = clWindowText
      BandFont.Height = -15
      BandFont.Name = #32048#26126#39636
      BandFont.Style = []
      DataSource = ds_Mast
      Filter.Criteria = {00000000}
      HeaderFont.Charset = CHINESEBIG5_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -15
      HeaderFont.Name = #32048#26126#39636
      HeaderFont.Style = []
      OptionsBehavior = [edgoAutoSort, edgoDragScroll, edgoEnterShowEditor, edgoImmediateEditor, edgoTabThrough, edgoVertThrough]
      OptionsDB = [edgoCancelOnExit, edgoCanNavigation, edgoConfirmDelete, edgoUseBookmarks]
      PreviewFont.Charset = DEFAULT_CHARSET
      PreviewFont.Color = clBlue
      PreviewFont.Height = -15
      PreviewFont.Name = #32048#26126#39636
      PreviewFont.Style = []
      object grid_MastHSMT_NO: TdxDBGridMaskColumn
        Width = 101
        BandIndex = 0
        RowIndex = 0
        FieldName = 'HSMT_NO'
      end
      object grid_MastHSMT_DATE: TdxDBGridDateColumn
        Width = 83
        BandIndex = 0
        RowIndex = 0
        FieldName = 'HSMT_DATE'
      end
      object grid_MastHSMT_TOTAL: TdxDBGridMaskColumn
        Width = 71
        BandIndex = 0
        RowIndex = 0
        FieldName = 'HSMT_TOTAL'
      end
      object grid_MastHSMT_TAX: TdxDBGridMaskColumn
        Width = 50
        BandIndex = 0
        RowIndex = 0
        FieldName = 'HSMT_TAX'
      end
      object grid_MastC_Amount: TdxDBGridColumn
        Width = 70
        BandIndex = 0
        RowIndex = 0
        FieldName = 'C_Amount'
      end
      object grid_HSMT_NOT_CLEAN: TdxDBGridColumn
        Width = 92
        BandIndex = 0
        RowIndex = 0
        FieldName = 'HSMT_NOT_CLEAN'
      end
      object grid_MastC_EPY_NAME: TdxDBGridColumn
        Width = 58
        BandIndex = 0
        RowIndex = 0
        FieldName = 'C_EPY_NAME'
      end
      object grid_MastHSMT_INV_NO: TdxDBGridMaskColumn
        Width = 85
        BandIndex = 0
        RowIndex = 0
        FieldName = 'HSMT_INV_NO'
      end
      object grid_MastHSMT_COST: TdxDBGridMaskColumn
        Width = 70
        BandIndex = 0
        RowIndex = 0
        FieldName = 'HSMT_COST'
      end
      object grid_MastHSMT_DESC: TdxDBGridMaskColumn
        Width = 140
        BandIndex = 0
        RowIndex = 0
        FieldName = 'HSMT_DESC'
      end
      object grid_MastHSMT_CREATOR: TdxDBGridMaskColumn
        Width = 85
        BandIndex = 0
        RowIndex = 0
        FieldName = 'HSMT_CREATOR'
      end
      object grid_MastHSMT_DESTINATION: TdxDBGridMaskColumn
        Width = 85
        BandIndex = 0
        RowIndex = 0
        FieldName = 'HSMT_DESTINATION'
      end
    end
    object Panel2: TPanel
      Left = 2
      Top = 222
      Width = 698
      Height = 24
      Align = alBottom
      BevelInner = bvSpace
      BevelOuter = bvLowered
      TabOrder = 1
      object DBNavigator2: TDBNavigator
        Left = 2
        Top = 2
        Width = 183
        Height = 20
        DataSource = ds_Mast
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
        Align = alLeft
        TabOrder = 0
      end
    end
    object Panel4: TPanel
      Left = 2
      Top = 17
      Width = 698
      Height = 36
      Align = alTop
      BevelInner = bvSpace
      BevelOuter = bvLowered
      TabOrder = 2
      object Label1: TLabel
        Left = 16
        Top = 8
        Width = 64
        Height = 15
        Caption = #23458#25142#32232#34399
        FocusControl = DBEdit1
      end
      object Label2: TLabel
        Left = 248
        Top = 8
        Width = 64
        Height = 15
        Caption = #23458#25142#21517#31281
        FocusControl = DBEdit2
      end
      object DBEdit1: TDBEdit
        Left = 80
        Top = 4
        Width = 157
        Height = 23
        TabStop = False
        DataField = 'CUM_NO'
        DataSource = ds_Mast
        ReadOnly = True
        TabOrder = 0
      end
      object DBEdit2: TDBEdit
        Left = 312
        Top = 4
        Width = 304
        Height = 23
        TabStop = False
        DataField = 'C_CUM_Name'
        DataSource = ds_Mast
        ReadOnly = True
        TabOrder = 1
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 420
    Width = 702
    Height = 40
    Align = alBottom
    BevelInner = bvSpace
    BevelOuter = bvLowered
    TabOrder = 2
    object Label3: TLabel
      Left = 32
      Top = 12
      Width = 80
      Height = 15
      Caption = #36039#26009#31558#25976#65306
    end
    object Button1: TButton
      Left = 548
      Top = 8
      Width = 75
      Height = 25
      Caption = #30906#23450
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object Edit_Rec: TEdit
      Left = 108
      Top = 8
      Width = 121
      Height = 23
      ReadOnly = True
      TabOrder = 1
      Text = 'Edit_Rec'
    end
  end
  object Client_Mast: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DataSetProvider1'
    AfterScroll = Client_MastAfterScroll
    OnCalcFields = Client_MastCalcFields
    Left = 516
    Top = 88
    object Client_MastCLS: TIntegerField
      FieldName = 'CLS'
      ReadOnly = True
    end
    object Client_MastHSMT_NO: TStringField
      DisplayLabel = #37559#36008#21934#32232#34399
      FieldName = 'HSMT_NO'
    end
    object Client_MastCUM_NO: TStringField
      DisplayLabel = #23458#25142#32232#34399
      FieldName = 'CUM_NO'
    end
    object Client_MastC_CUM_Name: TStringField
      DisplayLabel = #23458#25142#21517#31281
      FieldKind = fkCalculated
      FieldName = 'C_CUM_Name'
      Calculated = True
    end
    object Client_MastHSMT_INV_NO: TStringField
      DisplayLabel = #30332#31080#34399#30908
      FieldName = 'HSMT_INV_NO'
    end
    object Client_MastHSMT_DATE: TDateTimeField
      DisplayLabel = #37559#36008#26085#26399
      FieldName = 'HSMT_DATE'
    end
    object Client_MastHSMT_DESTINATION: TStringField
      DisplayLabel = #36865#36008#22320#22336
      FieldName = 'HSMT_DESTINATION'
      Size = 200
    end
    object Client_MastHSMT_TOTAL: TBCDField
      DisplayLabel = #26410#31237#21512#35336
      FieldName = 'HSMT_TOTAL'
      Precision = 19
    end
    object Client_MastHSMT_TAX: TBCDField
      DisplayLabel = #31237#38989
      FieldName = 'HSMT_TAX'
      Precision = 19
    end
    object Client_MastHSMT_COST: TBCDField
      DisplayLabel = #25104#26412#21512#35336
      FieldName = 'HSMT_COST'
      Precision = 19
    end
    object Client_MastHSMT_NOT_CLEAN: TBCDField
      DisplayLabel = #26410#25910#27454
      FieldName = 'HSMT_NOT_CLEAN'
      ReadOnly = True
      Precision = 19
    end
    object Client_MastHSMT_DESC: TStringField
      DisplayLabel = #20633#35387
      FieldName = 'HSMT_DESC'
      Size = 200
    end
    object Client_MastHSMT_CREATOR: TStringField
      DisplayLabel = #24314#31435#20154#21729
      FieldName = 'HSMT_CREATOR'
    end
    object Client_MastEPY_NO: TStringField
      DisplayLabel = #26989#21209#21729
      FieldName = 'EPY_NO'
    end
    object Client_MastC_EPY_NAME: TStringField
      DisplayLabel = #26989#21209#21729
      FieldKind = fkCalculated
      FieldName = 'C_EPY_NAME'
      Calculated = True
    end
    object Client_MastC_Amount: TCurrencyField
      DisplayLabel = #21547#31237#21512#35336
      FieldKind = fkCalculated
      FieldName = 'C_Amount'
      Currency = False
      Calculated = True
    end
  end
  object Client_DT: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DataSetProvider2'
    OnCalcFields = Client_DTCalcFields
    Left = 516
    Top = 124
    object Client_DTHSMT_NO: TStringField
      FieldName = 'HSMT_NO'
    end
    object Client_DTHSMD_SEQNO: TBCDField
      DisplayLabel = #24207#34399
      FieldName = 'HSMD_SEQNO'
      Precision = 18
      Size = 0
    end
    object Client_DTPRD_NO: TStringField
      DisplayLabel = #29986#21697#32232#34399
      FieldName = 'PRD_NO'
    end
    object Client_DTHSMD_PRD_NAME: TStringField
      DisplayLabel = #29986#21697#21517#31281
      FieldName = 'HSMD_PRD_NAME'
      OnGetText = Client_DTHSMD_PRD_NAMEGetText
      Size = 80
    end
    object Client_DTHSMD_UNIT_PRICE: TBCDField
      DisplayLabel = #21934#20729
      FieldName = 'HSMD_UNIT_PRICE'
      Precision = 19
    end
    object Client_DTHSMD_COST: TBCDField
      DisplayLabel = #25104#26412
      FieldName = 'HSMD_COST'
      Precision = 19
    end
    object Client_DTC_Sub_Total: TCurrencyField
      DisplayLabel = #23567#35336
      FieldKind = fkCalculated
      FieldName = 'C_Sub_Total'
      Currency = False
      Calculated = True
    end
    object Client_DTHSMD_QTY: TBCDField
      DisplayLabel = #25976#37327
      FieldName = 'HSMD_QTY'
      Precision = 18
    end
  end
  object ds_Mast: TDataSource
    AutoEdit = False
    DataSet = Client_Mast
    Left = 548
    Top = 88
  end
  object ds_DT: TDataSource
    AutoEdit = False
    DataSet = Client_DT
    Left = 548
    Top = 120
  end
  object ADOQuery1: TADOQuery
    Parameters = <>
    SQL.Strings = (
      'SELECT 1 CLS,HSMT_NO, CUM_NO, EPY_NO,0 HSMT_NOT_CLEAN'
      ', HSMT_INV_NO, HSMT_DATE, HSMT_DESTINATION'
      ', HSMT_TOTAL, HSMT_TAX, HSMT_COST'
      ', HSMT_DESC, HSMT_CREATOR '
      'FROM TBL_HIS_SHIP'
      'WHERE CUM_NO='#39'565201'#39
      'UNION'
      'SELECT 2, SMT_NO, CUM_NO, EPY_NO,SMT_NOT_CLEAN'
      ', SMT_INV_NO, SMT_DATE, SMT_DESTINATION'
      ', SMT_TOTAL, SMT_TAX, SMT_COST'
      ', SMT_DESC, SMT_CREATOR '
      'FROM TBL_SHIP'
      'WHERE CUM_NO='#39'565201'#39)
    Left = 396
    Top = 88
  end
  object DataSetProvider1: TDataSetProvider
    DataSet = ADOQuery1
    Constraints = True
    Left = 436
    Top = 88
  end
  object ADOQuery2: TADOQuery
    Parameters = <>
    SQL.Strings = (
      'SELECT HSMT_NO, HSMD_SEQNO, PRD_NO'
      ', INV_NO, HSMD_PRD_NAME, HSMD_UNIT_PRICE'
      ', HSMD_QTY, HSMD_COST '
      'FROM TBL_HIS_SHIP_DT'
      'WHERE HSMT_NO='#39'1'#39
      '')
    Left = 396
    Top = 120
  end
  object DataSetProvider2: TDataSetProvider
    DataSet = ADOQuery2
    Constraints = True
    Left = 436
    Top = 120
  end
end

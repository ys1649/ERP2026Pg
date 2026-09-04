object FM_Ship_Browse: TFM_Ship_Browse
  Left = 125
  Top = 93
  Width = 577
  Height = 430
  Caption = 'FM_Ship_Browse'
  Color = clBtnFace
  Font.Charset = CHINESEBIG5_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #32048#26126#39636
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 0
    Top = 189
    Width = 569
    Height = 11
    Cursor = crVSplit
    Align = alBottom
    Beveled = True
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 200
    Width = 569
    Height = 162
    Align = alBottom
    Caption = #37559#36008#21934#26126#32048
    TabOrder = 0
    object Grid_DT: TdxDBGrid
      Left = 2
      Top = 17
      Width = 565
      Height = 123
      Bands = <
        item
        end>
      DefaultLayout = True
      HeaderPanelRowCount = 1
      KeyField = 'SMD_SEQNO'
      SummaryGroups = <>
      SummarySeparator = ', '
      Align = alClient
      TabOrder = 0
      Filter.Criteria = {00000000}
      OptionsBehavior = [edgoAutoSort, edgoDragScroll, edgoImmediateEditor, edgoTabThrough, edgoVertThrough]
      OptionsDB = [edgoCancelOnExit, edgoCanNavigation, edgoConfirmDelete, edgoUseBookmarks]
      OnCustomDraw = Grid_DTCustomDraw
      object Grid_DTC_SEQNO: TdxDBGridColumn
        Width = 38
        BandIndex = 0
        RowIndex = 0
        FieldName = 'C_SEQNO'
      end
      object Grid_DTPRD_NO: TdxDBGridMaskColumn
        Width = 104
        BandIndex = 0
        RowIndex = 0
        FieldName = 'PRD_NO'
      end
      object Grid_DTSMD_PRD_NAME: TdxDBGridMaskColumn
        Width = 210
        BandIndex = 0
        RowIndex = 0
        FieldName = 'SMD_PRD_NAME'
      end
      object Grid_DTSMD_QTY: TdxDBGridMaskColumn
        Width = 84
        BandIndex = 0
        RowIndex = 0
        FieldName = 'SMD_QTY'
      end
      object Grid_DTSMD_UNIT_PRICE: TdxDBGridMaskColumn
        Width = 102
        BandIndex = 0
        RowIndex = 0
        FieldName = 'SMD_UNIT_PRICE'
      end
      object Grid_DTC_SUB_TOTAL: TdxDBGridColumn
        Width = 84
        BandIndex = 0
        RowIndex = 0
        FieldName = 'C_SUB_TOTAL'
      end
      object Grid_DTSMD_COST: TdxDBGridMaskColumn
        Width = 84
        BandIndex = 0
        RowIndex = 0
        FieldName = 'SMD_COST'
      end
    end
    object Panel3: TPanel
      Left = 2
      Top = 140
      Width = 565
      Height = 20
      Align = alBottom
      BevelInner = bvSpace
      BevelOuter = bvLowered
      TabOrder = 1
      object DBNavigator_dt: TDBNavigator
        Left = 2
        Top = 2
        Width = 183
        Height = 18
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
        Align = alLeft
        TabOrder = 0
      end
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 0
    Width = 569
    Height = 189
    Align = alClient
    Caption = #37559#36008#21934#20027#27284
    TabOrder = 1
    object grid_Mast: TdxDBGrid
      Left = 2
      Top = 17
      Width = 565
      Height = 146
      Bands = <
        item
        end>
      DefaultLayout = True
      HeaderPanelRowCount = 1
      KeyField = 'SMT_NO'
      SummaryGroups = <>
      SummarySeparator = ', '
      Align = alClient
      TabOrder = 0
      Filter.Criteria = {00000000}
      OptionsBehavior = [edgoAutoSort, edgoDragScroll, edgoImmediateEditor, edgoTabThrough, edgoVertThrough]
      OptionsDB = [edgoCancelOnExit, edgoCanNavigation, edgoConfirmDelete, edgoUseBookmarks]
      object grid_MastCUM_NO: TdxDBGridMaskColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'CUM_NO'
      end
      object grid_MastC_CUM_NAME: TdxDBGridColumn
        Width = 200
        BandIndex = 0
        RowIndex = 0
        FieldName = 'C_CUM_NAME'
      end
      object grid_MastSMT_DATE: TdxDBGridDateColumn
        Width = 114
        BandIndex = 0
        RowIndex = 0
        FieldName = 'SMT_DATE'
      end
      object grid_MastSMT_NO: TdxDBGridMaskColumn
        Width = 103
        BandIndex = 0
        RowIndex = 0
        FieldName = 'SMT_NO'
      end
      object grid_MastSMT_INV_NO: TdxDBGridMaskColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'SMT_INV_NO'
      end
      object grid_MastSMT_TOTAL: TdxDBGridMaskColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'SMT_TOTAL'
      end
      object grid_MastSMT_TAX: TdxDBGridMaskColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'SMT_TAX'
      end
      object grid_MastC_Amount: TdxDBGridColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'C_Amount'
      end
      object grid_MastSMT_NOT_CLEAN: TdxDBGridMaskColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'SMT_NOT_CLEAN'
      end
      object grid_MastC_EPY_NAME: TdxDBGridColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'C_EPY_NAME'
      end
      object grid_MastSMT_CREATOR: TdxDBGridMaskColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'SMT_CREATOR'
      end
      object grid_MastSMT_DESTINATION: TdxDBGridMaskColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'SMT_DESTINATION'
      end
    end
    object Panel2: TPanel
      Left = 2
      Top = 163
      Width = 565
      Height = 24
      Align = alBottom
      BevelInner = bvSpace
      BevelOuter = bvLowered
      TabOrder = 1
      object DBNavigator_mast: TDBNavigator
        Left = 2
        Top = 2
        Width = 183
        Height = 20
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
        Align = alLeft
        TabOrder = 0
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 362
    Width = 569
    Height = 38
    Align = alBottom
    BevelInner = bvSpace
    BevelOuter = bvLowered
    TabOrder = 2
    object Button1: TButton
      Left = 472
      Top = 8
      Width = 75
      Height = 25
      Caption = #30906#23450
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
  end
end

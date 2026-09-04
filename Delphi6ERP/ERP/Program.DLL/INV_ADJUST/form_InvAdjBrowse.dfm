object FM_InvAdjBrowse: TFM_InvAdjBrowse
  Left = 216
  Top = 220
  Width = 709
  Height = 430
  Caption = #24235#25151#35519#25972#21934
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
    Width = 701
    Height = 11
    Cursor = crVSplit
    Align = alBottom
    Beveled = True
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 200
    Width = 701
    Height = 162
    Align = alBottom
    Caption = #35519#25972#21934#26126#32048
    TabOrder = 1
    object Panel3: TPanel
      Left = 2
      Top = 140
      Width = 697
      Height = 20
      Align = alBottom
      BevelInner = bvSpace
      BevelOuter = bvLowered
      TabOrder = 0
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
    object grid_dt: TdxDBGrid
      Left = 2
      Top = 17
      Width = 697
      Height = 123
      Bands = <
        item
        end>
      DefaultLayout = True
      HeaderPanelRowCount = 1
      SummaryGroups = <>
      SummarySeparator = ', '
      Align = alClient
      TabOrder = 1
      Filter.Criteria = {00000000}
      OnCustomDraw = Grid_DTCustomDraw
      object grid_dtC_SEQNO: TdxDBGridColumn
        Width = 42
        BandIndex = 0
        RowIndex = 0
        FieldName = 'C_SEQNO'
      end
      object grid_dtPRD_NO: TdxDBGridMaskColumn
        Width = 123
        BandIndex = 0
        RowIndex = 0
        FieldName = 'PRD_NO'
      end
      object grid_dtC_PRD_NAME: TdxDBGridColumn
        Width = 158
        BandIndex = 0
        RowIndex = 0
        FieldName = 'C_PRD_NAME'
      end
      object grid_dtADD_QTY: TdxDBGridMaskColumn
        Width = 84
        BandIndex = 0
        RowIndex = 0
        FieldName = 'ADD_QTY'
      end
      object grid_dtADD_COST: TdxDBGridMaskColumn
        Width = 84
        BandIndex = 0
        RowIndex = 0
        FieldName = 'ADD_COST'
      end
      object grid_dtC_SUB_TOTAL: TdxDBGridColumn
        Width = 84
        BandIndex = 0
        RowIndex = 0
        FieldName = 'C_SUB_TOTAL'
      end
      object grid_dtC_PRD_ONHAND: TdxDBGridColumn
        Width = 84
        BandIndex = 0
        RowIndex = 0
        FieldName = 'C_PRD_ONHAND'
      end
      object grid_dtINV_NO: TdxDBGridMaskColumn
        Width = 84
        BandIndex = 0
        RowIndex = 0
        FieldName = 'INV_NO'
      end
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 0
    Width = 701
    Height = 189
    Align = alClient
    Caption = #35519#25972#21934#20027#27284
    TabOrder = 0
    object Panel2: TPanel
      Left = 2
      Top = 163
      Width = 697
      Height = 24
      Align = alBottom
      BevelInner = bvSpace
      BevelOuter = bvLowered
      TabOrder = 0
      object DBNavigator_Mast: TDBNavigator
        Left = 2
        Top = 2
        Width = 183
        Height = 20
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
        Align = alLeft
        TabOrder = 0
      end
    end
    object grid_mast: TdxDBGrid
      Left = 2
      Top = 17
      Width = 697
      Height = 146
      Bands = <
        item
        end>
      DefaultLayout = True
      HeaderPanelRowCount = 1
      SummaryGroups = <>
      SummarySeparator = ', '
      Align = alClient
      TabOrder = 1
      Filter.Criteria = {00000000}
      object grid_mastADJ_NO: TdxDBGridMaskColumn
        Width = 98
        BandIndex = 0
        RowIndex = 0
        FieldName = 'ADJ_NO'
      end
      object grid_mastADJ_STATUS: TdxDBGridMaskColumn
        Width = 109
        BandIndex = 0
        RowIndex = 0
        FieldName = 'ADJ_STATUS'
      end
      object grid_mastADJ_DATE: TdxDBGridDateColumn
        Width = 89
        BandIndex = 0
        RowIndex = 0
        FieldName = 'ADJ_DATE'
      end
      object grid_mastADJ_DESC: TdxDBGridMaskColumn
        Width = 268
        BandIndex = 0
        RowIndex = 0
        FieldName = 'ADJ_DESC'
      end
      object grid_mastADJ_CREATOR: TdxDBGridMaskColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'ADJ_CREATOR'
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 362
    Width = 701
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

object FM_PoRecv_Browse: TFM_PoRecv_Browse
  Left = 262
  Top = 284
  Width = 682
  Height = 430
  Caption = #36914#36008#21934
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
    Width = 674
    Height = 11
    Cursor = crVSplit
    Align = alBottom
    Beveled = True
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 200
    Width = 674
    Height = 162
    Align = alBottom
    Caption = #36914#36008#21934#26126#32048
    TabOrder = 1
    object Panel3: TPanel
      Left = 2
      Top = 140
      Width = 670
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
      Width = 670
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
        Width = 37
        BandIndex = 0
        RowIndex = 0
        FieldName = 'C_SEQNO'
      end
      object grid_dtPRD_NO: TdxDBGridMaskColumn
        Width = 118
        BandIndex = 0
        RowIndex = 0
        FieldName = 'PRD_NO'
      end
      object grid_dtRCD_PRD_NAME: TdxDBGridMaskColumn
        Width = 207
        BandIndex = 0
        RowIndex = 0
        FieldName = 'RCD_PRD_NAME'
      end
      object grid_dtRCD_QTY: TdxDBGridMaskColumn
        Width = 66
        BandIndex = 0
        RowIndex = 0
        FieldName = 'RCD_QTY'
      end
      object grid_dtRCD_UNIT_PRICE: TdxDBGridMaskColumn
        Width = 72
        BandIndex = 0
        RowIndex = 0
        FieldName = 'RCD_UNIT_PRICE'
      end
      object grid_dtC_SUB_TOTAL: TdxDBGridColumn
        Width = 75
        BandIndex = 0
        RowIndex = 0
        FieldName = 'C_SUB_TOTAL'
      end
      object grid_dtC_PRD_ONHAND: TdxDBGridColumn
        Width = 75
        BandIndex = 0
        RowIndex = 0
        FieldName = 'C_PRD_ONHAND'
      end
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 0
    Width = 674
    Height = 189
    Align = alClient
    Caption = #36914#36008#21934#20027#27284
    TabOrder = 0
    object Panel2: TPanel
      Left = 2
      Top = 163
      Width = 670
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
      Width = 670
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
      object grid_mastRCV_STATUS: TdxDBGridMaskColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'RCV_STATUS'
      end
      object grid_mastRCV_NO: TdxDBGridMaskColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'RCV_NO'
      end
      object grid_mastSUP_NO: TdxDBGridMaskColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'SUP_NO'
      end
      object grid_mastC_SUP_NAME: TdxDBGridColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'C_SUP_NAME'
      end
      object grid_mastRCV_DATE: TdxDBGridDateColumn
        Width = 96
        BandIndex = 0
        RowIndex = 0
        FieldName = 'RCV_DATE'
      end
      object grid_mastRCV_INV_NO: TdxDBGridMaskColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'RCV_INV_NO'
      end
      object grid_mastRCV_TOTAL: TdxDBGridMaskColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'RCV_TOTAL'
      end
      object grid_mastRCV_TAX: TdxDBGridMaskColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'RCV_TAX'
      end
      object grid_mastC_AMOUNT: TdxDBGridColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'C_AMOUNT'
      end
      object grid_mastRCV_NOT_CLEAN: TdxDBGridMaskColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'RCV_NOT_CLEAN'
      end
      object grid_mastRCV_DESC: TdxDBGridMaskColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'RCV_DESC'
      end
      object grid_mastC_SUP_ADDR: TdxDBGridColumn
        Width = 80
        BandIndex = 0
        RowIndex = 0
        FieldName = 'C_SUP_ADDR'
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 362
    Width = 674
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

object FM_Journal_Browse: TFM_Journal_Browse
  Left = 144
  Top = 200
  Width = 709
  Height = 430
  Caption = #20659#31080#28687#35261
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
    Caption = #20659#31080#26126#32048
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
      object grid_dtJND_SEQNO: TdxDBGridMaskColumn
        Width = 44
        BandIndex = 0
        RowIndex = 0
        FieldName = 'C_SEQNO'
      end
      object grid_dtJND_DC: TdxDBGridColumn
        BandIndex = 0
        RowIndex = 0
        FieldName = 'JND_DC'
      end
      object grid_dtACT_NO: TdxDBGridMaskColumn
        Width = 111
        BandIndex = 0
        RowIndex = 0
        FieldName = 'ACT_NO'
      end
      object grid_dtC_ACT_NAME: TdxDBGridColumn
        Width = 214
        BandIndex = 0
        RowIndex = 0
        FieldName = 'C_ACT_NAME'
      end
      object grid_dtJND_DESC: TdxDBGridMaskColumn
        Width = 179
        BandIndex = 0
        RowIndex = 0
        FieldName = 'JND_DESC'
      end
      object grid_dtJND_AMOUNT: TdxDBGridMaskColumn
        Width = 84
        BandIndex = 0
        RowIndex = 0
        FieldName = 'JND_AMOUNT'
      end
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 0
    Width = 701
    Height = 189
    Align = alClient
    Caption = #20659#31080#20027#27284
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
      object grid_mastJNL_NO: TdxDBGridMaskColumn
        Width = 142
        BandIndex = 0
        RowIndex = 0
        FieldName = 'JNL_NO'
      end
      object grid_mastJNL_DATE: TdxDBGridDateColumn
        Width = 131
        BandIndex = 0
        RowIndex = 0
        FieldName = 'JNL_DATE'
      end
      object grid_mastJNL_DESC: TdxDBGridMaskColumn
        Width = 298
        BandIndex = 0
        RowIndex = 0
        FieldName = 'JNL_DESC'
      end
      object grid_mastJNL_BILL_TYPE: TdxDBGridMaskColumn
        Width = 100
        BandIndex = 0
        RowIndex = 0
        FieldName = 'JNL_BILL_TYPE'
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

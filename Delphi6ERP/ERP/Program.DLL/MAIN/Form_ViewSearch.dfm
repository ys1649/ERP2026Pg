object FM_ViewSearch: TFM_ViewSearch
  Left = 302
  Top = 140
  Width = 427
  Height = 471
  Caption = 'FM_ViewSearch'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #32048#26126#39636
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 16
  object DBGrid1: TDBGrid
    Left = 0
    Top = 73
    Width = 419
    Height = 315
    Align = alClient
    DataSource = DataSource1
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = #32048#26126#39636
    TitleFont.Style = []
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 419
    Height = 73
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 12
      Top = 20
      Width = 96
      Height = 16
      Caption = #36039#26009#26597#35426#27396#20301
    end
    object Label2: TLabel
      Left = 228
      Top = 20
      Width = 64
      Height = 16
      Caption = #36039#26009#26597#35426
    end
    object ComboBox1: TComboBox
      Left = 12
      Top = 40
      Width = 180
      Height = 24
      ItemHeight = 16
      TabOrder = 0
      Text = 'ComboBox1'
    end
    object Edit1: TEdit
      Left = 228
      Top = 40
      Width = 180
      Height = 24
      TabOrder = 1
      Text = 'Edit1'
      OnKeyDown = Edit1KeyDown
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 388
    Width = 419
    Height = 53
    Align = alBottom
    TabOrder = 2
    object Button1: TButton
      Left = 248
      Top = 20
      Width = 75
      Height = 25
      Caption = '(&O)'#30906#23450
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #26032#32048#26126#39636
      Font.Style = []
      ModalResult = 1
      ParentFont = False
      TabOrder = 0
    end
    object Button2: TButton
      Left = 331
      Top = 20
      Width = 75
      Height = 25
      Caption = '(&C)'#21462#28040
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #26032#32048#26126#39636
      Font.Style = []
      ModalResult = 2
      ParentFont = False
      TabOrder = 1
    end
  end
  object QRY: TADOQuery
    Parameters = <>
    Left = 240
    Top = 100
  end
  object DataSource1: TDataSource
    DataSet = QRY
    Left = 236
    Top = 72
  end
end

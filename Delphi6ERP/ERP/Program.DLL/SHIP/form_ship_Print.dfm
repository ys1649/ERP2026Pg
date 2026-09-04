object FM_ship_Print: TFM_ship_Print
  Left = 194
  Top = 149
  Width = 346
  Height = 286
  Caption = #21015#21360
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #32048#26126#39636
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 15
  object BtnPrint: TButton
    Left = 160
    Top = 224
    Width = 75
    Height = 25
    Caption = #21015#21360
    TabOrder = 0
    OnClick = BtnPrintClick
  end
  object BtnCancel: TButton
    Left = 252
    Top = 224
    Width = 75
    Height = 25
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 1
  end
  object RadioFormat: TRadioGroup
    Left = 0
    Top = 0
    Width = 338
    Height = 137
    Align = alTop
    Caption = #21015#21360#26684#24335
    ItemIndex = 2
    Items.Strings = (
      '&1 '#26222#36890#21015#21360
      '&2 '#26222#36890#28961#38989#21015#21360
      '&3 '#22871#34920#21015#21360
      '&4 '#22871#34920#28961#38989#21015#21360)
    TabOrder = 2
  end
  object RadioScope: TRadioGroup
    Left = 0
    Top = 137
    Width = 338
    Height = 76
    Align = alTop
    Caption = #31684#22285
    ItemIndex = 0
    Items.Strings = (
      '&1 '#26412#38913
      '&2 '#25152#26377#31526#21512#26597#35426#26781#20214)
    TabOrder = 3
  end
  object BtnPreview: TButton
    Left = 72
    Top = 224
    Width = 75
    Height = 25
    Caption = #38928#35261
    Default = True
    TabOrder = 4
    OnClick = BtnPreviewClick
  end
end

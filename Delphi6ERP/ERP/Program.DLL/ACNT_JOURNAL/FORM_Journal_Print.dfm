object FM_Journal_Print: TFM_Journal_Print
  Left = 414
  Top = 292
  Width = 346
  Height = 245
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
    Left = 164
    Top = 184
    Width = 75
    Height = 25
    Caption = #38928#35261
    TabOrder = 0
    OnClick = BtnPrintClick
  end
  object BtnCancel: TButton
    Left = 256
    Top = 184
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
    Height = 93
    Align = alTop
    Caption = #21015#21360#26684#24335
    ItemIndex = 0
    Items.Strings = (
      '&1 '#26222#36890#21015#21360
      '&2 '#22871#34920#21015#21360)
    TabOrder = 2
  end
  object RadioScope: TRadioGroup
    Left = 0
    Top = 93
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
end

object Form1: TForm1
  Left = 141
  Top = 111
  Width = 393
  Height = 183
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 4
    Top = 88
    Width = 75
    Height = 25
    Caption = #22577#34920#35373#35336
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 84
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Test'
    TabOrder = 1
    OnClick = Button2Click
  end
  object RadioGroupDataBaseType: TRadioGroup
    Left = 0
    Top = 0
    Width = 385
    Height = 69
    Align = alTop
    Caption = 'DataBaseType'
    Items.Strings = (
      'ACCESS'
      'SQL'
      'ORACLE')
    TabOrder = 2
    OnClick = RadioGroupDataBaseTypeClick
  end
  object BitBtn1: TBitBtn
    Left = 264
    Top = 12
    Width = 107
    Height = 49
    Caption = 'SetADOConnection'
    TabOrder = 3
    OnClick = BitBtn1Click
  end
  object adodc: TADOConnection
    LoginPrompt = False
    Left = 348
    Top = 76
  end
end

object FM_Login: TFM_Login
  Left = 294
  Top = 217
  Width = 303
  Height = 156
  Caption = #31995#32113#30331#20837
  Color = clBtnFace
  Font.Charset = CHINESEBIG5_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #32048#26126#39636
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 80
    Height = 16
    Caption = #20351#29992#32773#20195#34399
  end
  object Label2: TLabel
    Left = 16
    Top = 60
    Width = 80
    Height = 16
    Caption = #20351#29992#32773#23494#30908
  end
  object EditUser: TEdit
    Left = 104
    Top = 20
    Width = 173
    Height = 24
    CharCase = ecUpperCase
    TabOrder = 0
    Text = 'EDITUSER'
  end
  object EditPassword: TEdit
    Left = 104
    Top = 56
    Width = 173
    Height = 24
    CharCase = ecUpperCase
    PasswordChar = '*'
    TabOrder = 1
    Text = 'EDITPASSWORD'
  end
  object Button2: TButton
    Left = 204
    Top = 91
    Width = 75
    Height = 25
    Caption = #38626#38283
    ModalResult = 2
    TabOrder = 3
  end
  object Button1: TButton
    Left = 108
    Top = 91
    Width = 75
    Height = 25
    Caption = #30906#23450
    Default = True
    TabOrder = 2
    OnClick = Button1Click
  end
end

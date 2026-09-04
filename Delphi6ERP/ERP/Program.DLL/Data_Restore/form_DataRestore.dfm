object fm_dataRestore: Tfm_dataRestore
  Left = 555
  Top = 329
  Width = 374
  Height = 189
  Caption = #36039#26009#36996#21407
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #32048#26126#39636
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 140
    Top = 28
    Width = 48
    Height = 15
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 140
    Top = 72
    Width = 48
    Height = 15
    Caption = 'Label2'
  end
  object Button1: TButton
    Left = 136
    Top = 128
    Width = 75
    Height = 25
    Caption = #36039#26009#36996#21407
    TabOrder = 0
    OnClick = Button1Click
  end
  object bar1: TProgressBar
    Left = 0
    Top = 8
    Width = 366
    Height = 17
    Min = 0
    Max = 100
    TabOrder = 1
  end
  object Button2: TButton
    Left = 224
    Top = 128
    Width = 75
    Height = 25
    Caption = #20013#26039
    TabOrder = 2
    OnClick = Button2Click
  end
  object bar2: TProgressBar
    Left = 0
    Top = 53
    Width = 366
    Height = 16
    Min = 0
    Max = 100
    TabOrder = 3
  end
  object OpenDialog1: TOpenDialog
    Left = 22
    Top = 118
  end
end

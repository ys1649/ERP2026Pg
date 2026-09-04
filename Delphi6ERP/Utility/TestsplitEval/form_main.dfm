object Form1: TForm1
  Left = 319
  Top = 242
  Width = 489
  Height = 527
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 24
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 481
    Height = 392
    Align = alClient
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 392
    Width = 481
    Height = 105
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 1
    object Button1: TButton
      Left = 372
      Top = 50
      Width = 103
      Height = 45
      Caption = 'Button1'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Edit1: TEdit
      Left = 12
      Top = 12
      Width = 465
      Height = 32
      TabOrder = 1
      Text = '123  + abc + ( (456 - (123*45)  )'
    end
  end
end

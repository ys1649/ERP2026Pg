object fm_backup: Tfm_backup
  Left = 366
  Top = 424
  Width = 510
  Height = 120
  Caption = #36039#26009#20633#20221
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #32048#26126#39636
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 4
    Top = 40
    Width = 64
    Height = 15
    Caption = #20633#20221#36914#24230
  end
  object bar1: TProgressBar
    Left = 0
    Top = 0
    Width = 502
    Height = 33
    Align = alTop
    Min = 0
    Max = 100
    TabOrder = 0
  end
  object btnAbort: TButton
    Left = 200
    Top = 56
    Width = 81
    Height = 25
    Caption = #20013#26039
    TabOrder = 1
    OnClick = btnAbortClick
  end
  object btnBackup: TButton
    Left = 188
    Top = 52
    Width = 81
    Height = 25
    Caption = #38283#22987#20633#20221
    TabOrder = 2
    OnClick = btnBackupClick
  end
end

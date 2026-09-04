object Fm_Query: TFm_Query
  Left = 212
  Top = 179
  Width = 696
  Height = 479
  Caption = #22577#34920#26597#35426
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #32048#26126#39636
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 16
  object GrpTitle: TGroupBox
    Left = 0
    Top = 0
    Width = 688
    Height = 85
    Align = alTop
    Caption = #22577#34920
    TabOrder = 0
    object Label1: TLabel
      Left = 44
      Top = 20
      Width = 64
      Height = 16
      Caption = #22577#34920#32232#34399
    end
    object Label2: TLabel
      Left = 44
      Top = 56
      Width = 64
      Height = 16
      Caption = #22577#34920#21517#31281
    end
    object Edit1: TEdit
      Left = 112
      Top = 16
      Width = 500
      Height = 24
      TabStop = False
      TabOrder = 0
      Text = 'Edit1'
    end
    object Edit2: TEdit
      Left = 112
      Top = 52
      Width = 500
      Height = 24
      TabStop = False
      TabOrder = 1
      Text = 'Edit2'
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 419
    Width = 688
    Height = 33
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 1
    object BtnPreview: TButton
      Left = 4
      Top = 4
      Width = 75
      Height = 25
      Caption = #38928#35261
      TabOrder = 0
      OnClick = BtnPreviewClick
    end
    object BtnPrint: TButton
      Left = 88
      Top = 4
      Width = 75
      Height = 25
      Caption = #21015#21360
      TabOrder = 1
      OnClick = BtnPrintClick
    end
    object BtnExport: TButton
      Left = 172
      Top = 4
      Width = 85
      Height = 25
      Caption = #21295#20986'Excel'
      TabOrder = 2
      Visible = False
      OnClick = BtnExportClick
    end
    object BtnCancel: TButton
      Left = 544
      Top = 4
      Width = 75
      Height = 25
      Caption = #21462#28040
      ModalResult = 2
      TabOrder = 3
    end
    object BtnOk: TButton
      Left = 460
      Top = 4
      Width = 75
      Height = 25
      Caption = #30906#23450
      TabOrder = 4
      OnClick = BtnOkClick
    end
    object Button1: TButton
      Left = 264
      Top = 4
      Width = 75
      Height = 25
      Caption = #28165#38500
      TabOrder = 5
      OnClick = Button1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 85
    Width = 688
    Height = 334
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 2
    object GrpQuery: TGroupBox
      Left = 1
      Top = 1
      Width = 466
      Height = 332
      Align = alClient
      Caption = #26597#35426#26781#20214
      TabOrder = 0
      object ScrollBox: TScrollBox
        Left = 2
        Top = 18
        Width = 462
        Height = 290
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BevelKind = bkFlat
        TabOrder = 0
      end
      object Panel3: TPanel
        Left = 2
        Top = 308
        Width = 462
        Height = 22
        Align = alBottom
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = #32048#26126#39636
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object Label4: TLabel
          Left = 312
          Top = 4
          Width = 121
          Height = 16
          AutoSize = False
          Caption = ' '#26781#20214#21487#22810#36984
          Color = 16777088
          ParentColor = False
        end
        object Label6: TLabel
          Left = 160
          Top = 4
          Width = 96
          Height = 16
          Caption = #24517#35201#26597#35426#26781#20214
          Font.Charset = ANSI_CHARSET
          Font.Color = clRed
          Font.Height = -16
          Font.Name = #32048#26126#39636
          Font.Style = []
          ParentFont = False
        end
        object Label7: TLabel
          Left = 8
          Top = 4
          Width = 121
          Height = 16
          AutoSize = False
          Caption = ' '#36984#25799#24615#26781#20214
          Color = clBtnFace
          ParentColor = False
        end
      end
    end
    object GrpSort: TGroupBox
      Left = 467
      Top = 1
      Width = 220
      Height = 332
      Align = alRight
      Caption = #25490#24207
      TabOrder = 1
      object GridSort: TStringGrid
        Left = 2
        Top = 18
        Width = 182
        Height = 286
        Align = alClient
        Color = clBtnFace
        ColCount = 2
        FixedCols = 0
        Font.Charset = CHINESEBIG5_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #32048#26126#39636
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        ColWidths = (
          124
          101)
      end
      object Panel4: TPanel
        Left = 2
        Top = 304
        Width = 216
        Height = 26
        Align = alBottom
        BevelOuter = bvLowered
        TabOrder = 1
        object BtnSortDec: TButton
          Left = 140
          Top = 3
          Width = 40
          Height = 20
          Caption = #36958#28187
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = #32048#26126#39636
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = BtnSortDecClick
        end
        object BtnSortInc: TButton
          Left = 92
          Top = 3
          Width = 40
          Height = 20
          Caption = #36958#22686
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = #32048#26126#39636
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = BtnSortIncClick
        end
      end
      object Panel5: TPanel
        Left = 184
        Top = 18
        Width = 34
        Height = 286
        Align = alRight
        BevelOuter = bvLowered
        TabOrder = 2
        object BtnDown: TSpeedButton
          Tag = -1
          Left = 5
          Top = 57
          Width = 25
          Height = 17
          Glyph.Data = {
            D6000000424DD60000000000000076000000280000000D0000000C0000000100
            04000000000060000000CE0E0000C40E00001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            7000777777777777700077777707777770007777700077777000777700000777
            7000777000000077700077000000000770007777000007777000777700000777
            7000777700000777700077777777777770007777777777777000}
          OnClick = BtnDownClick
        end
        object BtnUp: TSpeedButton
          Tag = 1
          Left = 5
          Top = 17
          Width = 25
          Height = 17
          Glyph.Data = {
            D6000000424DD60000000000000076000000280000000D0000000C0000000100
            04000000000060000000CE0E0000C40E00001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            7000777777777777700077770000077770007777000007777000777700000777
            7000770000000007700077700000007770007777000007777000777770007777
            7000777777077777700077777777777770007777777777777000}
          OnClick = BtnUpClick
        end
        object Label3: TLabel
          Left = 1
          Top = 39
          Width = 32
          Height = 15
          Caption = #38918#24207
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = #32048#26126#39636
          Font.Style = []
          ParentFont = False
        end
      end
    end
  end
end

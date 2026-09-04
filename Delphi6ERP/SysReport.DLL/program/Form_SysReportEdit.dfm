object fm_SysReportEdit: Tfm_SysReportEdit
  Left = 90
  Top = 153
  Width = 612
  Height = 506
  Caption = #22577#34920#35373#35336
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
  object PageControl1: TPageControl
    Left = 0
    Top = 101
    Width = 604
    Height = 324
    ActivePage = TabSheet1
    Align = alClient
    TabIndex = 0
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'SQL SELECT'
      object DCDBMemo1: TDBMemo
        Left = 0
        Top = 0
        Width = 596
        Height = 293
        Cursor = crIBeam
        Align = alClient
        Color = clBlack
        DataField = 'SRP_SELECT'
        DataSource = DataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Fixedsys'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        WantTabs = True
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'SQL WHERE'
      ImageIndex = 1
      object DCDBMemo2: TDBMemo
        Left = 0
        Top = 0
        Width = 596
        Height = 293
        Cursor = crIBeam
        Align = alClient
        Color = clBlack
        DataField = 'SRP_WHERE'
        DataSource = DataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Fixedsys'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        WantTabs = True
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'SQL GROUP BY'
      ImageIndex = 2
      object DCDBMemo3: TDBMemo
        Left = 0
        Top = 0
        Width = 596
        Height = 293
        Cursor = crIBeam
        Align = alClient
        Color = clBlack
        DataField = 'SRP_GROUPBY'
        DataSource = DataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Fixedsys'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        WantTabs = True
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'SQL ORDER BY'
      ImageIndex = 3
      object DCDBMemo4: TDBMemo
        Left = 0
        Top = 0
        Width = 596
        Height = 293
        Cursor = crIBeam
        Align = alClient
        Color = clBlack
        DataField = 'SRP_ORDERBY'
        DataSource = DataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Fixedsys'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        WantTabs = True
      end
    end
    object TabSheet5: TTabSheet
      Caption = #21069#32622' SCRIPT'
      ImageIndex = 4
      object DCDBMemo5: TDBMemo
        Left = 0
        Top = 0
        Width = 596
        Height = 293
        Cursor = crIBeam
        Align = alClient
        Color = clBlack
        DataField = 'SRP_PRESCRIPT'
        DataSource = DataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Fixedsys'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        WantTabs = True
      end
    end
    object TabSheet6: TTabSheet
      Caption = #24460#32622'SCRIPT'
      ImageIndex = 5
      object DCDBMemo6: TDBMemo
        Left = 0
        Top = 0
        Width = 596
        Height = 293
        Cursor = crIBeam
        Align = alClient
        Color = clBlack
        DataField = 'SRP_POSTSCRIPT'
        DataSource = DataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Fixedsys'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        WantTabs = True
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 604
    Height = 101
    Align = alTop
    BevelOuter = bvLowered
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 8
      Width = 64
      Height = 16
      Caption = #22577#34920#32232#34399
      FocusControl = DBEdit1
    end
    object Label2: TLabel
      Left = 276
      Top = 8
      Width = 64
      Height = 16
      Caption = #22577#34920#21517#31281
      FocusControl = DBEdit2
    end
    object Label3: TLabel
      Left = 16
      Top = 52
      Width = 64
      Height = 16
      Caption = #22577#34920#35498#26126
      FocusControl = DBEdit3
    end
    object DBEdit1: TDBEdit
      Left = 16
      Top = 24
      Width = 250
      Height = 24
      CharCase = ecUpperCase
      DataField = 'SRP_CODE'
      DataSource = DataSource
      TabOrder = 0
    end
    object DBEdit2: TDBEdit
      Left = 276
      Top = 24
      Width = 250
      Height = 24
      DataField = 'SRP_NAME'
      DataSource = DataSource
      TabOrder = 1
    end
    object DBEdit3: TDBEdit
      Left = 16
      Top = 68
      Width = 517
      Height = 24
      DataField = 'SRP_DESCRIPTION'
      DataSource = DataSource
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 425
    Width = 604
    Height = 54
    Align = alBottom
    TabOrder = 2
    object Button1: TButton
      Left = 16
      Top = 12
      Width = 75
      Height = 25
      Caption = #30906#23450
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 104
      Top = 12
      Width = 75
      Height = 25
      Caption = #21462#28040
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object DataSource: TDataSource
    Left = 520
    Top = 20
  end
end

object Fm_SysRepFldDefEdit: TFm_SysRepFldDefEdit
  Left = 167
  Top = 132
  Width = 619
  Height = 555
  BorderIcons = [biMinimize, biMaximize]
  Caption = #26597#35426#27396#20301#23450#32681
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #32048#26126#39636
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 611
    Height = 57
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 1
    object Label1: TLabel
      Left = 20
      Top = 4
      Width = 64
      Height = 16
      Caption = #22577#34920#32232#34399
      FocusControl = DBEdit1
    end
    object Label2: TLabel
      Left = 287
      Top = 4
      Width = 64
      Height = 16
      Caption = #22577#34920#21517#31281
      FocusControl = DBEdit2
    end
    object DBEdit1: TDBEdit
      Left = 20
      Top = 24
      Width = 250
      Height = 24
      TabStop = False
      CharCase = ecUpperCase
      DataField = 'SRP_CODE'
      DataSource = dsSysReport
      TabOrder = 0
    end
    object DBEdit2: TDBEdit
      Left = 287
      Top = 24
      Width = 310
      Height = 24
      TabStop = False
      DataField = 'SRP_NAME'
      DataSource = dsSysReport
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 490
    Width = 611
    Height = 38
    Align = alBottom
    TabOrder = 2
    object Button1: TButton
      Left = 20
      Top = 8
      Width = 75
      Height = 25
      Caption = #30906#23450
      ModalResult = 1
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 108
      Top = 8
      Width = 75
      Height = 25
      Caption = #21462#28040
      ModalResult = 2
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 57
    Width = 611
    Height = 433
    Align = alClient
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 1
      Top = 1
      Width = 609
      Height = 116
      Align = alTop
      TabOrder = 0
      object Label3: TLabel
        Left = 20
        Top = 12
        Width = 32
        Height = 16
        Caption = #24207#34399
        FocusControl = DBEdit3
      end
      object Label4: TLabel
        Left = 222
        Top = 12
        Width = 32
        Height = 16
        Caption = #38918#24207
        FocusControl = DBEdit4
      end
      object Label5: TLabel
        Left = 222
        Top = 64
        Width = 64
        Height = 16
        Caption = #34920#26684#21029#21517
        FocusControl = DBEdit5
      end
      object Label6: TLabel
        Left = 449
        Top = 12
        Width = 64
        Height = 16
        Caption = #27396#20301#21517#31281
      end
      object Label7: TLabel
        Left = 20
        Top = 64
        Width = 64
        Height = 16
        Caption = #36039#26009#22411#24907
      end
      object Label8: TLabel
        Left = 449
        Top = 64
        Width = 64
        Height = 16
        Caption = #39023#31034#21517#31281
        FocusControl = DBEdit8
      end
      object DBEdit3: TDBEdit
        Left = 20
        Top = 32
        Width = 145
        Height = 24
        TabStop = False
        DataField = 'SRF_SEQNO'
        DataSource = dsField
        TabOrder = 0
      end
      object DBEdit4: TDBEdit
        Left = 222
        Top = 32
        Width = 145
        Height = 24
        DataField = 'SRF_DISPORDER'
        DataSource = dsField
        TabOrder = 1
      end
      object DBEdit5: TDBEdit
        Left = 222
        Top = 81
        Width = 145
        Height = 24
        CharCase = ecUpperCase
        DataField = 'SRF_TABLEALIAS'
        DataSource = dsField
        TabOrder = 4
      end
      object DBEdit8: TDBEdit
        Left = 449
        Top = 81
        Width = 145
        Height = 24
        DataField = 'SRF_DISPNAME'
        DataSource = dsField
        TabOrder = 5
      end
      object cbSRF_DATATYPE: TDBComboBox
        Left = 20
        Top = 81
        Width = 145
        Height = 24
        Style = csDropDownList
        DataField = 'SRF_DATATYPE'
        DataSource = dsField
        ItemHeight = 16
        TabOrder = 3
      end
      object EditFieldName: TdxDBButtonEdit
        Left = 449
        Top = 32
        Width = 148
        TabOrder = 2
        DataField = 'SRF_FIELDNAME'
        DataSource = dsField
        Buttons = <
          item
            Default = True
          end>
        OnButtonClick = EditFieldNameButtonClick
        ExistButtons = True
      end
    end
    object GroupBox2: TGroupBox
      Left = 1
      Top = 117
      Width = 609
      Height = 128
      Align = alTop
      TabOrder = 1
      object Label9: TLabel
        Left = 20
        Top = 17
        Width = 64
        Height = 16
        Caption = #25511#21046#20803#20214
      end
      object Label10: TLabel
        Left = 185
        Top = 17
        Width = 64
        Height = 16
        Caption = #26781#20214#22411#24907
      end
      object Label12: TLabel
        Left = 20
        Top = 64
        Width = 144
        Height = 16
        Caption = #36984#38917#21015#34920'('#36887#34399#20998#38548')'
        FocusControl = DBMemo2
      end
      object DBCheckBox1: TDBCheckBox
        Left = 342
        Top = 24
        Width = 130
        Height = 17
        Caption = #26159#21542#24517#35201#26781#20214
        DataField = 'SRF_ISMUSTCRITERIA'
        DataSource = dsField
        TabOrder = 2
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox2: TDBCheckBox
        Left = 342
        Top = 48
        Width = 130
        Height = 17
        Caption = #26159#21542#26597#35426#26781#20214
        DataField = 'SRF_ISWHERE'
        DataSource = dsField
        TabOrder = 3
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckIsSortFld: TDBCheckBox
        Left = 470
        Top = 24
        Width = 130
        Height = 17
        Caption = #26159#21542#25490#24207#27396#20301
        DataField = 'SRF_ISSORT'
        DataSource = dsField
        TabOrder = 4
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBMemo2: TDBMemo
        Left = 20
        Top = 84
        Width = 565
        Height = 37
        DataField = 'SRF_LIST_VALUE'
        DataSource = dsField
        ScrollBars = ssVertical
        TabOrder = 5
      end
      object cbSRF_CONTROLTYPE: TDBComboBox
        Left = 20
        Top = 36
        Width = 145
        Height = 24
        Style = csDropDownList
        DataField = 'SRF_CONTROLTYPE'
        DataSource = dsField
        ItemHeight = 16
        TabOrder = 0
        OnChange = cbSRF_CONTROLTYPEChange
      end
      object cbSRF_QUERYTYPE: TDBComboBox
        Left = 184
        Top = 36
        Width = 145
        Height = 24
        Style = csDropDownList
        DataField = 'SRF_QUERYTYPE'
        DataSource = dsField
        ItemHeight = 16
        TabOrder = 1
        OnChange = cbSRF_QUERYTYPEChange
      end
      object DBCheckBoxSortDec: TDBCheckBox
        Left = 470
        Top = 48
        Width = 97
        Height = 17
        Caption = #36958#28187#25490#24207
        DataField = 'SRF_SORTDEC'
        DataSource = dsField
        TabOrder = 6
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
    end
    object GroupBox3: TGroupBox
      Left = 1
      Top = 245
      Width = 609
      Height = 187
      Align = alClient
      TabOrder = 2
      object Label11: TLabel
        Left = 20
        Top = 12
        Width = 64
        Height = 16
        Caption = #36984#38917' SQL'
        FocusControl = DBMemo1
      end
      object Label13: TLabel
        Left = 20
        Top = 112
        Width = 176
        Height = 16
        Caption = #36984#38917#39023#31034#27396#20301'('#36887#34399#20998#38548')'
        FocusControl = DBMemo3
      end
      object Label14: TLabel
        Left = 432
        Top = 112
        Width = 96
        Height = 16
        Caption = #36984#38917#20659#22238#27396#20301
        FocusControl = DBEdit9
      end
      object DBMemo1: TDBMemo
        Left = 20
        Top = 32
        Width = 565
        Height = 73
        DataField = 'SRF_LIST_SQL'
        DataSource = dsField
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object DBMemo3: TDBMemo
        Left = 20
        Top = 132
        Width = 397
        Height = 45
        DataField = 'SRF_LIST_FIELDDISP'
        DataSource = dsField
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object DBEdit9: TDBEdit
        Left = 432
        Top = 132
        Width = 150
        Height = 24
        CharCase = ecUpperCase
        DataField = 'SRF_LIST_RETURNFIELD'
        DataSource = dsField
        TabOrder = 2
      end
    end
  end
  object dsSysReport: TDataSource
    Left = 548
    Top = 20
  end
  object dsField: TDataSource
    DataSet = FM_SysRepFldDef.qry
    Left = 408
    Top = 100
  end
end

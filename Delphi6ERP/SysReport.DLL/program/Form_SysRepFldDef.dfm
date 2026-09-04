object FM_SysRepFldDef: TFM_SysRepFldDef
  Left = 179
  Top = 90
  Width = 604
  Height = 480
  Caption = #26597#35426#27396#20301#23450#32681
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #32048#26126#39636
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 402
    Width = 596
    Height = 51
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 0
    object BtnAppend: TButton
      Left = 8
      Top = 12
      Width = 60
      Height = 25
      Caption = #26032#22686
      TabOrder = 0
      OnClick = BtnAppendClick
    end
    object BtnModify: TButton
      Left = 72
      Top = 12
      Width = 60
      Height = 25
      Caption = #20462#25913
      TabOrder = 1
      OnClick = BtnModifyClick
    end
    object BtnDelete: TButton
      Left = 140
      Top = 12
      Width = 60
      Height = 25
      Caption = #21034#38500
      TabOrder = 2
      OnClick = BtnDeleteClick
    end
    object Button1: TButton
      Left = 508
      Top = 16
      Width = 75
      Height = 25
      Caption = #24207#34399#37325#25490
      TabOrder = 3
      OnClick = Button1Click
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 89
    Width = 596
    Height = 313
    Align = alClient
    DataSource = dsFleld
    TabOrder = 1
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = #32048#26126#39636
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'SRF_SEQNO'
        Width = 38
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SRF_DISPORDER'
        Width = 68
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SRF_TABLEALIAS'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SRF_FIELDNAME'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SRF_DISPNAME'
        Width = 113
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SRF_DATATYPE'
        Width = 86
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SRF_QUERYTYPE'
        Width = 75
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SRF_CONTROLTYPE'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SRF_ISMUSTCRITERIA'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SRF_ISWHERE'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SRF_ISSORT'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SRF_SORTDEC'
        Visible = True
      end>
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 596
    Height = 89
    Align = alTop
    Caption = #31995#32113#22577#34920
    TabOrder = 2
    object Label1: TLabel
      Left = 24
      Top = 24
      Width = 64
      Height = 16
      Caption = #22577#34920#32232#34399
      FocusControl = DBEdit1
    end
    object Label2: TLabel
      Left = 24
      Top = 60
      Width = 64
      Height = 16
      Caption = #22577#34920#21517#31281
      FocusControl = DBEdit2
    end
    object DBEdit1: TDBEdit
      Left = 100
      Top = 20
      Width = 250
      Height = 24
      DataField = 'SRP_CODE'
      DataSource = dsReport
      TabOrder = 0
    end
    object DBEdit2: TDBEdit
      Left = 100
      Top = 56
      Width = 250
      Height = 24
      DataField = 'SRP_NAME'
      DataSource = dsReport
      TabOrder = 1
    end
  end
  object qry: TADOQuery
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM TBLSYSREPORTFIELD')
    Left = 16
    Top = 128
    object qrySRP_ID: TIntegerField
      DisplayWidth = 7
      FieldName = 'SRP_ID'
    end
    object qrySRF_SEQNO: TIntegerField
      DisplayLabel = #24207#34399
      DisplayWidth = 10
      FieldName = 'SRF_SEQNO'
    end
    object qrySRF_FIELDNAME: TStringField
      DisplayLabel = #27396#20301#21517#31281
      DisplayWidth = 9
      FieldName = 'SRF_FIELDNAME'
      Size = 80
    end
    object qrySRF_DATATYPE: TStringField
      DisplayLabel = #36039#26009#22411#24907
      FieldName = 'SRF_DATATYPE'
    end
    object qrySRF_TABLEALIAS: TStringField
      DisplayLabel = #34920#26684#21029#21517
      DisplayWidth = 8
      FieldName = 'SRF_TABLEALIAS'
      Size = 80
    end
    object qrySRF_CONTROLTYPE: TStringField
      DisplayLabel = #25511#21046#20803#20214
      DisplayWidth = 9
      FieldName = 'SRF_CONTROLTYPE'
    end
    object qrySRF_QUERYTYPE: TStringField
      DisplayLabel = #26781#20214#22411#24907
      DisplayWidth = 20
      FieldName = 'SRF_QUERYTYPE'
    end
    object qrySRF_LIST_SQL: TMemoField
      DisplayLabel = #36984#38917' SQL'
      DisplayWidth = 10
      FieldName = 'SRF_LIST_SQL'
      BlobType = ftMemo
    end
    object qrySRF_LIST_VALUE: TMemoField
      DisplayLabel = #36984#38917#21015#34920
      DisplayWidth = 10
      FieldName = 'SRF_LIST_VALUE'
      BlobType = ftMemo
    end
    object qrySRF_LIST_FIELDDISP: TMemoField
      DisplayLabel = #36984#38917#39023#31034#27396#20301
      DisplayWidth = 12
      FieldName = 'SRF_LIST_FIELDDISP'
      BlobType = ftMemo
    end
    object qrySRF_LIST_RETURNFIELD: TStringField
      DisplayLabel = #36984#38917#20659#22238#27396#20301
      DisplayWidth = 80
      FieldName = 'SRF_LIST_RETURNFIELD'
      Size = 80
    end
    object qrySRF_DISPNAME: TStringField
      DisplayLabel = #39023#31034#21517#31281
      FieldName = 'SRF_DISPNAME'
      Size = 80
    end
    object qrySRF_DISPORDER: TIntegerField
      DisplayLabel = #39023#31034#38918#24207
      FieldName = 'SRF_DISPORDER'
    end
    object qrySRF_ISMUSTCRITERIA: TBooleanField
      DisplayLabel = #26159#21542#24517#35201#26781#20214
      FieldName = 'SRF_ISMUSTCRITERIA'
    end
    object qrySRF_ISWHERE: TBooleanField
      DisplayLabel = #26159#21542#26597#35426#26781#20214
      FieldName = 'SRF_ISWHERE'
    end
    object qrySRF_ISSORT: TBooleanField
      DisplayLabel = #26159#21542#25490#24207#27396#20301
      FieldName = 'SRF_ISSORT'
    end
    object qrySRF_SORTDEC: TBooleanField
      DisplayLabel = #36958#28187#25490#24207
      FieldName = 'SRF_SORTDEC'
    end
  end
  object dsFleld: TDataSource
    DataSet = qry
    Left = 16
    Top = 160
  end
  object dsReport: TDataSource
    Left = 364
    Top = 20
  end
end

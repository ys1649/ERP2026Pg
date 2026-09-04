object fm_AcntChgYear: Tfm_AcntChgYear
  Left = 413
  Top = 375
  Width = 661
  Height = 346
  ActiveControl = btnCancel
  Caption = #24180#24230#32080#36681
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #32048#26126#39636
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 28
    Top = 252
    Width = 64
    Height = 16
    Caption = #32080#36681#24180#24230
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 653
    Height = 221
    Align = alTop
    Caption = #24180#24230#32080#36681#20316#26989
    TabOrder = 0
    object Memo1: TMemo
      Left = 2
      Top = 18
      Width = 649
      Height = 201
      Align = alClient
      Lines.Strings = (
        ''
        #27880#24847#20107#38917':'
        ''
        '  1 '#24180#24230#32080#36681#21069#35531#20808#22519#34892#20633#20221#20316#26989
        ''
        '  2 '#32080#36681#23436#30050#24460', '#30070#24180#24230#25152#26377#20659#31080','#21253#25324#26371#35336#20659#31080','#36914#36864#36008#21934#25818','#37559#36864#36008#21934#25818#21450#25910#20184#27454#32000#37636
        '    '#22343#28961#27861#22686#20462#21450#21034#38500
        ''
        '  3 '#32080#36681#24460','#26412#24180#24230#25613#30410#23559#32047#35336#26044#31185#30446' [3351 '#32047#35336#30408#34407']'#20013
        '')
      ReadOnly = True
      TabOrder = 0
    end
  end
  object btnChange: TButton
    Left = 256
    Top = 240
    Width = 85
    Height = 45
    Caption = #32080#36681
    TabOrder = 1
    OnClick = btnChangeClick
  end
  object btnCancel: TButton
    Left = 444
    Top = 240
    Width = 85
    Height = 45
    Caption = #21462#28040
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object editYear: TEdit
    Left = 100
    Top = 252
    Width = 121
    Height = 24
    ReadOnly = True
    TabOrder = 3
    Text = 'editYear'
  end
  object Button1: TButton
    Left = 348
    Top = 240
    Width = 85
    Height = 45
    Caption = #21462#28040#24180#32080
    TabOrder = 4
    OnClick = Button1Click
  end
  object QryChgYear: TADOQuery
    Parameters = <>
    SQL.Strings = (
      'SELECT ACT_NO,SUM(AMOUNT) AMOUNT'
      'FROM'
      '('
      'SELECT A.JNL_NO,B.JND_SEQNO,C.ACT_NO,B.JND_AMOUNT AMOUNT'
      'FROM TBL_ACNT_JOURNAL A'
      #9'INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO'
      #9'INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO'
      #9'INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO'
      'WHERE A.JNL_DATE >= '#39'01/01/2003'#39
      #9'AND A.JNL_DATE < '#39'01/01/2004'#39
      #9'AND D.TYP_MAJOR_TYPE IN ('#39#36039#29986#39','#39#36000#20661#39','#39#26989#20027#27402#30410#39')'
      ')A'
      'GROUP BY A.ACT_NO'
      'UNION'
      'SELECT '#39'3351'#39' ACT_NO,SUM(B.JND_AMOUNT) AMOUNT'
      'FROM TBL_ACNT_JOURNAL A'
      'INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO'
      'INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO'
      'INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO'
      'WHERE D.TYP_MAJOR_TYPE NOT IN ('#39#36039#29986#39','#39#36000#20661#39','#39#26989#20027#27402#30410#39')'
      #9'and YEAR(A.JNL_DATE)=2003;'
      ''
      ' '
      ' ')
    Left = 540
    Top = 136
  end
end

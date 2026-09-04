object Fm_ResetInvTran: TFm_ResetInvTran
  Left = 204
  Top = 216
  Width = 594
  Height = 313
  Caption = #24235#23384#37325#25972
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #32048#26126#39636
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 12
    Top = 208
    Width = 32
    Height = 15
    Caption = #36914#24230
  end
  object lblMsg: TLabel
    Left = 52
    Top = 184
    Width = 48
    Height = 15
    Caption = 'lblMsg'
  end
  object BtnOk: TButton
    Left = 372
    Top = 248
    Width = 75
    Height = 25
    Caption = #38283#22987
    TabOrder = 0
    OnClick = BtnOkClick
  end
  object BtnCancel: TButton
    Left = 468
    Top = 248
    Width = 75
    Height = 25
    Caption = #38626#38283
    TabOrder = 1
    OnClick = BtnCancelClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 586
    Height = 173
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 2
    object Memo1: TMemo
      Left = 2
      Top = 2
      Width = 582
      Height = 169
      Align = alClient
      Lines.Strings = (
        #24235#23384#37325#25972','#23559#22519#34892#19979#21015#24037#20316':'
        ''
        '1.'#21034#38500#25152#26377#24235#23384#30064#21205#36039#26009'.'
        ''
        '2.'#37325#26032#24314#31435#25152#26377#20358#33258#20986#36008#21934','#25910#26009#21934#21450#35519#25972#21934#30340#24235#23384#30064#21205#36039#26009'.'
        ''
        '  '#30070#24744#23565#24235#23384#25976#37327#21450#25104#26412#26377#30097#21839#26178','#21487#22519#34892#26412#25805#20316','#22519#34892#26412#25805#20316#38656#35201#19968#20123#26178#38291' ('#32004
        #38656#25976#20998#37912#33267#25976#21313#20998#37912','#35222#36039#26009#22810#23521#32780#23450')'
        ''
        '  '#22519#34892#26412#20316#26989#26178','#35531#20808#26283#26178#20572#27490#20854#20182#24037#20316#31449#30340#25805#20316)
      ReadOnly = True
      TabOrder = 0
    end
  end
  object bar1: TProgressBar
    Left = 48
    Top = 204
    Width = 537
    Height = 25
    Min = 0
    Max = 100
    TabOrder = 3
  end
  object qryShip: TADOQuery
    Parameters = <>
    SQL.Strings = (
      
        'SELECT A.SMT_NO,A.SMT_DATE,B.SMD_SEQNO,B.PRD_NO,B.SMD_QTY,B.INV_' +
        'NO,B.SMD_UNIT_PRICE'
      'FROM TBL_SHIP A'
      'INNER JOIN TBL_SHIP_DT B ON A.SMT_NO=B.SMT_NO'
      'WHERE A.SMT_STATUS > 0'
      'ORDER BY A.SMT_DATE,A.SMT_NO,B.SMD_SEQNO')
    Left = 16
    Top = 236
  end
  object qryPoRecv: TADOQuery
    Parameters = <>
    SQL.Strings = (
      
        'SELECT A.RCV_DATE,A.RCV_NO,B.RCD_SEQNO,B.PRD_NO,B.RCD_QTY,B.INV_' +
        'NO,B.RCD_UNIT_PRICE'
      'FROM TBL_PO_RECV A'
      'INNER JOIN TBL_PO_RECV_DT B ON A.RCV_NO=B.RCV_NO'
      'WHERE A.RCV_STATUS > 0'
      'ORDER BY A.RCV_DATE,A.RCV_NO,B.RCD_SEQNO')
    Left = 76
    Top = 236
  end
  object qryAdj: TADOQuery
    Parameters = <>
    SQL.Strings = (
      
        'SELECT A.ADJ_DATE,A.ADJ_NO,B.ADD_SEQNO,B.PRD_NO,B.ADD_QTY,B.INV_' +
        'NO,B.ADD_COST,A.ADJ_STATUS'
      'FROM TBL_INV_ADJ A'
      'INNER JOIN TBL_INV_ADJ_DT B ON A.ADJ_NO=B.ADJ_NO'
      'WHERE A.ADJ_STATUS > 0'
      'ORDER BY A.ADJ_DATE,A.ADJ_NO,B.ADD_SEQNO')
    Left = 136
    Top = 236
  end
  object qryProduct: TADOQuery
    Parameters = <>
    SQL.Strings = (
      'SELECT A.PRD_NO'
      'FROM TBL_PRODUCT A'
      'ORDER BY A.PRD_NO')
    Left = 288
    Top = 236
  end
end

object FM_GetItmCode: TFM_GetItmCode
  Left = 243
  Top = 217
  Width = 507
  Height = 327
  Caption = 'FM_GetItmCode'
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
    Left = 36
    Top = 60
    Width = 64
    Height = 16
    Caption = #31278#39006#20195#30908
  end
  object Label2: TLabel
    Left = 36
    Top = 101
    Width = 64
    Height = 16
    Caption = #23610#23544#20195#30908
  end
  object Label3: TLabel
    Left = 36
    Top = 143
    Width = 64
    Height = 16
    Caption = #29943#26834#20195#30908
  end
  object Label4: TLabel
    Left = 36
    Top = 184
    Width = 64
    Height = 16
    Caption = #30382#33180#20195#30908
  end
  object Label5: TLabel
    Left = 36
    Top = 226
    Width = 64
    Height = 16
    Caption = #20056#25976#20195#30908
  end
  object Label6: TLabel
    Left = 256
    Top = 60
    Width = 96
    Height = 16
    Caption = #38459#20540#31684#22285#20195#30908
  end
  object Label7: TLabel
    Left = 288
    Top = 101
    Width = 64
    Height = 16
    Caption = #28331#24230#20418#25976
  end
  object Label8: TLabel
    Left = 280
    Top = 142
    Width = 72
    Height = 16
    Caption = #33258#35330#23660#24615'1'
  end
  object Label9: TLabel
    Left = 280
    Top = 184
    Width = 72
    Height = 16
    Caption = #33258#35330#23660#24615'2'
  end
  object Label10: TLabel
    Left = 36
    Top = 12
    Width = 64
    Height = 16
    Caption = #26009#21697#20195#34399
  end
  object EditClass: TdxButtonEdit
    Left = 108
    Top = 60
    Width = 121
    TabOrder = 0
    OnExit = EditClassExit
    Buttons = <
      item
        Default = True
      end>
    OnButtonClick = EditClassButtonClick
    ExistButtons = True
  end
  object EditSize: TdxButtonEdit
    Left = 108
    Top = 99
    Width = 121
    TabOrder = 1
    OnExit = EditClassExit
    Buttons = <
      item
        Default = True
      end>
    OnButtonClick = EditSizeButtonClick
    ExistButtons = True
  end
  object EditRod: TdxButtonEdit
    Left = 108
    Top = 139
    Width = 121
    TabOrder = 2
    OnExit = EditClassExit
    Buttons = <
      item
        Default = True
      end>
    OnButtonClick = EditRodButtonClick
    ExistButtons = True
  end
  object EditFilm: TdxButtonEdit
    Left = 108
    Top = 180
    Width = 121
    TabOrder = 3
    OnExit = EditClassExit
    Buttons = <
      item
        Default = True
      end>
    OnButtonClick = EditFilmButtonClick
    ExistButtons = True
  end
  object EditSort: TdxButtonEdit
    Left = 108
    Top = 222
    Width = 121
    TabOrder = 4
    OnExit = EditClassExit
    Buttons = <
      item
        Default = True
      end>
    OnButtonClick = EditSortButtonClick
    ExistButtons = True
  end
  object EditBound: TdxButtonEdit
    Left = 360
    Top = 56
    Width = 121
    TabOrder = 5
    OnExit = EditClassExit
    Buttons = <
      item
        Default = True
      end>
    OnButtonClick = EditBoundButtonClick
    ExistButtons = True
  end
  object EditTemper: TdxButtonEdit
    Left = 360
    Top = 97
    Width = 121
    TabOrder = 6
    OnExit = EditClassExit
    Buttons = <
      item
        Default = True
      end>
    OnButtonClick = EditTemperButtonClick
    ExistButtons = True
  end
  object EditUserDef1: TdxButtonEdit
    Left = 360
    Top = 138
    Width = 121
    TabOrder = 7
    OnExit = EditClassExit
    Buttons = <
      item
        Default = True
      end>
    OnButtonClick = EditUserDef1ButtonClick
    ExistButtons = True
  end
  object EditUserDef2: TdxButtonEdit
    Left = 360
    Top = 180
    Width = 121
    TabOrder = 8
    OnExit = EditClassExit
    Buttons = <
      item
        Default = True
      end>
    OnButtonClick = EditUserDef2ButtonClick
    ExistButtons = True
  end
  object EditItemCode: TdxEdit
    Left = 108
    Top = 8
    Width = 369
    Color = clSilver
    TabOrder = 9
    TabStop = False
    Text = 'EditItemCode'
    ReadOnly = True
    StoredValues = 64
  end
  object Button1: TButton
    Left = 316
    Top = 248
    Width = 75
    Height = 25
    Caption = #30906#23450
    TabOrder = 10
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 404
    Top = 248
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 11
  end
end

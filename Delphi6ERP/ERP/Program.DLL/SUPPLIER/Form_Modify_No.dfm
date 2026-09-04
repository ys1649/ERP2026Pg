object FM_Modify_No: TFM_Modify_No
  Left = 336
  Top = 287
  Width = 341
  Height = 247
  Caption = #32232#34399#35722#26356
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
  object Label3: TLabel
    Left = 8
    Top = 128
    Width = 80
    Height = 15
    Caption = #36664#20837#26032#32232#34399
  end
  object Button1: TButton
    Left = 12
    Top = 184
    Width = 75
    Height = 25
    Caption = #35722#26356
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 100
    Top = 184
    Width = 75
    Height = 25
    Caption = #21462#28040
    Default = True
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 333
    Height = 121
    Align = alTop
    TabOrder = 2
    object Label1: TLabel
      Left = 12
      Top = 16
      Width = 64
      Height = 15
      Caption = #24288#21830#32232#34399
      FocusControl = DBEdit1
    end
    object Label2: TLabel
      Left = 12
      Top = 60
      Width = 64
      Height = 15
      Caption = #24288#21830#21517#31281
      FocusControl = DBEdit2
    end
    object DBEdit1: TDBEdit
      Left = 12
      Top = 32
      Width = 304
      Height = 23
      Color = clSilver
      DataField = 'SUP_NO'
      DataSource = fm_supplier.DataSource1
      ReadOnly = True
      TabOrder = 0
    end
    object DBEdit2: TDBEdit
      Left = 12
      Top = 76
      Width = 304
      Height = 23
      Color = clSilver
      DataField = 'SUP_NAME'
      DataSource = fm_supplier.DataSource1
      ReadOnly = True
      TabOrder = 1
    end
  end
  object Edit_New_No: TEdit
    Left = 8
    Top = 148
    Width = 305
    Height = 23
    TabOrder = 3
    Text = 'Edit_New_No'
  end
end

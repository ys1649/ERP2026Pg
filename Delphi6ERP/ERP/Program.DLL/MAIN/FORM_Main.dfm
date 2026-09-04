object FM_Main: TFM_Main
  Left = 158
  Top = 90
  Width = 927
  Height = 642
  Caption = 'ERP '#37197#37559#31649#29702#27169#32068
  Color = 8421440
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #32048#26126#39636
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  Visible = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object Button1: TButton
    Left = 12
    Top = 12
    Width = 141
    Height = 25
    Action = actCustomer
    TabOrder = 0
  end
  object Button2: TButton
    Left = 12
    Top = 44
    Width = 141
    Height = 25
    Action = actSupplier
    TabOrder = 1
  end
  object Button3: TButton
    Left = 12
    Top = 76
    Width = 141
    Height = 25
    Action = actProduct
    TabOrder = 2
  end
  object Button4: TButton
    Left = 12
    Top = 108
    Width = 141
    Height = 25
    Action = actShip
    TabOrder = 3
  end
  object Button5: TButton
    Left = 12
    Top = 172
    Width = 141
    Height = 25
    Action = actAR_Recv
    TabOrder = 4
  end
  object Button6: TButton
    Left = 12
    Top = 140
    Width = 141
    Height = 25
    Action = actPO_Recv
    TabOrder = 5
  end
  object Button7: TButton
    Left = 12
    Top = 204
    Width = 141
    Height = 25
    Action = actAP_Pay
    TabOrder = 6
  end
  object ActionList1: TActionList
    Left = 648
    Top = 8
    object actData_Backup: TAction
      Caption = #36039#26009#20633#20221
      OnExecute = actData_BackupExecute
    end
    object actCustomer: TAction
      Caption = #23458#25142#22522#26412#36039#26009#35373#23450
      OnExecute = actCustomerExecute
    end
    object actSupplier: TAction
      Caption = #24288#21830#22522#26412#36039#26009#35373#23450
      OnExecute = actSupplierExecute
    end
    object actProduct: TAction
      Caption = #29986#21697#22522#26412#36039#26009#35373#23450
      OnExecute = actProductExecute
    end
    object actEmploye: TAction
      Caption = #21729#24037#22522#26412#36039#26009#35373#23450
      OnExecute = actEmployeExecute
    end
    object actShip: TAction
      Caption = #37559#36864#36008#21934#31649#29702
      OnExecute = actShipExecute
    end
    object actPO_Recv: TAction
      Caption = #36914#36864#36008#21934#31649#29702
      OnExecute = actPO_RecvExecute
    end
    object actAR_Recv: TAction
      Caption = #37559#36008#25910#27454#20316#26989
      OnExecute = actAR_RecvExecute
    end
    object actAP_Pay: TAction
      Caption = #36914#36008#20184#27454#20316#26989
      OnExecute = actAP_PayExecute
    end
    object actAdjust: TAction
      Caption = #24235#25151#35519#25972#21934
      OnExecute = actAdjustExecute
    end
    object actData_Restore: TAction
      Caption = #36039#26009#36996#21407
      OnExecute = actData_RestoreExecute
    end
    object actSYS_PARAM: TAction
      Caption = #31995#32113#35373#23450
      OnExecute = actSYS_PARAMExecute
    end
    object actACNT_CHANGE_YEAR: TAction
      Caption = #26371#35336#24180#24230#32080#36681
      OnExecute = actACNT_CHANGE_YEARExecute
    end
    object actACNT_ACCOUNT: TAction
      Caption = #26371#35336#31185#30446#35373#23450
      OnExecute = actACNT_ACCOUNTExecute
    end
    object actACNT_JOURNAL: TAction
      Caption = #20659#31080#32173#35703
      OnExecute = actACNT_JOURNALExecute
    end
    object actACNT_RPT_ASSET: TAction
      Caption = #36039#29986#36000#20661#34920
      OnExecute = actACNT_RPT_ASSETExecute
    end
    object actACNT_RPT_DETAIL: TAction
      Caption = #26126#32048#20998#39006#24115
      OnExecute = actACNT_RPT_DETAILExecute
    end
    object actACNT_RPT_INCOME_STAEMENT: TAction
      Caption = #25613#30410#34920
      OnExecute = actACNT_RPT_INCOME_STAEMENTExecute
    end
    object actACNT_RPT_TB: TAction
      Caption = #35430#31639#34920
      OnExecute = actACNT_RPT_TBExecute
    end
    object actACNT_RPT_CASH: TAction
      Caption = #29694#37329#31807
      OnExecute = actACNT_RPT_CASHExecute
    end
    object actACNT_RPT_BALANCE: TAction
      Caption = #31185#30446#39192#38989#34920
      OnExecute = actACNT_RPT_BALANCEExecute
    end
    object actACNT_RPT_DAILY: TAction
      Caption = #26085#35352#24115
      OnExecute = actACNT_RPT_DAILYExecute
    end
    object actResetInvTransaction: TAction
      Caption = #24235#23384#20132#26131#37325#25972
      OnExecute = actResetInvTransactionExecute
    end
    object actCar: TAction
      Caption = #36554#36635#22522#26412#36039#26009#35373#23450
      OnExecute = actCarExecute
    end
  end
  object MainMenu1: TMainMenu
    Left = 612
    Top = 8
    object N1: TMenuItem
      Caption = #22522#26412#36039#26009#35373#23450
      object N4: TMenuItem
        Action = actCustomer
      end
      object N5: TMenuItem
        Action = actSupplier
      end
      object N6: TMenuItem
        Action = actProduct
      end
      object N7: TMenuItem
        Action = actEmploye
      end
      object N27: TMenuItem
        Action = actCar
      end
    end
    object N2: TMenuItem
      Caption = #20132#26131#21934#25818#31649#29702
      object N8: TMenuItem
        Action = actShip
      end
      object N9: TMenuItem
        Action = actPO_Recv
      end
      object N10: TMenuItem
        Action = actAR_Recv
      end
      object N11: TMenuItem
        Action = actAP_Pay
      end
      object N19: TMenuItem
        Action = actAdjust
      end
    end
    object MnuRep1: TMenuItem
      Caption = #21508#38917#34920#21934#22577#34920
    end
    object MnuRep2: TMenuItem
      Caption = #36039#35338#31649#29702#22577#34920
    end
    object MnuRep3: TMenuItem
      Caption = #32113#35336#20998#26512#22577#34920
    end
    object N20: TMenuItem
      Caption = #31995#32113#35373#23450
      object N21: TMenuItem
        Action = actData_Backup
      end
      object actDataRestore1: TMenuItem
        Action = actData_Restore
      end
      object N22: TMenuItem
        Action = actSYS_PARAM
      end
      object N26: TMenuItem
        Action = actResetInvTransaction
      end
      object N24: TMenuItem
        Action = actACNT_CHANGE_YEAR
      end
    end
    object N3: TMenuItem
      Caption = #36001#21209#26371#35336#27169#32068
      object N12: TMenuItem
        Action = actACNT_ACCOUNT
      end
      object N13: TMenuItem
        Action = actACNT_JOURNAL
      end
      object N25: TMenuItem
        Action = actACNT_RPT_DAILY
      end
      object N18: TMenuItem
        Action = actACNT_RPT_DETAIL
      end
      object N23: TMenuItem
        Action = actACNT_RPT_TB
      end
      object N15: TMenuItem
        Action = actACNT_RPT_INCOME_STAEMENT
      end
      object N14: TMenuItem
        Action = actACNT_RPT_ASSET
      end
      object N16: TMenuItem
        Action = actACNT_RPT_CASH
      end
      object N17: TMenuItem
        Action = actACNT_RPT_BALANCE
      end
    end
  end
end

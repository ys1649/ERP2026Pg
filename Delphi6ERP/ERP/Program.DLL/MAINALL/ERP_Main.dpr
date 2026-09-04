  program ERP_Main;

uses
  ShareMem,
  Forms,
  SysReport_Head in '..\..\..\SysReport.DLL\program\SysReport_Head.pas',
  Uty in '..\..\..\Utility\Uty.pas',
  Form_Login in 'Form_Login.pas' {FM_Login},
  RecChoice in '..\..\..\Utility\RecChoice\RecChoice.pas' {frmRecChoice},
  form_SysReportQuery in '..\..\..\SysReport.DLL\program\form_SysReportQuery.pas' {fm_SysReportQuery},
  Form_Query in '..\..\..\SysReport.DLL\program\Form_Query.pas' {Fm_Query},
  SysReportUnit in '..\..\..\SysReport.DLL\program\SysReportUnit.pas',
  erp_public in '..\UTY\erp_public.pas',
  FORM_CUSTOMER in '..\CUSTOMER\FORM_CUSTOMER.pas' {FM_CUSTOMER},
  form_Browse in '..\..\..\Utility\form_Browse.pas' {FM_Browse},
  Form_Modify_No in '..\UTY\Form_Modify_No.pas' {FM_Modify_No},
  Form_Supplier in '..\SUPPLIER\Form_Supplier.pas' {fm_supplier},
  form_QuickCollect in '..\SHIP\form_QuickCollect.pas' {FM_QuickCollect},
  form_ship in '..\SHIP\form_ship.pas' {fm_ship},
  form_ship_Browse in '..\SHIP\form_ship_Browse.pas' {FM_Ship_Browse},
  FORM_ship_HISTORY in '..\SHIP\FORM_ship_HISTORY.pas' {FM_ship_HISTORY},
  form_ship_Print in '..\SHIP\form_ship_Print.pas' {FM_ship_Print},
  form_product in '..\PRODUCT\form_product.pas' {fm_product},
  Form_PoRecv in '..\PO_RECV\Form_PoRecv.pas' {fm_PoRecv},
  form_PoRecv_Browse in '..\PO_RECV\form_PoRecv_Browse.pas' {FM_PoRecv_Browse},
  FORM_porecv_HISTORY in '..\PO_RECV\FORM_porecv_HISTORY.pas' {FM_PoRecv_HISTORY},
  form_PoRecv_Print in '..\PO_RECV\form_PoRecv_Print.pas' {fm_porecv_Print},
  form_porecv_QuickPay in '..\PO_RECV\form_porecv_QuickPay.pas' {fm_porecv_QuickPay},
  form_employee in '..\EMPLOYEE\form_employee.pas' {fm_employee},
  FORM_AR_RECV in '..\AR_RECV\FORM_AR_RECV.pas' {fm_ar_recv},
  FORM_AP_PAY in '..\AP_PAY\FORM_AP_PAY.pas' {FM_AP_PAY},
  Form_Car in '..\CAR\Form_Car.pas' {fm_car},
  form_account in '..\ACNT_ACCOUNT\form_account.pas' {fm_account},
  Form_Journal in '..\ACNT_JOURNAL\Form_Journal.pas' {FM_Journal},
  Form_Journal_Browse in '..\ACNT_JOURNAL\Form_Journal_Browse.pas' {FM_Journal_Browse},
  FORM_Journal_Print in '..\ACNT_JOURNAL\FORM_Journal_Print.pas' {FM_Journal_Print},
  FORM_Main in 'FORM_Main.pas' {FM_Main},
  FORM_CLIENT in 'FORM_CLIENT.pas' {fm_client},
  form_InvAdjBrowse in '..\INV_ADJUST\form_InvAdjBrowse.pas' {FM_InvAdjBrowse},
  form_InvAdjust in '..\INV_ADJUST\form_InvAdjust.pas' {Fm_invAdjust},
  Form_backup in '..\Data_Backup\Form_backup.pas' {fm_backup},
  form_DataRestore in '..\Data_Restore\form_DataRestore.pas' {fm_dataRestore},
  Form_SysParam in '..\SYS_PARAM\Form_SysParam.pas' {fm_SysParam},
  Form_AcntChgYear in '..\ACNT_CHANGE_YEAR\Form_AcntChgYear.pas' {fm_AcntChgYear},
  Form_Acnt_Asset in '..\ACNT_RPT_ASSET\Form_Acnt_Asset.pas' {Fm_Acnt_Asset},
  Form_AcntBalance in '..\ACNT_RPT_BALANCE\Form_AcntBalance.pas' {Fm_AcntBalance},
  FORM_ERP_BASE in '..\UTY\FORM_ERP_BASE.pas' {FORM_ERP},
  Form_AcntCash in '..\ACNT_RPT_CASH\Form_AcntCash.pas' {Fm_AcntCash},
  Form_AcntDaily in '..\ACNT_RPT_DAILY\Form_AcntDaily.pas' {Fm_AcntDaily},
  Form_AcntIncomeStament in '..\ACNT_RPT_INCOME_STAEMENT\Form_AcntIncomeStament.pas' {Fm_AcntIncomeStament},
  Form_AcntTrialBalance in '..\ACNT_RPT_TrialBalance\Form_AcntTrialBalance.pas' {Fm_AcntTrialBalance},
  Form_AcntDetail in '..\ACNT_RPT_DETAIL\Form_AcntDetail.pas' {Fm_AcntDetail},
  Form_ResetInvTran in '..\ResetInvTransaction\Form_ResetInvTran.pas' {Fm_ResetInvTran},
  DBUty in '..\..\..\Utility\DBUty.pas',
  MSXML2_TLB in 'C:\Program Files (x86)\Borland\Delphi6\Imports\MSXML2_TLB.pas',
  MSScriptControl_TLB in 'C:\Program Files (x86)\Borland\Delphi6\Imports\MSScriptControl_TLB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFM_Main, FM_Main);
  Application.Run;
end.

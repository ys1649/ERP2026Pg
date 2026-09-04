library PO_RECV;

uses
  Forms,
  Form_PoRecv in 'Form_PoRecv.pas' {fm_PoRecv},
  Uty in '..\..\..\Utility\Uty.pas',
  RecChoice in '..\..\..\Utility\RecChoice\RecChoice.pas' {frmRecChoice},
  Form_Query in '..\..\..\SysReport.DLL\program\Form_Query.pas' {Fm_Query},
  SysReport_Head in '..\..\..\SysReport.DLL\program\SysReport_Head.pas',
  form_PoRecv_Browse in 'form_PoRecv_Browse.pas' {FM_PoRecv_Browse},
  FORM_porecv_HISTORY in 'FORM_porecv_HISTORY.pas' {FM_PoRecv_HISTORY},
  form_porecv_QuickPay in 'form_porecv_QuickPay.pas' {fm_porecv_QuickPay},
  form_PoRecv_Print in 'form_PoRecv_Print.pas' {fm_porecv_Print},
  form_SysReportQuery in '..\..\..\SysReport.DLL\program\form_SysReportQuery.pas' {fm_SysReportQuery},
  SysReportUnit in '..\..\..\SysReport.DLL\program\SysReportUnit.pas',
  erp_public in '..\UTY\erp_public.pas',
  FORM_ERP_BASE in '..\UTY\FORM_ERP_BASE.pas' {FORM_ERP};

var
    OldApp     : TApplication;

{$R *.res}

procedure RestoreDllApp; stdcall; export;
begin
    Application := OldApp;
end;

procedure init(app:TApplication); stdcall; export;
begin
  Application:=app;
end;

function Get_Main_Form():TFORM_ERP; stdcall; export;
var
  FM: TFM_PORECV;
begin
  fm:=TFM_PORECV.Create(application);
  result:=fm;
end;


exports RestoreDllApp,init,Get_Main_Form;

begin
    OldApp := Application;
end.

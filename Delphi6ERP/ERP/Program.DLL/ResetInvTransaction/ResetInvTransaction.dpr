library ResetInvTransaction;

uses
  Forms,
  Form_ResetInvTran in 'Form_ResetInvTran.pas' {Fm_ResetInvTran},
  SysReport_Head in '..\..\..\SysReport.DLL\program\SysReport_Head.pas',
  Uty in '..\..\..\Utility\Uty.pas',
  Erp_Public in '..\UTY\ERP_Public.pas',
  FORM_ERP_BASE in '..\UTY\FORM_ERP_BASE.pas' {FORM_ERP},
  RecChoice in '..\..\..\Utility\RecChoice\RecChoice.pas' {frmRecChoice};

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
  FM: TFm_ResetInvTran;
begin
  fm:=TFm_ResetInvTran.Create(application);
  result:=fm;
end;


exports RestoreDllApp,init,Get_Main_Form;

begin
    OldApp := Application;
end.


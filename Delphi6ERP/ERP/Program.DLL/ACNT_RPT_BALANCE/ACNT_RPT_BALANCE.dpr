library ACNT_RPT_BALANCE;

uses
  Forms,
  SysReport_Head in '..\..\..\SysReport.DLL\program\SysReport_Head.pas',
  Uty in '..\..\..\Utility\Uty.pas',
  Form_AcntBalance in 'Form_AcntBalance.pas' {Fm_AcntBalance},
  RecChoice in '..\..\..\Utility\RecChoice\RecChoice.pas' {frmRecChoice},
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
  FM: TFm_AcntBalance;
begin
  fm:=TFm_AcntBalance.Create(application);
  result:=fm;
end;


exports RestoreDllApp,init,Get_Main_Form;

begin
    OldApp := Application;
end.


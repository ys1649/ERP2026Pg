library ACNT_RPT_TB;

uses
  Forms,
  Uty in '..\..\..\Utility\Uty.pas',
  Form_AcntTrialBalance in 'Form_AcntTrialBalance.pas' {Fm_AcntTrialBalance},
  RecChoice in '..\..\..\Utility\RecChoice\RecChoice.pas' {frmRecChoice},
  Erp_Public in '..\UTY\ERP_Public.pas',
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
  FM: TFm_AcntTrialBalance;
begin
  fm:=TFm_AcntTrialBalance.Create(application);
  result:=fm;
end;


exports RestoreDllApp,init,Get_Main_Form;

begin
    OldApp := Application;
end.


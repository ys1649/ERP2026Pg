library ACNT_RPT_INCOME_STATEMENT;

uses
  Forms,
  Uty in '..\..\..\Utility\Uty.pas',
  Form_AcntIncomeStament in 'Form_AcntIncomeStament.pas' {Fm_AcntIncomeStament},
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
  FM: TFm_AcntIncomeStament;
begin
  fm:=TFm_AcntIncomeStament.Create(application);
  result:=fm;
end;


exports RestoreDllApp,init,Get_Main_Form;

begin
    OldApp := Application;
end.


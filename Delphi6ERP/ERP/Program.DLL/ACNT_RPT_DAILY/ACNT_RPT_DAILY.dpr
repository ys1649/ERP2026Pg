library ACNT_RPT_DAILY;

uses
  Forms,
  Uty in '..\..\..\Utility\Uty.pas',
  Form_AcntDaily in 'Form_AcntDaily.pas' {Fm_AcntDaily},
  RecChoice in '..\..\..\Utility\RecChoice\RecChoice.pas' {frmRecChoice},
  ERP_Public in '..\UTY\ERP_Public.pas',
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
  FM: TFm_AcntDaily;
begin
  fm:=TFm_AcntDaily.Create(application);
  result:=fm;
end;


exports RestoreDllApp,init,Get_Main_Form;

begin
    OldApp := Application;
end.


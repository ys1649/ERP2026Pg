library ACNT_RPT_ASSET;

uses
  ShareMem,
  forms,
  Uty in '..\..\..\Utility\Uty.pas',
  RecChoice in '..\..\..\Utility\RecChoice\RecChoice.pas' {frmRecChoice},
  erp_public in '..\UTY\erp_public.pas',
  Form_Acnt_Asset in 'Form_Acnt_Asset.pas' {Fm_Acnt_Asset},
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
  FM: TFm_Acnt_Asset;
begin
  fm:=TFm_Acnt_Asset.Create(application);
  result:=fm;
end;


exports RestoreDllApp,init,Get_Main_Form;

begin
    OldApp := Application;
end.


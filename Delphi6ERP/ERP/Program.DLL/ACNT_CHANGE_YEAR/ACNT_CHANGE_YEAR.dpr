library ACNT_CHANGE_YEAR;

uses
  Forms,
  SysReport_Head in '..\..\..\SysReport.DLL\program\SysReport_Head.pas',
  Uty in '..\..\..\Utility\Uty.pas',
  Form_AcntChgYear in 'Form_AcntChgYear.pas' {fm_AcntChgYear},
  erp_public in '..\UTY\erp_public.pas',
  RecChoice in '..\..\..\Utility\RecChoice\RecChoice.pas' {frmRecChoice},
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
  FM: Tfm_AcntChgYear;
begin
  fm:=Tfm_AcntChgYear.Create(application);
  result:=fm;
end;


exports RestoreDllApp,init,Get_Main_Form;

begin
    OldApp := Application;
end.


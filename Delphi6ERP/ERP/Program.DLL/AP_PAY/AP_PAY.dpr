library AP_PAY;

uses
  Forms,
  FORM_AP_PAY in 'FORM_AP_PAY.pas' {FM_AP_PAY},
  Uty in '..\..\..\Utility\Uty.pas',
  SysReport_Head in '..\..\..\SysReport.DLL\program\SysReport_Head.pas',
  RecChoice in '..\..\..\Utility\RecChoice\RecChoice.pas' {frmRecChoice},
  Form_Query in '..\..\..\SysReport.DLL\program\Form_Query.pas' {Fm_Query},
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
  FM: TFM_AP_PAY;
begin
  fm:=TFM_AP_PAY.Create(application);
  result:=fm;
end;


exports RestoreDllApp,init,Get_Main_Form;

begin
    OldApp := Application;
end.



library Data_Backup;

uses
  Forms,
  SysReport_Head in '..\..\..\SysReport.DLL\program\SysReport_Head.pas',
  Uty in '..\..\..\Utility\Uty.pas',
  Form_backup in 'Form_backup.pas' {fm_backup},
  erp_public in '..\UTY\erp_public.pas',
  FORM_ERP_BASE in '..\FORM_ERP\FORM_ERP_BASE.pas' {FORM_ERP},
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
  FM: Tfm_backup;
begin
  fm:=Tfm_backup.Create(application);
  result:=fm;
end;


exports RestoreDllApp,init,Get_Main_Form;

begin
    OldApp := Application;
end.




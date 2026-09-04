library ACNT_JOURNAL;

uses
  Forms,
  Uty in '..\..\..\Utility\Uty.pas',
  RecChoice in '..\..\..\Utility\RecChoice\RecChoice.pas' {frmRecChoice},
  SysReport_Head in '..\..\..\SysReport.DLL\program\SysReport_Head.pas',
  SysReportUnit in '..\..\..\SysReport.DLL\program\SysReportUnit.pas',
  Form_Query in '..\..\..\SysReport.DLL\program\Form_Query.pas' {Fm_Query},
  Form_Journal in 'Form_Journal.pas' {FM_Journal},
  Form_Journal_Browse in 'Form_Journal_Browse.pas' {FM_Journal_Browse},
  FORM_Journal_Print in 'FORM_Journal_Print.pas' {FM_Journal_Print},
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
  FM: TFM_Journal;
begin
  fm:=TFM_Journal.Create(application);
  result:=fm;
end;


exports RestoreDllApp,init,Get_Main_Form;

begin
    OldApp := Application;
end.


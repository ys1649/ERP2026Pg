library INV_ADJUST;

uses
  Forms,
  form_InvAdjust in 'form_InvAdjust.pas' {Fm_invAdjust},
  Uty in '..\..\..\Utility\Uty.pas',
  RecChoice in '..\..\..\Utility\RecChoice\RecChoice.pas' {frmRecChoice},
  Form_Query in '..\..\..\SysReport.DLL\program\Form_Query.pas' {Fm_Query},
  SysReport_Head in '..\..\..\SysReport.DLL\program\SysReport_Head.pas',
  form_InvAdjBrowse in 'form_InvAdjBrowse.pas' {FM_InvAdjBrowse},
  form_SysReportQuery in '..\..\..\SysReport.DLL\program\form_SysReportQuery.pas' {fm_SysReportQuery},
  SysReportUnit in '..\..\..\SysReport.DLL\program\SysReportUnit.pas',
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
  FM: TFm_invAdjust;
begin
  fm:=TFm_invAdjust.Create(application);
  result:=fm;
end;


exports RestoreDllApp,init,Get_Main_Form;

begin
    OldApp := Application;
end.

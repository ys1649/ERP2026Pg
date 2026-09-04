library ship;

uses
  Forms,
  Uty in '..\..\..\Utility\Uty.pas',
  RecChoice in '..\..\..\Utility\RecChoice\RecChoice.pas' {frmRecChoice},
  Form_Query in '..\..\..\SysReport.DLL\program\Form_Query.pas' {Fm_Query},
  SysReport_Head in '..\..\..\SysReport.DLL\program\SysReport_Head.pas',
  form_ship_Browse in 'form_ship_Browse.pas' {FM_Ship_Browse},
  FORM_ship_HISTORY in 'FORM_ship_HISTORY.pas' {FM_ship_HISTORY},
  form_QuickCollect in 'form_QuickCollect.pas' {FM_QuickCollect},
  form_ship_Print in 'form_ship_Print.pas' {FM_ship_Print},
  form_SysReportQuery in '..\..\..\SysReport.DLL\program\form_SysReportQuery.pas' {fm_SysReportQuery},
  SysReportUnit in '..\..\..\SysReport.DLL\program\SysReportUnit.pas',
  form_ship in 'form_ship.pas' {fm_ship},
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
  FM: TFM_SHIP;
begin
  fm:=TFM_SHIP.Create(application);
  result:=fm;
end;


exports RestoreDllApp,init,Get_Main_Form;

begin
    OldApp := Application;
end.

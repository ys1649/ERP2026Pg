  program ERP_Main;

uses
  ShareMem in 'C:\Program Files\Borland\Delphi6\Source\Rtl\Sys\ShareMem.pas',
  Forms,
  FORM_Main in 'FORM_Main.pas' {FM_Main},
  SysReport_Head in '..\..\..\SysReport.DLL\program\SysReport_Head.pas',
  Uty in '..\..\..\Utility\Uty.pas',
  Form_Login in 'Form_Login.pas' {FM_Login},
  RecChoice in '..\..\..\Utility\RecChoice\RecChoice.pas' {frmRecChoice},
  form_SysReportQuery in '..\..\..\SysReport.DLL\program\form_SysReportQuery.pas' {fm_SysReportQuery},
  Form_Query in '..\..\..\SysReport.DLL\program\Form_Query.pas' {Fm_Query},
  SysReportUnit in '..\..\..\SysReport.DLL\program\SysReportUnit.pas',
  DLL_Function in '..\UTY\DLL_Function.pas',
  erp_public in '..\UTY\erp_public.pas',
  FORM_ERP_BASE in '..\UTY\FORM_ERP_BASE.pas' {FORM_ERP},
  DBUty in '..\..\..\Utility\DBUty.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFM_Main, FM_Main);
  Application.Run;
end.

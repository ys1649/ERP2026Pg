library SysReport;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  Forms,
  SysUtils,
  Classes,
  Form_Query in 'Form_Query.pas' {Fm_Query},
  Form_SysRepFldDef in 'Form_SysRepFldDef.pas' {FM_SysRepFldDef},
  form_SysReportDef in 'form_SysReportDef.pas' {fm_SysReportDef},
  Form_SysReportEdit in 'Form_SysReportEdit.pas' {fm_SysReportEdit},
  form_SysReportQuery in 'form_SysReportQuery.pas' {fm_SysReportQuery},
  SysReportUnit in 'SysReportUnit.pas',
  Uty in '..\..\Utility\Uty.pas',
  WaitMsg in '..\..\Utility\WaitMsg.pas' {MsgForm},
  RecChoice in '..\..\Utility\RecChoice\RecChoice.pas' {frmRecChoice},
  Form_SysRepFldDefEdit in 'Form_SysRepFldDefEdit.pas' {Fm_SysRepFldDefEdit},
  Form_SelectField in 'Form_SelectField.pas' {fm_SelectField},
  SysReport_Head in 'SysReport_Head.pas',
  DBUty in '..\..\Utility\DBUty.pas';

var
    OldApp     : TApplication;

{$R *.res}

procedure ResApp; stdcall; export;
begin
    Application := OldApp;
end;

procedure init(app:TApplication); stdcall; export;
begin
  Application:=app;
end;

exports ResApp,init,ShowSysReportQuery,ShowSysReportDef,PrintFormReport;

begin
    OldApp := Application;
end.

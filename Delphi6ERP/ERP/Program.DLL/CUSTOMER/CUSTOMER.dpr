library CUSTOMER;

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
  ShareMem,
  FORM_CUSTOMER in 'FORM_CUSTOMER.pas' {FM_CUSTOMER},
  Forms,
  SysUtils,
  Classes,
  Form_Modify_No in 'Form_Modify_No.pas' {FM_Modify_No},
  form_Browse in '..\..\..\Utility\form_Browse.pas' {FM_Browse},
  Form_Query in '..\..\..\SysReport.DLL\program\Form_Query.pas' {Fm_Query},
  RecChoice in '..\..\..\Utility\RecChoice\RecChoice.pas' {frmRecChoice},
  SysReport_Head in '..\..\..\SysReport.DLL\program\SysReport_Head.pas',
  Uty in '..\..\..\Utility\Uty.pas',
  erp_public in '..\UTY\erp_public.pas',
  FORM_ERP_BASE in '..\UTY\FORM_ERP_BASE.pas' {FORM_ERP},
  DBUty in '..\..\..\Utility\DBUty.pas';

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
  FM: TFM_CUSTOMER;
begin
  fm:=TFM_CUSTOMER.Create(application);
  result:=fm;
end;


exports RestoreDllApp,init,Get_Main_Form;

begin
    OldApp := Application;
end.

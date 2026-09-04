program PJ_SysReport;

uses
  Forms,
  Form_Main in 'Form_Main.pas' {Form1},
  SysReport_Head in 'SysReport_Head.pas',
  Uty in '..\..\Utility\Uty.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

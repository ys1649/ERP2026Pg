program SyncProcessFlow_d6;

uses
  Forms,
  form_main in '..\..\..\Product\Program\IERPTool\SyncProcessFlow\form_main.pas' {Form1},
  Uty in 'Uty.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

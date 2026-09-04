program TestSplitEval;

uses
  Forms,
  form_main in 'form_main.pas' {Form1},
  Uty in '..\Uty.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

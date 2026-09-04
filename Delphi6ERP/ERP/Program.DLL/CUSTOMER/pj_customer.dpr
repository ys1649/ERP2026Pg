program pj_customer;

uses
  ShareMem,
  Forms,
  test_main in 'test_main.pas' {Form1},
  Uty in '..\..\..\Utility\Uty.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

program RecChoicePrj;

uses
  Forms,
  RecChoice in 'RecChoice.pas' {frmRecChoice},
  RecChoiceTst in 'RecChoiceTst.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses calc;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var c :TCalculator;
    d:double;
begin
  c:=TCalculator.Create;
  c.Expression:=edit1.Text;
  d:=Eval(edit1.text);

  label1.Caption:=floattostr(d);

end;

end.

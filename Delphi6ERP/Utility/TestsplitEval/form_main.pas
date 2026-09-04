unit form_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Uty;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var SL:TstringList;
  i:integer;
  s:string;
begin
  memo1.Clear;
  s:=edit1.Text;
//  s:='MONTHB+1';
  sl:=splitEval(s);
  for i:=0 to sl.Count-1 do begin
    memo1.Lines.Add(sl.Strings[i]);
  end;


end;

end.

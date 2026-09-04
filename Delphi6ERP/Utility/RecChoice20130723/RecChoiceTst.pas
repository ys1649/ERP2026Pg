unit RecChoiceTst;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db, Mask, DBCtrls, DBTables, ExtCtrls,RecChoice, ADODB;

type
  TForm1 = class(TForm)
    Button1: TButton;
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    Button2: TButton;
    Memo1: TMemo;
    ADOConnection1: TADOConnection;
    QRY: TADOQuery;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
close;
end;

procedure TForm1.Button2Click(Sender: TObject);
VAR R:TWRecChoice;
  i:integer;
begin
	R:=TWRecChoice.Create(self);
  r.DataSet:=QRY;
  r.ResultField:='ACT_NO';
  r.KeyField:='ACT_NO';
  r.AddColunm('ACT_NO','',150);
  r.AddColunm('ACT_NAME','',150);
  r.MultiSelect:=true;
  if r.Excute then begin
    memo1.Lines.Clear;
    for i:=0 to r.SelList.Count-1  do
    begin
      memo1.Lines.Add(r.SelList.Strings[i]);
    end;

  	edit1.Text:=r.SelList[0];
  end;
  r.free;

end;

end.

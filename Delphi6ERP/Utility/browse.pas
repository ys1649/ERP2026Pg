unit browse;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, Db, DBTables, ExtCtrls, DBCtrls;

type
  TfrmBrowse = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Panel1: TPanel;
    Button1: TButton;
    DBNavigator1: TDBNavigator;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure SetGrid;
  public
    procedure Browse(rst: TDataSet);
    { Public declarations }
  end;

var
  frmBrowse: TfrmBrowse;

implementation

{$R *.DFM}

procedure TfrmBrowse.Browse(rst: TDataSet);
begin
  datasource1.dataset:=rst;
  SetGrid;
  self.show;
end;


procedure TfrmBrowse.Button1Click(Sender: TObject);
begin
close;
end;

procedure TfrmBrowse.SetGrid;
var
	i:integer;
begin
	for i:=1 to dbgrid1.Columns.Count-1 do
  	DbGrid1.Columns.items[i].width:=100;

end;

end.

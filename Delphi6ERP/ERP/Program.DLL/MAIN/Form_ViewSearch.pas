unit Form_ViewSearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, DB, ADODB;

type
  TFM_ViewSearch = class(TForm)
    QRY: TADOQuery;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ViewSearch(adoc:TAdoConnection;sql:string;FldCaption:array of string;ResultField:string):variant;
implementation
var fm:TFm_ViewSearch;

{$R *.dfm}
function ViewSearch(adoc:TAdoConnection;sql:string;FldCaption:array of string;ResultField:string):variant;
var
  i:integer;
  DBCol:TColumn;
begin
  fm:=TFm_ViewSearch.Create(Application);
  try
    fm.QRY.Connection:=adoc;
    fm.QRY.SQL.Text:=sql;
    fm.QRY.Open;
    for i:=0 to High(FldCaption) do begin
      dbCol:=fm.dbgrid1.Columns.Add;
      dbCol.FieldName:=fm.QRY.Fields[i].FieldName;
      dbCol.Title.Caption:=FldCaption[i];
    end;
    fm.ShowModal;
    fm.QRY.Close;

  finally
    fm.Free;
  end;


end;
procedure TFM_ViewSearch.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=13 then qry.Locate()
end;

end.

unit RecChoice;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Grids, DBGrids, StdCtrls, Mask,  DB;

type
  TfrmRecChoice = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    DataSource1: TDataSource;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    LblSearchKey: TLabel;
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    MultiSelect:Boolean;
    KeyField:string;
    MarkList:TStringList;
    ResultField:string;
    procedure LocateRec;
  public
    { Public declarations }
  end;

  TWRecChoice=class(TComponent)
  private
    fm:TFrmRecChoice;
    procedure GetChoiceList;
    function GetHeight: integer;
    function GetKeyField: string;
    function GetLeft: integer;
    function GetTop: integer;
    function GetWidth: integer;
    procedure SetDataSet(const Value: TDataset);
    procedure SetHeight(const Value: integer);
    procedure SetKeyField(const Value: string);
    procedure SetLeft(const Value: integer);
    procedure SetTop(const Value: integer);
    procedure SetWidth(const Value: integer);
    function GetMultiSelect: Boolean;
    procedure SetMultiSelect(const Value: Boolean);
    function GetList: TStringList;
    function GetResultField: string;
    procedure SetResultField(const Value: string);
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    property ResultField:string
            read GetResultField write SetResultField;
    property DataSet:TDataset Write SetDataSet;
    property top:integer Read GetTop Write SetTop;
    property Left:integer Read GetLeft write SetLeft;
    property Height:integer Read GetHeight write SetHeight;
    property Width:integer Read GetWidth write SetWidth;
    property KeyField:string Read GetKeyField write SetKeyField;
    property MultiSelect:Boolean Read GetMultiSelect write SetMultiSelect;
    property SelList:TStringList Read GetList;
    function Excute:Boolean;
    procedure AddColunm(Field,Title:string;Colwidth:integer);
    procedure ClearColunm;

  end;

{$R *.DFM}
implementation



{ TWRecChoice }

procedure TWRecChoice.AddColunm(Field,Title: string; Colwidth: integer);
var DBCol:Tcolumn;
begin
	DBCol:=fm.DBGrid1.Columns.Add;
  DBCol.FieldName:=Field;
  if title='' then
  	DBCol.Title.Caption:=Field
  else
  	DBCol.Title.Caption:=Title;
    
  DBCOL.Width:=ColWidth;
end;

procedure TWRecChoice.ClearColunm;
begin
	fm.DBGrid1.Columns.Clear;
end;

constructor TWRecChoice.Create;
begin
	fm:=TfrmRecChoice.Create(Application);
  fm.Height:=400;
  fm.Width:=350;
  fm.MultiSelect:=False;
  fm.LblSearchKey.Caption:='';
  fm.MarkList:=TStringList.Create;
end;

destructor TWRecChoice.Destroy;
begin
  fm.MarkList.Free;
  fm.Free;
end;

function TWRecChoice.Excute: Boolean;
var WasActive:Boolean;
begin
  WasActive:=fm.DataSource1.DataSet.active;
  if not fm.DataSource1.DataSet.active then
    fm.DataSource1.DataSet.active:=True;
	if fm.ShowModal=mrOK then begin
  	GetChoiceList;
  	result:=true;
  end else
  	result:=false;
  fm.DataSource1.DataSet.active:=WasActive;
end;

procedure TWRecChoice.GetChoiceList;
begin
end;

function TWRecChoice.GetHeight: integer;
begin
	result:=fm.Height;
end;

function TWRecChoice.GetKeyField: string;
begin
	result:=fm.KeyField;
end;

function TWRecChoice.GetLeft: integer;
begin
	result:=fm.Left;
end;

function TWRecChoice.GetList: TStringList;
begin
  result:=fm.MarkList;
end;

function TWRecChoice.GetMultiSelect: Boolean;
begin
	result:=fm.MultiSelect;
end;

function TWRecChoice.GetResultField: string;
begin
  result:=fm.ResultField;
end;

function TWRecChoice.GetTop: integer;
begin
	result:=fm.Top;
end;

function TWRecChoice.GetWidth: integer;
begin
	result:=fm.Width;
end;

procedure TWRecChoice.SetDataSet(const Value: TDataset);
begin
	fm.DataSource1.DataSet:=value;
end;

procedure TWRecChoice.SetHeight(const Value: integer);
begin
	fm.Height:=value;
end;

procedure TWRecChoice.SetKeyField(const Value: string);
begin
	fm.KeyField:=value;
end;

procedure TWRecChoice.SetLeft(const Value: integer);
begin
	fm.Left:=value;
end;

procedure TWRecChoice.SetMultiSelect(const Value: Boolean);
begin
	fm.MultiSelect:=Value;
  if fm.MultiSelect then
    fm.DBGrid1.Options:=fm.DBGrid1.Options+[dgMultiSelect]
  else
    fm.DBGrid1.Options:=fm.DBGrid1.Options-[dgMultiSelect];


end;

procedure TWRecChoice.SetResultField(const Value: string);
begin
  fm.ResultField:=value;
end;

procedure TWRecChoice.SetTop(const Value: integer);
begin
	fm.top:=value;
end;

procedure TWRecChoice.SetWidth(const Value: integer);
begin
	fm.Width:=value;
end;



procedure TfrmRecChoice.DBGrid1DblClick(Sender: TObject);
begin
  Button1Click(Button1);
  ModalResult:=mrOk;
end;

procedure TfrmRecChoice.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
    mark:boolean;
begin
  if ssShift in shift then exit; 
	case key of
  VK_Escape:
  	Begin
    	key:=0;
  		ModalResult:=mrCancel;
	  end;
  VK_Space:
  	begin
    	key:=0;
      LblSearchKey.Caption:='';
      mark:=DbGrid1.SelectedRows.CurrentRowSelected;
      DbGrid1.SelectedRows.CurrentRowSelected:= not mark;
	  end;
  VK_Down:
  	begin
    	key:=0;
      DbGrid1.DataSource.DataSet.Next;
	  end;
  VK_UP:
  	begin
    	key:=0;
      DbGrid1.DataSource.DataSet.Prior;
	  end;

  end;

end;

procedure TfrmRecChoice.Button1Click(Sender: TObject);
var
  dst:tDataset;
  i:integer;
begin
  ModalResult:=mrOK;
  dst:=datasource1.DataSet;
  MarkList.Clear;
	if (dbgrid1.SelectedRows.Count=0) then //至少傳回一個,才不會導致空陣列
    MarkList.Add(dst.fieldbyName(ResultField).asstring);

  for i:=0 to dbgrid1.SelectedRows.Count-1 do
  begin
    dst.GotoBookmark(pointer(DBGrid1.SelectedRows.Items[i]));
    MarkList.Add(dst.fieldbyname(ResultField).AsString);
  end;

end;

procedure TfrmRecChoice.LocateRec;
var s:string;
begin
 s:=trim(LblSearchKey.Caption);
 if s='' then exit;
 DataSource1.DataSet.Locate(KeyField,s,[LoPartialKey]);
end;

procedure TfrmRecChoice.FormKeyPress(Sender: TObject; var Key: Char);
var s:string;
begin
  s:=LblSearchKey.Caption;
  case key of
    #8:delete(s,length(s),1);
    #33..'z':s:=s+key;
    else s:=s+key;
  end;
  LblSearchKey.Caption:=s;
  LocateRec;
end;

end.

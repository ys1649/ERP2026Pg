unit RecChoice;
{============================================================================
note history :2004/02/28 Multi-Select
              We use the procedure AddList() & DelList to recording user selected
              record.
              Since if we use the DbGrid1.SelectedRows(BookMarkList) to get
              the selected list ,
              we can not to get the user selected sequence,(順序一定從上往下,
              不管 user 點選的順序)

              2004/02/29 Use the dbgrid multi-selected function
                  1:  Use the DatasetThroughList to recording all through record.
                      Assign the DsetAfterScroll() event procedure
                      to fm.DataSource1.DataSet.AfterScroll property
                      in TWRecChoice.Excute().
                      This procedure use a TstringList variable DatasetThroughList
                      to recording all through record.
                  2:  On execute() run the GetChoiceList() to get all user selected
                      record.
                      GetChoiceList() will navigate all the element for
                      the TStringList variable DatasetThroughList
                      from the last element,Check the element whether in the
                      fm.DBGrid1.SelectedRows(), if true, add the record into the
                      MarkList
                  3:  return the MarkList.
                      if the MarkList is empty then add the current record into
                      the MarkList.

              2004/06/27 前一版本有bug 還原到不管 user 點選的順序
=============================================================================}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Grids, DBGrids, StdCtrls,db,DbTables, Mask, DBCtrls, ADODB;

type
  TfrmRecChoice = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    DataSource1: TDataSource;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    lblKey: TLabel;
    EditKey: TEdit;
    btnSearch: TButton;
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    MultiSelect:Boolean;
    KeyField:string;
    MarkList:TStringList;

    ResultField:string;
    procedure RecSelected;
//    procedure AddList(s:string);
//    procedure DelList(s:string);
    { Private declarations }
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

uses Uty;

procedure TfrmRecChoice.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin

end;


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
  fm.MultiSelect:=False;
  fm.EditKey.Text:='';
  fm.MarkList:=TStringList.Create;
end;

destructor TWRecChoice.Destroy;
begin
  fm.MarkList.Free;
  fm.Free;
end;

function TWRecChoice.Excute: Boolean;
var WasActive:Boolean;
    r :integer;
begin
  try
    WasActive:=fm.DataSource1.DataSet.active;
    if not fm.DataSource1.DataSet.active then
      fm.DataSource1.DataSet.active:=True;
    r:=fm.ShowModal;
  finally
    fm.DataSource1.DataSet.AfterScroll:=nil;
  end;
	if r=mrOK then begin
  	GetChoiceList;
  	result:=true;
  end else
  	result:=false;
  fm.DataSource1.DataSet.active:=WasActive;
end;

procedure TWRecChoice.GetChoiceList;
var i,cnt:integer;
    book,s,lastRec:string;
begin
  lastRec:=fm.DataSource1.DataSet.fieldbyname(fm.ResultField).AsString;
  fm.MarkList.Clear;
  cnt:=fm.DBGrid1.SelectedRows.Count;
  for i:= 0 to cnt-1 do begin
    book:=fm.DBGrid1.SelectedRows.Items[i];
    fm.DataSource1.DataSet.GotoBookmark(pointer(book));
    s:=fm.DataSource1.DataSet.fieldbyname(fm.ResultField).AsString;
    fm.MarkList.Add(s);
  end;



  if fm.MarkList.Count=0 then begin
    fm.MarkList.Add(lastRec);
  end;
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
  IF value then
    FM.DBGrid1.Options:=FM.DBGrid1.Options+[dgMultiSelect]
  else
    FM.DBGrid1.Options:=FM.DBGrid1.Options-[dgMultiSelect];
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

procedure TfrmRecChoice.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var dset:TDataset;
begin
	dset:=DataSource1.DataSet;
	case key of
  VK_Return:
  	Begin
    	key:=0;
    	ModalResult:=mrOk;
	  end;
  VK_Escape:
  	Begin
    	key:=0;
  		ModalResult:=mrCancel;
	  end;
  VK_Space:
  	begin
    	key:=0;
      EditKey.Text:='';
      RecSelected;
	  end;
  VK_UP:
  	begin
    	key:=0;
	    dset.Prior;
	  end;
  VK_Down:
  	begin
    	key:=0;
	    dset.Next;
    end;
  VK_Home:
  	begin
	    key:=0;
    	dset.first;
  	end;
  VK_END:
  	begin
    	key:=0;
    	dset.Last;
	  end;
  VK_Prior:
  	begin
    	key:=0;
    	dset.MoveBy(-10);
	  end;
  VK_Next:
  	begin
    	key:=0;
    	dset.MoveBy(10);
	  end;
  end;
end;

{procedure TfrmRecChoice.AddList(s: string);
begin
  if markList.IndexOf(s)=-1 then  MarkList.Add(s);
end;

procedure TfrmRecChoice.DelList(s: string);
var n:integer;
begin
  n:=MarkList.IndexOf(s);
  if n <>-1 then MarkList.Delete(n);
end;
}

procedure TfrmRecChoice.DBGrid1DblClick(Sender: TObject);
begin
 ModalResult:=mrok;
//close;
end;

procedure TfrmRecChoice.RecSelected;
var 
    mark:boolean;
begin
        mark:=DbGrid1.SelectedRows.CurrentRowSelected;
		    DbGrid1.SelectedRows.CurrentRowSelected:= not mark;
{        mark:=DbGrid1.SelectedRows.CurrentRowSelected;
        if mark then
          AddList(s)
        else
          DelList(s);
}

end;




end.

unit Form_Search;
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Grids, DBGrids, StdCtrls,db,DbTables, Mask, DBCtrls, ADODB,DBClient,
  Provider;

type
  TFM_Search = class(TForm)
    grdMain: TDBGrid;
    Panel1: TPanel;
    dsMain: TDataSource;
    Panel2: TPanel;
    btnOK: TButton;
    Button2: TButton;
    lblKey: TLabel;
    EditKey: TEdit;
    btnSearch: TButton;
    qryMain: TADOQuery;
    ADOConnection1: TADOConnection;
    dspMain: TDataSetProvider;
    cdsMain: TClientDataSet;
    procedure grdMainDblClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
  private
    adodc:TADOConnection;
    lstFields:TStringList;
    lstFieldDisplay:TStringList;
    sMainSql:string;
    MultiSelect:Boolean;
    procedure RefreshData;
    function GetWhereStr:string;
    procedure SetColunm;
  public
    function Init(adodc: TADOConnection; sql, FieldsList, DispList,
      initKey: string; cdsResult: TClientdataset;
      MultiSelect: boolean): Boolean;
  end;


{$R *.DFM}
implementation

uses Uty, DBUty, erp_public;


procedure TFM_Search.grdMainDblClick(Sender: TObject);
begin
 btnOKClick(nil);

end;




function TFM_Search.GetWhereStr: string;
var lstKey:TStringList;
    i:Integer;
    cond:string;
    skey:string;
begin
  skey:=Trim(EditKey.Text);
  if skey='' then begin
    Result:='';
    Exit;
  end;
  lstKey:=StrSplit(EditKey.Text,' ');
  cond:=#39;
  try
    for i:=0 to lstKey.Count-1 do begin
      cond:=cond+'%'+lstKey.Strings[i];
    end;
    cond:=cond+'%'#39;

    Result:='WHERE ';
    for i:=0 to lstFields.Count-1 do begin
      Result:=Result+lstFields.Strings[i] + ' LIKE '+cond+CR+'OR ';
    end;
    Result:=StrMid(Result,1,length(Result)-3);

  finally
    lstKey.Free;

  end;   

end;

procedure TFM_Search.SetColunm;
var DBCol:Tcolumn;
    i:Integer;
begin
  for i:=0 to lstFields.Count-1 do begin
    DBCol:=grdMain.Columns.Add;
    DBCol.FieldName:=lstFields.Strings[i];
    DBCol.Title.Caption:=lstFieldDisplay.Strings[i];
    DBCOL.Width:=120;
  end;
end;


function TFM_Search.Init(adodc: TADOConnection; sql, FieldsList,
  DispList: string;initKey:string;cdsResult:TClientdataset;MultiSelect:boolean):Boolean;
begin
  Self.MultiSelect:=MultiSelect;
  if MultiSelect then begin
    grdMain.Options:=grdMain.Options+[dgMultiSelect];
  end else begin
    grdMain.Options:=grdMain.Options-[dgMultiSelect];

  end;
  Self.adodc:=adodc;
  setAdoConnection(Self,adodc);
  lstFields:=StrSplit(FieldsList,',');
  lstFieldDisplay:=StrSplit(FieldsList,',');
  if lstFields.Count<> lstFieldDisplay.Count then begin
    raise Exception.Create('欄位數目與顯示數目不一致 !');
  end;
  SetColunm;
  sMainSql:=sql;
  EditKey.Text:=initKey;
  RefreshData;
  if ShowModal=mrcancel then begin
    Result:=False;
    Exit;
  end;
  CopySelectedData(grdMain,cdsResult);
  Result:=True;

end;

procedure TFM_Search.RefreshData;
var sWhere:string;
    sql:string;
begin
  sWhere:=GetWhereStr;
  if sWhere='' then Exit;
  sql:=sMainSql+CR+sWhere;
  debug(sql);
  DoQrySelect(sql,adodc,cdsMain);

end;



procedure TFM_Search.btnOKClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TFM_Search.btnSearchClick(Sender: TObject);
begin
  RefreshData;
end;

end.

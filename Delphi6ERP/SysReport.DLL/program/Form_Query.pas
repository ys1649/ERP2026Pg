unit Form_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons, dxExEdtr,
  dxEdLib, dxCntner, dxEditor, Grids, ComCtrls, wwdbdatetimepicker, uty,SysReport_Head;



const MinimaDate=-36522.0;    // 1800/01/01
const MaximaDate=365609.0;    // 2900/12/31
const MinimaNumberic=-2000000000;
const MaximaNumberic=2000000000;
const MinimaString=#1;
const MaximaString='龘龘龘';

type
  TQueryMode    =(Query,Report);
  TDataType     =(wdString,wdDate,wdNumberic);
  TCtrlType     =(wcEdit,wcDate,wcListItem,wcSQL);
  TQueryType    =(wqSingle,wqRange,wqMultiSelect);


  PQueryField=^TQueryField;
  TQueryField = record
    FieldName       :string;
    DispName        :string;
    TableAlias      :string;
    DataType        :TDataType;
    CtrlType        :TCtrlType;
    QueryType       :TQueryType;
    IsMustCriteria  :boolean;
//    IsWhere         :boolean;
//    IsSort          :boolean;
    ListValue       :string;
    ListSql         :string;
    ListReturnField :string;
    ListFieldDisp   :string;
    SortDec         :boolean;     //  是否遞減排序
    Ctrl1           :TControl;
    Ctrl2           :TControl;
    IsUsed          :Boolean;
    WhereText       :string;
  end;

  TFm_Query = class(TForm)
    GrpTitle: TGroupBox;
    Panel1: TPanel;
    BtnPreview: TButton;
    BtnPrint: TButton;
    BtnExport: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    BtnCancel: TButton;
    BtnOk: TButton;
    Panel2: TPanel;
    GrpQuery: TGroupBox;
    ScrollBox: TScrollBox;
    Panel3: TPanel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    GrpSort: TGroupBox;
    GridSort: TStringGrid;
    Button1: TButton;
    Panel4: TPanel;
    BtnSortDec: TButton;
    BtnSortInc: TButton;
    Panel5: TPanel;
    BtnDown: TSpeedButton;
    BtnUp: TSpeedButton;
    Label3: TLabel;
    procedure BtnDownClick(Sender: TObject);
    procedure BtnUpClick(Sender: TObject);
    procedure BtnSortIncClick(Sender: TObject);
    procedure BtnSortDecClick(Sender: TObject);
    procedure BtnPreviewClick(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    DataBaseType:TDataBaseType;
    WhereList,OrderList:TList;
    AdoDc:TAdoConnection;
    function GetListItem(s:string):string;
    procedure CreateQryCtrl(fld: PQueryField; Qryindex: integer);
    procedure dxButtonClick(Sender: TObject; AbsoluteIndex: Integer);
    procedure ShowOrderList;
    function GetSqlWhere:string;
    function GetSqlOrder:string;
    function GetMultiSelectWhere(lin:string;DataType:TDataType):string;

  public
    sqlWhere:string;
    sqlOrder:string;
    sqlWhereList:TstringList;
    CtrlTextList:TStringList;
    procedure Init(Adodc: TAdoConnection; Title1,Title2:string;
          WhereList,OrderList:TList;QueryMode:TQueryMode;dbsType:TDataBaseType);
    procedure SetCtrlText(n: integer; ctrl1_text, ctrl2_text: string);
  end;

{function GetReportSqlWhere(Adodc: TAdoConnection; Title1,Title2:string;
          WhereList,OrderList:TList;var sqlWhere,sqlOrder:string): TModalResult;
}
function JoinWhere(MainWhere,where2:string):string;
function JoinOrder(MainOrder,order2:string):string;
procedure ReleaseQryList(var WhereList,OrderList:TList);
procedure NewQueryFld(var fld:PQueryField);


implementation

uses RecChoice;

{$R *.dfm}

{ TFm_SysReportQuery }


procedure TFm_Query.CreateQryCtrl(fld:PQueryField;Qryindex:integer);
var CtrlClass:TControlClass;
    ctrl:TControl;
begin
    if (fld.DataType=wdDate) and (fld.CtrlType=wcEdit) then fld.CtrlType:=wcDate;

    if fld.CtrlType=wcEdit then
      CtrlClass:=TEdit
    else if fld.CtrlType=wcDate then
      CtrlClass:=TwwDBDateTimePicker
    else if fld.CtrlType=wcListItem then
      CtrlClass:=TComboBox
    else if fld.CtrlType=wcSQL then
      CtrlClass:=TdxButtonEdit
    else
    begin
      ErrMsg('Error in [TFm_Query.CreateQryCtrl]',user);
      exit;
    end;

//=========================================================================
//    建立控制項
//=========================================================================
    fld.ctrl1:=CtrlClass.Create(self);
    fld.ctrl1.SetBounds(120,QryIndex*32+12,140,24);
    fld.ctrl1.Parent:=ScrollBox;
    fld.ctrl1.Visible:=true;
    fld.Ctrl2:=nil;
    if fld.CtrlType=wcDate then
    BEGIN
      (fld.Ctrl1 as TwwDBDateTimePicker).UnboundDataType:=wwDTEdtDateTime;
//      (fld.Ctrl1 as TwwDBDateTimePicker).Options:=[];
    END;

    if (fld.QueryType=wqRange)  then
    begin
      fld.ctrl2:=CtrlClass.Create(self);
      fld.ctrl2.SetBounds(fld.ctrl1.Left+170,fld.ctrl1.Top,140,24);
      fld.ctrl2.Parent:=ScrollBox;
      fld.ctrl2.Visible:=true;
      with TLabel.Create(self) do
      begin
        Parent:=ScrollBox;
        Caption:='～';
        SetBounds(fld.ctrl1.Left+146,fld.ctrl1.top,16,16);
        Visible:=true;
      end;
      if fld.CtrlType=wcDate then
        (fld.Ctrl2 as TwwDBDateTimePicker).UnboundDataType:=wwDTEdtDateTime;

    end;

//=========================================================================
//    建立顯示欄位名稱
//=========================================================================
      ctrl:=TLabel.Create(self);
      TLabel(ctrl).Parent:=ScrollBox;
      TLabel(ctrl).AutoSize:=true;
      TLabel(ctrl).Visible:=true;
      TLabel(ctrl).SetBounds(10,fld.ctrl1.Top+5,100,16);
      TLabel(ctrl).Caption:=fld.DispName;
      if fld.IsMustCriteria then
        TLabel(ctrl).Font.Color:=clRed;


//=========================================================================
//    設定控制項類別為 ListItem 的item
//=========================================================================
  if fld.CtrlType=wcListItem then
  begin
    (fld.Ctrl1 AS TComboBox).Style:=csDropDownList;
    (fld.Ctrl1 AS TComboBox).Items.Text:=GetListItem(fld.ListValue);
    if fld.QueryType=wqRange then
    begin
      (fld.Ctrl2 AS TComboBox).Style:=csDropDownList;
      TComboBox(fld.Ctrl2).Items.Text:=GetListItem(fld.ListValue);
    end;

  end;

//=========================================================================
//    設定控制項類別為 SQL 的Button Event
//=========================================================================
  if fld.CtrlType=wcSQL then
  begin
    (fld.Ctrl1 AS TdxButtonEdit).Tag:=QryIndex;
    (fld.Ctrl1 AS TdxButtonEdit).OnButtonClick:=dxButtonClick;
    if fld.QueryType=wqMultiSelect then
      (fld.Ctrl1 AS TdxButtonEdit).Color:=$00FFFF80;
      
    if fld.QueryType=wqRange then
    begin
      (fld.Ctrl2 AS TdxButtonEdit).Tag:=QryIndex;
      (fld.Ctrl2 AS TdxButtonEdit).OnButtonClick:=dxButtonClick;
    end;
  end;

end;

function TFm_Query.GetListItem(s: string): string;
begin
  s:=#13#10+s;
  strReplace(s,',',#13#10);
  result:=s
end;

{function GetReportSqlWhere(Adodc: TAdoConnection; Title1,Title2:string;
          WhereList,OrderList:TList;var sqlWhere,sqlOrder:string): TModalResult;
var fm:Tfm_Query;
begin
  fm:=Tfm_Query.Create(application);
  try
    fm.Init(adodc,title1,title2,WhereList,OrderList,Report);
    result:=fm.ShowModal;
    if result <> mrCancel then
    begin
      sqlWhere:=fm.sqlWhere;
      sqlOrder:=fm.sqlOrder;
    end;
  finally
    fm.Free;
  end;


end;
}


procedure TFm_Query.dxButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var qry:TAdoQuery;
  fld:PQueryField;
  i:integer;
  GetRec:TWRecChoice;
  strList:TStringList;
  dispName,fldName:string;
  s:string;
begin
  i:=(sender as TdxButtonEdit).Tag;
  fld:=WhereList.Items[i];

  strList:=TStringList.Create;
	GetRec:=TWRecChoice.Create(self);
  qry:=TAdoQuery.Create(self);
  try
    qry.Connection:=adodc;
    qry.SQL.Text:=fld.ListSql;
    qry.Open;
    GetRec.DataSet:=qry;
    GetRec.ResultField:=fld.ListReturnField;
    StrDivide(fld.ListFieldDisp,',',strList);
    for i:=0 to strList.Count-1 do
    begin
      DispName:=strList.Strings[i];
      fldName:=qry.Fields[i].FieldName;
      GetRec.AddColunm(FldName,DispName,150);
    end;
    GetRec.KeyField:=fld.ListReturnField;

    GetRec.MultiSelect:=fld.QueryType=wqMultiSelect;
    if GetRec.Excute then
    begin
      if not GetRec.MultiSelect then
      BEGIN
        if fld.DataType=wdDate then
          (Sender as TdxButtonEdit).Text:=datetostr(strtodatetime(GetRec.SelList.Strings[0]))
        else
          (Sender as TdxButtonEdit).Text:=GetRec.SelList.Strings[0]

      end else
      begin
        s:='';
        for i:=0 to GetRec.SelList.Count-1 do
        begin
          if fld.DataType=wdDate then
            s:=s+datetostr(strtodatetime(GetRec.SelList.Strings[i]))+'|'
          else
            s:=s+GetRec.SelList.Strings[i]+'|';
        end;
        delete(s,length(s),1);
        (Sender as TdxButtonEdit).Text:=s;
      end;
    end;
  finally
    qry.Close;
    qry.Free;
    strList.Free;
    GetRec.Free;
  end;

end;

procedure TFm_Query.BtnDownClick(Sender: TObject);
var i:integer;
begin
  if OrderList.Count=1 then exit;
  i:=GridSort.Row;
  if i=GridSort.RowCount-1 THEN EXIT;
  OrderList.Exchange(i,i+1);
  ShowOrderList;
  GridSort.Row:=i+1;
end;

procedure TFm_Query.BtnUpClick(Sender: TObject);
var i:integer;
begin
  if OrderList.Count=1 then exit;
  i:=GridSort.Row;
  if i=0 THEN EXIT;
  OrderList.Exchange(i,i-1);
  ShowOrderList;
  GridSort.Row:=i-1;
end;

procedure TFm_Query.ShowOrderList;
var i:integer;
    fld:PQueryField;
    s:string;
begin
  GridSort.RowCount:=0;
  GridSort.RowCount:=OrderList.Count;
  for i:=0 to OrderList.Count-1 do
  begin
    fld:=OrderList.Items[i];
    if fld.SortDec then s:=' (Z.A)' else s:=' (A.Z)';
    GridSort.Cells[0,i]:=fld.DispName;
    GridSort.Cells[1,i]:=s;
  end;

end;

procedure TFm_Query.BtnSortIncClick(Sender: TObject);
var i:integer;
    fld:PQueryField;
begin
  i:=GridSort.Row;
  fld:=OrderList.Items[i];
  fld.SortDec:=false;
  ShowOrderList;
  GridSort.Row:=i;
end;

procedure TFm_Query.BtnSortDecClick(Sender: TObject);
var i:integer;
    fld:PQueryField;
begin
  i:=GridSort.Row;
  fld:=OrderList.Items[i];
  fld.SortDec:=True;
  ShowOrderList;
  GridSort.Row:=i;

end;

procedure TFm_Query.BtnPreviewClick(Sender: TObject);
begin
  sqlWhere:=GetSqlWhere;
  SqlOrder:=GetSqlOrder;
  ModalResult:=mrPreview;
end;

function TFm_Query.GetSqlWhere: string;
const MemSize=32000;
var i:integer;
    fld:PQueryField;
    WhereStr,text1,text2:string;
    buf:pointer;
    slWhere:TStringList;
    fldName:string;
    tmp:string;
    DateFrom,DateTo:TDateTime;
begin
  buf:=allocmem(MemSize);
  slWhere:=TStringList.Create;
  try
    CtrlTextList.Clear;
    for i:=0 to WhereList.Count-1 do
    begin
      fld:=WhereList.Items[i];
      fld.WhereText:=fld.DispName+' =(不限制)';
      fldName:=FLD.TableAlias+'.'+fld.FieldName;

//==============================================================
//  if fld.QueryType='Single' then
//==============================================================
      if fld.QueryType=wqSingle then
      begin
        fld.Ctrl1.GetTextBuf(buf,MemSize);
        text1:=trim(pchar(buf));
        if text1='' then
          if fld.IsMustCriteria then
            ErrMsg('['+fld.DispName+']  為必要查詢條件,不可忽略 !',user)
          else begin
            CtrlTextList.Add(text1);
            continue;
          end;
        fld.IsUsed:=True;
        IF FLD.DataType=wdDate then
        begin
          case DataBaseType of
            MSSQL:
              WhereStr:='fldName='+sqlDateTimeSql((fld.Ctrl1 as TwwDBDateTimePicker).date);
            ACCESS:
              WhereStr:='DateValue('+fldName+') = #'+FormatDateTime('mm-dd-yyyy',(fld.Ctrl1 as TwwDBDateTimePicker).date)+'# ';
          else
            ErrMsg('DataBase TYPE not support',user);
          end;
          fld.WhereText:=fld.DispName+ ' = '+text1;
        end else if fld.DataType=wdString then
        begin
          WhereStr:=fldName+' like '+sqlStr(text1);
          fld.WhereText:=fld.DispName+ ': LIKE '+text1;
        end else
        begin
          WhereStr:=fldName+' = '+text1;
          fld.WhereText:=fld.DispName+ ' = '+text1;
        end;
        CtrlTextList.Add(text1);
//==============================================================
//  if fld.QueryType='Range' then
//==============================================================
      end else if fld.QueryType=wqRange then
      begin
        DateFrom:=0;
        DateTo:=0;
        fld.Ctrl1.GetTextBuf(buf,MemSize);
        text1:=trim(pchar(buf));
        fld.Ctrl2.GetTextBuf(buf,MemSize);
        text2:=trim(pchar(buf));
        if (text1='') and (text2='') then
          if fld.IsMustCriteria then
            ErrMsg('['+fld.DispName+']  為必要查詢條件,不可忽略 !',user)
          else begin
            CtrlTextList.Add(text1);
            CtrlTextList.Add(text2);
            continue;
          end;
        fld.IsUsed:=True;

        if fld.DataType=wdDate then
        begin
          if text1<>'' then DateFrom:=(fld.Ctrl1 as TwwDBDateTimePicker).date;
          if text2<>'' then DateTo:=(fld.Ctrl2 as TwwDBDateTimePicker).date;
        end;

        if text1='' then
        begin
          if fld.DataType=wdDate then
          begin
            text1:=datetostr(MinimaDate);
            DateFrom:=MinimaDate;
          end else if fld.DataType=wdNumberic then
            text1:=floattostr(MinimaNumberic)
          else if fld.DataType=wdString then
            text1:=MinimaString;
          fld.WhereText:=fld.DispName+ ' : ～ '+text2;
        end else if text2='' then
        begin
          if fld.DataType=wdDate then
          begin
            text2:=datetostr(MaximaDate);
            DateTo:=MaximaDate;
          end else if fld.DataType=wdNumberic then
            text2:=floattostr(MaximaNumberic)
          else if fld.DataType=wdString then
            text2:=MaximaString;
          fld.WhereText:=fld.DispName+ ' :'+text1+' ～';
        end else
        begin
          fld.WhereText:=fld.DispName+ ' :'+text1+' ～ ' +text2;
        end;


        if fld.DataType=wdDate then
        begin
          case DataBaseType of
            MSSQL:
              WhereStr:=fldName+' >='+TAB+SqlDateTimeSql(DateFrom) +CR
                      +'  AND '+fldName+ ' <'+TAB+ SqlDateTimeSql(DateTo+1);
            ACCESS:
              WhereStr:='DateValue('+fldName+') BETWEEN #'
                        +FormatDateTime('mm-dd-yyyy',strtodate(text1))+'# AND #'
                        +FormatDateTime('mm-dd-yyyy',strtodate(text2))+'# ';
          else
            ErrMsg('DataBase TYPE not support',user);
          end;
        end else if fld.DataType=wdString then
        begin
          WhereStr:=fldName+' BETWEEN '+sqlStr(text1) + ' AND '+ SqlStr(text2)
        end else
          WhereStr:=fldName+' BETWEEN '+text1 + ' AND '+ text2;

        CtrlTextList.Add(text1);
        CtrlTextList.Add(text2);

//==============================================================
//  if fld.QueryType='MultiSelect'
//=====================-=========================================
      end else if fld.QueryType=wqMultiSelect then
      begin
        fld.Ctrl1.GetTextBuf(buf,MemSize);
        text1:=trim(pchar(buf));
        if text1='' then
          if fld.IsMustCriteria then
            ErrMsg('['+fld.DispName+']  為必要查詢條件,不可忽略 !',user)
          else begin
            CtrlTextList.Add(text1);
            continue;
          end;

        fld.IsUsed:=True;
        if fld.DataType=wdDate then
        begin
          case DataBaseType of
            MSSQL:
              WhereStr:=fldName+' IN '+GetMultiSelectWhere(text1,fld.DataType);
            ACCESS:
              WhereStr:='DateValue('+fldName+') IN '+GetMultiSelectWhere(text1,fld.DataType);
          else
            ErrMsg('DataBase TYPE not support',user);
          end;

        end else
          WhereStr:=fldName+' IN '+GetMultiSelectWhere(text1,fld.DataType);



        tmp:=text1;
        StrReplace(tmp,'|',',');
        fld.WhereText:=fld.DispName +' : 含('+tmp+')';
        CtrlTextList.Add(tmp);
      end else
      begin
        ErrMsg('查詢欄位定義錯誤 !! '+#13#13+'欄位名稱='+ fld.FieldName,USER);
        exit;
      end;

      slWhere.Add(WhereStr);
    end;    //  for i:=0 to WhereList.Count-1 do
    WhereStr:='';
    sqlWhereList.Clear;
    for i:= 0 to slWhere.Count-1 do begin
      sqlWhereList.Add(slWhere.Strings[i]);
      WhereStr:=WhereStr+'  AND '+slWhere.Strings[i] +CR;
    end;
    result:=strMid(WhereStr,7);
  finally
    FreeMem(buf);
    slWhere.Free;
  end;

end;


function TFm_Query.GetMultiSelectWhere(lin:string;DataType: TDataType): string;
var s:string;
    list:TStringList;
    i:integer;
begin
  list:=TStringlist.Create;
  try
      StrDivide(lin,'|',list);
      s:='';
      case DataType of
        wdString:
          for i:=0 to list.Count-1 do
            s:=s+sqlStr(list.Strings[i])+',';
        wdNumberic:
          for i:=0 to list.Count-1 do
            s:=s+list.Strings[i]+',';
        wdDate:
        begin
          case DataBaseType of
            MSSQL:
              for i:=0 to list.Count-1 do
                s:=s+SqlDateTimeSql(strtodatetime(list.Strings[i]))+',';
            Access:
              for i:=0 to list.Count-1 do
                s:=s+'#'+FormatDateTime('mm-dd-yyyy',strtodatetime(list.Strings[i]))+'#,';

          else 
            ErrMsg('DataBase Type not Support!',user);
          end;
        end;
      else
        ErrMsg('DataType not Support!',user);
      end;
      result:='('+copy(s,1,length(s)-1)+')';
  finally
    list.Free;
  end;


end;

function TFm_Query.GetSqlOrder: string;
var i:integer;
    s:string;
    fld:PQueryField;
begin
  for i:=0 to OrderList.Count-1 do
  begin
    fld:=OrderList.Items[i];
    if fld.SortDec then
      s:=s+iif(FLD.TableAlias='','', FLD.TableAlias+'.')+  fld.FieldName+' DESC,'
    else
      s:=s+iif(FLD.TableAlias='','', FLD.TableAlias+'.')+  fld.FieldName+','
  end;
  result:=copy(s,1,length(s)-1);
end;

procedure TFm_Query.BtnPrintClick(Sender: TObject);
begin
  sqlWhere:=GetSqlWhere;
  SqlOrder:=GetSqlOrder;
  ModalResult:=MrPrint;
end;

procedure TFm_Query.BtnExportClick(Sender: TObject);
begin
  sqlWhere:=GetSqlWhere;
  SqlOrder:=GetSqlOrder;
  ModalResult:=MrExport;
end;

procedure TFm_Query.Init(Adodc: TAdoConnection; Title1, Title2: string;
  WhereList, OrderList: TList;QueryMode:TQueryMode;dbsType:TDataBaseType);
var i:integer;
    fld:PQueryField;
begin
    DataBaseType:=dbsType;
    SetOwnerCtrlReadonly(self,False);
    SetCtrlReadonly(Edit1,True);
    SetCtrlReadonly(Edit2,True);
    Edit1.Text:=title1;
    Edit2.Text:=title2;
    self.adodc:=adodc;
    sqlWhereList:=TStringList.Create;
    ctrlTextList:=TStringList.Create;
    self.WhereList:=WhereList;
    self.OrderList:=OrderList;
    self.ShowOrderList;
    if self.OrderList.Count<>0 then
      self.GridSort.Row:=0;
    for i:=0 to WhereList.Count-1 do
    begin
      fld:=WhereList.items[i];
      CreateQryCtrl(fld,i);
    end;
    case QueryMode of
      Report:
      begin
        GrpTitle.Visible:=true;
        BtnPreview.Visible:=True;
        BtnPrint.Visible:=True;
        BtnExport.Visible:=True;
        BtnOk.Visible:=False;
      end ;
      Query:
      begin
        GrpTitle.Visible:=False;
        BtnPreview.Visible:=false;
        BtnPrint.Visible:=false;
        BtnExport.Visible:=false;
        BtnOk.Visible:=True;
      end ;
    end;

end;


function JoinWhere(MainWhere,where2:string):string;
begin
  MainWhere:=trim(MainWhere);
  where2:=trim(where2);
  if MainWhere='' then
  begin
    if where2='' then
      result:=''
    else
      result:='WHERE '+where2;
    exit;
  end;

  if where2='' then
    result:=MainWhere
  else
    result:=MainWhere+CR+'  AND '+where2;
end;


function JoinOrder(MainOrder,order2:string):string;
begin
  MainOrder:=trim(MainOrder);
  Order2:=trim(Order2);
  if MainOrder='' then
  begin
    if Order2='' then
      result:=''
    else
      result:='ORDER BY '+Order2;
    exit;
  end;

  if Order2='' then
    result:=MainOrder
  else
    result:=MainOrder+','+Order2;
    
end;


procedure TFm_Query.BtnOkClick(Sender: TObject);
begin
  sqlWhere:=GetSqlWhere;
  SqlOrder:=GetSqlOrder;
  ModalResult:=mrOk;
end;

procedure ReleaseQryList(var WhereList,OrderList:TList);
var i:integer;
    fld:PQueryField;
begin
  for i:=0 to OrderList.Count-1 do
  begin
    fld:=OrderList[i];
    if WhereList.IndexOf(fld)=-1 then
      dispose(fld);
  end;
  for i:=0 to WhereList.Count-1 do
  begin
    fld:=WhereList[i];
    dispose(fld);
  end;
  WhereList.Free;
  OrderList.Free;
end;

procedure TFm_Query.Button1Click(Sender: TObject);
var i:integer;
    fld:PQueryField;
begin
  for i:=0 to WhereList.Count-1 do
  begin
    fld:=WhereList.Items[i];
    fld.Ctrl1.SetTextBuf('');
    if fld.Ctrl2<>nil then
      fld.Ctrl2.SetTextBuf('');

  end;
end;

procedure NewQueryFld(var fld:PQueryField);
begin
  new(fld);
  FillChar(fld^,sizeof(fld^),0);
end;

procedure TFm_Query.SetCtrlText(n: integer; ctrl1_text,ctrl2_text: string);
var fld:PQueryField;
    ctrlDate:TwwDBDateTimePicker;
    dt:TDateTime;
begin
  fld:=WhereList.Items[n];
  if fld.DataType = wdDate then begin
    ctrlDate:=fld.ctrl1 as TwwDBDateTimePicker;
    dt:=strtodate(ctrl1_text);
    ctrlDate.DateTime:=dt;

    if fld.Ctrl2 <> nil then begin
      dt:=strtodate(ctrl2_text);
      ctrlDate:=fld.ctrl2 as TwwDBDateTimePicker;
      ctrlDate.DateTime:=dt;
    end;
  end else begin
    fld.Ctrl1.SetTextBuf(pchar(ctrl1_text));
    if fld.Ctrl2 <> nil then
      fld.Ctrl2.SetTextBuf(pchar(ctrl2_text));
  end;

end;

end.

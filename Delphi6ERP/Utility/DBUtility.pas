unit DBUtility;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,stdctrls,db,DBTables,Utili_Str,dbctrls,TypInfo,DBGrids,bde,Variants;



{Declare Begin}
//function IsLocked(ATable: TTable): boolean;
procedure CopyAllField(src,dest:TDataset);
procedure TblAssign(src,dest:TTable);
function GetAliasPath(const sAliasName: string): string;
function FieldDataType(dbsname,tblName,field:string):TFieldType;
function DataExist(Dset:TDataset;fld:string;data:Variant):Boolean;
function DataExistTbl(Dbs,Table1,fld:string;data:Variant):Boolean;
function SqlQuery(RangeFrom:string;RangeTo:string='';QueryMode:integer=0;DataType:integer=0):string;
function UpdateSql(dbs:string;tbl:string;fld:string;FromValue:string;ToValue:string):string;
procedure UpdateFldAllRec(dbs,tbl,FldName:string;FromValue,ToValue:Variant);
procedure SetRelation(tbl:Ttable;IdxField:string;MastSource:TDataSource;MastField:string);
function TableSeek(tbl:TTable;IndexField:string;key:variant):Boolean;
function SqlSum(dbsname,TblName,SumExpress,CondFld:string;Condkey:variant):double;
function TableSum(Tbl: TTable; IndexField,SumField:string;key: variant): currency;
procedure SetRequireField(dbsName,tblName,fldName:string);
function MaxField(dbsName,tblName,fldName:string):variant;
procedure SqlDelete(dbsName,tblName,KeyField:string;KeyValue:variant);

implementation

procedure SqlDelete(dbsName,tblName,KeyField:string;KeyValue:variant);
var qry:TQuery;
    keyStr:string;
begin
  case VarType(KeyValue) of
  varDate:
    keyStr:=#39+DateToStr(keyValue)+#39;
  varString:
    keyStr:=#39+keyValue+#39;
  else
    keyStr:=Vartostr(keyValue);
  end;

  qry:=TQuery.Create(nil);
  qry.DatabaseName:=DbsName;
  qry.SQL.Text:='Delete From '+TblName+' WHERE '+KeyField+'='+keystr;
  qry.ExecSQL;
  qry.free;
end;


function UpdateSql(dbs:string;tbl:string;fld:string;FromValue:string;ToValue:string):string;
var sql:string;
begin
  sql:='UPDATE '+tbl+' SET ' + fld + '="'+ToValue+'" WHERE '+fld
  + '="' + FromValue + '"';
  result:=sql;
end;

function SqlQuery(RangeFrom:string;RangeTo:string='';QueryMode:integer=0;DataType:integer=0):string;
{將RangeFrom 及 RangeTo 兩個字串轉換成 SQL 的 Where 子句
 QueryMode:轉換成Between 或 LIKE 模式
    0 --> 自動視 RangeFrom 及 RangeTo 是否有值
    1 --> 轉成Between
    2 --> 轉成 LIKE
 DataType:
    0-->String Compare
    1-->Numberic Compare

}
begin
  RangeFrom:=trim(RangeFrom);
  RangeTo:=trim(RangeTo);

  if (RangeFrom<>'') and (RangeTo<>'')  then
  begin
    result:=' Between '#39 + RangeFrom + #39' and '#39 + RangeTo + #39;
    exit;
  end;

  if (RangeFrom<>'') and (RangeTo='') then
  begin
    result:=' Between '#39 + RangeFrom + #39' and '#39 +
            RangeFrom + chr(253)+ #39;
    exit;
  end;


  if (RangeFrom='') and (RangeTo <>'') then
  begin
    result:=' <= '#39 + RangeTo + #39;
    exit;
  end;

  if (RangeFrom='') and (RangeTo='') then
  begin
    result:=' Between '#39#32#39' and '#39#253#39;
    exit;
  end;


end;

function DataExist(Dset:TDataset;fld:string;data:Variant):Boolean;
var v:variant;
begin
  v:=dset.Lookup(fld,data,fld);
  result:=(v=data);
end;

function DataExistTbl(Dbs,Table1,fld:string;data:Variant):Boolean;
{當使用資料感知元件時,USER 編修了一個Field 還未Post 之前 Delphi 若直接
使用 LookUp 或 Locate 時,當時編修的欄位也會被找到,導致無法判斷新值是否重複,
必需另開一獨立Table 尋找}
var Tbl:TTable;
begin
	tbl:=TTable.Create(nil);
  tbl.DataBaseName:=DBS;
  tbl.TableName:=Table1;
  tbl.Active:=True;
  result:=DataExist(tbl,fld,data);
  tbl.Active:=False;
  tbl.free;
end;


function FieldDataType(dbsname,tblName,field:string):TFieldType;
var tbl:TTable;
begin
  tbl:=TTable.Create(nil);
  tbl.DatabaseName:=dbsName;
  tbl.TableName:=tblName;
  tbl.Active:=true;
  result:=tbl.fieldbyname(field).DataType;
  tbl.Active:=false;
  tbl.free;
end;



procedure UpdateFldAllRec(dbs,tbl,FldName:string;FromValue,ToValue:Variant);
var qry:TQuery;
		Sqlcmd:string;
begin
	qry:=TQuery.Create(nil);
  qry.DatabaseName:=dbs;
  if VarType(Fromvalue)=VarString	then begin
    ToValue:=#39+ToValue+#39;
  	FromValue:=#39+FromValue+#39;
  end;

  SqlCmd:='Update '+tbl+' SET '+FldName+'='+vartostr(ToValue)+
  				' WHERE '+FldName+' ='+vartostr(FromValue);
  qry.SQL.Text:=SqlCmd;
  qry.ExecSQL;
  qry.free;
end;
{procedure UpdateFldAllRec(dbs,tbl,FldName:string;FromValue,ToValue:Variant);
var t:TTable;
begin
  t:=TTable.Create(nil);
try
  t.DatabaseName:=dbs;
  t.TableName:=tbl;
  t.open;
  t.IndexFieldNames:=FldName;
  t.SetRange([FromValue],[FromValue]);
  t.ApplyRange;
  t.first;
  while not t.eof do begin
    t.edit;
    t.FieldByName(FldName).value:=ToValue;
    t.Post;
  end;
  t.close;
finally
  t.free;
end;
end;}


procedure SetRelation(tbl:Ttable;IdxField:string;MastSource:TDataSource;MastField:string);
begin
  tbl.IndexFieldNames:=IdxField;
  tbl.MasterSource:=MastSource;
  tbl.MasterFields:=MastField;
end;

function TableSeek(tbl:TTable;IndexField:string;key:variant):Boolean;
begin
  tbl.IndexFieldNames:=IndexField;
  tbl.EditKey;
  tbl.FieldByName(IndexField).Value:=key;
  result:=tbl.GotoKey;
end;

{function IsLocked(ATable: TTable): boolean;
var  RecordProps: RECProps;
  wResult: DBIResult;
begin
  Result := True;
  with ATable do  begin
    if State = dsInactive then DBError(DataSetClosed);
    UpdateCursorPos;
    wResult := DbiGetRecord(Handle, dbiWriteLock, nil, @RecordProps);
    if wResult = DBIERR_NONE then begin
      DbiRelRecordLock(Handle, False);
      Result := False;
    end;
  end;
end;}


function GetAliasPath(const sAliasName: string): string;
{ uses DB, DBTables, DBConsts, DbiTypes, DbiProcs, DbiErrs; }
var szName: array[0..100] of char;
  Desc: DBDesc;
  wResult: DBIResult;
begin
  Result := '';
  StrPLCopy(szName, sAliasName, High(szName));
  wResult := DbiGetDatabaseDesc(szName, @Desc);
  if wResult = DBIERR_NONE then
    Result := StrPas(Desc.szPhyName);
end;

{procedure TblAssign(src,dest:TTable);
var i:integer;
  FldName:string;
  IdxFld:TStringList;
  HasRanged:Boolean;
  v:Variant;
begin
  hasRanged:=false;
  IdxFld:=TStringList.Create;
  if dest.Active then dest.close;
  with src do begin
    dest.DatabaseName:=Databasename;
    dest.TableName:=TableName;
    dest.open;
    dest.Filter:=Filter;
    if Filtered then begin
      dest.OnFilterRecord:=src.OnFilterRecord;
      dest.Filtered:=Filtered;
    end;
    if IndexFieldNames<>'' then begin
      dest.IndexFieldNames:=IndexFieldNames;
      dest.EditRangeStart;EditRangeStart;
      StrDivide(IndexFieldNames,IdxFld);
      for i:=0 to IdxFld.Count-1 do begin
        FldName:= IdxFld.Strings[i];
        v:=src.FieldByName(FldName).value;
        if v=NULL then continue;
        dest.FieldByName(FldName).value:=v;
        HasRanged:=True;
      end;

      dest.EditRangeEnd;EditRangeEnd;
      for i:=0 to IdxFld.Count-1 do begin
        FldName:= IdxFld.Strings[i];
        v:=src.FieldByName(FldName).value;
        if v=NULL then continue;
        dest.FieldByName(FldName).value:=v;
        HasRanged:=True;
      end;
      if HasRanged then begin
        dest.ApplyRange;
        ApplyRange;
      end;
    end;
  end;
  src.Refresh;
  dest.Refresh;
end;}

procedure TblAssign(src,dest:TTable);
{*暫時使用* 當SRC 有設定  Range 時 僅 copy range Field 的第一個欄位}
var
  FldName:string;
  IdxFld:TStringList;
  RangFrom,RangTo:Variant;
begin
  IdxFld:=TStringList.Create;
  if dest.Active then dest.close;
  with src do begin
    dest.DatabaseName:=Databasename;
    dest.TableName:=TableName;
    dest.open;
    dest.Filter:=Filter;
    if Filtered then begin
      dest.OnFilterRecord:=src.OnFilterRecord;
      dest.Filtered:=Filtered;
    end;
    if IndexFieldNames<>'' then begin
      dest.IndexFieldNames:=IndexFieldNames;
      StrDivide(IndexFieldNames,IdxFld);

      if IdxFld.Count>0 then begin
        FldName:= IdxFld.Strings[0];
        EditRangeStart;
        RangFrom:=src.FieldByName(FldName).value;
        EditRangeEnd;
        RangTo:=src.FieldByName(FldName).value;
        dest.SetRange([RangFrom],[RangTo]);
        dest.ApplyRange;
        ApplyRange;
      end;
    end;
  end;  //WITH SRC
  src.Refresh;
  dest.Refresh;
end;



function SqlSum(dbsname,TblName,SumExpress,CondFld:string;Condkey:variant):double;
var qry:TQuery;
begin
  qry:=TQuery.Create(nil);
  if vartype(CondKey)=VarString then
    CondKey:=#39+CondKey+#39;
  try
    qry.DatabaseName:=DbsName;
    qry.sql.Text:='Select';
    qry.sql.add (SumExpress + 'AS F1');
    qry.sql.add ('From '+TblName);
    qry.sql.Add('Where '+CondFld + ' = ' + VarToStr(CondKey));
    qry.open;
    result:=qry.fieldbyname('f1').AsFloat;
    qry.close;
  finally
    qry.free;
  end;
end;


procedure SetRequireField(dbsName,tblName,fldName:string);
var fld:TFieldDef;
    tbl:TTable;
begin
  tbl:=TTable.Create(nil);
  try
    tbl.DatabaseName:=dbsName;
    tbl.TableName:=TblName;
    TBL.OPEN;
    fld:=tbl.FieldDefs.Find(FldName);
    fld.Required:=True;
  finally
    TBL.CLOSE;
    tbl.CreateTable;
    tbl.free;
  end;

end;


function TableSum(Tbl: TTable; IndexField,SumField:string;key: variant): currency;
begin
  tbl.IndexFieldNames:=IndexField;
  tbl.SetRange([key],[key]);
  tbl.ApplyRange;
  tbl.First;
  result:=0;
  while (not tbl.Eof) do begin
    result:=result+tbl.fieldByName(SumField).AsCurrency;
    tbl.next;
  end;
end;

procedure CopyAllField(src,dest:TDataset);
var i:integer;
    nam:string;
begin
  dest.Append;
  for i:=0 to dest.FieldCount -1 do begin
    nam:=dest.Fields[i].FieldName;
    dest.Fields[i].Value :=src.fieldbyname(nam).Value;
  end;
  dest.Post;

end;

function MaxField(dbsName,tblName,fldName:string):variant;
var qry:TQuery;
begin
  qry:=TQuery.Create(nil);
  try
    qry.DatabaseName:=dbsName;
    qry.SQL.Text:='Select Max('+fldName+') as f1 From '+tblName;
    qry.open;
    result :=qry.fieldbyname('f1').Value;
  finally
    qry.close;
    qry.free;
  end;

end;


end.

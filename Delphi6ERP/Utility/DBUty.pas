unit DBUty;

interface
uses Classes,StdCtrls,SysUtils,ComCtrls,DB,DBTables,ADODB,ADOConEd,DBClient,Controls,Provider,Variants,uty,forms,DBGrids;

procedure InsertDataSetToTable(tblName:string;dst:TDataset;CheckTblField:boolean;ADODC:TADOConnection);
procedure UpdateDataSetToTable(tblName:string;dstNew,dstOld:TDataset;sPkList:string;CheckTblField:boolean;ADODC:TADOConnection);
function ExecuteSQL(sql:string;ADODC:TADOConnection):integer;
function CreateQry(ADODC:TADOConnection):TADOQuery;
procedure DoQrySelect(sql:string;adodc:TAdoConnection;Client_DataSet: TClientDataset);
function TblLookup(ADODC:TAdoConnection;TBL,KeyField:string;KeyValue:variant;ResultField:string;where:string=''):variant;
function TblLookupKey(ADODC:TAdoConnection;TblName,ResultField,sKeyList:string;keyValue:array of variant):variant;
FUNCTION GetMaxID(adoc:TAdoConnection;TblName,FldName:string;WhereStr:string=''):integer;
function DataExist(ADOC:TAdoConnection;TBL,fld:string;data:Variant;WhereStr:string=''):Boolean;
function GetNumbericCode(ADOC:TAdoConnection;TblName,Field:string;DateFMT:string;Date:TDate;SerialLen:integer;LeadStr:string='';WhereStr:string=''): string;
function Table2File(adodc:TAdoConnection;TblName,filename:string;where:string=''):integer;
function File2Table(adodc:TAdoConnection;TblName,filename:string;BAR1:TProgressBar=nil;capt:TLabel=nil):integer;
procedure GetAdoConnectionString(adodc:TAdoConnection;IniFile:string;ForceSetup:boolean=False);
function TableExist(adodc:TAdoConnection;TblName:string):boolean;
procedure GetTblFieldList(tblName:string;FieldList:TStringList;qry:TADOQuery);
procedure  UpdateBlobField(tblName,BlobFieldName:string;dst:TDataset;sPkList:string;adodc:TADOConnection);
procedure CopyDataRow(Dataset_Src, Dataset_Dest: TDataset);
procedure OpenClientData(sSql:string;qry:TAdoQuery;sKeyList:string);
procedure CopySelectedData(grid: TDBGrid; DestDataset: TClientDataset);


implementation
{==========================================================================================
    將 dataset 轉成  INSERT SQL ，並執行
==========================================================================================}
procedure InsertDataSetToTable(tblName:string;dst:TDataset;CheckTblField:boolean;ADODC:TADOConnection);
var i:integer;
    fldName:string;
    sql:string;
    FieldList:TStringList;
    qry:TADOQuery;
begin
  FieldList:=TStringList.Create;
  qry:=CreateQry(ADODC);
  try
    if CheckTblField then begin
      GetTblFieldList(tblName,FieldList,qry);
    end;

    sql:='insert into '+tblName+cr
        +'(';
    for i:=0 to dst.FieldCount-1 do begin
      fldName:=dst.Fields[i].FieldName;
      if CheckTblField then begin
          if FieldList.IndexOf(fldName) = -1 then continue;
      end;
      sql:=sql+fldName+CR+','
    end;

    sql:=copy(sql,1,length(sql)-1)+CR+')'+'Values'+CR+'(';
    for i:=0 to dst.FieldCount-1 do begin
      fldName:=dst.Fields[i].FieldName;
      if CheckTblField then begin
          if FieldList.IndexOf(fldName) = -1 then continue;
      end;
      sql:=sql+SqlValueByVariant(dst.Fields[i].value)+CR+',';
    end;
    sql:=copy(sql,1,length(sql)-1)+')'+CR;
    debug(sql,'A');
    Qry.sql.Text:=sql;
    qry.ExecSQL;

  finally
    qry.close;
    qry.Free;
    FieldList.free;
  end;
end;



{==========================================================================================
    將 dataset 轉成  Update SQL ，並執行
==========================================================================================}
procedure UpdateDataSetToTable(tblName:string;dstNew,dstOld:TDataset;sPkList:string;CheckTblField:boolean;ADODC:TADOConnection);
var i:integer;
    fldName:string;
    sql:string;
    pkList:TStringList;
    pk:string;
    FieldList:TStringList;
    qry:TADOQuery;
begin
  qry:=CreateQry(ADODC);

  FieldList:=TStringList.Create;
  try
    if CheckTblField then begin
      GetTblFieldList(tblName,FieldList,qry);
    end;

    pkList:=StrDivideList(sPkList,',');
    if pkList.Count=0 then begin
      raise Exception.Create('Primary key list can not be empty.');
    end;
    sql:='UPDATE '+tblName+cr
        +'SET ';
    for i:=0 to dstNew.FieldCount-1 do begin
      fldName:=dstNew.Fields[i].FieldName;
      if dstNew.Fields[i].DataType=ftBlob	 then begin
        UpdateBlobField(tblName,fldName,dstNew,sPkList,ADODC);
        continue;
      end;
      if CheckTblField then begin
          if FieldList.IndexOf(fldName) = -1 then continue;
      end;
      sql:=sql+fldName+' ='+SqlValueByVariant(dstNew.Fields[i].value)+CR+'   ,';
    end;


    sql:=copy(sql,1,length(sql)-4)+'WHERE ';
    for i:=0 to pkList.Count-1 do begin
      pk:=pkList.Strings[i];
      sql:=sql+pk+' ='+SqlValueByVariant(dstOld.Fieldbyname(pk).value)+CR+'  AND ';
    end;
    sql:=copy(sql,1,length(sql)-6);
    debug(sql,'A');
    Qry.sql.Text:=sql;
    qry.ExecSQL;
  finally
    qry.close;
    qry.free;
    FieldList.free;
  end;
end;


function ExecuteSQL(sql:string;ADODC:TADOConnection):integer;
var
  qry:TAdoQuery;
begin
  qry:=TAdoQuery.Create(nil);
  try
    qry.Connection:=ADODC;
    qry.SQL.Text:=sql;
    Result:=qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

function CreateQry(ADODC:TADOConnection):TADOQuery;
var
  qry:TAdoQuery;
begin
  qry:=TAdoQuery.Create(nil);
  qry.Connection:=ADODC;
  Result:=qry;

end;

procedure DoQrySelect(sql:string;adodc:TAdoConnection;Client_DataSet: TClientDataset);
var qry:TAdoQuery;
    provider:TDataSetProvider;
    I:INTEGER;
begin
  qry:=TAdoQuery.Create(nil);
  provider:=TDataSetProvider.Create(nil);
  try
    client_dataset.Close;
    qry.Connection:=adodc;
    provider.DataSet:=qry;
    qry.SQL.Text:=sql;
    qry.Open;

    for i:=0 to qry.Fields.Count-1 do begin
      qry.Fields[i].ReadOnly:=false;
    end;

    client_dataset.Data:=provider.Data;
    qry.Close;
  finally
    provider.Free;
    qry.Free;
  end;


end;


function TblLookup(ADODC:TAdoConnection;TBL,KeyField:string;KeyValue:variant;ResultField:string;where:string=''):variant;
var
  QRY:TAdoQuery;
  skeyValue:string;
  SQL:string;
begin
  case vartype(keyValue) of
  varString:
    skeyValue:=sqlStr(keyValue);
  else
    sKeyValue:=vartostr(keyValue);
  end;

  qry:=TAdoQuery.Create(nil);
  try
    qry.Connection:=adodc;
    sql:='SELECT ' + ResultField +' FROM '+TBL +' WHERE '+KeyFIeld+'='+skeyValue;
    debug(SQL);
    qry.SQL.Text:=SQL;
    if where<>'' then
      qry.SQL.Add(' AND '+where);
    qry.open;
    if not qry.Eof then
      result:=qry.Fields[0].Value
    else
      result:=null;

  finally
    qry.Close;
    qry.Free;

  end;
end;



function TblLookupKey(ADODC:TAdoConnection;TblName,ResultField,sKeyList:string;keyValue:array of variant):variant;
var KeyList:TStringList;
    i:integer;
    sql:string;
    sWhere:string;
    v:variant;
    opEquel:string;
    qry:TADOQuery;
    aryElemCount:integer;
begin
  KeyList:=StrSplit(sKeyList,',');
  try
    aryElemCount:=High(keyValue)-low(keyValue)+1;
    if aryElemCount<> KeyList.Count then begin
      ErrMsg('TblLookupKey() KeyList 與 KeyValue 數量不相符 !'+CR
                  +'KeyList Count='+inttostr(KeyList.Count)+CR
                  +'KeyValue Count='+inttostr(aryElemCount),SYS);
    end;

    sWhere:='WHERE ';
    for i:=0 to KeyList.Count-1 do begin
      v:=keyValue[i];
      if VarIsNull(v) then opEquel :=' IS ' else opEquel:=' =';
      sWhere:=sWhere+KeyList.Strings[i]+opEquel+SqlValueByVariant(v)+CR+'  AND ';
    end;
    sWhere:=copy(sWhere,1,length(sWhere)-6);
    sql:='  SELECT '+ResultField +CR
        +'  FROM '+TblName+cr
        +sWhere;
//    DEBUG(sql,'A');
    qry:=CreateQry(ADODC);
    try
      qry.SQL.Text:=sql;
      QRY.Open;
      if qry.IsEmpty then begin
        Result:=Null;
      end else begin
        result:=qry.Fields[0].Value;
      end;
    finally
      qry.Close;
      qry.free;
    end;
  finally
    KeyList.Free;
  end;
end;


FUNCTION GetMaxID(adoc:TAdoConnection;TblName,FldName,WhereStr:string):integer;
var qry:TAdoQuery;
begin
  qry:=TAdoQuery.Create(nil);
  try
    qry.Connection:=adoc;
    qry.SQL.Text:='SELECT MAX('+FldName+') AS f1 FROM '+TblName;
    IF WhereStr<>'' then qry.SQL.Add(' WHERE '+WhereStr);
    QRY.Open;
    if varisnull(qry.Fieldbyname('F1').Value) then
      result:=0
    else
      result:=qry.Fieldbyname('F1').asinteger;
  finally
    qry.close;
    qry.Free;
  end;

end;

function DataExist(ADOC:TAdoConnection;TBL,fld:string;data:Variant;WhereStr:string=''):Boolean;
var v:variant;
  QRY:TAdoQuery;
begin
  qry:=TAdoQuery.Create(nil);
  qry.Connection:=adoc;
  qry.SQL.Text:='SELECT ' + FLD +' FROM '+TBL;
  IF whereStr<>'' then qry.SQL.add(WhereStr);
  qry.open;
  try
    v:=qry.Lookup(fld,data,fld);
    result:=(v=data);
  finally
    qry.Close;
    qry.Free;

  end;
end;

function GetNumbericCode(ADOC:TAdoConnection;TblName,Field:string;DateFMT:string;Date:TDate;SerialLen:integer;LeadStr:string='';WhereStr:string=''): string;
VAR DateStr,s:STRING;
  serial:integer;
  DateFmtLen:integer;
  qry:TAdoQuery;
begin
  LeadStr:=trim(LeadStr);
  qry:=TAdoQuery.Create(nil);
  try
    qry.Connection:=adoc;
    DateFmtLen:=length(LeadStr+DateFMT);
    DateTimeToString(DateStr,DateFMT,Date);
    qry.SQL.Text:='SELECT MAX('+Field+') AS F1 FROM '+TblName+' WHERE LEFT('+Field+','+inttostr(DateFmtLen)+')='+SqlStr(LeadStr+DateStr);
    if WhereStr>'' then
      Qry.SQL.Add('AND '+WhereStr);

    Qry.open;
    if Qry.fieldbyname('F1').AsString='' then
      serial:=1
    else begin
      s:=Qry.fieldbyname('F1').AsString;
      s:=copy(s,DateFmtLen+1,99);
      serial:=strtoint(s)+1;
    end;
    result:=LeadStr+DateStr+FixedNum(serial,SerialLen,'0');
  finally
    qry.close;
    qry.Free;
  end;
end;



function Table2File(adodc:TAdoConnection;TblName,filename:string;where:string=''):integer;
var qry:TAdoQuery;
begin
  qry:=TAdoQuery.Create(nil);
  try
    qry.Connection:=adodc;
    qry.SQL.Text:='SELECT * FROM '+TblName+' '+where;
    qry.open;
    qry.SaveToFile(fileName,pfXML);
    result:=qry.RecordCount;
  finally
    qry.Close;
    qry.Free;
  end;

end;

function File2Table(adodc:TAdoConnection;TblName,filename:string;BAR1:TProgressBar=nil;capt:TLabel=nil):integer;
var qry,QryDst:TAdoQuery;
    TotalRec,n,i:integer;
    fldName:string;
begin
  qry:=TAdoQuery.Create(nil);
  QryDst:=TAdoQuery.Create(nil);
  try
    QryDst.Connection:=adodc;
//    QRY.LockType:=ltBatchOptimistic;
    qry.LoadFromFile(fileName);
    QryDst.SQL.Text:='SELECT * FROM '+TblName+' ';
    QryDst.Open;
    TotalRec:=qry.RecordCount;
    if bar1<>nil then
    begin
      bar1.Min:=0;
      bar1.Max:=qry.RecordCount;
      bar1.step:=1;
      bar1.Position:=0;
    end;

    qry.First;
    n:=0;
    while not qry.Eof do
    begin
      inc(n);
      qryDst.Insert;
      for i:=0 to qry.FieldCount-1 do
      begin
        fldName:=uppercase(qry.Fields[i].FieldName);
        if qryDst.FieldByName(fldName).CanModify then
          qryDst.FieldByName(fldName).Value:=qry.FieldByName(fldName).Value;
      end;
      qrydst.Post;
      qry.Next;
      if capt<>nil then  capt.caption:=inttostr(n)+'/'+inttostr(TotalRec);
      if bar1<>nil then
      begin
        bar1.StepIt;
        application.ProcessMessages;
      end;

    end;
    result:=qry.RecordCount;
  finally
    qry.Close;
    qry.Free;
    QryDst.Close;
    QryDst.Free;
  end;

end;



procedure GetAdoConnectionString(adodc:TAdoConnection;IniFile:string;ForceSetup:boolean=False);
Var F: TextFile;
  s:string;
begin
  adodc.connected:=false;
  AssignFile(F, IniFile);   { File selected in dialog box }
  try
    if FileExists(IniFile) then
    begin
      Reset(F);
      Readln(F, s);                          { Read the first line out of the file }
      adodc.ConnectionString:=s;
      if not ForceSetup then exit;
    end;
    try
      if EditConnectionString(AdoDc) then
    except
    end;
    begin
      ReWrite(F);
      s:=adodc.ConnectionString;
      Writeln(F, s);                          { Read the first line out of the file }
    end;
  finally
    CloseFile(F);
  end;
end;

function TableExist(adodc:TAdoConnection;TblName:string):boolean;
var qry:TAdoQuery;
begin
  qry:=TAdoQuery.Create(nil);
  try
    qry.Connection:=adodc;
    qry.SQL.Text:='SELECT 1 FROM '+TblName;
    try
      qry.Open;
      result:=True;
    except
      result:=False;
    end;
  finally
    qry.close;
    qry.Free;
  end;

end;

procedure GetTblFieldList(tblName:string;FieldList:TStringList;qry:TADOQuery);
var sql:string;
    i:integer;
    fldName:string;
begin
  sql:='SELECT * FROM '+tblName;
  qry.sql.Text:=sql;
  qry.Open;
  try
    FieldList.Clear;
    for i := 0 to qry.FieldCount-1 do begin
      fldName:=qry.Fields[i].FieldName;
      FieldList.Add(fldName);
    end;
  finally
    qry.Close;
  end;

end;


{==========================================================================================
    將 BLOB 欄位寫入Table
==========================================================================================}
procedure  UpdateBlobField(tblName,BlobFieldName:string;dst:TDataset;sPkList:string;adodc:TADOConnection);
var sql:string;
    pkList:TStringList;
    pk,sWhere:string;
    i:integer;
    qry:TADOQuery;
    BlobFld:TBlobField;
    memStream: TMemoryStream;
begin

  qry:=CreateQry(adodc);
  qry.ParamCheck:=true;
  memStream:=TMemoryStream.Create;
  try
    BlobFld:=dst.fieldbyname(BlobFieldName) as TBlobField;
    BlobFld.SaveToStream(memStream);
//    showmessage('BlobFld.Size='+inttostr(BlobFld.Size)+CR +'memStream.Size='+inttostr(memStream.Size)+CR );


    pkList:=StrDivideList(sPkList,',');
    sWhere:='WHERE ';
    try
      for i:=0 to pkList.Count-1 do begin
        pk:=pkList.Strings[i];
        sWhere:=sWhere+pk+' ='+SqlValueByVariant(dst.Fieldbyname(pk).value)+CR+'  AND ';
      end;
      sWhere:=copy(sWhere,1,length(sWhere)-6);
    finally
      pkList.free;
    end;

    if memStream.Size=0 then BEGIN
      sql:='  UPDATE  '+tblName
          +'  SET '+BlobFieldName+'=NULL'+CR
          + sWhere;
      qry.sql.text:=sql;
      qry.ExecSQL;;
    end else begin
      sql:='  UPDATE  '+tblName
          +'  SET '+BlobFieldName+'=:v1'+CR
          + sWhere;
      qry.sql.text:=sql;
      qry.Parameters.ParamByName('v1').LoadFromStream(memStream,ftBlob);
      qry.ExecSQL;;
    end;

  finally
    memStream.Free;
    qry.Close;
    qry.free;
  end;
end;


{=================================================================================
  copy 所有欄位到 from Dataset_Src to Dataset_Dest
                                                          2006/06/22 by mars_wu
=================================================================================}
procedure CopyDataRow(Dataset_Src, Dataset_Dest: TDataset);
var i: integer;
  fldName: string;
begin
  for i := 0 to Dataset_Src.FieldCount - 1 do begin
    fldName := Dataset_Src.Fields[i].FieldName;
    if Dataset_Src.Fields[i].FieldKind <> fkData then CONTINUE;


    Dataset_Dest.FieldByName(fldName).Value := Dataset_Src.FieldByName(fldName).Value;
  end;
end;


{================================================================================
  Open Client Data 並維持游標的位置在先前的位置
================================================================================}
procedure OpenClientData(sSql:string;qry:TAdoQuery;sKeyList:string);
var KeyList:TStringList;
    KeyFields:string;
    keyAry: Variant;
    singleKeyValue:string;
    i:integer;
    FieldName:string;
    b:Boolean;
begin
  KeyList:=StrSplit(sKeyList,',');
  singleKeyValue:='';
  screen.Cursor:=crSQLWait;
  try
    if qry.Active then begin
      if not qry.Eof then begin
        keyAry:=VarArrayCreate([0, KeyList.Count-1], varVariant);
        KeyFields:='';
        for i:=0 to KeyList.Count-1 do begin
          FieldName:=KeyList.Strings[i];
          KeyFields:=KeyFields+FieldName+';';
          keyAry[i]:=qry.fieldbyname(FieldName).Value;
        end;
        KeyFields:=copy(KeyFields,1,length(KeyFields)-1);
        if KeyList.Count=1 then begin
          singleKeyValue:=keyAry[0];
        end;
      end;
    end;
    qry.Close;
    debug(sSql,'A');
    qry.SQL.Text:=sSql;
    QRY.OPEN;
    IF KeyList.Count=1 then begin
      b:=qry.Locate(KeyFields,singleKeyValue,[]);
    end else begin
      b:=qry.Locate(KeyFields,keyAry,[]);
    end;
    if (b=false) or (KeyFields='') then begin
      qry.Last;
    end;
  finally
    KeyList.free;
    screen.Cursor:=crDefault;
  end;

end;

{=================================================================================
  Copy GRID 內所有選擇的資料列 To DestDataset
  注意：GRID所連接的 dataset 必須一定是TClientDataset。
=================================================================================}
procedure CopySelectedData(grid: TDBGrid; DestDataset: TClientDataset);
var SrcDataSet: TClientDataset;
  i: integer;
begin
  SrcDataSet := (grid.DataSource.DataSet as TClientDataSet);
  DestDataset.Data := SrcDataSet.Data;
  DestDataset.EmptyDataSet;
  if grid.SelectedRows.Count >0 then begin
    for i := 0 to grid.SelectedRows.Count - 1 do begin
      SrcDataSet.GotoBookmark(pointer(grid.SelectedRows.Items[i]));
      DestDataset.Append;
      CopyDataRow(SrcDataSet, DestDataset);
      DestDataset.Post;
    end;
  end else begin
    if not SrcDataSet.Eof then begin
      DestDataset.Append;
      CopyDataRow(SrcDataSet, DestDataset);
      DestDataset.Post;
    end;
  end;

end;



end.

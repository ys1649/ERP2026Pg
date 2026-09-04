unit SysReportUnit;

interface
uses ADODB,Forms,Classes;

function RunMultiSql(adodc: TAdoConnection;  sql: string): string;
procedure RunScript(script:string);
implementation

uses Uty;
procedure RunScript(script:string);
//var dcs:TdcScripter;
begin
{
  dcs:=TdcScripter.Create(application);
  try
    dcs.ModalRun:=true;
    dcs.Language:='VBScript';
    dcs.Script.Text:=script;
    dcs.Run;
  finally
    dcs.Free;
  end;
}

end;

function RunMultiSql(adodc: TAdoConnection;  sql: string): string;
var list:TStringList;
    qry:TAdoQuery;
    i:integer;
    r:string;
begin
  list:=TStringList.Create;
  qry:=TAdoQuery.Create(application);

  try
    qry.Connection:=adodc;
    StrDivide(sql,';',list);
    if list.Count=0 then ErrMsg('SQL ¿ù»~'#13+'SQL='+sql,user);
    for i:=0 to list.Count-2 do begin
      qry.SQL.Text:=list.Strings[i];
      qry.ExecSQL;
    end;
    r:=list.Strings[list.count-1];
    result:=r;
  finally
    qry.Close;
    qry.Free;
    list.free;
  end;
end;

end.

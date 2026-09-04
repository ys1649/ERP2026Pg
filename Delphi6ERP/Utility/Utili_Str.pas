unit Utili_Str;

interface

uses
  SysUtils,classes,Controls;
function Var2Str(v:variant):string;
function StrPart(s:string):string;
procedure StrDivide(const SrcStr:string;StrList:TStringList);
function InStr(s:string;SearPosi:integer;SearStr:string):integer;
function StrRepeat(ch:char;rep:integer):string;
function FixedNum(num,leng:integer;ch:char;Lead:Boolean=True):string;
function StrLeft(s:string;cnt:integer):string;
function StrRight(s:string;cnt:integer):string;
function StrMid(s:string;start:integer;cnt:integer=0):string;
//function str2val(s:string):variant;
function str2val(s:string):integer;
function str2Curr(s:string):currency;
function Date2StrFmt(date1:TDate;fmt:string='MDY'):string;

implementation

function Var2Str(v:variant):string;
{==========================================================
    依 VarType(v) 轉換 v 為 string 型態
    若 v 的型態為 string 或 date ,result將在前後加上單引號
===========================================================}
VAR n:integer;
begin
  n:=vartype(v);
  case n of
  varOleStr,varString:
    result:=#39+v+#39;
  varDate:result:=#39+date2strFmt(v)+#39;
  else
    result:=vartostr(v);
  end;
end;

function Date2StrFmt(date1:TDate;fmt:string='MDY'):string;
var OldDateFmt:string;
begin
  fmt:=UpperCase(fmt);
  OldDateFmt:=ShortDateFormat;
  if fmt ='MDY' then begin
    ShortDateFormat :='mm/dd/yyyy';
    result:=DateToStr(date1);
  end else if fmt='YMD' then begin
    ShortDateFormat :='yyyy/mm/dd';
    result:=DateToStr(date1);
  end else if fmt='DMY' then begin
    ShortDateFormat :='dd/mm/yyyy';
    result:=DateToStr(date1);
  end;
  ShortDateFormat:=OldDateFmt;
end;



function StrLeft(s:string;cnt:integer):string;
begin
  result:=copy(s,1,cnt);
end;

function StrRight(s:string;cnt:integer):string;
begin
  result:=copy(s,length(s)-cnt+1,cnt);
end;

function StrMid(s:string;start:integer;cnt:integer=0):string;
begin
  if cnt=0 then cnt:=length(s)-start+1;
  result:=copy(s,start,cnt);
end;

function InStr(s:string;SearPosi:integer;SearStr:string):integer;
var tmp:integer;
begin
  if SearPosi<1 then SearPosi:=1;
  tmp:=pos(SearStr,StrMid(s,SearPosi));
  if tmp=0 then
    result:=0
  else
    result:=tmp+(SearPosi-1);
end;

function str2val(s:string):integer;
var code:integer;
begin
  VAL(s,result,code);
end;

function str2Curr(s:string):currency;
begin
  s:=trim(s);
  if s='' then begin
    result:=0;
    exit;
  end;
  try
    result:=StrToCurr(s);
  except
    result:=0;
  end;
end;

function StrRepeat(ch:char;rep:integer):string;
var s:string;
  i:integer;
begin
  setlength(s,rep);
  for i:=1 to rep do
    s[i]:=ch;
  result:=s;

end;

function FixedNum(num,leng:integer;ch:char;Lead:Boolean=True):string;
{傳回固定位數的數字字串,不足位數補 ch}
var IntLeng:integer;
  s:string;
begin
  s:=inttostr(num);
  IntLeng:=length(s);
  if IntLeng>= leng then begin
    result:=s;
    exit;
  end;

  if Lead then
    result:=StrRepeat(ch,leng-IntLeng)+s
  else
    result:=s+StrRepeat(ch,leng-IntLeng);
end;

procedure StrDivide(const SrcStr:string;StrList:TStringList);
{以 ';' 為間隔, 分割字串存入StrList 傳回}
var n:integer;
  s:string;
begin
  s:=SrcStr;
  n:=pos(';',s);
  while (n>0) do begin
    StrList.Add(copy(s,0,n-1));
    delete(s,1,n);
    n:=pos(';',s);
  end;
  if s<>'' then StrList.Add(s);
end;

function StrPart(s:string):string;
{以 ';' 為間隔, 取得第一字串傳回}
var n:integer;
begin
  n:=pos(';',s);
  if n=0 then
    result:=s
  else
    result:=copy(s,1,n-1);
end;


end.

unit Uty;

interface
uses Classes,ComCtrls,forms,windows,Controls,DBCtrls,DBGrids,Graphics,Dialogs,math,
     StdCtrls,SysUtils,variants,TypInfo,StrUtils,MSXML2_TLB,MSScriptControl_TLB;


type ErrType=(USER,SYS);
TDataBaseType =(Unknow,Access,Oracle,MSSQL);

const CR=#13#10;
const TAB = #9;
CONST DoubleMin=-1E300;
CONST DoubleMax=1E300;
const ColrEditEnableFore=clBlue;
const ColrEditEnableBack=clWhite;
const ColrEditDisableFore=clMaroon;
const ColrEditDisableBack=clSilver;
const ColrActiveBack=$0080FFFF;
const ColrActiveFore=clBlack;


{===============================================================
    String and other Utility
===============================================================}
procedure debug (msg:string;mode:string='W');
function vartocurr(v:variant):currency;
function StrMid(s:string;start:integer;cnt:integer=-1):string;
function StrLeft(s:string;cnt:integer):string;
function StrRight(s:string;cnt:integer):string;
procedure StrDivide(const SrcStr,DivideStr:string;StrList:TStringList);
procedure StrReplace(var lin:string;sStr,dStr:string);
procedure delay(mSec:DWORD);
function SqlStr(s:string;convertNull:boolean=TRUE):string;

function SqlNum(s:string;convertNull:boolean=TRUE):string;
function splitEval(line:string):TSTringList;
function SqlBool(b:boolean):string;
function SqlValue(data: string; dataType:string;dtFormat:string;DBSTYPE:string;var errMsg:string): string;
function SqlValueByVariant(data: variant): string;


//function SqlDateSQL(da:TDate):string;
function SqlDateTime(dt:TDatetime;dbsType:string):string;
function SqlDateTimeSQL(da:TDatetime):string;
function SqlDateTimeOra(da:TDatetime):string;

function StrtoDatetimeFormat(s,fmt:string;var errMsg:string):TDatetime;
function StrtoDateFormat(dtStr,fmt:string):TDatetime;


function HasProperty(AObject: TObject; const APropName: string): boolean;
procedure SetOwnerCtrlReadOnly(AOwner:TComponent;mode:boolean);
procedure SetCtrlReadOnly(Ctl:TComponent;mode:boolean);
procedure SetOwnerCtrlColor(AOwner:TComponent;ForeColr,BackColr:TColor);
procedure SetCtrlColor(Ctl:TComponent;ForeColr,BackColr:TColor);

procedure msg(s:string);
procedure ErrMsg(msg:string;ErrClass:ErrType);
function ConfirmMsg(msg:string):Word;

function ProcessExecute(CommandLine: string; cShow: Word=sw_ShowNormal;wait:DWord=INFINITE): Integer;
function ProcessExecuteResult_hProcess(CommandLine: string; cShow: Word=sw_ShowNormal): Integer;

function FixedNum(num,leng:integer;ch:char;Lead:Boolean=True):string;
function StrRepeat(ch:char;rep:integer):string;
procedure hintMsg(bar:TStatusBar;msg:string);
procedure DeleteAllFile(fn:string);
function ParseVbScript(cmd: string): string;

function isLeafNode(xmlNode: IXMLDOMNode): boolean;
function iif(Condition: Boolean; TrueReturn, FalseReturn: Variant): Variant;
function getEnvrionment(Variable: string): string;
function StrSplit(line: string; delimit: string; TrimFlag: boolean = true): TStringList;
function StrDivideList(const SrcStr, separator: string;TrimFlag: boolean = true): TStringList;
procedure TrimEditCtrl(Ctrl: TCustomEdit);
procedure TrimAllText(AOwner: TComponent);
function RoundN(x: Double; n: Integer): double;
function FloatCalc(x: Double): double;





var G_TempPath: string; //TEMP 環境變數指向的路徑

implementation

procedure delay(mSec:DWORD);
var t0:DWORD;
begin
  t0:=GetTickCount();
  while(GetTickCount-t0<=mSec)do;
end;

function SqlStr(s:string;convertNull:boolean=TRUE):string;
begin
  if (s='') and convertNULL then begin
    result:='NULL';
  end else begin
    s:=AnsiReplaceText(s,#39,#39#39);
    result:=#39+s+#39;
  end;
end;


function SqlDateTimeSQL(da: TDatetime): string;
var oldLongDateTimeFormat, oldShortDateTimeFormat: string;

begin

  oldShortDateTimeFormat := ShortDateFormat;
  oldLongDateTimeFormat := LongTimeFormat;
  ShortDateFormat := 'mm-dd-yyyy';
  LongTimeFormat := 'hh:mm:ss';
  result := 'CONVERT(DATETIME,''' + DateTimeToStr(da) + ''',20)';
  ShortDateFormat := oldShortDateTimeFormat;
  LongTimeFormat := oldLongDateTimeFormat;

end;


function SqlNum(s:string;convertNull:boolean=TRUE):string;
begin
  if (s='') and convertNULL then begin
    result:='NULL';
  end else begin
    result:=s;
  end;
end;

function SqlBool(b:boolean):string;
begin
  if b then
    result:='1'
  else
    result:='0';
end;


function SqlValue(data: string; dataType:string;dtFormat:string;DBSTYPE:string;var errMsg:string): string;
var dt:TDateTime;
begin
  errMsg:='';
  if data='' then begin
    result:='NULL';
    exit;
  end;

  if dataType='STRING' then begin
    result:=sqlstr(data);
  end else if dataType='NUMBER' then begin
    result:=data;
  end else begin
    if DBSTYPE='ORACLE' then begin
      try
        dt:=StrtoDateFormat(data,dtFormat);
        result:=SqlDateTimeOra(dt);
      except
        on E:Exception do begin
          result:=e.Message
        end;
      end;
    end else begin
      try
        dt:=StrtoDateFormat(data,dtFormat);
        result:=SqlDateTimeSQL(dt);
      except
        on E:Exception do begin
          result:=e.Message
        end;
      end;
    end;
  end;
end;


function SqlValueByVariant(data: variant): string;
begin
  case vartype(data) of
    varDate:
      result := SqlDateTimeSQL(data);
    varString, VarOleStr:
      result := sqlstr(data);
    varEmpty, varNull:
      result := 'NULL';
    varSingle, varDouble, varCurrency:
      result := floattostr(data);
    varInteger, varSmallint:
      result := inttostr(data);
  else
    raise exception.Create('Error type conversion in SqlValueByVariant()');
  end;
end;


function StrSplit(line:string;delimit:string;TrimFlag:boolean=true):TStringList;
var n:integer;
  s,s0:string;
  sl:TStringList;
begin
  sl:=TStringList.Create;
  s:=line;
  n:=pos(delimit,s);
  while (n>0) do begin
    s0:=copy(s,0,n-1);
    if TrimFlag then begin
      s0:=trim(s0);
    end;
    sl.Add(s0);
    delete(s,1,n);
    n:=pos(delimit,s);
  end;
  if trimFlag then begin
    s:=trim(s);
  end;
  sl.add(s);
  result:=sl;
end;

function splitEval(line:string):TStringList;
{=====================================================
  將 line 依照四則運算符號分割成獨立的string segment 存入 stringList 傳回 
=======================================================}
var sl:TStringList;
    separator:string;
    i:integer;
    word:string;
    ch:char;
begin
  sl:=TStringList.Create;
  separator:=' +-*/()';
  line:=trim(line)+' ';

  word:='';
  for i:= 1 to length(line) do begin
    ch:=line[i];
    if pos(ch,separator)=0 then begin
      word:=word+ch;
    end else begin
      if word <> '' then begin
        sl.Add(word);
        word:='';
      end;
      if ch <>' ' then begin
        sl.Add(ch);
      end;
    end;
  end;
  result:=sl;
end;

{
function SqlDateSQL(da:TDate):string;
var y,m,d:word;
begin
  decodedate(da,y,m,d);
  result:=SqlStr(inttostr(m)+'/'+inttostr(d)+'/'+inttostr(y));
end;
}

{
function SqlDateTimeSQL(da:TDatetime):string;
var y,m,d:word;
    h,mi,s,ms:word;
begin
  decodedate(da,y,m,d);
  decodetime(da,h,mi,s,ms);
  result:='CAST ('+SQLSTR(inttostr(y)+'-'+inttostr(m)+'-'
            +inttostr(d) + ' '+inttostr(h)+':'+inttostr(mi)
            +':'+inttostr(s)+'.'+inttostr(ms)) +' AS datetime)';
end;\}


function SqlDateTime(dt:TDatetime;dbsType:string):string;
begin
  if dbsType='ORACLE' then
    result:=SqlDateTimeOra(dt)
  else
    result:=SqlDateTimeSQL(dt);
end;


function SqlDateTimeOra(da:TDatetime):string;
var oldLongDateTimeFormat,oldShortDateTimeFormat:string;

begin
  oldShortDateTimeFormat:=ShortDateFormat;
  oldLongDateTimeFormat:=LongTimeFormat;
  ShortDateFormat:='mm-dd-yyyy';
  LongTimeFormat := 'hh:mm:ss';
  result:='TO_DATE('''+DateTimeToStr(da)+''',''mm-dd-yyyy hh24:mi:ss'')';
  ShortDateFormat:=oldShortDateTimeFormat;
  LongTimeFormat:=oldLongDateTimeFormat;
end;



function _FindStringList(sl:TstringList;findstr:string):integer;
var i:integer;
begin
  result:=-1;
  for i:=0 to sl.Count-1 do begin
    if leftstr(sl.Strings[i],length(findstr))=findstr then begin
      result:=i;
      exit;
    end;
  end;
end;


function _StrtoDateFormat_sepparator(dtstr,fmt,separator:string):TDatetime;
var idxY,idxM,idxD:integer;
    SlFmt,slData:TStringList;
    yy,mm,dd:integer;
begin
  slFmt:=StrSplit(fmt,separator);
  slData:=StrSplit(dtstr,separator);
  if (slFmt.Count<> 3) or (slData.count <> 3) then begin
    Raise Exception.Create(dtstr+' is invalid date format. format='+fmt);
  end;

  idxY:=_FindStringList(slFmt,'Y');
  idxM:=_FindStringList(slFmt,'M');
  idxD:=_FindStringList(slFmt,'D');

  if (idxY=-1) or (idxM=-1) or (idxD=-1) then begin
    Raise Exception.Create(dtstr+' is invalid date format. format='+fmt);
  end;

  try
    yy:=strtoint(slData.Strings[idxY]);
    mm:=strtoint(slData.Strings[idxM]);
    dd:=strtoint(slData.Strings[idxD]);
    result:=EncodeDate(yy,mm,dd);
  except
    Raise Exception.Create(dtstr+' is invalid date format. format='+fmt);
  end;

end;

function StrtoDateFormat(dtStr,fmt:string):TDatetime;
var yyStart,mmStart,ddStart,yyLeng,mmLeng,ddLeng:integer;
    posi:integer;
    yy,mm,dd:integer;
begin
  fmt:=trim(uppercase(fmt));
  posi:=pos('-',fmt);
  if posi>0 then begin
    result:=_StrtoDateFormat_sepparator(dtStr,fmt,'-');
    exit;
  end;
  posi:=pos('/',fmt);

  if posi>0 then begin
    result:=_StrtoDateFormat_sepparator(dtStr,fmt,'/');
    exit;
  end;

  yyStart:=pos('Y',fmt);
  posi:=LastDelimiter('Y',fmt);
  yyLeng:=posi-yyStart+1;

  mmStart:=pos('M',fmt);
  posi:=LastDelimiter('M',fmt);
  mmLeng:=posi-mmStart+1;

  ddStart:=pos('D',fmt);
  posi:=LastDelimiter('D',fmt);
  ddLeng:=posi-ddStart+1;


  if (yyStart=0) or (mmStart=0) or (ddStart=0) then begin
    Raise Exception.Create(dtstr+' is invalid date format. format='+fmt);
  end;

  try
    yy:=strtoint(copy(dtstr,yyStart,yyLeng));
    mm:=strtoint(copy(dtstr,mmStart,mmLeng));
    dd:=strtoint(copy(dtstr,ddStart,ddLeng));
    result:=EncodeDate(yy,mm,dd);
  except
    Raise Exception.Create(dtstr+' is invalid date format. format='+fmt);
  end;
end;


function StrtoDatetimeFormat(s,fmt:string;var errMsg:string):TDatetime;
var oldLongTimeFmt,oldShortDateFmt:string;
    OldDateSeparator:char;

    n:integer;
    dateFmt,timeFmt:string;
    DateSplit:char;
begin
  oldShortDateFmt:=ShortDateFormat;
  oldLongTimeFmt:=LongTimeFormat;
  OldDateSeparator:=DateSeparator;
  try
    if fmt='' then begin
      fmt:='yyyy-mm-dd hh:nn:ss';
    end;

    n:=pos(' ',fmt);
    if n=0 then begin
      dateFmt:=fmt;
      timeFmt:=LongTimeFormat;
    end else begin
      dateFmt:=copy(fmt,1,n-1);
      timeFmt:=copy(fmt,n+1,65000);
    end;
    n:=pos('-',dateFmt);
    if n>0 then
      DateSplit:='-'
    else
      DateSplit:='/';

    DateSeparator:=DateSplit;
    ShortDateFormat:=  dateFmt;
    LongTimeFormat := timeFmt;

    errMsg:='';
    try
      result:=strtodatetime(s);
    except
      on E:Exception do begin
        result:=0;
        errMsg:=e.Message;
      end
    end;
  finally
    ShortDateFormat:=oldShortDateFmt;
    LongTimeFormat:=oldLongTimeFmt;
    DateSeparator:=OldDateSeparator;
  end;
end;


function HasProperty(AObject: TObject; const APropName: string): boolean;
begin
  Result := GetPropInfo(AObject.ClassInfo, APropName) <> nil;
end;

procedure SetCtrlReadOnly(Ctl:TComponent;mode:boolean);
var
    font:TFont;
//    color:TColor;
begin
  if not HasProperty(ctl,'Font') then exit;
//  if HasProperty(ctl,'Caption') then exit;
  if HasProperty(ctl,'ReadOnly')
    or  HasProperty(ctl,'OptionsDB') then     // for QuantumGrid
  begin
    if HasProperty(ctl,'ReadOnly') then
      SetPropValue(Ctl,'ReadOnly',Mode);
    if HasProperty(ctl,'Color') then
    begin
//      color:=GetPropValue(ctl,'Color');
//      if (color<>clWindow) or (color<>clWhite) then exit;

      IF mode then
        SetPropValue(ctl,'Color',ColrEditDisableBack)
      else
        SetPropValue(ctl,'Color',ColrEditEnableBack);

      if HasProperty(ctl,'Font') then
      begin
        font:=GetObjectProp(ctl,'Font') as TFont;
        if mode then
          font.Color:=ColrEditDisableFore
        else
          font.Color:=ColrEditEnableFore;
      end;
    end;
  end;
{  if HasProperty(ctl,'TabStop') then
    SetPropValue(ctl,'TabStop',not mode);}
end;

procedure SetOwnerCtrlReadOnly(AOwner:TComponent;mode:boolean);
var i:integer;
//    N:STRING;
begin
    for i:=0 to AOwner.ComponentCount-1 do
    begin
//      n:=AOwner.Components[i].Name;
      SetCtrlReadOnly(AOwner.Components[i],mode);
    end;
end;

procedure SetCtrlColor(Ctl:TComponent;ForeColr,BackColr:TColor);
var
    font:TFont;
begin
  if not HasProperty(ctl,'Font') then exit;
//  if HasProperty(ctl,'Caption') then exit;
  if HasProperty(ctl,'ReadOnly') or HasProperty(ctl,'DataSource') then
  begin
    if HasProperty(ctl,'Color') then
      SetPropValue(ctl,'Color',BackColr);
    if HasProperty(ctl,'Font') then
    begin
      font:=GetObjectProp(ctl,'Font') as TFont;
      font.Color:=ForeColr;
    end;
  end;
end;

procedure SetOwnerCtrlColor(AOwner:TComponent;ForeColr,BackColr:TColor);
var i:integer;
//    N:STRING;
begin
    for i:=0 to AOwner.ComponentCount-1 do
    begin
//      n:=AOwner.Components[i].Name;
      SetCtrlColor(AOwner.Components[i],ForeColr,BackColr);
    end;
end;


procedure ErrMsg(msg:string;ErrClass:ErrType);
var MsgStr:string;
begin
    if   ErrClass =USER then
      MsgStr := '使用者錯誤:'+cr+cr+msg
    else
       MsgStr := '系統錯誤:'+cr+cr+msg;

  raise EXCEPTION.Create(MsgStr);

end;

procedure msg(s:string);
begin
  MessageDlg(s,mtWarning,[mbOK]	,0);
end;


function ConfirmMsg(msg:string):Word;
begin
  Result :=MessageDlg(msg, mtConfirmation, [mbYes, mbNo], 0);
end;


function ProcessExecute(CommandLine: string; cShow: Word=sw_ShowNormal;wait:DWord=INFINITE): Integer;
var
  Rslt: LongBool;
  StartUpInfo: TStartUpInfo;  // documented as STARTUPINFO
  ProcessInfo: TProcessInformation; // documented as PROCESS_INFORMATION
begin
  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
  with StartupInfo do
  begin
    cb := SizeOf(TStartupInfo); // Specify size of structure
    dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK;
    wShowWindow := cShow
  end;
  Rslt := CreateProcess(nil,PChar(CommandLine),  nil, nil, False,
    NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo);
  if Rslt then
    with ProcessInfo do
    begin
      { Wait until the process is in idle. }
      WaitForInputIdle(hProcess, INFINITE);
      WaitforSingleObject(hProcess,wait);
      CloseHandle(hThread); // Free the hThread  handle
      CloseHandle(hProcess);// Free the hProcess handle
      Result := 0;          // Set Result to 0, meaning successful
    end
  else Result := GetLastError; // Set result to the error code.
end;

function ProcessExecuteResult_hProcess(CommandLine: string; cShow: Word=sw_ShowNormal): Integer;
var
  Rslt: LongBool;
  StartUpInfo: TStartUpInfo;  // documented as STARTUPINFO
  ProcessInfo: TProcessInformation; // documented as PROCESS_INFORMATION
begin
  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
  with StartupInfo do
  begin
    cb := SizeOf(TStartupInfo); // Specify size of structure
    dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK;
    wShowWindow := cShow
  end;
  Rslt := CreateProcess(nil,PChar(CommandLine),  nil, nil, False,
    NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo);
  if Rslt then
    with ProcessInfo do
    begin
      { Wait until the process is in idle. }
      WaitForInputIdle(hProcess, INFINITE);
      WaitforSingleObject(hProcess,0);
      CloseHandle(hThread); // Free the hThread  handle
      CloseHandle(hProcess);// Free the hProcess handle
      Result := hProcess;
    end
  else Result := -1;
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

function StrRepeat(ch:char;rep:integer):string;
var s:string;
  i:integer;
begin
  setlength(s,rep);
  for i:=1 to rep do
    s[i]:=ch;
  result:=s;
end;


procedure hintMsg(bar:TStatusBar;msg:string);
begin
  bar.SimpleText:=msg;
end;

procedure StrDivide(const SrcStr,DivideStr:string;StrList:TStringList);
{以 DivideStr 為間隔, 分割字串存入StrList 傳回}
var n:integer;
  s,s0:string;
begin
  s:=SrcStr;
  n:=pos(DivideStr,s);
  while (n>0) do begin
    s0:=trim(copy(s,0,n-1));
    StrList.Add(s0);
    delete(s,1,n);
    n:=pos(DivideStr,s);
  end;
  s:=trim(s);
  if s<>'' then StrList.Add(s);
end;


function StrMid(s:string;start:integer;cnt:integer=-1):string;
begin
  if cnt<0 then cnt:=length(s)-start+1;
  result:=copy(s,start,cnt);
end;

function StrLeft(s:string;cnt:integer):string;
begin
  result:=copy(s,1,cnt);
end;

function StrRight(s:string;cnt:integer):string;
begin
  result:=copy(s,length(s)-cnt+1,cnt);
end;



procedure StrReplace(var lin:string;sStr,dStr:string);
{將 lin 內含有 sStr 的部分取代為 dStr}
var n,lens:integer;
    s:string;
begin
  s:=lin;
  lin:='';
  lens:=length(sStr);
  n:=pos(sStr,s);
  while (n>0) do begin
    lin:=lin+copy(s,1,n-1)+dstr;
    s:=strMid(s,n+lens);
    n:=pos(sStr,s);
  end;
  if s<>'' then lin:=lin+s;
end;



function vartocurr(v:variant):currency;
begin
  IF VARISNULL(V) THEN
    result:=0
  else
    result:=v;
end;


procedure DeleteAllFile(fn:string);
var F: TSearchRec;
    path:string;
begin
  path:=ExtractFilePath(fn);
  if findfirst(fn,faAnyFile,F)=0 then
    repeat
        deleteFile(path+f.Name);
    until findnext(F)<>0;
end;

procedure debug (msg:string;mode:string='W');
var f:TextFile;
begin
  AssignFile(f,G_TempPath +'\DebugICD.SQL');
  if mode = 'W' then
    ReWrite (f)
  else
    append (f);
  writeln(f,msg);
  closeFile(f);

end;



function isLeafNode(xmlNode: IXMLDOMNode): boolean;
var list:IXMLDOMNodeList;
begin
  result:=false;
  list:=xmlNode.childNodes;
  if list.length=0 then begin
      result:=true;
  end;

  if list.length=1 then begin
    if list.item[0].nodeName='#text' then begin
      result:=true;
    end;
  end;
end;


function ParseVbScript(cmd: string): string;
var sc:TScriptControl;
    v:variant;
    ch:string;
begin
  cmd:=trim(cmd);
  ch:=leftstr(cmd,1);
  if ch <>'=' Then begin
    result:=cmd;
    exit;
  end;
  cmd:=midstr(cmd,2,999);


  sc:=TScriptControl.Create(nil);
  sc.Language:='VBScript';
  try
    try
      v:=sc.Eval(cmd);
      result:=vartostr(v);
    except
      on E: Exception do begin
        result:=e.Message;
      end;
    end;
  finally
    sc.Free;
  end;
end;


function iif(Condition: Boolean; TrueReturn, FalseReturn: Variant): Variant;
begin
  if Condition then
    Result := TrueReturn
  else
    Result := FalseReturn;
end;

// ============================================================================
// 取得環境變數
// ============================================================================
function getEnvrionment(Variable: string): string;
var s: string;
  b: array[0..255] of char;
begin
  s := Variable;
  GetEnvironmentVariable(pChar(s), b, sizeof(b));
  result := string(b);
end;





function StrDivideList(const SrcStr, separator: string;TrimFlag: boolean = true): TStringList;
{以 separator 為間隔, 分割字串存入StrList 傳回}
begin
  Result := StrSplit(SrcStr, separator,TrimFlag);
end;



procedure TrimEditCtrl(Ctrl: TCustomEdit);
begin
  ctrl.Text:=trim(ctrl.Text);
end;


procedure TrimAllText(AOwner: TComponent);
var i: integer;
    s:string;
begin
  for i := 0 to AOwner.ComponentCount - 1 do begin
    s:=AOwner.Components[i].Name;
    if AOwner.Components[i] is TCustomEdit then begin
      TrimEditCtrl(AOwner.Components[i] as TCustomEdit);
    end;
  end;
end;


{ ==========================================================
  四捨五入取到第 n 位
=============================================================}
function RoundN(x: Double; n: Integer): double;
var base: double;
begin
  if x > 0 then begin
    base := power(10, n);
    result := trunc(x * base + 0.5) / base;
  end else begin
    base := power(10, n);
    result := trunc(x * base - 0.5) / base;
  end;
end;




{ ==========================================================
  去除浮點運算誤差
  有效位數=14位
=============================================================}
function FloatCalc(x: Double): double;
var n: integer;
  ix: integer;
begin
  { ==========================================================
    //取得整數位數
  =============================================================}
  ix := floor(abs(x)); //只取整數部分
  if ix = 0 then begin
    n := 0;
  end else begin
    n := floor(Log10(ix)) + 1;
  end;

  result := RoundN(x, 14 - n);
end;


initialization
  G_TempPath := GetEnvrionment('TEMP'); //TEMP 環境變數指向的路徑

end.

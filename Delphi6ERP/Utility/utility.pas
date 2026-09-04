unit utility;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,stdctrls,db,DBTables,Utili_Str,dbctrls,TypInfo,DBGrids,Grids,math,
  printers,QuickRpt,WinSpool;

type
  ErrType=(USER,SYS);

const MinimaString=#1;
      MaximaString=#253#255;
      MinimaDate='60/01/01';
      MaximaDate='199/12/31';
      MinimaInteger=-999999999;
      MaximaInteger=999999999;
      MinimaFloat=-999999999999.0;
      MaximaFloat=999999999999.0;


{ Define for SetEdit????Mode Using}
const EditEnableFore=clRed;
const EditEnableBack=clWhite;
const EditDisableFore=clMaroon;
const EditDisableBack=clSilver;
const EditErrBack=ClRed;
const EditErrFore=ClWhite;

function ProcessExecute(CommandLine: string; cShow: Word=sw_ShowNormal): Integer;
procedure DeleteAllFile(fn:string);
function GetPrinterName(qrp:TQuickRep):string;
function SetPrinterUserSize(printerName:string;LengthMM,WidthMM:integer):boolean;
procedure ERR;
function trunc45(x: extended; Point: integer): extended;
function SignSame(n1,n2:double):boolean;
procedure WarpChLin(var lin:string;leng:integer);
function IsLeadByteTw(c:Char):Boolean;
function GetRangeData(OrgStr:string;DataType:TFieldType;RangeFrom:Boolean;ChiDate:Boolean=FALSE;StrAddDitto:Boolean=FALSE):variant;
procedure ChkCDateEdit(Edit:TEdit;AllowBlank:Boolean=False);
procedure ChkNumEdit(Edit:TEdit;AllowMinus:Boolean=False);
function ChkNum(s:string;AllowMinus:Boolean=False):String;
procedure ErrMsg(msg:string;ErrClass:ErrType=USER);
procedure ErrBeep;
procedure PcBeep;
procedure ClearGrid(grid1:TStringGrid);
procedure msg(s:string);
function Chi2ADDate(chidate:string):TDateTime;
function AD2ChiDate(AD_Date:TDateTime):string;
procedure ReadIndexToList(tbl:TTable;Combo:TComboBox);
procedure WSwapText(C1:TEdit;C2:TEdit);overload;
procedure WSwapText(C1:TComboBox;C2:TComboBox); overload;
procedure ClearGridRow(grid:TStringGrid;RowFrom,RowTo:integer);
procedure ClearFormEdit(AOwner:TWinControl);
procedure SetDBControlEnabled(AOwner:TWinControl;mode:boolean);
procedure SetModeDBEdit(AOwner:TWinControl;mode:boolean);
procedure SetModeDBMemo(AOwner:TWinControl;mode:boolean);
procedure SetModeDBGrid(AOwner:TWinControl;mode:boolean);
procedure SetModeDBLookupComboBox(AOwner:TWinControl;mode:boolean);
procedure SetDBControlReadOnly(AOwner:TWinControl;mode:boolean);
procedure TrimAllEdit(Aowner:TWinControl);
procedure SetModeEdit(AOwner:TWinControl;mode:boolean);
procedure SetModeStringGrid(AOwner:TWinControl;mode:boolean);
procedure SetControlReadOnly(AOwner:TWinControl;mode:boolean);
procedure SwapVar(var v1,v2:variant);

//Procedure SetCapsLock(bLockIt: boolean);
//Procedure SetNumLock(bLockIt: boolean);
procedure SetCapsLock(fLocked: boolean);
//procedure SetNumLock(fLocked: boolean);
function HasProperty(AObject: TObject; const APropName: string): boolean;


implementation

{ TWMsg }

///////////////////////////
procedure  ReadIndexToList(tbl:TTable;Combo:TComboBox);
var
  i:integer;
  list:TstringList;
  s:string;
Begin
  list:=TstringList.Create;
  list.Sorted:=true;

  tbl.IndexDefs.Update;
  for i:=0 to tbl.IndexDefs.Count-1 do
  with tbl.IndexDefs.Items[I] do begin
    //if name='' then continue;	//Primary Key
    s:=format('%-100s',[name])+fields;
    list.Add(s);
  end;
  for i:=0 to list.Count-1 do begin
    combo.Items.Add (copy(list.Strings[i],101,100));
  end;

End;

procedure WSwapText(C1:TEdit;C2:TEdit); overload;
var
  s:string;

begin
  s:=C1.Text;
  C1.Text:=C2.Text;
  C2.Text:=s;

end;

procedure WSwapText(C1:TComboBox;C2:TComboBox); overload;
var
  s:string;
begin
  s:=C1.Text;
  C1.Text:=C2.Text;
  C2.Text:=s;

end;

function AD2ChiDate(AD_Date:TDateTime):string;
var
  y,m,d:word;
begin
  DecodeDate(AD_Date,y,m,d);
  dec(y,1911);
  result:=format('%.2d/%.2d/%.2d',[y,m,d]);
end;

function Chi2ADDate(chidate:string):TDateTime;
var
  p1,p2,yr,mh,dy:integer;
  DateSep:char;
  DateFmt,s:string;

begin
  if InStr(ChiDate,1,'/')=0 then begin
    insert('/',ChiDate,3);
    insert('/',ChiDate,6);
  end;
  p1:=InStr(ChiDate,1,'/');
  p2:=Instr(ChiDate,p1+1,'/');
  if p2=0 then
    raise EConvertError.Create('日期格式錯誤 !!' + ChiDate);
try
  yr:=strtoint(StrLeft(ChiDate,p1-1))+1911;
  mh:=str2Val(StrMid(ChiDate,p1+1));
  dy:=str2val(StrMid(ChiDate,p2+1));
  s:=format('%.4d/%.2d/%.2d',[yr,mh,dy]);
  DateSep:=DateSeparator;
  DateFmt:=ShortDateFormat;
  DateSeparator:='/';
  ShortDateFormat:='yyyy/mm/dd';
  result:=strtodate(s);
  DateSeparator:=DateSep;
  ShortDateFormat:=DateFmt;
except
  raise EConvertError.Create('日期格式錯誤 !!' + ChiDate);
end;

end;


procedure SetDBControlEnabled(AOwner:TWinControl;mode:boolean);
var i:integer;
  s:string;
begin
  with AOwner do
    for i:=0 to ComponentCount-1 do begin
      s:=Components[i].name;
      if not HasProperty(Components[i], 'DataSource') then continue;
      if HasProperty(Components[i], 'ReadOnly') then
        (Components[i] as TControl).Enabled := mode;
{      if HasProperty(Components[i],'font') then
        if mode=true then begin
          (Components[i] as TControl).Color:= EditEnableBack;
          (Components[i] as TControl).font.Color:=EditEnableFore;
        end else begin
          (Components[i] as TControl).Color:= EditDisableBack;
          (Components[i] as TControl).font.Color:= EditDisableFore;
        end;}
    end;
end;




procedure SetModeDBEdit(AOwner:TWinControl;mode:boolean);
var i:integer;
begin
  with AOwner do
    for i:=0 to ComponentCount-1 do
    begin
      if Components[i] is TDBEdit then
      begin
        TDBEdit(Components[i]).ReadOnly:=not mode;
        if mode=true then
        begin
          TDBEdit(Components[i]).Color:= EditEnableBack;
          TDBEdit(Components[i]).font.Color:=EditEnableFore;
        end else
        begin
          TDBEdit(Components[i]).Color:= EditDisableBack;
          TDBEdit(Components[i]).font.Color:= EditDisableFore;
        end;
      end;
    end;
end;

procedure SetModeDBMemo(AOwner:TWinControl;mode:boolean);
var i:integer;
begin
  with AOwner do
    for i:=0 to ComponentCount-1 do
    begin
      if Components[i] is TDBMemo then
      begin
        TDBMemo(Components[i]).ReadOnly:=not mode;
        if mode=true then
        begin
          TDBMemo(Components[i]).Color:= EditEnableBack;
          TDBMemo(Components[i]).font.Color:=EditEnableFore;
        end else
        begin
          TDBMemo(Components[i]).Color:= EditDisableBack;
          TDBMemo(Components[i]).font.Color:= EditDisableFore;
        end;
      end;
    end;
end;

procedure SetModeDBGrid(AOwner:TWinControl;mode:boolean);
var i:integer;
begin
  with AOwner do
    for i:=0 to ComponentCount-1 do
    begin
      if Components[i] is TDBGrid then
      begin
        TDBGrid(Components[i]).ReadOnly:=not mode;
        if mode=true then
        begin
          TDBGrid(Components[i]).Color:= EditEnableBack;
          TDBGrid(Components[i]).font.Color:=EditEnableFore;
        end else
        begin
          TDBGrid(Components[i]).Color:= EditDisableBack;
          TDBGrid(Components[i]).font.Color:= EditDisableFore;
        end;
      end;
    end;
end;

procedure SetModeDBLookupComboBox(AOwner:TWinControl;mode:boolean);
var i:integer;
begin
  with AOwner do
    for i:=0 to ComponentCount-1 do
    begin
      if Components[i] is TDBLookupComboBox then
      begin
        TDBLookupComboBox(Components[i]).ReadOnly:=not mode;
        if mode=true then
        begin
          TDBLookupComboBox(Components[i]).Color:= EditEnableBack;
          TDBLookupComboBox(Components[i]).font.Color:=EditEnableFore;
        end else
        begin
          TDBLookupComboBox(Components[i]).Color:= EditDisableBack;
          TDBLookupComboBox(Components[i]).font.Color:= EditDisableFore;
        end;
      end;
    end;
end;

procedure SetDBControlReadOnly(AOwner:TWinControl;mode:boolean);
begin
  SetModeDBEdit(AOwner,mode);
  SetModeDBMemo(AOwner,mode);
  SetModeDBGrid(AOwner,mode);
  SetModeDBLookupComboBox(AOwner,mode);
end;


procedure SetModeEdit(AOwner:TWinControl;mode:boolean);
var i:integer;
begin
  with AOwner do
    for i:=0 to ComponentCount-1 do
    begin
      if Components[i] is TEdit then
      begin
        TEdit(Components[i]).ReadOnly:=not mode;
        if mode=true then
        begin
          TEdit(Components[i]).Color:= EditEnableBack;
          TEdit(Components[i]).font.Color:=EditEnableFore;
        end else
        begin
          TEdit(Components[i]).Color:= EditDisableBack;
          TEdit(Components[i]).font.Color:= EditDisableFore;
        end;
      end;
    end;
end;

procedure SetModeStringGrid(AOwner:TWinControl;mode:boolean);
var i:integer;
begin
  with AOwner do
    for i:=0 to ComponentCount-1 do
    begin
      if Components[i] is TStringGrid then
      begin
        TDBGrid(Components[i]).ReadOnly:=not mode;
        if mode=true then
        begin
          TStringGrid(Components[i]).Color:= EditEnableBack;
          TStringGrid(Components[i]).font.Color:=EditEnableFore;
        end else
        begin
          TStringGrid(Components[i]).Color:= EditEnableBack;
          TStringGrid(Components[i]).font.Color:= EditDisableFore;
        end;
      end;
    end;
end;

procedure SetControlReadOnly(AOwner:TWinControl;mode:boolean);
begin
  SetModeEdit(AOwner,mode);
  SetModeStringGrid(AOwner,mode);
end;

procedure SetCapsLock(fLocked: boolean);
var
  uKeyState: UINT;
begin
  uKeyState := GetKeyState(VK_CAPITAL);
  if ((uKeyState and 1) > 0) <> fLocked then
  begin
    keybd_event(VK_CAPITAL, MapVirtualKey(VK_CAPITAL, 0), 0, 0);
    keybd_event(VK_CAPITAL, MapVirtualKey(VK_CAPITAL, 0),
      KEYEVENTF_KEYUP, 0);
  end;
end;


{Procedure SetCapsLock(bLockIt: boolean);
Var
  KeyState : TKeyBoardState;
begin
  GetKeyboardState(KeyState);
  if bLockIt then
    KeyState[VK_CAPITAL] := 1
  else
    KeyState[VK_CAPITAL] := 0;
  setKeyboardState(KeyState);
end;

Procedure SetNumLock(bLockIt: boolean);
Var  KeyState : TKeyBoardState;
begin
  GetKeyboardState(KeyState);
  if bLockIt then
    KeyState[VK_NUMLOCK] := 1
  else
    KeyState[VK_NUMLOCK] := 0;
  SetKeyboardState(KeyState);
end;}

function HasProperty(AObject: TObject; const APropName: string): boolean;
begin
  Result := GetPropInfo(AObject.ClassInfo, APropName) <> nil;
end;


procedure ClearFormEdit(AOwner:TWinControl);
var i:integer;
begin
  with AOwner do
    for i:=0 to ComponentCount-1 do
      if Components[i] is TEdit then
      	TEdit(Components[i]).text:='';
end;

procedure ClearGridRow(grid:TStringGrid;RowFrom,RowTo:integer);
var i:integer;
	ts:TstringList;
begin
	ts:=TstringList.Create;
  for i:=1 to grid.ColCount do  ts.Add ('');
  for i:= RowFrom to RowTo do	grid.Rows[i]:=ts;
  ts.Free;
end;

procedure TrimAllEdit(Aowner:TWinControl);
var i:integer;
begin
  with AOwner do
    for i:=0 to ComponentCount-1 do
      if (Components[i] is TEdit) or (Components[i] is TDBEdit) then
        TCustomEdit(Components[i]).Text:=trim(TCustomEdit(Components[i]).Text);
end;

procedure SwapVar(var v1,v2:variant);
var v:variant;
begin
  v:=v1;
  v1:=v2;
  v2:=v;
end;

procedure ErrBeep;
begin
  MessageBeep(MB_ICONASTERISK);
end;

procedure PcBeep;
begin
  MessageBeep($FFFFFFFF);;
end;


procedure ErrMsg(msg:string;ErrClass:ErrType);
var MsgStr:string;
begin
  case ErrClass of
    USER: MsgStr := '使用者輸入錯誤 !'#13#13+msg;
    SYS : MsgStr := '系 統 錯 誤 !!! '#13#13+msg+#13#13+
                    '請聯絡工程師 !!!';
  end;
  ErrBeep;
  MessageDlg(MsgStr,mtError,[mbOK],0);
end;

procedure msg(s:string);
begin
  ShowMessage(s);
end;

procedure ClearGrid(grid1:TStringGrid);
begin
  ClearGridRow(grid1,1,grid1.RowCount-1);
end;


function ChkNum(s:string;AllowMinus:Boolean=False):String;
var c:currency;
begin
  s:=trim(s);
  if s='' then s:='0';
  try
    c:=StrToCurr(s);
    if (AllowMinus=false) and (c<0) then
      raise EConvertError.Create('');
    result:=CurrToStr(c);
  except
    raise EConvertError.Create('數值欄位錯誤');
  end;
end;

procedure ChkNumEdit(Edit:TEdit;AllowMinus:Boolean=False);
{ 檢查 Edit 欄位內容是否為合法的數值,若不是將出現Error Message後
  將執行 Edit.SetFocus; AllowMinus:允許負數 }
begin
  try
    edit.text:=ChkNum(edit.text,AllowMinus);
  except
    edit.SetFocus;
    raise;
  end;
end;


procedure ChkCDateEdit(Edit:TEdit;AllowBlank:Boolean=False);
{ 檢查 Edit 欄位內容是否為合法的中式日期,若不是將出現Error Message後
  將執行 Edit.SetFocus }
begin
  if (AllowBlank) and (trim(Edit.Text)='') then exit;
  try
    edit.text:=AD2ChiDate(Chi2ADDate(edit.text));
  except
    edit.SetFocus;
    raise;
  end;
end;


function GetRangeData(OrgStr:string;DataType:TFieldType;RangeFrom:Boolean;ChiDate:Boolean=FALSE;StrAddDitto:Boolean=FALSE):variant;
{將OrgStr 轉成typ所指示的DataType 傳回,
  若為空字串判斷RangeFrom的值
  若RangeFrom 為TRUE:傳回該DataType 的最小值 否則傳回最大值.
  若UseForDisplay=False 則result=
     1.字串前後必需加上單引號
     2.日期需轉成西元
  *** 本function假設Date 為民國日期
}
begin
  OrgStr:=trim(OrgStr);
  case DataType of
    ftString,ftWideString,ftFixedChar: begin
      if OrgStr='' then
        if RangeFrom then result:=MinimaString else result:=MaximaString
      else
        result:=OrgStr;
      if StrAddDitto then result:=#39+result+#39;
    end;
    ftDate,ftDateTime: begin
      if OrgStr='' then
        if RangeFrom then OrgStr:=MinimaDate else OrgStr:=MaximaDate;
      if ChiDate then
        result:=Ad2ChiDate(Chi2ADDate(OrgStr))
      else
        result:=Chi2ADDate(OrgStr);
    end;
    ftSmallInt,ftInteger,ftWord,ftAutoInc:begin
      if OrgStr='' then
        if RangeFrom then result:=MinimaInteger else result:=Maximainteger
      else
        result:=strtoint(OrgStr);
    end;
    ftFloat: begin
      if OrgStr='' then
        if RangeFrom then result:=MinimaFloat else result:=MaximaFloat
      else
        result:=strtofloat(OrgStr);
    end;
  else
    result:=NULL;
  end;
end;

//判斷某一個字元是否為中文的前導字元
function IsLeadByteTw(c:Char):Boolean;
begin
  //根據附屬應用程式中的"字元對應表"計算而得 ($81 .. $FE)
  Result:=(c in [Char($81)..Char($FE)]);
  {
  //呼叫 Windows API 來計算 (但效率較差)
  Result:=IsDBCSLeadByte(Byte(c));
  }
end;

procedure WarpChLin(var lin:string;leng:integer);
var i:integer;
begin
  i:=1;
  REPEAT
    if IsLeadByteTw(lin[i]) then inc(i,2) else inc(i);
  until i>leng;
  insert(#13,lin,i);
end;

function trunc45(x: extended; Point: integer): extended;
//依四捨五入法,取指定位數的小數
var fix,pwr:extended;
begin
  if x>0 then fix:=0.5 else fix :=-0.5;
  pwr:=power(10,point);
  result:=int(x*pwr+fix)/pwr;
end;


function SignSame(n1,n2:double):Boolean;
//判斷兩數的正負號是否一致
begin
  if (n1=0) or (n2=0) then
    result:=True
  else begin
    result:=((n1 / n2) >0.0);
  end

end;

procedure ERR;
begin
  strtocurr('123..2');
end;

function SetPrinterUserSize(printerName:string;LengthMM,WidthMM:integer):boolean;
var handle:Cardinal;
    buf:pointer;
    siz,level:DWord;
begin
  buf:=nil; // for Clear Warning
  if OpenPrinter(Pchar(PrinterName),handle,Nil)=False then begin
    result:=false;
    exit;
  end;
try
  level:=2;
  siz:=0;
  GetPrinter(handle,level,nil,siz,@siz);
  GetMem(buf,siz);
  if GetPrinter(handle,level,pbyte(buf),siz,@siz)=False then begin
    result:=false;
    exit;
  end;
  with DevMode(Printer_Info_2(buf^).pDevMode^) do begin
    dmPaperSize:=DMPaper_User;
    dmPaperLength:=LengthMM;
    dmPaperWidth:=WidthMM;
  end;
  if SetPrinter(handle,level,pbyte(buf),0)= false then begin
    beep;
    result:=false;
    exit;
  end;
  result:=True;
finally
  freemem(buf);
  ClosePrinter(handle);
end;
end;

function GetPrinterName(qrp:TQuickRep):string;
var Pr,dr,po:array[0..255] of char;
    mode:THandle;
begin
  try
    qrp.Prepare;
    printer.PrinterIndex:=qrp.printer.PrinterIndex;
    printer.GetPrinter(pr, Dr, Po, mode);
    result:=StrPas(pr);
  finally
    qrp.QRPrinter.Free;
    qrp.QRPrinter:=nil;
  end;
end;

function ProcessExecute(CommandLine: string; cShow: Word): Integer;
{ This method encapsulates the call to CreateProcess() which creates
  a new process and its primary thread. This is the method used in
  Win32 to execute another application, This method requires the use
  of the TStartInfo and TProcessInformation structures. These structures
  are not documented as part of the Delphi 4 online help but rather
  the Win32 help as STARTUPINFO and PROCESS_INFORMATION.

  The CommandLine paremeter specifies the pathname of the file to
  execute.

  The cShow paremeter specifies one of the SW_XXXX constants which
  specifies how to display the window. This value is assigned to the
  sShowWindow field of the TStartupInfo structure. }
var
  Rslt: LongBool;
  StartUpInfo: TStartUpInfo;  // documented as STARTUPINFO
  ProcessInfo: TProcessInformation; // documented as PROCESS_INFORMATION
begin
  { Clear the StartupInfo structure }
  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
  { Initialize the StartupInfo structure with required data.
    Here, we assign the SW_XXXX constant to the wShowWindow field
    of StartupInfo. When specifying a value to this field the
    STARTF_USESSHOWWINDOW flag must be set in the dwFlags field.
    Additional information on the TStartupInfo is provided in the Win32
    online help under STARTUPINFO. }
  with StartupInfo do
  begin
    cb := SizeOf(TStartupInfo); // Specify size of structure
    dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK;
    wShowWindow := cShow
  end;

  { Create the process by calling CreateProcess(). This function
    fills the ProcessInfo structure with information about the new
    process and its primary thread. Detailed information is provided
    in the Win32 online help for the TProcessInfo structure under
    PROCESS_INFORMATION. }
  Rslt := CreateProcess(nil,PChar(CommandLine),  nil, nil, False,
    NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo);
  { If Rslt is true, then the CreateProcess call was successful.
    Otherwise, GetLastError will return an error code representing the
    error which occurred. }
  if Rslt then
    with ProcessInfo do
    begin
      { Wait until the process is in idle. }
      WaitForInputIdle(hProcess, INFINITE);
      CloseHandle(hThread); // Free the hThread  handle
      CloseHandle(hProcess);// Free the hProcess handle
      Result := 0;          // Set Result to 0, meaning successful
    end
  else Result := GetLastError; // Set result to the error code.
end;

procedure DeleteAllFile(fn:string);
var F: TSearchRec;
    path:string;
begin
  path:=ExtractFilePath(fn);
  if findfirst(fn,faArchive,F)=0 then
    repeat
        deleteFile(path+f.Name);
    until findnext(F)<>0;
end;



end.

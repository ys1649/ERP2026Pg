unit ExMAPI;

interface
uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs,
  StdCtrls, MAPI;
type
  //使用系統預設郵件軟體發信(Outlook or Outlook Express)
  TExMAPI=class(TPersistent)
  private
    FHandle: THandle;
    FSubject: String;
    FText: String;
    FToList: TStrings;
    FBCCList: TStrings;
    FCCList: TStrings;
    FShowUI: Boolean;
    FAttachFiles: TStrings;
    FFromAddress: String;
    FFromName: String;
  protected
  public
    constructor Create(Control: TControl); virtual;
    destructor Destroy; override;
    //執行發送郵件
    function SendMail: Boolean;
    procedure Clear;
  published
    property Handle: THandle read FHandle write FHandle;
    //郵件主旨
    property Subject: String read FSubject write FSubject;
    //郵件內容
    property Text: String read FText write FText;
    //發信者電子郵件
    property FromAddress: String read FFromAddress write FFromAddress;
    //發信者名稱
    property FromName: String read FFromName write FFromName;
    //收件者
    property ToList: TStrings read FToList write FToList;
    //副本收件者
    property CCList: TStrings read FCCList write FCCList;
    //密件副本收件者
    property BCCList: TStrings read FBCCList write FBCCList;
    //附件
    property AttachFiles: TStrings read FAttachFiles write FAttachFiles;
    //是否顯示發信軟體UI
    property ShowUI: Boolean read FShowUI write FShowUI;
  end;

//使用系統預設郵件軟體發信(Outlook or Outlook Express)
function ExMAPISendMail(Subject: String; Text: String; AttachFiles: String;
  ToList: String; CCList: String; BCCList: String; ShowUI: Boolean=False): Boolean;

implementation
//uses ExComm;

function ExMAPISendMail(Subject: String; Text: String; AttachFiles: String;
  ToList: String; CCList: String; BCCList: String; ShowUI: Boolean=False): Boolean;
//意義: 使用系統預設郵件軟體發信(Outlook or Outlook Express)
//參數: Subject - 郵件主旨
//      Body - 郵件內容
//      AttachFiles - 附件(多個附件以逗點分隔)
//      ToList - 收件者(多個收件者以逗點分隔)
//      CCList - 副本(多個副本以逗點分隔)
//      BCCList - 密件副本(多個密件副本以逗點分隔)
//      ShowUI - 是否顯示發信軟體UI
var
  ExMAPI: TExMAPI;
begin
  ExMAPI:= TExMAPI.Create(nil);
  try
    ExMAPI.Subject:= Subject;
    ExMAPI.Text:= Text;
    if AttachFiles<>'' then ExMAPI.AttachFiles.Text:= StringReplace(AttachFiles,',',#13#10,[rfReplaceAll, rfIgnoreCase]);
    if ToList<>'' then ExMAPI.ToList.Text:= StringReplace(ToList,',',#13#10,[rfReplaceAll, rfIgnoreCase]);
    if CCList<>'' then ExMAPI.CCList.Text:= StringReplace(CCList,',',#13#10,[rfReplaceAll, rfIgnoreCase]);
    if BCCList<>'' then ExMAPI.BCCList.Text:= StringReplace(BCCList,',',#13#10,[rfReplaceAll, rfIgnoreCase]);
    ExMAPI.ShowUI:= ShowUI;
    Result:= ExMAPI.SendMail;
  finally
    FreeAndNil(ExMAPI);
  end;
end;
{ TExMAPI }

procedure TExMAPI.Clear;
begin
  FToList.Clear;
  FCCList.Clear;
  FBCCList.Clear;
  FAttachFiles.Clear;
end;

constructor TExMAPI.Create(Control: TControl);
begin
  FHandle:= Application.Handle;
  FToList:= TStringList.Create;       //收件者
  FCCList:= TStringList.Create;       //副本收件者
  FBCCList:= TStringList.Create;      //密件副本收件者
  FAttachFiles:= TStringList.Create;  //附件
end;

destructor TExMAPI.Destroy;
begin
  FreeAndNil(FToList);
  FreeAndNil(FCCList);
  FreeAndNil(FBCCList);
  FreeAndNil(FAttachFiles);
  inherited;
end;


function TExMAPI.SendMail: Boolean;
type
  TRecipArray = array[0..0] of TMapiRecipDesc;
  PRecipArray = ^TRecipArray;

  TAttachArray = array[0..0] of TMapiFileDesc;
  PAttachArray = ^TAttachArray;
var
  MMsg: TMapiMessage;          //發件內容
  Sender: TMapiRecipDesc;      //發信者
  Recips: PRecipArray;         //收件者、副本、密件副本
  Attachments: PAttachArray;   //附件內容
  iRecipTotal: Integer;
  iRecipCount: Integer;
  MAPI_Session: Cardinal;
  ExecRet: Cardinal;
  N1: Integer;
  flFlags: FLAGS;
  WndList: Pointer;
begin
  Result:= False;
  Recips:= nil;
  Attachments:= nil;
  iRecipTotal:= 0;
  try
    //若登入不成功則離開
    ExecRet:= MapiLogon(FHandle, PChar(''), PChar(''),
          MAPI_LOGON_UI or MAPI_NEW_SESSION, 0, @MAPI_Session);
    if (ExecRet<>SUCCESS_SUCCESS) then exit;

    FillChar(MMsg, Sizeof(TMapiMessage),#0);
    //FillChar(Recip, Sizeof(TMapiRecipDesc)*64,#0);
    //FillChar(Attachment, Sizeof(TMapiFileDesc)*64,#0);

    //郵件主旨
    MMsg.lpszSubject:= StrNew(PChar(FSubject));
    //郵件內容
    MMsg.lpszNoteText:= StrNew(PChar(FText));

    if FFromAddress<>'' then
    begin
      Sender.ulReserved:= 0;
      Sender.ulRecipClass:= MAPI_ORIG;
      Sender.lpszName:= StrNew(PChar(FFromName));
      //Sender.lpszAddress:= StrNew(PChar(FFromAddress));
      Sender.ulEIDSize:= 0;
      Sender.lpEntryID:= nil;
      MMsg.lpOriginator:= @Sender;
    end;

    iRecipTotal:= FToList.Count+FCCList.Count+FBCCList.Count;
    if iRecipTotal=0 then FShowUI:= True;
    if iRecipTotal>0 then
    begin
      GetMem(Recips, SizeOf(TMapiRecipDesc)*iRecipTotal);
      iRecipCount:= 0;

      //收件者
      for N1:= 0 to FToList.Count-1 do
      begin
         Inc(iRecipCount);
         FillChar(Recips[iRecipCount-1], SizeOf(TMapiRecipDesc), #0);
         Recips[iRecipCount-1].ulRecipClass:= MAPI_TO;
         Recips[iRecipCount-1].lpszName:= StrNew(PChar(FToList.Strings[N1]));
         Recips[iRecipCount-1].lpszAddress:= StrNew(PChar('SMTP:'+FToList.Strings[N1]));
      end;
      //副本收件者
      for N1:= 0 to FCCList.Count-1 do
      begin
         Inc(iRecipCount);
         Recips[iRecipCount-1].ulRecipClass:= MAPI_CC;
         Recips[iRecipCount-1].lpszName:= StrNew(PChar(FCCList.Strings[N1]));
         Recips[iRecipCount-1].lpszAddress:= StrNew(PChar('SMTP:'+FCCList.Strings[N1]));
      end;
      //密件副本收件者
      for N1:= 0 to FBCCList.Count-1 do
      begin
         Inc(iRecipCount);
         Recips[iRecipCount-1].ulRecipClass:= MAPI_BCC;
         Recips[iRecipCount-1].lpszName:= StrNew(PChar(FBCCList.Strings[N1]));
         Recips[iRecipCount-1].lpszAddress:= StrNew(PChar('SMTP:'+FBCCList.Strings[N1]));
      end;

      MMsg.nRecipCount:= iRecipCount;
      MMsg.lpRecips:= @Recips^;
    end;



    //附件
    if FAttachFiles.Count>0 then begin
      GetMem(Attachments, SizeOf(TMapiFileDesc)*FAttachFiles.Count);
      for N1:= 0 to FAttachFiles.Count-1 do
      begin
        Attachments[N1].ulReserved := 0;
        Attachments[N1].flFlags := 0;
        Attachments[N1].nPosition := ULONG($FFFFFFFF);
        Attachments[N1].lpszPathName := StrNew(PChar(FAttachFiles.Strings[N1]));
        Attachments[N1].lpszFileName := StrNew(PChar(ExtractFileName(FAttachFiles.Strings[N1])));
        Attachments[N1].lpFileType := nil;
      end; 
      MMsg.nFileCount:= FAttachFiles.Count;
      MMsg.lpFiles:= @Attachments^;
    end;

    WndList:= DisableTaskWindows(0);
    try
      //是否顯示發信軟體UI
      if FShowUI then
        flFlags:= MAPI_DIALOG
      else
        flFlags:= 0;
      flFlags:= flFlags+MAPI_NEW_SESSION;
      ExecRet:= MAPI.MapiSendMail(MAPI_Session, FHandle,
          MMsg, flFlags, 0);
      Result:= (ExecRet=SUCCESS_SUCCESS);
    finally
      EnableTaskWindows(WndList);
    end;

    Result:= True;
  finally
    if Assigned(MMsg.lpszSubject) then StrDispose(MMsg.lpszSubject);
    if Assigned(MMsg.lpszNoteText) then StrDispose(MMsg.lpszNoteText);
    if Assigned(Sender.lpszName) then StrDispose(Sender.lpszName);
    if Assigned(Sender.lpszAddress) then StrDispose(Sender.lpszAddress);

    for N1:= 0 to iRecipTotal-1 do
    begin
      if Assigned(Recips[N1].lpszName) then StrDispose(Recips[N1].lpszName);
      if Assigned(Recips[N1].lpszAddress) then StrDispose(Recips[N1].lpszAddress);
    end;
    for N1:= 0 to FAttachFiles.Count-1 do
    begin
      if Assigned(Attachments[N1].lpszPathName) then StrDispose(Attachments[N1].lpszPathName);
      if Assigned(Attachments[N1].lpszFileName) then StrDispose(Attachments[N1].lpszFileName);
    end;
    MapiLogOff(MAPI_Session, FHandle, 0, 0); 
  end;
end;

end.


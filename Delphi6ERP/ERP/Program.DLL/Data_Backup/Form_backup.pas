unit Form_backup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,DateUtils,erp_public, FORM_ERP_BASE;

procedure SysBackup(sysinfo:TSysinfo;immediate:boolean);  
type
  Tfm_backup = class(TForm)
    bar1: TProgressBar;
    Label1: TLabel;
    btnAbort: TButton;
    btnBackup: TButton;
    procedure btnAbortClick(Sender: TObject);
    procedure btnBackupClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    filename:string;
    AbortFlag:boolean;
    procedure CreateTmpPath(path:string);
    procedure SaveTable(path:string);
    procedure PackTable(path:string);
    PROCEDURE BACKUP;
    procedure DelOldBakFile(days: integer; ext: string);
    { Private declarations }
  public
    immediate:boolean;
    sysinfo:TSysinfo;
    procedure init;
    { Public declarations }
  end;

implementation

uses Uty, DBUty;

{$R *.dfm}

{ TFM_BACKUP }

procedure Tfm_backup.BACKUP;
begin
  btnAbort.Visible:=true;
  btnBackup.Visible:=false;
  try
    CreateTmpPath(SYS_tmpPath);
    SaveTable(SYS_tmpPath);
    if AbortFlag then exit;
    DelOldBakFile(20,BakExt);
    if AbortFlag then exit;
    PackTable(SYS_tmpPath);
    showmessage('資料備份完成 '+CR+CR+'備份檔案：'+filename);
  finally
    btnAbort.Visible:=false;;
    btnBackup.Visible:=true;
  end;

end;

procedure Tfm_backup.CreateTmpPath(path: string);
begin
    ForceDirectories(path);
    DeleteAllFile(path+'\*.*');
end;

procedure Tfm_backup.SaveTable(path: string);
var TblList:TStringList;
    i:integer;
    filename:string;
begin
  TblList:=TStringList.Create;
  try
    sysinfo.AdoConnection.GetTableNames(tblList,false);
    BAR1.Step:=1;
    bar1.Min:=0;
    bar1.Max:=tblList.Count;
    for i:=0 to tblList.Count-1 do
    begin
      application.ProcessMessages;
      if AbortFlag then exit;
      filename:=path+'\'+tblList.Strings[i]+'.XML';
      label1.Caption:=format(' %d / %d :%s',[i+1,tblList.Count,tblList.Strings[i]]);
      bar1.StepIt;
      if copy(tblList.Strings[i],1,3)<>'TBL' then continue;
      Table2File(sysinfo.AdoConnection,tblList.Strings[i],filename);
    end;
  finally
    tblList.Free;
  end;
end;

procedure Tfm_backup.PackTable(path: string);
var yy,mm,dd,hh,mi,ss,ms:word;
  CMD:STRING;
begin
  ForceDirectories(sysinfo.SPR_BKUP_PATH);
  decodedatetime(now,yy,mm,dd,hh,mi,ss,ms);
  filename:=sysinfo.SPR_BKUP_PATH+'\'+fixedNum(yy,4,'0')+fixedNum(mm,2,'0')+fixedNum(dd,2,'0')+fixedNum(hh,2,'0')+fixedNum(mi,2,'0')+'.'+BakExt;
  cmd:='WINRAR A '
      + filename
      +' '+SYS_tmpPath+'\*.*';
  ProcessExecute(cmd);



end;

procedure Tfm_backup.DelOldBakFile(days:integer;ext:string);
var yr,mo,da:word;
    strYear,strMon,Strday:string;
    condi,path:string;
    F: TSearchRec;
begin
  decodedate(now-days,yr,mo,da);
  strYear:=FixedNum(yr,4,'0');
  strMon:=FixedNum(mo,2,'0');
  strDay:=FixedNum(da,2,'0');
  condi:=strYear+strMon+strDay;
  path:=sysinfo.SPR_BKUP_PATH+'\*.'+ext;
  if findfirst(path,faAnyFile	,F)=0 then
    repeat
      if f.name<condi then
        deleteFile(sysinfo.SPR_BKUP_PATH+'\'+f.Name);
    until findnext(F)<>0;  
end;


procedure Tfm_backup.btnAbortClick(Sender: TObject);
begin
  AbortFlag:=true;
end;

procedure Tfm_backup.init;
begin
  btnAbort.Visible:=false;;
end;

procedure Tfm_backup.btnBackupClick(Sender: TObject);
begin
  backup;
  ModalResult:=mrOK;
end;

procedure Tfm_backup.FormActivate(Sender: TObject);
begin
    if immediate then begin
      backup;
      PostMessage(self.Handle,WM_CLOSE,0,0);
    end;

end;


procedure SysBackup(sysinfo:TSysinfo;immediate:boolean);
var fm:Tfm_backup;
begin
  fm:=TFm_Backup.Create(Application);
  try
    fm.sysinfo:=sysinfo;
    fm.immediate:=immediate;
    fm.init;
    fm.ShowModal;
  finally
    fm.Free;
  end;

end;

end.

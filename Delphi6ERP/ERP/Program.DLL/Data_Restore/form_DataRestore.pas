unit form_DataRestore;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, ComCtrls,FORM_ERP_BASE,erp_public;

type
  Tfm_dataRestore = class(TForm_ERP)
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    bar1: TProgressBar;
    Button2: TButton;
    Label1: TLabel;
    bar2: TProgressBar;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    AbortFlag:boolean;
    procedure Restore;
    procedure RestoreData(BakFile: string);
    procedure UnPack(BakFile: string);
    procedure ReCreateTable;
    procedure RestoreTable;
    procedure RestoreTbl(tbl: string);
    procedure CreateTmpPath(path: string);
    { Private declarations }
  public
    procedure init;override;
    { Public declarations }
  end;


implementation

uses Uty, DBUty;

{$R *.dfm}

procedure Tfm_dataRestore.Restore;
var m:string;
begin

  with OpenDialog1 do begin
    Title :='備份資料還原';
    Filter:='*.'+BakExt;
    InitialDir :=sysinfo.SPR_BKUP_PATH;
    FileName :='*.'+BakExt;
    IF Execute=false then exit;
    m:=FileName;
    RestoreData(FileName);
//    msg('資料還原完成,系統現在必須結束作業,'#13#13'結束後請重新進入本系統');
//    close;
  end;


end;


procedure Tfm_dataRestore.RestoreData(BakFile: string);
var s,yy,mon,day,hh,mm:string;
    fn:string;
begin
  fn:=ExtractFileName(BakFile);
  if length(fn)<>16 then begin
    ErrMsg('備份檔案格式錯誤 !',user);
    exit;
  end;
  yy:=StrLeft(fn,4);
  mon:=StrMid(fn,5,2);
  day:=StrMid(fn,7,2);
  hh:=StrMid(fn,9,2);
  mm:=StrMid(fn,11,2);
  s:=format('%s年 %s月 %s日 %s時 %s分',[yy,mon,day,hh,mm]);
  s:='您選擇還原的檔案名稱是:'+BakFile+#13#13+'此檔案的備份日期為:'+s;
  s:=s+#13#13+'是否確定執行還原作業 ?';
  if (MessageDlg(s,mtWarning ,[mbYes,MbNo],0)<>mrYes) then exit;
  CreateTmpPath(SYS_TmpPath);
  ReCreateTable;
  UnPack(BakFile);
  RestoreTable;
  MSG('作業完成 !!');
  close;

end;
procedure Tfm_dataRestore.UnPack(BakFile: string);
var cmd:string;
begin
  DeleteAllFile(SYS_TmpPath+'\*.*');
//  Param:='e -y '+ BakFile+ ' '+SYS_TmpPath;
//  cmd:=SPR_BKUP_CMD+' '+Param;
  CMD:='WINRAR E -Y '+ BakFile+ ' '+SYS_TmpPath;
  ProcessExecute(cmd);
end;

procedure Tfm_dataRestore.Button1Click(Sender: TObject);
begin
  restore;
end;


procedure Tfm_dataRestore.ReCreateTable;
var cmd:string;
    path:string;
begin
  path:=ExtractFilePath(application.ExeName);
  ChDir(path);
  cmd:='CR_EmptyTable.BAT';
  ProcessExecute(cmd);
end;

procedure Tfm_dataRestore.RestoreTable;
VAR
    SQL:STRING;
begin
  SQL:='DELETE FROM TBL_SYS_PARAM';
  sysinfo.AdoConnection.Execute(SQL);
  SQL:='DELETE FROM TBL_EMPLOYE';
  sysinfo.AdoConnection.Execute(SQL);
  SQL:='DELETE FROM TBL_INVENTORY';
  sysinfo.AdoConnection.Execute(SQL);
  SQL:='DELETE FROM TBL_ACNT_ACCOUNT';
  sysinfo.AdoConnection.Execute(SQL);
  SQL:='DELETE FROM TBL_ACNT_TYPE';
  sysinfo.AdoConnection.Execute(SQL);
  bar1.Max:=24;
  bar1.Min:=0;
  bar1.Step:=1;

{=============================================================================
  Restore Account Table
===============================================================================}
  RestoreTbl('TBL_ACNT_TYPE');
  if AbortFlag then exit;
  RestoreTbl('TBL_ACNT_ACCOUNT');
  if AbortFlag then exit;
//  RestoreTbl('TBL_ACNT_INIT');
//  if AbortFlag then exit;

  RestoreTbl('TBL_ACNT_JOURNAL');
  if AbortFlag then exit;
  RestoreTbl('TBL_ACNT_JOURNAL_DT');
  if AbortFlag then exit;



{=============================================================================
  Restore Distribution Table
===============================================================================}
  RestoreTbl('TBL_INVENTORY');
  if AbortFlag then exit;
  RestoreTbl('TBL_CUSTOMER');
  if AbortFlag then exit;
  RestoreTbl('TBL_SUPPLIER');
  if AbortFlag then exit;
  RestoreTbl('TBL_PRODUCT');
  if AbortFlag then exit;
  RestoreTbl('TBL_EMPLOYE');
  if AbortFlag then exit;
  RestoreTbl('TBL_CAR');
  if AbortFlag then exit;
  RestoreTbl('TBL_SYS_PARAM');
  if AbortFlag then exit;
  RestoreTbl('TBL_SHIP');
  if AbortFlag then exit;
  RestoreTbl('TBL_SHIP_DT');
  if AbortFlag then exit;
  RestoreTbl('TBL_PO_RECV');
  if AbortFlag then exit;
  RestoreTbl('TBL_PO_RECV_DT');
  if AbortFlag then exit;
  RestoreTbl('TBL_HIS_SHIP');
  if AbortFlag then exit;
  RestoreTbl('TBL_HIS_SHIP_DT');
  if AbortFlag then exit;
  RestoreTbl('TBL_HIS_PO_RECV');
  if AbortFlag then exit;
  RestoreTbl('TBL_HIS_PO_RECV_DT');
  if AbortFlag then exit;
  RestoreTbl('TBL_INV_ADJ');
  if AbortFlag then exit;
  RestoreTbl('TBL_INV_ADJ_DT');
  if AbortFlag then exit;
  RestoreTbl('TBL_AP_PAY');
  if AbortFlag then exit;
  RestoreTbl('TBL_AP_PAY_DT');
  if AbortFlag then exit;
  RestoreTbl('TBL_AR_RECV');
  if AbortFlag then exit;
  RestoreTbl('TBL_AR_RECV_DT');
  if AbortFlag then exit;
  RestoreTbl('TBLSYSREPORT');
  if AbortFlag then exit;
  RestoreTbl('TBLSYSREPORTFIELD');
  if AbortFlag then exit;
  RestoreTbl('TBL_TRANSACTION');
  if AbortFlag then exit;
  RestoreTbl('TBL_INV_ONHAND');
end;

procedure Tfm_dataRestore.Button2Click(Sender: TObject);
begin
  AbortFlag:=true;
end;

procedure Tfm_dataRestore.RestoreTbl(tbl: string);
begin
  bar1.StepIt;
  label1.Caption:=format(' %d / %d :%s',[bar1.Position,bar1.max,tbl]);
  application.ProcessMessages;
  File2Table(sysinfo.AdoConnection,tbl,SYS_TmpPath+'\'+tbl+'.XML',bar2,label2);

end;

procedure Tfm_dataRestore.CreateTmpPath(path: string);
begin
    ForceDirectories(path);
    DeleteAllFile(path+'\*.*');
end;


procedure Tfm_dataRestore.init;
begin
  inherited;

end;

end.

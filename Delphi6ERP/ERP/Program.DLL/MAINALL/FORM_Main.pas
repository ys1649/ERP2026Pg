unit FORM_Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ActnList, ImgList, StdCtrls, ExtCtrls
  , SysReport_Head, jpeg, DB, ADODB,erp_public,FORM_CUSTOMER,Form_supplier,FORM_ERP_BASE,
  Buttons, ToolWin, ComCtrls, ActnMan, ActnCtrls, ActnMenus, RzButton,
  RzPanel, StdActns,FORM_CLIENT;


type
  TFormErpClass = class of TForm_ERP;
  TFM_Main = class(TForm)
    ActionList1: TActionList;
    actCustomer: TAction;
    actSupplier: TAction;
    actProduct: TAction;
    actEmploye: TAction;
    actShip: TAction;
    actPO_Recv: TAction;
    actAR_Recv: TAction;
    actAP_Pay: TAction;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    MnuRep2: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    actAdjust: TAction;
    N19: TMenuItem;
    actData_Backup: TAction;
    N20: TMenuItem;
    N21: TMenuItem;
    actData_Restore: TAction;
    actDataRestore1: TMenuItem;
    actSYS_PARAM: TAction;
    N22: TMenuItem;
    MnuRep1: TMenuItem;
    MnuRep3: TMenuItem;
    N3: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N18: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    actACNT_CHANGE_YEAR: TAction;
    actACNT_ACCOUNT: TAction;
    actACNT_JOURNAL: TAction;
    actACNT_RPT_ASSET: TAction;
    actACNT_RPT_DETAIL: TAction;
    actACNT_RPT_INCOME_STAEMENT: TAction;
    actACNT_RPT_TB: TAction;
    actACNT_RPT_CASH: TAction;
    actACNT_RPT_BALANCE: TAction;
    N16: TMenuItem;
    N17: TMenuItem;
    actACNT_RPT_DAILY: TAction;
    N25: TMenuItem;
    actResetInvTransaction: TAction;
    N26: TMenuItem;
    actCar: TAction;
    N27: TMenuItem;
    RzToolbar1: TRzToolbar;
    ImageList1: TImageList;
    RzToolButton1: TRzToolButton;
    RzToolButton2: TRzToolButton;
    RzToolButton3: TRzToolButton;
    RzToolButton4: TRzToolButton;
    RzToolButton5: TRzToolButton;
    RzToolButton6: TRzToolButton;
    RzToolButton7: TRzToolButton;
    mnuWindows: TMenuItem;
    ActCloseAll: TAction;
    RzSpacer1: TRzSpacer;
    RzToolButton8: TRzToolButton;
    N28: TMenuItem;
    MinimizeAll1: TMenuItem;
    RzToolButton9: TRzToolButton;
    RzToolButton10: TRzToolButton;
    procedure FormDestroy(Sender: TObject);
    procedure actShipExecute(Sender: TObject);
    procedure actPO_RecvExecute(Sender: TObject);
    procedure actAP_PayExecute(Sender: TObject);
    procedure actAR_RecvExecute(Sender: TObject);
    procedure actCustomerExecute(Sender: TObject);
    procedure actProductExecute(Sender: TObject);
    procedure actEmployeExecute(Sender: TObject);
    procedure actAdjustExecute(Sender: TObject);
    procedure actData_BackupExecute(Sender: TObject);
    procedure actData_RestoreExecute(Sender: TObject);
    procedure actSYS_PARAMExecute(Sender: TObject);
    procedure actRep_AR_Recv_DetailExecute(Sender: TObject);
    procedure actRep_AR_Recv_Detail1Execute(Sender: TObject);
    procedure RptMenuClick(Sender: TObject);
    procedure actACNT_CHANGE_YEARExecute(Sender: TObject);
    procedure actACNT_ACCOUNTExecute(Sender: TObject);
    procedure actACNT_JOURNALExecute(Sender: TObject);
    procedure actACNT_RPT_ASSETExecute(Sender: TObject);
    procedure actACNT_RPT_DETAILExecute(Sender: TObject);
    procedure actACNT_RPT_INCOME_STAEMENTExecute(Sender: TObject);
    procedure actACNT_RPT_TBExecute(Sender: TObject);
    procedure actACNT_RPT_CASHExecute(Sender: TObject);
    procedure actACNT_RPT_BALANCEExecute(Sender: TObject);
    procedure actACNT_RPT_DAILYExecute(Sender: TObject);
    procedure actResetInvTransactionExecute(Sender: TObject);
    procedure actCarExecute(Sender: TObject);
    procedure actSupplierExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ActCloseAllExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    ArySysRepCode:array[0..1000] of string;
    arySysRepCode_Cnt:integer;
    FormList:TStringList;
    sysinfo:TSysInfo;

//==================================================
//    SYSTEM REPORT DECLARE BEGIN
//==================================================
//    srinit:TsrInit;
//    srShowSysReportDef:TsrShowSysReportDef;
//    srResApp:TsrResApp;
//    srShowSysReportQuery:TShowSysReportQuery;
//=========== END OF SYSTEM REPORT DECLARE =========

    procedure AddSysReport_ToMenu(MenuItem:TMenuItem;RptCode_Like:string);
    procedure ExecuteFunction(Tfm:TFormErpClass;cmd:integer);
    procedure WMFunctionClose(var msg:TMessage);message WMFuncClose;

  public
    procedure init;
    procedure SetFormCaption;
    { Public declarations }
  end;

var
  FM_Main: TFM_Main;

implementation

uses Form_Login, Uty, form_SysReportQuery, form_ship, form_product,
  Form_PoRecv, form_employee, form_ar_recv, FORM_AP_PAY, Form_Car, form_account,
  Form_Journal, form_InvAdjust, Form_backup, form_DataRestore,
  Form_SysParam, Form_AcntChgYear, Form_Acnt_Asset, Form_AcntBalance,
  Form_AcntCash, Form_AcntDaily, Form_AcntIncomeStament,
  Form_AcntTrialBalance, Form_AcntDetail, Form_ResetInvTran, DBUty;
{$R *.DFM}

procedure TFM_Main.FormDestroy(Sender: TObject);
begin
  FormList.Free;
end;

procedure TFM_Main.actShipExecute(Sender: TObject);
begin
  ExecuteFunction(TFM_SHIP,0);
end;

procedure TFM_Main.actPO_RecvExecute(Sender: TObject);
begin
  ExecuteFunction(Tfm_PoRecv,0);

end;

procedure TFM_Main.actAP_PayExecute(Sender: TObject);
begin
  ExecuteFunction(TFM_AP_PAY,0);

end;

procedure TFM_Main.actAR_RecvExecute(Sender: TObject);
begin
  ExecuteFunction(Tfm_ar_recv,0);
end;

procedure TFM_Main.actProductExecute(Sender: TObject);
begin
  ExecuteFunction(TFM_PRODUCT,0);

end;

procedure TFM_Main.actEmployeExecute(Sender: TObject);
begin
  ExecuteFunction(Tfm_employee,0);
end;

procedure TFM_Main.actAdjustExecute(Sender: TObject);
begin
  ExecuteFunction(TFm_invAdjust,0);
end;

procedure TFM_Main.actData_BackupExecute(Sender: TObject);
begin
  SysBackup(sysinfo,FALSE);
end;

procedure TFM_Main.actData_RestoreExecute(Sender: TObject);
var m:string;
begin
  m:='還原備份資料之前, 強烈建議您先執行備份作業 !!'#13#13'是否先執行備份作業 ?';
  if (MessageDlg(m,mtWarning ,[mbYes,MbNo],0)=mrYes) then BEGIN
    SysBackup(sysinfo,true);
  END;

  ExecuteFunction(Tfm_dataRestore,0);

end;

procedure TFM_Main.actSYS_PARAMExecute(Sender: TObject);
begin
  ExecuteFunction(Tfm_SysParam,0);
end;

procedure TFM_Main.actRep_AR_Recv_DetailExecute(Sender: TObject);
begin
  ShowSysReportQuery(sysinfo.AdoConnection,'AR_001',dbsType);

end;

procedure TFM_Main.actRep_AR_Recv_Detail1Execute(Sender: TObject);
begin
  ShowSysReportQuery(sysinfo.AdoConnection,'AR_002',dbsType);
end;

procedure TFM_Main.AddSysReport_ToMenu(MenuItem: TMenuItem;
  RptCode_Like: string);
var
    qry:TAdoQuery;
    mnu:TMenuItem;
begin
  qry:=TAdoQuery.Create(self);
  try
    QRY.Connection:=sysinfo.AdoConnection;
    qry.SQL.Text:='SELECT SRP_CODE,SRP_NAME FROM TBLSYSREPORT'
                 +' WHERE SRP_CODE LIKE'+sqlstr(RptCode_Like)
                 +' ORDER BY SRP_CODE';
    qry.Open;
    while not qry.Eof do
    begin
      ArySysRepCode[arySysRepCode_Cnt]:=qry.Fields[0].AsString;
      mnu:=TMenuItem.Create(self);
      MNU.Caption:=QRY.Fields[1].AsString;
      mnu.Tag:=arySysRepCode_Cnt;
      mnu.OnClick:=RptMenuClick;
      MenuItem.Add(mnu);
      inc(arySysRepCode_Cnt);
      qry.Next;
    end;

  finally
    qry.close;
    qry.Free;
  end;


end;


procedure TFM_Main.RptMenuClick(Sender: TObject);
var i:integer;
    rptCode:string;
    mnu:TMenuItem;
begin
  mnu:=sender as TMenuItem;
  i:=mnu.Tag;
  rptCode:=ArySysRepCode[i];
  ShowSysReportQuery(sysinfo.AdoConnection,rptCode,dbsType);
end;


procedure TFM_Main.actACNT_CHANGE_YEARExecute(Sender: TObject);
begin
  ExecuteFunction(Tfm_AcntChgYear,0);
end;

procedure TFM_Main.actACNT_ACCOUNTExecute(Sender: TObject);
begin
  ExecuteFunction(TFM_Account,0);
end;

procedure TFM_Main.actACNT_JOURNALExecute(Sender: TObject);
begin
  ExecuteFunction(TFM_Journal,0);

end;

procedure TFM_Main.actACNT_RPT_ASSETExecute(Sender: TObject);
begin
  ExecuteFunction(TFm_Acnt_Asset,0);
end;

procedure TFM_Main.actACNT_RPT_DETAILExecute(Sender: TObject);
begin
  ExecuteFunction(TFm_AcntDetail,1);

end;

procedure TFM_Main.actACNT_RPT_INCOME_STAEMENTExecute(Sender: TObject);
begin
  ExecuteFunction(TFm_AcntIncomeStament,0);
end;

procedure TFM_Main.actACNT_RPT_TBExecute(Sender: TObject);
begin
  ExecuteFunction(TFm_AcntTrialBalance,0);
end;

procedure TFM_Main.actACNT_RPT_CASHExecute(Sender: TObject);
begin
  ExecuteFunction(TFm_AcntCash,0);
end;

procedure TFM_Main.actACNT_RPT_BALANCEExecute(Sender: TObject);
begin
  ExecuteFunction(TFm_AcntBalance,0);
end;

procedure TFM_Main.actACNT_RPT_DAILYExecute(Sender: TObject);
begin
  ExecuteFunction(TFm_AcntDaily,0);

end;

procedure TFM_Main.actResetInvTransactionExecute(Sender: TObject);
begin
  ExecuteFunction(TFm_ResetInvTran,0);
end;

procedure TFM_Main.actCarExecute(Sender: TObject);
begin
  ExecuteFunction(TFM_CAR,0);
end;


procedure TFM_Main.actCustomerExecute(Sender: TObject);
begin
  ExecuteFunction(TFM_Customer,0);
end;


procedure TFM_Main.actSupplierExecute(Sender: TObject);
begin
  ExecuteFunction(TFM_SUPPLIER,0);
end;


procedure TFM_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var i:integer;
    fm:TForm_ERP;
    id:string;
begin
  CanClose:=True;
  for i:= 0 to FormList.Count-1 do begin
    id:=FormList.Strings[i];
    if id = 'null' then continue;
    fm:=FormList.Objects[i] as TForm_ERP;
    if not fm.CloseQuery then begin
      CanClose:=false;
      exit;
    end;
  end;

end;


{================================================================
  執行繼承自 TForm_ERP 的類別功能
  cmd =1 :獨占的執行模式，執行完畢，立即釋放。
          此模式，類別功能必須自行於fm.init 內呼叫 Form.ShowModal

  cmd =0 :允需背景執行。
================================================================}
procedure TFM_Main.ExecuteFunction(Tfm: TFormErpClass;cmd:integer);
var fm:TForm_ERP;
    id:string;
    n:integer;
begin
  if cmd=1 then begin
    fm:=tfm.Create(self);
    try
      fm.sysinfo:=sysinfo;
      fm.init;
    finally
      fm.Free;
    end;
    exit;
  end;

  id:=tfm.ClassName;
  n:=FormList.IndexOf(id);
  if n = -1 then begin
    fm:=tfm.Create(self);
    fm.sysinfo:=sysinfo;
    fm.init;
    FormList.AddObject(id,fm);
  end else begin;
    fm:=FormList.Objects[n] as TFM;
  end;
  fm.Top:=(ClientHeight-(RzToolbar1.Height+fm.Height+10)) div 2;
  fm.Left:=(ClientWidth-fm.Width) div 2;
  fm.WindowState:=wsNormal;
  fm.Show;
end;

procedure TFM_Main.ActCloseAllExecute(Sender: TObject);
var i:integer;
    fm:TForm_ERP;
    id:string;
    EmptyFlag:boolean;
begin
  EmptyFlag:=true;
  for i:= 0 to FormList.Count-1 do begin
    id:=FormList.Strings[i];
    if id = 'null' then continue;
    fm:=FormList.Objects[i] as TForm_ERP;
    if fm.CloseQuery then begin
      FormList.Strings[i]:='null';
      fm.Close;
      fm.Free;
    end else begin
      EmptyFlag:=false;
    end;
  end;
  if EmptyFlag then begin
    FormList.Clear;
  end;
end;

procedure TFM_Main.WMFunctionClose(var msg: TMessage);
var n:integer;
begin
  n:=msg.WParam;
  FormList.Strings[n]:='null';
end;

procedure TFM_Main.init;
begin
  FormList:=TStringList.Create;
  ReadSysParam(sysinfo);
  SetFormCaption;
{======================================================================
  show login form
======================================================================}
  Application.Title:=sysinfo.SPR_COR_NAME;
  arySysRepCode_Cnt:=0;
  AddSysReport_ToMenu(MnuRep1,'FM%');
  AddSysReport_ToMenu(MnuRep2,'MG%');
  AddSysReport_ToMenu(MnuRep3,'ST%');


end;

procedure TFM_Main.FormCreate(Sender: TObject);
begin
{======================================================================
  Get AdoConnectionString
======================================================================}
  ShortDateFormat:='yyyy/mm/dd';
  LongTimeFormat := 'hh:mm:ss';
  sysinfo:=TSysinfo.Create;

  sysinfo.AdoConnection:=TADOConnection.Create(self);
  sysinfo.AdoConnection.LoginPrompt:=false;
  GetAdoConnectionString(sysinfo.AdoConnection,'ERP.INI');
  try
    sysinfo.AdoConnection.Connected:=TRUE;
    SysLogin(fm_Main.sysinfo);
    fm_main.init;
  except
    on E :Exception do begin
      MessageDlg(e.Message,mtError ,[mbOK]	,0);
      Application.Terminate;
    end;
  end;

end;

procedure TFM_Main.FormResize(Sender: TObject);
begin
{  if assigned(fm_client) then begin
    fm_client.Perform(WMMainWindowResize,0,0);
  end;}
end;

procedure TFM_Main.SetFormCaption;
begin
  SELF.Caption:='ERP 配銷管理模組 --> '+sysinfo.SPR_cor_name+' 會計年度:'+inttostr(sysinfo.SPR_ACNT_YEAR);
end;

end.


unit FORM_Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ActnList, ImgList, StdCtrls, ExtCtrls
  , SysReport_Head, jpeg, DB, ADODB,erp_public,FORM_ERP_BASE;

type
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
    N12: TMenuItem;
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
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actShipExecute(Sender: TObject);
    procedure actPO_RecvExecute(Sender: TObject);
    procedure actAP_PayExecute(Sender: TObject);
    procedure actAR_RecvExecute(Sender: TObject);
    procedure actCustomerExecute(Sender: TObject);
    procedure actSupplierExecute(Sender: TObject);
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
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actCarExecute(Sender: TObject);
  private
    user,pass:string;
    ArySysRepCode:array[0..1000] of string;
    arySysRepCode_Cnt:integer;
    DllObjList:TStringList;
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
    procedure ExecuteFunction(DllFile:string);
  public
    { Public declarations }
  end;

var
  FM_Main: TFM_Main;

implementation

uses Form_Login, Uty, form_SysReportQuery,
  DLL_Function, DBUty;

{$R *.DFM}

procedure TFM_Main.FormCreate(Sender: TObject);
var fm:TFm_Login;
    s:string;
begin

{======================================================================
  set AdoConnectionString
======================================================================}

  sysinfo:=TSysinfo.Create;
  ShortDateFormat:='yyyy/mm/dd';
  LongTimeFormat := 'hh:mm:ss';
  sysinfo.AdoConnection:=TADOConnection.Create(self);
  sysinfo.AdoConnection.LoginPrompt:=false;
  GetAdoConnectionString(sysinfo.AdoConnection,'ERP.INI');
  sysinfo.AdoConnection.Connected:=TRUE;


{======================================================================
  show login form
======================================================================}
  fm:=TFm_Login.Create(application);
  fm.sysinfo:=sysinfo;
  try
    if fm.ShowModal=mrCancel then APPLICATION.Terminate;
    user:=fm.EditUser.Text;
    pass:=fm.EditPassword.Text;
  finally
    fm.Free;
  end;

  
  DllObjList:=TStringList.Create;
  ReadSysParam(sysinfo);

{======================================================================
  show login form
======================================================================}
  s:='會計年度:'+inttostr(sysinfo.SPR_ACNT_YEAR);
  SELF.Caption:=caption+' --> '+sysinfo.SPR_cor_name+'  ('+s+')';
  arySysRepCode_Cnt:=0;
  AddSysReport_ToMenu(MnuRep1,'FM%');
  AddSysReport_ToMenu(MnuRep2,'MG%');
  AddSysReport_ToMenu(MnuRep3,'ST%');

  G_str:='Test G_str';
  G_int:=2004;


end;

procedure TFM_Main.FormDestroy(Sender: TObject);
var i:integer;
  DllObj:TDllFuncObject;
begin
  for i:=0 to DllObjList.Count-1 do begin
    DllObj:=DllObjList.Objects[i] as TDllFuncObject;
    DllObj.srRestoreDllApp;
  end;
  DllObjList.Destroy;
end;

procedure TFM_Main.actShipExecute(Sender: TObject);
begin
  ExecuteFunction('SHIP.DLL');
end;

procedure TFM_Main.actPO_RecvExecute(Sender: TObject);
begin
  ExecuteFunction('PO_RECV.DLL');
end;

procedure TFM_Main.actAP_PayExecute(Sender: TObject);
begin
  ExecuteFunction('AP_PAY.DLL');

end;

procedure TFM_Main.actAR_RecvExecute(Sender: TObject);
begin
  ExecuteFunction('AR_RECV.DLL');
end;

procedure TFM_Main.actCustomerExecute(Sender: TObject);
begin
  ExecuteFunction('CUSTOMER.DLL');
end;

procedure TFM_Main.actSupplierExecute(Sender: TObject);
begin
  ExecuteFunction('SUPPLIER.DLL');
end;

procedure TFM_Main.actProductExecute(Sender: TObject);
begin
  ExecuteFunction('PRODUCT.DLL');

end;

procedure TFM_Main.actEmployeExecute(Sender: TObject);
begin
  ExecuteFunction('EMPLOYEE.DLL');
end;

procedure TFM_Main.actAdjustExecute(Sender: TObject);
begin
  ExecuteFunction('INV_ADJUST.DLL');
end;

procedure TFM_Main.actData_BackupExecute(Sender: TObject);
begin
  ExecuteFunction('Data_Backup.DLL');
end;

procedure TFM_Main.actData_RestoreExecute(Sender: TObject);
var m:string;
begin
  m:='還原備份資料之前, 強烈建議您先執行備份作業 !!'#13#13'是否先執行備份作業 ?';
  if (MessageDlg(m,mtWarning ,[mbYes,MbNo],0)=mrYes) then
    actData_BackupExecute(nil);

  ExecuteFunction('Data_Restore.DLL');

end;

procedure TFM_Main.actSYS_PARAMExecute(Sender: TObject);
begin
  ExecuteFunction('SYS_PARAM.DLL');
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
  ExecuteFunction('ACNT_CHANGE_YEAR.DLL');

end;

procedure TFM_Main.actACNT_ACCOUNTExecute(Sender: TObject);
var DllObj:TDllFuncObject;
    DllFile:string;
    idx:integer;
begin
  DllFile:='ACNT_ACCOUNT.DLL';
  idx:=DllObjList.IndexOf(DllFile);
  if idx= -1 then begin
    DllObj:=TDllFuncObject.Create(DllFile,sysinfo);
    DllObjList.AddObject(DllFile,DllObj);
  end else begin;
    DllObj:=DllObjList.Objects[idx] as TDllFuncObject;
  end;
  DllObj.fm_main.Show;
end;

procedure TFM_Main.actACNT_JOURNALExecute(Sender: TObject);
begin
  ExecuteFunction('ACNT_JOURNAL.DLL');
end;

procedure TFM_Main.actACNT_RPT_ASSETExecute(Sender: TObject);
begin
  ExecuteFunction('ACNT_RPT_ASSET.DLL');
end;

procedure TFM_Main.actACNT_RPT_DETAILExecute(Sender: TObject);
begin
  ExecuteFunction('ACNT_RPT_DETAIL.dll');

end;

procedure TFM_Main.actACNT_RPT_INCOME_STAEMENTExecute(Sender: TObject);
begin
  ProcessExecute('ACNT_RPT_INCOME_STATEMENT.FUN '+USER+' '+pass,1,1);

end;

procedure TFM_Main.actACNT_RPT_TBExecute(Sender: TObject);
begin
  ProcessExecute('ACNT_RPT_TB.FUN '+USER+' '+pass,1,1);

end;

procedure TFM_Main.actACNT_RPT_CASHExecute(Sender: TObject);
begin
  ExecuteFunction('ACNT_RPT_CASH.DLL');
end;

procedure TFM_Main.actACNT_RPT_BALANCEExecute(Sender: TObject);
begin
  ExecuteFunction('ACNT_RPT_BALANCE.DLL');
end;

procedure TFM_Main.actACNT_RPT_DAILYExecute(Sender: TObject);
begin
  ProcessExecute('ACNT_RPT_DAILY.FUN '+USER+' '+pass,1,1);

end;

procedure TFM_Main.actResetInvTransactionExecute(Sender: TObject);
begin
  ProcessExecute('ResetInvTransaction.FUN '+USER+' '+pass,1,1);

end;

procedure TFM_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var i:integer;
    DllObj:TDllFuncObject;
begin

  CanClose:=True;
  for i:= 0 to DllObjList.Count-1 do begin
    DllObj:=DllObjList.Objects[i] as TDllFuncObject;
    if not DllObj.fm_main.CloseQuery then begin
      CanClose:=false;
      exit;
    end;
  end;
end;

procedure TFM_Main.ExecuteFunction(DllFile: string);
var DllObj:TDllFuncObject;
    idx:integer;
begin



  idx:=DllObjList.IndexOf(DllFile);
  if idx= -1 then begin
    DllObj:=TDllFuncObject.Create(DllFile,sysinfo);
    DllObjList.AddObject(DllFile,DllObj);
  end else begin;
    DllObj:=DllObjList.Objects[idx] as TDllFuncObject;
  end;
  DllObj.fm_main.Show;

end;

procedure TFM_Main.actCarExecute(Sender: TObject);
begin
  ExecuteFunction('CAR.DLL');

end;

end.


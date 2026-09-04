unit Form_Main1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, ToolWin, ImgList, Menus, ActnList, RzPanel,
  RzButton,erp_public,adodb;

type
  Tfm_Main1 = class(TForm)
    Image1: TImage;
    RzToolbar1: TRzToolbar;
    RzToolButton1: TRzToolButton;
    RzToolButton2: TRzToolButton;
    RzToolButton3: TRzToolButton;
    RzToolButton4: TRzToolButton;
    RzToolButton5: TRzToolButton;
    RzToolButton6: TRzToolButton;
    RzToolButton7: TRzToolButton;
    RzSpacer1: TRzSpacer;
    RzToolButton8: TRzToolButton;
    RzToolButton9: TRzToolButton;
    ActionList1: TActionList;
    actCustomer: TAction;
    actSupplier: TAction;
    actProduct: TAction;
    actEmploye: TAction;
    actCar: TAction;
    actACNT_ACCOUNT: TAction;
    actShip: TAction;
    actPO_Recv: TAction;
    actAP_Pay: TAction;
    actAR_Recv: TAction;
    actData_Backup: TAction;
    actAdjust: TAction;
    actData_Restore: TAction;
    actSYS_PARAM: TAction;
    actACNT_CHANGE_YEAR: TAction;
    actACNT_JOURNAL: TAction;
    actACNT_RPT_ASSET: TAction;
    actACNT_RPT_DETAIL: TAction;
    actACNT_RPT_INCOME_STAEMENT: TAction;
    actACNT_RPT_TB: TAction;
    actACNT_RPT_CASH: TAction;
    actACNT_RPT_BALANCE: TAction;
    actACNT_RPT_DAILY: TAction;
    actResetInvTransaction: TAction;
    ActCloseAll: TAction;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N2: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N19: TMenuItem;
    MnuRep1: TMenuItem;
    MnuRep2: TMenuItem;
    MnuRep3: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    actDataRestore1: TMenuItem;
    N22: TMenuItem;
    N26: TMenuItem;
    N24: TMenuItem;
    N3: TMenuItem;
    N13: TMenuItem;
    N25: TMenuItem;
    N18: TMenuItem;
    N23: TMenuItem;
    N15: TMenuItem;
    N14: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    mnuWindows: TMenuItem;
    MinimizeAll1: TMenuItem;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
  private
    ArySysRepCode:array[0..1000] of string;
    arySysRepCode_Cnt:integer;
    FormList:TStringList;
    sysinfo:TSysInfo;
    procedure AddSysReport_ToMenu(MenuItem: TMenuItem;
      RptCode_Like: string);
    procedure RptMenuClick(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fm_Main1: Tfm_Main1;

implementation

uses Form_Login, Uty, form_SysReportQuery;

{$R *.dfm}

procedure Tfm_Main1.FormCreate(Sender: TObject);
var fm:TFm_Login;
    s:string;
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
  sysinfo.AdoConnection.Connected:=TRUE;
  sysinfo.SYS_AbortFlag:=false;


{======================================================================
  show login form
======================================================================}

  fm:=TFm_Login.Create(application);
  fm.sysinfo:=sysinfo;
  try
    if fm.ShowModal=mrCancel then APPLICATION.Terminate;
    sysinfo.LoginUserID:=fm.EditUser.Text;
  finally
    fm.Free;
  end;



  FormList:=TStringList.Create;
  ReadSysParam(sysinfo);

{======================================================================
  show login form
======================================================================}
  s:='會計年度:'+inttostr(sysinfo.SPR_ACNT_YEAR);
  SELF.Caption:=caption+' --> '+sysinfo.SPR_cor_name+'  ('+s+')';
  Application.Title:=sysinfo.SPR_COR_NAME;
  arySysRepCode_Cnt:=0;

  AddSysReport_ToMenu(MnuRep1,'FM%');
  AddSysReport_ToMenu(MnuRep2,'MG%');
  AddSysReport_ToMenu(MnuRep3,'ST%');

end;

procedure TFM_Main1.RptMenuClick(Sender: TObject);
var i:integer;
    rptCode:string;
    mnu:TMenuItem;
begin
  mnu:=sender as TMenuItem;
  i:=mnu.Tag;
  rptCode:=ArySysRepCode[i];
  ShowSysReportQuery(sysinfo.AdoConnection,rptCode,dbsType);
end;

procedure TFM_Main1.AddSysReport_ToMenu(MenuItem: TMenuItem;
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


end.

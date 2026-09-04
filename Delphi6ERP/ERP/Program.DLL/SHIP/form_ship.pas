unit form_ship;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, ComCtrls, ExtCtrls, Mask, Buttons, ActnList,
  ImgList, dxCntner, dxEditor, dxEdLib, dxDBELib, DBCtrls, dxExEdtr,
  DBClient, Provider, dxDBTLCl, dxGrClms, dxTL, dxDBCtrl, dxDBGrid,
  wwSpeedButton, wwDBNavigator, wwclearpanel, wwdbdatetimepicker, Grids,
  DBGrids, wwdblook, dxDBEdtr, Form_Query, Menus, DateUtils,uty,erp_public,
  FORM_ERP_BASE;

type
  Tfm_ship = class(TFORM_ERP)
    pnlMast1: TPanel;
    pnlStatus: TPanel;
    pnlMast2: TPanel;
    ActionList1: TActionList;
    ActAppend: TAction;
    ActEdit: TAction;
    ActDelete: TAction;
    ActQuery: TAction;
    ActPrint: TAction;
    ActBrowse: TAction;
    ActBook: TAction;
    ActUnBook: TAction;
    ActFirst: TAction;
    ActLast: TAction;
    ActPrior: TAction;
    ActNext: TAction;
    ActSave: TAction;
    ActAbort: TAction;
    ds_Master: TDataSource;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Edit_Smt_No: TdxDBEdit;
    Edit_SMT_INV_NO: TdxDBEdit;
    Edit_Smt_Destination: TdxDBEdit;
    Label1: TLabel;
    Label8: TLabel;
    Label7: TLabel;
    Label11: TLabel;
    Label15: TLabel;
    Edit_Amount: TdxDBEdit;
    Edit_SMT_Total: TdxDBEdit;
    memo_SMT_Desc: TdxDBMemo;
    Client_dt: TClientDataSet;
    Client_dtSMD_PRD_NAME: TStringField;
    Client_dtSMD_UNIT_PRICE: TBCDField;
    Client_dtSMD_COST: TBCDField;
    Client_dtC_SUB_TOTAL: TBCDField;
    Client_dtC_SEQNO: TIntegerField;
    ImageList1: TImageList;
    Client_dtSMT_NO: TStringField;
    Client_dtPRD_NO: TStringField;
    Client_dtINV_NO: TStringField;
    Edit_Cum_NO: TdxDBButtonEdit;
    ds_Client_dt: TDataSource;
    Edit_Epy_NO: TdxDBButtonEdit;
    Edit_Cum_Name: TdxDBButtonEdit;
    PnlDetail2: TPanel;
    grid: TdxDBGrid;
    gridC_SEQNO: TdxDBGridColumn;
    gridPRD_NO: TdxDBGridButtonColumn;
    gridSMD_PRD_NAME: TdxDBGridMaskColumn;
    gridSMD_QTY: TdxDBGridMaskColumn;
    gridSMD_UNIT_PRICE: TdxDBGridMaskColumn;
    gridC_SUB_TOTAL: TdxDBGridColumn;
    NavDetail: TDBNavigator;
    pnlCtrl: TPanel;
    BtnAppend: TButton;
    BtnEdit: TButton;
    BtnDelete: TButton;
    BtnQuery: TButton;
    BtnPrint: TButton;
    BtnConfirm: TButton;
    BtnUnConfirm: TButton;
    BtnSave: TButton;
    BtnAbort: TButton;
    Client_Mast: TClientDataSet;
    Client_MastCUM_NO: TStringField;
    Client_MastSMT_NO: TStringField;
    Client_MastSMT_INV_NO: TStringField;
    Client_MastSMT_DATE: TDateTimeField;
    Client_MastSMT_DESTINATION: TStringField;
    Client_MastSMT_TAX: TBCDField;
    Client_MastSMT_NOT_CLEAN: TBCDField;
    Client_MastSMT_COST: TBCDField;
    Client_MastSMT_DESC: TStringField;
    Client_MastSMT_CREATOR: TStringField;
    Client_MastSMT_STATUS: TBCDField;
    Client_MastSMT_TOTAL: TBCDField;
    Client_MastEPY_NO: TStringField;
    Client_MastC_Amount: TCurrencyField;
    ActRefresh: TAction;
    ActHistory: TAction;
    Client_MastC_CUM_NAME: TStringField;
    Client_MastC_EPY_NAME: TStringField;
    Edit_EPY_NAME: TDBEdit;
    Edit_SMT_Tax: TdxDBButtonEdit;
    Client_DTSMD_SEQNO: TBCDField;
    LblCost: TDBText;
    Panel1: TPanel;
    btnPrior: TSpeedButton;
    btnNext: TSpeedButton;
    BtnLast: TSpeedButton;
    btnFirst: TSpeedButton;
    Edit_Rec: TEdit;
    Panel2: TPanel;
    Label3: TLabel;
    Edit_Smt_Not_Clean: TDBEdit;
    Panel3: TPanel;
    LblStatus: TLabel;
    MenuFunc: TPopupMenu;
    B1: TMenuItem;
    H1: TMenuItem;
    R1: TMenuItem;
    BtnFunc: TButton;
    ActFunction: TAction;
    ActQuickCollect: TAction;
    ActCollectHist: TAction;
    N1: TMenuItem;
    N2: TMenuItem;
    Client_dtC_PRD_ONHAND: TFloatField;
    gridC_PRD_ONHAND: TdxDBGridColumn;
    Client_dtSMD_QTY: TBCDField;
    Client_dtC_PRD_UNIT: TStringField;
    gridC_PRD_UNIT: TdxDBGridColumn;
    qry_mast: TADOQuery;
    Provider_mast: TDataSetProvider;
    Client_MastJNL_NO: TStringField;
    Client_MastSMT_DELIVER1: TStringField;
    Client_MastSMT_DELIVER2: TStringField;
    Label9: TLabel;
    dxDBButtonEdit1: TdxDBButtonEdit;
    Label10: TLabel;
    dxDBButtonEdit2: TdxDBButtonEdit;
    Client_MastC_DELIVER1_NAME: TStringField;
    Client_MastC_DELIVER2_NAME: TStringField;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    Label12: TLabel;
    dxDBButtonEdit3: TdxDBButtonEdit;
    Client_MastCAR_NO: TStringField;
    Client_MastC_CAR_LICENSE: TStringField;
    DBEdit3: TDBEdit;
    wwDBDateTimePicker1: TwwDBDateTimePicker;
    procedure Client_MastCalcFields(DataSet: TDataSet);
    procedure Client_MastAfterScroll(DataSet: TDataSet);
    procedure Client_dtCalcFields(DataSet: TDataSet);
    procedure Client_dtSMD_PRD_NAMEGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure ActFirstExecute(Sender: TObject);
    procedure ActLastExecute(Sender: TObject);
    procedure ActPriorExecute(Sender: TObject);
    procedure ActNextExecute(Sender: TObject);
    procedure ActEditExecute(Sender: TObject);
    procedure ActAbortExecute(Sender: TObject);
    procedure ActAppendExecute(Sender: TObject);
    procedure Edit_Cum_NOButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure Edit_Epy_NOButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure Edit_Cum_NameButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure gridPRD_NOButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure Client_dtPRD_NOValidate(Sender: TField);
    procedure gridExit(Sender: TObject);
    procedure ActRefreshExecute(Sender: TObject);
    procedure Client_MastCUM_NOValidate(Sender: TField);
    procedure ActSaveExecute(Sender: TObject);
    procedure Client_dtSMD_PRD_NAMESetText(Sender: TField;
      const Text: String);
    procedure Edit_SMT_TaxButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure Client_dtBeforePost(DataSet: TDataSet);
    procedure ActQueryExecute(Sender: TObject);
    procedure Edit_SMT_TaxDblClick(Sender: TObject);
    procedure ActBrowseExecute(Sender: TObject);
    procedure ActDeleteExecute(Sender: TObject);
    procedure ActBookExecute(Sender: TObject);
    procedure ActUnBookExecute(Sender: TObject);
    procedure ActHistoryExecute(Sender: TObject);
    procedure Client_MastSMT_NOT_CLEANGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure Client_MastSMT_DATEValidate(Sender: TField);
    procedure gridCustomDraw(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxDBTreeListColumn;
      const AText: String; AFont: TFont; var AColor: TColor; ASelected,
      AFocused: Boolean; var ADone: Boolean);
    procedure ActFunctionExecute(Sender: TObject);
    procedure ActQuickCollectExecute(Sender: TObject);
    procedure Client_dtPRD_NOGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure ActPrintExecute(Sender: TObject);
    procedure dxDBButtonEdit1ButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure dxDBButtonEdit2ButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure dxDBButtonEdit3ButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    Sysdate:TDateTime;
    ERRFLAG:BOOLEAN;
    ModiFlag:boolean;
    Fm_Qry:TFM_Query;
    SQlWhere,SQLOrder:string;
    procedure hint(msg:string);
    procedure SetEditMode(EditFlag:Boolean);
    procedure AddProd(Prd_no:string);
    procedure chkDetail;
    procedure SaveMaster;
    procedure SaveDetail;
//    procedure SaveHisDetail;
//    procedure SaveHisMaster;
    procedure UpdateMaster;
    procedure InsertInv_Transaction;
    procedure ShowTotal;
    procedure DeleteDetail(SMT_NO: STRING);
    procedure SetupQueryForm;
    procedure RefreshData;
    function GetNotClean(SMT_NO:string):currency;
    procedure DeleteMaster(SMT_NO: STRING);
    procedure DeleteInv_Transaction(smt_no: string);
    function Chk_AR_Received(SMT_NO: string): boolean;
    PROCEDURE InsertAccount;
    function ChkStatusModified(rcv_no: string; old_st: integer): integer;
  public
    PROCEDURE Init;override;
    { Public declarations }
  end;

implementation

uses SysReport_Head,
  form_QuickCollect, form_SysReportQuery, form_ship_Browse,
  FORM_ship_HISTORY, form_ship_Print, DBUty;

{$R *.dfm}

{ TForm1 }

procedure Tfm_ship.Init;
//var t1:tdatetime;
begin

  SELF.Caption:=caption+' --> '+sysinfo.SPR_cor_name;  
  Sysdate:=now;
  BtnUnConfirm.Top:=BtnConfirm.Top;
  BtnUnConfirm.left:=BtnConfirm.left;
  SetEditMode(false);
  SetupQueryForm;
  SqlWhere:='M.SMT_DATE>='+SqlDateTimeSql(trunc(now)-30);
  SqlOrder:='M.SMT_DATE,M.SMT_NO';
  RefreshData;

end;

procedure Tfm_ship.Client_MastCalcFields(DataSet: TDataSet);
begin
  Client_MastC_Amount.Value:=Client_MastSMT_TOTAL.Value+Client_MastSmt_Tax.Value;
  client_mastC_Cum_Name.Value:=GetCumName(sysinfo,client_mastCum_no.Value);
  client_mastC_Epy_Name.Value:=GetEpyName(sysinfo,client_MastEPY_NO.Value);
  client_mastC_DELIVER1_NAME.Value:=GetEpyName(sysinfo,Client_MastSMT_DELIVER1.Value);
  client_mastC_DELIVER2_NAME.Value:=GetEpyName(sysinfo,Client_MastSMT_DELIVER2.Value);
  client_mastC_CAR_LICENSE.Value:=GetCARName(sysinfo,Client_MastCAR_NO.Value);

end;

procedure Tfm_ship.Client_MastAfterScroll(DataSet: TDataSet);
var sql:string;
  IsUnBook:boolean;
begin
  if Client_Mast.State<>dsBrowse then exit;
  
  sql:='SELECT * FROM TBL_SHIP_DT WHERE SMT_NO='+SqlStr(Client_MastSmt_NO.AsString);
  DoQrySelect(sql,sysinfo.AdoConnection,Client_DT);
  isUnBook:=(Client_mastSMT_Status.Value=Status_UnBook);
  ActBook.Enabled:=IsUnbook;
  ActUnBook.Enabled:=not IsUnbook;
  ActEdit.Enabled:=IsUnbook;
  ActQuickCollect.Enabled:=not IsUnbook;
  ActDelete.Enabled:=IsUnbook;
  BtnConfirm.Visible:=isUnBook;
  BtnUnConfirm.Visible:=not isUnBook;

  if IsUnBook then
  begin
    Panel2.Color:=$0095FFFF;
    Edit_Smt_Not_Clean.Color:=Panel2.Color;
//    SetOwnerCtrlColor(self,$00A00000,clSilver);
  end else
  begin
    Panel2.Color:=clBtnFace;
    Edit_Smt_Not_Clean.Color:=Panel2.Color;
//     SetOwnerCtrlColor(self,ColrEditDisableFore,ColrEditDisableBack);
  end;


  Edit_rec.Text:=format ('%d / %d',[Client_Mast.recno,Client_Mast.recordCount]);
  if Client_mast.Eof then
  begin
    ActNext.Enabled:=false;
    ActLast.Enabled:=false;
  end else
  begin
    ActNext.Enabled:=true;
    ActLast.Enabled:=true;

  end;
  if Client_mast.bof then
  begin
    ActPrior.Enabled:=false;
    ActFirst.Enabled:=false;
  end else
  begin
    ActPrior.Enabled:=True;
    ActFirst.Enabled:=True;
  end;
end;

procedure Tfm_ship.Client_dtCalcFields(DataSet: TDataSet);
begin
  client_dtC_SUB_TOTAL.Value:=client_dtSMD_QTY.Value*client_dtSMD_UNIT_PRICE.Value;
  client_dtC_SEQNO.Value:=client_dt.RecNo;
  Client_dtC_PRD_ONHAND.Value:=vartoCURR(TblLookup(sysinfo.AdoConnection,'TBL_PRODUCT','PRD_NO',Client_dtPRD_NO.AsString,'PRD_ONHAND'));
  Client_dtC_PRD_UNIT.Value:=vartostr(TblLookup(sysinfo.AdoConnection,'TBL_PRODUCT','PRD_NO',Client_dtPRD_NO.AsString,'PRD_UNIT'));
end;

procedure Tfm_ship.Client_dtSMD_PRD_NAMEGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
VAR prdname:variant;
begin
  if client_dtSMD_PRD_NAME.Value='' then
  BEGIN
    prdName:=GetPrdName(sysinfo,client_dtPrd_NO.Value);
    text:=vartostr(prdName);
  end else
    text:=client_dtSMD_PRD_NAME.Value;
end;

procedure Tfm_ship.ActFirstExecute(Sender: TObject);
begin
  Client_Mast.First;
end;

procedure Tfm_ship.ActLastExecute(Sender: TObject);
begin
Client_Mast.Last;
end;

procedure Tfm_ship.ActPriorExecute(Sender: TObject);
begin
Client_Mast.Prior;
end;

procedure Tfm_ship.ActNextExecute(Sender: TObject);
begin
  Client_Mast.next;
end;

procedure Tfm_ship.ActEditExecute(Sender: TObject);
begin
  ModiFlag:=True;
  Client_Mast.Edit;
  Edit_Cum_no.SetFocus;
  SetEditMode(True);
end;

procedure Tfm_ship.SetEditMode(EditFlag: Boolean);
begin
  ds_client_dt.AutoEdit:=EditFlag;
  ActHistory.Enabled:=true;
  SetOwnerCtrlReadOnly(self,not EditFlag);
  ActAppend.Enabled:=not EditFlag;
  ActEdit.Enabled:=not EditFlag;
  ActDelete.Enabled:=not EditFlag;
  ActQuery.Enabled:=not EditFlag;
  ActPrint.Enabled:=not EditFlag;
  ActBrowse.Enabled:=not EditFlag;
  ActRefresh.Enabled:=not EditFlag;
  ActQuickCollect.Enabled:=not EditFlag;
  ActBook.Enabled:=not EditFlag;
  ActUnBook.Enabled:=not EditFlag;

  ActFirst.Enabled:=not Editflag;
  ActPrior.Enabled:=not Editflag;
  ActNext.Enabled:=not Editflag;
  ActLast.Enabled:=not Editflag;


  ActAbort.Enabled:= EditFlag;
  ActSave.Enabled:= EditFlag;
  SetCtrlReadOnly(Edit_Smt_NO,true);
  SetCtrlReadOnly(Edit_Amount,true);
  SetCtrlReadOnly(Edit_Smt_Not_Clean,true);
  SetCtrlReadOnly(Edit_Rec,true);
  Edit_Cum_no.Buttons[0].Visible:=EditFlag;
  Edit_Cum_name.Buttons[0].Visible:=EditFlag;
  Edit_Epy_no.Buttons[0].Visible:=EditFlag;
  Edit_SMT_TAX.Buttons[0].Visible:=EditFlag;
//  gridC_PRD_ONHAND.Color:=ColrEditDisableBack;
//  gridC_PRD_ONHAND.ReadOnly:=TRUE;

  if EditFlag then
  begin
    navDetail.VisibleButtons:= [nbFirst,nbPrior,nbNext,nbLast,nbInsert,nbDelete];
  end else
  begin
    navDetail.VisibleButtons:= [nbFirst,nbPrior,nbNext,nbLast];
  end;
  Client_MastAfterScroll(Client_mast);

end;

procedure Tfm_ship.ActAbortExecute(Sender: TObject);
begin
  Client_Mast.Cancel;
  SetEditMode(false);
end;

procedure Tfm_ship.ActAppendExecute(Sender: TObject);
begin
  ModiFlag:=false;
  client_dt.Close;
  DoQrySelect('SELECT * FROM TBL_SHIP_DT WHERE SMT_NO IS NULL',sysinfo.AdoConnection,client_dt);
  client_dt.open;
  Client_Mast.Append;
  Client_Mast.fieldbyname('SMT_DATE').Value:=trunc(SYSDATE)+frac(now);
  Edit_Cum_no.SetFocus;
  SetEditMode(true);

end;

procedure Tfm_ship.Edit_Cum_NOButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var s:string;
begin
  if Client_Mast.State=dsBrowse then exit;
  s:=SelectCumNO(sysinfo);
  if s<>'' then
    Client_Mast.FieldByName('CUM_NO').Value:=s;
end;

procedure Tfm_ship.Edit_Epy_NOButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var s:string;
begin
  if Client_Mast.State=dsBrowse then exit;
  s:=SelectEpyNO(SYSINFO);
  if s<>'' then
    Client_Mast.FieldByName('EPY_NO').Value:=s;

end;

procedure Tfm_ship.Edit_Cum_NameButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var s:string;
begin
  if Client_Mast.State=dsBrowse then exit;
  s:=SelectCumName(sysinfo);
  if s<>'' then
    Client_Mast.FieldByName('CUM_NO').Value:=s;

end;

procedure Tfm_ship.gridPRD_NOButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var s:string;
    slist:TStringList;
    i:integer;
begin
  if Client_Mast.State=dsBrowse then exit;
  slist:=TStringList.Create;
  try
    s:=SelectPrdNo(sysinfo,slist);
    if s=''then exit;

    for i:=slist.Count-1 downto 0 do
    begin
      AddProd(slist.Strings[i]);
    end;
  finally
    slist.Free;
  end;

end;

procedure Tfm_ship.AddProd(Prd_no: string);
begin
  if client_dt.State<>dsInsert then
    client_dt.insert;
  client_dt.FieldByName('PRD_NO').Value:=PRD_NO;
  client_dt.FieldByName('SMD_QTY').Value:=1;
  client_dt.FieldByName('SMD_UNIT_PRICE').Value
  := GetCusHisPrice(sysinfo,Client_MastCUM_NO.AsString,Prd_no);
  client_dt.Post;
end;

procedure Tfm_ship.Client_dtPRD_NOValidate(Sender: TField);
begin
  client_dt.FieldByName('SMD_UNIT_PRICE').Value:= GetCusHisPrice(sysinfo,Client_MastCUM_NO.AsString,Client_DTPrd_NO.AsString);
end;

procedure Tfm_ship.chkDetail;
VAR Prd_no:string;
begin
  client_dt.First;
  while not client_dt.Eof DO
  BEGIN
    PRD_NO:=client_dt.FieldByName('PRD_NO').AsString;
    if VARISNULL(TblLookup(sysinfo.AdoConnection,'TBL_PRODUCT','PRD_NO',PRD_NO,'PRD_NO')) then
      errMsg(Prd_no+' :產品編號錯誤 !',user);
    if (client_dt.FieldByName('SMD_QTY').AsCurrency =0) THEN
      errMsg(Prd_no+' :產品數量不得為零 ! ',user);
    client_dt.Next;
  END;
end;


procedure Tfm_ship.gridExit(Sender: TObject);
begin
  if Client_Mast.State=dsBrowse then exit;
  ShowTotal;
end;

procedure Tfm_ship.ShowTotal;
var total:currency;
begin
  total:=0;
  client_dt.First;
  while not client_dt.Eof do
  begin
    total:=total+Client_dtC_SUB_TOTAL.Value;
    client_dt.Next;
  end;
  Client_MastSMT_Total.Value:=total;
  if Client_MastSMT_Tax.AsCurrency<>0 then
    Client_MastSMT_Tax.Value:=total*sysinfo.SPR_TAX_Rate
  else
    Client_MastSMT_Tax.Value:=0;

end;

procedure Tfm_ship.RefreshData;
var sql,s:string;
    T:TDate;
begin
  screen.Cursor:=crSQLWait;
  TRY
    t:=now;
    Sql:='SELECT DISTINCT M.* FROM TBL_SHIP M' +CR
        +'INNER JOIN TBL_SHIP_DT D ON M.SMT_NO=D.SMT_NO ' +CR
        + JoinWhere('',SqlWhere) +CR
        + JoinOrder('',SqlOrder);
    debug(sql);

    if Client_Mast.State<> dsinactive then
      s:=client_Mast.fieldbyname('SMT_NO').AsString;

    DoQrySelect(sql,sysinfo.AdoConnection,Client_Mast);
    if Client_mast.Eof then
    begin
      msg('查無任何資料 !');
    end;
    IF s='' then
      Client_Mast.Last
    else
      Client_Mast.Locate('SMT_NO',S,[]);
    hint(format('查尋時間:%f 秒',[ (now-t)*86400]));
  FINALLY
    screen.Cursor:=crDefault;
  END;

end;


procedure Tfm_ship.SaveMaster;
var sql:string;
    car_no:string;
begin
  car_no:=Client_Mast.fieldbyname('CAR_NO').AsString;

  sql:='INSERT INTO TBL_SHIP '
      +'(SMT_NO,CUM_NO,SMT_STATUS'
      +',SMT_INV_NO,SMT_DATE,SMT_DESTINATION'
      +',SMT_TOTAL,SMT_TAX,EPY_NO'
      +',SMT_NOT_CLEAN,SMT_COST,SMT_DESC,SMT_DELIVER1,SMT_DELIVER2,CAR_NO,SMT_CREATOR) '
      +' VALUES ('
      +sqlStr(Client_Mast.fieldbyname('SMT_NO').AsString)+','
      +sqlStr(Client_Mast.fieldbyname('CUM_NO').AsString)+','
      +Client_Mast.fieldbyname('SMT_STATUS').AsString+','
      +sqlStr(Client_Mast.fieldbyname('SMT_INV_NO').AsString)+','
      +sqlDateTimeSql(Client_Mast.fieldbyname('SMT_DATE').AsDateTime)+','
      +sqlStr(Client_Mast.fieldbyname('SMT_DESTINATION').AsString)+','
      +Client_Mast.fieldbyname('SMT_TOTAL').AsString+','
      +CURRTOSTR(Client_Mast.fieldbyname('SMT_TAX').ASCURRENCY)+','
      +sqlStr(Client_Mast.fieldbyname('EPY_NO').AsString)+','
      +'0,0,'
      +sqlStr(Client_Mast.fieldbyname('SMT_DESC').AsString)+','
      +sqlStr(Client_Mast.fieldbyname('SMT_DELIVER1').AsString)+','
      +sqlStr(Client_Mast.fieldbyname('SMT_DELIVER2').AsString)+','
      +sqlstr(car_no)+','
      +sqlStr(sysinfo.LoginUserName)+')';
  sysinfo.AdoConnection.Execute(SQL);


end;


procedure Tfm_ship.SaveDetail;
var sql:string;
  prd_name:string;
  s:string;
  CNT:INTEGER;
begin
  client_dt.First;
  CNT:=0;
  while not client_dt.Eof DO
  BEGIN
    INC(CNT);
    Client_DT.Edit;
    Client_DTSMD_Seqno.Value:=cnt;
    Client_DT.Post;

    s:=trim(client_dtSMD_PRD_NAME.Value);
    if s='' then
      prd_name:='NULL'
    else
      prd_name:=SqlStr(s);

    sql:='INSERT INTO TBL_SHIP_DT'
        +' (SMT_NO,SMD_SEQNO,PRD_NO,INV_NO,SMD_PRD_NAME,'
        +' SMD_UNIT_PRICE,SMD_QTY,SMD_COST)'
        +' VALUES ('
        +sqlStr(Client_MastSMT_NO.AsString)+','
        +Client_DTSMD_Seqno.AsString+','
        +sqlStr(Client_dtPrd_NO.AsString)+','
        +sqlStr(Client_dtInv_no.AsString)+','
        +Prd_Name+','
        +client_DTSMd_UNIT_Price.AsString+','
        +client_dtSMD_QTY.AsString
        +',0)';
    sysinfo.AdoConnection.Execute(sql);
    client_dt.Next;
  end;
  IF ERRFLAG THEN
    RAISE EXCEPTION.Create('TEST ERR');


end;

{
procedure TFm_Main.SaveHisMaster;
var sql:string;
begin
  sql:='INSERT INTO TBL_HIS_SHIP '
      +'(HSMT_NO,CUM_NO'
      +',HSMT_INV_NO,HSMT_DATE,HSMT_DESTINATION'
      +',HSMT_TOTAL,HSMT_TAX,EPY_NO'
      +',HSMT_DESC,HSMT_CREATOR) '
      +' VALUES ('
      +sqlStr(Client_Mast.fieldbyname('SMT_NO').AsString)+','
      +sqlStr(Client_Mast.fieldbyname('CUM_NO').AsString)+','
      +sqlStr(Client_Mast.fieldbyname('SMT_INV_NO').AsString)+','
      +sqlDateTimeSql(Client_Mast.fieldbyname('SMT_DATE').AsDateTime)+','
      +sqlStr(Client_Mast.fieldbyname('SMT_DESTINATION').AsString)+','
      +Client_Mast.fieldbyname('SMT_TOTAL').AsString+','
      +CURRTOSTR(Client_Mast.fieldbyname('SMT_TAX').ASCURRENCY)+','
      +sqlStr(Client_Mast.fieldbyname('EPY_NO').AsString)+','
      +sqlStr(Client_Mast.fieldbyname('SMT_DESC').AsString)+','
      +sqlStr(SYS_USER_NAME)+')';
  sysinfo.AdoConnection.Execute(SQL);


end;


procedure TFm_Main.SaveHisDetail;
var sql:string;
  prd_name:string;
  s:string;
begin
  client_dt.First;
  while not client_dt.Eof DO
  BEGIN
    s:=trim(client_dtSMD_PRD_NAME.Value);
    if s='' then
      prd_name:='NULL'
    else
      prd_name:=SqlStr(s);

    sql:='INSERT INTO TBL_HIS_SHIP_DT'
        +' (HSMT_NO,HSMD_SEQNO,PRD_NO,INV_NO,HSMD_PRD_NAME,'
        +' HSMD_UNIT_PRICE,HSMD_QTY)'
        +' VALUES ('
        +sqlStr(Client_MastSMT_NO.AsString)+','
        +Client_DTSMD_Seqno.AsString+','
        +sqlStr(Client_dtPrd_NO.AsString)+','
        +sqlStr(Client_dtInv_no.AsString)+','
        +Prd_Name+','
        +client_DTSMd_UNIT_Price.AsString+','
        +client_dtSMD_QTY.AsString
        +')';
    sysinfo.AdoConnection.Execute(sql);
    client_dt.Next;
  end;
end;
}

procedure Tfm_ship.ActRefreshExecute(Sender: TObject);
begin
  RefreshData;
end;

procedure Tfm_ship.Client_MastCUM_NOValidate(Sender: TField);
begin
  CLIENT_mast.FieldByName('SMT_DESTINATION').Value:=
      TblLookup(sysinfo.AdoConnection, 'TBL_CUSTOMER','CUM_NO',CLIENT_MASTCUM_NO.Value,'CUM_ADDR');      
end;

procedure Tfm_ship.ActSaveExecute(Sender: TObject);
var smt_no:string;
  t:tdate;
begin
    t:=now;
    ShowTotal;
    ChkDetail;
    Client_MastSMT_Status.Value:=STATUS_UNBOOK;
    Client_MastSMT_COST.Value:=0;
    if not ModiFlag then
    begin
      Client_Mast.FieldByName('SMT_NO').Value:=GetNumbericCode(sysinfo.AdoConnection,'Tbl_Ship','SMT_NO','yyyymmdd',Client_Mast.fieldbyname('SMT_DATE').Value,4);
      SysDate:=Client_Mast.fieldbyname('SMT_DATE').Value;
    end;
    smt_no:=Client_Mast.FieldByName('SMT_NO').AsString;

    sysinfo.AdoConnection.BeginTrans;
    try
      if ModiFlag then
      begin
        DeleteDetail(smt_no);
        UpdateMaster;
        SaveDetail;
      end else
      BEGIN
        SaveMaster;
        SaveDetail;
      END;
      sysinfo.AdoConnection.CommitTrans;
    except
      sysinfo.AdoConnection.RollbackTrans;
      raise;
    end;
    Client_Mast.Post;
    SetEditMode(false);
    hint(format('儲存時間:%f 秒',[ (now-t)*86400]));

end;

procedure Tfm_ship.Client_dtSMD_PRD_NAMESetText(Sender: TField;
  const Text: String);
VAR prdname:variant;
    s:string;
begin
  prdName:=GetPrdName(sysinfo,client_dtPrd_NO.Value);
  s:=trim(text);
  IF (s=prdName) or (s='') then
    sender.Value:=null
  else
    sender.Value:=s;

end;

procedure Tfm_ship.DeleteDetail(SMT_NO:STRING);
var s:string;
begin
  S:='DELETE TBL_SHIP_DT WHERE SMT_NO='+sqlStr(smt_no);
  sysinfo.AdoConnection.Execute(s);
end;

procedure Tfm_ship.DeleteMaster(SMT_NO:STRING);
var s:string;
begin
  S:='DELETE TBL_SHIP WHERE SMT_NO='+sqlStr(smt_no);
  sysinfo.AdoConnection.Execute(s);
  client_mast.Delete;
end;



procedure Tfm_ship.UpdateMaster;
var sql:string;
begin
  sql:='UPDATE TBL_SHIP'
      +' SET CUM_NO='     +sqlStr(Client_Mast.fieldbyname('CUM_NO').AsString)
      +',SMT_STATUS='     +Client_Mast.fieldbyname('SMT_STATUS').AsString
      +',SMT_INV_NO='     +sqlStr(Client_Mast.fieldbyname('SMT_INV_NO').AsString)
      +',SMT_DATE='       +sqlDateTimeSql(Client_Mast.fieldbyname('SMT_DATE').AsDateTime)
      +',SMT_DESTINATION='+sqlStr(Client_Mast.fieldbyname('SMT_DESTINATION').AsString)
      +',SMT_TOTAL='      +Client_Mast.fieldbyname('SMT_TOTAL').AsString
      +',SMT_TAX='        +CURRTOSTR(Client_Mast.fieldbyname('SMT_TAX').AsCurrency)
      +',EPY_NO='         +sqlStr(Client_Mast.fieldbyname('EPY_NO').AsString)
      +',SMT_DELIVER1='         +sqlStr(Client_Mast.fieldbyname('SMT_DELIVER1').AsString)
      +',SMT_DELIVER2='         +sqlStr(Client_Mast.fieldbyname('SMT_DELIVER2').AsString)
      +',CAR_NO='         +sqlStr(Client_Mast.fieldbyname('CAR_NO').AsString)
      +',SMT_DESC='       +sqlStr(Client_Mast.fieldbyname('SMT_DESC').AsString)
      +',SMT_CREATOR='    +sqlStr(sysinfo.LoginUserName)
      +' WHERE SMT_NO='       +sqlStr(Client_Mast.fieldbyname('SMT_NO').AsString);
      sysinfo.AdoConnection.Execute(SQL);

end;


function Tfm_ship.GetNotClean(SMT_NO: string): currency;
var RecvAmount:currency;
  S:STRING;
  qry:TAdoQuery;
begin
  qry:=TAdoQuery.Create(self);
  qry.Connection:=sysinfo.AdoConnection;
  try
    s:='SELECT SUM(ARD_AMOUNT+ARD_DISCOUNT) F1 FROM TBL_AR_RECV_DT WHERE SMT_NO='+SqlStr(SMT_NO);
    qry.SQL.Text:=s;
    qry.Open;
    RecvAmount:=qry.Fields[0].AsCurrency;
    qry.Close;
    result:=Client_MastC_Amount.Value-RecvAmount;
  finally
    qry.Free;
  end;

end;



procedure Tfm_ship.Edit_SMT_TaxButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
begin
  if (Client_Mast.State<>dsEdit) and (Client_Mast.State<>dsInsert) then exit;
    Client_MastSMT_Tax.Value:=Client_MastSMT_Total.AsCurrency*sysinfo.SPR_TAX_Rate;
end;
procedure Tfm_ship.Client_dtBeforePost(DataSet: TDataSet);
begin
  Client_dtINV_NO.Value:=Default_Inv;
end;

procedure Tfm_ship.InsertInv_Transaction;
var PRD_IS_DUMMY:boolean;
    PRD_DUM_COST_RATE:SINGLE;
    sql:string;
begin
  client_dt.First;
  while not client_dt.Eof do
  begin
    GetDummyPrd(sysinfo,Client_DTPRD_NO.AsString,PRD_IS_DUMMY,PRD_DUM_COST_RATE);
    if PRD_IS_DUMMY then
    begin
      sql:='UPDATE TBL_SHIP_DT'
          +' SET SMD_COST='+CURRTOSTR(Client_dtSMD_UNIT_PRICE.Value*PRD_DUM_COST_RATE)
          +' WHERE SMT_NO='+sqlStr(Client_dtSMT_NO.AsString)
          +'   AND SMD_SEQNO='+client_dtSMD_SEQNO.AsString;
      sysinfo.AdoConnection.Execute(Sql);
    end else
    begin
      InsertTransaction(sysinfo,Client_DTPRD_NO.AsString
                               ,Client_DTINV_NO.AsString
                               ,TRN_SHP
                               ,client_MastSMT_NO.AsString
                               ,client_dtSMD_SEQNO.AsString
                               ,client_MastSMT_Date.Value
                               ,client_dtSMD_Qty.Value*-1
                               ,0);
    end;
    client_dt.Next;
  end;
end;


procedure Tfm_ship.DeleteInv_Transaction(smt_no:string);
var s:string;
begin
  s:='DELETE TBL_TRANSACTION WHERE '
    +' TRN_TYPE='+inttostr(TRN_SHP)
    +' AND TRN_SRC_NO=' +sqlstr(smt_no);
  sysinfo.AdoConnection.Execute(s);
  CLIENT_DT.First;
  WHILE NOT CLIENT_DT.Eof DO
  BEGIN
    UpdateTransaction(sysinfo,client_dtPRD_NO.AsString
                              ,client_MastSMT_Date.Value);
    CLIENT_DT.Next;
  END;

end;


procedure Tfm_ship.SetupQueryForm;
var fld:PQueryField;
    WhereList,OrderList:TList;
begin
  WhereList:=TList.Create;
  OrderList:=TList.Create;

  NewQueryFld(fld);
  fld.FieldName   :=  'SMT_DATE';
  fld.DispName    :='交易日期';
  fld.TableAlias  :='M';
  fld.DataType    :=wdDate;
  fld.CtrlType    :=wcDate;
  fld.QueryType   :=wqRange;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'SMT_NO';
  fld.DispName    :='憑證編號';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'CUM_NO';
  fld.DispName    :='客戶編號';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcSQL;
  fld.QueryType   :=wqSingle;
  fld.ListSql:='SELECT CUM_NO,CUM_NAME FROM TBL_CUSTOMER';
  FLD.ListReturnField:='CUM_NO';
  fld.ListFieldDisp:='客戶編號,客戶名稱';
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'EPY_NO';
  fld.DispName    :='業務員編號';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcSQL;
  fld.QueryType   :=wqSingle;
  fld.ListSql:='SELECT EPY_NO,EPY_NAME FROM TBL_EMPLOYE';
  FLD.ListReturnField:='EPY_NO';
  fld.ListFieldDisp:='員工編號,員工名稱';
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'SMT_INV_NO';
  fld.DispName    :='發票號碼';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'PRD_NO';
  fld.DispName    :='產品編號';
  fld.TableAlias  :='D';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcSQL;
  fld.QueryType   :=wqSingle;
  fld.ListSql:='SELECT PRD_NO,PRD_NAME FROM TBL_PRODUCT';
  FLD.ListReturnField:='PRD_NO';
  fld.ListFieldDisp:='產品編號,產品名稱';
  WhereList.Add(fld);

  Fm_Qry:=TFM_Query.Create(self);
  fm_qry.Init(sysinfo.AdoConnection,'','',WhereList,OrderList,query,dbsType);


end;

procedure Tfm_ship.ActQueryExecute(Sender: TObject);
var n:integer;
begin
  n:=fm_qry.ShowModal;
  if n=mrCancel then
    exit;
  sqlWhere:=Fm_qry.sqlWhere;      //取得 SQLWher  字串
  SQLOrder:=fm_qry.sqlOrder;      //取得 SQLOrder 字串
  RefreshData;

end;


procedure Tfm_ship.hint(msg: string);
begin
  lblStatus.Caption:=msg;
end;

procedure Tfm_ship.Edit_SMT_TaxDblClick(Sender: TObject);
begin
Edit_SMT_TaxButtonClick(Edit_Smt_Tax,0);
end;

procedure Tfm_ship.ActBrowseExecute(Sender: TObject);
var fm:TFm_Ship_Browse;
begin
  fm:=TFm_Ship_Browse.Create(application);
  fm.ds_mast:=ds_Master;
  fm.ds_detail:=ds_Client_dt;
  fm.init;
  try
    fm.ShowModal;
  finally
    fm.Free;
  end;

end;

procedure Tfm_ship.ActDeleteExecute(Sender: TObject);
var smt_no:string;
  st:integer;
  sql:string;
begin
  IF Client_Mast.fieldbyname('SMT_Not_Clean').AsCurrency<>Client_MastC_Amount.AsCurrency then
  BEGIN
    MSG('此單據已有收款記錄 , 禁止刪除 !');
    exit;
  end;
  if MessageDlg('是否確定刪除 ?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;

  smt_no:=Client_Mast.FieldByName('SMT_NO').AsString;
  st:=ChkStatusModified(SMT_NO,Client_MastSMT_STATUS.AsInteger);
  if st=1 then begin
    Msg('單據狀態已被更改 !');
    RefreshData;
    exit;
  end else if st=2 then begin
    Msg('單據已被刪除 !');
    RefreshData;
    exit;
  end;

  sysinfo.AdoConnection.BeginTrans;
  try
    {============================================================
     刪除前的暫時狀態,當網路多人使用時,若同時有人對同一張單據先按刪除
     另外有人在同時或稍後按確認鍵,將造成單據不存在,但是 tbl_transaction 卻有資料
    ==============================================================}
    sql:='UPDATE TBL_SHIP '
      +' SET SMT_STATUS='+INTTOSTR(STATUS_WILL_DELETE)
      +' WHERE SMT_NO='+sqlStr(SMT_no);
    sysinfo.AdoConnection.Execute(sql);
    DeleteInv_Transaction(smt_no);
    DeleteDetail(smt_no);
    DeleteMaster(smt_no);
    sysinfo.AdoConnection.CommitTrans;
  except
    sysinfo.AdoConnection.RollbackTrans;
    raise;
  end;

end;

procedure Tfm_ship.ActBookExecute(Sender: TObject);
var smt_no,s:string;
  t:tdate;
  not_clean:currency;
  year,ST:integer;
begin
  smt_no:=Client_Mast.FieldByName('SMT_NO').AsString;
  st:=ChkStatusModified(SMT_NO,Client_MastSMT_STATUS.AsInteger);
  if st=1 then begin
    Msg('單據狀態已被更改 !');
    RefreshData;
    exit;
  end else if st=2 then begin
    Msg('單據已被刪除 !');
    RefreshData;
    exit;
  end;


  year:= yearof(Client_MastSMT_DATE.Value);
  if year < sysinfo.SPR_ACNT_YEAR then
    Errmsg ('不得修改小於本會計年度的傳票 !',user);


  t:=now;
  screen.Cursor:=crSQLWait;
  try
    sysinfo.AdoConnection.BeginTrans;
    try
      s:='UPDATE TBL_SHIP'
        +' SET SMT_STATUS='+INTTOSTR(STATUS_confirm)
          +' WHERE SMT_NO='+sqlStr(smt_no);
      sysinfo.AdoConnection.Execute(s);
      InsertInv_Transaction;
      UpdateSMT_Cost(sysinfo,smt_no);
      not_clean:=GetNotClean(smt_no);
      s:='UPDATE TBL_SHIP'
        +' SET SMT_NOT_CLEAN='+CURRTOSTR(NOT_CLEAN)
          +' WHERE SMT_NO='+sqlStr(smt_no);
      sysinfo.AdoConnection.Execute(s);
      InsertAccount;
      client_mast.Edit;
      CLIENT_MASTSMT_COST.Value:=TblLookup(sysinfo.AdoConnection,'TBL_SHIP','SMT_NO',SMT_NO,'SMT_COST');
      CLIENT_MASTJNL_NO.Value:=TblLookup(sysinfo.AdoConnection,'TBL_SHIP','SMT_NO',SMT_NO,'JNL_NO');
      Client_MastSMT_NOT_CLEAN.Value:=NOT_clean;
      client_mastSMT_Status.Value:=STATUS_Confirm;

      client_mast.Post;
      Client_MastAfterScroll(Client_mast);
      sysinfo.AdoConnection.CommitTrans;
      hint(format('時間:%f 秒',[ (now-t)*86400]));
    except
      sysinfo.AdoConnection.RollbackTrans;
      raise;
    end;
  finally
    screen.Cursor:=crDefault;
  end;

end;

procedure Tfm_ship.ActUnBookExecute(Sender: TObject);
var smt_no,sql:string;
  t:tdate;
  jnl_no:string;
  year,ST:integer;
begin
  smt_no:=Client_Mast.FieldByName('SMT_NO').AsString;
  st:=ChkStatusModified(SMT_NO,Client_MastSMT_STATUS.AsInteger);
  if st=1 then begin
    Msg('單據狀態已被更改 !');
    RefreshData;
    exit;
  end else if st=2 then begin
    Msg('單據已被刪除 !');
    RefreshData;
    exit;
  end;

  year:= yearof(Client_MastSMT_DATE.Value);
  if year < sysinfo.SPR_ACNT_YEAR then
    Errmsg ('不得修改小於本會計年度的傳票 !',user);

  t:=now;
  smt_no:=Client_Mast.FieldByName('SMT_NO').AsString;
  IF Chk_Ar_Received(smt_no) then
  BEGIN
    MSG('此單據已有收款記錄 , 禁止取消確認 !');
    exit;
  end;

  screen.Cursor:=crSQLWait;
  try
    sysinfo.AdoConnection.BeginTrans;
    try
      sql:='UPDATE TBL_SHIP SET SMT_STATUS='+INTTOSTR(STATUS_UNBOOK)
          +',SMT_COST=0'
          +',JNL_NO=NULL'
          +' WHERE SMT_NO='+sqlStr(smt_no);
      sysinfo.AdoConnection.Execute(sql);
      DeleteInv_Transaction(smt_no);
      client_mast.Edit;
      client_mastSMT_Status.Value:=STATUS_UNBOOK;
      client_mast.FieldByName('smt_cost').Value:=0;
      client_mast.Post;

      jnl_no:=client_mast.fieldbyname('JNL_NO').AsString;
      sql:='DELETE TBL_ACNT_JOURNAL_DT WHERE JNL_NO='+sqlstr(jnl_no);
      sysinfo.AdoConnection.Execute(sql);
      sql:='DELETE TBL_ACNT_JOURNAL WHERE JNL_NO='+sqlstr(jnl_no);
      sysinfo.AdoConnection.Execute(sql);

      Client_MastAfterScroll(Client_mast);
      sysinfo.AdoConnection.CommitTrans;
      hint(format('時間:%f 秒',[ (now-t)*86400]));
    except
      sysinfo.AdoConnection.RollbackTrans;
      raise;
    end;
  finally
    screen.Cursor:=crDefault;
  end;

end;

procedure Tfm_ship.ActHistoryExecute(Sender: TObject);
var fm:TFM_Ship_History;
  s:string;
begin
  fm:=TFM_Ship_History.Create(application);
  fm.sysinfo:=sysinfo;
  try
//    fm.Client_Mast.AfterScroll:=nil;
    s:='SELECT 1 CLS,HSMT_NO, CUM_NO, EPY_NO ,0 HSMT_NOT_CLEAN'
      +', HSMT_INV_NO, HSMT_DATE, HSMT_DESTINATION'
      +', HSMT_TOTAL, HSMT_TAX, HSMT_COST'
      +', HSMT_DESC, HSMT_CREATOR'
      +' FROM TBL_HIS_SHIP'
      +' WHERE CUM_NO='+sqlstr(client_mastCUM_NO.AsString)
      +' UNION'
      +' SELECT 2, SMT_NO, CUM_NO, EPY_NO ,SMT_NOT_CLEAN'
      +', SMT_INV_NO, SMT_DATE, SMT_DESTINATION'
      +', SMT_TOTAL, SMT_TAX, SMT_COST'
      +', SMT_DESC, SMT_CREATOR'
      +' FROM TBL_SHIP'
      +' WHERE CUM_NO='+sqlstr(client_mastCUM_NO.AsString)
      +' ORDER BY HSMT_DATE,HSMT_NO';
    DoQrySelect(s,sysinfo.AdoConnection,fm.Client_Mast);
    fm.Client_Mast.Open;
    fm.ShowModal;
  finally
    fm.Free;
  end;


end;

procedure Tfm_ship.Client_MastSMT_NOT_CLEANGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
if client_mastSMT_Status.Value=Status_UnBook then
  text:='單據未確認'
else
  text:=sender.AsString;
end;

procedure Tfm_ship.Client_MastSMT_DATEValidate(Sender: TField);
begin
  IF SENDER.AsDateTime<sysinfo.SPR_PERIOD_START THEN
    ErrMsg('交易日期不得小於(交易期間起始日期)'
            +#13#13'交易期間起始日期 ='+Datetostr(sysinfo.SPR_PERIOD_START),user);
end;

procedure Tfm_ship.gridCustomDraw(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxDBTreeListColumn;
  const AText: String; AFont: TFont; var AColor: TColor; ASelected,
  AFocused: Boolean; var ADone: Boolean);
var n:integer;
begin
  n:=grid.ColumnByFieldName('SMD_QTY').Index;
  if varisnull(ANode.Values[n]) then exit;
  if ANode.Values[n]<0 then
  begin
    AColor:=clYellow;
    Afont.Color:=clRed;
  end;

end;

procedure Tfm_ship.ActFunctionExecute(Sender: TObject);
var p:TPoint;
begin
  p.X:=BtnFunc.Left;
  p.Y:=BtnFunc.Top;
  p:=BtnFunc.ClientToScreen(point(0,0));
  MenuFunc.Popup(p.X,p.Y);
end;

procedure Tfm_ship.ActQuickCollectExecute(Sender: TObject);
var fm:TFM_QuickCollect;
    Arr_NO,CUM_NO,SMT_NO:string;
    desc:string;
begin
  if Client_MastSMT_Not_Clean.AsCurrency=0 then begin
    msg('此單據帳款已結清 !');
    exit;
  end;
  fm:=TFM_QuickCollect.Create(self);
  fm.dsMast:=ds_Master;
  fm.init;
  
  try
    fm.dt_Date.Date:=trunc(client_mastSMT_Date.Value);
    if fm.ShowModal<>mrok then exit;
    ARR_NO:=GetNumbericCode(sysinfo.AdoConnection,'Tbl_AR_RECV','ARR_NO','yyyymmdd',fm.ARR_Date,4);
    CUM_NO:=CLIENT_mastCUM_NO.Value;
    SMT_NO:=CLIENT_MASTSMT_NO.Value;
    sysinfo.AdoConnection.BeginTrans;
    desc:='系統傳輸--快速收款作業 '+Client_MastC_CUM_NAME.Value+'(憑證編號:'+arr_no+')';
    try
      Insert_AR_Recv(sysinfo,ARR_NO,cum_no,fm.ARR_Date,fm.cash,fm.check,0,0,'快速收付款',sysinfo.LoginUserName);
      Insert_AR_Recv_DT(sysinfo,ARR_NO,1,SMT_NO,FM.cash+FM.check,FM.discount);
      UpdateARNotClean(sysinfo,SMT_NO);
      ArRecvToAccount(sysinfo,arr_no
                                 ,cum_no
                                 ,fm.ARR_Date
                                 ,desc
                                 ,fm.cash
                                 ,fm.check
                                 ,fm.discount
                                 ,0,0);
      CLIENT_MAST.Edit;
      Client_MastSMT_NOT_CLEAN.Value:=GetNotClean(smt_no);
      client_mast.Post;

      sysinfo.AdoConnection.CommitTrans;
    except
      sysinfo.AdoConnection.RollbackTrans;
      RAISE;
    end;
  finally
    fm.Free;
  end;


end;

procedure Tfm_ship.Client_dtPRD_NOGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  text:=sender.AsString;

end;

function Tfm_ship.Chk_AR_Received(SMT_NO: string): boolean;
var N:INTEGER;
begin
  N:=TblLookup(sysinfo.AdoConnection,'TBL_AR_RECV_DT','SMT_NO',SMT_NO,'COUNT(*)');
  RESULT:=(N>0);

end;

procedure Tfm_ship.ActPrintExecute(Sender: TObject);
var fm:TFM_Ship_Print;
    mr:TModalResult;
    where,rpt:string;
begin
  fm:=TFM_Ship_Print.Create(application);
  try
    mr:=fm.ShowModal;
    case fm.RadioFormat.ItemIndex of
      0 :rpt:='ZZ_FM_SHIP_RPT01';
      1 :rpt:='ZZ_FM_SHIP_RPT02';
      2 :rpt:='ZZ_FM_SHIP_RPT03';
      3 :rpt:='ZZ_FM_SHIP_RPT04';
    end;
    case fm.RadioScope.ItemIndex of
      0:  where :='M.SMT_NO='+sqlStr(Client_mastSMT_NO.AsString);
      1:  where:=sqlWhere;
    end;

    case mr of
      MrPreview : PrintFormReport(sysinfo.AdoConnection,rpt,Where,SQLOrder,MrPreview);
      MrPrint   : PrintFormReport(sysinfo.AdoConnection,rpt,Where,SQLOrder,MrPrint);
    end;
  finally
    fm.Free;
  end;

end;

procedure Tfm_ship.InsertAccount;
var sale_revenue,sale_return,sale_discount:currency;
    qty,unit_price,subtotal,tax:currency;
    jnl_no,desc:string;
    cum_acnt_ar:string;
    sql:string;
begin
  sale_revenue:=0;
  sale_return:=0;
  sale_discount:=0;
  client_dt.First;
  while not client_dt.Eof do begin
    qty := Client_dtSMD_QTY.Value;
    unit_price:=Client_dtSMD_UNIT_PRICE.Value;
    subtotal:=Client_dtC_SUB_TOTAL.Value;
    if subtotal > 0 then
      sale_revenue:=sale_revenue+subtotal
    else if qty < 0 then
      sale_return:=sale_return+subtotal
    else if unit_price < 0 then
      sale_discount:=sale_discount+subtotal;
    client_dt.Next;
  end;

{=====================================================================
  會計主檔
=======================================================================}
  jnl_no:=GetNumbericCode(sysinfo.AdoConnection,'Tbl_ACNT_JOURNAL','JNL_NO','yyyymmdd',Client_MastSMT_DATE.Value,4);
  desc:='傳輸銷退貨作業:'+Client_MastC_CUM_NAME.AsString+' :'+Client_MastSMT_NO.AsString;
  sql:='INSERT INTO TBL_ACNT_JOURNAL '
      +'(JNL_NO'
      +',JNL_DATE'
      +',JNL_DESC'
      +',JNL_BILL_TYPE'
      +',JNL_CREATOR) '
      +' VALUES ('
      +sqlStr(jnl_no)+','
      +sqlDateTimeSql(Client_MastSMT_DATE.Value)+','
      +sqlStr(desc)+','
      +'1,'
      +sqlStr(sysinfo.LoginUserName)+')';
  sysinfo.AdoConnection.Execute(SQL);


    desc:='銷貨:'+Client_MastSMT_NO.AsString+':'+Client_MastC_CUM_NAME.AsString;
{=====================================================================
  會計明細  -- 應收帳款
=======================================================================}
    cum_acnt_ar:=vartostr(TblLookup(sysinfo.AdoConnection,'TBL_CUSTOMER','CUM_NO',Client_MastCUM_NO.AsString,'CUM_ACNT_AR'));
    sql:='INSERT INTO TBL_ACNT_JOURNAL_DT'
        +' (JNL_NO,JND_SEQNO,ACT_NO,'
        +' JND_AMOUNT,JND_DESC)'
        +' VALUES ('
        +sqlStr(jnl_no)+','
        +'1,'
        +sqlStr(cum_acnt_ar)+','
        +Client_MastC_Amount.AsString+','
        +sqlstr(desc)
        +')';
    sysinfo.AdoConnection.Execute(sql);

{=====================================================================
  會計明細  -- 銷貨收入
=======================================================================}
    sql:='INSERT INTO TBL_ACNT_JOURNAL_DT'
        +' (JNL_NO,JND_SEQNO,ACT_NO,'
        +' JND_AMOUNT,JND_DESC)'
        +' VALUES ('
        +sqlStr(jnl_no)+','
        +'2,'
        +sqlStr(sysinfo.SPR_ACNT_SALE_REVENUE)+','
        +currtostr(-sale_revenue)+','
        +sqlStr(desc)
        +')';
    sysinfo.AdoConnection.Execute(sql);


{=====================================================================
  會計明細  -- 銷項稅額
=======================================================================}
    tax:=Client_MastSMT_TAX.AsCurrency;
    if tax <> 0 then begin
      sql:='INSERT INTO TBL_ACNT_JOURNAL_DT'
          +' (JNL_NO,JND_SEQNO,ACT_NO,'
          +' JND_AMOUNT,JND_DESC)'
          +' VALUES ('
          +sqlStr(jnl_no)+','
          +'3,'
          +sqlStr(sysinfo.SPR_ACNT_SALE_TAX)+','
          +currtostr(-tax)+','
          +sqlStr(desc)
          +')';
      sysinfo.AdoConnection.Execute(sql);
    end;

{=====================================================================
  會計明細  -- 銷貨退回
=======================================================================}
    if sale_return <> 0 then begin
      sql:='INSERT INTO TBL_ACNT_JOURNAL_DT'
          +' (JNL_NO,JND_SEQNO,ACT_NO,'
          +' JND_AMOUNT,JND_DESC)'
          +' VALUES ('
          +sqlStr(jnl_no)+','
          +'4,'
          +sqlStr(sysinfo.SPR_ACNT_SALE_RETURN)+','
          +currtostr(-sale_return)+','
          +sqlStr(desc)
          +')';
      sysinfo.AdoConnection.Execute(sql);
    end;

{=====================================================================
  會計明細  -- 銷貨折讓
=======================================================================}
    if sale_discount <> 0 then begin
      sql:='INSERT INTO TBL_ACNT_JOURNAL_DT'
          +' (JNL_NO,JND_SEQNO,ACT_NO,'
          +' JND_AMOUNT,JND_DESC)'
          +' VALUES ('
          +sqlStr(jnl_no)+','
          +'5,'
          +sqlStr(sysinfo.SPR_ACNT_SALE_DISCOUNT)+','
          +currtostr(-sale_discount)+','
          +sqlStr(desc)
          +')';
      sysinfo.AdoConnection.Execute(sql);
    end;



{=====================================================================
  update TBL_SHIP.JNL_NO
=======================================================================}
      sql:='UPDATE TBL_SHIP'
        +' SET JNL_NO='+sqlstr(jnl_no)
          +' WHERE SMT_NO='+sqlStr(Client_MastSMT_NO.Value);
      sysinfo.AdoConnection.Execute(sql);

  ChkDCBalance(sysinfo,JNL_NO);
end;

function Tfm_ship.ChkStatusModified(rcv_no: string;old_st:integer): integer;
var v:variant;
begin
  v:=TblLookup(sysinfo.AdoConnection,'TBL_SHIP','SMT_NO',RCV_NO,'SMT_STATUS');
  if varisnull (v) then
    result:=2     // bill was deleted
  else if v=old_st then
    result:=0
  else
    result:=1;

end;



procedure Tfm_ship.dxDBButtonEdit1ButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var s:string;
begin
  if Client_Mast.State=dsBrowse then exit;
  s:=SelectEpyNO(sysinfo);
  if s<>'' then
    Client_Mast.FieldByName('SMT_DELIVER1').Value:=s;

end;

procedure Tfm_ship.dxDBButtonEdit2ButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var s:string;
begin
  if Client_Mast.State=dsBrowse then exit;
  s:=SelectEpyNO(sysinfo);
  if s<>'' then
    Client_Mast.FieldByName('SMT_DELIVER2').Value:=s;

end;

procedure Tfm_ship.dxDBButtonEdit3ButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var s:string;
begin
  if Client_Mast.State=dsBrowse then exit;
  s:=SelectCarNO(sysinfo);
  if s<>'' then
    Client_Mast.FieldByName('CAR_NO').Value:=s;

end;

procedure Tfm_ship.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var st:TDataSetState;
begin
  inherited;
  st:=Client_Mast.State;
  if (st=dsInsert)
  or (st=dsEdit) then
  begin
    CanClose:=false;
    show;
    msg('在新增或修改模式，不能結束作業 ！');
  end else begin
    CanClose:=True;
  end;


end;

end.

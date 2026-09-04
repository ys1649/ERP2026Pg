unit Form_PoRecv;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, ComCtrls, ExtCtrls, Mask, Buttons, ActnList,
  ImgList, dxCntner, dxEditor, dxEdLib, dxDBELib, DBCtrls, dxExEdtr,
  DBClient, Provider, dxDBTLCl, dxGrClms, dxTL, dxDBCtrl, dxDBGrid,
  wwSpeedButton, wwDBNavigator, wwclearpanel, wwdbdatetimepicker, Grids,
  DBGrids, wwdblook, dxDBEdtr, Form_Query, Menus, DateUtils,erp_public,FORM_ERP_BASE;

type
  Tfm_PoRecv = class(TFORM_ERP)
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
    Label13: TLabel;
    Label14: TLabel;
    Label1: TLabel;
    Label8: TLabel;
    Label7: TLabel;
    Label11: TLabel;
    Edit_Amount: TdxDBEdit;
    Client_dt: TClientDataSet;
    ImageList1: TImageList;
    ds_Client_dt: TDataSource;
    PnlDetail2: TPanel;
    grid: TdxDBGrid;
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
    ActRefresh: TAction;
    ActHistory: TAction;
    Panel1: TPanel;
    btnPrior: TSpeedButton;
    btnNext: TSpeedButton;
    BtnLast: TSpeedButton;
    btnFirst: TSpeedButton;
    Edit_Rec: TEdit;
    Panel2: TPanel;
    Label3: TLabel;
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
    qry_Mast: TADOQuery;
    qry_dt: TADOQuery;
    Provider_Mast: TDataSetProvider;
    Provider_DT: TDataSetProvider;
    Client_MastRCV_NO: TStringField;
    Client_MastSUP_NO: TStringField;
    Client_MastRCV_STATUS: TBCDField;
    Client_MastRCV_DATE: TDateTimeField;
    Client_MastRCV_INV_NO: TStringField;
    Client_MastRCV_TOTAL: TBCDField;
    Client_MastRCV_TAX: TBCDField;
    Client_MastRCV_NOT_CLEAN: TBCDField;
    Client_MastRCV_DESC: TStringField;
    Client_MastRCV_CREATOR: TStringField;
    Client_dtRCV_NO: TStringField;
    Client_dtRCD_SEQNO: TBCDField;
    Client_dtPRD_NO: TStringField;
    Client_dtINV_NO: TStringField;
    Client_dtRCD_PRD_NAME: TStringField;
    Client_dtRCD_QTY: TBCDField;
    Client_dtRCD_UNIT_PRICE: TBCDField;
    Client_MastC_SUP_NAME: TStringField;
    Client_dtC_SUB_TOTAL: TCurrencyField;
    Client_dtC_PRD_ONHAND: TFloatField;
    Client_MastC_AMOUNT: TCurrencyField;
    Edit_RCV_Not_Clean: TDBEdit;
    Client_dtC_SEQNO: TIntegerField;
    Edit_SUP_NO: TdxDBButtonEdit;
    Edit_RCV_No: TdxDBEdit;
    Edit_SUP_Name: TdxDBButtonEdit;
    Edit_RCV_Tax: TdxDBButtonEdit;
    Client_MastC_SUP_ADDR: TStringField;
    DBText1: TDBText;
    Label6: TLabel;
    dt_PAY_DATE: TwwDBDateTimePicker;
    memo_RCV_Desc: TdxDBMemo;
    gridRCD_PRD_NAME: TdxDBGridMaskColumn;
    gridRCD_QTY: TdxDBGridMaskColumn;
    gridRCD_UNIT_PRICE: TdxDBGridMaskColumn;
    gridC_SUB_TOTAL: TdxDBGridColumn;
    gridC_PRD_ONHAND: TdxDBGridColumn;
    gridC_SEQNO: TdxDBGridColumn;
    gridPRD_NO: TdxDBGridButtonColumn;
    Client_dtC_PRD_UNIT: TStringField;
    gridC_PRD_UNIT: TdxDBGridColumn;
    Client_MastJNL_NO: TStringField;
    procedure Client_MastCalcFields(DataSet: TDataSet);
    procedure Client_MastAfterScroll(DataSet: TDataSet);
    procedure Client_dtCalcFields(DataSet: TDataSet);
    procedure Client_dtRCD_PRD_NAMEGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure ActFirstExecute(Sender: TObject);
    procedure ActLastExecute(Sender: TObject);
    procedure ActPriorExecute(Sender: TObject);
    procedure ActNextExecute(Sender: TObject);
    procedure ActEditExecute(Sender: TObject);
    procedure ActAbortExecute(Sender: TObject);
    procedure ActAppendExecute(Sender: TObject);
    procedure Edit_SUP_NOButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure Edit_SUP_NameButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure gridPRD_NOButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure Client_dtPRD_NOValidate(Sender: TField);
    procedure gridExit(Sender: TObject);
    procedure ActRefreshExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure Client_dtRCD_PRD_NAMESetText(Sender: TField;
      const Text: String);
    procedure Edit_RCV_TaxButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure Client_dtBeforePost(DataSet: TDataSet);
    procedure ActQueryExecute(Sender: TObject);
    procedure Edit_RCV_TaxDblClick(Sender: TObject);
    procedure ActBrowseExecute(Sender: TObject);
    procedure ActDeleteExecute(Sender: TObject);
    procedure ActBookExecute(Sender: TObject);
    procedure ActUnBookExecute(Sender: TObject);
    procedure ActHistoryExecute(Sender: TObject);
    procedure Client_MastRCV_NOT_CLEANGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure Client_MastRCV_DATEValidate(Sender: TField);
    procedure gridCustomDraw(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxDBTreeListColumn;
      const AText: String; AFont: TFont; var AColor: TColor; ASelected,
      AFocused: Boolean; var ADone: Boolean);
    procedure ActFunctionExecute(Sender: TObject);
    procedure ActQuickCollectExecute(Sender: TObject);
    procedure Client_dtPRD_NOGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure ActPrintExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    Sysdate:TDateTime;
    ERRFLAG:BOOLEAN;
    ModiFlag:boolean;
    Fm_Qry:TFM_Query;
    SQlWhere,SQLOrder:string;
    WhereList,OrderList:TList;
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
    procedure DeleteDetail(RCV_NO: STRING);
    procedure SetupQueryForm;
    procedure RefreshData;
    function GetNotClean(RCV_NO:string):currency;
    procedure DeleteMaster(RCV_NO: STRING);
    procedure DeleteInv_Transaction(RCV_no: string);
    function Chk_AR_Received(RCV_NO: string): boolean;
    procedure InsertAccount;
    function ChkStatusModified(rcv_no: string; old_st: integer): integer;
    { Private declarations }
  public
    PROCEDURE Init;override;
    { Public declarations }
  end;


implementation

uses Uty, SysReport_Head, FORM_porecv_HISTORY,
  form_porecv_QuickPay, form_SysReportQuery, form_PoRecv_Print,
  form_PoRecv_Browse, DBUty;

{$R *.dfm}

{ TForm1 }

procedure Tfm_PoRecv.Init;
//var t1:tdatetime;
begin

  SELF.Caption:=caption+' --> '+sysinfo.SPR_cor_name;
  Sysdate:=now;
  BtnUnConfirm.Top:=BtnConfirm.Top;
  BtnUnConfirm.left:=BtnConfirm.left;
  SetEditMode(false);
  SetupQueryForm;
  SqlWhere:='M.RCV_DATE>='+SqlDateTimeSql(trunc(now)-90);
  SqlOrder:='M.RCV_DATE,M.RCV_NO';
  RefreshData;

end;

procedure Tfm_PoRecv.Client_MastCalcFields(DataSet: TDataSet);
begin
  Client_MastC_Amount.Value:=Client_MastRCV_TOTAL.Value+Client_MastRCV_Tax.Value;
  client_mastC_SUP_Name.Value:=GetSupName(sysinfo,client_mastSUP_no.Value);
  client_mastC_SUP_ADDR.Value:=vartostr(TblLookup(sysinfo.AdoConnection,'TBL_Supplier','SUP_NO',client_mastSUP_no.Value,'SUP_ADDR'));

end;

procedure Tfm_PoRecv.Client_MastAfterScroll(DataSet: TDataSet);
var sql:string;
  IsUnBook:boolean;
begin
  if Client_Mast.State<>dsBrowse then exit;
  
  sql:='SELECT * FROM TBL_PO_RECV_DT WHERE RCV_NO='+SqlStr(Client_MastRCV_NO.AsString);
  DoQrySelect(sql,sysinfo.AdoConnection,Client_DT);
  isUnBook:=(Client_mastRCV_Status.Value=Status_UnBook);
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
    Edit_RCV_Not_Clean.Color:=Panel2.Color;
//    SetOwnerCtrlColor(self,$00A00000,clSilver);
  end else
  begin
    Panel2.Color:=clBtnFace;
    Edit_RCV_Not_Clean.Color:=Panel2.Color;
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

procedure Tfm_PoRecv.Client_dtCalcFields(DataSet: TDataSet);
begin
  client_dtC_SUB_TOTAL.Value:=client_dtRCD_QTY.Value*client_dtRCD_UNIT_PRICE.Value;
  client_dtC_SEQNO.Value:=client_dt.RecNo;
  Client_dtC_PRD_ONHAND.Value:=vartoCURR(TblLookup(sysinfo.AdoConnection,'TBL_PRODUCT','PRD_NO',Client_dtPRD_NO.AsString,'PRD_ONHAND'));
  Client_dtC_PRD_UNIT.Value:=vartostr(TblLookup(sysinfo.AdoConnection,'TBL_PRODUCT','PRD_NO',Client_dtPRD_NO.AsString,'PRD_UNIT'));

end;

procedure Tfm_PoRecv.Client_dtRCD_PRD_NAMEGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
VAR prdname:variant;
begin
  if client_dtRCD_PRD_NAME.Value='' then
  BEGIN
    prdName:=GetPrdName(sysinfo,client_dtPrd_NO.Value);
    text:=vartostr(prdName);
  end else
    text:=client_dtRCD_PRD_NAME.Value;
end;

procedure Tfm_PoRecv.ActFirstExecute(Sender: TObject);
begin
  Client_Mast.First;
end;

procedure Tfm_PoRecv.ActLastExecute(Sender: TObject);
begin
Client_Mast.Last;
end;

procedure Tfm_PoRecv.ActPriorExecute(Sender: TObject);
begin
Client_Mast.Prior;
end;

procedure Tfm_PoRecv.ActNextExecute(Sender: TObject);
begin
  Client_Mast.next;
end;

procedure Tfm_PoRecv.ActEditExecute(Sender: TObject);
begin
  ModiFlag:=True;
  Client_Mast.Edit;
  Edit_SUP_no.SetFocus;
  SetEditMode(True);
end;

procedure Tfm_PoRecv.SetEditMode(EditFlag: Boolean);
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
  SetCtrlReadOnly(Edit_RCV_NO,true);
  SetCtrlReadOnly(Edit_Amount,true);
  SetCtrlReadOnly(Edit_RCV_Not_Clean,true);
  SetCtrlReadOnly(Edit_Rec,true);
  Edit_SUP_no.Buttons[0].Visible:=EditFlag;
  Edit_SUP_name.Buttons[0].Visible:=EditFlag;
  Edit_RCV_TAX.Buttons[0].Visible:=EditFlag;
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

procedure Tfm_PoRecv.ActAbortExecute(Sender: TObject);
begin
  Client_Mast.Cancel;
  SetEditMode(false);
end;

procedure Tfm_PoRecv.ActAppendExecute(Sender: TObject);
begin
  ModiFlag:=false;
  client_dt.Close;
  DoQrySelect('SELECT * FROM TBL_PO_RECV_DT WHERE RCV_NO IS NULL',sysinfo.AdoConnection,client_dt);
  client_dt.open;
  Client_Mast.Append;
  Client_Mast.fieldbyname('RCV_DATE').Value:=trunc(SYSDATE)+frac(now);
  Edit_SUP_no.SetFocus;
  SetEditMode(true);

end;

procedure Tfm_PoRecv.Edit_SUP_NOButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var s:string;
begin
  if Client_Mast.State=dsBrowse then exit;
  s:=SelectSupNO(sysinfo);
  if s<>'' then
    Client_Mast.FieldByName('SUP_NO').Value:=s;
end;


procedure Tfm_PoRecv.Edit_SUP_NameButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var s:string;
begin
  if Client_Mast.State=dsBrowse then exit;
  s:=SelectSupName(sysinfo);
  if s<>'' then
    Client_Mast.FieldByName('SUP_NO').Value:=s;

end;

procedure Tfm_PoRecv.gridPRD_NOButtonClick(Sender: TObject;
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

procedure Tfm_PoRecv.AddProd(Prd_no: string);
begin
  if client_dt.State<>dsInsert then
    client_dt.insert;
  client_dt.FieldByName('PRD_NO').Value:=PRD_NO;
  client_dt.FieldByName('RCD_QTY').Value:=1;
  client_dt.FieldByName('RCD_UNIT_PRICE').Value:= GetSupHisPrice(sysinfo,Client_MastSUP_NO.AsString,Prd_no);
  client_dt.Post;
end;

procedure Tfm_PoRecv.Client_dtPRD_NOValidate(Sender: TField);
begin
  client_dt.FieldByName('RCD_UNIT_PRICE').Value:= GetSupHisPrice(sysinfo,Client_MastSUP_NO.AsString,Client_DTPrd_NO.AsString);
end;

procedure Tfm_PoRecv.chkDetail;
VAR Prd_no:string;
begin
  client_dt.First;
  while not client_dt.Eof DO
  BEGIN
    PRD_NO:=client_dt.FieldByName('PRD_NO').AsString;
    if VARISNULL(TblLookup(sysinfo.AdoConnection,'TBL_PRODUCT','PRD_NO',PRD_NO,'PRD_NO')) then
      errMsg(Prd_no+' :產品編號錯誤 !',user);
    if (client_dt.FieldByName('RCD_QTY').AsCurrency =0) THEN
      errMsg(Prd_no+' :產品數量不得為零 ! ',user);
    client_dt.Next;
  END;
end;


procedure Tfm_PoRecv.gridExit(Sender: TObject);
begin
  if Client_Mast.State=dsBrowse then exit;
  ShowTotal;
end;

procedure Tfm_PoRecv.ShowTotal;
var total:currency;
begin
  total:=0;
  client_dt.First;
  while not client_dt.Eof do
  begin
    total:=total+Client_dtC_SUB_TOTAL.Value;
    client_dt.Next;
  end;
  Client_MastRCV_Total.Value:=total;
  if Client_MastRCV_Tax.AsCurrency<>0 then
    Client_MastRCV_Tax.Value:=total*sysinfo.SPR_TAX_Rate
  else
    Client_MastRCV_Tax.Value:=0;
end;

procedure Tfm_PoRecv.RefreshData;
var sql,s:string;
    T:TDate;
begin
  screen.Cursor:=crSQLWait;
  TRY
    t:=now;
    Sql:='SELECT DISTINCT M.* FROM TBL_PO_RECV M'+CR
        +' INNER JOIN TBL_PO_RECV_DT D ON M.RCV_NO=D.RCV_NO'+CR
        + JoinWhere('',SqlWhere)+CR
        + JoinOrder('',SqlOrder);

    if Client_Mast.State<> dsinactive then
      s:=client_Mast.fieldbyname('RCV_NO').AsString;

    DoQrySelect(sql,sysinfo.AdoConnection,Client_Mast);
    if Client_mast.Eof then
    begin
      msg('查無任何資料 !');
    end;
    IF s='' then
      Client_Mast.Last
    else
      Client_Mast.Locate('RCV_NO',S,[]);
    hint(format('查尋時間:%f 秒',[ (now-t)*86400]));
  FINALLY
    screen.Cursor:=crDefault;
  END;

end;


procedure Tfm_PoRecv.SaveMaster;
var sql:string;
begin
  sql:='INSERT INTO TBL_PO_RECV '
      +'(RCV_NO,SUP_NO,RCV_STATUS'
      +',RCV_INV_NO,RCV_DATE'
      +',RCV_TOTAL,RCV_TAX'
      +',RCV_NOT_CLEAN,RCV_DESC,RCV_CREATOR) '
      +' VALUES ('
      +sqlStr(Client_Mast.fieldbyname('RCV_NO').AsString)+','
      +sqlStr(Client_Mast.fieldbyname('SUP_NO').AsString)+','
      +Client_Mast.fieldbyname('RCV_STATUS').AsString+','
      +sqlStr(Client_Mast.fieldbyname('RCV_INV_NO').AsString)+','
      +sqlDateTimeSql(Client_Mast.fieldbyname('RCV_DATE').AsDateTime)+','
      +Client_Mast.fieldbyname('RCV_TOTAL').AsString+','
      +CURRTOSTR(Client_Mast.fieldbyname('RCV_TAX').ASCURRENCY)+','
      +'0,'
      +sqlStr(Client_Mast.fieldbyname('RCV_DESC').AsString)+','
      +sqlStr(sysinfo.LoginUserName)+')';
  sysinfo.AdoConnection.Execute(SQL);


end;


procedure Tfm_PoRecv.SaveDetail;
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
    Client_DTRCD_Seqno.Value:=cnt;
    Client_DT.Post;

    s:=trim(client_dtRCD_PRD_NAME.Value);
    if s='' then
      prd_name:='NULL'
    else
      prd_name:=SqlStr(s);

    sql:='INSERT INTO TBL_PO_RECV_DT'
        +' (RCV_NO,RCD_SEQNO,PRD_NO,INV_NO,RCD_PRD_NAME,'
        +' RCD_UNIT_PRICE,RCD_QTY)'
        +' VALUES ('
        +sqlStr(Client_MastRCV_NO.AsString)+','
        +Client_DTRCD_Seqno.AsString+','
        +sqlStr(Client_dtPrd_NO.AsString)+','
        +sqlStr(Client_dtInv_no.AsString)+','
        +Prd_Name+','
        +client_DTRCD_UNIT_Price.AsString+','
        +client_dtRCD_QTY.AsString
        +')';
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
  sql:='INSERT INTO TBL_HIS_PO_RECV '
      +'(HRCV_NO,SUP_NO'
      +',HRCV_INV_NO,HRCV_DATE,HRCV_DESTINATION'
      +',HRCV_TOTAL,HRCV_TAX,EPY_NO'
      +',HRCV_DESC,HRCV_CREATOR) '
      +' VALUES ('
      +sqlStr(Client_Mast.fieldbyname('RCV_NO').AsString)+','
      +sqlStr(Client_Mast.fieldbyname('SUP_NO').AsString)+','
      +sqlStr(Client_Mast.fieldbyname('RCV_INV_NO').AsString)+','
      +sqlDateTimeSql(Client_Mast.fieldbyname('RCV_DATE').AsDateTime)+','
      +sqlStr(Client_Mast.fieldbyname('RCV_DESTINATION').AsString)+','
      +Client_Mast.fieldbyname('RCV_TOTAL').AsString+','
      +CURRTOSTR(Client_Mast.fieldbyname('RCV_TAX').ASCURRENCY)+','
      +sqlStr(Client_Mast.fieldbyname('EPY_NO').AsString)+','
      +sqlStr(Client_Mast.fieldbyname('RCV_DESC').AsString)+','
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
    s:=trim(client_dtRCD_PRD_NAME.Value);
    if s='' then
      prd_name:='NULL'
    else
      prd_name:=SqlStr(s);

    sql:='INSERT INTO TBL_HIS_PO_RECV_DT'
        +' (HRCV_NO,HRCD_SEQNO,PRD_NO,INV_NO,HRCD_PRD_NAME,'
        +' HRCD_UNIT_PRICE,HRCD_QTY)'
        +' VALUES ('
        +sqlStr(Client_MastRCV_NO.AsString)+','
        +Client_DTRCD_Seqno.AsString+','
        +sqlStr(Client_dtPrd_NO.AsString)+','
        +sqlStr(Client_dtInv_no.AsString)+','
        +Prd_Name+','
        +client_DTRCD_UNIT_Price.AsString+','
        +client_dtRCD_QTY.AsString
        +')';
    sysinfo.AdoConnection.Execute(sql);
    client_dt.Next;
  end;
end;
}

procedure Tfm_PoRecv.ActRefreshExecute(Sender: TObject);
begin
  RefreshData;
end;

procedure Tfm_PoRecv.ActSaveExecute(Sender: TObject);
var RCV_no:string;
  t:tdate;
begin
    t:=now;
    ShowTotal;
    ChkDetail;
    Client_MastRCV_Status.Value:=STATUS_UNBOOK;
    if not ModiFlag then
    begin
      Client_Mast.FieldByName('RCV_NO').Value:=GetNumbericCode(sysinfo.AdoConnection,'Tbl_PO_RECV','RCV_NO','yyyymmdd',Client_Mast.fieldbyname('RCV_DATE').Value,4);
      SysDate:=Client_Mast.fieldbyname('RCV_DATE').Value;
    end;
    RCV_no:=Client_Mast.FieldByName('RCV_NO').AsString;

    sysinfo.AdoConnection.BeginTrans;
    try
      if ModiFlag then
      begin
        DeleteDetail(RCV_no);
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

procedure Tfm_PoRecv.Client_dtRCD_PRD_NAMESetText(Sender: TField;
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

procedure Tfm_PoRecv.DeleteDetail(RCV_NO:STRING);
var s:string;
begin
  S:='DELETE TBL_PO_RECV_DT WHERE RCV_NO='+sqlStr(RCV_no);
  sysinfo.AdoConnection.Execute(s);
end;

procedure Tfm_PoRecv.DeleteMaster(RCV_NO:STRING);
var s:string;
begin
  S:='DELETE TBL_PO_RECV WHERE RCV_NO='+sqlStr(RCV_no);
  sysinfo.AdoConnection.Execute(s);
  client_mast.Delete;
end;



procedure Tfm_PoRecv.UpdateMaster;
var sql:string;
begin
  sql:='UPDATE TBL_PO_RECV'
      +' SET SUP_NO='     +sqlStr(Client_Mast.fieldbyname('SUP_NO').AsString)
      +',RCV_STATUS='     +Client_Mast.fieldbyname('RCV_STATUS').AsString
      +',RCV_INV_NO='     +sqlStr(Client_Mast.fieldbyname('RCV_INV_NO').AsString)
      +',RCV_DATE='       +sqlDateTimeSql(Client_Mast.fieldbyname('RCV_DATE').AsDateTime)
      +',RCV_TOTAL='      +Client_Mast.fieldbyname('RCV_TOTAL').AsString
      +',RCV_TAX='        +CURRTOSTR(client_mastrcv_tax.Value)
      +',RCV_DESC='       +sqlStr(Client_Mast.fieldbyname('RCV_DESC').AsString)
      +',RCV_CREATOR='    +sqlStr(sysinfo.LoginUserName)
      +' WHERE RCV_NO='       +sqlStr(Client_Mast.fieldbyname('RCV_NO').AsString);
      sysinfo.AdoConnection.Execute(SQL);

end;


function Tfm_PoRecv.GetNotClean(RCV_NO: string): currency;
var RecvAmount:currency;
  S:STRING;
  qry:TAdoQuery;
begin
  qry:=TAdoQuery.Create(self);
  qry.Connection:=sysinfo.AdoConnection;
  s:='SELECT SUM(PAD_AMOUNT+PAD_DISCOUNT) F1 FROM TBL_AP_PAY_DT WHERE RCV_NO='+SqlStr(RCV_NO);
  qry.SQL.Text:=s;
  try
    qry.Open;
    RecvAmount:=qry.Fields[0].AsCurrency;
  finally
    qry.Close;
    qry.Free;
  end;

  result:=Client_MastC_Amount.Value-RecvAmount;

end;



procedure Tfm_PoRecv.Edit_RCV_TaxButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
begin
  if (Client_Mast.State<>dsEdit) and (Client_Mast.State<>dsInsert) then exit;
    Client_MastRCV_Tax.Value:=Client_MastRCV_Total.AsCurrency*sysinfo.SPR_TAX_Rate;
end;
procedure Tfm_PoRecv.Client_dtBeforePost(DataSet: TDataSet);
begin
  Client_dtINV_NO.Value:=Default_Inv;
end;


procedure Tfm_PoRecv.InsertInv_Transaction;
var PRD_IS_DUMMY:boolean;
    PRD_DUM_COST_RATE:SINGLE;
begin
  client_dt.First;
  while not client_dt.Eof do
  begin
    GetDummyPrd(sysinfo,Client_DTPRD_NO.AsString,PRD_IS_DUMMY,PRD_DUM_COST_RATE);
    if not PRD_IS_DUMMY then
      InsertTransaction(sysinfo,Client_DTPRD_NO.AsString
                               ,Client_DTINV_NO.AsString
                               ,Trn_RCV
                               ,client_MastRCV_NO.AsString
                               ,client_dtRCD_SEQNO.AsString
                               ,client_MastRCV_Date.Value
                               ,client_dtRCD_Qty.Value
                               ,Client_dtRCD_UNIT_PRICE.Value);
    client_dt.Next;
  end;


end;


procedure Tfm_PoRecv.DeleteInv_Transaction(RCV_no:string);
var s:string;
begin
  s:='DELETE TBL_TRANSACTION WHERE '
    +' TRN_TYPE='+inttostr(Trn_RCV)
    +' AND TRN_SRC_NO=' +sqlstr(RCV_no);
  sysinfo.AdoConnection.Execute(s);
  CLIENT_DT.First;
  WHILE NOT CLIENT_DT.Eof DO
  BEGIN
    UpdateTransaction(sysinfo,client_dtPRD_NO.AsString
                              ,client_MastRCV_Date.Value);
    CLIENT_DT.Next;
  END;

end;


procedure Tfm_PoRecv.SetupQueryForm;
var fld:PQueryField;
begin
  WhereList:=TList.Create;
  OrderList:=TList.Create;

  NewQueryFld(fld);
  fld.FieldName   :=  'RCV_DATE';
  fld.DispName    :='交易日期';
  fld.TableAlias  :='M';
  fld.DataType    :=wdDate;
  fld.CtrlType    :=wcDate;
  fld.QueryType   :=wqRange;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'RCV_NO';
  fld.DispName    :='憑證編號';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'SUP_NO';
  fld.DispName    :='廠商編號';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcSQL;
  fld.QueryType   :=wqSingle;
  fld.ListSql:='SELECT SUP_NO,SUP_NAME FROM TBL_SUPPLIER';
  FLD.ListReturnField:='SUP_NO';
  fld.ListFieldDisp:='廠商編號,廠商名稱';
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'RCV_INV_NO';
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

procedure Tfm_PoRecv.ActQueryExecute(Sender: TObject);
var n:integer;
begin
  n:=fm_qry.ShowModal;
  if n=mrCancel then
    exit;
  sqlWhere:=Fm_qry.sqlWhere;      //取得 SQLWher  字串
  SQLOrder:=fm_qry.sqlOrder;      //取得 SQLOrder 字串
  RefreshData;

end;


procedure Tfm_PoRecv.hint(msg: string);
begin
  lblStatus.Caption:=msg;
end;

procedure Tfm_PoRecv.Edit_RCV_TaxDblClick(Sender: TObject);
begin
Edit_RCV_TaxButtonClick(Edit_RCV_Tax,0);
end;

procedure Tfm_PoRecv.ActBrowseExecute(Sender: TObject);
var fm:TFM_PoRecv_Browse;
begin
  fm:=TFM_PoRecv_Browse.Create(application);
  fm.ds_mast:=ds_Master;
  fm.ds_detail:=ds_Client_dt;
  fm.init;
  try
    fm.ShowModal;
  finally
    fm.Free;
  end;

end;

procedure Tfm_PoRecv.ActDeleteExecute(Sender: TObject);
var RCV_no:string;
  st:integer;
  SQL:STRING;
begin
  IF Client_Mast.fieldbyname('RCV_Not_Clean').AsCurrency<>Client_MastC_Amount.AsCurrency then
  BEGIN
    MSG('此單據已有收款記錄 , 禁止刪除 !');
    exit;
  end;
  if MessageDlg('是否確定刪除 ?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;

  RCV_no:=Client_Mast.FieldByName('RCV_NO').AsString;
  st:=ChkStatusModified(rcv_no,Client_MastRCV_STATUS.AsInteger);
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
    sql:='UPDATE TBL_PO_RECV '
      +' SET RCV_STATUS='+INTTOSTR(STATUS_WILL_DELETE)
      +' WHERE RCV_NO='+sqlStr(RCV_no);
    sysinfo.AdoConnection.Execute(sql);
    DeleteInv_Transaction(RCV_no);
    DeleteDetail(RCV_no);
    DeleteMaster(RCV_no);
    sysinfo.AdoConnection.CommitTrans;
  except
    sysinfo.AdoConnection.RollbackTrans;
    raise;
  end;

end;

procedure Tfm_PoRecv.ActBookExecute(Sender: TObject);
var RCV_no,s:string;
  t:tdate;
  year:integer;
  not_clean:currency;
  st:integer;
begin
  RCV_no:=Client_Mast.FieldByName('RCV_NO').AsString;
  st:=ChkStatusModified(rcv_no,Client_MastRCV_STATUS.AsInteger);
  if st=1 then begin
    Msg('單據狀態已被更改 !');
    RefreshData;
    exit;
  end else if st=2 then begin
    Msg('單據已被刪除 !');
    RefreshData;
    exit;
  end;

  year:= yearof(Client_MastRCV_DATE.Value);
  if year < sysinfo.SPR_ACNT_YEAR then
    Errmsg ('不得修改小於本會計年度的傳票 !',user);

  t:=now;
  screen.Cursor:=crSQLWait;
  try

    sysinfo.AdoConnection.BeginTrans;
    try
      s:='UPDATE TBL_PO_RECV'
        +' SET RCV_STATUS='+INTTOSTR(STATUS_confirm)
          +' WHERE RCV_NO='+sqlStr(RCV_no);
      sysinfo.AdoConnection.Execute(s);
      InsertInv_Transaction;
      not_clean:=GetNotClean(RCV_no);
      s:='UPDATE TBL_PO_RECV'
        +' SET RCV_NOT_CLEAN='+CURRTOSTR(NOT_CLEAN)
          +' WHERE RCV_NO='+sqlStr(RCV_no);
      sysinfo.AdoConnection.Execute(s);
      InsertAccount;
      client_mast.Edit;
      CLIENT_MASTJNL_NO.Value:=TblLookup(sysinfo.AdoConnection,'TBL_PO_RECV','RCV_NO',RCV_NO,'JNL_NO');

      Client_MastRCV_NOT_CLEAN.Value:=NOT_clean;
      client_mastRCV_Status.Value:=STATUS_Confirm;
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

procedure Tfm_PoRecv.ActUnBookExecute(Sender: TObject);
var RCV_no,sql:string;
  t:tdate;
  jnl_no:string;
  year,st:integer;
begin
  RCV_no:=Client_Mast.FieldByName('RCV_NO').AsString;
  st:=ChkStatusModified(rcv_no,Client_MastRCV_STATUS.AsInteger);
  if st=1 then begin
    Msg('單據狀態已被更改 !');
    RefreshData;
    exit;
  end else if st=2 then begin
    Msg('單據已被刪除 !');
    RefreshData;
    exit;
  end;

  year:= yearof(Client_MastRCV_DATE.Value);
  if year < sysinfo.SPR_ACNT_YEAR then
    Errmsg ('不得修改小於本會計年度的傳票 !',user);
    
  t:=now;
  IF Chk_Ar_Received(RCV_no) then
  BEGIN
    MSG('此單據已有收款記錄 , 禁止取消確認 !');
    exit;
  end;

  screen.Cursor:=crSQLWait;
  try
    sysinfo.AdoConnection.BeginTrans;
    try
      sql:='UPDATE TBL_PO_RECV '
        +' SET RCV_STATUS='+INTTOSTR(STATUS_UNBOOK)
        +',JNL_NO=NULL'
        +' WHERE RCV_NO='+sqlStr(RCV_no);
      sysinfo.AdoConnection.Execute(sql);
      DeleteInv_Transaction(RCV_no);
      client_mast.Edit;
      client_mastRCV_Status.Value:=STATUS_UNBOOK;
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

procedure Tfm_PoRecv.ActHistoryExecute(Sender: TObject);
var fm:TFM_PoRecv_History;
  s:string;
begin
  fm:=TFM_PoRecv_History.Create(application);
  fm.sysinfo:=sysinfo;
  try
//    fm.Client_Mast.AfterScroll:=nil;
    s:='SELECT 1 CLS,HRCV_NO, SUP_NO ,0 HRCV_NOT_CLEAN'
      +', HRCV_INV_NO, HRCV_DATE'
      +', HRCV_TOTAL, HRCV_TAX'
      +', HRCV_DESC, HRCV_CREATOR'
      +' FROM TBL_HIS_PO_RECV'
      +' WHERE SUP_NO='+sqlstr(client_mastSUP_NO.AsString)
      +' UNION'
      +' SELECT 2, RCV_NO, SUP_NO ,RCV_NOT_CLEAN'
      +', RCV_INV_NO, RCV_DATE'
      +', RCV_TOTAL, RCV_TAX'
      +', RCV_DESC, RCV_CREATOR'
      +' FROM TBL_PO_RECV'
      +' WHERE SUP_NO='+sqlstr(client_mastSUP_NO.AsString)
      +' ORDER BY HRCV_DATE,HRCV_NO';
    DoQrySelect(s,sysinfo.AdoConnection,fm.Client_Mast);
    fm.Client_Mast.Open;
    fm.ShowModal;
  finally
    fm.Free;
  end;


end;

procedure Tfm_PoRecv.Client_MastRCV_NOT_CLEANGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
if client_mastRCV_Status.Value=Status_UnBook then
  text:='單據未確認'
else
  text:=sender.AsString;
end;

procedure Tfm_PoRecv.Client_MastRCV_DATEValidate(Sender: TField);
begin
  IF SENDER.AsDateTime<sysinfo.SPR_PERIOD_START THEN
    ErrMsg('交易日期不得小於(交易期間起始日期)'
            +#13#13'交易期間起始日期 ='+Datetostr(sysinfo.SPR_PERIOD_START),user);
end;

procedure Tfm_PoRecv.gridCustomDraw(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxDBTreeListColumn;
  const AText: String; AFont: TFont; var AColor: TColor; ASelected,
  AFocused: Boolean; var ADone: Boolean);
var n:integer;
begin
  n:=grid.ColumnByFieldName('RCD_QTY').Index;
  if varisnull(ANode.Values[n]) then exit;
  if ANode.Values[n]<0 then
  begin
    AColor:=clYellow;
    Afont.Color:=clRed;
  end;

end;

procedure Tfm_PoRecv.ActFunctionExecute(Sender: TObject);
var p:TPoint;
begin
  p.X:=BtnFunc.Left;
  p.Y:=BtnFunc.Top;
  p:=BtnFunc.ClientToScreen(point(0,0));
  MenuFunc.Popup(p.X,p.Y);
end;

procedure Tfm_PoRecv.ActQuickCollectExecute(Sender: TObject);
var fm:Tfm_porecv_QuickPay;
    PAY_NO,SUP_NO,RCV_NO:string;
    desc:string;
begin
  if Client_MastRCV_Not_Clean.AsCurrency=0 then begin
    msg('此單據帳款已結清 !');
    exit;
  end;
  fm:=Tfm_porecv_QuickPay.Create(self);
  fm.dsMast:=ds_Master;
  fm.init;
  try
    fm.dt_Date.Date:=trunc(client_mastRCV_Date.Value);
    if fm.ShowModal<>mrok then exit;
    PAY_NO:=GetNumbericCode(sysinfo.AdoConnection,'Tbl_AP_PAY','PAY_NO','yyyymmdd',fm.PAY_Date,4);
    SUP_NO:=CLIENT_mastSUP_NO.Value;
    RCV_NO:=CLIENT_MASTRCV_NO.Value;
    sysinfo.AdoConnection.BeginTrans;
    desc:='系統傳輸 -- 快速付款作業 '+Client_MastC_SUP_NAME.Value+'(憑證編號:'+pay_no+')';
    try
      Insert_AP_PAY(sysinfo,PAY_NO,SUP_no,fm.PAY_Date,fm.cash,fm.check,0,0,'快速收付款',sysinfo.LoginUserName);
      Insert_AP_PAY_DT(sysinfo,PAY_NO,1,RCV_NO,FM.cash+FM.check,FM.discount);
      UpdateAPNotClean(sysinfo,RCV_NO);
      ApPayToAccount(sysinfo,pay_no
                                ,sup_no
                                ,fm.PAY_Date
                                ,desc
                                ,fm.cash
                                ,fm.check
                                ,fm.discount
                                ,0,0);
      CLIENT_MAST.Edit;
      Client_MastRCV_NOT_CLEAN.Value:=GetNotClean(RCV_no);
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

procedure Tfm_PoRecv.Client_dtPRD_NOGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  text:=sender.AsString;

end;

function Tfm_PoRecv.Chk_AR_Received(RCV_NO: string): boolean;
var N:INTEGER;
begin
  N:=TblLookup(sysinfo.AdoConnection,'TBL_AP_PAY_DT','RCV_NO',RCV_NO,'COUNT(*)');
  RESULT:=(N>0);

end;

procedure Tfm_PoRecv.ActPrintExecute(Sender: TObject);
var fm:TFM_PoRecv_Print;
    mr:TModalResult;
    where,rpt:string;
begin
  fm:=TFM_PoRecv_Print.Create(application);
  try
    mr:=fm.ShowModal;
    case fm.RadioFormat.ItemIndex of
      0 :rpt:='ZZ_FM_PO_RECV_RPT01';
      1 :rpt:='ZZ_FM_PO_RECV_RPT02';
      2 :rpt:='ZZ_FM_PO_RECV_RPT03';
      3 :rpt:='ZZ_FM_PO_RECV_RPT04';
    end;
    case fm.RadioScope.ItemIndex of
      0:  where :='M.RCV_NO='+sqlStr(Client_mastRCV_NO.AsString);
      1:  where:=sqlWhere;
    end;

    case mr of
      MrPreview : PrintFormReport(sysinfo.AdoConnection,rpt,SQlWhere,SQLOrder,MrPreview);
      MrPrint   : PrintFormReport(sysinfo.AdoConnection,rpt,SQlWhere,SQLOrder,MrPrint);
    end;
  finally
    fm.Free;
  end;

end;

procedure Tfm_PoRecv.InsertAccount;
var sale_revenue,sale_return,sale_discount:currency;
    qty,unit_price,subtotal,tax:currency;
    jnl_no:string;
    sup_acnt_ap:string;
    sql:string;
    desc:string;
begin
  sale_revenue:=0;
  sale_return:=0;
  sale_discount:=0;
  client_dt.First;
  while not client_dt.Eof do begin
    qty := Client_dtRCD_QTY.Value;
    unit_price:=Client_dtRCD_UNIT_PRICE.Value;
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
  desc:='傳輸進退貨作業:'+Client_MastC_SUP_NAME.AsString+' :'+Client_MastRCV_NO.AsString;
  jnl_no:=GetNumbericCode(sysinfo.AdoConnection,'Tbl_ACNT_JOURNAL','JNL_NO','yyyymmdd',Client_MastRCV_DATE.Value,4);
  sql:='INSERT INTO TBL_ACNT_JOURNAL '
      +'(JNL_NO'
      +',JNL_DATE'
      +',JNL_DESC'
      +',JNL_BILL_TYPE'
      +',JNL_CREATOR) '
      +' VALUES ('
      +sqlStr(jnl_no)+','
      +sqlDateTimeSql(Client_MastRCV_DATE.Value)+','
      +sqlStr(desc)+','
      +'1,'
      +sqlStr(sysinfo.LoginUserName)+')';
  sysinfo.AdoConnection.Execute(SQL);


    desc:='進貨:'+Client_MastRCV_NO.AsString+':'+Client_MastC_SUP_NAME.AsString;
{=====================================================================
  會計明細  -- 進貨
=======================================================================}
    sql:='INSERT INTO TBL_ACNT_JOURNAL_DT'
        +' (JNL_NO,JND_SEQNO,ACT_NO,'
        +' JND_AMOUNT,JND_DESC)'
        +' VALUES ('
        +sqlStr(jnl_no)+','
        +'1,'
        +sqlStr(sysinfo.SPR_ACNT_PURCHASE)+','
        +currtostr(sale_revenue)+','
        +sqlStr(desc)
        +')';
    sysinfo.AdoConnection.Execute(sql);


{=====================================================================
  會計明細  -- 進項稅額
=======================================================================}
    tax:=Client_MastRCV_TAX.AsCurrency;
    if tax <> 0 then begin
      sql:='INSERT INTO TBL_ACNT_JOURNAL_DT'
          +' (JNL_NO,JND_SEQNO,ACT_NO,'
          +' JND_AMOUNT,JND_DESC)'
          +' VALUES ('
          +sqlStr(jnl_no)+','
          +'2,'
          +sqlStr(sysinfo.SPR_ACNT_PUR_TAX)+','
          +currtostr(tax)+','
          +sqlStr(desc)
          +')';
      sysinfo.AdoConnection.Execute(sql);
    end;

{=====================================================================
  會計明細  -- 進貨退回
=======================================================================}
    if sale_return <> 0 then begin
      sql:='INSERT INTO TBL_ACNT_JOURNAL_DT'
          +' (JNL_NO,JND_SEQNO,ACT_NO,'
          +' JND_AMOUNT,JND_DESC)'
          +' VALUES ('
          +sqlStr(jnl_no)+','
          +'3,'
          +sqlStr(sysinfo.SPR_ACNT_PUR_RETURN)+','
          +currtostr(sale_return)+','
          +sqlStr(desc)
          +')';
      sysinfo.AdoConnection.Execute(sql);
    end;

{=====================================================================
  會計明細  -- 進貨折讓
=======================================================================}
    if sale_discount <> 0 then begin
      sql:='INSERT INTO TBL_ACNT_JOURNAL_DT'
          +' (JNL_NO,JND_SEQNO,ACT_NO,'
          +' JND_AMOUNT,JND_DESC)'
          +' VALUES ('
          +sqlStr(jnl_no)+','
          +'4,'
          +sqlStr( sysinfo.SPR_ACNT_PUR_DISCOUNT)+','
          +currtostr(sale_discount)+','
          +sqlStr(desc)
          +')';
      sysinfo.AdoConnection.Execute(sql);
    end;

{=====================================================================
  會計明細  -- 應付帳款
=======================================================================}
    sup_acnt_ap:=vartostr(TblLookup(sysinfo.AdoConnection,'TBL_SUPPLIER','SUP_NO',Client_MastSUP_NO.AsString,'SUP_ACNT_AP'));

    sql:='INSERT INTO TBL_ACNT_JOURNAL_DT'
        +' (JNL_NO,JND_SEQNO,ACT_NO,'
        +' JND_AMOUNT,JND_DESC)'
        +' VALUES ('
        +sqlStr(jnl_no)+','
        +'5,'
        +sqlStr(sup_acnt_ap)+','
        +currtostr(-Client_MastC_AMOUNT.Value)+','
        +sqlStr(desc)
        +')';
    sysinfo.AdoConnection.Execute(sql);



{=====================================================================
  update TBL_SHIP.JNL_NO
=======================================================================}
      sql:='UPDATE TBL_PO_RECV'
        +' SET JNL_NO='+sqlstr(jnl_no)
          +' WHERE RCV_NO='+sqlStr(Client_MastRCV_NO.Value);
      sysinfo.AdoConnection.Execute(sql);

  ChkDCBalance(sysinfo,JNL_NO);
end;

function Tfm_PoRecv.ChkStatusModified(rcv_no: string;old_st:integer): integer;
var v:variant;
begin
  v:=TblLookup(sysinfo.AdoConnection,'TBL_PO_RECV','RCV_NO',RCV_NO,'RCV_STATUS');
  if varisnull (v) then
    result:=2     // bill was deleted
  else if v=old_st then
    result:=0
  else
    result:=1;

end;



procedure Tfm_PoRecv.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  
  if (Client_Mast.State=dsInsert)
  or (Client_Mast.State=dsEdit) then
  begin
    CanClose:=false;
    show;
    msg('在新增或修改模式，不能結束作業 ！');
  end else begin
    CanClose:=True;
  end;


end;

end.

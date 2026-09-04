unit FORM_AP_PAY;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxDBCtrl, dxDBGrid, dxDBTLCl, dxGrClms, dxTL, dxCntner,
  StdCtrls, ImgList, ActnList, Mask, DBCtrls, Buttons, dxEditor, dxExEdtr,
  dxEdLib, dxDBELib, wwdbdatetimepicker, ExtCtrls, DB, Provider, ADODB,
  DBClient, Form_Query,FmtBcd,DateUtils,FORM_ERP_BASE,erp_public;

type
  TFM_AP_PAY = class(TForm_ERP)
    pnlMast1: TPanel;
    Label2: TLabel;
    Label5: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Edit_PAY_No: TdxDBEdit;
    dt_PAY_date: TwwDBDateTimePicker;
    Edit_SUP_NO: TdxDBButtonEdit;
    Edit_SUP_Name: TdxDBButtonEdit;
    pnlStatus: TPanel;
    Panel1: TPanel;
    btnPrior: TSpeedButton;
    btnNext: TSpeedButton;
    BtnLast: TSpeedButton;
    btnFirst: TSpeedButton;
    Edit_Rec: TEdit;
    Panel3: TPanel;
    LblStatus: TLabel;
    ActionList1: TActionList;
    ActAppend: TAction;
    ActDelete: TAction;
    ActQuery: TAction;
    ActPrint: TAction;
    ActBrowse: TAction;
    ActFirst: TAction;
    ActLast: TAction;
    ActPrior: TAction;
    ActNext: TAction;
    ActSave: TAction;
    ActAbort: TAction;
    ActRefresh: TAction;
    ImageList1: TImageList;
    pnlCtrl: TPanel;
    BtnAppend: TButton;
    BtnDelete: TButton;
    BtnQuery: TButton;
    BtnPrint: TButton;
    BtnSave: TButton;
    BtnAbort: TButton;
    grid: TdxDBGrid;
    Client_Mast: TClientDataSet;
    Qry_Mast: TADOQuery;
    Qry_DT: TADOQuery;
    Provider_Mast: TDataSetProvider;
    Provider_DT: TDataSetProvider;
    Client_DT: TClientDataSet;
    ds_Client_Mast: TDataSource;
    ds_client_DT: TDataSource;
    Client_MastPAY_NO: TStringField;
    Client_MastSUP_NO: TStringField;
    Client_MastPAY_DATE: TDateTimeField;
    Client_MastPAY_CASH: TBCDField;
    Client_MastPAY_CHECK: TBCDField;
    Client_MastPAY_FROM_ADVANCE: TBCDField;
    Client_MastPAY_TO_ADVANCE: TBCDField;
    Client_MastPAY_DESC: TStringField;
    Client_MastPAY_CREATOR: TStringField;
    Client_MastC_SUP_NAME: TStringField;
    Client_DTPAY_NO: TStringField;
    Client_DTPAD_SEQNO: TBCDField;
    Client_DTRCV_NO: TStringField;
    Client_DTPAD_AMOUNT: TBCDField;
    Client_DTPAD_DISCOUNT: TBCDField;
    Label1: TLabel;
    Edit_PAY_CASH: TDBEdit;
    Label3: TLabel;
    Edit_PAY_Check: TDBEdit;
    Label4: TLabel;
    Edit_PAY_From_Advance: TDBEdit;
    Label6: TLabel;
    Edit_PAY_To_Advance: TDBEdit;
    Label7: TLabel;
    Edit_PAY_Desc: TDBEdit;
    Client_MastC_SUP_ADVANCE_AMOUNT: TCurrencyField;
    Label8: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label9: TLabel;
    lblRevSum: TLabel;
    lblRevBalance: TLabel;
    Button1: TButton;
    Client_DTC_SEQNO: TIntegerField;
    LblC_SUP_ADVANCE_AMOUNT: TDBText;
    Client_MastC_AR_SUM: TCurrencyField;
    DBText1: TDBText;
    LblC_AR_SUM: TDBText;
    Client_DTRCV_DATE: TDateTimeField;
    Client_DTRCV_INV_NO: TStringField;
    Client_DTRCV_AMOUNT: TBCDField;
    Client_DTRCV_NOT_CLEAN: TBCDField;
    gridC_SEQNO: TdxDBGridColumn;
    gridRCV_NO: TdxDBGridMaskColumn;
    gridRCV_DATE: TdxDBGridDateColumn;
    gridRCV_INV_NO: TdxDBGridMaskColumn;
    gridRCV_AMOUNT: TdxDBGridMaskColumn;
    gridRCV_NOT_CLEAN: TdxDBGridMaskColumn;
    gridPAD_AMOUNT: TdxDBGridMaskColumn;
    gridPAD_DISCOUNT: TdxDBGridMaskColumn;
    Button2: TButton;
    ActAutoFillin: TAction;
    Client_DTC_PAD_BALANCE: TCurrencyField;
    gridC_PAD_BALANCE: TdxDBGridColumn;
    Button3: TButton;
    Client_MastJNL_NO: TStringField;
    procedure ActQueryExecute(Sender: TObject);
    procedure Client_MastAfterScroll(DataSet: TDataSet);
    procedure Client_DTCalcFields(DataSet: TDataSet);
    procedure Client_MastCalcFields(DataSet: TDataSet);
    procedure ActFirstExecute(Sender: TObject);
    procedure ActLastExecute(Sender: TObject);
    procedure ActNextExecute(Sender: TObject);
    procedure ActPriorExecute(Sender: TObject);
    procedure Edit_SUP_NOButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure Edit_SUP_NameButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure ActAppendExecute(Sender: TObject);
    procedure ActAbortExecute(Sender: TObject);
    procedure Client_MastSUP_NOValidate(Sender: TField);
    procedure dt_PAY_dateExit(Sender: TObject);
    procedure Client_MastPAY_FROM_ADVANCEValidate(Sender: TField);
    procedure ActAutoFillinExecute(Sender: TObject);
    procedure Client_DTPAD_AMOUNTValidate(Sender: TField);
    procedure ActSaveExecute(Sender: TObject);
    procedure Edit_PAY_CASHExit(Sender: TObject);
    procedure gridEdited(Sender: TObject; Node: TdxTreeListNode);
    procedure ActRefreshExecute(Sender: TObject);
    procedure ActDeleteExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    SQlWhere,SQLOrder:string;
    WhereList,OrderList:TList;
    Fm_Qry:TFM_Query;
    procedure SetupQueryForm;
    procedure RefreshData;
    procedure hint(msg: string);
    procedure SetEditMode(EditFlag: Boolean);
    procedure InsertClientDT;
    procedure UpdateTitle;
    procedure CheckAllValidate;
    procedure SaveMaster;
    procedure SaveDetail;
    procedure DeleteDetail(PAY_NO:STRING);
    procedure DeleteMaster(PAY_NO:STRING);
    procedure InsertAccount;

    { Private declarations }
  public
    PROCEDURE init;override;
    { Public declarations }
  end;


implementation

uses SysReport_Head, RecChoice, Uty, DBUty;

{$R *.dfm}

{ TFM_MAIN }

procedure TFM_AP_PAY.init;
begin
    SetEditMode(false);
    SetupQueryForm;
    SqlWhere:='M.PAY_DATE>='+SqlDateTimeSql(trunc(now)-60);
    SqlOrder:='M.PAY_DATE,M.PAY_NO';
    RefreshData;
    CLIENT_DT.First;
    client_dt.Last;


end;

procedure TFM_AP_PAY.SetupQueryForm;
var fld:PQueryField;
begin
  WhereList:=TList.Create;
  OrderList:=TList.Create;

  NewQueryFld(fld);
  fld.FieldName   :=  'PAY_DATE';
  fld.DispName    :='交易日期';
  fld.TableAlias  :='M';
  fld.DataType    :=wdDate;
  fld.CtrlType    :=wcDate;
  fld.QueryType   :=wqRange;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'PAY_NO';
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
  fld.ListSql:='SELECT SUP_NO,SUP_NAME FROM TBL_Supplier';
  FLD.ListReturnField:='SUP_NO';
  fld.ListFieldDisp:='廠商編號,廠商名稱';
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'RCV_NO';
  fld.DispName    :='沖帳憑證編號';
  fld.TableAlias  :='D';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);



  Fm_Qry:=TFM_Query.Create(self);
  fm_qry.Init(sysinfo.AdoConnection,'','',WhereList,OrderList,query,dbsType);


end;

procedure TFM_AP_PAY.ActQueryExecute(Sender: TObject);
var n:integer;
begin
  n:=fm_qry.ShowModal;
  if n=mrCancel then
    exit;
  sqlWhere:=Fm_qry.sqlWhere;      //取得 SQLWher  字串
  SQLOrder:=fm_qry.sqlOrder;      //取得 SQLOrder 字串
  RefreshData;

end;

procedure TFM_AP_PAY.RefreshData;
var sql,s:string;
    T:TDate;
    P1,p2:TDataSetNotifyEvent;
begin
  screen.Cursor:=crSQLWait;
  P1:=client_mast.AfterScroll;
  P2:=CLIENT_MAST.OnCalcFields;
  Client_mast.AfterScroll:=NIL;
  CLIENT_MAST.OnCalcFields:=NIL;
  TRY
    t:=now;
    Sql:='SELECT DISTINCT M.* FROM TBL_AP_PAY M'+CR
        +' LEFT JOIN TBL_AP_PAY_DT D ON M.PAY_NO=D.PAY_NO '+CR
        + JoinWhere('',SqlWhere)+CR
        + JoinOrder('',SqlOrder);

    if Client_Mast.State<> dsinactive then
      s:=client_Mast.fieldbyname('PAY_NO').AsString;

    DoQrySelect(sql,sysinfo.AdoConnection,Client_Mast);
  FINALLY
    screen.Cursor:=crDefault;
    client_mast.AfterScroll:=p1;
    CLIENT_MAST.OnCalcFields:=P2;
  END;

  if Client_mast.Eof then
  begin
    msg('查無任何資料 !');
  end;
  IF s='' then
    Client_Mast.Last
  else
    Client_Mast.Locate('PAY_NO',S,[]);
  hint(format('查尋時間:%f 秒',[ (now-t)*86400]));

end;

procedure TFM_AP_PAY.hint(msg: string);
begin
  lblStatus.Caption:=msg;
end;

procedure TFM_AP_PAY.SetEditMode(EditFlag: Boolean);
begin
  ds_client_dt.AutoEdit:=EditFlag;
  SetOwnerCtrlReadOnly(self,not EditFlag);
  ActAppend.Enabled:=not EditFlag;
  ActDelete.Enabled:=not EditFlag;
  ActQuery.Enabled:=not EditFlag;
  ActPrint.Enabled:=not EditFlag;
  ActBrowse.Enabled:=not EditFlag;
  ActRefresh.Enabled:=not EditFlag;
  ActFirst.Enabled:=not Editflag;
  ActPrior.Enabled:=not Editflag;
  ActNext.Enabled:=not Editflag;
  ActLast.Enabled:=not Editflag;

  ActAbort.Enabled:= EditFlag;
  ActSave.Enabled:= EditFlag;
  ActAutoFillin.Enabled := EditFlag;
  SetCtrlReadOnly(Edit_PAY_NO,true);
  SetCtrlReadOnly(Edit_Rec,true);
  Edit_SUP_no.Buttons[0].Visible:=EditFlag;
  Edit_SUP_name.Buttons[0].Visible:=EditFlag;

  Client_MastAfterScroll(Client_mast);
  gridC_SEQNO.Color:=       ColrEditDisableBack;
  gridRCV_NO.Color:=        ColrEditDisableBack;
  gridRCV_DATE.Color:=      ColrEditDisableBack;
  gridRCV_NOT_CLEAN.Color:= ColrEditDisableBack;
  gridRCV_INV_NO.Color:=    ColrEditDisableBack;
  gridRCV_AMOUNT.Color:=    ColrEditDisableBack;
  gridRCV_NOT_CLEAN.Color:= ColrEditDisableBack;
  gridC_PAD_BALANCE.Color:= ColrEditDisableBack;


end;


procedure TFM_AP_PAY.Client_MastAfterScroll(DataSet: TDataSet);
var sql:string;
begin
  if Client_Mast.State<>dsBrowse then exit;

  sql:='SELECT A.*,B.RCV_DATE,B.RCV_INV_NO'
      +',B.RCV_TOTAL+RCV_TAX RCV_AMOUNT,B.RCV_NOT_CLEAN'
      +' FROM TBL_AP_PAY_DT A'
      +' INNER JOIN TBL_PO_RECV B ON A.RCV_NO=B.RCV_NO'
      +' WHERE PAY_NO='+SqlStr(Client_MastPAY_NO.AsString);
  DoQrySelect(sql,sysinfo.AdoConnection,Client_DT);

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
  lblRevSum.Caption:='';
  lblRevBalance.Caption:='';
end;

procedure TFM_AP_PAY.Client_DTCalcFields(DataSet: TDataSet);
begin
  client_dtC_SEQNO.Value:=client_dt.RecNo;
  if client_mast.State=dsBrowse then
    Client_DTC_PAD_BALANCE.Value:=Client_DTRCV_NOT_CLEAN.Value
  else
    Client_DTC_PAD_BALANCE.Value:=Client_DTRCV_NOT_CLEAN.Value-(Client_DTPAD_AMOUNT.Value+Client_DTPAD_DISCOUNT.Value);
end;

procedure TFM_AP_PAY.Client_MastCalcFields(DataSet: TDataSet);
VAR s,SUP_NO:STRING;
begin
  SUP_NO:=client_mastSUP_no.Value;
  client_mastC_SUP_Name.Value:=GetSupName(sysinfo,SUP_NO);
  Client_MastC_SUP_ADVANCE_AMOUNT.Value:=vartocurr(TblLookup(sysinfo.AdoConnection,'TBL_Supplier','SUP_NO',SUP_NO,'SUP_ADVANCE_AMOUNT'));
  s:='RCV_DATE<='+sqlDateTimeSQL(CLIENT_MastPAY_DATE.AsDateTime)
    +' AND RCV_STATUS='+INTTOSTR(STATUS_CONFIRM);
//  s1:=datetimetostr(CLIENT_MastPAY_DATE.AsDateTime);
//  label12.Caption:=s1;
  Client_MastC_AR_SUM.Value:=
    vartocurr(TblLookup(sysinfo.AdoConnection,'TBL_PO_RECV','SUP_NO',Client_mastSUP_NO.Value,'SUM(RCV_NOT_CLEAN)',s));
end;

procedure TFM_AP_PAY.ActFirstExecute(Sender: TObject);
begin
  Client_Mast.First;
end;


procedure TFM_AP_PAY.ActLastExecute(Sender: TObject);
begin
Client_Mast.Last;
end;

procedure TFM_AP_PAY.ActPriorExecute(Sender: TObject);
begin
Client_Mast.Prior;
end;

procedure TFM_AP_PAY.ActNextExecute(Sender: TObject);
begin
  Client_Mast.next;
end;

procedure TFM_AP_PAY.Edit_SUP_NOButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var s:string;
begin
  if Client_Mast.State=dsBrowse then exit;
  s:=SelectSupNO(sysinfo);
  if s<>'' then
    Client_Mast.FieldByName('SUP_NO').Value:=s;

end;

procedure TFM_AP_PAY.Edit_SUP_NameButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var s:string;
begin
  if Client_Mast.State=dsBrowse then exit;
  s:=SelectSupName(sysinfo);
  if s<>'' then
    Client_Mast.FieldByName('SUP_NO').Value:=s;

end;

procedure TFM_AP_PAY.ActAppendExecute(Sender: TObject);
begin
  client_dt.Close;
  Client_Mast.Append;
  Client_Mast.fieldbyname('PAY_DATE').Value:=NOW;
  Edit_SUP_no.SetFocus;
  SetEditMode(true);

end;

procedure TFM_AP_PAY.ActAbortExecute(Sender: TObject);
begin
  Client_Mast.Cancel;
  SetEditMode(false);

end;

procedure TFM_AP_PAY.Client_MastSUP_NOValidate(Sender: TField);
begin
  InsertClientDT;
end;

procedure TFM_AP_PAY.InsertClientDT;
var SUP_no:string;
    PAY_Date:TDateTime;
    sql:string;
    N:INTEGER;
    p:TDatasetNotifyEvent;
    qry:TAdoQuery;
begin
  qry:=TAdoQuery.Create(self);
  qry.Connection:=sysinfo.AdoConnection;
  sql:='SELECT A.*,B.RCV_DATE,B.RCV_INV_NO'
      +',B.RCV_TOTAL+RCV_TAX RCV_AMOUNT,B.RCV_NOT_CLEAN'
      +' FROM TBL_AP_PAY_DT A'
      +' INNER JOIN TBL_PO_RECV B ON A.RCV_NO=B.RCV_NO'
      +' WHERE 1=2';

  DoQrySelect(sql,sysinfo.AdoConnection,client_dt);
  CLIENT_DT.FieldByName('RCV_AMOUNT').ReadOnly:=FALSE;
  client_dt.open;
  N:=0;
  SUP_no:=Client_MastSUP_NO.AsString;
  PAY_Date:=dt_PAY_date.Date;
  sql:='SELECT RCV_NO,RCV_DATE,RCV_INV_NO'
      +',RCV_TOTAL+RCV_TAX RCV_AMOUNT,RCV_NOT_CLEAN'
      +' FROM TBL_PO_RECV'
      +' WHERE SUP_NO='+sqlstr(SUP_no)
      +' AND RCV_DATE<='+sqlDateTimeSql(PAY_date)
      +' AND RCV_NOT_CLEAN<>0'
      +' AND RCV_STATUS=1'
      +' ORDER BY RCV_DATE,RCV_NO';
  qry.SQL.TEXT:=SQL;
  qry.Open;
  p:=CLIENT_DT.OnCalcFields;
  CLIENT_DT.OnCalcFields:=nil;
  try
    WHILE not qry.Eof do
    begin
      INC(N);
      client_dt.Append;
      client_dt.FieldByName('PAD_SEQNO').Value:=N;
      client_dt.FieldByName('RCV_NO').Value:=qry.FIELDBYNAME('RCV_NO').Value;
      client_dt.FieldByName('RCV_DATE').Value:=qry.FIELDBYNAME('RCV_DATE').Value;
      client_dt.FieldByName('RCV_INV_NO').Value:=qry.FIELDBYNAME('RCV_INV_NO').Value;
      client_dt.FieldByName('RCV_AMOUNT').Value:=qry.FIELDBYNAME('RCV_AMOUNT').Value;
      client_dt.FieldByName('RCV_NOT_CLEAN').Value:=qry.FIELDBYNAME('RCV_NOT_CLEAN').Value;
      CLIENT_DT.Post;
      qry.Next;
    end;
  finally
    CLIENT_DT.OnCalcFields:=p;
    qry.Close;
    qry.free;
  end;
  CLIENT_DT.First;

end;

procedure TFM_AP_PAY.dt_PAY_dateExit(Sender: TObject);
begin
if client_mast.State=dsInsert then
  InsertClientDT;

end;

procedure TFM_AP_PAY.UpdateTitle;
var c,RevSUM,RevBalance:currency;
    bm: TBookmark;
    p:TDatasetNotifyEvent;
begin

  revSum:=client_mastPAY_CASH.Value
         +client_MastPAY_Check.Value
         +Client_MastPAY_FROM_ADVANCE.Value
         -Client_MastPAY_TO_ADVANCE.Value;
  bm:=client_dt.GetBookmark;
  client_dt.DisableControls;
  p:=CLIENT_DT.OnCalcFields;
  CLIENT_DT.OnCalcFields:=nil;
  try
    client_dt.First;
    c:=0;
    while not client_dt.Eof do
    begin
      c:=c+Client_DTPAD_AMOUNT.Value;
      client_dt.Next;
    end;
  finally
    CLIENT_DT.OnCalcFields:=p;
    client_dt.EnableControls;
    client_dt.GotoBookmark(bm);
    client_dt.FreeBookmark(bm);
  end;

  revBalance:=revSum-c;
  lblRevSum.Caption:=currtostr(revSum);
  lblRevBalance.Caption:=currtostr(revBalance);


end;

procedure TFM_AP_PAY.Client_MastPAY_FROM_ADVANCEValidate(Sender: TField);
begin
  if sender.AsCurrency>Client_MastC_SUP_ADVANCE_AMOUNT.AsCurrency then
    errmsg('預付款額度不足 !',user);
  UpdateTitle;

end;

procedure TFM_AP_PAY.ActAutoFillinExecute(Sender: TObject);
var revSum:currency;
    p:TDatasetNotifyEvent;
    p1:TFieldNotifyEvent;
begin
  try
    revSum:=strtocurr(lblRevSum.Caption);
  except
    revSum:=0;
  end;
  client_dt.DisableControls;
  p:=CLIENT_DT.OnCalcFields;
  p1:=Client_DTPAD_AMOUNT.OnValidate;
  Client_DTPAD_AMOUNT.OnValidate:=nil;
  Client_DTPAD_discount.OnValidate:=nil;
  CLIENT_DT.OnCalcFields:=nil;
  try
    client_dt.First;
    while not client_dt.Eof do
    begin
      client_dt.Edit;
      Client_DTPAD_DISCOUNT.Value:=0;
      if revSum>=Client_DTRCV_NOT_CLEAN.Value then
      begin
        Client_DTPAD_AMOUNT.Value:=Client_DTRCV_NOT_CLEAN.Value;
        revSum:=revSum-Client_DTRCV_NOT_CLEAN.Value;
      end else
      begin
        Client_DTPAD_AMOUNT.Value:=revSum;
        revSum:=0;
      end;
      client_dt.post;
      client_dt.Next;
    end;
  finally
    Client_DTPAD_AMOUNT.OnValidate:=p1;
    CLIENT_DT.OnCalcFields:=p;
    client_dt.EnableControls;
  end;
  UpdateTitle;
  if revSum>0 then
    msg('沖帳金額太多 !');


end;

procedure TFM_AP_PAY.Client_DTPAD_AMOUNTValidate(Sender: TField);
begin
  if Client_DTRCV_NOT_CLEAN.Value>0 then
  begin
    if (Client_DTPAD_AMOUNT.Value+Client_DTPAD_DISCOUNT.Value)
        >Client_DTRCV_NOT_CLEAN.Value then
      Msg('沖帳金額過多 !');
  end else
  begin
    if (Client_DTPAD_AMOUNT.Value+Client_DTPAD_DISCOUNT.Value)
        <Client_DTRCV_NOT_CLEAN.Value then
      Msg('沖帳金額過多 !');
  end;


end;

procedure TFM_AP_PAY.CheckAllValidate;
var revSum:currency;
begin
  try
    revSum:=strtocurr(lblRevBalance.Caption);
  except
    revSum:=0;
  end;
  if revSum<>0 then
    ErrMsg('尚有可沖帳餘額 !',user);
  client_dt.First;
  while not client_dt.Eof do
  begin
    if Client_DTRCV_NOT_CLEAN.Value>0 then
    begin
      if (Client_DTPAD_AMOUNT.Value+Client_DTPAD_DISCOUNT.Value)
          >Client_DTRCV_NOT_CLEAN.Value then
        ErrMsg('單據沖帳金額過多 !',user);
    end else
    begin
      if (Client_DTPAD_AMOUNT.Value+Client_DTPAD_DISCOUNT.Value)
          <Client_DTRCV_NOT_CLEAN.Value then
        ErrMsg('單據沖帳金額過多 !',User);
    end;
    client_dt.Next;
  end;

end;

procedure TFM_AP_PAY.ActSaveExecute(Sender: TObject);
var t:tdate;
  year:integer;
begin
  year:= yearof(Client_MastPAY_DATE.Value);
  if year < sysinfo.SPR_ACNT_YEAR then
    Errmsg ('交易日期不得小於本會計年度 !',user);

    CheckAllValidate;
    t:=now;
    Client_Mast.FieldByName('PAY_NO').Value:=GetNumbericCode(sysinfo.AdoConnection,'Tbl_AP_PAY','PAY_NO','yyyymmdd',Client_Mast.fieldbyname('PAY_DATE').Value,4);
    sysinfo.AdoConnection.BeginTrans;
    try
      SaveMaster;
      SaveDetail;
      InsertAccount;      
      sysinfo.AdoConnection.CommitTrans;
    except
      sysinfo.AdoConnection.RollbackTrans;
      raise;
    end;
    Client_Mast.Post;
    RefreshData;
    
    SetEditMode(false);
    hint(format('儲存時間:%f 秒',[ (now-t)*86400]));

end;

procedure TFM_AP_PAY.Edit_PAY_CASHExit(Sender: TObject);
begin
  UpdateTitle;
end;

procedure TFM_AP_PAY.gridEdited(Sender: TObject; Node: TdxTreeListNode);
begin
  UpdateTitle;
end;

procedure TFM_AP_PAY.ActRefreshExecute(Sender: TObject);
begin
  RefreshData;
end;

procedure TFM_AP_PAY.SaveDetail;
VAR RCV_no:STRING;
  amount,discount:currency;
begin
  client_dt.First;
  while not client_dt.Eof do
  begin
    amount:=Client_DT.fieldbyname('PAD_AMOUNT').AsCurrency;
    discount:=Client_DT.fieldbyname('PAD_DISCOUNT').AsCurrency;
    RCV_no:=Client_DT.fieldbyname('RCV_NO').AsString;
    if  (amount<>0)or (discount<>0) then
    begin
      Insert_AP_PAY_DT(sysinfo,Client_Mast.FieldByName('PAY_NO').AsString
                                   ,Client_DT.FieldByName('PAD_SEQNO').AsInteger
                                   ,Client_DT.FieldByName('RCV_NO').AsString
                                   ,Client_DT.FieldByName('PAD_AMOUNT').AsCurrency
                                   ,Client_DT.FieldByName('PAD_DISCOUNT').AsCurrency
                                   );
      UpdateAPNotClean(sysinfo,RCV_no);
    end;
    client_dt.Next;
  end;

end;

procedure TFM_AP_PAY.SaveMaster;
var SUP_no:string;
begin
  SUP_no:=Client_Mast.FieldByName('SUP_NO').AsString;
  Insert_AP_PAY(sysinfo,Client_Mast.FieldByName('PAY_NO').AsString
                            ,Client_Mast.FieldByName('SUP_NO').AsString
                            ,Client_Mast.FieldByName('PAY_DATE').AsDateTime
                            ,Client_Mast.FieldByName('PAY_CASH').AsCurrency
                            ,Client_Mast.FieldByName('PAY_CHECK').AsCurrency
                            ,Client_Mast.FieldByName('PAY_FROM_ADVANCE').AsCurrency
                            ,Client_Mast.FieldByName('PAY_TO_ADVANCE').AsCurrency
                            ,Client_Mast.FieldByName('PAY_DESC').AsString
                            ,Client_Mast.FieldByName('PAY_CREATOR').AsString
                            );
  UpdateSUP_Advance_Amount(sysinfo,SUP_no);
end;

procedure TFM_AP_PAY.ActDeleteExecute(Sender: TObject);
VAR PAY_NO:string;
    jnl_no:string;
    year:integer;
    sql:string;
begin
  year:= yearof(Client_MastPAY_DATE.Value);
  if year < sysinfo.SPR_ACNT_YEAR then
    Errmsg ('不得刪除小於本會計年度的傳票 !',user);


  if MessageDlg('是否確定刪除 ?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;

  PAY_NO:=Client_Mast.FieldByName('PAY_NO').AsString;
  jnl_no:=Client_MastJNL_NO.Value;
  sysinfo.AdoConnection.BeginTrans;
  try
    DeleteDetail(PAY_NO);
    DeleteMaster(PAY_NO);
    sql:='DELETE TBL_ACNT_JOURNAL_DT WHERE JNL_NO='+sqlstr(jnl_no);
    sysinfo.AdoConnection.Execute(sql);
    sql:='DELETE TBL_ACNT_JOURNAL WHERE JNL_NO='+sqlstr(jnl_no);
    sysinfo.AdoConnection.Execute(sql);
    sysinfo.AdoConnection.CommitTrans;
  except
    sysinfo.AdoConnection.RollbackTrans;
    raise;
  end;


end;

procedure TFM_AP_PAY.DeleteDetail(PAY_NO:STRING);
var s,RCV_NO:string;
begin
  S:='DELETE TBL_AP_PAY_DT WHERE PAY_NO='
    +sqlStr(PAY_NO);
  sysinfo.AdoConnection.Execute(s);

  client_dt.First;
  while not client_dt.Eof do
  begin
    RCV_NO:=Client_DT.fieldbyname('RCV_NO').AsString;
    UpdateAPNotClean(sysinfo,RCV_no);
    client_dt.Next;
  end;
end;

procedure TFM_AP_PAY.DeleteMaster(PAY_NO:STRING);
var s,SUP_no:string;
begin
  SUP_NO:=Client_Mast.FieldByName('SUP_NO').AsString;
  S:='DELETE TBL_AP_PAY WHERE PAY_NO='
    +sqlStr(PAY_NO);
  sysinfo.AdoConnection.Execute(s);
  UpdateSUP_Advance_Amount(sysinfo,SUP_NO);
  client_mast.Delete;
end;

procedure TFM_AP_PAY.InsertAccount;
var acnt_cash,acnt_check:currency;
    acnt_from_advance,acnt_to_advance:currency;
    acnt_discount:currency;
    sup_acnt_advance:string;  //客戶預收款科目
    sup_acnt_ap:string;       //應收帳款科目
    desc:string;
begin
  acnt_discount:=0;
  Client_DT.First;
  while not Client_DT.Eof do begin
    acnt_discount:=acnt_discount+Client_DTPAD_DISCOUNT.Value;
    Client_DT.Next;
  end;
  acnt_cash:=Client_MastPAY_CASH.Value;
  acnt_check:=Client_MastPAY_CHECK.Value;
  acnt_from_advance:=Client_MastPAY_FROM_ADVANCE.Value;
  acnt_to_advance:=Client_MastPAY_TO_ADVANCE.Value;

  sup_acnt_advance:=vartostr(TblLookup(sysinfo.AdoConnection,'TBL_SUPPLIER','SUP_NO',Client_MastSUP_NO.Value,'SUP_ACNT_ADVANCE'));
  sup_acnt_ap:=vartostr(TblLookup(sysinfo.AdoConnection,'TBL_SUPPLIER','SUP_NO',Client_MastSUP_NO.Value,'SUP_ACNT_AP'));
  desc:='系統傳輸 -- 付款作業 '+Client_MastC_SUP_NAME.Value+'(憑證編號:'+Client_MastPAY_NO.Value+')';
  ApPayToAccount(sysinfo,Client_MastPAY_NO.AsString
                            ,Client_MastSUP_NO.AsString
                            ,Client_MastPAY_DATE.Value
                            ,desc
                            ,acnt_cash
                            ,acnt_check
                            ,acnt_discount
                            ,acnt_from_advance
                            ,acnt_to_advance);
end;


procedure TFM_AP_PAY.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose:=TRUE;
  if (Client_mast.State=dsInsert)
  or (Client_mast.State=dsEdit) then
  begin
    msg('在編輯模式下，不能結束作業 ！');
    CanClose:=false;
  end;

end;

end.

unit form_ar_recv;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxDBCtrl, dxDBGrid, dxDBTLCl, dxGrClms, dxTL, dxCntner,
  StdCtrls, ImgList, ActnList, Mask, DBCtrls, Buttons, dxEditor, dxExEdtr,
  dxEdLib, dxDBELib, wwdbdatetimepicker, ExtCtrls, DB, Provider, ADODB,
  DBClient, Form_Query,FmtBcd,DateUtils,erp_public,FORM_ERP_BASE;

type
  Tfm_ar_recv = class(TForm_ERP)
    pnlMast1: TPanel;
    Label2: TLabel;
    Label5: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Edit_ARR_No: TdxDBEdit;
    dt_Arr_date: TwwDBDateTimePicker;
    Edit_Cum_NO: TdxDBButtonEdit;
    Edit_Cum_Name: TdxDBButtonEdit;
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
    Client_MastARR_NO: TStringField;
    Client_MastCUM_NO: TStringField;
    Client_MastARR_DATE: TDateTimeField;
    Client_MastARR_CASH: TBCDField;
    Client_MastARR_CHECK: TBCDField;
    Client_MastARR_FROM_ADVANCE: TBCDField;
    Client_MastARR_TO_ADVANCE: TBCDField;
    Client_MastARR_DESC: TStringField;
    Client_MastARR_CREATOR: TStringField;
    Client_MastC_CUM_NAME: TStringField;
    Client_DTARR_NO: TStringField;
    Client_DTARD_SEQNO: TBCDField;
    Client_DTSMT_NO: TStringField;
    Client_DTARD_AMOUNT: TBCDField;
    Client_DTARD_DISCOUNT: TBCDField;
    Label1: TLabel;
    Edit_Arr_CASH: TDBEdit;
    Label3: TLabel;
    Edit_ARR_Check: TDBEdit;
    Label4: TLabel;
    Edit_Arr_From_Advance: TDBEdit;
    Label6: TLabel;
    Edit_Arr_To_Advance: TDBEdit;
    Label7: TLabel;
    Edit_ARR_Desc: TDBEdit;
    Client_MastC_CUM_ADVANCE_AMOUNT: TCurrencyField;
    Label8: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label9: TLabel;
    lblRevSum: TLabel;
    lblRevBalance: TLabel;
    Button1: TButton;
    Client_DTC_SEQNO: TIntegerField;
    LblC_CUM_ADVANCE_AMOUNT: TDBText;
    Client_MastC_AR_SUM: TCurrencyField;
    DBText1: TDBText;
    LblC_AR_SUM: TDBText;
    Client_DTSMT_DATE: TDateTimeField;
    Client_DTSMT_INV_NO: TStringField;
    Client_DTSMT_AMOUNT: TBCDField;
    Client_DTSMT_NOT_CLEAN: TBCDField;
    gridC_SEQNO: TdxDBGridColumn;
    gridSMT_NO: TdxDBGridMaskColumn;
    gridSMT_DATE: TdxDBGridDateColumn;
    gridSMT_INV_NO: TdxDBGridMaskColumn;
    gridSMT_AMOUNT: TdxDBGridMaskColumn;
    gridSMT_NOT_CLEAN: TdxDBGridMaskColumn;
    gridARD_AMOUNT: TdxDBGridMaskColumn;
    gridARD_DISCOUNT: TdxDBGridMaskColumn;
    Button2: TButton;
    ActAutoFillin: TAction;
    Client_DTC_ARD_BALANCE: TCurrencyField;
    gridC_ARD_BALANCE: TdxDBGridColumn;
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
    procedure Edit_Cum_NOButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure Edit_Cum_NameButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure ActAppendExecute(Sender: TObject);
    procedure ActAbortExecute(Sender: TObject);
    procedure Client_MastCUM_NOValidate(Sender: TField);
    procedure dt_Arr_dateExit(Sender: TObject);
    procedure Client_MastARR_FROM_ADVANCEValidate(Sender: TField);
    procedure ActAutoFillinExecute(Sender: TObject);
    procedure Client_DTARD_AMOUNTValidate(Sender: TField);
    procedure ActSaveExecute(Sender: TObject);
    procedure Edit_Arr_CASHExit(Sender: TObject);
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
    procedure DeleteDetail(ARR_NO:STRING);
    procedure DeleteMaster(ARR_NO:STRING);
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

procedure Tfm_ar_recv.init;
begin
    SetEditMode(false);
    SetupQueryForm;
    SqlWhere:='M.ARR_DATE>='+SqlDateTimeSql(trunc(now)-60);
    SqlOrder:='M.ARR_DATE,M.ARR_NO';
    RefreshData;
    CLIENT_DT.First;
    client_dt.Last;


end;

procedure Tfm_ar_recv.SetupQueryForm;
var fld:PQueryField;
begin
  WhereList:=TList.Create;
  OrderList:=TList.Create;

  NewQueryFld(fld);
  fld.FieldName   :=  'ARR_DATE';
  fld.DispName    :='交易日期';
  fld.TableAlias  :='M';
  fld.DataType    :=wdDate;
  fld.CtrlType    :=wcDate;
  fld.QueryType   :=wqRange;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'ARR_NO';
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
  fld.FieldName   :=  'SMT_NO';
  fld.DispName    :='沖帳憑證編號';
  fld.TableAlias  :='D';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);



  Fm_Qry:=TFM_Query.Create(self);
  fm_qry.Init(sysinfo.AdoConnection,'','',WhereList,OrderList,query,dbsType);


end;

procedure Tfm_ar_recv.ActQueryExecute(Sender: TObject);
var n:integer;
begin
  n:=fm_qry.ShowModal;
  if n=mrCancel then
    exit;
  sqlWhere:=Fm_qry.sqlWhere;      //取得 SQLWher  字串
  SQLOrder:=fm_qry.sqlOrder;      //取得 SQLOrder 字串
  RefreshData;

end;

procedure Tfm_ar_recv.RefreshData;
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
    Sql:='SELECT DISTINCT M.* FROM TBL_AR_RECV M' +CR
        +'LEFT JOIN TBL_AR_RECV_DT D ON M.ARR_NO=D.ARR_NO '+CR
        + JoinWhere('',SqlWhere)+CR
        + JoinOrder('',SqlOrder);
    DEBUG(SQL);


    if Client_Mast.State<> dsinactive then
      s:=client_Mast.fieldbyname('ARR_NO').AsString;

//    DEBUG (SQL);
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
  CLIENT_MAST.Last;
  CLIENT_MAST.Next;
  CLIENT_MAST.Last;
  IF s='' then
    Client_Mast.Last
  else
    Client_Mast.Locate('ARR_NO',S,[]);
  hint(format('查尋時間:%f 秒',[ (now-t)*86400]));

end;

procedure Tfm_ar_recv.hint(msg: string);
begin
  lblStatus.Caption:=msg;
end;

procedure Tfm_ar_recv.SetEditMode(EditFlag: Boolean);
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
  SetCtrlReadOnly(Edit_ARR_NO,true);
  SetCtrlReadOnly(Edit_Rec,true);
  Edit_Cum_no.Buttons[0].Visible:=EditFlag;
  Edit_Cum_name.Buttons[0].Visible:=EditFlag;

  Client_MastAfterScroll(Client_mast);
  gridC_SEQNO.Color:=       ColrEditDisableBack;
  gridSMT_NO.Color:=        ColrEditDisableBack;
  gridSMT_DATE.Color:=      ColrEditDisableBack;
  gridSMT_NOT_CLEAN.Color:= ColrEditDisableBack;
  gridSMT_INV_NO.Color:=    ColrEditDisableBack;
  gridSMT_AMOUNT.Color:=    ColrEditDisableBack;
  gridSMT_NOT_CLEAN.Color:= ColrEditDisableBack;
  gridC_ARD_BALANCE.Color:= ColrEditDisableBack;


end;


procedure Tfm_ar_recv.Client_MastAfterScroll(DataSet: TDataSet);
var sql:string;
begin
  if Client_Mast.State<>dsBrowse then exit;

  sql:='SELECT A.*,B.SMT_DATE,B.SMT_INV_NO'+CR
      +',B.SMT_TOTAL+SMT_TAX SMT_AMOUNT,B.SMT_NOT_CLEAN'+CR
      +' FROM TBL_AR_RECV_DT A'+CR
      +' INNER JOIN TBL_SHIP B ON A.SMT_NO=B.SMT_NO'+CR
      +' WHERE ARR_NO='+SqlStr(Client_MastARR_NO.AsString);
//  DEBUG ('','A');
//  DEBUG ('--Tfm_ar_recv.Client_MastAfterScroll()','A');
//  DEBUG (SQL,'A');
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

procedure Tfm_ar_recv.Client_DTCalcFields(DataSet: TDataSet);
begin
  client_dtC_SEQNO.Value:=client_dt.RecNo;
  if client_mast.State=dsBrowse then
    Client_DTC_ARD_BALANCE.Value:=Client_DTSMT_NOT_CLEAN.Value
  else
    Client_DTC_ARD_BALANCE.Value:=Client_DTSMT_NOT_CLEAN.Value-(Client_DTARD_AMOUNT.Value+Client_DTARD_DISCOUNT.Value);
end;

procedure Tfm_ar_recv.Client_MastCalcFields(DataSet: TDataSet);
VAR s,CUM_NO:STRING;
begin
  CUM_NO:=client_mastCum_no.Value;
  client_mastC_Cum_Name.Value:=GetCumName(sysinfo,CUM_NO);
  Client_MastC_CUM_ADVANCE_AMOUNT.Value:=vartocurr(TblLookup(sysinfo.AdoConnection,'TBL_CUSTOMER','CUM_NO',CUM_NO,'CUM_ADVANCE_AMOUNT'));
  s:='SMT_DATE<='+sqlDateTimeSQL(CLIENT_MastARR_DATE.AsDateTime)
    +' AND SMT_STATUS='+INTTOSTR(STATUS_CONFIRM);
//  s1:=datetimetostr(CLIENT_MastARR_DATE.AsDateTime);
//  label12.Caption:=s1;
  Client_MastC_AR_SUM.Value:=
    vartocurr(TblLookup(sysinfo.AdoConnection,'TBL_SHIP','CUM_NO',Client_mastCUM_NO.Value,'SUM(SMT_NOT_CLEAN)',s));
end;

procedure Tfm_ar_recv.ActFirstExecute(Sender: TObject);
begin
  Client_Mast.First;
end;


procedure Tfm_ar_recv.ActLastExecute(Sender: TObject);
begin
Client_Mast.Last;
end;

procedure Tfm_ar_recv.ActPriorExecute(Sender: TObject);
begin
Client_Mast.Prior;
end;

procedure Tfm_ar_recv.ActNextExecute(Sender: TObject);
begin
  Client_Mast.next;
end;

procedure Tfm_ar_recv.Edit_Cum_NOButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var s:string;
begin
  if Client_Mast.State=dsBrowse then exit;
  s:=SelectCumNO(sysinfo);
  if s<>'' then
    Client_Mast.FieldByName('CUM_NO').Value:=s;

end;

procedure Tfm_ar_recv.Edit_Cum_NameButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var s:string;
begin
  if Client_Mast.State=dsBrowse then exit;
  s:=SelectCumName(sysinfo);
  if s<>'' then
    Client_Mast.FieldByName('CUM_NO').Value:=s;

end;

procedure Tfm_ar_recv.ActAppendExecute(Sender: TObject);
begin
  client_dt.Close;
  Client_Mast.Append;
  Client_Mast.fieldbyname('ARR_DATE').Value:=NOW;
  Edit_Cum_no.SetFocus;
  SetEditMode(true);

end;

procedure Tfm_ar_recv.ActAbortExecute(Sender: TObject);
begin
  Client_Mast.Cancel;
  SetEditMode(false);

end;

procedure Tfm_ar_recv.Client_MastCUM_NOValidate(Sender: TField);
begin
  InsertClientDT;
end;

procedure Tfm_ar_recv.InsertClientDT;
var cum_no:string;
    Arr_Date:TDateTime;
    sql:string;
    N:INTEGER;
    p:TDatasetNotifyEvent;
    qry:TAdoQuery;
begin
  qry:=TAdoQuery.Create(self);
  qry.Connection:=sysinfo.AdoConnection;
  sql:='SELECT A.*,B.SMT_DATE,B.SMT_INV_NO'
      +',B.SMT_TOTAL+SMT_TAX SMT_AMOUNT,B.SMT_NOT_CLEAN'
      +' FROM TBL_AR_RECV_DT A'
      +' INNER JOIN TBL_SHIP B ON A.SMT_NO=B.SMT_NO'
      +' WHERE 1=2';

  DoQrySelect(sql,sysinfo.AdoConnection,client_dt);
  CLIENT_DT.FieldByName('SMT_AMOUNT').ReadOnly:=FALSE;
  client_dt.open;
  N:=0;
  cum_no:=Client_MastCUM_NO.AsString;
  arr_Date:=dt_arr_date.Date;
  sql:='SELECT SMT_NO,SMT_DATE,SMT_INV_NO'
      +',SMT_TOTAL+SMT_TAX SMT_AMOUNT,SMT_NOT_CLEAN'
      +' FROM TBL_SHIP'
      +' WHERE CUM_NO='+sqlstr(cum_no)
      +' AND SMT_DATE<='+sqlDateTimeSql(arr_date)
      +' AND SMT_NOT_CLEAN<>0'
      +' AND SMT_STATUS=1'
      +' ORDER BY SMT_DATE,SMT_NO';
  qry.SQL.TEXT:=SQL;
  qry.Open;
  p:=CLIENT_DT.OnCalcFields;
  CLIENT_DT.OnCalcFields:=nil;
  try
    WHILE not qry.Eof do
    begin
      INC(N);
      client_dt.Append;
      client_dt.FieldByName('ARD_SEQNO').Value:=N;
      client_dt.FieldByName('SMT_NO').Value:=qry.FIELDBYNAME('SMT_NO').Value;
      client_dt.FieldByName('SMT_DATE').Value:=qry.FIELDBYNAME('SMT_DATE').Value;
      client_dt.FieldByName('SMT_INV_NO').Value:=qry.FIELDBYNAME('SMT_INV_NO').Value;
      client_dt.FieldByName('SMT_AMOUNT').Value:=qry.FIELDBYNAME('SMT_AMOUNT').Value;
      client_dt.FieldByName('SMT_NOT_CLEAN').Value:=qry.FIELDBYNAME('SMT_NOT_CLEAN').Value;
      CLIENT_DT.Post;
      qry.Next;
    end;
  finally
    qry.close;
    qry.Free;
    CLIENT_DT.OnCalcFields:=p;
  end;
  CLIENT_DT.First;

end;

procedure Tfm_ar_recv.dt_Arr_dateExit(Sender: TObject);
begin
if client_mast.State=dsInsert then
  InsertClientDT;

end;

procedure Tfm_ar_recv.UpdateTitle;
var c,RevSUM,RevBalance:currency;
    bm: TBookmark;
    p:TDatasetNotifyEvent;
begin

  revSum:=client_mastARR_CASH.Value
         +client_MastARR_Check.Value
         +Client_MastARR_FROM_ADVANCE.Value
         -Client_MastARR_TO_ADVANCE.Value;
  bm:=client_dt.GetBookmark;
  client_dt.DisableControls;
  p:=CLIENT_DT.OnCalcFields;
  CLIENT_DT.OnCalcFields:=nil;
  try
    client_dt.First;
    c:=0;
    while not client_dt.Eof do
    begin
      c:=c+Client_DTARD_AMOUNT.Value;
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

procedure Tfm_ar_recv.Client_MastARR_FROM_ADVANCEValidate(Sender: TField);
begin
  if sender.AsCurrency>Client_MastC_CUM_ADVANCE_AMOUNT.AsCurrency then
    errmsg('預收款額度不足 !',user);
  UpdateTitle;

end;

procedure Tfm_ar_recv.ActAutoFillinExecute(Sender: TObject);
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
  p1:=Client_DTARD_AMOUNT.OnValidate;
  Client_DTARD_AMOUNT.OnValidate:=nil;
  Client_DTARD_discount.OnValidate:=nil;
  CLIENT_DT.OnCalcFields:=nil;
  try
    client_dt.First;
    while not client_dt.Eof do
    begin
      client_dt.Edit;
      Client_DTARD_DISCOUNT.Value:=0;
      if revSum>=Client_DTSMT_NOT_CLEAN.Value then
      begin
        Client_DTARD_AMOUNT.Value:=Client_DTSMT_NOT_CLEAN.Value;
        revSum:=revSum-Client_DTSMT_NOT_CLEAN.Value;
      end else
      begin
        Client_DTARD_AMOUNT.Value:=revSum;
        revSum:=0;
      end;
      client_dt.post;
      client_dt.Next;
    end;
  finally
    Client_DTARD_AMOUNT.OnValidate:=p1;
    CLIENT_DT.OnCalcFields:=p;
    client_dt.EnableControls;
  end;
  UpdateTitle;
  if revSum>0 then
    msg('沖帳金額太多 !');


end;

procedure Tfm_ar_recv.Client_DTARD_AMOUNTValidate(Sender: TField);
begin
  if Client_DTSMT_NOT_CLEAN.Value>0 then
  begin
    if (Client_DTARD_AMOUNT.Value+Client_DTARD_DISCOUNT.Value)
        >Client_DTSMT_NOT_CLEAN.Value then
      Msg('沖帳金額過多 !');
  end else
  begin
    if (Client_DTARD_AMOUNT.Value+Client_DTARD_DISCOUNT.Value)
        <Client_DTSMT_NOT_CLEAN.Value then
      Msg('沖帳金額過多 !');
  end;


end;

procedure Tfm_ar_recv.CheckAllValidate;
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
    if Client_DTSMT_NOT_CLEAN.Value>0 then
    begin
      if (Client_DTARD_AMOUNT.Value+Client_DTARD_DISCOUNT.Value)
          >Client_DTSMT_NOT_CLEAN.Value then
        ErrMsg('單據沖帳金額過多 !',user);
    end else
    begin
      if (Client_DTARD_AMOUNT.Value+Client_DTARD_DISCOUNT.Value)
          <Client_DTSMT_NOT_CLEAN.Value then
        ErrMsg('單據沖帳金額過多 !',User);
    end;
    client_dt.Next;
  end;

end;

procedure Tfm_ar_recv.ActSaveExecute(Sender: TObject);
var t:tdate;
  year:integer;
begin
  year:= yearof(Client_MastARR_DATE.Value);
  if year < sysinfo.SPR_ACNT_YEAR then
    Errmsg ('交易日期不得小於本會計年度 !',user);


    CheckAllValidate;
    t:=now;
    Client_Mast.FieldByName('ARR_NO').Value:=GetNumbericCode(sysinfo.AdoConnection,'Tbl_AR_RECV','ARR_NO','yyyymmdd',Client_Mast.fieldbyname('ARR_DATE').Value,4);
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

procedure Tfm_ar_recv.Edit_Arr_CASHExit(Sender: TObject);
begin
  UpdateTitle;
end;

procedure Tfm_ar_recv.gridEdited(Sender: TObject; Node: TdxTreeListNode);
begin
  UpdateTitle;
end;

procedure Tfm_ar_recv.ActRefreshExecute(Sender: TObject);
begin
  RefreshData;
end;

procedure Tfm_ar_recv.SaveDetail;
VAR smt_no:STRING;
  amount,discount:currency;
begin
  client_dt.First;
  while not client_dt.Eof do
  begin
    amount:=Client_DT.fieldbyname('ARD_AMOUNT').AsCurrency;
    discount:=Client_DT.fieldbyname('ARD_DISCOUNT').AsCurrency;
    smt_no:=Client_DT.fieldbyname('SMT_NO').AsString;
    if  (amount<>0)or (discount<>0) then
    begin
      Insert_AR_Recv_DT(sysinfo,Client_Mast.FieldByName('ARR_NO').AsString
                                   ,Client_DT.FieldByName('ARD_SEQNO').AsInteger
                                   ,Client_DT.FieldByName('SMT_NO').AsString
                                   ,Client_DT.FieldByName('ARD_AMOUNT').AsCurrency
                                   ,Client_DT.FieldByName('ARD_DISCOUNT').AsCurrency
                                   );
      UpdateARNotClean(sysinfo,smt_no);
    end;
    client_dt.Next;
  end;

end;

procedure Tfm_ar_recv.SaveMaster;
var cum_no:string;
begin
  cum_no:=Client_Mast.FieldByName('CUM_NO').AsString;
  Insert_AR_Recv(sysinfo,Client_Mast.FieldByName('ARR_NO').AsString
                            ,Client_Mast.FieldByName('CUM_NO').AsString
                            ,Client_Mast.FieldByName('ARR_DATE').AsDateTime
                            ,Client_Mast.FieldByName('ARR_CASH').AsCurrency
                            ,Client_Mast.FieldByName('ARR_CHECK').AsCurrency
                            ,Client_Mast.FieldByName('ARR_FROM_ADVANCE').AsCurrency
                            ,Client_Mast.FieldByName('ARR_TO_ADVANCE').AsCurrency
                            ,Client_Mast.FieldByName('ARR_DESC').AsString
                            ,Client_Mast.FieldByName('ARR_CREATOR').AsString
                            );
  UpdateCUM_Advance_Amount(sysinfo,cum_no);
end;

procedure Tfm_ar_recv.ActDeleteExecute(Sender: TObject);
VAR ARR_NO:string;
    jnl_no,sql:string;
  year:integer;
begin
  year:= yearof(Client_MastARR_DATE.Value);
  if year < sysinfo.SPR_ACNT_YEAR then
    Errmsg ('不得刪除小於本會計年度的傳票 !',user);

  if MessageDlg('是否確定刪除 ?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;

  ARR_NO:=Client_Mast.FieldByName('ARR_NO').AsString;
  jnl_no:=Client_MastJNL_NO.Value;
  sysinfo.AdoConnection.BeginTrans;
  try
    DeleteDetail(ARR_NO);
    DeleteMaster(ARR_NO);

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

procedure Tfm_ar_recv.DeleteDetail(ARR_NO:STRING);
var s,SMT_NO:string;
begin
  S:='DELETE TBL_AR_RECV_DT WHERE ARR_NO='
    +sqlStr(ARR_NO);
  sysinfo.AdoConnection.Execute(s);

  client_dt.First;
  while not client_dt.Eof do
  begin
    SMT_NO:=Client_DT.fieldbyname('SMT_NO').AsString;
    UpdateARNotClean(sysinfo,smt_no);
    client_dt.Next;
  end;
end;

procedure Tfm_ar_recv.DeleteMaster(ARR_NO:STRING);
var s,cum_no:string;
begin
  CUM_NO:=Client_Mast.FieldByName('CUM_NO').AsString;
  S:='DELETE TBL_AR_RECV WHERE ARR_NO='
    +sqlStr(ARR_NO);
  sysinfo.AdoConnection.Execute(s);
  UpdateCUM_Advance_Amount(sysinfo,CUM_NO);
  client_mast.Delete;
end;

procedure Tfm_ar_recv.InsertAccount;
var acnt_cash,acnt_check:currency;
    acnt_from_advance,acnt_to_advance:currency;
    acnt_discount:currency;
    cum_acnt_advance:string;  //客戶預收款科目
    cum_acnt_ar:string;       //應收帳款科目
    desc:string;
begin
  acnt_discount:=0;
  Client_DT.First;
  while not Client_DT.Eof do begin
    acnt_discount:=acnt_discount+Client_DTARD_DISCOUNT.Value;
    Client_DT.Next;
  end;
  acnt_cash:=Client_MastARR_CASH.Value;
  acnt_check:=Client_MastARR_CHECK.Value;
  acnt_from_advance:=Client_MastARR_FROM_ADVANCE.Value;
  acnt_to_advance:=Client_MastARR_TO_ADVANCE.Value;

  cum_acnt_advance:=vartostr(TblLookup(sysinfo.AdoConnection,'TBL_CUSTOMER','CUM_NO',Client_MastCUM_NO.Value,'CUM_ACNT_ADVANCE'));
  cum_acnt_ar:=vartostr(TblLookup(sysinfo.AdoConnection,'TBL_CUSTOMER','CUM_NO',Client_MastCUM_NO.Value,'CUM_ACNT_AR'));

  desc:='系統傳輸--收款作業 '+Client_MastC_CUM_NAME.Value+'(憑證編號:'+Client_MastARR_NO.Value+')';
  ArRecvToAccount(sysinfo,Client_MastARR_NO.AsString
                             ,Client_MastCUM_NO.AsString
                             ,Client_MastARR_DATE.Value
                             ,desc
                             ,acnt_cash
                             ,acnt_check
                             ,acnt_discount
                             ,acnt_from_advance
                             ,acnt_to_advance);
end;

procedure Tfm_ar_recv.FormCloseQuery(Sender: TObject;
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

unit form_InvAdjust;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, ComCtrls, ExtCtrls, Mask, Buttons, ActnList,
  ImgList, dxCntner, dxEditor, dxEdLib, dxDBELib, DBCtrls, dxExEdtr,
  DBClient, Provider, dxDBTLCl, dxGrClms, dxTL, dxDBCtrl, dxDBGrid,
  wwSpeedButton, wwDBNavigator, wwclearpanel, wwdbdatetimepicker, Grids,
  DBGrids, wwdblook, dxDBEdtr, Form_Query, Menus, erp_public,FORM_ERP_BASE;

type
  TFm_invAdjust = class(TForm_ERP)
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
    Label5: TLabel;
    Label11: TLabel;
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
    Client_MastADJ_NO: TStringField;
    Client_MastADJ_STATUS: TBCDField;
    Client_MastADJ_DATE: TDateTimeField;
    Client_MastADJ_DESC: TStringField;
    Client_MastADJ_CREATOR: TStringField;
    Client_dtADJ_NO: TStringField;
    Client_dtADD_SEQNO: TBCDField;
    Client_dtPRD_NO: TStringField;
    Client_dtINV_NO: TStringField;
    Client_dtADD_QTY: TBCDField;
    Client_dtC_SUB_TOTAL: TCurrencyField;
    Client_dtC_PRD_ONHAND: TFloatField;
    Client_dtC_SEQNO: TIntegerField;
    Edit_ADJ_No: TdxDBEdit;
    dt_ADJ_DATE: TwwDBDateTimePicker;
    memo_ADJ_Desc: TdxDBMemo;
    gridADD_QTY: TdxDBGridMaskColumn;
    gridADD_COST: TdxDBGridMaskColumn;
    gridC_SUB_TOTAL: TdxDBGridColumn;
    gridC_PRD_ONHAND: TdxDBGridColumn;
    gridC_SEQNO: TdxDBGridColumn;
    gridPRD_NO: TdxDBGridButtonColumn;
    Client_dtC_PRD_NAME: TStringField;
    gridC_PRD_NAME: TdxDBGridColumn;
    Client_dtADD_COST: TBCDField;
    procedure Client_MastAfterScroll(DataSet: TDataSet);
    procedure Client_dtCalcFields(DataSet: TDataSet);
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
    procedure ActRefreshExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure Client_dtBeforePost(DataSet: TDataSet);
    procedure ActQueryExecute(Sender: TObject);
    procedure ActBrowseExecute(Sender: TObject);
    procedure ActDeleteExecute(Sender: TObject);
    procedure ActBookExecute(Sender: TObject);
    procedure ActUnBookExecute(Sender: TObject);
    procedure Client_MastADJ_NOT_CLEANGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure Client_MastADJ_DATEValidate(Sender: TField);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure gridCustomDraw(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxDBTreeListColumn;
      const AText: String; AFont: TFont; var AColor: TColor; ASelected,
      AFocused: Boolean; var ADone: Boolean);
    procedure ActFunctionExecute(Sender: TObject);
    procedure Client_dtPRD_NOGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
  private
    Sysdate:TDateTime;
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
    procedure DeleteDetail(ADJ_NO: STRING);
    procedure SetupQueryForm;
    procedure RefreshData;
    procedure DeleteMaster(ADJ_NO: STRING);
    procedure DeleteInv_Transaction(ADJ_no: string);
    { Private declarations }
  public
    PROCEDURE Init;override;
    { Public declarations }
  end;


implementation

uses Uty,
  SysReport_Head, form_InvAdjBrowse,
  form_SysReportQuery, DBUty;

{$R *.dfm}

{ TForm1 }

procedure TFm_invAdjust.Init;
//var t1:tdatetime;
begin
  Sysdate:=now;
  BtnUnConfirm.Top:=BtnConfirm.Top;
  BtnUnConfirm.left:=BtnConfirm.left;
  SetEditMode(false);
  SetupQueryForm;
  SqlWhere:='M.ADJ_DATE>='+SqlDateTimeSql(trunc(now)-30);
  SqlOrder:='M.ADJ_DATE,M.ADJ_NO';
  RefreshData;

end;

procedure TFm_invAdjust.Client_MastAfterScroll(DataSet: TDataSet);
var sql:string;
  IsUnBook:boolean;
begin
  if Client_Mast.State<>dsBrowse then exit;
  
  sql:='SELECT * FROM TBL_INV_ADJ_DT WHERE ADJ_NO='+SqlStr(Client_MastADJ_NO.AsString);
  DoQrySelect(sql,sysinfo.AdoConnection,Client_DT);
  isUnBook:=(Client_mastADJ_Status.Value=Status_UnBook);
  ActBook.Enabled:=IsUnbook;
  ActUnBook.Enabled:=not IsUnbook;
  ActEdit.Enabled:=IsUnbook;
  ActQuickCollect.Enabled:=not IsUnbook;
  ActDelete.Enabled:=IsUnbook;
  BtnConfirm.Visible:=isUnBook;
  BtnUnConfirm.Visible:=not isUnBook;

  if IsUnBook then
  begin
  end else
  begin
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

procedure TFm_invAdjust.Client_dtCalcFields(DataSet: TDataSet);
begin
  client_dtC_SUB_TOTAL.Value:=client_dtADD_QTY.Value*client_dtADD_COST.Value;
  client_dtC_SEQNO.Value:=client_dt.RecNo;
  Client_dtC_PRD_ONHAND.Value:=vartoCURR(TblLookup(sysinfo.AdoConnection,'TBL_PRODUCT','PRD_NO',Client_dtPRD_NO.AsString,'PRD_ONHAND'));
  Client_dtC_PRD_NAME.Value:=vartoSTR(TblLookup(sysinfo.AdoConnection,'TBL_PRODUCT','PRD_NO',Client_dtPRD_NO.AsString,'PRD_NAME'));
end;

procedure TFm_invAdjust.ActFirstExecute(Sender: TObject);
begin
  Client_Mast.First;
end;

procedure TFm_invAdjust.ActLastExecute(Sender: TObject);
begin
Client_Mast.Last;
end;

procedure TFm_invAdjust.ActPriorExecute(Sender: TObject);
begin
Client_Mast.Prior;
end;

procedure TFm_invAdjust.ActNextExecute(Sender: TObject);
begin
  Client_Mast.next;
end;

procedure TFm_invAdjust.ActEditExecute(Sender: TObject);
begin
  ModiFlag:=True;
  Client_Mast.Edit;
  dt_ADJ_DATE.SetFocus;
  SetEditMode(True);
end;

procedure TFm_invAdjust.SetEditMode(EditFlag: Boolean);
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
  SetCtrlReadOnly(Edit_ADJ_NO,true);
  SetCtrlReadOnly(Edit_Rec,true);

  if EditFlag then
  begin
    navDetail.VisibleButtons:= [nbFirst,nbPrior,nbNext,nbLast,nbInsert,nbDelete];
  end else
  begin
    navDetail.VisibleButtons:= [nbFirst,nbPrior,nbNext,nbLast];
  end;
  Client_MastAfterScroll(Client_mast);

end;

procedure TFm_invAdjust.ActAbortExecute(Sender: TObject);
begin
  Client_Mast.Cancel;
  SetEditMode(false);
end;

procedure TFm_invAdjust.ActAppendExecute(Sender: TObject);
begin
  ModiFlag:=false;
  client_dt.Close;
  DoQrySelect('SELECT * FROM TBL_INV_ADJ_DT WHERE ADJ_NO IS NULL',sysinfo.AdoConnection,client_dt);
  client_dt.open;
  Client_Mast.Append;
  Client_Mast.fieldbyname('ADJ_DATE').Value:=trunc(SYSDATE)+frac(now);
  dt_ADJ_DATE.SetFocus;
  SetEditMode(true);

end;

procedure TFm_invAdjust.Edit_SUP_NOButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var s:string;
begin
  if Client_Mast.State=dsBrowse then exit;
  s:=SelectSupNO(sysinfo);
  if s<>'' then
    Client_Mast.FieldByName('SUP_NO').Value:=s;
end;


procedure TFm_invAdjust.Edit_SUP_NameButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var s:string;
begin
  if Client_Mast.State=dsBrowse then exit;
  s:=SelectSupName(sysinfo);
  if s<>'' then
    Client_Mast.FieldByName('SUP_NO').Value:=s;

end;

procedure TFm_invAdjust.gridPRD_NOButtonClick(Sender: TObject;
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

procedure TFm_invAdjust.AddProd(Prd_no: string);
begin
  if client_dt.State<>dsInsert then
    client_dt.insert;
  client_dt.FieldByName('PRD_NO').Value:=PRD_NO;
  client_dt.FieldByName('ADD_QTY').Value:=1;
  client_dt.FieldByName('ADD_COST').Value
  := GetPrdCurrCost(sysinfo,Prd_no);
  client_dt.Post;
end;

procedure TFm_invAdjust.Client_dtPRD_NOValidate(Sender: TField);
begin
  client_dt.FieldByName('ADD_COST').Value
    := GetPrdCurrCost(sysinfo,Client_DTPrd_NO.AsString);
end;

procedure TFm_invAdjust.chkDetail;
VAR Prd_no:string;
begin
  client_dt.First;
  while not client_dt.Eof DO
  BEGIN
    PRD_NO:=client_dt.FieldByName('PRD_NO').AsString;
    if VARISNULL(TblLookup(sysinfo.AdoConnection,'TBL_PRODUCT','PRD_NO',PRD_NO,'PRD_NO')) then
      errMsg(Prd_no+' :產品編號錯誤 !',user);
    if (client_dt.FieldByName('ADD_QTY').AsCurrency =0) THEN
      errMsg(Prd_no+' :產品數量不得為零 ! ',user);
    client_dt.Next;
  END;
end;


procedure TFm_invAdjust.RefreshData;
var sql,s:string;
    T:TDate;
begin
  screen.Cursor:=crSQLWait;
  TRY
    t:=now;
    Sql:='SELECT DISTINCT M.* FROM TBL_INV_ADJ M'
        +' INNER JOIN TBL_INV_ADJ_DT D ON M.ADJ_NO=D.ADJ_NO '
        + JoinWhere('',SqlWhere)
        + JoinOrder('',SqlOrder);

    if Client_Mast.State<> dsinactive then
      s:=client_Mast.fieldbyname('ADJ_NO').AsString;

    DoQrySelect(sql,sysinfo.AdoConnection,Client_Mast);
    if Client_mast.Eof then
    begin
      msg('查無任何資料 !');
    end;
    IF s='' then
      Client_Mast.Last
    else
      Client_Mast.Locate('ADJ_NO',S,[]);
    hint(format('查尋時間:%f 秒',[ (now-t)*86400]));
  FINALLY
    screen.Cursor:=crDefault;
  END;

end;


procedure TFm_invAdjust.SaveMaster;
var sql:string;
begin
  sql:='INSERT INTO TBL_INV_ADJ '
      +'(ADJ_NO,ADJ_STATUS'
      +',ADJ_DATE'
      +',ADJ_DESC,ADJ_CREATOR) '
      +' VALUES ('
      +sqlStr(Client_Mast.fieldbyname('ADJ_NO').AsString)+','
      +Client_Mast.fieldbyname('ADJ_STATUS').AsString+','
      +sqlDateTimeSql(Client_Mast.fieldbyname('ADJ_DATE').AsDateTime)+','
      +sqlStr(Client_Mast.fieldbyname('ADJ_DESC').AsString)+','
      +sqlStr(sysinfo.LoginUserName)+')';
  sysinfo.AdoConnection.Execute(SQL);


end;


procedure TFm_invAdjust.SaveDetail;
var sql:string;
  CNT:INTEGER;
begin
  client_dt.First;
  CNT:=0;
  while not client_dt.Eof DO
  BEGIN
    INC(CNT);
    Client_DT.Edit;
    Client_DTADD_Seqno.Value:=cnt;
    Client_DT.Post;

    sql:='INSERT INTO TBL_INV_ADJ_DT'
        +' (ADJ_NO,ADD_SEQNO,PRD_NO,INV_NO,'
        +' ADD_COST,ADD_QTY)'
        +' VALUES ('
        +sqlStr(Client_MastADJ_NO.AsString)+','
        +Client_DTADD_Seqno.AsString+','
        +sqlStr(Client_dtPrd_NO.AsString)+','
        +sqlStr(Client_dtInv_no.AsString)+','
        +client_DTADD_COST.AsString+','
        +client_dtADD_QTY.AsString
        +')';
    sysinfo.AdoConnection.Execute(sql);
    client_dt.Next;
  end;


end;


procedure TFm_invAdjust.ActRefreshExecute(Sender: TObject);
begin
  RefreshData;
end;

procedure TFm_invAdjust.ActSaveExecute(Sender: TObject);
var ADJ_no:string;
  t:tdate;
begin
    t:=now;
    ChkDetail;
    Client_MastADJ_Status.Value:=STATUS_UNBOOK;
    if not ModiFlag then
    begin
      Client_Mast.FieldByName('ADJ_NO').Value:=GetNumbericCode(sysinfo.AdoConnection,'Tbl_INV_ADJ','ADJ_NO','yyyymmdd',Client_Mast.fieldbyname('ADJ_DATE').Value,4);
      SysDate:=Client_Mast.fieldbyname('ADJ_DATE').Value;
    end;
    ADJ_no:=Client_Mast.FieldByName('ADJ_NO').AsString;

    sysinfo.AdoConnection.BeginTrans;
    try
      if ModiFlag then
      begin
        DeleteDetail(ADJ_no);
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

procedure TFm_invAdjust.DeleteDetail(ADJ_NO:STRING);
var s:string;
begin
  S:='DELETE TBL_INV_ADJ_DT WHERE ADJ_NO='+sqlStr(ADJ_no);
  sysinfo.AdoConnection.Execute(s);
end;

procedure TFm_invAdjust.DeleteMaster(ADJ_NO:STRING);
var s:string;
begin
  S:='DELETE TBL_INV_ADJ WHERE ADJ_NO='+sqlStr(ADJ_no);
  sysinfo.AdoConnection.Execute(s);
  client_mast.Delete;
end;



procedure TFm_invAdjust.UpdateMaster;
var sql:string;
begin
  sql:='UPDATE TBL_INV_ADJ'
      +' SET ADJ_STATUS=' +Client_Mast.fieldbyname('ADJ_STATUS').AsString
      +',ADJ_DATE='       +sqlDateTimeSql(Client_Mast.fieldbyname('ADJ_DATE').AsDateTime)
      +',ADJ_DESC='       +sqlStr(Client_Mast.fieldbyname('ADJ_DESC').AsString)
      +',ADJ_CREATOR='    +sqlStr(sysinfo.LoginUserName)
      +' WHERE ADJ_NO='   +sqlStr(Client_Mast.fieldbyname('ADJ_NO').AsString);
      sysinfo.AdoConnection.Execute(SQL);

end;




procedure TFm_invAdjust.Client_dtBeforePost(DataSet: TDataSet);
begin
  Client_dtINV_NO.Value:=Default_Inv;
end;

procedure TFm_invAdjust.InsertInv_Transaction;
begin
  client_dt.First;
  while not client_dt.Eof do
  begin
    InsertTransaction(sysinfo,Client_DTPRD_NO.AsString
                             ,Client_DTINV_NO.AsString
                             ,TRN_ADJ
                             ,client_MastADJ_NO.AsString
                             ,client_dtADD_SEQNO.AsString
                             ,client_MastADJ_Date.Value
                             ,client_dtADD_Qty.Value
                             ,Client_dtADD_COST.Value);
    client_dt.Next;
  end;


end;


procedure TFm_invAdjust.DeleteInv_Transaction(ADJ_no:string);
var s:string;
begin
  s:='DELETE TBL_TRANSACTION WHERE '
    +' TRN_TYPE='+inttostr(TRN_ADJ)
    +' AND TRN_SRC_NO=' +sqlstr(ADJ_no);
  sysinfo.AdoConnection.Execute(s);
  CLIENT_DT.First;
  WHILE NOT CLIENT_DT.Eof DO
  BEGIN
    UpdateTransaction(sysinfo,client_dtPRD_NO.AsString
                              ,client_MastADJ_Date.Value);
    CLIENT_DT.Next;
  END;

end;


procedure TFm_invAdjust.SetupQueryForm;
var fld:PQueryField;
begin
  WhereList:=TList.Create;
  OrderList:=TList.Create;

  NewQueryFld(fld);
  fld.FieldName   :=  'ADJ_DATE';
  fld.DispName    :='交易日期';
  fld.TableAlias  :='M';
  fld.DataType    :=wdDate;
  fld.CtrlType    :=wcDate;
  fld.QueryType   :=wqRange;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'ADJ_NO';
  fld.DispName    :='憑證編號';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

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

procedure TFm_invAdjust.ActQueryExecute(Sender: TObject);
var n:integer;
begin
  n:=fm_qry.ShowModal;
  if n=mrCancel then
    exit;
  sqlWhere:=Fm_qry.sqlWhere;      //取得 SQLWher  字串
  SQLOrder:=fm_qry.sqlOrder;      //取得 SQLOrder 字串
  RefreshData;

end;


procedure TFm_invAdjust.hint(msg: string);
begin
  lblStatus.Caption:=msg;
end;

procedure TFm_invAdjust.ActBrowseExecute(Sender: TObject);
var fm:TFm_InvAdjBrowse;
begin
  fm:=TFm_InvAdjBrowse.Create(application);
  fm.ds_mast:=ds_Master;
  fm.ds_detail:=ds_Client_dt;
  fm.init;
  try
    fm.ShowModal;
  finally
    fm.Free;
  end;

end;

procedure TFm_invAdjust.ActDeleteExecute(Sender: TObject);
var ADJ_no:string;
begin
  if MessageDlg('是否確定刪除 ?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;

  ADJ_no:=Client_Mast.FieldByName('ADJ_NO').AsString;
  sysinfo.AdoConnection.BeginTrans;
  try
    DeleteInv_Transaction(ADJ_no);
    DeleteDetail(ADJ_no);
    DeleteMaster(ADJ_no);
    sysinfo.AdoConnection.CommitTrans;
  except
    sysinfo.AdoConnection.RollbackTrans;
    raise;
  end;

end;

procedure TFm_invAdjust.ActBookExecute(Sender: TObject);
var ADJ_no,s:string;
  t:tdate;
begin
  t:=now;
  screen.Cursor:=crSQLWait;
  ADJ_no:=Client_Mast.FieldByName('ADJ_NO').AsString;
  try
    sysinfo.AdoConnection.BeginTrans;
    try
      InsertInv_Transaction;
      s:='UPDATE TBL_INV_ADJ'
        +' SET ADJ_STATUS='+INTTOSTR(STATUS_confirm)
          +' WHERE ADJ_NO='+sqlStr(ADJ_no);
      sysinfo.AdoConnection.Execute(s);
      client_mast.Edit;
      client_mastADJ_Status.Value:=STATUS_Confirm;
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

procedure TFm_invAdjust.ActUnBookExecute(Sender: TObject);
var ADJ_no,s:string;
  t:tdate;
begin
  t:=now;
  ADJ_no:=Client_Mast.FieldByName('ADJ_NO').AsString;

  screen.Cursor:=crSQLWait;
  try
    sysinfo.AdoConnection.BeginTrans;
    try
      DeleteInv_Transaction(ADJ_no);
      s:='UPDATE TBL_INV_ADJ SET ADJ_STATUS='+INTTOSTR(STATUS_UNBOOK)
          +' WHERE ADJ_NO='+sqlStr(ADJ_no);
      sysinfo.AdoConnection.Execute(s);
      client_mast.Edit;
      client_mastADJ_Status.Value:=STATUS_UNBOOK;
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

procedure TFm_invAdjust.Client_MastADJ_NOT_CLEANGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
if client_mastADJ_Status.Value=Status_UnBook then
  text:='單據未確認'
else
  text:=sender.AsString;
end;

procedure TFm_invAdjust.Client_MastADJ_DATEValidate(Sender: TField);
begin
  IF SENDER.AsDateTime<sysinfo.SPR_PERIOD_START THEN
    ErrMsg('交易日期不得小於(交易期間起始日期)'
            +#13#13'交易期間起始日期 ='+Datetostr(sysinfo.SPR_PERIOD_START),user);
end;

procedure TFm_invAdjust.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (Client_mast.State=dsInsert)
  or (Client_mast.State=dsEdit) then
  begin
    msg('在新增或修改模式，不能結束作業 ！');
    action:=canone;
  end;
end;

procedure TFm_invAdjust.gridCustomDraw(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxDBTreeListColumn;
  const AText: String; AFont: TFont; var AColor: TColor; ASelected,
  AFocused: Boolean; var ADone: Boolean);
var n:integer;
begin
  n:=grid.ColumnByFieldName('ADD_QTY').Index;
  if varisnull(ANode.Values[n]) then exit;
  if ANode.Values[n]<0 then
  begin
    AColor:=clYellow;
    Afont.Color:=clRed;
  end;

end;

procedure TFm_invAdjust.ActFunctionExecute(Sender: TObject);
var p:TPoint;
begin
  p.X:=BtnFunc.Left;
  p.Y:=BtnFunc.Top;
  p:=BtnFunc.ClientToScreen(point(0,0));
  MenuFunc.Popup(p.X,p.Y);
end;

procedure TFm_invAdjust.Client_dtPRD_NOGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  text:=sender.AsString;

end;


end.

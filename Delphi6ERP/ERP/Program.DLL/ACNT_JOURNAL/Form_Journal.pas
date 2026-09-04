unit Form_Journal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, ComCtrls, ExtCtrls, Mask, Buttons, ActnList,
  ImgList, dxCntner, dxEditor, dxEdLib, dxDBELib, DBCtrls, dxExEdtr,
  DBClient, Provider, dxDBTLCl, dxGrClms, dxTL, dxDBCtrl, dxDBGrid,
  wwSpeedButton, wwDBNavigator, wwclearpanel, wwdbdatetimepicker, Grids,
  DBGrids, wwdblook, dxDBEdtr, Form_Query, Menus, dxGrClEx,
  DateUtils, ppCtrls, ppPrnabl, ppClass, ppBands, ppCache, ppProd,
  ppReport, ppComm, ppRelatv, ppDB, ppDBPipe,ppViewr,FORM_ERP_BASE,erp_public;

type
  TFM_Journal = class(TForm_ERP)
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
    ActFunction: TAction;
    ActQuickCollect: TAction;
    ActCollectHist: TAction;
    qry_Mast: TADOQuery;
    qry_dt: TADOQuery;
    Provider_Mast: TDataSetProvider;
    Provider_DT: TDataSetProvider;
    Client_MastJNL_NO: TStringField;
    Client_MastJNL_DATE: TDateTimeField;
    Client_MastJNL_DESC: TStringField;
    Client_MastJNL_BILL_TYPE: TBCDField;
    Client_MastJNL_CREATOR: TStringField;
    Label1: TLabel;
    Edit_Jnl_No: TDBEdit;
    Label2: TLabel;
    Label4: TLabel;
    DBEdit4: TDBEdit;
    dxDBMemo1: TdxDBMemo;
    Client_dtACT_NO: TStringField;
    Client_dtJND_AMOUNT: TBCDField;
    Client_dtJND_DESC: TStringField;
    Client_dtC_ACT_NAME: TStringField;
    gridJND_SEQNO: TdxDBGridMaskColumn;
    gridC_ACT_NAME: TdxDBGridColumn;
    gridJND_AMOUNT: TdxDBGridMaskColumn;
    gridJND_DESC: TdxDBGridMaskColumn;
    dt_JNL_Date: TwwDBDateTimePicker;
    gridACT_NO: TdxDBGridButtonColumn;
    Panel2: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Edit_AmountDebit: TdxEdit;
    Edit_AmountCredit: TdxEdit;
    Edit_AmountBalance: TdxEdit;
    ActShowBalance: TAction;
    Button1: TButton;
    Lbl_Balance: TLabel;
    Button2: TButton;
    Button3: TButton;
    Client_dtC_SEQNO: TIntegerField;
    Client_dtJND_SEQNO: TBCDField;
    gridJND_DC: TdxDBGridColumn;
    Client_dtJND_DC: TIntegerField;
    qryReport: TADOQuery;
    dsReport: TDataSource;
    ppDBPipeline1: TppDBPipeline;
    ppRep1: TppReport;
    ppHeaderBand1: TppHeaderBand;
    ppDetailBand1: TppDetailBand;
    ppFooterBand1: TppFooterBand;
    ppLabel8: TppLabel;
    ppLabel1: TppLabel;
    ppLabel3: TppLabel;
    ppLine1: TppLine;
    ppLblCorName: TppLabel;
    ppLabel7: TppLabel;
    ppLabel4: TppLabel;
    ppLabel10: TppLabel;
    ppDBText1: TppDBText;
    ppDBText2: TppDBText;
    ppLabel2: TppLabel;
    ppLabel5: TppLabel;
    ppDBText3: TppDBText;
    ppDBText4: TppDBText;
    ppDBText5: TppDBText;
    ppDBText6: TppDBText;
    ppDBText7: TppDBText;
    ppLine2: TppLine;
    ppGroup1: TppGroup;
    ppGroupHeaderBand1: TppGroupHeaderBand;
    ppGroupFooterBand1: TppGroupFooterBand;
    ppDBCalc1: TppDBCalc;
    ppDBCalc2: TppDBCalc;
    ppLabel6: TppLabel;
    ppLabel9: TppLabel;
    ppLabel11: TppLabel;
    ppLabel12: TppLabel;
    ppLine3: TppLine;
    ppLabel13: TppLabel;
    procedure Client_MastAfterScroll(DataSet: TDataSet);
    procedure Client_dtCalcFields(DataSet: TDataSet);
    procedure ActFirstExecute(Sender: TObject);
    procedure ActLastExecute(Sender: TObject);
    procedure ActPriorExecute(Sender: TObject);
    procedure ActNextExecute(Sender: TObject);
    procedure ActEditExecute(Sender: TObject);
    procedure ActAbortExecute(Sender: TObject);
    procedure ActAppendExecute(Sender: TObject);
    procedure ActRefreshExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ActQueryExecute(Sender: TObject);
    procedure ActBrowseExecute(Sender: TObject);
    procedure ActDeleteExecute(Sender: TObject);
    procedure Client_dtPRD_NOGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure ActPrintExecute(Sender: TObject);
    procedure Client_dtC_JND_DCGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure Client_dtC_ACT_NAMEGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure gridDblClick(Sender: TObject);
    procedure gridKeyPress(Sender: TObject; var Key: Char);
    procedure ActShowBalanceExecute(Sender: TObject);
    procedure gridExit(Sender: TObject);
    procedure gridACT_NOButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure Client_dtNewRecord(DataSet: TDataSet);
    procedure gridChangeColumn(Sender: TObject; Node: TdxTreeListNode;
      Column: Integer);
    procedure Client_MastJNL_DATEValidate(Sender: TField);
    procedure Client_dtJND_DCGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure Client_dtJND_AMOUNTSetText(Sender: TField;
      const Text: String);
    procedure Client_dtJND_AMOUNTGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure ppRep1PreviewFormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private

    Sysdate:TDateTime;
    ModiFlag:boolean;
    Fm_Qry:TFM_Query;
    SQlWhere,SQLOrder:string;
//    sqlReport:string;
    WhereList,OrderList:TList;
    AmountBalance:currency;
    procedure hint(msg:string);
    procedure SetEditMode(EditFlag:Boolean);
    procedure chkDetail;
    procedure SaveMaster;
    procedure SaveDetail;
//    procedure SaveHisDetail;
//    procedure SaveHisMaster;
    procedure UpdateMaster;
    procedure SetupQueryForm;
    procedure RefreshData;
    procedure ChangeDC;
    procedure ShowBalance;
    procedure DeleteDetail(jnl_NO: STRING);
    procedure DeleteMaster(jnl_no: STRING);
    { Private declarations }
  public
    PROCEDURE Init;override;
    { Public declarations }
  end;


implementation

uses Uty, SysReport_Head, form_Journal_Browse, form_Journal_Print, DBUty;

{$R *.dfm}

{ TForm1 }

procedure TFM_Journal.Init;
//var t1:tdatetime;
begin
  Sysdate:=now;
  SetEditMode(false);
  SetupQueryForm;
  SqlWhere:='M.JNL_DATE>='+SqlDateTimeSql(trunc(now)-500);
  SqlWhere:='M.JNL_DATE>=''01/01/2003''';
  SqlOrder:='M.JNL_DATE,M.JNL_NO';
  RefreshData;

end;

procedure TFM_Journal.Client_MastAfterScroll(DataSet: TDataSet);
var sql:string;
begin
  if Client_Mast.State<>dsBrowse then exit;

  sql:='SELECT JNL_NO,JND_SEQNO,ACT_NO'
      +',CASE WHEN JND_AMOUNT >= 0 THEN 1	ELSE -1	END AS JND_DC'
      +', JND_AMOUNT,JND_DESC'
      +' FROM TBL_ACNT_JOURNAL_DT WHERE JNL_NO='
      +SqlStr(Client_MastJNL_NO.AsString);
  DoQrySelect(sql,sysinfo.AdoConnection,Client_DT);
{
  ds_Client_dt.DataSet:=nil;
  Client_dt.First;
  while not client_dt.Eof do begin
    Client_dt.Edit;
    Client_dtJND_Amount.Value:=abs(Client_dtJND_Amount.Value);
    if Client_dtJND_DC.Value>=0 then
      Client_dtJND_DC.Value:=1
    else
      Client_dtJND_DC.Value:=-1;
    Client_dt.Post;
    Client_dt.Next;
  end;
  ds_Client_dt.DataSet:=Client_dt;
}


  ShowBalance;
{  ActEdit.Enabled:=IsUnbook;
  ActDelete.Enabled:=IsUnbook;
  BtnConfirm.Visible:=isUnBook;
  BtnUnConfirm.Visible:=not isUnBook;
}


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

procedure TFM_Journal.Client_dtCalcFields(DataSet: TDataSet);
begin
  Client_dtC_ACT_NAME.Value:=vartoSTR(TblLookup(sysinfo.AdoConnection,'TBL_ACNT_ACCOUNT','ACT_NO',Client_dtACT_NO.AsString,'ACT_NAME'));
  Client_dtC_SEQNO.Value:=client_dt.RecNo;
end;

procedure TFM_Journal.ActFirstExecute(Sender: TObject);
begin
  Client_Mast.First;
end;

procedure TFM_Journal.ActLastExecute(Sender: TObject);
begin
Client_Mast.Last;
end;

procedure TFM_Journal.ActPriorExecute(Sender: TObject);
begin
Client_Mast.Prior;
end;

procedure TFM_Journal.ActNextExecute(Sender: TObject);
begin
  Client_Mast.next;
end;

procedure TFM_Journal.ActEditExecute(Sender: TObject);
var
    year:integer;
begin

  year:= yearof(Client_MastJNL_DATE.Value);
  if year < sysinfo.SPR_ACNT_YEAR then begin
    Errmsg ('不得修改小於本會計年度的傳票 !',user);
  end;

  ModiFlag:=True;
  Client_Mast.Edit;
  dt_JNL_Date.SetFocus;
  SetEditMode(True);
end;

procedure TFM_Journal.SetEditMode(EditFlag: Boolean);
begin
//  sqlReport:=qryReport.SQL.Text;
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
  SetCtrlReadOnly(Edit_Jnl_No,true);
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

procedure TFM_Journal.ActAbortExecute(Sender: TObject);
begin
  Client_Mast.Cancel;
  SetEditMode(false);
end;

procedure TFM_Journal.ActAppendExecute(Sender: TObject);
begin
  ModiFlag:=false;
  client_dt.Close;
  DoQrySelect('SELECT JNL_NO,JND_SEQNO,ACT_NO,1 JND_DC, JND_AMOUNT,JND_DESC FROM TBL_ACNT_JOURNAL_DT WHERE JNL_NO IS NULL',sysinfo.AdoConnection,client_dt);
  client_dt.open;
  Client_Mast.Append;
  Client_Mast.fieldbyname('JNL_DATE').Value:=trunc(SYSDATE)+frac(now);
  Client_Mast.FieldByName('JNL_BILL_TYPE').Value:=0;
  dt_JNL_DATE.SetFocus;
  SetEditMode(true);

end;

procedure TFM_Journal.chkDetail;
VAR act_no:string;
    cnt:integer;
begin
  if AmountBalance <> 0 then begin
    errMsg('借貸不平衡 !',user);
  end;
  client_dt.First;
  cnt:=0;
  while not client_dt.Eof DO
  BEGIN
    cnt:=cnt+1;
    act_no:=client_dt.FieldByName('ACT_NO').AsString;
    if VARISNULL(TblLookup(sysinfo.AdoConnection,'TBL_ACNT_ACCOUNT','ACT_NO',ACT_NO,'ACT_NO')) then
      errMsg('項目'+inttostr(cnt)+' :'+ACT_NO+' :科目編號錯誤 !',user);
    if client_dt.FieldByName('JND_AMOUNT').AsCurrency=0 then
      errMsg('項目'+inttostr(cnt)+' :'+ACT_NO+' :金額為零 !',user);
    client_dt.Next;
  END;
end;


procedure TFM_Journal.RefreshData;
var sql,s:string;
    T:TDate;
begin
  screen.Cursor:=crSQLWait;
  TRY
    t:=now;
    Sql:='SELECT DISTINCT M.* '+CR
        +'FROM TBL_ACNT_JOURNAL M'+CR
        +'INNER JOIN TBL_ACNT_JOURNAL_DT D ON M.JNL_NO=D.JNL_NO '+CR
        + JoinWhere('',SqlWhere)+CR
        + JoinOrder('',SqlOrder);

    if Client_Mast.State<> dsinactive then
      s:=client_Mast.fieldbyname('JNL_NO').AsString;

    DEBUG(SQL);
    DoQrySelect(sql,sysinfo.AdoConnection,Client_Mast);
    if Client_mast.Eof then
    begin
      msg('查無任何資料 !');
    end;
    IF s='' then
      Client_Mast.Last
    else
      Client_Mast.Locate('JNL_NO',S,[]);
    hint(format('查尋時間:%f 秒',[ (now-t)*86400]));
  FINALLY
    screen.Cursor:=crDefault;
  END;

end;


procedure TFM_Journal.SaveMaster;
var sql:string;
begin
  sql:='INSERT INTO TBL_ACNT_JOURNAL '
      +'(JNL_NO'
      +',JNL_DATE'
      +',JNL_DESC'
      +',JNL_BILL_TYPE'
      +',JNL_CREATOR) '
      +' VALUES ('
      +sqlStr(Client_Mast.fieldbyname('JNL_NO').AsString)+','
      +sqlDateTimeSql(Client_Mast.fieldbyname('JNL_DATE').AsDateTime)+','
      +sqlStr(Client_Mast.fieldbyname('JNL_DESC').AsString)+','
      +Client_Mast.fieldbyname('JNL_BILL_TYPE').AsString+','
      +sqlStr(sysinfo.LoginUserName)+')';
  sysinfo.AdoConnection.Execute(SQL);


end;


procedure TFM_Journal.SaveDetail;
var sql:string;
  CNT:INTEGER;
begin
  client_dt.First;
  CNT:=0;
  while not client_dt.Eof DO
  BEGIN
    INC(CNT);
    Client_DT.Edit;
    Client_DT.FieldByName('JND_SEQNO').Value:=cnt;
    Client_DT.Post;

    sql:='INSERT INTO TBL_ACNT_JOURNAL_DT'
        +' (JNL_NO,JND_SEQNO,ACT_NO,'
        +' JND_AMOUNT,JND_DESC)'
        +' VALUES ('
        +sqlStr(Client_MastJNL_NO.AsString)+','
        +Client_DT.FieldByName('JND_SEQNO').AsString+','
        +sqlStr(Client_dtACT_NO.AsString)+','
        +client_DTJND_AMOUNT.AsString+','
        +sqlStr(client_dtJND_DESC.AsString)
        +')';
    sysinfo.AdoConnection.Execute(sql);
    client_dt.Next;
  end;


end;


procedure TFM_Journal.ActRefreshExecute(Sender: TObject);
begin
  RefreshData;
end;

procedure TFM_Journal.ActSaveExecute(Sender: TObject);
var jnl_no:string;
  t:tdate;
    year:integer;
begin

  year:= yearof(Client_MastJNL_DATE.Value);
  if year < sysinfo.SPR_ACNT_YEAR then begin
    Errmsg ('不得修改小於本會計年度的傳票 !',user);
  end;

    
    t:=now;
    ChkDetail;
    if not ModiFlag then
    begin
      Client_Mast.FieldByName('JNL_NO').Value:=GetNumbericCode(sysinfo.AdoConnection,'Tbl_ACNT_JOURNAL','JNL_NO','yyyymmdd',Client_Mast.fieldbyname('JNL_DATE').Value,4);
      SysDate:=Client_Mast.fieldbyname('JNL_DATE').Value;
    end;
    JNL_NO:=Client_Mast.FieldByName('JNL_NO').AsString;

    sysinfo.AdoConnection.BeginTrans;
    try
      if ModiFlag then
      begin
        DeleteDetail(JNL_no);
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

procedure TFM_Journal.DeleteDetail(jnl_NO:STRING);
var s:string;
begin
  S:='DELETE TBL_ACNT_JOURNAL_DT WHERE JNL_NO='+sqlStr(JNL_no);
  sysinfo.AdoConnection.Execute(s);
end;

procedure TFM_Journal.DeleteMaster(jnl_no:STRING);
var s:string;
begin
  S:='DELETE TBL_ACNT_JOURNAL WHERE JNL_NO='+sqlStr(JNL_NO);
  sysinfo.AdoConnection.Execute(s);
  client_mast.Delete;
end;



procedure TFM_Journal.UpdateMaster;
var sql:string;
begin
  sql:='UPDATE TBL_ACNT_JOURNAL'
      +' SET JNL_DATE='       +sqlDateTimeSql(Client_Mast.fieldbyname('JNL_DATE').AsDateTime)
      +',JNL_DESC='       +sqlStr(Client_Mast.fieldbyname('JNL_DESC').AsString)
      +',JNL_BILL_TYPE='  +Client_Mast.fieldbyname('JNL_BILL_TYPE').AsString
      +',JNL_CREATOR='    +sqlStr(sysinfo.LoginUserName)
      +' WHERE JNL_NO='   +sqlStr(Client_Mast.fieldbyname('JNL_NO').AsString);
      debug (sql);
      sysinfo.AdoConnection.Execute(SQL);

end;








procedure TFM_Journal.SetupQueryForm;
var fld:PQueryField;
    s1,s2:string;
begin
  WhereList:=TList.Create;
  OrderList:=TList.Create;

  NewQueryFld(fld);
  fld.FieldName   :=  'JNL_DATE';
  fld.DispName    :='交易日期';
  fld.TableAlias  :='M';
  fld.DataType    :=wdDate;
  fld.CtrlType    :=wcDate;
  fld.QueryType   :=wqRange;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'JNL_NO';
  fld.DispName    :='憑證編號';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);


  NewQueryFld(fld);
  fld.FieldName   :=  'ACT_NO';
  fld.DispName    :='科目編號';
  fld.TableAlias  :='D';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);

  Fm_Qry:=TFM_Query.Create(self);
  fm_qry.Init(sysinfo.AdoConnection,'','',WhereList,OrderList,query,dbsType);

  s1:=inttostr(sysinfo.spr_acnt_year)+'/01/01';
  s2:=inttostr(sysinfo.spr_acnt_year)+'/12/31';
  fm_qry.SetCtrlText(0,s1,s2);


end;

procedure TFM_Journal.ActQueryExecute(Sender: TObject);
var n:integer;
begin
  n:=fm_qry.ShowModal;
  if n=mrCancel then
    exit;
  sqlWhere:=Fm_qry.sqlWhere;      //取得 SQLWher  字串
  SQLOrder:=fm_qry.sqlOrder;      //取得 SQLOrder 字串
  RefreshData;

end;


procedure TFM_Journal.hint(msg: string);
begin
  lblStatus.Caption:=msg;
end;

procedure TFM_Journal.ActBrowseExecute(Sender: TObject);
var fm:TFm_Journal_Browse;
begin
  fm:=TFm_Journal_Browse.Create(application);
  fm.ds_mast:=ds_Master;
  fm.ds_detail:=ds_Client_dt;
  fm.init;
  try
    fm.ShowModal;
  finally
    fm.Free;
  end;

end;

procedure TFM_Journal.ActDeleteExecute(Sender: TObject);
var no:string;
    year:integer;
begin

  year:= yearof(Client_MastJNL_DATE.Value);
  if year < sysinfo.SPR_ACNT_YEAR then begin
    Errmsg ('不得修改小於本會計年度的傳票 !',user);
  end;

  if MessageDlg('是否確定刪除 ?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;

  no:=Client_Mast.FieldByName('JNL_NO').AsString;
  sysinfo.AdoConnection.BeginTrans;
  try
    DeleteDetail(no);
    DeleteMaster(no);
    sysinfo.AdoConnection.CommitTrans;
  except
    sysinfo.AdoConnection.RollbackTrans;
    raise;
  end;

end;

procedure TFM_Journal.Client_dtPRD_NOGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  text:=sender.AsString;

end;


procedure TFM_Journal.ActPrintExecute(Sender: TObject);
var fm:TFM_Journal_Print;
    mr:TModalResult;
    where:string;
    rpt:TppReport;
    sql:string;
begin
  fm:=TFM_Journal_Print.Create(application);
  try
    mr:=fm.ShowModal;
    case fm.RadioScope.ItemIndex of
      0:  where :='M.JNL_NO='+sqlStr(Client_mastJNL_NO.AsString);
      1:  where:=sqlWhere;
    end;
    sql:='SELECT M.JNL_DATE,M.JNL_NO,M.JNL_DESC' +CR
        +'			,D.ACT_NO' +CR
        +'			,DEBIT=CASE' +CR
        +'				WHEN D.JND_AMOUNT>=0 THEN D.JND_AMOUNT' +CR
        +'				ELSE 0' +CR
        +'			END' +CR
        +'			,CREDIT=CASE' +CR
        +'				WHEN D.JND_AMOUNT<0 THEN D.JND_AMOUNT * -1' +CR
        +'				ELSE 0' +CR
        +'			END' +CR
        +'			,D.JND_DESC' +CR
        +'		,C.ACT_NAME' +CR
        +'FROM TBL_ACNT_JOURNAL M' +CR
        +'INNER JOIN TBL_ACNT_JOURNAL_DT D ON M.JNL_NO=D.JNL_NO' +CR
        +'INNER JOIN TBL_ACNT_ACCOUNT C ON D.ACT_NO=C.ACT_NO' +CR
        +' WHERE '+where
        +' ORDER BY M.JNL_DATE,M.JNL_NO';
    qryReport.Connection:=sysinfo.AdoConnection;
    qryReport.Close;
    qryReport.sql.text:=sql;

     ppLblCorName.Caption:=sysinfo.SPR_COR_NAME;
    case fm.RadioFormat.ItemIndex of
      0 :rpt:=ppRep1;
      else rpt:=ppRep1;
    end;

    case mr of
      MrPrint   : BEGIN
        rpt.Print;
      END;
    end;
  finally
    fm.Free;
  end;

end;

procedure TFM_Journal.Client_dtC_JND_DCGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if sender.AsString='貸' then
    text:='  '+sender.AsString
  else
    TEXT:=sender.AsString;

end;

procedure TFM_Journal.Client_dtC_ACT_NAMEGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Client_dtJND_DC.Value>=0 then
    text:=sender.AsString
  else
    text:='    '+sender.AsString;
end;

procedure TFM_Journal.gridDblClick(Sender: TObject);
begin
  if (Client_mast.State<>dsInsert) and (Client_mast.State<>dsEdit) then exit;
  ChangeDC;


end;

procedure TFM_Journal.ChangeDC;
begin
  if grid.FocusedField.FieldName <>'JND_DC' THEN EXIT;
  client_dt.Edit;
  Client_dtJND_dc.Value:=-Client_dtJND_dc.Value;
  if Client_dtJnd_DC.Value>=0 then
    Client_dtJND_AMOUNT.Value:=abs(Client_dtJND_AMOUNT.Value)
  else
    Client_dtJND_AMOUNT.Value:=-abs(Client_dtJND_AMOUNT.Value);
  client_dt.Post;

end;

procedure TFM_Journal.gridKeyPress(Sender: TObject; var Key: Char);
begin
  if (Client_mast.State<>dsInsert) and (Client_mast.State<>dsEdit) then exit;
  if grid.FocusedField.FieldName <>'JND_DC' THEN EXIT;
  if key=#32 then changeDC;
  key:=#0;
end;

procedure TFM_Journal.ShowBalance;
var AmountDebit,AmountCredit:currency;
    amount:currency;

begin
  client_dt.First;
  AmountDebit:=0;
  AmountCredit:=0;
  while not client_dt.Eof do begin
    amount:=client_dt.fieldbyname('JND_AMOUNT').AsCurrency;
    if amount>=0 then
      AmountDebit:=AmountDebit+amount
    else
      AmountCredit:=AmountCredit+amount;
    client_dt.Next;
  end;
  amountCredit:=abs(AmountCredit);
  Edit_AmountDEbit.Text:=currtostr(AmountDebit);
  Edit_AmountCredit.Text:=currtostr(AmountCredit);
  AmountBalance:=AmountDebit-AmountCredit;
  Edit_AmountBalance.Text:=currtostr(AmountBalance);
  if AmountBalance>0 then begin
    Lbl_Balance.Font.Color:=clRed;
    Lbl_Balance.Caption:='借方餘額 :'+ currtostr(AmountBalance);
  end else if AmountBalance < 0 then begin
    Lbl_Balance.Font.Color:=clRed;
    Lbl_Balance.Caption:='貸方餘額 :'+ currtostr(abs(AmountBalance));
  end else begin
    Lbl_Balance.Font.color:=clBlue;
    Lbl_Balance.Caption:='借貸平衡';
  end;

end;

procedure TFM_Journal.ActShowBalanceExecute(Sender: TObject);
begin
  ShowBalance;
end;

procedure TFM_Journal.gridExit(Sender: TObject);
begin
ShowBalance;
end;

procedure TFM_Journal.gridACT_NOButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var s:string;
    slist:TStringList;
begin
  if Client_Mast.State=dsBrowse then exit;
  slist:=TStringList.Create;
  try
    s:=SelectACTNo(sysinfo,slist);
    if s=''then exit;
    client_dt.edit;
    Client_dtACT_NO.Value:=s;
    client_dt.post;
  finally
    slist.Free;
  end;

end;


procedure TFM_Journal.Client_dtNewRecord(DataSet: TDataSet);
begin
  Client_dtJND_DC.Value:=1;

end;

procedure TFM_Journal.gridChangeColumn(Sender: TObject; Node: TdxTreeListNode;
  Column: Integer);
begin
  if client_mast.State=dsBrowse then exit;
  case Column of
    1:hint ('切換借貸方請按空白鍵或用滑鼠雙擊');
    2:hint ('按 [CTRL]+[ENTER]:科目速查表');
    else
      hint ('');
  end;
end;

procedure TFM_Journal.Client_MastJNL_DATEValidate(Sender: TField);
var year :integer;
begin
  year := yearof(sender.asdatetime);
  if year < sysinfo.SPR_ACNT_YEAR then
    errmsg('傳票日期不得小於本會計年度 !'+cr+cr+'會計年度='+inttostr(sysinfo.SPR_ACNT_YEAR),user);

end;

procedure TFM_Journal.Client_dtJND_DCGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  if sender.AsCurrency>=0 then
    text:='借'
  else
    text:='  貸';

end;

procedure TFM_Journal.Client_dtJND_AMOUNTSetText(Sender: TField;
  const Text: String);
begin
  if Client_dtJnd_DC.Value>=0 then
    Client_dtJND_AMOUNT.Value:=abs(strtocurr(text))
  else
    Client_dtJND_AMOUNT.Value:=-abs(strtocurr(text));
end;


procedure TFM_Journal.Client_dtJND_AMOUNTGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  TEXT:=CURRTOSTR(ABS(SENDER.AsCurrency));
end;

procedure TFM_Journal.ppRep1PreviewFormCreate(Sender: TObject);
begin
  ppRep1.PreViewForm.WindowState := wsMaximized;
  TppViewer(ppRep1.preViewForm.Viewer).ZoomSetting := zsPageWidth;

end;

procedure TFM_Journal.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  CanClose:=True;
  if (Client_mast.State=dsInsert)
  or (Client_mast.State=dsEdit) then
  begin
    show;
    msg('在新增或修改模式，不能結束作業 ！');
    CanClose:=False;
  end;

end;

end.

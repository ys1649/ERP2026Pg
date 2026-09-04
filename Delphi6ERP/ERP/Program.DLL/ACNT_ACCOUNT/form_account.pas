unit form_account;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, Buttons, ExtCtrls, DB, ADODB, Mask, DBCtrls,
  ImgList,Form_Query, dxCntner, dxEditor, dxExEdtr, dxEdLib, dxDBELib,FORM_ERP_BASE,uty,erp_public;

type
  Tfm_account = class(TForm_erp)
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
    ActBrowse: TAction;
    ActFirst: TAction;
    ActLast: TAction;
    ActPrior: TAction;
    ActNext: TAction;
    ActSave: TAction;
    ActAbort: TAction;
    ActEditNo: TAction;
    qry: TADOQuery;
    DataSource1: TDataSource;
    ImageList1: TImageList;
    ActEdit: TAction;
    pnlCtrl: TPanel;
    BtnAppend: TButton;
    BtnEdit: TButton;
    BtnDelete: TButton;
    BtnQuery: TButton;
    BtnSave: TButton;
    BtnAbort: TButton;
    BtnFunc: TButton;
    Button1: TButton;
    qryACT_NO: TStringField;
    qryTYP_NO: TStringField;
    qryACT_NAME: TStringField;
    qryACT_CATEGORY_REVERSE: TBooleanField;
    qryACT_CATEGORY_CASH: TBooleanField;
    qryACT_DESC: TStringField;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit_Act_Name: TDBEdit;
    Check_ACT_CATEGORY_REVERSE: TDBCheckBox;
    Check_ACT_CATEGORY_CASH: TDBCheckBox;
    Label4: TLabel;
    Edit_Act_Desc: TDBEdit;
    Label6: TLabel;
    Edit_Act_Creator: TDBEdit;
    qryC_TYP_NAME: TStringField;
    Label5: TLabel;
    Edit_Typ_Name: TDBEdit;
    Edit_No: TdxDBButtonEdit;
    qryACT_CREATOR: TStringField;
    Edit_typ_no: TdxDBButtonEdit;
    procedure ActFirstExecute(Sender: TObject);
    procedure ActLastExecute(Sender: TObject);
    procedure ActPriorExecute(Sender: TObject);
    procedure ActNextExecute(Sender: TObject);
    procedure qryAfterScroll(DataSet: TDataSet);
    procedure ActAppendExecute(Sender: TObject);
    procedure ActEditExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ActAbortExecute(Sender: TObject);
    procedure ActDeleteExecute(Sender: TObject);
    procedure ActQueryExecute(Sender: TObject);
    procedure ActBrowseExecute(Sender: TObject);
    procedure qryCalcFields(DataSet: TDataSet);
    procedure qryACT_CATEGORY_REVERSEGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure Edit_NoButtonClick(Sender: TObject; AbsoluteIndex: Integer);
    procedure Edit_typ_noButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    Fm_Qry:TFM_Query;
    SQlWhere,SQLOrder:string;
    WhereList,OrderList:TList;
    PROCEDURE SetEditMode(mode:boolean);
    procedure SetupQueryForm;
    procedure RefreshData;
    procedure ChkValidNo;
  public
    procedure Init;override;
  end;


implementation

uses form_Browse, Form_Modify_No, DBUty;

{$R *.dfm}

procedure Tfm_account.Init;
begin
  qry.Connection:=sysinfo.AdoConnection;
  SetupQueryForm;
  SQlWhere:='';
  SQLOrder:='ACT_NO';
  RefreshData;
  SetEditMode(false);
end;

procedure Tfm_account.SetEditMode(mode: boolean);
begin
  SetOwnerCtrlReadOnly(self,not mode);
  ActAppend.Enabled:=not mode;
  ActEdit.Enabled:=not mode;
  ActDelete.Enabled:=not mode;
  ActQuery.Enabled:=not mode;
  ActBrowse.Enabled:=not mode;
  ActEditNo.Enabled:=not mode;             
  ActAbort.Enabled:= mode;
  ActSave.Enabled:= mode;
  ActFirst.Enabled:=not mode;
  ActPrior.Enabled:=not mode;
  ActNext.Enabled:=not mode;
  ActLast.Enabled:=not mode;
  SetCtrlReadOnly(Edit_Act_Creator,true);
  SetCtrlReadOnly(Edit_typ_name,true);
end;

procedure Tfm_account.ActFirstExecute(Sender: TObject);
begin
  qry.First;
end;

procedure Tfm_account.ActLastExecute(Sender: TObject);
begin
  qry.Last;
end;

procedure Tfm_account.ActPriorExecute(Sender: TObject);
begin
  qry.Prior;
end;

procedure Tfm_account.ActNextExecute(Sender: TObject);
begin
  qry.Next;
end;

procedure Tfm_account.qryAfterScroll(DataSet: TDataSet);
begin
  Edit_rec.Text:=format ('%d / %d',[QRY.recno,QRY.recordCount]);
  if qry.Eof then
  begin
    ActNext.Enabled:=false;
    ActLast.Enabled:=false;
  end else
  begin
    ActNext.Enabled:=true;
    ActLast.Enabled:=true;

  end;
  if qry.bof then
  begin
    ActPrior.Enabled:=false;
    ActFirst.Enabled:=false;
  end else
  begin
    ActPrior.Enabled:=True;
    ActFirst.Enabled:=True;
  end;

end;

procedure Tfm_account.ActAppendExecute(Sender: TObject);
begin
  qry.Append;
  qryACT_CREATOR.Value:=sysinfo.LoginUserName;
  qryACT_CATEGORY_REVERSE.Value:=false;
  qryACT_CATEGORY_CASH.Value:=false;
  SetEditMode(true);
  Edit_NO.SetFocus;
end;

procedure Tfm_account.ActEditExecute(Sender: TObject);
begin
  qry.Edit;
  seteditmode(true);
  SetCtrlReadOnly(Edit_NO,true);
  Edit_Act_Name.SetFocus;
end;

procedure Tfm_account.ActSaveExecute(Sender: TObject);
begin
  ChkValidNo;
  qry.Post;
  Seteditmode(false);
end;

procedure Tfm_account.ActAbortExecute(Sender: TObject);
begin
  qry.Cancel;
  Seteditmode(false);

end;

procedure Tfm_account.ActDeleteExecute(Sender: TObject);
begin
  if MessageDlg('是否確定刪除 ?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;
  TRY
    qry.Delete;
  EXCEPT
    MSG('資料使用中 ,無法刪除 !')
  END;
end;

procedure Tfm_account.SetupQueryForm;
var fld:PQueryField;
begin
  WhereList:=TList.Create;
  OrderList:=TList.Create;

  NewQueryFld(fld);
  fld.FieldName   :=  'ACT_NO';
  fld.DispName    :='科目編號';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'ACT_NAME';
  fld.DispName    :='科目名稱';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'TYP_NO';
  fld.DispName    :='科目類別';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);


  Fm_Qry:=TFM_Query.Create(self);
  fm_qry.Init(sysinfo.AdoConnection,'','',WhereList,OrderList,query,dbsType);
end;

procedure Tfm_account.RefreshData;
var sql:string;
begin
  screen.Cursor:=crSQLWait;
  TRY
    Sql:='SELECT * FROM TBL_ACNT_ACCOUNT M '+CR
        + JoinWhere('',SqlWhere)+CR
        + JoinOrder('',SqlOrder);
    QRY.Close;
    QRY.SQL.Text:=SQL;
    QRY.OPEN;
    if QRY.Eof then
    begin
      msg('查無任何資料 !');
    end;
  FINALLY
    screen.Cursor:=crDefault;
  END;

end;

procedure Tfm_account.ActQueryExecute(Sender: TObject);
var n:integer;
begin
  n:=fm_qry.ShowModal;
  if n=mrCancel then
    exit;
  sqlWhere:=Fm_qry.sqlWhere;      //取得 SQLWher  字串
  SQLOrder:=fm_qry.sqlOrder;      //取得 SQLOrder 字串
  RefreshData;

end;

procedure Tfm_account.ActBrowseExecute(Sender: TObject);
var fm:TFm_Browse;
begin
  fm:=TFM_Browse.Create(application);
  try
    fm.Browse(qry);
  finally
    fm.Free;
  end;
end;


procedure Tfm_account.qryCalcFields(DataSet: TDataSet);
begin
  qryC_TYP_NAME.Value:=vartostr(TblLookup(sysinfo.AdoConnection,'TBL_ACNT_TYPE','TYP_NO',qryTYP_NO.Value,'TYP_NAME'));
end;

procedure Tfm_account.qryACT_CATEGORY_REVERSEGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if sender.Value=true then
    Text:='是'
  else
    text:='否';
end;



procedure Tfm_account.Edit_NoButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var s:string;
    sql:string;
    QRY1:TAdoQuery;
    i:integer;
    fldName:string;
    list:TStringList;
begin
  if qry.State<>dsiNSERT then exit;
  list:=TStringList.Create;
  s:= SelectActNO(sysinfo,list);
  if s='' then exit;
  sql:='SELECT * FROM TBL_ACNT_ACCOUNT WHERE ACT_NO='+SQLSTR(S);
  qry1:=TAdoquery.Create(application);
  try
    qry1.Connection:=sysinfo.AdoConnection;
    qry1.SQL.Text:=sql;
    qry1.Open;
    for i:=0 to qry1.FieldCount-1 do
    begin
      fldName:=qry1.Fields[i].FieldName;
      qry.FieldByName(fldName).Value:=qry1.FieldByName(fldName).Value;
    end;
    qry.FieldByName('ACT_Creator').Value:=sysinfo.LoginUserName;
  finally
    qry1.Close;
    qry1.Free;
    list.Free;
  end;


end;

procedure Tfm_account.ChkValidNo;
var s:string;
    len:integer;
    msg:string;
    i:integer;
begin
  msg:='科目編號長度必須等於4碼或9碼,'
          +cr+cr+'四碼格式為4個數字,'
          +cr+cr+'9碼格式為前後各4位數字中間加一個小數點符號'
          +cr+cr+'例如:1111 (4碼) 或 1111.0001(9碼)';
  s:=qryACT_NO.Value;
  len:=length(s);
  if (len<>4) and (len<>9) then errmsg(msg,user);
  if (len=9) and (s[5] <> '.') then errmsg(msg,user);
  for i:=1 to len do begin
    if pos(s[i],'0123456789.')=0 then errmsg(msg,user);

  end;

end;

procedure Tfm_account.Edit_typ_noButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var s:string;
begin
  if qry.State=dsbrowse then exit;
    s:= SelectTypNO(sysinfo);
    if s<>'' then qryTYP_NO.Value:=s;
end;

procedure Tfm_account.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  if (qry.State=dsInsert)
  or (qry.State=dsEdit) then
  begin
    CanClose:=false;
    show;
    msg('在新增或修改模式，不能結束作業 ！');
  end else begin
    CanClose:=True;
  end;

end;

end.

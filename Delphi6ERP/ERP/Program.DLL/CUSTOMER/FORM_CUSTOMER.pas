unit FORM_CUSTOMER;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, Buttons, ExtCtrls, DB, ADODB, Mask, DBCtrls,
  ImgList,Form_Query, dxCntner, dxEditor, dxExEdtr, dxEdLib, dxDBELib,UTY,erp_public
  ,FORM_ERP_BASE;


type
  TFM_CUSTOMER = class(TFORM_ERP)
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
    qryCUM_NO: TStringField;
    qryCUM_NAME: TStringField;
    qryCUM_PRESIDENT: TStringField;
    qryCUM_CONTANT: TStringField;
    qryCUM_CONT_TITLE: TStringField;
    qryCUM_TEL1: TStringField;
    qryCUM_TEL2: TStringField;
    qryCUM_FAX: TStringField;
    qryCUM_UNIFORM_NO: TStringField;
    qryCUM_INV_ADDR: TStringField;
    qryCUM_ADDR: TStringField;
    qryCUM_ZIP_CODE: TStringField;
    qryCUM_ADVANCE_AMOUNT: TBCDField;
    qryCUM_DESC: TStringField;
    qryCUM_CREATOR: TStringField;
    Label1: TLabel;
    DataSource1: TDataSource;
    Label2: TLabel;
    Edit_Name: TDBEdit;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    Label4: TLabel;
    DBEdit4: TDBEdit;
    Label5: TLabel;
    DBEdit5: TDBEdit;
    Label6: TLabel;
    DBEdit6: TDBEdit;
    Label7: TLabel;
    DBEdit7: TDBEdit;
    Label8: TLabel;
    DBEdit8: TDBEdit;
    Label9: TLabel;
    DBEdit9: TDBEdit;
    Label10: TLabel;
    DBEdit10: TDBEdit;
    Label11: TLabel;
    DBEdit11: TDBEdit;
    Label12: TLabel;
    DBEdit12: TDBEdit;
    Label13: TLabel;
    Edit_Advance_Amount: TDBEdit;
    Label14: TLabel;
    DBEdit14: TDBEdit;
    Label15: TLabel;
    Edit_Creator: TDBEdit;
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
    Edit_No: TdxDBButtonEdit;
    qryCUM_INV_RATE: TBCDField;
    Label16: TLabel;
    DBEdit1: TDBEdit;
    ADOConnection1: TADOConnection;
    qryCUM_ACNT_AR: TStringField;
    qryCUM_ACNT_ADVANCE: TStringField;
    Button2: TButton;
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
    procedure Edit_NoButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure ActEditNoExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button2Click(Sender: TObject);
  private
    Fm_Qry:TFM_Query;
    SQlWhere,SQLOrder:string;
    WhereList,OrderList:TList;
    PROCEDURE SetEditMode(mode:boolean);
    PROCEDURE Modify_NO(OldNO,newNO:string);
    procedure SetupQueryForm;
    procedure RefreshData;

  public
    procedure Init;override;
  end;

implementation

uses form_Browse, Form_Modify_No;

{$R *.dfm}

procedure TFM_CUSTOMER.Init;
begin
  inherited;
  qry.Connection:=sysinfo.AdoConnection;
  SetupQueryForm;
  SQlWhere:='';
  SQLOrder:='CUM_NO';
  RefreshData;
  SetEditMode(false);
end;

procedure TFM_CUSTOMER.SetEditMode(mode: boolean);
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
  SetCtrlReadOnly(Edit_Creator,true);
  SetCtrlReadOnly(Edit_Advance_Amount,true);
  ActFirst.Enabled:=not mode;
  ActPrior.Enabled:=not mode;
  ActNext.Enabled:=not mode;
  ActLast.Enabled:=not mode;
end;

procedure TFM_CUSTOMER.ActFirstExecute(Sender: TObject);
begin
  qry.First;
end;

procedure TFM_CUSTOMER.ActLastExecute(Sender: TObject);
begin
  qry.Last;
end;

procedure TFM_CUSTOMER.ActPriorExecute(Sender: TObject);
begin
  qry.Prior;
end;

procedure TFM_CUSTOMER.ActNextExecute(Sender: TObject);
begin
  qry.Next;
end;

procedure TFM_CUSTOMER.qryAfterScroll(DataSet: TDataSet);
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

procedure TFM_CUSTOMER.ActAppendExecute(Sender: TObject);
begin
  qry.Append;
  qryCUM_ADVANCE_AMOUNT.Value:=0;
  qryCUM_CREATOR.Value:=sysinfo.LoginUserName;
  SetEditMode(true);
  Edit_No.SetFocus;
end;

procedure TFM_CUSTOMER.ActEditExecute(Sender: TObject);
begin
  qry.Edit;
  seteditmode(true);
  SetCtrlReadOnly(Edit_no,true);
  Edit_Name.SetFocus;
end;

procedure TFM_CUSTOMER.ActSaveExecute(Sender: TObject);
begin
  qry.Post;
  Seteditmode(false);
end;

procedure TFM_CUSTOMER.ActAbortExecute(Sender: TObject);
begin
  qry.Cancel;
  Seteditmode(false);

end;

procedure TFM_CUSTOMER.ActDeleteExecute(Sender: TObject);
begin
  if MessageDlg('是否確定刪除 ?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;
  TRY
    qry.Delete;
  EXCEPT
    MSG('資料使用中 ,無法刪除 !')
  END;
end;

procedure TFM_CUSTOMER.SetupQueryForm;
var fld:PQueryField;
begin
  WhereList:=TList.Create;
  OrderList:=TList.Create;

  NewQueryFld(fld);
  fld.FieldName   :=  'CUM_NO';
  fld.DispName    :='客戶編號';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'CUM_NAME';
  fld.DispName    :='客戶名稱';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'CUM_TEL1';
  fld.DispName    :='電話1';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'CUM_TEL2';
  fld.DispName    :='電話2';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'CUM_ZIP_CODE';
  fld.DispName    :='郵遞區號';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'CUM_CONTANT';
  fld.DispName    :='聯絡人';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'CUM_ADDR';
  fld.DispName    :='地址';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'CUM_INV_ADDR';
  fld.DispName    :='發票地址';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  Fm_Qry:=TFM_Query.Create(self);
  fm_qry.Init(sysinfo.AdoConnection,'','',WhereList,OrderList,query,dbsType);
end;

procedure TFM_CUSTOMER.RefreshData;
var sql:string;
begin
  screen.Cursor:=crSQLWait;
  TRY
    Sql:='SELECT * FROM TBL_CUSTOMER M '+CR
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

procedure TFM_CUSTOMER.ActQueryExecute(Sender: TObject);
var n:integer;
begin
  n:=fm_qry.ShowModal;
  if n=mrCancel then
    exit;
  sqlWhere:=Fm_qry.sqlWhere;      //取得 SQLWher  字串
  SQLOrder:=fm_qry.sqlOrder;      //取得 SQLOrder 字串
  RefreshData;

end;

procedure TFM_CUSTOMER.ActBrowseExecute(Sender: TObject);
var fm:TFm_Browse;
begin
  fm:=TFM_Browse.Create(application);
  try
    fm.Browse(qry);
  finally
    fm.Free;
  end;
end;

procedure TFM_CUSTOMER.Edit_NoButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var s:string;
    sql:string;
    QRY1:TAdoQuery;
    i:integer;
    fldName:string;
begin
  if qry.State<>dsiNSERT then exit;
  s:=SelectCumNO(sysinfo);
  if s='' then exit;
  sql:='SELECT * FROM TBL_CUSTOMER WHERE CUM_NO='+SQLSTR(S);
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
    qry.FieldByName('CUM_Creator').Value:=sysinfo.LoginUserName;
    qry.FieldByName('CUM_ADVANCE_AMOUNT').Value:=0;
  finally
    qry1.Close;
    qry1.Free;
  end;


end;

procedure TFM_CUSTOMER.ActEditNoExecute(Sender: TObject);
var fm:TFM_Modify_No;
    n:integer;
    NEW_NO:STRING;
begin
  fm:=TFM_Modify_No.Create(application);
  try
    FM.Edit_New_No.Text:=QRYCUM_NO.Value;
    n:=fm.ShowModal;
    if n=mrCancel then exit;
    NEW_NO:=TRIM(FM.Edit_New_No.Text);
    Modify_NO(qryCUM_NO.Value,NEW_NO);
    RefreshData;
    qry.Locate('CUM_NO',NEW_NO,[])
  finally
    fm.close;
  end;

end;

procedure TFM_CUSTOMER.Modify_NO(OldNO, newNO: string);
var sql:string;
begin
  sysinfo.AdoConnection.BeginTrans;
  try
    sql:='INSERT INTO TBL_CUSTOMER'
        +' (CUM_NO,CUM_NAME,CUM_PRESIDENT'
        +' ,CUM_CONTANT,CUM_CONT_TITLE,CUM_TEL1'
        +' ,CUM_TEL2,CUM_FAX,CUM_UNIFORM_NO'
        +' ,CUM_INV_ADDR,CUM_ADDR,CUM_ZIP_CODE'
        +' ,CUM_ADVANCE_AMOUNT,CUM_DESC,CUM_CREATOR)'
        +' VALUES('
        +SQLSTR(NEWNO) + ','
        +SQLSTR(qryCUM_NAME.AsString) + ','
        +SQLSTR(qryCUM_PRESIDENT.Value) + ','
        +SQLSTR(qryCUM_CONTANT.Value) + ','
        +SQLSTR(qryCUM_CONT_TITLE.Value) + ','
        +SQLSTR(qryCUM_TEL1.Value) + ','
        +SQLSTR(qryCUM_TEL2.Value) + ','
        +SQLSTR(qryCUM_FAX.Value) + ','
        +SQLSTR(qryCUM_UNIFORM_NO.Value) + ','
        +SQLSTR(qryCUM_INV_ADDR.Value) + ','
        +SQLSTR(qryCUM_ADDR.Value) + ','
        +SQLSTR(qryCUM_ZIP_CODE.Value) + ','
        +CURRTOSTR(qryCUM_ADVANCE_AMOUNT.Value) + ','
        +SQLSTR(qryCUM_DESC.Value) + ','
        +SQLSTR(sysinfo.LoginUserName)
        +')';
    sysinfo.AdoConnection.Execute(SQL);

    SQL:=' UPDATE TBL_SHIP SET CUM_NO='+SQLSTR(NEWNO)
        +' WHERE CUM_NO='+SQLSTR(oldNO);
    sysinfo.AdoConnection.Execute(SQL);

    SQL:=' UPDATE TBL_HIS_SHIP SET CUM_NO='+SQLSTR(NEWNO)
        +' WHERE CUM_NO='+SQLSTR(oldNO);
    sysinfo.AdoConnection.Execute(SQL);

    SQL:=' UPDATE TBL_AR_RECV SET CUM_NO='+SQLSTR(NEWNO)
        +' WHERE CUM_NO='+SQLSTR(oldNO);
    sysinfo.AdoConnection.Execute(SQL);

    SQL:=' DELETE TBL_CUSTOMER'
        +' WHERE CUM_NO='+SQLSTR(oldNO);
    sysinfo.AdoConnection.Execute(SQL);
    sysinfo.AdoConnection.CommitTrans;
  except
    sysinfo.AdoConnection.RollbackTrans;
    RAISE;
  end;


end;


procedure TFM_CUSTOMER.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
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

procedure TFM_CUSTOMER.Button2Click(Sender: TObject);
begin
  inherited;
  showmessage(G_str);
end;

end.

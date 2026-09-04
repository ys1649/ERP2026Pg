unit Form_Supplier;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, Buttons, ExtCtrls, DB, ADODB, Mask, DBCtrls,
  ImgList,Form_Query, dxCntner, dxEditor, dxExEdtr, dxEdLib, dxDBELib
  ,erp_public,FORM_ERP_BASE;

type
  Tfm_supplier = class(TFORM_ERP)
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
    QRY: TADOQuery;
    DataSource1: TDataSource;
    QRYSUP_NO: TStringField;
    QRYSUP_NAME: TStringField;
    QRYSUP_PRESIDENT: TStringField;
    QRYSUP_CONTANT: TStringField;
    QRYSUP_CONT_TITLE: TStringField;
    QRYSUP_TEL1: TStringField;
    QRYSUP_TEL2: TStringField;
    QRYSUP_FAX: TStringField;
    QRYSUP_UNIFORM_NO: TStringField;
    QRYSUP_INV_ADDR: TStringField;
    QRYSUP_ADDR: TStringField;
    QRYSUP_ZIP_CODE: TStringField;
    QRYSUP_ADVANCE_AMOUNT: TBCDField;
    QRYSUP_DESC: TStringField;
    QRYSUP_CREATOR: TStringField;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Edit_Name: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    DBEdit12: TDBEdit;
    Edit_Advance_Amount: TDBEdit;
    DBEdit14: TDBEdit;
    Edit_Creator: TDBEdit;
    Edit_No: TdxDBButtonEdit;
    ADOConnection1: TADOConnection;
    QRYSUP_ACNT_AP: TStringField;
    QRYSUP_ACNT_ADVANCE: TStringField;
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

uses Uty, form_Browse, Form_Modify_No;


{$R *.dfm}

procedure Tfm_supplier.Init;
begin
  inherited;
  qry.Connection:=sysinfo.AdoConnection;
  SetupQueryForm;
  SQlWhere:='';
  SQLOrder:='SUP_NO';
  RefreshData;
  SetEditMode(false);
end;

procedure Tfm_supplier.SetEditMode(mode: boolean);
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

procedure Tfm_supplier.ActFirstExecute(Sender: TObject);
begin
  qry.First;
end;

procedure Tfm_supplier.ActLastExecute(Sender: TObject);
begin
  qry.Last;
end;

procedure Tfm_supplier.ActPriorExecute(Sender: TObject);
begin
  qry.Prior;
end;

procedure Tfm_supplier.ActNextExecute(Sender: TObject);
begin
  qry.Next;
end;

procedure Tfm_supplier.qryAfterScroll(DataSet: TDataSet);
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

procedure Tfm_supplier.ActAppendExecute(Sender: TObject);
begin
  qry.Append;
  qrySUP_ADVANCE_AMOUNT.Value:=0;
  qrySUP_CREATOR.Value:=sysinfo.LoginUserName;
  SetEditMode(true);
  Edit_No.SetFocus;
end;

procedure Tfm_supplier.ActEditExecute(Sender: TObject);
begin
  qry.Edit;
  seteditmode(true);
  SetCtrlReadOnly(Edit_no,true);
  Edit_Name.SetFocus;
end;

procedure Tfm_supplier.ActSaveExecute(Sender: TObject);
begin
  qry.Post;
  Seteditmode(false);
end;

procedure Tfm_supplier.ActAbortExecute(Sender: TObject);
begin
  qry.Cancel;
  Seteditmode(false);

end;

procedure Tfm_supplier.ActDeleteExecute(Sender: TObject);
begin
  if MessageDlg('是否確定刪除 ?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;
  TRY
    qry.Delete;
  EXCEPT
    MSG('資料使用中 ,無法刪除 !')
  END;
end;

procedure Tfm_supplier.SetupQueryForm;
var fld:PQueryField;
begin
  WhereList:=TList.Create;
  OrderList:=TList.Create;

  NewQueryFld(fld);
  fld.FieldName   :=  'SUP_NO';
  fld.DispName    :='廠商編號';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'SUP_NAME';
  fld.DispName    :='廠商名稱';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'SUP_TEL1';
  fld.DispName    :='電話1';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'SUP_TEL2';
  fld.DispName    :='電話2';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'SUP_ZIP_CODE';
  fld.DispName    :='郵遞區號';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'SUP_CONTANT';
  fld.DispName    :='聯絡人';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'SUP_ADDR';
  fld.DispName    :='地址';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'SUP_INV_ADDR';
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

procedure Tfm_supplier.RefreshData;
var sql:string;
begin
  screen.Cursor:=crSQLWait;
  TRY
    Sql:='SELECT * FROM TBL_SUPPLIER M '+CR
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

procedure Tfm_supplier.ActQueryExecute(Sender: TObject);
var n:integer;
begin
  n:=fm_qry.ShowModal;
  if n=mrCancel then
    exit;
  sqlWhere:=Fm_qry.sqlWhere;      //取得 SQLWher  字串
  SQLOrder:=fm_qry.sqlOrder;      //取得 SQLOrder 字串
  RefreshData;

end;

procedure Tfm_supplier.ActBrowseExecute(Sender: TObject);
var fm:TFm_Browse;
begin
  fm:=TFM_Browse.Create(application);
  try
    fm.Browse(qry);
  finally
    fm.Free;
  end;
end;

procedure Tfm_supplier.Edit_NoButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var s:string;
    sql:string;
    QRY1:TAdoQuery;
    i:integer;
    fldName:string;
begin
  if qry.State<>dsiNSERT then exit;
  s:=SelectSupNO(sysinfo);
  if s='' then exit;
  sql:='SELECT * FROM TBL_SUPPLIER WHERE SUP_NO='+SQLSTR(S);
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
    qry.FieldByName('SUP_Creator').Value:=sysinfo.LoginUserName;
    qry.FieldByName('SUP_ADVANCE_AMOUNT').Value:=0;
  finally
    qry1.Close;
    qry1.Free;
  end;


end;

procedure Tfm_supplier.ActEditNoExecute(Sender: TObject);
var fm:TFM_Modify_No;
    n:integer;
    NEW_NO:STRING;
begin
  fm:=TFM_Modify_No.Create(application);
  try
    FM.Edit_New_No.Text:=QRYSUP_NO.Value;
    n:=fm.ShowModal;
    if n=mrCancel then exit;
    NEW_NO:=TRIM(FM.Edit_New_No.Text);
    Modify_NO(qrySUP_NO.Value,NEW_NO);
    RefreshData;
    qry.Locate('SUP_NO',NEW_NO,[])
  finally
    fm.close;
  end;

end;

procedure Tfm_supplier.Modify_NO(OldNO, newNO: string);
var sql:string;
begin
  sysinfo.AdoConnection.BeginTrans;
  try
    sql:='INSERT INTO TBL_SUPPLIER'
        +' (SUP_NO,SUP_NAME,SUP_PRESIDENT'
        +' ,SUP_CONTANT,SUP_CONT_TITLE,SUP_TEL1'
        +' ,SUP_TEL2,SUP_FAX,SUP_UNIFORM_NO'
        +' ,SUP_INV_ADDR,SUP_ADDR,SUP_ZIP_CODE'
        +' ,SUP_ADVANCE_AMOUNT,SUP_DESC,SUP_CREATOR)'
        +' VALUES('
        +SQLSTR(NEWNO) + ','
        +SQLSTR(qrySUP_NAME.AsString) + ','
        +SQLSTR(qrySUP_PRESIDENT.Value) + ','
        +SQLSTR(qrySUP_CONTANT.Value) + ','
        +SQLSTR(qrySUP_CONT_TITLE.Value) + ','
        +SQLSTR(qrySUP_TEL1.Value) + ','
        +SQLSTR(qrySUP_TEL2.Value) + ','
        +SQLSTR(qrySUP_FAX.Value) + ','
        +SQLSTR(qrySUP_UNIFORM_NO.Value) + ','
        +SQLSTR(qrySUP_INV_ADDR.Value) + ','
        +SQLSTR(qrySUP_ADDR.Value) + ','
        +SQLSTR(qrySUP_ZIP_CODE.Value) + ','
        +CURRTOSTR(qrySUP_ADVANCE_AMOUNT.Value) + ','
        +SQLSTR(qrySUP_DESC.Value) + ','
        +SQLSTR(sysinfo.LoginUserName)
        +')';
    sysinfo.AdoConnection.Execute(SQL);

    SQL:=' UPDATE TBL_PO_RECV SET SUP_NO='+SQLSTR(NEWNO)
        +' WHERE SUP_NO='+SQLSTR(oldNO);
    sysinfo.AdoConnection.Execute(SQL);

    SQL:=' UPDATE TBL_HIS_PO_RECV SET SUP_NO='+SQLSTR(NEWNO)
        +' WHERE SUP_NO='+SQLSTR(oldNO);
    sysinfo.AdoConnection.Execute(SQL);

    SQL:=' UPDATE TBL_AP_PAY SET SUP_NO='+SQLSTR(NEWNO)
        +' WHERE SUP_NO='+SQLSTR(oldNO);
    sysinfo.AdoConnection.Execute(SQL);

    SQL:=' DELETE TBL_SUPPLIER'
        +' WHERE SUP_NO='+SQLSTR(oldNO);
    sysinfo.AdoConnection.Execute(SQL);
    sysinfo.AdoConnection.CommitTrans;
  except
    sysinfo.AdoConnection.RollbackTrans;
    RAISE;
  end;


end;

procedure Tfm_supplier.FormCloseQuery(Sender: TObject;
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

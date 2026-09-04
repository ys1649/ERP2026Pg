unit form_product;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, Buttons, ExtCtrls, DB, ADODB, Mask, DBCtrls,
  ImgList,Form_Query, dxCntner, dxEditor, dxExEdtr, dxEdLib, dxDBELib,FORM_ERP_BASE,uty,erp_public;

type
  Tfm_product = class(TForm_ERP)
    pnlStatus: TPanel;
    Panel1: TPanel;
    btnPrior: TSpeedButton;
    btnNext: TSpeedButton;
    BtnLast: TSpeedButton;
    btnFirst: TSpeedButton;
    Edit_Rec: TEdit;
    Panel3: TPanel;
    LblStatus: TLabel;
    pnlCtrl: TPanel;
    BtnAppend: TButton;
    BtnEdit: TButton;
    BtnDelete: TButton;
    BtnQuery: TButton;
    BtnSave: TButton;
    BtnAbort: TButton;
    BtnFunc: TButton;
    Button1: TButton;
    ActionList1: TActionList;
    ActAppend: TAction;
    ActEdit: TAction;
    ActQuery: TAction;
    ActDelete: TAction;
    ActSave: TAction;
    ActAbort: TAction;
    ActEditNo: TAction;
    ActBrowse: TAction;
    ActFirst: TAction;
    ActLast: TAction;
    ActPrior: TAction;
    ActNext: TAction;
    qry: TADOQuery;
    qryPRD_NO: TStringField;
    qryPRD_NAME: TStringField;
    qryPRD_UNIT: TStringField;
    qryPRD_SALE_PRICE: TBCDField;
    qryPRD_SAFE_QTY: TBCDField;
    qryPRD_ONHAND: TBCDField;
    qryPRD_CUR_COST: TBCDField;
    qryPRD_DESC: TStringField;
    qryPRD_IS_DUMMY: TBooleanField;
    qryPRD_DUM_COST_RATE: TBCDField;
    qryPRD_EXT_COST_RATIO: TBCDField;
    qryPRD_CREATOR: TStringField;
    DataSource1: TDataSource;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Edit_Name: TDBEdit;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    Label4: TLabel;
    DBEdit4: TDBEdit;
    Label5: TLabel;
    DBEdit5: TDBEdit;
    Label6: TLabel;
    Edit_PRD_OnHand: TDBEdit;
    Label7: TLabel;
    Edit_PRD_CUR_COST: TDBEdit;
    DBCheckBox1: TDBCheckBox;
    Label8: TLabel;
    DBEdit8: TDBEdit;
    Label9: TLabel;
    DBEdit9: TDBEdit;
    Label10: TLabel;
    DBEdit10: TDBEdit;
    Label11: TLabel;
    Edit_Creator: TDBEdit;
    Edit_NO: TdxDBButtonEdit;
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

var
  fm_product: Tfm_product;

implementation

uses form_Browse, Form_Modify_No;

{$R *.dfm}

procedure Tfm_product.Init;
begin
  inherited;
  
  qry.Connection:=sysinfo.AdoConnection;
  SetupQueryForm;
  SQlWhere:='';
  SQLOrder:='PRD_NO';
  RefreshData;
  SetEditMode(false);
end;

procedure Tfm_product.SetEditMode(mode: boolean);
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
  SetCtrlReadOnly(Edit_PRD_OnHand,true);
  SetCtrlReadOnly(Edit_PRD_CUR_COST,true);
  ActFirst.Enabled:=not mode;
  ActPrior.Enabled:=not mode;
  ActNext.Enabled:=not mode;
  ActLast.Enabled:=not mode;
end;

procedure Tfm_product.ActFirstExecute(Sender: TObject);
begin
  qry.First;
end;

procedure Tfm_product.ActLastExecute(Sender: TObject);
begin
  qry.Last;
end;

procedure Tfm_product.ActPriorExecute(Sender: TObject);
begin
  qry.Prior;
end;

procedure Tfm_product.ActNextExecute(Sender: TObject);
begin
  qry.Next;
end;

procedure Tfm_product.qryAfterScroll(DataSet: TDataSet);
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

procedure Tfm_product.ActAppendExecute(Sender: TObject);
begin
  qry.Append;
  qryPRD_SALE_PRICE.Value:=0;
  qryPRD_SAFE_QTY.Value:=0;
  qryPRD_ONHAND.Value:=0;
  qryPRD_CUR_COST.Value:=0;
  qryPRD_IS_DUMMY.Value:=false;
  qryPRD_DUM_COST_RATE.Value:=0;
  qryPRD_EXT_COST_RATIO.Value:=sysinfo.SPR_PRD_COST_RATE;
  qryPRD_CREATOR.Value:=sysinfo.LoginUserName;
  SetEditMode(true);
  Edit_No.SetFocus;
end;

procedure Tfm_product.ActEditExecute(Sender: TObject);
begin
  qry.Edit;
  seteditmode(true);
  SetCtrlReadOnly(Edit_no,true);
  Edit_Name.SetFocus;
end;

procedure Tfm_product.ActSaveExecute(Sender: TObject);
begin
  qry.Post;
  Seteditmode(false);
end;

procedure Tfm_product.ActAbortExecute(Sender: TObject);
begin
  qry.Cancel;
  Seteditmode(false);

end;

procedure Tfm_product.ActDeleteExecute(Sender: TObject);
begin
  if MessageDlg('是否確定刪除 ?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;
  TRY
    qry.Delete;
  EXCEPT
    MSG('資料使用中 ,無法刪除 !')
  END;
end;

procedure Tfm_product.SetupQueryForm;
var fld:PQueryField;
begin
  WhereList:=TList.Create;
  OrderList:=TList.Create;

  NewQueryFld(fld);
  fld.FieldName   :=  'PRD_NO';
  fld.DispName    :='產品編號';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'PRD_NAME';
  fld.DispName    :='產品名稱';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);


  Fm_Qry:=TFM_Query.Create(self);
  fm_qry.Init(sysinfo.AdoConnection,'','',WhereList,OrderList,query,dbsType);
end;

procedure Tfm_product.RefreshData;
var sql:string;
begin
  screen.Cursor:=crSQLWait;
  TRY
    Sql:='SELECT * FROM TBL_PRODUCT M '+CR
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

procedure Tfm_product.ActQueryExecute(Sender: TObject);
var n:integer;
begin
  n:=fm_qry.ShowModal;
  if n=mrCancel then
    exit;
  sqlWhere:=Fm_qry.sqlWhere;      //取得 SQLWher  字串
  SQLOrder:=fm_qry.sqlOrder;      //取得 SQLOrder 字串
  RefreshData;

end;

procedure Tfm_product.ActBrowseExecute(Sender: TObject);
var fm:TFm_Browse;
begin
  fm:=TFM_Browse.Create(application);
  try
    fm.Browse(qry);
  finally
    fm.Free;
  end;
end;

procedure Tfm_product.Edit_NoButtonClick(Sender: TObject;
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
  s:= SelectPrdNO(sysinfo,list);
  if s='' then exit;
  sql:='SELECT * FROM TBL_PRODUCT WHERE PRD_NO='+SQLSTR(S);
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
    qry.FieldByName('PRD_Creator').Value:=sysinfo.LoginUserName;
    qry.FieldByName('PRD_ONHAND').Value:=0;
    qry.FieldByName('PRD_CUR_COST').Value:=0;
  finally
    qry1.Close;
    qry1.Free;
    list.Free;
  end;


end;

procedure Tfm_product.ActEditNoExecute(Sender: TObject);
var fm:TFM_Modify_No;
    n:integer;
    NEW_NO:STRING;
begin
  fm:=TFM_Modify_No.Create(application);
  try
    FM.Edit_New_No.Text:=QRYPRD_NO.Value;
    n:=fm.ShowModal;
    if n=mrCancel then exit;
    NEW_NO:=TRIM(FM.Edit_New_No.Text);
    Modify_NO(qryPrd_NO.Value,NEW_NO);
    RefreshData;
    qry.Locate('PRD_NO',NEW_NO,[])
  finally
    fm.close;
  end;

end;

procedure Tfm_product.Modify_NO(OldNO, newNO: string);
var sql,PRD_IS_DUMMY:string;

begin
  sysinfo.AdoConnection.BeginTrans;
  try
    if qryPRD_IS_DUMMY.Value then
      PRD_IS_DUMMY:='1'
    else
      PRD_IS_DUMMY:='0';

    sql:='INSERT INTO TBL_PRODUCT'
        +' (PRD_NO,PRD_NAME,PRD_UNIT'
        +' ,PRD_SALE_PRICE,PRD_SAFE_QTY,PRD_ONHAND'
        +' ,PRD_CUR_COST,PRD_DESC,PRD_IS_DUMMY'
        +' ,PRD_DUM_COST_RATE,PRD_EXT_COST_RATIO,PRD_CREATOR)'
        +' VALUES('
        +SQLSTR(NEWNO) + ','
        +SQLSTR(qryPRD_NAME.AsString) + ','
        +SQLSTR(qryPRD_UNIT.AsString) + ','
        +qryPRD_SALE_PRICE.AsString + ','
        +qryPRD_SAFE_QTY.AsString + ','
        +qryPRD_ONHAND.AsString + ','
        +qryPRD_CUR_COST.AsString + ','
        +SQLSTR(qryPRD_DESC.AsString) + ','
        +PRD_IS_DUMMY + ','
        +qryPRD_DUM_COST_RATE.AsString +','
        +qryPRD_EXT_COST_RATIO.AsString+','
        +SQLSTR(sysinfo.LoginUserName)
        +')';
    sysinfo.AdoConnection.Execute(SQL);

    SQL:=' UPDATE TBL_SHIP_DT SET PRD_NO='+SQLSTR(NEWNO)
        +' WHERE PRD_NO='+SQLSTR(oldNO);
    sysinfo.AdoConnection.Execute(SQL);

    SQL:=' UPDATE TBL_HIS_SHIP_DT SET PRD_NO='+SQLSTR(NEWNO)
        +' WHERE PRD_NO='+SQLSTR(oldNO);
    sysinfo.AdoConnection.Execute(SQL);

    SQL:=' UPDATE TBL_PO_RECV_DT SET PRD_NO='+SQLSTR(NEWNO)
        +' WHERE PRD_NO='+SQLSTR(oldNO);
    sysinfo.AdoConnection.Execute(SQL);

    SQL:=' UPDATE TBL_HIS_PO_RECV_DT SET PRD_NO='+SQLSTR(NEWNO)
        +' WHERE PRD_NO='+SQLSTR(oldNO);
    sysinfo.AdoConnection.Execute(SQL);

    SQL:=' UPDATE TBL_INV_ADJ_DT SET PRD_NO='+SQLSTR(NEWNO)
        +' WHERE PRD_NO='+SQLSTR(oldNO);
    sysinfo.AdoConnection.Execute(SQL);

    SQL:=' UPDATE TBL_INV_ONHAND SET PRD_NO='+SQLSTR(NEWNO)
        +' WHERE PRD_NO='+SQLSTR(oldNO);
    sysinfo.AdoConnection.Execute(SQL);

    SQL:=' UPDATE TBL_TRANSACTION SET PRD_NO='+SQLSTR(NEWNO)
        +' WHERE PRD_NO='+SQLSTR(oldNO);
    sysinfo.AdoConnection.Execute(SQL);

    SQL:=' DELETE TBL_PRODUCT'
        +' WHERE PRD_NO='+SQLSTR(oldNO);
    sysinfo.AdoConnection.Execute(SQL);
    sysinfo.AdoConnection.CommitTrans;
  except
    sysinfo.AdoConnection.RollbackTrans;
    RAISE;
  end;


end;

procedure Tfm_product.FormCloseQuery(Sender: TObject;
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

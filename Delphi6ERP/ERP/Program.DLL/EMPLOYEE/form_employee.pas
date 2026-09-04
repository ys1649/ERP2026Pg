unit form_employee;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, Buttons, ExtCtrls, DB, ADODB, Mask, DBCtrls,
  ImgList,Form_Query, dxCntner, dxEditor, dxExEdtr, dxEdLib, dxDBELib,FORM_ERP_BASE,erp_public;

type
  Tfm_employee = class(TForm_ERP)
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
    qryEPY_NO: TStringField;
    qryEPY_NAME: TStringField;
    qryEPY_PASSWORD: TStringField;
    qryEPY_TEL1: TStringField;
    qryEPY_TEL2: TStringField;
    qryEPY_ADDR: TStringField;
    qryEPY_IS_CAN_LOGIN: TBooleanField;
    qryEPY_DESC: TStringField;
    qryEPY_CREATOR: TStringField;
    Label1: TLabel;
    Edit_NO: TDBEdit;
    Label2: TLabel;
    Edit_Name: TDBEdit;
    Label3: TLabel;
    Edit_Password: TDBEdit;
    Label4: TLabel;
    DBEdit4: TDBEdit;
    Label5: TLabel;
    DBEdit5: TDBEdit;
    Label6: TLabel;
    DBEdit6: TDBEdit;
    DBCheckBox1: TDBCheckBox;
    Label7: TLabel;
    DBEdit7: TDBEdit;
    Label8: TLabel;
    Edit_Creator: TDBEdit;
    Label9: TLabel;
    Edit_Pass2: TEdit;
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
    procedure ActEditNoExecute(Sender: TObject);
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

procedure Tfm_employee.Init;
begin
  qry.Connection:=sysinfo.AdoConnection;
  SetupQueryForm;
  SQlWhere:='';
  SQLOrder:='EPY_NO';
  RefreshData;
  SetEditMode(false);
end;

procedure Tfm_employee.SetEditMode(mode: boolean);
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
  ActFirst.Enabled:=not mode;
  ActPrior.Enabled:=not mode;
  ActNext.Enabled:=not mode;
  ActLast.Enabled:=not mode;
end;

procedure Tfm_employee.ActFirstExecute(Sender: TObject);
begin
  qry.First;
end;

procedure Tfm_employee.ActLastExecute(Sender: TObject);
begin
  qry.Last;
end;

procedure Tfm_employee.ActPriorExecute(Sender: TObject);
begin
  qry.Prior;
end;

procedure Tfm_employee.ActNextExecute(Sender: TObject);
begin
  qry.Next;
end;

procedure Tfm_employee.qryAfterScroll(DataSet: TDataSet);
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

procedure Tfm_employee.ActAppendExecute(Sender: TObject);
begin
  qry.Append;
  qryEPY_IS_CAN_LOGIN.Value:=true;
  qryEPY_CREATOR.Value:=sysinfo.LoginUserName;
  SetEditMode(true);
  Edit_No.SetFocus;
end;

procedure Tfm_employee.ActEditExecute(Sender: TObject);
begin
  qry.Edit;
  seteditmode(true);
  SetCtrlReadOnly(Edit_no,true);
  Edit_Name.SetFocus;
end;

procedure Tfm_employee.ActSaveExecute(Sender: TObject);
begin
  if Edit_Password.Text<>Edit_Pass2.Text then
    errMsg(' 密碼不正確 !',user);
  qry.Post;
  Seteditmode(false);
end;

procedure Tfm_employee.ActAbortExecute(Sender: TObject);
begin
  qry.Cancel;
  Seteditmode(false);

end;

procedure Tfm_employee.ActDeleteExecute(Sender: TObject);
begin
  if MessageDlg('是否確定刪除 ?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;
  TRY
    qry.Delete;
  EXCEPT
    MSG('資料使用中 ,無法刪除 !')
  END;
end;

procedure Tfm_employee.SetupQueryForm;
var fld:PQueryField;
begin
  WhereList:=TList.Create;
  OrderList:=TList.Create;

  NewQueryFld(fld);
  fld.FieldName   :=  'EPY_NO';
  fld.DispName    :='員工編號';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'EPY_NAME';
  fld.DispName    :='員工姓名';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'EPY_TEL1';
  fld.DispName    :='電話1';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'EPY_TEL2';
  fld.DispName    :='電話2';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  Fm_Qry:=TFM_Query.Create(self);
  fm_qry.Init(sysinfo.AdoConnection,'','',WhereList,OrderList,query,dbsType);
end;

procedure Tfm_employee.RefreshData;
var sql:string;
begin
  screen.Cursor:=crSQLWait;
  TRY
    Sql:='SELECT * FROM TBL_EMPLOYE M '+CR
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

procedure Tfm_employee.ActQueryExecute(Sender: TObject);
var n:integer;
begin
  n:=fm_qry.ShowModal;
  if n=mrCancel then
    exit;
  sqlWhere:=Fm_qry.sqlWhere;      //取得 SQLWher  字串
  SQLOrder:=fm_qry.sqlOrder;      //取得 SQLOrder 字串
  RefreshData;

end;

procedure Tfm_employee.ActBrowseExecute(Sender: TObject);
var fm:TFm_Browse;
begin
  fm:=TFM_Browse.Create(application);
  try
    fm.Browse(qry);
  finally
    fm.Free;
  end;
end;


procedure Tfm_employee.ActEditNoExecute(Sender: TObject);
var fm:TFM_Modify_No;
    n:integer;
    NEW_NO:STRING;
begin
  fm:=TFM_Modify_No.Create(application);
  try
    FM.Edit_New_No.Text:=QRYEPY_NO.Value;
    n:=fm.ShowModal;
    if n=mrCancel then exit;
    NEW_NO:=TRIM(FM.Edit_New_No.Text);
    Modify_NO(qryEPY_NO.Value,NEW_NO);
    RefreshData;
    qry.Locate('EPY_NO',NEW_NO,[])
  finally
    fm.close;
  end;

end;

procedure Tfm_employee.Modify_NO(OldNO, newNO: string);
var IS_CAN_LOGIN,sql:string;

begin
  sysinfo.AdoConnection.BeginTrans;
  IF QRYEPY_IS_CAN_LOGIN.VALUE THEN
    IS_CAN_LOGIN:='1'
  ELSE
    IS_CAN_LOGIN:='0';
  try
    sql:='INSERT INTO TBL_EMPLOYE'
        +' (EPY_NO,EPY_NAME,EPY_PASSWORD'
        +' ,EPY_TEL1,EPY_TEL2,EPY_ADDR'
        +' ,EPY_IS_CAN_LOGIN,EPY_DESC,EPY_CREATOR)'
        +' VALUES('
        +SQLSTR(NEWNO) + ','
        +SQLSTR(qryEPY_NAME.AsString) + ','
        +SQLSTR(qryEPY_PASSWORD.ASSTRING)+','
        +SQLSTR(QRYEPY_TEL1.ASSTRING)+','
        +SQLSTR(QRYEPY_TEL2.ASSTRING)+','
        +SQLSTR(QRYEPY_ADDR.ASSTRING)+','
        +IS_CAN_LOGIN+','
        +SQLSTR(qryEPY_DESC.Value) + ','
        +SQLSTR(sysinfo.LoginUserName)
        +')';
    sysinfo.AdoConnection.Execute(SQL);

    SQL:=' UPDATE TBL_SHIP SET EPY_NO='+SQLSTR(NEWNO)
        +' WHERE EPY_NO='+SQLSTR(oldNO);
    sysinfo.AdoConnection.Execute(SQL);


    SQL:=' UPDATE TBL_SHIP SET SMT_DELIVER1='+SQLSTR(NEWNO)
        +' WHERE SMT_DELIVER1='+SQLSTR(oldNO);
    sysinfo.AdoConnection.Execute(SQL);

    SQL:=' UPDATE TBL_SHIP SET SMT_DELIVER2='+SQLSTR(NEWNO)
        +' WHERE SMT_DELIVER2='+SQLSTR(oldNO);
    sysinfo.AdoConnection.Execute(SQL);


    SQL:=' DELETE TBL_EMPLOYE'
        +' WHERE EPY_NO='+SQLSTR(oldNO);
    sysinfo.AdoConnection.Execute(SQL);
    sysinfo.AdoConnection.CommitTrans;
  except
    sysinfo.AdoConnection.RollbackTrans;
    RAISE;
  end;


end;

end.

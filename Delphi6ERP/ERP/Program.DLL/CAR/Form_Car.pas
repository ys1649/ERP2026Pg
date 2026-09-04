unit Form_Car;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, Buttons, ExtCtrls, DB, ADODB, Mask, DBCtrls,
  ImgList,Form_Query, dxCntner, dxEditor, dxExEdtr, dxEdLib, dxDBELib,
  wwdbdatetimepicker,FORM_ERP_BASE,erp_public;

type
  Tfm_car = class(TForm_ERP)
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
    qryCAR_NO: TStringField;
    qryCAR_BRAND: TStringField;
    qryCAR_LICENSE_NO: TStringField;
    qryCAR_DATE1: TDateTimeField;
    qryCAR_DESC: TStringField;
    qryCAR_CREATOR: TStringField;
    Label2: TLabel;
    edit_brand: TDBEdit;
    Label3: TLabel;
    edit_license_no: TDBEdit;
    Label4: TLabel;
    Label5: TLabel;
    Edit_Creator: TDBEdit;
    Label6: TLabel;
    edit_desc: TDBEdit;
    Label7: TLabel;
    Edit_NO: TDBEdit;
    edit_Date1: TwwDBDateTimePicker;
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

uses Uty, form_Browse,
  Form_Modify_No;

{$R *.dfm}

procedure Tfm_car.Init;
begin
  qry.Connection:=sysinfo.AdoConnection;
  SetupQueryForm;
  SQlWhere:='';
  SQLOrder:='CAR_NO';
  RefreshData;
  SetEditMode(false);
end;

procedure Tfm_car.SetEditMode(mode: boolean);
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

procedure Tfm_car.ActFirstExecute(Sender: TObject);
begin
  qry.First;
end;

procedure Tfm_car.ActLastExecute(Sender: TObject);
begin
  qry.Last;
end;

procedure Tfm_car.ActPriorExecute(Sender: TObject);
begin
  qry.Prior;
end;

procedure Tfm_car.ActNextExecute(Sender: TObject);
begin
  qry.Next;
end;

procedure Tfm_car.qryAfterScroll(DataSet: TDataSet);
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

procedure Tfm_car.ActAppendExecute(Sender: TObject);
begin
  qry.Append;
  qryCAR_CREATOR.Value:=sysinfo.LoginUserName;
  SetEditMode(true);
  Edit_No.SetFocus;
end;

procedure Tfm_car.ActEditExecute(Sender: TObject);
begin
  qry.Edit;
  seteditmode(true);
  SetCtrlReadOnly(Edit_no,true);
  Edit_Brand.SetFocus;
end;

procedure Tfm_car.ActSaveExecute(Sender: TObject);
begin
  qry.Post;
  Seteditmode(false);
end;

procedure Tfm_car.ActAbortExecute(Sender: TObject);
begin
  qry.Cancel;
  Seteditmode(false);

end;

procedure Tfm_car.ActDeleteExecute(Sender: TObject);
begin
  if MessageDlg('是否確定刪除 ?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;
  TRY
    qry.Delete;
  EXCEPT
    MSG('資料使用中 ,無法刪除 !')
  END;
end;

procedure Tfm_car.SetupQueryForm;
var fld:PQueryField;
begin
  WhereList:=TList.Create;
  OrderList:=TList.Create;

  NewQueryFld(fld);
  fld.FieldName   :=  'CAR_NO';
  fld.DispName    :='車輛編號';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'CAR_BRAND';
  fld.DispName    :='廠牌形式';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'CAR_LICENSE';
  fld.DispName    :='車牌號碼';
  fld.TableAlias  :='M';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqSingle;
  WhereList.Add(fld);
  OrderList.Add(fld);


  Fm_Qry:=TFM_Query.Create(self);
  fm_qry.Init(sysinfo.AdoConnection,'','',WhereList,OrderList,query,dbsType);
end;

procedure Tfm_car.RefreshData;
var sql:string;
begin
  screen.Cursor:=crSQLWait;
  TRY
    Sql:='SELECT * FROM TBL_CAR M '+CR
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

procedure Tfm_car.ActQueryExecute(Sender: TObject);
var n:integer;
begin
  n:=fm_qry.ShowModal;
  if n=mrCancel then
    exit;
  sqlWhere:=Fm_qry.sqlWhere;      //取得 SQLWher  字串
  SQLOrder:=fm_qry.sqlOrder;      //取得 SQLOrder 字串
  RefreshData;

end;

procedure Tfm_car.ActBrowseExecute(Sender: TObject);
var fm:TFm_Browse;
begin
  fm:=TFM_Browse.Create(application);
  try
    fm.Browse(qry);
  finally
    fm.Free;
  end;
end;

procedure Tfm_car.ActEditNoExecute(Sender: TObject);
var fm:TFM_Modify_No;
    n:integer;
    NEW_NO:STRING;
begin
  fm:=TFM_Modify_No.Create(application);
  try
    FM.Edit_New_No.Text:=QRYcar_NO.Value;
    n:=fm.ShowModal;
    if n=mrCancel then exit;
    NEW_NO:=TRIM(FM.Edit_New_No.Text);
    Modify_NO(qryCAR_NO.Value,NEW_NO);
    RefreshData;
    qry.Locate('CAR_NO',NEW_NO,[])
  finally
    fm.close;
  end;

end;

procedure Tfm_car.Modify_NO(OldNO, newNO: string);
var sql:string;
begin
  sysinfo.AdoConnection.BeginTrans;
  try
    sql:='INSERT INTO TBL_CAR'
        +' (CAR_NO,CAR_BRAND,CAR_LICENSE_NO'
        +' ,CAR_DATE1,CAR_DESC,CAR_CREATOR)'
        +' VALUES('
        +SQLSTR(NEWNO) + ','
        +SQLSTR(qryCAR_BRAND.AsString) + ','
        +SQLSTR(qryCAR_LICENSE_NO.Value) + ','
        +SqlDateTimeSQL(qryCAR_DATE1.Value) + ','
        +SQLSTR(qryCAR_DESC.Value) + ','
        +SQLSTR(sysinfo.LoginUserName)
        +')';
    sysinfo.AdoConnection.Execute(SQL);

    SQL:=' UPDATE TBL_SHIP SET CAR_NO='+SQLSTR(NEWNO)
        +' WHERE CAR_NO='+SQLSTR(oldNO);
    sysinfo.AdoConnection.Execute(SQL);


    SQL:=' DELETE TBL_CAR'
        +' WHERE CAR_NO='+SQLSTR(oldNO);
    sysinfo.AdoConnection.Execute(SQL);
    sysinfo.AdoConnection.CommitTrans;
  except
    sysinfo.AdoConnection.RollbackTrans;
    RAISE;
  end;


end;

end.

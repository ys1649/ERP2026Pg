unit Form_SysRepFldDef;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, Grids, DBGrids, StdCtrls, ExtCtrls, Mask, DBCtrls;

type
  TFM_SysRepFldDef = class(TForm)
    qry: TADOQuery;
    qrySRP_ID: TIntegerField;
    qrySRF_SEQNO: TIntegerField;
    qrySRF_TABLEALIAS: TStringField;
    qrySRF_FIELDNAME: TStringField;
    qrySRF_CONTROLTYPE: TStringField;
    qrySRF_LIST_VALUE: TMemoField;
    qrySRF_LIST_SQL: TMemoField;
    qrySRF_LIST_FIELDDISP: TMemoField;
    qrySRF_LIST_RETURNFIELD: TStringField;
    qrySRF_QUERYTYPE: TStringField;
    Panel1: TPanel;
    BtnAppend: TButton;
    BtnModify: TButton;
    BtnDelete: TButton;
    DBGrid1: TDBGrid;
    dsFleld: TDataSource;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    dsReport: TDataSource;
    qrySRF_DATATYPE: TStringField;
    qrySRF_DISPNAME: TStringField;
    qrySRF_DISPORDER: TIntegerField;
    qrySRF_ISMUSTCRITERIA: TBooleanField;
    qrySRF_ISWHERE: TBooleanField;
    qrySRF_ISSORT: TBooleanField;
    qrySRF_SORTDEC: TBooleanField;
    Button1: TButton;
    procedure BtnAppendClick(Sender: TObject);
    procedure BtnModifyClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Init(Adodc:TAdoConnection;RepDataSet:TDataSet);
    { Public declarations }
  end;

implementation

uses Uty, Form_SysRepFldDefEdit, DBUty;

{$R *.dfm}

{ TFM_SysRepFldDef }

procedure TFM_SysRepFldDef.Init(Adodc: TAdoConnection;
  RepDataSet: TDataSet);
begin
  qry.Connection:=adodc;
  dsReport.DataSet:=RepDataSet;
  Qry.SQL.Text:='SELECT * FROM TBLSYSREPORTFIELD WHERE SRP_ID='
               + RepDataSet.fieldbyname('SRP_ID').AsString
               + ' ORDER BY SRF_DISPORDER';
  Qry.Open;
  SetOwnerCtrlReadOnly(self,True);
end;

procedure TFM_SysRepFldDef.BtnAppendClick(Sender: TObject);
var
  fm:Tfm_SysRepFldDefEdit;
begin
  fm:=Tfm_SysRepFldDefEdit.Create(application);
  try
    fm.Init(qry.Connection, dsReport.DataSet,qry);
    qry.Append;
    qrySRP_ID.Value:=dsReport.DataSet.fieldbyname('SRP_ID').AsInteger;
    qrySRF_SEQNO.Value:=GetMaxID(qry.Connection,'TblSysReportField','SRF_SEQNO','SRP_ID='+qrySRP_ID.AsString)+1;
    qrySRF_DispORDER.Value:=GetMaxID(qry.Connection,'TblSysReportField','SRF_DISPORDER','SRP_ID='+qrySRP_ID.AsString)+10;
    qrySRF_IsWHERE.Value:=True;
    qrySRF_IsSORT.Value:=false;
    qrySRF_IsMUSTCRITERIA.Value:=false;
    qrySRF_QUERYTYPE.Value:='Range';
    qrySRF_CONTROLTYPE.Value:='Edit';
    qrySRF_DATATYPE.Value:='String';
    qrySRF_SORTDEC.Value:=false;
    fm.ShowModal;
  finally
    fm.Free;
  end;


end;

procedure TFM_SysRepFldDef.BtnModifyClick(Sender: TObject);
var
  fm:Tfm_SysRepFldDefEdit;
begin
  fm:=Tfm_SysRepFldDefEdit.Create(application);
  try
    fm.Init(qry.Connection, dsReport.DataSet,qry);
    qry.Edit;
    fm.ShowModal;
  finally
    fm.Free;
  end;
end;

procedure TFM_SysRepFldDef.BtnDeleteClick(Sender: TObject);
begin
    if application.messageBox(
      ' 您確定要刪除嗎?'
      ,'資料刪除詢問',mb_YesNO)=IDNO then exit;
    qry.Delete;
end;

procedure TFM_SysRepFldDef.Button1Click(Sender: TObject);
var n:integer;
begin
  n:=1000000;
  qry.First;
  while not qry.Eof do
  begin
    qry.Edit;
    qry.FieldByName('SRF_SEQNO').Value:=N;
    INC(N);
    qry.Post;
    QRY.Next;
  end;

  n:=1;
  qry.First;
  while not qry.Eof do
  begin
    qry.Edit;
    qry.FieldByName('SRF_SEQNO').Value:=N;
    qry.FieldByName('SRF_DISPORDER').Value:=N*10;
    INC(N);
    qry.Post;
    QRY.Next;
  end;
end;

end.

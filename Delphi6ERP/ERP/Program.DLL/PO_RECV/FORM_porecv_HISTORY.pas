unit FORM_porecv_HISTORY;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxDBGrid, dxDBTLCl, dxGrClms, dxTL, dxDBCtrl, StdCtrls, DBCtrls,
  ExtCtrls, dxCntner, DB, DBClient, ADODB, Provider, Mask,erp_public;

type
  TFM_PoRecv_HISTORY = class(TForm)
    GroupBox1: TGroupBox;
    Splitter1: TSplitter;
    GroupBox2: TGroupBox;
    grid_Mast: TdxDBGrid;
    Grid_DT: TdxDBGrid;
    Panel1: TPanel;
    Button1: TButton;
    Panel2: TPanel;
    DBNavigator2: TDBNavigator;
    Panel3: TPanel;
    DBNavigator3: TDBNavigator;
    Client_Mast: TClientDataSet;
    Client_DT: TClientDataSet;
    ds_Mast: TDataSource;
    ds_DT: TDataSource;
    ADOQuery1: TADOQuery;
    DataSetProvider1: TDataSetProvider;
    ADOQuery2: TADOQuery;
    DataSetProvider2: TDataSetProvider;
    Panel4: TPanel;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    Edit_Rec: TEdit;
    Client_MastCLS: TIntegerField;
    Client_MastHRCV_NO: TStringField;
    Client_MastSUP_NO: TStringField;
    Client_MastHRCV_INV_NO: TStringField;
    Client_MastHRCV_DATE: TDateTimeField;
    Client_MastHRCV_TOTAL: TBCDField;
    Client_MastHRCV_TAX: TBCDField;
    Client_MastHRCV_DESC: TStringField;
    Client_MastHRCV_CREATOR: TStringField;
    Client_MastC_AMOUNT: TCurrencyField;
    Client_MastC_SUP_NAME: TStringField;
    Client_DTHRCV_NO: TStringField;
    Client_DTHRCD_SEQNO: TBCDField;
    Client_DTPRD_NO: TStringField;
    Client_DTINV_NO: TStringField;
    Client_DTHRCD_PRD_NAME: TStringField;
    Client_DTHRCD_UNIT_PRICE: TBCDField;
    Client_DTHRCD_QTY: TBCDField;
    Client_DTC_SUB_TOTAL: TCurrencyField;
    grid_MastHRCV_NO: TdxDBGridMaskColumn;
    grid_MastSUP_NO: TdxDBGridMaskColumn;
    grid_MastHRCV_INV_NO: TdxDBGridMaskColumn;
    grid_MastHRCV_DATE: TdxDBGridDateColumn;
    grid_MastHRCV_TOTAL: TdxDBGridMaskColumn;
    grid_MastHRCV_TAX: TdxDBGridMaskColumn;
    grid_MastHRCV_DESC: TdxDBGridMaskColumn;
    grid_MastHRCV_CREATOR: TdxDBGridMaskColumn;
    grid_MastC_AMOUNT: TdxDBGridColumn;
    grid_MastC_SUP_NAME: TdxDBGridColumn;
    Grid_DTHRCD_SEQNO: TdxDBGridMaskColumn;
    Grid_DTPRD_NO: TdxDBGridMaskColumn;
    Grid_DTHRCD_PRD_NAME: TdxDBGridMaskColumn;
    Grid_DTHRCD_UNIT_PRICE: TdxDBGridMaskColumn;
    Grid_DTHRCD_QTY: TdxDBGridMaskColumn;
    Grid_DTC_SUB_TOTAL: TdxDBGridColumn;
    Client_MastHRCV_NOT_CLEAN: TBCDField;
    grid_HRCV_NOT_CLEAN: TdxDBGridColumn;
    procedure Client_MastCalcFields(DataSet: TDataSet);
    procedure Client_DTCalcFields(DataSet: TDataSet);
    procedure Client_MastAfterScroll(DataSet: TDataSet);
    procedure Client_DTHRCD_PRD_NAMEGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure Grid_DTCustomDraw(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxDBTreeListColumn;
      const AText: String; AFont: TFont; var AColor: TColor; ASelected,
      AFocused: Boolean; var ADone: Boolean);
  private
    { Private declarations }
  public
    sysinfo:TSysinfo;
    { Public declarations }
  end;


implementation

uses Uty, DBUty;

{$R *.dfm}

procedure TFM_PoRecv_HISTORY.Client_MastCalcFields(DataSet: TDataSet);
begin
  Client_MastC_Amount.Value:=Client_MastHRCV_TOTAL.Value+Client_MastHRCV_Tax.Value;
  client_mastC_SUP_Name.Value:=GetSupName(sysinfo,client_mastSUP_no.Value);

end;

procedure TFM_PoRecv_HISTORY.Client_DTCalcFields(DataSet: TDataSet);
begin
  client_dtC_SUB_TOTAL.Value:=client_dtHRCD_QTY.Value*client_dtHRCD_UNIT_PRICE.Value;

end;

procedure TFM_PoRecv_HISTORY.Client_MastAfterScroll(DataSet: TDataSet);
var sql:string;
begin
  if client_mastCls.Value=1 then
    sql:='SELECT HRCV_NO, HRCD_SEQNO, PRD_NO'
        +', INV_NO, HRCD_PRD_NAME, HRCD_UNIT_PRICE'
        +', HRCD_QTY'
        +' FROM TBL_HIS_PO_RECV_DT'
        +' WHERE HRCV_NO='
        +sqlstr(client_mastHRCV_NO.AsString)
  else
    sql:='SELECT RCV_NO HRCV_NO, RCD_SEQNO HRCD_SEQNO, PRD_NO'
        +', INV_NO,RCD_PRD_NAME HRCD_PRD_NAME,RCD_UNIT_PRICE HRCD_UNIT_PRICE'
        +',RCD_QTY HRCD_QTY'
        +' FROM TBL_PO_RECV_DT'
        +' WHERE RCV_NO='
        +sqlstr(client_mastHRCV_NO.AsString);

  DoQrySelect(sql,sysinfo.AdoConnection,Client_DT);
  Edit_rec.Text:=format ('%d / %d',[Client_Mast.recno,Client_Mast.recordCount]);

end;

procedure TFM_PoRecv_HISTORY.Client_DTHRCD_PRD_NAMEGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
VAR prdname:variant;
begin
  if client_dtHRCD_PRD_NAME.Value='' then
  BEGIN
    prdName:=GetPrdName(sysinfo,client_dtPrd_NO.Value);
    text:=vartostr(prdName);
  end else
    text:=client_dtHRCD_PRD_NAME.Value;

end;

procedure TFM_PoRecv_HISTORY.FormActivate(Sender: TObject);
begin
client_mast.AfterScroll:=Client_MastAfterScroll;
end;

procedure TFM_PoRecv_HISTORY.Grid_DTCustomDraw(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxDBTreeListColumn;
  const AText: String; AFont: TFont; var AColor: TColor; ASelected,
  AFocused: Boolean; var ADone: Boolean);
var n:integer;
begin
  n:=grid_DT.ColumnByFieldName('HRCD_QTY').Index;
  if varisnull(ANode.Values[n]) then exit;
  if ANode.Values[n]<0 then
  begin
    AColor:=clYellow;
    Afont.Color:=clRed;
  end;

end;

end.

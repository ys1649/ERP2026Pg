unit FORM_ship_HISTORY;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxDBGrid, dxDBTLCl, dxGrClms, dxTL, dxDBCtrl, StdCtrls, DBCtrls,
  ExtCtrls, dxCntner, DB, DBClient, ADODB, Provider, Mask,erp_public,
  FORM_ERP_BASE;

type
  TFM_ship_HISTORY = class(TForm)
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
    Client_MastHSMT_NO: TStringField;
    Client_MastCUM_NO: TStringField;
    Client_MastEPY_NO: TStringField;
    Client_MastHSMT_INV_NO: TStringField;
    Client_MastHSMT_DATE: TDateTimeField;
    Client_MastHSMT_DESTINATION: TStringField;
    Client_MastHSMT_TOTAL: TBCDField;
    Client_MastHSMT_TAX: TBCDField;
    Client_MastHSMT_COST: TBCDField;
    Client_MastHSMT_DESC: TStringField;
    Client_MastHSMT_CREATOR: TStringField;
    Client_MastC_CUM_Name: TStringField;
    Client_MastC_EPY_NAME: TStringField;
    Client_MastC_Amount: TCurrencyField;
    ADOQuery2: TADOQuery;
    DataSetProvider2: TDataSetProvider;
    Client_DTHSMT_NO: TStringField;
    Client_DTHSMD_SEQNO: TBCDField;
    Client_DTPRD_NO: TStringField;
    Client_DTHSMD_PRD_NAME: TStringField;
    Client_DTHSMD_UNIT_PRICE: TBCDField;
    Client_DTHSMD_COST: TBCDField;
    grid_MastHSMT_NO: TdxDBGridMaskColumn;
    grid_MastHSMT_INV_NO: TdxDBGridMaskColumn;
    grid_MastHSMT_DATE: TdxDBGridDateColumn;
    grid_MastHSMT_DESTINATION: TdxDBGridMaskColumn;
    grid_MastHSMT_TOTAL: TdxDBGridMaskColumn;
    grid_MastHSMT_TAX: TdxDBGridMaskColumn;
    grid_MastHSMT_COST: TdxDBGridMaskColumn;
    grid_MastHSMT_DESC: TdxDBGridMaskColumn;
    grid_MastHSMT_CREATOR: TdxDBGridMaskColumn;
    grid_MastC_EPY_NAME: TdxDBGridColumn;
    grid_MastC_Amount: TdxDBGridColumn;
    Client_DTC_Sub_Total: TCurrencyField;
    Client_MastCLS: TIntegerField;
    Panel4: TPanel;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Grid_DTHSMD_SEQNO: TdxDBGridMaskColumn;
    Grid_DTPRD_NO: TdxDBGridMaskColumn;
    Grid_DTHSMD_PRD_NAME: TdxDBGridMaskColumn;
    Grid_DTHSMD_UNIT_PRICE: TdxDBGridMaskColumn;
    Grid_DTHSMD_QTY: TdxDBGridMaskColumn;
    Grid_DTHSMD_COST: TdxDBGridMaskColumn;
    Grid_DTC_Sub_Total: TdxDBGridColumn;
    Label3: TLabel;
    Edit_Rec: TEdit;
    Client_DTHSMD_QTY: TBCDField;
    Client_MastHSMT_NOT_CLEAN: TBCDField;
    grid_HSMT_NOT_CLEAN: TdxDBGridColumn;
    procedure Client_MastCalcFields(DataSet: TDataSet);
    procedure Client_DTCalcFields(DataSet: TDataSet);
    procedure Client_MastAfterScroll(DataSet: TDataSet);
    procedure Client_DTHSMD_PRD_NAMEGetText(Sender: TField;
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

procedure TFM_ship_HISTORY.Client_MastCalcFields(DataSet: TDataSet);
begin
  Client_MastC_Amount.Value:=Client_MastHSMT_TOTAL.Value+Client_MastHSmt_Tax.Value;
  client_mastC_Cum_Name.Value:=GetCumName(sysinfo,client_mastCum_no.Value);
  client_mastC_Epy_Name.Value:=GetEpyName(sysinfo,client_MastEPY_NO.Value);

end;

procedure TFM_ship_HISTORY.Client_DTCalcFields(DataSet: TDataSet);
begin
  client_dtC_SUB_TOTAL.Value:=client_dtHSMD_QTY.Value*client_dtHSMD_UNIT_PRICE.Value;

end;

procedure TFM_ship_HISTORY.Client_MastAfterScroll(DataSet: TDataSet);
var sql:string;
begin
  if client_mastCls.Value=1 then
    sql:='SELECT HSMT_NO, HSMD_SEQNO, PRD_NO'
        +', INV_NO, HSMD_PRD_NAME, HSMD_UNIT_PRICE'
        +', HSMD_QTY, HSMD_COST'
        +' FROM TBL_HIS_SHIP_DT'
        +' WHERE HSMT_NO='
        +sqlstr(client_mastHSMT_NO.AsString)
  else
    sql:='SELECT SMT_NO HSMT_NO, SMD_SEQNO HSMD_SEQNO, PRD_NO'
        +', INV_NO,SMD_PRD_NAME HSMD_PRD_NAME,SMD_UNIT_PRICE HSMD_UNIT_PRICE'
        +',SMD_QTY HSMD_QTY,SMD_COST HSMD_COST'
        +' FROM TBL_SHIP_DT'
        +' WHERE SMT_NO='
        +sqlstr(client_mastHSMT_NO.AsString);

  DoQrySelect(sql,sysinfo.AdoConnection,Client_DT);
  Edit_rec.Text:=format ('%d / %d',[Client_Mast.recno,Client_Mast.recordCount]);

end;

procedure TFM_ship_HISTORY.Client_DTHSMD_PRD_NAMEGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
VAR prdname:variant;
begin
  if client_dtHSMD_PRD_NAME.Value='' then
  BEGIN
    prdName:=GetPrdName(sysinfo,client_dtPrd_NO.Value);
    text:=vartostr(prdName);
  end else
    text:=client_dtHSMD_PRD_NAME.Value;

end;

procedure TFM_ship_HISTORY.FormActivate(Sender: TObject);
begin
  client_mast.AfterScroll:=Client_MastAfterScroll;
end;

procedure TFM_ship_HISTORY.Grid_DTCustomDraw(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxDBTreeListColumn;
  const AText: String; AFont: TFont; var AColor: TColor; ASelected,
  AFocused: Boolean; var ADone: Boolean);
var n:integer;
begin
  n:=grid_DT.ColumnByFieldName('HSMD_QTY').Index;
  if varisnull(ANode.Values[n]) then exit;
  if ANode.Values[n]<0 then
  begin
    AColor:=clYellow;
    Afont.Color:=clRed;
  end;

end;

end.

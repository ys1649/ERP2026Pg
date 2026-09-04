unit form_PoRecv_Browse;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxDBGrid, dxDBTLCl, dxGrClms, dxTL, dxDBCtrl, StdCtrls, DBCtrls,
  ExtCtrls, dxCntner,db;

type
  TFM_PoRecv_Browse = class(TForm)
    GroupBox1: TGroupBox;
    Splitter1: TSplitter;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    Button1: TButton;
    Panel2: TPanel;
    DBNavigator_Mast: TDBNavigator;
    Panel3: TPanel;
    DBNavigator_dt: TDBNavigator;
    grid_mast: TdxDBGrid;
    grid_mastRCV_NO: TdxDBGridMaskColumn;
    grid_mastSUP_NO: TdxDBGridMaskColumn;
    grid_mastRCV_STATUS: TdxDBGridMaskColumn;
    grid_mastRCV_DATE: TdxDBGridDateColumn;
    grid_mastRCV_INV_NO: TdxDBGridMaskColumn;
    grid_mastRCV_TOTAL: TdxDBGridMaskColumn;
    grid_mastRCV_TAX: TdxDBGridMaskColumn;
    grid_mastRCV_NOT_CLEAN: TdxDBGridMaskColumn;
    grid_mastRCV_DESC: TdxDBGridMaskColumn;
    grid_mastC_SUP_NAME: TdxDBGridColumn;
    grid_mastC_AMOUNT: TdxDBGridColumn;
    grid_mastC_SUP_ADDR: TdxDBGridColumn;
    grid_dt: TdxDBGrid;
    grid_dtPRD_NO: TdxDBGridMaskColumn;
    grid_dtRCD_PRD_NAME: TdxDBGridMaskColumn;
    grid_dtRCD_QTY: TdxDBGridMaskColumn;
    grid_dtRCD_UNIT_PRICE: TdxDBGridMaskColumn;
    grid_dtC_SUB_TOTAL: TdxDBGridColumn;
    grid_dtC_PRD_ONHAND: TdxDBGridColumn;
    grid_dtC_SEQNO: TdxDBGridColumn;
    procedure Grid_DTCustomDraw(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxDBTreeListColumn;
      const AText: String; AFont: TFont; var AColor: TColor; ASelected,
      AFocused: Boolean; var ADone: Boolean);
  private
    { Private declarations }
  public
    ds_mast:TDatasource;
    ds_detail:TDatasource;
    procedure init;
    { Public declarations }
  end;


implementation


{$R *.dfm}

procedure TFM_PoRecv_Browse.Grid_DTCustomDraw(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxDBTreeListColumn;
  const AText: String; AFont: TFont; var AColor: TColor; ASelected,
  AFocused: Boolean; var ADone: Boolean);
var n:integer;
begin
  n:=grid_DT.ColumnByFieldName('RCD_QTY').Index;
  if varisnull(ANode.Values[n]) then exit;
  if ANode.Values[n]<0 then
  begin
    AColor:=clYellow;
    Afont.Color:=clRed;
  end;

end;

procedure TFM_PoRecv_Browse.init;
begin
  grid_mast.DataSource:=ds_mast;
  DBNavigator_mast.DataSource:=ds_mast;
  Grid_DT.DataSource:=ds_detail;
  DBNavigator_dt.DataSource:=ds_detail;

end;

end.

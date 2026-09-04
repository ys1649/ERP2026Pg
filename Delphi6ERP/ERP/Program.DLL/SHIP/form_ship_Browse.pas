unit form_ship_Browse;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxDBGrid, dxDBTLCl, dxGrClms, dxTL, dxDBCtrl, StdCtrls, DBCtrls,
  ExtCtrls, dxCntner,db;

type
  TFM_Ship_Browse = class(TForm)
    GroupBox1: TGroupBox;
    Splitter1: TSplitter;
    GroupBox2: TGroupBox;
    grid_Mast: TdxDBGrid;
    Grid_DT: TdxDBGrid;
    Panel1: TPanel;
    Button1: TButton;
    grid_MastCUM_NO: TdxDBGridMaskColumn;
    grid_MastSMT_NO: TdxDBGridMaskColumn;
    grid_MastSMT_INV_NO: TdxDBGridMaskColumn;
    grid_MastSMT_DATE: TdxDBGridDateColumn;
    grid_MastSMT_DESTINATION: TdxDBGridMaskColumn;
    grid_MastSMT_TAX: TdxDBGridMaskColumn;
    grid_MastSMT_NOT_CLEAN: TdxDBGridMaskColumn;
    grid_MastSMT_CREATOR: TdxDBGridMaskColumn;
    grid_MastSMT_TOTAL: TdxDBGridMaskColumn;
    grid_MastC_Amount: TdxDBGridColumn;
    grid_MastC_CUM_NAME: TdxDBGridColumn;
    grid_MastC_EPY_NAME: TdxDBGridColumn;
    Grid_DTC_SEQNO: TdxDBGridColumn;
    Grid_DTPRD_NO: TdxDBGridMaskColumn;
    Grid_DTSMD_PRD_NAME: TdxDBGridMaskColumn;
    Grid_DTSMD_QTY: TdxDBGridMaskColumn;
    Grid_DTSMD_UNIT_PRICE: TdxDBGridMaskColumn;
    Grid_DTSMD_COST: TdxDBGridMaskColumn;
    Grid_DTC_SUB_TOTAL: TdxDBGridColumn;
    Panel2: TPanel;
    DBNavigator_mast: TDBNavigator;
    Panel3: TPanel;
    DBNavigator_dt: TDBNavigator;
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

procedure TFM_Ship_Browse.Grid_DTCustomDraw(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxDBTreeListColumn;
  const AText: String; AFont: TFont; var AColor: TColor; ASelected,
  AFocused: Boolean; var ADone: Boolean);
var n:integer;
begin
  n:=grid_DT.ColumnByFieldName('SMD_QTY').Index;
  if varisnull(ANode.Values[n]) then exit;
  if ANode.Values[n]<0 then
  begin
    AColor:=clYellow;
    Afont.Color:=clRed;
  end;

end;

procedure TFM_Ship_Browse.init;
begin
  grid_mast.DataSource:=ds_mast;
  DBNavigator_mast.DataSource:=ds_mast;
  Grid_DT.DataSource:=ds_detail;
  DBNavigator_dt.DataSource:=ds_detail;
end;

end.

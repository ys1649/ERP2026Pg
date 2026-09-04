unit form_InvAdjBrowse;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxDBGrid, dxDBTLCl, dxGrClms, dxTL, dxDBCtrl, StdCtrls, DBCtrls,
  ExtCtrls, dxCntner,db;

type
  TFM_InvAdjBrowse = class(TForm)
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
    grid_dt: TdxDBGrid;
    grid_mastADJ_NO: TdxDBGridMaskColumn;
    grid_mastADJ_STATUS: TdxDBGridMaskColumn;
    grid_mastADJ_DATE: TdxDBGridDateColumn;
    grid_mastADJ_DESC: TdxDBGridMaskColumn;
    grid_mastADJ_CREATOR: TdxDBGridMaskColumn;
    grid_dtPRD_NO: TdxDBGridMaskColumn;
    grid_dtADD_COST: TdxDBGridMaskColumn;
    grid_dtINV_NO: TdxDBGridMaskColumn;
    grid_dtADD_QTY: TdxDBGridMaskColumn;
    grid_dtC_SUB_TOTAL: TdxDBGridColumn;
    grid_dtC_PRD_ONHAND: TdxDBGridColumn;
    grid_dtC_SEQNO: TdxDBGridColumn;
    grid_dtC_PRD_NAME: TdxDBGridColumn;
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

procedure TFM_InvAdjBrowse.Grid_DTCustomDraw(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxDBTreeListColumn;
  const AText: String; AFont: TFont; var AColor: TColor; ASelected,
  AFocused: Boolean; var ADone: Boolean);
var n:integer;
begin
  n:=grid_DT.ColumnByFieldName('ADD_QTY').Index;
  if varisnull(ANode.Values[n]) then exit;
  if ANode.Values[n]<0 then
  begin
    AColor:=clYellow;
    Afont.Color:=clRed;
  end;

end;

procedure TFM_InvAdjBrowse.init;
begin
  grid_mast.DataSource:=ds_mast;
  DBNavigator_mast.DataSource:=ds_mast;
  Grid_DT.DataSource:=ds_detail;
  DBNavigator_dt.DataSource:=ds_detail;

end;

end.

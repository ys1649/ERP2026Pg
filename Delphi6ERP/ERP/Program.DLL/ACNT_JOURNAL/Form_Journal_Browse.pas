unit Form_Journal_Browse;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxDBGrid, dxDBTLCl, dxGrClms, dxTL, dxDBCtrl, StdCtrls, DBCtrls,
  ExtCtrls, dxCntner,db;

type
  TFM_Journal_Browse = class(TForm)
    GroupBox1: TGroupBox;
    Splitter1: TSplitter;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    Button1: TButton;
    Panel2: TPanel;
    DBNavigator_mast: TDBNavigator;
    Panel3: TPanel;
    DBNavigator_dt: TDBNavigator;
    grid_mast: TdxDBGrid;
    grid_dt: TdxDBGrid;
    grid_mastJNL_NO: TdxDBGridMaskColumn;
    grid_mastJNL_DATE: TdxDBGridDateColumn;
    grid_mastJNL_DESC: TdxDBGridMaskColumn;
    grid_mastJNL_BILL_TYPE: TdxDBGridMaskColumn;
    grid_dtJND_SEQNO: TdxDBGridMaskColumn;
    grid_dtACT_NO: TdxDBGridMaskColumn;
    grid_dtC_ACT_NAME: TdxDBGridColumn;
    grid_dtJND_AMOUNT: TdxDBGridMaskColumn;
    grid_dtJND_DESC: TdxDBGridMaskColumn;
    grid_dtJND_DC: TdxDBGridColumn;
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

{ TFM_Journal_Browse }

procedure TFM_Journal_Browse.init;
begin
  grid_mast.DataSource:=ds_mast;
  DBNavigator_mast.DataSource:=ds_mast;
  Grid_DT.DataSource:=ds_detail;
  DBNavigator_dt.DataSource:=ds_detail;

end;

end.

unit form_Browse;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, Db, DBTables, ExtCtrls, DBCtrls;

type
  TFM_Browse = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Panel1: TPanel;
    Button1: TButton;
    DBNavigator1: TDBNavigator;
  private
    { Private declarations }
  public
    procedure Browse(rst: TDataSet);
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TFM_Browse.Browse(rst: TDataSet);
begin
  datasource1.dataset:=rst;
//  SetGrid;
  self.showmodal;
end;



end.

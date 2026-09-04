unit Form_SysReportEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Mask, DBCtrls, DB;

type
  Tfm_SysReportEdit = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DCDBMemo1: TDBMemo;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    Button1: TButton;
    Button2: TButton;
    DCDBMemo3: TDBMemo;
    DCDBMemo4: TDBMemo;
    DCDBMemo5: TDBMemo;
    DCDBMemo6: TDBMemo;
    DataSource: TDataSource;
    DCDBMemo2: TDBMemo;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
implementation

{$R *.dfm}

procedure Tfm_SysReportEdit.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePage:=TabSheet1;
end;

procedure Tfm_SysReportEdit.Button1Click(Sender: TObject);
begin
  DataSource.DataSet.post;
  ModalResult:=mrOK;

end;

procedure Tfm_SysReportEdit.Button2Click(Sender: TObject);
begin
  DataSource.DataSet.cancel;
  ModalResult:=mrCancel;

end;

end.

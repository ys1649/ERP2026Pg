unit Form_SysParam;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, Buttons, ExtCtrls, DB, ADODB, Mask, DBCtrls,
  ImgList,dxCntner, dxEditor, dxExEdtr, dxEdLib, dxDBELib,FORM_ERP_BASE,erp_public;

type
  Tfm_SysParam = class(TForm_ERP)
    pnlStatus: TPanel;
    Panel3: TPanel;
    LblStatus: TLabel;
    ActionList1: TActionList;
    ActSave: TAction;
    ActAbort: TAction;
    qry: TADOQuery;
    DataSource1: TDataSource;
    ImageList1: TImageList;
    ActEdit: TAction;
    pnlCtrl: TPanel;
    BtnEdit: TButton;
    BtnSave: TButton;
    BtnAbort: TButton;
    qrySPR_PERIOD_START: TDateTimeField;
    qrySPR_COR_NAME: TStringField;
    qrySPR_TEL: TStringField;
    qrySPR_FAX: TStringField;
    qrySPR_ADDR: TStringField;
    qrySPR_TAX_RATE: TBCDField;
    qrySPR_BKUP_PATH: TStringField;
    qrySPR_PRD_COST_RATE: TBCDField;
    qrySPR_BONUS_SALE_RATE: TBCDField;
    qrySPR_BONUS_PROFIT_RATE: TBCDField;
    Label1: TLabel;
    Edit_SPR_PERIOD_START: TDBEdit;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    Label4: TLabel;
    DBEdit4: TDBEdit;
    Label5: TLabel;
    DBEdit5: TDBEdit;
    Label6: TLabel;
    DBEdit6: TDBEdit;
    Label7: TLabel;
    DBEdit7: TDBEdit;
    Label8: TLabel;
    DBEdit8: TDBEdit;
    Label9: TLabel;
    DBEdit9: TDBEdit;
    Label10: TLabel;
    Edit_SPR_BKUP_PATH: TDBEdit;
    procedure ActEditExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ActAbortExecute(Sender: TObject);
  private
    PROCEDURE SetEditMode(mode:boolean);

  public
    procedure Init;override;
  end;


implementation

uses Uty;

{$R *.dfm}

procedure Tfm_SysParam.Init;
begin
  qry.Connection:=sysinfo.AdoConnection;
  QRY.Open;
  SetEditMode(false);

end;

procedure Tfm_SysParam.SetEditMode(mode: boolean);
begin
  SetOwnerCtrlReadOnly(self,not mode);
  ActEdit.Enabled:=not mode;
  ActAbort.Enabled:= mode;
  ActSave.Enabled:= mode;
  SetCtrlReadOnly(Edit_SPR_PERIOD_START,true);
end;

procedure Tfm_SysParam.ActEditExecute(Sender: TObject);
begin
  qry.Edit;
  seteditmode(true);
//  SetCtrlReadOnly(Edit_no,true);
//  Edit_Name.SetFocus;
end;

procedure Tfm_SysParam.ActSaveExecute(Sender: TObject);
var s:string;
begin
  s:=qrySPR_BKUP_PATH.Value;
  while strRight(s,1)='\' do
    delete(s,length(s),1);
  qrySPR_BKUP_PATH.Value:=s;

  qry.Post;
  Seteditmode(false);
end;

procedure Tfm_SysParam.ActAbortExecute(Sender: TObject);
begin
  qry.Cancel;
  Seteditmode(false);

end;

end.

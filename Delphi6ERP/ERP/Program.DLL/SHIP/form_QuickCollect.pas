unit form_QuickCollect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrls, ComCtrls, dxCntner, dxEditor, dxEdLib,
  dxDBELib,DB;

type
  TFM_QuickCollect = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    DBEdit1: TDBEdit;
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
    Label8: TLabel;
    DBEdit7: TDBEdit;
    lblCash: TLabel;
    lblBill: TLabel;
    Label9: TLabel;
    LblDate: TLabel;
    Label7: TLabel;
    BtnOK: TButton;
    BtnCancel: TButton;
    dt_Date: TDateTimePicker;
    Editbalance: TdxMaskEdit;
    EditCash: TdxMaskEdit;
    EditCheck: TdxMaskEdit;
    EditDiscount: TdxMaskEdit;
    procedure EditCashExit(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public

    dsMast:TDataSource;
    cash,check,discount,balance:currency;
    ARR_Date:TDate;
    procedure init;
    { Public declarations }
  end;


implementation

uses Uty;

{$R *.dfm}

procedure TFM_QuickCollect.EditCashExit(Sender: TObject);
var NotClean:currency;
begin
  NotClean:=dsMast.DataSet.FieldByName('SMT_NOT_CLEAN').Value;
  cash:=strtocurr(EditCash.Text);
  check:=strtocurr(EditCheck.Text);
  discount:=strtocurr(EditDiscount.Text);
  balance:=NotClean-(cash+check+discount);
  EditBalance.Text:=currtostr(balance);


end;

procedure TFM_QuickCollect.BtnOKClick(Sender: TObject);
var sum,NotClean:currency;
begin
  if dt_date.Date< trunc(dsMast.DataSet.FieldByName('SMT_DATE').Value) then
    ErrMsg('日期不得小於單據日期',user);
  ARR_Date:=dt_date.Date;
  NotClean:=dsMast.DataSet.FieldByName('SMT_NOT_CLEAN').Value;
  cash:=strtocurr(EditCash.Text);
  check:=strtocurr(EditCheck.Text);
  discount:=strtocurr(EditDiscount.Text);
  sum:=cash+check+discount;
  balance:=NotClean-sum;
  EditBalance.Text:=currtostr(balance);
  if sum=0 then
    Errmsg('沖帳金額不得為零 !',user);

  if balance<0  then
      Errmsg('沖帳金額太多 !',user);

  self.ModalResult:=mrOK;


end;

procedure TFM_QuickCollect.init;
var i:integer;
    com:TComponent;
begin
  for i:=0 to Self.ComponentCount-1 do begin
    com:=self.Components[i];
    if com is TDBEDIT then begin
      TDBEDIT(com).DataSource:=dsMast;
    end;
  end;
end;

end.

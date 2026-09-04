unit Form_ResetInvTran;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,ADODB, DB,FORM_ERP_BASE,Erp_Public;

type
  TFm_ResetInvTran = class(TForm_ERP)
    BtnOk: TButton;
    BtnCancel: TButton;
    Panel1: TPanel;
    Memo1: TMemo;
    bar1: TProgressBar;
    Label1: TLabel;
    lblMsg: TLabel;
    qryShip: TADOQuery;
    qryPoRecv: TADOQuery;
    qryAdj: TADOQuery;
    qryProduct: TADOQuery;
    procedure BtnOkClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
  private
    procedure DelTransaction;
    procedure RebuildFromShip;
    procedure RebuildFromPoRecv;
    procedure RebuildFromInvAdj;
    procedure UpdateAllProduct;
  public
    procedure init;override;
    { Public declarations }
  end;


implementation

uses Uty;

{$R *.dfm}

procedure TFm_ResetInvTran.BtnOkClick(Sender: TObject);
begin

  DelTransaction;
  RebuildFromPoRecv;
  RebuildFromShip;
  RebuildFromInvAdj;

  UpdateAllProduct;
  msg('重整完成 !');
end;

procedure TFm_ResetInvTran.DelTransaction;
var  sql:string;
begin
  sql:='DELETE TBL_TRANSACTION';
  Sysinfo.AdoConnection.Execute(SQL);

end;

procedure TFm_ResetInvTran.RebuildFromInvAdj;
VAR recNum,CNT:INTEGER;
begin
  LBLMSG.Caption:='3/4 轉入庫房調整單';
  Refresh;
  Application.ProcessMessages;
  qryAdj.Open;
  qryAdj.Last;
  qryAdj.First;
  recNum:=qryAdj.RecordCount;
  bar1.Max:=recNum;
  bar1.Min:=0;
  bar1.Step:=1;
  BAR1.Position:=0;
  cnt:=0;
  while not qryAdj.Eof do begin
    bar1.StepIt;
    inc(cnt);
    LBLMSG.Caption:='3/4 轉入庫房調整單 '+inttostr(cnt)+'/'+inttostr(recNum);
    Refresh;
    Application.ProcessMessages;
    InsertTransaction(sysinfo,qryAdj.fieldbyname('PRD_NO').AsString
                             ,qryAdj.fieldbyname('INV_NO').AsString
                             ,Trn_ADJ
                             ,qryAdj.fieldbyname('ADJ_NO').AsString
                             ,qryAdj.fieldbyname('ADD_SEQNO').AsString
                             ,qryAdj.fieldbyname('ADJ_DATE').AsDateTime
                             ,qryAdj.fieldbyname('ADD_QTY').AsCurrency
                             ,qryAdj.fieldbyname('ADD_COST').AsCurrency
                             ,FALSE);
    qryAdj.Next;

  end;
  qryAdj.Close;


end;

procedure TFm_ResetInvTran.RebuildFromPoRecv;
VAR recNum,CNT:INTEGER;
begin
  LBLMSG.Caption:='1/4 轉入收料單';
  Refresh;
  Application.ProcessMessages;
  qryPoRecv.Open;
  qryPoRecv.Last;
  qryPoRecv.First;
  recNum:=qryPoRecv.RecordCount;
  bar1.Max:=recNum;
  bar1.Min:=0;
  bar1.Step:=1;
  BAR1.Position:=0;
  cnt:=0;
  while not qryPoRecv.Eof do begin
    bar1.StepIt;
    inc(cnt);
    LBLMSG.Caption:='1/4 轉入收料單 '+inttostr(cnt)+'/'+inttostr(recNum);
    Refresh;
    Application.ProcessMessages;
    InsertTransaction(sysinfo,qryPoRecv.fieldbyname('PRD_NO').AsString
                             ,qryPoRecv.fieldbyname('INV_NO').AsString
                             ,Trn_RCV
                             ,qryPoRecv.fieldbyname('RCV_NO').AsString
                             ,qryPoRecv.fieldbyname('RCD_SEQNO').AsString
                             ,qryPoRecv.fieldbyname('RCV_DATE').AsDateTime
                             ,qryPoRecv.fieldbyname('RCD_QTY').AsCurrency
                             ,qryPoRecv.fieldbyname('RCD_UNIT_PRICE').AsCurrency
                             ,FALSE);
    qryPoRecv.Next;

  end;
  qryPoRecv.Close;

end;

procedure TFm_ResetInvTran.RebuildFromShip;
VAR recNum,CNT:INTEGER;
begin
  LBLMSG.Caption:='2/4 轉入出貨單';
  Refresh;
  Application.ProcessMessages;
  qryShip.Open;
  qryShip.Last;
  qryShip.First;
  recNum:=qryship.RecordCount;
  bar1.Max:=recNum;
  bar1.Min:=0;
  bar1.Step:=1;
  BAR1.Position:=0;
  cnt:=0;
  while not qryShip.Eof do begin
    bar1.StepIt;
    inc(cnt);
    LBLMSG.Caption:='2/4 轉入出貨單 '+inttostr(cnt)+'/'+inttostr(recNum);
    Refresh;
    Application.ProcessMessages;
    InsertTransaction(sysinfo,qryShip.fieldbyname('PRD_NO').AsString
                             ,qryShip.fieldbyname('INV_NO').AsString
                             ,Trn_SHP
                             ,qryShip.fieldbyname('SMT_NO').AsString
                             ,qryShip.fieldbyname('SMD_SEQNO').AsString
                             ,qryShip.fieldbyname('SMT_DATE').AsDateTime
                             ,qryShip.fieldbyname('SMD_QTY').AsCurrency* -1
                             ,0
                             ,FALSE);
    qryShip.Next;

  end;
  qryShip.Close;

end;

procedure TFm_ResetInvTran.BtnCancelClick(Sender: TObject);
begin
  CLOSE;
end;

procedure TFm_ResetInvTran.UpdateAllProduct;
VAR recNum,CNT:INTEGER;
    startTime:TDateTime;

begin
  startTime:=StrToDate('1980/01/01');
  LBLMSG.Caption:='4/4 更新存貨及成本';
  Refresh;
  Application.ProcessMessages;
  qryProduct.Open;
  qryProduct.Last;
  qryProduct.First;
  recNum:=qryProduct.RecordCount;
  bar1.Max:=recNum;
  bar1.Min:=0;
  bar1.Step:=1;
  BAR1.Position:=0;
  cnt:=0;


  while not qryProduct.Eof do begin
    bar1.StepIt;
    inc(cnt);
    LBLMSG.Caption:='4/4 更新存貨及成本 '+inttostr(cnt)+'/'+inttostr(recNum)
    +'    '+qryProduct.fieldbyname('PRD_NO').AsString;
    Refresh;
    Application.ProcessMessages;
    UpdateTransaction(sysinfo,qryProduct.fieldbyname('PRD_NO').AsString
                             ,startTime);
    qryProduct.Next;

  end;
  qryProduct.Close;

end;

procedure TFm_ResetInvTran.init;
begin
  inherited;
  setAdoConnection(self,sysinfo.AdoConnection);
end;

end.

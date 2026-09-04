unit WaitMsg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls;

type
  TMsgForm = class(TForm)
    ConMsg: TLabel;
    BtnCancel: TButton;
    Animate1: TAnimate;
    procedure BtnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TWaitMsg=class(TComponent)
  private
    MsgForm:TMsgForm;
    { Private declarations }
  public
    constructor Create(Aowner:TComponent);override;
    destructor Destroy;override;
    procedure ShowMsg(msg:string);
    procedure Close;
    { Public declarations }
  end;

var _WaitMsg:TWaitMsg;
    _AbortFlg:Boolean=False;
procedure WMsg(msg:string;AbortBtn:Boolean=False);
Procedure WMsgClose;

implementation

{$R *.DFM}

{ TWaitMsg }

procedure TWaitMsg.Close;
begin
  MsgForm.close;
end;

constructor TWaitMsg.Create(Aowner: TComponent);
begin
  if not assigned(MsgForm) then
    MsgForm:=TMsgForm.Create(Application);
    MsgForm.BorderStyle:=bsSingle;
    MsgForm.BorderStyle:=bsSizeable;
    MsgForm.BorderIcons:=[biSystemMenu];
end;


destructor TWaitMsg.Destroy;
begin
  MsgForm.free;
end;

procedure TWaitMsg.ShowMsg(msg: string);
begin
  MsgForm.ConMsg.caption:=#13#13#13+msg;
  MsgForm.Width:=length(msg)*10+40;
  if MsgForm.Width>500 then MsgForm.Width:=500;
  if MsgForm.BtnCancel.Visible then begin
    with MsgForm do Begin
      Height:=265;
      BtnCancel.Left:=(Width div 2) -(BtnCancel.Width div 2);
      BtnCancel.Top:=Height-(BtnCancel.Height+45);
    end;
  end else
	  MsgForm.Height:=180;
  MsgForm.Position:=poDesktopCenter;
  MsgForm.show;
  application.ProcessMessages;
end;


procedure WMsg(msg:string;AbortBtn:Boolean=False);
begin
  if not assigned(_WaitMsg) then
    _WaitMsg:=TWaitMsg.Create(nil);

  _AbortFlg:=False;
  _WaitMsg.MsgForm.BtnCancel.Visible:=AbortBtn;
  _WaitMsg.ShowMsg(msg);
end;

Procedure WMsgClose;
begin
 if assigned(_WaitMsg) then  _WaitMsg.Close;
end;

procedure TMsgForm.BtnCancelClick(Sender: TObject);
begin
  _AbortFlg:=True;
end;

procedure TMsgForm.FormActivate(Sender: TObject);
begin
animate1.Active:=true;
end;

end.

unit FORM_CLIENT;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,erp_public, ExtCtrls;

type
  Tfm_client = class(TForm)
    Image1: TImage;
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    procedure resizeClient(var msg:TMessage);message WMMainWindowResize;
    { Private declarations }
  public

    { Public declarations }
  end;

var fm_client:tfm_client;
implementation

uses FORM_Main;


{$R *.dfm}

procedure Tfm_client.resizeClient(var msg:TMessage);
begin
  Width:=Application.MainForm.Width-12;
  Height:=Application.MainForm.Height-FM_Main.RzToolbar1.Height-53;
  top:=0;
  left:=0;
end;

procedure Tfm_client.FormDestroy(Sender: TObject);
begin
  fm_client:=nil;
end;

procedure Tfm_client.FormActivate(Sender: TObject);
begin
  self.Perform(WMMainWindowResize,0,0);
end;

end.

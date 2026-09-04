unit form_PoRecv_Print;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  Tfm_porecv_Print = class(TForm)
    BtnPrint: TButton;
    BtnCancel: TButton;
    RadioFormat: TRadioGroup;
    RadioScope: TRadioGroup;
    BtnPreview: TButton;
    procedure BtnPreviewClick(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses SysReport_Head;

{$R *.dfm}

procedure Tfm_porecv_Print.BtnPreviewClick(Sender: TObject);
begin
   ModalResult:=MrPreview;
end;

procedure Tfm_porecv_Print.BtnPrintClick(Sender: TObject);
begin
   ModalResult:=MrPrint;
end;

end.

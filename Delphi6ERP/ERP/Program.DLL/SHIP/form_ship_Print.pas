unit form_ship_Print;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFM_ship_Print = class(TForm)
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

procedure TFM_ship_Print.BtnPreviewClick(Sender: TObject);
begin
   ModalResult:=MrPreview;
end;

procedure TFM_ship_Print.BtnPrintClick(Sender: TObject);
begin
   ModalResult:=MrPrint;
end;

end.

unit FORM_ERP_BASE;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,ERP_PUBLIC;

type
  TFORM_ERP = class(TForm)
  private
    { Private declarations }
  public
    sysinfo:TSysInfo;
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
    procedure init() ;virtual; abstract;

    { Public declarations }
  end;

implementation

{$R *.dfm}

{ TFORM_ERP }


{ TFORM_ERP }

constructor TFORM_ERP.Create(Owner: TComponent);
begin
  inherited;
//  sysinfo:= TSysinfo.Create;
end;

destructor TFORM_ERP.Destroy;
begin
  inherited;
end;

end.

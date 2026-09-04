unit Form_Login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,erp_public,UTY;

procedure SysLogin(sysinfo:TSysinfo);
type
  TFM_Login = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    EditUser: TEdit;
    EditPassword: TEdit;
    Button2: TButton;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    sysinfo:TSysinfo; 
    { Public declarations }
  end;

implementation


{$R *.dfm}

procedure TFM_Login.Button1Click(Sender: TObject);
begin
  if SysLoginCheckUser(sysinfo,editUser.Text,EditPassword.Text) then
    ModalResult:=mrOK
  else
  begin
    ErrMsg('±b¸¹©Î±K½X¿ù»~',USER);
  end;

end;

procedure TFM_Login.FormCreate(Sender: TObject);
begin
  EditUser.Text:='';
  EditPassword.Text:='';
end;


procedure SysLogin(sysinfo:TSysinfo);
var fm:TFm_Login;
begin
  fm:=TFm_Login.Create(application);
  fm.sysinfo:=sysinfo;
  try
    if fm.ShowModal=mrCancel then begin
      Application.Terminate;
    end else begin
      sysinfo.LoginUserID:=fm.EditUser.Text;
    end;
  finally
    fm.Free;
  end;
end;


end.

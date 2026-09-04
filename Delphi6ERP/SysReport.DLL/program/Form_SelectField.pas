unit Form_SelectField;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  Tfm_SelectField = class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    Button2: TButton;
    procedure ListBox1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
function SelectField(list:TStringList):string;

implementation

function SelectField(list:TStringList):string;
var fm:Tfm_SelectField;
    i:integer;
begin
  fm:=Tfm_SelectField.Create(application);
  fm.ListBox1.Items.Assign(list);
  if fm.ShowModal=mrOK then
  begin
    i:=fm.ListBox1.ItemIndex;
    result:=fm.ListBox1.Items[i];
  end else
    result:='';
end;

{$R *.dfm}

procedure Tfm_SelectField.ListBox1DblClick(Sender: TObject);
begin
  ModalResult:=mrOK;
end;

end.

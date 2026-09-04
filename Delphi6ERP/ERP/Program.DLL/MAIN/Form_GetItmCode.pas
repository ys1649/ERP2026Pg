unit Form_GetItmCode;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, dxCntner, dxEditor, dxExEdtr, dxEdLib;

type
  TFM_GetItmCode = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    EditClass: TdxButtonEdit;
    EditSize: TdxButtonEdit;
    EditRod: TdxButtonEdit;
    EditFilm: TdxButtonEdit;
    EditSort: TdxButtonEdit;
    EditBound: TdxButtonEdit;
    EditTemper: TdxButtonEdit;
    EditUserDef1: TdxButtonEdit;
    EditUserDef2: TdxButtonEdit;
    EditItemCode: TdxEdit;
    Label10: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure EditClassButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure EditSizeButtonClick(Sender: TObject; AbsoluteIndex: Integer);
    procedure EditRodButtonClick(Sender: TObject; AbsoluteIndex: Integer);
    procedure EditFilmButtonClick(Sender: TObject; AbsoluteIndex: Integer);
    procedure EditSortButtonClick(Sender: TObject; AbsoluteIndex: Integer);
    procedure EditBoundButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure EditTemperButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure EditUserDef1ButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure EditUserDef2ButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure EditClassExit(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure GenerItemCode;
    procedure   ChkPropertyField;

    { Private declarations }
  public
    { Public declarations }
  end;

Function GetItemCode:string;
var
  FM: TFM_GetItmCode;

implementation

uses DataModule_Main, RecChoice, Uty;

Function GetItemCode:string;
begin
  FM:= TFM_GetItmCode.Create(Application);
  try
    if fm.ShowModal=MrOK then
      result:=fm.EditItemCode.text;
  finally
    fm.Free;

  end;

end;

{$R *.dfm}

procedure TFM_GetItmCode.EditClassButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var GetRec:TWRecChoice;
begin
  DM_MAIN.QryClass.Open;
	GetRec:=TWRecChoice.Create(self);
  try
    GetRec.DataSet:=DM_MAIN.QryClass;
    GetRec.ResultField:='CLS_CODE';
    GetRec.AddColunm('CLS_CODE','類別代碼',100);
    GetRec.AddColunm('CLS_NAME','類別名稱',200);
    GetRec.Width:=330;
    GetRec.KeyField:='CLS_CODE';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      EditClass.Text:=GetRec.SelList.Strings[0];
  finally
    DM_MAIN.QryClass.close;
    GetRec.free;
  end;
end;

procedure TFM_GetItmCode.EditSizeButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var GetRec:TWRecChoice;
begin
  DM_MAIN.QrySize.Open;
	GetRec:=TWRecChoice.Create(self);
  try
    GetRec.DataSet:=DM_MAIN.QrySize;
    GetRec.ResultField:='SIZ_CODE';
    GetRec.AddColunm('SIZ_CODE','尺寸代碼',100);
    GetRec.AddColunm('SIZ_NAME','尺寸名稱',200);
    GetRec.Width:=330;
    GetRec.KeyField:='SIZ_CODE';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      EditSize.Text:=GetRec.SelList.Strings[0];
  finally
    DM_MAIN.QrySIZE.close;
    GetRec.free;
  end;

end;

procedure TFM_GetItmCode.EditRodButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var GetRec:TWRecChoice;
begin
  DM_MAIN.QryRod.Open;
	GetRec:=TWRecChoice.Create(self);
  try
    GetRec.DataSet:=DM_MAIN.QryRod;
    GetRec.ResultField:='ROD_CODE';
    GetRec.AddColunm('ROD_CODE','瓷棒代碼',100);
    GetRec.AddColunm('ROD_NAME','瓷棒名稱',200);
    GetRec.Width:=330;
    GetRec.KeyField:='ROD_CODE';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      EditRod.Text:=GetRec.SelList.Strings[0];
  finally
    DM_MAIN.QryRod.close;
    GetRec.free;
  end;


end;

procedure TFM_GetItmCode.EditFilmButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var GetRec:TWRecChoice;
begin
  DM_MAIN.QryFilm.Open;
	GetRec:=TWRecChoice.Create(self);
  try
    GetRec.DataSet:=DM_MAIN.QryFilm;
    GetRec.ResultField:='FIL_CODE';
    GetRec.AddColunm('FIL_CODE','皮膜代碼',100);
    GetRec.AddColunm('FIL_NAME','皮膜名稱',200);
    GetRec.Width:=330;
    GetRec.KeyField:='FIL_CODE';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      EditFilm.Text:=GetRec.SelList.Strings[0];
  finally
    DM_MAIN.QryFilm.close;
    GetRec.free;
  end;


end;

procedure TFM_GetItmCode.EditSortButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var GetRec:TWRecChoice;
begin
  DM_MAIN.QrySort.Open;
	GetRec:=TWRecChoice.Create(self);
  try
    GetRec.DataSet:=DM_MAIN.QrySort;
    GetRec.ResultField:='SRT_CODE';
    GetRec.AddColunm('SRT_CODE','選別乘數代碼',100);
    GetRec.AddColunm('SRT_NAME','選別乘數名稱',200);
    GetRec.Width:=330;
    GetRec.KeyField:='SRT_CODE';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      EditSort.Text:=GetRec.SelList.Strings[0];
  finally
    DM_MAIN.QrySort.close;
    GetRec.free;
  end;
end;

procedure TFM_GetItmCode.EditBoundButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var GetRec:TWRecChoice;
begin
  DM_MAIN.QryBound.Open;
	GetRec:=TWRecChoice.Create(self);
  try
    GetRec.DataSet:=DM_MAIN.QryBound;
    GetRec.ResultField:='BND_CODE';
    GetRec.AddColunm('BND_CODE','阻值範圍代碼',100);
    GetRec.AddColunm('BND_NAME','阻值範圍名稱',200);
    GetRec.Width:=330;
    GetRec.KeyField:='BND_CODE';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      EditBound.Text:=GetRec.SelList.Strings[0];
  finally
    DM_MAIN.QryBound.close;
    GetRec.free;
  end;
end;

procedure TFM_GetItmCode.EditTemperButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var GetRec:TWRecChoice;
begin
  DM_MAIN.QryTemperature.Open;
	GetRec:=TWRecChoice.Create(self);
  try
    GetRec.DataSet:=DM_MAIN.QryTemperature;
    GetRec.ResultField:='TMT_CODE';
    GetRec.AddColunm('TMT_CODE','溫度係數代碼',100);
    GetRec.AddColunm('TMT_NAME','溫度係數名稱',200);
    GetRec.Width:=330;
    GetRec.KeyField:='TMT_CODE';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      EditTemper.Text:=GetRec.SelList.Strings[0];
  finally
    DM_MAIN.QryTemperature.close;
    GetRec.free;
  end;
end;

procedure TFM_GetItmCode.EditUserDef1ButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var GetRec:TWRecChoice;
begin
  DM_MAIN.QryUserDef1.Open;
	GetRec:=TWRecChoice.Create(self);
  try
    GetRec.DataSet:=DM_MAIN.QryUserDef1;
    GetRec.ResultField:='UD1_CODE';
    GetRec.AddColunm('UD1_CODE','自訂屬性1代碼',100);
    GetRec.AddColunm('UD1_NAME','自訂屬性1名稱',200);
    GetRec.Width:=330;
    GetRec.KeyField:='UD1_CODE';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      EditUserDef1.Text:=GetRec.SelList.Strings[0];
  finally
    DM_MAIN.QryUserDef1.close;
    GetRec.free;
  end;

end;

procedure TFM_GetItmCode.EditUserDef2ButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
var GetRec:TWRecChoice;
begin
  DM_MAIN.QryUserDef2.Open;
	GetRec:=TWRecChoice.Create(self);
  try
    GetRec.DataSet:=DM_MAIN.QryUserDef2;
    GetRec.ResultField:='UD2_CODE';
    GetRec.AddColunm('UD2_CODE','自訂屬性2代碼',100);
    GetRec.AddColunm('UD2_NAME','自訂屬性2名稱',200);
    GetRec.Width:=330;
    GetRec.KeyField:='UD2_CODE';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      EditUserDef2.Text:=GetRec.SelList.Strings[0];
  finally
    DM_MAIN.QryUserDef2.close;
    GetRec.free;
  end;


end;

procedure TFM_GetItmCode.EditClassExit(Sender: TObject);
begin
  GenerItemCode;
end;

procedure TFM_GetItmCode.GenerItemCode;
begin
  EditItemCode.Text:=EditClass.Text+'-'+EditSize.Text+'-'+EditRod.Text
                    +'-'+EditFilm.Text+'-'+EditSort.Text+'-'+EditBound.Text
                    +'-'+EditUserDef1.Text+'-'+EditUserDef2.Text;
end;

procedure TFM_GetItmCode.Button1Click(Sender: TObject);
begin
  ChkPropertyField;
  ModalResult:=mrOK;
end;

procedure TFM_GetItmCode.ChkPropertyField;
begin
  if not DataExist(dm_main.adoc,'TBLCLASS','CLS_CODE',EditClass.Text) then
    raise Exception.Create('種類代碼找不到 !');

  if not DataExist(dm_main.adoc,'TBLCLASS','CLS_CODE',EditClass.Text) then
    raise Exception.Create('尺寸代碼找不到 !');

  if not DataExist(dm_main.adoc,'TBLCLASS','CLS_CODE',EditClass.Text) then
    raise Exception.Create('瓷棒代碼找不到 !');

  if not DataExist(dm_main.adoc,'TBLCLASS','CLS_CODE',EditClass.Text) then
    raise Exception.Create('皮膜代碼找不到 !');

  if not DataExist(dm_main.adoc,'TBLCLASS','CLS_CODE',EditClass.Text) then
    raise Exception.Create('乘數代碼找不到 !');

  if not DataExist(dm_main.adoc,'TBLCLASS','CLS_CODE',EditClass.Text) then
    raise Exception.Create('阻值範圍代碼找不到 !');

  if not DataExist(dm_main.adoc,'TBLCLASS','CLS_CODE',EditClass.Text) then
    raise Exception.Create('溫度係數代碼找不到 !');

end;

end.

unit Form_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls,SysReport_Head,ADOConEd, ExtCtrls, Buttons,UTY;


type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    RadioGroupDataBaseType: TRadioGroup;
    BitBtn1: TBitBtn;
    adodc: TADOConnection;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure RadioGroupDataBaseTypeClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
//==================================================
//    SYSTEM REPORT DECLARE BEGIN
//==================================================
    srinit:TsrInit;
    srShowSysReportDef:TsrShowSysReportDef;
    srResApp:TsrResApp;
    srShowSysReportQuery:TsrShowSysReportQuery;
//=========== END OF SYSTEM REPORT DECLARE =========

    { Private declarations }
  public
    { Public declarations }
  end;


var
  Form1: TForm1;
  DataBaseType:TDataBaseType=MSSQL;
implementation


{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  adodc.open;
  srShowSysReportDef(adodc,DataBaseType);
end;

procedure TForm1.FormCreate(Sender: TObject);
var handle:THandle;
begin
  RadioGroupDataBaseType.ItemIndex:=0;
  RadioGroupDataBaseTypeClick(RadioGroupDataBaseType);

  adodc.Connected:=false;
  GetAdoConnectionString(adodc,ExtractFilePath(application.ExeName)+'SysReport.INI');
  adodc.Connected:=true;

  handle:=LoadLibrary('SysReport.DLL');
  if handle=0 then raise Exception.Create('SysReport.DLL Not Found!');

  @srinit:=GetProcAddress( handle, 'init' );
  if @srinit=nil then raise Exception.Create('Init() Not Found!');

  @srShowSysReportDef:=GetProcAddress( handle, 'ShowSysReportDef' );
  if @srShowSysReportDef=nil then raise Exception.Create('ShowSysReportDef() Not Found!');

  @srShowSysReportQuery:=GetProcAddress( handle, 'ShowSysReportQuery' );
  if @srShowSysReportQuery=nil then raise Exception.Create('ShowSysReportQuery() Not Found!');

  @srResApp:=GetProcAddress( handle, 'ResApp' );
  if @srResApp=nil then raise Exception.Create('RestAPP() Not Found!');

  srinit(Application);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  srResApp;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  srShowSysReportQuery(adodc,'INV_REP01',DataBaseType);
end;

procedure TForm1.RadioGroupDataBaseTypeClick(Sender: TObject);
begin
  case RadioGroupDataBaseType.ItemIndex of
    0: DataBaseType:=ACCESS;      //ACCESS
    1: DataBaseType:=MSSQL;         //SQL
    2: DataBaseType:=Oracle;      //ORACLE
  else
    raise Exception.Create('DataBase TYPE not support');
  end;
end;


procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  adodc.Connected:=false;
  EditConnectionString(AdoDc);

end;

end.

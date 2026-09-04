unit Form_SysRepFldDefEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrls, ExtCtrls, DB, dxCntner, dxEditor,
  dxExEdtr, dxEdLib, dxDBELib,AdoDB;

type
  TFm_SysRepFldDefEdit = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    dsSysReport: TDataSource;
    Panel3: TPanel;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    Label4: TLabel;
    DBEdit4: TDBEdit;
    Label5: TLabel;
    DBEdit5: TDBEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    DBEdit8: TDBEdit;
    GroupBox2: TGroupBox;
    Label9: TLabel;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    DBCheckIsSortFld: TDBCheckBox;
    Label10: TLabel;
    GroupBox3: TGroupBox;
    Label11: TLabel;
    DBMemo1: TDBMemo;
    Label13: TLabel;
    DBMemo3: TDBMemo;
    Label14: TLabel;
    DBEdit9: TDBEdit;
    Label12: TLabel;
    DBMemo2: TDBMemo;
    dsField: TDataSource;
    cbSRF_CONTROLTYPE: TDBComboBox;
    cbSRF_QUERYTYPE: TDBComboBox;
    cbSRF_DATATYPE: TDBComboBox;
    DBCheckBoxSortDec: TDBCheckBox;
    EditFieldName: TdxDBButtonEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure cbSRF_CONTROLTYPEChange(Sender: TObject);
    procedure cbSRF_QUERYTYPEChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure EditFieldNameButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
  private
    adodc:TAdoConnection;
    procedure ChkField;
    procedure GetField();
    function GetDataType(ty:TFieldType):string;
    { Private declarations }
  public
    procedure Init(adodc1:TAdoConnection;DataSetRep, DataSetField: TDataSet);
    { Public declarations }
  end;


implementation

uses Form_SysRepFldDef, Uty, SysReportUnit, Form_SelectField;

{$R *.dfm}

{ Tfm_SysReportDefEdit }

procedure TFm_SysRepFldDefEdit.Init(adodc1:TAdoConnection;DataSetRep, DataSetField: TDataSet);
begin
  adodc:=adodc1;
  SetOwnerCtrlReadOnly(self,False);
  SetCtrlReadOnly(DbEdit1,True);
  SetCtrlReadOnly(DbEdit2,True);
  SetCtrlReadOnly(DbEdit3,True);

  dsSysReport.DataSet:=DataSetRep;
  dsField.DataSet:=DataSetField;
  cbSRF_CONTROLTYPE.Items.Add('Edit');
  cbSRF_CONTROLTYPE.Items.Add('Date');
  cbSRF_CONTROLTYPE.Items.Add('ListItem');
  cbSRF_CONTROLTYPE.Items.Add('SQL');

  cbSRF_QUERYTYPE.Items.Add('Single');
  cbSRF_QUERYTYPE.Items.Add('Range');
  cbSRF_QUERYTYPE.Items.Add('MultiSelect');

  cbSRF_DATATYPE.Items.Add('String');
  cbSRF_DATATYPE.Items.Add('Numberic');
  cbSRF_DATATYPE.Items.Add('Date');
end;

procedure TFm_SysRepFldDefEdit.Button1Click(Sender: TObject);
begin
  try
    ChkField;
    dsField.DataSet.Post;
  except
    ModalResult:=mrNone;
    raise;
  end;
end;

procedure TFm_SysRepFldDefEdit.Button2Click(Sender: TObject);
begin
  dsField.DataSet.Cancel;
end;

procedure TFm_SysRepFldDefEdit.cbSRF_CONTROLTYPEChange(Sender: TObject);
begin
  SetCtrlReadOnly(dbmemo2,cbSRF_CONTROLTYPE.Text<>'ListItem');
  SetCtrlReadOnly(dbmemo1,cbSRF_CONTROLTYPE.Text<>'SQL');
  SetCtrlReadOnly(dbmemo3,cbSRF_CONTROLTYPE.Text<>'SQL');
  SetCtrlReadOnly(dbEdit9,cbSRF_CONTROLTYPE.Text<>'SQL');

  if (cbSRF_QUERYTYPE.Text='MultiSelect') and (cbSRF_CONTROLTYPE.Text<>'SQL') then
  begin
    dsField.DataSet.FieldByName('SRF_QUERYTYPE').Value:='Single';
    cbSRF_CONTROLTYPEChange(cbSRF_CONTROLTYPE);
  end;
end;

procedure TFm_SysRepFldDefEdit.cbSRF_QUERYTYPEChange(Sender: TObject);
begin
  if cbSRF_QUERYTYPE.Text='MultiSelect' then
  begin
    dsField.DataSet.FieldByName('SRF_CONTROLTYPE').Value:='SQL';
    cbSRF_CONTROLTYPEChange(cbSRF_CONTROLTYPE);
  end;
end;

procedure TFm_SysRepFldDefEdit.FormActivate(Sender: TObject);
begin
  cbSRF_CONTROLTYPEChange(cbSRF_CONTROLTYPE);
end;

procedure TFm_SysRepFldDefEdit.ChkField;
var CtrlType:string;
    ds:TDataset;
begin
  ds:=dsField.DataSet;
  ctrlType:=ds.FieldByName('SRF_CONTROLTYPE').AsString;
  if CtrlType='ListItem' then
    if trim(ds.FieldByName('SRF_LIST_VALUE').AsString)='' then
      ErrMsg('[選項列表] 不可空白',USER);
  if CtrlType='SQL' then
  begin
    if trim(ds.FieldByName('SRF_LIST_SQL').AsString)='' then
      ErrMsg('[選項SQL] 不可空白',USER);
    if trim(ds.FieldByName('SRF_LIST_FIELDDISP').AsString)='' then
      ErrMsg('[選項顯示欄位] 不可空白',USER);
    if trim(ds.FieldByName('SRF_LIST_RETURNFIELD').AsString)='' then
      ErrMsg('[選項傳回欄位] 不可空白',USER);
  end;

end;

procedure TFm_SysRepFldDefEdit.EditFieldNameButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
begin
  GetField();
end;

procedure TFm_SysRepFldDefEdit.GetField();
var qry:TAdoQuery;
    sql,where:STRING;
    sl:TStringList;
    i:integer;
    fld:string;
begin
  RunScript(dsSysReport.DataSet.fieldbyname('SRP_PRESCRIPT').AsString);
  sql:=dsSysReport.Dataset.FieldbyName('SRP_SELECT').Asstring;
  sql:=RunMultiSql(adodc,sql);
  qry:=TAdoQuery.Create(self);
  sl:=TStringList.Create;
  try
    qry.Connection:=adodc;
    where:= trim(dsSysReport.Dataset.FieldbyName('SRP_WHERE').Asstring);
    if where ='' then
      where :=' WHERE 1=2 '
    ELSE
      where := where + ' AND 1=2 ';

    sql:=sql+' '+where +' ' + dsSysReport.Dataset.FieldbyName('SRP_GROUPBY').Asstring
                    + ' '+dsSysReport.Dataset.FieldbyName('SRP_ORDERBY').Asstring;
    qry.SQL.Text:=sql;
    qry.Open;
    for i:=0 to  qry.FieldCount -1 do
    begin
      sl.Add(qry.Fields[i].FieldName);
    end;
    fld:=SelectField(sl);
    if fld='' then exit;
    dsField.DataSet.FieldByName('SRF_FIELDNAME').Value:=fld;
    dsField.DataSet.FieldByName('SRF_DATATYPE').Value:=GetDataType(qry.fieldbyname(fld).DataType);
  finally
    qry.Close;
    qry.Free;
    sl.Free;
  end;
end;

function TFm_SysRepFldDefEdit.GetDataType(ty: TFieldType): string;
begin
case ty of
 ftDateTime	,ftDate,ftTime	  :result:='Date';
 ftString	,ftWideString	      :result:='String' ;
else 
  result:='Numberic';
end;

end;

end.

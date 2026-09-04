unit form_SysReportDef;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, Grids, DBGrids, ExtCtrls, DBCtrls, StdCtrls,
  ppEndUsr, ppBands, ppCache, ppClass, ppProd,
  ppReport, ppDB, ppComm, ppRelatv, ppDBPipe, SysReport_Head, ppPrnabl,
  ppCtrls, myChkBox, ppChrt, ppChrtDP,UTY;

type

  Tfm_SysReportDef = class(TForm)
    qrySysReport: TADOQuery;
    dsSysReport: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Panel1: TPanel;
    BtnAppend: TButton;
    BtnModify: TButton;
    BtnDelete: TButton;
    BtnFieldDef: TButton;
    BtnRepDesign: TButton;
    QryTemplate: TADOQuery;
    QryReportData: TADOQuery;
    dsTemplate: TDataSource;
    dsReportData: TDataSource;
    plTemplate: TppDBPipeline;
    plReportData: TppDBPipeline;
    plReportDatappField1: TppField;
    plReportDatappField2: TppField;
    plReportDatappField3: TppField;
    plReportDatappField4: TppField;
    plReportDatappField5: TppField;
    plReportDatappField6: TppField;
    plReportDatappField7: TppField;
    ppReport: TppReport;
    ppHeaderBand1: TppHeaderBand;
    ppDetailBand1: TppDetailBand;
    ppFooterBand1: TppFooterBand;
    Panel2: TPanel;
    BtnExport: TButton;
    BtnImport: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Button1: TButton;
    Button2: TButton;
    lbSQL_CreateAccess: TListBox;
    lbSQL_CreateSQL: TListBox;
    lbSQL_CreateOracle: TListBox;
    ppDesigner: TppDesigner;
    procedure BtnAppendClick(Sender: TObject);
    procedure BtnModifyClick(Sender: TObject);
    procedure BtnRepDesignClick(Sender: TObject);
    procedure BtnFieldDefClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
    procedure BtnImportClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    DataBaseType:TDataBaseType;
    procedure SysRepDesigner(ADODC: TAdoconnection; RptCode, Sql: string);
    function DupReport(SRP_ID:integer;RptCode:string):integer;
    procedure DupRepField(src_SRP_ID, dst_SRP_ID: integer);
    procedure ChkSysRepTable(adodc:TAdoConnection);
    procedure DeleteExistRpt(adodc:TAdoConnection;filename:string);
    procedure RepFile2Table(adodc: TAdoConnection; TblName,
      filename: string);
    procedure ReNumSRP_ID(adodc:TAdoConnection);
    { Private declarations }
  public
    procedure Init(adodc: TAdoConnection);

    { Public declarations }
  end;

procedure ShowSysReportDef(adodc:TAdoConnection;DataBaseType:TDataBaseType);stdcall;export;

implementation

uses WaitMsg, Form_SysReportEdit,
  Form_SysRepFldDef, SysReportUnit, form_SysReportQuery, DBUty;

{$R *.dfm}

procedure Tfm_SysReportDef.BtnAppendClick(Sender: TObject);
var fm:TFm_SysReportEdit;
begin
  fm:=TFm_SysReportEdit.Create(application);
  try
    fm.DataSource.DataSet:=QrySysReport;
    QrySysReport.Append;
    qrySysReport.fieldbyname('SRP_ID').Value:=GetMaxId(qrySysReport.Connection,'TBLSYSREPORT','SRP_ID')+1;
    if fm.ShowModal=mrOK then
      QrySysReport.post
    else
      qrySysReport.cancel;
  finally
    fm.Close;
  end;
end;


procedure Tfm_SysReportDef.BtnModifyClick(Sender: TObject);
var fm:TFm_SysReportEdit;
begin
  fm:=TFm_SysReportEdit.Create(application);
  try
    fm.DataSource.DataSet:=QrySysReport;
    QrySysReport.Edit;
    fm.ShowModal;
  finally
    fm.Close;
  end;
end;


procedure Tfm_SysReportDef.BtnRepDesignClick(Sender: TObject);
var sql:string;
begin
  WMsg('Wait for Running Script');
  RunScript(qrySysReport.fieldbyname('SRP_PRESCRIPT').AsString);
  sql:=RunMultiSql(qrySysReport.Connection,qrySysReport.fieldbyname('SRP_SELECT').AsString);
  WMsgClose;
  sql:=sql+ ' ' + qrySysReport.fieldbyname('SRP_WHERE').AsString
      +' '+qrySysReport.fieldbyname('SRP_GROUPBY').AsString + ' '+ qrySysReport.fieldbyname('SRP_ORDERBY').AsString;
  SysRepDesigner(qrySysReport.Connection,qrySysReport.fieldbyname('SRP_CODE').Value,sql);
end;

procedure Tfm_SysReportDef.Init(adodc:TAdoConnection);
begin
  SetOwnerCtrlReadOnly(self,true);
  ChkSysRepTable(adodc);
  qrySysReport.Connection:=adodc;
  qrySysReport.Open;
end;

procedure ShowSysReportDef(adodc:TAdoConnection;DataBaseType:TDataBaseType);stdcall;export;
var fm:TFm_SysReportDef;
begin
  fm:=TFm_SysReportDef.Create(Application);
  try
    fm.DataBaseType:=DataBaseType;
    fm.Init(adodc);
    fm.ShowModal;
  finally
    fm.Free;
  end;
end;

procedure Tfm_SysReportDef.BtnFieldDefClick(Sender: TObject);
var fm:TFm_SysRepFldDef;
begin
  fm:=TFm_SysRepFldDef.Create(Application);
  try
    fm.Init(qrySysReport.Connection,qrySysReport);
    fm.ShowModal;
  finally
    fm.Free;
  end;


end;

procedure Tfm_SysReportDef.BtnDeleteClick(Sender: TObject);
begin
    if application.messageBox(
      ' 您確定要刪除嗎?'
      ,'資料刪除詢問',mb_YesNO)=IDNO then exit;
    qrySysReport.Connection.Execute('DELETE FROM TBLSYSREPORTFIELD WHERE SRP_ID='+qrySysReport.fieldbyname('SRP_ID').AsString);
    qrySysReport.Delete;
end;

procedure Tfm_SysReportDef.SysRepDesigner(ADODC: TAdoconnection; RptCode,
  Sql: string);
begin
  QryReportData.close;
  qryTemplate.close;
  qryTemplate.Connection:=adodc;
  QryReportData.Connection:=adodc;
  qryTemplate.SQL.Text:='SELECT * FROM TBLSYSREPORT';
  QryReportData.SQL.Text:=sql;
  qryTemplate.open;
  QryReportData.open;
  try
    with ppReport do
    begin
      Template.new;
      Template.DatabaseSettings.NameField:='SRP_CODE';
      Template.DatabaseSettings.Name:=RptCode;
      Template.DatabaseSettings.TemplateField := 'SRP_REPORTFILE';

      if not TBlobField( QryTemplate.FieldByName('SRP_REPORTFILE') ).IsNULL then
      begin
        try
          Template.LoadFromDatabase;
        except
        end;
      end;
      SaveAsTemplate := TRUE;
    end;

    with ppDesigner do
    begin
      BringToFront;
      WindowState:=wsMaximized;
      ShowModal;
    end;
  finally
    QryReportData.close;
    qryTemplate.close;
  end;

end;


procedure Tfm_SysReportDef.Button1Click(Sender: TObject);
var srcID,dstID:integer;

begin
  srcID:=qrySysReport.fieldbyname('SRP_ID').Value;
  dstID:=DupReport(srcID,qrySysReport.fieldbyname('SRP_CODE').AsString+'(COPY)');
  DupRepField(srcID,dstID);
  qrySysReport.Close;
  qrySysReport.Open;
  qrySysReport.Locate('SRP_ID',dstID,[]);

end;

procedure Tfm_SysReportDef.DupRepField(src_SRP_ID,dst_SRP_ID: integer);
VAR QRY,qrydst:TAdoQuery;
    I:integer;
    fldName:string;
begin
  qry:=TAdoQuery.Create(application);
  qryDst:=TAdoQuery.Create(application);
  try
    qry.Connection:=qrySysReport.Connection;
    qry.SQL.Text:='SELECT * FROM TBLSYSREPORTFIELD WHERE SRP_ID='+INTTOSTR(src_SRP_ID);

    qryDst.Connection:=qrySysReport.Connection;
    qryDst.SQL.Text:='SELECT * FROM TBLSYSREPORTFIELD WHERE SRP_ID='+INTTOSTR(dst_SRP_ID);

    qryDst.Open;
    QRY.Open;
//    if qry.Eof then RAISE EXCEPTION.Create('SRP_ID NOT FOUND !');
    
    while not qry.Eof do
    begin
      qryDst.Insert;
      qryDst.FieldByName('SRP_ID').Value:=inttostr(dst_SRP_ID);
      for i:=0 to qry.FieldCount-1 do
      begin
        fldName:=uppercase(qry.Fields[i].FieldName);
        if fldname='SRP_ID' then continue;
        qryDst.FieldByName(fldName).Value:=qry.FieldByName(fldName).Value;
      end;
      qrydst.Post;
      qry.Next;
    end;
  finally
    qry.Close;
    qry.Free;
    qryDst.Close;
    qryDst.Free;
  end;


end;

function Tfm_SysReportDef.DupReport(SRP_ID: integer; RptCode: string):integer;
VAR qry,QryDst:TAdoQuery;
    I:integer;
    fldName:string;
    NewID:integer;
begin
  qry:=TAdoQuery.Create(application);
  qryDst:=TAdoQuery.Create(application);
  result:=-1;
  try
    NewID:=GetMaxId(qrySysReport.Connection,'TBLSYSREPORT','SRP_ID')+1;

    qry.Connection:=qrySysReport.Connection;
    qryDst.Connection:=qrySysReport.Connection;

    qry.SQL.Text:='SELECT * FROM TBLSYSREPORT WHERE SRP_ID='+INTTOSTR(SRP_ID);
    qryDst.SQL.Text:='SELECT * FROM TBLSYSREPORT WHERE SRP_ID='+INTTOSTR(NewId);

    QRY.Open;
    if qry.Eof then RAISE EXCEPTION.Create('SRP_ID NOT FOUND !');
    qryDst.open;

    qryDst.Insert;
    qryDst.FieldByName('SRP_ID').Value:=NewID;
    qryDst.FieldByName('SRP_CODE').Value:=RptCode;
    for i:=0 to qry.FieldCount-1 do
    begin
      fldName:=uppercase(qry.Fields[i].FieldName);
      if fldname='SRP_ID' then continue;
      if fldname='SRP_CODE' then continue;
      qryDst.FieldByName(fldName).Value:=qry.FieldByName(fldName).Value;
    end;
    qryDst.Post;
    result:=NewID;
  finally
    qry.Close;
    qry.Free;
    qryDst.Close;
    qryDst.Free;

  end;
end;

procedure Tfm_SysReportDef.BtnExportClick(Sender: TObject);
VAR path,filename:string;
begin
  if not SaveDialog1.Execute then exit;
  path:=EXTRACTFILEDIR(SaveDialog1.FileName);
  if StrRight(path,1)<>'\' then path:=path+'\';
  filename:=path+'TBLSYSREPORT.XML';
  Table2File(qrySysReport.Connection,'TBLSYSREPORT',FILENAME);
  filename:=path+'TBLSYSREPORTFIELD.XML';
  Table2File(qrySysReport.Connection,'TBLSYSREPORTFIELD',FILENAME);

end;

procedure Tfm_SysReportDef.BtnImportClick(Sender: TObject);
VAR path,filename:string;
begin
  if not OpenDialog1.Execute then exit;
  qrySysReport.Close;
  path:=EXTRACTFILEDIR(OpenDialog1.FileName);
  if StrRight(path,1)<>'\' then path:=path+'\';
  filename:=path+'TBLSYSREPORT.XML';
  DeleteExistRpt(qrySysReport.Connection,filename);
  RepFile2Table(qrySysReport.Connection,'TBLSYSREPORT',FILENAME);
  filename:=path+'TBLSYSREPORTFIELD.XML';
  RepFile2Table(qrySysReport.Connection,'TBLSYSREPORTFIELD',FILENAME);
  ReNumSRP_ID(QrySysReport.Connection);
  qrySysReport.open;

end;

procedure Tfm_SysReportDef.Button2Click(Sender: TObject);
VAR RPTCODE:STRING;
begin
  RPTCODE:=qrySysReport.fieldbyname('SRP_CODE').AsString;

//==============================================================
//  這裡關閉 Connection 的目的在於 Run SQL Server 時,若有temp table
//  可讓系統先自動刪除 temp table    
//==============================================================
  qrySysReport.close;
  qrySysReport.Connection.Close;
  qrySysReport.Connection.Open;
  ShowSysReportQuery(qrySysReport.Connection,RPTCODE,DataBaseType);
  qrySysReport.Open;
  qrySysReport.Locate('SRP_CODE',RPTCODE,[]);
end;

procedure Tfm_SysReportDef.ChkSysRepTable(adodc: TAdoConnection);
begin
  if TableExist(Adodc,'TBLSYSREPORT') then exit;
  case DataBaseType of
    ACCESS  :RunMultiSql(adodc,lbSQL_CreateAccess.items.Text);
    MSSQL     :RunMultiSql(adodc,lbSQL_CreateSQL.items.Text);
    Oracle  :RunMultiSql(adodc,lbSQL_CreateOracle.items.Text);
    else
      raise Exception.Create('DataBase Type not Support');
  end;

end;

procedure Tfm_SysReportDef.DeleteExistRpt(adodc: TAdoConnection;
  filename: string);
var qry:TAdoQuery;
    SRP_ID:STRING;
begin
  qry:=TAdoQuery.Create(application);
  QRY.Connection:=ADODC;
  try
    qry.LoadFromFile(fileName);
    qry.First;
    while not qry.Eof do
    begin
      SRP_ID:=VARTOSTR(TblLookup(ADODC,'TBLSYSREPORT','SRP_CODE',QRY.FIELDBYNAME('SRP_CODE').AsString,'SRP_ID'));
      IF SRP_ID<>'' THEN
      BEGIN
        ADODC.Execute('DELETE FROM TBLSYSREPORTFIELD WHERE SRP_ID='+SRP_ID);
        ADODC.Execute('DELETE FROM TBLSYSREPORT WHERE SRP_ID='+SRP_ID);
      END;
      QRY.Next;
    end;
  finally
    qry.Close;
    qry.Free;
  end;
end;


procedure Tfm_SysReportDef.RepFile2Table(adodc:TAdoConnection;TblName,filename:string);
var qry,QryDst:TAdoQuery;
    fldName:string;
    i:integer;
begin
  qry:=TAdoQuery.Create(application);
  QryDst:=TAdoQuery.Create(application);
  try
    QryDst.Connection:=adodc;
    qry.LoadFromFile(fileName);
    QryDst.SQL.Text:='SELECT * FROM '+TblName+' ';
    QryDst.Open;

    qry.First;
    while not qry.Eof do
    begin
      qry.edit;
      qry.FieldByName('SRP_ID').Value:=
            qry.FieldByName('SRP_ID').Value+1000000;
      qry.post;
      qryDst.Insert;
      for i:=0 to qry.FieldCount-1 do
      begin
        fldName:=uppercase(qry.Fields[i].FieldName);
        if qryDst.FieldByName(fldName).CanModify then
        qryDst.FieldByName(fldName).Value:=qry.FieldByName(fldName).Value;
      end;
      qrydst.Post;
      qry.Next;
    end;
  finally
    qry.Close;
    qry.Free;
    QryDst.Close;
    QryDst.Free;
  end;

end;



procedure Tfm_SysReportDef.ReNumSRP_ID(adodc: TAdoConnection);
const id_offset=10000000;
var qry:TAdoQuery;
  Old_id,New_id:integer;
  sql:string;
begin
  ADODC.BeginTrans;
  try
    SQL:='INSERT INTO TBLSYSREPORT (SRP_ID,SRP_CODE,SRP_NAME,SRP_SELECT)'
        +' SELECT SRP_ID+'+inttostr(id_offset)+','+SQLSTR('~#@~')
        +' + CONVERT(VARCHAR,SRP_ID),SRP_NAME,'+SQLSTR('DUMMY')
        +' FROM TBLSYSREPORT';
    ADODC.Execute(SQL);
    SQL:='UPDATE TBLSYSREPORTFIELD SET SRP_ID=SRP_ID+'+inttostr(id_offset);
    ADODC.Execute(SQL);

    qry:=TAdoQuery.Create(self);
    try
      New_ID:=0;
      qry.Connection:=adodc;
      qry.SQL.Text:='SELECT SRP_ID FROM TBLSYSREPORT'
                   +' WHERE SRP_ID<'+inttostr(id_offset)
                   +' ORDER BY SRP_CODE';
      QRY.Open;
      WHILE NOT QRY.Eof do
      begin
        inc(New_id);
        old_id:=qry.Fields[0].AsInteger;
        qry.Edit;
        qry.Fields[0].Value:=new_id;
        qry.post;
        sql:='UPDATE TBLSYSREPORTFIELD SET SRP_ID='
            +INTTOSTR(NEW_ID)
            +' WHERE SRP_ID='+inttostr(old_id+id_offset);
        adodc.Execute(sql);
        qry.Next;
      end;
      SQL:='DELETE TBLSYSREPORT WHERE SRP_ID>='+inttostr(id_offset);
      ADODC.Execute(SQL);
    finally
      qry.Close;
      qry.Free;
    end;
    adodc.CommitTrans;
  except
    adodc.RollbackTrans;
  end;


end;

end.

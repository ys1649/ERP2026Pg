unit Form_FormReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, ppProd, ppClass, ppReport, ppComm, ppRelatv, ppDB,ppCtrls,
  ppTypes,ppDBPipe, ppEndUsr, ppBands, ppCache,DBTables, ExtCtrls, ppViewr,
  SysReport_Head, TXComp, Menus, myChkBox, ppBarCod, ppPrnabl, ppChrt,
  ppChrtDP,Uty, StdCtrls, Grids, DBGrids;

type
  Tfm_FormReport = class(TForm)
    QryReportData: TADOQuery;
    dsReportData: TDataSource;
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
    QryTemplate: TADOQuery;
    dsTemplate: TDataSource;
    plTemplate: TppDBPipeline;
    SaveDialog: TSaveDialog;
    ExtraOptions1: TExtraOptions;
    Panel1: TPanel;
    BtnPreview: TButton;
    BtnExportExcel: TButton;
    BtnClose: TButton;
    Panel2: TPanel;
    btnNew: TButton;
    btnCopy: TButton;
    btnDelete: TButton;
    btnDesign: TButton;
    qryFormReport: TADOQuery;
    dsFormReport: TDataSource;
    DBGrid1: TDBGrid;
    ADOConnection1: TADOConnection;
    qryFormReportFRP_FORMNAME: TStringField;
    qryFormReportFRP_REPORTNAME: TStringField;
    qryFormReportFRP_REPORTFILE: TBlobField;
    ppDesigner: TppDesigner;
    qryFormReportFRP_SYSDEFAULT: TBooleanField;
    btnRename: TButton;
    btnExport: TButton;
    BtnImport: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    procedure ppReportPreviewFormCreate(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnDesignClick(Sender: TObject);
    procedure BtnPreviewClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnRenameClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure BtnImportClick(Sender: TObject);
  private
    Adodc:TADOConnection;
    FormName:String;
    procedure ShowFormReport(FormName, RptName: string; PrintMode: TModalResult);
    procedure RefreshData;
    procedure DeleteExistRpt(adodc: TAdoConnection; filename: string);
    procedure RepFile2Table(adodc: TAdoConnection; TblName,
      filename: string);
  public
    procedure init(Adodc: TAdoConnection; FormName, sql: string);
  end;



implementation

uses Form_Query, SysReportUnit, erp_public, DBUty;

{$R *.dfm}



{ Tfm_SysReportQuery }



procedure Tfm_FormReport.ShowFormReport(FormName,RptName:string;PrintMode:TModalResult);
var stream:TMemoryStream;
    qry:TAdoQuery;
    sql:string;

begin

//==========================================================================
//  qryTemplate 只是為了讓報表可以 show 出 報表id 及 報表名稱
//  plTemplate 名字不可隨意改變 ,需跟 Form_SysReportDEF(報表設計)plTemplate名字一樣
//==========================================================================
	sql:='SELECT *' +CR
			+'FROM TBLFORMREPORT A' +CR
			+'WHERE A.FRP_FORMNAME    ='+sqlstr(FormName) +CR
			+'	AND A.FRP_REPORTNAME  ='+sqlstr(RptName) +CR;
  qryTemplate.close;
  qryTemplate.Connection:=adodc;
  qryTemplate.SQL.Text:=SQL;
  qryTemplate.open;


  qry:=TAdoQuery.Create(self);
  qry.Connection:=adodc;
  qry.SQL.Text:=sql;
  qry.Open;

  Stream:=TMemoryStream.Create;
  try
    (qry.FieldByName('FRP_REPORTFILE') as TBlobField).SaveToStream(stream);
    ppReport.Template.LoadFromStream(stream);
  finally
    qryTemplate.Close;
    qry.Close;
    qry.free;
    stream.Free;
  end;
  QryReportData.First;
  try
    if QryReportData.Eof then
    begin
      msg('無任何符合查詢條件的資料  !!');
      exit;
    end;

    ppReport.ModalPreview := TRUE;

    if PrintMode=mrPreview then
    begin
      ppReport.OnPreviewFormCreate:=ppReportPreviewFormCreate;
      ppReport.ShowPrintDialog:=True;
      ppReport.DeviceType:='Screen';
      ppReport.AllowPrintToFile:=True;
      ppreport.Print;
    end else if PrintMode=mrPrint then
    begin
      ppReport.ShowPrintDialog:=True;
      ppReport.DeviceType:='Printer';
      ppreport.Print;
    end else if PrintMode=mrExport then
    begin
      ppReport.DeviceType:='ExcelFile';
      if not SaveDialog.Execute then exit;
      ppReport.TextFileName := SaveDialog.FileName;
      ppReport.ShowPrintDialog:=false;
      ppreport.Print;
    end

  finally
//    QryReportData.Close;
  end;

end;





procedure Tfm_FormReport.ppReportPreviewFormCreate(Sender: TObject);
begin
  ppreport.PreViewForm.WindowState := wsMaximized;
  TppViewer(ppReport.preViewForm.Viewer).ZoomSetting := zsPageWidth;
end;


procedure Tfm_FormReport.init(Adodc: TAdoConnection; FormName: string;sql:string);
begin
  Self.Adodc:=Adodc;
  Self.FormName:=FormName;
  setAdoConnection(Self,adodc);
  QryReportData.SQL.Text:=sql;
  QryReportData.Open;
  RefreshData;

end;


procedure Tfm_FormReport.RefreshData;
var s:string;
begin
	s:='SELECT *' +CR
			+'FROM TBLFORMREPORT  A' +CR
			+'WHERE A.FRP_FORMNAME='+sqlstr(FormName);
  qryFormReport.SQL.Text:=s;
  qryFormReport.Open;

end;

procedure Tfm_FormReport.btnNewClick(Sender: TObject);
var RptName:string;
begin
  if InputQuery('輸入報表名稱','報表名稱',RptName)<>True then Exit;
  RptName:=Trim(RptName);
  qryFormReport.Append;
  qryFormReportFRP_FORMNAME.Value:=FormName;
  qryFormReportFRP_REPORTNAME.Value:=RptName;
  qryFormReportFRP_SYSDEFAULT.Value:=False;
  qryFormReport.Post;
end;

procedure Tfm_FormReport.btnDesignClick(Sender: TObject);
var
    sql:string;
begin
	sql:='SELECT *' +CR
			+'FROM TBLFORMREPORT  A' +CR
			+'WHERE A.FRP_FORMNAME    ='+sqlstr(FormName) +CR
			+'	AND A.FRP_REPORTNAME  ='+sqlstr(qryFormReportFRP_REPORTNAME.Value) +CR;


  qryTemplate.close;
  qryTemplate.Connection:=adodc;
  qryTemplate.SQL.Text:=sql;
  qryTemplate.open;
  QryReportData.First;
  try
    with ppReport do
    begin
      Template.New;
      Template.DatabaseSettings.NameField:='FRP_REPORTNAME';
      Template.DatabaseSettings.Name:=qryFormReportFRP_REPORTNAME.AsString;
      Template.DatabaseSettings.TemplateField := 'FRP_REPORTFILE';

      if not TBlobField( QryTemplate.FieldByName('FRP_REPORTFILE') ).IsNULL then
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
    qryTemplate.close;
  end;

end;




procedure Tfm_FormReport.BtnPreviewClick(Sender: TObject);
begin
  ShowFormReport(FormName,qryFormReportFRP_REPORTNAME.AsString,mrPreview);
end;

procedure Tfm_FormReport.btnCopyClick(Sender: TObject);
var RptName:string;
    qry:TAdoQuery;
begin
  qry:=CreateQry(Adodc);
  try
    qry.SQL.Text:=qryFormReport.SQL.Text;
    qry.Open;
    qry.Append;
    CopyDataRow(qryFormReport,qry);
    RptName:=qryFormReportFRP_REPORTNAME.AsString+'-'+INTTOSTR(qryFormReport.RecordCount);
    qry.fieldbyname('FRP_REPORTNAME').Value:=RptName;
    qry.Post;
    RefreshData;
    qryFormReport.Locate('FRP_REPORTNAME',RptName,[]);
  finally
    qry.close;
    qry.Free;
  end;

end;


procedure Tfm_FormReport.btnRenameClick(Sender: TObject);
var RptName:string;
begin
  RptName:=qryFormReportFRP_REPORTNAME.AsString;
  if InputQuery('更改報表名稱','新的報表名稱',RptName)<>True then Exit;
  RptName:=Trim(RptName);
  qryFormReport.Edit;
  qryFormReportFRP_REPORTNAME.Value:=RptName;
  qryFormReport.Post;
end;

procedure Tfm_FormReport.BtnCloseClick(Sender: TObject);
begin
close;
end;

procedure Tfm_FormReport.btnDeleteClick(Sender: TObject);
begin
  if MessageDlg('是否確定刪除 ?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;
  qryFormReport.Delete;
end;

procedure Tfm_FormReport.btnExportClick(Sender: TObject);
VAR path,filename:string;
begin
  if not SaveDialog1.Execute then exit;
  path:=EXTRACTFILEDIR(SaveDialog1.FileName);
  if StrRight(path,1)<>'\' then path:=path+'\';
  filename:=path+'TBLFORMREPORT.XML';
  Table2File(Adodc,'TBLFORMREPORT',FILENAME);

end;



procedure Tfm_FormReport.BtnImportClick(Sender: TObject);
VAR path,filename:string;
begin
  if not OpenDialog1.Execute then exit;
  qryFormReport.Close;
  path:=EXTRACTFILEDIR(OpenDialog1.FileName);
  if StrRight(path,1)<>'\' then path:=path+'\';
  filename:=path+'TBLFORMREPORT.XML';
  DeleteExistRpt(Adodc,filename);
  RepFile2Table(Adodc,'TBLFORMREPORT',FILENAME);
  RefreshData;

end;



procedure Tfm_FormReport.DeleteExistRpt(adodc: TAdoConnection;
  filename: string);
var qry:TAdoQuery;
    s,FRP_FORMNAME,FRP_REPORTNAME:STRING;
    SQL:string;
begin
  qry:=TAdoQuery.Create(application);
  QRY.Connection:=ADODC;
  try
    qry.LoadFromFile(fileName);
    qry.First;
    while not qry.Eof do begin
      FRP_FORMNAME    :=qry.FIELDBYNAME('FRP_FORMNAME').AsString;
      FRP_REPORTNAME  :=qry.FIELDBYNAME('FRP_REPORTNAME').AsString;

      s:=VARTOSTR(TblLookupKey(ADODC,'TBLFORMREPORT','FRP_REPORTNAME','FRP_FORMNAME,FRP_REPORTNAME'
                                    ,[FRP_FORMNAME,FRP_REPORTNAME]));
      IF s<>'' THEN BEGIN
        SQL:='DELETE  TBLFORMREPORT'+cr
            +'WHERE FRP_FORMNAME   ='+sqlstr(FRP_FORMNAME)+cr
            +'  AND FRP_REPORTNAME ='+SQLSTR(FRP_REPORTNAME);
        ADODC.Execute(SQL);
      END;
      QRY.Next;
    end;
  finally
    qry.Close;
    qry.Free;
  end;
end;


procedure Tfm_FormReport.RepFile2Table(adodc:TAdoConnection;TblName,filename:string);
var qry,QryDst:TAdoQuery;
begin
  qry:=TAdoQuery.Create(application);
  QryDst:=TAdoQuery.Create(application);
  try
    QryDst.Connection:=adodc;
    qry.LoadFromFile(fileName);
    QryDst.SQL.Text:='SELECT * FROM '+TblName+' ';
    QryDst.Open;

    qry.First;
    while not qry.Eof do begin
      qryDst.Insert;
      CopyDataRow(QRY,QryDst);
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



end.

unit From_AcntCash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, ppCtrls, ppPrnabl, ppClass, ppDB,DateUtils,
  ppBands, ppCache, ppDBPipe, ppComm, ppRelatv, ppProd, ppReport, ppVar,ppViewr,
  StdCtrls, Grids, DBGrids, ExtCtrls, wwdbdatetimepicker, dxCntner,
  dxEditor, dxExEdtr, dxEdLib,erp_public,FORM_ERP_BASE;

type
  TFm_AcntCash = class(TForm_ERP)
    qryReport: TADOQuery;
    dsReport: TDataSource;
    ppDBPipeline1: TppDBPipeline;
    ppReport: TppReport;
    ppHeaderBand1: TppHeaderBand;
    ppDetailBand1: TppDetailBand;
    ppFooterBand1: TppFooterBand;
    ppLabel8: TppLabel;
    ppSystemVariable1: TppSystemVariable;
    ppLabel9: TppLabel;
    ppSystemVariable2: TppSystemVariable;
    ppLine2: TppLine;
    ppLabel1: TppLabel;
    ppLabel2: TppLabel;
    ppLabel3: TppLabel;
    ppLine1: TppLine;
    ppLabel5: TppLabel;
    ppLblPeriod: TppLabel;
    ppLblCorName: TppLabel;
    ppDBText4: TppDBText;
    qry: TADOQuery;
    ppGroup1: TppGroup;
    ppGroupHeaderBand1: TppGroupHeaderBand;
    ppGroupFooterBand1: TppGroupFooterBand;
    ppDBText1: TppDBText;
    ppDBText2: TppDBText;
    ppLabel6: TppLabel;
    ppLabel7: TppLabel;
    ppDBText6: TppDBText;
    ppDBCalc1: TppDBCalc;
    ppLabel4: TppLabel;
    ppDBText3: TppDBText;
    ppDBText5: TppDBText;
    ppDBText7: TppDBText;
    ppLabel10: TppLabel;
    ppLine3: TppLine;
    Label1: TLabel;
    dt1: TwwDBDateTimePicker;
    Button1: TButton;
    Button2: TButton;
    dt2: TwwDBDateTimePicker;
    Label2: TLabel;
    procedure ppReportPreviewFormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    sql_rpt:string;
    procedure setSQL;

    { Private declarations }
  public
    procedure init;override;
    { Public declarations }
  end;


implementation

uses Uty;

{$R *.dfm}



procedure TFm_AcntCash.ppReportPreviewFormCreate(Sender: TObject);
begin
  ppreport.PreViewForm.WindowState := wsMaximized;
  TppViewer(ppReport.preViewForm.Viewer).ZoomSetting := zsPageWidth;

end;

procedure TFm_AcntCash.init;
begin
  setAdoConnection(self,sysinfo.AdoConnection);

  dt1.Date:=strtodate(inttostr(sysinfo.spr_acnt_year)+'/01/01');
  dt2.Date:=strtodate(inttostr(sysinfo.spr_acnt_year)+'/12/31');
  sql_rpt:=qryReport.SQL.Text;
end;



procedure TFm_AcntCash.setSQL;
var dtFrom,dtTo:tDate;
  dateFrom,DateTo:string;
  sql:string;
  const sqlOrder=' ORDER BY A.ACT_NO,JNL_DATE,JNL_NO,JND_SEQNO';


begin
  dateFrom:=dt1.Text;
  dateTo:=dt2.Text;
  if dateFrom='' then begin
    dateFrom:='1980/01/01';
    dateTo:='2099/12/31';
  end;
  dtFrom:=strtodate(DateFrom);
  dtTo:=strtodate(DateTo)+1;


  ppLblPeriod.Caption:=dateFrom+ ' ~ '+ dateTo;
  ppLblCorName.Caption:=sysinfo.SPR_COR_NAME;
  dateFrom:=SqlDateTimeSQL(dtFrom);
  dateTo:=SqlDateTimeSQL(dtTo);
  sql:=sql_rpt;
  sql:=StringReplace(sql,'''04/01/2003''','dateFrom',[rfReplaceAll]);
  sql:=StringReplace(sql,'''06/01/2003''','dateTo',[rfReplaceAll]);

  sql:=StringReplace(sql,'dateFrom',dateFrom,[rfReplaceAll]);
  sql:=StringReplace(sql,'dateTo',dateTo,[rfReplaceAll]);
  sql:=sql+CR+' WHERE A.ACT_NO = ''1111''';
  sql:=sql+CR+sqlOrder;
  debug (sql);
  qryReport.SQL.Text:=sql;
end;

procedure TFm_AcntCash.Button1Click(Sender: TObject);
begin
    SetSQL;
    ppReport.Print;

end;

procedure TFm_AcntCash.Button2Click(Sender: TObject);
begin
  close;
end;

end.

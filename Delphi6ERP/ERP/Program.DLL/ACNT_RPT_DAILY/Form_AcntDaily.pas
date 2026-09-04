unit Form_AcntDaily;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, ppCtrls, ppPrnabl, ppClass, ppDB,DateUtils,
  ppBands, ppCache, ppDBPipe, ppComm, ppRelatv, ppProd, ppReport, ppVar,ppViewr,
  StdCtrls, Grids, DBGrids, ExtCtrls, wwdbdatetimepicker, dxCntner,
  dxEditor, dxExEdtr, dxEdLib,FORM_ERP_BASE,Erp_Public;

type
  TFm_AcntDaily = class(TForm_ERP)
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
    ppLine1: TppLine;
    ppLabel5: TppLabel;
    ppLblPeriod: TppLabel;
    ppLblCorName: TppLabel;
    qry: TADOQuery;
    ppLabel7: TppLabel;
    ppLabel4: TppLabel;
    ppDBText3: TppDBText;
    ppDBText5: TppDBText;
    ppDBText7: TppDBText;
    ppLabel10: TppLabel;
    ppLabel3: TppLabel;
    ppLabel6: TppLabel;
    ppLabel11: TppLabel;
    ppDBText1: TppDBText;
    ppDBText2: TppDBText;
    ppDBText4: TppDBText;
    ppDBText6: TppDBText;
    ppGroup1: TppGroup;
    ppGroupHeaderBand1: TppGroupHeaderBand;
    ppGroupFooterBand1: TppGroupFooterBand;
    Label1: TLabel;
    Label2: TLabel;
    dt1: TwwDBDateTimePicker;
    Button1: TButton;
    Button2: TButton;
    dt2: TwwDBDateTimePicker;
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



procedure TFm_AcntDaily.ppReportPreviewFormCreate(Sender: TObject);
begin
  ppreport.PreViewForm.WindowState := wsMaximized;
  TppViewer(ppReport.preViewForm.Viewer).ZoomSetting := zsPageWidth;

end;

procedure TFm_AcntDaily.init;
begin
  setAdoConnection(self,sysinfo.AdoConnection);
  dt1.Date:=strtodate(inttostr(sysinfo.spr_acnt_year)+'/01/01');
  dt2.Date:=strtodate(inttostr(sysinfo.spr_acnt_year)+'/12/31');
  sql_rpt:=qryReport.SQL.Text;
end;




procedure TFm_AcntDaily.setSQL;
var dtFrom,dtTo:tDate;
  dateFrom,DateTo:string;
  sql:string;


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
  sql:=StringReplace(sql,'''01/01/2003''','dateFrom',[rfReplaceAll]);
  sql:=StringReplace(sql,'''01/01/2004''','dateTo',[rfReplaceAll]);

  sql:=StringReplace(sql,'dateFrom',dateFrom,[rfReplaceAll]);
  sql:=StringReplace(sql,'dateTo',dateTo,[rfReplaceAll]);
  debug (sql);
  qryReport.SQL.Text:=sql;
end;

procedure TFm_AcntDaily.Button1Click(Sender: TObject);
begin
    SetSQL;
    ppReport.Print;

end;

procedure TFm_AcntDaily.Button2Click(Sender: TObject);
begin
  close;
end;

end.

unit Form_AcntTrialBalance;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, ppCtrls, ppPrnabl, ppClass, ppDB,DateUtils,
  ppBands, ppCache, ppDBPipe, ppComm, ppRelatv, ppProd, ppReport, ppVar,ppViewr,
  StdCtrls, Grids, DBGrids, ExtCtrls, wwdbdatetimepicker, dxCntner,
  dxEditor, dxExEdtr, dxEdLib,FORM_ERP_BASE,Erp_Public;

type
  TFm_AcntTrialBalance = class(TForm_ERP)
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
    ppLine1: TppLine;
    ppLabel5: TppLabel;
    ppLblRange: TppLabel;
    ppLblCorName: TppLabel;
    ppDBText4: TppDBText;
    qry: TADOQuery;
    ppLabel6: TppLabel;
    ppLabel7: TppLabel;
    ppDBText6: TppDBText;
    ppLabel4: TppLabel;
    ppDBText5: TppDBText;
    ppDBText7: TppDBText;
    ppLabel10: TppLabel;
    ppSummaryBand1: TppSummaryBand;
    ppDBCalc1: TppDBCalc;
    ppDBCalc2: TppDBCalc;
    ppLabel2: TppLabel;
    ppLine3: TppLine;
    ppLabel3: TppLabel;
    ppDBCalc3: TppDBCalc;
    ppLine4: TppLine;
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    Image1: TImage;
    Label4: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    dtFrom: TwwDBDateTimePicker;
    dtTo: TwwDBDateTimePicker;
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



procedure TFm_AcntTrialBalance.ppReportPreviewFormCreate(Sender: TObject);
begin
  ppreport.PreViewForm.WindowState := wsMaximized;
  TppViewer(ppReport.preViewForm.Viewer).ZoomSetting := zsPageWidth;

end;

procedure TFm_AcntTrialBalance.init;
begin
  setAdoConnection(self,sysinfo.AdoConnection);
  dtFrom.Date:=now;
  dtTo.Date:=now;
  sql_rpt:=qryReport.SQL.Text;
end;



procedure TFm_AcntTrialBalance.setSQL;
var
  DateFrom,DateTo:TDateTime;
  sql:string;

begin
  dateFrom  :=dtFrom.Date;
  DateTo    :=dtTo.Date+1;


  ppLblRange.Text:=dtFrom.Text+' ~ '+ dtto.Text;
  ppLblCorName.Caption:=sysinfo.SPR_COR_NAME;

  sql:=' SELECT B.ACT_NO,C.ACT_NAME,SUM(B.JND_AMOUNT) DEBIT,0 CREDIT,SUM(B.JND_AMOUNT) AMOUNT' + CR
      +' FROM TBL_ACNT_JOURNAL A ' + CR
      +' INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
      +' INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO' + CR
      +' WHERE A.JNL_DATE >='+SqlDateTimeSQL(DateFrom) +cr
      +' 		and A.JNL_DATE <'+SqlDateTimeSQL(DateTo) +CR

      +' GROUP BY B.ACT_NO,C.ACT_NAME' + CR
      +' HAVING SUM(B.JND_AMOUNT)>=0' + CR
      +' ' + CR
      +' UNION' + CR
      +' SELECT B.ACT_NO,C.ACT_NAME,0 DEBIT,-SUM(B.JND_AMOUNT) CREDIT,SUM(B.JND_AMOUNT) AMOUNT' + CR
      +' FROM TBL_ACNT_JOURNAL A ' + CR
      +' INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
      +' INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO' + CR
      +' WHERE A.JNL_DATE >='+SqlDateTimeSQL(DateFrom) +cr
      +' 		and A.JNL_DATE <'+SqlDateTimeSQL(DateTo) +CR
      +' GROUP BY B.ACT_NO,C.ACT_NAME' + CR
      +' HAVING SUM(B.JND_AMOUNT)<0';
  debug (sql);
  qryReport.SQL.Text:=sql;
end;

procedure TFm_AcntTrialBalance.Button1Click(Sender: TObject);
begin
  SetSQL;
  ppReport.Print;

end;

procedure TFm_AcntTrialBalance.Button2Click(Sender: TObject);
begin
  inherited;
  Close;
end;

end.

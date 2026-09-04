unit Form_AcntCash;

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
    dtFrom: TwwDBDateTimePicker;
    Button1: TButton;
    Button2: TButton;
    dtTo: TwwDBDateTimePicker;
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

  dtFrom.Date:=strtodate(inttostr(sysinfo.spr_acnt_year)+'/01/01');
  dtTo.Date:=strtodate(inttostr(sysinfo.spr_acnt_year)+'/12/31');
  sql_rpt:=qryReport.SQL.Text;
end;



procedure TFm_AcntCash.setSQL;
var DateFrom,DateTo:tDate;
  sql:string;
  const sqlOrder=' ORDER BY A.ACT_NO,JNL_DATE,JNL_NO,JND_SEQNO';
begin

  DateFrom  :=dtFrom.Date;
  DateTo    :=dtTo.Date+1;

  ppLblPeriod.Caption:=dtFrom.Text+ ' ~ '+ dtTo.Text;
  ppLblCorName.Caption:=sysinfo.SPR_COR_NAME;


  sql:='SELECT A.JNL_DATE,A.JNL_NO,A.JND_SEQNO,JND_DESC,A.ACT_NO,ACT_NAME,AMOUNT' + CR
      +' 			,''DEBIT''= CASE' + CR
      +' 								WHEN AMOUNT>=0 THEN AMOUNT' + CR
      +' 								ELSE 0' + CR
      +' 							END' + CR
      +' 			,''CREDIT''= CASE' + CR
      +' 								WHEN AMOUNT<0 THEN -AMOUNT' + CR
      +' 								ELSE 0' + CR
      +' 							END' + CR
      +' ' + CR
      +' FROM' + CR
      +' (	SELECT A.JNL_DATE,A.JNL_NO,B.JND_SEQNO,B.ACT_NO,B.JND_DESC,B.JND_AMOUNT AMOUNT' + CR
      +' 	FROM TBL_ACNT_JOURNAL A' + CR
      +' 	INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
      +' 	WHERE A.JNL_DATE >= '+SqlDateTimeSQL(DateFrom) +CR
      +' 		AND A.JNL_DATE < ' +SqlDateTimeSQL(DateTo+1) +CR
      +'    AND A.jnl_bill_type <>2'
      +' 	UNION' + CR
      +' 	SELECT '+SqlDateTimeSQL(dateFrom)+' JNL_DATE' + CR
      +' 				,''@@INIT'' JNL_NO' + CR
      +' 				,0 JND_SEQNO' + CR
      +' 				,ACT_NO' + CR
      +' 				,''´Áªìª÷ÃB'' JND_DESC' + CR
      +' 				,SUM(AMOUNT) AMOUNT' + CR
      +' 	FROM' + CR
      +' 	(	SELECT A.JNL_NO,B.JND_SEQNO,B.ACT_NO,B.JND_AMOUNT AMOUNT' + CR
      +' 		FROM TBL_ACNT_JOURNAL A' + CR
      +' 		INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
      +' 		WHERE A.JNL_DATE < '+SqlDateTimeSQL(dateFrom) +CR
      +'    AND A.jnl_bill_type <>2'
      +' 	) A' + CR
      +' 	GROUP BY A.ACT_NO' + CR
      +' ) A INNER JOIN TBL_ACNT_ACCOUNT B ON A.ACT_NO=B.ACT_NO' + CR
      +' WHERE A.ACT_NO=''1111''';


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

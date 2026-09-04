unit Form_AcntIncomeStament;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, ppCtrls, ppPrnabl, ppClass, ppDB,
  ppBands, ppCache, ppDBPipe, ppComm, ppRelatv, ppProd, ppReport, ppVar,ppViewr,
  StdCtrls, Grids, DBGrids, ExtCtrls,FORM_ERP_BASE,Erp_Public,
  wwdbdatetimepicker;

type
  TFm_AcntIncomeStament = class(TForm_ERP)
    qry: TADOQuery;
    qry_income: TADOQuery;
    DS_INCOME: TDataSource;
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
    ppDBText4: TppDBText;
    ppLabel1: TppLabel;
    ppLabel2: TppLabel;
    ppLabel3: TppLabel;
    ppLabel4: TppLabel;
    ppLine1: TppLine;
    ppLabel5: TppLabel;
    ppDtRange: TppLabel;
    ppGroup1: TppGroup;
    ppGroupHeaderBand1: TppGroupHeaderBand;
    ppGroupFooterBand1: TppGroupFooterBand;
    ppDBText1: TppDBText;
    ppDBText2: TppDBText;
    ppDBText3: TppDBText;
    ppDBText5: TppDBText;
    ppDBCalc1: TppDBCalc;
    ppDBText6: TppDBText;
    ppLine3: TppLine;
    ppLineLong: TppLine;
    ppLabel6: TppLabel;
    ppLbl1: TppLabel;
    ppLbl2: TppLabel;
    ppDBCalc2: TppDBCalc;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    Label2: TLabel;
    dtFrom: TwwDBDateTimePicker;
    Label3: TLabel;
    dtTo: TwwDBDateTimePicker;
    Image1: TImage;
    Label4: TLabel;
    procedure ppReportPreviewFormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ppGroupFooterBand1BeforeGenerate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    DateFrom,DateTo:TDateTime;
    TotalRevenue,TotalCost,TotalExpense,TotalNoOp,TotalTax:currency;
    procedure GetRptSummary;

    { Private declarations }
  public
    procedure init;override;
    { Public declarations }
  end;

implementation

uses Uty;

{$R *.dfm}



procedure TFm_AcntIncomeStament.GetRptSummary;
  var sql:string;
begin
  SQL:='SELECT SUM(B.JND_AMOUNT) * -1 C_JND_AMOUNT'
      +' FROM TBL_ACNT_JOURNAL A'
      +' INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO'
      +' INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO'
      +' INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO'
      +' WHERE TYP_MAJOR_TYPE =''營業收入'''
      +' 		and A.JNL_DATE >='+SqlDateTimeSQL(DateFrom) +CR
      +' 		and A.JNL_DATE <'+SqlDateTimeSQL(DateTo);

  QRY.SQL.Text:=SQL;
  QRY.Open;
  TotalRevenue:=qry.Fields[0].AsCurrency;
  qry.close;


  SQL:='SELECT SUM(B.JND_AMOUNT) * -1 C_JND_AMOUNT'
      +' FROM TBL_ACNT_JOURNAL A'
      +' INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO'
      +' INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO'
      +' INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO'
      +' WHERE TYP_MAJOR_TYPE =''營業成本'''
      +' 		and A.JNL_DATE >='+SqlDateTimeSQL(DateFrom) +CR
      +' 		and A.JNL_DATE <'+SqlDateTimeSQL(DateTo);

  QRY.SQL.Text:=SQL;
  QRY.Open;
  TotalCost:=qry.Fields[0].AsCurrency;
  qry.close;

  SQL:='SELECT SUM(B.JND_AMOUNT) * -1 C_JND_AMOUNT'
      +' FROM TBL_ACNT_JOURNAL A'
      +' INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO'
      +' INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO'
      +' INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO'
      +' WHERE TYP_MAJOR_TYPE =''營業費用'''
      +' 		and A.JNL_DATE >='+SqlDateTimeSQL(DateFrom) +CR
      +' 		and A.JNL_DATE <'+SqlDateTimeSQL(DateTo);

  QRY.SQL.Text:=SQL;
  QRY.Open;
  TotalExpense:=qry.Fields[0].AsCurrency;
  qry.close;

  SQL:='SELECT SUM(B.JND_AMOUNT) * -1 C_JND_AMOUNT'
      +' FROM TBL_ACNT_JOURNAL A'
      +' INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO'
      +' INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO'
      +' INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO'
      +' WHERE TYP_MAJOR_TYPE =''營業外收入及費用'''
      +' 		and A.JNL_DATE >='+SqlDateTimeSQL(DateFrom) +CR
      +' 		and A.JNL_DATE <'+SqlDateTimeSQL(DateTo);

  QRY.SQL.Text:=SQL;
  QRY.Open;
  TotalNoOp:=qry.Fields[0].AsCurrency;
  qry.close;


  SQL:='SELECT SUM(B.JND_AMOUNT) * -1 C_JND_AMOUNT'
      +' FROM TBL_ACNT_JOURNAL A'
      +' INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO'
      +' INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO'
      +' INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO'
      +' WHERE TYP_MAJOR_TYPE =''所得稅費用(或利益)'''
      +' 		and A.JNL_DATE >='+SqlDateTimeSQL(DateFrom) +CR
      +' 		and A.JNL_DATE <'+SqlDateTimeSQL(DateTo);

  QRY.SQL.Text:=SQL;
  QRY.Open;
  TotalTax:=qry.Fields[0].AsCurrency;
  qry.close;

end;


procedure TFm_AcntIncomeStament.ppReportPreviewFormCreate(Sender: TObject);
begin
  ppreport.PreViewForm.WindowState := wsMaximized;
  TppViewer(ppReport.preViewForm.Viewer).ZoomSetting := zsPageWidth;

end;

procedure TFm_AcntIncomeStament.Button1Click(Sender: TObject);
var sql:string;

begin
{         sql:=sql_income;
          sql:=stringreplace(sql,'2003',condYear, [rfReplaceAll]);
}
  DateFrom  :=dtFrom.Date;
  DateTo    :=dtTo.Date+1;
  ppDtRange.Text:=dtFrom.Text +' ～ '+dtTo.Text;

  GetRptSummary;

  sql:='SELECT 1 SN,A.TYP_MAJOR_TYPE,A.ACT_NAME,A.ACT_NO,A.SubTotal' + CR
      +' 			,RATE=	CASE B.AMOUNT' + CR
      +' 							WHEN 	0 THEN 0' + CR
      +' 							ELSE (A.SubTotal/b.amount)*100 ' + CR
      +' 							END' + CR
      +' 			,S.SPR_COR_NAME' + CR
      +' FROM' + CR
      +' (	SELECT D.TYP_MAJOR_TYPE,C.ACT_NAME,C.ACT_NO' + CR
      +' 				,SUM(B.JND_AMOUNT) * -1 SubTotal' + CR
      +' 	FROM TBL_ACNT_JOURNAL A' + CR
      +' 		INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
      +' 		INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO' + CR
      +' 		INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO' + CR
      +' 	WHERE D.TYP_MAJOR_TYPE =''營業收入''' + CR
      +' 		and A.JNL_DATE >='+SqlDateTimeSQL(DateFrom) +cr
      +' 		and A.JNL_DATE <'+SqlDateTimeSQL(DateTo) +CR
      +' 	GROUP BY  D.TYP_MAJOR_TYPE,C.ACT_NAME,C.ACT_NO' + CR
      +' ) A,' + CR
      +' (	SELECT D.TYP_MAJOR_TYPE' + CR
      +' 				,SUM(B.JND_AMOUNT) * -1 AMOUNT' + CR
      +' 	FROM TBL_ACNT_JOURNAL A' + CR
      +' 		INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
      +' 		INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO' + CR
      +' 		INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO' + CR
      +' 	WHERE D.TYP_MAJOR_TYPE =''營業收入''' + CR
      +' 		and A.JNL_DATE >='+SqlDateTimeSQL(DateFrom) +cr
      +' 		and A.JNL_DATE <'+SqlDateTimeSQL(DateTo) +CR
      +' 	GROUP BY  D.TYP_MAJOR_TYPE' + CR
      +' ) B' + CR
      +' ,TBL_SYS_PARAM S' + CR
      +' ' + CR
      +' union' + CR
      +' SELECT 2 SN,A.TYP_MAJOR_TYPE,A.ACT_NAME,A.ACT_NO,A.SubTotal' + CR
      +' 			,RATE=	CASE B.AMOUNT' + CR
      +' 							WHEN 	0 THEN 0' + CR
      +' 							ELSE (A.SubTotal/b.amount)*100 ' + CR
      +' 							END' + CR
      +' 			,S.SPR_COR_NAME' + CR
      +' FROM' + CR
      +' (	SELECT D.TYP_MAJOR_TYPE,C.ACT_NAME,C.ACT_NO' + CR
      +' 				,SUM(B.JND_AMOUNT) SubTotal' + CR
      +' 	FROM TBL_ACNT_JOURNAL A' + CR
      +' 		INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
      +' 		INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO' + CR
      +' 		INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO' + CR
      +' 	WHERE D.TYP_MAJOR_TYPE =''營業成本''' + CR
      +' 		and A.JNL_DATE >='+SqlDateTimeSQL(DateFrom) +cr
      +' 		and A.JNL_DATE <'+SqlDateTimeSQL(DateTo) +CR
      +' 	GROUP BY  D.TYP_MAJOR_TYPE,C.ACT_NAME,C.ACT_NO' + CR
      +' ) A,' + CR
      +' (	SELECT D.TYP_MAJOR_TYPE' + CR
      +' 				,SUM(B.JND_AMOUNT) AMOUNT' + CR
      +' 	FROM TBL_ACNT_JOURNAL A' + CR
      +' 		INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
      +' 		INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO' + CR
      +' 		INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO' + CR
      +' 	WHERE D.TYP_MAJOR_TYPE =''營業成本''' + CR
      +' 		and A.JNL_DATE >='+SqlDateTimeSQL(DateFrom) +cr
      +' 		and A.JNL_DATE <'+SqlDateTimeSQL(DateTo) +CR
      +' 	GROUP BY  D.TYP_MAJOR_TYPE' + CR
      +' ) B' + CR
      +' ,TBL_SYS_PARAM S' + CR
      +' ' + CR
      +' UNION' + CR
      +' SELECT 3 SN,A.TYP_MAJOR_TYPE,A.ACT_NAME,A.ACT_NO,A.SubTotal' + CR
      +' 			,RATE=	CASE B.AMOUNT' + CR
      +' 							WHEN 	0 THEN 0' + CR
      +' 							ELSE (A.SubTotal/b.amount)*100 ' + CR
      +' 							END' + CR
      +' 			,S.SPR_COR_NAME' + CR
      +' FROM' + CR
      +' (	SELECT D.TYP_MAJOR_TYPE,C.ACT_NAME,C.ACT_NO' + CR
      +' 				,SUM(B.JND_AMOUNT) SubTotal' + CR
      +' 	FROM TBL_ACNT_JOURNAL A' + CR
      +' 		INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
      +' 		INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO' + CR
      +' 		INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO' + CR
      +' 	WHERE D.TYP_MAJOR_TYPE =''營業費用''' + CR
      +' 		and A.JNL_DATE >='+SqlDateTimeSQL(DateFrom) +cr
      +' 		and A.JNL_DATE <'+SqlDateTimeSQL(DateTo) +CR
      +' 	GROUP BY  D.TYP_MAJOR_TYPE,C.ACT_NAME,C.ACT_NO' + CR
      +' ) A,' + CR
      +' (	SELECT D.TYP_MAJOR_TYPE' + CR
      +' 				,SUM(B.JND_AMOUNT) AMOUNT' + CR
      +' 	FROM TBL_ACNT_JOURNAL A' + CR
      +' 		INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
      +' 		INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO' + CR
      +' 		INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO' + CR
      +' 	WHERE D.TYP_MAJOR_TYPE =''營業費用''' + CR
      +' 		and A.JNL_DATE >='+SqlDateTimeSQL(DateFrom) +cr
      +' 		and A.JNL_DATE <'+SqlDateTimeSQL(DateTo) +CR
      +' 	GROUP BY  D.TYP_MAJOR_TYPE' + CR
      +' ) B' + CR
      +' ,TBL_SYS_PARAM S' + CR
      +' ' + CR
      +' UNION' + CR
      +' SELECT 4 SN,A.TYP_MAJOR_TYPE,A.ACT_NAME,A.ACT_NO,A.SubTotal' + CR
      +' 			,RATE=	CASE B.AMOUNT' + CR
      +' 							WHEN 	0 THEN 0' + CR
      +' 							ELSE (A.SubTotal/b.amount)*100 ' + CR
      +' 							END' + CR
      +' 			,S.SPR_COR_NAME' + CR
      +' FROM' + CR
      +' (	SELECT D.TYP_MAJOR_TYPE,C.ACT_NAME,C.ACT_NO' + CR
      +' 				,SUM(B.JND_AMOUNT) * -1 SubTotal' + CR
      +' 	FROM TBL_ACNT_JOURNAL A' + CR
      +' 		INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
      +' 		INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO' + CR
      +' 		INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO' + CR
      +' 	WHERE D.TYP_MAJOR_TYPE =''營業外收入及費用''' + CR
      +' 		and A.JNL_DATE >='+SqlDateTimeSQL(DateFrom) +cr
      +' 		and A.JNL_DATE <'+SqlDateTimeSQL(DateTo) +CR
      +' 	GROUP BY  D.TYP_MAJOR_TYPE,C.ACT_NAME,C.ACT_NO' + CR
      +' ) A,' + CR
      +' (	SELECT D.TYP_MAJOR_TYPE' + CR
      +' 				,SUM(B.JND_AMOUNT) * -1 AMOUNT' + CR
      +' 	FROM TBL_ACNT_JOURNAL A' + CR
      +' 		INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
      +' 		INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO' + CR
      +' 		INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO' + CR
      +' 	WHERE D.TYP_MAJOR_TYPE =''營業外收入及費用''' + CR
      +' 		and A.JNL_DATE >='+SqlDateTimeSQL(DateFrom) +cr
      +' 		and A.JNL_DATE <'+SqlDateTimeSQL(DateTo) +CR
      +' 	GROUP BY  D.TYP_MAJOR_TYPE' + CR
      +' ) B' + CR
      +' ,TBL_SYS_PARAM S' + CR
      +' ' + CR
      +' UNION' + CR
      +' SELECT 5 SN,A.TYP_MAJOR_TYPE,A.ACT_NAME,A.ACT_NO,A.SubTotal' + CR
      +' 			,RATE=	CASE B.AMOUNT' + CR
      +' 							WHEN 	0 THEN 0' + CR
      +' 							ELSE (A.SubTotal/b.amount)*100 ' + CR
      +' 							END' + CR
      +' 			,S.SPR_COR_NAME' + CR
      +' FROM' + CR
      +' (	SELECT D.TYP_MAJOR_TYPE,C.ACT_NAME,C.ACT_NO' + CR
      +' 				,SUM(B.JND_AMOUNT) SubTotal' + CR
      +' 	FROM TBL_ACNT_JOURNAL A' + CR
      +' 		INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
      +' 		INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO' + CR
      +' 		INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO' + CR
      +' 	WHERE D.TYP_MAJOR_TYPE =''所得稅費用(或利益)''' + CR
      +' 		and A.JNL_DATE >='+SqlDateTimeSQL(DateFrom) +cr
      +' 		and A.JNL_DATE <'+SqlDateTimeSQL(DateTo) +CR
      +' 	GROUP BY  D.TYP_MAJOR_TYPE,C.ACT_NAME,C.ACT_NO' + CR
      +' ) A,' + CR
      +' (	SELECT D.TYP_MAJOR_TYPE' + CR
      +' 				,SUM(B.JND_AMOUNT) AMOUNT' + CR
      +' 	FROM TBL_ACNT_JOURNAL A' + CR
      +' 		INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
      +' 		INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO' + CR
      +' 		INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO' + CR
      +' 	WHERE D.TYP_MAJOR_TYPE =''所得稅費用(或利益)''' + CR
      +' 		and A.JNL_DATE >='+SqlDateTimeSQL(DateFrom) +cr
      +' 		and A.JNL_DATE <'+SqlDateTimeSQL(DateTo) +CR
      +' 	GROUP BY  D.TYP_MAJOR_TYPE' + CR
      +' ) B' + CR
      +' ,TBL_SYS_PARAM S' + CR
      +' ' + CR
      +' ORDER BY SN,ACT_NO';

  debug (sql);
  QRY_INCOME.Close;
  qry_income.sql.Text:=sql;
//  QRY_INCOME.Open;
  ppReport.Print;

end;

procedure TFm_AcntIncomeStament.ppGroupFooterBand1BeforeGenerate(Sender: TObject);
begin
  if ppDBText6.Text='營業成本' then begin
    ppLbl1.Text:='毛利';
    ppLbl2.Text:=currtostr(TotalRevenue+TotalCost);
    ppLineLong.Visible:=true;
    ppLbl1.Visible:=true;
    ppLbl2.Visible:=true;
  end else if  ppDBText6.Text='營業費用' then begin
    ppLineLong.Visible:=true;
    ppLbl1.Visible:=true;
    ppLbl2.Visible:=true;
    ppLineLong.Visible:=true;
    ppLbl1.Text:='淨利';
    ppLbl2.Text:=currtostr(TotalRevenue+TotalCost+TotalExpense);
  end else if  ppDBText6.Text='營業外收入及費用' then begin
    ppLineLong.Visible:=true;
    ppLbl1.Visible:=true;
    ppLbl2.Visible:=true;
    ppLineLong.Visible:=true;
    ppLbl1.Text:='稅前損益';
    ppLbl2.Text:=currtostr(TotalRevenue+TotalCost+TotalExpense+TotalNoOp);
  end else if  ppDBText6.Text='所得稅費用(或利益)' then begin
    ppLineLong.Visible:=true;
    ppLbl1.Visible:=true;
    ppLbl2.Visible:=true;
    ppLineLong.Visible:=true;
    ppLbl1.Text:='本期損益';
    ppLbl2.Text:=currtostr(TotalRevenue+TotalCost+TotalExpense+TotalNoOp+TotalTax);
  end else begin
    ppLineLong.Visible:=false;
    ppLbl1.Visible:=false;
    ppLbl2.Visible:=false;
  end;

end;

procedure TFm_AcntIncomeStament.init;
begin
  setAdoConnection(self,sysinfo.AdoConnection);
  dtFrom.Date:=now;
  dtTo.Date:=now;
end;


procedure TFm_AcntIncomeStament.Button2Click(Sender: TObject);
begin
  close;
end;

end.

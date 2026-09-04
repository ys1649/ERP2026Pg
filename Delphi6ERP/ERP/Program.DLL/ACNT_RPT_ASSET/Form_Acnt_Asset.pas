unit Form_Acnt_Asset;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, ppCtrls, ppPrnabl, ppClass, ppDB,DateUtils,
  ppBands, ppCache, ppDBPipe, ppComm, ppRelatv, ppProd, ppReport, ppVar,ppViewr,
  StdCtrls, Grids, DBGrids, ExtCtrls, wwdbdatetimepicker,FORM_ERP_BASE,erp_public;

type
  TFm_Acnt_Asset = class(TForm_ERP)
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
    ppLabel4: TppLabel;
    ppLine1: TppLine;
    ppLabel5: TppLabel;
    ppLblEndDate: TppLabel;
    ppLblCorName: TppLabel;
    ppGroup1: TppGroup;
    ppGroupHeaderBand1: TppGroupHeaderBand;
    ppGroupFooterBand1: TppGroupFooterBand;
    ppGroup2: TppGroup;
    ppGroupHeaderBand2: TppGroupHeaderBand;
    ppGroupFooterBand2: TppGroupFooterBand;
    ppDBText1: TppDBText;
    ppDBText2: TppDBText;
    ppDBText3: TppDBText;
    ppDBText4: TppDBText;
    ppDBText5: TppDBText;
    ppDBText6: TppDBText;
    ppDBCalc1: TppDBCalc;
    ppDBCalc2: TppDBCalc;
    ppDBText7: TppDBText;
    ppLabel6: TppLabel;
    ppDBText8: TppDBText;
    ppLabel7: TppLabel;
    ppLine3: TppLine;
    ppLine5: TppLine;
    ppDBCalc3: TppDBCalc;
    qry: TADOQuery;
    dt1: TwwDBDateTimePicker;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    Image1: TImage;
    Label4: TLabel;
    procedure ppReportPreviewFormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    sql_rpt:string;
    procedure setSQL;

  public
    procedure init;override;
    { Public declarations }
  end;

implementation

uses Uty;

{$R *.dfm}



procedure TFm_Acnt_Asset.ppReportPreviewFormCreate(Sender: TObject);
begin
  ppreport.PreViewForm.WindowState := wsMaximized;
  TppViewer(ppReport.preViewForm.Viewer).ZoomSetting := zsPageWidth;

end;

procedure TFm_Acnt_Asset.init;
begin
  setAdoConnection(self,sysinfo.AdoConnection);
  dt1.Date:=strtodate(inttostr(sysinfo.spr_acnt_year)+'/12/31');
  sql_rpt:=qryReport.SQL.Text;
//  SetupQueryForm;
end;



procedure TFm_Acnt_Asset.setSQL;
var sql:string;
    dtFrom,dtEnd:tdate;
    sum_asset,sum_liability,sum_equity:currency;
    yy,mm,dd:word;
begin

{================================================================================
    求 DateFrom ,DateEnd
    DateEnd   =查詢終止日期
    DateFrom  = 如果目前會計年度< yearof(DateEnd) then
                    DateFrom= 目前會計年度/1月1日  (
                    ex: 目前會計年度  =2005
                        查詢終止日期  =2006/12/31
                        DateFrom      =2005/1/1

                如果目前會計年度>=yearof(DateEnd)
                    DateFrom= yearof(DateEnd)/1月1日
                    ex: 目前會計年度  =2006
                        查詢終止日期  =2004/12/31
                        DateFrom      =2004/1/1
================================================================================}
  if dt1.Text='' then begin
    dtEnd:=EncodeDate(2099,12,31);
  end else begin
    dtEnd:=dt1.Date;
  end;
  DecodeDate(dtEnd,yy,mm,dd);
  if sysinfo.SPR_ACNT_YEAR< yy then begin
    dtFrom:=EncodeDate(sysinfo.SPR_ACNT_YEAR,1,1);
  end else begin
    dtFrom:=EncodeDate(yy,1,1);
  end;



  qryReport.Close;
  ppLblEndDate.Caption:=dt1.Text;
  ppLblCorName.Caption:=sysinfo.SPR_COR_NAME;



{===============================================================================
  先把  '01/01/2004' 轉成 'date_end'  ,'01/01/2003' 轉成 'date_start'
  再把  'date_end' 轉成 date_end      ,'date_start'轉成 date_start
===============================================================================}
{===============================================================================
  get sum of assets  資產總額 for 計算比率
===============================================================================}
  sql:='SELECT SUM(A.JND_AMOUNT) AMOUNT' + CR
      +' FROM' + CR
      +' (	SELECT B.JNL_NO,B.JND_SEQNO,B.ACT_NO,B.JND_AMOUNT' + CR
      +' 	FROM TBL_ACNT_JOURNAL A' + CR
      +' 		INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
      +' 	WHERE A.JNL_DATE >= ' +SqlDateTimeSQL(dtFrom) +CR
      +'    AND A.JNL_DATE < '  +SqlDateTimeSQL(dtEnd+1) +CR
      +' ) A' + CR
      +' INNER JOIN TBL_ACNT_ACCOUNT C ON A.ACT_NO=C.ACT_NO' + CR
      +' INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO' + CR
      +' WHERE D.TYP_MAJOR_TYPE =''資產''';

  debug ('');
  debug ('資產總額','A');
  debug (sql,'A');
  qry.SQL.Text:=sql;
  qry.open;
  sum_asset:=qry.Fields[0].AsCurrency;
  qry.close;


{===============================================================================
  get sum of liability  負債總額 for 計算比率
===============================================================================}
  sql:='SELECT SUM(A.JND_AMOUNT) AMOUNT' + CR
      +' FROM' + CR
      +' (	SELECT B.JNL_NO,B.JND_SEQNO,B.ACT_NO,B.JND_AMOUNT' + CR
      +' 	FROM TBL_ACNT_JOURNAL A' + CR
      +' 		INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
      +' 	WHERE A.JNL_DATE >= ' +SqlDateTimeSQL(dtFrom) +CR
      +'    AND A.JNL_DATE < '  +SqlDateTimeSQL(dtEnd+1) +CR
      +' ) A' + CR
      +' INNER JOIN TBL_ACNT_ACCOUNT C ON A.ACT_NO=C.ACT_NO' + CR
      +' INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO' + CR
      +' WHERE D.TYP_MAJOR_TYPE =''負債''';
  debug ('','A');
  debug ('負債總額','A');
  debug (sql,'A');

  qry.sql.Text:=sql;
  qry.open;
  sum_liability:=qry.Fields[0].AsCurrency;
  qry.close;


{===============================================================================
  get sum of equity  業主權益總額 for 計算比率
===============================================================================}
  sql:='SELECT SUM(A.JND_AMOUNT) AMOUNT' + CR
      +'FROM' + CR
      +' ( SELECT B.JNL_NO,B.JND_SEQNO,B.ACT_NO,B.JND_AMOUNT' + CR
      +'   FROM TBL_ACNT_JOURNAL A' + CR
      +'     INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
      +' 		 INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO' + CR
      +' 		 INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO' + CR
      +'   WHERE A.JNL_DATE >= ' +SqlDateTimeSQL(dtFrom) +CR
      +'     AND A.JNL_DATE < '  +SqlDateTimeSQL(dtEnd+1) +CR
      +' 	   AND D.TYP_MAJOR_TYPE =''業主權益''' + CR
      +'   UNION' + CR
      +'   SELECT ''PROFIT'',-1,''3353'' ACT_NO' + CR
      +'         ,SUM(B.JND_AMOUNT)  AMOUNT' + CR
      +'   FROM TBL_ACNT_JOURNAL A' + CR
      +'     INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
      +'     INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO' + CR
      +'     INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO' + CR
      +'   WHERE A.JNL_DATE >= ' +SqlDateTimeSQL(dtFrom) +CR
      +'     AND A.JNL_DATE < '  +SqlDateTimeSQL(dtEnd+1) +CR
      +'     AND D.TYP_MAJOR_TYPE NOT IN (''資產'',''負債'',''業主權益'')' + CR
      +' ) A';
  debug ('','A');
  debug ('業主權益總額','A');
  debug (sql,'A');
  qry.SQL.Text:=sql;
  qry.open;
  sum_equity:=qry.Fields[0].AsCurrency;
  qry.close;


{===============================================================================
  產生 report
===============================================================================}
	sql:='--======================== 資產 ==============================================' + CR
			+' SELECT ''資產'' GRP,A.TYP_MAJOR_TYPE,A.TYP_NO,TYP_NAME,A.ACT_NO,A.ACT_NAME,A.AMOUNT' + CR
			+' 			,(A.AMOUNT/'+floattostr(sum_asset)+') * 100 RATE' + CR
			+' FROM' + CR
			+' (	SELECT D.TYP_MAJOR_TYPE,D.TYP_NO,D.TYP_NAME,SUBSTRING(C.ACT_NO,1,4) ACT_NO,C.ACT_NAME' + CR
			+' 			,SUM(A.JND_AMOUNT) AMOUNT' + CR
			+' 	FROM' + CR
			+' 	(	SELECT B.JNL_NO,B.JND_SEQNO,B.ACT_NO,B.JND_AMOUNT' + CR
			+' 		FROM TBL_ACNT_JOURNAL A' + CR
			+' 			INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
      +'    WHERE A.JNL_DATE >= ' +SqlDateTimeSQL(dtFrom) +CR
      +'      AND A.JNL_DATE < '  +SqlDateTimeSQL(dtEnd+1) +CR
			+' 	) A' + CR
			+' 	INNER JOIN TBL_ACNT_ACCOUNT C ON A.ACT_NO=C.ACT_NO' + CR
			+' 	INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO' + CR
			+' 	WHERE D.TYP_MAJOR_TYPE =''資產''' + CR
			+' 	GROUP BY D.TYP_MAJOR_TYPE,D.TYP_NO,D.TYP_NAME,SUBSTRING(C.ACT_NO,1,4),C.ACT_NAME' + CR
			+' 	HAVING SUM(A.JND_AMOUNT)<>0' + CR
			+' ) A' + CR
			+' ' + CR
			+' UNION' + CR
			+' ' + CR
			+' --======================== 負債 ==============================================' + CR
			+' SELECT  ''負債及業主權益'' GRP,A.TYP_MAJOR_TYPE,A.TYP_NO,TYP_NAME,A.ACT_NO,A.ACT_NAME,A.AMOUNT*-1' + CR
			+' 			,(A.AMOUNT/'+floattostr(sum_liability)+') * 100 RATE'
			+' FROM' + CR
			+' (	SELECT D.TYP_MAJOR_TYPE,D.TYP_NO,D.TYP_NAME,SUBSTRING(C.ACT_NO,1,4) ACT_NO,C.ACT_NAME' + CR
			+' 			,SUM(A.JND_AMOUNT) AMOUNT' + CR
			+' 	FROM' + CR
			+' 	(	SELECT B.JNL_NO,B.JND_SEQNO,B.ACT_NO,B.JND_AMOUNT' + CR
			+' 		FROM TBL_ACNT_JOURNAL A' + CR
			+' 			INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
      +'    WHERE A.JNL_DATE >= ' +SqlDateTimeSQL(dtFrom) +CR
      +'      AND A.JNL_DATE < '  +SqlDateTimeSQL(dtEnd+1) +CR
			+' 	) A' + CR
			+' 	INNER JOIN TBL_ACNT_ACCOUNT C ON A.ACT_NO=C.ACT_NO' + CR
			+' 	INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO' + CR
			+' 	WHERE D.TYP_MAJOR_TYPE =''負債''' + CR
			+' 	GROUP BY D.TYP_MAJOR_TYPE,D.TYP_NO,D.TYP_NAME,SUBSTRING(C.ACT_NO,1,4),C.ACT_NAME' + CR
			+' 	HAVING SUM(A.JND_AMOUNT)<>0' + CR
			+' ) A' + CR
			+' UNION' + CR
			+' --======================== 業主權益 ==============================================' + CR
			+' SELECT ''負債及業主權益'' GRP,A.TYP_MAJOR_TYPE,A.TYP_NO,TYP_NAME,A.ACT_NO,A.ACT_NAME,A.AMOUNT*-1' + CR
			+' 			,(A.AMOUNT/'+floattostr(sum_equity)+') * 100 RATE'
			+' FROM' + CR
			+' (	SELECT D.TYP_MAJOR_TYPE,D.TYP_NO,D.TYP_NAME,SUBSTRING(C.ACT_NO,1,4) ACT_NO,C.ACT_NAME' + CR
			+' 			,SUM(A.JND_AMOUNT) AMOUNT' + CR
			+' 	FROM' + CR
			+' 	(	SELECT B.JNL_NO,B.JND_SEQNO,B.ACT_NO,B.JND_AMOUNT' + CR
			+' 		FROM TBL_ACNT_JOURNAL A' + CR
			+' 			INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
      +'    WHERE A.JNL_DATE >= ' +SqlDateTimeSQL(dtFrom) +CR
      +'      AND A.JNL_DATE < '  +SqlDateTimeSQL(dtEnd+1) +CR
			+' 		UNION' + CR
			+' 		SELECT ''PROFIT'',-1,''3353'' ACT_NO' + CR
			+' 					,ISNULL(SUM(B.JND_AMOUNT),0)  AMOUNT' + CR
			+' 		FROM TBL_ACNT_JOURNAL A' + CR
			+' 			INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
			+' 			INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO' + CR
			+' 			INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO' + CR
      +'    WHERE A.JNL_DATE >= ' +SqlDateTimeSQL(dtFrom) +CR
      +'      AND A.JNL_DATE < '  +SqlDateTimeSQL(dtEnd+1) +CR
			+' 			AND D.TYP_MAJOR_TYPE NOT IN (''資產'',''負債'',''業主權益'')' + CR
			+' 	) A' + CR
			+' 	INNER JOIN TBL_ACNT_ACCOUNT C ON A.ACT_NO=C.ACT_NO' + CR
			+' 	INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO' + CR
			+' 	WHERE D.TYP_MAJOR_TYPE =''業主權益''' + CR
			+' 	GROUP BY D.TYP_MAJOR_TYPE,D.TYP_NO,D.TYP_NAME,SUBSTRING(C.ACT_NO,1,4),C.ACT_NAME' + CR
			+' 	HAVING SUM(A.JND_AMOUNT)<>0' + CR
			+' ) A' + CR
			+' ORDER BY TYP_NO,ACT_NO';

  debug ('','A');
  debug ('資產負債表','A');
  debug (sql,'A');
  qryReport.SQL.Text:=sql;

end;

procedure TFm_Acnt_Asset.Button1Click(Sender: TObject);
begin
  inherited;
  SetSQL;
  ppReport.Print;

end;

procedure TFm_Acnt_Asset.Button2Click(Sender: TObject);
begin
  inherited;
  Close;
end;

end.

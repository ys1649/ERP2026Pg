unit Form_AcntBalance;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, ppCtrls, ppPrnabl, ppClass, ppDB,DateUtils,
  ppBands, ppCache, ppDBPipe, ppComm, ppRelatv, ppProd, ppReport, ppVar,ppViewr,
  StdCtrls, Grids, DBGrids, ExtCtrls, wwdbdatetimepicker, dxCntner,
  dxEditor, dxExEdtr, dxEdLib,FORM_ERP_BASE,erp_public;

type
  TFm_AcntBalance = class(TForm_ERP)
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
    ppLblPeriod: TppLabel;
    ppLblCorName: TppLabel;
    ppDBText4: TppDBText;
    qry: TADOQuery;
    ppLabel6: TppLabel;
    ppLabel4: TppLabel;
    ppDBText5: TppDBText;
    ppDBText7: TppDBText;
    ppLabel10: TppLabel;
    Label1: TLabel;
    dt1: TwwDBDateTimePicker;
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    Image1: TImage;
    Label4: TLabel;
    ppLabel2: TppLabel;
    ppDBText1: TppDBText;
    procedure ppReportPreviewFormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    procedure setSQL;

    { Private declarations }
  public
    procedure init;override;
    { Public declarations }
  end;


implementation

uses Uty;

{$R *.dfm}



procedure TFm_AcntBalance.ppReportPreviewFormCreate(Sender: TObject);
begin
  ppreport.PreViewForm.WindowState := wsMaximized;
  TppViewer(ppReport.preViewForm.Viewer).ZoomSetting := zsPageWidth;

end;

procedure TFm_AcntBalance.init;
begin
  setAdoConnection(self,sysinfo.AdoConnection);
  dt1.Date:=strtodate(inttostr(sysinfo.spr_acnt_year)+'/12/31');

end;




procedure TFm_AcntBalance.setSQL;
var DateTo:tDate;
  sql:string;

begin

  DateTo:=dt1.Date;

  ppLblPeriod.Caption:=dt1.Text;
  ppLblCorName.Caption:=sysinfo.SPR_COR_NAME;

	sql:='SELECT D.TYP_MAJOR_TYPE,D.TYP_NO,D.TYP_NAME,B.ACT_NO,C.ACT_NAME' + CR
			+' 			,SUM(B.JND_AMOUNT) BALANCE' + CR
			+' FROM TBL_ACNT_JOURNAL A' + CR
			+' INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
			+' INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO' + CR
			+' INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO' + CR
			+' WHERE A.JNL_BILL_TYPE <> 2 ' + CR
			+' 	AND A.JNL_DATE < '+SqlDateTimeSQL(DateTo+1) +CR
			+' GROUP BY  D.TYP_MAJOR_TYPE,D.TYP_NO,D.TYP_NAME,B.ACT_NO,C.ACT_NAME' + CR
			+' ORDER BY D.TYP_NO,B.ACT_NO';


  debug (sql);
  qryReport.SQL.Text:=sql;
end;

procedure TFm_AcntBalance.Button1Click(Sender: TObject);
begin
  SetSQL;
  ppReport.Print;

end;

procedure TFm_AcntBalance.Button2Click(Sender: TObject);
begin
  inherited;
  close;
end;

end.

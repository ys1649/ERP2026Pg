unit Form_AcntDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Form_Query, DB, ADODB, ppCtrls, ppPrnabl, ppClass, ppDB,DateUtils,
  ppBands, ppCache, ppDBPipe, ppComm, ppRelatv, ppProd, ppReport, ppVar,ppViewr,
  StdCtrls, Grids, DBGrids, ExtCtrls, wwdbdatetimepicker, dxCntner,
  dxEditor, dxExEdtr, dxEdLib,FORM_ERP_BASE,Erp_Public;

type
  TFm_AcntDetail = class(TForm_ERP)
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
    procedure ppReportPreviewFormCreate(Sender: TObject);
  private
    sql_rpt:string;
    Fm_Qry:TFM_Query;
    procedure SetupQueryForm;
    procedure main;
    procedure setSQL;

    { Private declarations }
  public
    procedure init;override;
    { Public declarations }
  end;


implementation

uses Uty;

{$R *.dfm}



procedure TFm_AcntDetail.ppReportPreviewFormCreate(Sender: TObject);
begin
  ppreport.PreViewForm.WindowState := wsMaximized;
  TppViewer(ppReport.preViewForm.Viewer).ZoomSetting := zsPageWidth;

end;

procedure TFm_AcntDetail.init;
begin
  inherited;
  setAdoConnection(self,sysinfo.AdoConnection);
  sql_rpt:=qryReport.SQL.Text;
  SetupQueryForm;
  main;
  close;
end;


procedure TFm_AcntDetail.SetupQueryForm;
var fld:PQueryField;
    WhereList,OrderList:TList;
    s1,s2:string;
begin
  WhereList:=TList.Create;
  OrderList:=TList.Create;

  NewQueryFld(fld);
  fld.FieldName   :=  'JNL_DATE';
  fld.DispName    :='傳票日期';
  fld.TableAlias  :='A';
  fld.DataType    :=wdDate;
  fld.CtrlType    :=wcEdit;
  fld.QueryType   :=wqRange;
  WhereList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'ACT_NO';
  fld.DispName    :='科目編號';
  fld.TableAlias  :='A';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcSQL;
  fld.QueryType   :=wqRange;
  fld.ListSql:='SELECT ACT_NO,ACT_NAME FROM TBL_ACNT_ACCOUNT';
  FLD.ListReturnField:='ACT_NO';
  fld.ListFieldDisp:='科目編號,科目名稱';
  WhereList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'ACT_NO';
  fld.DispName    :='科目編號';
  fld.TableAlias  :='A';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcSQL;
  fld.QueryType   :=wqSingle;
  fld.ListSql:='SELECT ACT_NO,ACT_NAME FROM TBL_ACNT_ACCOUNT';
  FLD.ListReturnField:='ACT_NO';
  fld.ListFieldDisp:='科目編號,科目名稱';
  WhereList.Add(fld);

  NewQueryFld(fld);
  fld.FieldName   :=  'ACT_NO';
  fld.DispName    :='科目編號';
  fld.TableAlias  :='A';
  fld.DataType    :=wdString;
  fld.CtrlType    :=wcSQL;
  fld.QueryType   :=wqMultiSelect;
  fld.ListSql:='SELECT ACT_NO,ACT_NAME FROM TBL_ACNT_ACCOUNT';
  FLD.ListReturnField:='ACT_NO';
  fld.ListFieldDisp:='科目編號,科目名稱';
  WhereList.Add(fld);


  Fm_Qry:=TFM_Query.Create(self);
  fm_qry.Init(sysinfo.AdoConnection,'','',WhereList,OrderList,query,dbsType);
  fm_qry.BtnPreview.Visible:=true;
  fm_qry.Caption:='明細分類帳';
  fm_qry.GrpTitle.Visible:=true;
  fm_qry.Edit1.Text:='明細分類帳--程式報表';
  fm_qry.Edit2.Text:='明細分類帳';
  fm_qry.BtnOk.Visible:=false;
  fm_qry.BtnCancel.Caption:='離開';

  s1:=inttostr(sysinfo.spr_acnt_year)+'/01/01';
  s2:=inttostr(sysinfo.spr_acnt_year)+'/12/31';
  fm_qry.SetCtrlText(0,s1,s2);

end;

procedure TFm_AcntDetail.main;
var n:integer;
begin
  while true do begin
    n:=Fm_Qry.ShowModal;
    if n=mrCancel then break;
    SetSQL;
    ppReport.Print;
  end;

end;

procedure TFm_AcntDetail.setSQL;
var dtFrom,dtTo:tDate;
  dateFrom,DateTo:string;
  ActNoFrom,ActNoTo:string;
  ActNoLike:string;
  ActNoIn:string;
  sql:string;
  sqlWhere:string;
  WhereListIndex:integer;
  i:integer;
  const sqlOrder=' ORDER BY A.ACT_NO,JNL_DATE,JNL_NO,JND_SEQNO';


begin
  dateFrom    :=Fm_Qry.CtrlTextList.Strings[0];
  dateTo      :=Fm_Qry.CtrlTextList.Strings[1];
  ActNoFrom   :=Fm_Qry.CtrlTextList.Strings[2];
  ActNoTo     :=Fm_Qry.CtrlTextList.Strings[3];
  ActNoLike   :=Fm_Qry.CtrlTextList.Strings[4];
  ActNoIn     :=Fm_Qry.CtrlTextList.Strings[5];
  if dateFrom='' then begin
    dateFrom:='1980/01/01';
    dateTo:='2099/12/31';
    WhereListIndex:=0;
  end else begin
    WhereListIndex:=1;
  end;
  sqlWhere:='';
  for i:=WhereListIndex to fm_qry.sqlWhereList.Count-1 do begin
    sqlWhere:=sqlWhere+' AND '+fm_qry.sqlWhereList.Strings[i] +CR;
  end;
  sqlWhere:=strMid(sqlWhere,6);
  dtFrom:=strtodate(DateFrom);
  dtTo:=strtodate(DateTo)+1;


  ppLblPeriod.Caption:=dateFrom+ ' ~ '+ dateTo;
  ppLblCorName.Caption:=sysinfo.SPR_COR_NAME;
  dateFrom:=SqlDateTimeSQL(dtFrom);
  dateTo:=SqlDateTimeSQL(dtTo);



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
      +' 	WHERE A.JNL_DATE >= '+SqlDateTimeSQL(dtFrom) +CR
      +' 		AND A.JNL_DATE < ' +SqlDateTimeSQL(dtTo) +CR
      +'    AND A.jnl_bill_type <>2'
      +' 	UNION' + CR
      +' 	SELECT '+SqlDateTimeSQL(dtFrom)+' JNL_DATE' + CR
      +' 				,''@@INIT'' JNL_NO' + CR
      +' 				,0 JND_SEQNO' + CR
      +' 				,ACT_NO' + CR
      +' 				,''期初金額'' JND_DESC' + CR
      +' 				,SUM(AMOUNT) AMOUNT' + CR
      +' 	FROM' + CR
      +' 	(	SELECT A.JNL_NO,B.JND_SEQNO,B.ACT_NO,B.JND_AMOUNT AMOUNT' + CR
      +' 		FROM TBL_ACNT_JOURNAL A' + CR
      +' 		INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
      +' 		WHERE A.JNL_DATE < '+SqlDateTimeSQL(dtFrom) +CR
      +'    AND A.jnl_bill_type <>2'
      +' 	) A' + CR
      +' 	GROUP BY A.ACT_NO' + CR
      +' ) A INNER JOIN TBL_ACNT_ACCOUNT B ON A.ACT_NO=B.ACT_NO' + CR;

  if sqlWhere <> '' then
    sql:=sql+' WHERE '+sqlWhere;
  sql:=sql+sqlOrder;


  debug (sql);
  qryReport.SQL.Text:=sql;
end;

end.

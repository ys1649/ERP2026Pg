unit form_SysReportQuery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, ppProd, ppClass, ppReport, ppComm, ppRelatv, ppDB,ppCtrls,
  ppTypes,ppDBPipe, ppEndUsr, ppBands, ppCache,DBTables, ExtCtrls, ppViewr,
  SysReport_Head, TXComp, Menus, myChkBox, ppBarCod, ppPrnabl, ppChrt,
  ppChrtDP,Uty;

const RpKeyWord = '~COND'; //報表 Label 查詢條件識別文字
type
  Tfm_SysReportQuery = class(TForm)
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
    procedure ppReportPreviewFormCreate(Sender: TObject);
  private
    procedure ShowSysReport(Adodc: TAdoConnection; RptCode, sqlWhere,
      SQLOrder: string; PrintMode: TModalResult; QryList, SortList: TList);
    function IsNumeric(Value: string): boolean;
    procedure SetRpCondText(qryList:TList);
  public
    { Public declarations }
  end;


procedure ShowSysReportQuery(adodc:TAdoConnection;RptCode:string;dbsType:TDatabaseType);stdcall;export;
procedure PrintFormReport(adodc:TAdoConnection;RptCode,sqlWhere,SQLOrder: string; PrintMode: TModalResult);

implementation

uses Form_Query, SysReportUnit;

{$R *.dfm}
procedure PrintFormReport(adodc:TAdoConnection;RptCode,sqlWhere,SQLOrder: string; PrintMode: TModalResult);
var fm:Tfm_SysReportQuery;
begin
  fm:=Tfm_SysReportQuery.Create(APPLICATION);
  try
    fm.ShowSysReport(adodc,RptCode,sqlWhere,SQLOrder,PrintMode,nil,nil);
  finally
    fm.Free;
  end;

end;

procedure ShowSysReportQuery(adodc:TAdoConnection;RptCode:string;dbsType:TDatabaseType);
var qry:TAdoQuery;
    SRP_ID:INTEGER;
    Fld:PQueryField;
    title1,title2:string;
    sqlWhere,SQLOrder:string;
    QueryFieldList:TList;
    OrderFieldList:TList;
    fm:Tfm_SysReportQuery;
    fm_Qry:TFM_Query;
    FormResult:TModalResult;
    stmp:string;
begin
  QueryFieldList:=TList.Create;
  OrderFieldList:=TList.Create;

  qry:=TAdoQuery.Create(application);
  try
    qry.Connection:=adodc;
    qry.SQL.Text:='SELECT SRP_ID,SRP_CODE,SRP_NAME FROM TBLSYSREPORT WHERE SRP_CODE='+SqlStr(uppercase(RptCode));
    qry.Open;
    IF qry.eof then ErrMsg('報表代碼找不到 ! 報表代碼='+RptCode,user);

    title1:=qry.fieldbyname('SRP_CODE').AsString;
    title2:=qry.fieldbyname('SRP_NAME').AsString;
    SRP_ID:=qry.fieldbyname('SRP_ID').VALUE;
    qry.close;

//================================================================================================================================
//    由TBLSYSREPORTFIELD(報表查詢欄位)建立 QueryFieldList 及 OrderFieldList
//================================================================================================================================
    qry.SQL.Text:='SELECT * FROM TBLSYSREPORTFIELD WHERE SRP_ID='+inttostr(srp_id)
                 +' ORDER BY SRF_DISPORDER';
    qry.Open;
    while not qry.Eof do
    begin
      new(fld);
      fld.FieldName      :=qry.fieldbyname('SRF_FIELDNAME').AsString;
      fld.DispName       :=qry.fieldbyname('SRF_DISPNAME').AsString;
      fld.TableAlias     :=qry.fieldbyname('SRF_TABLEALIAS').AsString;
      stmp:=qry.fieldbyname('SRF_DATATYPE').AsString;
      if stmp='String' then
        fld.DataType  :=wdString
      else if stmp='Numberic' then
        fld.DataType  :=wdNumberic
      else if sTmp='Date' then
        fld.DataType  :=wdDate
      else
        ErrMsg('查詢欄位 [資料型態] 定義錯誤 !! [資料型態]='+sTmp,USER);


      sTmp:=qry.fieldbyname('SRF_CONTROLTYPE').AsString;
      if sTmp='Edit' then
        fld.CtrlType:=wcEdit
      else if sTmp='Date' then
        fld.CtrlType:=wcDate
      else if sTmp='ListItem' then
        fld.CtrlType:=wcListItem
      else if sTmp='SQL' then
        fld.CtrlType:=wcSQL
      else
        ErrMsg('查詢欄位 [控制項類別] 定義錯誤 !! [控制項類別]='+sTmp,USER);

      sTmp:=qry.fieldbyname('SRF_QUERYTYPE').AsString;
      if sTmp='Single' then
        fld.QueryType:=wqSingle
      else if sTmp='Range' then
        fld.QueryType:=wqRange
      else if sTmp='MultiSelect' then
        fld.QueryType:=wqMultiSelect
      else
        ErrMsg('查詢欄位 [查詢型態] 定義錯誤 !! [查詢型態]='+sTmp,USER);



      fld.IsMustCriteria :=qry.fieldbyname('SRF_ISMUSTCRITERIA').Value;

      fld.ListValue      :=qry.fieldbyname('SRF_LIST_VALUE').AsString;
      fld.ListSql        :=qry.fieldbyname('SRF_LIST_SQL').AsString;
      fld.ListReturnField:=qry.fieldbyname('SRF_LIST_RETURNFIELD').AsString;
      fld.ListFieldDisp  :=qry.fieldbyname('SRF_LIST_FIELDDISP').AsString;
      FLD.SortDec        :=qry.fieldbyname('SRF_SORTDEC').AsBoolean;
      if qry.fieldbyname('SRF_ISWHERE').Value then QueryFieldList.add(fld);
      if qry.fieldbyname('SRF_ISSORT').Value  then OrderFieldList.add(fld);
      qry.Next;
    end;
  finally
    qry.Close;
    qry.Free;
  end;


//================================================================================================================================
//    啟動查詢畫面 取得 SQLWher 及 SQLOrder 字串
//================================================================================================================================
    fm_Qry:=TFM_Query.Create(application);
    try
      fm_qry.Init(adodc,title1,title2,QueryFieldList,OrderFieldList,Report,dbsType);
      REPEAT
        FormResult:=fm_qry.ShowModal;
        if FormResult=mrCancel then
          exit;
        sqlWhere:=Fm_qry.sqlWhere;      //取得 SQLWher  字串
        SQLOrder:=fm_qry.sqlOrder;      //取得 SQLOrder 字串
        fm:=Tfm_SysReportQuery.Create(application);
        try
          fm.ShowSysReport(adodc,RptCode,sqlWhere,SQLOrder,FormResult,QueryFieldList,OrderFieldList);
        finally
          fm.Free;
        end;
      UNTIL false;
    finally
      ReleaseQryList(QueryFieldList,OrderFieldList);
      fm_qry.Free;
    end;

end;




{ Tfm_SysReportQuery }

procedure Tfm_SysReportQuery.ShowSysReport(Adodc: TAdoConnection; RptCode,sqlWhere,
  SQLOrder: string;PrintMode:TModalResult;QryList,SortList:TList);
var stream:TMemoryStream;
    sql,MainWhere,group,MainOrder:string;
    qry:TAdoQuery;

begin

//==========================================================================
//  qryTemplate 只是為了讓報表可以 show 出 報表id 及 報表名稱
//  plTemplate 名字不可隨意改變 ,需跟 Form_SysReportDEF(報表設計)plTemplate名字一樣
//==========================================================================
  qryTemplate.close;
  qryTemplate.Connection:=adodc;
  qryTemplate.SQL.Text:='SELECT * FROM TBLSYSREPORT WHERE SRP_CODE='+SqlStr(RptCode);
  qryTemplate.open;


  qry:=TAdoQuery.Create(self);
  qry.Connection:=adodc;
  qry.SQL.Text:='SELECT * FROM TBLSYSREPORT WHERE SRP_CODE='+SqlStr(RptCode);
  qry.Open;
  sql:=trim(qry.fieldbyname('SRP_SELECT').AsString);
  MainWhere:=trim(qry.fieldbyname('SRP_WHERE').AsString);
  group:=trim(qry.fieldbyname('SRP_GROUPBY').AsString);
  MainOrder:=trim(qry.fieldbyname('SRP_ORDERBY').AsString);
  MainWhere :=JoinWhere(MainWhere,SqlWhere);
  MainOrder :=JoinOrder(MainOrder,SQLOrder);

  Stream:=TMemoryStream.Create;
  try
    (qry.FieldByName('SRP_REPORTFILE') as TBlobField).SaveToStream(stream);
    ppReport.Template.LoadFromStream(stream);
    SetRpCondText(QryList);
  finally
    qryTemplate.Close;
    qry.Close;
    qry.free;
    stream.Free;
  end;
  QryReportData.close;
  QryReportData.Connection:=adodc;
  sql:=RunMultiSQL(adodc,sql);
  QryReportData.SQL.Text:=sql+CR+MainWhere+CR+group+CR+MainOrder;
  debug (QryReportData.SQL.Text);
  QryReportData.Open;
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
    QryReportData.Close;
  end;

end;





procedure Tfm_SysReportQuery.SetRpCondText(qryList:TList);
var i: integer;
    ppLabel: TppLabel;
    s, s1: string;
    n:integer;
    CondText:array [0..100] of string;
    fld:PQueryField;
begin

//==============================================================
//    將有使用到的查詢條件 依序存入CondText[]
//==============================================================
    if qryList=nil then exit;
    n:=0;
    for i:=0 to QryList.Count-1 do
    begin
      fld:=QryList.Items[i];
      if fld.IsUsed then
      begin
        CondText[n]:=fld.DispName+': '+fld.WhereText;
        inc(n);
      end;
    end;


    for i:= 0 to componentcount -1 do
    begin
      if components[i] is TppLabel then
      begin
        ppLabel := components[i] as TppLabel;
        s := Uppercase(trim(ppLabel.Caption));
        s1:= Copy(s, (Length(RpKeyWord)+1), (Length(s)-Length(RpKeyWord)));
        if (copy(s, 1, length(RpKeyWord)) = RpKeyWord) and IsNumeric(s1) then
        begin
          ppLabel.Caption:='';
          n:=strtoint(s1);
          if n<=QryList.Count then
            ppLabel.Caption:=PQueryField(qryList.Items[n-1]).WhereText;
        end;

      end;
    end;
end;


function Tfm_SysReportQuery.IsNumeric(Value: string): boolean;
var
  i: integer;
begin
  Result := True;
  if Length(Value) = 0 then
  begin
    Result := False;
    Exit;
  end;
  for i := 1 to Length(Value) do
  begin
    if (Ord(Value[i]) < 48) or (Ord(Value[i]) > 57) then
    begin
      Result := False;
      Exit;
    end;
  end;
end;




procedure Tfm_SysReportQuery.ppReportPreviewFormCreate(Sender: TObject);
begin
  ppreport.PreViewForm.WindowState := wsMaximized;
  TppViewer(ppReport.preViewForm.Viewer).ZoomSetting := zsPageWidth;
end;


end.

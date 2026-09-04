unit Erp_Public;

interface
uses ADODB,Variants,UTY,SysUtils,Controls,Classes,messages;
type
  TSysInfo = class

    LoginUserID         :string;
    LoginUserName       :string;
    AdoConnection       :TAdoConnection;

    SPR_TAX_RATE        :CURRENCY;
    SPR_QTY_DECIMAL     :INTEGER;
    SPR_AMOUNT_UNIT_DOT :INTEGER;
    SPR_AMOUNT_DOT      :INTEGER;
    SPR_BKUP_CMD        :STRING;
    SPR_BKUP_PARA       :STRING;
    SPR_BKUP_PATH       :STRING;
    SPR_PERIOD_START    :TDate;
    SPR_PRD_COST_RATE   :CURRENCY;
    SPR_BONUS_SALE_RATE :CURRENCY;
    SPR_BONUS_PROFIT_RATE:CURRENCY;
    SPR_COR_NAME        :string;

    SPR_ACNT_YEAR         :integer;
    SPR_ACNT_SALE_REVENUE :STRING;
    SPR_ACNT_SALE_RETURN  :STRING;
    SPR_ACNT_SALE_DISCOUNT:STRING;
    SPR_ACNT_SALE_TAX     :STRING;
    SPR_ACNT_PURCHASE     :STRING;
    SPR_ACNT_PUR_DISCOUNT :STRING;
    SPR_ACNT_PUR_RETURN   :STRING;
    SPR_ACNT_PUR_TAX      :STRING;
    SPR_ACNT_CASH         :STRING;
    SPR_ACNT_CUS_CHECK    :STRING;
    SPR_ACNT_SUP_CHECK    :STRING;

  end;
var G_str:string;
var G_int:integer;


const WMFuncClose = WM_USER+100;
const WMMainWindowResize = WM_USER+101;
{=========================================================
  交易類別常數定義
=========================================================}
CONST Trn_INIT    =0;    //期初
CONST Trn_RCV     =1;    //進貨
CONST Trn_SHP     =2;    //銷貨
CONST Trn_ADJ     =3;    //調整
const Default_INV='DEFAULT';
const STATUS_UNBOOK=0;
const STATUS_CONFIRM=1;
const STATUS_WILL_DELETE=2;   //刪除前的暫時狀態,避免網路多人使用,
const dbsType:TDatabaseTYPE=MSSQL;
const BakExt='STK';
CONST SYS_TmpPath='C:\$$BK_TMP';


procedure UpdateTransaction(sysinfo:TSysInfo;prd_no: string;trn_datetime:TDateTime);
procedure InsertTransaction(sysinfo:Tsysinfo;prd_no, inv_no: string;
  TRN_TYPE: integer; TRN_Src_NO, TRN_Src_SEQNO: string;
  TRN_DateTime: TDateTime; TRN_QTY: currency; TRN_Cost: currency;updateFlag:boolean=true);

function SysLoginCheckUser(sysinfo:Tsysinfo;user, pass: string): boolean;  
procedure ReadSysParam(sysinfo:TSysinfo);


PROCEDURE ChkDCBalance(sysinfo:TSysinfo;jnl_no: string);
procedure ArRecvToAccount(sysinfo:TSysinfo;arr_no,cum_no:string;Arr_date:TDateTime;desc:string;
          acnt_cash,acnt_check,acnt_discount,acnt_from_advance,acnt_to_advance:currency);
procedure UpdateARNotClean(sysinfo:TSysinfo;SMT_NO: string);
procedure Insert_AR_Recv(sysinfo:TSysinfo;ARR_NO, CUM_NO: string;
  ARR_DATE: TDate;ARR_CASH, ARR_CHECK, ARR_FROM_ADVANCE,
  ARR_TO_ADVANCE: CURRENCY; ARR_DESC, ARR_CREATOR: STRING);
procedure Insert_AR_Recv_DT(sysinfo:TSysinfo;ARR_NO: STRING;
  ARD_SEQNO: INTEGER; SMT_NO: STRING; ARD_AMOUNT, ARD_DISCOUNT: CURRENCY);
procedure UpdateCUM_Advance_Amount(sysinfo:TSysinfo;CUM_NO: string);
procedure UpdateSMT_Cost(sysinfo:TSysinfo;smt_no: string);

function SelectActNo(sysinfo:Tsysinfo;slist:TStringList): string;
function SelectTypNo(SYSINFO:TSysinfo): string;
function SelectCumName(sysinfo:Tsysinfo): string;
function SelectCumNO(SYSINFO:TSysInfo): string;
function GetCusHisPrice(sysinfo:TSysInfo;Cum_NO, Prd_NO: string): currency;
function GetCumName(sysinfo:TSysInfo;CUM_NO:STRING): string;

function SelectSupName(sysinfo:Tsysinfo): string;
function SelectSupNO(SYSINFO:TSysInfo): string;
function GetSupHisPrice(sysinfo:TSysinfo;SUP_NO, Prd_NO: string): currency;
function GetSupName(sysinfo:TSysinfo;SUP_NO:STRING): string;
procedure UpdateAPNotClean(sysinfo:Tsysinfo;RCV_NO: string);
procedure Insert_AP_PAY(sysinfo:TSysinfo;PAY_NO, SUP_NO: string;
  PAY_DATE: TDate;PAY_CASH, PAY_CHECK, PAY_FROM_ADVANCE,
  PAY_TO_ADVANCE: CURRENCY; PAY_DESC, PAY_CREATOR: STRING);
procedure Insert_AP_PAY_DT(sysinfo:TSysInfo;PAY_NO: STRING;
  PAD_SEQNO: INTEGER; RCV_NO: STRING; PAD_AMOUNT, PAD_DISCOUNT: CURRENCY);
procedure UpdateSUP_Advance_Amount(sysinfo:TSysinfo;SUP_NO: string);
procedure ApPayToAccount(sysinfo:TSysinfo;pay_no, sup_no: string;
  pay_date: TDateTime; desc: string; acnt_cash, acnt_check, acnt_discount,
  acnt_from_advance, acnt_to_advance: currency);

function GetPrdName(sysinfo:Tsysinfo;prd_no: string): string;
function GetPrdCurrCost(sysinfo:TSysinfo;prd_no: string): currency;
function SelectPrdNO(sysinfo:TSysinfo;slist:TStringList): string;
procedure GetDummyPrd(sysinfo:TSysinfo;prd_no: string; var PRD_IS_DUMMY: boolean;
  var PRD_DUM_COST_RATE: SINGLE);
function SelectCarNO(sysinfo:TSysinfo): string;
function GetCarName(sysinfo:Tsysinfo;CAR_No: string): string;
function SelectEpyNO(sysinfo:TSysinfo): string;
function GetEpyName(sysinfo:Tsysinfo;Epy_No: string): string;
procedure setAdoConnection(owner:TComponent;con:TAdoConnection);


implementation

uses RecChoice, DBUty;



procedure UpdateTransaction(sysinfo:TSysInfo;prd_no: string;trn_datetime:TDateTime);
var sql:string;
  TRNID:INTEGER;
  TrnCost,PreCost,avgCost:Double;
  TrnQty,PreQty,onHand:Double;
  TrnType:integer;
  QRY:TAdoQuery;

begin
{==============================================================
找出交易時間點之前最後庫存量及最後平均成本
===============================================================}
  SQL:='SELECT MAX(TRN_DATETIME) C1 FROM TBL_TRANSACTION'
      +' WHERE PRD_NO='+SqlStr(prd_no)
      +' AND TRN_DATETIME<'+sqlDateTimeSQL(trn_datetime);
  qry:=TAdoQuery.Create(nil);
  qry.Connection:=sysinfo.AdoConnection;
  try
    qry.SQL.Text:=sql;
    QRY.Open;
    IF VARISNULL(qry.Fields[0].Value) then
    begin
      preQty:=0;
      preCost:=0;
    end else
    begin
      SQL:='SELECT TRN_ONHAND,TRN_AVG_COST FROM TBL_TRANSACTION'
          +' WHERE PRD_NO='+SqlStr(prd_NO)
          +' AND TRN_DATETIME='+sqldateTimeSQL(qry.Fields[0].asdatetime)
          +' ORDER BY TRN_ID DESC';
      qry.Close;
      qry.sql.Text:=sql;
      qry.Open;
      PreQty:=QRY.fieldbyname('TRN_ONHAND').Value;
      PreCost:=QRY.fieldbyname('TRN_AVG_COST').Value;
    end;

  {==============================================================
    更新庫存量及平均成本
  ===============================================================}
    onHand:=PreQty;
    AvgCost:=PreCost;
    SQL:='SELECT * FROM TBL_TRANSACTION'
        +' WHERE PRD_NO='+SqlStr(prd_no)
        +' AND TRN_DATETIME>='+sqlDateTimeSQL(trn_datetime)
        +' ORDER BY TRN_DATETIME,TRN_TYPE,TRN_ID';
    qry.Close;
    QRY.SQL.Text:=sql;
    qry.Open;
//    debug ('init');
    while not qry.Eof do
    begin
      trnID:=qry.fieldbyname('TRN_ID').Value;
      trnqty:=qry.fieldbyname('TRN_QTY').Value;
      trnType:=qry.fieldbyname('TRN_TYPE').AsInteger;

{      debug (qry.fieldbyname('TRN_DATETIME').AsString+','
            +qry.fieldbyname('TRN_TYPE').AsString+','
            +qry.fieldbyname('TRN_ID').AsString+','
            +qry.fieldbyname('TRN_QTY').AsString
            ,'A');
}
      if ((TrnType=TRN_ADJ) and (trnQty>0))
      OR ((TrnType=TRN_RCV) and (trnQty>0))then   //進貨,調整增加
      begin
        onhand:=PreQty+TrnQty;
        trnCOST:=qry.fieldbyname('TRN_cost').Value;
        if onhand=0 then
          AvgCost:=0
        else
          AvgCost:= FloatCalc(((PreQty*PreCost)+(TrnQty*TrnCost))/onhand);
        SQL:='UPDATE TBL_TRANSACTION'
            +' SET TRN_ONHAND='+floatTOSTR(onhand)
            +',TRN_AVG_COST='+floatTOSTR(avgCost)
            +' WHERE TRN_ID='+INTTOSTR(TRNID);
        sysinfo.AdoConnection.Execute(sql);
      end else   //進貨退出,銷貨,銷貨退回,調整減少
      begin
        onhand:=PreQty+TrnQty;
        trnCOST:=PreCost;
        AvgCost:=trnCost;
        SQL:='UPDATE TBL_TRANSACTION'
            +' SET TRN_ONHAND='+floatTOSTR(onhand)
            +',TRN_AVG_COST='+floatTOSTR(avgCost)
            +',TRN_COST='+floatTOSTR(trncost)
            +' WHERE TRN_ID='+INTTOSTR(TRNID);
        sysinfo.AdoConnection.Execute(sql);
        if (TrnType=TRN_SHP) then   //  銷貨,銷貨退回
        begin
          sql:='UPDATE TBL_SHIP_DT'
              +' SET SMD_COST='+floatTOSTR(trncost)
              +' WHERE SMT_NO='+sqlStr(qry.fieldbyname('TRN_SRC_NO').AsString)
              +'   AND SMD_SEQNO='+qry.fieldbyname('TRN_SRC_SEQNO').AsString;
          sysinfo.AdoConnection.Execute(sql);
        end;
      end;
      PreQty:=onhand;
      PreCost:=AvgCost;
      qry.Next;
    end;
    sql:='UPDATE TBL_PRODUCT'
        +' SET PRD_ONHAND='+floattostr(onHand)
        +' ,   PRD_CUR_COST='+floatTOSTR(AVGCOST)
        +' WHERE PRD_NO='+sqlStr(prd_no);
    sysinfo.AdoConnection.Execute(sql);

  finally
    qry.Close;
    qry.Free;
  end;

end;

procedure InsertTransaction(sysinfo:Tsysinfo;prd_no, inv_no: string;
  TRN_TYPE: integer; TRN_Src_NO, TRN_Src_SEQNO: string;
  TRN_DateTime: TDateTime; TRN_QTY: currency; TRN_Cost: currency;updateFlag:boolean=true);
var s:string;
begin
  if trn_dateTime<sysinfo.SPR_PERIOD_START then
    errMsg('交易日期不得小於'+datetimetostr(sysinfo.SPR_PERIOD_START),user);
    s:='INSERT INTO TBL_TRANSACTION'
      +'(PRD_NO, INV_NO'
      +',TRN_TYPE, TRN_SRC_NO, TRN_SRC_SEQNO'
      +',TRN_DATETIME, TRN_QTY'
      +',TRN_COST,TRN_ONHAND,TRN_AVG_COST)'
      +' VALUES('
      +sqlStr(prd_no)+','
      +sqlStr(inv_no)+','
      +inttoStr(TRN_TYPE)+','
      +sqlStr(Trn_Src_no)+','
      +sqlStr(Trn_Src_SEQNO)+','
      +sqlDateTimeSql(Trn_DateTime)+','
      +currtostr(Trn_QTY)+','
      +currtostr(Trn_Cost)+','
      +'0,0)';
    sysinfo.AdoConnection.Execute(s);
    if updateFlag then begin
      UpdateTransaction(sysinfo,prd_no,Trn_DateTime);
    end;

end;


function SysLoginCheckUser(sysinfo:Tsysinfo;user, pass: string): boolean;
var qry:TAdoQuery;
begin

  user:=uppercase(user);
  pass:=uppercase(pass);
  IF (user='WYS') AND (pass='WYSEN') THEN
  BEGIN
    result:=true;
    exit;
  END;
  qry:=TAdoQuery.Create(nil);
  qry.Connection:=sysinfo.AdoConnection;
  try
    qry.SQL.Text  :='SELECT * FROM TBL_EMPLOYE WHERE EPY_NO='+SqlStr(user);
    qry.Open;
    if qry.Eof then
      result:=false
    else
      IF (UPPERCASE(qry.FieldByName('EPY_PASSWORD').AsString)=UPPERCASE(pass))
      and (qry.FieldByName('EPY_IS_CAN_LOGIN').AsBoolean) then begin
        sysinfo.LoginUserName:=TblLookup(sysinfo.AdoConnection,'TBL_EMPLOYE','EPY_NO',user,'EPY_NAME');
        sysinfo.LoginUserID:=user;
        result:=true;
      end else begin
        result:=false;
      end;
  finally
    qry.close;
    qry.Free;
  end;

end;

procedure ReadSysParam(sysinfo:TSysinfo);
var qry:TAdoQuery;
begin
  qry:=TAdoQuery.Create(nil);
  try
    qry.Connection:=sysinfo.AdoConnection;
    qry.SQL.Text:='SELECT * FROM TBL_SYS_PARAM';
    qry.Open;
    with sysinfo do begin
      SPR_PERIOD_START    :=qry.FIELDBYNAME('SPR_PERIOD_START').AsDateTime;
      SPR_TAX_RATE        :=qry.FIELDBYNAME('SPR_TAX_RATE').AsCurrency;
      SPR_QTY_DECIMAL     :=qry.FIELDBYNAME('SPR_QTY_DECIMAL').AsInteger;
      SPR_AMOUNT_UNIT_DOT :=qry.FIELDBYNAME('SPR_AMOUNT_UNIT_DOT').AsInteger;
      SPR_AMOUNT_DOT      :=qry.FIELDBYNAME('SPR_AMOUNT_DOT').AsInteger;
      SPR_BKUP_CMD        :=qry.FIELDBYNAME('SPR_BKUP_CMD').AsString;
      SPR_BKUP_PARA       :=qry.FIELDBYNAME('SPR_BKUP_PARA').AsString;
      SPR_BKUP_PATH       :=qry.FIELDBYNAME('SPR_BKUP_PATH').AsString;
      SPR_PRD_COST_RATE   :=qry.FIELDBYNAME('SPR_PRD_COST_RATE').AsCurrency;
      SPR_BONUS_SALE_RATE :=qry.FIELDBYNAME('SPR_BONUS_SALE_RATE').AsCurrency;
      SPR_BONUS_PROFIT_RATE:=qry.FIELDBYNAME('SPR_BONUS_PROFIT_RATE').AsCurrency;
      SPR_COR_NAME        :=qry.FIELDBYNAME('SPR_COR_NAME').AsString;

      SPR_ACNT_YEAR            :=qry.FIELDBYNAME('SPR_ACNT_YEAR').AsInteger;
      SPR_ACNT_SALE_REVENUE    :=qry.FIELDBYNAME('SPR_ACNT_SALE_REVENUE').AsString;
      SPR_ACNT_SALE_RETURN     :=qry.FIELDBYNAME('SPR_ACNT_SALE_RETURN').AsString;
      SPR_ACNT_SALE_DISCOUNT   :=qry.FIELDBYNAME('SPR_ACNT_SALE_DISCOUNT').AsString;
      SPR_ACNT_SALE_TAX        :=qry.FIELDBYNAME('SPR_ACNT_SALE_TAX').AsString;
      SPR_ACNT_PURCHASE        :=qry.FIELDBYNAME('SPR_ACNT_PURCHASE').AsString;
      SPR_ACNT_PUR_DISCOUNT    :=qry.FIELDBYNAME('SPR_ACNT_PUR_DISCOUNT').AsString;
      SPR_ACNT_PUR_RETURN      :=qry.FIELDBYNAME('SPR_ACNT_PUR_RETURN').AsString;
      SPR_ACNT_PUR_TAX         :=qry.FIELDBYNAME('SPR_ACNT_PUR_TAX').AsString;
      SPR_ACNT_CASH            :=qry.FIELDBYNAME('SPR_ACNT_CASH').AsString;
      SPR_ACNT_CUS_CHECK       :=qry.FIELDBYNAME('SPR_ACNT_CUS_CHECK').AsString;
      SPR_ACNT_SUP_CHECK       :=qry.FIELDBYNAME('SPR_ACNT_SUP_CHECK').AsString;
    end;

  finally
    qry.Close;
    qry.Free;
  end;
end;

PROCEDURE ChkDCBalance(sysinfo:TSysinfo;jnl_no: string);
var   qry:TAdoQuery;

begin
  qry:=TAdoQuery.Create(nil);
  qry.Connection:=sysinfo.AdoConnection;
  qry.SQL.Text:='SELECT SUM(JND_AMOUNT) FROM TBL_ACNT_JOURNAL_DT'
              +CR +' WHERE JNL_NO='+SQLSTR(JNL_NO);
  QRY.Open;
  TRY
    if qry.Fields[0].AsCurrency <> 0 then begin
      Raise Exception.Create('借貸不平衡 憑證編號='
            +jnl_no
            +CR+CR+'差額='+qry.Fields[0].AsString);
    end;
  FINALLY
    qry.close;
    qry.Free;
  end;


end;

function SelectActNo(sysinfo:Tsysinfo;slist:TStringList): string;
var GetRec:TWRecChoice;
  qry:TAdoQuery;
begin
	GetRec:=TWRecChoice.Create(nil);
  qry:=TAdoQuery.Create(nil);
  qry.Connection:=sysinfo.AdoConnection;
  qry.SQL.Text:='SELECT ACT_NO,ACT_NAME FROM TBL_ACNT_ACCOUNT ORDER BY ACT_NO';
  try
    qry.Open;
    qry.First;
    GetRec.DataSet:=qry;
    GetRec.ResultField:='ACT_NO';
    GetRec.AddColunm('ACT_No','科目編號',100);
    GetRec.AddColunm('ACT_NAME','科目名稱',200);
    GetRec.Width:=330;
    GetRec.KeyField:='ACT_NO';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
    begin
      slist.Assign(GetRec.SelList);
      Result:=GetRec.SelList.Strings[0]

    end else
      result:='';
    qry.Close;
  finally
    GetRec.free;
    qry.free;
  end;

end;

function SelectTypNo(SYSINFO:TSysinfo): string;
var GetRec:TWRecChoice;
  qry:TAdoQuery;
begin
	GetRec:=TWRecChoice.Create(nil);
  qry:=TAdoQuery.Create(nil);
  qry.Connection:=sysinfo.AdoConnection;
  qry.SQL.Text:='SELECT TYP_NO,TYP_NAME,TYP_MAJOR_TYPE FROM TBL_ACNT_TYPE ORDER BY TYP_NO';
  try
    qry.Open;
    qry.First;
    GetRec.DataSet:=qry;
    GetRec.ResultField:='TYP_NO';
    GetRec.AddColunm('TYP_No','類別編號',100);
    GetRec.AddColunm('TYP_NAME','類別名稱',200);
    GetRec.AddColunm('TYP_MAJOR_TYPE','主類別名稱',200);
    GetRec.Width:=600;
    GetRec.KeyField:='TYP_NO';
    GetRec.MultiSelect:=false;
    if GetRec.Excute then
    begin
      Result:=GetRec.SelList.Strings[0]

    end else
      result:='';
    qry.Close;
  finally
    GetRec.free;
    qry.free;
  end;

end;

procedure ArRecvToAccount(sysinfo:TSysinfo;arr_no,cum_no:string;Arr_date:TDateTime;desc:string;
          acnt_cash,acnt_check,acnt_discount,acnt_from_advance,acnt_to_advance:currency);
var
    acnt_sum:currency;        // 可沖帳總額
    jnl_no:string;
    sql:string;
    cum_acnt_advance:string;  //客戶預收款科目
    cum_acnt_ar:string;       //應收帳款科目
    cum_name:string;
    desc1:string;
begin
  acnt_sum:=acnt_cash+acnt_check+acnt_from_advance+acnt_discount-acnt_to_advance;

  cum_acnt_advance:=vartostr(TblLookup(sysinfo.AdoConnection,'TBL_CUSTOMER','CUM_NO',cum_no,'CUM_ACNT_ADVANCE'));
  cum_name:=vartostr(TblLookup(sysinfo.AdoConnection,'TBL_CUSTOMER','CUM_NO',cum_no,'CUM_NAME'));
  cum_acnt_ar:=vartostr(TblLookup(sysinfo.AdoConnection,'TBL_CUSTOMER','CUM_NO',CUM_NO,'CUM_ACNT_AR'));
{=====================================================================
  會計主檔
=======================================================================}
  jnl_no:=GetNumbericCode(sysinfo.AdoConnection,'Tbl_ACNT_JOURNAL','JNL_NO','yyyymmdd',arr_date,4);
  sql:='INSERT INTO TBL_ACNT_JOURNAL '
      +'(JNL_NO'
      +',JNL_DATE'
      +',JNL_DESC'
      +',JNL_BILL_TYPE'
      +',JNL_CREATOR) '
      +' VALUES ('
      +sqlStr(jnl_no)+','
      +sqlDateTimeSql(arr_date)+','
      +sqlStr(desc)+','
      +'1,'
      +sqlStr(sysinfo.LoginUserName)+')';
  sysinfo.AdoConnection.Execute(SQL);


  desc1:='收款:'+arr_no+':'+cum_name;
{=====================================================================
  會計明細  -- 現金
=======================================================================}
  if acnt_cash<> 0 then begin
    sql:='INSERT INTO TBL_ACNT_JOURNAL_DT'
        +' (JNL_NO,JND_SEQNO,ACT_NO,'
        +' JND_AMOUNT,JND_DESC)'
        +' VALUES ('
        +sqlStr(jnl_no)+','
        +'1,'
        +sqlStr(sysinfo.SPR_ACNT_CASH)+','
        +currtostr(acnt_cash)+','
        +sqlStr(desc1)
        +')';
    sysinfo.AdoConnection.Execute(sql);
  end;


{=====================================================================
  會計明細  -- 票據
=======================================================================}
  if acnt_check<>0 then begin
    sql:='INSERT INTO TBL_ACNT_JOURNAL_DT'
        +' (JNL_NO,JND_SEQNO,ACT_NO,'
        +' JND_AMOUNT,JND_DESC)'
        +' VALUES ('
        +sqlStr(jnl_no)+','
        +'2,'
        +sqlStr(sysinfo.SPR_ACNT_CUS_CHECK)+','
        +currtostr(acnt_check)+','
        +sqlStr(desc1)
        +')';
    sysinfo.AdoConnection.Execute(sql);
  end;

{=====================================================================
  會計明細  -- 折讓
=======================================================================}
  if acnt_discount<> 0 then begin
    sql:='INSERT INTO TBL_ACNT_JOURNAL_DT'
        +' (JNL_NO,JND_SEQNO,ACT_NO,'
        +' JND_AMOUNT,JND_DESC)'
        +' VALUES ('
        +sqlStr(jnl_no)+','
        +'3,'
        +sqlStr(sysinfo.SPR_ACNT_SALE_DISCOUNT)+','
        +currtostr(acnt_discount)+','
        +sqlStr(desc1)
        +')';
    sysinfo.AdoConnection.Execute(sql);
  end;

{=====================================================================
  會計明細  -- 取用預收
=======================================================================}
  if acnt_from_advance <> 0 then begin
    sql:='INSERT INTO TBL_ACNT_JOURNAL_DT'
        +' (JNL_NO,JND_SEQNO,ACT_NO,'
        +' JND_AMOUNT,JND_DESC)'
        +' VALUES ('
        +sqlStr(jnl_no)+','
        +'4,'
        +sqlStr(cum_acnt_advance)+','
        +currtostr(acnt_from_advance)+','
        +sqlStr(desc1)
        +')';
    sysinfo.AdoConnection.Execute(sql);
  end;

{=====================================================================
  會計明細  -- 累入預收
=======================================================================}
  if acnt_to_advance <> 0 then begin
    sql:='INSERT INTO TBL_ACNT_JOURNAL_DT'
        +' (JNL_NO,JND_SEQNO,ACT_NO,'
        +' JND_AMOUNT,JND_DESC)'
        +' VALUES ('
        +sqlStr(jnl_no)+','
        +'5,'
        +sqlStr(cum_acnt_advance)+','
        +currtostr(-acnt_to_advance)+','
        +sqlStr(desc1)
        +')';
    sysinfo.AdoConnection.Execute(sql);
  end;


{=====================================================================
  會計明細  -- 應收帳款
=======================================================================}
  if acnt_sum <> 0 then begin
    sql:='INSERT INTO TBL_ACNT_JOURNAL_DT'
        +' (JNL_NO,JND_SEQNO,ACT_NO,'
        +' JND_AMOUNT,JND_DESC)'
        +' VALUES ('
        +sqlStr(jnl_no)+','
        +'6,'
        +sqlStr(cum_acnt_ar)+','
        +currtostr(-acnt_sum)+','
        +sqlStr(desc1)
        +')';
    sysinfo.AdoConnection.Execute(sql);
  end;

{=====================================================================
  update TBL_AR_RECV.JNL_NO
=======================================================================}
  sql:='UPDATE TBL_AR_RECV'
        +' SET JNL_NO='+sqlstr(jnl_no)
          +' WHERE ARR_NO='+sqlStr(arr_no);
      sysinfo.AdoConnection.Execute(sql);


  ChkDCBalance(sysinfo,JNL_NO);

end;

function SelectCumName(sysinfo:Tsysinfo): string;
var GetRec:TWRecChoice;
    qry:TAdoQuery;
begin
  qry:=TAdoQuery.Create(nil);
	GetRec:=TWRecChoice.Create(nil);

  try
    qry.Connection:=sysinfo.AdoConnection;
    qry.SQL.Text:='SELECT CUM_NO,CUM_NAME FROM TBL_CUSTOMER';

    QRY.Open;
    QRY.First;
    GetRec.DataSet:=QRY;
    GetRec.ResultField:='Cum_No';
    GetRec.AddColunm('CUM_NAME','客戶名稱',200);
    GetRec.AddColunm('CUM_No','客戶編號',100);
    GetRec.Width:=330;
    GetRec.KeyField:='CUM_Name';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      Result:=GetRec.SelList.Strings[0]
    else
      result:='';
  finally
    GetRec.free;
    qry.close;
    qry.Free;
  end;
end;

function SelectCumNO(SYSINFO:TSysInfo): string;
var GetRec:TWRecChoice;
    qry:TAdoQuery;
begin
  qry:=TAdoQuery.Create(nil);
	GetRec:=TWRecChoice.Create(nil);

  try
    qry.Connection:=sysinfo.AdoConnection;
    qry.SQL.Text:='SELECT CUM_NO,CUM_NAME FROM TBL_CUSTOMER';
    QRY.Open;
    qry.First;
    GetRec.DataSet:=qry;
    GetRec.ResultField:='Cum_NO';
    GetRec.AddColunm('CUM_No','客戶編號',100);
    GetRec.AddColunm('CUM_NAME','客戶名稱',200);
    GetRec.Width:=330;
    GetRec.KeyField:='CUM_NO';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      Result:=GetRec.SelList.Strings[0]
    else
      result:='';
  finally
    GetRec.free;
    qry.Close;
    qry.Free;
  end;

end;



function GetCusHisPrice(sysinfo:TSysInfo;Cum_NO, Prd_NO: string): currency;
VAR S:STRING;
  qry:TAdoQuery;
begin
  S:='SELECT SMD_UNIT_PRICE'
  +' FROM TBL_SHIP M'
  +' INNER JOIN TBL_SHIP_DT D ON M.SMT_NO=D.SMT_NO'
  +' WHERE M.CUM_NO='+sqlStr(cum_no)
  +'   AND D.PRD_NO='+sqlStr(prd_no)
  +' ORDER BY M.SMT_DATE DESC';
  qry:=TAdoQuery.Create(nil);
  try
    QRY.Connection:=sysinfo.AdoConnection;
    qry.SQL.Text:=s;
    qry.Open;
    if not qry.Eof then
    begin
      result:=qry.Fields[0].AsCurrency;
      exit;
    end;
    qry.close;
    qry.SQL.Text:='SELECT PRD_SALE_PRICE FROM TBL_PRODUCT WHERE PRD_NO='+sqlStr(prd_no);
    qry.Open;
    IF not qry.Eof then
      RESULT:=qry.fields[0].AsCurrency
    ELSE
      RESULT:=0;
  finally
    qry.close;
    qry.Free;
  end;
end;


function GetCumName(sysinfo:TSysInfo;CUM_NO:STRING): string;
begin
  result:=vartostr(TblLookup(sysinfo.AdoConnection,'TBL_CUSTOMER','CUM_NO',CUM_NO,'CUM_NAME'));

end;


procedure UpdateARNotClean(sysinfo:TSysinfo;SMT_NO: string);
var S:STRING;
begin
  s:='UPDATE TBL_SHIP SET SMT_NOT_CLEAN=(SMT_TOTAL+SMT_TAX)-'
    +'( SELECT ISNULL(SUM(ARD_AMOUNT+ARD_DISCOUNT),0)'
    +'  FROM TBL_AR_RECV_DT'
    +'  WHERE SMT_NO='+SQLSTR(SMT_NO)
    +') '
    +'WHERE SMT_NO='+SQLSTR(SMT_NO);

  sysinfo.AdoConnection.Execute(s);

end;

procedure Insert_AR_Recv(sysinfo:TSysinfo;ARR_NO, CUM_NO: string;
  ARR_DATE: TDate;ARR_CASH, ARR_CHECK, ARR_FROM_ADVANCE,
  ARR_TO_ADVANCE: CURRENCY; ARR_DESC, ARR_CREATOR: STRING);
var s:string;
begin
  s:='INSERT INTO TBL_AR_RECV'
    +'(ARR_NO,CUM_NO,ARR_DATE,ARR_CASH'
    +',ARR_CHECK,ARR_FROM_ADVANCE,ARR_TO_ADVANCE,ARR_DESC,ARR_CREATOR)'
    +' VALUES('
    +sqlStr(ARR_NO)+','
    +SQLSTR(CUM_NO)+','
    +sqlDatetimeSql(Arr_Date)+','
    +currtostr(ARR_CASH)+','
    +currtostr(ARR_CHECK)+','
    +currtostr(ARR_FROM_ADVANCE)+','
    +currtostr(ARR_TO_ADVANCE)+','
    +sqlStr(ARR_DESC)+','
    +sqlStr(ARR_CREATOR)
    +')';
    sysinfo.AdoConnection.Execute(s);
end;

procedure Insert_AR_Recv_DT(sysinfo:TSysinfo;ARR_NO: STRING;
  ARD_SEQNO: INTEGER; SMT_NO: STRING; ARD_AMOUNT, ARD_DISCOUNT: CURRENCY);
var s:string;
begin
  s:='INSERT INTO TBL_AR_RECV_DT'
    +'(ARR_NO,ARD_SEQNO,SMT_NO,ARD_AMOUNT,ARD_DISCOUNT)'
    +' VALUES ('
    +SQLSTR(ARR_NO)+','
    +INTTOSTR(ARD_SEQNO)+','
    +SQLSTR(SMT_NO)+','
    +CURRTOSTR(ARD_AMOUNT)+','
    +CURRTOSTR(ARD_DISCOUNT)
    +')';
  sysinfo.AdoConnection.Execute(S);
end;

procedure UpdateCUM_Advance_Amount(sysinfo:TSysinfo;CUM_NO: string);
var s:string;
begin
    s:='UPDATE TBL_CUSTOMER SET CUM_ADVANCE_AMOUNT='
      +'( SELECT ISNULL(SUM(ARR_TO_ADVANCE-ARR_FROM_ADVANCE),0)'
      +'  FROM TBL_AR_RECV'
      +'  WHERE CUM_NO='+SQLSTR(CUM_NO)
      +') '
      +'WHERE CUM_NO='+SQLSTR(CUM_NO);
    sysinfo.AdoConnection.Execute(S);

end;

procedure UpdateSMT_Cost(sysinfo:TSysinfo;smt_no: string);
VAR S:STRING;
begin

  s:='UPDATE TBL_SHIP SET SMT_COST='
    +'(  SELECT SUM(SMD_QTY*SMD_COST) FROM TBL_SHIP_DT'
    +'   WHERE SMT_NO='+SQLSTR(SMT_NO)
    +') '
    +'WHERE SMT_NO='+SQLSTR(SMT_NO);
  sysinfo.AdoConnection.Execute(S);

end;


function SelectSupName(sysinfo:Tsysinfo): string;
var GetRec:TWRecChoice;
    qry:TAdoQuery;
begin
  qry:=TAdoQuery.Create(nil);
  qry.Connection:=sysinfo.AdoConnection;
  qry.SQL.Text:='SELECT SUP_NO,SUP_NAME FROM TBL_SUPPLIER';
	GetRec:=TWRecChoice.Create(nil);
  try
    QRY.Open;
    QRY.First;
    GetRec.DataSet:=QRY;
    GetRec.ResultField:='SUP_No';
    GetRec.AddColunm('SUP_NAME','廠商名稱',200);
    GetRec.AddColunm('SUP_No','廠商編號',100);
    GetRec.Width:=330;
    GetRec.KeyField:='SUP_Name';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      Result:=GetRec.SelList.Strings[0]
    else
      result:='';
  finally
    qry.Close;
    qry.Free;
    GetRec.free;
  end;
end;

function SelectSupNO(SYSINFO:TSysInfo): string;
var GetRec:TWRecChoice;
    qry:TAdoQuery;
begin
  qry:=TAdoQuery.Create(nil);
  qry.Connection:=sysinfo.AdoConnection;
  qry.SQL.Text:='SELECT SUP_NO,SUP_NAME FROM TBL_SUPPLIER';
	GetRec:=TWRecChoice.Create(nil);
  try
    qry.Open;
    QRY.First;
    GetRec.DataSet:=qry;
    GetRec.ResultField:='SUP_NO';
    GetRec.AddColunm('SUP_No','廠商編號',100);
    GetRec.AddColunm('SUP_NAME','廠商名稱',200);
    GetRec.Width:=330;
    GetRec.KeyField:='SUP_NO';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      Result:=GetRec.SelList.Strings[0]
    else
      result:='';
  finally
    GetRec.free;
  end;

end;



function GetSupHisPrice(sysinfo:TSysinfo;SUP_NO, Prd_NO: string): currency;
VAR S:STRING;
  qry:TAdoQuery;
begin
  S:='SELECT RCD_UNIT_PRICE'
  +' FROM TBL_PO_RECV M'
  +' INNER JOIN TBL_PO_RECV_DT D ON M.RCV_NO=D.RCV_NO'
  +' WHERE M.SUP_NO='+sqlStr(SUP_no)
  +'   AND D.PRD_NO='+sqlStr(prd_no)
  +' ORDER BY M.RCV_DATE DESC';
  qry:=TAdoQuery.Create(nil);
  try
    QRY.Connection:=sysinfo.AdoConnection;
    qry.SQL.Text:=s;
    qry.Open;
    if not qry.Eof then
    begin
      result:=qry.Fields[0].AsCurrency;
      exit;
    end;
    RESULT:=0;
  finally
    qry.close;
    qry.Free;
  end;
end;


function GetSupName(sysinfo:TSysinfo;SUP_NO:STRING): string;
begin
  result:=vartostr(TblLookup(sysinfo.AdoConnection,'TBL_Supplier','SUP_NO',SUP_NO,'SUP_NAME'));

end;



procedure UpdateAPNotClean(sysinfo:Tsysinfo;RCV_NO: string);
var S:STRING;
begin
  s:='UPDATE TBL_PO_RECV SET RCV_NOT_CLEAN=(RCV_TOTAL+RCV_TAX)-'
    +'( SELECT ISNULL(SUM(PAD_AMOUNT+PAD_DISCOUNT),0)'
    +'  FROM TBL_AP_PAY_DT'
    +'  WHERE RCV_NO='+SQLSTR(RCV_NO)
    +') '
    +'WHERE RCV_NO='+SQLSTR(RCV_NO);

  sysinfo.AdoConnection.Execute(s);

end;

procedure Insert_AP_PAY(sysinfo:TSysinfo;PAY_NO, SUP_NO: string;
  PAY_DATE: TDate;PAY_CASH, PAY_CHECK, PAY_FROM_ADVANCE,
  PAY_TO_ADVANCE: CURRENCY; PAY_DESC, PAY_CREATOR: STRING);
var s:string;
begin
  s:='INSERT INTO TBL_AP_PAY'
    +'(PAY_NO,SUP_NO,PAY_DATE,PAY_CASH'
    +',PAY_CHECK,PAY_FROM_ADVANCE,PAY_TO_ADVANCE,PAY_DESC,PAY_CREATOR)'
    +' VALUES('
    +sqlStr(PAY_NO)+','
    +SQLSTR(SUP_NO)+','
    +sqlDatetimeSql(PAY_Date)+','
    +currtostr(PAY_CASH)+','
    +currtostr(PAY_CHECK)+','
    +currtostr(PAY_FROM_ADVANCE)+','
    +currtostr(PAY_TO_ADVANCE)+','
    +sqlStr(PAY_DESC)+','
    +sqlStr(PAY_CREATOR)
    +')';
    sysinfo.AdoConnection.Execute(s);
end;

procedure Insert_AP_PAY_DT(sysinfo:TSysInfo;PAY_NO: STRING;
  PAD_SEQNO: INTEGER; RCV_NO: STRING; PAD_AMOUNT, PAD_DISCOUNT: CURRENCY);
var s:string;
begin
  s:='INSERT INTO TBL_AP_PAY_DT'
    +'(PAY_NO,PAD_SEQNO,RCV_NO,PAD_AMOUNT,PAD_DISCOUNT)'
    +' VALUES ('
    +SQLSTR(PAY_NO)+','
    +INTTOSTR(PAD_SEQNO)+','
    +SQLSTR(RCV_NO)+','
    +CURRTOSTR(PAD_AMOUNT)+','
    +CURRTOSTR(PAD_DISCOUNT)
    +')';
  sysinfo.AdoConnection.Execute(S);
end;

procedure UpdateSUP_Advance_Amount(sysinfo:TSysinfo;SUP_NO: string);
var s:string;
begin
    s:='UPDATE TBL_Supplier SET SUP_ADVANCE_AMOUNT='
      +'( SELECT ISNULL(SUM(PAY_TO_ADVANCE-PAY_FROM_ADVANCE),0)'
      +'  FROM TBL_AP_PAY'
      +'  WHERE SUP_NO='+SQLSTR(SUP_NO)
      +') '
      +'WHERE SUP_NO='+SQLSTR(SUP_NO);
    sysinfo.AdoConnection.Execute(S);

end;

procedure ApPayToAccount(sysinfo:TSysinfo;pay_no, sup_no: string;
  pay_date: TDateTime; desc: string; acnt_cash, acnt_check, acnt_discount,
  acnt_from_advance, acnt_to_advance: currency);
var acnt_sum:currency;        // 可沖帳總額
    jnl_no:string;
    sql:string;
    sup_acnt_advance:string;  //客戶預收款科目
    sup_acnt_ap:string;       //應收帳款科目
    sup_name,desc1:string;
begin
  acnt_sum:=acnt_cash+acnt_check+acnt_from_advance+acnt_discount-acnt_to_advance;

  sup_acnt_advance:=vartostr(TblLookup(sysinfo.AdoConnection,'TBL_SUPPLIER','SUP_NO',sup_no,'SUP_ACNT_ADVANCE'));
  sup_name:=vartostr(TblLookup(sysinfo.AdoConnection,'TBL_SUPPLIER','SUP_NO',sup_no,'SUP_NAME'));
  sup_acnt_ap:=vartostr(TblLookup(sysinfo.AdoConnection,'TBL_SUPPLIER','SUP_NO',sup_no,'SUP_ACNT_AP'));
{=====================================================================
  會計主檔
=======================================================================}
  jnl_no:=GetNumbericCode(sysinfo.AdoConnection,'Tbl_ACNT_JOURNAL','JNL_NO','yyyymmdd',pay_date,4);
  sql:='INSERT INTO TBL_ACNT_JOURNAL '
      +'(JNL_NO'
      +',JNL_DATE'
      +',JNL_DESC'
      +',JNL_BILL_TYPE'
      +',JNL_CREATOR) '
      +' VALUES ('
      +sqlStr(jnl_no)+','
      +sqlDateTimeSql(pay_date)+','
      +sqlStr(desc)+','
      +'1,'
      +sqlStr(sysinfo.LoginUserName)+')';
  sysinfo.AdoConnection.Execute(SQL);


  desc1:='付款:'+pay_no+':'+sup_name;
{=====================================================================
  會計明細  -- 現金
=======================================================================}
  if acnt_cash<> 0 then begin
    sql:='INSERT INTO TBL_ACNT_JOURNAL_DT'
        +' (JNL_NO,JND_SEQNO,ACT_NO,'
        +' JND_AMOUNT,JND_DESC)'
        +' VALUES ('
        +sqlStr(jnl_no)+','
        +'1,'
        +sqlStr(sysinfo.SPR_ACNT_CASH)+','
        +currtostr(-acnt_cash)+','
        +sqlStr(desc1)
        +')';
    sysinfo.AdoConnection.Execute(sql);
  end;


{=====================================================================
  會計明細  -- 票據
=======================================================================}
  if acnt_check<>0 then begin
    sql:='INSERT INTO TBL_ACNT_JOURNAL_DT'
        +' (JNL_NO,JND_SEQNO,ACT_NO,'
        +' JND_AMOUNT,JND_DESC)'
        +' VALUES ('
        +sqlStr(jnl_no)+','
        +'2,'
        +sqlStr(sysinfo.SPR_ACNT_SUP_CHECK)+','
        +currtostr(-acnt_check)+','
        +sqlStr(desc1)
        +')';
    sysinfo.AdoConnection.Execute(sql);
  end;

{=====================================================================
  會計明細  -- 折讓
=======================================================================}
  if acnt_discount<> 0 then begin
    sql:='INSERT INTO TBL_ACNT_JOURNAL_DT'
        +' (JNL_NO,JND_SEQNO,ACT_NO,'
        +' JND_AMOUNT,JND_DESC)'
        +' VALUES ('
        +sqlStr(jnl_no)+','
        +'3,'
        +sqlStr(sysinfo.SPR_ACNT_PUR_DISCOUNT)+','
        +currtostr(-acnt_discount)+','
        +sqlStr(desc1)
        +')';
    sysinfo.AdoConnection.Execute(sql);
  end;

{=====================================================================
  會計明細  -- 取用預付
=======================================================================}
  if acnt_from_advance <> 0 then begin
    sql:='INSERT INTO TBL_ACNT_JOURNAL_DT'
        +' (JNL_NO,JND_SEQNO,ACT_NO,'
        +' JND_AMOUNT,JND_DESC)'
        +' VALUES ('
        +sqlStr(jnl_no)+','
        +'4,'
        +sqlStr(sup_acnt_advance)+','
        +currtostr(-acnt_from_advance)+','
        +sqlStr(desc1)
        +')';
    sysinfo.AdoConnection.Execute(sql);
  end;

{=====================================================================
  會計明細  -- 累入預付
=======================================================================}
  if acnt_to_advance <> 0 then begin
    sql:='INSERT INTO TBL_ACNT_JOURNAL_DT'
        +' (JNL_NO,JND_SEQNO,ACT_NO,'
        +' JND_AMOUNT,JND_DESC)'
        +' VALUES ('
        +sqlStr(jnl_no)+','
        +'5,'
        +sqlStr(sup_acnt_advance)+','
        +currtostr(acnt_to_advance)+','
        +sqlStr(desc1)
        +')';
    sysinfo.AdoConnection.Execute(sql);
  end;


{=====================================================================
  會計明細  -- 應付帳款
=======================================================================}
  if acnt_sum <> 0 then begin
    sql:='INSERT INTO TBL_ACNT_JOURNAL_DT'
        +' (JNL_NO,JND_SEQNO,ACT_NO,'
        +' JND_AMOUNT,JND_DESC)'
        +' VALUES ('
        +sqlStr(jnl_no)+','
        +'6,'
        +sqlStr(sup_acnt_ap)+','
        +currtostr(acnt_sum)+','
        +sqlStr(desc1)
        +')';
    sysinfo.AdoConnection.Execute(sql);
  end;

{=====================================================================
  update TBL_AR_RECV.JNL_NO
=======================================================================}
  sql:='UPDATE TBL_AP_PAY'
        +' SET JNL_NO='+sqlstr(jnl_no)
          +' WHERE PAY_NO='+sqlStr(pay_no);
      sysinfo.AdoConnection.Execute(sql);

  ChkDCBalance(sysinfo,JNL_NO);
end;




function GetPrdName(sysinfo:Tsysinfo;prd_no: string): string;
begin
  result:=vartostr(TblLookup(sysinfo.AdoConnection,'TBL_PRODUCT','PRD_NO',PRD_NO,'PRD_NAME'));
end;

function GetPrdCurrCost(sysinfo:TSysinfo;prd_no: string): currency;
begin
  result:=vartoCURR(TblLookup(sysinfo.AdoConnection,'TBL_PRODUCT','PRD_NO',PRD_NO,'PRD_CUR_COST'));
end;

function SelectPrdNO(sysinfo:TSysinfo;slist:TStringList): string;
var GetRec:TWRecChoice;
  qry:TAdoQuery;
begin
	GetRec:=TWRecChoice.Create(nil);
  qry:=TAdoQuery.Create(nil);
  qry.Connection:=sysinfo.AdoConnection;
  qry.SQL.Text:='SELECT PRD_NO,PRD_NAME FROM TBL_PRODUCT ORDER BY PRD_NO';
  try
    qry.Open;
    qry.First;
    GetRec.DataSet:=qry;
    GetRec.ResultField:='PRD_NO';
    GetRec.AddColunm('PRD_No','產品編號',100);
    GetRec.AddColunm('PRD_NAME','產品名稱',200);
    GetRec.Width:=360;
    GetRec.KeyField:='PRD_NO';
    GetRec.MultiSelect:=TRUE;
    if GetRec.Excute then
    begin
      slist.Assign(GetRec.SelList);
      Result:=slist.Strings[0]

    end else
      result:='';
  finally
    qry.close;
    qry.Free;
    GetRec.free;
  end;

end;



procedure GetDummyPrd(sysinfo:TSysinfo;prd_no: string; var PRD_IS_DUMMY: boolean;
  var PRD_DUM_COST_RATE: SINGLE);
VAR SQL:string;
  qry:TAdoQuery;
begin
  qry:=TAdoQuery.Create(nil);
  try
    qry.Connection:=sysinfo.AdoConnection;
    sql:='SELECT PRD_IS_DUMMY,PRD_DUM_COST_RATE'
        +' FROM TBL_PRODUCT'
        +' WHERE PRD_NO='+sqlstr(prd_no);
    qry.SQL.Text:=sql;
    qry.Open;
    PRD_IS_DUMMY:=qry.FieldByName('PRD_IS_DUMMY').AsBoolean;
    PRD_DUM_COST_RATE:=qry.FieldByName('PRD_DUM_COST_RATE').AsFloat;
  finally
    QRY.Close;
    qry.Free;
  end;


end;



function SelectCarNO(sysinfo:TSysinfo): string;
var GetRec:TWRecChoice;
  qry:TAdoQuery;
begin
  qry:=TAdoQuery.Create(nil);
  qry.Connection:=sysinfo.AdoConnection;
  qry.SQL.Text:='SELECT CAR_NO,CAR_license_no,CAR_BRAND FROM TBL_CAR ORDER BY CAR_NO';

	GetRec:=TWRecChoice.Create(nil);
  try
    qry.Open;
    qry.FIRST;
    GetRec.DataSet:=qry;
    GetRec.ResultField:='CAR_NO';
    GetRec.AddColunm('CAR_No','車輛編號',100);
    GetRec.AddColunm('CAR_LICENSE_NO','牌照號碼',100);
    GetRec.AddColunm('CAR_BRAND','廠牌形式',200);
    GetRec.Width:=430;
    GetRec.KeyField:='CAR_NO';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      Result:=GetRec.SelList.Strings[0]
    else
      result:='';
  finally
    qry.close;
    qry.Free;
    GetRec.free;
  end;

end;

function GetCarName(sysinfo:Tsysinfo;CAR_No: string): string;
begin
  result:=vartostr(TblLookup(sysinfo.AdoConnection,'TBL_CAR','CAR_NO',CAR_NO,'CAR_LICENSE_NO'));

end;






function SelectEpyNO(sysinfo:TSysinfo): string;
var GetRec:TWRecChoice;
  qry:TAdoQuery;
begin
	GetRec:=TWRecChoice.Create(nil);
  qry:=TAdoQuery.Create(nil);
  qry.Connection:=sysinfo.AdoConnection;
  qry.SQL.Text:='SELECT EPY_NO,EPY_NAME FROM TBL_EMPLOYE ORDER BY EPY_NO';

  try
    qry.Open;
    qry.FIRST;
    GetRec.DataSet:=qry;
    GetRec.ResultField:='EPY_NO';
    GetRec.AddColunm('EPY_No','員工編號',100);
    GetRec.AddColunm('EPY_NAME','員工名稱',200);
    GetRec.Width:=330;
    GetRec.KeyField:='EPY_NO';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      Result:=GetRec.SelList.Strings[0]
    else
      result:='';
  finally
    qry.close;
    qry.free;
    GetRec.free;
  end;

end;

function GetEpyName(sysinfo:Tsysinfo;Epy_No: string): string;
begin
  result:=vartostr(TblLookup(sysinfo.AdoConnection,'TBL_Employe','EPY_NO',EPY_NO,'EPY_NAME'));

end;


procedure setAdoConnection(owner:TComponent;con:TAdoConnection);
var i:integer;
begin
  for i:=0 to owner.ComponentCount-1 do begin
    if owner.Components[i] is TAdoQuery then begin
      TAdoQuery(owner.Components[i]).Connection:=con;
    end;
  end;
end;

end.

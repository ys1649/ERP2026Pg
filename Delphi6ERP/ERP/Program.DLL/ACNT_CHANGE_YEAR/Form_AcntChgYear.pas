unit Form_AcntChgYear;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, DB, ADODB,erp_public,FORM_ERP_BASE;

type
  Tfm_AcntChgYear = class(TForm_ERP)
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    btnChange: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    editYear: TEdit;
    QryChgYear: TADOQuery;
    Button1: TButton;
    procedure btnChangeClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure ChangeYear;
    procedure UndoChangeYear;

  public
    procedure init;override;
    { Public declarations }
  end;


implementation

uses Uty;

{$R *.dfm}

procedure Tfm_AcntChgYear.btnChangeClick(Sender: TObject);
begin
  if messagedlg('是否執行年度結轉 ? ', mtWarning	,[mbYes, mbNo],0) <> mrYes then exit;
  changeYear;
  ReadSysParam(sysinfo);
  msg ('結轉完成 ! 新的會計年度為 '+inttostr(sysinfo.SPR_ACNT_YEAR) +CR +CR
        + '結轉完成後，系統必須離開，結束後請自行重新進入系統....');
  Application.Terminate;
end;


procedure Tfm_AcntChgYear.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure Tfm_AcntChgYear.ChangeYear;
VAR JNL_NO:string;
    jnl_date:TDate;
    sql:string;
    seqno:integer;
    newYear:integer;

    dtFrom,dtTo:Tdate;
begin
  sysinfo.AdoConnection.BeginTrans;
  try
    newYear:=sysinfo.SPR_ACNT_YEAR+1;
    jnl_no:=inttostr(NewYear)+'01010000';
    SQL:='DELETE TBL_ACNT_JOURNAL_DT WHERE JNL_NO='+SQLSTR(jnl_no);
    sysinfo.AdoConnection.Execute(sql);
    SQL:='DELETE TBL_ACNT_JOURNAL WHERE JNL_NO='+SQLSTR(jnl_no);
    sysinfo.AdoConnection.Execute(sql);

    dtFrom:=encodedate(sysinfo.SPR_ACNT_YEAR,1,1);
    dtTo:=encodedate(newYear,1,1);


    {==========================================================================
      結轉傳票主檔
    =========================================================================== }
    jnl_date:=dtTo;
    SQL:='INSERT INTO TBL_ACNT_JOURNAL (JNL_NO,JNL_DATE,JNL_DESC,JNL_BILL_TYPE,JNL_CREATOR)'
        +' VALUES ('
        + sqlstr(jnl_no)
        +',' + SqlDateTimeSQL(jnl_date)
        +',' + sqlstr('結轉 ' +inttostr(sysinfo.SPR_ACNT_YEAR)+' 年度餘額傳票')
        +', 2'
        +',' + sqlstr(sysinfo.LoginUserName) + ')';
    sysinfo.AdoConnection.Execute(sql);


    {==========================================================================
      結轉傳票明細分錄
    =========================================================================== }
    sql:='SELECT ACT_NO,SUM(AMOUNT) AMOUNT,'+sqlstr('結轉 '+inttostr(sysinfo.SPR_ACNT_YEAR)+' 年度-實科目餘額')+' JND_DESC' + CR
        +' FROM' + CR
        +' (' + CR
        +' SELECT A.JNL_NO,B.JND_SEQNO,C.ACT_NO,B.JND_AMOUNT AMOUNT' + CR
        +' FROM TBL_ACNT_JOURNAL A' + CR
        +' 	INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
        +' 	INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO' + CR
        +' 	INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO' + CR
        +' WHERE D.TYP_MAJOR_TYPE IN (''資產'',''負債'',''業主權益'')' + CR
        +'   AND A.JNL_DATE >= '+SqlDateTimeSQL(dtFrom) +CR
        +' 	 AND A.JNL_DATE < '+SqlDateTimeSQL(dtTo) +CR
        +' )A' + CR
        +' GROUP BY A.ACT_NO' + CR
        +' UNION' + CR
        +' SELECT ''3351'' ACT_NO,SUM(B.JND_AMOUNT) AMOUNT,'+sqlstr('結轉 '+inttostr(sysinfo.SPR_ACNT_YEAR)+' 年度-損益匯總')+' JND_DESC'  + CR
        +' FROM TBL_ACNT_JOURNAL A' + CR
        +' INNER JOIN TBL_ACNT_JOURNAL_DT B ON A.JNL_NO=B.JNL_NO' + CR
        +' INNER JOIN TBL_ACNT_ACCOUNT C ON B.ACT_NO=C.ACT_NO' + CR
        +' INNER JOIN TBL_ACNT_TYPE D ON C.TYP_NO=D.TYP_NO' + CR
        +' WHERE D.TYP_MAJOR_TYPE NOT IN (''資產'',''負債'',''業主權益'')' + CR
        +'   AND A.JNL_DATE >= '+SqlDateTimeSQL(dtFrom) +CR
        +' 	 AND A.JNL_DATE < '+SqlDateTimeSQL(dtTo);
    QryChgYear.Close;
    debug (sql);
    QryChgYear.SQL.Text:=sql;
    QryChgYear.Open;
    seqno:=0;
    while not QryChgYear.Eof do begin
      inc(seqno);
      sql:='INSERT INTO TBL_ACNT_JOURNAL_DT (JNL_NO,JND_SEQNO,ACT_NO,JND_AMOUNT,JND_DESC)'
          +' VALUES ('
          + sqlstr(jnl_no)
          + ',' + INTTOSTR(seqno)
          + ',' + sqlstr(QryChgYear.fieldbyname('ACT_NO').AsString)
          + ',' + floattostr(QryChgYear.fieldbyname('AMOUNT').AsFloat)
          + ',' + sqlstr(QryChgYear.fieldbyname('JND_DESC').AsString) + ')';
      sysinfo.AdoConnection.Execute(sql);
      QryChgYear.Next;
    end;
    QryChgYear.Close;

    {==========================================================================
      更換年度
    =========================================================================== }
    sql:='UPDATE TBL_SYS_PARAM SET SPR_ACNT_YEAR='+INTTOSTR(NewYear);
    sysinfo.AdoConnection.Execute(sql);
    sysinfo.AdoConnection.CommitTrans;
    sysinfo.SPR_ACNT_YEAR:= newYear;
    editYear.Text:=inttostr(sysinfo.SPR_ACNT_YEAR);
  except
    sysinfo.AdoConnection.RollbackTrans;
    Raise;
  end;
end;


procedure Tfm_AcntChgYear.init;
begin
  setAdoConnection(self,sysinfo.AdoConnection);
  editYear.Text:=inttostr(sysinfo.SPR_ACNT_YEAR);
end;


procedure Tfm_AcntChgYear.UndoChangeYear;
VAR JNL_NO:string;
    sql:string;
    newYear:integer;

begin
  sysinfo.AdoConnection.BeginTrans;
  try
    newYear:=sysinfo.SPR_ACNT_YEAR-1;
    jnl_no:=inttostr(sysinfo.SPR_ACNT_YEAR)+'01010000';
    SQL:='DELETE TBL_ACNT_JOURNAL_DT WHERE JNL_NO='+SQLSTR(jnl_no);
    sysinfo.AdoConnection.Execute(sql);
    SQL:='DELETE TBL_ACNT_JOURNAL WHERE JNL_NO='+SQLSTR(jnl_no);
    sysinfo.AdoConnection.Execute(sql);
    {==========================================================================
      更換年度
    =========================================================================== }
    sql:='UPDATE TBL_SYS_PARAM SET SPR_ACNT_YEAR='+INTTOSTR(NewYear);
    sysinfo.AdoConnection.Execute(sql);
    sysinfo.AdoConnection.CommitTrans;
    sysinfo.SPR_ACNT_YEAR:= newYear;
    editYear.Text:=inttostr(sysinfo.SPR_ACNT_YEAR);
  except
    sysinfo.AdoConnection.RollbackTrans;
    Raise;
  end;
end;


procedure Tfm_AcntChgYear.Button1Click(Sender: TObject);
begin
  inherited;
  if messagedlg('是否取消年結 ? ', mtWarning	,[mbYes, mbNo],0) <> mrYes then exit;
  UndoChangeYear;
  ReadSysParam(sysinfo);
  msg ('取消年結後 ! 會計年度回覆為 '+inttostr(sysinfo.SPR_ACNT_YEAR) +CR +CR
        + '取消完成，系統必須離開，結束後請自行重新進入系統....');

  Application.Terminate;
end;

end.

unit form_textDef;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, Provider, DBClient, StdCtrls, Buttons, ExtCtrls, ImgList,
  ActnList, ADODB, Mask, DBCtrls, dxCntner, dxTL, dxDBCtrl, dxDBGrid,
  dxDBTLCl, dxGrClms, dxGrClEx, Grids, Wwdbigrd, Wwdbgrid;

type
  Tfm_TextDef = class(TForm)
    qry_Mast: TADOQuery;
    qry_dt: TADOQuery;
    ActionList1: TActionList;
    ActAppend: TAction;
    ActEdit: TAction;
    ActDelete: TAction;
    ActBrowse: TAction;
    ActFirst: TAction;
    ActLast: TAction;
    ActPrior: TAction;
    ActNext: TAction;
    ActSave: TAction;
    ActAbort: TAction;
    ActRefresh: TAction;
    ImageList1: TImageList;
    pnlCtrl: TPanel;
    BtnAppend: TButton;
    BtnEdit: TButton;
    BtnDelete: TButton;
    BtnSave: TButton;
    BtnAbort: TButton;
    BtnFunc: TButton;
    pnlStatus: TPanel;
    Panel1: TPanel;
    btnPrior: TSpeedButton;
    btnNext: TSpeedButton;
    BtnLast: TSpeedButton;
    btnFirst: TSpeedButton;
    Panel3: TPanel;
    LblStatus: TLabel;
    pnlMast1: TPanel;
    Client_Mast: TClientDataSet;
    Client_dt: TClientDataSet;
    provider_Mast: TDataSetProvider;
    Provider_Dt: TDataSetProvider;
    ds_mast: TDataSource;
    ds_dt: TDataSource;
    Client_MastTKT_ID: TStringField;
    Client_MastTKT_SrcFldr: TStringField;
    Client_MastTKT_FilePattern: TStringField;
    Client_MastTKT_Type: TStringField;
    Client_MastTKT_DelimitMethod: TStringField;
    Client_MastTKT_DelimitChar: TStringField;
    Client_MastTKT_BackFldr: TStringField;
    Label2: TLabel;
    Edit_ID: TDBEdit;
    Label3: TLabel;
    EditSrcFldr: TDBEdit;
    Label4: TLabel;
    DBEdit3: TDBEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    DBEdit6: TDBEdit;
    Label8: TLabel;
    DBEdit7: TDBEdit;
    cb_Type: TDBComboBox;
    grid: TdxDBGrid;
    PnlDetail2: TPanel;
    NavDetail: TDBNavigator;
    Client_dtTKT_ID: TStringField;
    Client_dtTTC_SEQNO: TBCDField;
    Client_dtTTC_FieldName: TStringField;
    Client_dtTTC_StartPosi: TBCDField;
    Client_dtTTC_Leng: TBCDField;
    Client_dtTTC_ColType: TStringField;
    Client_dtTTC_ColFmt: TStringField;
    Label1: TLabel;
    Client_dtTTC_DefaultValue: TStringField;
    gridTTC_SEQNO: TdxDBGridMaskColumn;
    gridTTC_FieldName: TdxDBGridMaskColumn;
    gridTTC_StartPosi: TdxDBGridMaskColumn;
    gridTTC_Leng: TdxDBGridMaskColumn;
    gridTTC_ColFmt: TdxDBGridMaskColumn;
    gridTTC_DefaultValue: TdxDBGridMaskColumn;
    cbDelimiteMethod: TDBComboBox;
    gridTTC_ColType: TdxDBGridMRUColumn;
    Edit_Rec: TEdit;
    procedure Client_MastAfterScroll(DataSet: TDataSet);
    procedure ActAppendExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ActAbortExecute(Sender: TObject);
    procedure ActEditExecute(Sender: TObject);
    procedure ActFirstExecute(Sender: TObject);
    procedure ActLastExecute(Sender: TObject);
    procedure ActPriorExecute(Sender: TObject);
    procedure ActNextExecute(Sender: TObject);
    procedure ActBrowseExecute(Sender: TObject);
    procedure Client_dtAfterInsert(DataSet: TDataSet);
    procedure ActDeleteExecute(Sender: TObject);
  private
    ModiFlag:boolean;
    procedure SetEditMode(EditFlag: Boolean);
    procedure RefreshData;
    procedure DeleteDetail;
    procedure DeleteMaster;
    procedure UpdateMaster;
    procedure SaveDetail;
    procedure SaveMaster;

  public
    procedure init;
    { Public declarations }
  end;

var
  fm_TextDef: Tfm_TextDef;

implementation

uses DataModule_Main, Uty, Form_Browse;

{$R *.dfm}


procedure Tfm_TextDef.init;
begin
  SetEditMode(false);
  RefreshData;
end;

procedure Tfm_TextDef.SetEditMode(EditFlag: Boolean);
begin
  ds_dt.AutoEdit:=EditFlag;
  SetOwnerCtrlReadOnly(self,not EditFlag);
  ActAppend.Enabled:=not EditFlag;
  ActEdit.Enabled:=not EditFlag;
  ActDelete.Enabled:=not EditFlag;
  ActBrowse.Enabled:=not EditFlag;
  ActRefresh.Enabled:=not EditFlag;

  ActFirst.Enabled:=not Editflag;
  ActPrior.Enabled:=not Editflag;
  ActNext.Enabled:=not Editflag;
  ActLast.Enabled:=not Editflag;


  ActAbort.Enabled:= EditFlag;
  ActSave.Enabled:= EditFlag;
  BtnSave.Enabled:=EditFlag;
  if   ModiFlag=True then
    SetCtrlReadOnly(Edit_ID,true);
  SetCtrlReadOnly(Edit_Rec,true);

  if EditFlag then
  begin
    navDetail.VisibleButtons:= [nbFirst,nbPrior,nbNext,nbLast,nbInsert,nbDelete];
  end else
  begin
    navDetail.VisibleButtons:= [nbFirst,nbPrior,nbNext,nbLast];
  end;
  Client_MastAfterScroll(Client_mast);

end;

procedure Tfm_TextDef.Client_MastAfterScroll(DataSet: TDataSet);
var sql:string;
begin
  if Client_Mast.State<>dsBrowse then exit;
  sql:='SELECT * FROM Tsk_TxtColMap '
      +' WHERE TKT_ID='+SqlStr(Client_MastTKT_ID.AsString)
      +' ORDER BY TTC_SEQNO';
  DoQrySelect(sql,dm_main.adodc,Client_DT);

  Edit_rec.Text:=format ('%d / %d',[Client_Mast.recno,Client_Mast.recordCount]);
end;

procedure Tfm_TextDef.ActAppendExecute(Sender: TObject);
begin
  ModiFlag:=false;
  client_dt.Close;
  DoQrySelect('SELECT * FROM TSK_TxtColMap WHERE TKT_ID IS NULL',dm_main.adodc,client_dt);
  client_dt.open;
  Client_Mast.Append;
  Client_MastTKT_Type.Value:='TEXT';
  Client_MastTKT_FilePattern.Value:='*.TXT';
  Client_MastTKT_DelimitMethod.Value:='固定欄寬';
  Edit_ID.SetFocus;
  SetEditMode(true);

end;

procedure Tfm_TextDef.RefreshData;
var sql,s:string;
begin
  screen.Cursor:=crSQLWait;
  TRY
    Sql:='SELECT * FROM TSK_Txt';

    if Client_Mast.State<> dsinactive then
      s:=client_Mast.fieldbyname('TKT_ID').AsString;

    DoQrySelect(sql,dm_main.adodc,Client_Mast);
    IF s='' then
      Client_Mast.Last;
  FINALLY
    screen.Cursor:=crDefault;
  END;

end;
procedure Tfm_TextDef.ActSaveExecute(Sender: TObject);
begin

  dm_main.adodc.BeginTrans;
  try
    if ModiFlag then begin
      DeleteDetail;
      UpdateMaster;
      SaveDetail;
    end else begin
      SaveMaster;
      SaveDetail;
    end;
    dm_main.adodc.CommitTrans;
  except
    dm_main.adodc.RollbackTrans;
    raise;
  end;
  Client_Mast.Post;
  SetEditMode(false);
end;

procedure Tfm_TextDef.ActAbortExecute(Sender: TObject);
begin
  Client_Mast.Cancel;
  SetEditMode(false);
end;

procedure Tfm_TextDef.ActEditExecute(Sender: TObject);
begin
  ModiFlag:=true;
  Client_Mast.Edit;
  EditSrcFldr.SetFocus;
  SetEditMode(True);
end;

procedure Tfm_TextDef.DeleteDetail;
var sql:string;
    id:string;
begin
  id:=Client_Mast.fieldbyname('TKT_ID').AsString;
  sql:='DELETE FROM TSK_TxtCoLMap WHERE TKT_ID='+sqlstr(id);
  dm_main.adodc.Execute(sql);

end;

procedure Tfm_TextDef.SaveDetail;
var sql:string;
    id:string;
    sStartPosi,sLeng:string;
begin
  id:=Client_Mast.fieldbyname('TKT_ID').AsString;
  Client_dt.First;
  while not Client_dt.Eof do begin
    sStartPosi:=Client_dtTTC_StartPosi.AsString;
    if sStartPosi ='' then sStartPosi:='NULL';
    sLeng:=Client_dtTTC_Leng.AsString;
    if sLeng='' then sLeng:='NULL';

    sql:='insert into TSK_TxtColMap'
        +' (TKT_ID,TTC_SEQNO,TTC_FieldName'
        +' ,TTC_DefaultValue,TTC_StartPosi,TTC_Leng'
        +' ,TTC_ColType,TTC_ColFmt)'
        +' values('
        + sqlstr(id)+','
        + Client_dtTTC_SEQNO.AsString + ','
        + sqlstr(Client_dtTTC_FieldName.AsString) + ','
        + sqlstr(Client_dtTTC_DefaultValue.AsString) + ','
        + sStartPosi + ','
        + sLeng + ','
        + sqlstr(Client_dtTTC_ColType.AsString) + ','
        + sqlstr(Client_dtTTC_ColFmt.AsString) +')';
    dm_main.adodc.Execute(sql);
    Client_dt.Next;
  end;
end;

procedure Tfm_TextDef.UpdateMaster;
var sql:string;
    id:string;
begin
  id:=Client_Mast.fieldbyname('TKT_ID').AsString;
  sql:='UPDATE TSK_Txt '
      +' SET TKT_SrcFldr=' + sqlstr(Client_MastTKT_SrcFldr.AsString)
      +',TKT_FilePattern='+ sqlstr(Client_MastTKT_FilePattern.AsString)
      +',TKT_Type='+sqlstr(Client_MastTKT_Type.AsString)
      +',TKT_DelimitMethod='+sqlstr(Client_MastTKT_DelimitMethod.AsString)
      +',TKT_DelimitChar='+sqlstr(Client_MastTKT_DelimitChar.AsString)
      +',TKT_BackFldr='+sqlstr(Client_MastTKT_BackFldr.AsString)
      +' WHERE TKT_ID='+sqlstr(Client_MastTKT_ID.AsString);
  dm_main.adodc.Execute(sql);

end;

procedure Tfm_TextDef.SaveMaster;
var sql:string;
    id:string;
begin
  id:=Client_Mast.fieldbyname('TKT_ID').AsString;
  sql:='INSERT INTO TSK_Txt '
      +' (TKT_ID,TKT_SrcFldr,TKT_FilePattern,TKT_Type'
      +' ,TKT_DelimitMethod,TKT_DelimitChar,TKT_BackFldr)'
      +' VALUES ('
      + SQLSTR(Client_MastTKT_ID.AsString)+','
      + sqlstr(Client_MastTKT_SrcFldr.AsString)+','
      + sqlstr(Client_MastTKT_FilePattern.AsString)+','
      + sqlstr(Client_MastTKT_Type.AsString)+','
      + sqlstr(Client_MastTKT_DelimitMethod.AsString)+','
      + sqlstr(Client_MastTKT_DelimitChar.AsString)+','
      + sqlstr(Client_MastTKT_BackFldr.AsString)+')';
  dm_main.adodc.Execute(sql);

END;

procedure Tfm_TextDef.ActFirstExecute(Sender: TObject);
begin
  Client_Mast.First;
end;

procedure Tfm_TextDef.ActLastExecute(Sender: TObject);
begin
  Client_Mast.Last;
end;

procedure Tfm_TextDef.ActPriorExecute(Sender: TObject);
begin
  Client_Mast.Prior;
end;

procedure Tfm_TextDef.ActNextExecute(Sender: TObject);
begin
  Client_Mast.Next;
end;

procedure Tfm_TextDef.ActBrowseExecute(Sender: TObject);
var fm:TFm_Browse;
begin
  fm:=TFm_Browse.Create(application);
  try
    fm.ShowModal;
  finally
    fm.Free;
  end;

end;

procedure Tfm_TextDef.Client_dtAfterInsert(DataSet: TDataSet);
begin

  Client_dtTTC_SEQNO.Value:=(Client_dt.RecordCount+1)*10;
  Client_dtTTC_ColType.Value:='STRING';
end;

procedure Tfm_TextDef.DeleteMaster;
var sql:string;
begin
  sql:='DELETE Tsk_Txt WHERE TKT_ID='+sqlStr(Client_MastTKT_ID.AsString);
  dm_main.adodc.Execute(sql);
  client_mast.Delete;
end;

procedure Tfm_TextDef.ActDeleteExecute(Sender: TObject);
begin
  if MessageDlg('是否確定刪除 ?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;


  DM_Main.adodc.BeginTrans;
  try
    DeleteDetail;
    DeleteMaster;
    dm_main.adodc.CommitTrans;
  except
    dm_main.adodc.RollbackTrans;
    raise;
  end;

end;

end.

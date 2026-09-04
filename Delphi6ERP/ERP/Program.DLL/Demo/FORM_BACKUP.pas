unit FORM_BACKUP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TFM_BACKUP = class(TForm)
    bar1: TProgressBar;
    Label1: TLabel;
    procedure FormActivate(Sender: TObject);
  private
    procedure CreateTmpPath(path:string);
    procedure SaveTable(path:string);
    PROCEDURE BACKUP;
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

uses Uty;

{$R *.dfm}

{ TFM_BACKUP }

procedure TFM_BACKUP.BACKUP;
CONST tmpPath='C:\$$BK_TMP\aaa\bbb\ccc\ddd\eee';
begin
//  ProcessPath(SPR_BKUP_PATH,drv,path ,filePart);
  CreateTmpPath(tmpPath);
  SaveTable(tmpPath);

end;

procedure TFM_BACKUP.CreateTmpPath(path: string);
var sr: TSearchRec;
    n:integer;
begin
  try
    ForceDirectories(path);
    n:=findfirst(path+'\*.*',faAnyFile, sr);
    while (n=0) do
    begin
      deletefile(path+'\'+sr.Name);
      n:=findnext(sr);
    end;
  except
  end;

end;

procedure TFM_BACKUP.SaveTable(path: string);
var TblList:TStringList;
    i:integer;
    filename:string;
begin
  TblList:=TStringList.Create;
  try
    dm_main.adodc.GetTableNames(tblList,false);
    BAR1.Step:=1;
    bar1.Min:=0;
    bar1.Max:=tblList.Count;
    for i:=0 to tblList.Count-1 do
    begin
      filename:=path+'\'+tblList.Strings[i]+'.XML';
      label1.Caption:=format(' %d / %d :%s',[i+1,tblList.Count,tblList.Strings[i]]);
      bar1.StepIt;
      application.ProcessMessages;
      if copy(tblList.Strings[i],1,6)<>'TBL_AP' then continue;
      Table2File(dm_main.adodc,tblList.Strings[i],filename);
    end;
  finally
    tblList.Free;
  end;
end;

procedure TFM_BACKUP.FormActivate(Sender: TObject);
begin
  backup;
  PostMessage(self.Handle,WM_CLOSE,0,0);
end;

end.

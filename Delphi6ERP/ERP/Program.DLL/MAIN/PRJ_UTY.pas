unit PRJ_UTY;

interface
uses DataModule_Main, RecChoice, Uty,SysUtils,SysReport_Head;


const stConfirm ='Confirm';
const stUnBook  ='UnBook';

const dbsType:TDatabaseTYPE=SQL;

Function GetClassCode:string;
Function GetSizeCode:string;
Function GetRodCode:string;
Function GetFilmCode:string;
Function GetSortCode:string;
Function GetBoundCode(L:Double=DoubleMin;H:Double=DoubleMax;Power:Double=1.0):string;

Function GetTemperCode:string;
Function GetUserDef1Code:string;
Function GetUserDef2Code:string;
Function GetInvCode:string;
Function GetLocCode(InvCode:string):string;
Function GetReltblCode:string;
Function GetProdBound(ReltblCode:string):string;


implementation


Function GetLocCode(InvCode:string):string;
var GetRec:TWRecChoice;
begin
  DM_MAIN.QryLoc.close;
  DM_MAIN.QryLoc.SQL.Text:='SELECT * FROM TBLINVLOCATOR WHERE INV_CODE='+SqlStr(InvCode);
  DM_MAIN.QryLoc.open;
	GetRec:=TWRecChoice.Create(nil);
  try
    GetRec.DataSet:=DM_MAIN.QryLoc;
    GetRec.ResultField:='LOC_CODE';
    GetRec.AddColunm('LOC_CODE','儲位代碼',100);
    GetRec.AddColunm('LOC_NAME','儲位名稱',200);
    GetRec.Width:=330;
    GetRec.KeyField:='LOC_CODE';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      Result:=GetRec.SelList.Strings[0];
  finally
    DM_MAIN.QryLoc.close;
    GetRec.free;
  end;
end;



Function GetInvCode:string;
var GetRec:TWRecChoice;
begin
  DM_MAIN.QryInv.Open;
	GetRec:=TWRecChoice.Create(nil);
  try
    GetRec.DataSet:=DM_MAIN.QryInv;
    GetRec.ResultField:='INV_CODE';
    GetRec.AddColunm('INV_CODE','庫房代碼',100);
    GetRec.AddColunm('INV_NAME','庫房名稱',200);
    GetRec.Width:=330;
    GetRec.KeyField:='INV_CODE';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      Result:=GetRec.SelList.Strings[0];
  finally
    DM_MAIN.QryINV.close;
    GetRec.free;
  end;
end;


Function GetClassCode:string;
var GetRec:TWRecChoice;
begin
  DM_MAIN.QryClass.Open;
	GetRec:=TWRecChoice.Create(nil);
  try
    GetRec.DataSet:=DM_MAIN.QryClass;
    GetRec.ResultField:='CLS_CODE';
    GetRec.AddColunm('CLS_CODE','類別代碼',100);
    GetRec.AddColunm('CLS_NAME','類別名稱',200);
    GetRec.Width:=330;
    GetRec.KeyField:='CLS_CODE';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      Result:=GetRec.SelList.Strings[0];
  finally
    DM_MAIN.QryClass.close;
    GetRec.free;
  end;
end;

Function GetSizeCode:string;
var GetRec:TWRecChoice;
begin
  DM_MAIN.QrySize.Open;
	GetRec:=TWRecChoice.Create(nil);
  try
    GetRec.DataSet:=DM_MAIN.QrySize;
    GetRec.ResultField:='SIZ_CODE';
    GetRec.AddColunm('SIZ_CODE','尺寸代碼',100);
    GetRec.AddColunm('SIZ_NAME','尺寸名稱',200);
    GetRec.Width:=330;
    GetRec.KeyField:='SIZ_CODE';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      Result:=GetRec.SelList.Strings[0];
  finally
    DM_MAIN.QrySIZE.close;
    GetRec.free;
  end;

end;

Function GetRodCode:string;
var GetRec:TWRecChoice;
begin
  DM_MAIN.QryRod.Open;
	GetRec:=TWRecChoice.Create(nil);
  try
    GetRec.DataSet:=DM_MAIN.QryRod;
    GetRec.ResultField:='ROD_CODE';
    GetRec.AddColunm('ROD_CODE','瓷棒代碼',100);
    GetRec.AddColunm('ROD_NAME','瓷棒名稱',200);
    GetRec.Width:=330;
    GetRec.KeyField:='ROD_CODE';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      Result:=GetRec.SelList.Strings[0];
  finally
    DM_MAIN.QryRod.close;
    GetRec.free;
  end;


end;

Function GetFilmCode:string;
var GetRec:TWRecChoice;
begin
  DM_MAIN.QryFilm.Open;
	GetRec:=TWRecChoice.Create(nil);
  try
    GetRec.DataSet:=DM_MAIN.QryFilm;
    GetRec.ResultField:='FIL_CODE';
    GetRec.AddColunm('FIL_CODE','皮膜代碼',100);
    GetRec.AddColunm('FIL_NAME','皮膜名稱',200);
    GetRec.Width:=330;
    GetRec.KeyField:='FIL_CODE';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      Result:=GetRec.SelList.Strings[0];
  finally
    DM_MAIN.QryFilm.close;
    GetRec.free;
  end;


end;

Function GetSortCode:string;
var GetRec:TWRecChoice;
begin
  DM_MAIN.QrySort.Open;
	GetRec:=TWRecChoice.Create(nil);
  try
    GetRec.DataSet:=DM_MAIN.QrySort;
    GetRec.ResultField:='SRT_CODE';
    GetRec.AddColunm('SRT_CODE','選別乘數代碼',100);
    GetRec.AddColunm('SRT_NAME','選別乘數名稱',100);
    GetRec.AddColunm('SRT_POWER','阻值乘數',100);
    GetRec.Width:=350;
    GetRec.KeyField:='SRT_CODE';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      Result:=GetRec.SelList.Strings[0];
  finally
    DM_MAIN.QrySort.close;
    GetRec.free;
  end;
end;

Function GetBoundCode(L:Double;H:Double;Power:Double):string;
var GetRec:TWRecChoice;
begin
  DM_MAIN.QryBound.Close;
  DM_MAIN.QryBound.SQL.Text:= 'SELECT * FROM TBLBOUND '
                            +' WHERE BND_LOW * '+FLOATTOSTR(power)+' >= '+floattostr(L)
                            +' AND BND_HIGH * '+FLOATTOSTR(power)+' <='+floattostr(H);
  DM_MAIN.QryBound.Open;
	GetRec:=TWRecChoice.Create(nil);
  try
    GetRec.DataSet:=DM_MAIN.QryBound;
    GetRec.ResultField:='BND_CODE';
    GetRec.AddColunm('BND_CODE','阻值範圍代碼',100);
    GetRec.AddColunm('BND_NAME','阻值範圍名稱',100);
    GetRec.AddColunm('BND_LOW','阻值低',60);
    GetRec.AddColunm('BND_HIGH','阻值高',60);
    GetRec.Width:=370;
    GetRec.KeyField:='BND_CODE';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      Result:=GetRec.SelList.Strings[0];
  finally
    DM_MAIN.QryBound.close;
    GetRec.free;
  end;
end;

Function GetTemperCode:string;
var GetRec:TWRecChoice;
begin
  DM_MAIN.QryTemperature.Open;
	GetRec:=TWRecChoice.Create(nil);
  try
    GetRec.DataSet:=DM_MAIN.QryTemperature;
    GetRec.ResultField:='TMT_CODE';
    GetRec.AddColunm('TMT_CODE','溫度係數代碼',100);
    GetRec.AddColunm('TMT_NAME','溫度係數名稱',200);
    GetRec.Width:=330;
    GetRec.KeyField:='TMT_CODE';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      Result:=GetRec.SelList.Strings[0];
  finally
    DM_MAIN.QryTemperature.close;
    GetRec.free;
  end;
end;

Function GetUserDef1Code:string;
var GetRec:TWRecChoice;
begin
  DM_MAIN.QryUserDef1.Open;
	GetRec:=TWRecChoice.Create(nil);
  try
    GetRec.DataSet:=DM_MAIN.QryUserDef1;
    GetRec.ResultField:='UD1_CODE';
    GetRec.AddColunm('UD1_CODE','自訂屬性1代碼',100);
    GetRec.AddColunm('UD1_NAME','自訂屬性1名稱',200);
    GetRec.Width:=330;
    GetRec.KeyField:='UD1_CODE';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      Result:=GetRec.SelList.Strings[0];
  finally
    DM_MAIN.QryUserDef1.close;
    GetRec.free;
  end;

end;

Function GetUserDef2Code:string;
var GetRec:TWRecChoice;
begin
  DM_MAIN.QryUserDef2.Open;
	GetRec:=TWRecChoice.Create(nil);
  try
    GetRec.DataSet:=DM_MAIN.QryUserDef2;
    GetRec.ResultField:='UD2_CODE';
    GetRec.AddColunm('UD2_CODE','自訂屬性2代碼',100);
    GetRec.AddColunm('UD2_NAME','自訂屬性2名稱',200);
    GetRec.Width:=330;
    GetRec.KeyField:='UD2_CODE';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      Result:=GetRec.SelList.Strings[0];
  finally
    DM_MAIN.QryUserDef2.close;
    GetRec.free;
  end;
end;


Function GetReltblCode:string;
var GetRec:TWRecChoice;
begin
  DM_MAIN.QryRel.Open;
	GetRec:=TWRecChoice.Create(nil);
  try
    GetRec.DataSet:=DM_MAIN.QryRel;
    GetRec.ResultField:='REL_CODE';
    GetRec.AddColunm('REL_CODE','發料表格代碼',100);
    GetRec.AddColunm('REL_NAME','發料表格名稱',200);
    GetRec.Width:=330;
    GetRec.KeyField:='REL_CODE';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      Result:=GetRec.SelList.Strings[0];
  finally
    DM_MAIN.QryRel.close;
    GetRec.free;
  end;
end;

Function GetProdBound(ReltblCode:string):string;
var GetRec:TWRecChoice;
begin
  DM_MAIN.QryRelDt.close;
  DM_MAIN.QryRelDT.SQL.Text:='SELECT * FROM TBLRELEASETBLDT WHERE REL_CODE='+SqlStr(RelTblCode)+' ORDER BY RET_PRODBND';
  DM_MAIN.QryRelDT.open;
	GetRec:=TWRecChoice.Create(nil);
  try
    GetRec.DataSet:=DM_MAIN.QryRelDT;
    GetRec.ResultField:='RET_PRODBND';
    GetRec.AddColunm('RET_PRODBND','成品阻值',80);
    GetRec.AddColunm('RET_RELBNDLOW','發料阻值低',100);
    GetRec.AddColunm('RET_RELBNDHIGH','發料阻值高',100);
    GetRec.Width:=330;
    GetRec.KeyField:='RET_PRODBND';
    GetRec.MultiSelect:=FALSE;
    if GetRec.Excute then
      Result:=GetRec.SelList.Strings[0];
  finally
    DM_MAIN.QryRelDT.close;
    GetRec.free;
  end;
end;


end.

unit SysReport_Head;

interface

uses
  Forms, ADODB,Controls,UTY;

const MrPrint=mrYesToAll+100;
const MrPreview=MrPrint+1;
const MrExport=MrPreview+1;

type
  TsrShowSysReportDef   =procedure(adodc:TAdoConnection;dbsType:TDataBaseType);stdcall;
  TsrShowSysReportQuery =procedure (adodc:TAdoConnection;RptCode:string;dbsType:TDataBaseType);stdcall;
//  TsrPrintFormReport    =procedure (adodc:TAdoConnection;RptCode,sqlWhere,SQLOrder: string; PrintMode: TModalResult);stdcall;

  TsrInit               =procedure(app:TApplication); stdcall;
  TsrResApp             =procedure();stdcall;

implementation

end.

unit DLL_Function;

interface

uses
  Windows,SysUtils,Classes,Forms,FORM_ERP_BASE,erp_public;

type
  TsrGet_Main_Form      =  function():TFORM_ERP;stdcall;
  TsrRestoreDllApp      =  procedure();stdcall;
  TsrInit               =  procedure(app:TApplication); stdcall;

  TDllFuncObject = class (TObject)
    private
    public
      DLL_FileName:string;
      DLL_handle:THandle;
      srGet_Main_Form:TsrGet_Main_Form;
      srRestoreDllApp:TsrRestoreDllApp;
      srInit:TsrInit;
      fm_main:TFORM_ERP;
      constructor Create(DllFileName:string;sysinfo:TSysInfo);
  end;

implementation

{ TDllFuncObject }


{ TDllFuncObject }

constructor TDllFuncObject.Create(DllFileName: string;sysinfo:TSysInfo);
begin
  inherited Create;
  DLL_FileName:=DllFileName;

  DLL_handle:=LoadLibrary(PChar(DllFileName));
  if DLL_handle=0 then raise Exception.Create(DllFileName+' Not Found!');
  

  @srInit:=GetProcAddress(DLL_handle, 'init' );
  if @srInit=nil then raise Exception.Create('init() Not Found!');

  @srRestoreDllApp:=GetProcAddress(DLL_handle, 'RestoreDllApp' );
  if @srRestoreDllApp=nil then raise Exception.Create('RestoreDllApp() Not Found!');

  @srGet_Main_Form:=GetProcAddress(DLL_handle, 'Get_Main_Form' );
  if @srGet_Main_Form=nil then raise Exception.Create('Get_Main_Form() Not Found!');

  srInit(Application);
  fm_main:=srGet_Main_Form();
  FM_MAIN.sysinfo:=sysinfo;
  fm_main.init;
end;

end.

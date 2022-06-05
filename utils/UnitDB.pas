unit UnitDB;

interface

uses Windows, System.SysUtils, System.Classes, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

function GetXMLScript(Sender: TObject; XmlID: integer): string;

implementation

uses MainModule, Main;

procedure DebugMsg(const Msg: String);
begin
  OutputDebugString(PChar(Msg + char(10)));
end;

function GetXMLScript(Sender: TObject; XmlID: integer): string;
var
  exeSP: TFDStoredProc;
begin
  DebugMsg('UnitDB.GetXMLScript(Sender,' + IntToStr(XmlID) + ')');
  exeSP := TFDStoredProc.Create(TComponent(Sender));
  exeSP.Connection := UniMainModule.FDConn;
  exeSP.FetchOptions.AutoClose := false;
  exeSP.PackageName := 'DATOS_PRJ.ZULU_SUPPORT';
  exeSP.StoredProcName := 'getFormWrappedInCursor';
  exeSP.Prepare;
  exeSP.ParamByName('pFormID').Value := XmlID;
  exeSP.ParamByName('pLanguage').Value := 'EN';
  exeSP.ParamByName('pClientAppVersion').Value := MainForm.appClientVer;
  exeSP.Open();
  exeSP.First;
  Result := exeSP.FieldByName('SCRIPT').AsString;
  DebugMsg(Result);
end;

end.

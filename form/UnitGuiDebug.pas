unit UnitGuiDebug;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniGUIBaseClasses, uniMemo;

type
  TfrmGuiDebug = class(TUniForm)
    UniMemo1: TUniMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function frmGuiDebug: TfrmGuiDebug;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function frmGuiDebug: TfrmGuiDebug;
begin
  Result := TfrmGuiDebug(UniMainModule.GetFormInstance(TfrmGuiDebug));
end;

end.

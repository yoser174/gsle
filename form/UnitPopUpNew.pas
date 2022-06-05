unit UnitPopUpNew;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm;

type
  TfrmPopUpNew = class(TUniForm)
    procedure UniFormBeforeShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  var
    FORMID, XMLID, PARAM: string;
  end;

function frmPopUpNew: TfrmPopUpNew;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, UnitPopUpForm;

function frmPopUpNew: TfrmPopUpNew;
begin
  Result := TfrmPopUpNew(UniMainModule.GetFormInstance(TfrmPopUpNew));
end;

procedure TfrmPopUpNew.UniFormBeforeShow(Sender: TObject);
begin
  PopUpNewBeforeShow(Sender);
end;

end.

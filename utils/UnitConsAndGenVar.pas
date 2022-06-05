unit UnitConsAndGenVar;

interface

uses System.Classes;

procedure GenerateGenVar(Sender: TObject);

implementation

uses UnitComp, Main, uniGUIApplication;

procedure GenerateGenVar(Sender: TObject);
begin
//  SetCompVarObj(TComponent(Sender), 'USER',
//    UniApplication.Cookies.GetCookie('UserName'));
//  SetCompVarObj(TComponent(Sender), 'MANDANT', MainForm.defLoc);
end;

end.

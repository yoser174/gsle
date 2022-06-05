unit UnitBuildViewRoutes;

interface

uses System.Classes, Forms, Vcl.Controls;

procedure RouteRunBtnClick(Sender: TObject);
procedure RouteRunOnShow(Sender: TObject; XmlId: string);

implementation

uses Main, MainModule, uniGUIForm, UniGUIApplication, UnitPopAnalytComment;

procedure RouteRunBtnClick(Sender: TObject);
var
  Form: TUniForm;
begin
  if (Sender as TComponent).Name = 'PopAnalytComment_btnOK' then
  begin
     BtnOKClick(TUniForm(UniSession.FormsList[UniSession.FormsList.Count - 1]));
     // MainForm.ShowMessage
     // (TUniForm(UniSession.FormsList[UniSession.FormsList.Count - 1]).Name);
  end;

end;

procedure RouteRunOnShow(Sender: TObject; XmlId: string);
begin
  if XmlId = 'F01' then
    RunOnShowF01(Sender);
end;

end.

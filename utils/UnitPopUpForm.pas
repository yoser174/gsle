unit UnitPopUpForm;

interface

uses Windows, System.Types, System.Classes, System.StrUtils, SysUtils,
  System.UITypes, System.Variants, UnitConsAndGenVar;

procedure ShowPopUpForm(AOwner: TComponent; PopUpName: string);
procedure PopUpNewBeforeShow(Sender: TObject);

implementation

uses UniGUIApplication, Main, UnitComp, UnitPopUpNew, UnitBuildView, UniGUIForm,
  UnitDB, XMLIntf, XMLDoc, Xml.xmldom, Xml.Win.msxmldom, Xml.omnixmldom,
  UnitXml, UnitBuildViewRoutes;

procedure DebugMsg(const Msg: String);
begin
  OutputDebugString(PChar(Msg + char(10)));
end;

procedure ShowPopUpForm(AOwner: TComponent; PopUpName: string);
var
  Pop: TfrmPopUpNew;
  ConfStr, SVar1, SVar2, XmlTxt: string;
  TmpStr: TStringDynArray;
  I: integer;
  XmlNd: IXMLNode;
  XmlNdChild: IXMLNode;
  Doc: IXMLDocument;
begin

  Pop := TfrmPopUpNew.Create(UniApplication);
  ConfStr := GetCompVar(PopUpName);
  DebugMsg(ConfStr);
  TmpStr := SplitString(ConfStr, sLineBreak);

  DebugMsg('Get PopUp XML [' + 'POPUPNEW_' + PopUpName + ']');

  XmlTxt := GetCompText('POPUPNEW_' + PopUpName);
  XmlNd := ParseXml(XmlTxt);

  if not VarIsNull(XmlNd.Attributes['ID']) then
    Pop.Name := XmlNd.Attributes['ID'];
  if not VarIsNull(XmlNd.Attributes['TITLE']) then
    Pop.Caption := XmlNd.Attributes['TITLE'];
  if not VarIsNull(XmlNd.Attributes['WIDTH']) then
    Pop.Width := XmlNd.Attributes['WIDTH'];
  if not VarIsNull(XmlNd.Attributes['HEIGHT']) then
    Pop.Height := +XmlNd.Attributes['HEIGHT'];
  if not VarIsNull(XmlNd.Attributes['TOP']) then
    Pop.Top := +XmlNd.Attributes['HEIGHT'];
  if not VarIsNull(XmlNd.Attributes['LEFT']) then
    Pop.Left := +XmlNd.Attributes['LEFT'];

  if not VarIsNull(XmlNd.Attributes['PARAM']) then
    Pop.PARAM := XmlNd.Attributes['PARAM'];
  if not VarIsNull(XmlNd.Attributes['FORMID']) then
    Pop.FORMID := XmlNd.Attributes['FORMID'];
  if not VarIsNull(XmlNd.Attributes['XMLID']) then
    Pop.XMLID := XmlNd.Attributes['XMLID'];

end;

procedure PopUpNewBeforeShow(Sender: TObject);
var
  XmlNode: IXMLNode;
var
  XMlScript: string;
begin
  DebugMsg('PopUpNewBeforeShow');
  try
    XMlScript := GetXMLScript(Sender, TfrmPopUpNew(Sender).XMLID.ToInteger());
    XmlNode := ParseXml(XMlScript);
    if not VarIsNull(XmlNode.Attributes['WIDTH']) then
      TfrmPopUpNew(Sender).Width := XmlNode.Attributes['WIDTH'];
    if not VarIsNull(XmlNode.Attributes['HEIGHT']) then
      TfrmPopUpNew(Sender).Height := +XmlNode.Attributes['HEIGHT'];
    GenerateGenVar(TfrmPopUpNew(Sender));
    BuildView(TComponent(Sender), XmlNode);
    RouteRunOnShow(Sender, XmlNode.Attributes['ID']);
  except
    on E: Exception do
      DebugMsg(E.Message);
  end;
end;

end.

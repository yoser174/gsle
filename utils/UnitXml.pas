unit UnitXml;

interface

uses MSXML, XMLIntf, XMLDoc, Xml.xmldom, Xml.Win.msxmldom, Xml.omnixmldom;

function ParseXml(XmlScript: string): IXMLNode;

implementation

function ParseXml(XmlScript: string): IXMLNode;
var
  Doc: IXMLDocument;
begin
  DefaultDOMVendor := sOmniXmlVendor;
  Doc := TXMLDocument.Create(nil);
  Doc.LoadFromXML(XmlScript);
  Result := Doc.DocumentElement;
end;

end.

unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, Vcl.Menus, uniMainMenu,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, uniGUIBaseClasses, uniButton, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, uniBasicGrid, uniDBGrid,
  uniImageList, uniMultiItem, uniComboBox, uniToolBar, uniTreeView, uniPanel,
  uniLabel, uniPageControl, uniMemo, XMLIntf, XMLDoc, Xml.xmldom,
  Xml.Win.msxmldom, Xml.omnixmldom, UniGUIFrame, UniEdit, UniGroupBox,
  uniDBLookupComboBox, uniDBComboBox, uniCheckBox, StrUtils, Types, uniListBox,
  uniDBListBox, uniDBLookupListBox, uniDateTimePicker, uniHTMLFrame, uniTimer,
  System.Actions, Vcl.ActnList, Vcl.ActnMan;

type
  TMainForm = class(TUniForm)
    mnMain: TUniMainMenu;
    Application1: TUniMenuItem;
    Close1: TUniMenuItem;
    N1: TUniMenuItem;
    Changepassword1: TUniMenuItem;
    exeSP: TFDStoredProc;
    Location1: TUniMenuItem;
    Workplaces1: TUniMenuItem;
    UniPanel1: TUniPanel;
    NavTree: TUniTreeView;
    UniToolBar1: TUniToolBar;
    UniToolButton1: TUniToolButton;
    UniToolButton2: TUniToolButton;
    UniToolButton3: TUniToolButton;
    UniToolButton4: TUniToolButton;
    SearchEdit: TUniComboBox;
    ilMain: TUniNativeImageList;
    UniContainerPanel2: TUniContainerPanel;
    UniPageControl1: TUniPageControl;
    UniTabSheet1: TUniTabSheet;
    DataSource1: TDataSource;
    XMLDoc: TXMLDocument;
    cHeader: TUniContainerPanel;
    lblNav: TUniLabel;
    lblUserLoc: TUniLabel;
    UniPopupMenu1: TUniPopupMenu;
    es1: TUniMenuItem;
    pmTest: TUniPopupMenu;
    EST22221: TUniMenuItem;
    asdsdgfd1: TUniMenuItem;
    asdas1: TUniMenuItem;
    FDQuery1: TFDQuery;
    FDQuery2: TFDQuery;
    FDStoredProc1: TFDStoredProc;
    DataSource2: TDataSource;
    FDStoredProc2: TFDStoredProc;
    FDCommand1: TFDCommand;
    FDSpPrint: TFDStoredProc;
    DataSource3: TDataSource;
    FDQuery3: TFDQuery;
    cHome: TUniContainerPanel;
    btnConvert: TUniButton;
    mmParse: TUniMemo;
    btnRunActionJS: TUniButton;
    UniButton1: TUniButton;
    UniEdit1: TUniEdit;
    UniButton2: TUniButton;
    btnTest: TUniButton;
    UniButton3: TUniButton;
    btnPrint: TUniButton;
    UniLabel2: TUniLabel;
    UniButton4: TUniButton;
    UniButton5: TUniButton;
    UniButton6: TUniButton;
    UniButton7: TUniButton;
    mmLog: TUniMemo;
    mmJS: TUniMemo;
    UniContainerPanel1: TUniContainerPanel;
    FDStoredProc3: TFDStoredProc;
    DataSource4: TDataSource;
    UniDBGrid1: TUniDBGrid;
    ActionList1: TActionList;
    ActBtnClick: TAction;
    Action2: TAction;
    procedure Close1Click(Sender: TObject);
    procedure GetMainMenu(Sender: TObject);
    procedure UniFormBeforeShow(Sender: TObject);
    procedure UniToolButton1Click(Sender: TObject);
    procedure UniToolButton2Click(Sender: TObject);
    procedure UniToolButton4Click(Sender: TObject);
    procedure SearchEditChange(Sender: TObject);
    procedure SearchTree(const AText: string);
    procedure NavTreeClick(Sender: TObject);
    procedure UniTabSheet1Close(Sender: TObject; var AllowClose: Boolean);
    procedure TabSheetClose(Sender: TObject; var AllowClose: Boolean);
    procedure btnConvertClick(Sender: TObject);
    procedure UniFormAjaxEvent(Sender: TComponent; EventName: string;
      Params: TUniStrings);
    procedure btnRunMemoClick(Sender: TObject);
    procedure btnRnJsClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure UniButton4Click(Sender: TObject);
    procedure UniButton5Click(Sender: TObject);
    procedure NavTreeAjaxEvent(Sender: TComponent; EventName: string;
      Params: TUniStrings);
    procedure RunClick(Sender: TObject);
    procedure UniButton2Click(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnRunJSClick(Sender: TObject);
    procedure btnRunActionJSClick(Sender: TObject);
    procedure EST22221Click(Sender: TObject);
    procedure PopUpMenuClick(Sender: TObject);
    procedure FDStoredProc1AfterScroll(DataSet: TDataSet);
    procedure FDSPAfterScroll(DataSet: TDataSet);
    procedure DBGridKeyDownEnter(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PoUpAfterShow(Sender: TObject);
    procedure BtnOnClick(Sender: TObject);
    procedure UniEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditKeyEnter(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure UniDBGrid1CellClick(Column: TUniDBGridColumn);
    procedure mjjnnhjghh(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormClose(Sender: TObject; var Action: TCloseAction);
    procedure ReloadTableClick(Sender: TObject);
    procedure PropertiesTableClick(Sender: TObject);
    procedure GrdColumnResize(Sender: TUniBaseDBGridColumn; NewSize: Integer);
    procedure GridColumnMove(Column: TUniBaseDBGridColumn;
      OldIndex, NewIndex: Integer);
    procedure UniButton6Click(Sender: TObject);
    procedure UniButton7Click(Sender: TObject);

    procedure GridDrawColumnCell(Sender: TObject; ACol, ARow: Integer;
      Column: TUniDBGridColumn; Attribs: TUniCellAttribs);
    procedure cHeaderClick(Sender: TObject);
    procedure ActBtnClickExecute(Sender: TObject);

  private
    { Private declarations }
    PSString, defLocDes, defWorkplaceDesc: string;
    function getCompIfJs(AOwner: TComponent; Text: string;
      CompText: string): String;
    // function BuildPanel(XmlNd: IXMLNode): TUniPanel;
    // function BuildPageControl(XmlNd: IXMLNode): TUniPageControl;
    // function BuildTabSheet(XmlNd: IXMLNode; Pc: TUniPageControl): TUniTabSheet;
    // function BuildGroupBox(XmlNd: IXMLNode; Ts: TUniTabSheet): TUniGroupBox;
    // function BuildEdit(XmlNd: IXMLNode): TUniEdit;
    // function BuildLabel(XmlNd: IXMLNode): TUniLabel;
    // function BuildButton(XmlNd: IXMLNode): TUniButton;
    // function BuildLookup(XmlNd: IXMLNode): TUniDBLookupComboBox;
    // function BuildDate(XmlNd: IXMLNode): TUniDateTimePicker;
    // function BuildCheck(XmlNd: IXMLNode): TUniCheckBox;
    // function BuildContainerPanel(XmlNd: IXMLNode; Ts: TUniTabSheet): TUniPanel;
    // function BuildDBGrid(XmlNd: IXMLNode): TUniDBGrid;
    function BuildPopupMenu(XmlNd: IXMLNode): TUniPopupMenu;
    // procedure BuildQuery(XmlNd: IXMLNode; frName: string);
    // procedure BuildScriptEx(XmlNd: IXMLNode; frName: string);
    // procedure BuildVariable(XmlNd: IXMLNode; frName: string);
    // procedure BuildPopupEx(XmlNd: IXMLNode; frName: string);
    procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings);
    // procedure RunAction(Script: string);
    // procedure RunActionJS(Script: string);
    function GetActiveFormSuffix(): String;

  public
    { Public declarations }
  var
    ActiveFormName, defLoc: string;
    PopRes: Integer;
    FNameList: TStringList;
    FNameIndex: Integer;
    Gr: TUniDBGrid;

  const
    appClientVer = '2.10.00.0103';
  end;

function MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication, UnitPopUp, UnitBuildControls,
  UnitGuiDebug, UnitProperties, UnitBuildViewRoutes, UnitCommons;

procedure TMainForm.PoUpAfterShow(Sender: TObject);
begin
  mmLog.Lines.Add('PoUpAfterShow [' + TfrmPopUp(Sender).Name + ']');
  if TfrmPopUp(Sender).Name = 'F01' then
    RunAction(self, TfrmPopUp(Sender).OnShowRun);
end;

procedure TMainForm.EditKeyEnter(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  CompName, Script: string;
begin
  if Key = VK_RETURN then
  begin
    CompName := (Sender as TComponent).Name;
    Script := GetCompValue(self, CompName + '_ONKEYENTER');
    RunAction(self, Script);
  end;
end;

procedure TMainForm.BtnOnClick(Sender: TObject);
var
  CompName, Script: string;
begin
  CompName := (Sender as TComponent).Name;
  Script := GetCompValue(self, CompName + '_ONCLICK');
  RunAction(self, Script);
end;

procedure TMainForm.ReloadTableClick(Sender: TObject);
var
  GrName: String;
  Co: TComponent;
  Gr: TUniDBGrid;
begin
  GrName := StringReplace(TUniMenuItem(Sender).Name, '_RELOAD', '',
    [rfReplaceAll, rfIgnoreCase]);
  Co := GetCompByNameMain(GrName);
  if Co = Nil then
    Co := GetCompByNamePopUp(GrName);

  if Co = Nil then
    raise Exception.Create('209 ReloadTableClick() FindComponent Failure [' +
      GrName + ']');

  Gr := TUniDBGrid(Co);
  Gr.DataSource.DataSet.Refresh;
end;

procedure TMainForm.PropertiesTableClick(Sender: TObject);
var
  GrName: String;
  Co: TComponent;
  Gr: TUniDBGrid;
begin
  GrName := StringReplace(TUniMenuItem(Sender).Name, '_PROPERTIES', '',
    [rfReplaceAll, rfIgnoreCase]);
  Co := GetCompByNameMain(GrName);
  if Co = Nil then
    Co := GetCompByNamePopUp(GrName);

  if Co = Nil then
    raise Exception.Create('209 PropertiesTableClick() FindComponent Failure ['
      + GrName + ']');

  Gr := TUniDBGrid(Co);
  frmProperties.Gr := Gr;
  // Gr.DataSource.DataSet.Refresh;
  frmProperties.ShowModal;

end;

procedure TMainForm.FDSPAfterScroll(DataSet: TDataSet);
var
  KeyField, KeyFieldValue: string;
begin
  mmLog.Lines.Add('FDSPAfterScroll()' + DataSet.Name);

  /// HARDCODE ROUTINE
  /// TODO: Create Engine
  ///

  try
    if Trim(DataSet.Name) = 'fr5120_qSearchOrder' then
    begin
      KeyField := 'SEQNR';
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'fr5120_seqnr', KeyFieldValue);

      KeyField := UpperCase('auftnr');
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'fr5120_' + KeyField, KeyFieldValue);

      KeyField := UpperCase('patient');
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'fr5120_' + KeyField, KeyFieldValue);

      KeyField := UpperCase('loeschen');
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'fr5120_DelAuf', KeyFieldValue);

      KeyField := UpperCase('aendern');
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'fr5120_UpdAuf', KeyFieldValue);

      KeyField := UpperCase('aktiv');
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'fr5120_vActive', KeyFieldValue);

      KeyField := UpperCase('PatID');
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'fr5120_vPatID', KeyFieldValue);

      RunAction(self, 'scOnOrderScroll.RunScript()');
    end;
    if Trim(DataSet.Name) = 'fr5120_qGetResult' then
    begin

      KeyField := 'NAME';
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'fr5120_name', KeyFieldValue);
      mmLog.Lines.Add('fr5120_qGetResult=' + KeyField + ':' + KeyFieldValue);

      KeyField := 'ANALYTNR';
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'fr5120_analytnr', KeyFieldValue);
      mmLog.Lines.Add('fr5120_qGetResult=' + KeyField + ':' + KeyFieldValue);

      KeyField := 'ANALYTETYPE';
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'fr5120_' + KeyField, KeyFieldValue);
      mmLog.Lines.Add('fr5120_qGetResult=' + KeyField + ':' + KeyFieldValue);

      KeyField := 'RESULT';
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'fr5120_' + KeyField, KeyFieldValue);
      mmLog.Lines.Add('fr5120_qGetResult=' + KeyField + ':' + KeyFieldValue);

      KeyField := 'RESULT_SEQNR';
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'fr5120_' + KeyField, KeyFieldValue);
      mmLog.Lines.Add('fr5120_qGetResult=' + KeyField + ':' + KeyFieldValue);

      KeyField := 'RERUN1VALUE';
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'fr5120_' + KeyField, KeyFieldValue);
      mmLog.Lines.Add('fr5120_qGetResult=' + KeyField + ':' + KeyFieldValue);

      KeyField := 'RERUN2VALUE';
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'fr5120_' + KeyField, KeyFieldValue);
      mmLog.Lines.Add('fr5120_qGetResult=' + KeyField + ':' + KeyFieldValue);

      KeyField := 'RERUN1SEQNR';
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'fr5120_' + KeyField, KeyFieldValue);
      mmLog.Lines.Add('fr5120_qGetResult=' + KeyField + ':' + KeyFieldValue);

      KeyField := 'RERUN2SEQNR';
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'fr5120_' + KeyField, KeyFieldValue);
      mmLog.Lines.Add('fr5120_qGetResult=' + KeyField + ':' + KeyFieldValue);

      KeyField := UpperCase('PrevResReleased');
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'fr5120_' + KeyField, KeyFieldValue);
      mmLog.Lines.Add('fr5120_qGetResult=' + KeyField + ':' + KeyFieldValue);

      KeyField := UpperCase('Einheit');
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'fr5120_' + KeyField, KeyFieldValue);
      mmLog.Lines.Add('fr5120_qGetResult=' + KeyField + ':' + KeyFieldValue);

      KeyField := UpperCase('resupdatenr');
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'fr5120_' + KeyField, KeyFieldValue);
      mmLog.Lines.Add('fr5120_qGetResult=' + KeyField + ':' + KeyFieldValue);

      KeyField := UpperCase('tagupdatenr');
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'fr5120_' + KeyField, KeyFieldValue);
      mmLog.Lines.Add('fr5120_qGetResult=' + KeyField + ':' + KeyFieldValue);

      KeyField := UpperCase('aendern'); // keyfield
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'fr5120_UpdRes', KeyFieldValue);
      mmLog.Lines.Add('fr5120_qGetResult=' + KeyField + ':' + KeyFieldValue);

      KeyField := UpperCase('source');
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'fr5120_' + KeyField, KeyFieldValue);
      mmLog.Lines.Add('fr5120_qGetResult=' + KeyField + ':' + KeyFieldValue);

      KeyField := UpperCase('from_file');
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'fr5120_' + KeyField, KeyFieldValue);
      mmLog.Lines.Add('fr5120_qGetResult=' + KeyField + ':' + KeyFieldValue);

      KeyField := UpperCase('sample_seqnr');
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'fr5120_' + KeyField, KeyFieldValue);
      mmLog.Lines.Add('fr5120_qGetResult=' + KeyField + ':' + KeyFieldValue);

      RunAction(self,
        'qConfidentialAnalyte.Execute();qIsConfidentialResult.Execute();scConfAnalytComments.Runscript();scOnChangeResult.RunScript');
    end;

    if Trim(DataSet.Name) = 'F01_qGetComments' then
    begin
      KeyField := 'comment_rid';
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'F01_rid', KeyFieldValue);
      mmLog.Lines.Add('F01_rid=' + KeyField + ':' + KeyFieldValue);

      KeyField := 'comment_text';
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'F01_vText', KeyFieldValue);
      mmLog.Lines.Add('F01_vText=' + KeyField + ':' + KeyFieldValue);

      KeyField := 'comment_textcode';
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'F01_vTextcode', KeyFieldValue);
      mmLog.Lines.Add('F01_vTextcode=' + KeyField + ':' + KeyFieldValue);

      KeyField := 'comment_internal';
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'F01_vIntern', KeyFieldValue);
      mmLog.Lines.Add('F01_vIntern=' + KeyField + ':' + KeyFieldValue);

      KeyField := 'comment_id';
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'F01_vCommentID', KeyFieldValue);
      mmLog.Lines.Add('F01_vCommentID=' + KeyField + ':' + KeyFieldValue);

      KeyField := 'comment_speccommentid';
      KeyFieldValue := DataSet.FieldByName(KeyField).AsString;
      mmLog.Lines.Add('KeyFieldValue[' + KeyFieldValue + ']');
      SetCompValue(self, 'F01_vSpecCommentId', KeyFieldValue);
      mmLog.Lines.Add('F01_vSpecCommentId=' + KeyField + ':' + KeyFieldValue);
    end;

  except
    on E: Exception do
      MainForm.MessageDlg('299 FDSPAfterScroll:' + E.Message, mtError,
        [mbOk], nil);
  end;
end;

procedure TMainForm.DBGridKeyDownEnter(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key <> 13 then
    exit;

  mmLog.Lines.Add(TComponent(Sender).Name + ' keydown:' + IntToStr(Key));

  if TComponent(Sender).Name = 'fr5120_grResult' then
    RunAction(self, 'scOnKeyEnterResultGrid.RunScript()');

end;

procedure TMainForm.PopUpMenuClick(Sender: TObject);
var
  CompName, Script, OnClick: String;
  Comp: TComponent;
begin
  CompName := (Sender as TComponent).Name;
  Script := GetCompValue(self, CompName + '_ACTION');
  OnClick := SplitString(Script, '|')[0];
  if ContainsText(OnClick, 'ONCLICK:') then
    OnClick := StringReplace(OnClick, 'ONCLICK:', '',
      [rfReplaceAll, rfIgnoreCase]);

  Comp := self.FindComponent(SplitString(CompName, '_')[0]);
  // ShowMessage(Comp.Name);

  // UniSession.AddJS('ajaxRequest(MainForm.form, "_buttonclick" , ["script=' +
  // OnClick + ';"]);');

  RunAction(self, OnClick);

end;

// display initial
procedure TMainForm.GetMainMenu(Sender: TObject);
var
  mnItem: TUniMenuItem;
  defWorkplaceId: string;
  Nd: TUniTreeNode;
  MenuNode: TUniTreeNode;
begin
  exeSP.FetchOptions.AutoClose := false;
  exeSP.PackageName := 'DATOS_PRJ.ZULU_SUPPORT';

  // location
  exeSP.StoredProcName := 'GetAvailableLocations';
  exeSP.Prepare;
  exeSP.ParamByName('pUsername').Value := UniApplication.Cookies.GetCookie
    ('UserName');
  exeSP.Open();
  exeSP.First;
  // set default location name
  defLoc := exeSP.FieldByName('LOCATION').AsString;
  defLocDes := exeSP.FieldByName('BESCHREIBUNG').AsString;
  UniApplication.Cookies.SetCookie('mandant', defLoc);
  while not exeSP.Eof do
  begin
    mnItem := TUniMenuItem.Create(nil);
    mnItem.Caption := exeSP.FieldByName('BESCHREIBUNG').AsString;
    mnItem.Name := exeSP.FieldByName('LOCATION').AsString;
    mnMain.Items.find('Location').Add(mnItem);
    exeSP.Next;
  end;

  // update label
  lblUserLoc.Caption := UniApplication.Cookies.GetCookie('UserName') + ' / ' +
    defLocDes;

  // workplace
  exeSP.StoredProcName := 'GetAvailableWorkplaces';
  exeSP.Prepare;
  exeSP.ParamByName('pUsername').Value := UniApplication.Cookies.GetCookie
    ('UserName');
  exeSP.ParamByName('pLocation').Value := defLoc;
  exeSP.Open();
  exeSP.First;
  defWorkplaceId := exeSP.FieldByName('WORKPLACE_ID').AsString;
  defWorkplaceDesc := exeSP.FieldByName('CAPTION').AsString;
  while not exeSP.Eof do
  begin
    mnItem := TUniMenuItem.Create(nil);
    mnItem.Caption := exeSP.FieldByName('CAPTION').AsString;
    mnItem.Name := 'WP_' + exeSP.FieldByName('START_QUERY_NAME').AsString;
    mnItem.Tag := exeSP.FieldByName('WORKPLACE_ID').AsInteger;
    mnMain.Items.find('Workplaces').Add(mnItem);
    exeSP.Next;
  end;

  // update label
  lblNav.Caption := defWorkplaceDesc;

  // workplace component
  if exeSP.Active then
    exeSP.Active := false;

  exeSP.PackageName := 'DATOS_PRJ.LOCALE_DEPEND';
  exeSP.StoredProcName := 'getWorkplaceComponents';
  exeSP.Prepare;
  exeSP.ParamByName('pWorkplaceID').Value := defWorkplaceId;
  exeSP.ParamByName('pLanguage').Value := 'EN';
  exeSP.Open();
  exeSP.First;

  NavTree.Items.Clear;
  while not exeSP.Eof do
  begin
    MenuNode := NavTree.Items.Add(nil, exeSP.FieldByName('CAPTION').AsString);
    MenuNode.Tag := exeSP.FieldByName('COMPONENT_ID').AsInteger;
    exeSP.Next;
  end;
end;

// --- routine

function TMainForm.GetActiveFormSuffix(): String;
begin
  Result := StringReplace(UniPageControl1.ActivePage.Name, 'ts', 'fr',
    [rfReplaceAll, rfIgnoreCase]);
end;

procedure TMainForm.TabSheetClose(Sender: TObject; var AllowClose: Boolean);
var
  Ts: TUniTabSheet;
  Nd: TUniTreeNode;
begin
  Ts := Sender as TUniTabSheet;
  Nd := Pointer(Ts.Tag);
  if Assigned(Nd) then
  begin
    Nd.Data := nil;
    if NavTree.Selected = Nd then
      NavTree.Selected := nil;
  end;
end;

function RecursiveFindNode(ANode: IXMLNode;
  const SearchNodeName: string): String;
var
  I: Integer;
begin
  if CompareText(ANode.NodeName, SearchNodeName) = 0 then
  begin
    if Assigned(ANode) then
      Result := ANode.Text;
  end
  else if not Assigned(ANode.ChildNodes) then
    Result := ''
  else
  begin
    for I := 0 to ANode.ChildNodes.Count - 1 do
    begin
      Result := RecursiveFindNode(ANode.ChildNodes[I], SearchNodeName);
      if Result <> '' then
        exit;
    end;
  end;
end;
// --

// =============================== Build Action ================================
//
// procedure TMainForm.RunActionJS(Script: string);
// var
// tmpStr, TmpStr0, FrmName: TStringDynArray;
// I, J: Integer;
// STmp0, STmp0_0, STmp1, STmp1_0, STmp2: string;
// B0, B1: Boolean;
// Lb: TUniLabel;
// Ed: TUniEdit;
// Lo: TUniDBLookupComboBox;
// frm: TUniForm;
// begin
// tmpStr := SplitString(Script, ';');
// for I := 0 to length(tmpStr) - 1 do
// begin
// tmpStr[I] := Trim(tmpStr[I]);
// // RUN Script
// if LeftStr(Trim(UpperCase(tmpStr[I])), 4) = 'RUN(' then
// begin
// TmpStr0 := SplitString(tmpStr[I], '''');
// STmp0 := TmpStr0[1];
// RunAction(Self, STmp0);
// end
// else if ContainsText(tmpStr[I], '=') then
// begin
// // set value
// TmpStr0 := SplitString(tmpStr[I], '=');
// STmp0 := Trim(TmpStr0[0]);
// STmp1 := Trim(TmpStr0[1]);
// if ContainsText(STmp0, '.') then
// begin
// STmp0_0 := SplitString(STmp0, '.')[1];
// STmp0 := SplitString(STmp0, '.')[0];
// end;
// if ContainsText(STmp1, '.') then
// begin
// STmp1_0 := SplitString(STmp1, '.')[1];
// STmp1 := SplitString(STmp1, '.')[0];
// end;
//
// // jika COMPONENT.value = COMPONENT.value
// if (UpperCase(STmp0_0) = 'VALUE') and (UpperCase(STmp1_0) = 'VALUE') then
// begin
// tmpStr[I] := 'MainForm.' + STmp0 + '.setText(MainForm.' + STmp1 +
// '.getText());';
// // find component
// B0 := false;
// B1 := false;
//
// // label
// if LeftStr(STmp0, 1) = 'V' then
// begin
// for J := 0 to ComponentCount - 1 do
// begin
// if Components[J] is TUniLabel then
// begin
// Lb := TUniLabel(Components[J]);
// if UpperCase(Lb.Name) = UpperCase(GetActiveFormSuffix) + '_' +
// UpperCase(STmp0) then
// begin
// STmp0 := 'MainForm.' + Lb.Name + '.setText';
// B0 := True;
// end;
// end;
// end;
// end
// else
// // Edit
// if LeftStr(STmp0, 2) = 'ED' then
// begin
// for J := 0 to ComponentCount - 1 do
// if Components[J] is TUniEdit then
// begin
// Ed := TUniEdit(Components[J]);
// if UpperCase(Ed.Name) = UpperCase(STmp0) then
// begin
// STmp0 := 'MainForm.' + Ed.Name + '.setValue';
// B0 := True;
// end;
// end;
// end;
//
// // -------------- Param 2 ----------------
//
// if LeftStr(STmp1, 2) = 'ED' then
// begin
// for J := 0 to ComponentCount - 1 do
// if Components[J] is TUniEdit then
// begin
// Ed := TUniEdit(Components[J]);
// if UpperCase(Ed.Name) = UpperCase(STmp1) then
// begin
// STmp1 := 'MainForm.' + Ed.Name + '.getValue';
// B1 := True;
// end;
// end;
// end
// else if LeftStr(STmp1, 2) = 'LO' then
// begin
// for J := 0 to ComponentCount - 1 do
// if Components[J] is TUniDBLookupComboBox then
// begin
// Lo := TUniDBLookupComboBox(Components[J]);
// if UpperCase(Lo.Name) = UpperCase(STmp1) then
// begin
// STmp1 := 'MainForm.' + Lo.Name + '.getValue';
// B1 := True;
// end;
// end;
// end;
//
// if B0 and B1 then
// begin
// UniSession.AddJS(STmp0 + '(' + STmp1 + ');');
// tmpStr[I] := STmp0 + '(' + STmp1 + ');';
// end
// else
// ShowMessage('Not Found:' + STmp0 + ':' + STmp1);
// // UniSession.AddJS(tmpStr[I]);
// end;
// end;
//
// end;
// end;
//
// procedure TMainForm.RunAction(Script: string);
// var
// jsScript, FrmName, ParamName, Line: string;
// I, J, K, L: Integer;
// tmpStr, TmpStr0: TStringDynArray;
// Ed: TUniEdit;
// Lo: TUniDBLookupComboBox;
// Lb: TUniLabel;
// Mm: TUniMemo;
// Bt: TUniButton;
// Da: TUniDateTimePicker;
// Q: TFDStoredProc;
// Qr: TFDQuery;
// Pop: TfrmPopUp;
// begin
// FrmName := UniPageControl1.ActivePage.Name;
// FrmName := StringReplace(FrmName, 'ts', 'fr', [rfReplaceAll, rfIgnoreCase]);
//
// Script := StringReplace(Script, '&apos;', '''', [rfReplaceAll, rfIgnoreCase]);
// tmpStr := SplitString(Script, ';');
//
// for I := 0 to length(tmpStr) - 1 do
// begin
// tmpStr[I] := Trim(tmpStr[I]);
//
// // POP UP window
// if UpperCase(LeftStr(tmpStr[I], 3)) = 'POP' then
// begin
// TmpStr0 := SplitString(tmpStr[I], '.');
// for J := 0 to ComponentCount - 1 do
// if Components[J] is TUniMemo then
// begin
// Mm := TUniMemo(Components[J]);
// if UpperCase(Mm.Name) = UpperCase(GetActiveFormSuffix) + '_' +
// UpperCase(TmpStr0[0]) then
// begin
// // ketemu
// Pop := TfrmPopUp.Create(UniApplication);
// for K := 0 to Mm.Lines.Count - 1 do
// begin
// Line := Mm.Lines.Strings[K];
// if SplitString(Line, '=')[0] = 'ID' then
// Pop.Name := SplitString(Line, '=')[1];
// if SplitString(Line, '=')[0] = 'TITLE' then
// Pop.Caption := SplitString(Line, '=')[1];
// if SplitString(Line, '=')[0] = 'FORMID' then
// Pop.FORMID := StrToInt(SplitString(Line, '=')[1]);
// if SplitString(Line, '=')[0] = 'XMLID' then
// Pop.XMLID := StrToInt(SplitString(Line, '=')[1]);
// if SplitString(Line, '=')[0] = 'PARAM' then
// Pop.Param := SplitString(Line, '=')[1];
// if SplitString(Line, '=')[0] = 'WIDTH' then
// Pop.Width := StrToInt(SplitString(Line, '=')[1]);
// if SplitString(Line, '=')[0] = 'HEIGHT' then
// Pop.Height := StrToInt(SplitString(Line, '=')[1]);
// if SplitString(Line, '=')[0] = 'TOP' then
// Pop.Top := StrToInt(SplitString(Line, '=')[1]);
// if SplitString(Line, '=')[0] = 'LEFT' then
// Pop.Left := StrToInt(SplitString(Line, '=')[1]);
//
// end;
// Pop.ShowModal;
// end;
// end;
//
// end;
//
// // cek Edit Box
// if UpperCase(LeftStr(tmpStr[I], 2)) = 'ED' then
// begin
// TmpStr0 := SplitString(tmpStr[I], '.');
// for J := 0 to ComponentCount - 1 do
// if Components[J] is TUniEdit then
// begin
// Ed := TUniEdit(Components[J]);
// if UpperCase(Ed.Name) = UpperCase(TmpStr0[0]) then
// begin
// // Clear field
// if TmpStr0[1] = 'Clear' then
// Ed.Clear;
// // Enable edit
// if TmpStr0[1] = 'enable()' then
// Ed.Enabled := True;
// // Set Focus
// if Trim(TmpStr0[1]) = 'SetFocus' then
// Ed.SetFocus;
//
// end;
// end;
// end;
//
// // cek Lookup Box
// if UpperCase(LeftStr(tmpStr[I], 2)) = 'LO' then
// begin
// TmpStr0 := SplitString(tmpStr[I], '.');
// for J := 0 to ComponentCount - 1 do
// if Components[J] is TUniDBLookupComboBox then
// begin
// Lo := TUniDBLookupComboBox(Components[J]);
// if UpperCase(Lo.Name) = UpperCase(TmpStr0[0]) then
// begin
// // Clear field
// if TmpStr0[1] = 'Clear' then
// Lo.Clear;
// // Enable edit
// if TmpStr0[1] = 'enable()' then
// Lo.Enabled := True;
//
// // Set Value
// if LeftStr(TmpStr0[1], 4) = 'Set(' then
// begin
// ParamName :=
// UpperCase(SplitString(SplitString(TmpStr0[1], '(')[1], ')')[0]);
//
// if ParamName = UpperCase('mandant') then
// begin
// Lo.Text := UniApplication.Cookies.GetCookie('mandant');
// end;
//
// // for K := 0 to ComponentCount - 1 do
// // if Components[K] is TUniDBLookupComboBox then
// // begin
// // if Components[K].Name = ParamName then
// // begin
// // Lb := TUniLabel(Components[K]);
// // mm3.Lines.Add(Lb.Name);
// // mm3.Lines.Add(Lb.Caption);
// // Da.DateTime := StrToDateTime(Lb.Caption);
// // end;
// // end;
// end;
//
// end;
// end;
// end;
//
// // cek Button
// if UpperCase(LeftStr(tmpStr[I], 2)) = 'BU' then
// begin
// TmpStr0 := SplitString(tmpStr[I], '.');
// for J := 0 to ComponentCount - 1 do
// if Components[J] is TUniButton then
// begin
// Bt := TUniButton(Components[J]);
// if UpperCase(Bt.Name) = UpperCase(TmpStr0[0]) then
// begin
// // Clear field
// if TmpStr0[1] = 'disable()' then
// Bt.Enabled := false;
// // Enable edit
// if TmpStr0[1] = 'enable()' then
// Bt.Enabled := True;
//
// end;
// end;
// end;
//
// // cek Datetime picker
// if UpperCase(LeftStr(tmpStr[I], 2)) = 'DA' then
// begin
// TmpStr0 := SplitString(tmpStr[I], '.');
// for J := 0 to ComponentCount - 1 do
// if Components[J] is TUniDateTimePicker then
// begin
// Da := TUniDateTimePicker(Components[J]);
// if UpperCase(Da.Name) = UpperCase(TmpStr0[0]) then
// begin
// // Clear field
// if TmpStr0[1] = 'disable()' then
// Da.Enabled := false;
// // Enable edit
// if TmpStr0[1] = 'enable()' then
// Da.Enabled := True;
//
// // Set Value
// if LeftStr(TmpStr0[1], 4) = 'Set(' then
// begin
// ParamName :=
// UpperCase(SplitString(SplitString(Script, '(')[1], ')')[0]);
// for K := 0 to ComponentCount - 1 do
// if Components[K] is TUniLabel then
// begin
// if Components[K].Name = ParamName then
// begin
// Lb := TUniLabel(Components[K]);
// Da.DateTime := StrToDateTime(Lb.Caption);
// end;
// end;
// end;
// end;
// end;
//
// end;
//
// // cek Query
// if UpperCase(LeftStr(tmpStr[I], 1)) = 'Q' then
// begin
// TmpStr0 := SplitString(tmpStr[I], '.');
// for J := 0 to ComponentCount - 1 do
// if Components[J] is TFDStoredProc then
// begin
// Q := TFDStoredProc(Components[J]);
// if UpperCase(Q.Name) = UpperCase('SP_' + TmpStr0[0]) then
// begin
// // Execute
// if TmpStr0[1] = 'execute' then
// begin
// // mm2.Lines.Add('Execute.');
// end;
// end;
// end;
// // Query
// for J := 0 to ComponentCount - 1 do
// if Components[J] is TFDQuery then
// begin
// Qr := TFDQuery(Components[J]);
// if UpperCase(Qr.Name) = UpperCase('SP_' + TmpStr0[0]) then
// begin
// // Execute
// if TmpStr0[1] = 'execute' then
// begin
// if Qr.Active then
// Qr.Active := false;
// Qr.Prepare;
// Qr.ExecSQL;
// for K := 0 to Qr.ParamCount - 1 do
// begin
// if True then
// begin
// Qr.Params[K].ParamType := ptOutput;
// // find variable
// for L := 0 to ComponentCount - 1 do
// if Components[L] is TUniLabel then
// begin
// // temukan variabel isi nilai nya
// if Components[L].Name = Qr.Params[K].Name then
// begin
// Lb := TUniLabel(Components[L]);
// if Qr.Params[K].DataType = ftDateTime then
// Lb.Caption := DateTimeToStr(Qr.Params[K].Value);
// end;
// end;
// end;
// end;
//
// end;
// end;
// end;
// end;
//
// // Script Action
// if UpperCase(LeftStr(tmpStr[I], 1)) = 'S' then
// begin
// TmpStr0 := SplitString(tmpStr[I], '.');
// for J := 0 to ComponentCount - 1 do
// if Components[J] is TUniMemo then
// begin
// Mm := TUniMemo(Components[J]);
// if UpperCase(Mm.Name) = UpperCase(FrmName + '_' + TmpStr0[0]) then
// begin
// if TmpStr0[1] = 'RunScript' then
// begin
// // Run Script Action
// if Mm.Tag = 1 then
// RunActionJS(Mm.Lines.Text)
// else
// RunAction(Mm.Lines.Text);
// end;
// end;
// end;
// end;
//
// end; // loop
//
// end;


// =============================== Build Component =============================

// ScriptEx
// procedure TMainForm.BuildScriptEx(XmlNd: IXMLNode; frName: string);
// var
// Mm: TUniMemo;
// Script: string;
// OuterRoot: IXMLNode;
// begin
// Mm := TUniMemo.Create(Self);
// Mm.Name := frName + '_' + XmlNd.Attributes['ID'];
// Mm.Tag := 0;
// if not VarIsNull(XmlNd.Attributes['JS']) then
// begin
// Mm.Tag := 1;
// Script := '';
// if VarIsNull(XmlNd.Attributes['DYNAMIC']) then
// begin
// if XmlNd.Attributes['JS'] = 'Y' then
// begin
// if XmlNd.nodeType = ntText then
// Script := XmlNd.NodeValue
// else if not VarIsNull(XmlNd.ChildNodes.Get(0).NodeValue) then
// Script := XmlNd.ChildNodes.Get(0).NodeValue;
// end;
// end;
//
// Mm.Lines.Text := Script;
// end;
// if Mm.Tag = 0 then
// Mm.Lines.Text := XmlNd.NodeValue;
// Mm.Visible := false;
// end;

// VARIABEL
// procedure TMainForm.BuildVariable(XmlNd: IXMLNode; frName: string);
// var
// Lb: TUniLabel;
// begin
// Lb := TUniLabel.Create(Self);
// Lb.Name := frName + '_' + XmlNd.Attributes['ID'];
// Lb.Caption := '';
// if not VarIsNull(XmlNd.Attributes['DEF']) then
// Lb.Caption := XmlNd.Attributes['DEF'];
//
// Lb.Visible := false;
// end;

/// / Pop Up From
// procedure TMainForm.BuildPopupEx(XmlNd: IXMLNode; frName: string);
// var
// Mm: TUniMemo;
// I: Integer;
// SChild: String;
// begin
// Mm := TUniMemo.Create(Self);
// Mm.Name := frName + '_' + XmlNd.Attributes['ID'];
// Mm.Lines.Add('ID=' + XmlNd.Attributes['ID']);
// if not VarIsNull(XmlNd.Attributes['TITLE']) then
// Mm.Lines.Add('TITLE=' + XmlNd.Attributes['TITLE']);
// if not VarIsNull(XmlNd.Attributes['PARAM']) then
// Mm.Lines.Add('PARAM=' + XmlNd.Attributes['PARAM']);
// if not VarIsNull(XmlNd.Attributes['FORMID']) then
// Mm.Lines.Add('FORMID=' + XmlNd.Attributes['FORMID']);
// if not VarIsNull(XmlNd.Attributes['XMLID']) then
// Mm.Lines.Add('XMLID=' + XmlNd.Attributes['XMLID']);
// if not VarIsNull(XmlNd.Attributes['WIDTH']) then
// Mm.Lines.Add('WIDTH=' + XmlNd.Attributes['WIDTH']);
// if not VarIsNull(XmlNd.Attributes['HEIGHT']) then
// Mm.Lines.Add('HEIGHT=' + XmlNd.Attributes['HEIGHT']);
// if not VarIsNull(XmlNd.Attributes['LEFT']) then
// Mm.Lines.Add('LEFT=' + XmlNd.Attributes['LEFT']);
// if not VarIsNull(XmlNd.Attributes['NLS_TITLE']) then
// Mm.Lines.Add('NLS_TITLE=' + XmlNd.Attributes['NLS_TITLE']);
// SChild := '';
//
// for I := 0 to XmlNd.ChildNodes.Count - 1 do
// begin
// if XmlNd.ChildNodes[I].NodeName = 'Variable' then
// begin
// SChild := 'VAR_' + XmlNd.ChildNodes[I].Attributes['ID'];
// if not VarIsNull(XmlNd.Attributes['TYPE']) then
// SChild := SChild + ';TYPE=' + XmlNd.ChildNodes[I].Attributes['TYPE'];
// if not VarIsNull(XmlNd.Attributes['KEYFIELD']) then
// SChild := SChild + ';KEYFIELD=' + XmlNd.ChildNodes[I].Attributes
// ['KEYFIELD'];
// if not VarIsNull(XmlNd.Attributes['LINKID']) then
// SChild := SChild + ';LINKID=' + XmlNd.ChildNodes[I].Attributes
// ['LINKID'];
// Mm.Lines.Add(SChild);
// end;
// end;
//
// Mm.Visible := false;
// end;

procedure TMainForm.FDStoredProc1AfterScroll(DataSet: TDataSet);
begin

end;

// QUERY
// procedure TMainForm.BuildQuery(XmlNd: IXMLNode; frName: string);
// var
// FdSP: TFDStoredProc;
// Ds: TDataSource;
// FdQ: TFDQuery;
// Script, PackageName, StoredProcName, STmp, sTmpPar: string;
// OutPutList: TStringList;
// List, Param, TmpList: TStringDynArray;
// QParam: TFDParam;
// Lb: TUniLabel;
// I, J: Integer;
// begin
//
// if XmlNd.nodeType = ntText then
// Script := XmlNd.NodeValue
// else
// Script := XmlNd.ChildNodes.Get(0).NodeValue;
//
// Script := StringReplace(Script, '{', '', [rfReplaceAll, rfIgnoreCase]);
// Script := StringReplace(Script, '}', '', [rfReplaceAll, rfIgnoreCase]);
// Script := StringReplace(Script, '=', ':=', [rfReplaceAll, rfIgnoreCase]);
// Script := StringReplace(Script, 'call', '', [rfReplaceAll, rfIgnoreCase]);
//
// if ContainsText(Script, '=') then
// begin
// // ------------- query call -----------------
//
// FdQ := TFDQuery.Create(Self);
// FdQ.Connection := UniMainModule.FDConn;
// with FdQ.SQL do
// begin
// Clear;
// Add('begin');
// Add('  ' + Script + ';');
// Add('end;');
// end;
// FdQ.Name := 'SP_' + XmlNd.Attributes['ID'];
//
// for I := 0 to XmlNd.ChildNodes.Count - 1 do
// begin
// if XmlNd.ChildNodes[I].NodeName = 'Variable' then
// begin
// FdQ.ParamByName(UpperCase(XmlNd.ChildNodes[I].Attributes['ID']))
// .AsDateTime := Now;
//
// // jika output buat label
// if XmlNd.ChildNodes[I].Attributes['DIR'] = 'RETURN' then
// begin
// FdQ.ParamByName(UpperCase(XmlNd.ChildNodes[I].Attributes['ID']))
// .ParamType := ptOutput;
// Lb := TUniLabel.Create(Self);
// Lb.Name := UpperCase(XmlNd.ChildNodes[I].Attributes['ID']);
// Lb.Caption := '';
// Lb.Visible := false;
// end;
// end;
// end;
//
// end
// else
// begin
// // -------- package call ---
//
// // PackageName
// TmpList := SplitString(SplitString(Script, '.')[0], ' ');
// PackageName := TmpList[length(TmpList) - 1];
// PackageName := 'datos_prj.' + PackageName;
//
// // StoredProcName
// TmpList := SplitString(SplitString(Script, '.')[1], ' ');
// StoredProcName := SplitString(TmpList[0], '(')[0];
//
// // param string
// TmpList := SplitString(Script, '(');
// sTmpPar := SplitString(TmpList[1], ')')[0];
//
// // cek
// if Pos(',', sTmpPar) = 0 then
// begin
//
// // satu param saja
// STmp := StringReplace(sTmpPar, '&apos;', '',
// [rfReplaceAll, rfIgnoreCase]);
// STmp := StringReplace(sTmpPar, '''', '', [rfReplaceAll, rfIgnoreCase]);
//
// // koneksi
// Ds := TDataSource.Create(Self);
// Ds.Name := 'DS_' + XmlNd.Attributes['ID'];
// FdSP := TFDStoredProc.Create(Self);
// FdSP.Name := 'SP_' + XmlNd.Attributes['ID'];
// FdSP.Connection := UniMainModule.FDConn;
/// /      UniDBGrid1.DataSource := Ds;
// Ds.DataSet := FdSP;
// FdSP.PackageName := PackageName;
// FdSP.StoredProcName := StoredProcName;
// FdSP.Prepare;
// STmp := Trim(STmp);
// FdSP.Params[1].Value := STmp;
//
// // cari nilai
// if LeftStr(STmp, 1) = ':' then
// begin
// STmp := StringReplace(sTmpPar, ':', '', [rfReplaceAll, rfIgnoreCase]);
// for J := 0 to ComponentCount - 1 do
// if Components[J] is TUniLabel then
// begin
// if Components[J].Name = frName + '_' + Trim(STmp) then
// begin
// Lb := TUniLabel(Components[J]);
// FdSP.Params[1].Value := Lb.Caption;
// end;
// end;
// end;
//
// FdSP.Open();
// end
// else
// begin
//
// // lebih dari satu param
// STmp := StringReplace(sTmpPar, '&apos;', '',
// [rfReplaceAll, rfIgnoreCase]);
// STmp := StringReplace(sTmpPar, '''', '', [rfReplaceAll, rfIgnoreCase]);
// TmpList := SplitString(STmp, ',');
//
// // koneksi
// Ds := TDataSource.Create(Self);
// Ds.Name := 'DS_' + XmlNd.Attributes['ID'];
// FdSP := TFDStoredProc.Create(Self);
// FdSP.Name := 'SP_' + XmlNd.Attributes['ID'];
// FdSP.Connection := UniMainModule.FDConn;
// Ds.DataSet := FdSP;
// FdSP.PackageName := PackageName;
// FdSP.StoredProcName := StoredProcName;
// FdSP.Prepare;
// for I := 0 to length(TmpList) - 1 do
// begin
// if Trim(TmpList[I]) = ':user' then
// begin
// // TmpList[I] := QuotedStr(UniApplication.Cookies.GetCookie('UserName'));
// FdSP.Params[I + 1].Value :=
// Trim(UniApplication.Cookies.GetCookie('UserName'));
// end
//
// else if UpperCase(Trim(TmpList[I])) <> 'NULL' then
// begin
// FdSP.Params[I + 1].Value := Trim(TmpList[I]);
// end;
// end;
//
// FdSP.Open();
//
/// /      for I := 0 to FdSP.ParamCount - 1 do
/// /      begin
/// /        // setup Output Param
/// /        mm3.Lines.Add(FdSP.Params[I].Name + '=>' +
/// /          VarToStr(FdSP.Params[I].Value));
/// /        if FdSP.Params[I].ParamType = ptOutput then
/// /          mm3.Lines.Add('Output');
/// /
/// /      end;
// end;
// end;
// end;

// MENU
function TMainForm.BuildPopupMenu(XmlNd: IXMLNode): TUniPopupMenu;
var
  Pm: TUniPopupMenu;
  Mi: TUniMenuItem;
  I: Integer;
begin
  Pm := TUniPopupMenu.Create(self);
  Pm.Name := XmlNd.Attributes['TYPE'] + XmlNd.Attributes['PARAM'];
  for I := 0 to XmlNd.ChildNodes.Count - 1 do
  begin
    // Buat LooupDBComboBox
    if XmlNd.ChildNodes[I].NodeName = 'MenuEx' then
    begin
      Mi := TUniMenuItem.Create(self);
      Mi.Name := XmlNd.ChildNodes[I].Attributes['LINKID'];
      Mi.Caption := XmlNd.ChildNodes[I].Attributes['INAME'];
      Pm.Items.Add(Mi);
    end;
  end;
  Result := Pm;
end;

procedure TMainForm.cHeaderClick(Sender: TObject);
begin

end;

/// / DB GRID
// function TMainForm.BuildDBGrid(XmlNd: IXMLNode): TUniDBGrid;
// var
// Gr: TUniDBGrid;
// I: Integer;
// begin
// Gr := TUniDBGrid.Create(Self);
// Gr.Name := XmlNd.Attributes['ID'];
// if not VarIsNull(XmlNd.Attributes['TOP']) then
// Gr.Top := XmlNd.Attributes['TOP'];
// if not VarIsNull(XmlNd.Attributes['LEFT']) then
// Gr.Left := StrToInt(XmlNd.Attributes['LEFT']);
// if not VarIsNull(XmlNd.Attributes['WIDTH']) then
// Gr.Width := StrToInt(XmlNd.Attributes['WIDTH']);
//
// for I := 0 to XmlNd.ChildNodes.Count - 1 do
// begin
// // Buat LooupDBComboBox
// if XmlNd.ChildNodes[I].NodeName = 'MenuEx' then
// begin
// // Gr.InsertControl(BuildLookup(XmlNd.ChildNodes[I]));
// end;
// end;
// // add JS script
// Gr.ClientEvents.ExtEvents.Values['mousedown'] :=
// 'function mousedown(sender, x, y, eOpts) ' +
// '{  ajaxRequest(MainForm.form, ' + QuotedStr('_contextmenu') + ', [' +
// QuotedStr('x=') + '+x, ' + QuotedStr('y=') + '+y, ' +
// QuotedStr('name=' + Gr.Name) + ']); }';
// Gr.ClientEvents.Enabled := True;
//
// Gr.Align := alClient;
//
// Result := Gr;
// end;

/// / PANEL CHILD
// function TMainForm.BuildContainerPanel(XmlNd: IXMLNode; Ts: TUniTabSheet)
// : TUniPanel;
// var
// Pn: TUniPanel;
// I: Integer;
// begin
// Pn := TUniPanel.Create(Ts);
// Pn.Parent := Ts;
// if XmlNd.Attributes['ALIGN'] = 'Top' then
// begin
// Pn.Align := alTop;
// if not VarIsNull(XmlNd.Attributes['HEIGHT']) then
// Pn.Height := StrToInt(XmlNd.Attributes['HEIGHT']) + 10;
// end;
// if XmlNd.Attributes['ALIGN'] = 'Client' then
// Pn.Align := alClient;
//
// for I := 0 to XmlNd.ChildNodes.Count - 1 do
// begin
// // Buat LooupDBComboBox
// if XmlNd.ChildNodes[I].NodeName = 'Lookup' then
// begin
// Pn.InsertControl(BuildLookup(Self, XmlNd.ChildNodes[I]));
// end;
// // Buat DBGrid
// if XmlNd.ChildNodes[I].NodeName = 'ExpGrid' then
// begin
// Pn.InsertControl(BuildDBGrid(Self, XmlNd.ChildNodes[I]));
// end;
// end;
//
// Result := Pn;
// end;

/// / CHECKBOX
// function TMainForm.BuildCheck(XmlNd: IXMLNode): TUniCheckBox;
// var
// Cb: TUniCheckBox;
// begin
// Cb := TUniCheckBox.Create(Self);
// Cb.Name := XmlNd.Attributes['ID'];
// if not VarIsNull(XmlNd.Attributes['LABEL']) then
// Cb.Caption := XmlNd.Attributes['LABEL'];
//
// if not VarIsNull(XmlNd.Attributes['TOP']) then
// Cb.Top := XmlNd.Attributes['TOP'];
// if not VarIsNull(XmlNd.Attributes['LEFT']) then
// Cb.Left := StrToInt(XmlNd.Attributes['LEFT']);
// if not VarIsNull(XmlNd.Attributes['WIDTH']) then
// Cb.Width := StrToInt(XmlNd.Attributes['WIDTH']);
//
// if not VarIsNull(XmlNd.Attributes['CAPTION']) then
// begin
// Cb.FieldLabel := XmlNd.Attributes['CAPTION'];
// Cb.FieldLabelWidth := 60;
// Cb.Left := Cb.Left - 60;
// end;
//
// if not VarIsNull(XmlNd.Attributes['ENABLE']) then
// begin
// if XmlNd.Attributes['ENABLE'] = 'Y' then
// Cb.Enabled := True
// Else
// Cb.Enabled := false;
// end;
// Result := Cb;
// end;

/// / BUTTON
// function TMainForm.BuildLookup(XmlNd: IXMLNode): TUniDBLookupComboBox;
// var
// Lcb: TUniDBLookupComboBox;
// CutOff, I: Integer;
// Ds, TmpDs: TDataSource;
// begin
// CutOff := 80;
//
// if length(XmlNd.Attributes['CAPTION']) <= 5 then
// CutOff := 30;
//
// if length(XmlNd.Attributes['CAPTION']) > 10 then
// CutOff := 90;
//
// Lcb := TUniDBLookupComboBox.Create(Self);
// Lcb.Name := XmlNd.Attributes['ID'];
// Lcb.Caption := XmlNd.Attributes['CAPTION'];
// Lcb.FieldLabel := XmlNd.Attributes['CAPTION'];
// Lcb.FieldLabelWidth := CutOff;
// if not VarIsNull(XmlNd.Attributes['TOP']) then
// Lcb.Top := XmlNd.Attributes['TOP'];
// if not VarIsNull(XmlNd.Attributes['LEFT']) then
// Lcb.Left := StrToInt(XmlNd.Attributes['LEFT']) - CutOff;
// if not VarIsNull(XmlNd.Attributes['WIDTH']) then
// Lcb.Width := StrToInt(XmlNd.Attributes['WIDTH']) + CutOff - 10;
// if not VarIsNull(XmlNd.Attributes['ALIGNMENT']) then
// if XmlNd.Attributes['ALIGNMENT'] = 'Left' then
// Lcb.Alignment := taLeftJustify;
// if XmlNd.Attributes['ALIGNMENT'] = 'Right' then
// Lcb.Alignment := taRightJustify;
// if not VarIsNull(XmlNd.Attributes['ENABLE']) then
// begin
// if XmlNd.Attributes['ENABLE'] = 'Y' then
// Lcb.Enabled := True
// Else
// Lcb.Enabled := false;
// end;
//
// Lcb.KeyField := XmlNd.Attributes['LKEY'];
// if True then
//
// begin
// for I := 0 to ComponentCount - 1 do
// if Components[I] is TDataSource then
// begin
// TmpDs := TDataSource(Components[I]);
// if TmpDs.Name = 'DS_' + XmlNd.Attributes['LOOKID'] then
// begin
// Lcb.ListSource := TmpDs;
// end;
// end;
// end;
// Result := Lcb;
//
// end;

/// / BUTTON
// function TMainForm.BuildButton(XmlNd: IXMLNode): TUniButton;
// var
// Bt: TUniButton;
// begin
// Bt := TUniButton.Create(Self);
// Bt.Name := XmlNd.Attributes['ID'];
// Bt.Caption := XmlNd.Attributes['CAPTION'];
// if not VarIsNull(XmlNd.Attributes['TOP']) then
// Bt.Top := XmlNd.Attributes['TOP'];
// if not VarIsNull(XmlNd.Attributes['LEFT']) then
// Bt.Left := StrToInt(XmlNd.Attributes['LEFT']);
// if not VarIsNull(XmlNd.Attributes['WIDTH']) then
// Bt.Width := StrToInt(XmlNd.Attributes['WIDTH']);
// if not VarIsNull(XmlNd.Attributes['ALIGNMENT']) then
// if XmlNd.Attributes['ALIGNMENT'] = 'Left' then
// Bt.Alignment := taLeftJustify;
// if XmlNd.Attributes['ALIGNMENT'] = 'Right' then
// Bt.Alignment := taRightJustify;
// if not VarIsNull(XmlNd.Attributes['HINT']) then
// begin
// Bt.Hint := XmlNd.Attributes['HINT'];
// Bt.ShowHint := True;
// end;
// if not VarIsNull(XmlNd.Attributes['ENABLE']) then
// begin
// if XmlNd.Attributes['ENABLE'] = 'Y' then
// Bt.Enabled := True
// Else
// Bt.Enabled := false;
// end;
//
// if (Bt.Name = 'buNew') or (Bt.Name = 'buPatient') then
// begin
// Bt.ClientEvents.ExtEvents.Values['click'] :=
// 'function click(sender, e, eOpts){  ajaxRequest(MainForm.form, ' +
// QuotedStr('_buttonclick') + ', [' +
// QuotedStr('script=' + XmlNd.Attributes['ONCLICK']) + ']); }';
// Bt.ClientEvents.Enabled := True;
// end;
//
// Result := Bt;
// end;

/// / LABEL
// function TMainForm.BuildLabel(XmlNd: IXMLNode): TUniLabel;
// var
// Lb: TUniLabel;
// begin
// Lb := TUniLabel.Create(Self);
// // Lb.Name := XmlNd.Attributes['ID'];
// Lb.Caption := XmlNd.Attributes['CAPTION'];
// if not VarIsNull(XmlNd.Attributes['TOP']) then
// Lb.Top := XmlNd.Attributes['TOP'];
// if not VarIsNull(XmlNd.Attributes['LEFT']) then
// Lb.Left := StrToInt(XmlNd.Attributes['LEFT']);
// if not VarIsNull(XmlNd.Attributes['WIDTH']) then
// Lb.Width := StrToInt(XmlNd.Attributes['WIDTH']);
// if not VarIsNull(XmlNd.Attributes['ALIGNMENT']) then
// if XmlNd.Attributes['ALIGNMENT'] = 'Left' then
// Lb.Alignment := taLeftJustify;
// if XmlNd.Attributes['ALIGNMENT'] = 'Right' then
// Lb.Alignment := taRightJustify;
// Result := Lb;
// end;

/// / EDIT BOX
// function TMainForm.BuildEdit(XmlNd: IXMLNode): TUniEdit;
// var
// Ed: TUniEdit;
// CutOff: Integer;
// begin
// CutOff := 30;
// if length(XmlNd.Attributes['CAPTION']) >= 8 then
// CutOff := 80;
// Ed := TUniEdit.Create(Self);
// Ed.Name := XmlNd.Attributes['ID'];
// Ed.Caption := XmlNd.Attributes['CAPTION'];
// Ed.FieldLabel := XmlNd.Attributes['CAPTION'];
// Ed.FieldLabelWidth := CutOff;
// if not VarIsNull(XmlNd.Attributes['TOP']) then
// Ed.Top := XmlNd.Attributes['TOP'];
// if not VarIsNull(XmlNd.Attributes['LEFT']) then
// Ed.Left := StrToInt(XmlNd.Attributes['LEFT']) - CutOff;
// if not VarIsNull(XmlNd.Attributes['WIDTH']) then
// Ed.Width := StrToInt(XmlNd.Attributes['WIDTH']) + CutOff;
// if not VarIsNull(XmlNd.Attributes['ALIGNMENT']) then
// if XmlNd.Attributes['ALIGNMENT'] = 'Left' then
// Ed.Alignment := taLeftJustify;
// if XmlNd.Attributes['ALIGNMENT'] = 'Right' then
// Ed.Alignment := taRightJustify;
//
// if not VarIsNull(XmlNd.Attributes['ENABLE']) then
// begin
// if XmlNd.Attributes['ENABLE'] = 'Y' then
// Ed.Enabled := True
// Else
// Ed.Enabled := false;
// end;
//
// if not VarIsNull(XmlNd.Attributes['FOCUS']) and
// (XmlNd.Attributes['FOCUS'] = 'Y') then
// Ed.SetFocus;
// Result := Ed;
// end;

// GROUP BOX
// function TMainForm.BuildGroupBox(XmlNd: IXMLNode; Ts: TUniTabSheet)
// : TUniGroupBox;
// var
// Gb: TUniGroupBox;
// I: Integer;
// begin
// Gb := TUniGroupBox.Create(Self);
// Gb.Top := 5;
// Gb.Padding.Top := 5;
// if not VarIsNull(XmlNd.Attributes['LEFT']) then
// Gb.Left := XmlNd.Attributes['LEFT'] + 5;
// if not VarIsNull(XmlNd.Attributes['HEIGHT']) then
// Gb.Height := XmlNd.Attributes['HEIGHT'] - 10;
// if not VarIsNull(XmlNd.Attributes['WIDTH']) then
// Gb.Width := XmlNd.Attributes['WIDTH'];
// if not VarIsNull(XmlNd.Attributes['ALIGN']) then
// begin
// if XmlNd.Attributes['ALIGN'] = 'None' then
// begin
// Gb.Align := alNone;
// end;
// if XmlNd.Attributes['ALIGN'] = 'Client' then
// begin
// Gb.Align := alClient;
// end;
// end;
// Gb.Parent := Ts;
//
// for I := 0 to XmlNd.ChildNodes.Count - 1 do
// begin
// // Buat Page Control
// if XmlNd.ChildNodes[I].NodeName = 'Edit' then
// begin
// Gb.InsertControl(BuildEdit(XmlNd.ChildNodes[I]));
// end;
// // Buat Label
// if XmlNd.ChildNodes[I].NodeName = 'Label' then
// begin
// Gb.InsertControl(BuildLabel(XmlNd.ChildNodes[I]));
// end;
// // Buat Button
// if XmlNd.ChildNodes[I].NodeName = 'Button' then
// begin
// Gb.InsertControl(BuildButton(XmlNd.ChildNodes[I]));
// end;
// // Buat LooupDBComboBox
// if XmlNd.ChildNodes[I].NodeName = 'Lookup' then
// begin
// Gb.InsertControl(BuildLookup(Self, XmlNd.ChildNodes[I]));
// end;
// // Buat CheckBox
// if XmlNd.ChildNodes[I].NodeName = 'Check' then
// begin
// Gb.InsertControl(BuildCheck(Self, XmlNd.ChildNodes[I]));
// end;
// // Buat Date time picker
// if XmlNd.ChildNodes[I].NodeName = 'Date' then
// begin
// Gb.InsertControl(BuildDate(Self, XmlNd.ChildNodes[I]));
// end;
// end;
// Result := Gb;
// end;

/// / TAB SHEET
// function TMainForm.BuildTabSheet(XmlNd: IXMLNode; Pc: TUniPageControl)
// : TUniTabSheet;
// var
// Ts: TUniTabSheet;
// Pn: TUniPanel;
// I: Integer;
// begin
// Ts := TUniTabSheet.Create(Self);
// with TUniTabSheet(InsertControl(Ts)) do
// begin
// Ts.Name := XmlNd.Attributes['ID'];
// Ts.Caption := XmlNd.Attributes['CAPTION'];
// Ts.PageControl := Pc;
// for I := 0 to XmlNd.ChildNodes.Count - 1 do
// begin
// if XmlNd.ChildNodes[I].NodeName = 'GroupBox' then
// begin
// // Buat Group Box
// Ts.InsertControl(BuildGroupBox(XmlNd.ChildNodes[I], Ts));
// end;
// if XmlNd.ChildNodes[I].NodeName = 'PanelEx' then
// begin
// Ts.InsertControl(BuildContainerPanel(XmlNd.ChildNodes[I], Ts));
// end;
// end;
// end;
// Result := Ts;
// end;

/// / PAGE CONTROL
// function TMainForm.BuildPageControl(XmlNd: IXMLNode): TUniPageControl;
// var
// Pc: TUniPageControl;
// I: Integer;
// begin
// Pc := TUniPageControl.Create(Self);
// With TUniPageControl(InsertControl(Pc)) do
// begin
// Name := XmlNd.Attributes['ID'];
// if XmlNd.Attributes['ALIGN'] = 'None' then
// begin
// Width := XmlNd.Attributes['WIDTH'];
// Left := XmlNd.Attributes['LEFT'];
// Width := XmlNd.Attributes['WIDTH'];
// Height := XmlNd.Attributes['HEIGHT'];
// end
// else
// begin
// if XmlNd.Attributes['ALIGN'] = 'Client' then
// Align := alClient;
// end;
// for I := 0 to XmlNd.ChildNodes.Count - 1 do
// begin
// // Buat Tab Sheet
// Pc.InsertControl(BuildTabSheet(XmlNd.ChildNodes[I], Pc));
// end;
// end;
// Result := Pc;
// end;

/// / PANEL
// function TMainForm.BuildPanel(XmlNd: IXMLNode): TUniPanel;
// var
// Pn: TUniPanel;
// Pc: TUniPageControl;
// I: Integer;
// begin
// Pn := TUniPanel.Create(Self);
// with TUniPanel(InsertControl(Pn)) do
// begin
// if XmlNd.Attributes['ALIGN'] = 'Top' then
// Align := alTop;
// if XmlNd.Attributes['ALIGN'] = 'Client' then
// Align := alClient;
//
// if not VarIsNull(XmlNd.Attributes['HEIGHT']) then
// Height := StrToInt(XmlNd.Attributes['HEIGHT']) + 10;
//
// for I := 0 to XmlNd.ChildNodes.Count - 1 do
// begin
// // Buat Page Control
// if XmlNd.ChildNodes[I].NodeName = 'PageControl' then
// begin
// Pn.InsertControl(BuildPageControl(XmlNd.ChildNodes[I]));
// end;
// // Buat Page Control
// if XmlNd.ChildNodes[I].NodeName = 'Button' then
// begin
// Pn.InsertControl(BuildButton(XmlNd.ChildNodes[I]));
// end;
// // Buat Lookup DB
// if XmlNd.ChildNodes[I].NodeName = 'Lookup' then
// begin
// Pn.InsertControl(BuildLookup(Self, XmlNd.ChildNodes[I]));
// end;
// // Buat CheckBox
// if XmlNd.ChildNodes[I].NodeName = 'Check' then
// begin
// Pn.InsertControl(BuildCheck(Self, XmlNd.ChildNodes[I]));
// end;
// // Buat Date Time
// if XmlNd.ChildNodes[I].NodeName = 'Date' then
// begin
// Pn.InsertControl(BuildDate(Self, XmlNd.ChildNodes[I]));
// end;
// end;
// end;
// Result := Pn;
// end;

// Date time
// function TMainForm.BuildDate(XmlNd: IXMLNode): TUniDateTimePicker;
// var
// Dt: TUniDateTimePicker;
// Pc: TUniPageControl;
// I, CutOff: Integer;
// begin
// CutOff := 80;
//
// if length(XmlNd.Attributes['CAPTION']) <= 5 then
// CutOff := 30;
//
// if length(XmlNd.Attributes['CAPTION']) > 10 then
// CutOff := 90;
//
// Dt := TUniDateTimePicker.Create(Self);
// Dt.Name := XmlNd.Attributes['ID'];
// Dt.Caption := XmlNd.Attributes['CAPTION'];
// Dt.FieldLabel := XmlNd.Attributes['CAPTION'];
// Dt.FieldLabelWidth := CutOff;
// if not VarIsNull(XmlNd.Attributes['TOP']) then
// Dt.Top := XmlNd.Attributes['TOP'];
// if not VarIsNull(XmlNd.Attributes['LEFT']) then
// Dt.Left := StrToInt(XmlNd.Attributes['LEFT']) - CutOff;
// if not VarIsNull(XmlNd.Attributes['WIDTH']) then
// Dt.Width := StrToInt(XmlNd.Attributes['WIDTH']) + CutOff - 10;
// if not VarIsNull(XmlNd.Attributes['ALIGNMENT']) then
// if XmlNd.Attributes['ALIGNMENT'] = 'Left' then
// Dt.Alignment := taLeftJustify;
// if XmlNd.Attributes['ALIGNMENT'] = 'Right' then
// Dt.Alignment := taRightJustify;
// if not VarIsNull(XmlNd.Attributes['TYPE']) then
// begin
// if XmlNd.Attributes['TYPE'] = 'DateTime' then
// begin
// Dt.DateMode := dtmDateTime;
// Dt.Width := Dt.Width + 5;
// end;
// end;
//
// if not VarIsNull(XmlNd.Attributes['ENABLE']) then
// begin
// if XmlNd.Attributes['ENABLE'] = 'Y' then
// Dt.Enabled := True
// else
// Dt.Enabled := false;
// end;
//
// Result := Dt;
// end;

// =============================== Build Component =============================

procedure TMainForm.NavTreeAjaxEvent(Sender: TComponent; EventName: string;
  Params: TUniStrings);
var
  Script: string;
begin
  if EventName = '_buttonclick' then
  begin
    ShowMask('Loading');
    UniSession.Synchronize();
    Script := Params.Values['script'];
    RunAction(self, Script);
    HideMask;
  end;
end;

procedure TMainForm.NavTreeClick(Sender: TObject);
var
  Nd: TUniTreeNode;
  treeXMLID, compXMLID, compDesc: string;
  treeNode, Level_0_Node, Level_1_Node, Level_2_Node, Level_3_Node: IXMLNode;
  FrC: TUniFrame;
  Fr: TUniFrame;
  Ts, TsPc: TUniTabSheet;
  Pn: TUniPanel;
  Bt: TUniButton;
  Ed: TUniEdit;
  Pc: TUniPageControl;
  Gb: TUniGroupBox;
  I, J, K, L: Integer;
  Co: TComponent;
  Lb: TUniLabel;
begin
  ShowMask('Loading');
  UniSession.Synchronize();
  Nd := NavTree.Selected;
  if Nd.Count = 0 then
  begin

    if exeSP.Active then
      exeSP.Active := false;

    exeSP.FetchOptions.AutoClose := false;
    exeSP.PackageName := 'DATOS_PRJ.ZULU_SUPPORT';
    exeSP.StoredProcName := 'getFormWrappedInCursor';
    exeSP.Prepare;
    exeSP.ParamByName('pFormID').Value := Nd.Tag;
    exeSP.ParamByName('pLanguage').Value := 'EN';
    exeSP.ParamByName('pClientAppVersion').Value := appClientVer;
    exeSP.Open();
    exeSP.First;

    // read XML
    XMLDoc.LoadFromXML(exeSP.FieldByName('SCRIPT').AsString);

    XMLDoc.Active := True;
    try
      treeXMLID := XMLDoc.ChildNodes['TREE'].Attributes['XMLID'];

      treeNode := XMLDoc.ChildNodes['TREE'];
      compXMLID := treeNode.ChildNodes['ACOMPONENT'].Attributes['XMLID'];
      compDesc := treeNode.ChildNodes['ACOMPONENT'].Attributes['NAME'];

      // update label
      lblNav.Caption := defWorkplaceDesc + ' > ' + compDesc;

      // load XML component
      if exeSP.Active then
        exeSP.Active := false;
      exeSP.PackageName := 'DATOS_PRJ.ZULU_SUPPORT';
      exeSP.StoredProcName := 'getFormWrappedInCursor';
      exeSP.Prepare;
      exeSP.ParamByName('pFormID').Value := compXMLID;
      exeSP.ParamByName('pLanguage').Value := 'EN';
      exeSP.ParamByName('pClientAppVersion').Value := appClientVer;
      exeSP.Open();
      exeSP.First;

      ActiveFormName := 'fr' + compXMLID;

      // create Frame
      Ts := Nd.Data;
      if not Assigned(Ts) then
      begin

        Ts := TUniTabSheet.Create(self);
        with TUniTabSheet(InsertControl(Ts)) do
        begin
          Ts.PageControl := UniPageControl1;

          Ts.Closable := True;
          Ts.OnClose := TabSheetClose;
          Ts.Tag := NativeInt(Nd);
          Ts.Caption := Nd.Text;
          Ts.ImageIndex := Nd.ImageIndex;
          Ts.Name := 'ts' + compXMLID;
          Ts.Closable := false;

          Fr := TUniFrame.Create(self);
          with TUniFrame(InsertControl(Fr)) do
          begin
            Fr.Align := alClient;
            Fr.Name := 'fr' + compXMLID;
            XMLDoc.LoadFromXML(exeSP.FieldByName('SCRIPT').AsString);

            // UniMemo2.Lines.Clear;
            // UniMemo2.Lines.Add(exeSP.FieldByName('SCRIPT').AsString);
            // HideMask;
            // Exit;

            // UniMemo1.Lines.Add(exeSP.FieldByName('SCRIPT').AsString);
            // frmGuiDebug.UniMemo1.Lines.Clear;
            // frmGuiDebug.UniMemo1.Lines.Add(exeSP.FieldByName('SCRIPT')
            // .AsString);

            // ================= LEVEL 0 ==================
            // 1. Panel
            XMLDoc.Active := True;
            Level_0_Node := XMLDoc.DocumentElement;

            // BUILD predefine Variable ************
            BuildPreVariable(self, 'GV01', Fr.Name);
            BuildPreVariable(self, 'X01', Fr.Name);
            BuildPreVariable(self, 'X02', Fr.Name);
            BuildPreVariable(self, 'X03', Fr.Name);
            BuildPreVariable(self, 'X04', Fr.Name);
            BuildPreVariable(self, 'EDTAB', Fr.Name);
            // special
            BuildPreVariable(self, 'USER', Fr.Name);
            SetCompValue(self, Fr.Name + '_USER',
              UniApplication.Cookies.GetCookie('UserName'));
            BuildPreVariable(self, 'MANDANT', Fr.Name);
            SetCompValue(self, Fr.Name + '_MANDANT', defLoc);

            for I := 0 to Level_0_Node.ChildNodes.Count - 1 do
            begin

              // UniMemo1.Lines.Add(Level_0_Node.ChildNodes[I].NodeName + '-');
              // if VarIsNull(Level_0_Node.ChildNodes[I].Attributes['ID']) then
              // UniMemo1.Lines.Add(Level_0_Node.ChildNodes[I].Attributes['ID']);

              // Build Pop Up From
              if Level_0_Node.ChildNodes[I].NodeName = 'PopupEx' then
              begin
                if not VarIsNull(Level_0_Node.ChildNodes[I]) then
                begin
                  BuildPopupEx(self, Level_0_Node.ChildNodes[I], Fr.Name);
                end;
              end;

              // Build variable as LabelComponent
              if Level_0_Node.ChildNodes[I].NodeName = 'Variable' then
              begin
                if not VarIsNull(Level_0_Node.ChildNodes[I]) then
                  BuildVariable(self, Level_0_Node.ChildNodes[I], Fr.Name);
              end;

              // Build Script as Memo component
              if Level_0_Node.ChildNodes[I].NodeName = 'ScriptEx' then
              begin
                if not VarIsNull(Level_0_Node.ChildNodes[I]) then
                begin
                  BuildScriptEx(self, Level_0_Node.ChildNodes[I], Fr.Name);
                end;
              end;

              // Build Script as Memo component
              if Level_0_Node.ChildNodes[I].NodeName = 'MsgDialog' then
              begin
                if not VarIsNull(Level_0_Node.ChildNodes[I]) then
                begin
                  BuildMsgDialog(self, Level_0_Node.ChildNodes[I], Fr.Name);
                end;
              end;

              // Build Query
              if Level_0_Node.ChildNodes[I].NodeName = 'QueryEx' then
              begin
                if not VarIsNull(Level_0_Node.ChildNodes[I]) then
                  BuildQuery(self, Level_0_Node.ChildNodes[I], Fr.Name);
              end;

              // Build Panel
              if Level_0_Node.ChildNodes[I].NodeName = 'PanelEx' then
              begin
                Fr.InsertControl(BuildPanel(self, Level_0_Node.ChildNodes[I]));
              end;

              // Build Page Control
              if Level_0_Node.ChildNodes[I].NodeName = 'PageControl' then
              begin
                Fr.InsertControl(BuildPageControl(self,
                  Level_0_Node.ChildNodes[I]));
              end;

            end;
          end;
        end;

        Nd.Data := Ts;
      end;
      UniPageControl1.ActivePage := Ts;
    finally
      XMLDoc.Active := false;
    end;

  end;
  UniSession.Synchronize();
  HideMask;
end;

procedure TMainForm.RunClick(Sender: TObject);
var
  com: TComponent;
  Lo: TUniDBLookupComboBox;
  Js: string;
begin
  // com := GetCompomentByName(Self, 'LOCASE');
  // Lo := com as TUniDBLookupComboBox;
  //
  // mmRunJS.Lines.Clear;
  // mmRunJS.Lines.Add(Lo.Name);
  //
  // Js := 'MainForm.UniLabel1.setText(MainForm.' + Lo.Name + '.getValue());';
  // mmRunJS.Lines.Add(Js);

  // UniSession.AddJS(Js);
  // UniSession.AddJS(mmRunJS.Lines.Text);
end;

procedure TMainForm.SearchTree(const AText: string);
var
  S, SString: string;
  I: Integer;
  aExpand: Boolean;
begin
  SString := Trim(AText);
  if SString <> PSString then
  begin
    PSString := LowerCase(SString);
    if (length(PSString) > 1) or (PSString = '') then
    begin
      aExpand := PSString <> '';
      NavTree.BeginUpdate;
      try
        NavTree.ResetData;
        for I := 0 to NavTree.Items.Count - 1 do
        begin
          S := LowerCase(NavTree.Items[I].Text);
          NavTree.Items[I].Visible := (length(PSString) = 0) or
            (Pos(PSString, S) > 0);
          NavTree.Items[I].Expanded := aExpand;
        end;
      finally
        NavTree.EndUpdate;
      end;
    end;
  end;
end;

procedure TMainForm.SearchEditChange(Sender: TObject);
begin
  SearchTree(SearchEdit.Text);
end;

function MainForm: TMainForm;
begin
  Result := TMainForm(UniMainModule.GetFormInstance(TMainForm));
end;

procedure TMainForm.Close1Click(Sender: TObject);
begin
  UniSession.Logout;
end;

procedure TMainForm.EST22221Click(Sender: TObject);
begin
  ShowMessage((Sender as TComponent).Name);
end;

procedure TMainForm.btnRunActionJSClick(Sender: TObject);
begin
  UniSession.AddJS(mmJS.Lines.Text);
end;

procedure TMainForm.btnRunJSClick(Sender: TObject);
var
  Node, PanelNode: IXMLNode;
  I, J: Integer;
  SLine, JSScript, SVar1, SVar2, SCompVar1, SCompVar2: String;
  OuterRoot, EntryNode: IXMLNode;
  TmpStr: TStringDynArray;
  com: TComponent;
begin
  JSScript := mmJS.Lines.Text;

  mmParse.Lines.Clear;

  for I := 0 to mmJS.Lines.Count - 1 do
  begin
    mmParse.Lines.Add(mmJS.Lines[I]);
    SLine := mmJS.Lines[I];
    if (ContainsText(SLine, '=')) and
      (not ContainsText(UpperCase(SLine), 'IF (')) and
      (not ContainsText(UpperCase(SLine), 'IF(')) then
    begin

      mmParse.Lines.Add('Persamaan IF()');
      TmpStr := SplitString(SLine, '=');

      for J := 0 to length(TmpStr) do
      begin
        mmParse.Lines.Add(IntToStr(J) + ':' + TmpStr[J]);
      end;

      SVar1 := Trim(TmpStr[0]);
      SVar1 := Trim(TmpStr[1]);
      mmParse.Lines.Add('SVar1:' + SVar1);
      mmParse.Lines.Add('SVar2:' + SVar2);

      SVar1 := SplitString(SVar1, '.')[0];
      mmParse.Lines.Add('SVar1:' + SVar1);

      SVar2 := Trim(TmpStr[1]);
      mmParse.Lines.Add('SVar2:' + SVar2);
      SVar2 := SplitString(SVar2, '.')[0];
      mmParse.Lines.Add('SVar1:' + SVar1);
      mmParse.Lines.Add('SVar2:' + SVar2);

      SCompVar1 := GetCompByName(self, SVar1);
      if UpperCase(LeftStr(SVar1, 1)) = 'V' then
        SCompVar1 := 'MainForm.' + SCompVar1 + '.setText('
      else
        SCompVar1 := 'MainForm.' + SCompVar1 + '.setValue(';

      mmParse.Lines.Add('Component Name:' + SCompVar1);

      mmParse.Lines.Add('Var2:' + SVar2);

      SCompVar2 := GetCompByName(self, SVar2);
      // if (UpperCase(LeftStr(SVar1, 1)) = 'V') or
      // (UpperCase(LeftStr(SVar1, 1)) = 'V') then
      SCompVar2 := 'MainForm.' + SCompVar2 + '.getValue()';

      mmParse.Lines.Add('Component Name:' + SCompVar2);

      mmParse.Lines.Add('Script:' + SCompVar1 + SCompVar2 + ');');

      mmJS.Lines[I] := SCompVar1 + SCompVar2 + ');';

      // if S then

      // cari component

    end
    else if (ContainsText(SLine, 'RUN(')) then
    begin
      mmParse.Lines.Add('RUN()');
      TmpStr := SplitString(SLine, '''');

      mmJS.Lines[I] := 'ajaxRequest(MainForm.form, "_buttonclick" , ["script=' +
        TmpStr[1] + ';"]);';

    end
    else if (ContainsText(UpperCase(SLine), 'IF (')) or
      (ContainsText(UpperCase(SLine), 'IF(')) then
    begin
      mmParse.Lines.Add(' IF() ');
      // ==
      if ContainsText(SLine, '==') then
      begin
        mmParse.Lines.Add('Persamaan IF() "==" ');
        TmpStr := SplitString(SLine, '==');

        for J := 0 to length(TmpStr) do
        begin
          mmParse.Lines.Add(IntToStr(J) + ':' + TmpStr[J]);
        end;

        SVar1 := Trim(TmpStr[0]);
        SVar2 := Trim(TmpStr[2]);

        TmpStr := SplitString(SVar1, '(');
        SVar1 := Trim(TmpStr[1]);

        TmpStr := SplitString(SVar2, ')');
        SVar2 := Trim(TmpStr[0]);

        mmParse.Lines.Add('SVar1:' + SVar1);
        mmParse.Lines.Add('SVar2:' + SVar2);

        //

        TmpStr := SplitString(SVar1, '.');
        SCompVar1 := Trim(TmpStr[0]);
        SCompVar1 := GetCompByName(self, SCompVar1);
        if UpperCase(LeftStr(SVar1, 1)) = 'V' then
          SCompVar1 := 'MainForm.' + SCompVar1 + '.text'
        else
          SCompVar1 := 'MainForm.' + SCompVar1 + '.getValue()';

        if ContainsText(SVar2, '.') then
        begin
          TmpStr := SplitString(SVar2, '.');
          SCompVar2 := Trim(TmpStr[0]);
          SCompVar2 := GetCompByName(self, SCompVar2);
          if UpperCase(LeftStr(SVar2, 1)) = 'V' then
            SCompVar2 := 'MainForm.' + SCompVar2 + '.text'
          else
            SCompVar2 := 'MainForm.' + SCompVar2 + '.getValue()';
          mmParse.Lines.Add('SCompVar2:' + SCompVar2);
          mmParse.Lines.Add('SCompVar2:' + SCompVar2);
          mmJS.Lines[I] := StringReplace(mmJS.Lines[I], SVar2, SCompVar2,
            [rfReplaceAll, rfIgnoreCase]);
        end;

        mmParse.Lines.Add('SCompVar1:' + SCompVar1);
        mmJS.Lines[I] := StringReplace(mmJS.Lines[I], SVar1, SCompVar1,
          [rfReplaceAll, rfIgnoreCase]);

      end
      else
      begin

        // =
        if ContainsText(UpperCase(SLine), ' = ') then
        begin

          SCompVar1 := SplitString(SplitString(SLine, '(')[1], '=')[0];
          mmParse.Lines.Add('SCompVar1:' + SCompVar1);

          TmpStr := SplitString(SplitString(SLine, '(')[1], '=');
          SCompVar2 := TmpStr[length(TmpStr) - 1];
          SCompVar2 := StringReplace(SCompVar2, ')', '',
            [rfReplaceAll, rfIgnoreCase]);
          SCompVar2 := StringReplace(SCompVar2, '{', '',
            [rfReplaceAll, rfIgnoreCase]);
          mmParse.Lines.Add('SCompVar2:' + SCompVar2);

          if ContainsText(SCompVar2, '.') then
          begin
            mmParse.Lines.Add('Ada persamaan sebelah kanan.');

          end;

          SCompVar1 := StringReplace(SCompVar1, '!', '',
            [rfReplaceAll, rfIgnoreCase]);
          SCompVar1 := StringReplace(SCompVar1, '>', '',
            [rfReplaceAll, rfIgnoreCase]);
          SCompVar1 := StringReplace(SCompVar1, '>', '',
            [rfReplaceAll, rfIgnoreCase]);
          SCompVar1 := Trim(SCompVar1);
          mmParse.Lines.Add(SCompVar1);

          SVar1 := Trim(SCompVar1);
          mmParse.Lines.Add(SVar1);
          SVar1 := SplitString(SVar1, '.')[0];
          mmParse.Lines.Add(SVar1);
        end
        else
        begin
          // > <

          mmParse.Lines.Add(' > <');
          if ContainsText(UpperCase(SLine), ' > ') then
          begin
            mmParse.Lines.Add(' >');
            SCompVar1 := SplitString(SplitString(SLine, '(')[1], '>')[0];
            mmParse.Lines.Add('SCompVar1:' + SCompVar1);

            TmpStr := SplitString(SplitString(SLine, '(')[1], '>');
            SCompVar2 := TmpStr[length(TmpStr) - 1];
          end
          else
          begin
            mmParse.Lines.Add(' <');
            SCompVar1 := SplitString(SplitString(SLine, '(')[1], '<')[0];
            mmParse.Lines.Add('SCompVar1:' + SCompVar1);

            TmpStr := SplitString(SplitString(SLine, '(')[1], '<');
            SCompVar2 := TmpStr[length(TmpStr) - 1];
          end;

          SCompVar2 := StringReplace(SCompVar2, ')', '',
            [rfReplaceAll, rfIgnoreCase]);
          SCompVar2 := StringReplace(SCompVar2, '{', '',
            [rfReplaceAll, rfIgnoreCase]);
          mmParse.Lines.Add('SCompVar2:' + SCompVar2);

          if ContainsText(SCompVar2, '.') then
          begin
            mmParse.Lines.Add('Ada persamaan sebelah kanan.');

          end;

          SCompVar1 := StringReplace(SCompVar1, '!', '',
            [rfReplaceAll, rfIgnoreCase]);
          SCompVar1 := StringReplace(SCompVar1, '>', '',
            [rfReplaceAll, rfIgnoreCase]);
          SCompVar1 := StringReplace(SCompVar1, '>', '',
            [rfReplaceAll, rfIgnoreCase]);
          SCompVar1 := Trim(SCompVar1);
          mmParse.Lines.Add(SCompVar1);

          SVar1 := Trim(SCompVar1);
          mmParse.Lines.Add(SVar1);
          SVar1 := SplitString(SVar1, '.')[0];
          mmParse.Lines.Add(SVar1);

        end;

        SCompVar1 := GetCompByName(self, SVar1);
        mmParse.Lines.Add(SCompVar1);
        SCompVar1 := 'MainForm.' + SCompVar1 + '.getValue()';
        mmParse.Lines.Add(SCompVar1);

      end;

    end;

  end;
end;

procedure TMainForm.btnRunMemoClick(Sender: TObject);
begin
  // RunAction(mm2.Lines.Text);
end;

procedure TMainForm.btnTestClick(Sender: TObject);
begin

  // ShowMessage(UniLabel1.Caption);

end;

procedure TMainForm.UniButton2Click(Sender: TObject);
var
  XmlNd: IXMLNode;
  bExec: Boolean;
  Script: String;
begin
  SetCompValue(self, GetCompByName(self, 'LBL_AUFTDAT'),
    '10/10/2021 11:28:06 AM');

end;

procedure TMainForm.mjjnnhjghh(Sender: TObject);
var
  FdSP: TFDStoredProc;
begin

  FdSP := TFDStoredProc.Create(nil);
  try
    FdSP.Connection := UniMainModule.FDConn;
    FdSP.PackageName := 'datos_prj.befund';
    FdSP.StoredProcName := 'erzeugen';
    FdSP.Prepare;
    FdSP.ParamByName('PTYP').Value := 'E';
    FdSP.ParamByName('PFRMNR').Value := '10';
    FdSP.ParamByName('PSEQNR').Value := '1';
    FdSP.ParamByName('PLOCAL').Value := 'LAB1';

    FdSP.Execute;
    FdSP.Connection.Commit;

    ShowMessage(FdSP.ParamByName('RESULT').AsString);
  finally
    FdSP.Free;
  end;
  //
  // if FDSpPrint.Active then
  // FDSpPrint.Active := false;
  //
  // FDSpPrint.ParamByName('PTYP').Value := 'E';
  // FDSpPrint.ParamByName('PFRMNR').Value := '10';
  // FDSpPrint.ParamByName('PSEQNR').Value := '1';
  // // FDSpPrint.ParamByName('PAUFTDATVON').Value := 'E';
  // // FDSpPrint.ParamByName('PAUFTDATBIZ').Value := 'E';
  // FDSpPrint.ParamByName('PLOCAL').Value := 'LAB1';
  // // FDSpPrint.ParamByName('PTYP').Value := 'E';
  //
  // FDSpPrint.Execute;
  // FDSpPrint.Connection.Commit;
  //
  // ShowMessage(FDSpPrint.ParamByName('RESULT').AsString);

end;

procedure TMainForm.btnPrintClick(Sender: TObject);
var
  Nd: TUniTreeNode;
  treeXMLID, compXMLID, compDesc: string;
  treeNode, Level_0_Node, Level_1_Node, Level_2_Node, Level_3_Node: IXMLNode;
  FrC: TUniFrame;
  Fr: TUniFrame;
  Ts, TsPc: TUniTabSheet;
  Pn: TUniPanel;
  Bt: TUniButton;
  Ed: TUniEdit;
  Pc: TUniPageControl;
  Gb: TUniGroupBox;
  I, J, K, L: Integer;
begin
  // load XML component

  compXMLID := '10143';

  if exeSP.Active then
    exeSP.Active := false;
  exeSP.PackageName := 'DATOS_PRJ.ZULU_SUPPORT';
  exeSP.StoredProcName := 'getFormWrappedInCursor';
  exeSP.Prepare;
  exeSP.ParamByName('pFormID').Value := compXMLID;
  exeSP.ParamByName('pLanguage').Value := 'EN';
  exeSP.ParamByName('pClientAppVersion').Value := appClientVer;
  exeSP.Open();
  exeSP.First;

  ActiveFormName := 'fr' + compXMLID;

  // create Frame

  Ts := TUniTabSheet.Create(self);
  with TUniTabSheet(InsertControl(Ts)) do
  begin
    Ts.PageControl := UniPageControl1;

    Ts.Closable := True;
    Ts.OnClose := TabSheetClose;
    Ts.Caption := 'fr' + compXMLID;;

    Ts.Name := 'ts' + compXMLID;

    Fr := TUniFrame.Create(self);
    with TUniFrame(InsertControl(Fr)) do
    begin
      Fr.Align := alClient;
      Fr.Name := 'fr' + compXMLID;
      XMLDoc.LoadFromXML(exeSP.FieldByName('SCRIPT').AsString);

      // UniMemo2.Lines.Clear;
      // UniMemo2.Lines.Add(exeSP.FieldByName('SCRIPT').AsString);
      // HideMask;
      // Exit;

      // UniMemo1.Lines.Add(exeSP.FieldByName('SCRIPT').AsString);
      // frmGuiDebug.UniMemo1.Lines.Clear;
      // frmGuiDebug.UniMemo1.Lines.Add(exeSP.FieldByName('SCRIPT')
      // .AsString);

      // ================= LEVEL 0 ==================
      // 1. Panel
      XMLDoc.Active := True;
      Level_0_Node := XMLDoc.DocumentElement;

      for I := 0 to Level_0_Node.ChildNodes.Count - 1 do
      begin

        // UniMemo1.Lines.Add(Level_0_Node.ChildNodes[I].NodeName + '-');
        // if VarIsNull(Level_0_Node.ChildNodes[I].Attributes['ID']) then
        // UniMemo1.Lines.Add(Level_0_Node.ChildNodes[I].Attributes['ID']);

        // Build Pop Up From
        if Level_0_Node.ChildNodes[I].NodeName = 'PopupEx' then
        begin
          if not VarIsNull(Level_0_Node.ChildNodes[I]) then
          begin
            BuildPopupEx(self, Level_0_Node.ChildNodes[I], Fr.Name);
          end;
        end;

        // Build variable as LabelComponent
        if Level_0_Node.ChildNodes[I].NodeName = 'Variable' then
        begin
          if not VarIsNull(Level_0_Node.ChildNodes[I]) then
            BuildVariable(self, Level_0_Node.ChildNodes[I], Fr.Name);
        end;

        // Build Script as Memo component
        if Level_0_Node.ChildNodes[I].NodeName = 'ScriptEx' then
        begin
          if not VarIsNull(Level_0_Node.ChildNodes[I]) then
          begin
            BuildScriptEx(self, Level_0_Node.ChildNodes[I], Fr.Name);
          end;
        end;

        // Build Query
        if Level_0_Node.ChildNodes[I].NodeName = 'QueryEx' then
        begin
          if not VarIsNull(Level_0_Node.ChildNodes[I]) then
            BuildQuery(self, Level_0_Node.ChildNodes[I], Fr.Name);
        end;

        // Build Panel
        if Level_0_Node.ChildNodes[I].NodeName = 'PanelEx' then
        begin
          Fr.InsertControl(BuildPanel(self, Level_0_Node.ChildNodes[I]));
        end;

        // Build Page Control
        if Level_0_Node.ChildNodes[I].NodeName = 'PageControl' then
        begin
          Fr.InsertControl(BuildPageControl(self, Level_0_Node.ChildNodes[I]));
        end;

      end;
    end;
  end;

end;

procedure TMainForm.ActBtnClickExecute(Sender: TObject);
begin
  RouteRunBtnClick(Sender);
end;

procedure TMainForm.btnConvertClick(Sender: TObject);
var
  Node, PanelNode: IXMLNode;
  I, J, K: Integer;
  SLine, JSScript, SVar1, SVar2, SCompVar1, SCompVar2: String;
  OuterRoot, EntryNode: IXMLNode;
  TmpStr, TmpStr0: TStringDynArray;
  com: TComponent;
begin
  JSScript := mmJS.Lines.Text;

  mmParse.Lines.Clear;

  for I := 0 to mmJS.Lines.Count - 1 do
  begin
    mmParse.Lines.Add(mmJS.Lines[I]);

    if (ContainsText(mmJS.Lines[I], 'RUN(')) then // RUN Action
    begin
      mmParse.Lines.Add('* RUN() action');
      TmpStr := SplitString(mmJS.Lines[I], '''');
      mmJS.Lines[I] := 'ajaxRequest(MainForm.form, "_buttonclick" , ["script=' +
        TmpStr[1] + ';"]);';
    end
    else if (ContainsText(UpperCase(mmJS.Lines[I]), '.REFRESH(')) then
    // REFRESH Action
    begin
      mmParse.Lines.Add('*  REFRESH() action');
      TmpStr := SplitString(mmJS.Lines[I], '''');
      mmJS.Lines[I] := 'ajaxRequest(MainForm.form, "_buttonclick" , ["script=' +
        TmpStr[I] + ';"]);';
    end
    else if (ContainsText(UpperCase(mmJS.Lines[I]), 'IF (')) or
      (ContainsText(UpperCase(mmJS.Lines[I]), 'IF(')) then
    // IF Condition
    begin
      mmParse.Lines.Add('* IF Condition');
      if (ContainsText(UpperCase(mmJS.Lines[I]), '=')) then
      begin

        if (ContainsText(UpperCase(mmJS.Lines[I]), '||')) then
        begin
          mmParse.Lines.Add('* ||');
          TmpStr := SplitString(mmJS.Lines[I], '||');

          for J := 0 to length(TmpStr) - 1 do
          begin
            mmParse.Lines.Add(IntToStr(J) + ':' + TmpStr[J]);

            if (Trim(TmpStr[J]) = '') then
            begin
              mmParse.Lines.Add('* Skip');
            end
            else if (not ContainsText(TmpStr[J], '&&')) then
            begin
              mmParse.Lines.Add('** found.');
              mmJS.Lines[I] := getCompIfJs(self, mmJS.Lines[I], TmpStr[J]);
            end
            else
            begin
              // pecah lagi
              TmpStr0 := SplitString(TmpStr[J], '&&');
              for K := 0 to length(TmpStr0) - 1 do
              begin
                mmParse.Lines.Add(IntToStr(K) + ':' + TmpStr0[K]);
                if Trim(TmpStr0[K]) <> '' then
                begin
                  mmParse.Lines.Add('* Found');
                  mmJS.Lines[I] := getCompIfJs(self, mmJS.Lines[I], TmpStr0[K]);
                end
                else
                  mmParse.Lines.Add('* Skip');
              end;
            end;
          end;
        end

        else if (ContainsText(UpperCase(mmJS.Lines[I]), '&&')) or
          (ContainsText(UpperCase(mmJS.Lines[I]), '||')) then
        begin
          if (ContainsText(UpperCase(mmJS.Lines[I]), '&&')) then
          begin
            mmParse.Lines.Add('* &&');
            TmpStr := SplitString(mmJS.Lines[I], '&&');

            for J := 0 to length(TmpStr) - 1 do
            begin
              mmParse.Lines.Add(IntToStr(J) + ':' + TmpStr[J]);
              if (Trim(TmpStr[J]) = '') then
              begin
                mmParse.Lines.Add('* Skip');
              end
              else if (not ContainsText(TmpStr[J], '||')) then
              begin
                mmParse.Lines.Add('** found.');
                mmJS.Lines[I] := getCompIfJs(self, mmJS.Lines[I], TmpStr[J]);
              end
              else
              begin
                // pecah lagi
                TmpStr0 := SplitString(TmpStr[J], '||');
                for K := 0 to length(TmpStr0) - 1 do
                begin
                  mmParse.Lines.Add(IntToStr(K) + ':' + TmpStr0[K]);
                  if Trim(TmpStr0[K]) <> '' then
                  begin
                    mmParse.Lines.Add('* Found');
                    mmJS.Lines[I] := getCompIfJs(self, mmJS.Lines[I],
                      TmpStr0[K]);
                  end
                  else
                    mmParse.Lines.Add('* Skip');
                end;
              end;
            end;
          end;
        end
        else
        begin
          mmParse.Lines.Add('* "=" ');
          mmJS.Lines[I] := getCompIfJs(self, mmJS.Lines[I], mmJS.Lines[I]);
        end;
      end
      else if (ContainsText(UpperCase(mmJS.Lines[I]), '>')) then
      begin
        mmParse.Lines.Add('* ">" ');
        mmJS.Lines[I] := getCompIfJs(self, mmJS.Lines[I], mmJS.Lines[I]);
      end
      else if (ContainsText(UpperCase(mmJS.Lines[I]), '<')) then
      begin
        mmParse.Lines.Add('* "<" ');
        mmJS.Lines[I] := getCompIfJs(self, mmJS.Lines[I], mmJS.Lines[I]);
      end
      else
      begin
        mmParse.Lines.Add('* Tanpa Persamaan');
        mmJS.Lines[I] := getCompIfJs(self, mmJS.Lines[I], mmJS.Lines[I]);
      end;

    end
    else if (not ContainsText(UpperCase(mmJS.Lines[I]), 'IF (')) and
      (not ContainsText(UpperCase(mmJS.Lines[I]), 'IF(')) and
      (ContainsText(UpperCase(mmJS.Lines[I]), ' = ')) then
    // Persamaan
    begin
      mmParse.Lines.Add('* Persamaan');
      mmJS.Lines[I] := getCompIfJs(self, mmJS.Lines[I], mmJS.Lines[I]);
    end
    else if ContainsText(UpperCase(mmJS.Lines[I]), '.CLEAR()') then
    begin
      mmParse.Lines.Add('* Clear()');
      SVar1 := Trim(SplitString(mmJS.Lines[I], '.')[0]);
      mmParse.Lines.Add('SVar1:' + SVar1);
      SVar1 := 'MainForm.' + GetCompByName(self, SVar1) + '.setValue("");';
      mmParse.Lines.Add('SVar1:' + SVar1);
      mmJS.Lines[I] := SVar1;
    end
    else
    // no need
    begin
      mmParse.Lines.Add('* No need convert');
    end;

  end;
end;

procedure TMainForm.btnRnJsClick(Sender: TObject);
begin
  RunActionJS(self, mmJS.Lines.Text);
end;

function TMainForm.getCompIfJs(AOwner: TComponent; Text: string;
  CompText: string): String;
var
  SVar1, SVar2, SCompVar1, SCompVar2: String;
  TmpStr, TmpStr0: TStringDynArray;
  I, J: Integer;
begin
  mmParse.Lines.Add('Call getCompIfJs()');
  mmParse.Lines.Add('CompText:' + CompText);
  mmParse.Lines.Add('* "=" ');
  TmpStr := SplitString(CompText, '=');

  for J := 0 to length(TmpStr) - 1 do
  begin
    if ContainsText(TmpStr[J], 'Value.indexOf(') then
      TmpStr[J] := SplitString(TmpStr[J], '.')[0] + '.Value';
    mmParse.Lines.Add(IntToStr(J) + ':' + TmpStr[J]);
  end;

  mmParse.Lines.Add('star cek.');
  SVar1 := Trim(TmpStr[0]);

  if ContainsText(SVar1, '<') then
    SVar1 := SplitString(SVar1, '<')[0];

  if ContainsText(SVar1, '>') then
    SVar1 := SplitString(SVar1, '>')[0];

  if (ContainsText(SVar1, '!')) and (ContainsText(SVar1, '=')) then
    SVar1 := SplitString(SVar1, '!')[0];

  mmParse.Lines.Add('debug SVar1:' + SVar1);
  if ContainsText(SVar1, '(') then
    SVar1 := Trim(SplitString(SVar1, '(')[1]);

  SVar2 := TmpStr[1];
  if (SVar2 = '') and (length(TmpStr) > 2) then
    SVar2 := TmpStr[2];

  if ContainsText(SVar2, ')') then
    SVar2 := Trim(SplitString(SVar2, ')')[0]);

  // fix
  SVar1 := StringReplace(SVar1, '!', '', [rfReplaceAll, rfIgnoreCase]);
  SVar1 := StringReplace(SVar1, ')', '', [rfReplaceAll, rfIgnoreCase]);
  SVar1 := StringReplace(SVar1, '{', '', [rfReplaceAll, rfIgnoreCase]);

  SVar1 := Trim(SVar1);

  // fix 2
  SVar2 := Trim(SVar2);

  mmParse.Lines.Add('SVar1:' + SVar1);
  mmParse.Lines.Add('SVar2:' + SVar2);

  SCompVar1 := Trim(SplitString(SVar1, '.')[0]);

  // fix
  SCompVar1 := StringReplace(SCompVar1, '!', '', [rfReplaceAll, rfIgnoreCase]);

  mmParse.Lines.Add('SCompVar1:' + SCompVar1);
  SCompVar1 := GetCompByName(self, SCompVar1);

  if (ContainsText(UpperCase(Text), 'IF(')) or
    (ContainsText(UpperCase(Text), 'IF (')) then
  begin

    if UpperCase(LeftStr(Trim(SVar1), 1)) = 'V' then
      SCompVar1 := 'MainForm.' + SCompVar1 + '.text '
    else if UpperCase(LeftStr(Trim(SVar1), 2)) = 'ED' then
      SCompVar1 := 'MainForm.' + SCompVar1 + '.getValue() '
    else
      SCompVar1 := 'MainForm.' + SCompVar1 + '.text ';

    mmParse.Lines.Add('SCompVar1:' + SCompVar1);

    Text := StringReplace(Text, SVar1, SCompVar1, [rfReplaceAll, rfIgnoreCase]);
    mmParse.Lines.Add(Text);
  end
  else if (ContainsText(UpperCase(Text), '.VISIBLE')) then
  begin
    // visible
    mmParse.Lines.Add('** Visible.');
    SCompVar1 := 'MainForm.' + SCompVar1 + '.setVisible(';
    mmParse.Lines.Add('SCompVar1:' + SCompVar1);
  end
  else
  begin
    mmParse.Lines.Add('** Persamaan.');
    if UpperCase(LeftStr(Trim(SVar1), 1)) = 'V' then
      SCompVar1 := 'MainForm.' + SCompVar1 + '.setText('
    else if UpperCase(LeftStr(Trim(SVar1), 2)) = 'ED' then
      SCompVar1 := 'MainForm.' + SCompVar1 + '.setValue('
    else
      SCompVar1 := 'MainForm.' + SCompVar1 + '.setText(';

    mmParse.Lines.Add('SCompVar1:' + SCompVar1);
  end;

  if ContainsText(SVar2, '.') then
  begin
    // fixing
    if ContainsText(Trim(SVar2), ' ') then
    begin
      mmParse.Lines.Add('* fixing space');
      SVar2 := SplitString(Trim(SVar2), ' ')
        [length(SplitString(Trim(SVar2), ' ')) - 1];
    end;

    // SCompVar2 := SplitString(SVar1, '.')[0];
    // mmParse.Lines.Add('SCompVar2:' + SCompVar2);
    SCompVar2 := SplitString(SVar2, '.')[0];
    mmParse.Lines.Add('SCompVar2:' + SCompVar2);

    SCompVar2 := GetCompByName(self, SCompVar2);
    mmParse.Lines.Add('SCompVar2:' + SCompVar2);

    if (ContainsText(UpperCase(Text), 'IF(')) or
      (ContainsText(UpperCase(Text), 'IF (')) then
    begin
      if UpperCase(LeftStr(SVar2, 1)) = 'V' then
        SCompVar2 := 'MainForm.' + SCompVar2 + '.text '
      else if UpperCase(LeftStr(Trim(SVar2), 2)) = 'ED' then
        SCompVar2 := 'MainForm.' + SCompVar2 + '.getValue() '
      else
        SCompVar2 := 'MainForm.' + SCompVar2 + '.text() ';

      mmParse.Lines.Add('SCompVar2:' + SCompVar2);
      Text := StringReplace(Text, SVar2, SCompVar2,
        [rfReplaceAll, rfIgnoreCase]);
    end
    else
    begin
      mmParse.Lines.Add('** Persamaan.');

      if UpperCase(LeftStr(SVar2, 1)) = 'V' then
        SCompVar2 := 'MainForm.' + SCompVar2 + '.text '
      else if UpperCase(LeftStr(Trim(SVar2), 2)) = 'ED' then
        SCompVar2 := 'MainForm.' + SCompVar2 + '.getValue() '
      else
        SCompVar2 := 'MainForm.' + SCompVar2 + '.text ';

      Text := SCompVar1 + SCompVar2 + ');';

    end;
  end
  else
  begin
    if (not ContainsText(UpperCase(Text), 'IF(')) and
      (not ContainsText(UpperCase(Text), 'IF (')) then
    begin
      mmParse.Lines.Add('** Persamaan.');
      SVar2 := StringReplace(SVar2, ';', '', [rfReplaceAll, rfIgnoreCase]);
      Text := SCompVar1 + SVar2 + ');';
    end;
  end;

  Result := Text;
end;

procedure TMainForm.UniButton4Click(Sender: TObject);
var
  Node, PanelNode: IXMLNode;
  I, J, K: Integer;
  SLine, JSScript, SVar1, SVar2, SCompVar1, SCompVar2: String;
  OuterRoot, EntryNode: IXMLNode;
  TmpStr, TmpStr0: TStringDynArray;
  com: TComponent;
begin
  JSScript := mmJS.Lines.Text;

  mmParse.Lines.Clear;

  for I := 0 to mmJS.Lines.Count - 1 do
  begin
    mmParse.Lines.Add(mmJS.Lines[I]);

    if (ContainsText(mmJS.Lines[I], 'RUN(')) then // RUN Action
    begin
      mmParse.Lines.Add('* REFRESH() action');
      TmpStr := SplitString(mmJS.Lines[I], '''');
      mmJS.Lines[I] := 'ajaxRequest(MainForm.form, "_buttonclick" , ["script=' +
        TmpStr[1] + ';"]);';
    end

    else if (ContainsText(UpperCase(mmJS.Lines[I]), 'IF (')) or
      (ContainsText(UpperCase(mmJS.Lines[I]), 'IF(')) then
    // IF Condition
    begin
      mmParse.Lines.Add('* IF Condition');
      if (ContainsText(UpperCase(mmJS.Lines[I]), '=')) then
      begin

        if (ContainsText(UpperCase(mmJS.Lines[I]), '&&')) or
          (ContainsText(UpperCase(mmJS.Lines[I]), '||')) then
        begin
          if (ContainsText(UpperCase(mmJS.Lines[I]), '&&')) then
          begin
            mmParse.Lines.Add('* &&');
            TmpStr := SplitString(mmJS.Lines[I], '&&');

            for J := 0 to length(TmpStr) - 1 do
            begin
              mmParse.Lines.Add(IntToStr(J) + ':' + TmpStr[J]);
              if (Trim(TmpStr[J]) = '') then
              begin
                mmParse.Lines.Add('* Skip');
              end
              else if (not ContainsText(TmpStr[J], '||')) then
              begin
                mmParse.Lines.Add('** found.');
                mmJS.Lines[I] := getCompIfJs(self, mmJS.Lines[I], TmpStr[J]);
              end
              else
              begin
                // pecah lagi
                TmpStr0 := SplitString(TmpStr[J], '||');
                for K := 0 to length(TmpStr0) - 1 do
                begin
                  mmParse.Lines.Add(IntToStr(K) + ':' + TmpStr0[K]);
                  if Trim(TmpStr0[K]) <> '' then
                  begin
                    mmParse.Lines.Add('* Found');
                    mmJS.Lines[I] := getCompIfJs(self, mmJS.Lines[I],
                      TmpStr0[K]);
                  end
                  else
                    mmParse.Lines.Add('* Skip');
                end;
              end;
            end;
          end;
        end
        else
        begin
          mmParse.Lines.Add('* "=" ');
          mmJS.Lines[I] := getCompIfJs(self, mmJS.Lines[I], mmJS.Lines[I]);
        end;
      end
      else if (ContainsText(UpperCase(mmJS.Lines[I]), '>')) then
      begin
        mmParse.Lines.Add('* ">" ');
        mmJS.Lines[I] := getCompIfJs(self, mmJS.Lines[I], mmJS.Lines[I]);
      end
      else if (ContainsText(UpperCase(mmJS.Lines[I]), '<')) then
      begin
        mmParse.Lines.Add('* "<" ');
        mmJS.Lines[I] := getCompIfJs(self, mmJS.Lines[I], mmJS.Lines[I]);
      end
      else
      begin
        mmParse.Lines.Add('* Tanpa Persamaan');
        mmJS.Lines[I] := getCompIfJs(self, mmJS.Lines[I], mmJS.Lines[I]);
      end;

    end
    else if (not ContainsText(UpperCase(mmJS.Lines[I]), 'IF (')) and
      (not ContainsText(UpperCase(mmJS.Lines[I]), 'IF(')) and
      (ContainsText(UpperCase(mmJS.Lines[I]), ' = ')) then
    // Persamaan
    begin
      mmParse.Lines.Add('* Persamaan');
      mmJS.Lines[I] := getCompIfJs(self, mmJS.Lines[I], mmJS.Lines[I]);
    end
    else if ContainsText(UpperCase(mmJS.Lines[I]), '.CLEAR()') then
    begin
      mmParse.Lines.Add('* Clear()');
      SVar1 := Trim(SplitString(mmJS.Lines[I], '.')[0]);
      mmParse.Lines.Add('SVar1:' + SVar1);
      SVar1 := 'MainForm.' + GetCompByName(self, SVar1) + '.setValue("");';
      mmParse.Lines.Add('SVar1:' + SVar1);
      mmJS.Lines[I] := SVar1;
    end
    else
    // no need
    begin
      mmParse.Lines.Add('* No need convert');
    end;

  end;

end;

procedure TMainForm.UniButton5Click(Sender: TObject);
begin
  frmPopUp.FORMID := 5460;
  frmPopUp.XMLID := 5460;
  frmPopUp.ShowModal;
end;

procedure TMainForm.UniButton6Click(Sender: TObject);
begin
  // UniDBGrid1.Columns[1].Index := 2;
end;

procedure TMainForm.UniButton7Click(Sender: TObject);
begin
  // UniLabel1.Alignment := taLeftJustify;
end;

procedure TMainForm.UniDBGrid1CellClick(Column: TUniDBGridColumn);
begin
  // UniDBGrid1.
end;

procedure TMainForm.GridDrawColumnCell(Sender: TObject; ACol, ARow: Integer;
  Column: TUniDBGridColumn; Attribs: TUniCellAttribs);
begin

  if Column.Grid.Name = 'fr5120_grResult' then
  begin
    if UpperCase(Column.FieldName) = 'NAME' then
      Attribs.Font.Color := $FF0000;
    if UpperCase(Column.FieldName) = 'RESULT' then
    begin
      if Column.Field.DataSet.FieldByName('COLOR').Value <> '' then
        Attribs.Font.Color := Column.Field.DataSet.FieldByName('COLOR').Value;
    end;
  end;
end;

procedure TMainForm.GridColumnMove(Column: TUniBaseDBGridColumn;
  OldIndex, NewIndex: Integer);
var
  XML_id, Gridname: string;
  I: Integer;
begin

  for I := 0 to TUniDBGrid(Column.Grid).Columns.Count - 1 do
  begin
    SetGridColRegVal(TUniDBGrid(Column.Grid), TUniDBGrid(Column.Grid)
      .Columns[I].FieldName, 'Index',
      IntToStr(TUniDBGrid(Column.Grid).Columns[I].Index));
  end;

  // ShowMessage(IntToStr(OldIndex) + ':' + IntToStr(NewIndex));

  // geser ke kanan index yg lain
  // for I := NewIndex to TUniDBGrid(Column.Grid).Columns.Count - 1 do
  // begin
  // TUniDBGrid(Column.Grid).Columns[I].Index := TUniDBGrid(Column.Grid)
  // .Columns[I].Index + 1;
  // end;
  //
  // XML_id := StringReplace(SplitString(Column.Grid.Name, '_')[0], 'fr', '',
  // [rfReplaceAll, rfIgnoreCase]);
  // Gridname := UpperCase(SplitString(Column.Grid.Name, '_')[1]);
  //
  // SetGridColRegVal(TUniDBGrid(Column.Grid), Column.FieldName, 'Index',
  // IntToStr(NewIndex));

end;

procedure TMainForm.GrdColumnResize(Sender: TUniBaseDBGridColumn;
  NewSize: Integer);
var
  XML_id, Gridname: string;
begin
  XML_id := StringReplace(SplitString(Sender.Grid.Name, '_')[0], 'fr', '',
    [rfReplaceAll, rfIgnoreCase]);
  Gridname := UpperCase(SplitString(Sender.Grid.Name, '_')[1]);

  SetGridColRegVal(TUniDBGrid(Sender.Grid), Sender.FieldName, 'Width',
    IntToStr(NewSize));
end;

procedure TMainForm.UniEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    ShowMessage('ok');
  end;
end;

procedure TMainForm.Split(Delimiter: Char; Str: string;
  ListOfStrings: TStrings);
begin
  ListOfStrings.Clear;
  ListOfStrings.Delimiter := Delimiter;
  ListOfStrings.StrictDelimiter := True;
  // Requires D2006 or newer.
  ListOfStrings.DelimitedText := Str;
end;

procedure TMainForm.UniFormAjaxEvent(Sender: TComponent; EventName: string;
  Params: TUniStrings);
var
  X, Y, I: Integer;
  Name, Script, FormParent, FormChild, Comp, Value, Pop, Grid, LinkID, Res,
    SValue1: String;
  TmpPop: TUniPopupMenu;
  TmpGrid: TUniDBGrid;
  Frm: TfrmPopUp;
  Lb: TUniLabel;
  Co: TComponent;
  PopUpFrm: TfrmPopUp;
begin
  // if EventName = '_contextmenu' then
  // begin
  // X := StrToInt(Params.Values['x']);
  // Y := StrToInt(Params.Values['y']);
  // Name := Params.Values['name'];
  // for I := 0 to ComponentCount - 1 do
  // if Components[I] is TUniPopupMenu then
  // begin
  // TmpPop := TUniPopupMenu(Components[I]);
  // // if TmpPop.Name = Name then
  // // TmpPop.Popup(X, Y, UniDBGrid1);
  // end;
  // end;

  if EventName = '_pdf_result' then
  begin
    ShowMessage(EventName);
  end;

  if EventName = '_popafterclose' then
  begin
    ShowMessage(EventName);
  end;

  if EventName = '_popok' then
  begin
    // ShowMessage('OK');
    PopRes := 1;
  end;

  if EventName = '_popok' then
  begin
    // ShowMessage('OK');
    PopRes := 1;
  end;

  if EventName = '_popclose' then
  begin
    Pop := Params.Values['form'];
    Res := Params.Values['result'];
    // ShowMessage('PopUp Closed.[' + Pop + '][' + IntToStr(PopRes) + ']');
    if Pop = 'F01' then
    begin
      RunAction(self, 'GRRESULT.Select(VANALYTNR.Value);');
      RunAction(self, 'GRRESULT.NextNode();');
    end;
  end;

  if EventName = '_contextmenu' then
  begin
    Pop := Params.Values['pop'];
    Grid := Params.Values['grid'];
    LinkID := Params.Values['linkid'];
    mmLog.Lines.Add('pop:' + Pop);
    mmLog.Lines.Add('Grid:' + Grid);
    mmLog.Lines.Add('LinkID:' + LinkID);

    TmpPop := MainForm.FindComponent(Pop) as TUniPopupMenu;

    if TmpPop = Nil then
    begin
      DebugMsg('Tidak ketemu di Main form, cari di PopUp...');
      Co := GetCompByNamePopUp(Pop);
      if Co = Nil then
        raise Exception.Create('AJAX _contextmenu FindComponent Failure [' +
          Pop + ']');
      DebugMsg('Comp Class[' + Co.ClassName + ']');
      TmpPop := TUniPopupMenu(Co);
    end;

    TmpGrid := MainForm.FindComponent(Grid) as TUniDBGrid;

    if TmpGrid = Nil then
    begin
      DebugMsg('Tidak ketemu di Main form, cari di PopUp...');
      Co := GetCompByNamePopUp(Grid);
      if Co = Nil then
        raise Exception.Create('AJAX _contextmenu FindComponent Failure [' +
          Grid + ']');
      DebugMsg('Comp Class[' + Co.ClassName + ']');
      TmpGrid := TUniDBGrid(Co);
    end;

    // pmTest.Popup(Params.Values['x'].ToInteger(), Params.Values['y'].ToInteger(),
    // UniDBGrid1);

    TmpPop.Popup(Params.Values['x'].ToInteger(),
      Params.Values['y'].ToInteger(), TmpGrid);
  end;

  if EventName = '_visible' then
  begin
    Script := Params.Values['script'];
    Script := StringReplace(Script, ';', '', [rfReplaceAll, rfIgnoreCase]);
    mmLog.Lines.Add('_visible[' + Script + ']');
    Comp := Trim(SplitString(Script, '=')[0]);
    Value := Trim(SplitString(Script, '=')[1]);
    mmLog.Lines.Add('Comp[' + Comp + '] Value[' + Value + ']');

    if UpperCase(LeftStr(Comp, 2)) = 'FR' then
    begin
      mmLog.Lines.Add('Frame.');
      if ContainsText(Script, '_') then
        Co := PopUpFrm.FindComponent(SplitString(Comp, '_')[1]);
    end
    else
    begin
      mmLog.Lines.Add('PopUp.');
      if ContainsText(Script, '_') then
      begin
        mmLog.Lines.Add('Cari Component [' + Trim(Comp) + ']');
        Co := GetCompByNamePopUp(Trim(Comp));
      end;
    end;
    if PopUpFrm <> nil then
      mmLog.Lines.Add('Component ketemu [' + Co.Name + '][' +
        Co.ClassName + ']')
    else
      mmLog.Lines.Add('Component tidak ketemu.');

    if Co <> nil then
      if Co is TUniCheckBox then
        if UpperCase(Value) = 'TRUE' then
        begin
          TUniCheckBox(Co).Visible := True;
          TUniCheckBox(Co).SetFocus;
        end
        else
          TUniCheckBox(Co).Visible := false
      else if Co is TUniEdit then
        if UpperCase(Value) = 'TRUE' then
        begin
          TUniEdit(Co).Visible := True;
          TUniEdit(Co).SetFocus;
        end
        else
          TUniEdit(Co).Visible := false
      else if Co is TUniDBLookupComboBox then
        if UpperCase(Value) = 'TRUE' then
        begin
          TUniDBLookupComboBox(Co).Visible := True;
          TUniDBLookupComboBox(Co).SetFocus;
        end
        else
          TUniDBLookupComboBox(Co).Visible := false
      else
        raise Exception.Create('Ajax Main Form _visible: component [' + Co.Name
          + '] unknown.');

  end;

  if (EventName = '_disable') or (EventName = '_enable') then
  begin
    Script := Params.Values['script'];

    if Trim(Script) = '' then
      exit;

    mmLog.Lines.Add('_disable[' + Script + '][' + EventName + ']');
    if UpperCase(LeftStr(Script, 2)) = 'FR' then
    begin
      mmLog.Lines.Add('Frame.');
      Co := MainForm.FindComponent(Script);
      if Co = Nil then
        if ContainsText(Script, '_') then
          Co := PopUpFrm.FindComponent(SplitString(Script, '_')[1]);
    end
    else
    begin
      mmLog.Lines.Add('PopUp.');
      if ContainsText(Script, '_') then
      begin
        mmLog.Lines.Add('Cari Component [' + Trim(Script) + ']');
        Co := GetCompByNamePopUp(Trim(Script));
      end;
    end;
    if PopUpFrm <> nil then
      mmLog.Lines.Add('Component ketemu [' + Co.Name + '][' +
        Co.ClassName + ']')
    else
      mmLog.Lines.Add('Component tidak ketemu.');

    if Co <> nil then
      if Co is TUniCheckBox then
        if EventName = '_enable' then
          TUniCheckBox(Co).Enabled := True
        else
          TUniCheckBox(Co).Enabled := false
      else if Co is TUniEdit then
        if EventName = '_enable' then
          TUniEdit(Co).Enabled := True
        else
          TUniEdit(Co).Enabled := false
      else if Co is TUniDBLookupComboBox then
        if EventName = '_enable' then
          TUniDBLookupComboBox(Co).Enabled := True
        else
          TUniDBLookupComboBox(Co).Enabled := false
      else if Co is TUniButton then
        if EventName = '_enable' then
          TUniButton(Co).Enabled := True
        else
          TUniButton(Co).Enabled := false
      else
        raise Exception.Create('Ajax Main Form _disable: component [' + Co.Name
          + '] unknown.');

  end;

  if (EventName = '_setfocus') then
  begin
    Script := Params.Values['script'];
    mmLog.Lines.Add('_setfocus[' + Script + '][' + EventName + ']');
    if UpperCase(LeftStr(Script, 2)) = 'FR' then
    begin
      mmLog.Lines.Add('Frame.');
      Co := MainForm.FindComponent(Script);
      if Co = Nil then
        if ContainsText(Script, '_') then
          Co := PopUpFrm.FindComponent(SplitString(Script, '_')[1]);
    end
    else
    begin
      mmLog.Lines.Add('PopUp.');
      if ContainsText(Script, '_') then
      begin
        mmLog.Lines.Add('Cari Component [' + Trim(Script) + ']');
        Co := GetCompByNamePopUp(Trim(Script));
      end;
    end;
    if PopUpFrm <> nil then
      mmLog.Lines.Add('Component ketemu [' + Co.Name + '][' +
        Co.ClassName + ']')
    else
      mmLog.Lines.Add('Component tidak ketemu.');

    if Co <> nil then
      if Co is TUniCheckBox then
        TUniCheckBox(Co).SetFocus
      else if Co is TUniEdit then
        TUniEdit(Co).SetFocus
      else if Co is TUniDBLookupComboBox then
        TUniDBLookupComboBox(Co).SetFocus
      else if Co is TUniButton then
        TUniButton(Co).SetFocus
      else
        raise Exception.Create('Ajax Main Form _disable: component [' + Co.Name
          + '] unknown.');

  end;

  if EventName = '_buttonclick' then
  begin
    // ShowMask('Loading');
    // UniSession.Synchronize();
    Script := Params.Values['script'];
    FormParent := Params.Values['formparent'];
    FormChild := Params.Values['formchild'];
    mmLog.Lines.Add('_buttonclick Script => ' + Script);

    if ContainsText(Script, '.Close') then
    begin
      Frm := UniApplication.FindComponent
        (UpperCase(Trim(SplitString(Script, '.')[0]))) as TfrmPopUp;

      mmLog.Lines.Add('CLOSE [' + Script + '][' +
        UpperCase(Trim(SplitString(Script, '.')[0])) + ']');
      if Assigned(Frm) then
      begin
        mmLog.Lines.Add('Found.');
        Frm.Close
      end
      else
        mmLog.Lines.Add('Not FOUND.');
    end
    else
      RunAction(self, Script);
    // HideMask;
  end;

  if EventName = '_set' then
  begin
    Script := Params.Values['script'];
    // DebugMsg('*** AJAX _SET ****[' + Script + ']');
    mmLog.Lines.Add('*** AJAX _SET ****[' + Script + ']');
    try
      SetCompValue(self, Trim(SplitString(Script, '=')[0]),
        GetCompValue(self, SplitString(Script, '=')[1]));
    except
      on E: Exception do
        ShowMessage('_set:' + E.Message);
    end;
  end;

  if EventName = '_setvalue' then
  begin
    // ShowMask('Loading');
    UniSession.Synchronize();
    Script := Params.Values['script'];
    mmLog.Lines.Add('Script => ' + Script);

    Comp := Trim(SplitString(Script, '.')[1]);
    mmLog.Lines.Add('Comp => ' + Comp);
    Value := SplitString(SplitString(Script, '(')[1], ')')[0];
    Value := StringReplace(Value, '''', '', [rfReplaceAll, rfIgnoreCase]);
    mmLog.Lines.Add('Value => ' + Value);

    try
      SetCompValue(self, Comp, Value);
    except
      on E: Exception do
        ShowMessage('_setvalue:' + E.Message);
    end;
    // HideMask;
  end;

  if EventName = '_cellkeypress' then
  begin
    Script := Params.Values['script'];
    ShowMessage(Script);
  end;

  // _celldblclick
  if EventName = '_celldblclick' then
  begin
    ShowMask('Loading');
    UniSession.Synchronize();
    Script := Params.Values['script'];
    mmLog.Lines.Add('_celldblclick => ' + Script);
    if ContainsText(Script, '.Close') then
    begin
      Frm := UniApplication.FindComponent
        (UpperCase(Trim(SplitString(Script, '.')[0]))) as TfrmPopUp;
      if Assigned(Frm) then
      begin
        Frm.Close
      end;
    end
    else
      RunAction(self, Script);
    HideMask;
  end;
end;

procedure TMainForm.UniFormBeforeShow(Sender: TObject);
begin
  GetMainMenu(self);
  PopRes := 0;
end;

procedure TMainForm.UniFormClose(Sender: TObject; var Action: TCloseAction);
begin
  FNameList.Free;
end;

procedure TMainForm.UniFormCreate(Sender: TObject);
var
  I: Integer;
begin
  Randomize;
  FNameIndex := 0;
  FNameList := TStringList.Create;
  FNameList.Add('Name1');
  FNameList.Add('Name2');
  FNameList.Add('Name3');
  FNameList.Add('Name4');
  FNameList.Add('Name5');
  FNameList.Add('Name6');
  FNameList.Add('Name7');
  FNameList.Add('Name8');
  FNameList.Add('Name9');
  FNameList.Add('Name10');
  FNameList.Add('Name11');
  FNameList.Add('Name12');
  FNameList.Add('Name13');
  FNameList.Add('Name14');
  FNameList.Add('Name15');
  FNameList.Add('Name16');
  FNameList.Add('Name17');
  FNameList.Add('Name18');
  FNameList.Add('Name19');
  FNameList.Add('Name20');
  FNameList.Add('Name21');
  FNameList.Add('Name22');
  FNameList.Add('Name23');
  FNameList.Add('Name24');
  FNameList.Add('Name25');
  FNameList.Add('Name26');
  FNameList.Add('Name27');
  FNameList.Add('Name28');
  FNameList.Add('Name29');
  FNameList.Add('Name30');

  for I := 1 to 100 do
    FNameList.Exchange(Random(FNameList.Count - 1),
      Random(FNameList.Count - 1));
end;

procedure TMainForm.UniTabSheet1Close(Sender: TObject; var AllowClose: Boolean);
var
  Ts: TUniTabSheet;
  Nd: TUniTreeNode;
begin
  Ts := Sender as TUniTabSheet;
  Nd := Pointer(Ts.Tag);
  if Assigned(Nd) then
  begin
    Nd.Data := nil;
    if NavTree.Selected = Nd then
      NavTree.Selected := nil;
  end;
end;

procedure TMainForm.UniToolButton1Click(Sender: TObject);
begin
  NavTree.FullExpand;
end;

procedure TMainForm.UniToolButton2Click(Sender: TObject);
begin
  NavTree.FullCollapse;
end;

procedure TMainForm.UniToolButton4Click(Sender: TObject);
var
  I: Integer;
  Ts: TUniTabSheet;
begin
  for I := UniPageControl1.PageCount - 1 downto 0 do
  begin
    Ts := UniPageControl1.Pages[I];
    if Ts.Closable then
      Ts.Close;
  end;
end;

initialization

RegisterAppFormClass(TMainForm);

end.

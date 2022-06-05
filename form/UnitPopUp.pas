unit UnitPopUp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniGUIBaseClasses, uniMemo, uniBasicGrid,
  uniDBGrid, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, XMLIntf, XMLDoc, Xml.xmldom,
  Xml.Win.msxmldom, Xml.omnixmldom, UnitBuildControls, uniButton, uniPanel,
  StrUtils, uniGroupBox, uniURLFrame, uniHTMLFrame, uniSplitter;

type
  TfrmPopUp = class(TUniForm)
    FDStoredProc1: TFDStoredProc;
    DataSource1: TDataSource;
    XMLDoc: TXMLDocument;
    FDQuery1: TFDQuery;
    UniSplitter1: TUniSplitter;
    procedure UniFormBeforeShow(Sender: TObject);
    procedure UniFormAjaxEvent(Sender: TComponent; EventName: string;
      Params: TUniStrings);
    procedure UniButton1Click(Sender: TObject);
    procedure UniFormClose(Sender: TObject; var Action: TCloseAction);
    procedure UniFormReady(Sender: TObject);
    procedure UniFormAfterShow(Sender: TObject);

  private
    { Private declarations }
    procedure DebugMsg(const Msg: String);

  var
    exeSP: TFDStoredProc;
    XmlScript, FormParent, FormChild: string;
  public
    { Public declarations }
    procedure ResOk(Sender: TObject);

  var
    FORMID, XMLID: integer;
    Param, CallerFormName, StrOut, OnShowRun: String;
    PopRes: integer;
  end;

function frmPopUp: TfrmPopUp;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, Main, UnitGuiDebug, UnitReportJasper;

function frmPopUp: TfrmPopUp;
begin
  Result := TfrmPopUp(UniMainModule.GetFormInstance(TfrmPopUp));
end;

procedure TfrmPopUp.ResOk(Sender: TObject);
begin
  PopRes := 1;
end;

procedure TfrmPopUp.DebugMsg(const Msg: String);
begin
  OutputDebugString(PChar(Msg + char(10)))
end;

procedure TfrmPopUp.UniButton1Click(Sender: TObject);
begin
  // UniSession.AddJS(UniMemo2.Lines.Text);
end;

procedure TfrmPopUp.UniFormAfterShow(Sender: TObject);
var
  Fr: TUniURLFrame;
begin

end;

procedure TfrmPopUp.UniFormAjaxEvent(Sender: TComponent; EventName: string;
  Params: TUniStrings);
var
  Script, Job: string;
  Frm: TfrmPopUp;
begin
  // if EventName = '_buttonclick' then
  // begin
  // ShowMask('Loading');
  // UniSession.Synchronize();
  // Script := Params.Values['script'];
  // DebugMsg('AJAX run:' + Script);
  // RunAction(self, Script);
  // if ContainsText(Script, '.Close') then
  // begin
  // Frm := UniApplication.FindComponent
  // (UpperCase(Trim(SplitString(Script, '.')[0]))) as TfrmPopUp;
  // if Assigned(Frm) then
  // begin
  // Frm.Close
  // end;
  // end
  // else
  // RunAction(self, Script);
  // HideMask;
  // end;

  if EventName = '_pdf_result' then
  begin
    Job := Params.Values['job'];
    // ShowMessage(Job);
    ShowMask('Loading');
    // UniSession.Synchronize();
    // UrlFrm.Visible := True;
    // UrlFrm.URL := reportExecReqParams('html', 'RESULT_REPORT', Job, 'N', '');
    //
    // UniSession.Synchronize();
    // ShowMessage(UrlFrm.URL);
    HideMask;
  end;

  if EventName = '_buttonclick' then
  begin
    // ShowMask('Loading');
    // UniSession.Synchronize();
    Script := Params.Values['script'];
    // UniMemo1.Lines.Add('script:' + Script);
    // cek script apakah form close
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
    // HideMask;
  end;

  // _celldblclick
  if EventName = '_celldblclick' then
  begin
    ShowMask('Loading');
    UniSession.Synchronize();
    Script := Params.Values['script'];
    // UniMemo1.Lines.Add('_celldblclick => ' + Script);
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

procedure TfrmPopUp.UniFormBeforeShow(Sender: TObject);
var
  treeNode, Level_0_Node, Level_1_Node, Level_2_Node, Level_3_Node: IXMLNode;
  I: integer;
  treeXMLID, compXMLID, compDesc, XmlScript: string;
  Pn: TUniPanel;
  Gb: TUniGroupBox;
  Fr: TUniURLFrame;
begin
  PopRes := 0;

  try
    // UniMemo1.Lines.Clear;
    // UniMemo1.Lines.Add('FORMID:' + IntToStr(FORMID));
    // UniMemo1.Lines.Add('XMLID:' + IntToStr(XMLID));
    // UniMemo1.Lines.Add('PARAM:' + Param);
    // UniMemo1.Lines.Add('StrOut:' + StrOut);
    // UniMemo1.Lines.Add
    // ('-----------------------------------------------------------------------');

    // find Xml
    exeSP := TFDStoredProc.Create(self);
    // UniMemo1.Lines.Add('Create');
    exeSP.Connection := UniMainModule.FDConn;
    // UniMemo1.Lines.Add('Connection');
    exeSP.FetchOptions.AutoClose := false;
    // UniMemo1.Lines.Add('AutoClose');
    exeSP.PackageName := 'DATOS_PRJ.ZULU_SUPPORT';
    // UniMemo1.Lines.Add('PackageName');
    exeSP.StoredProcName := 'getFormWrappedInCursor';
    // UniMemo1.Lines.Add('StoredProcName');
    exeSP.Prepare;
    // UniMemo1.Lines.Add('Prepare');
    exeSP.ParamByName('pFormID').Value := XMLID;
    // UniMemo1.Lines.Add('ParamByName()');
    exeSP.ParamByName('pLanguage').Value := 'EN';
    // UniMemo1.Lines.Add('pLanguage');
    exeSP.ParamByName('pClientAppVersion').Value := MainForm.appClientVer;
    // UniMemo1.Lines.Add('pClientAppVersion');
    exeSP.Open();
    // UniMemo1.Lines.Add('Open()');
    exeSP.First;
    // UniMemo1.Lines.Add('First()');

    DataSource1.DataSet := exeSP;

    XmlScript := exeSP.FieldByName('SCRIPT').AsString;

    // ShowMessage(XmlScript);
    // UniMemo1.Clear;

    // UniMemo1.Lines.Add(exeSP.FieldByName('SCRIPT').AsString);
    // UniMemo1.Lines.Add('LineAdd()');

    XMLDoc.LoadFromXML(XmlScript);
    XMLDoc.Active := True;

    Level_0_Node := XMLDoc.DocumentElement;

    if not VarIsNull(Level_0_Node.Attributes['HEIGHT']) then
      self.Height := StrToInt(Level_0_Node.Attributes['HEIGHT']) + 5;
    if not VarIsNull(Level_0_Node.Attributes['WIDTH']) then
      self.Width := StrToInt(Level_0_Node.Attributes['WIDTH']);

    if not VarIsNull(Level_0_Node.Attributes['ID']) then
      self.Name := Level_0_Node.Attributes['ID'];

    // Special variable
    BuildPreVariable(self, 'USER', self.Name);
    // HARCODE
    if (Not ContainsText(self.Name, 'PopHistory')) and
      (Not ContainsText(self.Name, 'PopOrderHist')) then
      SetCompValue(self, self.Name + '_USER',
        UniApplication.Cookies.GetCookie('UserName'));

    BuildPreVariable(self, 'MANDANT', self.Name);
    // HARCODE
    if Not ContainsText(self.Name, 'PopHistory') then
      SetCompValue(self, self.Name + '_MANDANT', MainForm.defLoc);

    self.Position := poDesktopCenter;

    // UniMemo1.Lines.Add('LineAdd()');

    if not VarIsNull(Level_0_Node.Attributes['ONSHOW']) then
      OnShowRun := Level_0_Node.Attributes['ONSHOW'];

    self.OnAfterShow := MainForm.PoUpAfterShow;

    // TODO: HARCODE
    if self.Name = 'foBefund' then
    begin
      for I := 0 to Level_0_Node.ChildNodes.Count - 1 do
      begin
        if Level_0_Node.ChildNodes[I].NodeName = 'Variable' then
        begin
          BuildVariable(self, Level_0_Node.ChildNodes[I], self.Name);
        end;
      end;
      exit;
    end;

    for I := 0 to Level_0_Node.ChildNodes.Count - 1 do
    begin
      if Level_0_Node.ChildNodes[I].NodeName = 'PopupEx' then
      begin
        if not VarIsNull(Level_0_Node.ChildNodes[I]) then
        begin
          BuildPopupEx(self, Level_0_Node.ChildNodes[I], self.Name);
        end;
      end;
      if Level_0_Node.ChildNodes[I].NodeName = 'ScriptEx' then
      begin
        if not VarIsNull(Level_0_Node.ChildNodes[I]) then
        begin
          BuildScriptEx(self, Level_0_Node.ChildNodes[I], self.Name);
        end;
      end;
      if Level_0_Node.ChildNodes[I].NodeName = 'Variable' then
      begin
        BuildVariable(self, Level_0_Node.ChildNodes[I], self.Name);
      end;
      if Level_0_Node.ChildNodes[I].NodeName = 'QueryEx' then
      begin
        BuildQuery(self, Level_0_Node.ChildNodes[I], self.Name);
      end;
      if Level_0_Node.ChildNodes[I].NodeName = 'MsgDialog' then
      begin
        BuildMsgDialog(self, Level_0_Node.ChildNodes[I], self.Name);
      end;
      if Level_0_Node.ChildNodes[I].NodeName = 'PanelEx' then
      begin
        // Pn := BuildPanel(self, Level_0_Node.ChildNodes[I]);
        // Pn.Align := alClient;
        // Pn.Visible := True;
        // Pn.Parent := self;
        self.InsertControl(BuildPanel(self, Level_0_Node.ChildNodes[I]));
      end;
      if Level_0_Node.ChildNodes[I].NodeName = 'GroupBox' then
      begin
        Gb := BuildGroupBox(self, Level_0_Node.ChildNodes[I]);
        Gb.Parent := self;
      end;
      if Level_0_Node.ChildNodes[I].NodeName = 'Combo' then
      begin
        self.InsertControl(BuildCombo(self, Level_0_Node.ChildNodes[I]));
      end;
    end;

    XMLDoc.Active := false;

  except
    on E: Exception do
      MainForm.MessageDlg(E.Message, mtError, [mbOk], nil);
  end;


  //
  // BuildControls(self, XmlScript);

  // XMLDoc.LoadFromXML(XmlScript);
  // XMLDoc.Active := True;
  //
  // Level_0_Node := XMLDoc.DocumentElement;
  // //
  // self.Height := StrToInt(Level_0_Node.Attributes['HEIGHT']) + 5;
  // //
  // for I := 0 to Level_0_Node.ChildNodes.Count - 1 do
  // begin
  // if Level_0_Node.ChildNodes[I].NodeName = 'PopupEx' then
  // begin
  // if not VarIsNull(Level_0_Node.ChildNodes[I]) then
  // begin
  // BuildPopupEx(self, Level_0_Node.ChildNodes[I], self.Name);
  // end;
  // end;
  // if Level_0_Node.ChildNodes[I].NodeName = 'ScriptEx' then
  // begin
  // if not VarIsNull(Level_0_Node.ChildNodes[I]) then
  // begin
  // BuildScriptEx(self, Level_0_Node.ChildNodes[I], self.Name);
  // end;
  // end;
  // if Level_0_Node.ChildNodes[I].NodeName = 'Variable' then
  // begin
  // BuildVariable(self, Level_0_Node.ChildNodes[I], self.Name);
  // end;
  // if Level_0_Node.ChildNodes[I].NodeName = 'QueryEx' then
  // begin
  // BuildQuery(self, Level_0_Node.ChildNodes[I], self.Name);
  // end;
  // if Level_0_Node.ChildNodes[I].NodeName = 'PanelEx' then
  // begin
  // Pn := BuildPanel(self, Level_0_Node.ChildNodes[I]);
  // Pn.Parent := self;
  // end;
  // end;
  //
  // XMLDoc.Active := false;

  // read XML
  // XMLDoc.LoadFromXML(exeSP.FieldByName('SCRIPT').AsString);
  // XMLDoc.Active := True;
  // treeXMLID := XMLDoc.ChildNodes['TREE'].Attributes['XMLID'];
  //
  // treeNode := XMLDoc.ChildNodes['TREE'];
  // compXMLID := treeNode.ChildNodes['ACOMPONENT'].Attributes['XMLID'];
  // compDesc := treeNode.ChildNodes['ACOMPONENT'].Attributes['NAME'];

  //
  // // load XML component
  // if exeSP.Active then
  // exeSP.Active := false;
  // exeSP.PackageName := 'DATOS_PRJ.ZULU_SUPPORT';
  // exeSP.StoredProcName := 'getFormWrappedInCursor';
  // exeSP.Prepare;
  // exeSP.ParamByName('pFormID').Value := compXMLID;
  // exeSP.ParamByName('pLanguage').Value := 'EN';
  // exeSP.ParamByName('pClientAppVersion').Value := MainForm.appClientVer;
  // exeSP.Open();
  // exeSP.First;

  DataSource1.DataSet := exeSP;
end;

procedure TfrmPopUp.UniFormClose(Sender: TObject; var Action: TCloseAction);
var
  Co: TComponent;
  SValue1: String;
  Fr: TUniURLFrame;
begin

  // OnClosePopUp(self);

  // UniSession.AddJS('ajaxRequest(MainForm.form, "_popclose" , ["form=' +
  // self.Name + '","result=' + IntToStr(PopRes) + '",false]);');

  {
    <ScriptEx ID="scSelectionPop" JS="Y"><![CDATA[
    POPSEARCH.OpenUpd();
    RUN('VORDERDATEFROM.Set(PAUFTDAT_FROM)');
    RUN('VORDERDATETO.Set(PAUFTDAT_TO)');
    VINTINSTRUMENT.Value = VINSTRUMENT.Value;
    VINTINSTRUMENTGROUP.Value = VINSTRUMENTGROUP.Value;
    QSEARCHORDER.Execute();
    GRALL.FirstNode();
    QSEARCHORDERINFO.Execute();
    ST1.Execute();
    ]]></ScriptEx>
  }

  // HARCODE Close PopUP
  // TODO : buat engine otomatis

  if (self.Name = 'F01') and (PopRes = 1) then
  begin
    {
      GRALL.Refresh();
      GRRESULT.Select(VANALYTNR.Value);
      GRRESULT.NextNode();
    }
    RunAction(MainForm, 'GRALL.Refresh();');

    UniSession.AddJS('ajaxRequest(MainForm.form, "_popclose" , ["form=' +
      self.Name + '","result=' + IntToStr(PopRes) + '",false]);');

  end;

  if (self.Name = 'Daylist_Selection') and (PopRes = 1) then
  begin
    DebugMsg('UniFormClose() [Daylist_Selection]');
    // 1. RUN('VORDERDATEFROM.Set(PAUFTDAT_FROM)');
    SValue1 := GetCompValue(self, 'DAYLIST_SELECTION_EAUFTDAT_FROM');
    DebugMsg('UniFormClose() Comp Value: ' + SValue1);
    Co := GetCompByNameMain('fr5120_vOrderDateFrom');
    DebugMsg('UniFormClose() Main Comp Name: ' + Co.Name);
    SetCompValue(MainForm, Co.Name, SValue1);

    // 2. RUN('VORDERDATETO.Set(PAUFTDAT_TO)');
    SValue1 := GetCompValue(self, 'DAYLIST_SELECTION_EAUFTDAT_TO');
    DebugMsg('UniFormClose() Comp Value: ' + SValue1);
    Co := GetCompByNameMain('fr5120_vOrderDateTo');
    DebugMsg('UniFormClose() Main Comp Name: ' + Co.Name);
    SetCompValue(MainForm, Co.Name, SValue1);

    // 3. VINTSENDER.Value = VSENDER.Value;
    SValue1 := GetCompValue(self, 'DAYLIST_SELECTION_VSENDER');
    DebugMsg('UniFormClose() Comp Value: ' + SValue1);
    Co := GetCompByNameMain('fr5120_VINTSENDER');
    DebugMsg('UniFormClose() Main Comp Name: ' + Co.Name);
    SetCompValue(MainForm, Co.Name, SValue1);

    // 4. VINTSENDERGROUP.Value = VSENDERGROUP.Value;
    SValue1 := GetCompValue(self, 'DAYLIST_SELECTION_VSENDERGROUP');
    DebugMsg('UniFormClose() Comp Value: ' + SValue1);
    Co := GetCompByNameMain('fr5120_VINTSENDERGROUP');
    DebugMsg('UniFormClose() Main Comp Name: ' + Co.Name);
    SetCompValue(MainForm, Co.Name, SValue1);

    // 5. VINTSENDERGROUP.Value = VSENDERGROUP.Value;
    SValue1 := GetCompValue(self, 'DAYLIST_SELECTION_VSENDERGROUP');
    DebugMsg('UniFormClose() Comp Value: ' + SValue1);
    Co := GetCompByNameMain('fr5120_VINTSENDERGROUP');
    DebugMsg('UniFormClose() Main Comp Name: ' + Co.Name);
    SetCompValue(MainForm, Co.Name, SValue1);


    // UniSession.AddJS('ajaxRequest(MainForm.form, "_popclose" , ["form=' +
    // self.Name + '","result=' + IntToStr(PopRes) + '",false]);');

    // 6. QSEARCHORDER.Execute();
    RunAction(MainForm, 'QSEARCHORDER.Execute();');

    // 7. GRALL.FirstNode();
    RunAction(MainForm, 'GRALL.FirstNode();');

    // 8. QSEARCHORDERINFO.Execute();
    RunAction(MainForm, 'QSEARCHORDERINFO.Execute();');
    // 9. ST1.Execute();
    // RunAction(MainForm, 'ST1.Execute();');
  end;

end;

procedure TfrmPopUp.UniFormReady(Sender: TObject);
var
  FdSP: TFDStoredProc;
  Job: integer;
begin

  DebugMsg('454 self.Name[' + self.Name + ']');
  // HARDCODE before show

  if self.Name = 'foPrevalues' then
  begin
    DebugMsg('436 OnShow [' + self.Name + '][' + OnShowRun + ']');
    RunAction(self, OnShowRun);
  end;

  if self.Name = 'foBefund' then
  begin
    // ShowMask('Loading');

    Job := 0;
    // UniSession.Synchronize();

    FdSP := TFDStoredProc.Create(nil);
    try
      FdSP.Connection := UniMainModule.FDConn;
      FdSP.PackageName := 'datos_prj.befund';
      FdSP.StoredProcName := 'erzeugen';
      FdSP.Prepare;
      FdSP.ParamByName('PTYP').Value := 'E';
      FdSP.ParamByName('PFRMNR').Value := '10';
      FdSP.ParamByName('PSEQNR').Value := GetCompValue(self, 'foBefund_seqnr');
      FdSP.ParamByName('PLOCAL').Value := 'LAB1';

      FdSP.Execute;
      FdSP.Connection.Commit;

      Job := FdSP.ParamByName('RESULT').AsInteger;

      UniSession.AddJS('ajaxRequest(' + self.Name +
        '.form, "_pdf_result" , ["job=' + IntToStr(Job) + '"]);');

    finally
      FdSP.Free;
    end;

    // UrlFrm.URL := reportExecReqParams('pdf', 'RESULT_REPORT',
    // IntToStr(job), 'N', '');

    // HideMask;
  end;
end;

end.

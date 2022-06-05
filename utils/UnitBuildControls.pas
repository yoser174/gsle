unit UnitBuildControls;

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
  uniDBListBox, uniDBLookupListBox, uniDateTimePicker, uniGUIVars, MainModule,
  uniGUIApplication, UnitCommons, UniHTMLFrame;

function BuildPanel(AOwner: TComponent; XmlNd: IXMLNode): TUniPanel;
function BuildGroupBox(AOwner: TComponent; XmlNd: IXMLNode): TUniGroupBox;
function BuildLabel(AOwner: TComponent; XmlNd: IXMLNode): TUniLabel;
function BuildDate(AOwner: TComponent; XmlNd: IXMLNode): TUniDateTimePicker;
function BuildEdit(AOwner: TComponent; XmlNd: IXMLNode): TUniEdit;
function BuildLookup(AOwner: TComponent; XmlNd: IXMLNode): TUniDBLookupComboBox;
function BuildCheck(AOwner: TComponent; XmlNd: IXMLNode): TUniCheckBox;
function BuildDBGrid(AOwner: TComponent; XmlNd: IXMLNode): TUniDBGrid;
function BuildCombo(AOwner: TComponent; XmlNd: IXMLNode): TUniComboBox;
function BuildPageControl(AOwner: TComponent; XmlNd: IXMLNode): TUniPageControl;
function BuildTabSheet(AOwner: TComponent; XmlNd: IXMLNode; Pc: TUniPageControl)
  : TUniTabSheet;
function BuildContainerPanel(AOwner: TComponent; XmlNd: IXMLNode;
  Ts: TUniTabSheet): TUniPanel;
function GetCompByNameMain(ComponentName: String): TComponent;
function GetCompByName(AOwner: TComponent; ComponentName: String): String;
function GetCompByNameStr(AOwner: TComponent; ComponentName: String): String;
function GetCompomentByName(AOwner: TComponent; ComponentName: String)
  : TComponent;
function GetCompByNamePopUp(ComponentName: String): TComponent;
function GetCompValue(AOwner: TComponent; CompName: string): String;
procedure BuildPreVariable(AOwner: TComponent; VarName: string; frName: string);
procedure BuildVariable(AOwner: TComponent; XmlNd: IXMLNode; frName: string);
procedure BuildQuery(AOwner: TComponent; XmlNd: IXMLNode; frName: string);
procedure RunAction(AOwner: TComponent; Script: string);
procedure RunActionJS(AOwner: TComponent; JSScript: string);
procedure BuildScriptEx(AOwner: TComponent; XmlNd: IXMLNode; frName: string);
procedure BuildMsgDialog(AOwner: TComponent; XmlNd: IXMLNode; frName: string);
procedure BuildPopupEx(AOwner: TComponent; XmlNd: IXMLNode; frName: string);
procedure SetColumnGridFromDB(AOwner: TComponent; CompName: String);
procedure SetCompValue(AOwner: TComponent; CompName: string; Value: String);
procedure SetCompValFromDB(AOwner: TComponent; CompName: String;
  CompValue: string; DbCompaName: String);

procedure OnClosePopUp(AOwner: TComponent);

function getCompIfJs(AOwner: TComponent; Text: string;
  CompText: string): String;

procedure DebugMsg(const Msg: String);
function GetOwnerName(AOwner: TComponent): string;

const
  vendor = 'Roche';

var
  Ret, Pa02: integer;

implementation

Uses UnitPopUp, Main, UnitRepPerview, UnitComp, UnitPopUpForm;

procedure DebugMsg(const Msg: String);
begin
  OutputDebugString(PChar(Msg + char(10)));
  // MainForm.mmLog.Lines.Add(Msg);
end;

function GetOwnerName(AOwner: TComponent): string;
var
  FromName: string;
begin
  FromName := AOwner.Name;
  if UpperCase(AOwner.Name) = 'MAINFORM' then
  begin
    FromName := MainForm.ActiveFormName;
  end;
  Result := FromName;
end;

function GetOwnerNameByCompNameJS(AOwner: TComponent; CompName: string): String;
begin
  DebugMsg('GetOwnerNameByCompNameJS(' + CompName + ')');
  if (LeftStr(UpperCase(CompName), 2) = 'MA') or
    (LeftStr(UpperCase(CompName), 2) = 'FR') then
    Result := 'MainForm'
  else if LeftStr(UpperCase(CompName), 3) = 'F01' then
    Result := SplitString(CompName, '_')[0]
  else
    Result := GetOwnerName(AOwner);
  DebugMsg('Result[' + Result + ']');
end;

function GetOwnerNameJS(AOwner: TComponent): string;
var
  FromName: string;
begin

  FromName := AOwner.Name;
  if (LeftStr(UpperCase(AOwner.Name), 2) = 'MA') or
    (LeftStr(UpperCase(AOwner.Name), 2) = 'FR') then
    Result := 'MainForm'
  else if LeftStr(UpperCase(AOwner.Name), 3) = 'F01' then
    Result := SplitString(AOwner.Name, '_')[0]
  else
    Result := FromName;

  DebugMsg('Result[' + Result + ']');
end;

function FixCompName(ComponentName: String): String;
begin
  if ContainsText(ComponentName, '_X_') then
  begin
    // DebugMsg('FixCompName(' + ComponentName + ')');
    // DebugMsg('***Component name ada _X_ !');
    ComponentName := StringReplace(ComponentName, '_X_', '|',
      [rfReplaceAll, rfIgnoreCase]);
    ComponentName := Trim(SplitString(ComponentName, '|')[0]);
    // DebugMsg('Convert [' + ComponentName + ']');
  end;
  Result := ComponentName;
end;

function GetCompByNameMain(ComponentName: String): TComponent;
var
  ActiveForm, SVar1, SVar2: string;
  I: integer;
  Co: TComponent;
begin
  DebugMsg('137 GetCompByNameMain');
  Result := Nil;
  for I := 0 to MainForm.ComponentCount - 1 do
  begin
    SVar1 := UpperCase(MainForm.Components[I].Name);
    SVar1 := FixCompName(SVar1);
    SVar2 := UpperCase(Trim(ComponentName));
    SVar2 := FixCompName(SVar2);

    if MainForm.Components[I].Name <> '' then
    begin
      if ContainsText(UpperCase(ComponentName), 'SCCHECKDELCOMMENT') then
        DebugMsg('142 Komponen[' + SVar1 + '] cari [' + SVar2 + ']');
      if SVar1 = SVar2 then
      begin
        Co := TUniComponent(MainForm.Components[I]);
        DebugMsg('146 Ketemu Value [' + Co.Name + ']');
        Result := Co;
        exit;
      end;
    end;
  end;
end;

function GetCompByNamePopUp(ComponentName: String): TComponent;
var
  ActiveForm, SVar1, SVar2: string;
  I: integer;
  Co: TComponent;
begin
  Result := Nil;
  ActiveForm := TuniForm(UniSession.FormsList[UniSession.FormsList.Count
    - 1]).Name;
  // DebugMsg('144 GetCompByNamePopUp() Active From not "MainForm" = ' +
  // ActiveForm);
  for I := 0 to TuniForm(UniSession.FormsList[UniSession.FormsList.Count - 1])
    .ComponentCount - 1 do
  begin
    SVar1 := UpperCase(TuniForm(UniSession.FormsList[UniSession.FormsList.Count
      - 1]).Components[I].Name);
    SVar1 := FixCompName(SVar1);
    SVar2 := UpperCase(Trim(ComponentName));
    SVar2 := FixCompName(SVar2);

    if ContainsText(UpperCase(SVar1), 'AUFGCD') then
      DebugMsg('172 SVar1[' + SVar1 + '] SVar2[' + SVar2 + ']');

    if (not ContainsText(SVar2, ActiveForm + '_')) and (ContainsText(SVar2, '_'))
    then
    begin
      SVar2 := ActiveForm + '_' + SplitString(SVar2, '_')[1];
    end;

    if TuniForm(UniSession.FormsList[UniSession.FormsList.Count - 1])
      .Components[I].Name <> '' then
    begin
      if ContainsText(UpperCase(SVar1), 'AUFGCD') then
        DebugMsg('158 Komponen[' + SVar1 + '] cari [' + SVar2 + ']');
      if SVar1 = SVar2 then
      begin
        Co := TUniComponent
          (TuniForm(UniSession.FormsList[UniSession.FormsList.Count - 1])
          .Components[I]);
        DebugMsg('181 Ketemu Value [' + Co.Name + ']');
        Result := Co;
        exit;
      end;
    end;
  end;

  // for I := 0 to TuniForm(UniSession.FormsList[UniSession.FormsList.Count - 1])
  // .ComponentCount - 1 do
  // begin
  // SVar1 := UpperCase(TuniForm(UniSession.FormsList[UniSession.FormsList.Count
  // - 1]).Components[I].Name);
  // SVar1 := FixCompName(SVar1);
  // SVar2 := UpperCase(Trim(ComponentName));
  // SVar1 := FixCompName(SVar2);
  // if TuniForm(UniSession.FormsList[UniSession.FormsList.Count - 1])
  // .Components[I].Name <> '' then
  // begin
  // DebugMsg('Komponen[' + SVar1 + '] cari [' + SVar2 + ']');
  // if SVar1 = SVar2 then
  // begin
  // Co := TComponent(UniSession.FormsList[UniSession.FormsList.Count - 1])
  // .Components[I];
  // DebugMsg('Ketemu Value [' + Co.Name + ']');
  // Result := Co;
  // end;
  // end;
  // end;
end;

function GetCompByName(AOwner: TComponent; ComponentName: String): String;
var
  I: integer;
  Co: TUniComponent;
  SVar1, SVar2, ActiveForm: string;
  BKetemu: boolean;
begin
  BKetemu := False;
  ActiveForm := TuniForm(UniSession.FormsList[UniSession.FormsList.Count
    - 1]).Name;
  DebugMsg('228 Active Form Name:' + ActiveForm);
  DebugMsg('229 GetCompByName():' + ComponentName);
  DebugMsg('230 GetCompByName() name search:' + UpperCase(GetOwnerName(AOwner) +
    '_' + UpperCase(Trim(ComponentName))));
  for I := 0 to AOwner.ComponentCount - 1 do
    // if AOwner.Components[I] is TUniComponent then
    // begin
    if AOwner.Components[I].Name <> '' then
    begin
      SVar1 := UpperCase(AOwner.Components[I].Name);
      SVar1 := FixCompName(SVar1);
      SVar2 := UpperCase(GetOwnerName(AOwner) + '_' +
        UpperCase(Trim(ComponentName)));
      if ContainsText(SVar2, 'MSDELKOMMENTAR') then
        DebugMsg('Komponen[' + SVar1 + '] cari [' + SVar2 + ']');
      if SVar1 = SVar2 then
      begin
        Co := TUniComponent(AOwner.Components[I]);
        DebugMsg('Ketemu Value [' + Co.Name + ']');
        BKetemu := True;
        Result := Co.Name;
      end;
      // end;
    end;

  if not BKetemu then
  begin
    DebugMsg('225 tidak ketemu [' + ComponentName + ']');
    if ActiveForm <> 'MainForm' then
    begin
      DebugMsg('258 Active From not "MainForm" = ' + ActiveForm);
      for I := 0 to TuniForm(UniSession.FormsList[UniSession.FormsList.Count -
        1]).ComponentCount - 1 do
      begin
        SVar1 := UpperCase
          (TuniForm(UniSession.FormsList[UniSession.FormsList.Count - 1])
          .Components[I].Name);
        SVar1 := FixCompName(SVar1);

        if not ContainsText(ComponentName, ActiveForm + '_') then
          SVar2 := UpperCase(ActiveForm + '_' + UpperCase(Trim(ComponentName)))
        else
          SVar2 := UpperCase(Trim(ComponentName));

        if TuniForm(UniSession.FormsList[UniSession.FormsList.Count - 1])
          .Components[I].Name <> '' then
        begin
          if ContainsText(SVar2, 'MSDELKOMMENTAR') then
            DebugMsg('272 Komponen[' + SVar1 + '] cari [' + SVar2 + ']');
          if SVar1 = SVar2 then
          begin
            Co := TUniComponent
              (TuniForm(UniSession.FormsList[UniSession.FormsList.Count - 1])
              .Components[I]);
            DebugMsg('269 Ketemu Value [' + Co.Name + ']');
            BKetemu := True;
            Result := Co.Name;
            exit;
          end;
        end;
      end;
    end;

  end;
end;

function GetCompByNameStr(AOwner: TComponent; ComponentName: String): String;
var
  I: integer;
  Mm: TUniMemo;
  bFound: boolean;
  SVar1: String;
begin

  bFound := False;
  for I := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[I].Name <> '' then
    begin
      // DebugMsg('Komponen[' + AOwner.Components[I].Name + '] cari [' +
      // GetOwnerName(AOwner) + '_' + UpperCase(Trim(ComponentName)) + ']');

      SVar1 := FixCompName(AOwner.Components[I].Name);
      if UpperCase(SVar1) = UpperCase(GetOwnerName(AOwner) + '_' +
        UpperCase(Trim(ComponentName))) then
      begin
        Mm := TUniMemo(AOwner.Components[I]);
        DebugMsg('Ketemu Value [' + Mm.Name + ']');
        Result := Mm.Lines.Text;
      end;
    end;

  // if bFound then
  // begin
  // Mm := TUniMemo(AOwner.Components[I]);
  // DebugMsg('Ketemu Value [' + Mm.Name + ']');
  // Result := Mm.Lines.Text;
  // end
  // else
  // Result := '';
end;

function GetCompomentByName(AOwner: TComponent; ComponentName: String)
  : TComponent;
var
  I: integer;
  Lo: TUniDBLookupComboBox;
  La: TUniLabel;
  Ed: TUniEdit;
  SVar1: string;
begin

  if UpperCase(LeftStr(ComponentName, 2)) = 'LO' then
    DebugMsg('Lookup DB..');
  for I := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[I] is TUniDBLookupComboBox then
    begin
      if AOwner.Components[I].Name <> '' then
      begin
        SVar1 := FixCompName(AOwner.Components[I].Name);
        // DebugMsg('Komponen[' + SVar1 + '] cari [' + GetOwnerName(AOwner) + '_' +
        // UpperCase(Trim(ComponentName)) + ']');
        if UpperCase(SVar1) = UpperCase(GetOwnerName(AOwner) + '_' +
          UpperCase(Trim(ComponentName))) then
        begin
          Lo := TUniDBLookupComboBox(AOwner.Components[I]);
          DebugMsg('Ketemu Value [' + Lo.Name + ']');
          Result := Lo;
        end;
      end;
    end;
  if UpperCase(LeftStr(ComponentName, 2)) = 'ED' then
    DebugMsg('Edit..');
  for I := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[I] is TUniEdit then
    begin
      if AOwner.Components[I].Name <> '' then
      begin
        SVar1 := FixCompName(AOwner.Components[I].Name);
        // DebugMsg('Komponen[' + SVar1 + '] cari [' + GetOwnerName(AOwner) + '_' +
        // UpperCase(Trim(ComponentName)) + ']');
        if UpperCase(SVar1) = UpperCase(GetOwnerName(AOwner) + '_' +
          UpperCase(Trim(ComponentName))) then
        begin
          Ed := TUniEdit(AOwner.Components[I]);
          DebugMsg('Ketemu Value [' + Ed.Name + ']');
          Result := Ed;
        end;
      end;
    end;
  if UpperCase(LeftStr(ComponentName, 1)) = 'V' then
    DebugMsg('Label..');
  for I := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[I] is TUniLabel then
    begin
      if AOwner.Components[I].Name <> '' then
      begin
        SVar1 := FixCompName(AOwner.Components[I].Name);
        // DebugMsg('Komponen[' + SVar1 + '] cari [' + GetOwnerName(AOwner) + '_' +
        // UpperCase(Trim(ComponentName)) + ']');
        if UpperCase(SVar1) = UpperCase(GetOwnerName(AOwner) + '_' +
          UpperCase(Trim(ComponentName))) then
        begin
          La := TUniLabel(AOwner.Components[I]);
          DebugMsg('Ketemu Value [' + La.Name + ']');
          Result := La;
        end;
      end;
    end;
end;

function GetCompValue(AOwner: TComponent; CompName: string): String;
var
  Co: TComponent;
  TmpStr: string;
begin
  try
    DebugMsg('GetCompValue() ' + CompName);
    Co := AOwner.FindComponent(CompName);
    if Co = Nil then
      Co := AOwner.FindComponent(CompName + '_VAR');

    if Co = Nil then
    begin
      DebugMsg('Tidak ketemu di Main form, cari di PopUp...');
      Co := GetCompByNamePopUp(CompName);
      if Co = Nil then
        raise Exception.Create('403 GetCompValue() 304 FindComponent Failure ['
          + CompName + ']');
    end;

    if Co is TUniEdit then
    begin
      DebugMsg('TUniEdit [' + TUniEdit(Co).Text + ']');
      Result := TUniEdit(Co).Text
    end
    else if Co is TUniDBLookupComboBox then
      Result := TUniDBLookupComboBox(Co).Text
    else if Co is TUniDateTimePicker then
    begin
      TmpStr := formatdatetime('dd-mmm-yy', TUniDateTimePicker(Co).DateTime);
      if TmpStr = '30-Dec-99' then
        Result := ''
      else
        Result := TmpStr;
    end
    else if Co is TUniCheckBox then
    begin
      TmpStr := '0';
      if TUniCheckBox(Co).Checked then
        TmpStr := '1';
      Result := TmpStr;
    end
    else if Co is TUniLabel then
    begin
      DebugMsg('TUniLabel [' + TUniLabel(Co).Caption + ']');
      Result := TUniLabel(Co).Caption
    end
    else if Co is TUniMemo then
      Result := TUniMemo(Co).Lines.Text
    else
      raise Exception.Create('437 GetCompValue() : Component [' + Co.Name +
        '] unknown type.');
  except
    on E: Exception do
      MainForm.MessageDlg(E.Message, mtError, [mbOk], nil);
  end;
end;

function GetVarValue(AOwner: TComponent; VarName: String): string;
var
  Lb: TUniLabel;
  I: integer;
  Caption, SVar1: string;
begin
  VarName := FixCompName(VarName);

  // DebugMsg('GetVarValue...');
  Caption := '';
  // try
  // Lb := AOwner.FindComponent(UpperCase(GetOwnerName(AOwner) + '_' +
  // UpperCase(Trim(VarName)))) as TUniLabel;
  // Result := Lb.Caption;
  // except
  // Result := '';
  // end;
  for I := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[I] is TUniLabel then
    begin
      // DebugMsg('465 Komponen[' + AOwner.Components[I].Name + '] cari [' +
      // GetOwnerName(AOwner) + '_' + UpperCase(Trim(VarName)) + ']');
      SVar1 := FixCompName(AOwner.Components[I].Name);
      if UpperCase(SVar1) = UpperCase(GetOwnerName(AOwner) + '_' +
        UpperCase(Trim(VarName))) then
      begin
        Lb := TUniLabel(AOwner.Components[I]);
        // DebugMsg('Ketemu Value [' + Lb.Caption + ']');
        Caption := Lb.Caption;
      end;
    end;
  Result := Caption;
end;


// on Close PopUp

procedure OnClosePopUp(AOwner: TComponent);
begin
  DebugMsg('OnClosePopUp()');
end;

// Pop Up Window
procedure BuildPopupEx(AOwner: TComponent; XmlNd: IXMLNode; frName: string);
var
  Mm, MmNew: TUniMemo;
  I: integer;
  SChild: String;
begin

  Mm := TUniMemo.Create(AOwner);
  Mm.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];
  DebugMsg('************** Build PopupEx [' + Mm.Name +
    '] **********************');
  Mm.Lines.Add('ID=' + XmlNd.Attributes['ID']);
  if not VarIsNull(XmlNd.Attributes['TITLE']) then
    Mm.Lines.Add('TITLE=' + XmlNd.Attributes['TITLE']);
  if not VarIsNull(XmlNd.Attributes['PARAM']) then
    Mm.Lines.Add('PARAM=' + XmlNd.Attributes['PARAM']);
  if not VarIsNull(XmlNd.Attributes['FORMID']) then
    Mm.Lines.Add('FORMID=' + XmlNd.Attributes['FORMID']);
  if not VarIsNull(XmlNd.Attributes['XMLID']) then
    Mm.Lines.Add('XMLID=' + XmlNd.Attributes['XMLID']);
  if not VarIsNull(XmlNd.Attributes['WIDTH']) then
    Mm.Lines.Add('WIDTH=' + XmlNd.Attributes['WIDTH']);
  if not VarIsNull(XmlNd.Attributes['HEIGHT']) then
    Mm.Lines.Add('HEIGHT=' + XmlNd.Attributes['HEIGHT']);
  if not VarIsNull(XmlNd.Attributes['LEFT']) then
    Mm.Lines.Add('LEFT=' + XmlNd.Attributes['LEFT']);
  if not VarIsNull(XmlNd.Attributes['NLS_TITLE']) then
    Mm.Lines.Add('NLS_TITLE=' + XmlNd.Attributes['NLS_TITLE']);
  SChild := '';

  for I := 0 to XmlNd.ChildNodes.Count - 1 do
  begin
    if XmlNd.ChildNodes[I].NodeName = 'Variable' then
    begin

      SChild := GetOwnerName(AOwner) + '_' + XmlNd.ChildNodes[I]
        .Attributes['ID'];

      BuildVariable(AOwner, XmlNd.ChildNodes[I], GetOwnerName(AOwner));

      if not VarIsNull(XmlNd.Attributes['TYPE']) then
        SChild := SChild + ';TYPE=' + XmlNd.ChildNodes[I].Attributes['TYPE'];
      if not VarIsNull(XmlNd.Attributes['KEYFIELD']) then
        SChild := SChild + ';KEYFIELD=' + XmlNd.ChildNodes[I].Attributes
          ['KEYFIELD'];
      if not VarIsNull(XmlNd.Attributes['LINKID']) then
        SChild := SChild + ';LINKID=' + XmlNd.ChildNodes[I].Attributes
          ['LINKID'];
      Mm.Lines.Add(SChild);
    end;
  end;

  Mm.Visible := False;

  // build popup attribut message untuk new PopUp Method
  MmNew := TUniMemo.Create(MainForm);
  MmNew.Visible := False;
  MmNew.Name := 'POPUPNEW_' + UpperCase(XmlNd.Attributes['ID']);
  DebugMsg(MmNew.Name);
  DebugMsg(XmlNd.Xml);
  if not VarIsNull(XmlNd) then
    MmNew.Lines.Text := XmlNd.Xml;
end;

// MsgDialog
procedure BuildMsgDialog(AOwner: TComponent; XmlNd: IXMLNode; frName: string);
var
  Mm: TUniMemo;
begin
  Mm := TUniMemo.Create(AOwner);
  Mm.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];
  DebugMsg('266 MsgDialog:' + Mm.Name);
  Mm.Lines.Text := XmlNd.Xml;
  DebugMsg('570 Text:' + Mm.Lines.Text);
  Mm.Visible := False;
end;

// ScriptEx
procedure BuildScriptEx(AOwner: TComponent; XmlNd: IXMLNode; frName: string);
var
  Mm: TUniMemo;
  Script: string;
  Hf: TUniHTMLFrame;
begin
  Mm := TUniMemo.Create(AOwner);
  Mm.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];

  DebugMsg('BuildScriptEx:' + Mm.Name);
  Mm.Tag := 0;
  if not VarIsNull(XmlNd.Attributes['JS']) then
  begin
    Mm.Tag := 1;
    Script := '';
    if VarIsNull(XmlNd.Attributes['DYNAMIC']) then
    begin
      if XmlNd.Attributes['JS'] = 'Y' then
      begin
        if XmlNd.nodeType = ntText then
          Script := XmlNd.NodeValue
        else if not VarIsNull(XmlNd.ChildNodes.Get(0).NodeValue) then
          Script := XmlNd.ChildNodes.Get(0).NodeValue;

      end;
    end;
    Mm.Lines.Text := Script;
  end;
  if Mm.Tag = 0 then
    Mm.Lines.Text := XmlNd.NodeValue;
  Mm.Visible := False;

  /// HARDCODE HERE
  /// TODO: Buat Engine
  ///
  if Mm.Name = 'fr5120_scSelectionPop' then
  begin
    DebugMsg('Todo: harcode for :fr5120_scSelectionPop');
    Mm.Lines.Text := 'POPSEARCH.OpenUpd();';
  end;

  // scOnKeyEnterResultGrid
  if Mm.Name = 'fr5120_scOnKeyEnterResultGrid' then
  begin
    Mm.Lines.Clear;
    Mm.Lines.Add(' if (VACTIVE.Value == ' + QuotedStr('J') + ') ');
    Mm.Lines.Add('{');
    Mm.Lines.Add('VANALYTNR.Value = ANALYTNR.Value;');
    Mm.Lines.Add('POPRESULT.OpenUpd();');
    Mm.Lines.Add('}');
  end;
end;

function getCompIfJs(AOwner: TComponent; Text: string;
  CompText: string): String;
var
  SVar1, SVar2, SCompVar1, SCompVar2, ActiveForm: String;
  TmpStr, TmpStr0, TmpStr1: TStringDynArray;
  I, J: integer;
begin

  try
    DebugMsg('Call getCompIfJs()');
    DebugMsg('CompText:' + CompText);
    DebugMsg('* "=" ');
    TmpStr := SplitString(CompText, '=');

    /// HARDCODE
    /// TODO: create engine
    ///
    if Trim(CompText) = 'VANALYTNR.Value = ANALYTNR.Value;' then
    begin
      DebugMsg('597 SCompVar1:' + SCompVar1);
      SCompVar1 := GetCompByName(AOwner, SCompVar1);
      Result := 'ajaxRequest(MainForm.form, "_set" , ["script=fr5120_vAnalytNr=fr5120_analytnr",false]);';
      exit;
    end;

    for J := 0 to length(TmpStr) - 1 do
    begin
      if ContainsText(TmpStr[J], 'Value.indexOf(') then
        TmpStr[J] := SplitString(TmpStr[J], '.')[0] + '.Value';
      DebugMsg(IntToStr(J) + ':' + TmpStr[J]);
    end;

    DebugMsg('star cek.');
    SVar1 := Trim(TmpStr[0]);

    if ContainsText(SVar1, '<') then
      SVar1 := SplitString(SVar1, '<')[0];

    if ContainsText(SVar1, '>') then
      SVar1 := SplitString(SVar1, '>')[0];

    if (ContainsText(SVar1, '!')) and (ContainsText(SVar1, '=')) then
      SVar1 := SplitString(SVar1, '!')[0];

    DebugMsg('debug SVar1:' + SVar1);
    if ContainsText(SVar1, '(') then
    begin
      TmpStr0 := SplitString(SVar1, '(');
      for J := 0 to length(TmpStr0) - 1 do
        DebugMsg(IntToStr(J) + ':' + TmpStr0[J]);

      SVar1 := TmpStr0[length(TmpStr0) - 1];

      DebugMsg('SVar1:' + SVar1);
    end;

    DebugMsg('debug SVar1 split (:' + SVar1);

    SVar2 := '';
    if length(TmpStr) > 1 then
    begin
      SVar2 := TmpStr[1];
      if (SVar2 = '') and (length(TmpStr) > 2) then
        SVar2 := TmpStr[2];

      if ContainsText(SVar2, ')') then
        SVar2 := Trim(SplitString(SVar2, ')')[0]);
    end;

    DebugMsg('debug SVar2 split ):' + SVar2);

    // fix
    SVar1 := StringReplace(SVar1, '!', '', [rfReplaceAll, rfIgnoreCase]);
    SVar1 := StringReplace(SVar1, ')', '', [rfReplaceAll, rfIgnoreCase]);
    SVar1 := StringReplace(SVar1, '{', '', [rfReplaceAll, rfIgnoreCase]);

    SVar1 := Trim(SVar1);

    // fix 2
    SVar2 := Trim(SVar2);

    DebugMsg('SVar1:' + SVar1);
    DebugMsg('676 SVar2:' + SVar2);

    SCompVar1 := Trim(SplitString(SVar1, '.')[0]);

    // fix
    SCompVar1 := StringReplace(SCompVar1, '!', '',
      [rfReplaceAll, rfIgnoreCase]);

    DebugMsg('668 SCompVar1:' + SCompVar1);
    SCompVar1 := GetCompByName(AOwner, SCompVar1);

    if (ContainsText(UpperCase(Text), 'IF(')) or
      (ContainsText(UpperCase(Text), 'IF (')) then
    begin

      // if UpperCase(LeftStr(Trim(SVar1), 1)) = 'V' then
      // SCompVar1 := GetOwnerNameJS(AOwner) + '.' + SCompVar1 + '.text '
      // else if UpperCase(LeftStr(Trim(SVar1), 2)) = 'ED' then
      // SCompVar1 := GetOwnerNameJS(AOwner) + '.' + SCompVar1 + '.getValue() '
      // else if UpperCase(LeftStr(Trim(SVar1), 2)) = 'SH' then
      // SCompVar1 := GetOwnerNameJS(AOwner) + '.' + SCompVar1 + '.isVisible() '
      // else
      // SCompVar1 := GetOwnerNameJS(AOwner) + '.' + SCompVar1 + '.text ';

      if UpperCase(LeftStr(Trim(SVar1), 1)) = 'V' then
        SCompVar1 := GetOwnerNameByCompNameJS(AOwner, SCompVar1) + '.' +
          SCompVar1 + '.text '
      else if UpperCase(LeftStr(Trim(SVar1), 2)) = 'ED' then
        SCompVar1 := GetOwnerNameByCompNameJS(AOwner, SCompVar1) + '.' +
          SCompVar1 + '.getValue() '
      else if UpperCase(LeftStr(Trim(SVar1), 2)) = 'SH' then
        SCompVar1 := GetOwnerNameByCompNameJS(AOwner, SCompVar1) + '.' +
          SCompVar1 + '.isVisible() '
      else
        SCompVar1 := GetOwnerNameByCompNameJS(AOwner, SCompVar1) + '.' +
          SCompVar1 + '.text';

      DebugMsg('684 SCompVar1:' + SCompVar1);

      Text := StringReplace(Text, SVar1, SCompVar1,
        [rfReplaceAll, rfIgnoreCase]);
    end
    else if (ContainsText(UpperCase(Text), '.VISIBLE')) then
    begin
      // visible
      DebugMsg('** Visible.');
      // SCompVar1 := 'MainForm.' + SCompVar1 + '.setVisible(';
      SCompVar1 := GetOwnerNameByCompNameJS(AOwner, SCompVar1) + '.' + SCompVar1
        + '.setVisible(';
      DebugMsg('694 SCompVar1:' + SCompVar1);
      Text := SCompVar1;
      DebugMsg('** Text[' + Text + ']');
    end
    else
    begin
      DebugMsg('** 689 Persamaan.');
      if UpperCase(LeftStr(Trim(SVar1), 1)) = 'V' then
        if ContainsText(SCompVar1,
          TuniForm(UniSession.FormsList[UniSession.FormsList.Count - 1]).Name)
        then
          SCompVar1 := TuniForm(UniSession.FormsList[UniSession.FormsList.Count
            - 1]).Name + '.' + SCompVar1 + '.setText('
        else
          SCompVar1 := GetOwnerNameJS(AOwner) + '.' + SCompVar1 + '.setText('
      else if (UpperCase(LeftStr(Trim(SVar1), 2)) = 'ED') or
        (UpperCase(LeftStr(Trim(SVar1), 2)) = 'CH') or
        (UpperCase(LeftStr(Trim(SVar1), 4)) = 'TEXT') then
        if ContainsText(SCompVar1,
          TuniForm(UniSession.FormsList[UniSession.FormsList.Count - 1]).Name)
        then
          SCompVar1 := TuniForm(UniSession.FormsList[UniSession.FormsList.Count
            - 1]).Name + '.' + SCompVar1 + '.setValue('
        else
          SCompVar1 := GetOwnerNameJS(AOwner) + '.' + SCompVar1 + '.setValue('
      else if ContainsText(SCompVar1,
        TuniForm(UniSession.FormsList[UniSession.FormsList.Count - 1]).Name)
      then
        SCompVar1 := TuniForm(UniSession.FormsList[UniSession.FormsList.Count -
          1]).Name + '.' + SCompVar1 + '.setText('
      else
        SCompVar1 := GetOwnerNameJS(AOwner) + '.' + SCompVar1 + '.setText(';
      DebugMsg('724 SCompVar1:' + SCompVar1);
    end;

    if ContainsText(SVar2, '.') then
    begin
      // fixing
      if ContainsText(Trim(SVar2), ' ') then
      begin
        DebugMsg('* fixing space');
        SVar2 := SplitString(Trim(SVar2), ' ')
          [length(SplitString(Trim(SVar2), ' ')) - 1];
      end;

      // SCompVar2 := SplitString(SVar1, '.')[0];
      // DebugMsg('SCompVar2:' + SCompVar2);
      SCompVar2 := SplitString(SVar2, '.')[0];
      DebugMsg('SCompVar2:' + SCompVar2);

      SCompVar2 := GetCompByName(AOwner, SCompVar2);
      DebugMsg('SCompVar2:' + SCompVar2);

      if (ContainsText(UpperCase(Text), 'IF(')) or
        (ContainsText(UpperCase(Text), 'IF (')) then
      begin
        if UpperCase(LeftStr(SVar2, 1)) = 'V' then
          if ContainsText(SCompVar2,
            TuniForm(UniSession.FormsList[UniSession.FormsList.Count - 1]).Name)
          then
            SCompVar2 :=
              TuniForm(UniSession.FormsList[UniSession.FormsList.Count - 1])
              .Name + '.' + SCompVar2 + '.text '
          else
            SCompVar2 := GetOwnerNameJS(AOwner) + '.' + SCompVar2 + '.text '
        else if UpperCase(LeftStr(Trim(SVar2), 2)) = 'ED' then
          if ContainsText(SCompVar2,
            TuniForm(UniSession.FormsList[UniSession.FormsList.Count - 1]).Name)
          then
            SCompVar2 :=
              TuniForm(UniSession.FormsList[UniSession.FormsList.Count - 1])
              .Name + '.' + SCompVar2 + '.getValue() '
          else
            SCompVar2 := GetOwnerNameJS(AOwner) + '.' + SCompVar2 +
              '.getValue() '
        else if ContainsText(SCompVar2,
          TuniForm(UniSession.FormsList[UniSession.FormsList.Count - 1]).Name)
        then
          SCompVar2 := TuniForm(UniSession.FormsList[UniSession.FormsList.Count
            - 1]).Name + '.' + SCompVar2 + '.text() '
        else
          SCompVar2 := GetOwnerNameJS(AOwner) + '.' + SCompVar2 + '.text() ';

        DebugMsg('SCompVar2:' + SCompVar2);
        Text := StringReplace(Text, SVar2, SCompVar2,
          [rfReplaceAll, rfIgnoreCase]);
      end
      else
      begin
        DebugMsg('** 770 Persamaan.');

        if UpperCase(LeftStr(SVar2, 1)) = 'V' then
          if ContainsText(SCompVar2,
            TuniForm(UniSession.FormsList[UniSession.FormsList.Count - 1]).Name)
          then
            SCompVar2 :=
              TuniForm(UniSession.FormsList[UniSession.FormsList.Count - 1])
              .Name + '.' + SCompVar2 + '.text'
          else
            SCompVar2 := GetOwnerNameJS(AOwner) + '.' + SCompVar2 + '.text'
        else if UpperCase(LeftStr(Trim(SVar2), 2)) = 'ED' then
          if ContainsText(SCompVar2,
            TuniForm(UniSession.FormsList[UniSession.FormsList.Count - 1]).Name)
          then
            SCompVar2 :=
              TuniForm(UniSession.FormsList[UniSession.FormsList.Count - 1])
              .Name + '.' + SCompVar2 + '.getValue() '
          else
            SCompVar2 := GetOwnerNameJS(AOwner) + '.' + SCompVar2 +
              '.getValue() '
        else if ContainsText(SCompVar2,
          TuniForm(UniSession.FormsList[UniSession.FormsList.Count - 1]).Name)
        then
          SCompVar2 := TuniForm(UniSession.FormsList[UniSession.FormsList.Count
            - 1]).Name + '.' + SCompVar2 + '.text '
        else
          SCompVar2 := GetOwnerNameJS(AOwner) + '.' + SCompVar2 + '.text ';

        Text := SCompVar1 + SCompVar2 + ');';
        // Text := 'ajaxRequest(MainForm.form, "_setvalue" , ["script=' + Text +
        // '",false]);';

      end;
    end
    else if ContainsText(UpperCase(Text), '.SETVISIBLE(') then
    begin
      DebugMsg('** Set Visible()');
      DebugMsg('** SVar2[' + SVar2 + ']');
      SVar2 := StringReplace(SVar2, ';', '', [rfReplaceAll, rfIgnoreCase]);
      Text := Text + SVar2 + ');';
    end
    else
    begin
      if (not ContainsText(UpperCase(Text), 'IF(')) and
        (not ContainsText(UpperCase(Text), 'IF (')) then
      begin
        DebugMsg('** Persamaan call ajax.');
        SVar2 := StringReplace(SVar2, ';', '', [rfReplaceAll, rfIgnoreCase]);
        Text := SCompVar1 + SVar2 + ');';

        Text := 'ajaxRequest(MainForm.form, "_setvalue" , ["script=' + Text +
          '",false]);';

      end;
    end;

    DebugMsg('867 Text:' + Text);

    Result := Trim(Text);
  except
    begin
      raise Exception.Create('877 getCompIfJS() :Exception [' +
        TmpStr[I] + '].');
      Result := '';
    end;

  end;
  // var
  // SVar1, SVar2, SCompVar1, SCompVar2: String;
  // TmpStr, TmpStr0: TStringDynArray;
  // I, J: integer;
  // begin
  // DebugMsg('Call getCompIfJs()');
  // DebugMsg('CompText:' + CompText);
  // DebugMsg('* "=" ');
  // TmpStr := SplitString(CompText, '=');
  //
  // for J := 0 to length(TmpStr) - 1 do
  // begin
  // if ContainsText(TmpStr[J], 'Value.indexOf(') then
  // TmpStr[J] := SplitString(TmpStr[J], '.')[0] + '.Value';
  // DebugMsg(IntToStr(J) + ':' + TmpStr[J]);
  // end;
  //
  // DebugMsg('star cek.');
  // SVar1 := Trim(TmpStr[0]);
  //
  // if ContainsText(SVar1, '<') then
  // SVar1 := SplitString(SVar1, '<')[0];
  //
  // if ContainsText(SVar1, '>') then
  // SVar1 := SplitString(SVar1, '>')[0];
  //
  // if (ContainsText(SVar1, '!')) and (ContainsText(SVar1, '=')) then
  // SVar1 := SplitString(SVar1, '!')[0];
  //
  // DebugMsg('debug SVar1:' + SVar1);
  // if ContainsText(SVar1, '(') then
  // SVar1 := Trim(SplitString(SVar1, '(')[1]);
  //
  // SVar2 := TmpStr[1];
  // if (SVar2 = '') and (length(TmpStr) > 2) then
  // SVar2 := TmpStr[2];
  //
  // if ContainsText(SVar2, ')') then
  // SVar2 := Trim(SplitString(SVar2, ')')[0]);
  //
  // // fix
  // SVar1 := StringReplace(SVar1, '!', '', [rfReplaceAll, rfIgnoreCase]);
  // SVar1 := Trim(StringReplace(SVar1, ')', '', [rfReplaceAll, rfIgnoreCase]));
  //
  // // fix 2
  // SVar2 := Trim(SVar2);
  //
  // DebugMsg('SVar1:' + SVar1);
  // DebugMsg('SVar2:' + SVar2);
  //
  // SCompVar1 := Trim(SplitString(SVar1, '.')[0]);
  //
  // // fix
  // SCompVar1 := StringReplace(SCompVar1, '!', '', [rfReplaceAll, rfIgnoreCase]);
  //
  // DebugMsg('SCompVar1:' + SCompVar1);
  // SCompVar1 := GetCompByName(AOwner, SCompVar1);
  //
  // if (ContainsText(UpperCase(Text), 'IF(')) or
  // (ContainsText(UpperCase(Text), 'IF (')) then
  // begin
  //
  // if UpperCase(LeftStr(Trim(SVar1), 1)) = 'V' then
  // SCompVar1 := 'MainForm.' + SCompVar1 + '.text'
  // else if UpperCase(LeftStr(Trim(SVar1), 2)) = 'ED' then
  // SCompVar1 := 'MainForm.' + SCompVar1 + '.getValue()'
  // else
  // SCompVar1 := 'MainForm.' + SCompVar1 + '.text';
  //
  // DebugMsg('SCompVar1:' + SCompVar1);
  //
  // Text := StringReplace(Text, SVar1, SCompVar1, [rfReplaceAll, rfIgnoreCase]);
  // end
  // else
  // begin
  // DebugMsg('** Persamaan.');
  // if UpperCase(LeftStr(Trim(SVar1), 1)) = 'V' then
  // SCompVar1 := 'MainForm.' + SCompVar1 + '.setText('
  // else if UpperCase(LeftStr(Trim(SVar1), 2)) = 'ED' then
  // SCompVar1 := 'MainForm.' + SCompVar1 + '.setValue('
  // else
  // SCompVar1 := 'MainForm.' + SCompVar1 + '.setText(';
  //
  // DebugMsg('SCompVar1:' + SCompVar1);
  // end;
  //
  // if ContainsText(SVar2, '.') then
  // begin
  // // fixing
  // if ContainsText(Trim(SVar2), ' ') then
  // begin
  // DebugMsg('* fixing space');
  // SVar2 := SplitString(Trim(SVar2), ' ')
  // [length(SplitString(Trim(SVar2), ' ')) - 1];
  // end;
  //
  // SCompVar2 := SplitString(SVar2, '.')[0];
  // DebugMsg('SCompVar2:' + SCompVar2);
  //
  // SCompVar2 := GetCompByName(AOwner, SCompVar2);
  // DebugMsg('SCompVar2:' + SCompVar2);
  //
  // if (ContainsText(UpperCase(Text), 'IF(')) or
  // (ContainsText(UpperCase(Text), 'IF (')) then
  // begin
  // if UpperCase(LeftStr(SVar2, 1)) = 'V' then
  // SCompVar2 := 'MainForm.' + SCompVar2 + '.text'
  // else if UpperCase(LeftStr(Trim(SVar2), 2)) = 'ED' then
  // SCompVar2 := 'MainForm.' + SCompVar2 + '.getValue()'
  // else
  // SCompVar2 := 'MainForm.' + SCompVar2 + '.text()';
  //
  // DebugMsg('SCompVar2:' + SCompVar2);
  // Text := StringReplace(Text, SVar2, SCompVar2,
  // [rfReplaceAll, rfIgnoreCase]);
  // end
  // else
  // begin
  // DebugMsg('** Persamaan.');
  //
  // if UpperCase(LeftStr(SVar2, 1)) = 'V' then
  // SCompVar2 := 'MainForm.' + SCompVar2 + '.text'
  // else if UpperCase(LeftStr(Trim(SVar2), 2)) = 'ED' then
  // SCompVar2 := 'MainForm.' + SCompVar2 + '.getValue()'
  // else
  // SCompVar2 := 'MainForm.' + SCompVar2 + '.text';
  //
  // Text := SCompVar1 + SCompVar2 + ');';
  //
  // end;
  // end
  // else
  // begin
  // if (not ContainsText(UpperCase(Text), 'IF(')) and
  // (not ContainsText(UpperCase(Text), 'IF (')) then
  // begin
  // DebugMsg('** Persamaan.');
  // SVar2 := StringReplace(SVar2, ';', '', [rfReplaceAll, rfIgnoreCase]);
  // Text := SCompVar1 + SVar2 + ');';
  // end;
  // end;
  //
  // Result := Text;
end;

// Run Action JS
procedure RunActionJS(AOwner: TComponent; JSScript: string);
var
  TmpStr, TmpStr0, TmpStr1, TmpStr2, TmpArr: TStringDynArray;
  I, J, K: integer;
  STmp0, STmp0_0, STmp1, STmp1_0, SVar1, SVar2, SVar3, SVar4, SCompVar1,
    SCompVar2, ExtJsScript: string;
  B0, B1: boolean;
  Lb: TUniLabel;
  Ed: TUniEdit;
  Lo: TUniDBLookupComboBox;
  com: TComponent;
begin
  DebugMsg('1052 ************* Run Script JS [' + JSScript +
    '] **************');

  TmpStr := SplitString(JSScript, sLineBreak);

  ExtJsScript := '';

  // TODO: HARCODE

  if ContainsText(JSScript, 'var isEflow = VTESTTYPE.Value') then
    exit;

  if ContainsText(JSScript, 'BUCODE.Value == null) &&') and
    (not ContainsText(JSScript, 'MS05.Execute();')) then
  begin
    frmRepPerview.SeqNr := StrToInt(GetCompValue(AOwner, 'F01_seqnr'));
    frmRepPerview.ShowModal;
    exit;
  end;

  for I := 0 to length(TmpStr) - 1 do
  begin
    DebugMsg(TmpStr[I]);

    if (ContainsText(TmpStr[I], 'RUN(')) then // RUN Action
    begin
      DebugMsg('* RUN() action');
      TmpArr := SplitString(TmpStr[I], '''');
      DebugMsg('TmpArr[0]:' + TmpArr[1]);
      TmpStr[I] := 'ajaxRequest(' + GetOwnerNameJS(AOwner) +
        '.form, "_buttonclick" , ["script=' + TmpArr[1] + ';",false]);';
      DebugMsg('TmpStr[I]:' + TmpStr[I]);
    end
    else if (ContainsText(UpperCase(TmpStr[I]), '.REFRESH(')) then
    // REFRESH Action
    begin
      DebugMsg('* REFRESH() action');
      TmpStr[I] := 'ajaxRequest(' + GetOwnerNameJS(AOwner) +
        '.form, "_buttonclick" , ["script=' + Trim(TmpStr[I]) + '",false]);';
      DebugMsg('TmpStr[I]:' + TmpStr[I]);
    end
    else if (ContainsText(TmpStr[I], 'RUNSCRIPT(')) then // RUN Action
    begin
      DebugMsg('* RUNSCRIPT() action');
      TmpStr[I] := 'ajaxRequest(' + GetOwnerNameJS(AOwner) +
        '.form, "_buttonclick" , ["script=' + Trim(TmpStr[I]) + '",false]);';
      DebugMsg('TmpStr[I]:' + TmpStr[I]);
    end
    else if (ContainsText(TmpStr[I], 'CLOSE(')) then // RUN Action
    begin
      DebugMsg('* CLOSE() action');
      TmpStr[I] := 'ajaxRequest(' + GetOwnerNameJS(AOwner) +
        '.form, "_buttonclick" , ["script=' + Trim(TmpStr[I]) + '",false]);';
      DebugMsg('TmpStr[I]:' + TmpStr[I]);
    end
    else if (ContainsText(TmpStr[I], 'OPENUPD()')) then
    begin
      DebugMsg('* OPENUPD() action');
      TmpStr[I] := 'ajaxRequest(' + GetOwnerNameJS(AOwner) +
        '.form, "_buttonclick" , ["script=' + Trim(TmpStr[I]) + '",false]);';
      DebugMsg('TmpStr[I]:' + TmpStr[I]);
    end
    else if (ContainsText(TmpStr[I], 'FIRSTNODE()')) then
    begin
      DebugMsg('* FIRSTNODE() action');
      TmpStr[I] := 'ajaxRequest(' + GetOwnerNameJS(AOwner) +
        '.form, "_buttonclick" , ["script=' + Trim(TmpStr[I]) + '",false]);';
      DebugMsg('TmpStr[I]:' + TmpStr[I]);
    end
    else if (ContainsText(UpperCase(TmpStr[I]), '.EXECUTE()')) then
    begin
      DebugMsg('* .EXECUTE() action');
      TmpStr[I] := 'ajaxRequest(' + GetOwnerNameJS(AOwner) +
        '.form, "_buttonclick" , ["script=' + Trim(TmpStr[I]) + '",false]);';
      DebugMsg('TmpStr[I]:' + TmpStr[I]);
    end
    else if (ContainsText(UpperCase(TmpStr[I]), 'IF (')) or
      (ContainsText(UpperCase(TmpStr[I]), 'IF(')) then // IF Condition
    begin
      DebugMsg('* IF Condition');
      if (ContainsText(UpperCase(TmpStr[I]), '=')) then
      begin

        if (ContainsText(UpperCase(TmpStr[I]), '&&')) or
          (ContainsText(UpperCase(TmpStr[I]), '||')) then
        begin

          if (ContainsText(UpperCase(TmpStr[I]), '||')) then
          begin
            DebugMsg('* ||');
            TmpStr0 := SplitString(TmpStr[I], '||');

            for J := 0 to length(TmpStr0) - 1 do
            begin
              DebugMsg(IntToStr(J) + ':' + TmpStr0[J]);
              if (Trim(TmpStr0[J]) = '') then
              begin
                DebugMsg('747 * Skip:' + TmpStr0[J] + ' = ""');
              end
              else if (not ContainsText(TmpStr0[J], '&&')) then
              begin
                DebugMsg('** found.');
                TmpStr[I] := getCompIfJs(AOwner, TmpStr[I], TmpStr0[J]);
              end
              else
              begin
                // pecah lagi
                TmpStr1 := SplitString(TmpStr0[J], '&&');
                for K := 0 to length(TmpStr1) - 1 do
                begin
                  DebugMsg(IntToStr(K) + ':' + TmpStr1[K]);
                  if Trim(TmpStr1[K]) <> '' then
                  begin
                    DebugMsg('* Found');
                    TmpStr[I] := getCompIfJs(AOwner, TmpStr[I], TmpStr1[K]);
                  end
                  else
                    DebugMsg('767 * Skip:' + TmpStr1[K] + ' <> ""');
                end;
              end;
            end;
          end

          else if (ContainsText(UpperCase(TmpStr[I]), '&&')) then
          begin
            DebugMsg('* &&');
            TmpStr0 := SplitString(TmpStr[I], '&&');

            for J := 0 to length(TmpStr0) - 1 do
            begin
              DebugMsg(IntToStr(J) + ':' + TmpStr0[J]);
              if (Trim(TmpStr0[J]) = '') then
              begin
                DebugMsg('783 * Skip:' + TmpStr0[J] + ' = ""');
              end
              else if (not ContainsText(TmpStr0[J], '||')) then
              begin
                DebugMsg('** found = TmpStr0[J]' + TmpStr0[J]);
                TmpStr[I] := getCompIfJs(AOwner, TmpStr[I], TmpStr0[J]);
              end
              else
              begin
                // pecah lagi
                TmpStr1 := SplitString(TmpStr0[J], '||');
                for K := 0 to length(TmpStr1) - 1 do
                begin
                  DebugMsg(IntToStr(K) + ':' + TmpStr1[K]);
                  if Trim(TmpStr1[K]) <> '' then
                  begin
                    DebugMsg('* Found');
                    TmpStr[I] := getCompIfJs(AOwner, TmpStr[I], TmpStr1[K]);
                  end
                  else
                    DebugMsg('803 * Skip:' + TmpStr1[K] + ' <> ""');
                end;
              end;
            end;
          end;
        end
        else
        begin
          DebugMsg('* "=" ');
          TmpStr[I] := getCompIfJs(AOwner, TmpStr[I], TmpStr[I]);
        end;
      end
      else if (ContainsText(UpperCase(TmpStr[I]), '>')) then
      begin
        DebugMsg('* ">" ');
        TmpStr[I] := getCompIfJs(AOwner, TmpStr[I], TmpStr[I]);
      end
      else if (ContainsText(UpperCase(TmpStr[I]), '<')) then
      begin
        DebugMsg('* "<" ');
        TmpStr[I] := getCompIfJs(AOwner, TmpStr[I], TmpStr[I]);
      end
      else
      begin
        DebugMsg('* Tanpa Persamaan');
        TmpStr[I] := getCompIfJs(AOwner, TmpStr[I], TmpStr[I]);
      end;

    end
    else if (not ContainsText(UpperCase(TmpStr[I]), 'IF (')) and
      (not ContainsText(UpperCase(TmpStr[I]), 'IF(')) and
      (ContainsText(UpperCase(TmpStr[I]), ' = ')) then
    // Persamaan
    begin
      DebugMsg('* Persamaan');
      TmpStr[I] := getCompIfJs(AOwner, TmpStr[I], TmpStr[I]);
    end
    else if ContainsText(UpperCase(TmpStr[I]), '.CLEAR()') then
    begin
      DebugMsg('* Clear()');
      SVar1 := Trim(SplitString(TmpStr[I], '.')[0]);
      DebugMsg('1214 SVar1:' + SVar1);
      SVar1 := 'MainForm.' + GetCompByName(AOwner, SVar1) + '.setValue("");';
      DebugMsg('1216 SVar1:' + SVar1);
      TmpStr[I] := SVar1;
    end
    else if ContainsText(UpperCase(TmpStr[I]), '.DISABLE()') then
    begin
      DebugMsg('1222 Disable()');
      SVar1 := StringReplace(TmpStr[I], '{', '', [rfReplaceAll, rfIgnoreCase]);
      SVar1 := StringReplace(SVar1, '}', '', [rfReplaceAll, rfIgnoreCase]);
      SVar1 := Trim(SVar1);
      SVar2 := Trim(SplitString(SVar1, '.')[0]);
      DebugMsg('1226 SVar2:' + SVar2);

      TmpStr[I] := 'ajaxRequest(MainForm.form, "_disable" , ["script=' +
        Trim(GetCompByName(AOwner, SVar2)) + '",false]);';
      DebugMsg('TmpStr[I]:' + TmpStr[I]);
    end
    else if ContainsText(UpperCase(TmpStr[I]), '.ENABLE()') then
    begin
      DebugMsg('1235 Enable()');
      SVar1 := StringReplace(TmpStr[I], '{', '', [rfReplaceAll, rfIgnoreCase]);
      SVar1 := StringReplace(SVar1, '}', '', [rfReplaceAll, rfIgnoreCase]);
      SVar1 := Trim(SVar1);
      SVar2 := Trim(SplitString(SVar1, '.')[0]);
      DebugMsg('1240 SVar2:' + SVar2);

      // TODO: HARDCODE COLUMN NAME ACTION

      if (SVar2 = 'MIRESDELETE') or (SVar2 = 'LOE') or (SVar2 = 'GTEXT') or
        (SVar2 = 'GNAME') or (SVar2 = 'GRESTEXT') or (SVar2 = 'GRESNAME') then
        TmpStr[I] := ''
      else
        TmpStr[I] := StringReplace(TmpStr[I], SVar1,
          'ajaxRequest(MainForm.form, "_enable" , ["script=' +
          Trim(GetCompByName(AOwner, SVar2)) + '",false]);',
          [rfReplaceAll, rfIgnoreCase]);

      DebugMsg('1247 TmpStr[I]:' + TmpStr[I]);
    end
    else if ContainsText(UpperCase(TmpStr[I]), '.VISIBLE=') then
    begin
      DebugMsg('1235 .VISIBLE=');
      SVar1 := SplitString(TmpStr[I], '=')[0];
      SVar2 := SplitString(TmpStr[I], '=')[1];
      SVar1 := StringReplace(SVar1, '.VISIBLE', '',
        [rfReplaceAll, rfIgnoreCase]);
      SVar1 := StringReplace(SVar1, '{', '', [rfReplaceAll, rfIgnoreCase]);
      SVar1 := StringReplace(SVar1, '}', '', [rfReplaceAll, rfIgnoreCase]);
      SVar2 := StringReplace(SVar2, '{', '', [rfReplaceAll, rfIgnoreCase]);
      SVar2 := StringReplace(SVar2, '}', '', [rfReplaceAll, rfIgnoreCase]);
      SVar1 := Trim(SVar1);

      TmpStr[I] := StringReplace(TmpStr[I], '.Visible=true;', '',
        [rfReplaceAll, rfIgnoreCase]);
      TmpStr[I] := StringReplace(TmpStr[I], '.Visible=false;', '',
        [rfReplaceAll, rfIgnoreCase]);

      TmpStr[I] := StringReplace(TmpStr[I], SVar1,
        'ajaxRequest(MainForm.form, "_visible" , ["script=' +
        Trim(GetCompByName(AOwner, SVar1)) + '=' + SVar2 + '",false]);',
        [rfReplaceAll, rfIgnoreCase]);
    end
    else if (ContainsText(UpperCase(TmpStr[I]), '.VALUE')) and
      (ContainsText(UpperCase(TmpStr[I]), '=')) then
    begin
      DebugMsg('1279 X.Value = Y.Value');
      SVar1 := Trim(SplitString(TmpStr[I], '=')[0]);
      SVar1 := SplitString(SVar1, '.')[0];
      SVar1 := GetCompByName(AOwner, SVar1);
      // SVar1 := GetOwnerName(AOwner) + '_' + SVar1;
      SVar2 := Trim(SplitString(TmpStr[I], '=')[1]);
      SVar2 := SplitString(SVar2, '.')[0];
      // SVar2 := GetOwnerName(AOwner) + '_' + SVar2;
      SVar2 := GetCompByName(AOwner, SVar2);
      DebugMsg('1285 SVar1[' + SVar1 + '] SVar2[' + SVar2 + ']');
      TmpStr[I] := 'ajaxRequest(MainForm.form, "_set" , ["script=' + SVar1 + '='
        + SVar2 + '",false]);';
    end
    else if (ContainsText(UpperCase(TmpStr[I]), '.SETFOCUS()')) then
    begin
      DebugMsg('1350 SETFOCUS() action');
      SVar1 := '';
      if ContainsText(TmpStr[I], '''') then
      begin
        TmpArr := SplitString(TmpStr[I], '''');
        SVar1 := TmpArr[1];
      end;
      if ContainsText(TmpStr[I], '.') then
      begin
        TmpArr := SplitString(TmpStr[I], '.');
        SVar1 := TmpArr[0];
      end;

      DebugMsg('SVar1:' + SVar1);
      SVar1 := Trim(SVar1);
      TmpStr[I] := 'ajaxRequest(' + GetOwnerNameJS(AOwner) +
        '.form, "_setfocus" , ["script=' + SVar1 + ';",false]);';
      DebugMsg('TmpStr[I]:' + TmpStr[I]);
    end
    else if (ContainsText(UpperCase(TmpStr[I]), '.SETCAPTION()')) then
    begin
      // TODO
      DebugMsg('1325 SetCaption() do nothing.');
      TmpStr[I] := '';
    end
    else
      DebugMsg('1247 No need convert');

    // Run JS
    ExtJsScript := ExtJsScript + TmpStr[I] + sLineBreak;

  end;

  DebugMsg('** RUN JS [' + ExtJsScript + ']');
  UniSession.AddJS(ExtJsScript);

  {
    for I := 0 to length(tmpStr) - 1 do
    begin
    if tmpStr[I] <> '' then
    begin
    tmpStr[I] := Trim(tmpStr[I]);
    DebugMsg('tmpStr[' + IntToStr(I) + ']:' + tmpStr[I]);
    if (ContainsText(tmpStr[I], '=')) and
    (not ContainsText(UpperCase(tmpStr[I]), 'IF (')) and
    (not ContainsText(UpperCase(tmpStr[I]), 'IF(')) then
    begin
    DebugMsg('Persamaan.');
    tmpStr0 := SplitString(tmpStr[I], '=');
    SVar1 := Trim(tmpStr0[0]);
    SVar1 := SplitString(SVar1, '.')[0];
    SVar2 := Trim(tmpStr0[1]);
    SVar2 := SplitString(SVar2, '.')[0];
    DebugMsg('Var1:' + SVar1);

    SCompVar1 := '';
    // with GetCompomentByName(MainForm, SVar1) do
    // begin
    SCompVar1 := GetCompByName(MainForm, SVar1);
    if UpperCase(LeftStr(SVar1, 1)) = 'V' then
    SCompVar1 := 'MainForm.' + SCompVar1 + '.setText('
    else
    SCompVar1 := 'MainForm.' + SCompVar1 + '.setValue(';

    DebugMsg('Component Name:' + SCompVar1);
    // end;

    DebugMsg('Var2:' + SVar2);

    // with GetCompomentByName(AOwner, SVar2) do
    // begin
    SCompVar2 := GetCompByName(MainForm, SVar2);
    // if (UpperCase(LeftStr(SVar1, 1)) = 'V') or
    // (UpperCase(LeftStr(SVar1, 1)) = 'V') then
    SCompVar2 := 'MainForm.' + SCompVar2 + '.getValue()';
    // end;

    DebugMsg('Component Name:' + SCompVar2);

    DebugMsg('Script:' + SCompVar1 + SCompVar2 + ');');

    ExtJsScript := ExtJsScript + sLineBreak + SCompVar1 + SCompVar2 + ');';
    end
    else if (ContainsText(tmpStr[I], 'RUN(')) then
    begin
    DebugMsg('RUN()');
    tmpStr0 := SplitString(tmpStr[I], '''');

    if (tmpStr0[1] = 'form.Close') then
    tmpStr0[1] := StringReplace('form.Close', 'form',
    GetOwnerName(AOwner), [rfReplaceAll, rfIgnoreCase]);

    ExtJsScript := ExtJsScript + sLineBreak +
    'ajaxRequest(MainForm.form, "_buttonclick" , ["script=' + tmpStr0[1]
    + ';"]);';
    end
    else if ContainsText(UpperCase(tmpStr[I]), 'IF (') or
    (ContainsText(UpperCase(tmpStr[I]), 'IF(')) then
    begin
    DebugMsg('IF()');

    if ContainsText(UpperCase(tmpStr[I]), ' = ') then
    begin
    SCompVar1 := SplitString(SplitString(tmpStr[I], '(')[1], '=')[0];
    tmpStr2 := SplitString(SplitString(tmpStr[I], '(')[1], '=');
    end
    else
    begin
    if ContainsText(UpperCase(tmpStr[I]), '>') then
    begin
    SCompVar1 := SplitString(SplitString(tmpStr[I], '(')[1], '>')[0];
    tmpStr2 := SplitString(SplitString(tmpStr[I], '(')[1], '>');
    end

    else
    begin
    SCompVar1 := SplitString(SplitString(tmpStr[I], '(')[1], '<')[0];
    tmpStr2 := SplitString(SplitString(tmpStr[I], '(')[1], '<');
    end;
    end;
    SCompVar2 := tmpStr2[length(tmpStr2) - 1];
    SCompVar2 := StringReplace(SCompVar2, ')', '',
    [rfReplaceAll, rfIgnoreCase]);
    SCompVar2 := StringReplace(SCompVar2, '{', '',
    [rfReplaceAll, rfIgnoreCase]);
    DebugMsg('SCompVar2:' + SCompVar2);

    // cek sebelah kanan jika variabel
    if ContainsText(SCompVar2, '.') then
    begin
    DebugMsg('Variabel kanan variabel');
    SCompVar2 := Trim(SCompVar2);
    DebugMsg('*** SCompVar2:' + SCompVar2);

    SVar3 := SCompVar2;
    DebugMsg(SCompVar2);

    SVar2 := Trim(SCompVar2);
    DebugMsg(SVar2);
    SVar2 := SplitString(SVar2, '.')[0];
    DebugMsg(SVar2);

    SCompVar2 := GetCompByName(MainForm, SVar2);
    DebugMsg(SCompVar2);
    if (UpperCase(LeftStr(SVar2, 1)) = 'V') then
    SCompVar2 := 'MainForm.' + SCompVar2 + '.text'
    else
    SCompVar2 := 'MainForm.' + SCompVar2 + '.getValue()';
    DebugMsg(SCompVar2);

    DebugMsg('replace... [' + SVar3 + '] [' + SCompVar2 + ']');

    tmpStr[I] := StringReplace(tmpStr[I], SVar3, SCompVar2,
    [rfReplaceAll, rfIgnoreCase]);
    DebugMsg('tmpStr[I] :' + tmpStr[I]);

    end;

    SCompVar1 := StringReplace(SCompVar1, '!', '',
    [rfReplaceAll, rfIgnoreCase]);
    SCompVar1 := StringReplace(SCompVar1, '>', '',
    [rfReplaceAll, rfIgnoreCase]);
    SCompVar1 := StringReplace(SCompVar1, '>', '',
    [rfReplaceAll, rfIgnoreCase]);
    SCompVar1 := Trim(SCompVar1);
    SVar3 := SCompVar1;
    DebugMsg(SCompVar1);

    SVar1 := Trim(SCompVar1);
    DebugMsg(SVar1);
    SVar1 := SplitString(SVar1, '.')[0];
    DebugMsg(SVar1);

    SCompVar1 := GetCompByName(MainForm, SVar1);
    DebugMsg(SCompVar1);
    if (UpperCase(LeftStr(SVar1, 1)) = 'V') or
    (UpperCase(LeftStr(SVar1, 3)) = 'RET') then
    SCompVar1 := 'MainForm.' + SCompVar1 + '.text'
    else
    SCompVar1 := 'MainForm.' + SCompVar1 + '.getValue()';
    DebugMsg(SCompVar1);

    tmpStr[I] := StringReplace(tmpStr[I], SVar3, SCompVar1,
    [rfReplaceAll, rfIgnoreCase]);

    ExtJsScript := ExtJsScript + sLineBreak + tmpStr[I];

    end
    else if (ContainsText(UpperCase(tmpStr[I]), ' ELSE ')) or
    (Trim(tmpStr[I]) = '{') or (Trim(tmpStr[I]) = '') then
    begin
    ExtJsScript := ExtJsScript + sLineBreak + tmpStr[I];
    end;
    end;
    end;

    DebugMsg('== > Script JS [' + ExtJsScript + '] **************');
    UniSession.AddJS(ExtJsScript);



    mmParse.Lines.Clear;

    for I := 0 to tmpStr.Count - 1 do
    begin
    DebugMsg(tmpStr[I]);
    SLine := tmpStr[I];
    if (ContainsText(SLine, '=')) and (not ContainsText(UpperCase(SLine), ' IF'))
    then
    begin
    DebugMsg('Persamaan.');
    tmpStr := SplitString(SLine, '=');
    SVar1 := Trim(tmpStr[0]);
    SVar1 := SplitString(SVar1, '.')[0];
    SVar2 := Trim(tmpStr[1]);
    SVar2 := SplitString(SVar2, '.')[0];
    DebugMsg('Var1:' + SVar1);

    com := GetCompomentByName(AOwner, SVar1);
    SCompVar1 := com.Name;
    if UpperCase(LeftStr(SVar1, 1)) = 'V' then
    SCompVar1 := 'MainForm.' + SCompVar1 + '.setText(';

    DebugMsg('Component Name:' + SCompVar1);

    DebugMsg('Var2:' + SVar2);

    com := GetCompomentByName(AOwner, SVar2);
    SCompVar2 := com.Name;
    if (UpperCase(LeftStr(SVar1, 1)) = 'V') or
    (UpperCase(LeftStr(SVar1, 1)) = 'V') then
    SCompVar2 := 'MainForm.' + SCompVar2 + '.getValue()';

    DebugMsg('Component Name:' + SCompVar2);

    DebugMsg('Script:' + SCompVar1 + SCompVar2 + ');');

    tmpStr[I] := SCompVar1 + SCompVar2 + ');';

    // if S then


    // cari component

    end;

    end;
  }

  //
  //
  // tmpStr := SplitString(Script, ';');
  // for I := 0 to length(tmpStr) - 1 do
  // begin
  // tmpStr[I] := Trim(tmpStr[I]);
  // DebugMsg('*** ' + IntToStr(I) + ' **** [' + tmpStr[I] + ']');
  //
  // // RUN Script
  // if LeftStr(Trim(UpperCase(tmpStr[I])), 4) = 'RUN(' then
  // begin
  // tmpStr0 := SplitString(tmpStr[I], '''');
  // STmp0 := tmpStr0[1];
  // RunAction(AOwner, STmp0);
  // end
  // else if ContainsText(tmpStr[I], '=') then
  // begin
  // // set value
  // tmpStr0 := SplitString(tmpStr[I], '=');
  // STmp0 := Trim(tmpStr0[0]);
  // STmp1 := Trim(tmpStr0[1]);
  //
  // if ContainsText(STmp0, '.') then
  // begin
  // STmp0_0 := SplitString(STmp0, '.')[1];
  // STmp0 := SplitString(STmp0, '.')[0];
  // end;
  //
  // // Jika COMPONENT.VALUE = VALUE
  // if not ContainsText(STmp1, '.') then
  // begin
  // //
  // DebugMsg('**** COMPONENT.VALUE = VALUE');
  // B0 := false;
  // // label
  // if LeftStr(STmp0, 1) = 'V' then
  // begin
  // for J := 0 to AOwner.ComponentCount - 1 do
  // begin
  // if AOwner.Components[J] is TUniLabel then
  // begin
  // Lb := TUniLabel(AOwner.Components[J]);
  // if UpperCase(Lb.Name) = UpperCase(AOwner.Name) + '_' +
  // UpperCase(STmp0) then
  // begin
  // STmp0 := AOwner.Name + '.' + Lb.Name + '.setText';
  // B0 := True;
  // end;
  // end;
  // end;
  // end
  // else
  // // Edit
  // if LeftStr(STmp0, 2) = 'ED' then
  // begin
  // for J := 0 to AOwner.ComponentCount - 1 do
  // if AOwner.Components[J] is TUniEdit then
  // begin
  // Ed := TUniEdit(AOwner.Components[J]);
  // if UpperCase(Ed.Name) = UpperCase(STmp0) then
  // begin
  // STmp0 := AOwner.Name + '.' + Ed.Name + '.setValue';
  // B0 := True;
  // end;
  // end;
  // end;
  // if B0 then
  // begin
  // UniSession.AddJS(STmp0 + '("' + STmp1 + '");');
  // ExtJsScript := STmp0 + '("' + STmp1 + '")';
  // Script := StringReplace(Script, tmpStr[I], ExtJsScript,
  // [rfReplaceAll, rfIgnoreCase]);
  // end;
  //
  // end
  // // jika COMPONENT.value = COMPONENT.value
  // else
  // // if (UpperCase(STmp0_0) = 'VALUE') and (UpperCase(STmp1_0) = 'VALUE')
  // // then
  // begin
  // if ContainsText(STmp1, '.') then
  // begin
  // STmp1_0 := SplitString(STmp1, '.')[1];
  // STmp1 := SplitString(STmp1, '.')[0];
  // end;
  // DebugMsg('**** COMPONENT.VALUE = COMPONENT.VALUE');
  // tmpStr[I] := 'MainForm.' + STmp0 + '.setText(MainForm.' + STmp1 +
  // '.getText());';
  // // find component
  // B0 := false;
  // B1 := false;
  //
  // // label
  // if LeftStr(STmp0, 1) = 'V' then
  // begin
  // for J := 0 to AOwner.ComponentCount - 1 do
  // begin
  // if AOwner.Components[J] is TUniLabel then
  // begin
  // Lb := TUniLabel(AOwner.Components[J]);
  // if UpperCase(Lb.Name) = UpperCase(AOwner.Name) + '_' +
  // UpperCase(STmp0) then
  // begin
  // STmp0 := AOwner.Name + '.' + Lb.Name + '.setText';
  // B0 := True;
  // end;
  // end;
  // end;
  // end
  // else
  // // Edit
  // if LeftStr(STmp0, 2) = 'ED' then
  // begin
  // for J := 0 to AOwner.ComponentCount - 1 do
  // if AOwner.Components[J] is TUniEdit then
  // begin
  // Ed := TUniEdit(AOwner.Components[J]);
  // if UpperCase(Ed.Name) = UpperCase(STmp0) then
  // begin
  // STmp0 := AOwner.Name + '.' + Ed.Name + '.setValue';
  // B0 := True;
  // end;
  // end;
  // end;
  //
  // // -------------- Param 2 ----------------
  //
  // if LeftStr(STmp1, 2) = 'ED' then
  // begin
  // for J := 0 to AOwner.ComponentCount - 1 do
  // if AOwner.Components[J] is TUniEdit then
  // begin
  // Ed := TUniEdit(AOwner.Components[J]);
  // if UpperCase(Ed.Name) = UpperCase(STmp1) then
  // begin
  // STmp1 := AOwner.Name + '.' + Ed.Name + '.getValue';
  // B1 := True;
  // end;
  // end;
  // end
  // else if LeftStr(STmp1, 2) = 'LO' then
  // begin
  // for J := 0 to AOwner.ComponentCount - 1 do
  // if AOwner.Components[J] is TUniDBLookupComboBox then
  // begin
  // Lo := TUniDBLookupComboBox(AOwner.Components[J]);
  // if UpperCase(Lo.Name) = UpperCase(STmp1) then
  // begin
  // STmp1 := AOwner.Name + '.' + Lo.Name + '.getValue';
  // B1 := True;
  // end;
  // end;
  // end;
  //
  // if B0 and B1 then
  // begin
  // UniSession.AddJS(STmp0 + '(' + STmp1 + ');');
  // ExtJsScript := STmp0 + '(' + STmp1 + ')';
  // Script := StringReplace(Script, tmpStr[I], ExtJsScript,
  // [rfReplaceAll, rfIgnoreCase]);
  // end
  // end;
  // end;
  // end;
  //
  // DebugMsg('********** SCRIPT JS FINAL :' + Script);

end;

procedure CallBackPopUp(AOwner: TComponent; FormName: string; Result: integer);
begin
  DebugMsg('** CallBackPopUp(' + FormName + ',' + IntToStr(Result) + ')');
end;

procedure RunAction(AOwner: TComponent; Script: string);
var
  FrmName, ParamName, Line, SVar1, SVar2, SVar3, SVar4, SQLText, ColumnData,
    DsName, GrdName, SComp1, ActiveForm: string;
  I, J, K, L, LastRecNo: integer;
  TmpStr, TmpStr0, TmpStr1, TmpStr2: TStringDynArray;
  Ed: TUniEdit;
  Lo: TUniDBLookupComboBox;
  Lb: TUniLabel;
  Mm: TUniMemo;
  Bt: TUniButton;
  Da: TUniDateTimePicker;
  Q: TFDStoredProc;
  FdC: TFDCommand;
  Qr: TFDQuery;
  Pop: TfrmPopUp;
  Co, Co1: TComponent;
  Var1: Variant;
begin
  DebugMsg('1731 ************* Run Script [' + Script + '] **************');

  Script := Trim(StringReplace(StringReplace(Script, #10, '', [rfReplaceAll]),
    #13, '', [rfReplaceAll]));

  DebugMsg('1745 Script[' + Script + ']');


  // HARDCODE

  // 1809 fr5120_miCommentAnal_ACTION
  if Trim(Script) = 'type.Set(B);PopAnalytComment.OpenUpd;grResult.Refresh' then
  begin
    DebugMsg('HARDCODE:fr5120_miCommentAnal_ACTION');
    GetCompByNamePopUp('FR5120_TYPE');

    SetCompVar('FR5120_TYPE', 'B');
    DebugMsg(GetCompVar('FR5120_TYPE'));

    ShowPopUpForm(AOwner, 'PopAnalytComment');

    exit;
  end;

  if Trim(Script) = 'STINFO.Execute();' then
    exit;

  if Trim(Script) = 'grResult.DoSelected(scReleaseResult.RunScript());grResult.NextNode;'
  then
  begin
    Script := 'grResult.DoSelected(scReleaseResult.RunScript());';
  end;

  if Trim(Script) = 'grResult.DoSelected(qSetRetry.Execute);grResult.Refresh'
  then
  begin
    ScriptExecSQL(AOwner, 'qSetRetry.Execute');
    RefreshDataSet(AOwner, 'grResult.Refresh');
    exit;
  end;

  if Trim(Script) = 'grResult.DoSelected(qForceMedval.Execute);grResult.NextNode;'
  then
  begin
    ScriptExecSQL(AOwner, 'qForceMedval.Execute');
    NextNodeDataSet(AOwner, 'grResult.NextNode');
    exit;
  end;

  if Trim(Script) = 'QSETRELEASE.Execute();' then
  begin
    ScriptExecSQL(AOwner, 'QSETRELEASE.Execute()');
    RefreshDataSet(AOwner, 'grResult.Refresh');
    exit;
  end;

  if Trim(Script) = 'msgDeleteAnalyt.Execute' then
  begin
    BuildMsgBox(AOwner, Script);
    exit;
  end;

  if Trim(Script) = 'SCCHECKDELCOMMENT.RunScript();' then
  begin
    BuildMsgBox(AOwner, 'msDelKommentar.Execute');
    exit;
  end;

  if Trim(Script) = 'msMussfeld.execute;' then
  begin
    BuildMsgBox(AOwner, 'msMussfeld.execute');
    exit;
  end;

  if Trim(Script) = 'QDELETEFREETEXT.execute' then
  begin
    Script := 'QDELETEFREETEXT.execute;qGetComments.Execute();';
  end;

  if Trim(Script) = 'grResult.DoSelected(qDeleteAnalyt.Execute);      grResult.NextNode;'
  then
  begin
    ScriptExecSQL(AOwner, 'qDeleteAnalyt.Execute');
    RefreshDataSet(AOwner, 'grResult.Refresh');
    NextNodeDataSet(AOwner, 'grResult.NextNode');
    exit;
  end;

  if Trim(Script) = 'QGETORDER.Execute();' then
  begin
    ScriptExecSQL(AOwner, 'QGETORDER.Execute()');
    exit;
  end;

  if Trim(Script) = 'QUGETAUFTRAG.Execute();' then
  begin
    ScriptExecSQL(AOwner, 'QUGETAUFTRAG.Execute()');
    exit;
  end;

  if Trim(Script) = 'Daylist_Selection.Cancel' then
  begin
    Script := 'Daylist_Selection.Close();';
  end;

  if Trim(Script) = 'scOnOk.RunScript();' then
  begin
    TfrmPopUp(UniSession.FormsList[UniSession.FormsList.Count - 1]).PopRes := 1;
  end;

  if Trim(Script) = 'RUN(' + QuotedStr('scOnInitForm.RunScript') + ');' then
  begin
    Script := 'scOnInitForm.RunScript;';
  end;

  if Trim(Script) = 'type.Set(B);PopAnalytComment.OpenUpd;grResult.Refresh' then
  begin
    Script := 'type.Set(B);PopAnalytComment.OpenUpd;';
  end;

  if Trim(Script) = 'type.Set(A);PopComment.OpenUpd;grAll.Refresh' then
  begin
    Script := 'PopComment.OpenUpd';
  end;

  if Trim(Script) = 'scOpenAnalyteDetails.RunScript' then
  begin
    Script := 'POPDETAILANALYT.OpenUpd';
  end;

  if Trim(Script) = 'chInternalComment.Clear;' then
  begin
    Co := MainForm.FindComponent('F01_GRDCOMMENTS');
    if Co = Nil then
    begin
      Co := GetCompByNamePopUp('F01_GRDCOMMENTS');
      if Co = Nil then
        raise Exception.Create('1853 RunAction() FindComponent Failure [' +
          SVar1 + ']');
    end;
    RebuildColumnGrid(AOwner, TUniDBGrid(Co));
  end;

  if Trim(Script) = 'QDELETEFREETEXT.execute' then
  begin
    Script := 'QDELETEFREETEXT.execute;qGetComments.Execute();';
  end;

  if Trim(Script) = 'QGetAufgcd.Execute;' then
  begin
    ScriptExecSQL(AOwner, 'QGetAufgcd.Execute');
    exit;
  end;

  if Trim(Script) = 'PopRequest.OpenUpd;grResult.Refresh' then
  begin
    Script := 'PopRequest.OpenUpd;';
  end;

  if Trim(Script) = 'Q29.Execute(); if (TEST.Value==' + QuotedStr('1') + ') BU03.Enable(); else BU03.Disable();'
  then
  begin
    exit;
  end;

  if Trim(Script) = 'MS05.Execute();' then
  begin
    BuildMsgBox(AOwner, Script);
    exit;
  end;

  try
    TmpStr := SplitString(Script, ';');
    for I := 0 to length(TmpStr) - 1 do
    begin
      TmpStr[I] := Trim(TmpStr[I]);

      if TmpStr[I] = '' then
        exit;

      DebugMsg('1698 tmpStr[' + IntToStr(I) + ']: [' + TmpStr[I] + ']');
      if TmpStr[I] <> '' then
        if (ContainsText(UpperCase(TmpStr[I]), '.CLEAR')) or
          (ContainsText(UpperCase(TmpStr[I]), '.SET()')) or
          (ContainsText(UpperCase(TmpStr[I]), '.SETCAPTION')) then
        begin
          DebugMsg('* Clear / Set() / setcaption');
          SVar1 := Trim(SplitString(TmpStr[I], '.')[0]);
          DebugMsg('1669 SVar1:' + SVar1);
          SVar1 := GetCompByName(AOwner, SVar1);
          DebugMsg('1671 SVar1:' + SVar1);

          Co := MainForm.FindComponent(SVar1);
          if Co = Nil then
          begin
            Co := GetCompByNamePopUp(SVar1);
            if Co = Nil then
              raise Exception.Create('1856 RunAction() FindComponent Failure ['
                + SVar1 + ']');
          end;
          DebugMsg('1850 Comp Class[' + Co.ClassName + ']');
          if Co is TUniEdit then
            TUniEdit(Co).Clear
          else if Co is TUniLabel then
            TUniLabel(Co).Caption := ''
          else if Co is TUniDateTimePicker then
            TUniDateTimePicker(Co).Text := ''
          else if Co is TUniDBLookupComboBox then
            TUniDBLookupComboBox(Co).Clear
          else if Co is TUniCheckBox then
            TUniCheckBox(Co).Checked := False
          else if Co is TUniMemo then
            TUniMemo(Co).Lines.Clear
          else
            raise Exception.Create('1738 RunAction() : Component [' + SVar1 +
              '] unknown type.');
        end
        else if ContainsText(UpperCase(TmpStr[I]), '.CLOSE()') then
        begin
          DebugMsg('* ClOSE()');
          ActiveForm := TuniForm(UniSession.FormsList[UniSession.FormsList.Count
            - 1]).Name;
          DebugMsg('1662 Active From not "MainForm" = ' + ActiveForm);
          // for I := 0 to TuniForm(UniSession.FormsList[UniSession.FormsList.Count -
          // 1]).ComponentCount - 1 do
          for J := 0 to UniSession.FormsList.Count - 1 do
          begin
            DebugMsg('Form [' + UpperCase(Trim(TuniForm(UniSession.FormsList[J])
              .Name)) + ']  Find:[' + SplitString(UpperCase(TmpStr[I]), '.')
              [0] + ']');
            if UpperCase(Trim(TuniForm(UniSession.FormsList[J]).Name))
              = SplitString(UpperCase(TmpStr[I]), '.')[0] then
              TuniForm(UniSession.FormsList[J]).Close;
          end;
        end
        else if ContainsText(UpperCase(TmpStr[I]), '.REFRESH()') then
        begin
          DebugMsg('* REFRESH()');
          SVar1 := Trim(SplitString(TmpStr[I], '.')[0]);
          DebugMsg('1709 SVar1:' + SVar1);
          SVar1 := GetCompByName(AOwner, SVar1);
          DebugMsg('1711 SVar1:' + SVar1);
          Co := MainForm.FindComponent(SVar1);

          if Co = Nil then
          begin
            DebugMsg('1923 Tidak ketemu di Main form, cari di PopUp...');
            Co := GetCompByNamePopUp(SVar1);
            if Co = Nil then
              raise Exception.Create
                ('1927 RunAction() Query Open FindComponent Failure [' +
                SVar1 + ']');
          end;

          // execute query dulu
          SVar2 := TUniDBGrid(Co).DataSource.DataSet.Name;
          // fix prefix form xmlid
          SVar2 := StringReplace(SVar2, GetOwnerName(AOwner) + '_', '',
            [rfReplaceAll, rfIgnoreCase]);

          if Trim(SVar2) <> '' then
          begin
            DebugMsg('1790 Execute data set [' + SVar2 + ']');
            RunAction(AOwner, Trim(SVar2) + '.EXECUTE();');
          end;
          if Co is TUniDBGrid then
          begin
            LastRecNo := TUniDBGrid(Co).CurrRow + 1;
            TUniDBGrid(Co).Refresh;
            DebugMsg('1797 LastRecNo [' + IntToStr(LastRecNo) +
              '] DataSet.RecordCount [' + IntToStr(TUniDBGrid(Co)
              .DataSource.DataSet.RecordCount) + ']');
            if LastRecNo <= TUniDBGrid(Co).DataSource.DataSet.RecordCount then
              TUniDBGrid(Co).DataSource.DataSet.RecNo := LastRecNo;

          end
          else
            raise Exception.Create('1782 RunAction() : Component [' + SVar1 +
              '] unknown type.');
        end
        else if ContainsText(UpperCase(TmpStr[I]), '.FIRSTNODE()') then
        begin
          DebugMsg('* FIRSTNODE()');
          SVar1 := Trim(SplitString(TmpStr[I], '.')[0]);
          DebugMsg('1735 SVar1:' + SVar1);
          SVar1 := GetCompByName(AOwner, SVar1);
          DebugMsg('1737 SVar1:' + SVar1);
          Co := MainForm.FindComponent(SVar1);
          if Co is TUniDBGrid then
            TUniDBGrid(Co).DataSource.DataSet.First
          else
            raise Exception.Create('1796 RunAction() : Component [' + SVar1 +
              '] unknown type.');
        end
        else if ContainsText(UpperCase(TmpStr[I]), '.NEXTNODE') then
        begin
          DebugMsg('* NEXTNODE()');
          SVar1 := Trim(SplitString(TmpStr[I], '.')[0]);
          DebugMsg('1804 SVar1:' + SVar1);
          SVar1 := GetCompByName(AOwner, SVar1);
          DebugMsg('1806 SVar1:' + SVar1);
          Co := MainForm.FindComponent(SVar1);
          LastRecNo := TUniDBGrid(Co).DataSource.DataSet.RecNo;
          if Co is TUniDBGrid then
          begin
            // TUniDBGrid(Co).DataSource.DataSet.RecNo := TUniDBGrid(Co)
            // .DataSource.DataSet.RecNo + 1;
            // TUniDBGrid(Co).Refresh;
            TUniDBGrid(Co).CurrRow := LastRecNo;
            TUniDBGrid(Co).DataSource.DataSet.RecNo := LastRecNo + 1;

          end
          else
            raise Exception.Create('1810 RunAction() : Component [' + SVar1 +
              '] unknown type.');
        end

        else if ContainsText(UpperCase(TmpStr[I]), '.REFRESH()') then
        begin
          DebugMsg('* REFRESH()');
          SVar1 := Trim(SplitString(TmpStr[I], '.')[0]);
          DebugMsg('1804 SVar1:' + SVar1);
          SVar1 := GetCompByName(AOwner, SVar1);
          DebugMsg('1806 SVar1:' + SVar1);
          Co := MainForm.FindComponent(SVar1);
          if Co is TUniDBGrid then
            // TUniDBGrid(Co).DataSource.DataSet.First
            TUniDBGrid(Co).Refresh
          else
            raise Exception.Create('1839 RunAction() : Component [' + SVar1 +
              '] unknown type.');
        end
        else if ContainsText(UpperCase(TmpStr[I]), '.SELECT(') then
        begin
          DebugMsg('* SELECT()');
          SVar1 := Trim(SplitString(TmpStr[I], '.')[0]);
          DebugMsg('1840 SVar1:' + SVar1);
          if Trim(SVar1) = 'GRRESULT' then
          begin
            Co := MainForm.FindComponent(GetCompByName(AOwner, 'GRRESULT'));
            if Co <> nil then
              if Co is TUniDBGrid then
              begin
                SVar2 := GetCompValue(AOwner, 'FR5120_VANALYTNR');
                DebugMsg('1848 VANALYTNR value[' + SVar2 + ']');
                TUniDBGrid(Co).DataSource.DataSet.First;
                for J := 0 to TUniDBGrid(Co)
                  .DataSource.DataSet.RecordCount - 1 do
                begin
                  DebugMsg('1852 [' + TUniDBGrid(Co)
                    .DataSource.DataSet.FieldByName('ANALYTNR').AsString + ']['
                    + SVar2 + ']');

                  if TUniDBGrid(Co).DataSource.DataSet.FieldByName('ANALYTNR')
                    .AsString = SVar2 then
                  begin
                    // TUniDBGrid(Co).Refresh;
                    // TUniDBGrid(Co).DataSource.DataSet.Refresh;
                    DebugMsg('1859 Ketemu di Record [' + IntToStr(J) + ']');
                    TUniDBGrid(Co).DataSource.DataSet.RecNo := J + 1;
                    // TUniDBGrid(Co).sel := J + 1;
                    exit;
                  end;
                  TUniDBGrid(Co).DataSource.DataSet.Next;
                end;
              end;
          end;
        end
        else if (ContainsText(UpperCase(TmpStr[I]), '.DOSELECTED(')) and
          (ContainsText(UpperCase(TmpStr[I]), '.RUNSCRIPT')) then
        begin
          DebugMsg('1893 do selected with run script.[' + TmpStr[I] + ']');
          SVar1 := SplitString(TmpStr[I], '(')[1];
          DebugMsg('1900 SVar1 [' + SVar1 + ']');
          SVar2 := SplitString(TmpStr[I], '(')[0];
          DebugMsg('1902 SVar2 [' + SVar2 + ']');

          // run script
          DebugMsg('1904 Run Script');
          SVar1 := Trim(SplitString(SVar1, '.')[0]);
          SVar1 := Trim(StringReplace(SVar1, '''', '',
            [rfReplaceAll, rfIgnoreCase]));
          DebugMsg('AOwner:' + GetOwnerName(AOwner));
          DebugMsg('1907 SVar1 [' + SVar1 + ']');
          Co := GetCompByNameMain(GetOwnerName(AOwner) + '_' + SVar1);
          if Co <> Nil then
            DebugMsg('1909 Co [' + Co.Name + ']');
          // Co := AOwner.FindComponent(SVar1);
          if Co = Nil then
          begin
            DebugMsg('Tidak ketemu di Main form, cari di PopUp...');
            Co := GetCompByNamePopUp(GetOwnerName(AOwner) + '_' + SVar1);
            if Co = Nil then
              raise Exception.Create
                ('1856 RunAction() 1464 FindComponent Failure [' + SVar1 + ']');
          end;

          if not(Co is TUniMemo) then
            raise Exception.Create('1919 RunAction() : Component [' + SVar1 +
              '] is not memo, can not running action.');
          Mm := TUniMemo(Co);
          if Mm.Tag = 1 then
            RunActionJS(AOwner, Mm.Lines.Text)
          else
            RunAction(AOwner, Mm.Lines.Text);

        end
        else if ContainsText(UpperCase(TmpStr[I]), '.RUNSCRIPT') then
        begin
          DebugMsg('1892 Run Script');
          SVar1 := Trim(SplitString(TmpStr[I], '.')[0]);
          DebugMsg('1894 SVar1:' + SVar1);
          SVar2 := GetCompByName(AOwner, SVar1);
          DebugMsg('2303 SVar2:' + SVar2);
          DebugMsg('AOwner:' + AOwner.Name);
          Co := AOwner.FindComponent(SVar2);
          if Co = Nil then
          begin
            DebugMsg('Tidak ketemu di Main form, cari di PopUp...');
            if SVar2 <> '' then
              Co := GetCompByNamePopUp(SVar2)
            else
              Co := GetCompByNamePopUp(SVar1);
            if Co = Nil then
              raise Exception.Create
                ('1856 RunAction() 1464 FindComponent Failure [' + SVar1 + ']');
          end;

          if not(Co is TUniMemo) and (SVar1 <> 'scOnInitForm') then
            raise Exception.Create('1861 RunAction() : Component [' + SVar1 +
              '] is not memo, can not running action.');

          if (SVar1 = 'scOnInitForm') and not(Co is TUniMemo) then
            exit;

          Mm := TUniMemo(Co);
          if Mm.Tag = 1 then
            RunActionJS(AOwner, Mm.Lines.Text)
          else
            RunAction(AOwner, Mm.Lines.Text);
        end
        else if ContainsText(UpperCase(TmpStr[I]), '.EXECUTE') then
        begin
          DebugMsg('2032 Execute Query');
          if LeftStr(UpperCase(TmpStr[I]), 2) <> 'ST' then
          begin

            SVar1 := Trim(SplitString(TmpStr[I], '.')[0]);
            DebugMsg('1779 SVar1:' + SVar1);

            SVar1 := GetCompByName(AOwner, SVar1);
            DebugMsg('1780 SVar1:' + SVar1);
            if SVar1 = '' then
            begin
              Co := GetCompByNamePopUp(SVar1);
              if Co <> Nil then
                SVar1 := Co.Name;
            end;
            DebugMsg('2170 SVar1:' + SVar1);

            if SVar1 = '' then
              exit;

            Co := AOwner.FindComponent(SVar1);

            if Co = Nil then
            begin
              Co := GetCompByNamePopUp(SVar1);
              if Co = Nil then
                raise Exception.Create
                  ('RunAction Execute() 1549 FindComponent Failure [' +
                  SVar1 + ']');
            end;

            if Co is TFDStoredProc then
            begin
              DebugMsg('2015 TFDStoredProc');
              with TFDStoredProc(Co) do
              begin
                if Active then
                  Active := False;

                DebugMsg('2020 TFDStoredProc Name [' + Name + ']');
                DebugMsg('2021 PackageName [' + PackageName + ']');
                DebugMsg('2022 StoredProcName [' + StoredProcName + ']');
                DebugMsg('2023 Params.Count [' + IntToStr(Params.Count) + ']');


                // HARDCODE: command execute
                // TODO: buat engine untuk cek storeproc adalah execute command atau SP

                DebugMsg('Tag[' + IntToStr(Tag) + ']');

                if Tag = 1 then
                  if (Name = 'fr5120_qSetRelease') or (Name = 'fr5120_qSetRetry')
                  then
                  begin
                    DebugMsg('2032 Hardcode: execute function');
                    // ambil dulu text script nya

                    FdC := TFDCommand(GetCompByNameMain(Name + '_EXEC'));
                    if FdC = Nil then
                      FdC := TFDCommand(GetCompByNamePopUp(Name + '_EXEC'));
                    if FdC <> Nil then
                    begin

                      // get script query

                      if not ContainsText(UpperCase(FdC.CommandText.Text),
                        'CALL') then
                        FdC.CommandText.Text := 'call ' + FdC.CommandText.Text;

                      DebugMsg('2041 FdC.CommandText [' +
                        FdC.CommandText.Text + ']');
                      // isi param
                      TmpStr1 := SplitString(FdC.CommandText.Text, ',');
                      FdC.Params.Clear;
                      for J := 0 to length(TmpStr1) - 1 do
                      begin
                        if ContainsText(TmpStr1[J], '(') then
                          TmpStr1[J] := Trim(SplitString(TmpStr1[J], '(')[1]);
                        if ContainsText(TmpStr1[J], ')') then
                          TmpStr1[J] := Trim(SplitString(TmpStr1[J], ')')[0]);
                        DebugMsg('2052 Param [' + IntToStr(J) + '][' +
                          TmpStr1[J] + ']');
                        TmpStr1[J] := Trim(TmpStr1[J]);
                        if LeftStr(TmpStr1[J], 1) = ':' then
                        begin
                          SVar1 := UpperCase
                            (Trim(StringReplace(TmpStr1[J], ':', '',
                            [rfReplaceAll, rfIgnoreCase])));
                          DebugMsg('2065 Param [' + SVar1 + ']');
                          FdC.Params.Add.Name := SVar1;
                          SVar2 := GetCompValue(AOwner,
                            GetOwnerName(AOwner) + '_' + SVar1);
                          DebugMsg('2070 Value [' + SVar2 + ']');
                          FdC.ParamByName(SVar1).Value := SVar2;

                        end;

                      end;

                    end
                    else
                      raise Exception.Create
                        ('2044 Command exec cannot find comp EXEC [' +
                        Name + ']');
                    FdC.Execute;
                    FdC.Connection.Commit;
                    exit;
                  end;


                // Params.Clear;
                // Prepare;

                for J := 0 to Params.Count - 1 do
                begin
                  DebugMsg('2024 [' + IntToStr(J) + '][' + Params[J]
                    .Name + ']');
                end;

                // get value
                try
                  SVar3 := StringReplace(Co.Name, GetOwnerName(AOwner) + '_',
                    '', [rfReplaceAll, rfIgnoreCase]);
                  SVar3 := GetCompByName(AOwner, SVar3 + '_SQLTEXT');
                  DebugMsg('1913 Parameter SP SVar3:' + SVar3);
                  if SVar3 <> '' then
                  begin
                    // Co1 := AOwner.FindComponent(SVar3);
                    // SVar3 := TUniLabel(Co1).Caption;
                    SVar3 := GetCompValue(AOwner, SVar3);
                    DebugMsg('1918 Value:' + SVar3);
                    // parsing nilai
                    if ContainsText(SVar3, '(') and ContainsText(SVar3, ')')
                    then
                    begin
                      SVar3 := Trim
                        (SplitString(SplitString(SVar3, '(')[1], ')')[0]);
                      // DebugMsg('SVar3:' + SVar3);
                      TmpStr1 := SplitString(SVar3, ',');
                      for J := 0 to length(TmpStr1) - 1 do
                      begin
                        DebugMsg('2231TmpStr1[' + IntToStr(J) + '] = ' +
                          TmpStr1[J]);
                        TmpStr1[J] := Trim(TmpStr1[J]);

                        if LeftStr(TmpStr1[J], 1) = ':' then
                        begin
                          TmpStr1[J] := StringReplace(TmpStr1[J], ':', '',
                            [rfReplaceAll, rfIgnoreCase]);
                          SVar3 := Trim(TmpStr1[J]);
                          DebugMsg('SVar3:' + SVar3);
                          SVar4 := GetCompByName(AOwner, SVar3);
                          DebugMsg('SVar4:' + SVar4);

                          SVar4 := GetCompValue(AOwner, SVar4);
                          DebugMsg('SVar4 Value:' + SVar4);
                          TmpStr1[J] := SVar4
                        end
                        else
                        begin
                          TmpStr1[J] := StringReplace(TmpStr1[J], '''', '',
                            [rfReplaceAll, rfIgnoreCase]);
                        end;
                        // DebugMsg('FINAL TmpStr1[' + IntToStr(J) + '] = ' +
                        // TmpStr1[J]);
                      end;
                      // see value
                      Prepare;
                      DebugMsg('1902 Params.Count [' + IntToStr(Params.Count) +
                        '] length(TmpStr1)[' + IntToStr(length(TmpStr1)) + ']');
                      for J := 0 to length(TmpStr1) - 1 do
                      begin

                        if Params[J].ParamType = ptInput then
                          DebugMsg('1908 INPUT - Param[' + IntToStr(J) +
                            '].Name [' + Params[J].Name + '] VALUE [' +
                            TmpStr1[J] + ']')
                        else
                          DebugMsg('1910 OTHERS - Param[' + IntToStr(J) +
                            '].Name [' + Params[J].Name + '] VALUE [' +
                            TmpStr1[J] + ']');

                        if TmpStr1[J] <> '' then
                        begin
                          // if Params.Count > length(TmpStr1) then
                          if Params[0].ParamType <> ptInput then
                            Params[J + 1].Value := TmpStr1[J]
                          else
                            Params[J].Value := TmpStr1[J];
                        end;

                      end;
                    end;
                  end;
                except
                  on E: Exception do
                    MainForm.MessageDlg(E.Message, mtError, [mbOk], nil);
                end;

                for J := 0 to Params.Count - 1 do
                begin

                  // fix tanda =>
                  if not VarIsNull(Params[J].Value) then
                    if ContainsText(Params[J].Value, '>') then
                    begin
                      DebugMsg('2297 Ada tanda "=>"[' + Params[J].Value + ']');
                      TmpStr1[J] := Trim(SplitString(Params[J].Value, '>')[1]);
                      DebugMsg('2299 Fix "=>"[' + Params[J].Value + ']');
                    end;

                  if not VarIsNull(Params[J].Value) then
                    if UpperCase(Params[J].Value) = 'NULL' then
                      with Params[J] do
                      begin
                        DebugMsg('Null Clear Value.');
                        // DataType := ftString;
                        Clear;
                      end;

                  if VarIsNull(Params[J].Value) then
                    DebugMsg('1936 Params[' + IntToStr(J) + '].Name <' +
                      Params[J].Name + '>.Value <NULL>')
                  else

                    DebugMsg('1940 Params[' + IntToStr(J) + '].Name <' +
                      Params[J].Name + '>.Value <' +
                      VarToStr(Params[J].Value) + '>');

                end;

                // Execute();

                // MainForm.DataSource2.DataSet := TFDStoredProc(Co);
                if Tag = 1 then
                begin
                  DebugMsg('2125 Execute() SP.');
                  DebugMsg('2431 SPName [' + Name + ']');
                  Execute();

                  // Harcode set result need to refresh
                  if Name = 'F01_qSetResult' then
                  begin
                    RefreshDataSet(AOwner, 'grResult.Refresh');
                  end;

                  exit;
                end
                else
                begin
                  DebugMsg('2131 Open() SP.');
                  Open();
                  SetColumnGridFromDB(AOwner, Name);
                end;


                // TFDStoredProc(Co).DataSource.
                // Konfig Column field



                // DebugMsg('Konfig Column DBGrid yang link ke Query [' +
                // Name + ']');
                // for J := 0 to AOwner.ComponentCount - 1 do
                // if AOwner.Components[J] is TUniDBGrid then
                // begin
                // GrdName := TUniDBGrid(AOwner.Components[J]).Name;
                // DsName := TUniDBGrid(AOwner.Components[J]).DataSource.Name;
                // DebugMsg(IntToStr(J) + ':' + GrdName + '=' + DsName);
                // if ContainsText(DsName, '_') then
                // begin
                // DebugMsg('Cek DS:' + UpperCase(Trim(StringReplace(DsName,
                // 'DS_', '', [rfReplaceAll, rfIgnoreCase]))) + ' = ' +
                // UpperCase(Trim(Name)));
                // if UpperCase(Trim(StringReplace(DsName, 'DS_', '',
                // [rfReplaceAll, rfIgnoreCase]))) = UpperCase(Trim(Name))
                // then
                // DebugMsg('*** Ketemu [' + GrdName + '][' +
                // DsName + ']');
                // // columxml
                // ColumnData := GetCompValue(AOwner, GrdName + '_COLUMN');
                // DebugMsg('ColumnData [' + ColumnData + ']');
                //
                // end;
                //
                // end;
                //
                // xx

                // ColumnData := GetCompValue(AOwner, Name + '_COLUMN');
                // DebugMsg('ColumnData [' + ColumnData + ']');

                DebugMsg('Record Count open:' + IntToStr(RecordCount));
                for J := 0 to FieldCount - 1 do
                begin
                  DebugMsg(Fields[J].FieldName + '=>' +
                    VarToStr(Fields[J].Value));
                  SetCompValFromDB(AOwner, Fields[J].FieldName,
                    VarToStr(Fields[J].Value), Name);

                end;

              end;
            end
            else if Co is TFDQuery then
            begin
              DebugMsg('2439 TFDQuery');
              with TFDQuery(Co) do
              begin
                if Active then
                  Active := False;

                DebugMsg('Tag:' + IntToStr(Tag));
                SQL.Text := GetCompValue(AOwner, Name + '_SQLTEXT');
                DebugMsg('SQL.Text:' + SQL.Text);
                // SQLText := SQL.Text;
                // DebugMsg('SQLText:' + SQLText);

                if ContainsText(SQL.Text, '(') and ContainsText(SQL.Text, ')')
                  and ContainsText(SQL.Text, ',') then
                begin
                  SVar1 := SplitString(SQL.Text, '(')[1];
                  DebugMsg('1976 SVar1:' + SVar1);
                  SVar1 := SplitString(SVar1, ')')[0];
                  DebugMsg('1978 SVar1:' + SVar1);

                  TmpStr1 := SplitString(SVar1, ',');

                  for J := 0 to length(TmpStr1) - 1 do
                  begin
                    SVar1 := Trim(TmpStr1[J]);
                    DebugMsg(IntToStr(J) + ':' + SVar1);
                    SVar1 := GetCompByName(AOwner, SVar1);
                    SVar2 := GetCompValue(AOwner, SVar1);
                    DebugMsg('1988 SVar2:' + SVar2);
                    SQL.Text := StringReplace(SQL.Text, Trim(TmpStr1[J]),
                      QuotedStr(SVar2), [rfReplaceAll, rfIgnoreCase]);
                  end;

                  DebugMsg('Final SQL.Text:' + SQL.Text);

                end
                else if ContainsText(SQL.Text, '(') and
                  ContainsText(SQL.Text, ')') then
                // single param
                begin
                  SVar1 := SplitString(SQL.Text, '(')[1];
                  DebugMsg('2000 SVar1:' + SVar1);
                  SVar1 := Trim(SplitString(SVar1, ')')[0]);
                  DebugMsg('2003 SVar1:' + SVar1);

                  SComp1 := GetCompByName(AOwner, SVar1);
                  SVar2 := GetCompValue(AOwner, SComp1);
                  DebugMsg('2007 SVar2:' + SVar2);

                  SQL.Text := StringReplace(SQL.Text, Trim(SVar1),
                    QuotedStr(SVar2), [rfReplaceAll, rfIgnoreCase]);

                  DebugMsg('Final SQL.Text:' + SQL.Text);
                end;

                Open;

                DebugMsg('Record COUNT:' + IntToStr(RecordCount));

                // get value
                for J := 0 to FieldCount - 1 do
                begin
                  // for K := 0 to FieldCount - 1 do
                  DebugMsg('Fields[' + IntToStr(J) + '].FieldName :' +
                    Fields[J].FieldName);
                  Var1 := Fields[J].Value;
                  DebugMsg('Fields[' + IntToStr(J) + '].Value :' +
                    VarToStr(Var1));
                  // cari field
                  SVar1 := GetCompByName(AOwner, Fields[J].FieldName);
                  DebugMsg('2030 SVar1:' + SVar1);
                  Co := MainForm.FindComponent(SVar1);
                  if Co = Nil then
                  begin
                    DebugMsg('Tidak ketemu di Main form, cari di PopUp...');
                    Co := GetCompByNamePopUp(SVar1);
                    if Co = Nil then
                      raise Exception.Create
                        ('RunAction() Query Open 1780 FindComponent Failure [' +
                        SVar1 + ']');
                  end;
                  DebugMsg('2079 Co.Name:' + Co.Name);
                  if Co is TUniLabel then
                  begin
                    DebugMsg('2082 Co is label');
                    DebugMsg('2083 set Value:' + VarToStr(Var1));
                    TUniLabel(Co).Caption := VarToStr(Var1);
                  end
                  else if Co is TUniDateTimePicker then
                  begin
                    DebugMsg('Co is Date time picker');
                    TUniDateTimePicker(Co).DateTime := Var1
                  end
                  else
                    raise Exception.Create
                      ('RunAction() Query Execute : Component [' + SVar1 +
                      '] unknown type.');
                end;
                // DebugMsg('Set ulang SQLText:' + SQLText);
                // SQL.Text := SQLText;
              end;

            end
            else if Trim(SVar1) <> '' then
              raise Exception.Create('2166 RunAction() : Component [' + SVar1 +
                '] unknown type, it shoud FireDac Component.');
          end
          else
            DebugMsg('Start with ST*** skip (todo: status text).');

        end
        else if ContainsText(UpperCase(TmpStr[I]), '.SET(') then
        begin

          DebugMsg('* Set (Value)');
          SVar1 := Trim(SplitString(TmpStr[I], '.')[0]);
          SVar2 := SplitString(TmpStr[I], '(')[1];
          SVar2 := Trim(SplitString(SVar2, ')')[0]);

          SVar1 := GetCompByName(AOwner, SVar1);

          if (SVar2 <> 'Y') and (SVar2 <> 'N') and (SVar2 <> 'B') and
            (UpperCase(SVar2) <> 'MANDANT') then
          begin
            SVar2 := GetCompByName(AOwner, SVar2);
            DebugMsg('Finding [' + SVar2 + ']...');

            Co := MainForm.FindComponent(SVar2);

            if Co = Nil then
            begin
              Co := GetCompByNamePopUp(SVar2);
              if Co = Nil then
                raise Exception.Create
                  ('2195 RunAction() FindComponent Failure [' + SVar2 + ']');
            end;

            if Co is TUniLabel then
              SVar2 := TUniLabel(Co).Caption
            else if Co is TUniDateTimePicker then
              SVar2 := DateTimeToStr(TUniDateTimePicker(Co).DateTime)
            else
              raise Exception.Create
                ('RunAction() Find#1 Set (Value) : Component [' + Co.Name +
                '] unknown type.');
          end;

          if UpperCase(SVar2) = 'MANDANT' then
            SVar2 := Trim(UniApplication.Cookies.GetCookie('mandant'));

          Co := MainForm.FindComponent(SVar1);

          if Co = Nil then
          begin
            Co := GetCompByNamePopUp(SVar1);
            if Co = Nil then
              raise Exception.Create('2218 RunAction() FindComponent Failure ['
                + SVar1 + ']');
          end;

          if Co is TUniLabel then
            TUniLabel(Co).Caption := SVar2
          else if Co is TUniDBLookupComboBox then
            TUniDBLookupComboBox(Co).Text := SVar2
          else if Co is TUniDateTimePicker then
            TUniDateTimePicker(Co).DateTime := StrToDateTime(SVar2)

          else
            raise Exception.Create
              ('2230 RunAction() Find#2 Set (Value) : Component [' + SVar1 +
              '] unknown type.');

          DebugMsg('2132 SVar1:' + SVar1);
          DebugMsg('2133 SVar2:' + SVar2);

        end
        else if ContainsText(UpperCase(TmpStr[I]), '.ENABLE()') then
        begin
          DebugMsg('* enable()');
          SVar1 := Trim(SplitString(TmpStr[I], '.')[0]);
          SVar1 := Trim(StringReplace(UpperCase(SVar1), 'IF', '',
            [rfReplaceAll, rfIgnoreCase]));
          SVar1 := Trim(StringReplace(UpperCase(SVar1), '(', '',
            [rfReplaceAll, rfIgnoreCase]));
          SVar1 := GetCompByName(AOwner, SVar1);
          Co := MainForm.FindComponent(SVar1);
          if Co is TUniEdit then
            TUniEdit(Co).Enabled := True
          else if Co is TUniLabel then
            TUniLabel(Co).Enabled := True
          else if Co is TUniButton then
            TUniButton(Co).Enabled := True
          else if Co is TUniDateTimePicker then
            TUniDateTimePicker(Co).Enabled := True
          else if Co is TUniDBLookupComboBox then
            TUniDBLookupComboBox(Co).Enabled := True
          else if Co is TUniCheckBox then
            TUniCheckBox(Co).Enabled := True
          else
            raise Exception.Create('2256 RunAction() : enable() [' + SVar1 +
              '] unknown type.');
        end
        else if ContainsText(UpperCase(TmpStr[I]), '.DISABLE()') then
        begin
          DebugMsg('2165 disable()');
          SVar1 := Trim(SplitString(TmpStr[I], '.')[0]);
          SVar1 := GetCompByName(AOwner, SVar1);
          Co := MainForm.FindComponent(SVar1);
          if Co is TUniEdit then
            TUniEdit(Co).Enabled := False
          else if Co is TUniLabel then
            TUniLabel(Co).Enabled := False
          else if Co is TUniButton then
            TUniButton(Co).Enabled := False
          else if Co is TUniDateTimePicker then
            TUniDateTimePicker(Co).Enabled := False
          else if Co is TUniDBLookupComboBox then
            TUniDBLookupComboBox(Co).Enabled := False
          else if Co is TUniCheckBox then
            TUniCheckBox(Co).Enabled := False
          else if Co is TUniDBGrid then
            TUniDBGrid(Co).Enabled := False
          else
            raise Exception.Create('2280 RunAction() : disable() [' + SVar1 +
              '] unknown type.');
        end
        else if ContainsText(UpperCase(TmpStr[I]), '.SETFOCUS') then
        begin
          DebugMsg('2724 SetFocus()');
          SVar1 := Trim(SplitString(TmpStr[I], '.')[0]);
          SVar1 := GetCompByName(AOwner, SVar1);
          Co := AOwner.FindComponent(SVar1);

          if Co = Nil then
          begin
            DebugMsg('2635 Tidak ketemu di Main form, cari di PopUp...');
            if ContainsText(SVar1, '_') then
              Co := GetCompByNamePopUp(SVar1)
            else
              Co := GetCompByNamePopUp(GetOwnerName(AOwner) + '_' + SVar1);
            if Co = Nil then
              raise Exception.Create('2639 RunAction() FindComponent Failure ['
                + SVar1 + '][' + TmpStr[I] + ']');
          end;

          if Co is TUniEdit then
            TUniEdit(Co).SetFocus
          else if Co is TUniLabel then
            TUniLabel(Co).SetFocus
          else if Co is TUniButton then
            TUniButton(Co).SetFocus
          else if Co is TUniDateTimePicker then
            TUniDateTimePicker(Co).SetFocus
          else if Co is TUniDBLookupComboBox then
            TUniDBLookupComboBox(Co).SetFocus
          else if Co is TUniCheckBox then
            TUniCheckBox(Co).SetFocus
          else if Co is TUniDBGrid then
            TUniDBGrid(Co).SetFocus
          else if Co is TUniMemo then
            TUniMemo(Co).SetFocus
          else
            raise Exception.Create('2304 RunAction() : SetFocus() [' + SVar1 +
              '] unknown type.');
        end
        else if (ContainsText(UpperCase(TmpStr[I]), '.OPENUPD')) or
          (ContainsText(UpperCase(TmpStr[I]), '.OPENINS')) then
        begin
          try
            DebugMsg('* OpenUpd() / OpenIns():' + TmpStr[I]);
            SVar1 := Trim(SplitString(TmpStr[I], '.')[0]);
            DebugMsg('2212 SVar1:' + SVar1);
            DebugMsg('*** POP UP ****');

            Pop := TfrmPopUp.Create(UniApplication);

            // Pop.Show(
            // procedure(Sender: TComponent; Result: integer)
            // begin
            // // DebugMsg('Form: ' + (Sender as TfrmPopUp).Name + ', Result: ' +
            // // IntToStr(Result));
            //
            // end);

            SVar2 := GetCompByNameStr(AOwner, SVar1);
            DebugMsg(SVar2);
            TmpStr0 := SplitString(SVar2, sLineBreak);

            Pop.CallerFormName := GetOwnerName(AOwner);
            DebugMsg('Pop.CallerFormName [' + Pop.CallerFormName + ']');

            for K := 0 to length(TmpStr0) - 1 do
            begin
              if ContainsText(TmpStr0[K], '=') then
              begin
                DebugMsg(TmpStr0[K]);
                SVar1 := Trim(SplitString(TmpStr0[K], '=')[0]);
                SVar2 := Trim(SplitString(TmpStr0[K], '=')[1]);

                DebugMsg('2240 SVar1:' + SVar1);
                DebugMsg('2241 SVar2:' + SVar2);
                if SVar1 = 'ID' then
                  Pop.Name := GetOwnerName(AOwner) + '_' + SVar2;
                if SVar1 = 'TITLE' then
                  Pop.Caption := SVar2;
                if SVar1 = 'FORMID' then
                  Pop.FORMID := StrToInt(SVar2);
                if SVar1 = 'XMLID' then
                  Pop.XMLID := StrToInt(SVar2);
                if SVar1 = 'PARAM' then
                  Pop.Param := SVar2;
                if SVar1 = 'WIDTH' then
                  Pop.Width := StrToInt(SVar2);
                if SVar1 = 'HEIGHT' then
                  Pop.Height := StrToInt(SVar2);
                if SVar1 = 'TOP' then
                  Pop.Top := StrToInt(SVar2);
                if SVar1 = 'LEFT' then
                  Pop.left := StrToInt(SVar2);
              end;
            end;

            DebugMsg('Pop.Param [' + Pop.Param + ']');
            // Pop.ShowModal;

          except
            on E: Exception do
              MainForm.MessageDlg(E.Message, mtError, [mbOk], nil);
          end;

        end
        else if (ContainsText(UpperCase(TmpStr[I]), 'K1.')) or
          (ContainsText(UpperCase(TmpStr[I]), 'SPINS.')) then
        begin
          // TODO: K1,SPINS = Perlu action khusus untuk buat card lagi. saat ini di skip dulu
          DebugMsg('TODO skip:' + TmpStr[I]);
        end
        else if TmpStr[I] <> '' then
          raise Exception.Create('2380 RunAction() : Unknown script [' +
            TmpStr[I] + '].');

    end;
  except
    on E: Exception do
      MainForm.MessageDlg(E.Message, mtError, [mbOk], nil);
  end;

  {

    TmpStr := SplitString(Script, ';');
    for I := 0 to length(TmpStr) - 1 do
    begin
    TmpStr[I] := Trim(TmpStr[I]);
    DebugMsg('tmpStr[' + IntToStr(I) + ']:' + TmpStr[I]);
    // POP UP window
    if UpperCase(LeftStr(TmpStr[I], 3)) = 'POP' then
    begin
    DebugMsg('*** POP UP ****');
    TmpStr0 := SplitString(TmpStr[I], '.');
    for J := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[J] is TUniMemo then
    begin
    Mm := TUniMemo(AOwner.Components[J]);
    DebugMsg('POP Mm.Name:' + Mm.Name + ' cek for:' + UpperCase(Mm.Name) +
    ' = ' + UpperCase(GetOwnerName(AOwner)) + '_' +
    UpperCase(TmpStr0[0]));
    if UpperCase(Mm.Name) = UpperCase(GetOwnerName(AOwner)) + '_' +
    UpperCase(TmpStr0[0]) then
    begin
    // ketemu
    Pop := TfrmPopUp.Create(UniApplication);
    for K := 0 to Mm.Lines.Count - 1 do
    begin
    Line := Mm.Lines.Strings[K];
    if SplitString(Line, '=')[0] = 'ID' then
    Pop.Name := SplitString(Line, '=')[1];
    if SplitString(Line, '=')[0] = 'TITLE' then
    Pop.Caption := SplitString(Line, '=')[1];
    if SplitString(Line, '=')[0] = 'FORMID' then
    Pop.FORMID := StrToInt(SplitString(Line, '=')[1]);
    if SplitString(Line, '=')[0] = 'XMLID' then
    Pop.XMLID := StrToInt(SplitString(Line, '=')[1]);
    if SplitString(Line, '=')[0] = 'PARAM' then
    Pop.Param := SplitString(Line, '=')[1];
    if SplitString(Line, '=')[0] = 'WIDTH' then
    Pop.Width := StrToInt(SplitString(Line, '=')[1]);
    if SplitString(Line, '=')[0] = 'HEIGHT' then
    Pop.Height := StrToInt(SplitString(Line, '=')[1]);
    if SplitString(Line, '=')[0] = 'TOP' then
    Pop.Top := StrToInt(SplitString(Line, '=')[1]);
    if SplitString(Line, '=')[0] = 'LEFT' then
    Pop.Left := StrToInt(SplitString(Line, '=')[1]);

    // // define hardcode untuk XML ID
    // if Pop.XMLID = 10143 then
    // Pop.Height := 370;

    end;
    Pop.ShowModal;
    end;
    end;

    end

    // cek Edit Box
    else if UpperCase(LeftStr(TmpStr[I], 2)) = 'ED' then
    begin
    DebugMsg('* ED *');
    TmpStr0 := SplitString(TmpStr[I], '.');
    for J := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[J] is TUniEdit then
    begin
    Ed := TUniEdit(AOwner.Components[J]);
    if UpperCase(Ed.Name) = UpperCase(TmpStr0[0]) then
    begin
    // Clear field
    if TmpStr0[1] = 'Clear' then
    Ed.Clear;
    // Enable edit
    if TmpStr0[1] = 'enable()' then
    Ed.Enabled := True;
    // Set Focus
    if Trim(TmpStr0[1]) = 'SetFocus' then
    Ed.SetFocus;

    end;
    end;
    end

    // cek Lookup Box
    else if UpperCase(LeftStr(TmpStr[I], 2)) = 'LO' then
    begin
    DebugMsg('** Lookup Button [LO]..');
    TmpStr0 := SplitString(TmpStr[I], '.');
    for J := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[J] is TUniDBLookupComboBox then
    begin
    Lo := TUniDBLookupComboBox(AOwner.Components[J]);
    if UpperCase(Lo.Name) = UpperCase(GetOwnerName(AOwner) + '_' +
    UpperCase(TmpStr0[0])) then
    begin
    // Clear field
    if TmpStr0[1] = 'Clear' then
    Lo.Clear;
    // Enable edit
    if TmpStr0[1] = 'enable()' then
    Lo.Enabled := True;

    // Set Value
    if LeftStr(TmpStr0[1], 4) = 'Set(' then
    begin
    ParamName :=
    UpperCase(SplitString(SplitString(TmpStr0[1], '(')[1], ')')[0]);

    if ParamName = UpperCase('mandant') then
    begin
    Lo.Text := UniApplication.Cookies.GetCookie('mandant');
    end;

    // for K := 0 to ComponentCount - 1 do
    // if Components[K] is TUniDBLookupComboBox then
    // begin
    // if Components[K].Name = ParamName then
    // begin
    // Lb := TUniLabel(Components[K]);
    // mm3.Lines.Add(Lb.Name);
    // mm3.Lines.Add(Lb.Caption);
    // Da.DateTime := StrToDateTime(Lb.Caption);
    // end;
    // end;
    end;

    end;
    end;
    end

    // cek Button
    else if UpperCase(LeftStr(TmpStr[I], 2)) = 'BU' then
    begin
    DebugMsg('** Button [BU]..');
    TmpStr0 := SplitString(TmpStr[I], '.');
    for J := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[J] is TUniButton then
    begin
    Bt := TUniButton(AOwner.Components[J]);
    if UpperCase(Bt.Name) = UpperCase(GetOwnerName(AOwner) + '_' +
    UpperCase(TmpStr0[0])) then
    begin
    // Clear field
    if TmpStr0[1] = 'disable()' then
    Bt.Enabled := false;
    // Enable edit
    if TmpStr0[1] = 'enable()' then
    Bt.Enabled := True;

    end;
    end;
    end

    // cek Datetime picker
    else if UpperCase(LeftStr(TmpStr[I], 2)) = 'DA' then
    begin
    DebugMsg('** DateTimePicker [DA]..');
    TmpStr0 := SplitString(TmpStr[I], '.');
    for J := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[J] is TUniDateTimePicker then
    begin
    Da := TUniDateTimePicker(AOwner.Components[J]);
    if UpperCase(Da.Name) = UpperCase(GetOwnerName(AOwner) + '_' +
    UpperCase(TmpStr0[0])) then
    begin
    // Clear field
    if TmpStr0[1] = 'disable()' then
    Da.Enabled := false;
    // Enable edit
    if TmpStr0[1] = 'enable()' then
    Da.Enabled := True;

    // Set Value
    if LeftStr(TmpStr0[1], 4) = 'Set(' then
    begin
    ParamName :=
    UpperCase(SplitString(SplitString(Script, '(')[1], ')')[0]);
    for K := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[K] is TUniLabel then
    begin
    if AOwner.Components[K].Name = ParamName then
    begin
    Lb := TUniLabel(AOwner.Components[K]);
    Da.DateTime := StrToDateTime(Lb.Caption);
    end;
    end;
    end;
    end;
    end;
    end

    // cek Query
    else if UpperCase(LeftStr(TmpStr[I], 1)) = 'Q' then
    begin
    TmpStr0 := SplitString(TmpStr[I], '.');
    for J := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[J] is TFDStoredProc then
    begin
    Q := TFDStoredProc(AOwner.Components[J]);
    if UpperCase(Q.Name) = UpperCase('SP_' + TmpStr0[0]) then
    begin
    // Execute
    if TmpStr0[1] = 'execute' then
    begin
    // mm2.Lines.Add('Execute.');
    end;
    end;
    end;
    // Query
    for J := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[J] is TFDQuery then
    begin
    Qr := TFDQuery(AOwner.Components[J]);
    if UpperCase(Qr.Name) = UpperCase('SP_' + TmpStr0[0]) then
    begin
    // Execute
    if TmpStr0[1] = 'execute' then
    begin
    if Qr.Active then
    Qr.Active := false;
    Qr.Prepare;
    Qr.ExecSQL;
    for K := 0 to Qr.ParamCount - 1 do
    begin
    if True then
    begin
    Qr.Params[K].ParamType := ptOutput;
    // find variable
    for L := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[L] is TUniLabel then
    begin
    // temukan variabel isi nilai nya
    if AOwner.Components[L].Name = Qr.Params[K].Name then
    begin
    Lb := TUniLabel(AOwner.Components[L]);
    if Qr.Params[K].DataType = ftDateTime then
    Lb.Caption := DateTimeToStr(Qr.Params[K].Value);
    end;
    end;
    end;
    end;

    end;
    end;
    end;
    end

    // Script Action
    else if UpperCase(LeftStr(TmpStr[I], 1)) = 'S' then
    begin
    DebugMsg('* Script Action *** ');
    // DebugMsg('* Script Action *** Find:' + UpperCase(GetOwnerName(AOwner) +
    // '_' + tmpStr0[0]));
    TmpStr0 := SplitString(TmpStr[I], '.');

    for J := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[J] is TUniMemo then
    begin
    Mm := TUniMemo(AOwner.Components[J]);
    // DebugMsg(UpperCase(Mm.Name) + '  = ' + UpperCase(GetOwnerName(AOwner)
    // + '_' + tmpStr0[0]));
    if UpperCase(Mm.Name) = UpperCase(GetOwnerName(AOwner) + '_' +
    TmpStr0[0]) then
    begin
    DebugMsg('** Found:' + Mm.Name);
    DebugMsg('tmpStr0[1]:' + TmpStr0[1] + ' Cek for:' +
    UpperCase(TmpStr0[1]) + ' = ' + 'RUNSCRIPT');
    if UpperCase(TmpStr0[1]) = 'RUNSCRIPT' then
    begin
    DebugMsg('Run Script...');
    // Run Script Action
    if Mm.Tag = 1 then
    RunActionJS(AOwner, Mm.Lines.Text)
    else
    RunAction(AOwner, Mm.Lines.Text);
    end;
    end;
    end;
    end
    else
    DebugMsg('!! notfound.');

    end; // loop
  }
end;

procedure BuildPreVariable(AOwner: TComponent; VarName: string; frName: string);
var
  Lb: TUniLabel;
begin
  DebugMsg('Variable');
  DebugMsg('******************** BUILD PREDEFINE VARIABEL =>' + VarName +
    '**********************');

  Lb := TUniLabel.Create(AOwner);
  Lb.Name := GetOwnerName(AOwner) + '_' + VarName;
  Lb.Caption := '';

  Lb.Visible := False;
  DebugMsg('** ' + Lb.Name);
end;

procedure SetCompValue(AOwner: TComponent; CompName: string; Value: String);
var
  Co: TComponent;
  TmpStr: string;
  fs: TFormatSettings;
begin
  try
    DebugMsg('2633 SetCompValue() ' + CompName);
    if UpperCase(LeftStr(CompName, 2)) = 'FR' then
    begin
      DebugMsg('2640 Main Form.');
      Co := GetCompByNameMain(CompName);
    end
    else
    begin
      DebugMsg('2645 PopUpForm.');
      Co := GetCompByNamePopUp(CompName);
    end;
    DebugMsg('2648 Component Name found:' + Co.Name);
    DebugMsg('2649 Set value:' + Value);
    if Co is TUniEdit then
      TUniEdit(Co).Text := Value
    else if Co is TUniDBLookupComboBox then
      TUniDBLookupComboBox(Co).Text := Value
    else if Co is TUniDateTimePicker then
    begin
      fs := TFormatSettings.Create;
      fs.DateSeparator := '-';
      fs.ShortDateFormat := 'dd-mmm-yy';
      fs.TimeSeparator := ':';
      fs.ShortTimeFormat := 'hh:mm';
      fs.LongTimeFormat := 'hh:mm:ss';
      TUniDateTimePicker(Co).DateTime := StrToDateTime(Value, fs);
    end
    else if Co is TUniCheckBox then
    begin
      if Value = '0' then
        TUniCheckBox(Co).Checked := False;
      if Value = '1' then
        TUniCheckBox(Co).Checked := True;
    end
    else if Co is TUniLabel then
    begin
      DebugMsg('UniLabel:' + TUniLabel(Co).Name + ' set caption:' + Value);
      TUniLabel(Co).Caption := Value;
    end
    else
      raise Exception.Create('2664 SetCompValue() : Component [' + Co.Name +
        '] unknown type.');
  except
    on E: Exception do
      MainForm.MessageDlg('2672 SetCompValue():' + E.Message, mtError,
        [mbOk], nil);
  end;
end;

procedure SetColumnGridFromDB(AOwner: TComponent; CompName: String);
var
  I, J, K: integer;
  GrdName, DsName, ColumnData, WidthReg, IndexReg: string;
  XmlNd: IXMLNode;
  XmlNdChild: IXMLNode;
  Doc: IXMLDocument;
  Gr: TUniDBGrid;
  BMatch: boolean;
begin
  DebugMsg('SetColumnGridFromDB() [' + CompName + ']');
  for I := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[I] is TUniDBGrid then
    begin
      GrdName := TUniDBGrid(AOwner.Components[I]).Name;
      DsName := TUniDBGrid(AOwner.Components[I]).DataSource.Name;
      DebugMsg(IntToStr(I) + ':' + GrdName + '=' + DsName);
      if ContainsText(DsName, '_') then
      begin
        DebugMsg('Cek DS:' + UpperCase(Trim(StringReplace(DsName, 'DS_', '',
          [rfReplaceAll, rfIgnoreCase]))) + ' = ' + UpperCase(Trim(CompName)));
        if UpperCase(Trim(StringReplace(DsName, 'DS_', '', [rfReplaceAll,
          rfIgnoreCase]))) = UpperCase(Trim(CompName)) then
        begin
          DebugMsg('*** Ketemu [' + GrdName + '][' + DsName + ']');
          // columxml
          ColumnData := GetCompValue(AOwner, GrdName + '_COLUMN');
          ColumnData := '<ExpGrid>' + ColumnData + '</ExpGrid>';
          DebugMsg('3266 ColumnData [' + ColumnData + ']');

          // read XML
          DefaultDOMVendor := sOmniXmlVendor;

          Doc := LoadXMLData(ColumnData);
          DebugMsg('3272 Doc:' + Doc.Xml.ToString);

          XmlNd := Doc.DocumentElement;
          DebugMsg('3275 XmlNd:' + XmlNd.Xml);

          DebugMsg('3277 GrdName:' + GrdName);

          with AOwner.FindComponent(GrdName) as TUniDBGrid do
          begin
            for J := 0 to Columns.Count - 1 do
            begin
              for K := 0 to XmlNd.ChildNodes.Count - 1 do
              begin
                BMatch := False;
                if UpperCase(XmlNd.ChildNodes[K].Attributes['NAME'])
                  = UpperCase(Columns.Items[J].FieldName) then
                begin
                  BMatch := True;
                  // DebugMsg('Match.');
                  Columns.Items[J].ReadOnly := True;
                  Columns.Items[J].Tag := 1;
                  Columns.Items[J].Sortable := False;
                  Columns.Items[J].Menu.MenuEnabled := False;
                  // Columns.Items[J].Flex := 1;

                  // DebugMsg('Set Caption..');
                  if not VarIsNull(XmlNd.ChildNodes[K].Attributes['CAPTION'])
                  then
                    Columns.Items[J].Title.Caption := XmlNd.ChildNodes[K]
                      .Attributes['CAPTION'];

                  if not VarIsNull(XmlNd.ChildNodes[K].Attributes['TYPE']) then
                  begin
                    if UpperCase(XmlNd.ChildNodes[K].Attributes['TYPE']) = 'CHECK'
                    then
                    begin
                      Columns.Items[J].CheckBoxField.BooleanFieldOnly := False;
                      Columns.Items[J].CheckBoxField.DisplayValues := ';';
                      Columns.Items[J].CheckBoxField.FieldValues :=
                        XmlNd.ChildNodes[K].Attributes['CHECK'] + ';' +
                        XmlNd.ChildNodes[K].Attributes['UNCHECK'];
                      // Columns.Items[J].ShowToolTip := True;
                      // Columns.Items[J].ShowToolTipAlways := True;
                    end;
                  end;

                  // DebugMsg('Set Visible..');
                  if not VarIsNull(XmlNd.ChildNodes[K].Attributes['VISIBLE'])
                  then
                    if UpperCase(XmlNd.ChildNodes[K].Attributes['VISIBLE']) = 'Y'
                    then
                      Columns.Items[J].Visible := True
                    else
                      Columns.Items[J].Visible := False;

                  // DebugMsg('Set Width..');
                  // if not VarIsNull(XmlNd.ChildNodes[K].Attributes['WIDTH']) then
                  // begin
                  // Columns.Items[J].Width :=
                  // StrToInt(XmlNd.ChildNodes[K].Attributes['WIDTH'] + 40);
                  // end;

                  // Width
                  WidthReg := GetGridColRegVal(AOwner.FindComponent(GrdName)
                    as TUniDBGrid, TUniDBGrid(AOwner.FindComponent(GrdName))
                    .Columns[J].FieldName, 'Width');

                  if WidthReg <> '' then
                    Columns.Items[J].Width := StrToInt(WidthReg)
                  else if not VarIsNull(XmlNd.ChildNodes[K].Attributes['WIDTH'])
                  then
                  begin
                    Columns.Items[J].Width :=
                      StrToInt(XmlNd.ChildNodes[K].Attributes['WIDTH'] + 40);
                  end;

                  IndexReg := GetGridColRegVal(AOwner.FindComponent(GrdName)
                    as TUniDBGrid, TUniDBGrid(AOwner.FindComponent(GrdName))
                    .Columns[J].FieldName, 'Index');

                  if IndexReg <> '' then
                    Columns.Items[J].index := StrToInt(IndexReg)
                  else if not VarIsNull(XmlNd.ChildNodes[K].Attributes['SORT'])
                  then
                  begin
                    Columns.Items[J].Width :=
                      StrToInt(XmlNd.ChildNodes[K].Attributes['SORT']);
                  end;

                end
                else
                begin
                  // delete column
                  // Columns.Items[J].Visible := False;
                  // Columns.Items[J].Menu.ColumnHideable := False;
                end;
              end;
            end;
          end;

          //
          with AOwner.FindComponent(GrdName) as TUniDBGrid do
          begin
            for J := 0 to Columns.Count - 1 do
            begin
              // DebugMsg('Cek kolumn:' + Columns[J].FieldName + ':' +
              // IntToStr(Columns[J].Tag) + ':' + Columns[J].Title.Caption);
              if Columns.Items[J].Tag = 0 then
              begin
                // DebugMsg('Hide.');
                Columns[J].Visible := False;
                Columns[J].Menu.ColumnHideable := False;
              end;
            end;

          end;

          // rekonfig column again
          ReConfGridCol(AOwner.FindComponent(GrdName) as TUniDBGrid);
        end;
      end;
    end;
end;

procedure SetCompValFromDB(AOwner: TComponent; CompName: String;
  CompValue: string; DbCompaName: String);
var
  XmlStr, TmpStr: string;
  XmlNd: IXMLNode;
  XmlNdChild: IXMLNode;
  Doc: IXMLDocument;
  I, J: integer;
begin
  DebugMsg('******************** SetCompValFromDB(ComName:' + CompName +
    ',CompValue:' + CompValue + ',DbCompaName:' + DbCompaName + ')');
  XmlStr := '<QueryEx>' + GetCompValue(AOwner, DbCompaName + '_VAR') +
    '</QueryEx>';
  // DebugMsg('XmlStr:' + XmlStr);

  // read XML
  DefaultDOMVendor := sOmniXmlVendor;

  Doc := LoadXMLData(XmlStr);
  // DebugMsg('Doc:' + Doc.Xml.ToString);

  XmlNd := Doc.DocumentElement;
  // DebugMsg('XmlNd:' + XmlNd.Xml);

  for I := 0 to XmlNd.ChildNodes.Count - 1 do
  begin
    // if not VarIsNull(XmlNd.ChildNodes.Get(I).NodeValue) then
    // DebugMsg(IntToStr(I) + ':' + XmlNd.ChildNodes[I].Xml);
    // DebugMsg(IntToStr(I) + ':KEYFIELD =>[' +
    // UpperCase(XmlNd.ChildNodes[I].Attributes['KEYFIELD']) + '] find:[' +
    // UpperCase(CompName) + ']');
    if UpperCase(XmlNd.ChildNodes[I].Attributes['KEYFIELD'])
      = UpperCase(CompName) then
    begin
      // DebugMsg('** Proses value.');
      // isi Label atau variabel
      // DebugMsg('** find field:' + CompName);
      // ambil ID dari KeyField untuk nama component
      TmpStr := 'LBL_' + XmlNd.ChildNodes[I].Attributes['ID'];
      TmpStr := GetCompByName(AOwner, TmpStr);
      // DebugMsg('** full find name:' + TmpStr);
      if Trim(TmpStr) <> '' then
      begin
        // DebugMsg('Label FOUND.');
        if VarToStr(CompValue) <> '' then
          SetCompValue(AOwner, TmpStr, CompValue)
        else
          SetCompValue(AOwner, TmpStr, '');
      end
      else
        DebugMsg('Label NOT FOUND.');

      // variabel
      // DebugMsg('** find VARIABEL:' + CompName);
      TmpStr := XmlNd.ChildNodes[I].Attributes['ID'];
      TmpStr := GetCompByName(AOwner, TmpStr);
      // DebugMsg('** full find name:' + TmpStr);
      if Trim(TmpStr) <> '' then
      begin
        // DebugMsg('Label FOUND.');
        if VarToStr(CompValue) <> '' then
          SetCompValue(AOwner, TmpStr, CompValue)
        else
          SetCompValue(AOwner, TmpStr, '');
      end
      else
        DebugMsg('Label NOT FOUND.');

    end;
  end;

end;

// VARIABEL
procedure BuildVariable(AOwner: TComponent; XmlNd: IXMLNode; frName: string);
var
  Lb: TUniLabel;
  DefValue: String;
  Co: TComponent;
  TmpStr: TStringDynArray;
  I, J: integer;
begin
  DebugMsg('******************** BUILD VARIABEL [' + AOwner.Name + '][' +
    XmlNd.Attributes['ID'] + '] **********************');

  DefValue := '';

  Lb := TUniLabel.Create(AOwner);

  if AOwner.FindComponent(GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID']) = Nil
  then
    Lb.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];
  Lb.Caption := '';
  if not VarIsNull(XmlNd.Attributes['DEF']) then
    Lb.Caption := XmlNd.Attributes['DEF'];

  if not VarIsNull(XmlNd.Attributes['DATATYPE']) then
    if UpperCase(XmlNd.Attributes['DATATYPE']) = 'DATE' then
      Lb.Caption := DateToStr(Now);

  Lb.Tag := 0;
  if not VarIsNull(XmlNd.Attributes['TYPE']) then
    if UpperCase(XmlNd.Attributes['TYPE']) = 'RETURN' then
    begin
      Lb.Tag := 1;
      if not VarIsNull(XmlNd.Attributes['KEYFIELD']) then
        Lb.Name := Lb.Name + '_X_' + XmlNd.Attributes['KEYFIELD'];
    end
    else if not VarIsNull(XmlNd.Attributes['KEYFIELD']) then
      Lb.Name := Lb.Name + '_X_' + XmlNd.Attributes['KEYFIELD'];

  Lb.Visible := False;
  DebugMsg('** Lb Name:' + Lb.Name);

  if Trim(AOwner.Name) <> 'MainForm' then
  begin
    DebugMsg('*** Variable on PopUp Form *** [' + AOwner.Name + ']');
    DebugMsg('***  PopUp Caller Form Name:' + TfrmPopUp(AOwner).CallerFormName);
    DebugMsg('***  PopUp Parameter:' + TfrmPopUp(AOwner).Param);
    Co := MainForm.FindComponent(TfrmPopUp(AOwner).CallerFormName);
    DebugMsg('***  TComp Name:' + Co.Name);
    // get  value
    if not VarIsNull(XmlNd.Attributes['KEYFIELD']) then
    begin
      TmpStr := SplitString(TfrmPopUp(AOwner).Param, ';');
      if length(TmpStr) > 0 then
        for I := 0 to length(TmpStr) - 1 do
        begin
          // DefValue := TUniLabel(Co.FindComponent(Trim(TmpStr[I]))).Caption;
          DebugMsg('2938 param[' + IntToStr(I) + '][' + TmpStr[I] + ']');
          if UpperCase(Trim(TmpStr[I]))
            = UpperCase(Trim(XmlNd.Attributes['KEYFIELD'])) then
          begin
            DebugMsg('2942 ambil value');

            // DefValue := GetCompValue(Co, Co.Name + '_' + Trim(TmpStr[I]));
            // DebugMsg('[' + DefValue + ']');
            if LeftStr(Co.Name, 2) = 'fr' then
              for J := 0 to MainForm.ComponentCount - 1 do
              begin
                if UpperCase(Trim(MainForm.Components[J].Name))
                  = UpperCase(Trim(Co.Name) + '_' +
                  Trim(XmlNd.Attributes['KEYFIELD'])) then
                begin
                  DebugMsg('[' + IntToStr(J) + '] Name[' +
                    Trim(MainForm.Components[J].Name) + ']');
                  if MainForm.Components[J] is TUniLabel then
                  begin
                    Lb.Caption := TUniLabel(MainForm.Components[J]).Caption;
                    DebugMsg('Var DefValue [' + Lb.Caption + ']');
                  end;
                end;
              end;
          end;
        end;

    end;
    // DefValue := GetCompValue(UnitPopUp(AOwner), 'x');
    // lb.Caption := SetCompValue(AOwner,Lb.Name,;
  end;

end;

procedure FDSPAfterScroll(DataSet: TDataSet);
begin
  DebugMsg('FDSPAfterScroll()');
end;

// Event handler
type
  TDataSetNotifyEvent = procedure(DataSet: TDataSet) of object;

  // QUERY
procedure BuildQuery(AOwner: TComponent; XmlNd: IXMLNode; frName: string);
var
  FdSP: TFDStoredProc;
  Mm: TUniMemo;
  ds: TDataSource;
  FdQ: TFDQuery;
  FdC: TFDCommand;
  Script, PackageName, StoredProcName, STmp, sTmpPar, DataSetName, SVar1, SVar2,
    ParName, ParVal: string;
  // OutPutList: TStringList;
  TmpList, TmpList1: TStringDynArray;
  // QParam: TFDParam;
  Lb: TUniLabel;
  I, J, K, x: integer;
  bExec, bStartup, bJs: boolean;
begin
  DebugMsg('3290 ******************** BUILD QUERY =>' + XmlNd.Attributes['ID'] +
    '**********************');

  DebugMsg(XmlNd.Xml);
  bExec := False;
  // Cek apakah query execute?
  if not VarIsNull(XmlNd.Attributes['TYPE']) then
    if UpperCase(XmlNd.Attributes['TYPE']) = 'EXEC' then
      bExec := True;

  DebugMsg('3288 ambil script...');

  if XmlNd.nodeType = ntText then
    DebugMsg('3291 type:ntText');

  if XmlNd.nodeType = ntText then
    Script := XmlNd.NodeValue
  else
  begin
    DebugMsg(IntToStr(XmlNd.ChildNodes.Count));
    for I := 0 to XmlNd.ChildNodes.Count - 1 do
    begin
      if not VarIsNull(XmlNd.ChildNodes.Get(I).NodeValue) then
      begin
        DebugMsg(IntToStr(I) + ':' + XmlNd.ChildNodes.Get(I).NodeValue);
        Script := XmlNd.ChildNodes.Get(I).NodeValue;
      end
      else
        DebugMsg(IntToStr(I) + ':null');
      // if Trim(VarToStr(XmlNd.ChildNodes.Get(0).NodeValue)) <> '' then
      // Script := XmlNd.ChildNodes.Get(0).NodeValue;
    end;
  end;

  DataSetName := frName + '_' + XmlNd.Attributes['ID'];

  Mm := TUniMemo.Create(AOwner);
  Mm.Name := frName + '_' + XmlNd.Attributes['ID'] + '_VAR';
  for I := 0 to XmlNd.ChildNodes.Count - 1 do
  begin
    if XmlNd.ChildNodes[I].NodeName = 'Variable' then
    begin
      Mm.Lines.Add(XmlNd.ChildNodes[I].Xml);
    end;
  end;

  DebugMsg('MemoName:' + Mm.Name);
  DebugMsg('Content Variable:' + Mm.Lines.Text);

  DebugMsg('SCRIPT:' + Script);

  Script := StringReplace(Script, '{', '', [rfReplaceAll, rfIgnoreCase]);
  Script := StringReplace(Script, '}', '', [rfReplaceAll, rfIgnoreCase]);
  Script := StringReplace(Script, '= ', ':=', [rfReplaceAll, rfIgnoreCase]);
  Script := StringReplace(Script, 'call', '', [rfReplaceAll, rfIgnoreCase]);
  Script := StringReplace(Script, 'datos_prj.', '',
    [rfReplaceAll, rfIgnoreCase]);

  DebugMsg('Build Variable..');

  // ******* VARIABEL CHILD
  for I := 0 to XmlNd.ChildNodes.Count - 1 do
  begin
    if XmlNd.ChildNodes[I].NodeName = 'Variable' then
    begin
      DebugMsg('** Build Variable');
      BuildVariable(AOwner, XmlNd.ChildNodes[I], frName);
    end;
  end;

  DebugMsg('SCRIPT #1:' + Script);

  // HARDCODE
  if (UpperCase(DataSetName) = 'F01_QUGETAUFTRAG') then
  begin
    DebugMsg('3440 Package call [' + DataSetName + ']');

    // save parameters nama aslinya
    Lb := TUniLabel.Create(AOwner);
    Lb.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'] + '_SP';
    Lb.Caption := Script;
    Lb.Visible := False;

    bStartup := False;
    // Cek apakah query execute?
    if not VarIsNull(XmlNd.Attributes['STARTUP']) then
      if UpperCase(XmlNd.Attributes['STARTUP']) = 'Y' then
        bStartup := True;
    // PackageName
    TmpList := SplitString(SplitString(Script, '.')[0], ' ');
    PackageName := TmpList[length(TmpList) - 1];
    PackageName := 'datos_prj.' + PackageName;
    DebugMsg('3457 PackageName:' + PackageName);

    // StoredProcName
    TmpList := SplitString(SplitString(Script, '.')[1], ' ');
    StoredProcName := SplitString(TmpList[0], '(')[0];
    DebugMsg('3462 StoredProcName:' + StoredProcName);

    // param string
    if ContainsText(Script, '(') then
    begin
      TmpList := SplitString(Script, '(');
      sTmpPar := SplitString(TmpList[1], ')')[0];
      for I := 0 to length(TmpList) - 1 do
      begin
        DebugMsg('3471 TmpList[' + IntToStr(I) + ']:' + TmpList[I]);
      end;
    end
    else
      sTmpPar := '';

    DebugMsg('3477 sTmpPar:' + sTmpPar);

    FdSP := TFDStoredProc.Create(AOwner);
    FdSP.Connection := UniMainModule.FDConn;
    FdSP.PackageName := PackageName;
    FdSP.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];
    FdSP.StoredProcName := StoredProcName;
    FdSP.Prepare;

    for J := 0 to FdSP.Params.Count - 1 do
    begin
      DebugMsg('3490 Param[' + IntToStr(J) + '][' + FdSP.Params[J].Name + ']');
    end;

    TmpList := SplitString(sTmpPar, ',');
    for J := 0 to length(TmpList) - 1 do
    begin
      if ContainsText(TmpList[J], '=>') then
      begin
        TmpList1 := SplitString(Trim(TmpList[J]), '>');

        SVar1 := Trim(StringReplace(TmpList1[0], '=', '',
          [rfReplaceAll, rfIgnoreCase]));
        SVar2 := Trim(StringReplace(TmpList1[1], '=', '',
          [rfReplaceAll, rfIgnoreCase]));
        DebugMsg('3504 Val[' + SVar1 + '][' + SVar2 + ']');
        if UpperCase(Trim(SVar2)) <> 'NULL' then
          for K := 0 to FdSP.Params.Count - 1 do
          begin
            DebugMsg('3509 ' + UpperCase(Trim(FdSP.Params[K].Name)) + ' = ' +
              UpperCase(Trim(SVar1)));
            if UpperCase(Trim(FdSP.Params[K].Name)) = UpperCase(Trim(SVar1))
            then
            begin
              DebugMsg('3514 ' + FdSP.Params[K].Name + '=>' + SVar2);
              FdSP.Params[K].Value := SVar2;
            end;
          end;
      end;
    end;
    DebugMsg('3516 Final FdSP Name[' + FdSP.Name + ']');
    exit;
  end
  else if (DataSetName = 'foPrevalues_qGetOrder') then
  begin
    DebugMsg('3353 Package call.');

    // save parameters nama aslinya
    Lb := TUniLabel.Create(AOwner);
    Lb.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'] + '_SP';
    Lb.Caption := Script;
    Lb.Visible := False;

    bStartup := False;
    // Cek apakah query execute?
    if not VarIsNull(XmlNd.Attributes['STARTUP']) then
      if UpperCase(XmlNd.Attributes['STARTUP']) = 'Y' then
        bStartup := True;
    // PackageName
    TmpList := SplitString(SplitString(Script, '.')[0], ' ');
    PackageName := TmpList[length(TmpList) - 1];
    PackageName := 'datos_prj.' + PackageName;
    DebugMsg('3372 PackageName:' + PackageName);

    // StoredProcName
    TmpList := SplitString(SplitString(Script, '.')[1], ' ');
    StoredProcName := SplitString(TmpList[0], '(')[0];
    DebugMsg('3376 StoredProcName:' + StoredProcName);

    // param string
    if ContainsText(Script, '(') then
    begin
      TmpList := SplitString(Script, '(');
      sTmpPar := SplitString(TmpList[1], ')')[0];
      for I := 0 to length(TmpList) - 1 do
      begin
        DebugMsg('3385 TmpList[' + IntToStr(I) + ']:' + TmpList[I]);
      end;
    end
    else
      sTmpPar := '';

    DebugMsg('3391 sTmpPar:' + sTmpPar);

    FdSP := TFDStoredProc.Create(AOwner);
    FdSP.Name := 'foPrevalues_qGetOrder';
    FdSP.Connection := UniMainModule.FDConn;
    FdSP.PackageName := PackageName;
    FdSP.StoredProcName := StoredProcName;
    // FdSP.Name := DataSetName;
    FdSP.Prepare;

    // DebugMsg('3486 Final FdSP Name[' + FdSP.Name + ']');

    for J := 0 to FdSP.Params.Count - 1 do
    begin
      DebugMsg('3400 Param[' + IntToStr(J) + '][' + FdSP.Params[J].Name + ']');
    end;

    TmpList := SplitString(sTmpPar, ',');
    for J := 0 to length(TmpList) - 1 do
    begin
      if ContainsText(TmpList[J], '=>') then
      begin
        TmpList1 := SplitString(Trim(TmpList[J]), '>');

        SVar1 := Trim(StringReplace(TmpList1[0], '=', '',
          [rfReplaceAll, rfIgnoreCase]));
        SVar2 := Trim(StringReplace(TmpList1[1], '=', '',
          [rfReplaceAll, rfIgnoreCase]));
        DebugMsg('3413 Val[' + SVar1 + '][' + SVar2 + ']');
        // isi param value
        if UpperCase(Trim(SVar2)) <> 'NULL' then
          for K := 0 to FdSP.Params.Count - 1 do
          begin
            DebugMsg('3420 ' + UpperCase(Trim(FdSP.Params[K].Name)) + ' = ' +
              UpperCase(Trim(SVar1)));
            if UpperCase(Trim(FdSP.Params[K].Name)) = UpperCase(Trim(SVar1))
            then
            begin
              DebugMsg('3423 ' + FdSP.Params[K].Name + '=>' + SVar2);
              FdSP.Params[K].Value := SVar2;
            end;
          end;

      end;
    end;

    DebugMsg('3821 FdName [' + FdSP.Name + ']');
    exit;
  end
  else if ContainsText(UpperCase(Script), 'SELECT ') then
  begin
    DebugMsg('3353 SELECT statement.');
    FdQ := TFDQuery.Create(AOwner);
    if bExec then
      FdQ.Tag := 1;

    FdQ.AfterScroll := MainForm.FDSPAfterScroll;
    FdQ.AfterOpen := MainForm.FDSPAfterScroll;
    FdQ.Connection := UniMainModule.FDConn;
    FdQ.Name := frName + '_' + XmlNd.Attributes['ID'];

    // Script

    Script := StringReplace(Script, ':=', '=', [rfReplaceAll, rfIgnoreCase]);

    Script := StringReplace(Script, ':mandant',
      QuotedStr(Trim(UniApplication.Cookies.GetCookie('mandant'))),
      [rfReplaceAll, rfIgnoreCase]);

    Script := StringReplace(Script, ':ret', QuotedStr('0'),
      [rfReplaceAll, rfIgnoreCase]);

    Script := StringReplace(Script, ':Pa02', QuotedStr('0'),
      [rfReplaceAll, rfIgnoreCase]);

    Script := StringReplace(Script, ':Pa09', QuotedStr('0'),
      [rfReplaceAll, rfIgnoreCase]);

    FdQ.SQL.Text := Script;

    DebugMsg('SQL:' + FdQ.SQL.Text);

    // simpan di variabel
    Mm := TUniMemo.Create(AOwner);
    Mm.Name := FdQ.Name + '_SQLTEXT';
    Mm.Lines.Text := FdQ.SQL.Text;
    DebugMsg('Isi [' + Mm.Name + '] => [' + Mm.Lines.Text + ']');

    DebugMsg('3729 buat DS..');
    ds := TDataSource.Create(AOwner);
    ds.Name := 'DS_' + frName + '_' + XmlNd.Attributes['ID'];
    DebugMsg('3732 Create DS:' + ds.Name);
    ds.DataSet := FdQ;

    with FdQ do
      if ContainsText(SQL.Text, ':') then
      begin
        DebugMsg('706 ada parameters di SQL.');
        // Prepare;
        for J := 0 to Params.Count - 1 do
        begin
          DebugMsg('710 [' + IntToStr(J) + '][' + Params[J].Name + ']');
          ParName := GetCompByName(AOwner, Params[J].Name);
          ParVal := GetCompValue(AOwner, ParName);
          DebugMsg('729 [' + ParName + '][' + ParVal + ']');
          // Params[J].DataType := ftString;
          Params[J].Value := ParVal;
        end;
      end;

    FdQ.Open;

  end
  else if ContainsText(Script, '=>') then
  begin
    DebugMsg('SCRIPT #1 dengan =>:' + Script);

    FdQ := TFDQuery.Create(AOwner);
    if bExec then
      FdQ.Tag := 1;

    FdQ.AfterScroll := MainForm.FDSPAfterScroll;
    FdQ.Connection := UniMainModule.FDConn;
    with FdQ.SQL do
    begin
      Clear;
      Add('begin');
      Add('  ' + Script + ';');
      Add('end;');
    end;
    FdQ.Name := frName + '_' + XmlNd.Attributes['ID'];

    // get all parameter
    for I := 0 to FdQ.ParamCount - 1 do
    begin
      STmp := FdQ.Params[I].Name;
      for J := 0 to AOwner.ComponentCount - 1 do
        if AOwner.Components[J] is TUniLabel then
        begin
          // DebugMsg('Komponen[' + AOwner.Components[J].Name + '] cari [' + frName
          // + '_' + Trim(STmp) + ']');
          if UpperCase(AOwner.Components[J].Name)
            = UpperCase(frName + '_' + Trim(STmp)) then
          begin
            DebugMsg('3430 KETEMU ISI VALUE');
            Lb := TUniLabel(AOwner.Components[J]);
            DebugMsg('** ' + FdQ.Params[I].Name + ' => ' + Lb.Caption);
            FdQ.Params[I].Value := Lb.Caption;
          end;
        end;

    end;

    // simpan di variabel
    Mm := TUniMemo.Create(AOwner);
    Mm.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'] + '_SQLTEXT';
    Mm.Lines.Text := FdQ.SQL.Text;
    DebugMsg('Isi [' + Mm.Name + '] => [' + Mm.Lines.Text + ']');

    // ******* VARIABEL CHILD
    for I := 0 to XmlNd.ChildNodes.Count - 1 do
    begin
      if XmlNd.ChildNodes[I].NodeName = 'Variable' then
      begin
        // DebugMsg('** Build Variable');
        // BuildVariable(AOwner, XmlNd.ChildNodes[I], frName);
        // FdQ.ParamByName(UpperCase(XmlNd.ChildNodes[I].Attributes['ID']))
        // .AsDateTime := Now;
        //
        // // jika output buat label
        // if XmlNd.ChildNodes[I].Attributes['DIR'] = 'RETURN' then
        // begin
        // FdQ.ParamByName(UpperCase(XmlNd.ChildNodes[I].Attributes['ID']))
        // .ParamType := ptOutput;
        // Lb := TUniLabel.Create(AOwner);
        // Lb.Name := UpperCase(XmlNd.ChildNodes[I].Attributes['ID']);
        // Lb.Caption := '';
        // Lb.Visible := false;
        // end;
      end;
    end;
  end
  else if ContainsText(Script, '=') then
  begin
    DebugMsg('3464 Script dengan ada persamaan [=]');
    // ------------- query call -----------------

    FdQ := TFDQuery.Create(AOwner);
    if bExec then
      FdQ.Tag := 1;

    FdQ.AfterScroll := MainForm.FDSPAfterScroll;
    FdQ.Connection := UniMainModule.FDConn;
    with FdQ.SQL do
    begin
      Clear;
      // Add('begin');
      Script := 'select ' + StringReplace(SplitString(Script, '=')[1], ':', '',
        [rfReplaceAll, rfIgnoreCase]) + ' as ' +
        UpperCase(StringReplace(SplitString(Script, '=')[0], ':', '',
        [rfReplaceAll, rfIgnoreCase])) + ' from dual';
      Add(Script);
      // Add('end;');
    end;
    FdQ.Name := frName + '_' + XmlNd.Attributes['ID'];

    DebugMsg('3579 FdQ.Name [' + FdQ.Name + ']');

    DebugMsg(FdQ.SQL.Text);

    // simpan di variabel
    Mm := TUniMemo.Create(AOwner);
    Mm.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'] + '_SQLTEXT';
    Mm.Lines.Text := FdQ.SQL.Text;
    DebugMsg('Isi [' + Mm.Name + '] => [' + Mm.Lines.Text + ']');

    // for I := 0 to XmlNd.ChildNodes.Count - 1 do
    // begin
    // if XmlNd.ChildNodes[I].NodeName = 'Variable' then
    // begin
    // FdQ.ParamByName(UpperCase(XmlNd.ChildNodes[I].Attributes['ID']))
    // .AsDateTime := Now;

    // jika output buat label

    // BuildVariable(AOwner, XmlNd.ChildNodes[I], frName);

    // if XmlNd.ChildNodes[I].Attributes['DIR'] = 'RETURN' then
    // begin
    // FdQ.ParamByName(UpperCase(XmlNd.ChildNodes[I].Attributes['ID']))
    // .ParamType := ptOutput;
    // Lb := TUniLabel.Create(AOwner);
    // Lb.Name := UpperCase(XmlNd.ChildNodes[I].Attributes['ID']);
    // Lb.Caption := '';
    // Lb.Visible := false;
    // end;
    // end;
    // end;

  end
  else
  begin
    DebugMsg('Package call.');

    // save parameters nama aslinya
    Lb := TUniLabel.Create(AOwner);
    Lb.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'] + '_SQLTEXT';
    Lb.Caption := Script;

    Lb.Visible := False;
    DebugMsg('** simpan script ke:' + Lb.Name);

    bStartup := False;
    // Cek apakah query execute?
    if not VarIsNull(XmlNd.Attributes['STARTUP']) then
      if UpperCase(XmlNd.Attributes['STARTUP']) = 'Y' then
        bStartup := True;
    // -------- package call ---
    // PackageName
    TmpList := SplitString(SplitString(Script, '.')[0], ' ');
    PackageName := TmpList[length(TmpList) - 1];
    PackageName := 'datos_prj.' + PackageName;

    DebugMsg('PackageName:' + PackageName);

    // StoredProcName
    TmpList := SplitString(SplitString(Script, '.')[1], ' ');
    StoredProcName := SplitString(TmpList[0], '(')[0];

    DebugMsg('StoredProcName:' + StoredProcName);

    // param string
    if ContainsText(Script, '(') then
    begin
      TmpList := SplitString(Script, '(');
      sTmpPar := SplitString(TmpList[1], ')')[0];
      for I := 0 to length(TmpList) - 1 do
      begin
        // DebugMsg('TmpList[' + IntToStr(I) + ']:' + TmpList[I]);
      end;
    end
    else
      sTmpPar := '';

    DebugMsg('sTmpPar:' + sTmpPar);

    if (Pos('(', Script) = 0) or (sTmpPar = '') then
    begin
      // tidak punya parameter
      DebugMsg('Tidak ada parameter.');
      // koneksi
      ds := TDataSource.Create(AOwner);
      ds.Name := 'DS_' + frName + '_' + XmlNd.Attributes['ID'];

      // scroll
      // ds.OnDataChange := DSDataChange(AOwn);

      FdSP := TFDStoredProc.Create(AOwner);

      if bExec then
      begin
        FdSP.Tag := 1;
        FdC := TFDCommand.Create(AOwner);
        FdC.Name := frName + '_' + XmlNd.Attributes['ID'] + '_SQLTEXT';
        FdC.Connection := UniMainModule.FDConn;
        FdC.CommandText.Text := Script;
      end;

      FdSP.AfterScroll := MainForm.FDSPAfterScroll;
      FdSP.Name := frName + '_' + XmlNd.Attributes['ID'];
      FdSP.Connection := UniMainModule.FDConn;
      ds.DataSet := FdSP;
      FdSP.PackageName := PackageName;
      FdSP.StoredProcName := StoredProcName;

      // scroll
      FdSP.AfterScroll := MainForm.FDSPAfterScroll;

      // FdSP := FdSP.DataSource.DataSet;

      FdSP.Prepare;
      FdSP.Open();
      exit;
    end;

    // cek
    if Pos(',', sTmpPar) = 0 then
    begin
      DebugMsg('Satu param saja.');
      // satu param saja
      STmp := StringReplace(sTmpPar, '&apos;', '',
        [rfReplaceAll, rfIgnoreCase]);
      STmp := StringReplace(sTmpPar, '''', '', [rfReplaceAll, rfIgnoreCase]);

      DebugMsg('STmp:' + STmp);

      // koneksi
      ds := TDataSource.Create(AOwner);
      ds.Name := 'DS_' + frName + '_' + XmlNd.Attributes['ID'];
      DebugMsg('Ds.Name:' + ds.Name);
      FdSP := TFDStoredProc.Create(AOwner);
      if bExec then
      begin
        FdSP.Tag := 1;
        FdC := TFDCommand.Create(AOwner);
        FdC.Name := frName + '_' + XmlNd.Attributes['ID'] + '_EXEC';
        FdC.Connection := UniMainModule.FDConn;
        FdC.CommandText.Text := Script;
      end;

      FdSP.AfterScroll := MainForm.FDSPAfterScroll;
      FdSP.Name := frName + '_' + XmlNd.Attributes['ID'];
      DebugMsg('FdSP.Name:' + FdSP.Name);
      FdSP.Connection := UniMainModule.FDConn;
      ds.DataSet := FdSP;
      FdSP.PackageName := PackageName;
      DebugMsg('PackageName:' + PackageName);
      FdSP.StoredProcName := StoredProcName;
      DebugMsg('StoredProcName:' + StoredProcName);

      // cek dulu exec atau tidak

      bExec := False;
      if not VarIsNull(XmlNd.Attributes['TYPE']) then
        if UpperCase(XmlNd.Attributes['TYPE']) = 'EXEC' then
          bExec := True;

      // cek param vs value
      DebugMsg('FdSP.StoredProcName:' + FdSP.StoredProcName);
      DebugMsg('FdSP.PackageName:' + FdSP.PackageName);
      for I := 0 to FdSP.ParamCount - 1 do
      begin
        DebugMsg('Param Name:' + FdSP.Params[I].Name);
        DebugMsg('Param Value:' + VarToStr(FdSP.Params[I].Value));
      end;

      DebugMsg('bExec:' + BoolToStr(bExec));

      if not bExec then
      begin
        FdSP.Prepare;
        STmp := Trim(STmp);
        FdSP.Params[1].Value := STmp;

        // cari nilai
        DebugMsg('Cari nilai variable...');
        if LeftStr(STmp, 1) = ':' then
        begin
          STmp := StringReplace(STmp, ':', '', [rfReplaceAll, rfIgnoreCase]);
          for J := 0 to AOwner.ComponentCount - 1 do
            if AOwner.Components[J] is TUniLabel then
            begin
              DebugMsg('3360 Komponen[' + AOwner.Components[J].Name + '] cari ['
                + frName + '_' + Trim(STmp) + ']');
              if UpperCase(AOwner.Components[J].Name)
                = UpperCase(frName + '_' + Trim(STmp)) then
              begin
                Lb := TUniLabel(AOwner.Components[J]);
                FdSP.Params[1].Value := Lb.Caption;
              end;
            end;
        end;
        if bStartup then
          FdSP.Open();
      end;
    end
    else
    begin
      // lebih dari satu param
      DebugMsg('Param lebih dari 1');
      STmp := StringReplace(sTmpPar, '&apos;', '',
        [rfReplaceAll, rfIgnoreCase]);
      DebugMsg('Replace &apos; :' + STmp);
      STmp := StringReplace(sTmpPar, '''', '', [rfReplaceAll, rfIgnoreCase]);
      DebugMsg('Replace kutip :' + STmp);
      TmpList := SplitString(STmp, ',');

      DebugMsg('length(TmpList):' + IntToStr(length(TmpList)));
      for I := 0 to length(TmpList) - 1 do
      begin
        // DebugMsg('TmpList[' + IntToStr(I) + ']:' + TmpList[I]);
      end;

      // koneksi
      DebugMsg('Create koneksi database..');
      DebugMsg('buat DS..');
      ds := TDataSource.Create(AOwner);
      ds.Name := 'DS_' + frName + '_' + XmlNd.Attributes['ID'];
      DebugMsg('Create DS:' + ds.Name);
      FdSP := TFDStoredProc.Create(AOwner);
      if bExec then
      begin
        FdSP.Tag := 1;
        FdC := TFDCommand.Create(AOwner);
        FdC.Name := frName + '_' + XmlNd.Attributes['ID'] + '_EXEC';
        FdC.Connection := UniMainModule.FDConn;
        FdC.CommandText.Text := Script;
      end;

      FdSP.AfterScroll := MainForm.FDSPAfterScroll;
      FdSP.Name := frName + '_' + XmlNd.Attributes['ID'];
      DebugMsg('3993 Create SP:' + FdSP.Name);
      FdSP.Connection := UniMainModule.FDConn;
      ds.DataSet := FdSP;
      FdSP.PackageName := PackageName;
      FdSP.StoredProcName := StoredProcName;
      DebugMsg('3998 FdSP PackageName:' + FdSP.PackageName);
      DebugMsg('3999 FdSP StoredProcName:' + FdSP.StoredProcName);

      if not bExec then
      begin

        FdSP.Prepare;
        DebugMsg('4005 FdSP prepared.');
        DebugMsg('4006 Isi value Parameter...');
        DebugMsg('4007 Length FdSP.Params:' + IntToStr(FdSP.ParamCount));
        for I := 0 to FdSP.ParamCount - 1 do
        begin
          // DebugMsg('Param [' + IntToStr(I) + ']:' + FdSP.Params[I].Name)
        end;

        for I := 0 to length(TmpList) - 1 do
        begin
          if Trim(TmpList[I]) = ':mandant' then
          begin
            FdSP.Params[I + 1].Value :=
              Trim(UniApplication.Cookies.GetCookie('mandant'));
          end
          else if Trim(TmpList[I]) = ':user' then
          begin
            FdSP.Params[I + 1].Value :=
              Trim(UniApplication.Cookies.GetCookie('UserName'));
          end
          else if LeftStr(Trim(TmpList[I]), 1) = ':' then
          begin
            STmp := StringReplace(Trim(TmpList[I]), ':', '',
              [rfReplaceAll, rfIgnoreCase]);
            DebugMsg('4249 STmp:' + STmp);
            for J := 0 to AOwner.ComponentCount - 1 do
              if AOwner.Components[J] is TUniLabel then
              begin
                if AOwner.Components[J].Name = frName + '_' + Trim(STmp) then
                begin
                  Lb := TUniLabel(AOwner.Components[J]);
                  DebugMsg('4256 VALUE :' + Lb.Caption);

                  if FdSP.ParamCount > length(TmpList) then
                    x := I + 1
                  else
                    x := I;

                  case FdSP.Params[x].DataType of
                    ftString:
                      DebugMsg(FdSP.Params[x].Name + ' is a string field');
                    ftInteger:
                      DebugMsg(FdSP.Params[x].Name + ' is an integer field');
                    ftFloat:
                      DebugMsg(FdSP.Params[x].Name + ' is a float field');
                    ftDate:
                      DebugMsg(FdSP.Params[x].Name + ' is a date field');
                    ftBoolean:
                      DebugMsg(FdSP.Params[x].Name + ' is a boolean field');
                    ftCurrency:
                      DebugMsg(FdSP.Params[x].Name + ' is a currency field');
                  else
                    DebugMsg('unknown.');

                  end;

                  // if FdSP.ParamCount > length(TmpList) then
                  // begin
                  // if (FdSP.Params[I + 1].DataType = ftDate) and
                  // (Lb.Caption = '') then
                  // begin
                  // DebugMsg('File Type: DATE');
                  // FdSP.Params[I + 1].Value := Now;
                  // end
                  // else
                  // FdSP.Params[I + 1].Value := Lb.Caption;
                  //
                  // if (FdSP.Params[I + 1].DataType = ftCurrency) and
                  // (Lb.Caption = '') then
                  // begin
                  // DebugMsg('File Type: Currency');
                  // FdSP.Params[I + 1].Value := null;
                  // end
                  // else
                  // FdSP.Params[I + 1].Value := Lb.Caption;
                  // end
                  // else
                  // begin

                  if (FdSP.Params[x].DataType = ftDate) and (Lb.Caption = '')
                  then
                    FdSP.Params[x].Value := Now
                  else if Lb.Caption <> '' then
                    FdSP.Params[x].Value := Lb.Caption;
                  // end;
                end;
              end;
          end
          else if UpperCase(Trim(TmpList[I])) <> 'NULL' then
          begin
            if FdSP.ParamCount > length(TmpList) then
              FdSP.Params[I + 1].Value := Trim(TmpList[I])
            else
              FdSP.Params[I].Value := Trim(TmpList[I])
          end;
        end;

        // CEK default Value

        CekSPParamDefVal(AOwner, FdSP);

        //
        // DebugMsg('Checking Param and Value...');
        // for I := 0 to FdSP.ParamCount - 1 do
        // begin
        // // setup Output Param
        // try
        // DebugMsg(FdSP.Params[I].Name + ' => ' +
        // VarToStr(FdSP.Params[I].Value));
        // except
        // DebugMsg('Error');
        // end;
        // // DebugMsg(FdSP.Params[I].Name);
        //
        // // if (FdSP.Params[I].DataType = ftDate) and
        // // (VarToStr(FdSP.Params[I].Value) = '') then
        // // FdSP.Params[I].Value := Now;
        // if FdSP.Params[I].ParamType = ptOutput then
        // DebugMsg('Output');
        // end;

        // cek if open query
        bJs := False;
        if not VarIsNull(XmlNd.Attributes['JS']) then
          if UpperCase(XmlNd.Attributes['JS']) = 'Y' then
            bJs := True;

        DebugMsg('4287 FdSP.Name[' + FdSP.Name + ']');

        if (not bJs) then
        begin
          // HARDCODE
          if (FdSP.Name <> 'fr62342_QBARCODEPRINT') and
            (FdSP.Name <> 'fr62342_QAuftSuch') then
          begin
            FdSP.Open();
            DebugMsg('46361 Open Query..[' + IntToStr(FdSP.RecordCount) + ']');
          end;
        end;
      end;
      // if not bExec then

    end;
  end;
  DebugMsg('********* QUERY END ****************');
end;

// COMBO
function BuildCombo(AOwner: TComponent; XmlNd: IXMLNode): TUniComboBox;
var
  Cb: TUniComboBox;
  CutOff, I: integer;
  // TmpDs: TDataSource;
  SListItem: String;
  TmpStr: TStringDynArray;
begin
  CutOff := 80;

  if length(XmlNd.Attributes['CAPTION']) <= 5 then
    CutOff := 30;

  if length(XmlNd.Attributes['CAPTION']) > 10 then
    CutOff := 90;

  Cb := TUniComboBox.Create(AOwner);
  Cb.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];
  Cb.FieldLabel := XmlNd.Attributes['CAPTION'];
  Cb.FieldLabelWidth := CutOff;
  Cb.FieldLabelAlign := laRight;
  if not VarIsNull(XmlNd.Attributes['TOP']) then
    Cb.Top := XmlNd.Attributes['TOP'];
  if not VarIsNull(XmlNd.Attributes['LEFT']) then
    Cb.left := StrToInt(XmlNd.Attributes['LEFT']) - CutOff;
  if not VarIsNull(XmlNd.Attributes['WIDTH']) then
    Cb.Width := StrToInt(XmlNd.Attributes['WIDTH']) + CutOff - 10;
  if not VarIsNull(XmlNd.Attributes['ALIGNMENT']) then
    if XmlNd.Attributes['ALIGNMENT'] = 'Left' then
      Cb.Alignment := taLeftJustify;
  if XmlNd.Attributes['ALIGNMENT'] = 'Right' then
    Cb.Alignment := taRightJustify;
  if not VarIsNull(XmlNd.Attributes['ENABLE']) then
  begin
    if XmlNd.Attributes['ENABLE'] = 'Y' then
      Cb.Enabled := True
    Else
      Cb.Enabled := False;
  end;

  SListItem := XmlNd.NodeValue;

  TmpStr := SplitString(SListItem, ';');

  for I := 0 to length(TmpStr) - 1 do
  begin
    Cb.Items.Add(SplitString(TmpStr[I], ',')[0]);
  end;

  Result := Cb;

end;

procedure BuildPopUpMenu(AOwner: TComponent; XmlNd: IXMLNode; Gr: TUniDBGrid);
var
  PopMenu: TUniPopupMenu;
  Item: TUniMenuItem;
  I: integer;
  LinkId: string;
  Lb: TUniLabel;
begin
  DebugMsg('********* BUILD GRID POPUP MENU****************');
  PopMenu := TUniPopupMenu.Create(AOwner);
  PopMenu.Name := Gr.Name + '_POPUP';
  DebugMsg('**Name:' + PopMenu.Name);
  DebugMsg('4335 XML Str[' + XmlNd.Xml + ']');
  LinkId := '';
  if not VarIsNull(XmlNd.Attributes['LINKID']) then
    LinkId := XmlNd.Attributes['LINKID'];
  DebugMsg('4338 **LinkId:' + LinkId);

  for I := 0 to XmlNd.ChildNodes.Count - 1 do
  begin
    if XmlNd.ChildNodes[I].NodeName = 'MenuItemEx' then
    begin
      Item := TUniMenuItem.Create(PopMenu);
      if not VarIsNull(XmlNd.ChildNodes[I].Attributes['NLS_INAME']) then
      begin
        // Item.Name := GetOwnerName(AOwner) + '_' +
        // SplitString(XmlNd.ChildNodes[I].Attributes['NLS_INAME'], '.')[1];

        if not VarIsNull(XmlNd.ChildNodes[I].Attributes['ID']) then
          Item.Name := GetOwnerName(AOwner) + '_' + XmlNd.ChildNodes[I]
            .Attributes['ID']
        else
          Item.Name := GetOwnerName(AOwner) + '_' +
            SplitString(XmlNd.ChildNodes[I].Attributes['NLS_INAME'], '.')[1];

        Lb := TUniLabel.Create(AOwner);
        Lb.Name := Item.Name + '_ACTION';

        if not VarIsNull(XmlNd.ChildNodes[I].Attributes['ONCLICK']) then
          Lb.Caption := 'ONCLICK:' + XmlNd.ChildNodes[I].Attributes['ONCLICK'];

        if not VarIsNull(XmlNd.ChildNodes[I].Attributes['LINKID']) then
          Lb.Caption := Lb.Caption + '|LINKID:' + XmlNd.ChildNodes[I].Attributes
            ['LINKID'];

        Lb.Visible := False;

      end;
      if not VarIsNull(XmlNd.ChildNodes[I].Attributes['INAME']) then
        Item.Caption := XmlNd.ChildNodes[I].Attributes['INAME'];

      DebugMsg('4367 Item.Caption [' + Item.Caption + ']');

      Item.OnClick := MainForm.PopUpMenuClick;
      PopMenu.Items.Add(Item);
    end;

  end;

  // tambahkan system default
  Item := TUniMenuItem.Create(PopMenu);
  Item.Caption := '-';
  PopMenu.Items.Add(Item);

  Item := TUniMenuItem.Create(PopMenu);
  Item.Caption := 'Reload table';
  Item.Name := Gr.Name + '_RELOAD';
  Item.OnClick := MainForm.ReloadTableClick;
  PopMenu.Items.Add(Item);

  Item := TUniMenuItem.Create(PopMenu);
  Item.Caption := 'Properties';
  Item.Name := Gr.Name + '_PROPERTIES';
  Item.OnClick := MainForm.PropertiesTableClick;
  PopMenu.Items.Add(Item);

  Gr.ClientEvents.ExtEvents.Values['afterrender'] :=
    'function afterrender(sender, eOpts) { sender.getEl().dom.addEventListener( '
    + '' + QuotedStr('mousedown') + ',' + 'function(e) {' +
    '   if (e.button == 2) {  ajaxRequest(MainForm.form, ' +
    QuotedStr('_contextmenu') + ', [' + QuotedStr('x=') + ' + e.offsetX, ' +
    QuotedStr('y=') + ' + e.offsetY,' + QuotedStr('Pop=' + PopMenu.Name) + ',' +
    QuotedStr('grid=' + Gr.Name) + ',' + QuotedStr('linkid=' + LinkId) +
    ']);    } ' + '} ' + ') }';

  DebugMsg('afterrender:[' + Gr.ClientEvents.ExtEvents.Values
    ['afterrender'] + ']');

end;

// DB GRID
function BuildDBGrid(AOwner: TComponent; XmlNd: IXMLNode): TUniDBGrid;
var
  Gr: TUniDBGrid;
  // Cl: TUniBaseDBGridColumn;
  I, J: integer;
  TmpDs: TDataSource;
  BColFound: boolean;
  FromName, SVar1, SVar2: String;
  Mm, Mm2: TUniMemo;
begin

  DebugMsg('********* BUILD GRID ****************');
  Gr := TUniDBGrid.Create(AOwner);
  Gr.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];
  DebugMsg('**Name:' + Gr.Name);
  Gr.WebOptions.Paged := False;
  if not VarIsNull(XmlNd.Attributes['ALIGN']) then
  begin
    if UpperCase(XmlNd.Attributes['ALIGN']) = 'CLIENT' then
      Gr.Align := alClient
    else if UpperCase(XmlNd.Attributes['ALIGN']) = 'LEFT' then
      Gr.Align := alLeft
    else
      Gr.Align := alNone
  end;

  // Setup default value

  Gr.Options := [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines,
    dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgAutoRefreshRow,
    dgColumnMove];

  Gr.WebOptions.FetchAll := True;

  Gr.WebOptions.Paged := False;

  Gr.OnColumnResize := MainForm.GrdColumnResize;

  Gr.OnColumnMove := MainForm.GridColumnMove;

  Mm := TUniMemo.Create(AOwner);
  Mm.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'] + '_COLUMN';
  for I := 0 to XmlNd.ChildNodes.Count - 1 do
  begin
    if XmlNd.ChildNodes[I].NodeName = 'Column' then
    begin
      Mm.Lines.Add(XmlNd.ChildNodes[I].Xml);
    end;
  end;
  DebugMsg('4574 build COLUMN [' + Mm.Name + '][' + Mm.Lines.Text + ']');

  Mm2 := TUniMemo.Create(AOwner);
  Mm2.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'] + '_KEYFIELD';

  if not VarIsNull(XmlNd.Attributes['KEYFIELD']) then
  begin
    Mm2.Lines.Add(UpperCase(XmlNd.Attributes['KEYFIELD']));
  end;

  // if not VarIsNull(XmlNd.Attributes['ONDBLCLICK']) then
  // Gr.ClientEvents.ExtEvents.Values['celldblclick'] :=
  // ' function celldblclick(sender, e, eOpts){  ajaxRequest(' + AOwner.Name +
  // '.form, "_celldblclick" , ["script=' + XmlNd.Attributes['ONDBLCLICK']
  // + '"]); }';

  // if not VarIsNull(XmlNd.Attributes['ONKEYENTER']) then
  // Gr.ClientEvents.ExtEvents.Values['keypress'] :=
  // ' function keypress(e, t, eOpts) { if (e.getKey() == 13 ) {  ajaxRequest('
  // + AOwner.Name + '.form, "_celldblclick" , ["script=' + XmlNd.Attributes
  // ['ONKEYENTER'] + '"]);   } } ';

  if not VarIsNull(XmlNd.Attributes['ONKEYENTER']) then
    Gr.OnKeyDown := MainForm.DBGridKeyDownEnter;

  FromName := AOwner.Name;

  if UpperCase(AOwner.Name) = 'MAINFORM' then
  begin
    FromName := MainForm.ActiveFormName;
  end;

  DebugMsg('4589 Cari Data Source...');
  DebugMsg('1590 Form name: ' + AOwner.Name + sLineBreak + 'Sender name: ' +
    TUniDBLookupComboBox(AOwner).Name);

  for I := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[I] is TDataSource then
    begin
      TmpDs := TDataSource(AOwner.Components[I]);
      // DebugMsg('TmpDs.Name:' + TmpDs.Name);
      // DebugMsg('Compare -> ' + UpperCase(TmpDs.Name) + '=' + 'DS_' +
      // UpperCase(FromName) + '_' + UpperCase(XmlNd.Attributes['LINKID']));
      if UpperCase(TmpDs.Name) = 'DS_' + UpperCase(FromName) + '_' +
        UpperCase(XmlNd.Attributes['LINKID']) then
      begin
        DebugMsg('4610 KETEMU [' + TmpDs.Name + ']');
        Gr.DataSource := TmpDs;
        break;
      end;
    end;

  // define column
  for I := 0 to Gr.Columns.Count - 1 do
  begin
    DebugMsg('4611 Cek column [' + Gr.Columns[I].FieldName + ']');
    Gr.Columns[I].Visible := False;
    Gr.Columns[I].Menu.MenuEnabled := False;

    BColFound := False;

    for J := 0 to XmlNd.ChildNodes.Count - 1 do
    begin
      // Column
      if XmlNd.ChildNodes[J].NodeName = 'Column' then
      begin
        // DebugMsg('4621 ' + UpperCase(XmlNd.ChildNodes[J].Attributes['NAME']) +
        // ' = ' + Gr.Columns[I].FieldName);
        if UpperCase(XmlNd.ChildNodes[J].Attributes['NAME']) = Gr.Columns[I].FieldName
        then
        begin
          DebugMsg('4645 ***** Ketemu Kolumn');
          BColFound := True;
          try
            if not VarIsNull(XmlNd.ChildNodes[J].Attributes['CAPTION']) then
              Gr.Columns[I].Title.Caption := XmlNd.ChildNodes[J].Attributes
                ['CAPTION'];

            Gr.Columns[I].Visible := False;
            if not VarIsNull(XmlNd.ChildNodes[J].Attributes['VISIBLE']) then
              if XmlNd.ChildNodes[J].Attributes['VISIBLE'] = 'Y' then
                Gr.Columns[I].Visible := True
              else
                Gr.Columns[I].Visible := False;

            if not VarIsNull(XmlNd.ChildNodes[J].Attributes['WIDTH']) then
              Gr.Columns[I].Width :=
                StrToInt(XmlNd.ChildNodes[J].Attributes['WIDTH']);

            if not VarIsNull(XmlNd.ChildNodes[J].Attributes['COMMENTCOLUMN'])
            then
              Gr.Columns[I].DisplayMemo := True;

          except
            on E: Exception do
              DebugMsg('Warning - kesalahan seting colum properti [' +
                E.Message + ']');
          end;
        end;
      end;
    end;
    if not BColFound then
      Gr.Columns[I].Visible := False;
  end;

  // sorting column

  // HARCODE:
  // Display harcode column
  if Gr.Name = 'fr5120_PopHistory_GR1' then
  begin
    for I := 0 to Gr.Columns.Count - 1 do
    begin
      if MatchStr(Gr.Columns[I].FieldName, ['KONTRDATE', 'KONTRUSER',
        'AKTIONS_TEXT']) then
      begin
        Gr.Columns[I].Visible := True;
        if Gr.Columns[I].FieldName = 'KONTRDATE' then
          Gr.Columns[I].Width := 130;
        if Gr.Columns[I].FieldName = 'AKTIONS_TEXT' then
          Gr.Columns[I].Width := 395;
      end;
    end;
  end;

  DebugMsg('4652 Context Menu...');

  // Context Menu
  for J := 0 to XmlNd.ChildNodes.Count - 1 do
  begin
    if XmlNd.ChildNodes[J].NodeName = 'MenuEx' then
    begin
      BuildPopUpMenu(AOwner, XmlNd.ChildNodes[J], Gr);
    end;
  end;

  Gr.Visible := True;

  // Tool tips
  // HARCODE
  if Gr.Name = 'fr5120_grAnalytComments' then
  begin
    Gr.ClientEvents.ExtEvents.Values['viewready'] :=
      'function viewready(sender, eOpts) { ' +
      '   var tm = new Ext.util.TextMetrics();' +
      '   sender.view.tip = Ext.create("Ext.tip.ToolTip", {' +
      '       target: sender.view.el,' +
      '       delegate: sender.view.cellSelector,' + '       trackMouse: true,'
      + '       renderTo: Ext.getBody(), ' + '       listeners: {' +
      '           beforeshow: function updateTipBody(tip) {' +
      '               gridColums = sender.view.getGridColumns();' +
      '               column = gridColums[tip.triggerElement.cellIndex]; ' +
      '               record = sender.view.getRecord(tip.triggerElement.parentNode); '
      + ' if(column.dataIndex == "6"){ tip.update(record.data[parseInt(column.dataIndex)]); } else { return false; }'
      +
    // + 'tip.update(column.dataIndex);' +
      '           }' + '       }' + '   });' + ' }';
  end;

  if Gr.Name = 'fr5120_grResult' then
  begin
    // Gr.ClientEvents.ExtEvents.Values['viewready'] :=
    // 'function viewready(sender, eOpts) { ' +
    // '   var tm = new Ext.util.TextMetrics();' +
    // '   sender.view.tip = Ext.create("Ext.tip.ToolTip", {' +
    // '       target: sender.view.el,' +
    // '       delegate: sender.view.cellSelector,' + '       trackMouse: true,'
    // + '       renderTo: Ext.getBody(), ' + '       listeners: {' +
    // '           beforeshow: function updateTipBody(tip) {' +
    // '               gridColums = sender.view.getGridColumns();' +
    // '               column = gridColums[tip.triggerElement.cellIndex]; ' +
    // '               record = sender.view.getRecord(tip.triggerElement.parentNode); '
    // // + ' if(column.dataIndex == "77"){ tip.update(record.data[parseInt("78")]); } else { return false; }'
    // // +
    // + 'tip.update(record.get(78));' + '           }' + '       }' +
    // '   });' + ' }';

    // SVar1 :=;

    // Gr.ClientEvents.ExtEvents.Values['store.load'] :=
    // 'function store.load(sender, records, successful, operation, eOpts) ' +
    // '{ ' + 'sender.grid.getColumns()[' + GetGridColRegVal(Gr,
    // 'HASREFRANGEINFORMATION', 'Index') +
    // '].renderer = function (value,metadata,record) { ' + 'metadata.tdAttr = '
    // + QuotedStr('data-qclass="dvQtip" data-qtip="') + '+record.get(' +
    // GetGridColRegVal(Gr, 'REF_RANGE_INFORMATION', 'Index') + ')+' +
    // QuotedStr('"') + '; ' +
    // 'return new Ext.ux.CheckColumn().renderer(value);} ' +
    //
    // ' }';

    Gr.ClientEvents.ExtEvents.Values['store.load'] :=
      'function store.load(sender, records, successful, operation, eOpts) ' +
      '{ ' + 'sender.grid.getColumns()[' + GetGridColRegVal(Gr,
      'HASREFRANGEINFORMATION', 'Index') +
      '].renderer = function (value,metadata,record) { ' + 'metadata.tdAttr = '
      + QuotedStr('data-qclass="dvQtip" data-qtip="') + '+record.get(' +
      GetGridColRegVal(Gr, 'REF_RANGE_INFORMATION', 'Index') + ')+' +
      QuotedStr('"') + '; ' +
      'return new Ext.ux.CheckColumn().renderer(value);} ' +
      '; sender.grid.getColumns()[' + GetGridColRegVal(Gr, 'KOMMENTAR', 'Index')
      + '].renderer = function (value,metadata,record) { ' +
      'metadata.tdAttr = ' + QuotedStr('data-qclass="dvQtip" data-qtip="') +
      '+record.get(' + GetGridColRegVal(Gr, 'COMMENTHINT', 'Index') + ')+' +
      QuotedStr('"') + '; ' +
      'return new Ext.ux.CheckColumn().renderer(value);} ' +

      ' }';
  end;


  // Color grid

  Gr.OnDrawColumnCell := MainForm.GridDrawColumnCell;

  // rebuild grid column
  // RebuildColumnGrid(AOwner, Gr);

  Result := Gr;
end;

// CHECKBOX
function BuildCheck(AOwner: TComponent; XmlNd: IXMLNode): TUniCheckBox;
var
  Cb: TUniCheckBox;
  CutOff: integer;
begin
  // CutOff := 120;
  CutOff := 0;
  if not VarIsNull(XmlNd.Attributes['CAPTION']) then
    if XmlNd.Attributes['CAPTION'] <> '' then
      if length(XmlNd.Attributes['CAPTION']) > 20 then
        CutOff := 180
      else
        CutOff := 90;

  Cb := TUniCheckBox.Create(AOwner);
  Cb.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];
  if not VarIsNull(XmlNd.Attributes['LABEL']) then
    Cb.Caption := XmlNd.Attributes['LABEL'];

  if not VarIsNull(XmlNd.Attributes['TOP']) then
    Cb.Top := XmlNd.Attributes['TOP'];
  if not VarIsNull(XmlNd.Attributes['LEFT']) then
    Cb.left := StrToInt(XmlNd.Attributes['LEFT']);
  if not VarIsNull(XmlNd.Attributes['WIDTH']) then
    Cb.Width := StrToInt(XmlNd.Attributes['WIDTH']);

  if not VarIsNull(XmlNd.Attributes['CAPTION']) then
  begin
    Cb.FieldLabel := XmlNd.Attributes['CAPTION'];
    Cb.FieldLabelWidth := CutOff;
    Cb.FieldLabelAlign := laRight;
    Cb.left := Cb.left - CutOff;
  end;

  if not VarIsNull(XmlNd.Attributes['ENABLE']) then
  begin
    if XmlNd.Attributes['ENABLE'] = 'Y' then
      Cb.Enabled := True
    Else
      Cb.Enabled := False;
  end;

  if not VarIsNull(XmlNd.Attributes['VISIBLE']) then
    if XmlNd.Attributes['VISIBLE'] = 'N' then
    begin
      DebugMsg('CheckBox visible=False');
      Cb.Visible := False;
    end;

  Result := Cb;
end;

// BUTTON
function BuildButton(AOwner: TComponent; XmlNd: IXMLNode): TUniButton;
var
  Bt: TUniButton;
  Mm: TUniMemo;
begin
  Bt := TUniButton.Create(AOwner);

  if not VarIsNull(XmlNd.Attributes['ID']) then
  begin
    DebugMsg('4185 ************ BUTTON [' + XmlNd.Attributes['ID'] +
      '] ****************');
    Bt.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];
  end
  else
  begin
    if MainForm.FNameIndex < MainForm.FNameList.Count then
    begin
      Bt.Name := MainForm.FNameList.Strings[MainForm.FNameIndex];
      inc(MainForm.FNameIndex);
    end;
    DebugMsg('4190 ************ BUTTON Rand[' + Bt.Name + '] ****************');
  end;

  if not VarIsNull(XmlNd.Attributes['CAPTION']) then
    Bt.Caption := XmlNd.Attributes['CAPTION'];

  if not VarIsNull(XmlNd.Attributes['TOP']) then
    Bt.Top := XmlNd.Attributes['TOP'];

  if not VarIsNull(XmlNd.Attributes['LEFT']) then
    Bt.left := StrToInt(XmlNd.Attributes['LEFT']);

  if not VarIsNull(XmlNd.Attributes['WIDTH']) then
    Bt.Width := StrToInt(XmlNd.Attributes['WIDTH']);

  if not VarIsNull(XmlNd.Attributes['ALIGNMENT']) then
    if XmlNd.Attributes['ALIGNMENT'] = 'Left' then
      Bt.Alignment := taLeftJustify;

  if XmlNd.Attributes['ALIGNMENT'] = 'Right' then
    Bt.Alignment := taRightJustify;

  if not VarIsNull(XmlNd.Attributes['HINT']) then
  begin
    Bt.Hint := XmlNd.Attributes['HINT'];
    Bt.ShowHint := True;
  end;

  if not VarIsNull(XmlNd.Attributes['ENABLE']) then
  begin
    if XmlNd.Attributes['ENABLE'] = 'Y' then
      Bt.Enabled := True
    Else
      Bt.Enabled := False;
  end;

  Mm := TUniMemo.Create(AOwner);
  Mm.Name := Bt.Name + '_ONCLICK';

  if not VarIsNull(XmlNd.Attributes['ONCLICK']) then
  begin
    Mm.Lines.Text := XmlNd.Attributes['ONCLICK'];
    Bt.OnClick := MainForm.BtnOnClick;
  end;

  // if not VarIsNull(XmlNd.Attributes['ONCLICK']) then
  // if XmlNd.Attributes['ID'] = 'BOK' then
  // begin
  // DebugMsg('XXXID is BOK');
  // Bt.ClientEvents.ExtEvents.Values['click'] :=
  // ' function click(sender, e, eOpts){  ajaxRequest(MainForm.form, "_popok" , []);ajaxRequest('
  // + AOwner.Name + '.form, "_buttonclick" , ["script=' + XmlNd.Attributes
  // ['ONCLICK'] + '"]); }'
  // end
  // else
  // Bt.ClientEvents.ExtEvents.Values['click'] :=
  // ' function click(sender, e, eOpts){  ajaxRequest(' + AOwner.Name +
  // '.form, "_buttonclick" , ["script=' + XmlNd.Attributes['ONCLICK']
  // + '"]); }';

  // if (Bt.Name = 'buNew') or (Bt.Name = 'buPatient') then
  // begin
  // Bt.ClientEvents.ExtEvents.Values['click'] :=
  // 'function click(sender, e, eOpts){  ajaxRequest(MainForm.form, ' +
  // QuotedStr('_buttonclick') + ', [' +
  // QuotedStr('script=' + XmlNd.Attributes['ONCLICK']) + ']); }';
  // Bt.ClientEvents.Enabled := True;
  // end;

  Result := Bt;
end;

// LOOKUP
function BuildLookup(AOwner: TComponent; XmlNd: IXMLNode): TUniDBLookupComboBox;
var
  Lcb: TUniDBLookupComboBox;
  CutOff, I: integer;
  TmpDs: TDataSource;
begin
  CutOff := 80;

  if length(XmlNd.Attributes['CAPTION']) <= 5 then
    CutOff := 30;

  if length(XmlNd.Attributes['CAPTION']) > 10 then
    CutOff := 90;

  Lcb := TUniDBLookupComboBox.Create(AOwner);
  Lcb.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];
  Lcb.Caption := XmlNd.Attributes['CAPTION'];

  DebugMsg('********** Build LOOKUP [' + Lcb.Name + '][' + Lcb.Caption +
    '] ***********************');
  Lcb.FieldLabel := XmlNd.Attributes['CAPTION'];
  Lcb.FieldLabelWidth := CutOff;
  Lcb.FieldLabelAlign := laRight;
  if not VarIsNull(XmlNd.Attributes['TOP']) then
    Lcb.Top := XmlNd.Attributes['TOP'];
  if not VarIsNull(XmlNd.Attributes['LEFT']) then
    Lcb.left := StrToInt(XmlNd.Attributes['LEFT']) - CutOff;
  if not VarIsNull(XmlNd.Attributes['WIDTH']) then
    Lcb.Width := StrToInt(XmlNd.Attributes['WIDTH']) + CutOff - 10;
  if not VarIsNull(XmlNd.Attributes['ALIGNMENT']) then
    if XmlNd.Attributes['ALIGNMENT'] = 'Left' then
      Lcb.Alignment := taLeftJustify;
  if XmlNd.Attributes['ALIGNMENT'] = 'Right' then
    Lcb.Alignment := taRightJustify;
  if not VarIsNull(XmlNd.Attributes['ENABLE']) then
  begin
    if XmlNd.Attributes['ENABLE'] = 'Y' then
      Lcb.Enabled := True
    Else
      Lcb.Enabled := False;
  end;

  if not VarIsNull(XmlNd.Attributes['VISIBLE']) then
    if XmlNd.Attributes['VISIBLE'] = 'N' then
      Lcb.Visible := False;

  // if not VarIsNull(XmlNd.Attributes['LKEY']) then
  // Lcb.KeyField := XmlNd.Attributes['LKEY'];

  if not VarIsNull(XmlNd.Attributes['DKEY']) then
    Lcb.KeyField := SplitString(XmlNd.Attributes['DKEY'], ',')[0];

  DebugMsg('Cari Data Source...');
  DebugMsg('Form name: ' + AOwner.Name + sLineBreak + 'Sender name: ' +
    TUniDBLookupComboBox(AOwner).Name);
  for I := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[I] is TDataSource then
    begin
      TmpDs := TDataSource(AOwner.Components[I]);
      // DebugMsg('TmpDs.Name:' + TmpDs.Name);
      // DebugMsg('Compare -> ' + UpperCase(TmpDs.Name) + '=' + 'DS_' +
      // UpperCase(AOwner.Name) + '_' + UpperCase(XmlNd.Attributes['LOOKID']));
      if UpperCase(TmpDs.Name) = 'DS_' + UpperCase(GetOwnerName(AOwner)) + '_' +
        UpperCase(XmlNd.Attributes['LOOKID']) then
      begin
        DebugMsg('KETEMU [' + TmpDs.Name + ']');
        Lcb.ListSource := TmpDs;
      end;
    end;

  Result := Lcb;

end;

// EDIT BOX
function BuildEdit(AOwner: TComponent; XmlNd: IXMLNode): TUniEdit;
var
  Ed: TUniEdit;
  CutOff: integer;
  Mm: TUniMemo;
begin
  CutOff := 70;
  Ed := TUniEdit.Create(AOwner);
  Ed.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];
  Ed.FieldLabel := XmlNd.Attributes['CAPTION'];
  Ed.FieldLabelAlign := laRight;
  Ed.FieldLabelWidth := CutOff + length(XmlNd.Attributes['CAPTION']);
  if not VarIsNull(XmlNd.Attributes['TOP']) then
    Ed.Top := XmlNd.Attributes['TOP'];
  if not VarIsNull(XmlNd.Attributes['LEFT']) then
    Ed.left := StrToInt(XmlNd.Attributes['LEFT']) - 10 - Ed.FieldLabelWidth;
  if not VarIsNull(XmlNd.Attributes['WIDTH']) then
    Ed.Width := StrToInt(XmlNd.Attributes['WIDTH']) + Ed.FieldLabelWidth;
  if not VarIsNull(XmlNd.Attributes['ALIGNMENT']) then
    if XmlNd.Attributes['ALIGNMENT'] = 'Left' then
      Ed.Alignment := taLeftJustify
    else if XmlNd.Attributes['ALIGNMENT'] = 'Right' then
      Ed.Alignment := taRightJustify;

  if not VarIsNull(XmlNd.Attributes['ENABLE']) then
  begin
    if XmlNd.Attributes['ENABLE'] = 'Y' then
      Ed.Enabled := True
    Else
      Ed.Enabled := False;
  end;

  if not VarIsNull(XmlNd.Attributes['VISIBLE']) then
    if XmlNd.Attributes['VISIBLE'] = 'N' then
      Ed.Visible := False;

  Mm := TUniMemo.Create(AOwner);
  Mm.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'] +
    '_ONKEYENTER';

  if not VarIsNull(XmlNd.Attributes['ONKEYENTER']) then
  begin
    Mm.Lines.Text := XmlNd.Attributes['ONKEYENTER'];
    Ed.OnKeyDown := MainForm.EditKeyEnter;
  end;


  // if not VarIsNull(XmlNd.Attributes['ONKEYENTER']) then
  // Ed.ClientEvents.ExtEvents.Values['keypress'] :=
  // ' function keypress(sender, e, eOpts){  if(e.getKey() == 13) {  ajaxRequest('
  // + AOwner.Name + '.form, "_buttonclick" , ["script=' + XmlNd.Attributes
  // ['ONKEYENTER'] + '"]); } }';

  if not VarIsNull(XmlNd.Attributes['FOCUS']) and
    (XmlNd.Attributes['FOCUS'] = 'Y') then
    Ed.SetFocus;
  Result := Ed;
end;

function BuildMemo(AOwner: TComponent; XmlNd: IXMLNode): TUniMemo;
var
  Mm: TUniMemo;
  CutOff: integer;
begin
  CutOff := 90;
  Mm := TUniMemo.Create(AOwner);
  Mm.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];
  Mm.FieldLabel := XmlNd.Attributes['CAPTION'];
  Mm.FieldLabelAlign := laRight;
  Mm.FieldLabelWidth := CutOff + length(XmlNd.Attributes['CAPTION']);
  if not VarIsNull(XmlNd.Attributes['TOP']) then
    Mm.Top := XmlNd.Attributes['TOP'];
  if not VarIsNull(XmlNd.Attributes['HEIGHT']) then
    Mm.Height := XmlNd.Attributes['HEIGHT'];
  if not VarIsNull(XmlNd.Attributes['LEFT']) then
    Mm.left := StrToInt(XmlNd.Attributes['LEFT']) - Mm.FieldLabelWidth;
  if not VarIsNull(XmlNd.Attributes['WIDTH']) then
    Mm.Width := StrToInt(XmlNd.Attributes['WIDTH']) + Mm.FieldLabelWidth;
  if not VarIsNull(XmlNd.Attributes['ALIGNMENT']) then
    if XmlNd.Attributes['ALIGNMENT'] = 'Left' then
      Mm.Alignment := taLeftJustify
    else if XmlNd.Attributes['ALIGNMENT'] = 'Right' then
      Mm.Alignment := taRightJustify;

  if not VarIsNull(XmlNd.Attributes['ENABLE']) then
  begin
    if XmlNd.Attributes['ENABLE'] = 'Y' then
      Mm.Enabled := True
    Else
      Mm.Enabled := False;
  end;

  if not VarIsNull(XmlNd.Attributes['VISIBLE']) then
    if XmlNd.Attributes['VISIBLE'] = 'N' then
      Mm.Visible := False;

  if not VarIsNull(XmlNd.Attributes['FOCUS']) and
    (XmlNd.Attributes['FOCUS'] = 'Y') then
    Mm.SetFocus;
  Result := Mm;
end;

// Date time
function BuildDate(AOwner: TComponent; XmlNd: IXMLNode): TUniDateTimePicker;
var
  Dt: TUniDateTimePicker;
  // Pc: TUniPageControl;
  CutOff: integer;
begin
  CutOff := 80;

  if length(XmlNd.Attributes['CAPTION']) <= 5 then
    CutOff := 50;

  if length(XmlNd.Attributes['CAPTION']) > 10 then
    CutOff := 90;

  Dt := TUniDateTimePicker.Create(AOwner);
  Dt.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];

  DebugMsg('Build Date [' + Dt.Name + ']');
  Dt.FieldLabel := XmlNd.Attributes['CAPTION'];
  Dt.FieldLabelWidth := CutOff;
  Dt.FieldLabelAlign := laRight;
  if not VarIsNull(XmlNd.Attributes['TOP']) then
    Dt.Top := XmlNd.Attributes['TOP'];
  if not VarIsNull(XmlNd.Attributes['LEFT']) then
    Dt.left := StrToInt(XmlNd.Attributes['LEFT']) - CutOff - 10;
  if not VarIsNull(XmlNd.Attributes['WIDTH']) then
    Dt.Width := StrToInt(XmlNd.Attributes['WIDTH']) + CutOff;
  if not VarIsNull(XmlNd.Attributes['ALIGNMENT']) then
    if XmlNd.Attributes['ALIGNMENT'] = 'Left' then
      Dt.Alignment := taLeftJustify;
  if XmlNd.Attributes['ALIGNMENT'] = 'Right' then
    Dt.Alignment := taRightJustify;
  if not VarIsNull(XmlNd.Attributes['TYPE']) then
  begin
    if XmlNd.Attributes['TYPE'] = 'DateTime' then
    begin
      Dt.DateMode := dtmDateTime;
      Dt.Width := Dt.Width + 5;
    end;
  end;

  if not VarIsNull(XmlNd.Attributes['ENABLE']) then
  begin
    if XmlNd.Attributes['ENABLE'] = 'Y' then
      Dt.Enabled := True
    else
      Dt.Enabled := False;
  end;

  Result := Dt;
end;

// PANEL CHILD
function BuildContainerPanel(AOwner: TComponent; XmlNd: IXMLNode;
  Ts: TUniTabSheet): TUniPanel;
var
  Pn: TUniPanel;
  I: integer;
begin
  Pn := TUniPanel.Create(Ts);
  Pn.Parent := Ts;
  if XmlNd.Attributes['ALIGN'] = 'Top' then
  begin
    Pn.Align := alTop;
    if not VarIsNull(XmlNd.Attributes['HEIGHT']) then
      Pn.Height := StrToInt(XmlNd.Attributes['HEIGHT']) + 10;
  end;
  if XmlNd.Attributes['ALIGN'] = 'Client' then
    Pn.Align := alClient;

  if not VarIsNull(XmlNd.Attributes['ID']) then
    Pn.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];

  for I := 0 to XmlNd.ChildNodes.Count - 1 do
  begin
    // Buat LooupDBComboBox
    if XmlNd.ChildNodes[I].NodeName = 'Lookup' then
    begin
      Pn.InsertControl(BuildLookup(AOwner, XmlNd.ChildNodes[I]));
    end;
    // Buat DBGrid
    if XmlNd.ChildNodes[I].NodeName = 'ExpGrid' then
    begin
      Pn.InsertControl(BuildDBGrid(AOwner, XmlNd.ChildNodes[I]));
    end;
  end;
  Result := Pn;
end;

// TAB SHEET
function BuildTabSheet(AOwner: TComponent; XmlNd: IXMLNode; Pc: TUniPageControl)
  : TUniTabSheet;
var
  Ts: TUniTabSheet;
  // Pn: TUniPanel;
  I: integer;
begin
  DebugMsg('4996 ********** Build TabSheet ***********');
  DebugMsg('4967 XML string[' + XmlNd.Xml + ']');

  if VarIsNull(XmlNd.Attributes['ID']) then
    exit;

  Ts := TUniTabSheet.Create(AOwner);

  if not VarIsNull(XmlNd.Attributes['ID']) then
    Ts.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];
  if not VarIsNull(XmlNd.Attributes['CAPTION']) then
    Ts.Caption := XmlNd.Attributes['CAPTION'];

  Ts.PageControl := Pc;
  for I := 0 to XmlNd.ChildNodes.Count - 1 do
  begin
    if XmlNd.ChildNodes[I].NodeName = 'GroupBox' then
    begin
      Ts.InsertControl(BuildGroupBox(AOwner, XmlNd.ChildNodes[I]));
    end;

    if XmlNd.ChildNodes[I].NodeName = 'PanelEx' then
    begin
      Ts.InsertControl(BuildPanel(AOwner, XmlNd.ChildNodes[I]));
    end;

    if XmlNd.ChildNodes[I].NodeName = 'ExpGrid' then
    begin
      Ts.InsertControl(BuildDBGrid(AOwner, XmlNd.ChildNodes[I]));
    end;

  end;
  Result := Ts;

  DebugMsg('3995 end build tabSheet');
end;

function BuildPageControl(AOwner: TComponent; XmlNd: IXMLNode): TUniPageControl;
var
  Pc: TUniPageControl;
  I: integer;
begin

  DebugMsg('***************** PAGE CONTROL *************************');
  Pc := TUniPageControl.Create(AOwner);
  if not VarIsNull(XmlNd.Attributes['ID']) then
  begin
    Pc.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];
    DebugMsg('Name :' + Pc.Name);
  end;
  if not VarIsNull(XmlNd.Attributes['ALIGN']) then
  begin
    DebugMsg('Align :' + XmlNd.Attributes['ALIGN']);
    if XmlNd.Attributes['ALIGN'] = 'None' then
    begin
      Pc.Width := XmlNd.Attributes['WIDTH'];
      Pc.left := XmlNd.Attributes['LEFT'];
      Pc.Width := XmlNd.Attributes['WIDTH'];
      Pc.Height := XmlNd.Attributes['HEIGHT'];
    end
    else
    begin
      if XmlNd.Attributes['ALIGN'] = 'Client' then
        Pc.Align := alClient;
    end;
  end;

  for I := 0 to XmlNd.ChildNodes.Count - 1 do
  begin
    DebugMsg('5053 Build TabSheet..');
    // Buat Tab Sheet
    DebugMsg('5055 XmlNd.ChildNodes[' + IntToStr(I) + '].XML [' +
      XmlNd.ChildNodes[I].Xml + ']');
    if XmlNd.ChildNodes[I].NodeName = 'TabSheet' then
      Pc.InsertControl(BuildTabSheet(AOwner, XmlNd.ChildNodes[I], Pc));
  end;
  Result := Pc;
end;

// LABEL
function BuildLabel(AOwner: TComponent; XmlNd: IXMLNode): TUniLabel;
var
  Lb: TUniLabel;
  ValName, SVar1, SVar2: String;
  TmpStr: TStringDynArray;
  I: integer;
begin
  Lb := TUniLabel.Create(AOwner);
  Lb.Alignment := taRightJustify;
  DebugMsg('5032 ********************** Build Label **********************');

  if not VarIsNull(XmlNd.Attributes['CAPTION']) then
    DebugMsg('5035 CAPTION :' + XmlNd.Attributes['CAPTION']);

  if not VarIsNull(XmlNd.Attributes['ID']) then
  begin
    DebugMsg('5039 ID :' + XmlNd.Attributes['ID']);
    if GetCompByName(AOwner, XmlNd.Attributes['ID']) = '' then
      Lb.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];
  end;
  Lb.Caption := XmlNd.Attributes['CAPTION'];

  if not VarIsNull(XmlNd.Attributes['LEFT']) then
    Lb.left := StrToInt(XmlNd.Attributes['LEFT']);

  if ContainsText(UpperCase(Lb.Caption), '$') then
  begin
    ValName := XmlNd.Attributes['CAPTION'];
    // TODO: HARDCODE
    if (ValName = 'Order ;$auftnr; for Patient ;$patient;') or
      (ValName = '$frmName;') then
    begin
      //
      Lb.Caption := ''; // kosongkan dulu
    end
    else
    begin
      // isi variabel

      ValName := StringReplace(ValName, '$', '', [rfReplaceAll, rfIgnoreCase]);
      Lb.Caption := '';
      if Trim(GetCompByName(AOwner, 'LBL_' + ValName)) = '' then
        Lb.Name := GetOwnerName(AOwner) + '_LBL_' + ValName;
      Lb.Caption := Lb.Name;

      Lb.Caption := '';

      // isi dengan variabel
      Lb.Caption := GetVarValue(AOwner, ValName);

      Lb.left := Lb.left + 8;
    end;
  end;




  // FONT="Style,Bold"

  if not VarIsNull(XmlNd.Attributes['FONT']) then
  begin
    DebugMsg('** Font perlu di set.');
    TmpStr := SplitString(XmlNd.Attributes['FONT'], ',');
    for I := 0 to length(TmpStr) - 1 do
    begin
      DebugMsg(IntToStr(I) + ':' + TmpStr[I]);
      if Trim(UpperCase(TmpStr[I])) = 'BOLD' then
        Lb.Font.Style := Lb.Font.Style + [TFontStyle.fsBold];
    end;
  end;

  // ALIGNMENT
  if not VarIsNull(XmlNd.Attributes['ALIGNMENT']) then
  begin
    // Lb.Top := XmlNd.Attributes['ALIGNMENT'];
    // DebugMsg('5242 [' + Trim(UpperCase(XmlNd.Attributes['ALIGNMENT']))+']');
    // if Trim(UpperCase(XmlNd.Attributes['ALIGNMENT'])) = 'RIGHT' then
    // Lb.Alignment := taRightJustify;
    //
    // if Trim(UpperCase(XmlNd.Attributes['ALIGNMENT'])) = 'LEFT' then
    // Lb.Alignment := taLeftJustify;
  end;

  if not VarIsNull(XmlNd.Attributes['TOP']) then
    Lb.Top := XmlNd.Attributes['TOP'];

  if not VarIsNull(XmlNd.Attributes['WIDTH']) then
    Lb.Width := StrToInt(XmlNd.Attributes['WIDTH']);

  // if not VarIsNull(XmlNd.Attributes['ALIGNMENT']) then
  // if XmlNd.Attributes['ALIGNMENT'] = 'Left' then
  // Lb.Alignment := taLeftJustify;
  // if XmlNd.Attributes['ALIGNMENT'] = 'Right' then
  // Lb.Alignment := taRightJustify;

  if not VarIsNull(XmlNd.Attributes['VISIBLE']) then
    if XmlNd.Attributes['VISIBLE'] = 'N' then
    begin
      DebugMsg('Label Visible=FALSE');
      Lb.Visible := False;
    end;

  // HARDCODE
  if GetOwnerName(AOwner) = 'foPrevalues' then
  begin
    if ContainsText(Lb.Caption, ':') then
    begin
      Lb.left := Lb.left - 40;
    end;
    if ContainsText(Lb.Caption, 'e flow') then
      Lb.Visible := False;

  end;

  DebugMsg('Final label name [' + Lb.Name + ']');
  Result := Lb;
end;

function BuildGroupBox(AOwner: TComponent; XmlNd: IXMLNode): TUniGroupBox;
var
  Gb: TUniGroupBox;
  I: integer;
begin
  DebugMsg('********************** GROUP BOX **********************');

  if not VarIsNull(XmlNd.Attributes['ID']) then
    DebugMsg('*** ID :' + XmlNd.Attributes['ID']);

  if not VarIsNull(XmlNd.Attributes['ALIGN']) then
    DebugMsg('*** ALIGN :' + XmlNd.Attributes['ALIGN']);

  if not VarIsNull(XmlNd.Attributes['VISIBLE']) then
    DebugMsg('*** VISIBLE :' + XmlNd.Attributes['VISIBLE']);
  Gb := TUniGroupBox.Create(AOwner);

  if not VarIsNull(XmlNd.Attributes['ID']) then
    Gb.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];

  if not VarIsNull(XmlNd.Attributes['TOP']) then
    DebugMsg('*** TOP :' + XmlNd.Attributes['TOP']);
  Gb := TUniGroupBox.Create(AOwner);

  if not VarIsNull(XmlNd.Attributes['TOP']) then
    Gb.Top := XmlNd.Attributes['TOP'] + 5;
  if not VarIsNull(XmlNd.Attributes['LEFT']) then
    Gb.left := XmlNd.Attributes['LEFT'] - 5;
  if not VarIsNull(XmlNd.Attributes['HEIGHT']) then
    Gb.Height := XmlNd.Attributes['HEIGHT'];
  if not VarIsNull(XmlNd.Attributes['WIDTH']) then
  begin
    Gb.Width := XmlNd.Attributes['WIDTH'];
  end;
  if not VarIsNull(XmlNd.Attributes['ALIGN']) then
  begin
    if UpperCase(XmlNd.Attributes['ALIGN']) = 'CLIENT' then
      Gb.Align := alClient
    else if UpperCase(XmlNd.Attributes['ALIGN']) = 'TOP' then
      Gb.Align := alTop
    else if UpperCase(XmlNd.Attributes['ALIGN']) = 'LEFT' then
      Gb.Align := alLeft
    else
      Gb.Align := alNone;

  end;
  // Gb.Parent := Parent;

  if not VarIsNull(XmlNd.Attributes['CAPTION']) then
    Gb.Caption := XmlNd.Attributes['CAPTION'];

  for I := 0 to XmlNd.ChildNodes.Count - 1 do
  begin
    // Buat Group Box
    if XmlNd.ChildNodes[I].NodeName = 'GroupBox' then
    begin
      Gb.InsertControl(BuildGroupBox(AOwner, XmlNd.ChildNodes[I]));
    end;

    // Buat Label
    if XmlNd.ChildNodes[I].NodeName = 'Label' then
    begin
      Gb.InsertControl(BuildLabel(AOwner, XmlNd.ChildNodes[I]));
    end;

    // Buat Date time picker
    if XmlNd.ChildNodes[I].NodeName = 'Date' then
    begin
      Gb.InsertControl(BuildDate(AOwner, XmlNd.ChildNodes[I]));
    end;

    // Buat LooupDBComboBox
    if XmlNd.ChildNodes[I].NodeName = 'Lookup' then
    begin
      Gb.InsertControl(BuildLookup(AOwner, XmlNd.ChildNodes[I]));
    end;

    // Buat EditBox
    if XmlNd.ChildNodes[I].NodeName = 'Edit' then
    begin
      Gb.InsertControl(BuildEdit(AOwner, XmlNd.ChildNodes[I]));
    end;

    // Buat MemoBox
    if XmlNd.ChildNodes[I].NodeName = 'Memo' then
    begin
      Gb.InsertControl(BuildMemo(AOwner, XmlNd.ChildNodes[I]));
    end;

    // Buat Button
    if XmlNd.ChildNodes[I].NodeName = 'Button' then
    begin
      Gb.InsertControl(BuildButton(AOwner, XmlNd.ChildNodes[I]));
    end;

    // Buat CheckBox
    if XmlNd.ChildNodes[I].NodeName = 'Check' then
    begin
      Gb.InsertControl(BuildCheck(AOwner, XmlNd.ChildNodes[I]));
    end;

    // Buat Label
    if XmlNd.ChildNodes[I].NodeName = 'Label' then
    begin
      Gb.InsertControl(BuildLabel(AOwner, XmlNd.ChildNodes[I]));
    end;

    // Buat Label
    if XmlNd.ChildNodes[I].NodeName = 'ExpGrid' then
    begin
      Gb.InsertControl(BuildDBGrid(AOwner, XmlNd.ChildNodes[I]));
    end;

    // // Buat Date time picker
    // if XmlNd.ChildNodes[I].NodeName = 'Date' then
    // begin
    // Gb.InsertControl(BuildDate(XmlNd.ChildNodes[I]));
    // end;
  end;
  Result := Gb;
end;

// PANEL
function BuildPanel(AOwner: TComponent; XmlNd: IXMLNode): TUniPanel;
var
  Pn: TUniPanel;
  // Btn: TUniButton;
  // Pc: TUniPageControl;
  I: integer;
begin
  Pn := TUniPanel.Create(AOwner);
  DebugMsg('*********************** PANEL **********************');

  // if not VarIsNull(XmlNd.Attributes['ID']) then
  // DebugMsg('*** ID :' + XmlNd.Attributes['ID']);
  //
  // if not VarIsNull(XmlNd.Attributes['ALIGN']) then
  // DebugMsg('*** ALIGN :' + XmlNd.Attributes['ALIGN']);
  //
  // if not VarIsNull(XmlNd.Attributes['VISIBLE']) then
  // DebugMsg('*** VISIBLE :' + XmlNd.Attributes['VISIBLE']);

  // DebugMsg('>> [' + GetOwnerName(AOwner) + ']');
  //
  // if GetOwnerName(AOwner) = 'fr5120_PopHistory' then
  // begin
  // Pn := TUniPanel.Create(AOwner);
  // Pn.Align := alClient;
  // Pn.Color := clRed;
  // // Pn.Visible := True;
  //
  // Pn.BorderStyle := ubsNone;
  //
  // for I := 0 to XmlNd.ChildNodes.Count - 1 do
  // begin
  // // Buat Grid
  // if XmlNd.ChildNodes[I].NodeName = 'ExpGrid' then
  // begin
  // Pn.InsertControl(BuildDBGrid(AOwner, XmlNd.ChildNodes[I]));
  // end;
  // end;
  //
  // // TfrmPopUp(AOwner).InsertControl(Pn);
  // Result := Pn;
  // exit;
  // // Pn.Parent := TfrmPopUp(AOwner);
  // // Result := Pn;
  // end;

  with TUniPanel(Pn) do
  begin
    if not VarIsNull(XmlNd.Attributes['ALIGN']) then
      if Trim(UpperCase(XmlNd.Attributes['ALIGN'])) = 'CLIENT' then
        Align := alClient
      else if Trim(UpperCase(XmlNd.Attributes['ALIGN'])) = 'TOP' then
        Align := alTop
      else if Trim(UpperCase(XmlNd.Attributes['ALIGN'])) = 'LEFT' then
        Align := alLeft
      else if Trim(UpperCase(XmlNd.Attributes['ALIGN'])) = 'RIGHT' then
        Align := alRight
      else if Trim(UpperCase(XmlNd.Attributes['ALIGN'])) = 'BOTTOM' then
        Align := alBottom
      else
        Align := alNone;

    if not VarIsNull(XmlNd.Attributes['ID']) then
      Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];

    Pn.BorderStyle := ubsNone;

    if not VarIsNull(XmlNd.Attributes['HEIGHT']) then
      if StrToInt(XmlNd.Attributes['HEIGHT']) <= 15 then
        Height := StrToInt(XmlNd.Attributes['HEIGHT'])
      else
        Height := StrToInt(XmlNd.Attributes['HEIGHT']) + 15;

    if not VarIsNull(XmlNd.Attributes['WIDTH']) then
      Width := StrToInt(XmlNd.Attributes['WIDTH']);

    if not VarIsNull(XmlNd.Attributes['TOP']) then
      Top := StrToInt(XmlNd.Attributes['TOP']);

    if not VarIsNull(XmlNd.Attributes['LEFT']) then
      left := StrToInt(XmlNd.Attributes['LEFT']);

    if not VarIsNull(XmlNd.Attributes['VISIBLE']) then
      if XmlNd.Attributes['VISIBLE'] = 'N' then
        Visible := False
      else
        Visible := True;

    DebugMsg('5554 panel Name [' + Pn.Name + ']');

  end;

  for I := 0 to XmlNd.ChildNodes.Count - 1 do
  begin

    DebugMsg('*** ' + IntToStr(I) + ' :' + XmlNd.ChildNodes[I].NodeName);

    // Buat Panel
    if XmlNd.ChildNodes[I].NodeName = 'PanelEx' then
    begin
      Pn.InsertControl(BuildPanel(AOwner, XmlNd.ChildNodes[I]));
    end;

    // Buat Group Box
    if XmlNd.ChildNodes[I].NodeName = 'GroupBox' then
    begin
      Pn.InsertControl(BuildGroupBox(AOwner, XmlNd.ChildNodes[I]));
    end;

    // Buat Grid
    if XmlNd.ChildNodes[I].NodeName = 'ExpGrid' then
    begin
      Pn.InsertControl(BuildDBGrid(AOwner, XmlNd.ChildNodes[I]));
    end;

    // Buat Label
    if XmlNd.ChildNodes[I].NodeName = 'Label' then
    begin
      Pn.InsertControl(BuildLabel(AOwner, XmlNd.ChildNodes[I]));
    end;

    // Buat Combo DB
    if XmlNd.ChildNodes[I].NodeName = 'Combo' then
    begin
      Pn.InsertControl(BuildCombo(AOwner, XmlNd.ChildNodes[I]));
    end;

    // Buat Button
    if XmlNd.ChildNodes[I].NodeName = 'Button' then
    begin
      Pn.InsertControl(BuildButton(AOwner, XmlNd.ChildNodes[I]));
    end;

    // Buat Page Control
    if XmlNd.ChildNodes[I].NodeName = 'PageControl' then
    begin
      Pn.InsertControl(BuildPageControl(AOwner, XmlNd.ChildNodes[I]));
    end;

    // Buat Lookup
    if XmlNd.ChildNodes[I].NodeName = 'Lookup' then
    begin
      Pn.InsertControl(BuildLookup(AOwner, XmlNd.ChildNodes[I]));
    end;

    if XmlNd.ChildNodes[I].NodeName = 'Check' then
    begin
      Pn.InsertControl(BuildCheck(AOwner, XmlNd.ChildNodes[I]));
    end;

    // // Buat CheckBox
    // if XmlNd.ChildNodes[I].NodeName = 'Check' then
    // begin
    // Pn.InsertControl(BuildCheck(XmlNd.ChildNodes[I]));
    // end;
    // // Buat Date Time
    // if XmlNd.ChildNodes[I].NodeName = 'Date' then
    // begin
    // Pn.InsertControl(BuildDate(XmlNd.ChildNodes[I]));
    // end;
    // end;
  end;
  Result := Pn;
end;

end.

unit UnitCommons;

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
  uniGUIApplication, UniHTMLFrame, System.Win.Registry;

function isNumber(Str: String): boolean;
function GetCompByNameComp(AOwner: TComponent; ComponentName: String)
  : TComponent;
procedure BuildMsgBox(AOwner: TComponent; Script: string);
procedure NextNodeDataSet(AOwner: TComponent; Script: string);
procedure RefreshDataSet(AOwner: TComponent; Script: string);
procedure ScriptExecSQL(AOwner: TComponent; Script: string);
procedure CekSPParamDefVal(AOwner: TComponent; FdSP: TFDStoredProc);
procedure RebuildColumnGrid(AOwner: TComponent; Gr: TUniDBGrid);
function GetRegistryValue(KeyName: string; Str: string): string;
procedure SetRegistryValue(KeyName: string; Str: string; val: string);
function GetGridColRegVal(Gr: TUniDBGrid; ColNo: string; Str: string): String;
procedure SetGridColRegVal(Gr: TUniDBGrid; ColNo: string; Str: string;
  val: string);
procedure ReConfGridCol(Gr: TUniDBGrid);
procedure GrColumnResize(Sender: TUniBaseDBGridColumn; NewSize: Integer);
procedure DebugMsg(const Msg: String);
function GetOwnerName(AOwner: TComponent): string;
function GetCompByName(AOwner: TComponent; ComponentName: String): String;
function GetVarValue(AOwner: TComponent; VarName: String): string;
function GetCompValue(AOwner: TComponent; CompName: string): String;

const
  vendor = 'GSLE';

implementation

Uses UnitPopUp, Main, UnitBuildControls;

procedure DebugMsg(const Msg: String);
begin
  OutputDebugString(PChar(Msg + char(10)));
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

function GetCompByName(AOwner: TComponent; ComponentName: String): String;
var
  I: Integer;
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

function GetVarValue(AOwner: TComponent; VarName: String): string;
var
  Lb: TUniLabel;
  I: Integer;
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

function isNumber(Str: String): boolean;
var
  s: String;
  iValue, iCode: Integer;
begin
  val(s, iValue, iCode);

  if iCode = 0 then
    Result := True
  else
    Result := False;
end;

procedure GrColumnResize(Sender: TUniBaseDBGridColumn; NewSize: Integer);
var
  XML_id, Gridname: string;
begin
  XML_id := StringReplace(SplitString(Sender.Grid.Name, '_')[0], 'fr', '',
    [rfReplaceAll, rfIgnoreCase]);
  Gridname := UpperCase(SplitString(Sender.Grid.Name, '_')[1]);

  SetGridColRegVal(TUniDBGrid(Sender.Grid), Sender.FieldName, 'Width',
    IntToStr(NewSize));
end;

procedure ReConfGridCol(Gr: TUniDBGrid);
var
  I: Integer;
  XML_id, Gridname: string;
  Registry: TRegistry;
begin
  XML_id := StringReplace(SplitString(Gr.Name, '_')[0], 'fr', '',
    [rfReplaceAll, rfIgnoreCase]);
  Gridname := UpperCase(SplitString(Gr.Name, '_')[1]);

  DebugMsg('97 Gridname[' + Gridname + ']');

  Registry := TRegistry.Create(KEY_READ);
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    Registry.OpenKey('SOFTWARE\' + vendor + '\LIS\Application\' +
      UniApplication.Cookies.GetCookie('UserName') + '\' + XML_id + '\' +
      Gridname + '\', False);

    if (Gridname <> 'GRANALYTCOMMENTS') and (Gridname <> 'GRORDERCOMMENTS') then
      if Registry.KeyExists('Grid Settings') then
      begin
        for I := 0 to Gr.Columns.Count - 1 do
        begin
          if GetGridColRegVal(Gr, Gr.Columns[I].FieldName, 'Visible') = '"False"'
          then
            Gr.Columns[I].Visible := False;
          if GetGridColRegVal(Gr, Gr.Columns[I].FieldName, 'Visible') = '"True"'
          then
            Gr.Columns[I].Visible := True;

        end;
      end;
  finally
    Registry.Free;
  end;

end;

function GetGridColRegVal(Gr: TUniDBGrid; ColNo: string; Str: string): string;
var
  XML_id, Gridname: string;
begin
  XML_id := StringReplace(SplitString(Gr.Name, '_')[0], 'fr', '',
    [rfReplaceAll, rfIgnoreCase]);
  Gridname := UpperCase(SplitString(Gr.Name, '_')[1]);

  Result := GetRegistryValue('SOFTWARE\' + vendor + '\LIS\Application\' +
    UniApplication.Cookies.GetCookie('UserName') + '\' + XML_id + '\' + Gridname
    + '\Grid Settings\' + ColNo, Str);
end;

procedure SetGridColRegVal(Gr: TUniDBGrid; ColNo: string; Str: string;
  val: string);
var
  XML_id, Gridname: string;
begin
  XML_id := StringReplace(SplitString(Gr.Name, '_')[0], 'fr', '',
    [rfReplaceAll, rfIgnoreCase]);
  Gridname := UpperCase(SplitString(Gr.Name, '_')[1]);

  SetRegistryValue('SOFTWARE\' + vendor + '\LIS\Application\' +
    UniApplication.Cookies.GetCookie('UserName') + '\' + XML_id + '\' + Gridname
    + '\Grid Settings\' + ColNo, Str, val);
end;

function GetRegistryValue(KeyName: string; Str: string): string;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create(KEY_READ);
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    Registry.OpenKey(KeyName, True);
    Result := Registry.ReadString(Str);
  finally
    Registry.Free;
  end;
end;

procedure SetRegistryValue(KeyName: string; Str: string; val: string);
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create(KEY_WRITE);
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    Registry.OpenKey(KeyName, True);
    Registry.WriteString(Str, val);
  finally
    Registry.Free;
  end;
end;

procedure CekSPParamDefVal(AOwner: TComponent; FdSP: TFDStoredProc);
var
  I: Integer;
begin
  DebugMsg('60 CekSPParamDefVal [' + FdSP.Name + ']');
  for I := 0 to FdSP.Params.Count - 1 do
  begin
    if VarIsNull(FdSP.Params[I].Value) then
      DebugMsg('62 [' + IntToStr(I) + '][' + FdSP.Params[I].Name + '] is NULL');
    if UpperCase(FdSP.Params[I].Name) = 'PREFOBJECT' then
      FdSP.Params[I].Value := '%';
    if UpperCase(FdSP.Params[I].Name) = 'PREFOBJECT_SEQNR' then
      FdSP.Params[I].Value := '%';
    if UpperCase(FdSP.Params[I].Name) = 'PFREETEXT_SEQNR' then
      FdSP.Params[I].Value := '%';
  end;
end;

procedure RebuildColumnGrid(AOwner: TComponent; Gr: TUniDBGrid);
var
  I, J, K: Integer;
  GrdName, DsName, ColumnData: string;
  XmlNd: IXMLNode;
  XmlNdChild: IXMLNode;
  Doc: IXMLDocument;
  BMatch: boolean;
begin
  GrdName := Gr.Name;
  DsName := Gr.DataSource.Name;
  DebugMsg('84 *** Ketemu [' + GrdName + '][' + DsName + ']');
  // columxml
  ColumnData := GetCompValue(AOwner, GrdName + '_COLUMN');
  ColumnData := '<ExpGrid>' + ColumnData + '</ExpGrid>';
  DebugMsg('88 ColumnData [' + ColumnData + ']');

  // read XML
  DefaultDOMVendor := sOmniXmlVendor;

  Doc := LoadXMLData(ColumnData);
  DebugMsg('94 Doc:' + Doc.Xml.ToString);

  XmlNd := Doc.DocumentElement;
  DebugMsg('97 XmlNd:' + XmlNd.Xml);

  DebugMsg('99 GrdName:' + GrdName);

  DebugMsg('104 Gr.ColumCount:' + IntToStr(Gr.Columns.Count));

  for I := 0 to Gr.Columns.Count - 1 do
  begin
    DebugMsg('108 [' + IntToStr(I) + '][' + Gr.Columns[I].FieldName + ']');
    Gr.Columns.Items[I].Visible := False;
    for J := 0 to XmlNd.ChildNodes.Count - 1 do
    begin
      BMatch := False;

      // DebugMsg('112 Attr Name [' + UpperCase(XmlNd.ChildNodes[J].Attributes
      // ['NAME'] + '] = [' + UpperCase(Gr.Columns.Items[I].FieldName)) + ']');

      if UpperCase(XmlNd.ChildNodes[J].Attributes['NAME'])
        = UpperCase(Gr.Columns.Items[I].FieldName) then
      begin
        BMatch := True;
        DebugMsg('116 Match [' + XmlNd.ChildNodes[J].Attributes['NAME'] + ']');
        Gr.Columns.Items[I].Visible := True;

        Gr.Columns.Items[I].ReadOnly := True;
        Gr.Columns.Items[I].Tag := 1;

        if not VarIsNull(XmlNd.ChildNodes[J].Attributes['CAPTION']) then
          Gr.Columns.Items[I].Title.Caption := XmlNd.ChildNodes[J].Attributes
            ['CAPTION'];
        if not VarIsNull(XmlNd.ChildNodes[J].Attributes['VISIBLE']) then
          if UpperCase(XmlNd.ChildNodes[J].Attributes['VISIBLE']) = 'Y' then
            Gr.Columns.Items[I].Visible := True
          else
            Gr.Columns.Items[I].Visible := False;
        if not VarIsNull(XmlNd.ChildNodes[K].Attributes['WIDTH']) then
          Gr.Columns.Items[I].Width :=
            StrToInt(XmlNd.ChildNodes[J].Attributes['WIDTH']) + 40;

        if not VarIsNull(XmlNd.ChildNodes[J].Attributes['TYPE']) then
        begin
          if UpperCase(XmlNd.ChildNodes[J].Attributes['TYPE']) = 'CHECK' then
          begin
            Gr.Columns.Items[I].CheckBoxField.BooleanFieldOnly := False;
            Gr.Columns.Items[I].CheckBoxField.DisplayValues := ';';
            Gr.Columns.Items[I].CheckBoxField.FieldValues := XmlNd.ChildNodes[J]
              .Attributes['CHECK'] + ';' + XmlNd.ChildNodes[J].Attributes
              ['UNCHECK'];
          end;
        end;

        Gr.Columns.Items[I].Sortable := True;

      end;
    end;
  end;

  exit;

  with Gr do
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
end;

function GetCompByNameComp(AOwner: TComponent; ComponentName: String)
  : TComponent;
var
  I: Integer;
  Co: TUniComponent;
  SVar1, SVar2, ActiveForm: string;
  BKetemu: boolean;
begin
  BKetemu := False;

  for I := 0 to UniSession.FormsList.Count - 1 do
  begin
    DebugMsg('68 [' + IntToStr(I) + '][' + TuniForm(UniSession.FormsList[I])
      .Name + ']');
  end;

  ActiveForm := TuniForm(UniSession.FormsList[UniSession.FormsList.Count
    - 1]).Name;

  if ComponentName = 'QGETOFFSETFROMDATE' then
    ActiveForm := 'Daylist_Selection';

  DebugMsg('53 Active Form Name:' + ActiveForm);
  DebugMsg('54 GetCompByNameComp():' + ComponentName);
  if not ContainsText(ComponentName, '_') then
    DebugMsg('55 GetCompByNameComp() name search:' +
      UpperCase(GetOwnerName(AOwner) + '_' + UpperCase(Trim(ComponentName))));
  for I := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[I].Name <> '' then
    begin
      SVar1 := UpperCase(AOwner.Components[I].Name);
      SVar1 := FixCompName(SVar1);
      if not ContainsText(ComponentName, '_') then
        SVar2 := UpperCase(GetOwnerName(AOwner) + '_' +
          UpperCase(Trim(ComponentName)))
      else
        SVar2 := UpperCase(Trim(ComponentName));
      if ContainsText(SVar2, 'QGETORDER') then
        DebugMsg('Komponen[' + SVar1 + '] cari [' + SVar2 + ']');
      if SVar1 = SVar2 then
      begin
        Co := TUniComponent(AOwner.Components[I]);
        DebugMsg('Ketemu Value [' + Co.Name + ']');
        BKetemu := True;
        DebugMsg(Co.ClassName);
        Result := Co;
        exit;
      end;
    end;

  if not BKetemu then
  begin
    DebugMsg('78 tidak ketemu [' + ComponentName + ']');
    DebugMsg('92 Cari ActiveForm [' + ActiveForm + ']');
    if ActiveForm <> 'MainForm' then
    begin
      DebugMsg('81 Active From not "MainForm" = ' + ActiveForm);
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
          if ContainsText(SVar2, 'QGETOFFSETFROMDATE') then
            DebugMsg('98 Komponen[' + SVar1 + '] cari [' + SVar2 + ']');
          if SVar1 = SVar2 then
          begin
            Co := TUniComponent
              (TuniForm(UniSession.FormsList[UniSession.FormsList.Count - 1])
              .Components[I]);
            DebugMsg('105 Ketemu Value [' + Co.Name + ']');
            BKetemu := True;
            Result := Co;
            exit;
          end;
        end;
      end;
    end;
  end;
end;

procedure BuildMsgBox(AOwner: TComponent; Script: string);
var
  SVar1, SVar2, Text, Buttons, OnOk, OnYes, SType, OriCompName, CompName,
    CompValue: string;
  Co: TComponent;
  XmlNd: IXMLNode;
  Doc: IXMLDocument;
begin
  DebugMsg('* BuilMsgBox()');
  SVar1 := Trim(SplitString(Script, '.')[0]);
  DebugMsg('49 SVar1:' + SVar1);
  SVar1 := GetCompByName(AOwner, SVar1);
  DebugMsg('51 SVar1:' + SVar1);
  Co := GetCompByNameMain(SVar1);
  if Co = Nil then
    Co := GetCompByNamePopUp(SVar1);
  if Co <> Nil then
  begin
    if Co is TUniMemo then
    begin
      DebugMsg('60 XML [' + TUniMemo(Co).Lines.Text + ']');
      DefaultDOMVendor := sOmniXmlVendor;

      Doc := LoadXMLData(TUniMemo(Co).Lines.Text);
      DebugMsg('65 Doc:' + Doc.Xml.ToString);

      XmlNd := Doc.DocumentElement;
      DebugMsg('67 XmlNd.Xml [' + XmlNd.Xml + ']');

      Text := '';
      if not VarIsNull(XmlNd.Attributes['TEXT']) then
        Text := XmlNd.Attributes['TEXT'];

      if ContainsText(UpperCase(Text), '$') then
      begin
        DebugMsg('297  Text[' + Text + ']');
        CompName := SplitString(Text, ';')[1];
        OriCompName := CompName;
        DebugMsg('298  CompName[' + CompName + ']');
        CompName := StringReplace(CompName, '$', '',
          [rfReplaceAll, rfIgnoreCase]);
        DebugMsg('302  CompName[' + CompName + ']');
        CompName := GetOwnerName(AOwner) + '_' + CompName;
        DebugMsg('302  CompName[' + CompName + ']');
        CompValue := GetCompValue(AOwner, CompName);
        DebugMsg('300 CompValue[' + CompValue + ']');
        Text := StringReplace(Text, ';' + OriCompName + ';',
          ' ' + CompValue + ' ', [rfReplaceAll, rfIgnoreCase]);
        DebugMsg('304  Text[' + Text + ']');
      end;

      Buttons := '';
      if not VarIsNull(XmlNd.Attributes['BUTTONS']) then
        Buttons := XmlNd.Attributes['BUTTONS'];

      OnOk := '';
      if not VarIsNull(XmlNd.Attributes['ONOK']) then
        OnOk := XmlNd.Attributes['ONOK'];

      OnYes := '';
      if not VarIsNull(XmlNd.Attributes['ONYES']) then
        OnYes := XmlNd.Attributes['ONYES'];

      SType := '';
      if not VarIsNull(XmlNd.Attributes['TYPE']) then
        SType := XmlNd.Attributes['TYPE'];

      if UpperCase(Buttons) = 'OK;CANCEL' then
      begin
        // Konfirmasi
        MainForm.MessageDlg(Text, mtConfirmation, mbOkCancel,
          procedure(Sender: TComponent; Res: Integer)
          begin
            case Res of
              mrOk:
                RunAction(AOwner, OnOk);
              mrCancel:
                DebugMsg('DResult: Cancel');
            end;
          end);
      end
      else if UpperCase(Buttons) = 'YES;NO' then
      begin
        // Konfirmasi
        MainForm.MessageDlg(Text, mtConfirmation, mbYesNo,
          procedure(Sender: TComponent; Res: Integer)
          begin
            case Res of
              mrYes:
                RunAction(AOwner, OnYes);
              mrNo:
                DebugMsg('DResult: No');
            end;
          end);
      end
      else if UpperCase(Buttons) = 'OK' then
      begin
        MainForm.ShowMessage(Text);
      end
      else
        raise Exception.Create('60 BuildMsgBox() : Buttons [' + Buttons +
          '] unknown');
    end
    else
      raise Exception.Create('60 BuildMsgBox() : Component [' + SVar1 +
        '] not Memo');
  end
  else
    raise Exception.Create('60 BuildMsgBox() : Component [' + SVar1 +
      '] not found');

end;

procedure NextNodeDataSet(AOwner: TComponent; Script: string);
var
  SVar1, SVar2: string;
  Co: TComponent;
  LastRecNo: Integer;
begin
  DebugMsg('* NEXTNODE()');
  SVar1 := Trim(SplitString(Script, '.')[0]);
  DebugMsg('1804 SVar1:' + SVar1);
  SVar1 := GetCompByName(AOwner, SVar1);
  DebugMsg('1806 SVar1:' + SVar1);
  Co := MainForm.FindComponent(SVar1);
  LastRecNo := TUniDBGrid(Co).DataSource.DataSet.RecNo;
  if Co is TUniDBGrid then
  begin
    TUniDBGrid(Co).CurrRow := LastRecNo;
    TUniDBGrid(Co).DataSource.DataSet.RecNo := LastRecNo + 1;
  end
  else
    raise Exception.Create('1810 RunAction() : Component [' + SVar1 +
      '] unknown type.');
end;

procedure RefreshDataSet(AOwner: TComponent; Script: string);
var
  SVar1, SVar2: string;
  Co: TComponent;
  LastRecNo: Integer;
begin
  DebugMsg('* REFRESH()');
  SVar1 := Trim(SplitString(Script, '.')[0]);
  DebugMsg('1709 SVar1:' + SVar1);
  SVar1 := GetCompByName(AOwner, SVar1);
  DebugMsg('1711 SVar1:' + SVar1);
  Co := MainForm.FindComponent(SVar1);
  // execute query dulu
  SVar2 := TUniDBGrid(Co).DataSource.DataSet.Name;
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
end;

procedure SetCompValueFromDataSet(AOwner: TComponent; FdQ: TFDQuery);
var
  J: Integer;
  Co: TComponent;
  CompName, CompVal: String;
begin
  with FdQ do
    for J := 0 to FieldCount - 1 do
    begin
      DebugMsg('444 Fields[' + IntToStr(J) + '].FieldName :' +
        Fields[J].FieldName);
      DebugMsg('446 Fields[' + IntToStr(J) + '].Value :' +
        VarToStr(Fields[J].Value));

      CompName := GetOwnerName(AOwner) + '_' + Fields[J].FieldName;

      DebugMsg('450 CompName:' + CompName);
      Co := MainForm.FindComponent(CompName);
      if Co = Nil then
      begin
        DebugMsg('353 Tidak ketemu di Main form, cari di PopUp...');
        Co := GetCompByNamePopUp(CompName);
        if Co = Nil then
        begin
          DebugMsg('457 Tdk ketemu komponen skip.');
          exit;
        end;
        // raise Exception.Create
        // ('458 SerCompValueFromDataSet FindComponent Failure [' +
        // CompName + ']');
      end;
      DebugMsg('461 Co.Name:' + Co.Name);
      if Co is TUniLabel then
      begin
        DebugMsg('464 Co is label');
        DebugMsg('465 set Value:' + VarToStr(Fields[J].Value));
        TUniLabel(Co).Caption := VarToStr(Fields[J].Value);
      end
      else if Co is TUniDateTimePicker then
      begin
        DebugMsg('Co is Date time picker');
        TUniDateTimePicker(Co).DateTime := Fields[J].Value;
      end
      else
        raise Exception.Create('RunAction() Query Execute : Component [' +
          VarToStr(Fields[J].Value) + '] unknown type.');
    end;
end;

procedure ScriptExecSQL(AOwner: TComponent; Script: string);
var
  SVar1, SVar2, SVar3, SVar4, SComp1, Cmd, ParName, ParVal: string;
  Co: TComponent;
  FdC: TFDCommand;
  TmpStr1: TStringDynArray;
  J: Integer;
  Var1: Variant;
begin
  DebugMsg('* Execute Query');
  if LeftStr(UpperCase(Script), 2) <> 'ST' then
  begin

    SVar1 := Trim(SplitString(Script, '.')[0]);
    DebugMsg('1779 SVar1:' + SVar1);
    SVar1 := GetCompByName(AOwner, SVar1);
    DebugMsg('1780 SVar1:' + SVar1);

    Co := GetCompByNameComp(AOwner, SVar1);
    DebugMsg('294 Co.ClassName [' + Co.ClassName + ']');

    // Co := AOwner.FindComponent(SVar1);
    //
    // if Co = Nil then
    // begin
    // Co := GetCompByNamePopUp(SVar1);
    // if Co = Nil then
    // raise Exception.Create
    // ('RunAction Execute() 1549 FindComponent Failure [' + SVar1 + ']');
    // end;

    if Co is TFDStoredProc then
    begin
      DebugMsg('2015 TFDStoredProc');
      with TFDStoredProc(Co) do
      begin
        if Active then
          Active := False;

        DebugMsg('317 TFDStoredProc Name [' + Name + ']');
        DebugMsg('318 PackageName [' + PackageName + ']');
        DebugMsg('319 StoredProcName [' + StoredProcName + ']');
        DebugMsg('320 Params.Count [' + IntToStr(Params.Count) + ']');
        DebugMsg('321 Tag[' + IntToStr(Tag) + ']');


        // HARDCODE: command execute
        // TODO: buat engine untuk cek storeproc adalah execute command atau SP

        if Tag = 1 then
          if (Name = 'fr5120_qSetRelease') or (Name = 'fr5120_qForceMedval') or
            (Name = 'fr5120_qSetRetry') then
          begin
            DebugMsg('2032 Hardcode: execute function');
            // ambil dulu text script nya

            FdC := TFDCommand(GetCompByNameMain(Name + '_EXEC'));
            if FdC = Nil then
              FdC := TFDCommand(GetCompByNamePopUp(Name + '_EXEC'));
            if FdC <> Nil then
            begin
              // FdC.CommandText.Text := GetCompValue(AOwner, FdC.Name + '_SQLTEXT');

              if not ContainsText(UpperCase(FdC.CommandText.Text), 'CALL') then
                FdC.CommandText.Text := 'call ' + FdC.CommandText.Text;

              Cmd := FdC.CommandText.Text;

              DebugMsg('2041 FdC.CommandText [' + FdC.CommandText.Text + ']');
              // isi param
              TmpStr1 := SplitString(FdC.CommandText.Text, ',');
              // FdC.Prepared := False;

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
                  SVar1 := UpperCase(Trim(StringReplace(TmpStr1[J], ':', '',
                    [rfReplaceAll, rfIgnoreCase])));
                  DebugMsg('2065 Param [' + SVar1 + ']');
                  // FdC.Params.Add.Name := SVar1;
                  SVar2 := Trim(GetCompValue(AOwner, GetOwnerName(AOwner) + '_'
                    + SVar1));
                  DebugMsg('2070 Value [' + SVar2 + ']');
                  FdC.CommandText.Text := StringReplace(FdC.CommandText.Text,
                    ':' + SVar1, QuotedStr(SVar2),
                    [rfReplaceAll, rfIgnoreCase]);
                  // if SVar2 <> '' then
                  // FdC.ParamByName(SVar1).Value := SVar2
                  // else
                  // FdC.ParamByName(SVar1).DataType := ftString;

                end;

              end;

            end
            else
              raise Exception.Create('2044 Command exec cannot find comp EXEC ['
                + Name + ']');
            DebugMsg('201 FdC.CommandText.Text[' + FdC.CommandText.Text + ']');
            FdC.Execute;
            FdC.Connection.Commit;

            FdC.CommandText.Text := Cmd;
            exit;
          end;

        for J := 0 to Params.Count - 1 do
        begin
          DebugMsg('396 [' + IntToStr(J) + '][' + Params[J].Name + ']');
        end;

        // get value
        try
          SVar3 := StringReplace(Co.Name, GetOwnerName(AOwner) + '_', '',
            [rfReplaceAll, rfIgnoreCase]);
          SVar3 := GetCompByName(AOwner, SVar3 + '_SP');
          DebugMsg('404 Parameter SP SVar3:' + SVar3);
          if SVar3 <> '' then
          begin
            SVar3 := GetCompValue(AOwner, SVar3);
            DebugMsg('408 Value:' + SVar3);
            // parsing nilai
            if ContainsText(SVar3, '(') and ContainsText(SVar3, ')') then
            begin
              SVar3 := Trim(SplitString(SplitString(SVar3, '(')[1], ')')[0]);
              TmpStr1 := SplitString(SVar3, ',');
              for J := 0 to length(TmpStr1) - 1 do
              begin
                TmpStr1[J] := Trim(TmpStr1[J]);
                if ContainsText(TmpStr1[J], '=>') then
                begin
                  DebugMsg('441 Ada tanda "=>"[' + TmpStr1[J] + ']');
                  TmpStr1[J] := Trim(SplitString(TmpStr1[J], '>')[1]);
                  DebugMsg('443 Fix "=>"[' + TmpStr1[J] + ']');
                end;
                if LeftStr(TmpStr1[J], 1) = ':' then
                begin
                  TmpStr1[J] := StringReplace(TmpStr1[J], ':', '',
                    [rfReplaceAll, rfIgnoreCase]);
                  SVar3 := Trim(TmpStr1[J]);
                  SVar4 := GetCompByName(AOwner, SVar3);
                  SVar4 := GetCompValue(AOwner, SVar4);
                  TmpStr1[J] := SVar4
                end
                else
                begin
                  TmpStr1[J] := StringReplace(TmpStr1[J], '''', '',
                    [rfReplaceAll, rfIgnoreCase]);
                end;
              end;
              // see value
              Prepare;
              DebugMsg('434 Params.Count [' + IntToStr(Params.Count) +
                '] length(TmpStr1)[' + IntToStr(length(TmpStr1)) + ']');
              for J := 0 to length(TmpStr1) - 1 do
              begin

                if Params[J].ParamType = ptInput then
                  DebugMsg('439 INPUT - Param[' + IntToStr(J) + '].Name [' +
                    Params[J].Name + '] VALUE [' + TmpStr1[J] + ']')
                else
                  DebugMsg('442 OTHERS - Param[' + IntToStr(J) + '].Name [' +
                    Params[J].Name + '] VALUE [' + TmpStr1[J] + ']');

                if TmpStr1[J] <> '' then
                begin
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
          if not VarIsNull(Params[J].Value) then
            if UpperCase(Params[J].Value) = 'NULL' then
              with Params[J] do
              begin
                DebugMsg('Null Clear Value.');
                Clear;
              end;

          if VarIsNull(Params[J].Value) then
            DebugMsg('481 Params[' + IntToStr(J) + '].Name <' + Params[J].Name +
              '>.Value <NULL>')
          else

            DebugMsg('185 Params[' + IntToStr(J) + '].Name <' + Params[J].Name +
              '>.Value <' + VarToStr(Params[J].Value) + '>');

        end;

        if Tag = 1 then
        begin
          DebugMsg('492 Execute() SP.');
          Execute();
          exit;
        end
        else
        begin
          DebugMsg('498 Open() SP.');
          Open();
          SetColumnGridFromDB(AOwner, Name);
        end;

        DebugMsg('829 Record Count open:' + IntToStr(RecordCount));
        for J := 0 to FieldCount - 1 do
        begin
          DebugMsg(Fields[J].FieldName + '=>' + VarToStr(Fields[J].Value));
          SetCompValFromDB(AOwner, Fields[J].FieldName,
            VarToStr(Fields[J].Value), Name);

        end;

        // HARCODE
        // if Name = 'foPrevalues_qGetPrevalues' then
        // begin
        // DebugMsg('841 rekonfig.');
        // // ReConfGridCol(GetCompByNamePopUp('foPrevalues_EG1') as TUniDBGrid);
        // with GetCompByNamePopUp('foPrevalues_EG1') as TUniDBGrid do
        // begin
        // for J := 0 to Columns.Count - 1 do
        // begin
        // Columns[J].Visible := False;
        // DebugMsg('848 Field name:' + Columns[J].FieldName);
        // end;
        // end;
        // end;

      end;
    end
    else if Co is TFDQuery then
    begin
      DebugMsg('669 TFDQuery');
      with TFDQuery(Co) do
      begin
        if Active then
          Active := False;

        DebugMsg('675 Tag:' + IntToStr(Tag));
        SQL.Text := GetCompValue(AOwner, Name + '_SQLTEXT');
        DebugMsg('677 SQL.Text:' + SQL.Text);

        if ContainsText(SQL.Text, '(') and ContainsText(SQL.Text, ')') and
          ContainsText(SQL.Text, ',') then
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

          DebugMsg('700 Final SQL.Text:' + SQL.Text);
        end
        else if ContainsText(SQL.Text, '(') and ContainsText(SQL.Text, ')') then
        // single param
        begin
          SVar1 := SplitString(SQL.Text, '(')[1];
          DebugMsg('2000 SVar1:' + SVar1);
          SVar1 := Trim(SplitString(SVar1, ')')[0]);
          DebugMsg('2003 SVar1:' + SVar1);

          SComp1 := GetCompByName(AOwner, SVar1);
          SVar2 := GetCompValue(AOwner, SComp1);
          DebugMsg('2007 SVar2:' + SVar2);

          SQL.Text := StringReplace(SQL.Text, Trim(SVar1), QuotedStr(SVar2),
            [rfReplaceAll, rfIgnoreCase]);

          DebugMsg('Final SQL.Text:' + SQL.Text);
        end;

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

        Open;

        DebugMsg('736 Record COUNT:' + IntToStr(RecordCount));

        // // get value
        // for J := 0 to FieldCount - 1 do
        // begin
        // // for K := 0 to FieldCount - 1 do
        // DebugMsg('743 Fields[' + IntToStr(J) + '].FieldName :' +
        // Fields[J].FieldName);
        // Var1 := Fields[J].Value;
        // DebugMsg('746 Fields[' + IntToStr(J) + '].Value :' + VarToStr(Var1));
        // // cari field
        // s SVar1 := GetCompByName(AOwner, Fields[J].FieldName);
        // DebugMsg('749 SVar1:' + SVar1);
        // Co := MainForm.FindComponent(SVar1);
        // if Co = Nil then
        // begin
        // DebugMsg('Tidak ketemu di Main form, cari di PopUp...');
        // Co := GetCompByNamePopUp(SVar1);
        // if Co = Nil then
        // raise Exception.Create
        // ('RunAction() Query Open 1780 FindComponent Failure [' +
        // SVar1 + ']');
        // end;
        // DebugMsg('2079 Co.Name:' + Co.Name);
        // if Co is TUniLabel then
        // begin
        // DebugMsg('2082 Co is label');
        // DebugMsg('2083 set Value:' + VarToStr(Var1));
        // TUniLabel(Co).Caption := VarToStr(Var1);
        // end
        // else if Co is TUniDateTimePicker then
        // begin
        // DebugMsg('Co is Date time picker');
        // TUniDateTimePicker(Co).DateTime := Var1
        // end
        // else
        // raise Exception.Create('RunAction() Query Execute : Component [' +
        // SVar1 + '] unknown type.');
        // end;

        //
        // if RecordCount > 0 then
        // SetCompValueFromDataSet(AOwner, TFDQuery(Co));
      end;

    end
    else if Trim(SVar1) <> '' then
      raise Exception.Create('2166 RunAction() : Component [' + SVar1 +
        '] unknown type, it shoud FireDac Component.');
  end
  else
    DebugMsg('Start with ST*** skip (todo: status text).');
end;

end.

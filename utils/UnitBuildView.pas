unit UnitBuildView;

interface

uses System.Classes, System.Variants, System.SysUtils, System.Types, Controls,
  System.StrUtils, System.UITypes, XMLIntf, XMLDoc, Xml.xmldom,
  Xml.Win.msxmldom, Xml.omnixmldom;

procedure BuildView(AOwner: TComponent; XmlNode: IXMLNode);

implementation

uses Main, MainModule, UniGUIApplication, UniGUIForm, UniGroupBox, UniPanel,
  UniLabel, UniCheckBox, UniDBLookupComboBox, UniDBGrid, UniMemo, UniButton,
  UniSplitter, UniMainMenu, UniGUITypes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, UnitCommons;

function BuildVariable(AOwner: TComponent; XmlNd: IXMLNode): TUniLabel;
var
  Lb: TUniLabel;
  DefValue: String;
  Co: TComponent;
  TmpStr: TStringDynArray;
  I, J: integer;
begin
  DebugMsg('BuildVariable()');
  DefValue := '';
  Lb := TUniLabel.Create(AOwner);
  with Lb do
  begin
    if AOwner.FindComponent(GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'])
      = Nil then
      Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];
    Caption := '';
    if not VarIsNull(XmlNd.Attributes['DEF']) then
      Caption := XmlNd.Attributes['DEF'];

    if not VarIsNull(XmlNd.Attributes['DATATYPE']) then
      if UpperCase(XmlNd.Attributes['DATATYPE']) = 'DATE' then
        Caption := DateToStr(Now);

    Tag := 0;
    if not VarIsNull(XmlNd.Attributes['TYPE']) then
      if UpperCase(XmlNd.Attributes['TYPE']) = 'RETURN' then
      begin
        Tag := 1;
        if not VarIsNull(XmlNd.Attributes['KEYFIELD']) then
          Name := Name + '_X_' + XmlNd.Attributes['KEYFIELD'];
      end
      else if not VarIsNull(XmlNd.Attributes['KEYFIELD']) then
        Name := Name + '_X_' + XmlNd.Attributes['KEYFIELD'];

    Visible := False;
  end;

  Result := Lb;
end;

procedure BuildQueryEx(AOwner: TComponent; XmlNd: IXMLNode);
var
  FdSP: TFDStoredProc;
  Mm: TUniMemo;
  ds: TDataSource;
  FdQ: TFDQuery;
  FdC: TFDCommand;
  Script, PackageName, StoredProcName, STmp, sTmpPar, DataSetName, SVar1, SVar2,
    ParName, ParVal, frName: string;
  TmpList, TmpList1: TStringDynArray;
  Lb: TUniLabel;
  I, J, K, x: integer;
  bExec, bStartup, bJs: boolean;
begin
  DebugMsg('BuildQueryEx()');
  DebugMsg(XmlNd.Xml);
  bExec := False;
  frName := GetOwnerName(AOwner);
  // Cek apakah query execute?
  if not VarIsNull(XmlNd.Attributes['TYPE']) then
    if UpperCase(XmlNd.Attributes['TYPE']) = 'EXEC' then
      bExec := True;

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
      BuildVariable(AOwner, XmlNd.ChildNodes[I]);
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

function BuildGridMenuEx(AOwner: TComponent; XmlNd: IXMLNode; Gr: TUniDBGrid)
  : TUniPopupMenu;
var
  PopMenu: TUniPopupMenu;
  Item: TUniMenuItem;
  I: integer;
  LinkId: string;
  Lb: TUniLabel;
begin
  DebugMsg('BuildGridMenuEx()');
  PopMenu := TUniPopupMenu.Create(AOwner);
  with PopMenu do
  begin
    PopMenu.Name := Gr.Name + '_POPUP';
    LinkId := '';
    if not VarIsNull(XmlNd.Attributes['LINKID']) then
      LinkId := XmlNd.Attributes['LINKID'];
    for I := 0 to XmlNd.ChildNodes.Count - 1 do
    begin
      if XmlNd.ChildNodes[I].NodeName = 'MenuItemEx' then
      begin
        Item := TUniMenuItem.Create(PopMenu);
        if not VarIsNull(XmlNd.ChildNodes[I].Attributes['NLS_INAME']) then
        begin
          if not VarIsNull(XmlNd.ChildNodes[I].Attributes['ID']) then
            Item.Name := GetOwnerName(AOwner) + '_' + XmlNd.ChildNodes[I]
              .Attributes['ID']
          else
            Item.Name := GetOwnerName(AOwner) + '_' +
              SplitString(XmlNd.ChildNodes[I].Attributes['NLS_INAME'], '.')[1];

          Lb := TUniLabel.Create(AOwner);
          Lb.Name := Item.Name + '_ACTION';

          if not VarIsNull(XmlNd.ChildNodes[I].Attributes['ONCLICK']) then
            Lb.Caption := 'ONCLICK:' + XmlNd.ChildNodes[I].Attributes
              ['ONCLICK'];

          if not VarIsNull(XmlNd.ChildNodes[I].Attributes['LINKID']) then
            Lb.Caption := Lb.Caption + '|LINKID:' + XmlNd.ChildNodes[I]
              .Attributes['LINKID'];

          Lb.Visible := False;

        end;
        if not VarIsNull(XmlNd.ChildNodes[I].Attributes['INAME']) then
          Item.Caption := XmlNd.ChildNodes[I].Attributes['INAME'];
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
      QuotedStr('y=') + ' + e.offsetY,' + QuotedStr('Pop=' + PopMenu.Name) + ','
      + QuotedStr('grid=' + Gr.Name) + ',' + QuotedStr('linkid=' + LinkId) +
      ']);    } ' + '} ' + ') }';

    DebugMsg('afterrender:[' + Gr.ClientEvents.ExtEvents.Values
      ['afterrender'] + ']');
  end;

  Result := PopMenu;

end;

function BuildExpGrid(AOwner: TComponent; XmlNd: IXMLNode): TUniDBGrid;
var
  Gr: TUniDBGrid;
  I, J: integer;
  TmpDs: TDataSource;
  BColFound: boolean;
  FromName, SVar1, SVar2: String;
  Mm, Mm2: TUniMemo;
begin
  DebugMsg('BuildExpGrid()');
  Gr := TUniDBGrid.Create(AOwner);
  with Gr do
  begin
    Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];
    WebOptions.Paged := False;
    if not VarIsNull(XmlNd.Attributes['ALIGN']) then
    begin
      if UpperCase(XmlNd.Attributes['ALIGN']) = 'CLIENT' then
        Gr.Align := alClient
      else if UpperCase(XmlNd.Attributes['ALIGN']) = 'LEFT' then
        Gr.Align := alLeft
      else
        Gr.Align := alNone
    end;

    Gr.Options := [dgTitles, dgIndicator, dgColumnResize, dgColLines,
      dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete,
      dgAutoRefreshRow, dgColumnMove];
    Gr.WebOptions.FetchAll := True;
    Gr.WebOptions.Paged := False;
//    Gr.OnColumnResize := MainForm.GrdColumnResize;
//    Gr.OnColumnMove := MainForm.GridColumnMove;

    Mm := TUniMemo.Create(AOwner);
    Mm.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'] + '_COLUMN';
    for I := 0 to XmlNd.ChildNodes.Count - 1 do
    begin
      if XmlNd.ChildNodes[I].NodeName = 'Column' then
      begin
        Mm.Lines.Add(XmlNd.ChildNodes[I].Xml);
      end;
    end;
    Mm2 := TUniMemo.Create(AOwner);
    Mm2.Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'] +
      '_KEYFIELD';
    if not VarIsNull(XmlNd.Attributes['KEYFIELD']) then
      Mm2.Lines.Add(UpperCase(XmlNd.Attributes['KEYFIELD']));
    if not VarIsNull(XmlNd.Attributes['ONKEYENTER']) then
      Gr.OnKeyDown := MainForm.DBGridKeyDownEnter;

    FromName := AOwner.Name;
    if UpperCase(AOwner.Name) = 'MAINFORM' then
      FromName := MainForm.ActiveFormName;

    for I := 0 to AOwner.ComponentCount - 1 do
      if AOwner.Components[I] is TDataSource then
      begin
        TmpDs := TDataSource(AOwner.Components[I]);
        if UpperCase(TmpDs.Name) = 'DS_' + UpperCase(FromName) + '_' +
          UpperCase(XmlNd.Attributes['LINKID']) then
        begin
          DebugMsg('4610 KETEMU [' + TmpDs.Name + ']');
          Gr.DataSource := TmpDs;
          break;
        end;
      end;

//    for I := 0 to Columns.Count - 1 do
//    begin
//      Columns[I].Visible := False;
//      Columns[I].Menu.MenuEnabled := False;
//
//      BColFound := False;
//      for J := 0 to XmlNd.ChildNodes.Count - 1 do
//      begin
//        if XmlNd.ChildNodes[J].NodeName = 'Column' then
//        begin
//          if UpperCase(XmlNd.ChildNodes[J].Attributes['NAME']) = Gr.Columns[I].FieldName
//          then
//          begin
//            BColFound := True;
//            try
//              if not VarIsNull(XmlNd.ChildNodes[J].Attributes['CAPTION']) then
//                Gr.Columns[I].Title.Caption := XmlNd.ChildNodes[J].Attributes
//                  ['CAPTION'];
//
//              Gr.Columns[I].Visible := False;
//              if not VarIsNull(XmlNd.ChildNodes[J].Attributes['VISIBLE']) then
//                if XmlNd.ChildNodes[J].Attributes['VISIBLE'] = 'Y' then
//                  Gr.Columns[I].Visible := True
//                else
//                  Gr.Columns[I].Visible := False;
//
//              if not VarIsNull(XmlNd.ChildNodes[J].Attributes['WIDTH']) then
//                Gr.Columns[I].Width :=
//                  StrToInt(XmlNd.ChildNodes[J].Attributes['WIDTH']);
//
//              if not VarIsNull(XmlNd.ChildNodes[J].Attributes['COMMENTCOLUMN'])
//              then
//                Gr.Columns[I].DisplayMemo := True;
//
//            except
//              on E: Exception do
//                DebugMsg('Warning - kesalahan seting colum properti [' +
//                  E.Message + ']');
//            end;
//          end;
//        end;
//      end;
//      if not BColFound then
//        Gr.Columns[I].Visible := False;
//    end;

//    // HARCODE:
//    // Display harcode column
//    if Name = 'fr5120_PopHistory_GR1' then
//    begin
//      for I := 0 to Gr.Columns.Count - 1 do
//      begin
//        if MatchStr(Gr.Columns[I].FieldName, ['KONTRDATE', 'KONTRUSER',
//          'AKTIONS_TEXT']) then
//        begin
//          Columns[I].Visible := True;
//          if Columns[I].FieldName = 'KONTRDATE' then
//            Columns[I].Width := 130;
//          if Columns[I].FieldName = 'AKTIONS_TEXT' then
//            Columns[I].Width := 395;
//        end;
//      end;
//    end;
    // Context Menu
    for J := 0 to XmlNd.ChildNodes.Count - 1 do
    begin
      if XmlNd.ChildNodes[J].NodeName = 'MenuEx' then
      begin
        BuildGridMenuEx(AOwner, XmlNd.ChildNodes[J], Gr);
      end;
    end;
//
//    // Tool tips
//    // HARCODE
//    if Gr.Name = 'fr5120_grAnalytComments' then
//    begin
//      Gr.ClientEvents.ExtEvents.Values['viewready'] :=
//        'function viewready(sender, eOpts) { ' +
//        '   var tm = new Ext.util.TextMetrics();' +
//        '   sender.view.tip = Ext.create("Ext.tip.ToolTip", {' +
//        '       target: sender.view.el,' +
//        '       delegate: sender.view.cellSelector,' +
//        '       trackMouse: true,' + '       renderTo: Ext.getBody(), ' +
//        '       listeners: {' +
//        '           beforeshow: function updateTipBody(tip) {' +
//        '               gridColums = sender.view.getGridColumns();' +
//        '               column = gridColums[tip.triggerElement.cellIndex]; ' +
//        '               record = sender.view.getRecord(tip.triggerElement.parentNode); '
//        + ' if(column.dataIndex == "6"){ tip.update(record.data[parseInt(column.dataIndex)]); } else { return false; }'
//        + '           }' + '       }' + '   });' + ' }';
//    end;
//
//    if Gr.Name = 'fr5120_grResult' then
//      Gr.ClientEvents.ExtEvents.Values['store.load'] :=
//        'function store.load(sender, records, successful, operation, eOpts) ' +
//        '{ ' + 'sender.grid.getColumns()[' + GetGridColRegVal(Gr,
//        'HASREFRANGEINFORMATION', 'Index') +
//        '].renderer = function (value,metadata,record) { ' +
//        'metadata.tdAttr = ' + QuotedStr('data-qclass="dvQtip" data-qtip="') +
//        '+record.get(' + GetGridColRegVal(Gr, 'REF_RANGE_INFORMATION', 'Index')
//        + ')+' + QuotedStr('"') + '; ' +
//        'return new Ext.ux.CheckColumn().renderer(value);} ' +
//        '; sender.grid.getColumns()[' + GetGridColRegVal(Gr, 'KOMMENTAR',
//        'Index') + '].renderer = function (value,metadata,record) { ' +
//        'metadata.tdAttr = ' + QuotedStr('data-qclass="dvQtip" data-qtip="') +
//        '+record.get(' + GetGridColRegVal(Gr, 'COMMENTHINT', 'Index') + ')+' +
//        QuotedStr('"') + '; ' +
//        'return new Ext.ux.CheckColumn().renderer(value);} ' + ' }';
//
//    if (UpperCase(Name) <> 'POPANALYTCOMMENT_GRDRESCOMMENTS') and
//      (UpperCase(Name) <> 'POPANALYTCOMMENT_GRDCOMMENTS') then
//      OnDrawColumnCell := MainForm.GridDrawColumnCell;
    Visible := True;
  end;

  Result := Gr;
end;

function BuildSplitterEx(AOwner: TComponent; XmlNd: IXMLNode): TUniSplitter;
var
  Sp: TUniSplitter;
begin
  DebugMsg('BuildSplitterEx()');
  Sp := TUniSplitter.Create(AOwner);
  with Sp do
  begin
    Align := alTop;
  end;
  Result := Sp;
end;

function BuildButton(AOwner: TComponent; XmlNd: IXMLNode): TUniButton;
var
  Bt: TUniButton;
  Mm: TUniMemo;
begin
  DebugMsg('BuildButton()');
  Bt := TUniButton.Create(AOwner);
  with Bt do
  begin
    if not VarIsNull(XmlNd.Attributes['ID']) then
      Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID']
    else if MainForm.FNameIndex < MainForm.FNameList.Count then
    begin
      Name := MainForm.FNameList.Strings[MainForm.FNameIndex];
      inc(MainForm.FNameIndex);
    end;

    if not VarIsNull(XmlNd.Attributes['CAPTION']) then
      Caption := XmlNd.Attributes['CAPTION'];

    if not VarIsNull(XmlNd.Attributes['TOP']) then
      Top := XmlNd.Attributes['TOP'];

    if not VarIsNull(XmlNd.Attributes['LEFT']) then
      left := StrToInt(XmlNd.Attributes['LEFT']);

    if not VarIsNull(XmlNd.Attributes['WIDTH']) then
      Width := StrToInt(XmlNd.Attributes['WIDTH']);

    if not VarIsNull(XmlNd.Attributes['ALIGNMENT']) then
      if XmlNd.Attributes['ALIGNMENT'] = 'Left' then
        Alignment := taLeftJustify;

    if XmlNd.Attributes['ALIGNMENT'] = 'Right' then
      Alignment := taRightJustify;

    if not VarIsNull(XmlNd.Attributes['HINT']) then
    begin
      Hint := XmlNd.Attributes['HINT'];
      ShowHint := True;
    end;

    if not VarIsNull(XmlNd.Attributes['ENABLE']) then
    begin
      if XmlNd.Attributes['ENABLE'] = 'Y' then
        Enabled := True
      Else
        Enabled := False;
    end;

    Mm := TUniMemo.Create(AOwner);
    Mm.Name := Bt.Name + '_ONCLICK';

    if not VarIsNull(XmlNd.Attributes['ONCLICK']) then
    begin
      Mm.Lines.Text := XmlNd.Attributes['ONCLICK'];
      Bt.OnClick := MainForm.ActBtnClickExecute;
    end;
  end;

  Result := Bt;
end;

function BuildMemo(AOwner: TComponent; XmlNd: IXMLNode): TUniMemo;
var
  Mm: TUniMemo;
  CutOff: integer;
begin
  DebugMsg('BuildMemo()');
  CutOff := 90;
  Mm := TUniMemo.Create(AOwner);
  with Mm do
  begin
    Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];
    FieldLabel := XmlNd.Attributes['CAPTION'];
    FieldLabelAlign := laRight;
    FieldLabelWidth := CutOff + length(XmlNd.Attributes['CAPTION']);
    if not VarIsNull(XmlNd.Attributes['TOP']) then
      Top := XmlNd.Attributes['TOP'];
    if not VarIsNull(XmlNd.Attributes['HEIGHT']) then
      Height := XmlNd.Attributes['HEIGHT'];
    if not VarIsNull(XmlNd.Attributes['LEFT']) then
      left := StrToInt(XmlNd.Attributes['LEFT']) - Mm.FieldLabelWidth;
    if not VarIsNull(XmlNd.Attributes['WIDTH']) then
      Width := StrToInt(XmlNd.Attributes['WIDTH']) + Mm.FieldLabelWidth;
    if not VarIsNull(XmlNd.Attributes['ALIGNMENT']) then
      if XmlNd.Attributes['ALIGNMENT'] = 'Left' then
        Alignment := taLeftJustify
      else if XmlNd.Attributes['ALIGNMENT'] = 'Right' then
        Alignment := taRightJustify;

    if not VarIsNull(XmlNd.Attributes['ENABLE']) then
      if XmlNd.Attributes['ENABLE'] = 'Y' then
        Enabled := True
      Else
        Enabled := False;

    if not VarIsNull(XmlNd.Attributes['VISIBLE']) then
      if XmlNd.Attributes['VISIBLE'] = 'N' then
        Visible := False;

    if not VarIsNull(XmlNd.Attributes['FOCUS']) and
      (XmlNd.Attributes['FOCUS'] = 'Y') then
      SetFocus;
  end;
  Result := Mm;
end;

function BuildLookup(AOwner: TComponent; XmlNd: IXMLNode): TUniDBLookupComboBox;
var
  Lcb: TUniDBLookupComboBox;
  CutOff, I: integer;
  TmpDs: TDataSource;
begin
  DebugMsg('BuildLookup()');
  CutOff := 80;
  if length(XmlNd.Attributes['CAPTION']) <= 5 then
    CutOff := 30;
  if length(XmlNd.Attributes['CAPTION']) > 10 then
    CutOff := 90;

  Lcb := TUniDBLookupComboBox.Create(AOwner);
  With Lcb do
  begin
    Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];
    Caption := XmlNd.Attributes['CAPTION'];
    FieldLabel := XmlNd.Attributes['CAPTION'];
    FieldLabelWidth := CutOff;
    FieldLabelAlign := laRight;
    if not VarIsNull(XmlNd.Attributes['TOP']) then
      Top := XmlNd.Attributes['TOP'];
    if not VarIsNull(XmlNd.Attributes['LEFT']) then
      left := StrToInt(XmlNd.Attributes['LEFT']) - CutOff;
    if not VarIsNull(XmlNd.Attributes['WIDTH']) then
      Width := StrToInt(XmlNd.Attributes['WIDTH']) + CutOff - 10;
    if not VarIsNull(XmlNd.Attributes['ALIGNMENT']) then
      if XmlNd.Attributes['ALIGNMENT'] = 'Left' then
        Alignment := taLeftJustify;
    if XmlNd.Attributes['ALIGNMENT'] = 'Right' then
      Alignment := taRightJustify;
    if not VarIsNull(XmlNd.Attributes['ENABLE']) then
    begin
      if XmlNd.Attributes['ENABLE'] = 'Y' then
        Enabled := True
      Else
        Enabled := False;
    end;

    if not VarIsNull(XmlNd.Attributes['VISIBLE']) then
      if XmlNd.Attributes['VISIBLE'] = 'N' then
        Lcb.Visible := False;
    if not VarIsNull(XmlNd.Attributes['DKEY']) then
      Lcb.KeyField := SplitString(XmlNd.Attributes['DKEY'], ',')[0];

    for I := 0 to AOwner.ComponentCount - 1 do
      if AOwner.Components[I] is TDataSource then
      begin
        TmpDs := TDataSource(AOwner.Components[I]);
        if UpperCase(TmpDs.Name) = 'DS_' + UpperCase(GetOwnerName(AOwner)) + '_'
          + UpperCase(XmlNd.Attributes['LOOKID']) then
        begin
          DebugMsg('KETEMU [' + TmpDs.Name + ']');
          Lcb.ListSource := TmpDs;
        end;
      end;
  end;

  Result := Lcb;
end;

function BuildCheck(AOwner: TComponent; XmlNd: IXMLNode): TUniCheckBox;
var
  Cb: TUniCheckBox;
  CutOff: integer;
begin
  CutOff := 0;
  if not VarIsNull(XmlNd.Attributes['CAPTION']) then
    if XmlNd.Attributes['CAPTION'] <> '' then
      if length(XmlNd.Attributes['CAPTION']) > 20 then
        CutOff := 180
      else
        CutOff := 90;

  Cb := TUniCheckBox.Create(AOwner);
  with Cb do
  begin
    Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];
    if not VarIsNull(XmlNd.Attributes['LABEL']) then
      Caption := XmlNd.Attributes['LABEL'];

    if not VarIsNull(XmlNd.Attributes['TOP']) then
      Top := XmlNd.Attributes['TOP'];
    if not VarIsNull(XmlNd.Attributes['LEFT']) then
      left := StrToInt(XmlNd.Attributes['LEFT']);
    if not VarIsNull(XmlNd.Attributes['WIDTH']) then
      Width := StrToInt(XmlNd.Attributes['WIDTH']);

    if not VarIsNull(XmlNd.Attributes['CAPTION']) then
    begin
      FieldLabel := XmlNd.Attributes['CAPTION'];
      FieldLabelWidth := CutOff;
      FieldLabelAlign := laRight;
      if FieldLabel <> '' then
        left := left - CutOff + 3
      else
        left := left + 8;
    end;

    if not VarIsNull(XmlNd.Attributes['ENABLE']) then
    begin
      if XmlNd.Attributes['ENABLE'] = 'Y' then
        Enabled := True
      Else
        Enabled := False;
    end;

    if not VarIsNull(XmlNd.Attributes['VISIBLE']) then
      if XmlNd.Attributes['VISIBLE'] = 'N' then
      begin
        DebugMsg('CheckBox visible=False');
        Visible := False;
      end;
  end;

  Result := Cb;
end;

function BuildLabel(AOwner: TComponent; XmlNd: IXMLNode): TUniLabel;
var
  Lb: TUniLabel;
  ValName, SVar1, SVar2: String;
  TmpStr: TStringDynArray;
  I: integer;
begin
  DebugMsg('BuildLabel()');

  Lb := TUniLabel.Create(AOwner);
  with Lb do
  begin
    Alignment := taRightJustify;

    if not VarIsNull(XmlNd.Attributes['ID']) then
    begin
      DebugMsg('5039 ID :' + XmlNd.Attributes['ID']);
      if GetCompByName(AOwner, XmlNd.Attributes['ID']) = '' then
        Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];
    end;
    Caption := XmlNd.Attributes['CAPTION'];

    if not VarIsNull(XmlNd.Attributes['LEFT']) then
      left := StrToInt(XmlNd.Attributes['LEFT']);

    if ContainsText(UpperCase(Lb.Caption), '$') then
    begin
      ValName := XmlNd.Attributes['CAPTION'];
      // TODO: HARDCODE
      if (ValName = 'Order ;$auftnr; for Patient ;$patient;') or
        (ValName = '$frmName;') then
      begin
        //
        Caption := ''; // kosongkan dulu
      end
      else
      begin
        // isi variabel
        ValName := StringReplace(ValName, '$', '',
          [rfReplaceAll, rfIgnoreCase]);
        Caption := '';
        if Trim(GetCompByName(AOwner, 'LBL_' + ValName)) = '' then
          Name := GetOwnerName(AOwner) + '_LBL_' + ValName;
        Caption := Name;
        Caption := '';
        // isi dengan variabel
        Lb.Caption := GetVarValue(AOwner, ValName);

        Lb.left := Lb.left + 8;
      end;
    end;

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

    if not VarIsNull(XmlNd.Attributes['TOP']) then
      Lb.Top := XmlNd.Attributes['TOP'];

    if not VarIsNull(XmlNd.Attributes['WIDTH']) then
      Lb.Width := StrToInt(XmlNd.Attributes['WIDTH']);

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
  end;
  Result := Lb;
end;

function BuildGroupBox(AOwner: TComponent; XmlNd: IXMLNode): TUniGroupBox;
var
  Gb: TUniGroupBox;
  I: integer;
begin
  DebugMsg('BuildGroupBox()');
  Gb := TUniGroupBox.Create(AOwner);
  with Gb do
  begin
    if not VarIsNull(XmlNd.Attributes['ID']) then
      Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];
    if not VarIsNull(XmlNd.Attributes['TOP']) then
      Gb.Top := XmlNd.Attributes['TOP'] + 5;
    if not VarIsNull(XmlNd.Attributes['LEFT']) then
      Gb.left := XmlNd.Attributes['LEFT'] - 5;
    if not VarIsNull(XmlNd.Attributes['HEIGHT']) then
      Gb.Height := XmlNd.Attributes['HEIGHT'];
    if not VarIsNull(XmlNd.Attributes['WIDTH']) then
      Gb.Width := XmlNd.Attributes['WIDTH'];
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
    if not VarIsNull(XmlNd.Attributes['CAPTION']) then
      Gb.Caption := XmlNd.Attributes['CAPTION'];

    for I := 0 to XmlNd.ChildNodes.Count - 1 do
    begin
      if XmlNd.ChildNodes[I].NodeName = 'Label' then
        Gb.InsertControl(BuildLabel(AOwner, XmlNd.ChildNodes[I]));
      if XmlNd.ChildNodes[I].NodeName = 'Check' then
        Gb.InsertControl(BuildCheck(AOwner, XmlNd.ChildNodes[I]));
      if XmlNd.ChildNodes[I].NodeName = 'Lookup' then
        Gb.InsertControl(BuildLookup(AOwner, XmlNd.ChildNodes[I]));
      if XmlNd.ChildNodes[I].NodeName = 'Memo' then
        Gb.InsertControl(BuildMemo(AOwner, XmlNd.ChildNodes[I]));
      if XmlNd.ChildNodes[I].NodeName = 'Button' then
        Gb.InsertControl(BuildButton(AOwner, XmlNd.ChildNodes[I]));
    end;

  end;

  Result := Gb;
end;

function BuildPanelEx(AOwner: TComponent; XmlNd: IXMLNode): TUniPanel;
var
  Pn: TUniPanel;
  I: integer;
begin
  DebugMsg('BuildPanelEx()');
  DebugMsg(XmlNd.Xml);
  Pn := TUniPanel.Create(AOwner);
  with Pn do
  begin
    if not VarIsNull(XmlNd.Attributes['ID']) then
      Name := GetOwnerName(AOwner) + '_' + XmlNd.Attributes['ID'];
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

    if not VarIsNull(XmlNd.Attributes['SCROLL']) then
      if XmlNd.Attributes['SCROLL'] = 'Y' then
        AutoScroll := True;

    for I := 0 to XmlNd.ChildNodes.Count - 1 do
    begin
      if XmlNd.ChildNodes[I].NodeName = 'GroupBox' then
        Pn.InsertControl(BuildGroupBox(AOwner, XmlNd.ChildNodes[I]));
      if XmlNd.ChildNodes[I].NodeName = 'ExpGrid' then
        Pn.InsertControl(BuildExpGrid(AOwner, XmlNd.ChildNodes[I]));
    end;

    // Pn.BorderStyle := ubsNone;
  end;

  Result := Pn;
end;

procedure BuildView(AOwner: TComponent; XmlNode: IXMLNode);
var
  I: integer;
  Gb: TUniGroupBox;
begin
  for I := 0 to XmlNode.ChildNodes.Count - 1 do
  begin
    DebugMsg(XmlNode.ChildNodes[I].NodeName);
    if XmlNode.ChildNodes[I].NodeName = 'Variable' then
      TUniForm(AOwner).InsertControl(BuildVariable(AOwner,
        XmlNode.ChildNodes[I]));
    if XmlNode.ChildNodes[I].NodeName = 'QueryEx' then
      BuildQueryEx(AOwner, XmlNode.ChildNodes[I]);
    if XmlNode.ChildNodes[I].NodeName = 'PanelEx' then
      TUniForm(AOwner).InsertControl(BuildPanelEx(AOwner,
        XmlNode.ChildNodes[I]));
    if XmlNode.ChildNodes[I].NodeName = 'SplitterEx' then
      TUniForm(AOwner).InsertControl(BuildSplitterEx(AOwner,
        XmlNode.ChildNodes[I]));

    // if XmlNode.ChildNodes[I].NodeName = 'PopupEx' then
    // begin
    // if not VarIsNull(XmlNode.ChildNodes[I]) then
    // begin
    // BuildPopupEx(AOwner, XmlNode.ChildNodes[I], AOwner.Name);
    // end;
    // end;
    // if XmlNode.ChildNodes[I].NodeName = 'ScriptEx' then
    // begin
    // if not VarIsNull(XmlNode.ChildNodes[I]) then
    // begin
    // BuildScriptEx(AOwner, XmlNode.ChildNodes[I], AOwner.Name);
    // end;
    // end;
    // if XmlNode.ChildNodes[I].NodeName = 'Variable' then
    // begin
    // BuildVariable(AOwner, XmlNode.ChildNodes[I], AOwner.Name);
    // end;
    // if XmlNode.ChildNodes[I].NodeName = 'QueryEx' then
    // begin
    // BuildQuery(AOwner, XmlNode.ChildNodes[I], AOwner.Name);
    // end;
    // if XmlNode.ChildNodes[I].NodeName = 'MsgDialog' then
    // begin
    // BuildMsgDialog(AOwner, XmlNode.ChildNodes[I], AOwner.Name);
    // end;
    // if XmlNode.ChildNodes[I].NodeName = 'PanelEx' then
    // begin
    // TUniForm(AOwner).InsertControl(BuildPanel(AOwner, XmlNode.ChildNodes[I]));
    // end;
    // if XmlNode.ChildNodes[I].NodeName = 'GroupBox' then
    // begin
    // Gb := BuildGroupBox(AOwner, XmlNode.ChildNodes[I]);
    // // Gb.Parent := TComponent(AOwner);
    // end;
    // if XmlNode.ChildNodes[I].NodeName = 'Combo' then
    // begin
    // TUniForm(AOwner).InsertControl(BuildCombo(AOwner, XmlNode.ChildNodes[I]));
    // end;
  end;
end;

end.

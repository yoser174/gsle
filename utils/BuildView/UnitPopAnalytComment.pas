unit UnitPopAnalytComment;

interface

uses System.Classes, System.SysUtils, FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Data.DB;

procedure BtnOKClick(Sender: TObject);
procedure RunOnShowF01(Sender: TObject);
procedure QFixedTextAfterScroll(DataSet: TDataSet);

implementation

uses Main, MainModule, UniLabel, UniMemo, UnitComp, UniDBLookupComboBox,
  UniCheckBox, UniDBGrid, UniGUIFrame, uniGUITypes, UnitCommons;


// if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_text', TComponent(Comp))
// then
// TUniMemo(Comp).Lines.Add(ClassName);

// for I := 0 to ParamCount - 1 do
// if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_text', TComponent(Comp))
// then
// TUniMemo(Comp).Lines.Add(Params[I].Name);

procedure QCreateFreeTextExec(Sender: TObject);
var
  Comp: TComponent;
  Q: TFDStoredProc;
  I: integer;
begin
  Q := TFDStoredProc.Create(TComponent(Sender));
  with Q do
  begin
    Connection := UniMainModule.FDConn;
    PackageName := 'datos_prj.comment_package';
    StoredProcName := 'createcomment';
    Prepare;

    ParamByName('PTEXT').Value := GetCompTextObj(TComponent(Sender),
      'POPANALYTCOMMENT_text');
    ParamByName('PKEY1').Value := GetCompVarObj(TComponent(Sender),
      'POPANALYTCOMMENT_SEQNR');
    ParamByName('PTYPE').Value := GetCompVarObj(TComponent(Sender),
      'POPANALYTCOMMENT_TYPE');
    ParamByName('PKEY2').Value := GetCompVarObj(TComponent(Sender),
      'POPANALYTCOMMENT_ANALYTNR');
    ParamByName('PTEXTKEY').Clear;
    ParamByName('PTEXTCODE').Clear;
    ParamByName('PLOCATION').Value := GetCompVarObj(TComponent(Sender),
      'POPANALYTCOMMENT_MANDANT');
    ParamByName('PFIELDID').Clear;
    ParamByName('PINTERNAL').Value := '0';
    if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_CHINTERNALCOMMENT',
      TComponent(Comp)) then
      if TUniCheckBox(Comp).Checked then
        ParamByName('PINTERNAL').Value := '1';
    ParamByName('PSPECCD').Clear;
    ParamByName('PRIGHTCHECKDONE').Value := 'YES';
    ParamByName('PREFOBJECT').Clear;
    ParamByName('PREFOBJECT_SEQNR').Clear;
    ParamByName('PFREETEXT_SEQNR').Clear;
    ParamByName('PUSER').Clear;

    Execute;
  end;
end;

procedure QuCreateResultCommentFreeExec(Sender: TObject);
var
  Comp: TComponent;
  Q: TFDStoredProc;
  I: integer;
begin
  Q := TFDStoredProc.Create(TComponent(Sender));
  with Q do
  begin
    Connection := UniMainModule.FDConn;
    PackageName := 'datos_prj.lis_results_package';
    StoredProcName := 'createResultComment';
    Prepare;

    ParamByName('RESULT').Clear;
    ParamByName('PRESULTSEQNR').Value := GetCompVarObj(TComponent(Sender),
      'POPANALYTCOMMENT_RESULT_SEQNR');
    ParamByName('PTEXTCODE').Clear;
    ParamByName('PTEXT').Value := GetCompTextObj(TComponent(Sender),
      'POPANALYTCOMMENT_text');
    ParamByName('PLOCATION').Value := GetCompVarObj(TComponent(Sender),
      'POPANALYTCOMMENT_MANDANT');
    ParamByName('PRIGHTCHECKDONE').Value := 'YES';
    ParamByName('PINTERNAL').Value := '0';
    if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_CHINTERNALCOMMENT',
      TComponent(Comp)) then
      if TUniCheckBox(Comp).Checked then
        ParamByName('PINTERNAL').Value := '1';
    ParamByName('PUSER').Clear;

    Execute;
  end;
end;

procedure QFreeTextForSpecimenExec(Sender: TObject);
var
  Comp: TComponent;
  Q: TFDStoredProc;
  I: integer;
begin
  if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_QFREETEXTFORSPECIMEN',
    TComponent(Q)) then
  begin
    TFDStoredProc(Q).Active := False;
    TFDStoredProc(Q).Prepare;

    TFDStoredProc(Q).ParamByName('PTEXT').Value :=
      GetCompTextObj(TComponent(Sender), 'POPANALYTCOMMENT_text');
    TFDStoredProc(Q).ParamByName('PKEY1').Value :=
      GetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_SEQNR');
    TFDStoredProc(Q).ParamByName('PTYPE').Value :=
      GetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_TYPE');
    TFDStoredProc(Q).ParamByName('PKEY2').Value :=
      GetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_ANALYTNR');
    TFDStoredProc(Q).ParamByName('PTEXTKEY').Clear;
    TFDStoredProc(Q).ParamByName('PLOCATION').Value :=
      GetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_MANDANT');
    TFDStoredProc(Q).ParamByName('PFIELDID').Clear;
    TFDStoredProc(Q).ParamByName('PINTERNAL').Value := '0';
    if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_CHINTERNALCOMMENT',
      TComponent(Comp)) then
      if TUniCheckBox(Comp).Checked then
        TFDStoredProc(Q).ParamByName('PINTERNAL').Value := '1';

    TFDStoredProc(Q).ParamByName('PSPECCD').Value :=
      GetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_VSPECCD');
    TFDStoredProc(Q).ParamByName('PTEXTCODE').Clear;
    TFDStoredProc(Q).ParamByName('PRIGHTCHECKDONE').Value := 'YES';

    TFDStoredProc(Q).Execute();
  end;
end;

procedure ScOnFreeTextRun(Sender: TObject);
var
  Comp: TComponent;
begin
  (*
    if(GV01.Value == 'INS')
    {
    if(CHSPEZIMEN.Value == '1')
    {
    RUN('qFreeTextForSpecimen.execute');
    }
    else
    {
    if(TYPE.Value == 'Z')
    {
    RUN('QUCREATERESULTCOMMENTFREE.Execute');
    }
    else
    {
    RUN('qCreateFreeText.execute');
    }
    }
    }
    else
    {
    if(TYPE.Value == 'Z')
    {
    RUN('GRDRESCOMMENTS.Select(vTempKey)');
    RUN('qUpdFreetextRES.execute');
    }
    else
    {
    RUN('GRDCOMMENTS.Select(vTempKey)');
    if(VSPECCOMMENTID.Value)
    {
    RUN('msSpecCommentAendern.execute');
    }
    else
    {
    RUN('qUpdFreetext.execute');
    }
    }
    }
  *)

  if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_GV01', TComponent(Comp))
  then
    if TUniLabel(Comp).Caption = 'INS' then
    begin
      if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_GV01', TComponent(Comp))
      then
        if TUniLabel(Comp).Caption = 'INS' then
        begin
          if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_CHSPEZIMEN',
            TComponent(Comp)) then
            if TUniCheckBox(Comp).Checked then
              QFreeTextForSpecimenExec(Sender)
            else
            begin
              if GetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_TYPE') = 'Z'
              then
                QuCreateResultCommentFreeExec(Sender)
              else
                QCreateFreeTextExec(Sender);
            end;
        end;
    end
    else
    begin
      if GetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_TYPE') = 'Z' then
      begin
        if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_GRDRESCOMMENTS',
          TComponent(Comp)) then
          SetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_VTEMPKEY',
            TUniDBGrid(Comp).DataSource.DataSet.FieldByName('COMMENT_ID')
            .AsString);
            // continue
             RUN('qUpdFreetextRES.execute');
      end
      else
      begin
      end;
    end;

end;

procedure ScMussfelderRun(Sender: TObject);
var
  Comp: TComponent;
begin
  (*
    VMUSSFELDPRUEFUNG.Value = 0;
    if(VMUSSFELDPRUEFUNG.Value == 0)
    {
    if(!TEXT.Value)
    {
    VMUSSFELDPRUEFUNG.Value = 1;
    VMUSSFELD.Value = VDEF1.value;
    RUN('msMussfeld.execute');
    RUN('text.SetFocus');
    }
    }
    VRETSPEICHERN.Value = VMUSSFELDPRUEFUNG.Value;
  *)

  if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_VMUSSFELDPRUEFUNG',
    TComponent(Comp)) then
    TUniLabel(Comp).Caption := '0';
  if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_VMUSSFELDPRUEFUNG',
    TComponent(Comp)) then
    if TUniLabel(Comp).Caption = '0' then
    begin
      if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_text', TComponent(Comp))
      then
        if TUniMemo(Comp).Lines.Text = '' then
        begin
          if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_VMUSSFELDPRUEFUNG',
            TComponent(Comp)) then
            TUniLabel(Comp).Caption := '1';

          if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_VMUSSFELD',
            TComponent(Comp)) then
            TUniLabel(Comp).Caption := GetCompVarObj(TComponent(Sender),
              'POPANALYTCOMMENT_VDEF1');
          MainForm.MessageDlg('An entry in the field &lt;' +
            GetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_VMUSSFELD') +
            '&gt; is required.', mtError, [mbOK]);
          if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_text',
            TComponent(Comp)) then
            TUniMemo(Comp).SetFocus;
        end;
    end;
  if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_VRETSPEICHERN',
    TComponent(Comp)) then
    TUniLabel(Comp).Caption := GetCompVarObj(TComponent(Sender),
      'POPANALYTCOMMENT_VMUSSFELDPRUEFUNG');

end;

procedure ScSpeichernRun(Sender: TObject);
var
  Comp: TComponent;
begin
  (*
    if (VACTIVE.Value == 'J')
    {
    RUN('scMussfelder.RunScript');
    if(VRETSPEICHERN.Value == 0)
    {
    if(VFIXEDTEXT.Value != 1)
    {
    RUN('scOnFreeText.RunScript');
    }
    else
    {
    RUN('scOnFixedText.RunScript');
    }
    }
    }
    else
    {
    MSGINACTIVEORDER.Execute();
    }
  *)

  if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_VACTIVE', TComponent(Comp))
  then
    if TUniLabel(Comp).Caption = 'J' then
    begin
      ScMussfelderRun(Sender);
      if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_VRETSPEICHERN',
        TComponent(Comp)) then
        if TUniLabel(Comp).Caption = '0' then
        begin
          if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_VFIXEDTEXT',
            TComponent(Comp)) then
            if TUniLabel(Comp).Caption <> '1' then
            begin
              //
            end
            else
            begin
              //
            end;
        end;
    end;

end;

procedure BtnOKClick(Sender: TObject);
var
  Comp: TComponent;
begin
  (*
    VCLOSE.Set(1);
    RUN('scSpeichern.RunScript');
    if(VRETSPEICHERN.Value == 0)
    {
    if(VCLOSE.Value == '1')
    {
    RUN('F01.Close');
    }
    }
  *)

  if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_VCLOSE', TComponent(Comp))
  then
    TUniLabel(Comp).Caption := '1';
  ScSpeichernRun(Sender);

end;

procedure QFixedTextAfterScroll(DataSet: TDataSet);
begin
  // SetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_VCOMMENT_TEXT1',
  // Q.FieldByName('text').AsString);
  // SetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_VCODE1',
  // Q.FieldByName('code').AsString);
end;

procedure QGetFixedTextExec(Sender: TObject);
var
  Q: TFDQuery;
  Comp: TComponent;
begin
  if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_QGETFIXEDTEXT',
    TComponent(Q)) then
  begin
    with TFDStoredProc(Q) do
    begin
      Active := False;
      Prepare;

      ParamByName('PCONTEXT').Clear;
      ParamByName('PORDERBY').Clear;
      ParamByName('PANALYTGRP').Clear;
      if GetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_VCONTEXT') <> ''
      then
        ParamByName('PCONTEXT').Value := GetCompVarObj(TComponent(Sender),
          'POPANALYTCOMMENT_VCONTEXT');
      ParamByName('PORDERBY').Value := 'text';
      ParamByName('PANALYTGRP').Value := GetCompVarObj(TComponent(Sender),
        'POPANALYTCOMMENT_VANALYTGRP');

      Active := True;

      // AfterScroll := (
      // procedure(DataSet: TDataSet)
      // begin
      // end);
      // begin
      // end;
    end;

  end;

end;

procedure QGetSpecimenExec(Sender: TObject);
var
  Q: TFDQuery;
  Comp: TComponent;
begin
  if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_QGETSPECIMEN', TComponent(Q))
  then
  begin
    with TFDStoredProc(Q) do
    begin
      Active := False;
      Prepare;
      ParamByName('PSPECCD').Value := GetCompVarObj(TComponent(Sender),
        'POPANALYTCOMMENT_VSPECCD');
      Active := True;

      if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_VSPEZIMEN',
        TComponent(Comp)) then
        TUniLabel(Comp).Caption := FieldByName('SPECIMEN').AsString;
    end;

    if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_LBL_VSPEZIMEN',
      TComponent(Comp)) then
      TUniLabel(Comp).Caption := GetCompVarObj(TComponent(Sender),
        'POPANALYTCOMMENT_VSPEZIMEN');
  end;
end;

procedure QGetAnalytExec(Sender: TObject);
var
  Q: TFDQuery;
  Comp: TComponent;
begin
  if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_QGETANALYT', TComponent(Q))
  then
  begin
    with TFDStoredProc(Q) do
    begin
      Active := False;
      Prepare;
      ParamByName('PANALYTNR').Value := GetCompVarObj(TComponent(Sender),
        'POPANALYTCOMMENT_ANALYTNR');
      Active := True;

      if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_VANALYT',
        TComponent(Comp)) then
        TUniLabel(Comp).Caption := FieldByName('NAME').AsString;

      if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_VSPECCD',
        TComponent(Comp)) then
        TUniLabel(Comp).Caption := FieldByName('SPECCD').AsString;

      if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_VANALYTGRP',
        TComponent(Comp)) then
        TUniLabel(Comp).Caption := FieldByName('ANALYTGRP').AsString;

    end;

    if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_LBL_VANALYT',
      TComponent(Comp)) then
      TUniLabel(Comp).Caption := GetCompVarObj(TComponent(Sender),
        'POPANALYTCOMMENT_VANALYT');

    // if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_LBL_VSPEZIMEN',
    // TComponent(Comp)) then
    // TUniLabel(Comp).Caption := GetCompVarObj(TComponent(Sender),
    // 'POPANALYTCOMMENT_VSPECCD');
  end;
end;

procedure QGetCommentExec(Sender: TObject);
var
  Q: TFDQuery;
  I: integer;
  Ds: TDataSource;
  Gr: TUniDBGrid;
begin
  if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_QGETCOMMENTS', TComponent(Q))
  then
  begin
    Ds := TDataSource.Create(TComponent(Sender));
    With Ds do
    Begin
      Ds.DataSet := TFDStoredProc(Q);

      if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_GRDRESCOMMENTS',
        TComponent(Gr)) then
        TUniDBGrid(Gr).DataSource := Ds;
    End;

    TFDStoredProc(Q).Active := False;
    TFDStoredProc(Q).Prepare;
    // clear all
    TFDStoredProc(Q).ParamByName('RESULT').Clear;
    TFDStoredProc(Q).ParamByName('PKEY1').Clear;
    TFDStoredProc(Q).ParamByName('PTYPE').Clear;
    TFDStoredProc(Q).ParamByName('PKEY2').Clear;
    TFDStoredProc(Q).ParamByName('PLOCATION').Clear;
    TFDStoredProc(Q).ParamByName('PFIELDID').Clear;
    TFDStoredProc(Q).ParamByName('PRIGHTCHECKDONE').Clear;
    TFDStoredProc(Q).ParamByName('PSYNCCOMMENTS').Clear;
    TFDStoredProc(Q).ParamByName('PREFOBJECT').Clear;
    TFDStoredProc(Q).ParamByName('PREFOBJECT_SEQNR').Clear;
    TFDStoredProc(Q).ParamByName('PFREETEXT_SEQNR').Clear;

    TFDStoredProc(Q).ParamByName('PKEY1').Value :=
      GetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_SEQNR');
    TFDStoredProc(Q).ParamByName('PKEY2').Value :=
      GetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_ANALYTNR');
    TFDStoredProc(Q).ParamByName('PTYPE').Value :=
      GetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_TYPE');
    TFDStoredProc(Q).ParamByName('PLOCATION').Value :=
      GetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_MANDANT');

    TFDStoredProc(Q).ParamByName('PRIGHTCHECKDONE').Value := 'YES';
    TFDStoredProc(Q).ParamByName('PSYNCCOMMENTS').Value := 'YES';
    TFDStoredProc(Q).ParamByName('PREFOBJECT').Value := '%';
    TFDStoredProc(Q).ParamByName('PREFOBJECT_SEQNR').Value := '%';
    TFDStoredProc(Q).ParamByName('PFREETEXT_SEQNR').Value := '%';

    TFDStoredProc(Q).Active := True;

    // hide all column
    for I := 0 to Gr.Columns.Count - 1 do
    begin
      Gr.Columns[I].Menu.MenuEnabled := False;
      if Gr.Columns[I].FieldName = 'COMMENT_DATE' then
      begin
        Gr.Columns[I].Title.Caption := 'Order date';
        Gr.Columns[I].Index := 1;
        Gr.Columns[I].Width := 200;
      end
      else if Gr.Columns[I].FieldName = 'COMMENT_TEXT' then
      begin
        Gr.Columns[I].Title.Caption := 'Comment';
        Gr.Columns[I].Index := 3;
        Gr.Columns[I].Width := 500;
      end
      // else if Gr.Columns[I].FieldName = 'COMMENT_TEXTCODE' then
      // begin
      // Gr.Columns[I].Title.Caption := 'Code';
      // Gr.Columns[I].Index := 3;
      // Gr.Columns[I].Width := 30;
      // Gr.Columns[I].Visible := False;
      // end
      else if Gr.Columns[I].FieldName = 'COMMENT_INTERNAL' then
      begin
        Gr.Columns[I].Title.Caption := 'Intern';
        Gr.Columns[I].Index := 2;
        Gr.Columns[I].Width := 100;
        Gr.Columns[I].CheckBoxField.DisplayValues := ';';
        Gr.Columns[I].CheckBoxField.FieldValues := '0;1';
        Gr.Columns[I].CheckBoxField.BooleanFieldOnly := False;
        Gr.Columns[I].CheckBoxField.Enabled := True;
      end
      else
        Gr.Columns[I].Visible := False;

    end;

  end;
end;

procedure scClearFields(Sender: TObject);
var
  Comp: TComponent;
begin
  { RUN('Text.Clear');
    RUN('loSearch.Clear');
    RUN('loSearchCode.Clear');
    RUN('chSpezimen.Clear');
    RUN('chInternalComment.Clear');
    VFIXEDTEXTCODE.Value = '';
    VFIXEDTEXT.Value = 0;
  }
  if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_text', TComponent(Comp))
  then
    TUniMemo(Comp).Clear;
  if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_loSearch', TComponent(Comp))
  then
    TUniDBLookupComboBox(Comp).Clear;
  if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_loSearchCode',
    TComponent(Comp)) then
    TUniDBLookupComboBox(Comp).Clear;
  if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_chSpezimen',
    TComponent(Comp)) then
    TUniCheckBox(Comp).Checked := False;
  if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_chInternalComment',
    TComponent(Comp)) then
    TUniCheckBox(Comp).Checked := False;
  if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_VFIXEDTEXTCODE',
    TComponent(Comp)) then
    TUniLabel(Comp).Caption := '';
  if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_VFIXEDTEXT',
    TComponent(Comp)) then
    TUniLabel(Comp).Caption := '0';
end;

procedure RunOnShowF01(Sender: TObject);
var
  Comp: TComponent;
  Q: TFDQuery;
  I: integer;
  // Ds: TDataSource;
  // Gr: TUniDBGrid;
begin
  (*
    SCCLEARFIELDS.RunScript();
    GV01.Value = 'INS';
    if(TYPE.Value == 'Z')
    {
    CHSPEZIMEN.Value = '0';
    CHSPEZIMEN.Visible = false;
    LABCHSPEZIMEN.Visible = false;
    GRESNAME.Enable();
    GRESTEXT.Enable();
    GRDCOMMENTS.Visible = false;
    GRDRESCOMMENTS.Visible = true;
    QUGETRESCOMMENTS.Execute();
    VCONTEXT.Value = 3;
    }
    else
    {
    CHSPEZIMEN.Visible = true;
    LABCHSPEZIMEN.Visible = true;
    GNAME.Enable();
    GTEXT.Enable();
    GRDCOMMENTS.Visible = true;
    GRDRESCOMMENTS.Visible = false;
    QGETCOMMENTS.Execute();
    VCONTEXT.Value = 2;
    }
    QGETANALYT.execute();
    QGETSPECIMEN.execute();
    RUN('labAnalyt.SetCaption');
    RUN('labSpezimen.SetCaption');
    if (VCALLEDFROM.Value)
    {
    VCONTEXT.Value = VCALLEDFROM.Value;
    }
    QGETFIXEDTEXT.Execute();
    QGETFIXEDTEXT2.Execute();
    LOSEARCHCODE.SetFocus();
    QUGETAUFTRAG.Execute();
    if (VACTIVE.Value == 'J')
    {
    LOE.Enable();
    MIRESDELETE.Enable();
    }
    else
    {
    LOE.Disable();
    MIRESDELETE.Disable();
    }
  *)
  DebugMsg('RunOnShowF01()');

  // PARAMETER SET
  SetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_SEQNR',
    GetCompVar('fr5120_SEQNR'));
  SetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_TYPE',
    GetCompVar('fr5120_TYPE'));
  SetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_ANALYTNR',
    GetCompVar('fr5120_ANALYTNR'));
  SetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_MANDANT',
    GetCompVar('fr5120_MANDANT'));
  SetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_RESULT_SEQNR',
    GetCompVar('fr5120_RESULT_SEQNR'));

  // Label
  SetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_AUFTNR',
    GetCompVar('fr5120_AUFTNR'));
  if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_LBL_AUFTNR',
    TComponent(Comp)) then
    TUniLabel(Comp).Caption := GetCompVarObj(TComponent(Sender),
      'POPANALYTCOMMENT_AUFTNR');

  try
    scClearFields(Sender);
    SetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_GV01', 'INS');
    if GetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_TYPE') = 'Z' then
    begin
      if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_chSpezimen',
        TComponent(Comp)) then
        TUniCheckBox(Comp).Checked := False;
      if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_chSpezimen',
        TComponent(Comp)) then
        TUniCheckBox(Comp).Visible := False;
      if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_LABCHSPEZIMEN',
        TComponent(Comp)) then
        TUniLabel(Comp).Visible := False;

      if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_GRDRESCOMMENTS',
        TComponent(Comp)) then
        TUniDBGrid(Comp).Columns.ColumnFromFieldName('kontrmoddate')
          .Visible := True;
      if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_GRDRESCOMMENTS',
        TComponent(Comp)) then
        TUniDBGrid(Comp).Columns.ColumnFromFieldName('Text').Visible := True;
      if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_GRDCOMMENTS',
        TComponent(Comp)) then
        TUniDBGrid(Comp).Visible := True;
      if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_GRDRESCOMMENTS',
        TComponent(Comp)) then
        TUniDBGrid(Comp).Visible := True;
      if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_QUGETRESCOMMENTS',
        TComponent(Comp)) then
        TFDQuery(Comp).Active := True;
      SetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_VCONTEXT', '3');
    end
    else
    begin
      if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_chSpezimen',
        TComponent(Comp)) then
        TUniCheckBox(Comp).Visible := True;
      if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_LABCHSPEZIMEN',
        TComponent(Comp)) then
        TUniLabel(Comp).Visible := True;

      if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_GRDCOMMENTS',
        TComponent(Comp)) then
        TUniDBGrid(Comp).Visible := False;
      if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_GRDRESCOMMENTS',
        TComponent(Comp)) then
        TUniDBGrid(Comp).Visible := True;

      QGetCommentExec(Sender);

      SetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_VCONTEXT', '2');
    end;

    QGetAnalytExec(Sender);
    QGetSpecimenExec(Sender);

    if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_VCALLEDFROM',
      TComponent(Comp)) then
      if TUniLabel(Comp).Caption <> '' then
        SetCompVarObj(TComponent(Sender), 'POPANALYTCOMMENT_VCONTEXT',
          TUniLabel(Comp).Caption);

    QGetFixedTextExec(Sender);

    // QGETANALYT
    // if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_QGETFIXEDTEXT',
    // TComponent(Q)) then
    // if FindComp(TComponent(Sender), 'POPANALYTCOMMENT_text', TComponent(Comp))
    // then
    // TUniMemo(Comp).Lines.Add(Q.ClassName);

  except
    on E: Exception do
      Exception.Create(E.Message);

  end;

end;

end.

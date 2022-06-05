unit UnitProperties;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniButton, uniGUIBaseClasses, uniPanel,
  uniMultiItem, uniListBox, uniDBGrid, System.StrUtils;

type
  TfrmProperties = class(TUniForm)
    UniContainerPanel1: TUniContainerPanel;
    BtnApplyChanges: TUniButton;
    ListBoxColumns: TUniListBox;
    procedure UniFormBeforeShow(Sender: TObject);
    procedure BtnApplyChangesClick(Sender: TObject);
  private
  { Private declarations }
    const
    vendor = 'Roche';
  public
    { Public declarations }
  var
    Gr: TUniDBGrid;
  end;

function frmProperties: TfrmProperties;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, UnitCommons;

function frmProperties: TfrmProperties;
begin
  Result := TfrmProperties(UniMainModule.GetFormInstance(TfrmProperties));
end;

procedure TfrmProperties.BtnApplyChangesClick(Sender: TObject);
var
  I, J: integer;
begin
  for I := 0 to ListBoxColumns.Count - 1 do
    if ListBoxColumns.Selected[I] then
    begin
      for J := 0 to Gr.Columns.Count - 1 do
        if Gr.Columns[J].Title.Caption = ListBoxColumns.Items[I] then
          SetGridColRegVal(Gr, Gr.Columns[J].FieldName, 'Visible', '"True"');
    end
    else
      for J := 0 to Gr.Columns.Count - 1 do
        if Gr.Columns[J].Title.Caption = ListBoxColumns.Items[I] then
          SetGridColRegVal(Gr, Gr.Columns[J].FieldName, 'Visible', '"False"');

  ReConfGridCol(Gr);

  Close;
end;

procedure TfrmProperties.UniFormBeforeShow(Sender: TObject);
var
  I, J: integer;
begin
  // tampilkan kolumn tabel

  // Self.Caption := Gr.Name;

  J := 0;

  ListBoxColumns.Clear;
  for I := 0 to Gr.Columns.Count - 1 do
  begin
    // if not(UpperCase(Gr.Columns[I].Title.Caption) = Gr.Columns[I].Title.Caption)
    if True

    then
    begin
      ListBoxColumns.Items.Add(Gr.Columns[I].Title.Caption);
      ListBoxColumns.Items[J];
      // if GetGridColRegVal(Gr, Gr.Columns[I].FieldName, 'Visible') = '"True"'
      if Gr.Columns[I].Visible then
        ListBoxColumns.Selected[J] := True;

      J := J + 1;
    end;
  end;

end;

end.

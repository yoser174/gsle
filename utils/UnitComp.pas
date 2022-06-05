unit UnitComp;

interface

uses Windows, System.SysUtils, System.Classes;

function FindComp(AOwner: TComponent; ComponentName: String;
  var CompOut: TComponent): boolean;

function GetCompVar(ComponentName: String): String;
procedure SetCompVar(ComponentName: String; Value: string);
function GetCompText(ComponentName: String): String;

function GetCompVarObj(AOwner: TComponent; ComponentName: String): string;
procedure SetCompVarObj(AOwner: TComponent; ComponentName: String;
  Value: string);
function GetCompTextObj(AOwner: TComponent; ComponentName: String): String;

implementation

uses UnitPopUp, UniGUIForm, UniGUIApplication, Main, UniLabel, UniMemo;

procedure DebugMsg(const Msg: String);
begin
  OutputDebugString(PChar(Msg + char(10)));
end;

{
  Buat variable component baru dengan isi kosong
}
procedure CreateNewVar(AOwner: TComponent; ComponentName: String;
  Value: String);
var
  Lb: TUniLabel;
begin
  Lb := TUniLabel.Create(AOwner);
  Lb.Name := ComponentName;
  Lb.Visible := False;
  Lb.Caption := Value;
  TUniForm(AOwner).InsertControl(Lb);
end;

{
  Find component from name in Main Window
}
function FindComp(AOwner: TComponent; ComponentName: String;
  var CompOut: TComponent): boolean;
var
  I: integer;
begin
  DebugMsg('FindComp(' + ComponentName + ')');
  for I := 0 to AOwner.ComponentCount - 1 do
  begin
    // DebugMsg('[' + IntToStr(I) + '][' + UpperCase(AOwner.Components[I].Name) +
    // '][' + ComponentName + ']');
    if UpperCase(AOwner.Components[I].Name) = UpperCase(ComponentName) then
    begin
      DebugMsg('[' + IntToStr(I) + '][' + UpperCase(AOwner.Components[I].Name) +
        '][' + ComponentName + ']');
      CompOut := AOwner.Components[I];
      Result := True;
      exit;
    end;
  end;
  Result := False;
end;

{
  Ambil value variable di Main form, jika komponen tidak ada auto-create
}
function GetCompVar(ComponentName: String): String;
var
  I: integer;
  Comp: TComponent;
begin
  DebugMsg('GetCompVar(' + ComponentName + ')');
  if FindComp(MainForm, ComponentName, Comp) then
  begin
    Result := TUniLabel(Comp).Caption;
    DebugMsg('Value [' + Result + ']');
    exit;
  end;

  Result := '';
  CreateNewVar(MainForm, ComponentName, '');
end;

{
  Set value variable di Main form, jika komponen tidak ada auto-create
}
procedure SetCompVar(ComponentName: String; Value: string);
var
  I: integer;
  Comp: TComponent;
begin
  DebugMsg('SetCompVar(' + ComponentName + ',' + Value + ')');
  if FindComp(MainForm, ComponentName, Comp) then
  begin
    TUniLabel(Comp).Caption := Value;
    exit;
  end;

  CreateNewVar(MainForm, ComponentName, Value);
end;

{
  Ambil value Text di Main form, jika komponen tidak ada auto-create
}
function GetCompText(ComponentName: String): String;
var
  I: integer;
  Comp: TComponent;
begin
  DebugMsg('GetCompVar(' + ComponentName + ')');
  if FindComp(MainForm, ComponentName, Comp) then
  begin
    Result := TUniMemo(Comp).Lines.Text;
    DebugMsg('Value [' + Result + ']');
    exit;
  end;

  Result := '';
  CreateNewVar(MainForm, ComponentName, '');

end;

{
  Set value variable di Main form, jika komponen tidak ada auto-create
}
procedure SetCompVarObj(AOwner: TComponent; ComponentName: String;
  Value: string);
var
  I: integer;
  Comp: TComponent;
begin
  DebugMsg('SetCompVarObj(' + AOwner.Name + ',' + ComponentName + ',' +
    Value + ')');
  if FindComp(AOwner, ComponentName, Comp) then
  begin
    TUniLabel(Comp).Caption := Value;
    exit;
  end;

  CreateNewVar(AOwner, ComponentName, Value);
end;

{
  Get value variable di Main form, jika komponen tidak ada auto-create
}
function GetCompVarObj(AOwner: TComponent; ComponentName: String): string;
var
  I: integer;
  Comp: TComponent;
begin
  DebugMsg('SetCompVarObj(' + AOwner.Name + ',' + ComponentName + ')');
  if FindComp(AOwner, ComponentName, Comp) then
  begin
    Result := TUniLabel(Comp).Caption;
    exit;
  end;

  CreateNewVar(AOwner, ComponentName, '');
  Result := 'g ketemu';
end;

{
  Ambil value Text di Main form, jika komponen tidak ada auto-create
}
function GetCompTextObj(AOwner: TComponent; ComponentName: String): String;
var
  I: integer;
  Comp: TComponent;
begin
  DebugMsg('GetCompVar(' + ComponentName + ')');
  if FindComp(AOwner, ComponentName, Comp) then
  begin
    Result := TUniMemo(Comp).Lines.Text;
    DebugMsg('Value [' + Result + ']');
    exit;
  end;

  Result := '';
  CreateNewVar(MainForm, ComponentName, '');

end;

end.

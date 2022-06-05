unit UnitLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniGUIBaseClasses, uniLabel,
  uniEdit, uniButton, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, uniMemo, Vcl.Imaging.pngimage,
  uniImage;

type
  TfrmLogin = class(TUniLoginForm)
    UniLabel1: TUniLabel;
    UniLabel2: TUniLabel;
    UniLabel3: TUniLabel;
    UniLabel4: TUniLabel;
    btnLogon: TUniButton;
    UniButton2: TUniButton;
    edUsername: TUniEdit;
    edPassword: TUniEdit;
    FDQuery1: TFDQuery;
    UniImage1: TUniImage;
    procedure UniButton2Click(Sender: TObject);
    procedure UniLoginFormBeforeShow(Sender: TObject);
    procedure btnLogonClick(Sender: TObject);
    procedure edUsernameKeyPress(Sender: TObject; var Key: Char);
    procedure edPasswordKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function frmLogin: TfrmLogin;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication;

function frmLogin: TfrmLogin;
begin
  Result := TfrmLogin(UniMainModule.GetFormInstance(TfrmLogin));
end;

procedure TfrmLogin.edPasswordKeyPress(Sender: TObject; var Key: Char);
begin
  if Ord(Key) = VK_RETURN then
    btnLogonClick(self);
end;

procedure TfrmLogin.edUsernameKeyPress(Sender: TObject; var Key: Char);
begin
  if Ord(Key) = VK_RETURN then
    edPassword.SetFocus;
end;

procedure TfrmLogin.btnLogonClick(Sender: TObject);
begin
  if (edUsername.Text <> '') and (edPassword.Text <> '') then
  begin
    ShowMask('Loading');
    UniSession.Synchronize();
    // login
    try
      UniMainModule.FDConn.Params.UserName := edUsername.Text;
      UniMainModule.FDConn.Params.Password := edPassword.Text;
      UniMainModule.FDConn.Connected := true;
      // sukses login
      ModalResult := mrOK;
      UniApplication.Cookies.SetCookie('UserName', edUsername.Text);
    except
      on E: Exception do
        MessageDlg('Incorrect user name or password.'+char(13)+E.Message, mtError, [mbOK], nil);
    end;
  end;
  HideMask;
end;

procedure TfrmLogin.UniButton2Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmLogin.UniLoginFormBeforeShow(Sender: TObject);
begin
  if UniMainModule.FDConn.Connected then
    UniMainModule.FDConn.Connected := false;
end;

initialization

RegisterAppFormClass(TfrmLogin);

end.

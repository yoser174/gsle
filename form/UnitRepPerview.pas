unit UnitRepPerview;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniGUIBaseClasses, uniURLFrame, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TfrmRepPerview = class(TUniForm)
    UrlFrm: TUniURLFrame;
    procedure UniFormBeforeShow(Sender: TObject);
    procedure UniFormAjaxEvent(Sender: TComponent; EventName: string;
      Params: TUniStrings);
  private
    { Private declarations }
  public
    { Public declarations }
    SeqNr: integer;
  end;

function frmRepPerview: TfrmRepPerview;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, UnitReportJasper;

function frmRepPerview: TfrmRepPerview;
begin
  Result := TfrmRepPerview(UniMainModule.GetFormInstance(TfrmRepPerview));
end;

procedure TfrmRepPerview.UniFormAjaxEvent(Sender: TComponent; EventName: string;
  Params: TUniStrings);
var
  Job: String;
begin
  if EventName = '_pdf_result' then
  begin
    Job := Params.Values['job'];
    // ShowMessage(Job);
    ShowMask('Loading');
    // UniSession.Synchronize();
    // UrlFrm.Visible := True;

    UrlFrm.URL := reportExecReqParams('pdf', 'RESULT_REPORT', Job, 'N', '');
    //
    // UniSession.Synchronize();
    // ShowMessage(UrlFrm.URL);
    HideMask;
  end;
end;

procedure TfrmRepPerview.UniFormBeforeShow(Sender: TObject);
var
  FdSP: TFDStoredProc;
  Job: integer;
begin
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
    // FdSP.ParamByName('PSEQNR').Value := GetCompValue(self, 'foBefund_seqnr');
    FdSP.ParamByName('PSEQNR').Value := SeqNr;
    FdSP.ParamByName('PLOCAL').Value := 'LAB1';

    FdSP.Execute;
    FdSP.Connection.Commit;

    Job := FdSP.ParamByName('RESULT').AsInteger;

    // UrlFrm.URL := reportExecReqParams('pdf', 'RESULT_REPORT',
    // IntToStr(Job), 'N', '');

    UniSession.AddJS('ajaxRequest(' + self.Name +
      '.form, "_pdf_result" , ["job=' + IntToStr(Job) + '"]);');

  finally
    FdSP.Free;
  end;
end;

end.

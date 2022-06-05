program GSLE;

uses
  Forms,
  ServerModule in 'ServerModule.pas' {UniServerModule: TUniGUIServerModule},
  MainModule in 'MainModule.pas' {UniMainModule: TUniGUIMainModule},
  Main in 'Main.pas' {MainForm: TUniForm},
  UnitLogin in 'form\UnitLogin.pas' {frmLogin: TUniLoginForm},
  UnitPopUp in 'form\UnitPopUp.pas' {frmPopUp: TUniForm},
  UnitBuildControls in 'utils\UnitBuildControls.pas',
  UnitGuiDebug in 'form\UnitGuiDebug.pas' {frmGuiDebug: TUniForm},
  UnitCommons in 'utils\UnitCommons.pas',
  UnitReportJasper in 'utils\UnitReportJasper.pas',
  UnitRepPerview in 'form\UnitRepPerview.pas' {frmRepPerview: TUniForm},
  UnitProperties in 'form\UnitProperties.pas' {frmProperties: TUniForm},
  UnitComp in 'utils\UnitComp.pas',
  UnitPopUpForm in 'utils\UnitPopUpForm.pas',
  UnitPopUpNew in 'form\UnitPopUpNew.pas' {frmPopUpNew: TUniForm},
  UnitDB in 'utils\UnitDB.pas',
  UnitXml in 'utils\UnitXml.pas',
  UnitConsAndGenVar in 'utils\UnitConsAndGenVar.pas',
  UnitBuildView in 'utils\UnitBuildView.pas',
  UnitBuildViewRoutes in 'utils\BuildView\UnitBuildViewRoutes.pas',
  UnitPopAnalytComment in 'utils\BuildView\UnitPopAnalytComment.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  TUniServerModule.Create(Application);
  Application.Title := 'GS LAB Enterprise';
  Application.Run;
end.

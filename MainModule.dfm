object UniMainModule: TUniMainModule
  OldCreateOrder = False
  Theme = 'neptune'
  BrowserOptions = [boDisableMouseRightClick, boDisableChromeRefresh]
  MonitoredKeys.Keys = <>
  EnableSynchronousOperations = True
  Height = 336
  Width = 441
  object FDConn: TFDConnection
    Params.Strings = (
      'Database=127.0.01/LIS'
      'User_Name=datos_prj'
      'Password=prj_bmg'
      'DriverID=Ora')
    LoginPrompt = False
    Left = 72
    Top = 48
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    ScreenCursor = gcrNone
    Left = 144
    Top = 72
  end
  object FDPhysOracleDriverLink1: TFDPhysOracleDriverLink
    VendorHome = 'Ora11204'
    Left = 72
    Top = 160
  end
end

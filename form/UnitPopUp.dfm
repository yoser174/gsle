object frmPopUp: TfrmPopUp
  Left = 0
  Top = 0
  ClientHeight = 572
  ClientWidth = 697
  Caption = 'New Pop Up Form'
  BorderStyle = bsDialog
  Position = poDesktopCenter
  OldCreateOrder = False
  OnClose = UniFormClose
  Visible = True
  MonitoredKeys.Keys = <>
  Font.Height = -13
  Font.Name = 'Roboto'
  OnReady = UniFormReady
  OnBeforeShow = UniFormBeforeShow
  OnAfterShow = UniFormAfterShow
  OnAjaxEvent = UniFormAjaxEvent
  PixelsPerInch = 96
  TextHeight = 15
  object UniSplitter1: TUniSplitter
    Left = 0
    Top = 0
    Width = 697
    Height = 6
    Cursor = crVSplit
    Hint = ''
    Align = alTop
    ParentColor = False
    Color = clBtnFace
    ExplicitWidth = 572
  end
  object FDStoredProc1: TFDStoredProc
    Left = 512
    Top = 200
  end
  object DataSource1: TDataSource
    Left = 624
    Top = 216
  end
  object XMLDoc: TXMLDocument
    Left = 571
    Top = 8
    DOMVendorDesc = 'Omni XML'
  end
  object FDQuery1: TFDQuery
    Left = 384
    Top = 224
  end
end

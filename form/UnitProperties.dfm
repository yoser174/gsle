object frmProperties: TfrmProperties
  Left = 0
  Top = 0
  ClientHeight = 418
  ClientWidth = 292
  Caption = 'Properties'
  BorderStyle = bsDialog
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  Font.Height = -13
  Font.Name = 'Roboto'
  OnBeforeShow = UniFormBeforeShow
  PixelsPerInch = 96
  TextHeight = 15
  object UniContainerPanel1: TUniContainerPanel
    Left = 0
    Top = 384
    Width = 292
    Height = 34
    Hint = ''
    ParentColor = False
    Align = alBottom
    TabOrder = 0
    object BtnApplyChanges: TUniButton
      Left = 184
      Top = 6
      Width = 105
      Height = 25
      Hint = ''
      Caption = 'Apply Changes'
      TabOrder = 1
      Default = True
      OnClick = BtnApplyChangesClick
    end
  end
  object ListBoxColumns: TUniListBox
    Left = 0
    Top = 0
    Width = 292
    Height = 384
    Hint = ''
    Items.Strings = (
      'A'
      'B'
      'C'
      'D'
      'E'
      'F'
      'G'
      'H'
      'I')
    Align = alClient
    TabOrder = 1
    MultiSelect = True
    ShowCheckBoxes = True
  end
end

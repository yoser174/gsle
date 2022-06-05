object MainForm: TMainForm
  Left = 0
  Top = 0
  ClientHeight = 903
  ClientWidth = 1117
  Caption = 'MainForm'
  OldCreateOrder = False
  OnClose = UniFormClose
  Menu = mnMain
  MonitoredKeys.Keys = <>
  Font.Height = -13
  Font.Name = 'Roboto'
  OnBeforeShow = UniFormBeforeShow
  OnAjaxEvent = UniFormAjaxEvent
  OnCreate = UniFormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object UniPanel1: TUniPanel
    Left = 0
    Top = 49
    Width = 240
    Height = 854
    Hint = ''
    Constraints.MaxWidth = 300
    Align = alLeft
    TabOrder = 0
    TitleAlign = taCenter
    Title = 'Navigate'
    Caption = 'UniPanel1'
    Collapsible = True
    CollapseDirection = cdLeft
    object NavTree: TUniTreeView
      Left = 1
      Top = 53
      Width = 238
      Height = 800
      Hint = ''
      Items.FontData = {0100000000}
      AutoExpand = True
      Align = alClient
      TabOrder = 1
      ScreenMask.ShowMessage = False
      ScreenMask.Target = Owner
      ScreenMask.Color = clWhite
      ScreenMask.Opacity = 0.200000002980232200
      Color = clWindow
      BorderStyle = ubsNone
      OnClick = NavTreeClick
      OnAjaxEvent = NavTreeAjaxEvent
    end
    object UniToolBar1: TUniToolBar
      Left = 1
      Top = 1
      Width = 238
      Height = 29
      Hint = ''
      ShowHint = True
      ParentShowHint = False
      ButtonHeight = 23
      Images = ilMain
      BorderWidth = 1
      TabOrder = 2
      ParentColor = False
      Color = clBtnFace
      object UniToolButton1: TUniToolButton
        Left = 0
        Top = 0
        Hint = 'Expand All'
        ShowHint = True
        ImageIndex = 0
        Caption = 'UniToolButton1'
        TabOrder = 1
        OnClick = UniToolButton1Click
      end
      object UniToolButton2: TUniToolButton
        Left = 23
        Top = 0
        Hint = 'Collapse All'
        ShowHint = True
        ImageIndex = 1
        Caption = 'UniToolButton2'
        TabOrder = 2
        OnClick = UniToolButton2Click
      end
      object UniToolButton3: TUniToolButton
        Left = 46
        Top = 0
        Width = 8
        Hint = ''
        ShowHint = True
        Style = tbsSeparator
        Caption = 'UniToolButton3'
        TabOrder = 3
      end
      object UniToolButton4: TUniToolButton
        Left = 54
        Top = 0
        Hint = 'Close All Tabs'
        ShowHint = True
        ImageIndex = 2
        Caption = 'UniToolButton4'
        ScreenMask.Enabled = True
        ScreenMask.Message = 'Cleaning up...'
        ScreenMask.Target = Owner
        ScreenMask.Color = clWhite
        ScreenMask.Opacity = 0.349999994039535500
        TabOrder = 4
        OnClick = UniToolButton4Click
      end
    end
    object SearchEdit: TUniComboBox
      Left = 1
      Top = 30
      Width = 238
      Height = 23
      Hint = ''
      Text = ''
      Align = alTop
      TabOrder = 3
      MinQueryLength = 3
      CheckChangeDelay = 250
      ClearButton = True
      FieldLabelWidth = 250
      Triggers = <
        item
          ButtonId = 0
          IconCls = 'x-form-search-trigger'
          HandleClicks = True
        end>
      IconItems = <>
      OnChange = SearchEditChange
    end
  end
  object UniContainerPanel2: TUniContainerPanel
    Left = 240
    Top = 49
    Width = 877
    Height = 854
    Hint = ''
    ParentColor = False
    Align = alClient
    TabOrder = 1
    object UniPageControl1: TUniPageControl
      Left = 0
      Top = 0
      Width = 877
      Height = 854
      Hint = ''
      ActivePage = UniTabSheet1
      Align = alClient
      TabOrder = 1
      object UniTabSheet1: TUniTabSheet
        Hint = ''
        Caption = 'Home'
        Font.Height = -13
        Font.Name = 'Roboto'
        ParentFont = False
        OnClose = UniTabSheet1Close
        object cHome: TUniContainerPanel
          Left = 0
          Top = 0
          Width = 537
          Height = 826
          Hint = ''
          Visible = False
          ParentColor = False
          Align = alLeft
          TabOrder = 0
          object btnConvert: TUniButton
            Left = 3
            Top = 367
            Width = 75
            Height = 25
            Hint = ''
            Visible = False
            Caption = 'Convert'
            TabOrder = 1
            OnClick = btnConvertClick
          end
          object mmParse: TUniMemo
            Left = 3
            Top = 400
            Width = 416
            Height = 369
            Hint = ''
            Visible = False
            Lines.Strings = (
              '  <QueryEx ID="Q10" ONSCROLL="Q11.Execute">'
              
                '    { call auftrag_package.GetGeraeteForSample(:seqnr,:vInternSa' +
                'mpleId,:CB01) }'
              #9'<Variable ID="gernr" KEYFIELD="gernr"/>'
              '    <Variable ID="vExtInt" KEYFIELD="extInt"/>'
              '    <Variable ID="vExtLoc" KEYFIELD="location"/>'
              '  </QueryEx>')
            TabOrder = 2
          end
          object btnRunActionJS: TUniButton
            Left = 84
            Top = 367
            Width = 107
            Height = 25
            Hint = ''
            Visible = False
            Caption = 'Run Action JS'
            TabOrder = 3
            OnClick = btnRunActionJSClick
          end
          object UniButton1: TUniButton
            Left = 197
            Top = 367
            Width = 107
            Height = 25
            Hint = ''
            Visible = False
            Caption = 'Run JS'
            TabOrder = 4
            OnClick = btnRunActionJSClick
          end
          object UniEdit1: TUniEdit
            Left = 310
            Top = 367
            Width = 91
            Hint = ''
            Visible = False
            Text = 'UniEdit1'
            TabOrder = 5
            ClientEvents.ExtEvents.Strings = (
              
                'keypress=function keypress(sender, e, eOpts)'#13#10'{'#13#10' if(e.getKey() ' +
                '== 13) { alert("enter pressed."); }'#13#10'}')
            OnKeyDown = UniEdit1KeyDown
          end
          object UniButton2: TUniButton
            Left = 407
            Top = 367
            Width = 75
            Height = 25
            Hint = ''
            Visible = False
            Caption = 'UniButton2'
            TabOrder = 6
            OnClick = UniButton2Click
          end
          object btnTest: TUniButton
            Left = 440
            Top = 432
            Width = 75
            Height = 25
            Hint = ''
            Visible = False
            Caption = 'btnTest'
            TabOrder = 7
            OnClick = btnTestClick
          end
          object UniButton3: TUniButton
            Left = 448
            Top = 494
            Width = 75
            Height = 25
            Hint = ''
            Visible = False
            Caption = 'UniButton3'
            TabOrder = 8
            OnClick = mjjnnhjghh
          end
          object btnPrint: TUniButton
            Left = 448
            Top = 401
            Width = 75
            Height = 25
            Hint = ''
            Visible = False
            Caption = 'Print'
            TabOrder = 9
            OnClick = btnPrintClick
          end
          object UniLabel2: TUniLabel
            Left = 448
            Top = 648
            Width = 57
            Height = 15
            Hint = ''
            Caption = 'UniLabel2'
            TabOrder = 10
          end
          object UniButton4: TUniButton
            Left = 440
            Top = 463
            Width = 75
            Height = 25
            Hint = ''
            Visible = False
            Caption = 'UniButton4'
            TabOrder = 11
            OnClick = UniButton4Click
          end
          object UniButton5: TUniButton
            Left = 440
            Top = 525
            Width = 75
            Height = 25
            Hint = ''
            Visible = False
            Caption = 'UniButton5'
            TabOrder = 12
            OnClick = UniButton5Click
          end
          object UniButton6: TUniButton
            Left = 440
            Top = 568
            Width = 75
            Height = 25
            Hint = ''
            Visible = False
            Caption = 'UniButton6'
            TabOrder = 13
            OnClick = UniButton6Click
          end
          object UniButton7: TUniButton
            Left = 440
            Top = 599
            Width = 75
            Height = 25
            Hint = ''
            Visible = False
            Caption = 'UniButton7'
            TabOrder = 14
            OnClick = UniButton7Click
          end
          object mmLog: TUniMemo
            Left = 320
            Top = 120
            Width = 185
            Height = 89
            Hint = ''
            Lines.Strings = (
              'mmLog')
            TabOrder = 15
          end
          object mmJS: TUniMemo
            Left = 88
            Top = 96
            Width = 185
            Height = 89
            Hint = ''
            Lines.Strings = (
              'mmJS')
            TabOrder = 16
          end
        end
        object UniContainerPanel1: TUniContainerPanel
          Left = 32
          Top = -7
          Width = 834
          Height = 495
          Hint = ''
          Visible = False
          ParentColor = False
          TabOrder = 1
          object UniDBGrid1: TUniDBGrid
            Left = 29
            Top = 96
            Width = 724
            Height = 185
            Hint = ''
            DataSource = DataSource4
            LoadMask.Message = 'Loading data...'
            TabOrder = 1
            Columns = <
              item
                FieldName = 'COMMENT_RID'
                Title.Caption = 'COMMENT_RID'
                Width = 64
                Font.Name = 'Roboto'
              end
              item
                FieldName = 'COMMENT_ID'
                Title.Caption = 'COMMENT_ID'
                Width = 64
                Font.Name = 'Roboto'
              end
              item
                FieldName = 'COMMENT_TYPE'
                Title.Caption = 'COMMENT_TYPE'
                Width = 64
                Font.Name = 'Roboto'
              end
              item
                FieldName = 'COMMENT_KEY1'
                Title.Caption = 'COMMENT_KEY1'
                Width = 64
                Font.Name = 'Roboto'
              end
              item
                FieldName = 'COMMENT_KEY2'
                Title.Caption = 'COMMENT_KEY2'
                Width = 64
                Font.Name = 'Roboto'
              end
              item
                FieldName = 'COMMENT_KEY3'
                Title.Caption = 'COMMENT_KEY3'
                Width = 64
                Font.Name = 'Roboto'
              end
              item
                FieldName = 'COMMENT_TEXT'
                Title.Caption = 'COMMENT_TEXT'
                Width = 64
                Font.Name = 'Roboto'
              end
              item
                FieldName = 'COMMENT_DATE'
                Title.Caption = 'COMMENT_DATE'
                Width = 64
                Font.Name = 'Roboto'
              end
              item
                FieldName = 'COMMENT_USER'
                Title.Caption = 'COMMENT_USER'
                Width = 64
                Font.Name = 'Roboto'
              end
              item
                FieldName = 'COMMENT_TEXTCODE'
                Title.Caption = 'COMMENT_TEXTCODE'
                Width = 64
                Font.Name = 'Roboto'
              end
              item
                FieldName = 'COMMENT_TEXTKEY'
                Title.Caption = 'COMMENT_TEXTKEY'
                Width = 64
                Font.Name = 'Roboto'
              end
              item
                FieldName = 'COMMENT_SPECCOMMENTID'
                Title.Caption = 'COMMENT_SPECCOMMENTID'
                Width = 64
                Font.Name = 'Roboto'
              end
              item
                FieldName = 'COMMENT_INTERNAL'
                Title.Caption = 'COMMENT_INTERNAL'
                Width = 64
                Font.Name = 'Roboto'
                Alignment = taLeftJustify
                CheckBoxField.BooleanFieldOnly = False
                CheckBoxField.FieldValues = '0;1'
                CheckBoxField.DisplayValues = ';'
              end
              item
                FieldName = 'MULTILINE'
                Title.Caption = 'MULTILINE'
                Width = 64
                Font.Name = 'Roboto'
              end
              item
                FieldName = 'COMMENT_REFOBJECT'
                Title.Caption = 'COMMENT_REFOBJECT'
                Width = 64
                Font.Name = 'Roboto'
              end
              item
                FieldName = 'COMMENT_REFOBJECT_SEQNR'
                Title.Caption = 'COMMENT_REFOBJECT_SEQNR'
                Width = 64
                Font.Name = 'Roboto'
              end
              item
                FieldName = 'COMMENT_FREETEXT_SEQNR'
                Title.Caption = 'COMMENT_FREETEXT_SEQNR'
                Width = 64
                Font.Name = 'Roboto'
              end>
          end
        end
      end
    end
  end
  object cHeader: TUniContainerPanel
    Left = 0
    Top = 0
    Width = 1117
    Height = 49
    Hint = ''
    ParentColor = False
    Align = alTop
    TabOrder = 2
    OnClick = cHeaderClick
    object lblNav: TUniLabel
      Left = 3
      Top = 3
      Width = 460
      Height = 15
      Hint = ''
      AutoSize = False
      Caption = '<nav>'
      ParentFont = False
      Font.Color = clHighlight
      Font.Height = -16
      Font.Name = 'Roboto'
      Font.Style = [fsBold]
      Font.Quality = fqAntialiased
      TabOrder = 1
    end
    object lblUserLoc: TUniLabel
      Left = 3
      Top = 24
      Width = 460
      Height = 19
      Hint = ''
      AutoSize = False
      Caption = '<user> / <location>'
      ParentFont = False
      Font.Color = clHighlight
      Font.Height = -16
      Font.Name = 'Roboto'
      Font.Style = [fsBold]
      Font.Quality = fqAntialiased
      TabOrder = 2
    end
  end
  object mnMain: TUniMainMenu
    Left = 848
    object Application1: TUniMenuItem
      Caption = 'Application'
      object Close1: TUniMenuItem
        Caption = 'Close'
        OnClick = Close1Click
      end
      object N1: TUniMenuItem
        Caption = '-'
      end
      object Changepassword1: TUniMenuItem
        Caption = 'Change password'
      end
    end
    object Workplaces1: TUniMenuItem
      Caption = 'Workplaces'
    end
    object Location1: TUniMenuItem
      Caption = 'Location'
    end
  end
  object exeSP: TFDStoredProc
    Connection = UniMainModule.FDConn
    Left = 888
    ParamData = <
      item
      end>
  end
  object ilMain: TUniNativeImageList
    Left = 808
    Images = {
      04000000FFFFFF1F057E04000000000100010010100000010020006804000016
      0000002800000010000000200000000100200000000000000000000000000000
      000000000000000000000000000000000000008C7973FF000000000000000000
      00000063A65AFF848684FF848684FF848684FF848684FF848684FF848684FF84
      8684FF848684FF848684FF00000000000000008C7163FF00000000000000007B
      6152FF63A65AFF848684FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7
      E7E7FFE7E7E7FF848684FF00000000000000008C7163FF8C7973FF8C7163FF31
      A631FF63A65AFF848684FFE7E7E7FFE7E7E7FFE7E7E7FF212021FFE7E7E7FFE7
      E7E7FFE7E7E7FF848684FF00000000000000008C7973FF000000000000000063
      A65AFF84B684FF848684FFF7F7EFFFF7F7EFFFF7F7EFFF212021FFF7F7EFFFF7
      F7EFFFF7F7EFFF848684FF00000000000000008C7163FF000000000000000000
      00000063A65AFF848684FFF7F7EFFF181818FF181818FF000000FF181818FF18
      1818FFF7F7EFFF848684FF00000000000000008C7973FF000000000000000000
      00000000000000848684FFFFF7F7FFFFF7F7FFFFF7F7FF081010FFFFF7F7FFFF
      F7F7FFFFF7F7FF848684FF00000000000000008C7163FF000000000000000000
      00000063A65AFF848684FFFFF7F7FFFFF7F7FFFFF7F7FF000000FFFFF7F7FFFF
      F7F7FFFFF7F7FF848684FF00000000000000008C7973FF000000000000000063
      A65AFF63A65AFF848684FFFFFFF7FFFFFFF7FFFFFFF7FFFFFFF7FFFFFFF7FFFF
      FFF7FFFFFFF7FF848684FF00000000000000008C7163FF8C7973FF8C7163FF31
      A631FF63A65AFF8C8E94FF848684FF848684FF848684FF848684FF848684FF84
      8684FF848684FF8C8E94FF00000000000000008C7163FF000000000000000063
      A65AFF63A65AFF84B684FF84B684FF63A65AFF00000000000000000000000000
      000000000000000000000000000000000000008C7163FF000000000000000000
      00000063A65AFF63A65AFF63A65AFF0000000000000000000000000000000000
      00000000000000000000000000000063A65AFF63A65AFF7B6152FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000063A65AFF63A65AFF63A65AFF63A65AFF63A65AFF00
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000031A631FF63A65AFF63A65AFF84B684FF31A631FF00
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000063A65AFF63A65AFF9CDFA5FF63A65AFF63A65AFF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000063A65AFF63A65AFF63A65AFF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000DC00AC41D800AC41C000AC41D800AC41DC00AC41DE
      00AC41DC00AC41D800AC41C000AC41D83FAC41DC7FAC418FFFAC4107FFAC4107
      FFAC4107FFAC418FFFAC41FFFFFF1F057E040000000001000100101000000100
      2000680400001600000028000000100000002000000001002000000000000000
      00000000000000000000000000000000000000000000000000008C7973FF0000
      0000000000000000000063A65AFF848684FF848684FF848684FF848684FF8486
      84FF848684FF848684FF848684FF848684FF00000000000000008C7163FF0000
      0000000000007B6152FF63A65AFF848684FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7
      E7FFE7E7E7FFE7E7E7FFE7E7E7FF848684FF00000000000000008C7163FF8C79
      73FF8C7163FF31A631FF63A65AFF848684FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7
      E7FFE7E7E7FFE7E7E7FFE7E7E7FF848684FF00000000000000008C7973FF0000
      00000000000063A65AFF84B684FF848684FFF7F7EFFFF7F7EFFFF7F7EFFFF7F7
      EFFFF7F7EFFFF7F7EFFFF7F7EFFF848684FF00000000000000008C7163FF0000
      0000000000000000000063A65AFF848684FFF7F7EFFF181818FF181818FF0000
      00FF181818FF181818FFF7F7EFFF848684FF00000000000000008C7973FF0000
      0000000000000000000000000000848684FFFFF7F7FFFFF7F7FFFFF7F7FFFFF7
      F7FFFFF7F7FFFFF7F7FFFFF7F7FF848684FF00000000000000008C7163FF0000
      0000000000000000000063A65AFF848684FFFFF7F7FFFFF7F7FFFFF7F7FFFFF7
      F7FFFFF7F7FFFFF7F7FFFFF7F7FF848684FF00000000000000008C7973FF0000
      00000000000063A65AFF63A65AFF848684FFFFFFF7FFFFFFF7FFFFFFF7FFFFFF
      F7FFFFFFF7FFFFFFF7FFFFFFF7FF848684FF00000000000000008C7163FF8C79
      73FF8C7163FF31A631FF63A65AFF8C8E94FF848684FF848684FF848684FF8486
      84FF848684FF848684FF848684FF8C8E94FF00000000000000008C7163FF0000
      00000000000063A65AFF63A65AFF84B684FF84B684FF63A65AFF000000000000
      00000000000000000000000000000000000000000000000000008C7163FF0000
      0000000000000000000063A65AFF63A65AFF63A65AFF00000000000000000000
      0000000000000000000000000000000000000000000063A65AFF63A65AFF7B61
      52FF000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000063A65AFF63A65AFF63A65AFF63A6
      5AFF63A65AFF0000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000031A631FF63A65AFF63A65AFF84B6
      84FF31A631FF0000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000063A65AFF63A65AFF9CDFA5FF63A6
      5AFF63A65AFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000063A65AFF63A65AFF63A6
      5AFF000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DC00AC41D800AC41C000AC41D800
      AC41DC00AC41DE00AC41DC00AC41D800AC41C000AC41D83FAC41DC7FAC418FFF
      AC4107FFAC4107FFAC4107FFAC418FFFAC41FFFFFF1F040101000089504E470D
      0A1A0A0000000D49484452000000100000001008060000001FF3FF6100000009
      7048597300000EC300000EC301C76FA864000000B349444154388D6360A01030
      3EEF739BCFC0C09080437E8164D1AE444206FCC7A760E6272B9C720D0D0D8C2C
      849C585F5F8F55BCB1B191818181818165E6272BBC8AB0CB20004117C06C22CB
      005C2E43369889900B08018A0D2018065090C8C8C8B8806C03181919175C0B35
      C29A5E8875010303030383E6AAB30CEFB62D636060606010F28A62B81E664C9A
      0177B27D1914BB96C1D90C0CD40A444289050654A66E867B4165EA6686EB61C6
      0C8CC4DA842B1001A91430D225B86B260000000049454E44AE426082FFFFFF1F
      057E040000000001000100101000000100200068040000160000002800000010
      0000002000000001002000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000006AA361FF388D35FF1A
      7D1AFF1D7F1DFF3B8E38FF73A668FF0000000000000000000000000000000000
      0000000000000000000000000000007BAB70FF208121FF26912AFF26992CFF24
      9E2BFF219B27FF219527FF238E25FF1F801FFF93B583FF000000000000000000
      00000000000000000000003D8F39FF2F8F32FF3BAA46FF38AB42FF31A83BFF2D
      A535FF2BA433FF2DA535FF31A83BFF33A43CFF2A8B2CFF51984BFF0000000000
      000000000000007CAB70FF369539FF4BB558FF44B250FF3DAE49FF38AB43FF3C
      A342FF3DA141FF35A93FFF38AB43FF3DAE49FF44B250FF2F8D2FFF9AB88AFF00
      00000000000000248324FF52B760FF50B85EFF4AB557FF44B251FF46A94DFFE7
      E1DCFF4C9E4BFF3DAE48FF40AF4CFF44B251FF4AB557FF48AF54FF238222FF00
      00000073A769FF41A24AFF5CBE6CFF56BB65FF50B85FFF50AF59FFE7E1DCFFE7
      E1DCFF599B54FF53A254FF55A456FF57A559FF57AE5EFF56BB65FF38983DFF8C
      B17DFF499545FF58B768FF62C273FF5CBF6DFF5BB466FFE7E1DCFFE7E1DCFFE7
      E1DCFFE7E1DCFFE7E1DCFFE7E1DCFFF3EFEBFF61AA64FF5CBF6DFF4BAC56FF57
      9B51FF2D872CFF6CC67EFF68C57BFF66BA72FFE7E1DCFFE7E1DCFFE7E1DCFFE7
      E1DCFFE7E1DCFFE7E1DCFFE7E1DCFFF3EFEBFF66AD6AFF63C275FF5FBC6FFF27
      8426FF2A8529FF72CA86FF6FC983FFF3EFEBFFF3EFEBFFF3EFEBFFF3EFEBFFF3
      EFEBFFF3EFEBFFF3EFEBFFF3EFEBFFF3EFEBFF6CB071FF6AC67DFF65C076FF2D
      882CFF449341FF68BF79FF76CC8BFF71CA86FFFAF5F4FFFAF5F4FFFAF5F4FFFA
      F5F4FFFAF5F4FFFAF5F4FFFAF5F4FFFAF5F4FF72B378FF71CA86FF58B266FF59
      9B52FF71A667FF51AB5EFF7DD093FF79CE8FFF76CC8BFFFAF5F4FFF6F1F0FFF6
      F1F0FFFAF5F4FFFAF5F4FFFAF5F4FFFAF5F4FF77C386FF79CE8FFF459F4DFF8C
      B17EFF00000000268427FF7DCE92FF81D298FF7ED194FF7BCF91FFFAF5F4FFF6
      F1F0FF7AB781FF78CE8EFF79CE8FFF7BCF91FF7ED194FF71C585FF248324FF00
      000000000000007DAB71FF499E4FFF89D7A1FF86D59DFF83D49BFF82D399FFFA
      F5F4FF80C891FF81D297FF82D399FF83D49BFF86D59DFF3A923DFF9AB88AFF00
      000000000000000000000040903DFF439B49FF82CF98FF8CD8A4FF8AD7A3FF89
      D7A1FF89D7A1FF89D7A1FF8AD7A3FF7BCA8FFF3A933DFF559A4EFF0000000000
      0000000000000000000000000000007DAB71FF248324FF51A95DFF6EBF7FFF87
      D39EFF83D099FF6BBC7CFF4CA456FF218222FF93B584FF000000000000000000
      000000000000000000000000000000000000000000000075A86BFF4A9648FF28
      8527FF288527FF4B9648FF76A86BFF0000000000000000000000000000000000
      000000F81FAC41E007AC41C003AC418001AC418001AC410000AC410000AC4100
      00AC410000AC410000AC410000AC418001AC418001AC41C003AC41E007AC41F8
      1FAC41}
  end
  object DataSource1: TDataSource
    DataSet = exeSP
    Left = 636
    Top = 376
  end
  object XMLDoc: TXMLDocument
    Left = 776
    DOMVendorDesc = 'Omni XML'
  end
  object UniPopupMenu1: TUniPopupMenu
    Left = 276
    Top = 354
    object es1: TUniMenuItem
      Caption = 'Tes'
    end
  end
  object pmTest: TUniPopupMenu
    Left = 532
    Top = 378
    object EST22221: TUniMenuItem
      Caption = 'TEST 2222'
      OnClick = EST22221Click
    end
    object asdsdgfd1: TUniMenuItem
      Caption = 'asdsdgfd'
    end
    object asdas1: TUniMenuItem
      Caption = 'asdas'
    end
  end
  object FDQuery1: TFDQuery
    Connection = UniMainModule.FDConn
    SQL.Strings = (
      'select  util_time.getSysdate  as  VCURDATE  from dual')
    Left = 388
    Top = 185
  end
  object FDQuery2: TFDQuery
    Connection = UniMainModule.FDConn
    SQL.Strings = (
      
        'begin datos_prj.patient_package.FindPatients(:patName,:patVornam' +
        'e,:patGebDat,:patSex,:patIdent,'
      
        '                                        :patFall,:patStation,:pa' +
        'tFach,:patZimmer, '#39'N'#39'); end;')
    Left = 340
    Top = 273
    ParamData = <
      item
        Name = 'PATNAME'
        DataType = ftVariant
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'PATVORNAME'
        DataType = ftVariant
        ParamType = ptInput
      end
      item
        Name = 'PATGEBDAT'
        DataType = ftVariant
        ParamType = ptInput
      end
      item
        Name = 'PATSEX'
        DataType = ftVariant
        ParamType = ptInput
      end
      item
        Name = 'PATIDENT'
        DataType = ftVariant
        ParamType = ptInput
      end
      item
        Name = 'PATFALL'
        DataType = ftVariant
        ParamType = ptInput
      end
      item
        Name = 'PATSTATION'
        DataType = ftVariant
        ParamType = ptInput
      end
      item
        Name = 'PATFACH'
        DataType = ftVariant
        ParamType = ptInput
      end
      item
        Name = 'PATZIMMER'
        DataType = ftVariant
        ParamType = ptInput
      end>
  end
  object FDStoredProc1: TFDStoredProc
    AfterScroll = FDStoredProc1AfterScroll
    Connection = UniMainModule.FDConn
    PackageName = 'DATOS_PRJ.AUFTRAG_PACKAGE'
    StoredProcName = 'GetTagesResEx'
    Left = 724
    Top = 289
    ParamData = <
      item
        Position = 1
        Name = 'RESULT'
        DataType = ftCursor
        FDDataType = dtCursorRef
        ParamType = ptResult
        Value = '1'
      end
      item
        Position = 2
        Name = 'PSEQNR'
        DataType = ftFMTBcd
        FDDataType = dtFmtBCD
        Precision = 38
        NumericScale = 38
        ParamType = ptInput
        Value = '1'
      end
      item
        Position = 3
        Name = 'PUSER'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
        Value = 'YOSE'
      end
      item
        Position = 4
        Name = 'PLOCATION'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
        Value = 'LAB1'
      end
      item
        Position = 5
        Name = 'PGERNR'
        DataType = ftFMTBcd
        FDDataType = dtFmtBCD
        Precision = 38
        NumericScale = 38
        ParamType = ptInput
      end
      item
        Position = 6
        Name = 'PSPECCD'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 7
        Name = 'PSPECCDEX'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 8
        Name = 'PTYP'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
        Value = 'G'
      end
      item
        Position = 9
        Name = 'PEXTINT'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 10
        Name = 'PEXTLOC'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end>
  end
  object DataSource2: TDataSource
    DataSet = FDStoredProc2
    Left = 724
    Top = 369
  end
  object FDStoredProc2: TFDStoredProc
    Connection = UniMainModule.FDConn
    PackageName = 'datos_prj.comment_package'
    StoredProcName = 'getComments'
    Left = 676
    Top = 193
    ParamData = <
      item
        Position = 1
        Name = 'RESULT'
        DataType = ftCursor
        FDDataType = dtCursorRef
        ParamType = ptResult
      end
      item
        Position = 2
        Name = 'PKEY1'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
        Value = '1'
      end
      item
        Position = 3
        Name = 'PTYPE'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
        Value = 'B'
      end
      item
        Position = 4
        Name = 'PKEY2'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
        Value = '100'
      end
      item
        Position = 5
        Name = 'PLOCATION'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
        Value = 'LAB1'
      end
      item
        Position = 6
        Name = 'PFIELDID'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
        Size = 40
      end
      item
        Position = 7
        Name = 'PRIGHTCHECKDONE'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 8
        Name = 'PSYNCCOMMENTS'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 9
        Name = 'PREFOBJECT'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
        Value = '%'
      end
      item
        Position = 10
        Name = 'PREFOBJECT_SEQNR'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
        Value = '%'
      end
      item
        Position = 11
        Name = 'PFREETEXT_SEQNR'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
        Value = '%'
      end>
  end
  object FDCommand1: TFDCommand
    ParamData = <
      item
      end>
    Left = 684
    Top = 249
  end
  object FDSpPrint: TFDStoredProc
    Connection = UniMainModule.FDConn
    PackageName = 'datos_prj.befund'
    StoredProcName = 'erzeugen'
    Left = 684
    Top = 545
    ParamData = <
      item
        Position = 1
        Name = 'RESULT'
        DataType = ftFMTBcd
        FDDataType = dtFmtBCD
        Precision = 38
        NumericScale = 38
        ParamType = ptResult
        Value = '61'
      end
      item
        Position = 2
        Name = 'PTYP'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 3
        Name = 'PFRMNR'
        DataType = ftFMTBcd
        FDDataType = dtFmtBCD
        Precision = 38
        NumericScale = 38
        ParamType = ptInput
      end
      item
        Position = 4
        Name = 'PAUFGGRP'
        DataType = ftFMTBcd
        FDDataType = dtFmtBCD
        Precision = 38
        NumericScale = 38
        ParamType = ptInput
      end
      item
        Position = 5
        Name = 'PAUFGCD'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 6
        Name = 'PPATID'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 7
        Name = 'PFALL'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 8
        Name = 'PAUFTNR'
        DataType = ftFMTBcd
        FDDataType = dtFmtBCD
        Precision = 38
        NumericScale = 38
        ParamType = ptInput
      end
      item
        Position = 9
        Name = 'PTAGESNRVON'
        DataType = ftFMTBcd
        FDDataType = dtFmtBCD
        Precision = 38
        NumericScale = 38
        ParamType = ptInput
      end
      item
        Position = 10
        Name = 'PTAGESNRBIS'
        DataType = ftFMTBcd
        FDDataType = dtFmtBCD
        Precision = 38
        NumericScale = 38
        ParamType = ptInput
      end
      item
        Position = 11
        Name = 'PAUFTDATVON'
        DataType = ftDateTime
        FDDataType = dtDateTime
        NumericScale = 1000
        ParamType = ptInput
      end
      item
        Position = 12
        Name = 'PAUFTDATBIS'
        DataType = ftDateTime
        FDDataType = dtDateTime
        NumericScale = 1000
        ParamType = ptInput
      end
      item
        Position = 13
        Name = 'PANALYSEDATUM'
        DataType = ftDateTime
        FDDataType = dtDateTime
        NumericScale = 1000
        ParamType = ptInput
      end
      item
        Position = 14
        Name = 'PANALYTNR'
        DataType = ftFMTBcd
        FDDataType = dtFmtBCD
        Precision = 38
        NumericScale = 38
        ParamType = ptInput
      end
      item
        Position = 15
        Name = 'PPROFIL'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 16
        Name = 'PANALYTGRUPPE'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 17
        Name = 'PANFOCODE'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 18
        Name = 'PNICHTGEDR'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 19
        Name = 'PVOLLSTAENDIG'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 20
        Name = 'PTEILBEFUND'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 21
        Name = 'PMEDVAL'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 22
        Name = 'PSTATCOM'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 23
        Name = 'PANZAHL'
        DataType = ftFMTBcd
        FDDataType = dtFmtBCD
        Precision = 38
        NumericScale = 38
        ParamType = ptOutput
        Value = '0'
      end
      item
        Position = 24
        Name = 'PHOST'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 25
        Name = 'PLOCAL'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 26
        Name = 'PAKTIV'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 27
        Name = 'PSELECT'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 28
        Name = 'PUSE'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 29
        Name = 'PUPDATE'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 30
        Name = 'PUSEEND'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 31
        Name = 'PUSETAGES'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 32
        Name = 'PANALYSEDATBIS'
        DataType = ftDateTime
        FDDataType = dtDateTime
        NumericScale = 1000
        ParamType = ptInput
      end
      item
        Position = 33
        Name = 'PNUMBERREPLACE'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 34
        Name = 'PSEQNR'
        DataType = ftFMTBcd
        FDDataType = dtFmtBCD
        Precision = 38
        NumericScale = 38
        ParamType = ptInput
      end
      item
        Position = 35
        Name = 'PSIZE'
        DataType = ftFMTBcd
        FDDataType = dtFmtBCD
        Precision = 38
        NumericScale = 38
        ParamType = ptInput
      end
      item
        Position = 36
        Name = 'PKUMDIR'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 37
        Name = 'PFORMULARGRP'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 38
        Name = 'PKOMMALLE'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 39
        Name = 'PKUMKURZ'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 40
        Name = 'PNEWFLAGS'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 41
        Name = 'PFACHRICHTUNG'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 42
        Name = 'PSOPTEXT'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 43
        Name = 'PSUBREPORTPOS1'
        DataType = ftFMTBcd
        FDDataType = dtFmtBCD
        Precision = 38
        NumericScale = 38
        ParamType = ptInput
      end
      item
        Position = 44
        Name = 'PSUBREPORTPOS2'
        DataType = ftFMTBcd
        FDDataType = dtFmtBCD
        Precision = 38
        NumericScale = 38
        ParamType = ptInput
      end
      item
        Position = 45
        Name = 'PSUBREPORTPOS3'
        DataType = ftFMTBcd
        FDDataType = dtFmtBCD
        Precision = 38
        NumericScale = 38
        ParamType = ptInput
      end
      item
        Position = 46
        Name = 'PSUBREPORTPOS4'
        DataType = ftFMTBcd
        FDDataType = dtFmtBCD
        Precision = 38
        NumericScale = 38
        ParamType = ptInput
      end
      item
        Position = 47
        Name = 'PSUBREPORTPOS5'
        DataType = ftFMTBcd
        FDDataType = dtFmtBCD
        Precision = 38
        NumericScale = 38
        ParamType = ptInput
      end
      item
        Position = 48
        Name = 'PSUBREPORTPOS6'
        DataType = ftFMTBcd
        FDDataType = dtFmtBCD
        Precision = 38
        NumericScale = 38
        ParamType = ptInput
      end
      item
        Position = 49
        Name = 'PSHOWLASTORDER'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 50
        Name = 'PHISSYSTEM'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 51
        Name = 'PSORTSEQUENCE'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 52
        Name = 'PCREATEREPORTFORGESAMTBEFUND'
        DataType = ftFMTBcd
        FDDataType = dtFmtBCD
        Precision = 38
        ParamType = ptInput
      end
      item
        Position = 53
        Name = 'PCONFIGNR'
        DataType = ftFMTBcd
        FDDataType = dtFmtBCD
        Precision = 38
        ParamType = ptInput
      end
      item
        Position = 54
        Name = 'PORDERSEQNR'
        DataType = ftFMTBcd
        FDDataType = dtFmtBCD
        Precision = 38
        ParamType = ptInput
      end
      item
        Position = 55
        Name = 'PWARDCOMACTIV'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
        Size = 4
      end
      item
        Position = 56
        Name = 'PTHOUSANDSSEPARATOR'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
        Size = 40
      end>
  end
  object DataSource3: TDataSource
    DataSet = FDQuery3
    Left = 692
    Top = 593
  end
  object FDQuery3: TFDQuery
    Connection = UniMainModule.FDConn
    SQL.Strings = (
      'select  * from co_user')
    Left = 700
    Top = 329
  end
  object FDStoredProc3: TFDStoredProc
    Connection = UniMainModule.FDConn
    PackageName = 'COMMENT_PACKAGE'
    StoredProcName = 'GETCOMMENTS'
    Left = 700
    Top = 114
    ParamData = <
      item
        Position = 1
        Name = 'RESULT'
        DataType = ftCursor
        FDDataType = dtCursorRef
        ParamType = ptResult
      end
      item
        Position = 2
        Name = 'PKEY1'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
        Value = '16'
      end
      item
        Position = 3
        Name = 'PTYPE'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
        Value = 'B'
      end
      item
        Position = 4
        Name = 'PKEY2'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
        Value = '1007'
      end
      item
        Position = 5
        Name = 'PLOCATION'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
        Value = 'LAB1'
      end
      item
        Position = 6
        Name = 'PFIELDID'
        DataType = ftWideString
        FDDataType = dtWideString
        ParamType = ptInput
        Size = 40
      end
      item
        Position = 7
        Name = 'PRIGHTCHECKDONE'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
        Value = 'NO'
      end
      item
        Position = 8
        Name = 'PSYNCCOMMENTS'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
        Value = 'YES'
      end
      item
        Position = 9
        Name = 'PREFOBJECT'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
        Value = '%'
      end
      item
        Position = 10
        Name = 'PREFOBJECT_SEQNR'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
        Value = '%'
      end
      item
        Position = 11
        Name = 'PFREETEXT_SEQNR'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
        Value = '%'
      end>
  end
  object DataSource4: TDataSource
    DataSet = FDStoredProc3
    Left = 260
    Top = 89
  end
  object ActionList1: TActionList
    Left = 348
    Top = 106
    object ActBtnClick: TAction
      Caption = 'ActBtnClick'
      OnExecute = ActBtnClickExecute
    end
    object Action2: TAction
      Caption = 'Action2'
    end
  end
end

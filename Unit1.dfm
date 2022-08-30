object frmImportFile: TfrmImportFile
  Left = 0
  Top = 0
  Caption = 'Import File'
  ClientHeight = 412
  ClientWidth = 621
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 393
    Width = 621
    Height = 19
    Panels = <>
    ExplicitWidth = 633
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 621
    Height = 113
    Align = alTop
    Caption = 'Locate file'
    TabOrder = 1
    ExplicitWidth = 633
    object lblImportFile: TLabel
      Left = 32
      Top = 35
      Width = 51
      Height = 13
      Caption = 'Import File'
      FocusControl = edtImportFile
    end
    object edtImportFile: TEdit
      Left = 89
      Top = 32
      Width = 320
      Height = 21
      TabOrder = 0
      Text = 'C:\Temp\ExampleOperatorServiceDaysOfOp.csv'
    end
    object btnBrowse: TBitBtn
      Left = 423
      Top = 30
      Width = 75
      Height = 25
      Caption = '&Browse'
      TabOrder = 1
      OnClick = btnBrowseClick
    end
    object btnImport: TBitBtn
      Left = 89
      Top = 59
      Width = 75
      Height = 25
      Caption = '&Import'
      TabOrder = 2
      OnClick = btnImportClick
    end
  end
  object TreeView1: TTreeView
    Left = 0
    Top = 113
    Width = 423
    Height = 280
    Align = alClient
    Indent = 19
    TabOrder = 2
    OnDblClick = TreeView1DblClick
    ExplicitLeft = 32
    ExplicitTop = 161
    ExplicitWidth = 273
  end
  object ListBox1: TListBox
    Left = 423
    Top = 113
    Width = 198
    Height = 280
    Align = alRight
    ItemHeight = 13
    TabOrder = 3
    Visible = False
  end
  object OpenDialog1: TOpenDialog
    Left = 272
    Top = 136
  end
  object MainMenu1: TMainMenu
    Left = 392
    Top = 144
    object File1: TMenuItem
      Caption = '&File'
      object mnuImport: TMenuItem
        Caption = '&Import'
        OnClick = btnImportClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Print1: TMenuItem
        Caption = '&Print...'
        Visible = False
      end
      object PrintSetup1: TMenuItem
        Caption = 'P&rint Setup...'
        Visible = False
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object About1: TMenuItem
        Caption = '&About...'
        OnClick = About1Click
      end
    end
  end
end

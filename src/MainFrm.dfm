object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Products (SOAP Client)'
  ClientHeight = 531
  ClientWidth = 735
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 249
    Top = 0
    Height = 490
    ExplicitLeft = 200
    ExplicitTop = 176
    ExplicitHeight = 100
  end
  object pnLeft: TPanel
    Left = 0
    Top = 0
    Width = 249
    Height = 490
    Align = alLeft
    TabOrder = 0
    object pnTitleTree: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 241
      Height = 18
      Align = alTop
      BevelKind = bkFlat
      BevelOuter = bvNone
      Caption = 'Product categories'
      TabOrder = 0
    end
    object tvCategories: TTreeView
      AlignWithMargins = True
      Left = 4
      Top = 25
      Width = 241
      Height = 461
      Margins.Top = 0
      Align = alClient
      Indent = 19
      PopupMenu = PopupMenu
      ReadOnly = True
      RowSelect = True
      TabOrder = 1
      OnChange = tvCategoriesChange
    end
  end
  object pnBottom: TPanel
    Left = 0
    Top = 490
    Width = 735
    Height = 41
    Align = alBottom
    TabOrder = 1
    object btnExportToExcel: TButton
      AlignWithMargins = True
      Left = 621
      Top = 7
      Width = 107
      Height = 27
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Action = actExportToExel
      Align = alRight
      TabOrder = 0
    end
    object btnFindProducts: TButton
      AlignWithMargins = True
      Left = 508
      Top = 7
      Width = 107
      Height = 27
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 6
      Action = actFindProducts
      Align = alRight
      TabOrder = 1
    end
    object edFindText: TEdit
      AlignWithMargins = True
      Left = 7
      Top = 9
      Width = 411
      Height = 23
      Margins.Left = 6
      Margins.Top = 8
      Margins.Right = 0
      Margins.Bottom = 8
      Align = alClient
      TabOrder = 2
      OnChange = edFindParamChange
      OnEnter = edFindTextEnter
      OnExit = edFindTextExit
      ExplicitHeight = 21
    end
    object edFindCatalogID: TEdit
      AlignWithMargins = True
      Left = 466
      Top = 9
      Width = 36
      Height = 23
      Hint = 'Product catalog ID'
      Margins.Left = 6
      Margins.Top = 8
      Margins.Right = 0
      Margins.Bottom = 8
      Align = alRight
      NumbersOnly = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Text = '2'
      OnChange = edFindParamChange
      ExplicitHeight = 21
    end
    object edFindLimit: TEdit
      AlignWithMargins = True
      Left = 424
      Top = 9
      Width = 36
      Height = 23
      Hint = 'Number of query result'
      Margins.Left = 6
      Margins.Top = 8
      Margins.Right = 0
      Margins.Bottom = 8
      Align = alRight
      NumbersOnly = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      Text = '20'
      OnChange = edFindParamChange
      ExplicitHeight = 21
    end
  end
  object pnClient: TPanel
    Left = 252
    Top = 0
    Width = 483
    Height = 490
    Align = alClient
    TabOrder = 2
    object pnTitleGrid: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 475
      Height = 18
      Align = alTop
      BevelKind = bkFlat
      BevelOuter = bvNone
      Caption = 'List of products'
      TabOrder = 0
    end
    object dbgProducts: TDBGrid
      AlignWithMargins = True
      Left = 4
      Top = 25
      Width = 475
      Height = 461
      Margins.Top = 0
      Align = alClient
      DataSource = DM.dsProducts
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgMultiSelect, dgTitleClick, dgTitleHotTrack]
      PopupMenu = PopupMenu
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnCellClick = dbgProductsCellClick
      Columns = <
        item
          Expanded = False
          FieldName = 'ProductID'
          Title.Alignment = taCenter
          Title.Caption = 'ID'
          Width = 30
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ProductName'
          Title.Alignment = taCenter
          Title.Caption = 'Name'
          Width = 150
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ProductBrand'
          Title.Alignment = taCenter
          Title.Caption = 'Brand'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MinPrice'
          Title.Alignment = taCenter
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ProductCode'
          Title.Alignment = taCenter
          Title.Caption = 'Code'
          Visible = True
        end>
    end
  end
  object ActionList: TActionList
    Left = 300
    Top = 112
    object actExportToExel: TAction
      Caption = 'Export to MS Exel'
      ShortCut = 16453
      OnExecute = actExportToExelExecute
    end
    object actFindProducts: TAction
      Caption = 'Find products'
      ShortCut = 16454
      OnExecute = actFindProductsExecute
    end
    object actRefresh: TAction
      Caption = 'Refresh data'
      ShortCut = 116
      OnExecute = actRefreshExecute
    end
  end
  object PopupMenu: TPopupMenu
    Left = 384
    Top = 112
    object ExporttoMSExel1: TMenuItem
      Action = actExportToExel
    end
    object Findproducts1: TMenuItem
      Action = actFindProducts
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Refreshdata1: TMenuItem
      Action = actRefresh
    end
  end
end

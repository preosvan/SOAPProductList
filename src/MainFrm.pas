unit MainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ComCtrls, Vcl.StdCtrls, System.Actions, Vcl.ActnList,
  PLClasses, Vcl.Menus;

type
  TMainForm = class(TForm)
    pnLeft: TPanel;
    pnBottom: TPanel;
    pnClient: TPanel;
    Splitter: TSplitter;
    pnTitleTree: TPanel;
    pnTitleGrid: TPanel;
    tvCategories: TTreeView;
    dbgProducts: TDBGrid;
    ActionList: TActionList;
    actExportToExel: TAction;
    actFindProducts: TAction;
    btnExportToExcel: TButton;
    btnFindProducts: TButton;
    edFindText: TEdit;
    edFindCatalogID: TEdit;
    edFindLimit: TEdit;
    actRefresh: TAction;
    PopupMenu: TPopupMenu;
    ExporttoMSExel1: TMenuItem;
    Findproducts1: TMenuItem;
    N1: TMenuItem;
    Refreshdata1: TMenuItem;
    procedure edFindTextEnter(Sender: TObject);
    procedure edFindTextExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edFindParamChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actFindProductsExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure tvCategoriesChange(Sender: TObject; Node: TTreeNode);
    procedure actExportToExelExecute(Sender: TObject);
    procedure dbgProductsCellClick(Column: TColumn);
  private
    FCategoryList: TCategoryList;
    FProdList: TProdList;
    function GetFindText: string;
    procedure SetFindText(const Value: string);
    function GetFindLimit: Integer;
    procedure SetFindLimit(const Value: Integer);
    function GetFindCatalogID: Integer;
    procedure SetFindCatalogID(const Value: Integer);
    procedure InitParams;
    procedure InitActions;
    procedure LoadObjects;
  public
    property CategoryList: TCategoryList read FCategoryList write FCategoryList;
    property ProdList: TProdList read FProdList write FProdList;
    property FindText: string read GetFindText write SetFindText;
    property FindLimit: Integer read GetFindLimit write SetFindLimit;
    property FindCatalogID: Integer read GetFindCatalogID write SetFindCatalogID;
  end;

var
  MainForm: TMainForm;

implementation

uses
  PLConst, PLDataModule, SOAPQuadService, PLView, PLExcelUtils;

{$R *.dfm}

procedure TMainForm.actExportToExelExecute(Sender: TObject);
begin
  ExportGridToExcel(dbgProducts);
end;

procedure TMainForm.actFindProductsExecute(Sender: TObject);
var
  QuadService: IQuadService;
  SessionKey: string;
  ProductList: TProductList;
  I: Integer;
begin
  QuadService := GetIQuadService(True, '', DM.HTTPRIO);
  if Assigned(QuadService) then
  begin
    SessionKey := QuadService.Connection(SOAP_USER_KEY);
    if not SessionKey.IsEmpty then
    begin
      ProductList := QuadService.FindProducts(SessionKey, FindText, FindLimit, FindCatalogID);
      for I := 0 to High(ProductList) do
        CategoryList.Add(ProductList[I].Category);
      for I := 0 to High(ProductList) do
        ProdList.Add(ProductList[I], CategoryList.GetIdByFullPath(ProductList[I].Category));
      if DM.Connected then
      begin
        if CategoryList.IsModify then
        begin
          CategoryList.Save(DM.Query);
          CategoryListToTreeView(CategoryList, tvCategories);
        end;
        if ProdList.IsModify then
          ProdList.Save(DM.Query);
      end;
    end;
  end;
end;

procedure TMainForm.actRefreshExecute(Sender: TObject);
begin
  LoadObjects;
end;

procedure TMainForm.dbgProductsCellClick(Column: TColumn);
begin
  InitActions;
end;

procedure TMainForm.edFindParamChange(Sender: TObject);
begin
  InitActions;
end;

procedure TMainForm.edFindTextEnter(Sender: TObject);
begin
  if Trim(edFindText.Text) = TXT_EN_INPUT_SEARCH then
  begin
    edFindText.Text := EmptyStr;
    edFindText.Font.Color := clBlack;
  end;
end;

procedure TMainForm.edFindTextExit(Sender: TObject);
begin
  if (Trim(edFindText.Text) = TXT_EN_INPUT_SEARCH) or
     (Trim(edFindText.Text) = EmptyStr) then
  begin
    edFindText.Text := TXT_EN_INPUT_SEARCH;
    edFindText.Font.Color := clGray;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FCategoryList := TCategoryList.Create;
  FProdList := TProdList.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FCategoryList);
  FreeAndNil(FProdList);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  InitParams;
end;

function TMainForm.GetFindCatalogID: Integer;
begin
  Result := StrToIntDef(edFindCatalogID.Text, FIND_CATALOG_ID_DEF);
end;

function TMainForm.GetFindText: string;
begin
  if Trim(edFindText.Text) <> TXT_EN_INPUT_SEARCH then
    Result := edFindText.Text
  else
    Result := EmptyStr;
end;

function TMainForm.GetFindLimit: Integer;
begin
  Result := StrToIntDef(edFindLimit.Text, FIND_LIMIT_DEF);
end;

procedure TMainForm.InitActions;
begin
  actFindProducts.Enabled := (FindText <> EmptyStr) and (FindLimit > 0) and
    (FindCatalogID > 0);
  actExportToExel.Enabled := dbgProducts.SelectedRows.Count > 0;
end;

procedure TMainForm.InitParams;
begin
  FindText := TXT_EN_INPUT_SEARCH;
  if DM.Connected then
    LoadObjects;
  InitActions;
end;

procedure TMainForm.LoadObjects;
begin
  CategoryList.Load(DM.Query);
  ProdList.Load(DM.Query);
  CategoryListToTreeView(CategoryList, tvCategories);
  DM.ProductsRefresh(0);
end;

procedure TMainForm.SetFindCatalogID(const Value: Integer);
begin
  edFindCatalogID.Text := Value.ToString;
end;

procedure TMainForm.SetFindText(const Value: string);
begin
  edFindText.Text := Value;
  edFindTextExit(edFindText);
end;

procedure TMainForm.tvCategoriesChange(Sender: TObject; Node: TTreeNode);
begin
  if Assigned(Node) then
  begin
    DM.ProductsRefresh(CategoryList.GetIdByName(Trim(Node.Text)));
    InitActions;
  end;
end;

procedure TMainForm.SetFindLimit(const Value: Integer);
begin
  edFindLimit.Text := Value.ToString;
end;

end.

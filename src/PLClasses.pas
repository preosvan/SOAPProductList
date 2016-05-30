unit PLClasses;

interface

uses
  System.Classes, PLListClasses, FireDAC.Comp.Client, SOAPQuadService;

type
  TCategoryItem = class(TCustomItem)
  private
    FParentId: Integer;
    function GetIsRoot: Boolean;
  public
    property ParentId: Integer read FParentId write FParentId;
    property IsRoot: Boolean read GetIsRoot;
    constructor Create(AId, AParentId: Integer; AName: string); overload;
  end;

  TCategoryList = class(TCustomList)
  public
    function Add(AFullPath: string): TCategoryItem; overload;
    function GetIdByFullPath(AFullPath: string): Integer;
    function Exist(ACategoryName: string): Boolean;
    function Load(AQuery: TFDQuery): Boolean;
    function Save(AQuery: TFDQuery): Boolean;
  end;

  TProductItem = class(TCustomItem)
  private
    FCode: string;
    FBrand: string;
    FCategoryId: Integer;
    FMinPrice: Double;
    function GetModel: string;
    procedure SetModel(const Value: string);
  published
    property CategoryId: Integer read FCategoryId write FCategoryId;
    property Model: string read GetModel write SetModel;
    property Code: string read FCode write FCode;
    property Brand: string read FBrand write FBrand;
    property MinPrice: Double read FMinPrice write FMinPrice;
    constructor Create(AId, ACategoryId: Integer; AModel, ACode, ABrand: string;
      AMinPrice: Double); overload;
  end;

  TProdList = class(TCustomList)
  public
    function Add(AProduct: TProduct; ACategoryId: Integer): TProductItem; overload;
    function GetItemByCode(ACode: string): TProductItem;
    function Exist(AProductCode: string): Boolean;
    function Load(AQuery: TFDQuery): Boolean;
    function Save(AQuery: TFDQuery): Boolean;
  end;

implementation

uses
  System.SysUtils, PLConst, Vcl.Dialogs;

{ TProductGroup }

constructor TCategoryItem.Create(AId, AParentId: Integer; AName: string);
begin
  inherited Create(AId, AName);
  FParentId := AParentId;
end;

{ TProductGroupList }

function TCategoryList.Add(AFullPath: string): TCategoryItem;
var
  SL: TStringList;
  I, ParentId: Integer;
  CategoryName: string;
begin
  Result := nil;
  SL := TStringList.Create;
  try
    SL := TStringList.Create;
    SL.StrictDelimiter := True;
    SL.Delimiter := CATALOG_DELIMITER;
    SL.DelimitedText := AFullPath;
    CategoryName := '';
    ParentId := 0;
    for I := 0 to SL.Count - 1 do
    begin
      CategoryName := Trim(SL[I]);
      if not Exist(CategoryName) then
      begin
        Result := Add(TCategoryItem.Create(NextId, ParentId, CategoryName)) as TCategoryItem;
        Result.State := siInsert;
        ParentId := Result.Id;
      end
      else
        ParentId := GetIdByName(CategoryName);
    end;
  finally
    FreeAndNil(SL);
  end;
end;

function TCategoryList.Exist(ACategoryName: string): Boolean;
begin
  Result := Assigned(GetItemByName(ACategoryName));
end;

function TCategoryList.GetIdByFullPath(AFullPath: string): Integer;
var
  SL: TStringList;
  CategoryName: string;
begin
  Result := 0;
  SL := TStringList.Create;
  try
    SL := TStringList.Create;
    SL.StrictDelimiter := True;
    SL.Delimiter := CATALOG_DELIMITER;
    SL.DelimitedText := AFullPath;
    CategoryName := Trim(SL[SL.Count - 1]);
    Result := GetIdByName(CategoryName);
  finally
    FreeAndNil(SL);
  end;
end;

function TCategoryList.Load(AQuery: TFDQuery): Boolean;
begin
  Result := True;
  Clear;
  AQuery.SQL.Text := 'select * from Categories order by CategoryName';
  try
    try
      AQuery.Open;
      while not AQuery.Eof do
      begin
        Add(TCategoryItem.Create(
          AQuery.FieldByName('CategoryId').AsInteger,
          AQuery.FieldByName('CategoryParentId').AsInteger,
          AQuery.FieldByName('CategoryName').AsString));
        AQuery.Next;
      end;
    except
      on E: Exception do
      begin
        MessageDlg(e.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
        Result := False;
      end;
    end;
  finally
    AQuery.Close;
  end;
end;

function TCategoryList.Save(AQuery: TFDQuery): Boolean;
var
  I: Integer;
  Category: TCategoryItem;
begin
  Result := True;
  for I := 0 to Count - 1 do
  begin
    Category := Items[I] as TCategoryItem;
    if Category.State = siInsert then
    begin
      AQuery.Close;
      AQuery.SQL.Clear;
      AQuery.SQL.Add('INSERT INTO Categories ');
      AQuery.SQL.Add(' (CategoryId, CategoryParentId, CategoryName) ');
      AQuery.SQL.Add(' VALUES (' + IntToStr(Category.ID) + ', ');
      AQuery.SQL.Add(IntToStr(Category.ParentId) + ', ');
      AQuery.SQL.Add(QuotedStr(Category.Name) + ') ');
      try
        AQuery.ExecSQL;
      except
        on E: Exception do
        begin
          MessageDlg(e.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
          Result := False;
        end;
      end;
    end;
    Category.State := siNone;
  end;
end;

function TCategoryItem.GetIsRoot: Boolean;
begin
  Result := ParentId = 0;
end;

{ TProduct }

constructor TProductItem.Create(AId, ACategoryId: Integer; AModel, ACode, ABrand: string;
  AMinPrice: Double);
begin
  inherited Create(AId, AModel);
  FCategoryId := ACategoryId;
  FCode := ACode;
  FBrand := ABrand;
  FMinPrice := AMinPrice;
end;

function TProductItem.GetModel: string;
begin
  Result := Name;
end;

procedure TProductItem.SetModel(const Value: string);
begin
  Name := Value;
end;

{ TProductList }

function TProdList.Add(AProduct: TProduct; ACategoryId: Integer): TProductItem;
begin
  Result := nil;
  if Assigned(AProduct) and (ACategoryId > 0) then
  begin
    if not Exist(AProduct.Code) then
    begin
      Result := Add(TProductItem.Create(NextId, ACategoryId, AProduct.Model,
        AProduct.Code, AProduct.Brand, AProduct.MinPrice)) as TProductItem;
      Result.State := siInsert;
    end
  end;
end;

function TProdList.Exist(AProductCode: string): Boolean;
begin
  Result := Assigned(GetItemByCode(AProductCode));
end;

function TProdList.GetItemByCode(ACode: string): TProductItem;
var
  I: Integer;
  Item: TProductItem;
begin
  Result := nil;
  LockList;
  try
    for I := 0 to Count - 1 do
    begin
      Item := Items[I] as TProductItem;
      if Assigned(Item) then
        if Item.Code = ACode then
        begin
          Result := Item;
          Break;
        end;
    end;
  finally
    UnlockList;
  end;
end;

function TProdList.Load(AQuery: TFDQuery): Boolean;
begin
  Result := True;
  Clear;
  AQuery.SQL.Text := 'select * from Products order by CategoryId, ProductName';
  try
    try
      AQuery.Open;
      while not AQuery.Eof do
      begin
        Add(TProductItem.Create(
          AQuery.FieldByName('ProductId').AsInteger,
          AQuery.FieldByName('CategoryId').AsInteger,
          AQuery.FieldByName('ProductName').AsString,
          AQuery.FieldByName('ProductCode').AsString,
          AQuery.FieldByName('ProductBrand').AsString,
          AQuery.FieldByName('MinPrice').AsFloat));
        AQuery.Next;
      end;
    except
      on E: Exception do
      begin
        MessageDlg(e.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
        Result := False;
      end;
    end;
  finally
    AQuery.Close;
  end;
end;

function TProdList.Save(AQuery: TFDQuery): Boolean;
var
  I: Integer;
  Product: TProductItem;
begin
  Result := True;
  for I := 0 to Count - 1 do
  begin
    Product := Items[I] as TProductItem;
    if Product.State = siInsert then
    begin
      AQuery.Close;
      AQuery.SQL.Clear;
      AQuery.SQL.Add('INSERT INTO Products ');
      AQuery.SQL.Add(' (ProductId, CategoryId, ProductName, ProductCode, ProductBrand, MinPrice) ');
      AQuery.SQL.Add(' VALUES (' + IntToStr(Product.ID) + ', ');
      AQuery.SQL.Add(IntToStr(Product.CategoryId) + ', ');
      AQuery.SQL.Add(QuotedStr(Product.Model) + ', ');
      AQuery.SQL.Add(QuotedStr(Product.Code) + ', ');
      AQuery.SQL.Add(QuotedStr(Product.Brand) + ', ');
      AQuery.SQL.Add(FloatToStr(Product.MinPrice) + ') ');
      try
        AQuery.ExecSQL;
      except
        on E: Exception do
        begin
          MessageDlg(e.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
          Result := False;
        end;
      end;
    end;
    Product.State := siNone;
  end;
end;

end.

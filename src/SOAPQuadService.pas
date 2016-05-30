unit SOAPQuadService;

interface

uses Soap.InvokeRegistry, Soap.SOAPHTTPClient, System.Types, Soap.XSBuiltIns;

type
  RemException = class;
  TFindResponse = class;
  TUserAccess = class;
  TFindQuery = class;
  TOption = class;
  TProduct = class;
  TProductWDesc = class;
  TPopular = class;

  TPopularList = array of TPopular;
  TProductWDescList = array of TProductWDesc;

  RemException = class(ERemotableException);

  TOptionList = array of TOption;
  TArray_System_Byte_ = array of Byte;

  TFindResponse = class(TRemotable)
  private
    FFindData: TArray_System_Byte_;
  published
    property FindData: TArray_System_Byte_  read FFindData write FFindData;
  end;

  TProductList = array of TProduct;

  TUserAccess = class(TRemotable)
  private
    FValidTo: TXSDateTime;
    FFindAccess: Boolean;
    FFindValidTo: TXSDateTime;
    FProdDescAccess: Boolean;
    FProdDescValidTo: TXSDateTime;
    FGroupDescAccess: Boolean;
    FGroupDescValidTo: TXSDateTime;
    FPriceAccess: Boolean;
    FPriceValidTo: TXSDateTime;
    FPopulValidTo: TXSDateTime;
  public
    destructor Destroy; override;
  published
    property ValidTo: TXSDateTime read FValidTo write FValidTo;
    property FindAccess: Boolean read FFindAccess write FFindAccess;
    property FindValidTo: TXSDateTime read FFindValidTo write FFindValidTo;
    property ProdDescAccess: Boolean read FProdDescAccess write FProdDescAccess;
    property ProdDescValidTo: TXSDateTime read FProdDescValidTo write FProdDescValidTo;
    property GroupDescAccess: Boolean read FGroupDescAccess write FGroupDescAccess;
    property GroupDescValidTo: TXSDateTime read FGroupDescValidTo write FGroupDescValidTo;
    property PriceAccess: Boolean read FPriceAccess write FPriceAccess;
    property PriceValidTo: TXSDateTime read FPriceValidTo write FPriceValidTo;
    property PopulValidTo: TXSDateTime read FPopulValidTo write FPopulValidTo;
  end;

  TFindQuery = class(TRemotable)
  private
    FFindData: TArray_System_Byte_;
  published
    property FindData: TArray_System_Byte_  read FFindData write FFindData;
  end;

  TOption = class(TRemotable)
  private
    FOptionType: Integer;
    FCode: string;
    FTitle: string;
    FValue: string;
    FIsMy: Byte;
    FLastModified: TXSDateTime;
  public
    destructor Destroy; override;
  published
    property OptionType: Integer read FOptionType write FOptionType;
    property Code: string read FCode write FCode;
    property Title: string read FTitle write FTitle;
    property Value: string read FValue write FValue;
    property IsMy: Byte read FIsMy write FIsMy;
    property LastModified: TXSDateTime read FLastModified write FLastModified;
  end;

  TStrList   = array of string;                 { "urn:QuadServiceIntf"[GblCplx] }

  TProduct = class(TRemotable)
  private
    FCode: string;
    FModel: string;
    FBrand: string;
    FCategory: string;
    FMinPrice: Double;
    FRank: Double;
  published
    property Code: string read FCode write FCode;
    property Model: string read FModel write FModel;
    property Brand: string read FBrand write FBrand;
    property Category: string read FCategory write FCategory;
    property MinPrice: Double read FMinPrice write FMinPrice;
    property Rank: Double read FRank write FRank;
  end;

  TProductWDesc = class(TProduct)
  private
    FTitle: string;
    FShortDesc: string;
    FFullDesc: string;
    FCharact: string;
    FUrl: string;
    FManLegAddr: string;
    FManProdAddr: string;
    FImpAddr: string;
    FServAddr: string;
    FExplPer: Integer;
    FPopular: Double;
    FFacts: string;
    FRating: Double;
    FIsGroup: Boolean;
    FIsModification: Boolean;
    FParentCode: string;
  published
    property Title: string read FTitle write FTitle;
    property ShortDesc: string read FShortDesc write FShortDesc;
    property FullDesc: string read FFullDesc write FFullDesc;
    property Charact: string read FCharact write FCharact;
    property Url: string read FUrl write FUrl;
    property ManLegAddr: string read FManLegAddr write FManLegAddr;
    property ManProdAddr: string read FManProdAddr write FManProdAddr;
    property ImpAddr: string read FImpAddr write FImpAddr;
    property ServAddr: string read FServAddr write FServAddr;
    property ExplPer: Integer read FExplPer write FExplPer;
    property Popular: Double read FPopular write FPopular;
    property Facts: string read FFacts write FFacts;
    property Rating: Double read FRating write FRating;
    property IsGroup: Boolean read FIsGroup write FIsGroup;
    property IsModification: Boolean read FIsModification write FIsModification;
    property ParentCode: string read FParentCode write FParentCode;
  end;

  TPopular = class(TRemotable)
  private
    FDate: TXSDateTime;
    FValue: Double;
  public
    destructor Destroy; override;
  published
    property Date:  TXSDateTime read FDate write FDate;
    property Value: Double read FValue write FValue;
  end;

  IQuadService = interface(IInvokable)
  ['{2FF01436-4033-BCD5-C979-DC48E5856AD5}']
    function  Connection(const AUserKey: string): string; stdcall;
    procedure Disconnection(const ACHash: string); stdcall;
    function  GetUserAccess(const ACHash: string): TUserAccess; stdcall;
    function  FindProducts(const ACHash: string; const AFindStr: string; const ALimit: Byte; const ACatID: Integer): TProductList; stdcall;
    function  BatchFindProducts(const ACHash: string; const AFindQuery: TFindQuery; const ALimit: Byte; const ACatID: Integer): TFindResponse; stdcall;
    function  FindProducts1(const ACHash: string; const ABrandStr: string; const AModelStr: string; const ACatalogStr: string; const ALimit: Byte; const ACatID: Integer): TProductList; stdcall;
    function  GetCatalogList(const ACHash: string; const ACatID: Integer): TStrList; stdcall;
    function  GetBrandList(const ACHash: string; const ACatalogStr: string; const ACatID: Integer): TStrList; stdcall;
    function  GetProductList(const ACHash: string; const ACatalogStr: string; const ABrandStr: string; const ACatID: Integer): TProductList; stdcall;
    function  GetProductsByCodes(const ACHash: string; const ACodeList: TStrList; const ACatID: Integer): TProductList; stdcall;
    function  GetProductWDescList(const ACHash: string; const ACatalogStr: string; const ABrandStr: string; const AFields: Word; const ACatID: Integer): TProductWDescList; stdcall;
    function  GetProductsWDescByCodes(const ACHash: string; const ACodeList: TStrList; const AFields: Word; const ACatID: Integer): TProductWDescList; stdcall;
    function  GetProductsPriceByCodes(const ACHash: string; const ACodeList: TStrList): TStrList; stdcall;
    function  GetOnlinerPriceTime(const ACHash: string): TXSDateTime; stdcall;
    function  GetProductCode(const ACHash: string; const ACatalog: string; const ABrand: string; const AModel: string; const ACatID: Integer): string; stdcall;
    function  GetProductHTMLbyCode(const ACHash: string; const ACodeStr: string; const ACatID: Integer): string; stdcall;
    function  GetCategoryPopularStat(const ACHash: string; const ACatID: Integer; const APopID: Integer; const ACategoryTitle: string; const ADateFrom: TXSDateTime; const ADateTo: TXSDateTime): TPopularList; stdcall;
    function  GetQuadOptions(const ACHash: string; const AListType: Integer; const AOptionType: Integer; const AOptionCode: string; const AModifiedFrom: TXSDateTime): TOptionList; stdcall;
    procedure SetQuadOption(const ACHash: string; const AOptionType: Integer; const AOptionCode: string; const AOptionTitle: string; const AOptionValue: string); stdcall;
    procedure DeleteQuadOption(const ACHash: string; const AOptionCode: string); stdcall;
    procedure AddUserStat(const ACHash: string; const AStatID: Integer; const AStrValue: string; const AFloatValue: Double); stdcall;
    function  GetMaxUserStat(const ACHash: string; const AStatID: Integer): Double; stdcall;
    function  GetSumUserStat(const ACHash: string; const AStatID: Integer): Double; stdcall;
    procedure AddModel(const ACHash: string; const AModel: TProductWDesc; const ACatID: Integer); stdcall;
  end;

function GetIQuadService(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): IQuadService;

implementation
  uses System.SysUtils;

function GetIQuadService(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): IQuadService;
const
  defWSDL = 'http://148.251.190.144/IQuadNet.dll/wsdl/IQuadService';
  defURL  = 'http://148.251.190.144/IQuadNet.dll/soap/IQuadService';
  defSvc  = 'IQuadServiceservice';
  defPrt  = 'IQuadServicePort';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as IQuadService);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


destructor TUserAccess.Destroy;
begin
  System.SysUtils.FreeAndNil(FValidTo);
  System.SysUtils.FreeAndNil(FFindValidTo);
  System.SysUtils.FreeAndNil(FProdDescValidTo);
  System.SysUtils.FreeAndNil(FGroupDescValidTo);
  System.SysUtils.FreeAndNil(FPriceValidTo);
  System.SysUtils.FreeAndNil(FPopulValidTo);
  inherited Destroy;
end;

destructor TOption.Destroy;
begin
  System.SysUtils.FreeAndNil(FLastModified);
  inherited Destroy;
end;

destructor TPopular.Destroy;
begin
  System.SysUtils.FreeAndNil(FDate);
  inherited Destroy;
end;

initialization
  { IQuadService }
  InvRegistry.RegisterInterface(TypeInfo(IQuadService), 'urn:QuadServiceIntf-IQuadService', '');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(IQuadService), 'urn:QuadServiceIntf-IQuadService#%operationName%');
  RemClassRegistry.RegisterXSInfo(TypeInfo(TPopularList), 'urn:QuadServiceIntf', 'TPopularList');
  RemClassRegistry.RegisterXSInfo(TypeInfo(TProductWDescList), 'urn:QuadServiceIntf', 'TProductWDescList');
  RemClassRegistry.RegisterXSClass(RemException, 'urn:QuadServiceIntf', 'RemException');
  RemClassRegistry.RegisterXSInfo(TypeInfo(TOptionList), 'urn:QuadServiceIntf', 'TOptionList');
  RemClassRegistry.RegisterXSInfo(TypeInfo(TArray_System_Byte_), 'urn:System', 'TArray_System_Byte_', 'TArray<System.Byte>');
  RemClassRegistry.RegisterXSClass(TFindResponse, 'urn:QuadServiceIntf', 'TFindResponse');
  RemClassRegistry.RegisterXSInfo(TypeInfo(TProductList), 'urn:QuadServiceIntf', 'TProductList');
  RemClassRegistry.RegisterXSClass(TUserAccess, 'urn:QuadServiceIntf', 'TUserAccess');
  RemClassRegistry.RegisterXSClass(TFindQuery, 'urn:QuadServiceIntf', 'TFindQuery');
  RemClassRegistry.RegisterXSClass(TOption, 'urn:QuadServiceIntf', 'TOption');
  RemClassRegistry.RegisterXSInfo(TypeInfo(TStrList), 'urn:QuadServiceIntf', 'TStrList');
  RemClassRegistry.RegisterXSClass(TProduct, 'urn:QuadServiceIntf', 'TProduct');
  RemClassRegistry.RegisterXSClass(TProductWDesc, 'urn:QuadServiceIntf', 'TProductWDesc');
  RemClassRegistry.RegisterXSClass(TPopular, 'urn:QuadServiceIntf', 'TPopular');

end.
unit PLDataModule;

interface

uses
  System.SysUtils, System.Classes, Soap.InvokeRegistry, Soap.Rio,
  Soap.SOAPHTTPClient, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.MSAcc,
  FireDAC.Phys.MSAccDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet;

type
  TDM = class(TDataModule)
    HTTPRIO: THTTPRIO;
    FDQuery: TFDQuery;
    FDConnection: TFDConnection;
    FDQueryProducts: TFDQuery;
    dsProducts: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure InitConnection;
    procedure InitSOAP;
    function GetConnected: Boolean;
  public
    procedure ProductsRefresh(ACategoryId: Integer);
    property Connected: Boolean read GetConnected;
    property Query: TFDQuery read FDQuery write FDQuery;
  end;

var
  DM: TDM;

implementation

uses
  Vcl.Dialogs, PLConst;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function TDM.GetConnected: Boolean;
begin
  Result := FDConnection.Connected;
end;

procedure TDM.InitConnection;
var
  PathToDB: string;
const
  MSG_ERROR_CONNECT = 'Unable to connect to database: ';
begin
  PathToDB := ExtractFilePath(ParamStr(0)) + DB_NAME;
  FDConnection.Params.Values['Database'] := PathToDB;
  try
    if FDConnection.Connected then
      FDConnection.Connected := False;
    FDConnection.Connected := True;
  except on e: Exception do
    MessageDlg(MSG_ERROR_CONNECT + #13#10 + PathToDB + #13#10 +
      ' Error: ' + e.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0)
  end;
end;

procedure TDM.InitSOAP;
begin
  HTTPRIO.WSDLLocation := SOAP_WSDL;
end;

procedure TDM.ProductsRefresh(ACategoryId: Integer);
begin
  if FDQueryProducts.Active then
    FDQueryProducts.Close;
  FDQueryProducts.ParamByName('pCategoryId').AsInteger := ACategoryId;
  FDQueryProducts.Open;
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  InitConnection;
  InitSOAP;
end;

end.

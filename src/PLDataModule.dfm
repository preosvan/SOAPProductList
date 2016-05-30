object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 368
  Width = 143
  object HTTPRIO: THTTPRIO
    WSDLLocation = 'http://148.251.190.144/IQuadNet.dll/wsdl/IQuadService'
    Service = 'IQuadServiceservice'
    Port = 'IQuadServicePort'
    HTTPWebNode.UseUTF8InHeader = True
    HTTPWebNode.InvokeOptions = [soIgnoreInvalidCerts, soAutoCheckAccessPointViaUDDI]
    HTTPWebNode.WebNodeOptions = []
    Converter.Options = [soSendMultiRefObj, soTryAllSchema, soRootRefNodesToBody, soCacheMimeResponse, soUTF8EncodeXML]
    Left = 56
    Top = 32
  end
  object FDQuery: TFDQuery
    Connection = FDConnection
    Left = 56
    Top = 160
  end
  object FDConnection: TFDConnection
    Params.Strings = (
      
        'Database=E:\DelphiProjects\_Puntus\ProductList\bin\Win32\Debug\P' +
        'LDatabase.mdb'
      'DriverID=MSAcc')
    LoginPrompt = False
    Left = 56
    Top = 96
  end
  object FDQueryProducts: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'Select * from products where CategoryId = :pCategoryId;')
    Left = 56
    Top = 224
    ParamData = <
      item
        Name = 'PCATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object dsProducts: TDataSource
    DataSet = FDQueryProducts
    Left = 56
    Top = 288
  end
end

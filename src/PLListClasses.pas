unit PLListClasses;

interface

uses
  System.Classes, Winapi.Windows;

type
  TStateItem = (siNone, siInsert);

  TCustomItem = class(TPersistent)
  private
    FId: Integer;
    FName: string;
    FState: TStateItem;
  public
    constructor Create(AId: Integer; AName: string); overload;
    property Id: Integer read FId write FId;
    property Name: string read FName write FName;
    property State: TStateItem read FState write FState;
  end;

  TCustomList = class(TPersistent)
  private
    FList: TList;
    FLock: TRTLCriticalSection;
    FIsLoaded: Boolean;
    function GetCount: Integer;
    function GetItems(Index: Integer): TCustomItem;
    function GetLastId: Integer;
    function GetLastItem: TCustomItem;
    function GetNextId: Integer;
    function GetIsModify: Boolean;
  public
    constructor Create; overload;
    destructor Destroy; override;
    function Add(AItem: TCustomItem): TCustomItem; overload;
    procedure Clear(AIsFreeItems: Boolean = True); virtual;
    procedure DestroyNotClear;
    function GetIdByName(AName: string): Integer;
    function GetItemById(AId: Integer): TCustomItem;
    function GetItemByName(AName: string): TCustomItem;
    function LockList: TList;
    procedure Remove(AItem: TCustomItem; IsFreeItem: Boolean = False);
    procedure Sort(ACompare: TListSortCompare);
    procedure UnlockList;
    property Count: Integer read GetCount;
    property Items[Index: integer]: TCustomItem read GetItems; default;
    property LastId: Integer read GetLastId;
    property NextId: Integer read GetNextId;
    property LastItem: TCustomItem read GetLastItem;
    property IsModify: Boolean read GetIsModify;
  end;

  function CompareByName(AItem1, AItem2: Pointer): Integer;

implementation

function CompareByName(AItem1, AItem2: Pointer): Integer;
var
  Item1, Item2: TCustomItem;
begin
  Result := 0;
  Item1 := TCustomItem(AItem1);
  Item2 := TCustomItem(AItem2);
  if Item1.Name > Item2.Name then
    Result := 1
  else if Item1.Name = Item2.Name then
    Result := 0
  else if Item1.Name < Item2.Name then
    Result := -1;
end;

{ TCustomItem }

constructor TCustomItem.Create(AId: Integer; AName: string);
begin
  inherited Create;
  FId := AId;
  FName := AName;
end;

{ TCustomItems }

function TCustomList.Add(AItem: TCustomItem): TCustomItem;
begin
  Result := nil;
  LockList;
  try
    FList.Add(AItem);
    Result := AItem;
  finally
    UnlockList;
  end;
end;

procedure TCustomList.Clear(AIsFreeItems: Boolean);
var
  I: Integer;
begin
  if Assigned(FList) then
  begin
    if AIsFreeItems then
      for I := FList.Count - 1 downto 0 do
        if Assigned(FList[I]) then
        begin
          TCustomItem(FList[I]).Free;
          FList[I] := nil;
        end;
    FList.Clear;
  end;
end;

constructor TCustomList.Create;
begin
  inherited Create;
  InitializeCriticalSection(FLock);
  FList := TList.Create;
end;

destructor TCustomList.Destroy;
begin
  Clear;
  LockList;
  try
    FList.Free;
    inherited;
  finally
    UnlockList;
    DeleteCriticalSection(FLock);
  end;
end;

procedure TCustomList.DestroyNotClear;
begin
  LockList;
  try
    FList.Free;
    inherited;
  finally
    UnlockList;
    DeleteCriticalSection(FLock);
  end;
end;

function TCustomList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TCustomList.GetIdByName(AName: string): Integer;
var
  I: Integer;
  Item: TCustomItem;
begin
  Result := 0;
  LockList;
  try
    for I := 0 to Count - 1 do
    begin
      Item := FList[I];
      if Assigned(Item) then
        if Item.Name = AName then
        begin
          Result := Item.Id;
          Break;
        end;
    end;
  finally
    UnlockList;
  end;
end;

function TCustomList.GetIsModify: Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Count - 1 do
  if Items[I].State <> siNone then
  begin
    Result := True;
    Break;
  end;
end;

function TCustomList.GetItemById(AId: Integer): TCustomItem;
var
  I: Integer;
  Item: TCustomItem;
begin
  Result := nil;
  LockList;
  try
    for I := 0 to Count - 1 do
    begin
      Item := FList[I];
      if Assigned(Item) then
        if Item.Id = AId then
        begin
          Result := Item;
          Break;
        end;
    end;
  finally
    UnlockList;
  end;
end;

function TCustomList.GetItemByName(AName: string): TCustomItem;
var
  I: Integer;
  Item: TCustomItem;
begin
  Result := nil;
  LockList;
  try
    for I := 0 to Count - 1 do
    begin
      Item := FList[I];
      if Assigned(Item) then
        if Item.Name = AName then
        begin
          Result := Item;
          Break;
        end;
    end;
  finally
    UnlockList;
  end;
end;

function TCustomList.GetItems(Index: Integer): TCustomItem;
begin
  if Index < FList.Count then
    Result := FList[Index] else
    Result := nil;
end;

function TCustomList.GetLastId: Integer;
var
  I: Integer;
  Item: TCustomItem;
begin
  Result := 0;
  if Assigned(FList) then
  begin
    LockList;
    try
      for I := 0 to FList.Count - 1 do
      begin
        Item := FList[I];
        if Result < Item.Id then
          Result := Item.Id;
      end;
    finally
      UnlockList;
    end;
  end;
end;

function TCustomList.GetLastItem: TCustomItem;
begin
  Result := GetItemById(LastId);
end;

function TCustomList.GetNextId: Integer;
begin
  Result := LastId + 1;
end;

function TCustomList.LockList: TList;
begin
  EnterCriticalSection(FLock);
  Result := FList;
end;

procedure TCustomList.Remove(AItem: TCustomItem; IsFreeItem: Boolean);
var
  I: Integer;
begin
  LockList;
  try
    for I := 0 to Count - 1 do
    if FList[I] = AItem then
    begin
      if IsFreeItem then
        AItem.Free;
      FList.Delete(I);
      Break;
    end;
  finally
    UnlockList;
  end;
end;

procedure TCustomList.Sort(ACompare: TListSortCompare);
begin
  FList.Sort(ACompare);
end;

procedure TCustomList.UnlockList;
begin
  LeaveCriticalSection(FLock);
end;

end.

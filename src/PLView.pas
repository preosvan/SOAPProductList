unit PLView;

interface

uses
  PLClasses, Vcl.ComCtrls, Vcl.DBGrids;

procedure CategoryListToTreeView(ACategoryList: TCategoryList; ATreeView: TTreeView);
procedure ProdListToGrid(AProdList: TProdList; AGrid: TDBGrid);

implementation

uses
  PLListClasses;

procedure InitChild(ACategoryList: TCategoryList; ATreeView: TTreeView;
  ARootCategory: TCategoryItem; ARootNode: TTreeNode);
var
  Category: TCategoryItem;
  TreeNode: TTreeNode;
  I: Integer;
begin
  for I := 0 to ACategoryList.Count - 1 do
  begin
    Category := ACategoryList[I] as TCategoryItem;
    if not Category.IsRoot and (Category.ParentId = ARootCategory.Id) then
    begin
      TreeNode := ATreeView.Items.AddChild(ARootNode, Category.Name);
      InitChild(ACategoryList, ATreeView, Category, TreeNode);
    end;
  end;

end;

procedure CategoryListToTreeView(ACategoryList: TCategoryList; ATreeView: TTreeView);
var
  I: Integer;
  Category: TCategoryItem;
  TreeNode: TTreeNode;
begin
  ATreeView.Items.BeginUpdate;
  try
    ATreeView.Items.Clear;
    ACategoryList.Sort(CompareByName);
    for I := 0 to ACategoryList.Count - 1 do
    begin
      Category := ACategoryList[I] as TCategoryItem;
      if Category.IsRoot then
      begin
        TreeNode := ATreeView.Items.AddChild(nil, Category.Name);
        InitChild(ACategoryList, ATreeView, Category, TreeNode);
      end;
    end;
  finally
    ATreeView.Items.EndUpdate;
  end;
end;

procedure ProdListToGrid(AProdList: TProdList; AGrid: TDBGrid);
begin

end;

end.

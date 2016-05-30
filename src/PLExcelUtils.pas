unit PLExcelUtils;

interface

uses
  Vcl.DBGrids;

procedure ExportGridToExcel(ADBGrid: TDBGrid);

implementation

uses
  System.Win.ComObj, System.Variants, System.Classes, System.SysUtils,
  Vcl.Dialogs, System.IOUtils, Vcl.Forms;

procedure ExcelSaveAs(AExcelObj: OleVariant; APathToFile: string; AWorkBookIdx: Integer = 1);
const
  xlExcel9795 = $0000002B;
  xlExcel8 = 56;
begin
  try
    //формат xls 97-2003 если установлен 2007-2013 Excel
    AExcelObj.Workbooks[AWorkBookIdx].SaveAs(APathToFile, xlExcel8);
  except
    try
      //формат xls 97-2003 если установлен 2003 Excel
      AExcelObj.Workbooks[AWorkBookIdx].SaveAs(APathToFile, xlExcel9795);
    except

    end;
  end;
end;

procedure ExportGridToExcel(ADBGrid: TDBGrid);
const
  SHEET_NAME = 'ExportData';
var
  Excel, Sheet, Range: OleVariant;
  I, J: Integer;
  TabGrid: Variant;
begin
  if Assigned(ADBGrid) then
  begin
    //Check Excel
    try
      Excel := CreateOleObject('Excel.Application');
    except
      MessageDlg('Microsoft Excel is not installed!',
        TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
    end;

    try
      Excel.WorkBooks.Add;
      Sheet := Excel.Worksheets.Add;
      Sheet.Name := SHEET_NAME;
      Excel.Visible := False;
      Excel.DisplayAlerts := False;
      Excel.EnableEvents := False;
      Excel.ScreenUpdating := False;

      TabGrid := VarArrayCreate([0, ADBGrid.SelectedRows.Count + 1, 0, ADBGrid.DataSource.DataSet.FieldCount - 1], VarOleStr);

      //Columns Title
      for J := 0 to ADBGrid.Columns.Count - 1 do
        TabGrid[0, J] := Trim(ADBGrid.Columns[J].Title.Caption);
      //Data
      for I := 0 to ADBGrid.SelectedRows.Count - 1 do
      begin
        ADBGrid.DataSource.DataSet.GotoBookmark(Pointer(ADBGrid.SelectedRows.Items[I]));
        for J := 0 to ADBGrid.Columns.Count - 1 do
          TabGrid[I + 1, J] :=
            Trim(ADBGrid.DataSource.DataSet.FieldByName(ADBGrid.Columns[J].FieldName).AsString);
      end;

      Sheet.Cells.Clear;
      Sheet.Range['A1', Sheet.Cells.Item[ADBGrid.SelectedRows.Count + 1, ADBGrid.DataSource.DataSet.FieldCount]].Value := TabGrid;
    finally
      Excel.DisplayAlerts := True;
      Excel.EnableEvents := True;
      Excel.ScreenUpdating := True;
      Excel.Visible := True;
      Range := Unassigned;
      Sheet := Unassigned;
    end;
  end;
end;

end.

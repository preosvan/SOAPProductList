program ProductList;

uses
  Vcl.Forms,
  MainFrm in 'MainFrm.pas' {MainForm},
  PLConst in 'PLConst.pas',
  PLDataModule in 'PLDataModule.pas' {DM: TDataModule},
  SOAPQuadService in 'SOAPQuadService.pas',
  PLClasses in 'PLClasses.pas',
  PLListClasses in 'PLListClasses.pas',
  PLView in 'PLView.pas',
  PLExcelUtils in 'PLExcelUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.

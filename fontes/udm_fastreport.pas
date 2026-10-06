unit udm_fastreport;

interface

uses
  System.SysUtils, System.Classes, frxClass, frxExportBaseDialog, frxExportPDF,
  frxExportDOCX, frxExportImage, frxExportCSV;

type
  Tdm_fastreport = class(TDataModule)
    frxPDFExport1: TfrxPDFExport;
    frRelat: TfrxReport;
    frxCSVExport1: TfrxCSVExport;
    frxJPEGExport1: TfrxJPEGExport;
    frxBMPExport1: TfrxBMPExport;
    frxDOCXExport1: TfrxDOCXExport;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm_fastreport: Tdm_fastreport;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.

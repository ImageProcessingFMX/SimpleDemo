program ImageProcessingFMX;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit_FMX_IF in 'Unit_FMX_IF.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.


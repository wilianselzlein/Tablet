program Tablet;

uses
  Forms,
  UTablet in 'UTablet.pas' {FTablet};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Tablet Domper';
  Application.CreateForm(TFTablet, FTablet);
  Application.Run;
end.

program Conversor;

uses
  Forms,
  UDataModule in 'UDataModule.pas' {Datam1: TDataModule},
  EllTypes in 'Comuns\EllTypes.pas',
  UProdutos in 'Comuns\UProdutos.pas',
  dfMensagem in 'Forms\dfMensagem.pas' {fdtMensagem},
  TeladeErro in 'Forms\TeladeErro.pas' {FTeladeErro},
  UPrincipal in 'Forms\UPrincipal.pas' {FPrincipal},
  PaiRotinaEll in 'Forms\PaiRotinaEll.pas' {FPaiRotinaEll},
  PaiConversor in 'Forms\PaiConversor.pas' {FPaiConversor},
  CVD101AA in 'Forms\CVD101AA.pas' {FCVD101AA},
  CVD102AA in 'Forms\CVD102AA.pas' {FCVD102AA},
  CVD201AA in 'Forms\CVD201AA.pas' {FCVD201AA},
  CVD200AA in 'Forms\CVD200AA.pas' {FCVD200AA},
  CVD604AA in 'Forms\CVD604AA.pas' {FCVD604AA},
  CVD603AA in 'Forms\CVD603AA.pas' {FCVD603AA},
  CVD600AA in 'Forms\CVD600AA.pas' {FCVD600AA},
  CVD602AA in 'Forms\CVD602AA.pas' {FCVD602AA},
  CVD802AA in 'Forms\CVD802AA.pas' {FCVD802AA},
  UFornecedores in 'Comuns\UFornecedores.pas',
  UClientes in 'Comuns\UClientes.pas',
  UConfig in 'Comuns\UConfig.pas',
  Interfaces in 'Comuns\Interfaces.pas';

{$R *.res}
{$R winxp.res}

begin
  Application.Initialize;
  Application.Title := 'Conversor';
  Application.CreateForm(TDatam1, Datam1);
  Application.CreateForm(TFPrincipal, FPrincipal);
  Application.Run;
end.

unit UConfig;

interface

uses IniFiles;

type
  TConfiguracao = class(TObject)
  private
    FIniFile: TIniFile;
    FArquivoConf: String;
    FBancoDeDados: String;
    FBancoDeDadosOrigem: String;
    FCaminhoDLL: String;
    FNomeConexaoODBC: String;
    FIdEmpresa: Integer;
  public
    constructor Create(ArquivoConf: String);
    destructor Destroy; override;
    procedure LeConfiguracoes;
  published
    property BancoDeDados: String read FBancoDeDados;
    property BancoDeDadosOrigem: String read FBancoDeDadosOrigem;
    property CaminhoDLL: String read FCaminhoDLL;
    property IdEmpresa: Integer read FIdEmpresa;
    property NomeConexaoODBC: String read FNomeConexaoODBC;
  end;

implementation

{ TConfiguracao }

constructor TConfiguracao.Create(ArquivoConf: String);
begin
   FArquivoConf := ArquivoConf;
   FIniFile     := TIniFile.Create(FArquivoConf);

   LeConfiguracoes;
end;

destructor TConfiguracao.Destroy;
begin
   FIniFile.Free;
   inherited;
end;

procedure TConfiguracao.LeConfiguracoes;
begin
   FBancoDeDados       := FIniFile.ReadString ('Dados', 'Database', '');
   FBancoDeDadosOrigem := FIniFile.ReadString ('Dados', 'DatabaseOrigem', '');
   FCaminhoDll         := FIniFile.ReadString ('Preferencias', 'Firebird', 'GDS32.DLL');
   FIdEmpresa          := FIniFile.ReadInteger('Opcoes',  'EmpresaPadrao', 1);
   FNomeConexaoODBC    := FIniFile.ReadString('conexao_odbc_conversao', 'DataSource', 'sete');
end;

end.

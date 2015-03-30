unit UConfig;

interface

uses IniFiles;

type
  TConfiguracao = class(TObject)
  private
    FIniFile: TIniFile;
    FArquivoConf: String;
    FBancoDeDados: String;
    FCaminhoOrigem: String;
    FCaminhoDLL: String;
    FNomeConexaoODBC: String;
    FIdEmpresa: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LeConfiguracoes;
  published
    property BancoDeDados: String read FBancoDeDados;
    property CaminhoOrigem: String read FCaminhoOrigem;
    property CaminhoDLL: String read FCaminhoDLL;
    property IdEmpresa: Integer read FIdEmpresa;
    property NomeConexaoODBC: String read FNomeConexaoODBC;
    property NomeArquivo: String read FArquivoConf;
  end;

implementation

uses Forms, SysUtils;

{ TConfiguracao }

constructor TConfiguracao.Create;
var
   ArquivoIni: String;
begin
   ArquivoIni := ChangeFileExt(Application.ExeName, '.ini');
   if not FileExists(ArquivoIni) then begin
      ArquivoIni := ExtractFilePath(Application.ExeName) + 'Ello.ini';
   end;

   FArquivoConf := ArquivoIni;
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
   FBancoDeDados    := FIniFile.ReadString ('Dados', 'Database', '');
   FCaminhoOrigem   := FIniFile.ReadString ('Conversao', 'CaminhoOrigem', '');
   FCaminhoDll      := FIniFile.ReadString ('Preferencias', 'Firebird', 'GDS32.DLL');
   FIdEmpresa       := FIniFile.ReadInteger('Opcoes',  'EmpresaPadrao', 1);
   FNomeConexaoODBC := FIniFile.ReadString('conexao_odbc_conversao', 'DataSource', 'teste');
end;

end.

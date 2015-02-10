unit UDataModule;

interface

uses
  SysUtils, Forms, Controls, Classes, DBXpress, DB, ADODB, SqlExpr, IniFiles, EllTypes, unSql,
  EllConnection, FMTBcd;

type
  TDatam1 = class(TDataModule)
    { Private declarations }
    sConnection: TEllConnection;
    ADOConnection: TADOConnection;
    ADOQuery: TADOQuery;
    QueryPesquisa: TSQLQuery;
    QueryTrabalho: TSQLQuery;
    ADOTable1: TADOTable;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FUsuario: String;
  public
    { Public declarations }
  end;

  function MensagemEllo(msg : string; Tipo: TTipoMensagem):boolean;

var
  Datam1: TDatam1;
  TD: TTransactionDesc;
  SqlDados: TEllQuery;

implementation

uses dfMensagem, GravaDados, UConfig;

{$R *.dfm}

procedure TDatam1.DataModuleCreate(Sender: TObject);
var
   ArquivoIni         : String;
   BancoDeDadosOrigem : String;
   sMens              : String;
   DataArq            : TDate;
   Retorno            : Integer;

   Configuracao : TConfiguracao;
begin
   ArquivoIni := ChangeFileExt(Application.ExeName, '.ini');
   if not FileExists(ArquivoIni) then begin
      ArquivoIni := ExtractFilePath(Application.ExeName) + 'Ello.ini';
   end;

   Configuracao       := TConfiguracao.Create(ArquivoIni);
   BancoDeDadosOrigem := Configuracao.BancoDeDadosOrigem;
   FUsuario           := 'IMPORTACAO';

   GravaDados.Empresa := Configuracao.IdEmpresa;
   GravaDados.Usuario := FUsuario;

   sConnection.LibraryName := 'dbexpint.dll';
   sConnection.Empresa     := Configuracao.IdEmpresa;
   sConnection.Params.Values['DataBase'] := Configuracao.BancoDeDados;
   sConnection.Connected   := Configuracao.BancoDeDados <>'';

   ADOConnection.ConnectionString := Format('Provider=MSDASQL.1;Persist Security Info=False;Data Source=%s;Mode=ReadWrite;',
                                            [Configuracao.NomeConexaoODBC]);
   ADOConnection.Connected := True;

   TD.TransactionID  := 1;
   TD.IsolationLevel := xilReadCommitted;
   SqlDados          := TEllQuery.Create;

   if Pos('C:\', UpperCase(Configuracao.BancoDeDados)) > 0 then begin
      Retorno := FileAge(Configuracao.BancoDeDados);
      if Retorno <= 0 then begin
         MensagemEllo('O caminho para os dados em: '+Configuracao.BancoDeDados+', n�o foi encontrado, ' +
                      'ou a senha do usu�rio SYSDBA est� incorreta.             ' + #13#10 +
                      'Verifique o arquivo '+ArquivoIni, tmErro);
         Application.Terminate;
      end;
      DataArq := Trunc(FileDateToDateTime(Retorno));
      if Date < DataArq then begin
         sMens := 'ATEN��O: A data deste computador n�o coincide com a data do banco de dados !';
      end;
   end;

   Configuracao.Free;
   
   if sMens <> '' then begin
      MensagemEllo(sMens, tmInforma);
      Application.Terminate;
      Exit;
   end;
end;

procedure TDatam1.DataModuleDestroy(Sender: TObject);
begin
   sConnection.Connected := False;
   FreeAndNil(SqlDados);
end;

function MensagemEllo(Msg :String; Tipo: TTipoMensagem):Boolean;
begin
  Application.CreateForm(TfdtMensagem,fdtMensagem);
  try
    fdtMensagem.Mensagem := Msg;
    fdtMensagem.TipoMsg  := Tipo;
    fdtMensagem.ShowModal;
    result := fdtMensagem.Tag = 1;
  finally
    fdtMensagem.Free;
  end;
end;

end.

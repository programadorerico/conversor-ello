unit UDataModule;

interface

uses
  SysUtils, Forms, Controls, Classes, DBXpress, DB, ADODB, SqlExpr, EllTypes, unSql,
  EllConnection, FMTBcd, UConfig;

type
  TDatam1 = class(TDataModule)
    sConnection: TEllConnection;
    ADOConnection: TADOConnection;
    ADOQuery: TADOQuery;
    QueryPesquisa: TSQLQuery;
    QueryTrabalho: TSQLQuery;
    ADOTable1: TADOTable;
    OriginConnection: TEllConnection;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure AppException(Sender: TObject; E: Exception);
  private
    FConfiguracao: TConfiguracao;
    function PerguntaLocalizacaoArquivo: String;
    procedure VerificaDataDoServidor;
    procedure InicializaDatabaseOrigem;
    procedure InicializaDatabaseDestino;
  end;

  function MensagemEllo(msg : string; Tipo: TTipoMensagem):boolean;

var
  Datam1: TDatam1;
  TD: TTransactionDesc;
  SqlDados: TEllQuery;

implementation

uses Dialogs, dfMensagem;

{$R *.dfm}

procedure TDatam1.DataModuleCreate(Sender: TObject);
begin
   Application.onException := AppException;
   FConfiguracao := TConfiguracao.Create;
   SqlDados      := TEllQuery.Create(sConnection);

   InicializaDatabaseOrigem;
   InicializaDatabaseDestino;
   VerificaDataDoServidor;

   FConfiguracao.Free;
end;

procedure TDatam1.InicializaDatabaseOrigem;
var
   ConnectionString: String;
begin
   ConnectionString := 'Provider=MSDASQL.1;Password=%s;Persist Security Info=True;User ID=%s;Data Source=%s;Mode=ReadWrite';
   ConnectionString := Format(ConnectionString, [FConfiguracao.PasswordODBC, FConfiguracao.UsernameODBC, FConfiguracao.NomeConexaoODBC]);
   ADOConnection.ConnectionString := ConnectionString;

   try
      ADOConnection.Connected := True;
   except
      Application.Terminate;
      raise Exception.Create('Erro ao conectar no banco de dados origem.');
   end;
end;

procedure TDatam1.InicializaDatabaseDestino;
begin
   sConnection.LibraryName := 'dbexpint.dll';
   sConnection.Empresa     := FConfiguracao.IdEmpresa;
   sConnection.Params.Values['DataBase'] := FConfiguracao.BancoDeDados;

   try
      sConnection.Connected   := FConfiguracao.BancoDeDados <>'';
   except
      Application.Terminate;
      raise Exception.Create('Erro ao conectar no banco de dados destino.');
   end;

   TD.TransactionID  := 1;
   TD.IsolationLevel := xilReadCommitted;
end;

procedure TDatam1.VerificaDataDoServidor;
var
   sMens   : String;
   DataArq : TDate;
   Retorno : Integer;
begin
   if Pos('C:\', UpperCase(FConfiguracao.BancoDeDados)) > 0 then begin
      Retorno := FileAge(FConfiguracao.BancoDeDados);
      if Retorno <= 0 then begin
         MensagemEllo('O caminho para os dados em: '+FConfiguracao.BancoDeDados+', não foi encontrado, ' +
                      'ou a senha do usuário SYSDBA está incorreta.             ' + #13#10 +
                      'Verifique o arquivo ' + FConfiguracao.NomeArquivo, tmErro);
         Application.Terminate;
      end;
      DataArq := Trunc(FileDateToDateTime(Retorno));
      if Date < DataArq then begin
         sMens := 'ATENÇÃO: A data deste computador não coincide com a data do banco de dados !';
      end;
   end;
end;

function TDatam1.PerguntaLocalizacaoArquivo: String;
var
   OpenDialog: TOpenDialog;
begin
   OpenDialog := TOpenDialog.Create(nil);
   OpenDialog.InitialDir := GetCurrentDir;
   OpenDialog.Options := [ofFileMustExist];
   OpenDialog.Filter := 'Arquivos do firebird |*.fdb';
   OpenDialog.FilterIndex := 1;
   OpenDialog.Title := 'Selecione o arquivo do banco de dados de origem';
   if openDialog.Execute then
      Result := openDialog.FileName
   else begin
      Application.Terminate;
      Abort;
   end;
   OpenDialog.Free;
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

procedure TDatam1.AppException(Sender: TObject; E: Exception);
const
   Arquivo = 'conversor.log';
var
   Linha: String;
   Texto: TextFile;
begin
   if not FileExists(Arquivo) then begin
      try
         AssignFile(Texto, Arquivo);
         ReWrite(Texto);
      finally
         CloseFile(Texto);
      end;
   end;
   AssignFile(Texto, Arquivo);
   Append(Texto);
   Linha := DateToStr(Date) + ' ' + TimeToStr(Time) + ' -> ' + E.Message;
   try
      WriteLn(Texto, Linha);
      Flush(Texto);
   finally
      CloseFile(Texto);
   end;
end;

end.

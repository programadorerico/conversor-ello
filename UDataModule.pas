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
    ProdutosConnection: TADOConnection;
    ClientesConnection: TADOConnection;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure AppException(Sender: TObject; E: Exception);
  private
    FConfiguracao: TConfiguracao;
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

uses Dialogs, dfMensagem, stdActns;

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
   ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=%s\%s;Mode=ReadWrite;Persist Security Info=False;' +
                       'Jet OLEDB:System database="";Jet OLEDB:Registry Path="";Jet OLEDB:Database Password="";Jet OLEDB:Engine Type=5;' +
                       'Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Global Bulk Transactions=1;' +
                       'Jet OLEDB:New Database Password="";Jet OLEDB:Create System Database=False;Jet OLEDB:Encrypt Database=False;' +
                       'Jet OLEDB:Don''t Copy Locale on Compact=False;Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:SFP=False;';

   if FConfiguracao.CaminhoOrigem='' then begin
      Application.Terminate;
      raise Exception.Create('Caminho do banco de dados de Origem não configurado!');
   end;

   ProdutosConnection.ConnectionString := Format(ConnectionString, [FConfiguracao.CaminhoOrigem, 'ESTOQUE.MDB']);
   ProdutosConnection.Connected := True;

   ClientesConnection.ConnectionString := Format(ConnectionString, [FConfiguracao.CaminhoOrigem, 'CLIENTES.MDB']);
   ClientesConnection.Connected := True;
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

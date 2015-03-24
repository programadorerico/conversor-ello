unit UDataModule;

interface

uses
  SysUtils, Forms, Controls, Classes, DBXpress, DB, ADODB, SqlExpr, IniFiles, EllTypes, unSql,
  EllConnection, FMTBcd;

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
  private
    FUsuario: String;
  end;

  function MensagemEllo(msg : string; Tipo: TTipoMensagem):boolean;

var
  Datam1: TDatam1;
  TD: TTransactionDesc;
  SqlDados: TEllQuery;

implementation

uses Dialogs, dfMensagem, UConfig;

{$R *.dfm}

procedure TDatam1.DataModuleCreate(Sender: TObject);
var
   BancoDeDadosOrigem : String;
   sMens              : String;
   DataArq            : TDate;
   Retorno            : Integer;

   Configuracao : TConfiguracao;

   OpenDialog: TOpenDialog;
begin
   OpenDialog := TOpenDialog.Create(nil);
   OpenDialog.InitialDir := GetCurrentDir;
   OpenDialog.Options := [ofFileMustExist];
   OpenDialog.Filter := 'Arquivos do firebird |*.fdb';
   OpenDialog.FilterIndex := 1;
   OpenDialog.Title := 'Selecione o arquivo do banco de dados de origem';
   if openDialog.Execute then
      BancoDeDadosOrigem := openDialog.FileName
   else begin
      Application.Terminate;
      Application.ProcessMessages;
      Exit;
   end;
   OpenDialog.Free;

   Configuracao       := TConfiguracao.Create;
   FUsuario           := 'IMPORTACAO';

   sConnection.LibraryName := 'dbexpint.dll';
   sConnection.Empresa     := Configuracao.IdEmpresa;
   sConnection.Params.Values['DataBase'] := Configuracao.BancoDeDados;
   sConnection.Connected   := Configuracao.BancoDeDados <>'';

   OriginConnection.Params.Values['Database'] := BancoDeDadosOrigem;
   OriginConnection.Connected := True;

   TD.TransactionID  := 1;
   TD.IsolationLevel := xilReadCommitted;
   SqlDados          := TEllQuery.Create(sConnection);

   if Pos('C:\', UpperCase(Configuracao.BancoDeDados)) > 0 then begin
      Retorno := FileAge(Configuracao.BancoDeDados);
      if Retorno <= 0 then begin
         MensagemEllo('O caminho para os dados em: '+Configuracao.BancoDeDados+', não foi encontrado, ' +
                      'ou a senha do usuário SYSDBA está incorreta.             ' + #13#10 +
                      'Verifique o arquivo ' + Configuracao.NomeArquivo, tmErro);
         Application.Terminate;
      end;
      DataArq := Trunc(FileDateToDateTime(Retorno));
      if Date < DataArq then begin
         sMens := 'ATENÇÃO: A data deste computador não coincide com a data do banco de dados !';
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

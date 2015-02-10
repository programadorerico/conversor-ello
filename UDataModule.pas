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
    ConnectionOrigem: TSQLConnection;
    QueryPesquisa: TSQLQuery;
    QueryTrabalho: TSQLQuery;
    QueryECO: TSQLQuery;
    ADOTable1: TADOTable;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function MensagemEllo(msg : string; Tipo: TTipoMensagem):boolean;

var
  Datam1: TDatam1;
  TD: TTransactionDesc;
  Empresa: Integer;
  Usuario: String;
  SqlDados: TEllQuery;

implementation

uses dfMensagem;

{$R *.dfm}

procedure TDatam1.DataModuleCreate(Sender: TObject);
var IniFile            : TIniFile;
    ArquivoIni         : String;
    BancoDeDados       : String;
    BancoDeDadosOrigem : String;
    CaminhoDll         : String;
    sMens              : String;
    DataArq            : TDate;
    DataX              : TDate;
    Retorno            : Integer;
begin
   sConnection.Close;
   sConnection.Params.Values['DataBase'] := '';
   ArquivoIni := ChangeFileExt(Application.ExeName, '.ini');

   if not FileExists(ArquivoIni) then begin
      ArquivoIni := ExtractFilePath(Application.ExeName) + 'Ello.ini';
   end;

   IniFile                 := TIniFile.Create(ArquivoIni);
   BancoDeDados            := IniFile.ReadString ('Dados', 'Database', '');
   BancoDeDadosOrigem      := IniFile.ReadString ('Dados', 'DatabaseOrigem', '');
   CaminhoDll              := IniFile.ReadString ('Preferencias', 'Firebird', 'GDS32.DLL');
   Empresa                 := IniFile.ReadInteger('Opcoes',  'EmpresaPadrao', 1);
   Usuario                 := 'IMPORTACAO';

   sConnection.LibraryName := 'dbexpint.dll';
   sConnection.Empresa     := Empresa;
   sConnection.Params.Values['DataBase']    := BancoDeDados;
   sConnection.Connected   := BancoDeDados   <>'';

   ConnectionOrigem.LibraryName := 'dbexpint.dll';
   ConnectionOrigem.Params.Values['DataBase']    := BancoDeDadosOrigem;
   ConnectionOrigem.Connected   := BancoDeDadosOrigem<>'';

   // ado connection
   ADOConnection.ConnectionString := Format('Provider=MSDASQL.1;Persist Security Info=False;Data Source=%s;Mode=ReadWrite;',
                                            [IniFile.ReadString('conexao_odbc_conversao', 'DataSource', 'Solutions')]);
   ADOConnection.Connected := True;


   TD.TransactionID        := 1;
   TD.IsolationLevel       := xilReadCommitted;
   SqlDados                := TEllQuery.Create;

   if Pos('C:\', UpperCase(BancoDeDados)) > 0 then begin
      Retorno := FileAge(BancoDeDados);
      if Retorno <= 0 then begin
         MensagemEllo('O caminho para os dados em: '+BancoDeDados+', não foi encontrado, ' +
                      'ou a senha do usuário SYSDBA está incorreta.             ' + #13#10 +
                      'Verifique o arquivo '+ArquivoIni, tmErro);
         IniFile.Free;
         Application.Terminate;
      end;
      DataArq := Trunc(FileDateToDateTime(Retorno));
      if Date < DataArq then begin
         sMens := 'ATENÇÃO: A data deste computador não coincide com a data do banco de dados !';
      end;
   end;

   if sMens <> '' then begin
      MensagemEllo(sMens, tmInforma);
      IniFile.Free;
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
  application.createform(TfdtMensagem,fdtMensagem);
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

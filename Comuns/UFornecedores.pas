unit UFornecedores;

interface

uses DB, SqlExpr, Interfaces;

const
   QUERY = 'SELECT                              ' +
           '      [Codigo]                      ' +
           '      ,[Descricao]                  ' +
           '      ,[Cgc ou Cpf] AS cpfcnpj      ' +
           '      ,[Fone]                       ' +
           '      ,[Endereco]                   ' +
           '      ,[Bairro]                     ' +
           '      ,[Cep]                        ' +
           '      ,[Cidade]                     ' +
           '      ,[Uf]                         ' +
           '      ,[Rg]                         ' +
           '      ,[Contato]                    ' +
           '      ,[Fax]                        ' +
           '      ,[GrupoRegiao]                ' +
           '      ,[Fantasia]                   ' +
           '      ,[Representante]              ' +
           '      ,[Fone1]                      ' +
           '      ,[Fax1]                       ' +
           '      ,[Celular]                    ' +
           '      ,[IscEst]                     ' +
           '      ,[Internet]                   ' +
           '      ,[Email]                      ' +
           '  FROM [BD_NI10].[dbo].[Fornecedor] ';


type
  TFornecedorConvertido = class(TInterfacedObject, IRegistroConvertido)
  private
    FDataSet: TDataSet;
    FQueryPesquisa: TSqlQuery;
    FIdFornecedor: Integer;
    FIdCidade: Integer;
    FDiaEspecifico: Integer;
    FRGIE: String;
    FOrgaoExpedidor: String;
    FHomepage: String;
    FComplemento: String;
    FNome: String;
    FTipo: String;
    FEndereco: String;
    FContatofone: String;
    FContato: String;
    FUsuario: String;
    FBairro: String;
    FFone: String;
    FEmail: String;
    FObs: String;
    FFantasia: String;
    FCaixaPostal: String;
    FNumero: String;
    FCpfCnpj: String;
    FFax: String;
    FCep: String;
    FDataCadastro: TDateTime;
    function GetCidade: Integer;
    function GetCNPJCPF: String;
    function GetRGIE: String;
    function GetTipoPessoa: String;
    function GetCEP: String;
  public
    procedure CarregaDoDataset(DataSet: TDataSet);
    property QueryPesquisa: TSqlQuery read FQueryPesquisa write FQueryPesquisa;
  published
    property IdFornecedor: Integer read FIdFornecedor;
    property Nome: String read FNome;
    property Tipo: String read FTipo;
    property Fantasia: String read FFantasia;
    property CpfCnpj: String read FCpfCnpj;
    property RGIE: String read FRGIE;
    property OrgaoExpedidor: String read FOrgaoExpedidor;
    property Endereco: String read FEndereco;
    property Numero: String read FNumero;
    property Complemento: String read FComplemento;
    property Bairro: String read FBairro;
    property CaixaPostal: String read FCaixaPostal;
    property IdCidade: Integer read FIdCidade;
    property Cep: String read FCep;
    property Fax: String read FFax;
    property Contato: String read FContato;
    property Email: String read FEmail;
    property DiaEspecifico: Integer read FDiaEspecifico;
    property Usuario: String read FUsuario;
    property DataCadastro: TDateTime read FDataCadastro;
    property Homepage: String read FHomepage;
    property Contatofone: String read FContatofone;
    property Fone: String read FFone;
    property Obs: String read FObs;
  end;

  procedure LimpaFornecedores(query: TSQLQuery);

implementation

uses SysUtils, Utils;

{ TFornecedorConvertido }

procedure TFornecedorConvertido.CarregaDoDataset(DataSet: TDataSet);
begin
   FDataSet := DataSet;

   FIdFornecedor   := FDataSet.FieldByName('CODIGO').AsInteger;
   FNome           := Trim(UpperCase(TiraAcentos(FDataSet.FieldByName('DESCRICAO').AsString)));
   FCpfCnpj        := GetCNPJCPF;
   FTipo           := GetTipoPessoa;
   FFantasia       := Trim(UpperCase(TiraAcentos(FDataSet.FieldByName('FANTASIA').AsString)));
   FRGIE           := GetRGIE;
   FOrgaoExpedidor := '';
   FEndereco       := UpperCase(FDataSet.FieldByName('ENDERECO').AsString);
   FNumero         := '';
   FComplemento    := '';
   FBairro         := UpperCase(FDataSet.FieldByName('BAIRRO').AsString);
   FCaixaPostal    := '';
   FCep            := GetCEP;
   FIdCidade       := GetCidade;
   FFax            := FDataSet.FieldByName('FAX').AsString;
   FContato        := UpperCase(FDataSet.FieldByName('CONTATO').AsString);
   FEmail          := FDataSet.FieldByName('EMAIL').AsString;
   FDiaEspecifico  := 0;
   FHomepage       := FDataSet.FieldByName('INTERNET').AsString;
   FContatofone    := '';
   FFone           := FDataSet.FieldByName('FONE').AsString;
   FObs            := '';
   FUsuario        := 'IMPLANTACAO';
   FDataCadastro   := Now;
end;

function TFornecedorConvertido.GetCNPJCPF: String;
begin
   Result := ApenasDigitos(FDataSet.FieldByName('CPFCNPJ').AsString);
end;

function TFornecedorConvertido.GetRGIE: String;
begin
   Result := ApenasDigitos(FDataSet.FieldByName('RG').AsString);
end;

function TFornecedorConvertido.GetCidade: Integer;
begin
   QueryPesquisa.SQL.Text := Format('SELECT IdCidade FROM TGerCidade WHERE CEP=''%s''', [FCep]);
   QueryPesquisa.Open;
   Result := QueryPesquisa.FieldByName('IDCIDADE').AsInteger;
end;

function TFornecedorConvertido.GetTipoPessoa: String;
begin
   if Length(FCpfCnpj) < 18 then
      Result := 'F'
   else
      Result := 'J';
end;

function TFornecedorConvertido.GetCEP: String;
begin
   Result := ApenasDigitos(FDataSet.FieldByName('CEP').AsString);
   if Result='' then
      Result := '78580000';

   QueryPesquisa.SQL.Text := Format('SELECT IdCidade FROM TGerCidade WHERE CEP=''%s''', [Result]);
   QueryPesquisa.Open;

   if QueryPesquisa.IsEmpty then
      Result := '78580000';
end;

{ Limpeza }

procedure LimpaFornecedores(query: TSQLQuery);
begin
   // contas a pagar
   query.SQLConnection.ExecuteDirect('DELETE FROM TCCUMOVIMENTO');
   query.SQLConnection.ExecuteDirect('DELETE FROM TPLCMOVIMENTO');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRECCHEQUEMOVIMENTO');
   query.SQLConnection.ExecuteDirect('DELETE FROM TCOLLANCAMENTO');
   query.SQLConnection.ExecuteDirect('UPDATE TCTALANCAMENTO set pagdocumento=null');
   query.SQLConnection.ExecuteDirect('DELETE FROM TPAGDOCUMENTO');
   query.SQLConnection.ExecuteDirect('DELETE FROM TCTALANCAMENTO');

   query.SQLConnection.ExecuteDirect('DELETE FROM TEstProdutoFornecedor');
   query.SQLConnection.ExecuteDirect('UPDATE TEstProduto SET IdFornecedor=NULL');
   query.SQLConnection.ExecuteDirect('DELETE FROM TPagBaixaParcela');
   query.SQLConnection.ExecuteDirect('DELETE FROM TPagBaixa');
   query.SQLConnection.ExecuteDirect('DELETE FROM TPagParcela');
   query.SQLConnection.ExecuteDirect('DELETE FROM TPagDocumento');
   query.SQLConnection.ExecuteDirect('DELETE FROM TPagFornecedor');
end;

end.

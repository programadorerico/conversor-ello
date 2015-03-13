unit UFornecedores;

interface

uses DB, SqlExpr, Interfaces;

const
   QUERY = 'SELECT a.ID_FABRICANTE_FORNECEDOR, a.PESSOA_FISICA_JURIDICA, a.RAZAO_SOCIAL_NOME, a.NOME_FANTASIA, ' +
           'a.CNPJ_CPF, a.INSCRICAO_ESTADUAL_RG, a.NOME_CONTATO, a.TELEFONE_1, a.TELEFONE_2, a.FAX, a.EMAIL, a.ENDERECO_INTERNET, ' +
           'a.ENDERECO, a.NUMERO, a.COMPLEMENTO, a.CEP, ' +
           'b.NOME_BAIRRO as bairro ' +
           'FROM FABRICANTES_FORNECEDORES a ' +
           'left join BAIRROS b on b.ID_BAIRRO=a.ID_BAIRRO';

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

   FIdFornecedor   := FDataSet.FieldByName('ID_FABRICANTE_FORNECEDOR').AsInteger;
   FNome           := Trim(UpperCase(TiraAcentos(FDataSet.FieldByName('RAZAO_SOCIAL_NOME').AsString)));
   FTipo           := FDataSet.FieldByName('PESSOA_FISICA_JURIDICA').AsString;
   FFantasia       := Trim(UpperCase(TiraAcentos(FDataSet.FieldByName('NOME_FANTASIA').AsString)));
   FCpfCnpj        := GetCNPJCPF;
   FRGIE           := GetRGIE;
   FOrgaoExpedidor := '';
   FEndereco       := FDataSet.FieldByName('ENDERECO').AsString;
   FNumero         := FDataSet.FieldByName('NUMERO').AsString;
   FComplemento    := FDataSet.FieldByName('COMPLEMENTO').AsString;
   FBairro         := FDataSet.FieldByName('BAIRRO').AsString;
   FCaixaPostal    := '';
   FIdCidade       := GetCidade;
   FCep            := '78525000';
   FFax            := '';
   FContato        := FDataSet.FieldByName('NOME_CONTATO').AsString;
   FEmail          := FDataSet.FieldByName('EMAIL').AsString;
   FDiaEspecifico  := 0;
   FHomepage       := FDataSet.FieldByName('ENDERECO_INTERNET').AsString;
   FContatofone    := '';
   FFone           := FDataSet.FieldByName('TELEFONE_1').AsString;
   FObs            := '';
   FUsuario        := 'IMPLANTACAO';
   FDataCadastro   := Now;
end;

function TFornecedorConvertido.GetCNPJCPF: String;
begin
   Result := ApenasDigitos(FDataSet.FieldByName('CNPJ_CPF').AsString);
end;

function TFornecedorConvertido.GetRGIE: String;
begin
   Result := ApenasDigitos(FDataSet.FieldByName('INSCRICAO_ESTADUAL_RG').AsString);
end;

function TFornecedorConvertido.GetCidade: Integer;
begin
   Result := 4077;
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

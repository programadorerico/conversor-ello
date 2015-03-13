unit UClientes;

interface

uses SqlExpr, DB, Classes, Interfaces;

const
  QUERY = 'SELECT cli.*,                                                                                                                           ' +
          '   (select first 1 identificador from CLIENTES_COMUNICACAO where id_cliente=cli.ID_CLIENTE and tipo_comunicacao in (7, 5)) as email,    ' +
          '   (select first 1 identificador from CLIENTES_COMUNICACAO where id_cliente=cli.ID_CLIENTE and tipo_comunicacao in (1, 2)) as telefone, ' +
          '   e.endereco,                                                                                                                          ' +
          '   e.cep,                                                                                                                               ' +
          '   CAST(e.COMPL_ENDERECO AS VARCHAR(200)) AS COMPLEMENTO,                                                                               ' +
          '   b.nome_bairro as bairro,                                                                                                             ' +
          '   m.NOME_MUNICIPIO as cidade,                                                                                                          ' +
          '   m.ID_ESTADO as uf,                                                                                                                   ' +
          '   m.COD_IBGE                                                                                                                           ' +
          'FROM CLIENTES cli                                                                                                                       ' +
          'left join CLIENTES_ENDERECOS e on (e.id_cliente=cli.id_cliente)                                                                         ' +
          'left join bairros b on (b.ID_BAIRRO=e.ID_BAIRRO)                                                                                        ' +
          'left join municipios m on (m.ID_MUNICIPIO=b.ID_MUNICIPIO)                                                                               ';

type
  TClienteConvertido = class(TInterfacedObject, IRegistroConvertido)
  private
    FDataSet: TDataSet;
    FIdCliente: Integer;
    FPessoa: String;
    FNascimento: TDateTime;
    FSexo: String;
    FNome: String;
    FFantasia: String;
    FDataCadastro: TDateTime;
    FEmail: String;
    FCelular: String;
    FFone: String;
    FAtivo: String;
    FQueryPesquisa: TSqlQuery;
    FHomePage: String;
    FOrgaoExpedidor: String;
    FComplemento: String;
    FEndereco: String;
    FContato: String;
    FEstadoCivil: String;
    FBairro: String;
    FIdCidade: Integer;
    FNumero: String;
    FCep: String;
    FPercentualMulta: Integer;
    FDescontoReceberValor: Integer;
    FEndComercial: Integer;
    FAcrescimoNaVendaValor: Integer;
    FDescontoNaVendaValor: Integer;
    FPercentualJuros: Integer;
    FEndEntrega: Integer;
    FJurosReceberCarencia: Integer;
    FEndCobranca: Integer;
    FJurosReceberValor: Integer;
    FLimiteValor: Integer;
    FJurosReceber: String;
    FUsuario: String;
    FLimite: String;
    FFormaCrediario: String;
    FDescontoReceber: String;
    FConjuge: String;
    FJuroMultaDiferenciado: String;
    FFormaCartao: String;
    FDescontoNaVenda: String;
    FFormaConvenio: String;
    FFormaCheque: String;
    FAcrescimoNaVenda: String;
    FLimiteVcto: TDateTime;
    FObs: String;
    function GetCpfCnpj: String;
    function GetRGIE: String;
    function GetIdCidade: Integer;
    function GetEstadoCivil: String;
  public
    procedure CarregaDoDataset(DataSet: TDataSet);
  published
    property IdCliente: Integer read FIdCliente;
    property Nome: String read FNome;
    property Fantasia: String read FFantasia;
    property Pessoa: String read FPessoa;
    property CpfCnpj: String read GetCpfCnpj;
    property RGIE: String read GetRGIE;
    property Nascimento: TDateTime read FNascimento;
    property Sexo: String read FSexo;
    property DataCadastro: TDateTime read FDataCadastro;
    property Email: String read FEmail;
    property Fone: String read FFone;
    property Celular: String read FCelular;
    property Ativo: String read FAtivo;
    property Endereco: String read FEndereco;
    property Cep: String read FCep;
    property Complemento: String read FComplemento;
    property Bairro: String read FBairro;
    property IdCidade: Integer read FIdCidade;
    property Numero: String read FNumero;
    property Contato: String read FContato;
    property OrgaoExpedidor: String read FOrgaoExpedidor;
    property EstadoCivil: String read FEstadoCivil;
    property HomePage: String read FHomePage;
    property Conjuge: String read FConjuge;
    property PercentualJuros: Integer read FPercentualJuros;
    property PercentualMulta: Integer read FPercentualMulta;
    property JuroMultaDiferenciado: String read FJuroMultaDiferenciado;
    property EndComercial: Integer read FEndComercial;
    property EndEntrega: Integer read FEndEntrega;
    property EndCobranca: Integer read FEndCobranca;
    property Limite: String read FLimite;
    property LimiteValor: Integer read FLimiteValor;
    property LimiteVcto: TDateTime read FLimiteVcto;
    property DescontoNaVenda: String read FDescontoNaVenda;
    property DescontoNaVendaValor: Integer read FDescontoNaVendaValor;
    property AcrescimoNaVenda: String read FAcrescimoNaVenda;
    property AcrescimoNaVendaValor: Integer read FAcrescimoNaVendaValor;
    property JurosReceber: String read FJurosReceber;
    property JurosReceberValor: Integer read FJurosReceberValor;
    property JurosReceberCarencia: Integer read FJurosReceberCarencia;
    property DescontoReceber: String read FDescontoReceber;
    property DescontoReceberValor: Integer read FDescontoReceberValor;
    property FormaCrediario: String read FFormaCrediario;
    property FormaCheque: String read FFormaCheque;
    property FormaCartao: String read FFormaCartao;
    property FormaConvenio: String read FFormaConvenio;
    property Obs: String read FObs;
    property Usuario: String read FUsuario;

    property QueryPesquisa: TSqlQuery read FQueryPesquisa write FQueryPesquisa;
  end;

procedure LimpaClientes(query: TSQLQuery);

implementation

uses SysUtils, Utils;

{ TClienteConvertido }

procedure TClienteConvertido.CarregaDoDataset(DataSet: TDataSet);
begin
   FDataSet := DataSet;

   FIdCliente             := FDataset.FieldByName('ID_CLIENTE').AsInteger;
   FNome                  := Trim(UpperCase(TiraAcentos(FDataSet.FieldByName('RAZAO_SOCIAL_NOME').AsString)));
   FFantasia              := Trim(UpperCase(TiraAcentos(FDataSet.FieldByName('NOME_FANTASIA').AsString)));
   FPessoa                := FDataset.FieldByName('PESSOA_FISICA_JURIDICA').AsString;
   FNascimento            := FDataset.FieldByName('DATA_NASCIMENTO').AsDateTime;
   FSexo                  := FDataset.FieldByName('SEXO').AsString;
   FDataCadastro          := FDataSet.FieldByName('DATA_INCLUSAO_CADASTRO').AsDateTime;
   FEmail                 := FDataSet.FieldByName('EMAIL').AsString;
   FFone                  := ApenasDigitos(FDataSet.FieldByName('TELEFONE').AsString);
   FCelular               := '';
   FAtivo                 := 'S';
   FEndereco              := Trim(UpperCase(TiraAcentos(FDataSet.FieldByName('ENDERECO').AsString)));
   FCep                   := ApenasDigitos(FDataSet.FieldByName('CEP').AsString);
   FComplemento           := FDataSet.FieldByName('COMPLEMENTO').AsString;
   FBairro                := Trim(UpperCase(TiraAcentos(FDataSet.FieldByName('BAIRRO').AsString)));
   FIdCidade              := GetIdCidade;
   FNumero                := '';
   FContato               := '';
   FOrgaoExpedidor        := '';
   FEstadoCivil           := GetEstadoCivil;
   FHomePage              := '';
   FConjuge               := '';
   FPercentualJuros       := 0;
   FPercentualMulta       := 0;
   FJuroMultaDiferenciado := 'N';
   FEndComercial          := 1;
   FEndEntrega            := 2;
   FEndCobranca           := 3;
   FLimite                := 'UNICO';
   FLimiteValor           := 0;
   FLimiteVcto            := DataValida('31.12.2015') ;
   FDescontoNaVenda       := 'N';
   FDescontoNaVendaValor  := 0;
   FAcrescimoNaVenda      := 'N';
   FAcrescimoNaVendaValor := 0;
   FJurosReceber          := 'N';
   FJurosReceberValor     := 0;
   FJurosReceberCarencia  := 0;
   FDescontoReceber       := 'N';
   FDescontoReceberValor  := 0;
   FFormaCrediario        := 'S';
   FFormaCheque           := 'S';
   FFormaCartao           := 'S';
   FFormaConvenio         := 'S';
   FUsuario               := 'IMPLANTACAO';
end;

function TClienteConvertido.GetCpfCnpj: String;
begin
   if FPessoa='J' then
      Result := FDataset.FieldByName('CNPJ').AsString
   else
      Result := FDataset.FieldByName('CPF').AsString;
   Result := ApenasDigitos(Result);
end;

function TClienteConvertido.GetIdCidade: Integer;
begin
   Result := 3998;
   if FDataSet.FieldByName('COD_IBGE').AsString = '' then exit;
   with FQueryPesquisa do begin
      Sql.Clear;
      Sql.Add(Format('Select IdCidade From TGerCidade Where CodigoIBGE = ''%s'' ', [FDataSet.FieldByName('COD_IBGE').AsString]));
      Open;
      if not FQueryPesquisa.IsEmpty then begin
         Result := FieldbyName('IdCidade').AsInteger;
      end;
   end;
end;

function TClienteConvertido.GetEstadoCivil: String;
begin
   Result := 'OUTROS';
   {with CDSDados do begin
      if FieldByName('EstadoCivil').AsString = 'C' then Result := 'CASADO';
      if FieldByName('EstadoCivil').AsString = 'S' then Result := 'SOLTEIRO';
      if FieldByName('EstadoCivil').AsString = 'D' then Result := 'DIVORCIADO';
      if FieldByName('EstadoCivil').AsString = 'V' then Result := 'VIUVO';
   end;}
end;

{ Limpeza }

procedure LimpaClientes(query: TSQLQuery);
begin
   query.SQLConnection.ExecuteDirect('ALTER TRIGGER TESTPRODUTOMOVIMENTO_ALL_AF INACTIVE');
   query.SQLConnection.ExecuteDirect('UPDATE TEstProdutoMovimento Set IdMovimentoOrigem = null where IdMovimentoOrigem is not null');
   query.SQLConnection.ExecuteDirect('UPDATE TRecCheque   Set IdRegistroForma = null');
   query.SQLConnection.ExecuteDirect('UPDATE TRecChequeMovimento Set IdLancamento = null');
   query.SQLConnection.ExecuteDirect('UPDATE TRegRegistro Set IdBaixa  = null where idbaixa is not null');
   query.SQLConnection.ExecuteDirect('UPDATE TRegRegistro Set IdPedido  = null');
   query.SQLConnection.ExecuteDirect('UPDATE TVdaPedido   Set IdRegistro = null where idregistro is not null');
   query.SQLConnection.ExecuteDirect('UPDATE TVdaPedido   Set IdPedidoOrigem = null where IdPedidoOrigem is not null');
   query.SQLConnection.ExecuteDirect('update trecdocumento set idrenegociacao=null');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRenegociacao');
   query.SQLConnection.ExecuteDirect('DELETE FROM TPlcMovimento');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRecComissao');
   query.SQLConnection.ExecuteDirect('DELETE FROM TBloqueio');
   query.SQLConnection.ExecuteDirect('DELETE FROM TCtaLancamento');
   query.SQLConnection.ExecuteDirect('DELETE FROM TVdaProdutoComissionado');
   query.SQLConnection.ExecuteDirect('DELETE FROM TPagBaixaParcela');
   query.SQLConnection.ExecuteDirect('DELETE FROM TPagBaixa');
   query.SQLConnection.ExecuteDirect('DELETE FROM TPagParcela');
   query.SQLConnection.ExecuteDirect('DELETE FROM TPagDocumento');
   query.SQLConnection.ExecuteDirect('DELETE FROM TEstProdutoMovimentoLote');
   query.SQLConnection.ExecuteDirect('DELETE FROM TNfnProduto');
   query.SQLConnection.ExecuteDirect('DELETE FROM TEstProdutoMovimento');
   query.SQLConnection.ExecuteDirect('DELETE FROM TNfnNota');
   query.SQLConnection.ExecuteDirect('DELETE FROM TEstProdutoEstoque');
   query.SQLConnection.ExecuteDirect('DELETE FROM TEstInventarioProduto');
   query.SQLConnection.ExecuteDirect('DELETE FROM TEstInventario');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRecChequeMovimento');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRegRegistroForma');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRecChequeMovimento');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRecCheque');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRecBaixaParcela');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRecBaixa');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRECPARCELAPROGRAMADA');
   query.SQLConnection.ExecuteDirect('DELETE FROM TCobBoleto');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRecParcela');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRecDocumento');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRegRegistro');
   query.SQLConnection.ExecuteDirect('DELETE FROM TVdaPedidoForma');
   query.SQLConnection.ExecuteDirect('DELETE FROM TVdaPedidoCancelado');
   query.SQLConnection.ExecuteDirect('DELETE FROM TVdaComissaoLiberada');
   query.SQLConnection.ExecuteDirect('DELETE FROM TVdaPedidoComissao');
   query.SQLConnection.ExecuteDirect('DELETE FROM TSngpc');
   query.SQLConnection.ExecuteDirect('DELETE FROM TSngpcMovimento');
   query.SQLConnection.ExecuteDirect('DELETE FROM TVdaFarmaciaPopularItem');
   query.SQLConnection.ExecuteDirect('DELETE FROM TVdaFarmaciaPopular');
   query.SQLConnection.ExecuteDirect('DELETE FROM TNfeTransporte');
   query.SQLConnection.ExecuteDirect('DELETE FROM TNfeDestinatario');
   query.SQLConnection.ExecuteDirect('DELETE FROM TNfeCupomPedido');
   query.SQLConnection.ExecuteDirect('DELETE FROM TNfeProdutos');
   query.SQLConnection.ExecuteDirect('DELETE FROM TNfeNota');
   query.SQLConnection.ExecuteDirect('DELETE FROM TEstGrupoMovimento');
   query.SQLConnection.ExecuteDirect('DELETE FROM TVdaPedido');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRegPeriodo');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRecBaixaParcela');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRecBaixa');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRecParcela');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRecDocumento');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRecDebitoCliente');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRecClienteReferencia');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRecClienteEstatistica');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRecClienteBloqueio');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRecClienteConveniado');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRecClienteEndereco');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRecCreditoMovimento');
   query.SQLConnection.ExecuteDirect('DELETE FROM TGerAdministradoras');
   query.SQLConnection.ExecuteDirect('DELETE FROM TSolSolicitacao');
   query.SQLConnection.ExecuteDirect('DELETE FROM TRecCliente');
   query.SQLConnection.ExecuteDirect('ALTER TRIGGER TESTPRODUTOMOVIMENTO_ALL_AF ACTIVE');
end;

function TClienteConvertido.GetRGIE: String;
begin
   Result := FDataset.FieldByName('DOC_IDENTIDADE').AsString;
   if Length(Result)<=1 then
      Result := FDataset.FieldByName('INSC_ESTADUAL').AsString;
end;

end.

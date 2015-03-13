unit UProdutos;

interface

uses DB, SqlExpr, Classes, Interfaces;

const
   QUERY = 'SELECT                                                                                             ' +
           '   a.ID_PRODUTO,                                                                                   ' +
           '   (select first 1 descricao from PRODUTOS_DESCRICOES where id_produto=a.ID_PRODUTO) AS DESCRICAO, ' +
           '   a.CODIGO_BARRAS,                                                                                ' +
           '   a.ID_FABRICANTE_FORNECEDOR,                                                                     ' +
           '   a.CODIGO_FABRICANTE,                                                                            ' +
           '   a.ID_GRUPO_PRODUTOS, a.ID_SUB_GRUPO_PRODUTOS,                                                   ' +
           '   a.QUANT_UNITARIA,                                                                               ' +
           '   a.UNIDADE,                                                                                      ' +
           '   a.DATA_CADASTRO, a.ULTIMA_ATUALIZACAO_CADASTRO,                                                 ' +
           '   a.CODIGO_NCM                                                                                    ' +
           '   , c.ESTOQUE_INTEIRO, c.ESTOQUE_FRACAO                                                           ' +
           '   , d.PRECO_COMPRA, d.PRECO_CUSTO, d.CUSTO_MEDIO, d.PRECO_VENDA, d.PRECO_VENDA_ANTERIOR           ' +
           'FROM PRODUTOS a                                                                                    ' +
           'inner JOIN PRODUTOS_ESTOQUES c ON (c.ID_PRODUTO=a.ID_PRODUTO)                                      ' +
           'inner JOIN PRODUTOS_PRECOS d ON (d.ID_PRODUTO=a.ID_PRODUTO)                                        ';

type
  TProdutoConvertido = class(TInterfacedObject, IRegistroConvertido)
  private
    FQueryPesquisa: TSqlQuery;
    FDataSet: TDataSet;
    FIdProduto: Integer;
    FDescricao: String;
    FStatus: String;
    FIdGrupoCredito: Integer;
    FMargemGarantido: Integer;
    FCodReferencia: String;
    FComissaoVista: Integer;
    FDecimais: Integer;
    FIdCofinsSaida: Integer;
    FMargemLucro: Integer;
    FEstoqueCritico: Integer;
    FVarejoAjuste: Integer;
    FIdPisSaida: Integer;
    FEstoqueMaximo: Integer;
    FIdCofinsEntrada: Integer;
    FAtacadoAjuste: Integer;
    FEstoqueMinimo: Currency;
    FComissaoPrazo: Integer;
    FDesconto: Integer;
    FBonificacao: Integer;
    FQtdeEmbalagem: Integer;
    FIdPisEntrada: Integer;
    FAtacadoQtde: Integer;
    FFracionado: String;
    FImportacao: String;
    FFabricacao: String;
    FUsuario: String;
    FNacional: String;
    FDescontoMaximo: String;
    FControlaLote: String;
    FMonitorado: String;
    FClassFiscal: String;
    FCodAntigo: String;
    FComissaoEspecial: String;
    FContinuo: String;
    FEstoqueAutomatico: String;
    FPrecoLivre: String;
    FPrecoCusto: Currency;
    FDataCadastro: TDateTime;
    function GetUnidadeDeMedida: String;
    function GetIdSubGrupo: Integer;
    function GetIdMarca: Integer;
    function GetPrecoVenda: Currency;
    function GetPagaComissao: String;
    function GetIdNCM: Integer;
    function GetIdGrupoICMS: Integer;
    function GetIdTributacao: Integer;
    function GetIdClasse: Integer;
    function GetCodBarras: String;
    function GeraNovoEAN13(const Codigo: String): String;
    function GetQuantidadeEmEstoque: Currency;
    function GetIdFornecedor: Integer;
  public
    procedure CarregaDoDataset(DataSet: TDataSet);
  published
    property IdProduto         : Integer read FIdProduto;
    property Descricao         : String read FDescricao;
    property Embalagem         : String read GetUnidadeDeMedida;
    property IdSubGrupo        : Integer read GetIdSubGrupo;
    property IdMarca           : Integer read GetIdMarca;
    property PrecoVenda        : Currency read GetPrecoVenda;
    property PagaComissao      : String read GetPagaComissao;
    property Status            : String read FStatus;
    property CodNCM            : Integer read GetIdNCM;
    property IdGrupoICMS       : Integer read GetIdGrupoICMS;
    property IdTributacao      : Integer read GetIdTributacao;
    property IdGrupoCredito    : Integer read FIdGrupoCredito;
    property IdClasse          : Integer read GetIdClasse;
    property MargemGarantido   : Integer read FMargemGarantido;
    property CodBarras         : String read GetCodBarras;
    property CodReferencia     : String read FCodReferencia;
    property CodAntigo         : String read FCodAntigo;
    property ClassFiscal       : String read FClassFiscal;
    property ControlaLote      : String read FControlaLote;
    property PrecoLivre        : String read FPrecoLivre;
    property Fracionado        : String read FFracionado;
    property Monitorado        : String read FMonitorado;
    property Continuo          : String read FContinuo;
    property Decimais          : Integer read FDecimais;
    property DescontoMaximo    : String read FDescontoMaximo;
    property Desconto          : Integer read FDesconto;
    property ComissaoEspecial  : String read FComissaoEspecial;
    property ComissaoVista     : Integer read FComissaoVista;
    property ComissaoPrazo     : Integer read FComissaoPrazo;
    property EstoqueAutomatico : String read FEstoqueAutomatico;
    property EstoqueMaximo     : Integer read FEstoqueMaximo;
    property EstoqueMinimo     : Currency read FEstoqueMinimo;
    property EstoqueCritico    : Integer read FEstoqueCritico;
    property Bonificacao       : Integer read FBonificacao;
    property Fabricacao        : String read FFabricacao;
    property Nacional          : String read FNacional;
    property Importacao        : String read FImportacao;
    property MargemLucro       : Integer read FMargemLucro;
    property QtdeEmbalagem     : Integer read FQtdeEmbalagem;
    property AtacadoAjuste     : Integer read FAtacadoAjuste;
    property VarejoAjuste      : Integer read FVarejoAjuste;
    property AtacadoQtde       : Integer read FAtacadoQtde;
    property IdPisEntrada      : Integer read FIdPisEntrada;
    property IdPisSaida        : Integer read FIdPisSaida;
    property IdCofinsEntrada   : Integer read FIdCofinsEntrada;
    property IdCofinsSaida     : Integer read FIdCofinsSaida;
    property Usuario           : String read FUsuario;
    property PrecoCusto        : Currency read FPrecoCusto;
    property QuantidadeEmEstoque: Currency read GetQuantidadeEmEstoque;
    property DataCadastro      : TDateTime read FDataCadastro;
    property IdFornecedor      : Integer read GetIdFornecedor;

    property QueryPesquisa: TSqlQuery read FQueryPesquisa write FQueryPesquisa;
  end;

  TTipoMovimento    = ({00} tmNaoIdentificado,
                       {01} tmVenda,
                       {02} tmOrcamento,
                       {03} tmCondicional,
                       {04} tmEntregaFutura,
                       {05} tmDevolucao,
                       {06} tmInventario,
                       {07} tmTransferencia,
                       {08} tmOrdemServico,
                       {09} tmNotaEntrada,
                       {10} tmTransfAlmoxarifado,
                       {11} tmDevolucaoCompra,
                       {12} tmRemessaGarantia,
                       {13} tmRemessaConserto);

  TEstProdutoMovimento = class(TPersistent)
  private
    { Private declarations }
    fQtde: Extended;
    fPrVenda: Extended;
    fUnitarioLiquido: Extended;
    fDesconto: Extended;
    fQtdeEntregue: Extended;
    fValor: Extended;
    fTotalLiquido: Extended;
    fTotalBruto: Extended;
    fIdProdutoPrincipal: Integer;
    fIdAlmox: Integer;
    fIdPedido: Integer;
    fIdTipoMovimento: TTipoMovimento;
    fQtdeEmbalagem: Integer;
    fIdMovimentoOrigem: Integer;
    fMovimentaEstoque: Boolean;
    fDescricao: String;
    fIdInventario: Integer;
    fVendaAliquotaIcms: Extended;
    fTipoAliquota: String;
    fIdNotaEntrada: Integer;
    fIdTransfAlmox: Integer;
    fDescontoEmValor: Boolean;
    fIdMovimento: Integer;
    FIdProduto: Integer;
  public
    { Public declarations }
    procedure Grava;
  published
    { Published declarations }
    property IdMovimento: Integer              read fIdMovimento           write fIdMovimento;
    property IdMovimentoOrigem: Integer        read fIdMovimentoOrigem     write fIdMovimentoOrigem;
    property IdTransfAlmox: Integer            read fIdTransfAlmox         write fIdTransfAlmox;
    property IdInventario: Integer             read fIdInventario          write fIdInventario;
    property IdPedido: Integer                 read fIdPedido              write fIdPedido;
    property IdNotaEntrada: Integer            read fIdNotaEntrada         write fIdNotaEntrada;
    property IdProduto: Integer                read fIdProduto             write fIdProduto;
    property IdProdutoPrincipal: Integer       read fIdProdutoPrincipal    write fIdProdutoPrincipal;
    property IdAlmox: Integer                  read fIdAlmox               write fIdAlmox;
    property Descricao: String                 read fDescricao             write fDescricao;
    property MovimentaEstoque: Boolean         read fMovimentaEstoque      write fMovimentaEstoque;
    property IdTipoMovimento: TTipoMovimento   read fIdTipoMovimento       write fIdTipoMovimento;
    property Qtde: Extended                    read fQtde                  write fQtde;
    property QtdeEntregue: Extended            read fQtdeEntregue          write fQtdeEntregue;
    property QtdeEmbalagem: Integer            read fQtdeEmbalagem         write fQtdeEmbalagem;
    property PrVenda: Extended                 read fPrVenda               write fPrVenda;
    property Valor: Extended                   read fValor                 write fValor;
    property TotalBruto: Extended              read fTotalBruto            write fTotalBruto;
    property Desconto: Extended                read fDesconto              write fDesconto;
    property DescontoEmValor: Boolean          read fDescontoEmValor       write fDescontoEmValor;
    property UnitarioLiquido: Extended         read fUnitarioLiquido       write fUnitarioLiquido;
    property TipoAliquota: String              read fTipoAliquota          write fTipoAliquota;
    property VendaAliquotaIcms: Extended       read fVendaAliquotaIcms     write fVendaAliquotaIcms;
    property TotalLiquido: Extended            read fTotalLiquido          write fTotalLiquido;
  end;

procedure LimpaProdutos(query: TSQLQuery);
procedure LimpaGrupos(query: TSQLQuery);
procedure LimpaClasses(query: TSQLQuery);
procedure LimpaMarcas(query: TSQLQuery);

implementation

uses SysUtils, Utils, UCodigoEAN, UDataModule, UnSQL;

{ TProdutoConvertido }

procedure TProdutoConvertido.CarregaDoDataset(DataSet: TDataSet);
begin
   FDataSet := DataSet;
   
   FIdProduto         := FDataSet.FieldByName('ID_PRODUTO').AsInteger;
   FDescricao         := Copy(Trim(UpperCase(TirarAcentos(FDataSet.FieldByName('DESCRICAO').AsString))), 1, 50);
   FPrecoCusto        := FDataSet.FieldByName('PRECO_CUSTO').AsFloat;
   FDataCadastro      := FDataSet.FieldByName('DATA_CADASTRO').AsDateTime;
   FStatus            := 'ATIVO'; // 'ATIVO', 'INATIVO'
   FIdGrupoCredito    := 1;
   FMargemGarantido   := 0;
   FCodReferencia     := IntToStr(FIdProduto);
   FCodAntigo         := '';
   FClassFiscal       := '';
   FControlaLote      := 'N';
   FPrecoLivre        := 'N';
   FFracionado        := 'N';
   FMonitorado        := 'N';
   FContinuo          := 'N';
   FDecimais          := 2;
   FDescontoMaximo    := 'N';
   FDesconto          := 0;
   FComissaoEspecial  := 'N';
   FComissaoVista     := 0;
   FComissaoPrazo     := 0;
   FEstoqueAutomatico := 'N';
   FEstoqueMaximo     := 0;
   FEstoqueMinimo     := 0;
   FEstoqueCritico    := 0;
   FBonificacao       := 0;
   FFabricacao        := 'N';
   FNacional          := 'S';
   FImportacao        := 'N';
   FMargemLucro       := 43;
   FQtdeEmbalagem     := 1;
   FAtacadoAjuste     := 0;
   FVarejoAjuste      := 0;
   FAtacadoQtde       := 0;
   FIdPisEntrada      := 10;
   FIdPisSaida        := 10;
   FIdCofinsEntrada   := 10;
   FIdCofinsSaida     := 10;
   FUsuario           := 'IMPLANTACAO';
end;

function TProdutoConvertido.GetIdGrupoICMS: Integer;
begin
   Result := 5; // tributado
end;

function TProdutoConvertido.GetIdTributacao: Integer;
begin
   Result := 605;
end;

function TProdutoConvertido.GetIdClasse: Integer;
begin
   Result := 1;
end;

function TProdutoConvertido.GetIdMarca: Integer;
begin
   Result := 1;
end;

function TProdutoConvertido.GetIdNCM: Integer;
var
   codncm: String;
begin
   codncm := FDataSet.FieldByName('CODIGO_NCM').AsString;
   FQueryPesquisa.SQL.Text := format('select idncm from testncm where codigo=%s', [QuotedStr(codncm)]);
   FQueryPesquisa.Open;
   if FQueryPesquisa.IsEmpty then
      Result := 1
   else
      Result := FQueryPesquisa.FieldByName('idncm').AsInteger;
end;

function TProdutoConvertido.GetIdSubGrupo: Integer;
begin
   Result := 1;
end;

function TProdutoConvertido.GetPagaComissao: String;
begin
   Result := 'N';
end;

function TProdutoConvertido.GetPrecoVenda: Currency;
begin
   Result := FDataSet.FieldByName('PRECO_VENDA').AsCurrency;
end;

function TProdutoConvertido.GetUnidadeDeMedida: String;
begin
   Result := Copy(Trim(UpperCase(FDataSet.FieldByName('UNIDADE').AsString)), 1, 2);
   if Result = '' then Result := 'UN';
   if Result = '1' then Result := 'UN';
   if Result = '81' then Result := 'UN';
end;

function TProdutoConvertido.GetCodBarras: String;
var
   codbarras: String;
begin
   codbarras := FDataSet.FieldByName('CODIGO_BARRAS').AsString;
   if Length(codbarras)<13 then
      Result := GeraNovoEAN13(IntToStr(fIdProduto))
   else
      Result := codbarras;
end;

function TProdutoConvertido.GeraNovoEAN13(const Codigo: string) :string;
var ean: TCodigoEAN;
begin
   ean := TCodigoEAN.Create;
   try
      ean.CodigoEAN := '110010'+StrZero(Codigo,6)+'0';
      ean.ValidaCodigo;
      Result := ean.CodigoEAN;
   finally
      ean.Free;
   end;
end;

function TProdutoConvertido.GetQuantidadeEmEstoque: Currency;
begin
   Result := FDataSet.FieldByName('ESTOQUE_INTEIRO').AsCurrency;
   if Result > 9999999 then
      Result := 0;     
end;

function TProdutoConvertido.GetIdFornecedor: Integer;
begin
   Result := FDataSet.FieldByName('ID_FABRICANTE_FORNECEDOR').AsInteger;
end;

{ TEstProdutoMovimento }

procedure TEstProdutoMovimento.Grava;
begin
   with SqlDados do begin
      Start(tcInsert,'TEstProdutoMovimento', Datam1.QueryTrabalho);
         AddValue('Empresa',              1);
         AddValue('IdMovimento',          fIdMovimento       );
         AddValue('IdMovimentoOrigem',    fIdMovimentoOrigem );
         AddValue('IdInventario',         fIdInventario      );
         AddValue('IdTransfAlmoxarifado', fIdTransfAlmox     );
         AddValue('IdPedido',             fIdPedido          );
         AddValue('IdNotaEntrada',        fIdNotaEntrada     );
         AddValue('IdProduto',            fIdProduto         );
         AddValue('IdProdutoPrincipal',   fIdProdutoPrincipal);
         AddValue('IdAlmox',              fIdAlmox           );
         AddValue('Descricao',            fDescricao         );
         AddValue('MovimentaEstoque',     1                  );
         AddValue('IdTipoMovimento',      fIdTipoMovimento   );
         AddValue('Qtde',                 fQtde              );
         AddValue('QtdeEntregue',         fQtdeEntregue      );
         AddValue('QtdeEmbalagem',        fQtdeEmbalagem     );
         AddValue('PrVenda',              fPrVenda           );
         AddValue('Valor',                fValor             );
         AddValue('TotalBruto',           fTotalBruto        );
         AddValue('Desconto',             fDesconto          );
         AddValue('DescontoEmValor',      fDescontoEmValor   );
         AddValue('UnitarioLiquido',      fUnitarioLiquido   );
         AddValue('TotalLiquido',         fTotalLiquido      );
         AddValue('TipoAliquota',         fTipoAliquota      );
         AddValue('VendaAliquotaIcms',    fVendaAliquotaIcms );
         if IdTipoMovimento in [tmVenda, tmOrcamento, tmCondicional, tmOrdemServico, tmTransferencia] then begin
            AddValue('EstDisponivel',  -fQtde);
         end;
         if IdTipoMovimento in [tmDevolucao, tmInventario, tmTransfAlmoxarifado, tmNotaEntrada] then begin
            AddValue('EstDisponivel',   fQtde);
         end;
         if IdTipoMovimento in [tmVenda, tmOrdemServico] then begin
            AddValue('EstReservado',    fQtde);
         end;
         if IdTipoMovimento in [tmCondicional] then begin
            AddValue('EstCondicional',  fQtde);
         end;
      Executa;
   end;
end;

{ ----------------- }

procedure LimpaProdutos(query: TSQLQuery);
begin
   query.SQLConnection.ExecuteDirect('UPDATE TEstProdutoMovimento SET IDMOVIMENTOORIGEM = NULL WHERE IdMovimentoOrigem IS NOT NULL');
   query.SQLConnection.ExecuteDirect('DELETE FROM TNfnProduto');
   query.SQLConnection.ExecuteDirect('DELETE FROM TEstAjustePrecoProduto');
   query.SQLConnection.ExecuteDirect('DELETE FROM TVdaProdutoComissionado');
   query.SQLConnection.ExecuteDirect('DELETE FROM TVdaCupomProduto');
   query.SQLConnection.ExecuteDirect('DELETE FROM TVdaCupom');
   query.SQLConnection.ExecuteDirect('DELETE FROM TSpdECFTotalizador');
   query.SQLConnection.ExecuteDirect('DELETE FROM TSpdECFReducaoZ');
   query.SQLConnection.ExecuteDirect('DELETE FROM TSpdInventarioProduto');
   query.SQLConnection.ExecuteDirect('DELETE FROM TSpdInventario');
   query.SQLConnection.ExecuteDirect('DELETE FROM TSpdSped');
   query.SQLConnection.ExecuteDirect('DELETE FROM TEstProdutoLoteSaldoMensal');
   query.SQLConnection.ExecuteDirect('DELETE FROM TEstProdutoMovimentoLote');
   query.SQLConnection.ExecuteDirect('DELETE FROM TEstProdutoLote');
   query.SQLConnection.ExecuteDirect('DELETE FROM TEstProdutoMovimento');
   query.SQLConnection.ExecuteDirect('DELETE FROM TEstClasseGradeComissao');
   query.SQLConnection.ExecuteDirect('DELETE FROM TEstInventarioProduto');
   query.SQLConnection.ExecuteDirect('DELETE FROM TEstInventario');
   query.SQLConnection.ExecuteDirect('DELETE FROM TNfnNota');
   query.SQLConnection.ExecuteDirect('DELETE FROM TEstProdutoSaldoMensal');
   query.SQLConnection.ExecuteDirect('DELETE FROM TEstSolicitacao');
   query.SQLConnection.ExecuteDirect('DELETE FROM TEstProdutoFornecedor');
   query.SQLConnection.ExecuteDirect('DELETE FROM TEstProduto');
end;

procedure LimpaGrupos(query: TSQLQuery);
begin
   query.SQLConnection.ExecuteDirect('DELETE FROM TEstSubGrupo');
   query.SQLConnection.ExecuteDirect('DELETE FROM TEstGrupo');
end;

procedure LimpaClasses(query: TSQLQuery);
begin
   query.SQLConnection.ExecuteDirect('Delete From TEstClasse');
end;

procedure LimpaMarcas(query: TSQLQuery);
begin
   query.SQLConnection.ExecuteDirect('Delete From TEstMarca');
end;

end.

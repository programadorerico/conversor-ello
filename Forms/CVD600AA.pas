unit CVD600AA;

interface

uses
  SysUtils, Variants, Classes, Controls, Forms, PaiConversor, StdCtrls, DBClient, ADODB, DB, SqlExpr, ComCtrls, FMTBcd,
  Provider, Buttons, ToolWin, cxControls, cxContainer, cxEdit, cxTextEdit, cxMemo, Grids, DBGrids, ExlDBGrid, PtlBox1,
  Graphics, ExtCtrls, EllBox, UProdutos;

type
  TFCVD600AA = class(TFPaiConversor)
    CBEstoque: TCheckBox;
    CBEstoque1: TCheckBox;
    ADOTable1: TADOTable;
    procedure CBEstoqueClick(Sender: TObject);
    procedure BImportarClick(Sender: TObject);
    procedure CDSProdutosBeforeScroll(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject); override;
  private
    { Private declarations }
    FIdMovimento : Integer;
    procedure LimpaRegistros; override;
    procedure GravaRegistro; override;
    procedure AntesDeImportar; override;
    procedure GravaProduto(produtoConvertido: TProdutoConvertido);
    procedure GravaEstoque(produtoConvertido: TProdutoConvertido);
  public
    { Public declarations }
  end;

var
  FCVD600AA: TFCVD600AA;

implementation

uses Utils, UnSql, UDataModule, PaiRotinaEll;

var  fIdInventario: Integer;

{$R *.dfm}

procedure TFCVD600AA.FormCreate(Sender: TObject);
begin
   inherited;
   QueryOrigem.SQL.Text := UProdutos.QUERY;
end;

procedure TFCVD600AA.LimpaRegistros;
begin
   LimpaProdutos(QueryTrabalho);
   LimpaClasses(QueryTrabalho);
   inherited;
end;

procedure TFCVD600AA.CBEstoqueClick(Sender: TObject);
begin
   inherited;
   CBEstoque1.Enabled := CBEstoque.Checked;
end;

procedure TFCVD600AA.GravaRegistro;
var
   produtoConvertido: TProdutoConvertido;
begin
   inherited;
   produtoConvertido := TProdutoConvertido.Create;
   produtoConvertido.QueryPesquisa := QueryPesquisa;
   produtoConvertido.CarregaDoDataset(CDSDadosOrigem);

   try
      GravaProduto(produtoConvertido);
   except
      on e:Exception do begin
         GravaLog('Produto: ' + IntToStr(produtoConvertido.IdProduto) + ' Mensagem: ' + E.Message);
         produtoConvertido.Free;
         raise;
      end;
   end;

   try
      GravaEstoque(produtoConvertido);
   except
      on e:Exception do begin
         GravaLog('Produto: ' + IntToStr(produtoConvertido.IdProduto) + ' Mensagem: ' + E.Message);
         produtoConvertido.Free;
         raise;
      end;
   end;

   produtoConvertido.Free;
end;

procedure TFCVD600AA.GravaProduto(produtoConvertido: TProdutoConvertido);
begin
   with SqlDados do begin
      Start(tcInsert, 'TEstProduto', QueryTrabalho);
      AddValue('IdProduto',                produtoConvertido.IdProduto);
      AddValue('Matricula',                produtoConvertido.IdProduto);
      AddValue('IdProdutoPrincipal',       produtoConvertido.IdProduto);
      AddValue('Descricao',                produtoConvertido.Descricao);
      AddValue('DescComum',                produtoConvertido.Descricao);
      AddValue('Embalagem',                produtoConvertido.Embalagem);
      AddValue('IdSubGrupo',               produtoConvertido.IdSubGrupo);
      AddValue('IdMarca',                  produtoConvertido.IdMarca);
      AddValue('PrecoVenda',               produtoConvertido.PrecoVenda);
      AddValue('PrecoPrazo',               produtoConvertido.PrecoVenda);
      AddValue('VarejoPreco',              produtoConvertido.PrecoVenda);
      AddValue('AtacadoPreco',             produtoConvertido.PrecoVenda);
      AddValue('PagaComissao',             produtoConvertido.PagaComissao);
      AddValue('Status',                   produtoConvertido.Status);
      AddValue('CodNcm',                   produtoConvertido.CodNCM);
      AddValue('IdGrupoIcms',              produtoConvertido.IdGrupoICMS);
      AddValue('IdTributacao',             produtoConvertido.IdTributacao);
      AddValue('IdGrupoCredito',           produtoConvertido.IdGrupoCredito);
      AddValue('IdClasse',                 produtoConvertido.IdClasse);
      AddValue('MargemGarantido',          produtoConvertido.MargemGarantido);
      AddValue('CodBarras',                produtoConvertido.CodBarras);
      AddValue('CodReferencia',            produtoConvertido.CodReferencia);
      AddValue('CodAntigo',                produtoConvertido.CodAntigo);
      AddValue('ClassFiscal',              produtoConvertido.ClassFiscal);
      AddValue('ControlaLote',             produtoConvertido.ControlaLote);
      AddValue('PrecoLivre',               produtoConvertido.PrecoLivre);
      AddValue('Fracionado',               produtoConvertido.Fracionado);
      AddValue('Monitorado',               produtoConvertido.Monitorado);
      AddValue('Continuo',                 produtoConvertido.Continuo);
      AddValue('Decimais',                 produtoConvertido.Decimais);
      AddValue('DescontoMaximo',           produtoConvertido.DescontoMaximo);
      AddValue('Desconto',                 produtoConvertido.Desconto);
      AddValue('ComissaoEspecial',         produtoConvertido.ComissaoEspecial);
      AddValue('ComissaoVista',            produtoConvertido.ComissaoVista);
      AddValue('ComissaoPrazo',            produtoConvertido.ComissaoPrazo);
      AddValue('EstoqueAutomatico',        produtoConvertido.EstoqueAutomatico);
      AddValue('EstoqueMaximo',            produtoConvertido.EstoqueMaximo);
      AddValue('EstoqueMinimo',            produtoConvertido.EstoqueMinimo);
      AddValue('EstoqueCritico',           produtoConvertido.EstoqueCritico);
      AddValue('Bonificacao',              produtoConvertido.Bonificacao);
      AddValue('Fabricacao',               produtoConvertido.Fabricacao);
      AddValue('Nacional',                 produtoConvertido.Nacional);
      AddValue('Importacao',               produtoConvertido.Importacao);
      AddValue('Fabrica_Anterior',         produtoConvertido.PrecoCusto);
      AddValue('Fabrica_Atual',            produtoConvertido.PrecoCusto);
      AddValue('Fabrica_MedioAnterior',    produtoConvertido.PrecoCusto);
      AddValue('Fabrica_MedioAtual',       produtoConvertido.PrecoCusto);
      AddValue('Nota_Anterior',            produtoConvertido.PrecoCusto);
      AddValue('Nota_Atual',               produtoConvertido.PrecoCusto);
      AddValue('Nota_MedioAnterior',       produtoConvertido.PrecoCusto);
      AddValue('Nota_MedioAtual',          produtoConvertido.PrecoCusto);
      AddValue('Reposicao_Anterior',       produtoConvertido.PrecoCusto);
      AddValue('Reposicao_Atual',          produtoConvertido.PrecoCusto);
      AddValue('Reposicao_MedioAnterior',  produtoConvertido.PrecoCusto);
      AddValue('Reposicao_MedioAtual',     produtoConvertido.PrecoCusto);
      AddValue('MargemLucro',              produtoConvertido.MargemLucro);
      AddValue('QtdeEmbalagem',            produtoConvertido.QtdeEmbalagem);
      AddValue('AtacadoAjuste',            produtoConvertido.AtacadoAjuste);
      AddValue('VarejoAjuste',             produtoConvertido.VarejoAjuste);
      AddValue('AtacadoQtde',              produtoConvertido.AtacadoQtde);
      AddValue('IdPisEntrada',             produtoConvertido.IdPisEntrada);
      AddValue('IdPisSaida',               produtoConvertido.IdPisSaida);
      AddValue('IdCofinsEntrada',          produtoConvertido.IdCofinsEntrada);
      AddValue('IdCofinsSaida',            produtoConvertido.IdCofinsSaida);
      AddValue('Usuario',                  produtoConvertido.Usuario);
      AddValue('DataCadastro',             produtoConvertido.DataCadastro);
      AddValue('IdFornecedor',             produtoConvertido.IdFornecedor);
      Executa;
   end;
end;

procedure TFCVD600AA.GravaEstoque(produtoConvertido: TProdutoConvertido);
var
   produtoMovimento: TEstProdutoMovimento;
begin
   if not CBEstoque.Checked then
      Exit;

   if (produtoConvertido.QuantidadeEmEstoque<=0) then
      Exit;

   Inc(FIdMovimento);
   produtoMovimento := TEstProdutoMovimento.Create;
   try
      produtoMovimento.IdMovimento        := FIdMovimento;
      produtoMovimento.IdInventario       := fIdInventario;
      produtoMovimento.IdProduto          := produtoConvertido.IdProduto;
      produtoMovimento.IdProdutoPrincipal := produtoConvertido.IdProduto;
      produtoMovimento.IdAlmox            := 1;
      produtoMovimento.Descricao          := produtoConvertido.Descricao;
      produtoMovimento.MovimentaEstoque   := True;
      produtoMovimento.IdTipoMovimento    := tmInventario;
      produtoMovimento.Qtde               := produtoConvertido.QuantidadeEmEstoque;
      produtoMovimento.QtdeEmbalagem      := 1;
      produtoMovimento.PrVenda            := produtoConvertido.PrecoVenda;
      produtoMovimento.Valor              := produtoConvertido.PrecoVenda;
      produtoMovimento.Grava;
   finally
      produtoMovimento.Free;
   end;
end;

procedure TFCVD600AA.BImportarClick(Sender: TObject);
begin
   fIdInventario    := 0;
   FIdMovimento     := 0;
   inherited;
end;

procedure TFCVD600AA.CDSProdutosBeforeScroll(DataSet: TDataSet);
begin
   inherited;
   ProgressBar1.Position := ProgressBar1.Position + 1;
   ProgressBar1.Refresh;
   Label12.Caption       := StrZero(ProgressBar1.Position,6)+ ' / ' + StrZero(ProgressBar1.Max,6);
   Label12.Refresh;
   Application.ProcessMessages;
end;

procedure TFCVD600AA.AntesDeImportar;
begin
   inherited;

   // inserir as classes no banco de dados.
   Datam1.sConnection.ExecuteDirect(
      'INSERT INTO TESTCLASSE (IDCLASSE, DESCRICAO, MONITORADO, AJUSTE, AJUSTEPERCENTUAL, DESCONTO, DESCONTOPERCENTUAL,' +
                               'COMISSAOESPECIAL, COMISSAOVISTA, COMISSAOPRAZO, MARGEMLUCRO, USUARIO, IMAGEM, LISTAEXCECOES,' +
                               'IDCONTA, IDCONTAVISTA, IDCONTAPRAZO, MOBILE) ' +
      'VALUES (''1'', ''CLASSE'', ''N'', ''N'', ''0.0000'', ''N'', ''0.0000'', ''N'', ''0.000'', ''0.000'', ''0.000000'', ''TRIBURTINI'', ''0'', ' +
      'NULL, NULL, NULL, NULL, ''S'')'
   );

end;

initialization RegisterClass(TFCVD600AA);

end.



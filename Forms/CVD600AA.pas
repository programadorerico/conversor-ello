unit CVD600AA;

interface

uses
  SysUtils, Variants, Classes, Controls, Forms, PaiConversor, StdCtrls, DBClient, ADODB, DB, SqlExpr, ComCtrls, FMTBcd,
  Provider, Buttons, ToolWin, cxControls, cxContainer, cxEdit, cxTextEdit, cxMemo, Grids, DBGrids, ExlDBGrid, PtlBox1,
  Graphics, ExtCtrls, EllBox;

type
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

  TFCVD600AA = class(TFPaiConversor)
    CBEstoque: TCheckBox;
    CBEstoque1: TCheckBox;
    ADOTable1: TADOTable;
    CDSProdutos: TClientDataSet;
    procedure CBEstoqueClick(Sender: TObject);
    procedure BImportarClick(Sender: TObject);
    procedure CDSProdutosAfterOpen(DataSet: TDataSet);
    procedure CDSProdutosBeforeScroll(DataSet: TDataSet);
  private
    { Private declarations }
    FIdProduto: Integer;
    procedure LimpaRegistros; override;
    procedure GravaRegistro; override;
    function GeraNovoEAN13(const Codigo: string): string;
  public
    { Public declarations }
  end;

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

var
  FCVD600AA: TFCVD600AA;

implementation

uses Utils, UnSql, UDataModule, UCodigoEAN, UProdutos, PaiRotinaEll;

var  fIdInventario: Integer;
     fIdLote: Integer;
     fIdMovimentoLote: Integer;
     fIdentificador: Integer;

{$R *.dfm}

procedure TFCVD600AA.LimpaRegistros;
begin
   LimpaProdutos(QueryTrabalho);
   inherited;
end;

procedure TFCVD600AA.CBEstoqueClick(Sender: TObject);
begin
   inherited;
   CBEstoque1.Enabled := CBEstoque.Checked;
end;

procedure TFCVD600AA.GravaRegistro;
var
   produtoMovimento: TEstProdutoMovimento;
   precoCusto: double;

    function GetGrupoIcms: Integer;
    begin
       Result := 5; // tributado
//       if CDSProdutos.FieldByName('TribECFInt').AsString='06' then
//          Result := 6;
    end;

    function GetTributacao: Integer;
    begin
       Result := 605;
//       if CDSProdutos.FieldByName('TribECFInt').AsString='06' then
//          Result := 600;
    end;

    function GetClasse: Integer;
    begin
       Result := 1;
    end;

    function GetMarca: Integer;
    var marca: String;
    begin
       marca := Trim(CDSDados.FieldByName('marca').AsString);
       QueryPesquisa.SQL.Text := format('select idmarca from testmarca where descricao=%s', [QuotedStr(marca)]);
       QueryPesquisa.Open;
       if QueryPesquisa.IsEmpty then Result := 1
       else Result := QueryPesquisa.FieldByName('idmarca').AsInteger;
    end;

    function GetSubGrupo: Integer;
    var subgrupo: String;
    begin
       subgrupo := Trim(CDSDados.FieldByName('subgrp').AsString);
       QueryPesquisa.SQL.Text := format('select idsubgrupo from testsubgrupo where descricao=%s', [QuotedStr(subgrupo)]);
       QueryPesquisa.Open;
       Result := QueryPesquisa.FieldByName('idsubgrupo').AsInteger;
    end;

    function GetUnidadeMedida: String;
    begin
       Result := Copy(Trim(UpperCase(CDSDados.FieldByName('UNIDADE').AsString)), 1, 2);
       if Result = '' then Result := 'UN';
       if Result = '1' then Result := 'UN';
       if Result = '81' then Result := 'UN';
    end;

    function GetCodBarra: String;
    var codbarras: String;
    begin
       codbarras := CDSDados.FieldByName('codbarra').AsString;
       if Length(codbarras)<13 then
          Result := GeraNovoEAN13(IntToStr(fIdProduto))
       else
          Result := codbarras;
    end;

    function GetDescricao: String;
    begin
       Result := Trim(UpperCase(TirarAcentos(CDSDados.FieldByName('descricao').AsString)));
    end;

    procedure GravaProduto;
    begin
       FIdProduto := CDSDados.FieldByName('codigo').AsInteger;
       precoCusto := 0;
       try
          with SqlDados do begin
             Start(tcInsert, 'TEstProduto', QueryTrabalho);
             AddValue('IdProduto',                FIdProduto);
             AddValue('IdProdutoPrincipal',       FIdProduto);
             AddValue('IdGrupoIcms',              GetGrupoIcms);
             AddValue('IdTributacao',             GetTributacao);
             AddValue('IdGrupoCredito',           1);
             AddValue('IdSubGrupo',               1);
             AddValue('IdMarca',                  GetMarca);
             AddValue('IdClasse',                 GetClasse);
             AddValue('Matricula',                FIdProduto);
             AddValue('Descricao',                GetDescricao);
             AddValue('DescComum',                GetDescricao);
             AddValue('MargemGarantido',          0);
             AddValue('CodBarras',                GetCodBarra);
             AddValue('CodReferencia',            IntToStr(FIdProduto));
             AddValue('CodAntigo',                '');
             AddValue('CodNcm',                   CDSDados.FieldByName('idncm').AsString);
             AddValue('ClassFiscal',              '');
             AddValue('ControlaLote',             'N');
             AddValue('PrecoLivre',               'N');
             AddValue('Fracionado',               'N');
             AddValue('Monitorado',               'N');
             AddValue('Continuo',                 'N');
             AddValue('Decimais',                 2);
             AddValue('DescontoMaximo',           'N');
             AddValue('Desconto',                 0);
             AddValue('PagaComissao',             'S');
             AddValue('ComissaoEspecial',         'N');
             AddValue('ComissaoVista',            0);
             AddValue('ComissaoPrazo',            0);
             AddValue('EstoqueAutomatico',        'N');
             AddValue('EstoqueMaximo',            0);
             AddValue('EstoqueMinimo',            0);
             AddValue('EstoqueCritico',           0);
             AddValue('Bonificacao',              0);
             AddValue('Fabricacao',               'N');
             AddValue('Nacional',                 'S');
             AddValue('Importacao',               'N');
             AddValue('Fabrica_Anterior',         precoCusto);
             AddValue('Fabrica_Atual',            precoCusto);
             AddValue('Fabrica_MedioAnterior',    precoCusto);
             AddValue('Fabrica_MedioAtual',       precoCusto);
             AddValue('Nota_Anterior',            precoCusto);
             AddValue('Nota_Atual',               precoCusto);
             AddValue('Nota_MedioAnterior',       precoCusto);
             AddValue('Nota_MedioAtual',          precoCusto);
             AddValue('Reposicao_Anterior',       precoCusto);
             AddValue('Reposicao_Atual',          precoCusto);
             AddValue('Reposicao_MedioAnterior',  precoCusto);
             AddValue('Reposicao_MedioAtual',     precoCusto);
             AddValue('MargemLucro',              43);
             AddValue('PrecoVenda',               CDSDados.FieldByName('precovenda').AsFloat);
             AddValue('PrecoPrazo',               CDSDados.FieldByName('precovenda').AsFloat);
             AddValue('Status',                   'ATIVO');
             AddValue('Embalagem',                GetUnidadeMedida);
             AddValue('QtdeEmbalagem',            1);
             AddValue('VarejoAjuste',             0);
             AddValue('VarejoPreco',              CDSDados.FieldByName('precovenda').AsFloat);
             AddValue('AtacadoAjuste',            0);
             AddValue('AtacadoPreco',             CDSDados.FieldByName('precovenda').AsFloat);
             AddValue('AtacadoQtde',              0);
             AddValue('IdPisEntrada',             10);
             AddValue('IdPisSaida',               10);
             AddValue('IdCofinsEntrada',          10);
             AddValue('IdCofinsSaida',            10);
             AddValue('Usuario',                  'IMPLANTACAO');
             Executa;
          end;
       except on e:Exception do GravaLog('Produto: ' + CDSDados.FieldByName('IDPRODUTO').AsString + ' Mensagem: ' + E.Message);
       end;
    end;

    procedure GravaEstoque;

        procedure GravaCapaInventario;
        begin
           fIdInventario := 1;
           with SqlDados do begin
              Start(tcInsert, 'TEstInventario', QueryTrabalho);
                 AddValue('Empresa',       1);
                 AddValue('IdInventario',  fIdInventario);
                 AddValue('IdAlmox',       1);
                 AddValue('Usuario',       'IMPLANTACAO');
              Executa;
           end;
        end;

    begin
       if not CBEstoque.Checked then exit;
       if (CDSDados.FieldByName('estoque').AsFloat<=0) then exit;

       try
          if fIdInventario=0 then GravaCapaInventario;

          produtoMovimento := TEstProdutoMovimento.Create;

          produtoMovimento.IdInventario       := fIdInventario;
          produtoMovimento.IdProduto          := fIdProduto;
          produtoMovimento.IdProdutoPrincipal := fIdProduto;
          produtoMovimento.IdAlmox            := 1;
          produtoMovimento.Descricao          := Copy(UpperCase(TirarAcentos(CDSDados.FieldByName('descricao').AsString)), 1, 50);
          produtoMovimento.MovimentaEstoque   := True;
          produtoMovimento.IdTipoMovimento    := tmInventario;
          produtoMovimento.Qtde               := CDSDados.FieldByName('estoque').AsCurrency;
          produtoMovimento.QtdeEmbalagem      := 1;
          produtoMovimento.PrVenda            := CDSDados.FieldByName('precovenda').AsFloat;
          produtoMovimento.Valor              := CDSDados.FieldByName('precovenda').AsFloat;
          produtoMovimento.Grava;

          FreeAndNil(produtoMovimento);
       except on e:Exception do begin
             FreeAndNil(produtoMovimento);
             GravaLog('Produto: ' + CDSDados.FieldByName('IDPRODUTO').AsString + ' Mensagem: '+E.Message);
          end;
       end;

    end;

begin
   inherited;
   GravaProduto;
   GravaEstoque;
end;

function TFCVD600AA.GeraNovoEAN13(const Codigo: string) :string;
var FCodigoEAN :TCodigoEAN;
begin
   FCodigoEAN := TCodigoEAN.Create;
   try
      FCodigoEAN.CodigoEAN := '110010'+StrZero(Codigo,6)+'0';
      FCodigoEAN.ValidaCodigo;
      Result := FCodigoEAN.CodigoEAN;
   finally
      FCodigoEAN.Free;
   end;
end;

procedure TFCVD600AA.BImportarClick(Sender: TObject);
begin
   fIdProduto       := 0;
   fIdInventario    := 0;
   fIdentificador   := 0;
   fIdLote          := 0;
   fIdMovimentoLote := 0;
   inherited;
end;

procedure TFCVD600AA.CDSProdutosAfterOpen(DataSet: TDataSet);
begin
   inherited;
   Label1.Caption        := 'Registros '+StrZero(CDSProdutos.RecordCount,6);
   Label1.Visible        := True;
   ProgressBar1.Max      := CDSProdutos.RecordCount;
   ProgressBar1.Position := 0;
   BImportar.Enabled     := CDSProdutos.RecordCount>0;
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

{ TEstProdutoMovimento }

procedure TEstProdutoMovimento.Grava;
begin
   with SqlDados do begin
      Inc(fIdentificador);
      Self.IdMovimento := fIdentificador;

      Start(tcInsert,'TEstProdutoMovimento', Datam1.QueryTrabalho);
         AddValue('Empresa',              1);
         AddValue('IdMovimento',          fIdentificador     );
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

initialization RegisterClass(TFCVD600AA);

end.



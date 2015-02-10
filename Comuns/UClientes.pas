unit UClientes;

interface

uses SqlExpr;

procedure LimpaClientes(query: TSQLQuery);

implementation

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

end.

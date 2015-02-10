unit UProdutos;

interface

uses SqlExpr;

procedure LimpaProdutos(query: TSQLQuery);
procedure LimpaGrupos(query: TSQLQuery);
procedure LimpaClasses(query: TSQLQuery);
procedure LimpaMarcas(query: TSQLQuery);

implementation

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

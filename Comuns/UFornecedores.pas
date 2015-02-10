unit UFornecedores;

interface

uses SqlExpr;

procedure LimpaFornecedores(query: TSQLQuery);

implementation

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

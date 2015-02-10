unit GravaDados;

interface
uses UDataModule, SqlExpr, SysUtils, EllClientDataSet, EllLocate, DB, unSql, Utilitarios;

function  NewIdentificador(Tabela:String; Param01: String=''):Integer; overload;
function  NewIdentificador(Tabela: String; Id: String; EmpresaNaChave: Boolean): Integer; overload;
function  NovoIdentificador(CDSDados :TEllClientDataSet; Incrementar:Boolean=False):Integer;
function  ClausulaWhere(CDSDados: TEllClientDataSet): String;
function  InsereRegistro(CDSDados: TEllClientDataSet): Boolean;
function  ExcluiRegistro(CDSDados: TEllClientDataSet): Boolean;
function  AlteraRegistro(CDSDados: TEllClientDataSet): Boolean;
procedure RepassaValoresCampos(Query:TSqlQuery; CDSDados:TEllClientDataSet);
procedure AjustaSequencial(CDSDados :TEllClientDataSet);
procedure LimpaCampoChave(CampoChave :TEllLocate);
procedure AjustaEmpresaUsuario(CDSDados :TEllClientDataSet);


implementation
uses EllTypes;

function NewIdentificador(Tabela: String; Id: String; EmpresaNaChave: Boolean): Integer; overload;
var TextoSql :String;
begin
   Tabela := UpperCase(Tabela);
   Id     := UpperCase(Id);
   Result := 1;
   if EmpresaNaChave then begin
       TextoSql := Format('Select Max(%s) Id From %s Where Empresa = %d',  [Id, Tabela, 1]);
   end else begin
       TextoSql := Format('Select Max(%s) Id From %s ',  [Id, Tabela]);
   end;
   with Datam1.QueryPesquisa do begin
      Sql.Clear;
      Sql.Add(TextoSql);
      if QueryOpen(Datam1.QueryPesquisa) then begin
         Result := StrToIntDef(FieldByName('Id').AsString, 0)+1;
         if Tabela='TRECMOTIVOBLOQUEIO'     then Result := iif(Result<20,20,Result);
      end;
   end;
end;

function NewIdentificador(Tabela:String; Param01: String=''):Integer;
var TextoSql :String;
begin
   Tabela   := UpperCase(Tabela);
   TextoSql := '';
   with Datam1.QueryPesquisa do begin
      Result := 1;
      if Tabela='TBLOQUEIO'                 then TextoSql := Format('Select Max(IdBloqueio)            Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TBLOQUEIOITEM'             then TextoSql := Format('Select Max(IdBloqueioItem)        Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TBLOQUEIOFORMAS'           then TextoSql := Format('Select Max(IdBloqueioForma)       Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TBLOQUEIOPRODUTOS'         then TextoSql := Format('Select Max(IdBloqueioProduto)     Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);

      if Tabela='TCENCENTROCUSTO'           then TextoSql := Format('Select Max(IdCentroCusto)         Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TCENPLANOCONTA'            then TextoSql := Format('Select Max(IdConta)               Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);

      if Tabela='TCTABANCO'                 then TextoSql := Format('Select Max(IdBanco)               Id From %s ', [Tabela]);
      if Tabela='TCTACONTA'                 then TextoSql := Format('Select Max(IdConta)               Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TCTAOPERACAO'              then TextoSql := Format('Select Max(IdOperacao)            Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TCTALANCAMENTO'            then TextoSql := Format('Select Max(IdLancamento)          Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TCTADEPOSITO'              then TextoSql := Format('Select Max(IdDeposito)            Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);

      if Tabela='TMEMMEMBRO'                then TextoSql := Format('Select Max(IdMembro)              Id From %s ', [Tabela]);
      if Tabela='TMEMCARGO'                 then TextoSql := Format('Select Max(IdCargo)               Id From %s ', [Tabela]);
      if Tabela='TMEMCONGREGACAO'           then TextoSql := Format('Select Max(IdCongregacao)         Id From %s ', [Tabela]);

      if Tabela='TESTALMOXARIFADO'          then TextoSql := Format('Select Max(IdAlmox)               Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TESTMARCA'                 then TextoSql := Format('Select Max(IdMarca)               Id From %s ', [Tabela]);
      if Tabela='TESTNATUREZA'              then TextoSql := Format('Select Max(IdNatureza)            Id From %s ', [Tabela]);
      if Tabela='TESTTRIBUTACAO'            then TextoSql := Format('Select Max(IdTributacao)          Id From %s ', [Tabela]);
      if Tabela='TESTCLASSIFICACAO'         then TextoSql := Format('Select Max(IdClassificacao)       Id From %s ', [Tabela]);
      if Tabela='TESTCLASSE'                then TextoSql := Format('Select Max(IdClasse)              Id From %s ', [Tabela]);
      if Tabela='TESTGRUPO'                 then TextoSql := Format('Select Max(IdGrupo)               Id From %s ', [Tabela]);
      if Tabela='TESTSUBGRUPO'              then TextoSql := Format('Select Max(IdSubGrupo)            Id From %s ', [Tabela]);
      if Tabela='TESTPRODUTO'               then TextoSql := Format('Select Max(IdProduto)             Id From %s ', [Tabela]);
      if Tabela='TESTPRODUTOEXTRATO'        then TextoSql := Format('Select Max(IdExtrato)             Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TESTPRODUTOMOVIMENTO'      then TextoSql := Format('Select Max(IdMovimento)           Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TESTGRUPOICMS'             then TextoSql := Format('Select Max(IdGrupoIcms)           Id From %s ', [Tabela]);
      if Tabela='TESTGRUPOCREDITO'          then TextoSql := Format('Select Max(IdGrupoCredito)        Id From %s ', [Tabela]);
      if Tabela='TESTINVENTARIO'            then TextoSql := Format('Select Max(IdInventario)          Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TESTAJUSTEPRECO'           then TextoSql := Format('Select Max(IdAjuste)              Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TESTFABRICANTE'            then TextoSql := Format('Select Max(IdFabricante)          Id From %s ', [Tabela]);
      if Tabela='TESTTRANSFALMOXARIFADO'    then TextoSql := Format('Select Max(IdTransfAlmoxarifado)  Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TESTPRODUTOLOTE'           then TextoSql := Format('Select Max(IdLote)                Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TESTPRODUTOMOVIMENTOLOTE'  then TextoSql := Format('Select Max(IdMovimentoLote)       Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TESTCARGA'                 then TextoSql := Format('Select Max(IdCarga)               Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TESTCARGADESPESAS'         then TextoSql := Format('Select Max(Identificador)         Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TESTDESPESA'               then TextoSql := Format('Select Max(IdDespesa)             Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TESTUNIDADEMEDIDA'         then TextoSql := Format('Select Max(IdUnidadeMedida)       Id From %s ', [Tabela]);

      if Tabela='TFICFICHA'                 then TextoSql := Format('Select Max(IdFicha)               Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TFICOPERACAO'              then TextoSql := Format('Select Max(IdOperacao)            Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TFICLANCAMENTO'            then TextoSql := Format('Select Max(IdLancamento)          Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);

      if Tabela='TNFNOPERACAO'              then TextoSql := Format('Select Max(IdOperacao)            Id From %s ', [Tabela]);
      if Tabela='TNFNNOTA'                  then TextoSql := Format('Select Max(IdNota)                Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TNFEPRODUTO'               then TextoSql := Format('Select Max(Identificador)         Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);

      if Tabela='TREGREGISTRADORA'          then TextoSql := Format('Select Max(IdRegistradora)        Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TREGPERIODO'               then TextoSql := Format('Select Max(IdPeriodo)             Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TREGREGISTRO'              then TextoSql := Format('Select Max(IdRegistro)            Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TREGREGISTROFORMA'         then TextoSql := Format('Select Max(IdRegistroForma)       Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);

      if Tabela='TPAGFORNECEDOR'            then TextoSql := Format('Select Max(IdFornecedor)          Id From %s ', [Tabela]);
      if Tabela='TPAGDOCUMENTO'             then TextoSql := Format('Select Max(IdDocumento)           Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TPAGDOCUMENTOTIPO'         then TextoSql := Format('Select Max(IdTipo)                Id From %s ', [Tabela]);
      if Tabela='TPAGPARCELA'               then TextoSql := Format('Select Max(IdParcela)             Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TPAGBAIXA'                 then TextoSql := Format('Select Max(IdBaixa)               Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);

      if Tabela='TPAGPREGAO'                then TextoSql := Format('Select Max(IdPregao)              Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TPAGPREGAOPRODUTOS'        then TextoSql := Format('Select Max(Identificador)         Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TPAGPREGAOAJUSTE'          then TextoSql := Format('Select Max(IdAjuste)              Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TPAGPREGAOADITIVO'         then TextoSql := Format('Select Max(IdAditivo)             Id From %s Where Empresa = %s and IdPregao = %s', [Tabela, IntToStr(Empresa), Param01]);

      if Tabela='TRECCLIENTE'               then TextoSql := Format('Select Max(IdCliente)             Id From %s ', [Tabela]);
      if Tabela='TRECCLIENTEBLOQUEIO'       then TextoSql := Format('Select Max(IdBloqueio)            Id From %s ', [Tabela]);
      if Tabela='TRECCLIENTECLASSIFICACAO'  then TextoSql := Format('Select Max(IdClassificacao)       Id From %s ', [Tabela]);
      if Tabela='TRECDOCUMENTO'             then TextoSql := Format('Select Max(IdDocumento)           Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TRECPARCELA'               then TextoSql := Format('Select Max(IdParcela)             Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TRECCHEQUE'                then TextoSql := Format('Select Max(IdCheque)              Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TRECCHEQUEMOVIMENTO'       then TextoSql := Format('Select Max(IdMovimento)           Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TRECBAIXA'                 then TextoSql := Format('Select Max(IdBaixa)               Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TRECREGIAO'                then TextoSql := Format('Select Max(IdRegiao)              Id From %s ', [Tabela]);
      if Tabela='TRECINDICE'                then TextoSql := Format('Select Max(IdIndice)              Id From %s ', [Tabela]);
      if Tabela='TRECMOTIVOBLOQUEIO'        then TextoSql := Format('Select Max(IdMotivo)              Id From %s ', [Tabela]);
      if Tabela='TRECCREDITOMOVIMENTO'      then TextoSql := Format('Select Max(IdMovimento)           Id From %s ', [Tabela]);

      if Tabela='THSPPROCEDIMENTO'          then TextoSql := Format('Select Max(IdProcedimento)        Id From %s ', [Tabela]);
      if Tabela='THSPPROCEDIMENTOLCTO'      then TextoSql := Format('Select Max(IdProcedimentoLcto)    Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='THSPMEDICO'                then TextoSql := Format('Select Max(IdMedico)              Id From %s ', [Tabela]);
      if Tabela='THSPOPERADORA'             then TextoSql := Format('Select Max(IdOperadora)           Id From %s ', [Tabela]);

      if Tabela='TGEREMPRESA'               then TextoSql := Format('Select Max(Codigo)                Id From %s ', [Tabela]);
      if Tabela='TGERADMINISTRADORAS'       then TextoSql := Format('Select Max(IdAdministradora)      Id From %s ', [Tabela]);
      if Tabela='TGERPESQUISA'              then TextoSql := Format('Select Max(IdPesquisa)            Id From %s ', [Tabela]);
      if Tabela='TGERACESSO'                then TextoSql := Format('Select Max(IdAcesso)              Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TGERPROGRAMA'              then TextoSql := Format('Select Max(IdPrograma)            Id From %s ', [Tabela]);
      if Tabela='TGERMENU'                  then TextoSql := Format('Select Max(IdMenu)                Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TGERAUTONOMIAS'            then TextoSql := Format('Select Max(Identificador)         Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TGERRELATORIOS'            then TextoSql := Format('Select Max(IdRelatorio)           Id From %s ', [Tabela]);
      if Tabela='TGERPARAMETROS'            then TextoSql := Format('Select Max(IdParametro)           Id From %s ', [Tabela]);
      if Tabela='TGERUNIDADE'               then TextoSql := Format('Select Max(IdUnidade)             Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TGERSOLICITANTE'           then TextoSql := Format('Select Max(IdSolicitante)         Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TGERCENTROCUSTO'           then TextoSql := Format('Select Max(IdCentroCusto)         Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TGERCENTROCUSTOTETO'       then TextoSql := Format('Select Max(IdTeto)                Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TGERCIDADE'                then TextoSql := Format('Select Max(IdCidade)              Id From %s ', [Tabela]);
      if Tabela='TGEROCUPACAO'              then TextoSql := Format('Select Max(IdOcupacao)            Id From %s ', [Tabela]);
      if Tabela='TGERUSUARIO'               then TextoSql := Format('Select Max(IdUsuario)             Id From %s ', [Tabela]);
      if Tabela='TGERETIQUETAS'             then TextoSql := Format('Select Max(IdEtiqueta)            Id From %s ', [Tabela]);
      if Tabela='TGERETIQUETASCAMPOS'       then TextoSql := Format('Select Max(IdEtiquetaCampo)       Id From %s ', [Tabela]);
      if Tabela='TGERPISCOFINS'             then TextoSql := Format('Select Max(IdPisCofins)           Id From %s ', [Tabela]);

      if Tabela='TGERSETOR'                 then TextoSql := Format('Select Max(IdSetor)               Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TGERFUNCAO'                then TextoSql := Format('Select Max(IdFuncao)              Id From %s ', [Tabela]);
      if Tabela='TGERALOJAMENTO'            then TextoSql := Format('Select Max(IdAlojamento)          Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TGERALOJAMENTOQUARTO'      then TextoSql := Format('Select Max(IdQuarto)              Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);

      if Tabela='TLABCATEGORIA'             then TextoSql := Format('Select Max(IdCategoria)           Id From %s ', [Tabela]);
      if Tabela='TLABEXAMES'                then TextoSql := Format('Select Max(IdExame)               Id From %s ', [Tabela]);
      if Tabela='TLABEXAMESCAMPO'           then TextoSql := Format('Select Max(IdCampo)               Id From %s ', [Tabela]);
      if Tabela='TLABRESULTADO'             then TextoSql := Format('Select Max(IdResultado)           Id From %s ', [Tabela]);
      if Tabela='TLABRECEPCAO'              then TextoSql := Format('Select Max(IdExame)               Id From %s ', [Tabela]);

      if Tabela='TETQPRODUTO'               then TextoSql := Format('Select Max(IdSequencia)           Id From %s ', [Tabela]);
      if Tabela='TETQPRODUTOLOTE'           then TextoSql := Format('Select Max(IdLote)                Id From %s ', ['TETQPRODUTO']);


      if Tabela='TMEGASENA'                 then TextoSql := Format('Select Max(Concurso)              Id From %s ', [Tabela]);
      if Tabela='TBINSORTEIO'               then TextoSql := Format('Select Max(IdSequencia)           Id From %s where IdPremio = %s ', [Tabela, Param01]);

      if Tabela='TREQCOMPRA'                then TextoSql := Format('Select Max(IdRequisicao)          Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TREQCOMPRAPRODUTO'         then TextoSql := Format('Select Max(Identificador)         Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);

      if Tabela='TVDAPEDIDO'                then TextoSql := Format('Select Max(IdPedido)              Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TVDAPEDIDOFORMA'           then TextoSql := Format('Select Max(IdPedidoForma)         Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TVDACONDICAO'              then TextoSql := Format('Select Max(IdCondicao)            Id From %s ', [Tabela]);
      if Tabela='TVDACONSUMIDOR'            then TextoSql := Format('Select Max(IdConsumidor)          Id From %s ', [Tabela]);
      if Tabela='TVDAPRODUTO'               then TextoSql := Format('Select Max(Identificador)         Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TVDACOMISSIONADO'          then TextoSql := Format('Select Max(IdComissionado)        Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TVDACOMISSIONADOTIPO'      then TextoSql := Format('Select Max(IdComissionadoTipo)    Id From %s ', [Tabela]);
      if Tabela='TVDACOMISSAOLIBERADA'      then TextoSql := Format('Select Max(IdLiberacao)           Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TVDAFARMACIAPOPULAR'       then TextoSql := Format('Select Max(IdSolicitacao)         Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);

      { S.N.G.P.C.}
      if Tabela='TSNGPC'                    then TextoSql := Format('Select Max(IdSngpc)               Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TSNGPCPROFISSIONAL'        then TextoSql := Format('Select Max(IdProfissional)        Id From %s ', [Tabela]);
      if Tabela='TSNGPCMOVIMENTO'           then TextoSql := Format('Select Max(IdMovimento)           Id From %s ', [Tabela]);
      if Tabela='TSNGPCRESPONSAVEL'         then TextoSql := Format('Select Max(IdResponsavel)         Id From %s ', [Tabela]);

      { Nota Fiscal Eletronica }
      if Tabela='TNFENOTA'                  then TextoSql := Format('Select Max(IdNota)                Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);

      { Imoveis }
      if Tabela='TIMOVENDA'                 then TextoSql := Format('Select Max(IdVenda)               Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);
      if Tabela='TRENEGOCIACAO'             then TextoSql := Format('Select Max(IdRenegociacao)        Id From %s Where Empresa = %s', [Tabela, IntToStr(Empresa)]);

      if (TextoSql<>'') then begin
         Sql.Clear;
         Sql.Add(TextoSql);
         if QueryOpen(Datam1.QueryPesquisa) then begin
            Result := StrToIntDef(FieldByName('Id').AsString,0)+1;
            if Tabela='TRECMOTIVOBLOQUEIO'     then Result := iif(Result<20,20,Result);
         end;
      end else begin
         raise Exception.CreateHelp('Falta programar a função NewIdentificador para a tabela '+Tabela,1);
      end;
   end;
end;


function NovoIdentificador(CDSDados :TEllClientDataSet; Incrementar:Boolean=False):Integer;
var PorEmpresa    :Boolean;
    QueryPesquisa :TSqlQuery;
    FieldEmpresa  :TField;
    FieldUsuario  :TField;

    function LocalizaIdentificador:Boolean;
    begin
       with QueryPesquisa do begin
          Sql.Clear;
          Sql.Add('SELECT Prm.PorEmpresa             ' +
                  'FROM   TGerParametro Prm          ' +
                  'WHERE  Prm.Parametro = :Parametro ');
          ParamByName('Parametro').AsString := CDSDados.EllIdentificador;
          Result     := QueryOpen(QueryPesquisa);
          PorEmpresa := StrToIntDef(FieldByName('PorEmpresa').AsString,0)=1;
       end;
    end;

    function LocalizaValorIdentificador:Boolean;
    begin
       with QueryPesquisa do begin
          Sql.Clear;
          Sql.Add('SELECT Vlr.Valor                  ' +
                  'FROM   TGerParametroValor Vlr     ' +
                  'WHERE  Vlr.Parametro = :Parametro ');
          if PorEmpresa then Sql.Add(' AND Vlr.Empresa = '+IntToStr(Empresa));
          ParamByName('Parametro').AsString := CDSDados.EllIdentificador;
          Result     := QueryOpen(QueryPesquisa);
       end;
    end;

    procedure Incrementa;
    begin
       with QueryPesquisa do begin
          if Incrementar then begin
             Sql.Clear;
             Sql.Add('UPDATE TGerParametroValor Set ' +
                     '       Valor = :Valor         ' +
                     'WHERE  Parametro = :Parametro ');
             if PorEmpresa then Sql.Add(' AND Empresa = '+IntToStr(Empresa));
             ParamByName('Valor').AsString     := IntToStr(Result);
             ParamByName('Parametro').AsString := CDSDados.EllIdentificador;
             ExecSql;
          end;
       end;
    end;

    procedure IniciaParametro;
    begin
       with QueryPesquisa do begin
          SqlAddString := 'Insert Into TGerParametroValor ( ';
          SqlAddValues := 'Values (';
          SqlAddWhere  := '';

          StrNotNull('Parametro ', 30, CDSDados.EllIdentificador  );
          IntNull   ('Empresa   ',     iif(PorEmpresa,Empresa,0)  );
          StrNotNull('Valor)    ', 06, '0'                        );

          Sql.Clear;
          Sql.Add(SqlAddString + SqlAddValues +  SqlAddWhere);
          ExecSql;
       end;
    end;


begin
   QueryPesquisa               := TSqlQuery(CDSDados.EllDataSet);

   Result := 0;
   if CDSDados.EllIdentificador='' then exit;
   if not CDSDados.EllIncremental  then exit;

   if LocalizaIdentificador then begin
      if LocalizaValorIdentificador then begin
         Result := StrToIntDef(QueryPesquisa.FieldByName('Valor').AsString,0) + 1;
         Incrementa;
      end else begin
         IniciaParametro;
         AjustaSequencial(CDSDados);
         Incrementa;
         if LocalizaValorIdentificador then begin
             Result := StrToIntDef(QueryPesquisa.FieldByName('Valor').AsString,0) + 1;
         end;
      end;
   end else begin
      MensagemEllo('Parametro não cadastrado !!!' + #10#13 +
               'Parametro: ' + CDSDados.EllIdentificador, tmInforma);
      Exit;
   end;

   FieldEmpresa := CDSDados.FindField('EMPRESA');
   FieldUsuario := CDSDados.FindField('USUARIO');

   CDSDados.Edit;
   CDSDados.FieldByName(CDSDados.EllIdentificador).AsInteger := Result;
   if Assigned(FieldEmpresa) and FieldEmpresa.IsNull then FieldEmpresa.AsInteger := Empresa;
   if Assigned(FieldUsuario) and FieldUsuario.IsNull then FieldUsuario.AsString  := Usuario;
   CDSDados.Post;

end;

procedure LimpaCampoChave(CampoChave :TEllLocate);
begin
   CampoChave.Field.AsString := ''
end;


procedure AjustaSequencial(CDSDados :TEllClientDataSet);
var PorEmpresa    :Boolean;
    QueryPesquisa :TSqlQuery;

    function LocalizaIdentificador:Boolean;
    begin
       with QueryPesquisa do begin
          Sql.Clear;
          Sql.Add('SELECT Prm.PorEmpresa             ' +
                  'FROM   TGerParametro Prm          ' +
                  'WHERE  Prm.Parametro = :Parametro ');
          ParamByName('Parametro').AsString := CDSDados.EllIdentificador;
          Result     := QueryOpen(QueryPesquisa);
          PorEmpresa := StrToIntDef(FieldByName('PorEmpresa').AsString,0)=1;
       end;
    end;

    function LocalizaIdentificadorMaximo:String;
    begin
       with QueryPesquisa do begin
          Sql.Clear;
          Sql.Add('SELECT Max('+CDSDados.EllIdentificador+') As Maximo ' +
                  'FROM   ' + CDSDados.EllTableName + '                ');
          if PorEmpresa then Sql.Add('WHERE Empresa = '+IntToStr(Empresa));
          Open;
          Result     := FieldByName('Maximo').AsString;
       end;
    end;

    procedure AjustaIdentificador;
    var Identificador :String;
    begin
       with QueryPesquisa do begin
          Identificador := LocalizaIdentificadorMaximo;
          Sql.Clear;
          Sql.Add('UPDATE TGerParametroValor Set ' +
                  '       Valor = :Valor         ' +
                  'WHERE  Parametro = :Parametro ');
          if PorEmpresa then Sql.Add(' AND Empresa = '+IntToStr(Empresa));
          ParamByName('Valor').AsString     := Identificador;
          ParamByName('Parametro').AsString := CDSDados.EllIdentificador;
          ExecSql;
       end;
    end;

begin

   if CDSDados.EllIdentificador='' then exit;

   QueryPesquisa := TSqlQuery(CDSDados.EllDataSet);
   if LocalizaIdentificador then AjustaIdentificador;

end;

function ClausulaWhere(CDSDados :TEllClientDataSet):String;
var Valor :Variant;
begin
   Valor := CDSDados.FieldByName(CDSDados.EllIdentificador).AsString;
   Valor := iif(CDSDados.EllIncremental, Valor, QuotedStr(Valor));

   Result := ' WHERE ' +CDSDados.EllIdentificador + ' = ' +Valor;
   if CDSDados.EllEmpresaNaChave then Result := Result + ' AND Empresa = ' + IntToStr(Empresa);
end;


function InsereRegistro(CDSDados :TEllClientDataSet):Boolean;
var Contador      :Integer;
    F             :TField;
    SqlDados      :TEllQuery;
begin
   Result := False;
   if CDSDados.IsEmpty         then exit;
   if CDSDados.EllTableName='' then exit;

   NovoIdentificador(CDSDados, True);

   with TSqlQuery(CDSDados.EllDataSet) do begin

      try

         SqlDados := TEllQuery.Create;
         SqlDados.Start(tcInsert, CDSDados.EllTableName, TSqlQuery(CDSDados.EllDataSet), ClausulaWhere(CDSDados));

         for Contador := 0 to CDSDados.FieldCount - 1 do begin
            F := CDSDados.Fields[Contador];
            if (F.Tag in [1, 10]) then SqlDados.AddValue(F.FieldName, F.AsString);
         end;

         SqlDados.Executa;

      except on e:Exception do 
         raise Exception.Create(E.Message);

      end;
      SqlDados.Free;
      Result := True;
   end;
end;


procedure AjustaEmpresaUsuario(CDSDados :TEllClientDataSet);
var Field :TField;
begin
   Field := CDSDados.FindField('Empresa');
   if Assigned(Field) then begin
      CDSDados.Edit;
      Field.AsInteger := Empresa;
      CDSDados.Post;
   end;
   Field := CDSDados.FindField('Usuario');
   if Assigned(Field) then begin
      CDSDados.Edit;
      Field.AsString := Usuario;
      CDSDados.Post;
   end;
end;


function AlteraRegistro(CDSDados :TEllClientDataSet):Boolean;
var Contador      :Integer;
    F             :TField;
    SqlDados      :TEllQuery;
begin
   Result := False;
   if CDSDados.IsEmpty                                            then exit;
   if CDSDados.EllTableName=''                                    then exit;
   if CDSDados.FieldByName(CDSDados.EllIdentificador).AsString='' then exit;

   try

      SqlDados := TEllQuery.Create;
      SqlDados.Start(tcUpdate, CDSDados.EllTableName, TSqlQuery(CDSDados.EllDataSet), ClausulaWhere(CDSDados));

      for Contador := 0 to CDSDados.FieldCount - 1 do begin
         F := CDSDados.Fields[Contador];
         if (F.Tag in [1, 10]) then SqlDados.AddValue(F.FieldName, F.AsString);
      end;
      SqlDados.Executa;

   finally
      SqlDados.Free;
      Result := True;
   end;
end;

function ExcluiRegistro(CDSDados :TEllClientDataSet):Boolean;
Var SqlDados      :TEllQuery;
begin
   Result := False;
   if CDSDados.IsEmpty                                            then exit;
   if CDSDados.EllTableName=''                                    then exit;
   if CDSDados.FieldByName(CDSDados.EllIdentificador).AsString='' then exit;

   with TSqlQuery(CDSDados.EllDataSet) do begin

      try

         SqlDados := TEllQuery.Create;
         SqlDados.Start(tcDelete, CDSDados.EllTableName, TSqlQuery(CDSDados.EllDataSet), ClausulaWhere(CDSDados));
         SqlDados.Executa;

         AjustaSequencial(CDSDados);

      finally
         SqlDados.Free;
         Result := True;
      end;

   end;
end;


procedure RepassaValoresCampos(Query:TSqlQuery; CDSDados:TEllClientDataSet);
var InField  : TField;
    OutField : TField;

    procedure RepassaCampos;
    var Contador :Integer;
    begin
       with Query do begin
          for Contador := 0 to FieldCount - 1 do begin
             OutField := Fields[Contador];
             InField  := CDSDados.FindField(OutField.FieldName);
             if Assigned(InField) then InField.Value := OutField.Value;
          end;
       end;
    end;

begin
   while not Query.eof do begin
      CDSDados.Append;
      RepassaCampos;
      CDSDados.Post;
      Query.Next;
   end;
end;




end.

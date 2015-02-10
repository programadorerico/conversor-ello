unit EllTypes;

interface
uses  Classes;

type
  TTipoBanco       = (tbInterbase);
  
  TTipoForma       = (tfIndefinido,
                      tfDinheiro,
                      tfCheque,
                      tfCartao,
                      tfCrediario,
                      tfCredito,
                      tfValeTrocoConcedido,
                      tfValeTrocoRecebido,
                      tfParcelasAbatidas,
                      tfChequeUtilizado,
                      tfConvenio);

  TTipoVenda        = (tvdaIndefinido,
                       tvVenda,
                       tvOrcamento,
                       tvCondicional,
                       tvEntregaFutura,
                       tvOrdemServico,
                       tvDevolucao,
                       tvTransferencia,
                       tvDevolucaoCompra,
                       tvRemessaGarantia,
                       tvRemessaConserto);
                      
                      
  TTipoValor       = (tvIndefinido,                     { 00 = 'C' }
                      tvDinheiro,                       { 01 = 'C' }
                      tvCrediario,                      { 02 = 'C' }
                      tvChequeVista,                    { 03 = 'C' }
                      tvChequePrazo,                    { 04 = 'C' }
                      tvCartaoDebito,                   { 05 = 'C' }
                      tvCartaoCredito,                  { 06 = 'C' }
                      tvMasterDebito,                   { 07 = 'C' }
                      tvMasterCredito,                  { 08 = 'C' }
                      tvTrocoDinheiro,                  { 09 = 'D' }
                      tvCreditoUtilizado,               { 10 = 'C' }
                      tvCreditoConcedido,               { 11 = 'D' }
                      tvValeTrocoConcedido,             { 12 = 'C' }
                      tvValeTrocoRecebido,              { 13 = 'D' }
                      tvParcelasAbatidas,               { 14 = 'D' }
                      tvChequeUtilizado,                { 15 = 'D' }
                      tvFarmaciaPopular);               { 16 = 'C' }

  TSngpcMotivoPerda= (Sngpc_mp00Desconhecido,
                      Sngpc_mp01FurtoRoubo,
                      Sngpc_mp02Avaria,
                      Sngpc_mp03Vencimento,
                      Sngpc_mp04Apreensao);

  TTipoAcesso      = (taAcessar,
                      taIncluir,
                      taEditar,
                      taConsultar,
                      taExcluir);

  TTipoEmpresa = (tePadrao,
                  tePrefeitura,
                  tePersonalizado,
                  tePosto,
                  teSupermercado,
                  teMercearia,
                  tePanificadora,
                  teRestaurante,
                  teFarmacia,
                  teOficina,
                  teHospital);

  TCRT         = (crtIndefinido,
                  crtSimplesNacional,
                  crtSimplesSubLimite,
                  crtNormal);

  TModulos     = (mdGeral,
                  mdContaFinanceira,
                  mdFichaFinanceira,
                  mdContasPagar,
                  mdContasReceber,
                  mdEstoque,
                  mdAtendimento,
                  mdUsuarios,
                  mdSistema,
                  mdSngpc,
                  mdManutencao);

  TTipoMensagem    = (tmConfirma, tmConfirmaN, tmInforma, tmErro, tmNada, tmPergunta, tmCancela, tmCancelaN, tmEsc, tmBloqueioCliente);
  TEstados         = (meInclui, meEdita, meConsulta, meExclui, meNone);
  TTipoPrograma    = (tpCadastro, tpRotina, tpPesquisaCadastro, tpRelatorio, tpPesquisa, tpPesquisaCadastroPersonal);
  TTipoBloqueio    = (tbVenda);
  TTipoAcao10      = (CompToClasse, ClasseToComp);
  TTipoCondicao    = (tcAVista, tcMensal, tcParcelado, tcPeriodico, tcSemanal);
  TFormaPagto      = (fpDinheiro, fpCrediario, fpCartao, fpCheque, fpConvenio);
  TTipoJuro        = (tjSimples, tjCompostoMensal, tjCompostoDiario);
  TTipoPessoa      = (tpJuridica, tpFisica);
  TTipoAcaoNFE     = (taConfigurandoAmbiente, taReservandoNumeroNFE, taVerificandoStatus, taGerando, taAssinando, taValidando, taGerandoLote, taTransmitindo, taConsultandoProtocolo, taImprimindo, taCancelando, taInutilizando, taAguardandoAcao);
  TStatusNota      = (snNone, snGerada, snAssinada, snValidada, snTransmitida, snProcessada, snImpressa, snCancelada, snInutilizada);

  TMultaJuros = class(TPersistent)
  private
    { Private declarations   }
    fJurosMultaDiferenciado: Boolean;
    fJuros: Double;
    fMulta: Double;
    fApartir: Integer;
    fTipo: TTipoJuro;
  protected
    { Protected declarations }
  public
    { Public declarations    }
    procedure Clear; virtual;
  published
    { Published declarations }
    property JurosMultaDiferenciado: Boolean read fJurosMultaDiferenciado write fJurosMultaDiferenciado;
    property Multa: Double read fMulta write fMulta;
    property Juros: Double read fJuros write fJuros;
    property Apartir: Integer read fApartir write fApartir; { Apartir de qual dia comeca a cobrar os juros }
    property Tipo: TTipoJuro read fTipo write fTipo;
  end;


  function RetStrTipoForma(fForma: TTipoForma):String;
  function RetStrTipoCondicao(fTipo: TTipoCondicao):String;

  const  TTipoEmpresaStr: Array[Low(TTipoEmpresa)..High(TTipoEmpresa)] of String = ('Padrao', 'Prefeitura', 'Personalizado', 'Posto', 'Supermercado', 'Mercearia', 'Panificadora', 'Restaurante', 'Farmacia', 'Oficina', 'Hospital');

  const  TTipoAcaoString: Array[Low(TTipoAcaoNFE)..High(TTipoAcaoNFE)] of String =
        ('Configurando Ambiente',
         'Reservando Numero NFE',
         'Verificando status do serviço',
         'Gerando arquivo XML',
         'Assinando',
         'Validando',
         'Gerando Lote XML para enviar',
         'Transmitindo lote para SEFAZ',
         'Consultando protocolo de recebimento. Aguarde....',
         'Imprimindo DANFE',
         'Cancelando NFE...',
         'Inutilizando NFE...',
         'Aguardando ação...');

  const  TModulosStrings: Array[Low(TModulos)..High(TModulos)] of String =
       ('Geral',
        'Contas financeiras',
        'Fichas financeiras',
        'Despesas/Contas a pagar',
        'Contas a receber',
        'Estoques',
        'Atendimento',
        'Usuários',
        'Sistema',
        'Sngpc',
        'Manutenção');
        
  const  TFormasString: Array[Low(TTipoForma)..High(TTipoForma)] of String =
        ('Indefinido',
         'Dinheiro',
         'Cheque',
         'Cartao',
         'Crediario',
         'Credito',
         'Vale Troco Concedido',
         'Vale Troco Recebido',
         'Parcelas Abatidas',
         'Cheque Utilizados',
         'Convenio');

implementation

function RetStrTipoForma(fForma: TTipoForma):String;
begin
   Result := '';
   Case fForma of
     tfDinheiro          : Result := 'Dinheiro';
     tfCheque            : Result := 'Cheque';
     tfCartao            : Result := 'Cartao';
     tfCrediario         : Result := 'Crediario';
     tfCredito           : Result := 'Credito';
     tfConvenio          : Result := 'Convenio';
     tfValeTrocoConcedido: Result := 'Vale troco concedido';
     tfValeTrocoRecebido : Result := 'Vale troco recebido';
   end;
end;

function RetStrTipoCondicao(fTipo: TTipoCondicao):String;
begin
   Result := '';
   Case fTipo of
     tcAVista            : Result := 'A Vista';
     tcMensal            : Result := 'Mensal';
     tcParcelado         : Result := 'Parcelado';
     tcPeriodico         : Result := 'Periódico';
     tcSemanal           : Result := 'Semanal';
   end;
end;


{ TMultaJuros }

procedure TMultaJuros.Clear;
begin
   fJurosMultaDiferenciado := False;
   fMulta                  := 0;
   fJuros                  := 0;
   fApartir                := 1;
   fTipo                   := tjCompostoMensal;
end;

end.


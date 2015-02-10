unit CVD802AA;

interface

uses
  SysUtils, Variants, Classes, Controls, Forms,
  PaiConversor, StdCtrls, ADODB, DB,
  SqlExpr, Contnrs, UnSql, 
  EllConnection, FMTBcd, Provider, ComCtrls, Buttons, ToolWin, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMemo, Grids, DBGrids, ExlDBGrid,
  PtlBox1, Graphics, ExtCtrls, EllBox;

type
  TImoAjustaRateioDocumento = class;

  TFCVD802AA = class(TFPaiConversor)
    ADOComissao: TADOQuery;
    ADOComissaoprCodi: TStringField;
    ADOComissaoCodCli: TStringField;
    ADOComissaoTicket: TStringField;
    ADOComissaoBaCodi: TStringField;
    ADOComissaoTot_Comis: TFloatField;
    Edit1: TEdit;
    Label2: TLabel;
    QAux: TSQLQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BImportarClick(Sender: TObject);
  private
    { Private declarations }
    fSincronismo: TImoAjustaRateioDocumento;
    procedure LimpaRegistros; override;
    procedure GravaRegistro; override;
    procedure Open; override;
  public
    { Public declarations }
  end;

  TImo_Rateio = Class(TPersistent)
  private
    { Private declarations   }
    fTTRateio: Double;
    fIdImovelVenda: Integer;
  public
  published
    { Published declarations }
    property IdImovelVenda: Integer read fIdImovelVenda write fIdImovelVenda;
    property TTRateio: Double read fTTRateio write fTTRateio;
  end;

  TImoAjustaRateioDocumento = class(TPersistent)
  private
    { Private declarations }
    fRateios: TObjectList;
    fQuery: TSqlQuery;
    fQueryAux: TSqlQuery;
    fQueryGrava: TSqlQuery;
    fSqlGrava: TQueryGrava;
    fEmpresa: Integer;
    function  AddRateio(pIdImovelVenda: Integer; pRateio: Double): TImo_Rateio;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(fConnection: TEllConnection; pEmpresa: Integer);
    destructor Destroy;
    procedure AjustaContrato(pIdCliente, pIdDocumento: Integer; pDocumento: String; pValorDocumento: Double);
    procedure AjustaDocumento(pIdDocumento: Integer);
    procedure AjustaRenegociacao(pIdRenegociacao: Integer);
  published
    { Published declarations }
    property Empresa: Integer read fEmpresa write fEmpresa;
    property Rateios:TObjectList read fRateios write fRateios;
  end;


var
  FCVD802AA: TFCVD802AA;

implementation
uses UDataModule, Utils;
var fDetalhe: TStringList;
    fIdDocumento: Integer;
    fIdParcela: Integer;
    fIdVenda: Integer;
    fIdBaixa: Integer;
    fIdRenegociacao: Integer;

{$R *.dfm}

procedure TFCVD802AA.LimpaRegistros;
begin
  inherited;
   with QueryTrabalho do begin
      Sql.Clear;
      Sql.Add('Delete from TRecBaixaParcela');
      ExecSql;

      Sql.Clear;
      Sql.Add('Delete from TRecBaixa');
      ExecSql;

      Sql.Clear;
      Sql.Add('Delete from TRecParcelaImovel');
      ExecSql;

      Sql.Clear;
      Sql.Add('Delete from TRecParcela');
      ExecSql;

      Sql.Clear;
      Sql.Add('Delete from TRecDocumento');
      ExecSql;

      Sql.Clear;
      Sql.Add('Delete from TRenegociacao');
      ExecSql;
   end;
end;

procedure TFCVD802AA.GravaRegistro;
var
    TTParcelas: Double;

    function RetornaTipoDocumento(pTipo: Integer): Integer;
    begin
       Result := 1;
       with CDSDados do begin
          if pTipo = 06 then Result := 6;
          if pTipo = 11 then Result := 2;
          if pTipo = 12 then Result := 3;
       end;
    end;

    procedure GravaVenda;
    begin
       with SqlDados, CDSDados do begin
          { Venda }
          Inc(fIdVenda);
          Start(tcInsert, 'TImoVenda', QueryTrabalho  );
             AddValue('Empresa',         FieldByName('Empresa').AsInteger);
             AddValue('IdVenda',         fIdVenda);
             AddValue('IdLote',          FieldByName('IdLote').AsString);
             AddValue('IdCondicao',      1);
             AddValue('IdComprador',     FieldByName('Cliente').AsString);
             AddValue('IdVendedor',      1);
             AddValue('IdPeriodo',       null);
             AddValue('IdRegistro',      null);
             AddValue('DataVenda',       FieldByName('DataEmissao').AsDateTime);
             AddValue('Data',            FieldByName('DataEmissao').AsDateTime);
             AddValue('Valor',           FieldByName('ValorImovel').AsFloat);
             AddValue('Desconto',        0);
             AddValue('Acrescimo',       0);
             AddValue('Entrada',         FieldByName('ValorEntrada').AsFloat);
             AddValue('ValorPago',       FieldByName('ValorImovel').AsFloat);
             AddValue('Indice',          0);
             AddValue('Parcelas',        FieldByName('QtdParcela').AsInteger);
             AddValue('VistaPrazo',      iif(FieldByName('ValorEntrada').AsFloat=FieldByName('ValorImovel').AsFloat,'V','P') );
             AddValue('Situacao',        'CONCLUIDO');
             AddValue('IdUsuario',       1);
             AddValue('Cod_Venda',       FieldByName('Documento').AsString);
             AddValue('Observacao',      null);
             AddValue('QtdeParcelas',    FieldByName('QtdParcela').AsInteger);
          Executa;
       end;
    end;

    procedure GravaComprador;
    begin
       with SqlDados, CDSDados do begin
          { Comprador(s) }
          Start(tcInsert, 'TImoVendaComprador', QueryTrabalho  );
             AddValue('Empresa',   FieldByName('Empresa').AsInteger);
             AddValue('IdVenda',   fIdVenda);
             AddValue('IdCliente', FieldByName('Cliente').AsString);
             AddValue('Cod_Venda', FieldByName('Documento').AsString);
          Executa;
       end;
    end;

    procedure GravaParcelasVenda;
    begin
       with QueryPesquisaECO, SqlDados do begin
          Sql.Clear;
          Sql.Add(Format('Select * From TRecParcela Where Empresa = ''%s'' AND Cliente = ''%s'' AND Documento = ''%s'' AND Tipo = ''01'' ',
                         [CDSDados.FieldByName('Empresa').AsString,
                          CDSDados.FieldByName('Cliente').AsString,
                          CDSDados.FieldByName('Documento').AsString]));
          Open;
          while (not eof) and (not Cancelar) do begin
             Start(tcInsert, 'TImoVendaParcela', QueryTrabalho  );
                AddValue('Empresa', FieldByName('Empresa').AsInteger);
                AddValue('IdVenda', fIdVenda);
                AddValue('Parcela', FieldByName('Parcela').AsInteger);
                AddValue('Vcto',    FieldByName('Vencimento').AsString);
                AddValue('Valor',   FieldByName('Valor').AsString);
             Executa;
             Next;
          end;
       end;
    end;

(*    procedure GravaParcelas(pDocumento, pTipo: String);
    begin
       with QueryPesquisaECO, SqlGrava do begin
          Sql.Clear;
          Sql.Add(Format('Select * From TRecParcela Where Empresa = ''%s'' AND Cliente = ''%s'' AND Documento = ''%s'' AND Tipo = ''%s'' ',
                         [CDSDados.FieldByName('Empresa').AsString,
                          CDSDados.FieldByName('Cliente').AsString,
                          pDocumento, pTipo]));
          Open;
          TTParcelas := 0;
          while (not eof) and (not Cancelar) do begin
             { Parcela }
             Inc(fIdParcela);
             Start(tcInsert, 'TRecParcela', QueryTrabalho  );
                AddValue('Empresa',                FieldByName('Empresa').AsInteger);
                AddValue('IdParcela',              fIdParcela);
                AddValue('IdDocumento',            fIdDocumento);
                AddValue('IdPortador',             FieldByName('Portador').AsInteger);
                AddValue('IdTipoDocumento',        RetornaTipoDocumento(StrToIntDef(pTipo, 0)) );
                AddValue('IdCliente',              FieldByName('Cliente').AsString);
                AddValue('Parcela',                FieldByName('Parcela').AsString);
                AddValue('Vencimento',             FieldByName('Vencimento').AsDateTime);
                AddValue('DataBaixa',              FieldByName('DataBaixa').AsDateTime);
                AddValue('NossoNumero',            FieldByName('NossoNumero').AsString);
                AddValue('Valor',                  FieldByName('Valor').AsFloat);
                AddValue('IdRenegociacaoTemp',     FieldByName('IdRenegociacao').AsInteger);

                AddValue('Programada',             FieldByName('Data_Programada').AsDateTime);
                if FieldByName('IdRenegociacao').IsNull then begin
                   AddValue('UltimoRecebimento',  FieldByName('UltimoRecebimento').AsDateTime);
                   AddValue('ValorPendente',          FieldByName('ValorPendente').AsFloat);
                   AddValue('ValorBaixado',           FieldByName('Valor').AsFloat - FieldByName('ValorPendente').AsFloat);
                   AddValue('BaixaPorImportacao',     FieldByName('Valor').AsFloat - FieldByName('ValorPendente').AsFloat);
                   AddValue('JurosAcumulado',         FieldByName('JurosAcumulado').AsFloat);
                end else begin
                   AddValue('UltimoRecebimento',      FieldByName('DataBaixa').AsDateTime);
                   AddValue('ValorPendente',          0);
                   AddValue('ValorBaixado',           FieldByName('Valor').AsFloat);
                   AddValue('BaixadoPorRenegociacao', FieldByName('Valor').AsFloat);
                   AddValue('JurosAcumulado',         FieldByName('JurosAcumulado').AsFloat);
                   AddValue('OrigemBaixa',            'RENEGOCIACAO');
                end;

             Executa;
             TTParcelas := TTParcelas + FieldByName('Valor').AsFloat;
             Next;
          end;
       end;
    end;*)

    procedure GravaParcelas(pDocumento, pTipo: String);
    begin
       with QueryPesquisaECO, SqlGrava do begin
          Sql.Clear;
          Sql.Add(Format('Select * From TRecParcela Where Empresa = ''%s'' AND Cliente = ''%s'' AND Documento = ''%s'' AND Tipo = ''%s'' ',
                         [CDSDados.FieldByName('Empresa').AsString,
                          CDSDados.FieldByName('Cliente').AsString,
                          pDocumento, pTipo]));
          Open;
          TTParcelas := 0;
          while (not eof) and (not Cancelar) do begin
             { Parcela }
             Inc(fIdParcela);
             Start(tcInsert, 'TRecParcela', QueryTrabalho  );
                AddValue('Empresa',                FieldByName('Empresa').AsInteger);
                AddValue('IdParcela',              fIdParcela);
                AddValue('IdDocumento',            fIdDocumento);
                AddValue('IdPortador',             FieldByName('Portador').AsInteger);
                AddValue('IdTipoDocumento',        RetornaTipoDocumento(StrToIntDef(pTipo, 0)) );
                AddValue('IdCliente',              FieldByName('Cliente').AsString);
                AddValue('Parcela',                FieldByName('Parcela').AsString);
                AddValue('Vencimento',             FieldByName('Vencimento').AsDateTime);
                AddValue('DataBaixa',              FieldByName('DataBaixa').AsDateTime);
                AddValue('NossoNumero',            FieldByName('NossoNumero').AsString);
                AddValue('Valor',                  FieldByName('Valor').AsFloat);
                //AddValue('IdRenegociacao',         iif(CDSDados.FieldByName('Origem').AsString='REN', fIdRenegociacao, NULL) );
                AddValue('IdRenegociacaoTemp',     FieldByName('IdRenegociacao').AsInteger);
                AddValue('UltimoRecebimento',      FieldByName('UltimoRecebimento').AsDateTime);
                AddValue('ValorPendente',          FieldByName('ValorPendente').AsFloat);
                AddValue('ValorBaixado',           FieldByName('Valor').AsFloat - FieldByName('ValorPendente').AsFloat);
                AddValue('BaixaPorImportacao',     FieldByName('Valor').AsFloat - FieldByName('ValorPendente').AsFloat);
                AddValue('JurosAcumulado',         FieldByName('JurosAcumulado').AsFloat);
                AddValue('Programada',             FieldByName('Data_Programada').AsDateTime);
             Executa;
             TTParcelas := TTParcelas + FieldByName('Valor').AsFloat;

             if (fIdVenda<>0) and (CDSDados.FieldByName('Origem').AsString='IMO') then begin
                Start(tcInsert, 'TRecParcelaImovel', QueryTrabalho  );
                   AddValue('Empresa',         FieldByName('Empresa').AsInteger);
                   AddValue('IdDocumento',     fIdDocumento);
                   AddValue('IdParcela',       fIdParcela);
                   AddValue('IdImovelVenda',   fIdVenda);
                   AddValue('Valor',           FieldByName('Valor').AsFloat);
                Executa;
             end;

             Next;
          end;
       end;
    end;

(*    procedure GravaDocumentoReceber;
    var fQuery: TSqlQuery;
    begin
       fQuery    := TSqlQuery.Create(self);
       try
          fQuery.NoMetaData    := False;
          fQuery.SQLConnection := QueryPesquisaECO.SQLConnection;
          with fQuery do begin
             Sql.Clear;
             Sql.Add(Format('Select * From TRecDocumento Where Empresa = ''%s'' AND Cliente = ''%s'' AND Documento = ''%s'' ',
                            [CDSDados.FieldByName('Empresa').AsString,
                             CDSDados.FieldByName('Cliente').AsString,
                             CDSDados.FieldByName('Documento').AsString]));
             Open;
             while not fQuery.eof do begin
                { Documento  }
                Inc(fIdDocumento);
                with SqlDados do begin
                   Start(tcInsert, 'TRecDocumento', QueryTrabalho  );
                      AddValue('Empresa',         FieldByName('Empresa').AsInteger);
                      AddValue('IdDocumento',     fIdDocumento);
                      AddValue('IdCliente',       FieldByName('Cliente').AsString);
                      AddValue('IdTipo',          RetornaTipoDocumento(StrToIntDef(FieldByName('Tipo').AsString, 0)));
                      AddValue('IdImovelVenda',   fIdVenda);
                      AddValue('Documento',       FieldByName('Documento').AsString);
                      AddValue('Complemento',     'Documento Referente as parcelas do Contrato ' + FieldByName('Documento').AsString);
                      AddValue('Emissao',         FieldByName('Emissao').AsDateTime);
                      AddValue('Valor',           TTParcelas);
                      AddValue('QtdeParcela',     FieldByName('QtdParcela').AsInteger);
                      AddValue('Origem',          'IMP');
                      AddValue('Valido',          'S');
                      AddValue('Usuario',         'IMPLANTACAO');
                   Executa;

                   GravaParcelas(FieldByName('Documento').AsString, FieldByName('Tipo').AsString);
                   
                   Start(tcUpdate, 'TRecDocumento', QueryTrabalho  );
                      AddWhere('Empresa',         FieldByName('Empresa').AsInteger);
                      AddWhere('IdDocumento',     fIdDocumento);
                      AddValue('Valor',           TTParcelas);
                   Executa;
                end;
                Next;

             end;
          end;
       finally
          FreeAndNil(fQuery)
       end;
    end;
*)    

    function GetIdVenda: Integer;
    begin
       with QAux do begin
          Sql.Clear;
          if CDSDados.FieldByName('Origem').AsString='REN' then begin
             Sql.Add(Format('Select IdVenda                                                                                        ' +
                            'From   TImoVenda V                                                                                    ' +
                            'Where  V.Empresa     = %d AND                                                                         ' +
                            '       V.IdComprador = %d AND                                                                         ' +
                            '       V.Cod_Venda   =  (Select First 1 D.Documento                                                   ' +
                            '                         From   TRecParcela P JOIN TRecDocumento D ON (D.Empresa     = P.Empresa      ' +
                            '                                                                   AND D.IdDocumento = P.IdDocumento) ' +
                            '                         Where  P.IdRenegociacaoTemp = %d)                                            ',
                            [CDSDados.FieldByName('Empresa').AsInteger,
                             CDSDados.FieldByName('Cliente').AsInteger,
                             CDSDados.FieldByName('IdDocumento').AsInteger]));
             Open;
          end else begin
             Sql.Add(Format('Select IdVenda              ' +
                            'From   TImoVenda            ' +
                            'Where  Empresa     = %d AND ' +
                            '       IdComprador = %d AND ' +
                            '       Cod_Venda   = ''%s'' ',
                            [CDSDados.FieldByName('Empresa').AsInteger,
                             CDSDados.FieldByName('Cliente').AsInteger,
                             CDSDados.FieldByName('Documento').AsString]));
             Open;
          end;
          Result := QAux.FieldByName('IdVenda').AsInteger;
       end;
    end;

    procedure GravaDocumentoReceber;
    begin
       { Documento  }
       Inc(fIdDocumento);
       with SqlDados do begin
          Start(tcInsert, 'TRecDocumento', QueryTrabalho  );
             AddValue('Empresa',         CDSDados.FieldByName('Empresa').AsInteger);
             AddValue('IdDocumento',     fIdDocumento);
             AddValue('IdCliente',       CDSDados.FieldByName('Cliente').AsString);
             AddValue('IdTipo',          RetornaTipoDocumento(StrToIntDef(CDSDados.FieldByName('Tipo').AsString, 0)));
             AddValue('IdImovelVenda',   fIdVenda);
             AddValue('Documento',       CDSDados.FieldByName('Documento').AsString);
             AddValue('Complemento',     CDSDados.FieldByName('Observacao').AsString);
             AddValue('Emissao',         CDSDados.FieldByName('Emissao').AsDateTime);
             AddValue('Valor',           TTParcelas);
             AddValue('QtdeParcela',     CDSDados.FieldByName('QtdParcela').AsInteger);
             AddValue('IdRenegociacao',  iif(CDSDados.FieldByName('Origem').AsString='REN', fIdRenegociacao, NULL) );
             AddValue('Origem',          iif(CDSDados.FieldByName('Origem').AsString='REN', 'REN', 'IMP') );
             AddValue('Valido',          'S');
             AddValue('Usuario',         'IMPORTACAO');
          Executa;

          GravaParcelas(CDSDados.FieldByName('Documento').AsString, CDSDados.FieldByName('Tipo').AsString);

          Start(tcUpdate, 'TRecDocumento', QueryTrabalho  );
             AddWhere('Empresa',         CDSDados.FieldByName('Empresa').AsInteger);
             AddWhere('IdDocumento',     fIdDocumento);
             AddValue('Valor',           TTParcelas);
          Executa;
       end;
       Next;
    end;

    procedure GravaRenegociacao;
    var TTBaixado: Double;

        procedure GravaRenegociacao;
        begin
           with SqlDados do begin
              Inc(fIdRenegociacao); 
              Start(tcInsert, 'TRenegociacao', QueryTrabalho  );
                 AddValue('Empresa',          CDSDados.FieldByName('Empresa').AsInteger);
                 AddValue('IdRenegociacao',   fIdRenegociacao);
                 AddValue('IdCliente',        CDSDados.FieldByName('Cliente').AsInteger);
                 AddValue('IdUsuario',        1);
                 AddValue('Data',             CDSDados.FieldByName('Emissao').AsDateTime);
                 AddValue('ValorBaixado',     0);
                 AddValue('ValorRenegociado', 0);
                 AddValue('ValorGerado',      CDSDados.FieldByName('Valor').AsFloat);
                 AddValue('Observacao',       CDSDados.FieldByName('Observacao').AsString);
                 AddValue('Origem',           'IMPORTACAO');
              Executa;
           end;
        end;

        procedure GravaBaixaParcela;
        begin
           with QueryPesquisa, SqlDados do begin
              Sql.Clear;
              Sql.Add(Format('Select * From TRecParcela Where Empresa = %d AND IdRenegociacaoTemp = %d ',
                             [CDSDados.FieldByName('Empresa').AsInteger,
                              CDSDados.FieldByName('IdDocumento').AsInteger]));
              Open;
              TTBaixado := 0;
              while (not eof) and (not Cancelar) do begin
                 { Ajusta a Parcela }
                 Start(tcUpdate, 'TRecParcela', QueryTrabalho  );
                    AddWhere('Empresa',                CDSDados.FieldByName('Empresa').AsInteger);
                    AddWhere('IdParcela',              FieldByName('IdParcela').AsInteger);
                    AddValue('IdRenegociacao',         fIdRenegociacao);
                    AddValue('BaixadoPorRenegociacao', FieldByName('ValorPendente').AsFloat);
                 Executa;


                 { Grava baixa da Parcela }
                 Start(tcInsert, 'TRecBaixaParcela', QueryTrabalho  );
                    AddValue('Empresa',                CDSDados.FieldByName('Empresa').AsInteger);
                    AddValue('IdBaixa',                fIdBaixa);
                    AddValue('IdParcela',              FieldByName('IdParcela').AsInteger);
                    AddValue('OrigemPendente',         FieldByName('ValorPendente').AsFloat);
                    AddValue('Data',                   CDSDados.FieldByName('Emissao').AsDateTime);
                    AddValue('ValorBaixado',           FieldByName('ValorPendente').AsFloat);
                    AddValue('ValorRecebido',          FieldByName('ValorPendente').AsFloat);
                    AddValue('IdRenegociacao',         fIdRenegociacao);
                 Executa;
                 TTBaixado := TTBaixado + FieldByName('ValorPendente').AsFloat;

                 Next;
              end;
           end;
        end;

        procedure GravaBaixa;
        begin
           Inc(fIdBaixa);
           with SqlDados do begin
              Start(tcInsert, 'TRecBaixa', QueryTrabalho  );
                 AddValue('Empresa',          CDSDados.FieldByName('Empresa').AsInteger);
                 AddValue('IdBaixa',          fIdBaixa);
                 AddValue('IdCliente',        CDSDados.FieldByName('Cliente').AsInteger);
                 AddValue('Data',             CDSDados.FieldByName('Emissao').AsDateTime);
                 AddValue('ValorBaixado',     0);
                 AddValue('ValorRecebido',    0);
                 AddValue('Usuario',          'IMPORTACAO');
                 AddValue('ORIGEM',           'RENEGOCIACAO');
                 AddValue('IdRenegociacao',   fIdRenegociacao);
              Executa;
           end;
        end;

        procedure Finaliza;
        begin
           with SqlDados do begin
              { Ajusta a renegociacao }
              Start(tcUpdate, 'TRenegociacao', QueryTrabalho  );
                 AddWhere('Empresa',          CDSDados.FieldByName('Empresa').AsInteger);
                 AddWhere('IdRenegociacao',   fIdRenegociacao);
                 AddValue('ValorBaixado',     TTBaixado);
                 AddValue('ValorRenegociado', TTBaixado);
              Executa;

              { Ajusta Baixa }
              Start(tcUpdate, 'TRecBaixa', QueryTrabalho  );
                 AddWhere('Empresa',          CDSDados.FieldByName('Empresa').AsInteger);
                 AddWhere('IdBaixa',          fIdBaixa);
                 AddValue('ValorBaixado',     TTBaixado);
                 AddValue('ValorRecebido',    TTBaixado);
              Executa;

              { Documento }
              {Start(tcUpdate, 'TRecDocumento', QueryTrabalho  );
                 AddWhere('Empresa',         CDSDados.FieldByName('Empresa').AsInteger);
                 AddWhere('IdDocumento',     fIdDocumento);
                 AddValue('IdRenegociacao',  fIdRenegociacao);
                 AddValue('Origem',          'REN');
              Executa;}

              { Parcelas }
              {Start(tcUpdate, 'TRecParcela', QueryTrabalho  );
                 AddWhere('Empresa',         CDSDados.FieldByName('Empresa').AsInteger);
                 AddWhere('IdDocumento',     fIdDocumento);
                 AddValue('IdRenegociacao',  fIdRenegociacao);
              Executa;}

           end;
        end;


    begin
       if CDSDados.FieldByName('Origem').AsString='REN' then begin

          {1} GravaRenegociacao;
          {2} GravaBaixa;
          {3} GravaBaixaParcela;
          {4} GravaDocumentoReceber;

          {5} Finaliza;

       end;
    end;

    procedure VinculaContratoAoLote;
    begin
       with SqlDados, CDSDados do begin
          Start(tcUpdate, 'TImoLote', QueryTrabalho  );
             AddWhere('IdLote',    FieldByName('IdLote').AsInteger);
             AddValue('IdVenda',   fIdVenda);
             AddValue('Cod_Vda',   FieldByName('Documento').AsString);
             AddValue('IdCliente', FieldByName('Cliente').AsString);
             AddValue('Situacao',  'VENDIDO');
          Executa;
       end;
    end;

    procedure GravaSincronizacao;
    begin
       if CDSDados.FieldByName('Origem').AsString='REN' then begin
          fSincronismo.AjustaRenegociacao(fIdRenegociacao);
       end else begin
          fSincronismo.AjustaContrato(CDSDados.FieldByName('Cliente').AsInteger,
                                      fIdDocumento,
                                      CDSDados.FieldByName('Documento').AsString,
                                      TTParcelas);
       end;   
    end;

begin
  inherited;
   with CDSDados do begin
      try
         fIdVenda := GetIdVenda;

         if CDSDados.FieldByName('Origem').AsString='REN' then begin
            {1} GravaRenegociacao;
         end else begin
            {1} GravaDocumentoReceber;
         end;

         {2} GravaSincronizacao;

      except on e:Exception do GravaLog('Documento: ' + CDSDados.FieldByName('Documento').AsString + ' Mensagem: '+E.Message);
      end;
   end;
end;

procedure TFCVD802AA.FormCreate(Sender: TObject);
begin
  inherited;
   fDetalhe := TStringList.Create;
   fSincronismo := TImoAjustaRateioDocumento.Create(Datam1.sConnection, 1);
end;

procedure TFCVD802AA.FormDestroy(Sender: TObject);
begin
   fDetalhe.Free;
   FreeAndNil(fSincronismo);
  inherited;
end;

procedure TFCVD802AA.Open;
begin
//    with QueryTECNOBYTE do begin
//        Filtro := iif(Edit1.Text<>'', Format(' AND Dct.Cliente = ''%s'' ', [StrZero(StrToIntDef(Edit1.Text,0), 5)]), '');
//        Sql.Clear;
//        Sql.Add(Format('SELECT *                           ' +
//                       'FROM   TRecDocumento Dct           ' +
//                       'WHERE  Dct.Empresa = ''01''       ' +
//                       '      %s                           ' +
//                       'ORDER BY                           ' +
//                       '       Dct.IdDocumento             ',
//                       [Filtro]));
//   end;
//   CDSOpen(CDSDados);
//   Label1.Caption        := 'Registros '+StrZero(CDSDados.RecordCount,6);
//   Label1.Visible        := True;
//   ProgressBar1.Max      := CDSDados.RecordCount;
//   ProgressBar1.Position := 0;
//   BImportar.Enabled     := (CDSDados.RecordCount>0);
end;

procedure TFCVD802AA.BImportarClick(Sender: TObject);
begin
   fIdDocumento    := 0; //NewIdentificador('TRecDocumento');
   fIdParcela      := 0; //NewIdentificador('TRecParcela');
   fIdBaixa        := 0; //NewIdentificador('TRecBaixa');
   fIdVenda        := 0; //NewIdentificador('TImoVenda');
   fIdRenegociacao := 0; //NewIdentificador('TRenegociacao');
  inherited;
end;

{ TImoAjustaRateioDocumento }

function TImoAjustaRateioDocumento.AddRateio(pIdImovelVenda: Integer; pRateio: Double): TImo_Rateio;
var contador: Integer;
begin
   Result := nil;
   for Contador := 0 to Self.Rateios.Count-1 do begin
      if TImo_Rateio(Self.Rateios.Items[Contador]).IdImovelVenda = pIdImovelVenda then begin
         Result := TImo_Rateio(Self.Rateios.Items[Contador]);
         Break;
      end;
   end;
   if Result = nil then begin
      Result               := TImo_Rateio.Create;
      Result.IdImovelVenda := pIdImovelVenda;
      Self.Rateios.Add(Result);
   end;
   Result.TTRateio := Result.TTRateio + pRateio;
end;

procedure TImoAjustaRateioDocumento.AjustaContrato(pIdCliente, pIdDocumento: Integer; pDocumento: String; pValorDocumento: Double);
begin
   with fSqlGrava, fQuery do begin
      Sql.Clear;
      Sql.Add(Format('SELECT IdVenda                 ' +
                     'FROM   TImoVenda V             ' +
                     'WHERE  Empresa     = %d AND    ' +
                     '       IdComprador = %d AND    ' +
                     '       Cod_Venda   = ''%s''    ',
                     [fEmpresa, pIdCliente, pDocumento]));
      Open;
      if not fQuery.IsEmpty then begin
         { Elimina sincronismos gravados }
         Start(tcDelete, 'TRecDocumentoImovel', fQueryGrava);
            AddWhere('Empresa',     fEmpresa);
            AddWhere('IdDocumento', pIdDocumento);
         Executa;

         Start(tcInsert,'TRecDocumentoImovel', fQueryGrava);
            AddValue('Empresa',        fEmpresa);
            AddValue('IdDocumento',    pIdDocumento);
            AddValue('IdImovelVenda',  fQuery.FieldByName('IdVenda').AsInteger);
            AddValue('IdCliente',      pIdCliente);
            AddValue('Rateio',         pValorDocumento);
         Executa;
      end;
   end;
end;

procedure TImoAjustaRateioDocumento.AjustaDocumento(pIdDocumento: Integer);
begin
   Self.Rateios.Clear;
   with fQuery do begin
      Sql.Clear;
      Sql.Add(Format('SELECT Distinct IdRenegociacao ' +
                     'FROM   TRecParcela P           ' +
                     'WHERE  Empresa     = %d AND    ' +
                     '       IdDocumento = %d        ',
                     [fEmpresa, pIdDocumento]));
      Open;
      while not eof do begin
         AjustaRenegociacao(FieldByName('IdRenegociacao').AsInteger);
         Next;
      end;
   end;
end;

procedure TImoAjustaRateioDocumento.AjustaRenegociacao(pIdRenegociacao: Integer);
var fValorRateio: Double;
    Contador: integer;
    ffIdDocumento: Integer;
    ffIdCliente: Integer;
    ffTTRenegociado: Double;
    ffValorDocumento: Double;
    fRateio: TImo_Rateio;
begin
   with fSqlGrava, fQueryAux do begin
      { Seleciona os dados da renegociacao }
      Sql.Clear;
      Sql.Add(Format('SELECT D.IdDocumento,                                                                ' +
                     '       D.IdCliente,                                                                  ' +
                     '       D.Valor As ValorDocumento,                                                    ' +
                     '       R.ValorBaixado,                                                               ' +
                     '       R.ValorGerado                                                                 ' +
                     'FROM   TRecDocumento D JOIN TRenegociacao R ON (R.Empresa        = D.Empresa         ' +
                     '                                            AND R.IdRenegociacao = D.IdRenegociacao) ' +
                     'WHERE  D.Empresa        = %d AND                                                     ' +
                     '       D.IdRenegociacao = %d                                                         ',
                     [fEmpresa, pIdRenegociacao]));
      Open;
      if not fQueryAux.IsEmpty then begin
         ffIdCliente      := FieldByName('IdCliente').AsInteger;
         ffIdDocumento    := FieldByName('IdDocumento').AsInteger;
         ffTTRenegociado  := FieldByName('ValorBaixado').AsFloat;
         ffValorDocumento := FieldByName('ValorDocumento').AsFloat;

         { Elimina sincronismos gravados }
         Start(tcDelete, 'TRecDocumentoImovel', fQueryAux);
            AddWhere('Empresa',     fEmpresa);
            AddWhere('IdDocumento', ffIdDocumento);
         Executa;

         { Seleciona parcelas renegociadas }
         Sql.Clear;
         Sql.Add(Format('SELECT D.Valor As ValorDocumento,                                                  ' +
                        '       I.IdImovelVenda,                                                            ' +
                        '       I.Rateio,                                                                   ' +
                        '       Sum(P.BaixadoPorRenegociacao) Renegociado                                   ' +
                        'FROM   TRecParcela P JOIN TRecDocumento       D ON (D.Empresa     = P.Empresa      ' +
                        '                                                AND D.IdDocumento = P.IdDocumento) ' +
                        '          LEFT OUTER JOIN TRecDocumentoImovel I ON (I.Empresa     = D.Empresa      ' +
                        '                                                AND I.IdDocumento = D.IdDocumento) ' +
                        'WHERE  P.Empresa        = %d AND                                                   ' +
                        '       P.IdRenegociacao = %d                                                       ' +
                        'group by D.Valor,                                                                  ' +
                        '         I.IdImovelVenda,                                                          ' +
                        '         I.Rateio                                                                  ',
                        [fEmpresa, pIdRenegociacao]));
         Open;
         while not eof do begin
            fValorRateio  := Divide(fQueryAux.FieldByName('Rateio').AsFloat, fQueryAux.FieldByName('ValorDocumento').AsFloat, 1) * fQueryAux.FieldByName('Renegociado').AsFloat;
            fValorRateio  := Divide(fValorRateio, ffTTRenegociado, 1) * ffValorDocumento;

            AddRateio(FieldByName('IdImovelVenda').AsInteger, fValorRateio);
            Next;
         end;

         { Gravacao }
         with fSqlGrava do begin

            { Elimina sincronismos gravados }
            Start(tcDelete, 'TRecDocumentoImovel', fQueryAux);
               AddWhere('Empresa',     fEmpresa);
               AddWhere('IdDocumento', ffIdDocumento);
            Executa;

            { Grava sincronismos }
            for contador := 0 to Self.Rateios.Count - 1 do begin
               fRateio := TImo_Rateio(Self.Rateios.Items[Contador]);

               Start(tcInsert,'TRecDocumentoImovel', fQueryAux);
                  AddValue('Empresa',        fEmpresa);
                  AddValue('IdDocumento',    ffIdDocumento);
                  AddValue('IdImovelVenda',  fRateio.IdImovelVenda);
                  AddValue('IdCliente',      ffIdCliente);
                  AddValue('Rateio',         fRateio.TTRateio);
                  AddValue('Origem',         'REN');
               Executa;
            end;
         end;

         AjustaDocumento(ffIdDocumento);

      end;

   end;
end;

constructor TImoAjustaRateioDocumento.Create(fConnection: TEllConnection; pEmpresa: Integer);
begin
   fRateios := TObjectList.Create;
   fEmpresa := pEmpresa;

   fSqlGrava                 := TQueryGrava.Create;   

   fQuery                    := TSqlQuery.Create(Nil);
   fQuery.NoMetadata         := True;
   fQuery.SQLConnection      := fConnection;

   fQueryGrava               := TSqlQuery.Create(Nil);
   fQueryGrava.NoMetadata    := True;
   fQueryGrava.SQLConnection := fConnection;

   fQueryAux                 := TSqlQuery.Create(Nil);
   fQueryAux.NoMetadata      := True;
   fQueryAux.SQLConnection   := fConnection;
end;

destructor TImoAjustaRateioDocumento.Destroy;
begin
   FreeAndNil(fRateios);
   FreeAndNil(fQuery);
   FreeAndNil(fQueryAux);
   FreeAndNil(fQueryGrava);

   FreeAndNil(fSqlGrava);
  inherited;
end;

initialization RegisterClass(TFCVD802AA);

end.



unit CVD801AA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PaiConversor, FMTBcd, StdCtrls, DBClient, Provider, ADODB, DB,
  SqlExpr, ComCtrls, Buttons, ToolWin, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMemo, Grids, DBGrids, ExlDBGrid, PtlBox1, ExtCtrls, EllBox, EllConnection;

type
  TFCVD801AA = class(TFPaiConversor)
    ADOComissao: TADOQuery;
    ADOComissaoprCodi: TStringField;
    ADOComissaoCodCli: TStringField;
    ADOComissaoTicket: TStringField;
    ADOComissaoBaCodi: TStringField;
    ADOComissaoTot_Comis: TFloatField;
    Edit1: TEdit;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BImportarClick(Sender: TObject);
  private
    { Private declarations }
    procedure LimpaRegistros; override;
    procedure GravaRegistro; override;
    procedure Open; override;
    procedure Inicia;
  public
    { Public declarations }
  end;

var
  FCVD801AA: TFCVD801AA;

implementation
uses UDataModule, GravaDados, UnSql, Utils;
var fDetalhe: TStringList;
    fIdDocumento: Integer;
    fIdParcela: Integer;
    fIdVenda: Integer;
    fIdBaixa: Integer;
    fIdRenegociacao: Integer;

{$R *.dfm}

procedure TFCVD801AA.LimpaRegistros;
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

      Sql.Clear;
      Sql.Add('Delete from TImoVendaComprador');
      ExecSql;

      Sql.Clear;
      Sql.Add('Delete from TImoVendaParcela');
      ExecSql;

      Sql.Clear;
      Sql.Add('Delete from TImoVenda');
      ExecSql;

   end;
end;

procedure TFCVD801AA.GravaRegistro;
var fParcela: Integer;
    fChave1: String;
    fChave2: String;
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
    var fAcrescimo: Double;
        fDesconto: Double;
        fDiferenca: Double;
    begin
       with SqlGrava, CDSDados do begin
          { Venda }
          Inc(fIdVenda);

          fDiferenca := CDSDados.FieldByName('ValorImovel').AsFloat - CDSDados.FieldByName('ValorLote').AsFloat;

          fAcrescimo := Abs(iif(fDiferenca>0, fDiferenca, 0));
          fDesconto  := Abs(iif(fDiferenca>0, 0, fDiferenca));

          Start(tcInsert, 'TImoVenda', QueryTrabalho  );
             AddValue('Empresa',         FieldByName('Empresa').AsInteger);
             AddValue('IdVenda',         fIdVenda);
             AddValue('IdLote',          FieldByName('IdLote').AsInteger);
             AddValue('IdCondicao',      1);
             AddValue('IdComprador',     CDSDados.FieldByName('Cliente').AsInteger);
             AddValue('IdVendedor',      1);
             AddValue('IdPeriodo',       null);
             AddValue('IdRegistro',      null);
             AddValue('DataVenda',       FieldByName('DataEmissao').AsDateTime);
             AddValue('Data',            FieldByName('DataEmissao').AsDateTime);
             AddValue('Valor',           FieldByName('ValorLote').AsFloat);
             AddValue('Desconto',        fDesconto);
             AddValue('Acrescimo',       fAcrescimo);
             AddValue('Entrada',         FieldByName('ValorEntrada').AsFloat);
             AddValue('ValorPago',       FieldByName('ValorImovel').AsFloat);
             AddValue('Indice',          0);
             AddValue('Parcelas',        FieldByName('QtdParcela').AsInteger);
             AddValue('VistaPrazo',      iif(FieldByName('ValorEntrada').AsFloat=FieldByName('ValorImovel').AsFloat,'V','P') );
             AddValue('Situacao',        'PENDENTE');
             AddValue('Origem',          'IMP');
             AddValue('IdUsuario',       1);
             AddValue('Cod_Venda',       FieldByName('Documento').AsString);
             AddValue('Observacao',      null);
             AddValue('QtdeParcelas',    FieldByName('QtdParcela').AsInteger);
          Executa;
       end;
    end;

    procedure GravaComprador;
    begin
       with SqlGrava, CDSDados do begin
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
       with QueryPesquisaECO, SqlGrava do begin
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
                AddValue('Vcto',    FieldByName('Vencimento').AsDateTime);
                AddValue('Valor',   FieldByName('Valor').AsFloat);
             Executa;
             Next;
          end;
       end;
    end;

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
                AddValue('IdRenegociacaoTemp',     FieldByName('IdRenegociacao').AsInteger);
                AddValue('UltimoRecebimento',      FieldByName('UltimoRecebimento').AsDateTime);
                AddValue('ValorPendente',          FieldByName('ValorPendente').AsFloat);
                AddValue('ValorBaixado',           FieldByName('Valor').AsFloat - FieldByName('ValorPendente').AsFloat);
                AddValue('BaixaPorImportacao',     FieldByName('Valor').AsFloat - FieldByName('ValorPendente').AsFloat);
                AddValue('JurosAcumulado',         FieldByName('JurosAcumulado').AsFloat);
                AddValue('Programada',             FieldByName('Data_Programada').AsDateTime);
             Executa;
             TTParcelas := TTParcelas + FieldByName('Valor').AsFloat;
             Next;
          end;
       end;
    end;

    procedure GravaDocumentoReceber;
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
                with SqlGrava do begin
                   Start(tcInsert, 'TRecDocumento', QueryTrabalho  );
                      AddValue('Empresa',         fQuery.FieldByName('Empresa').AsInteger);
                      AddValue('IdDocumento',     fIdDocumento);
                      AddValue('IdCliente',       fQuery.FieldByName('Cliente').AsString);
                      AddValue('IdTipo',          RetornaTipoDocumento(StrToIntDef(fQuery.FieldByName('Tipo').AsString, 0)));
                      AddValue('IdImovelVenda',   fIdVenda);
                      AddValue('Documento',       FieldByName('Documento').AsString);
                      AddValue('Complemento',     'Documento Referente as parcelas do Contrato ' + fQuery.FieldByName('Documento').AsString);
                      AddValue('Emissao',         fQuery.FieldByName('Emissao').AsDateTime);
                      AddValue('Valor',           0);
                      AddValue('QtdeParcela',     fQuery.FieldByName('QtdParcela').AsInteger);
                      AddValue('Origem',          'IMP');
                      AddValue('Valido',          'S');
                      AddValue('Usuario',         'IMPLANTACAO');
                   Executa;

                   GravaParcelas(fQuery.FieldByName('Documento').AsString, fQuery.FieldByName('Tipo').AsString);

                   Start(tcUpdate, 'TRecDocumento', QueryTrabalho  );
                      AddWhere('Empresa',         fQuery.FieldByName('Empresa').AsInteger);
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

    procedure GravaRenegociacoes(pDocumento: String='');
    var fQuery: TSqlQuery;
        fQueryAux: TSqlQuery;
        fQueryAux1: TSqlQuery;

        procedure GravaRenegociacao;
        begin
           with SqlGrava do begin
              Inc(fIdRenegociacao); 
              Start(tcInsert, 'TRenegociacao', QueryTrabalho  );
                 AddValue('Empresa',          CDSDados.FieldByName('Empresa').AsInteger);
                 AddValue('IdRenegociacao',   fIdRenegociacao);
                 AddValue('IdCliente',        CDSDados.FieldByName('Cliente').AsInteger);
                 AddValue('IdUsuario',        1);
                 AddValue('Data',             fQueryAux.FieldByName('Emissao').AsDateTime);
                 AddValue('ValorBaixado',     fQuery.FieldByName('ValorBaixado').AsFloat);
                 AddValue('ValorRenegociado', fQueryAux.FieldByName('Valor').AsFloat);
                 AddValue('ValorGerado',      fQueryAux.FieldByName('Valor').AsFloat);
                 AddValue('Observacao',       fQueryAux.FieldByName('Observacao').AsString);
              Executa;
           end;
        end;

         procedure GravaBaixaParcela;
         begin
            with QueryPesquisa, SqlGrava do begin
               Sql.Clear;
               Sql.Add(Format('Select * From TRecParcela Where Empresa = %d AND IdRenegociacaoTemp = %d ',
                              [CDSDados.FieldByName('Empresa').AsInteger,
                               fQuery.FieldByName('IdRenegociacao').AsInteger]));
               Open;
               while (not eof) and (not Cancelar) do begin
                  Start(tcInsert, 'TRecBaixaParcela', QueryTrabalho  );
                     AddValue('Empresa',                FieldByName('Empresa').AsInteger);
                     AddValue('IdBaixa',                fIdBaixa);
                     AddValue('IdParcela',              FieldByName('IdParcela').AsInteger);
                     AddValue('OrigemPendente',         FieldByName('ValorPendente').AsFloat);
                     AddValue('Data',                   fQueryAux.FieldByName('Emissao').AsDateTime);
                     AddValue('ValorBaixado',           FieldByName('ValorPendente').AsFloat);
                     AddValue('ValorRecebido',          FieldByName('ValorPendente').AsFloat);
                     AddValue('IdRenegociacao',         fIdRenegociacao);
                  Executa;
                  Next;
               end;
            end;
         end;

        procedure GravaBaixa;
        begin
           Inc(fIdBaixa);
           with SqlGrava do begin
              Start(tcInsert, 'TRecBaixa', QueryTrabalho  );
                 AddValue('Empresa',          CDSDados.FieldByName('Empresa').AsInteger);
                 AddValue('IdBaixa',          fIdBaixa);
                 AddValue('IdCliente',        CDSDados.FieldByName('Cliente').AsInteger);
                 AddValue('Data',             fQueryAux.FieldByName('Emissao').AsDateTime);
                 AddValue('ValorBaixado',     fQuery.FieldByName('ValorBaixado').AsFloat);
                 AddValue('ValorRecebido',    fQuery.FieldByName('ValorBaixado').AsFloat);
                 AddValue('Usuario',          'IMPORTACAO');
                 AddValue('ORIGEM',           'RENEGOCIACAO');
                 AddValue('IdRenegociacao',   fIdRenegociacao);
              Executa;

              GravaBaixaParcela;
           end;
        end;

        procedure GravaDocumento;
        begin
           { Documento  }
           Inc(fIdDocumento);
           with SqlGrava do begin
              Start(tcInsert, 'TRecDocumento', QueryTrabalho  );
                 AddValue('Empresa',         CDSDados.FieldByName('Empresa').AsInteger);
                 AddValue('IdDocumento',     fIdDocumento);
                 AddValue('IdCliente',       CDSDados.FieldByName('Cliente').AsString);
                 AddValue('IdTipo',          RetornaTipoDocumento(fQueryAux.FieldByName('Tipo').AsInteger));
                 AddValue('IdRenegociacao',  fIdRenegociacao);
                 AddValue('IdImovelVenda',   fIdVenda);
                 AddValue('Documento',       fQueryAux.FieldByName('Documento').AsString);
                 AddValue('Complemento',     fQueryAux.FieldByName('Observacao').AsString);
                 AddValue('Emissao',         fQueryAux.FieldByName('Emissao').AsDateTime);
                 AddValue('Valor',           fQueryAux.FieldByName('Valor').AsFloat);
                 AddValue('QtdeParcela',     fQueryAux.FieldByName('QtdParcela').AsInteger);
                 AddValue('Origem',          'REN');
                 AddValue('Valido',          'S');
                 AddValue('Usuario',         'RENEGOCIACAO');
              Executa;

              GravaParcelas(fQueryAux.FieldByName('Documento').AsString, fQueryAux.FieldByName('Tipo').AsString);
           end;
        end;

        procedure DefineComoGravado;
        begin
           with SqlGrava do begin
              Start(tcUpdate, 'TRecDocumento', fQueryAux1);
                 AddWhere('Empresa',   fQueryAux.FieldByName('Empresa').AsString);
                 AddWhere('Cliente',   fQueryAux.FieldByName('Cliente').AsString);
                 AddWhere('Documento', fQueryAux.FieldByName('Documento').AsString);
                 AddWhere('Tipo',      fQueryAux.FieldByName('Tipo').AsString);
                 AddValue('Gravado',   'S');
              Executa;
           end;
        end;

    begin
       if pDocumento='' then pDocumento := CDSDados.FieldByName('Documento').AsString;

       fQuery     := TSqlQuery.Create(self);
       fQueryAux  := TSqlQuery.Create(self);
       fQueryAux1 := TSqlQuery.Create(self);
       try
          fQuery.NoMetaData    := False;
          fQuery.SQLConnection := QueryPesquisaECO.SQLConnection;

          fQueryAux.NoMetaData    := False;
          fQueryAux.SQLConnection := QueryPesquisaECO.SQLConnection;

          fQueryAux1.NoMetaData    := False;
          fQueryAux1.SQLConnection := QueryPesquisaECO.SQLConnection;

          { Seleciona Renegociacoes que houveram nas parcelas do documento }
          with fQuery do begin
             Sql.Clear;
             Sql.Add(Format('SELECT Par.IdRenegociacao,                 ' +
                            '       SUM(Par.ValorPendente) ValorBaixado ' +
                            'FROM   TRecParcela Par                     ' +
                            'Where  Par.IdRenegociacao is not null AND  ' +
                            '       Par.Empresa   = ''%s''         AND  ' +
                            '       Par.Cliente   = ''%s''         AND  ' +
                            '       Par.Documento = ''%s''              ' +
                            'GROUP BY Par.IdRenegociacao                ',
                            [CDSDados.FieldByName('Empresa').AsString,
                             CDSDados.FieldByName('Cliente').AsString,
                             pDocumento]));
             Open;
          end;

          while (not fQuery.eof) and (not Cancelar) do begin
             { Seleciona os documentos gerados pelas renegociacoes }
             with fQueryAux do begin
                Sql.Clear;
                Sql.Add(Format('SELECT *                          ' +
                               'FROM   TRecDocumento Dct          ' +
                               'Where  Dct.Empresa   = ''%s'' AND ' +
                               '       Dct.Cliente   = ''%s'' AND ' +
                               '       Dct.Documento = ''%s''     ',
                               [CDSDados.FieldByName('Empresa').AsString,
                                CDSDados.FieldByName('Cliente').AsString,
                                'R'+StrZero(fQuery.FieldByName('IdRenegociacao').AsInteger, 6)]));
                Open;

                if not fQueryAux.IsEmpty then begin
                   {1} GravaRenegociacao;
                   {2} GravaDocumento;
                   {3} GravaBaixa;
                   {5} GravaRenegociacoes(fQueryAux.FieldByName('Documento').AsString);
                end;
             end;

             fQuery.Next;
          end;

       finally
          FreeAndNil(fQuery);
          FreeAndNil(fQueryAux);
          FreeAndNil(fQueryAux1);
       end;
    end;

    procedure VinculaContratoAoLote;
    begin
       with SqlDados, CDSDados do begin
          Start(tcUpdate, 'TImoLote', QueryTrabalho  );
             AddWhere('IdLote',        FieldByName('IdLote').AsInteger);
             AddValue('IdVenda',       fIdVenda);
             AddValue('Cod_Vda',       FieldByName('Documento').AsString);
             AddValue('IdClienteTemp', FieldByName('Cliente').AsString);
             AddValue('Situacao',      'VENDIDO');
          Executa;
       end;
    end;

begin
  inherited;
   with CDSDados do begin
      try
         {1} GravaVenda;
         {2} GravaComprador;
         {3} GravaParcelasVenda;
         {4} VinculaContratoAoLote;
//         {4} GravaDocumentoReceber;
//         {5} GravaRenegociacoes;

      except on e:Exception do GravaLog('Documento: ' + CDSDados.FieldByName('Documento').AsString + ' Mensagem: '+E.Message);
      end;
   end;
end;

procedure TFCVD801AA.FormCreate(Sender: TObject);
begin
  inherited;
   fDetalhe := TStringList.Create;
end;

procedure TFCVD801AA.FormDestroy(Sender: TObject);
begin
   fDetalhe.Free;
  inherited;
end;

procedure TFCVD801AA.Open;
var Filtro: String;
begin
//    with QueryTECNOBYTE do begin
//        Filtro := iif(Edit1.Text<>'', Format(' AND C.Cliente = ''%s'' ', [StrZero(StrToIntDef(Edit1.Text,0), 5)]), '');
//        Sql.Clear;
//        Sql.Add(Format('Select C.*,                                                  ' +
//                       '       L.VALOR AS VALORLOTE                                  ' +
//                       'From   TImoContrato C                                        ' +
//                       '       LEFT OUTER JOIN TIMOLOTES L ON (L.EMPRESA = C.empresa ' +
//                       '                                   AND L.IDLOTE  = C.IDLOTE) ' +
//                       'WHERE  C.Empresa = ''01'' AND                                ' +
//                       '       C.DataEmissao is not null                             ' +
//                       '      %s                                                     ' +
//                       'ORDER BY                                                     ' +
//                       '       C.Empresa,                                            ' +
//                       '       C.IdImoContrato                                       ',
//                       [Filtro]));
//   end;
//   CDSOpen(CDSDados);
//   Label1.Caption        := 'Registros '+StrZero(CDSDados.RecordCount,6);
//   Label1.Visible        := True;
//   ProgressBar1.Max      := CDSDados.RecordCount;
//   ProgressBar1.Position := 0;
//   BImportar.Enabled     := (CDSDados.RecordCount>0);
end;

procedure TFCVD801AA.BImportarClick(Sender: TObject);
begin
   fIdDocumento    := 0; //NewIdentificador('TRecDocumento');
   fIdParcela      := 0; //NewIdentificador('TRecParcela');
   fIdBaixa        := 0; //NewIdentificador('TRecBaixa');
   fIdVenda        := 0; //NewIdentificador('TImoVenda');
   fIdRenegociacao := 0; //NewIdentificador('TRenegociacao');
   Inicia;
  inherited;
end;

procedure TFCVD801AA.Inicia;
begin
   with SqlGrava do begin
      { Zera Posicao do Lote }
      Start(tcUpdate, 'TImoLote', QueryTrabalho  );
         AddValue('IdVenda',        null);
         AddValue('Cod_Vda',        null);
         AddValue('IdCliente',      null);
         AddValue('IdClienteTemp',  null);
         AddValue('Situacao',       'DISPONIVEL');
         AddValue('SituacaoVenda',  null);
         AddValue('Sincronizado',   'N');
      Executa;
   end;
end;

initialization RegisterClass(TFCVD801AA);

end.


UPDATE OR INSERT INTO TRECPORTADOR (IDPORTADOR, NOME, FORMATO, USUARIO) VALUES (1, 'CARTEIRA', 'CA', 'TRIBURTINI');
UPDATE OR INSERT INTO TRECPORTADOR (IDPORTADOR, NOME, FORMATO, USUARIO) VALUES (2, 'BANCO DO BRASIL', 'CA', 'TRIBURTINI');
UPDATE OR INSERT INTO TRECPORTADOR (IDPORTADOR, NOME, FORMATO, USUARIO) VALUES (3, 'CAIXA ECONOMICA', 'CA', 'TRIBURTINI');
UPDATE OR INSERT INTO TRECPORTADOR (IDPORTADOR, NOME, FORMATO, USUARIO) VALUES (4, 'BRADESCO 350024-1', 'CA', 'TRIBURTINI');
UPDATE OR INSERT INTO TRECPORTADOR (IDPORTADOR, NOME, FORMATO, USUARIO) VALUES (5, 'BRADESCO 26509-8', 'CA', 'TRIBURTINI');
UPDATE OR INSERT INTO TRECPORTADOR (IDPORTADOR, NOME, FORMATO, USUARIO) VALUES (6, 'SICREDI', 'CA', 'TRIBURTINI');

COMMIT WORK;






ALTER TRIGGER TRECBAIXA_ALL_AF INACTIVE;
ALTER TRIGGER TRECBAIXAPARCELA_ALL_AF INACTIVE;
ALTER TRIGGER TRECPARCELA_ALL INACTIVE;
ALTER TRIGGER TRECPARCELA_ALL_AF INACTIVE;
ALTER TRIGGER TRECPARCELA_ALL_BE INACTIVE;
COMMIT WORK;

update tctalancamento set PagDocumento = null;
update tPagDocumento set IdCtaLancamento = null;
update TPlcMovimento set IdCtaLancamento = null;

delete from tpagBaixaparcela;
delete from tpagBaixa;
delete from tpagparcela;

delete from tCtaLancamento;
delete from tColLancamento;

delete from TPlcMovimento;
delete from tpagDocumento;

delete from TRecBaixaparcela;
delete from TRecBaixa;

delete from TRecParcela;
delete from TRecDocumento;

delete from timoVendaParcela;
delete from timoVendaComprador;
delete from timoVenda;



ALTER TRIGGER TRECBAIXA_ALL_AF ACTIVE;
ALTER TRIGGER TRECBAIXAPARCELA_ALL_AF ACTIVE;
ALTER TRIGGER TRECPARCELA_ALL ACTIVE;
ALTER TRIGGER TRECPARCELA_ALL_AF ACTIVE;
ALTER TRIGGER TRECPARCELA_ALL_BE ACTIVE;




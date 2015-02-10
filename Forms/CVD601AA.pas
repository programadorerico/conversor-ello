unit CVD601AA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PaiConversor, FMTBcd, StdCtrls, DBClient, Provider, ADODB, DB,
  SqlExpr, ComCtrls, Buttons, ToolWin, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMemo, Grids, DBGrids, ExlDBGrid, PtlBox1, ExtCtrls, EllBox, EllConnection;

type
  TFCVD601AA = class(TFPaiConversor)
  private
    { Private declarations }
    procedure LimpaRegistros; override;
    procedure GravaRegistro; override;
  public
    { Public declarations }
  end;

var
  FCVD601AA: TFCVD601AA;

implementation
uses EllTypes, UnSql, GravaDados, UDataModule;
{$R *.dfm}

procedure TFCVD601AA.GravaRegistro;
var IdLote: Integer;
begin
  inherited;
   with SqlDados, CDSDados do begin
      if FieldByName('EstoqueAtual').AsInteger>0 then begin
         try
            { Lote }
            IdLote := NewIdentificador('TEstProdutoLote', 'IdLote', True);
            Start(tcInsert, 'TEstProdutoLote',  QueryTrabalho);
               AddValue('Empresa             ', 1);
               AddValue('IdLote              ', IdLote);
               AddValue('IdProdutoPrincipal  ', FieldByName('ProdutoPrincipal').AsInteger);
               AddValue('EstoqueInicial      ', 0);
               AddValue('Saldo               ', 0);
               AddValue('Lote                ', FieldByName('Lote').AsString);
               AddValue('Partida             ', FieldByName('Partida').AsString);
               AddValue('Fabricacao          ', FieldByName('Fabricacao').AsDateTime);
               AddValue('Vencimento          ', FieldByName('Vencimento').AsDateTime);
               AddValue('AnoMesVcto          ', FormatDateTime('yyyymm', FieldByName('Vencimento').AsDateTime));
            Executa;

            { Movimento }
            Start(tcInsert, 'TEstProdutoMovimentoLote',  QueryTrabalho);
               AddValue('Empresa             ', 1);
               AddValue('IdMovimentoLote     ', NewIdentificador('TEstProdutoMovimentoLote', 'IdMovimentoLote', True));
               AddValue('IdUsuario           ', 1);
               AddValue('IdLote              ', IdLote);
               AddValue('Qtde                ', FieldByName('EstoqueAtual').AsFloat);
               AddValue('Origem              ', 'MVT');
               AddValue('Status              ', 'V');
               AddValue('IdProduto           ', FieldByName('ProdutoPrincipal').AsInteger);
               AddValue('DataMovimento       ', Now);
               AddValue('Lote                ', FieldByName('Lote').AsString);
               AddValue('Tipo                ', 1);  {0=Movimento normal, 1=Movimento de importacao}
               AddValue('TipoMovimento       ', 1);  {Entradas}
            Executa;

            Start(tcUpdate, 'TEstProduto',  QueryTrabalho);
               AddWhere('IdProdutoPrincipal  ', FieldByName('ProdutoPrincipal').AsInteger);
               AddValue('ControlaLote        ', 'S');
            Executa;

         except on e:Exception do GravaLog('Lote: ' + FieldByName('Identificador').AsString + ' Mensagem: '+E.Message);
         end;
      end;
   end;
end;

procedure TFCVD601AA.LimpaRegistros;
begin
  inherited;
   with QueryTrabalho do begin
      Sql.Clear;
      Sql.Add('Delete From TEstProdutoMovimentoLote');
      ExecSql;

      Sql.Clear;
      Sql.Add('Delete From TEstProdutoLoteSaldoMensal');
      ExecSql;

      Sql.Clear;
      Sql.Add('Delete From TEstProdutoLote');
      ExecSql;
   end;
end;

initialization RegisterClass(TFCVD601AA);

end.




    procedure GravaLotes;
    var idLote: Integer;

        function LocalizaLotes(idProduto: Integer): Boolean;
        begin
           ADOTrabalho.SQL.Clear;
           ADOTrabalho.SQL.Add(format('select lot_codigo, lot_lote, lot_vcto, lot_qtde from estlot where lot_codigo = %d',[idProduto]));
           ADOTrabalho.Open;
           Result := ADOTrabalho.IsEmpty;
        end;

    begin
       if LocalizaLotes(ADO.FieldByName('cad_codigo').AsInteger) then exit;
       ADOTrabalho.First;
       while not ADOTrabalho.Eof do begin

           try
              with ADOTrabalho, SqlDados do begin
              end;

              with ADOTrabalho, SqlDados do begin
              end;
             except on e:Exception do GravaLog('Produto: ' + ADO.FieldByName('cad_codigo').AsString + ' Mensagem: '+E.Message);
           end;

           ADOTrabalho.Next;
       end;
       ADOTrabalho.Close;
    end;


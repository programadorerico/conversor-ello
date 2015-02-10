unit CVD800AA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PaiConversor, FMTBcd, StdCtrls, DBClient, Provider, ADODB, DB,
  SqlExpr, ComCtrls, Buttons, ToolWin, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMemo, Grids, DBGrids, ExlDBGrid, PtlBox1, ExtCtrls, EllBox, EllConnection;

type
  TFCVD800AA = class(TFPaiConversor)
    ADOComissao: TADOQuery;
    ADOComissaoprCodi: TStringField;
    ADOComissaoCodCli: TStringField;
    ADOComissaoTicket: TStringField;
    ADOComissaoBaCodi: TStringField;
    ADOComissaoTot_Comis: TFloatField;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BImportarClick(Sender: TObject);
  private
    { Private declarations }
    procedure LimpaRegistros; override;
    procedure GravaRegistro; override;
  public
    { Public declarations }
  end;

var
  FCVD800AA: TFCVD800AA;

implementation
uses UDataModule, GravaDados, UnSql, Utils;
var fDetalhe: TStringList;
    fIdDocumento: Integer;
    fIdQuadra: Integer;
    
{$R *.dfm}

procedure TFCVD800AA.LimpaRegistros;
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
      Sql.Add('Delete from TRecParcela');
      ExecSql;

      Sql.Clear;
      Sql.Add('Delete from TRecDocumento');
      ExecSql;

      Sql.Clear;
      Sql.Add('Delete from TImoVenda');
      ExecSql;

      Sql.Clear;
      Sql.Add('Delete from TImoLoteMarco');
      ExecSql;

      Sql.Clear;
      Sql.Add('Delete from TImoLote');
      ExecSql;

      Sql.Clear;
      Sql.Add('Delete from TImoQuadra');
      ExecSql;

      Sql.Clear;
      Sql.Add('Delete from TImoSetor');
      ExecSql;
   end;
end;

procedure TFCVD800AA.GravaRegistro;
var fIdDocumento: Integer;
    fParcela: Integer;
    fIdSetor: Integer;
    fChave1: String;
    fChave2: String;
    fArea: Double;
    fValorUnitario: Double;

    function RetornaTipoDocumento: Integer;
    begin
       Result := 1;
       with CDSDados do begin
          if FieldByName('Tipo').AsInteger = 11 then Result := 2;
          if FieldByName('Tipo').AsInteger = 12 then Result := 3;
       end;
    end;

begin
  inherited;
   with SqlDados, CDSDados do begin
      try
         CDSDados.First;
         fIdSetor := 0;
         fChave1  := '';
         while (not eof) and (not Cancelar) do begin
            { Setor }
            if fIdSetor<>FieldByName('IdResidencial').AsInteger then begin
               Start(tcInsert, 'TImoSetor', QueryTrabalho  );
                  AddValue('IdSetor',     FieldByName('IdResidencial').AsInteger);
                  AddValue('IdCidade',    1);
                  AddValue('Nome',        TiraAcentos(UpperCase(FieldByName('Nome').AsString)) );
                  AddValue('Abreviatura', Copy(TiraAcentos(UpperCase(FieldByName('Nome').AsString)),1,7) );
                  AddValue('Zona',        'URBANA');
               Executa;
               fIdSetor := FieldByName('IdResidencial').AsInteger;
            end;

            { Quadra }
            if fChave1<>(StrZero(FieldByName('IdResidencial').AsString, 3) + StrZero(FieldByName('Quadra').AsInteger, 3)) then begin
               Inc(fIdQuadra);
               Start(tcInsert, 'TImoQuadra', QueryTrabalho  );
                  AddValue('IdQuadra',    fIdQuadra);
                  AddValue('IdSetor',     FieldByName('IdResidencial').AsInteger);
                  AddValue('Nome',        FieldByName('Quadra').AsString);
               Executa;
               fChave1 := StrZero(FieldByName('IdResidencial').AsString, 3) + StrZero(FieldByName('Quadra').AsInteger, 3);
            end;

            { Lote }
            fArea          := FieldByName('Dimensao1').AsFloat * FieldByName('Dimensao2').AsFloat;
            fArea          := iif(fArea<=0, 1, fArea);
            fValorUnitario := Divide(FieldByName('Valor').AsFloat, fArea);
            Start(tcInsert, 'TImoLote', QueryTrabalho  );
               AddValue('IdLote',         FieldByName('IdLote').AsInteger);
               AddValue('IdQuadra',       fIdQuadra);
               AddValue('Nome',           FieldByName('NumeroLote').AsString);
               AddValue('TipoUso',        'RESIDENCIAL');
               AddValue('Area',           fArea);
               AddValue('ValorUnitario',  fValorUnitario);
               AddValue('Total',          FieldByName('Valor').AsString);
            Executa;
            Next;
         end;

      except on e:Exception do GravaLog('Id Lote: ' + CDSDados.FieldByName('IdLote').AsString + ' Mensagem: '+E.Message);
      end;
   end;
end;

procedure TFCVD800AA.FormCreate(Sender: TObject);
begin
  inherited;
   fDetalhe := TStringList.Create;
end;

procedure TFCVD800AA.FormDestroy(Sender: TObject);
begin
   fDetalhe.Free;
  inherited;
end;

procedure TFCVD800AA.BImportarClick(Sender: TObject);
begin
   fIdQuadra   := 0;
  inherited;
end;

initialization RegisterClass(TFCVD800AA);

end.


UPDATE OR INSERT INTO TRECPORTADOR (IDPORTADOR, NOME, FORMATO, USUARIO) VALUES (1, 'CARTEIRA', 'CA', 'TRIBURTINI');
UPDATE OR INSERT INTO TRECPORTADOR (IDPORTADOR, NOME, FORMATO, USUARIO) VALUES (2, 'BANCO DO BRASIL', 'CA', 'TRIBURTINI');
UPDATE OR INSERT INTO TRECPORTADOR (IDPORTADOR, NOME, FORMATO, USUARIO) VALUES (3, 'CAIXA ECONOMICA', 'CA', 'TRIBURTINI');
UPDATE OR INSERT INTO TRECPORTADOR (IDPORTADOR, NOME, FORMATO, USUARIO) VALUES (4, 'BRADESCO 350024-1', 'CA', 'TRIBURTINI');
UPDATE OR INSERT INTO TRECPORTADOR (IDPORTADOR, NOME, FORMATO, USUARIO) VALUES (5, 'BRADESCO 26509-8', 'CA', 'TRIBURTINI');
UPDATE OR INSERT INTO TRECPORTADOR (IDPORTADOR, NOME, FORMATO, USUARIO) VALUES (6, 'SICREDI', 'CA', 'TRIBURTINI');

COMMIT WORK;




ALTER TRIGGER TRECPARCELA_ALL INACTIVE;
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



ALTER TRIGGER TRECPARCELA_ALL ACTIVE;

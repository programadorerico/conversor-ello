unit CVD102AA;

interface

uses
  SysUtils, Variants, Classes, Controls, Forms,
  PaiConversor, StdCtrls, ADODB, DB,
  SqlExpr, FMTBcd, Provider, ComCtrls, Buttons, ToolWin, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMemo, Grids, DBGrids, ExlDBGrid,
  PtlBox1, Graphics, ExtCtrls, EllBox;

type
  TFCVD102AA = class(TFPaiConversor)
    ADOComissao: TADOQuery;
    ADOComissaoprCodi: TStringField;
    ADOComissaoCodCli: TStringField;
    ADOComissaoTicket: TStringField;
    ADOComissaoBaCodi: TStringField;
    ADOComissaoTot_Comis: TFloatField;
    Edit1: TEdit;
    Label2: TLabel;
    procedure BImportarClick(Sender: TObject);
  private
    { Private declarations }
    procedure LimpaRegistros; override;
    procedure GravaRegistro; override;
  end;

var
  FCVD102AA: TFCVD102AA;

implementation

uses UDataModule, UnSql, Utils;

var
   fIdDocumento: Integer;
   fIdParcela: Integer;
    
{$R *.dfm}

procedure TFCVD102AA.LimpaRegistros;
begin
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
   end;
   inherited;
end;

procedure TFCVD102AA.GravaRegistro;
var valor, valor_recebido: Currency;
begin
   inherited;
   with SqlDados, CDSDados do begin
      try
         Inc(fIdDocumento);
         Start(tcInsert, 'TRecDocumento', QueryTrabalho);
            AddValue('Empresa',     1);
            AddValue('IdDocumento', fIdDocumento);
            AddValue('IdCliente',   FieldByName('cliente_codigo').AsInteger);
            AddValue('IdTipo',      1);
            AddValue('Documento',   StrZero(FieldByName('numero_fatura').AsString, 7));
//            AddValue('Complemento', FieldByName('Observacao').AsString + '  Fatura: ' + FieldByName('FaturaNumero').AsString);
            AddValue('Emissao',     FieldByName('data_fatura').AsDateTime);
            AddValue('Valor',       FieldByName('Valor').AsFloat);
            AddValue('QtdeParcela', 1);
            AddValue('Origem',      'IMP');
            AddValue('Valido',      'S');
            AddValue('Usuario',     'IMPLANTACAO');
         Executa;

         valor := FieldByName('valor').AsCurrency;
         valor_recebido := FieldByName('valor_recebido').AsCurrency;

         Inc(fIdParcela);
         Start(tcInsert, 'TRecParcela', QueryTrabalho);
            AddValue('Empresa',            1);
            AddValue('IdParcela',          fIdParcela);
            AddValue('IdDocumento',        fIdDocumento);
            AddValue('IdPortador',         1);
            AddValue('IdTipoDocumento',    1);
            AddValue('IdCliente',          FieldByName('cliente_codigo').AsInteger);
            AddValue('Parcela',            1);
            AddValue('Vencimento',         FieldByName('data_recebimento').AsDateTime);
            AddValue('Valor',              FieldByName('Valor').AsFloat);
            AddValue('DataBaixa',          FieldByName('data_recebimento').Asdatetime);
            AddValue('ValorBaixado',       FieldByName('valor_recebido').AsFloat);
         Executa;

      except on e:Exception do GravaLog('Documento: ' + CDSDados.FieldByName('numero_fatura').AsString + ' Mensagem: '+E.Message);
      end;
   end;
end;

procedure TFCVD102AA.BImportarClick(Sender: TObject);
begin
   fIdDocumento := 0;
   fIdParcela   := 0;
   inherited;
end;

initialization RegisterClass(TFCVD102AA);

end.



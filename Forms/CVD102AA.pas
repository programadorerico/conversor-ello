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
    fIdDocumento: Integer;
    fIdParcela: Integer;
    procedure LimpaRegistros; override;
    procedure GravaRegistro; override;
  end;

var
  FCVD102AA: TFCVD102AA;

implementation

uses UDataModule, UnSql, Utils;

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
   FIdDocumento := CDSDados.FieldByName('CodContaReceber').AsInteger;
   valor := CDSDados.FieldByName('valor').AsCurrency;
   valor_recebido := CDSDados.FieldByName('ValorRecebido').AsCurrency;
   with SqlDados do begin
      try
         Start(tcInsert, 'TRecDocumento', QueryTrabalho);
            AddValue('Empresa',     1);
            AddValue('IdDocumento', FIdDocumento);
            AddValue('IdCliente',   CDSDados.FieldByName('CodCliente').AsInteger);
            AddValue('IdTipo',      1);
            AddValue('Documento',   StrZero(CDSDados.FieldByName('numeroTitulo').AsString, 7));
//            AddValue('Complemento', FieldByName('Observacao').AsString + '  Fatura: ' + FieldByName('FaturaNumero').AsString);
            AddValue('Emissao',     CDSDados.FieldByName('DataEmissao').AsDateTime);
            AddValue('Valor',       valor);
            AddValue('QtdeParcela', 1);
            AddValue('Origem',      'IMP');
            AddValue('Valido',      'S');
            AddValue('Usuario',     'IMPLANTACAO');
         Executa;

         Inc(fIdParcela);
         Start(tcInsert, 'TRecParcela', QueryTrabalho);
            AddValue('Empresa',            1);
            AddValue('IdParcela',          fIdParcela);
            AddValue('IdDocumento',        fIdDocumento);
            AddValue('IdPortador',         1);
            AddValue('IdTipoDocumento',    1);
            AddValue('IdCliente',          CDSDados.FieldByName('CodCliente').AsInteger);
            AddValue('Parcela',            1);
            AddValue('Vencimento',         CDSDados.FieldByName('DataRecebimento').AsDateTime);
            AddValue('Valor',              valor);
            AddValue('DataBaixa',          CDSDados.FieldByName('DataRecebimento').Asdatetime);
            AddValue('ValorBaixado',       valor_recebido);
         Executa;

      except
         on e:Exception do
            GravaLog('Documento: ' + CDSDados.FieldByName('NumeroTitulo').AsString + ' Mensagem: '+E.Message);
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



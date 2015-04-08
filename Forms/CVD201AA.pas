unit CVD201AA;

interface

uses
  SysUtils, Variants, Classes, Controls, Forms, PaiConversor, ADODB, DB, SqlExpr, FMTBcd, Provider,
  ComCtrls, Buttons, ToolWin, StdCtrls, cxControls, cxContainer, cxEdit, cxTextEdit, cxMemo, Grids,
  DBGrids, ExlDBGrid, PtlBox1, Graphics, ExtCtrls, EllBox, DBClient, UContasPagar;

type
  TFCVD201AA = class(TFPaiConversor)
    procedure FormCreate(Sender: TObject);
  private
    fIdDocumento: Integer;
    fIdParcela: Integer;
    procedure LimpaRegistros; override;
    procedure GravaRegistro; override;
    procedure GravaContaPagar(Conta: TContaConvertida);
  end;

var
  FCVD201AA: TFCVD201AA;

implementation

uses UDataModule, UnSql, Utils;

{$R *.dfm}

procedure TFCVD201AA.FormCreate(Sender: TObject);
begin
   inherited;
   ADOQueryOrigem.SQL.Text := UContasPagar.QUERY;
end;

procedure TFCVD201AA.GravaRegistro;
var
   Conta: TContaConvertida;
begin
   inherited;

   Conta := TContaConvertida.Create(QueryPesquisa);
   Conta.CarregaDoDataset(CDSDadosOrigem);

   try
      GravaContaPagar(Conta);
   except
      on e:Exception do
         GravaLog('Documento: ' + IntToStr(Conta.IdDocumento) + ' Mensagem: ' + E.Message);
   end;

   Conta.Free;
end;

procedure TFCVD201AA.GravaContaPagar(Conta: TContaConvertida);
begin
   with SqlDados do begin
      Start(tcInsert, 'TPagDocumento');
         AddValue('Empresa',      Conta.IdEmpresa);
         AddValue('IdDocumento',  Conta.IdDocumento);
         AddValue('IdFornecedor', Conta.IdFornecedor);
         AddValue('IdTipo',       Conta.IdTipo);
         AddValue('Documento',    Conta.Documento);
         AddValue('Complemento',  Conta.Complemento);
         AddValue('Emissao',      Conta.Emissao);
         AddValue('Valor',        Conta.Valor);
         AddValue('Pago',         Conta.Pago);
         AddValue('APagar',       Conta.APagar);
         AddValue('QtdeParcela',  Conta.QtdeParcela);
         AddValue('Origem',       Conta.Origem);
         AddValue('Usuario',      Conta.Usuario);
      Executa;

      Start(tcInsert, 'TPagParcela');
         AddValue('Empresa',          Conta.IdEmpresa);
         AddValue('IdParcela',        Conta.IdDocumento);
         AddValue('IdDocumento',      Conta.IdDocumento);
         AddValue('Parcela',          1);
         AddValue('Vencimento',       Conta.Vencimento);
         AddValue('Valor',            Conta.Valor);
         AddValue('ValorPendente',    Conta.APagar);
         AddValue('ValorBaixado',     Conta.Pago);
      Executa;
   end;
end;

procedure TFCVD201AA.LimpaRegistros;
begin
   inherited;
   UContasPagar.LimpaRegistros(QueryPesquisa);
end;

initialization RegisterClass(TFCVD201AA);

end.

unit CVD102AA;

interface

uses
  SysUtils, Variants, Classes, Controls, Forms, PaiConversor, StdCtrls, ADODB, DB,
  SqlExpr, FMTBcd, Provider, ComCtrls, Buttons, ToolWin, cxControls, cxContainer,
  cxEdit, cxTextEdit, cxMemo, Grids, DBGrids, ExlDBGrid, PtlBox1, Graphics,
  ExtCtrls, EllBox, DBClient, UContasReceber;

type
  TFCVD102AA = class(TFPaiConversor)
    Edit1: TEdit;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    procedure LimpaRegistros; override;
    procedure GravaRegistro; override;
    procedure GravaContaReceber(Conta: TContaConvertida);
  end;

var
  FCVD102AA: TFCVD102AA;

implementation

uses UDataModule, UnSql, Utils;

{$R *.dfm}

procedure TFCVD102AA.FormCreate(Sender: TObject);
begin
   inherited;
   ADOQueryOrigem.SQL.Text := UContasReceber.QUERY;
end;

procedure TFCVD102AA.GravaRegistro;
var
   Conta: TContaConvertida;
begin
   inherited;
   Conta := TContaConvertida.Create(QueryPesquisa);
   Conta.CarregaDoDataset(CDSDadosOrigem);

   try
      GravaContaReceber(Conta);
   except
      on e:Exception do
         GravaLog('Documento: ' + CDSDadosOrigem.FieldByName('NumeroTitulo').AsString + ' Mensagem: '+E.Message);
   end;
end;

procedure TFCVD102AA.LimpaRegistros;
begin
   inherited;
   UContasReceber.LimpaRegistros(QueryPesquisa);
end;

procedure TFCVD102AA.GravaContaReceber(Conta: TContaConvertida);
begin
   with SqlDados do begin
      if Conta.NumeroParcela=1 then begin
         Start(tcInsert, 'TRecDocumento');
            AddValue('Empresa',     Conta.IdEmpresa);
            AddValue('IdDocumento', Conta.IdDocumento);
            AddValue('IdCliente',   Conta.IdCliente);
            AddValue('IdTipo',      Conta.IdTipo);
            AddValue('Documento',   Conta.Documento);
            AddValue('Complemento', Conta.Complemento);
            AddValue('Emissao',     Conta.Emissao);
            AddValue('Valor',       Conta.Valor);
            AddValue('QtdeParcela', Conta.QtdeParcela);
            AddValue('Origem',      Conta.Origem);
            AddValue('Valido',      Conta.Valido);
            AddValue('Usuario',     Conta.Usuario);
         Executa;
      end;

      Start(tcInsert, 'TRecParcela');
         AddValue('Empresa',            Conta.IdEmpresa);
         AddValue('IdParcela',          Conta.IdDocumento);
         AddValue('IdDocumento',        Conta.IdPrimeiraParcela);
         AddValue('IdPortador',         Conta.IdPortador);
         AddValue('IdTipoDocumento',    Conta.IdTipoDocumento);
         AddValue('IdCliente',          Conta.IdCliente);
         AddValue('Parcela',            Conta.NumeroParcela);
         AddValue('Vencimento',         Conta.Vencimento);
         AddValue('Valor',              Conta.Valor);

         if Conta.Recebida then begin
            AddValue('DataBaixa',       Conta.DataBaixa);
            AddValue('ValorBaixado',    Conta.Valor);
         end;
      Executa;

      Start(tcUpdate, 'TRecDocumento');
         AddWhere('Empresa',     Conta.IdEmpresa);
         AddWhere('Documento',   Conta.Documento);
         AddValue('QtdeParcela', Conta.NumeroParcela);
      Executa;
   end;
end;

initialization RegisterClass(TFCVD102AA);

end.



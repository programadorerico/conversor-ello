unit UContasPagar;

interface

uses DB, SqlExpr, Interfaces;

const
  QUERY = 'SELECT * FROM ContasPagar';

type
  TContaConvertida = class(TInterfacedObject, IRegistroConvertido)
  private
    FDataSet: TDataSet;
    FQuery: TSqlQuery;
    FAPagar: Currency;
    FValor: Currency;
    FPago: Integer;
    FIdEmpresa: Integer;
    FIdDocumento: Integer;
    FIdTipo: Integer;
    FIdFornecedor: Integer;
    FQtdeParcela: Integer;
    FUsuario: String;
    FOrigem: String;
    FDocumento: String;
    FComplemento: String;
    FEmissao: TDateTime;
    FVencimento: TDateTime;
  public
    constructor Create(Query: TSqlQuery);
    procedure CarregaDoDataset(DataSet: TDataSet);
 published
    property IdEmpresa: Integer read FIdEmpresa;
    property IdDocumento: Integer read FIdDocumento;
    property IdFornecedor: Integer read FIdFornecedor;
    property IdTipo: Integer read FIdTipo;
    property Documento: String read FDocumento;
    property Complemento: String read FComplemento;
    property Emissao: TDateTime read FEmissao;
    property Vencimento: TDateTime read FVencimento;
    property Valor: Currency read FValor;
    property Pago: Integer read FPago;
    property APagar: Currency read FAPagar;
    property QtdeParcela: Integer read FQtdeParcela;
    property Origem: String read FOrigem;
    property Usuario: String read FUsuario;
  end;

  procedure LimpaRegistros(Query: TSqlQuery);

implementation

uses SysUtils, Utils;

{ TContaConvertida }

constructor TContaConvertida.Create(Query: TSqlQuery);
begin
   FQuery := Query;
end;

procedure TContaConvertida.CarregaDoDataset(DataSet: TDataSet);
begin
   FDataSet := DataSet;

   FIdEmpresa   := 1;
   FOrigem      := 'IMP';
   FUsuario     := 'IMPLANTACAO';
   FIdTipo      := 1;
   FQtdeParcela := 1;

   FIdDocumento  := FDataSet.FieldByName('COD').AsInteger;
   FIdFornecedor := FDataSet.FieldByName('FORNECEDOR').AsInteger;
   FDocumento    := FDataSet.FieldByName('NUMERODOCUMENTO').AsString;
   FComplemento  := UpperCase(TiraAcentos(FDataSet.FieldByName('OBS').AsString));
   FEmissao      := FDataSet.FieldByName('EMISSAO').AsDateTime;
   FValor        := FDataSet.FieldByName('VALOR').AsCurrency;
   FPago         := iif(FDataSet.FieldByName('VALORPAG').AsCurrency>0, 1, 0);
   FAPagar       := FValor - FPago;
   FVencimento   := FDataSet.FieldByName('VENCIMENTO').AsDateTime;
end;

procedure LimpaRegistros(Query: TSqlQuery);
begin
   with Query do begin
      Sql.Clear;
      Sql.Add('Delete from TPagBaixaParcela');
      ExecSql;

      Sql.Clear;
      Sql.Add('Delete from TPagBaixa');
      ExecSql;

      Sql.Clear;
      Sql.Add('Delete from TPagParcela');
      ExecSql;

      Sql.Clear;
      Sql.Add('Delete from TPagDocumento');
      ExecSql;
   end;
end;

end.

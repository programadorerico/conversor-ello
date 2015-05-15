unit UContasReceber;

interface

uses DB, SqlExpr, Interfaces;

const
  QUERY = 'SELECT * FROM ContasReceber WHERE Cliente>0 AND Emissao>''2013-01-01''';
  //QUERY = 'SELECT * FROM ContasReceber WHERE Cliente IN (217, 291) AND Emissao>''2013-01-01''';

type
  TContaConvertida = class(TInterfacedObject, IRegistroConvertido)
  private
    FDataSet: TDataSet;
    FQuery: TSqlQuery;
    FValor: Currency;
    FQtdeParcela: Integer;
    FIdDocumento: Integer;
    FIdCliente: Integer;
    FIdEmpresa: Integer;
    FIdTipo: Integer;
    FValido: String;
    FOrigem: String;
    FUsuario: String;
    FComplemento: String;
    FDocumento: String;
    FEmissao: TDateTime;
    FIdPortador: Integer;
    FIdTipoDocumento: Integer;
    FVencimento: TDateTime;
    FValorBaixado: Currency;
    FDataBaixa: TDateTime;
    function GetRecebida: Boolean;
    function GetNumeroParcela: Integer;
    function GetIdPrimeiraParcela: Integer;
  public
    constructor Create(Query: TSqlQuery);
    procedure CarregaDoDataset(DataSet: TDataSet);
  published
    property IdEmpresa: Integer read FIdEmpresa;
    property IdDocumento: Integer read FIdDocumento;
    property IdCliente: Integer read FIdCliente;
    property IdTipo: Integer read FIdTipo;
    property Documento: String read FDocumento;
    property Complemento: String read FComplemento;
    property Emissao: TDateTime read FEmissao;
    property Valor: Currency read FValor;
    property QtdeParcela: Integer read FQtdeParcela;
    property Origem: String read FOrigem;
    property Valido: String read FValido;
    property Usuario: String read FUsuario;

    property IdPortador: Integer read FIdPortador;
    property IdTipoDocumento: Integer read FIdTipoDocumento;
    property Vencimento: TDateTime read FVencimento;

    property Recebida: Boolean read GetRecebida;
    property DataBaixa: TDateTime read FDataBaixa;
    property ValorBaixado: Currency read FValorBaixado;

    property NumeroParcela: Integer read GetNumeroParcela;
    property IdPrimeiraParcela: Integer read GetIdPrimeiraParcela;
  end;

  procedure LimpaRegistros(Query: TSqlQuery);

implementation

uses Math, SysUtils;

{ TContaConvertida }

constructor TContaConvertida.Create(Query: TSqlQuery);
begin
   FQuery := Query;
end;

procedure TContaConvertida.CarregaDoDataset(DataSet: TDataSet);
begin
   FDataSet := DataSet;

   FIdEmpresa   := 1;
   FQtdeParcela := 1;
   FOrigem      := 'IMP';
   FValido      := 'S';
   FUsuario     := 'IMPLANTACAO';
   FIdTipo      := 1;
   FIdDocumento := FDataSet.FieldByName('COD').AsInteger;
   FIdCliente   := FDataSet.FieldByName('CLIENTE').AsInteger;
   FDocumento   := FDataSet.FieldByName('VENDA').AsString;
   FComplemento := FDataSet.FieldByName('OBS').AsString;
   FEmissao     := FDataSet.FieldByName('EMISSAO').AsDateTime;
   FValor       := FDataSet.FieldByName('VALOR').AsCurrency;

   FIdPortador      := 1;
   FIdTipoDocumento := 1;
   FVencimento      := FDataSet.FieldByName('VENCIMENTO').AsDateTime;
   FDataBaixa       := FDataSet.FieldByName('DATAPAG').AsDateTime;
   FValorBaixado    := FDataSet.FieldByName('VALORPAG').AsCurrency;
end;

procedure LimpaRegistros(Query: TSqlQuery);
begin
   with Query do begin
      SQL.Text := 'DELETE FROM TRECDEBITOCLIENTE';
      ExecSql;

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
end;

function TContaConvertida.GetRecebida: Boolean;
begin
   Result := FDataSet.FieldByName('SITUACAO').AsString='B';
end;

function TContaConvertida.GetNumeroParcela: Integer;
begin
   Result := FDataSet.FieldByName('PARCELANUM').AsInteger;
   Result := Max(Result, 1);
end;

function TContaConvertida.GetIdPrimeiraParcela: Integer;
begin
   FQuery.SQL.Text := Format('SELECT FIRST 1 IdDocumento FROM TRecDocumento WHERE DOCUMENTO=''%s'' ORDER BY 1', [FDocumento]);
   FQuery.Open;

   Result := FQuery.FieldByName('IDDOCUMENTO').AsInteger;
end;

end.

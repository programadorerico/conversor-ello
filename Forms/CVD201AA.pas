unit CVD201AA;

interface

uses
  SysUtils, Variants, Classes, Controls, Forms,
  PaiConversor, ADODB, DB,
  SqlExpr, FMTBcd, Provider, ComCtrls, Buttons, ToolWin, StdCtrls,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMemo, Grids, DBGrids,
  ExlDBGrid, PtlBox1, Graphics, ExtCtrls, EllBox;

type
  TFCVD201AA = class(TFPaiConversor)
    procedure BImportarClick(Sender: TObject);
  private
    { Private declarations }
    fIdDocumento: Integer;
    fIdParcela: Integer;
    procedure LimpaRegistros; override;
    procedure GravaRegistro; override;
  public
    { Public declarations }
  end;

var
  FCVD201AA: TFCVD201AA;

implementation

uses UDataModule, UnSql, Utils;

{$R *.dfm}

procedure TFCVD201AA.LimpaRegistros;
begin
   with QueryTrabalho do begin
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
   inherited;
end;

procedure TFCVD201AA.GravaRegistro;
begin
   inherited;
   with SqlDados, CDSDados do begin
      try
         Inc(fIdDocumento);
         Start(tcInsert, 'TPagDocumento', QueryTrabalho);
            AddValue('Empresa',      1);
            AddValue('IdDocumento',  fIdDocumento);
            AddValue('IdFornecedor', CDSDados.FieldByName('fornecedor_codigo').AsInteger);
            AddValue('IdTipo',       1);
            AddValue('Documento',    FieldByName('numero_documento').AsString);
            AddValue('Complemento',  UpperCase(TiraAcentos(FieldByName('obs').AsString)));
            AddValue('Emissao',      FieldByName('data_emissao').AsDateTime);
            AddValue('Valor',        FieldByName('valor_parcela').AsFloat);
            AddValue('Pago',         0);
            AddValue('APagar',       FieldByName('valor_parcela').AsFloat);
            AddValue('QtdeParcela',  1);
            AddValue('Origem',       'IMP');
            AddValue('Usuario',      'IMPLANTACAO');
         Executa;

         { Parcela }
         Inc(fIdParcela);
         Start(tcInsert, 'TPagParcela', QueryTrabalho  );
            AddValue('Empresa',          1);
            AddValue('IdParcela',        fIdParcela);
            AddValue('IdDocumento',      fIdDocumento);
            AddValue('Parcela',          1);
            AddValue('Vencimento',       FieldByName('data_venda').AsDateTime);
            AddValue('Valor',            FieldByName('valor_parcela').AsFloat);
            AddValue('ValorPendente',    FieldByName('valor_parcela').AsFloat-FieldByName('valor_pago').AsFloat);
            AddValue('ValorBaixado',     FieldByName('valor_pago').AsFloat);
         Executa;

      except on e:Exception do GravaLog('Documento: ' + FieldByName('numero_documento').AsString + ' Mensagem: '+E.Message);

      end;
   end;
end;

procedure TFCVD201AA.BImportarClick(Sender: TObject);
begin
   fIdDocumento := 0;
   fIdParcela   := 0;
   inherited;
end;

initialization RegisterClass(TFCVD201AA);

end.

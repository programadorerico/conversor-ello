unit CVD100AA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PaiConversor, FMTBcd, StdCtrls, DBClient, Provider, ADODB, DB,
  SqlExpr, ComCtrls, Buttons, ToolWin, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMemo, Grids, DBGrids, ExlDBGrid, PtlBox1, ExtCtrls, EllBox, EllConnection;

type
  TFCVD100AA = class(TFPaiConversor)
  private
    { Private declarations }
    procedure LimpaRegistros; override;
    procedure GravaRegistro; override;
  public
    { Public declarations }
  end;

var
  FCVD100AA: TFCVD100AA;

implementation
uses UnSql, GravaDados, UDataModule;
{$R *.dfm}

procedure TFCVD100AA.GravaRegistro;
begin
  inherited;
   with SqlDados, CDSDados do begin
   {
      Start(tcInsert, 'TGerCidade', QueryTrabalho  );
         AddValue('IdCidade',        FieldByName('Codigo').AsInteger);
         AddValue('Nome',            FieldByName('Nome').AsString);
         AddValue('Cep',             FieldByName('CepPadrao').AsString);
         AddValue('DDD',             FieldByName('DDD').AsString);
         AddValue('CodigoNacional',  FieldByName('CodigoNacional').AsString);
         AddValue('Tipo',            FieldByName('TipoCidade').AsString);
         AddValue('IssQn',           FieldByName('IssQn').AsFloat);
         AddValue('UF',              FieldByName('Estado').AsString);
         AddValue('IdPais',          FieldByName('IdPais').AsInteger);
         AddValue('CodigoIBGE',      FieldByName('CodigoIBGE').AsInteger);
         AddValue('Usuario',         'IMPLANTACAO');
      Executa;
      }

      try
         Start(tcInsert, 'TGerCidade', QueryTrabalho  );
            AddValue('IdCidade',        FieldByName('Codigo').AsInteger);
            AddValue('Nome',            FieldByName('Nome').AsString);
            AddValue('Cep',             FieldByName('CepPadrao').AsString);
            AddValue('DDD',             FieldByName('DDD').AsString);
            AddValue('CodigoNacional',  FieldByName('CodigoNacional').AsString);
            AddValue('Tipo',            FieldByName('TipoCidade').AsString);
            AddValue('IssQn',           FieldByName('IssQn').AsFloat);
            AddValue('UF',              FieldByName('Estado').AsString);
            AddValue('IdPais',          FieldByName('IdPais').AsInteger);
            AddValue('CodigoIBGE',      FieldByName('CodigoIBGE').AsInteger);
            AddValue('Usuario',         'IMPLANTACAO');
         Executa;
      except on e:Exception do begin
            GravaLog('Cidade: ' + FieldByName('CodMunicipio').AsString + ' Mensagem: '+E.Message);
         end;
      end;

   end;
end;

procedure TFCVD100AA.LimpaRegistros;
begin
  inherited;
   with QueryTrabalho do begin
      Sql.Clear;
      Sql.Add('Delete From TGerCidade');
      ExecSql;
   end;
end;

initialization RegisterClass(TFCVD100AA);

end.

unit CVD200AA;

interface

uses
  SysUtils, Variants, Classes, Controls, Forms, PaiConversor, ADODB, DB, SqlExpr, FMTBcd, Provider, ComCtrls, Buttons, ToolWin, StdCtrls,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMemo, Grids, DBGrids, ExlDBGrid, PtlBox1, Graphics, ExtCtrls, EllBox;

type
  TFCVD200AA = class(TFPaiConversor)
  private
    { Private declarations }
    procedure LimpaRegistros; override;
    procedure GravaRegistro; override;
  public
    { Public declarations }
  end;

var
  FCVD200AA: TFCVD200AA;

implementation

uses UnSql, UDataModule, Utils, UFornecedores;

{$R *.dfm}

procedure TFCVD200AA.GravaRegistro;
var
   IdFornecedor : Integer;

   function GetTipoPessoa: String;
   begin
      Result := 'J';
   end;

   function GetNome: String;
   begin
      Result := Trim(UpperCase(TiraAcentos(CDSDados.FieldByName('NomeFantasia').AsString)));
   end;

   function GetFantasia: String;
   begin
      Result := CDSDados.FieldByName('NomeFantasia').AsString;
   end;

   function GetCNPJCPF: String;
   begin
      Result := ApenasDigitos(CDSDados.FieldByName('CNPJ_CPF').AsString);
   end;

   function GetRGIE: String;
   begin
      Result := ApenasDigitos(CDSDados.FieldByName('InscricaoEstadual').AsString);
   end;

   function GetCidade: Integer;
   var codigo_ibge : string;
   begin
      codigo_ibge := CDSDados.FieldByName('CodMunicipio').AsString;
      Result := 3998;
      if codigo_ibge='' then Exit;
      with QueryPesquisa do begin
         Sql.Clear;
         Sql.Add(Format('Select IdCidade From TGerCidade Where CodigoIBGE = ''%s'' ', [codigo_ibge]));
         Open;
         if not QueryPesquisa.IsEmpty then begin
            Result := FieldbyName('IdCidade').AsInteger;
         end;
      end;
   end;

begin
   inherited;
   IdFornecedor := CDSDados.FieldByName('CodFornecedor').AsInteger;
   with SqlDados do begin
      try
         Start(tcInsert, 'TPagFornecedor', QueryTrabalho);
            AddValue('IdFornecedor',     IdFornecedor);
            AddValue('Nome',             GetNome);
            AddValue('Tipo',             GetTipoPessoa);
            AddValue('Fantasia',         GetFantasia);
            AddValue('CpfCnpj',          GetCNPJCPF);
            AddValue('RGIE',             GetRGIE);
            AddValue('OrgaoExpedidor',   '');
            AddValue('Endereco',         UpperCase(TiraAcentos(CDSDados.FieldByName('Endereco').AsString)) );
            AddValue('Numero',           CDSDados.FieldByName('Numero').AsString);
            AddValue('Complemento',      '');
            AddValue('Bairro',           UpperCase(TiraAcentos(CDSDados.FieldByName('Bairro').AsString)) );
            AddValue('CaixaPostal',      '' );
            AddValue('IdCidade',         GetCidade);

            AddValue('Cep',              ApenasDigitos(CDSDados.FieldByName('Cep').AsString) );
            AddValue('Fax',              ApenasDigitos(CDSDados.FieldByName('Fax').AsString));
            AddValue('Contato',          GetFantasia);
            AddValue('Email',            CDSDados.FieldByName('Email').AsString);
            AddValue('DiaEspecifico',    0);
            AddValue('Usuario',          'IMPLANTACAO');
            AddValue('DataCadastro',     Now);

            AddValue('Homepage',         '');
            AddValue('Contatofone',      '');
            AddValue('Fone',             '');
            AddValue('Obs',              '');
         Executa;

      except on e:Exception do begin
            GravaLog('Fornecedor: ' + GetNome + ' Mensagem: '+E.Message);
         end;
      end;
   end;
end;

procedure TFCVD200AA.LimpaRegistros;
begin
   LimpaFornecedores(QueryTrabalho);
   inherited;
end;

initialization RegisterClass(TFCVD200AA);

end.

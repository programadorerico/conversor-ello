unit CVD200AA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PaiConversor, FMTBcd, StdCtrls, DBClient, Provider, ADODB, DB,
  SqlExpr, ComCtrls, Buttons, ToolWin, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMemo, Grids, DBGrids, ExlDBGrid, PtlBox1, ExtCtrls, EllBox, EllConnection;

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

uses UnSql, UDataModule, Utils, GravaDados, UFornecedores;

{$R *.dfm}

procedure TFCVD200AA.GravaRegistro;
var fOrdem: Integer;
 i : integer;

   function GetTipoPessoa: String;
   begin
      Result := 'J';
   end;

   function GetNome: String;
   begin
      Result := Trim(UpperCase(TiraAcentos(CDSDados.FieldByName('Nome').AsString)));
   end;

   function GetFantasia: String;
   begin
      Result := CDSDados.FieldByName('Nome').AsString;
      Result := Trim(UpperCase(TiraAcentos(Result)));
      if Result='' then Result := GetNome;
   end;

   function GetCNPJCPF: String;
   begin
      if GetTipoPessoa='J' then begin
         Result := ApenasDigitos(CDSDados.FieldByName('CNPJ').AsString);
      end else begin
         Result := ApenasDigitos(CDSDados.FieldByName('CPF').AsString);
      end;
   end;

   function GetRGIE: String;
   begin
      if GetTipoPessoa='J' then begin
         Result := ApenasDigitos(CDSDados.FieldByName('InsEstadual').AsString);
      end else begin
         Result := CDSDados.FieldByName('RG').AsString;
      end;
   end;

   function GetCidade: Integer;
   var codigo_ibge : string;
   begin
      codigo_ibge := CDSDados.FieldByName('CodCidade').AsString;
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
   i := CDSDados.FieldByName('Codigo').AsInteger;
   with SqlDados, CDSDados do begin
      try
         Start(tcInsert, 'TPagFornecedor', QueryTrabalho  );
            AddValue('IdFornecedor',     FieldByName('Codigo').AsInteger);
            AddValue('Nome',             GetNome);
            AddValue('Tipo',             GetTipoPessoa);
            AddValue('Fantasia',         GetFantasia);
            AddValue('CpfCnpj',          GetCNPJCPF);
            AddValue('RGIE',             GetRGIE);
            AddValue('OrgaoExpedidor',   '');
            AddValue('Endereco',         UpperCase(TiraAcentos(FieldByName('Endereco').AsString)) );
            AddValue('Numero',           '');
            AddValue('Complemento',      '');
            AddValue('Bairro',           UpperCase(TiraAcentos(FieldByName('Bairro').AsString)) );
            AddValue('CaixaPostal',      '' );
            AddValue('IdCidade',         GetCidade);

            AddValue('Cep',              ApenasDigitos(FieldByName('Cep').AsString) );
            AddValue('Fone',             ApenasDigitos(FieldByName('Fone').AsString) );
            AddValue('Fax',              ApenasDigitos(FieldByName('Fax').AsString));
            AddValue('Contato',          GetFantasia);
            AddValue('ContatoFone',      ApenasDigitos(FieldByName('ContatoFone').AsString) );
            AddValue('VendedorFoneCel',  '');
            AddValue('Email',            FieldByName('Email').AsString);
            AddValue('HomePage',         FieldByName('HomePage').AsString);

            AddValue('DataCadastro',     FieldByName('DtaCadastro').AsDateTime);

            AddValue('DiaEspecifico',    0);
            AddValue('Obs',              '');
            AddValue('Usuario',          'IMPLANTACAO');
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

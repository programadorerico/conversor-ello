unit CVD101AA;

interface

uses
  SysUtils, Variants, Classes, Controls, Forms, PaiConversor, ADODB, DB, SqlExpr, FMTBcd, Provider, ComCtrls,
  Buttons, ToolWin, StdCtrls, cxControls, cxContainer, cxEdit, cxTextEdit, cxMemo, Grids, DBGrids, ExlDBGrid,
  PtlBox1, Graphics, ExtCtrls, EllBox;

type
  TFCVD101AA = class(TFPaiConversor)
    ADOTable1: TADOTable;
    procedure BImportarClick(Sender: TObject);
  private
    { Private declarations }
    fIdCliente: Integer;
    fIdReferencia: Integer;
    procedure LimpaRegistros; override;
    procedure GravaRegistro; override;
  public
    { Public declarations }
  end;

var
  FCVD101AA: TFCVD101AA;

implementation

uses UDataModule, Utils, UnSql, UClientes;

{$R *.dfm}

procedure TFCVD101AA.GravaRegistro;
var Observacao: TStringList;
    Tipo: String;
    Ordem: Integer;
    IdCliente: Integer;

   function RetornaEstadoCivil: String;
   begin
      Result := 'OUTROS';
      {with CDSDados do begin
         if FieldByName('EstadoCivil').AsString = 'C' then Result := 'CASADO';
         if FieldByName('EstadoCivil').AsString = 'S' then Result := 'SOLTEIRO';
         if FieldByName('EstadoCivil').AsString = 'D' then Result := 'DIVORCIADO';
         if FieldByName('EstadoCivil').AsString = 'V' then Result := 'VIUVO';
      end;}
   end;

   function GetTipoPessoa: String;
   begin
      Result := CDSDados.FieldByName('TipoPessoa').AsString;
   end;

   function GetNome: String;
   begin
      Result := Trim(UpperCase(TiraAcentos(CDSDados.FieldByName('Nome').AsString)));
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
      Result := CDSDados.FieldByName('InscricaoEstadual').AsString;
   end;

   function GetCidade: Integer;
   begin
      Result := 3998;
      if cdsdados.FieldByName('CodMunicipio').AsString = '' then exit;
      with QueryPesquisa do begin
         Sql.Clear;
         Sql.Add(Format('Select IdCidade From TGerCidade Where CodigoIBGE = ''%s'' ', [CDSDados.FieldByName('codmunicipio').AsString]));
         Open;
         if not QueryPesquisa.IsEmpty then begin
            Result := FieldbyName('IdCidade').AsInteger;
         end;
      end;
   end;

begin
   inherited;
   IdCliente := CDSDados.FieldByName('CodCliente').AsInteger;
   with SqlDados do begin
      try
         Start(tcInsert, 'TRecCliente', QueryTrabalho);
            AddValue('IdCliente',    IdCliente);
            AddValue('Nome',         GetNome);
            AddValue('Pessoa',       GetTipoPessoa);
            AddValue('Fantasia',     GetFantasia);
            AddValue('Endereco',     Trim(UpperCase(TiraAcentos(CDSDados.FieldByName('Endereco').AsString))));
            AddValue('Bairro',       Trim(UpperCase(TiraAcentos(CDSDados.FieldByName('Bairro').AsString))));
            AddValue('Cep',          ApenasDigitos(CDSDados.FieldByName('Cep').AsString));
            AddValue('IdCidade',     GetCidade);
            AddValue('Numero',       CDSDados.FieldByName('numero').AsString);
            AddValue('Complemento',  CDSDados.FieldByName('Complemento').AsString);
            AddValue('DataCadastro', CDSDados.FieldByName('DataCadastro').AsDateTime);
            AddValue('Fone',         ApenasDigitos(CDSDados.FieldByName('telefone').AsString));
            AddValue('CpfCnpj',      GetCNPJCPF);
            AddValue('RGIE',         GetRGIE);
            AddValue('Email',        CDSDados.FieldByName('email').AsString);
            AddValue('Celular',      ApenasDigitos(CDSDados.FieldByName('Celular').AsString) );
            AddValue('Ativo',        ApenasDigitos(CDSDados.FieldByName('Ativo').AsString) );
            AddValue('Contato',      ApenasDigitos(CDSDados.FieldByName('Contato').AsString) );
            AddValue('OrgaoExpedidor',         '');
            AddValue('EstadoCivil',            RetornaEstadoCivil);
            AddValue('HomePage',               '');
            //AddValue('Sexo',                   FieldByName('Sexo').AsString);
            AddValue('Conjuge',                '');
//            AddValue('Nascimento',             FieldByName('Data_Nascimento').AsDateTime);
            AddValue('PercentualJuros',        0);
            AddValue('PercentualMulta',        0);
            AddValue('JuroMultaDiferenciado',  'N');
            AddValue('EndComercial',           1);
            AddValue('EndEntrega',             2);
            AddValue('EndCobranca',            3);
            AddValue('Limite',                 'UNICO');
            AddValue('LimiteValor',            0);
            AddValue('LimiteVcto',             DataValida('31.12.2015') );
            AddValue('DescontoNaVenda',        'N');
            AddValue('DescontoNaVendaValor',   0);
            AddValue('AcrescimoNaVenda',       'N');
            AddValue('AcrescimoNaVendaValor',  0);
            AddValue('JurosReceber',           'N');
            AddValue('JurosReceberValor',      0);
            AddValue('JurosReceberCarencia',   0);
            AddValue('DescontoReceber',        'N');
            AddValue('DescontoReceberValor',   0);
            AddValue('FormaCrediario',        'S');
            AddValue('FormaCheque',           'S');
            AddValue('FormaCartao',           'S');
            AddValue('FormaConvenio',         'S');
//            AddValue('Obs',                   FieldByName('Obs').AsString);
            AddValue('Usuario',            'IMPLANTACAO');
         Executa;

         { Endereco Comercial }
         Start(tcInsert, 'TRecClienteEndereco', QueryTrabalho  );
            AddValue('IdCliente',              IdCliente);
            AddValue('Tipo',                   1);
            AddValue('Endereco',               UpperCase(TiraAcentos(CDSDados.FieldByName('Endereco').AsString)) );
            AddValue('Numero',                 '');
            AddValue('Complemento',            '');
            AddValue('Bairro',                 UpperCase(TiraAcentos(CDSDados.FieldByName('Bairro').AsString)) );
            AddValue('EstadoCivil',            RetornaEstadoCivil);
            AddValue('IdCidade',               GetCidade);
            AddValue('Cep',                    ApenasDigitos(CDSDados.FieldByName('Cep').AsString) );
            AddValue('Fone',                   ApenasDigitos(CDSDados.FieldByName('telefone').AsString) );
            AddValue('Celular',                ApenasDigitos(CDSDados.FieldByName('Celular').AsString) );
            AddValue('Email',                  CDSDados.FieldByName('Email').AsString);
//            AddValue('HomePage',               FieldByName('HomePage').AsString);
//            AddValue('Observacao',             FieldByName('Obs').AsString);
         Executa;

      except on e:Exception do begin
            GravaLog('Cliente: ' + CDSDados.FieldByName('Codigo').AsString + ' Mensagem: '+E.Message);
         end;
      end;
   end;
end;

procedure TFCVD101AA.LimpaRegistros;
begin
   LimpaClientes(QueryTrabalho);
   inherited;
end;

procedure TFCVD101AA.BImportarClick(Sender: TObject);
begin
   fIdCliente := 0;
   fIdReferencia := 0;
   //ImportaClassificacao;
   inherited;
end;

initialization RegisterClass(TFCVD101AA);

end.


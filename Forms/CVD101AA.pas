unit CVD101AA;

interface

uses
  SysUtils, Variants, Classes, Controls, Forms,
  PaiConversor, ADODB, DB,
  SqlExpr, FMTBcd, Provider, ComCtrls, Buttons, ToolWin, StdCtrls,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMemo, Grids, DBGrids,
  ExlDBGrid, PtlBox1, Graphics, ExtCtrls, EllBox;

type
  TFCVD101AA = class(TFPaiConversor)
    ADOTable1: TADOTable;
    procedure BImportarClick(Sender: TObject);
  private
    { Private declarations }
    procedure LimpaRegistros; override;
    procedure GravaRegistro; override;
    procedure ImportaClassificacao;
  public
    { Public declarations }
  end;

var
  FCVD101AA: TFCVD101AA;

implementation

uses UDataModule, Utils, UnSql, UClientes;

var fIdCliente: Integer;
    fIdReferencia: Integer;

{$R *.dfm}

procedure TFCVD101AA.GravaRegistro;
var fObservacao: TStringList;
    fTipo: String;
    fOrdem: Integer;

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
      Result := iif(Length(CDSDados.FieldByName('CPF').AsString)>14, 'J', 'F');
   end;

   function GetNome: String;
   begin
      Result := Trim(UpperCase(TiraAcentos(CDSDados.FieldByName('Nome').AsString)));
   end;

   function GetFantasia: String;
   begin
      if GetTipoPessoa='J' then begin
         Result := CDSDados.FieldByName('Nome_Fantasia').AsString;
      end else begin
         Result := CDSDados.FieldByName('Nome').AsString;
      end;
      Result := Trim(UpperCase(TiraAcentos(Result)));
      if Result='' then Result := GetNome;
   end;

   function GetCNPJCPF: String;
   begin
      Result := ApenasDigitos(CDSDados.FieldByName('CPF').AsString);
   end;

   function GetRGIE: String;
   begin
      Result := CDSDados.FieldByName('RG').AsString;
   end;

   function GetCidade: Integer;
   begin
      Result := 3998;
      if cdsdados.FieldByName('codigo_ibge').AsString = '' then exit;
      with QueryPesquisa do begin
         Sql.Clear;
         Sql.Add(Format('Select IdCidade From TGerCidade Where CodigoIBGE = ''%s'' ', [CDSDados.FieldByName('codigo_ibge').AsString]));
         Open;
         if not QueryPesquisa.IsEmpty then begin
            Result := FieldbyName('IdCidade').AsInteger;
         end;
      end;
   end;

begin
  inherited;
   with SqlDados, CDSDados do begin
      try
         Start(tcInsert, 'TRecCliente', QueryTrabalho  );
            AddValue('IdCliente',              FieldByName('Codigo').AsInteger);
            //AddValue('IdClassificacao',        FieldByName('Grupo_Id').AsInteger);
            AddValue('Matricula',              FieldByName('Codigo').AsString);
            AddValue('Pessoa',                 GetTipoPessoa);
            AddValue('Nome',                   GetNome);
            AddValue('Fantasia',               GetFantasia);
            AddValue('CpfCnpj',                GetCNPJCPF);
            AddValue('RGIE',                   GetRGIE);
            AddValue('OrgaoExpedidor',         '');
            AddValue('Endereco',               Trim(UpperCase(TiraAcentos(FieldByName('Endereco').AsString))) );
            AddValue('Numero',                 '');
            AddValue('Complemento',            '');
            AddValue('Bairro',                 Trim(UpperCase(TiraAcentos(FieldByName('Bairro').AsString))) );
            //AddValue('Sexo',                   FieldByName('Sexo').AsString);
            AddValue('EstadoCivil',            RetornaEstadoCivil);
            AddValue('IdCidade',               GetCidade);
            AddValue('Cep',                    ApenasDigitos(FieldByName('Cep').AsString) );
            AddValue('Fone',                   ApenasDigitos(FieldByName('telefone').AsString) );
            AddValue('Celular',                ApenasDigitos(FieldByName('Celular').AsString) );
            AddValue('Email',                  FieldByName('email').AsString);
            AddValue('HomePage',               '');

            AddValue('Conjuge',                '');
            AddValue('FiliacaoPai',            UpperCase(TiraAcentos(FieldByName('nome_pai').AsString)) );
            AddValue('FiliacaoMae',            UpperCase(TiraAcentos(FieldByName('nome_mae').AsString)) );
            AddValue('Nascimento',             FieldByName('Data_Nascimento').AsDateTime);
            AddValue('PercentualJuros',        0);
            AddValue('PercentualMulta',        0);
            AddValue('JuroMultaDiferenciado',  'N');
            AddValue('EndComercial',           1);
            AddValue('EndEntrega',             2);
            AddValue('EndCobranca',            3);
            AddValue('Limite',                 'UNICO');
            AddValue('LimiteValor',            0);
            AddValue('LimiteVcto',             DataValida('31.12.2014') );
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
            AddValue('IdCliente',              FieldByName('Codigo').AsInteger);
            AddValue('Tipo',                   1);
            AddValue('Endereco',               UpperCase(TiraAcentos(FieldByName('Endereco').AsString)) );
            AddValue('Numero',                 '');
            AddValue('Complemento',            '');
            AddValue('Bairro',                 UpperCase(TiraAcentos(FieldByName('Bairro').AsString)) );
            AddValue('EstadoCivil',            RetornaEstadoCivil);
            AddValue('IdCidade',               GetCidade);
            AddValue('Cep',                    ApenasDigitos(FieldByName('Cep').AsString) );
            AddValue('Fone',                   ApenasDigitos(FieldByName('telefone').AsString) );
            AddValue('Celular',                ApenasDigitos(FieldByName('Celular').AsString) );
            AddValue('Email',                  FieldByName('Email').AsString);
//            AddValue('HomePage',               FieldByName('HomePage').AsString);
//            AddValue('Observacao',             FieldByName('Obs').AsString);
         Executa;
         (*

         { Endereco Entrega }
         Start(tcInsert, 'TRecClienteEndereco', QueryTrabalho  );
            AddValue('IdCliente',              FieldByName('CodCliente').AsInteger);
            AddValue('Tipo',                   3);
            AddValue('Endereco',               UpperCase(TiraAcentos(FieldByName('EnderecoPrincipal').AsString)) );
            AddValue('Numero',                 ApenasDigitos(FieldByName('NumeroEnderecoPrincipal').AsString) );
            AddValue('Complemento',            UpperCase(TiraAcentos(FieldByName('ComplementoEnderecoPrincipal').AsString)) );
            AddValue('Bairro',                 UpperCase(TiraAcentos(FieldByName('BairroEnderecoPrincipal').AsString)) );
            AddValue('EstadoCivil',            RetornaEstadoCivil);
            AddValue('IdCidade',               GetCidade);
            AddValue('Cep',                    ApenasDigitos(FieldByName('CepEnderecoPrincipal').AsString) );
            AddValue('Fone',                   ApenasDigitos(FieldByName('Telefone').AsString) );
            AddValue('Celular',                ApenasDigitos(FieldByName('Celular').AsString) );
            AddValue('Email',                  FieldByName('Email').AsString);
            AddValue('HomePage',               FieldByName('HomePage').AsString);
            AddValue('Observacao',             FieldByName('NomeEmpresaTrabalho').AsString);
         Executa;

         { Endereco Cobranca }
         Start(tcInsert, 'TRecClienteEndereco', QueryTrabalho  );
            AddValue('IdCliente',              FieldByName('CodCliente').AsInteger);
            AddValue('Tipo',                   4);
            AddValue('Endereco',               UpperCase(TiraAcentos(FieldByName('EnderecoCobranca').AsString)) );
            AddValue('Numero',                 ApenasDigitos(FieldByName('NumeroEnderecoCobranca').AsString) );
            AddValue('Complemento',            UpperCase(TiraAcentos(FieldByName('ComplementoEnderecoPrincipal').AsString)) );
            AddValue('Bairro',                 UpperCase(TiraAcentos(FieldByName('BairroEnderecoCobranca').AsString)) );
            AddValue('EstadoCivil',            RetornaEstadoCivil);
            AddValue('IdCidade',               GetCidade);
            AddValue('Cep',                    ApenasDigitos(FieldByName('CepEnderecoCobranca').AsString) );
            AddValue('Fone',                   ApenasDigitos(FieldByName('TelefoneEnderecoCobranca').AsString) );
            AddValue('Celular',                ApenasDigitos(FieldByName('Celular').AsString) );
            AddValue('Email',                  FieldByName('Email').AsString);
            AddValue('HomePage',               FieldByName('HomePage').AsString);
            AddValue('Observacao',             FieldByName('NomeEmpresaTrabalho').AsString+#13#10+
                                               ApenasDigitos(FieldByName('TelefoneEmpresaTrabalho').AsString));
         Executa;
         *)

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

procedure TFCVD101AA.ImportaClassificacao;
begin
//   with SqlDados, QueryTECNOBYTE do begin
//      { Limpa a tabela }
//      Start(tcDelete, 'TRecClienteClassificacao', QueryTrabalho);
//      Executa;
//      try
//         Sql.Clear;
//         Sql.Add('Select * From GrupoCliente ');
//         Open;
//         { Importa Registros }
//         while not eof do begin
//            Start(tcInsert, 'TRecClienteClassificacao', QueryTrabalho  );
//               AddValue('IdClassificacao', FieldByName('Id').AsInteger);
//               AddValue('Descricao',       UpperCase(TiraAcentos(FieldByName('Nome').AsString)) );
//               AddValue('IdUsuario',       1);
//            Executa;
//
//            QueryPesquisaECO.Next;
//
//         end;
//      except on e:Exception do begin
//            GravaLog('Classificacao: ' + FieldByName('Id').AsString + ' Mensagem: '+E.Message);
//         end;
//      end;
//   end;
end;

initialization RegisterClass(TFCVD101AA);

end.


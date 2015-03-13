unit CVD200AA;

interface

uses
  SysUtils, Variants, Classes, Controls, Forms, PaiConversor, ADODB, DB, SqlExpr, FMTBcd, Provider, ComCtrls, Buttons, ToolWin, StdCtrls,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMemo, Grids, DBGrids, ExlDBGrid, PtlBox1, Graphics, ExtCtrls, EllBox,
  DBClient;

type
  TFCVD200AA = class(TFPaiConversor)
    procedure BImportarClick(Sender: TObject);
  private
    { Private declarations }
    FIdFornecedor : Integer;
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

   function GetTipoPessoa: String;
   begin
      Result := 'J';
   end;

   function GetNome: String;
   begin
      Result := Trim(UpperCase(TiraAcentos(CDSDadosOrigem.FieldByName('Fornecedor').AsString)));
   end;

   function GetFantasia: String;
   begin
      Result := GetNome;
   end;

   function GetCNPJCPF: String;
   begin
      Result := ApenasDigitos('00.000.000/0000-00');
   end;

   function GetRGIE: String;
   begin
      Result := ApenasDigitos('00000000');
   end;

   function GetCidade: Integer;
   var codigo_ibge : string;
   begin
      codigo_ibge := '5105606';
      Result := 4077;
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
   Inc(FIdFornecedor);
   with SqlDados do begin
      try
         Start(tcInsert, 'TPagFornecedor', QueryTrabalho);
            AddValue('IdFornecedor',     FIdFornecedor);
            AddValue('Nome',             GetNome);
            AddValue('Tipo',             GetTipoPessoa);
            AddValue('Fantasia',         GetFantasia);
            AddValue('CpfCnpj',          GetCNPJCPF);
            AddValue('RGIE',             GetRGIE);
            AddValue('OrgaoExpedidor',   '');
            AddValue('Endereco',         'INDEFINIDO');
            AddValue('Numero',           '0');
            AddValue('Complemento',      '');
            AddValue('Bairro',           'INDEFINIDO');
            AddValue('CaixaPostal',      '' );
            AddValue('IdCidade',         GetCidade);

            AddValue('Cep',              '78525000');
            AddValue('Fax',              '');
            AddValue('Contato',          GetFantasia);
            AddValue('Email',            'naoinformado@nada.com.br');
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

procedure TFCVD200AA.BImportarClick(Sender: TObject);
begin
   inherited;
   FIdFornecedor := 0;
end;

initialization RegisterClass(TFCVD200AA);

end.

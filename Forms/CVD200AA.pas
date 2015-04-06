unit CVD200AA;

interface

uses
  SysUtils, Variants, Classes, Controls, Forms, PaiConversor, ADODB, DB, SqlExpr, FMTBcd, Provider, ComCtrls, Buttons, ToolWin, StdCtrls,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMemo, Grids, DBGrids, ExlDBGrid, PtlBox1, Graphics, ExtCtrls, EllBox,
  DBClient, UFornecedores;

type
  TFCVD200AA = class(TFPaiConversor)
    procedure FormCreate(Sender: TObject); override;
  private
    FIdFornecedor : Integer;
    procedure LimpaRegistros; override;
    procedure GravaRegistro; override;
    procedure GravaFornecedor(Fornecedor: TFornecedorConvertido);
  end;

var
  FCVD200AA: TFCVD200AA;

implementation

uses UnSql, UDataModule, Utils;

{$R *.dfm}

{ TFCVD200AA }

procedure TFCVD200AA.FormCreate(Sender: TObject);
begin
   inherited;
   ADOQueryOrigem.SQL.Text := UFornecedores.QUERY;
end;

procedure TFCVD200AA.GravaRegistro;
var
   FornecedorConvertido: TFornecedorConvertido;
begin
   inherited;

   FornecedorConvertido := TFornecedorConvertido.Create;
   FornecedorConvertido.QueryPesquisa := QueryPesquisa;
   FornecedorConvertido.CarregaDoDataset(CDSDadosOrigem);
   try
      GravaFornecedor(FornecedorConvertido);
   except
      on e:Exception do begin
         GravaLog('Fornecedor: ' + FornecedorConvertido.Nome + ' Mensagem: '+E.Message);
      end;
   end;
   FornecedorConvertido.Free;
end;

procedure TFCVD200AA.LimpaRegistros;
begin
   LimpaFornecedores(QueryTrabalho);
   inherited;
end;

procedure TFCVD200AA.GravaFornecedor(Fornecedor: TFornecedorConvertido);
begin
   with SqlDados do begin
      Start(tcInsert, 'TPagFornecedor');
         AddValue('IdFornecedor',     Fornecedor.IdFornecedor);
         AddValue('Nome',             Fornecedor.Nome);
         AddValue('Tipo',             Fornecedor.Tipo);
         AddValue('Fantasia',         Fornecedor.Fantasia);
         AddValue('CpfCnpj',          Fornecedor.CpfCnpj);
         AddValue('RGIE',             Fornecedor.RGIE);
         AddValue('OrgaoExpedidor',   '');
         AddValue('Endereco',         'INDEFINIDO');
         AddValue('Numero',           '0');
         AddValue('Complemento',      '');
         AddValue('Bairro',           'INDEFINIDO');
         AddValue('CaixaPostal',      '' );
         AddValue('IdCidade',         Fornecedor.IdCidade);

         AddValue('Cep',              '78525000');
         AddValue('Fax',              '');
         AddValue('Contato',          Fornecedor.Contato);
         AddValue('Email',            'naoinformado@nada.com.br');
         AddValue('DiaEspecifico',    0);
         AddValue('Usuario',          'IMPLANTACAO');
         AddValue('DataCadastro',     Fornecedor.DataCadastro);

         AddValue('Homepage',         '');
         AddValue('Contatofone',      '');
         AddValue('Fone',             '');
         AddValue('Obs',              '');
      Executa;
   end;
end;

initialization RegisterClass(TFCVD200AA);

end.

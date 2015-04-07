unit CVD101AA;

interface

uses
  SysUtils, Variants, Classes, Controls, Forms, PaiConversor, ADODB, DB, SqlExpr, FMTBcd, Provider, ComCtrls,
  Buttons, ToolWin, StdCtrls, cxControls, cxContainer, cxEdit, cxTextEdit, cxMemo, Grids, DBGrids, ExlDBGrid,
  PtlBox1, Graphics, ExtCtrls, EllBox, UClientes, DBClient;

type
  TFCVD101AA = class(TFPaiConversor)
    procedure FormCreate(Sender: TObject); override;
  private
    fIdCliente: Integer;
    fIdReferencia: Integer;
    procedure LimpaRegistros; override;
    procedure GravaRegistro; override;
    procedure GravaCliente(Cliente: TClienteConvertido);
    procedure GravaEndereco(Endereco: TEnderecoConvertido);
  public
    procedure Open; override;
  end;

var
  FCVD101AA: TFCVD101AA;

implementation

uses UDataModule, Utils, UnSql, StdConvs;

{$R *.dfm}

procedure TFCVD101AA.FormCreate(Sender: TObject);
begin
   inherited;
   ADOQueryOrigem.SQL.Text := UClientes.QUERY;
end;

procedure TFCVD101AA.GravaRegistro;
var
   ClienteConvertido: TClienteConvertido;
   EnderecoConvertido: TEnderecoConvertido;
begin
   inherited;
   ClienteConvertido := TClienteConvertido.Create;
   ClienteConvertido.QueryPesquisa := QueryPesquisa;
   ClienteConvertido.CarregaDoDataset(CDSDadosOrigem);

   EnderecoConvertido := TEnderecoConvertido.Create;
   EnderecoConvertido.QueryPesquisa := QueryPesquisa;
   EnderecoConvertido.CarregaDoDataset(CDSDadosOrigem);

   try
      GravaCliente(ClienteConvertido);
      GravaEndereco(EnderecoConvertido);
   except on e:Exception do begin
         GravaLog('Cliente: ' + IntToStr(ClienteConvertido.Idcliente) + ' Mensagem: '+E.Message);
      end;
   end;

   ClienteConvertido.Free;
   EnderecoConvertido.Free;
end;

procedure TFCVD101AA.LimpaRegistros;
begin
   LimpaClientes(QueryTrabalho);
   inherited;
end;

procedure TFCVD101AA.GravaCliente(Cliente: TClienteConvertido);
begin
   with SqlDados do begin
      Start(tcInsert, 'TRecCliente');
         AddValue('IdCliente',             Cliente.IdCliente);
         AddValue('Nome',                  Cliente.Nome);
         AddValue('Pessoa',                Cliente.Pessoa);
         AddValue('Fantasia',              Cliente.Fantasia);
         AddValue('Endereco',              Cliente.Endereco);
         AddValue('Bairro',                Cliente.Bairro);
         AddValue('Cep',                   Cliente.Cep);
         AddValue('IdCidade',              Cliente.IdCidade);
         AddValue('Numero',                Cliente.Numero);
         AddValue('Complemento',           Cliente.Complemento);
         AddValue('DataCadastro',          Cliente.DataCadastro);
         AddValue('Fone',                  Cliente.Fone);
         AddValue('CpfCnpj',               Cliente.CpfCnpj);
         AddValue('RGIE',                  Cliente.RGIE);
         AddValue('Email',                 Cliente.Email);
         AddValue('Celular',               Cliente.Celular);
         AddValue('Ativo',                 Cliente.Ativo);
         AddValue('Contato',               Cliente.Contato);
         AddValue('OrgaoExpedidor',        Cliente.OrgaoExpedidor);
         AddValue('EstadoCivil',           Cliente.EstadoCivil);
         AddValue('HomePage',              Cliente.HomePage);
         AddValue('Sexo',                  Cliente.Sexo);
         AddValue('Conjuge',               Cliente.Conjuge);
         AddValue('Nascimento',            Cliente.Nascimento);
         AddValue('PercentualJuros',       Cliente.PercentualJuros);
         AddValue('PercentualMulta',       Cliente.PercentualMulta);
         AddValue('JuroMultaDiferenciado', Cliente.JuroMultaDiferenciado);
         AddValue('EndComercial',          Cliente.EndComercial);
         AddValue('EndEntrega',            Cliente.EndEntrega);
         AddValue('EndCobranca',           Cliente.EndCobranca);
         AddValue('Limite',                Cliente.Limite);
         AddValue('LimiteValor',           Cliente.LimiteValor);
         AddValue('LimiteVcto',            Cliente.LimiteVcto);
         AddValue('DescontoNaVenda',       Cliente.DescontoNaVenda);
         AddValue('DescontoNaVendaValor',  Cliente.DescontoNaVendaValor);
         AddValue('AcrescimoNaVenda',      Cliente.AcrescimoNaVenda);
         AddValue('AcrescimoNaVendaValor', Cliente.AcrescimoNaVendaValor);
         AddValue('JurosReceber',          Cliente.JurosReceber);
         AddValue('JurosReceberValor',     Cliente.JurosReceberValor);
         AddValue('JurosReceberCarencia',  Cliente.JurosReceberCarencia);
         AddValue('DescontoReceber',       Cliente.DescontoReceber);
         AddValue('DescontoReceberValor',  Cliente.DescontoReceberValor);
         AddValue('FormaCrediario',        Cliente.FormaCrediario);
         AddValue('FormaCheque',           Cliente.FormaCheque);
         AddValue('FormaCartao',           Cliente.FormaCartao);
         AddValue('FormaConvenio',         Cliente.FormaConvenio);
         AddValue('Obs',                   Cliente.Obs);
         AddValue('FILIACAOPAI',           Cliente.FiliacaoPai);
         AddValue('FILIACAOMAE',           Cliente.FiliacaoMae);
         AddValue('Usuario',               Cliente.Usuario);
      Executa;
   end;
end;

procedure TFCVD101AA.GravaEndereco(Endereco: TEnderecoConvertido);
begin
   with SqlDados do begin
      Start(tcInsert, 'TRecClienteEndereco');
         AddValue('IdCliente',              Endereco.IdCliente);
         AddValue('Tipo',                   Endereco.Tipo);
         AddValue('Endereco',               Endereco.Endereco);
         AddValue('Numero',                 Endereco.Numero);
         AddValue('Complemento',            Endereco.Complemento);
         AddValue('Bairro',                 Endereco.Bairro);
         AddValue('EstadoCivil',            Endereco.EstadoCivil);
         AddValue('IdCidade',               Endereco.IdCidade);
         AddValue('Cep',                    Endereco.Cep);
         AddValue('Fone',                   Endereco.Fone);
         AddValue('Celular',                Endereco.Celular);
         AddValue('Email',                  Endereco.Email);
         AddValue('HomePage',               Endereco.HomePage);
         AddValue('Observacao',             Endereco.Observacao);
      Executa;
   end;
end;

procedure TFCVD101AA.Open;
begin
   CDSDadosOrigem.Open;
   Label1.Caption        := 'Registros '+StrZero(CDSDadosOrigem.RecordCount,6);
   Label1.Visible        := True;
   ProgressBar1.Max      := CDSDadosOrigem.RecordCount;
   ProgressBar1.Position := 0;
   BImportar.Enabled     := CDSDadosOrigem.RecordCount>0;
end;

initialization RegisterClass(TFCVD101AA);

end.


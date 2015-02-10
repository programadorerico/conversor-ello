unit CVD602AA;

interface

uses
  Variants, Classes, Controls, Forms, PaiConversor, SqlExpr, FMTBcd, ADODB,
  Provider, DB, ComCtrls, Buttons, ToolWin, StdCtrls, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMemo, Grids, DBGrids, ExlDBGrid,
  PtlBox1, Graphics, ExtCtrls, EllBox;

type
  TFCVD602AA = class(TFPaiConversor)
    procedure BtAbrirClick(Sender: TObject);
  private
    { Private declarations }
    procedure LimpaRegistros; override;
    procedure GravaRegistro; override;
    procedure Importa; override;
  public
    { Public declarations }
  end;

var
  FCVD602AA: TFCVD602AA;

implementation

uses SysUtils, EllTypes, UnSql, UDataModule, UProdutos;

{$R *.dfm}

{ Chamado para cada registro da tabela }
procedure TFCVD602AA.GravaRegistro;
begin
   with SqlDados do begin
      Start(tcInsert, 'TEstGrupo', QueryTrabalho);
         AddValue('IdGrupo',   FIdRegistro);
         AddValue('IdTipo',    1);
         AddValue('Descricao', Trim(CDSDados.FieldByName('grupo').AsString));
         AddValue('Tipo',      'REV');
         AddValue('Usuario',   'IMPLANTACAO');
      Executa;
   end;
end;

procedure TFCVD602AA.LimpaRegistros;
begin
   if not MensagemEllo('Este processo limpara todos os produtos e movimentações dos produtos'+#13#10+'Deseja continuar', tmConfirmaN) then exit;
   LimpaProdutos(QueryTrabalho);
   LimpaGrupos(QueryTrabalho);
   LimpaClasses(QueryTrabalho);
   inherited;
end;

procedure TFCVD602AA.BtAbrirClick(Sender: TObject);
begin
   inherited;
   BImportar.Enabled := True;
end;

{ Chamado ao clicar no botão importar }
procedure TFCVD602AA.Importa;
begin
   with SqlDados do begin
      Start(tcInsert, 'TEstClasse', QueryTrabalho);
         AddValue('IdClasse',  1);
         AddValue('Imagem',    0);
         AddValue('Descricao', 'PRODUTOS');
         AddValue('Usuario',   'IMPLANTACAO');
      Executa;
   end;
   inherited;
end;

initialization RegisterClass(TFCVD602AA);

end.

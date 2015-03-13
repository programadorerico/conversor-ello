unit CVD604AA;

interface

uses
  Variants, Classes, Controls, Forms, PaiConversor, StdCtrls, DB, SqlExpr, FMTBcd, ADODB, Provider, ComCtrls, Buttons, ToolWin, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMemo, Grids, DBGrids, ExlDBGrid, PtlBox1, Graphics, ExtCtrls, EllBox;

type
  TFCVD604AA = class(TFPaiConversor)
    procedure BtAbrirClick(Sender: TObject);
    procedure BImportarClick(Sender: TObject);
  private
    { Private declarations }
    FIdMarca: Integer;
    procedure LimpaRegistros; override;
    procedure GravaRegistro; override;
  end;

var
  FCVD604AA: TFCVD604AA;

implementation

uses SysUtils, EllTypes, UnSql, UDataModule, UProdutos;

{$R *.dfm}

procedure TFCVD604AA.LimpaRegistros;
begin
   if not MensagemEllo('Este processo limpara todos os produtos e movimentações dos produtos'+#13#10+'Deseja continuar', tmConfirmaN) then exit;
   LimpaProdutos(QueryTrabalho);
   LimpaGrupos(QueryTrabalho);
   LimpaClasses(QueryTrabalho);
   LimpaMarcas(QueryTrabalho);
   inherited;
end;

procedure TFCVD604AA.BtAbrirClick(Sender: TObject);
begin
   inherited;
   BImportar.Enabled := True;
end;

procedure TFCVD604AA.GravaRegistro;
begin
   inherited;
   Inc(FIdMarca);
   SqlDados.Start(tcInsert, 'TEstMarca', QueryTrabalho);
   SqlDados.AddValue('IdMarca',    FIdMarca);
   SqlDados.AddValue('Descricao',  Trim(CDSDados.FieldByName('Marca').AsString));
   SqlDados.AddValue('Usuario',   'IMPLANTACAO');
   SqlDados.Executa;
end;

procedure TFCVD604AA.BImportarClick(Sender: TObject);
begin
   inherited;
   FIdMarca := 0;
end;

initialization RegisterClass(TFCVD604AA);

end.

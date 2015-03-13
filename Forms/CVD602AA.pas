unit CVD602AA;

interface

uses
  Variants, Classes, Controls, Forms, PaiConversor, 
  DB, StdCtrls, FMTBcd, ADODB, Provider, SqlExpr, ComCtrls, Buttons,
  ToolWin, cxControls, cxContainer, cxEdit, cxTextEdit, cxMemo, Grids,
  DBGrids, ExlDBGrid, PtlBox1, Graphics, ExtCtrls, EllBox, DBClient;

type
  TFCVD602AA = class(TFPaiConversor)
    procedure BImportarClick(Sender: TObject);
  private
    FIdGrupo: Integer;
    procedure LimpaRegistros; override;
    procedure GravaRegistro; override;
  end;

var
  FCVD602AA: TFCVD602AA;

implementation

uses SysUtils, EllTypes, UnSql, UDataModule, UProdutos;

{$R *.dfm}

{ Chamado para cada registro da tabela }
procedure TFCVD602AA.GravaRegistro;
begin
   Inc(FIdGrupo);

   SqlDados.Start(tcInsert, 'TEstGrupo', QueryTrabalho);
   SqlDados.AddValue('IdTipo',    1);
   SqlDados.AddValue('IdGrupo',   FIdGrupo);
   SqlDados.AddValue('Descricao', Trim(CDSDadosOrigem.FieldByName('Grupo').AsString));
   SqlDados.AddValue('Tipo',      'REV');
   SqlDados.AddValue('Usuario',   'IMPLANTACAO');
   SqlDados.Executa;

   SqlDados.Start(tcInsert, 'TEstSubGrupo', QueryTrabalho);
   SqlDados.AddValue('IdSubGrupo', FIdRegistro);
   SqlDados.AddValue('IdGrupo',    FIdGrupo);
   SqlDados.AddValue('Descricao',  Trim(CDSDadosOrigem.FieldByName('Grupo').AsString));
   SqlDados.AddValue('Usuario',   'IMPLANTACAO');
   SqlDados.Executa;
end;

procedure TFCVD602AA.BImportarClick(Sender: TObject);
begin
   inherited;
   FIdGrupo := 0;
end;

procedure TFCVD602AA.LimpaRegistros;
begin
   inherited;
   LimpaGrupos(QueryTrabalho);
end;

initialization RegisterClass(TFCVD602AA);

end.

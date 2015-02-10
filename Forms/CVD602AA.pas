unit CVD602AA;

interface

uses
  Variants, Classes, Controls, Forms, PaiConversor, 
  DB, StdCtrls, FMTBcd, ADODB, Provider, SqlExpr, ComCtrls, Buttons,
  ToolWin, cxControls, cxContainer, cxEdit, cxTextEdit, cxMemo, Grids,
  DBGrids, ExlDBGrid, PtlBox1, Graphics, ExtCtrls, EllBox;

type
  TFCVD602AA = class(TFPaiConversor)
  private
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
   SqlDados.Start(tcInsert, 'TEstGrupo', QueryTrabalho);
   SqlDados.AddValue('IdTipo',    1);
   SqlDados.AddValue('IdGrupo',   CDSDados.FieldByName('codgrupoproduto').AsInteger);
   SqlDados.AddValue('Descricao', Trim(CDSDados.FieldByName('nome').AsString));
   SqlDados.AddValue('Tipo',      'REV');
   SqlDados.AddValue('Usuario',   'IMPLANTACAO');
   SqlDados.Executa;

   SqlDados.Start(tcInsert, 'TEstSubGrupo', QueryTrabalho);
   SqlDados.AddValue('IdSubGrupo', FIdRegistro);
   SqlDados.AddValue('IdGrupo',    CDSDados.FieldByName('codgrupoproduto').AsInteger);
   SqlDados.AddValue('Descricao',  Trim(CDSDados.FieldByName('nome').AsString));
   SqlDados.AddValue('Usuario',   'IMPLANTACAO');
   SqlDados.Executa;
end;

initialization RegisterClass(TFCVD602AA);

end.

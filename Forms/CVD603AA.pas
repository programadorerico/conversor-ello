unit CVD603AA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PaiConversor, FMTBcd, StdCtrls, DBClient, Provider, ADODB, DB,
  SqlExpr, ComCtrls, Buttons, ToolWin, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMemo, Grids, DBGrids, ExlDBGrid, PtlBox1, ExtCtrls, EllBox, EllConnection;

type
  TFCVD603AA = class(TFPaiConversor)
    procedure BtAbrirClick(Sender: TObject);
  private
    { Private declarations }
    procedure LimpaRegistros; override;
    procedure GravaRegistro; override;
  public
    { Public declarations }
  end;

var
  FCVD603AA: TFCVD603AA;

implementation

uses EllTypes, UnSql, GravaDados, UDataModule, Utils, UProdutos;

{$R *.dfm}

procedure TFCVD603AA.GravaRegistro;

   function getIdGrupo(nomeGrupo: String): Integer;
   begin
      QueryPesquisa.SQL.Text := Format('SELECT idgrupo FROM testgrupo WHERE descricao=''%s''', [nomeGrupo]);
      QueryPesquisa.Open;
      Result := QueryPesquisa.FieldByName('idgrupo').AsInteger;      
   end;

begin
   SqlDados.Start(tcInsert, 'TEstSubGrupo', QueryTrabalho);
   SqlDados.AddValue('IdSubGrupo', FIdRegistro);
   SqlDados.AddValue('IdGrupo',    getIdGrupo(CDSDados.FieldByName('grupo').AsString));
   SqlDados.AddValue('Descricao',  Trim(CDSDados.FieldByName('subgrupo').AsString));
   SqlDados.AddValue('Usuario',   'IMPLANTACAO');
   SqlDados.Executa;
end;

procedure TFCVD603AA.LimpaRegistros;
begin
   if not MensagemEllo('Este processo limpara todos os produtos e movimentações dos produtos'+#13#10+'Deseja continuar', tmConfirmaN) then exit;
   LimpaProdutos(QueryTrabalho);
   QueryTrabalho.SQLConnection.ExecuteDirect('Delete From TEstSubGrupo');
   inherited;
end;

procedure TFCVD603AA.BtAbrirClick(Sender: TObject);
begin
   inherited;
   BImportar.Enabled := True;
end;

initialization RegisterClass(TFCVD603AA);

end.

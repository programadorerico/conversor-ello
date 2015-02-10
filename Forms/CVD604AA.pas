unit CVD604AA;

interface

uses
  Variants, Classes, Controls, Forms,
  PaiConversor, StdCtrls, DB,
  SqlExpr, FMTBcd, ADODB, Provider, ComCtrls, Buttons, ToolWin, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMemo, Grids, DBGrids, ExlDBGrid,
  PtlBox1, Graphics, ExtCtrls, EllBox;

type
  TFCVD604AA = class(TFPaiConversor)
    procedure BtAbrirClick(Sender: TObject);
  private
    { Private declarations }
    procedure LimpaRegistros; override;
    procedure GravaRegistro; override;
    procedure AfterImporta; override;
  end;

var
  FCVD604AA: TFCVD604AA;

implementation

uses EllTypes, UnSql, UDataModule, UProdutos;

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
   SqlDados.Start(tcInsert, 'TEstMarca', QueryTrabalho);
   SqlDados.AddValue('IdMarca',    FIdRegistro);
   SqlDados.AddValue('Descricao',  CDSDados.FieldByName('marca').AsString);
   SqlDados.AddValue('Usuario',   'IMPLANTACAO');
   SqlDados.Executa;
end;

procedure TFCVD604AA.AfterImporta;
begin
  inherited;
  Datam1.sConnection.ExecuteDirect(
     'INSERT INTO TESTGRUPO (IDGRUPO, IDTIPO, DESCRICAO, TIPO, AJUSTE, AJUSTEPERCENTUAL, USUARIO, GRUPOBALANCA, IDCONTA, IDCONTAVISTA, IDCONTAPRAZO) ' +
     'VALUES (''1'', ''1'', ''REVENDA'', ''REV'', ''N'', ''0.000'', '' '', ''N'', NULL, NULL, NULL)'
  );

  Datam1.sConnection.ExecuteDirect(
     'INSERT INTO TESTSUBGRUPO (IDSUBGRUPO, IDGRUPO, DESCRICAO, AJUSTE, AJUSTEPERCENTUAL, USUARIO, TEMP, IDIMPRESSORA, LISTAEXCECOES) ' +
     'VALUES (''1'', ''1'', ''REVENDA'', ''N'', ''0.000'', '' '', NULL, NULL, NULL)'
  );

  Datam1.sConnection.ExecuteDirect(
     'INSERT INTO TESTCLASSE (IDCLASSE, DESCRICAO, MONITORADO, AJUSTE, AJUSTEPERCENTUAL, DESCONTO, DESCONTOPERCENTUAL, COMISSAOESPECIAL, COMISSAOVISTA, COMISSAOPRAZO, MARGEMLUCRO, USUARIO, IMAGEM, LISTAEXCECOES, IDCONTA, IDCONTAVISTA, IDCONTAPRAZO, MOBILE) ' +
     'VALUES (''1'', ''CLASSE'', ''N'', ''N'', ''0.0000'', ''N'', ''0.0000'', ''N'', ''0.000'', ''0.000'', ''0.000000'', ''TRIBURTINI'', ''0'', NULL, NULL, NULL, NULL, ''S'')'
  );
end;

initialization RegisterClass(TFCVD604AA);

end.

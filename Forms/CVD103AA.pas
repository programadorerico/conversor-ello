unit CVD103AA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PaiConversor, FMTBcd, StdCtrls, DBClient, Provider, ADODB, DB,
  SqlExpr, ComCtrls, Buttons, ToolWin, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMemo, Grids, DBGrids, ExlDBGrid, PtlBox1, ExtCtrls, EllBox, EllConnection;

type
  TFCVD103AA = class(TFPaiConversor)
    procedure BImportarClick(Sender: TObject);
  private
    { Private declarations }
    fIdAgenda: Integer;
    procedure LimpaRegistros; override;
    procedure GravaRegistro; override;
  public
    { Public declarations }
  end;

var
  FCVD103AA: TFCVD103AA;

implementation
uses UnSql, Utils, GravaDados, UDataModule;
{$R *.dfm}

procedure TFCVD103AA.GravaRegistro;
var fObservacao: TStringList;
begin
  inherited;
   with SqlDados, CDSDAdos do begin

      fObservacao := TStringList.Create;
      fObservacao.Add(' Telefone: '+FieldByName('Telefone').AsString);
      fObservacao.Add('      Fax: '+FieldByName('Fax').AsString);
      fObservacao.Add('  Celular: '+FieldByName('Celular').AsString);

      try
         try
            Inc(fIdAgenda);
            Start(tcInsert, 'TRecAgenda', QueryTrabalho  );
               AddValue('IdAgenda',          fIdAgenda);
               AddValue('Nome',              FieldByName('Nome').AsString);
               AddValue('Empresa',           FieldByName('NomeUsual').AsString);
               AddValue('FoneResidencial',   ApenasDigitos(FieldByName('Telefone').AsString) );
               AddValue('FoneComercial',     ApenasDigitos(FieldByName('Fax').AsString) );
               AddValue('FoneCelular',       ApenasDigitos(FieldByName('Celular').AsString) );
               AddValue('Observacao',        fObservacao.Text);
               AddValue('IdUsuario',         1);
            Executa;
         except on e:Exception do begin
               GravaLog('Telefone: ' + FieldByName('Nome').AsString + ' Mensagem: '+E.Message);
            end;
         end;
      finally
         FreeAndNil(fObservacao);
      end;

   end;
end;

procedure TFCVD103AA.LimpaRegistros;
begin
  inherited;
   with QueryTrabalho do begin
      Sql.Clear;
      Sql.Add('Delete from TRecAgenda');
      ExecSql;
   end;
end;

procedure TFCVD103AA.BImportarClick(Sender: TObject);
begin
   fIdAgenda := 0;
  inherited;
end;

initialization RegisterClass(TFCVD103AA);

end.

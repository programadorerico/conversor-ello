unit CVD605AA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PaiConversor, FMTBcd, StdCtrls, DBClient, Provider, ADODB, DB,
  SqlExpr, ComCtrls, Buttons, ToolWin, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMemo, Grids, DBGrids, ExlDBGrid, PtlBox1, ExtCtrls, EllBox, EllConnection;

type
  TFCVD605AA = class(TFPaiConversor)
  private
    { Private declarations }
    procedure GravaRegistro; override;
  public
    { Public declarations }
  end;

var
  FCVD605AA: TFCVD605AA;

implementation
uses EllTypes, Utils, UnSql, GravaDados, UDataModule;
{$R *.dfm}

procedure TFCVD605AA.GravaRegistro;
var fTel: String;
    fTel1: String;
    fTel2: String;
begin
   with QueryTrabalho do begin
      try
         fTel1 := Trim(ApenasDigitos(CDSDados.FieldByName('FCEL_Cli').AsString));
         fTel2 := Trim(ApenasDigitos(CDSDados.FieldByName('FON2_Cli').AsString));
         fTel  := iif(fTel1='', fTel2, fTel1);

         if fTel<>'' then begin
            Sql.Clear;
            Sql.Add('Update TRecCliente Set        ' +
                    '       Celular  = :Celular,   ' +
                    '       HomePage = :HomePage   ' +
                    'Where  IdCliente = :IdCliente ');
            ParamByName('Celular').AsString    := fTel;
            ParamByName('HomePage').AsString   := IIF(fTel1<>'', 'Tel1: '+fTel1+'  ','')+IIF(fTel2<>'', 'Cel: '+fTel2,'');
            ParamByName('IdCliente').AsInteger := CDSDados.FieldByName('CODI_CLI').AsInteger;
            ExecSql;
         end;
      except on e:Exception do GravaLog('Cod Cli: ' + CDSDados.FieldByName('CODI_CLI').AsString + ' Mensagem: '+E.Message);
      end;
   end;
end;

initialization RegisterClass(TFCVD605AA);

end.

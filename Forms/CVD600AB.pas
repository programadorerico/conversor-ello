unit CVD600AB;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FMTBcd, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMemo, Acao, DB, SqlExpr, Buttons, ToolWin, ComCtrls,
  StdCtrls, ExtCtrls, EllBox, ADODB;

type
  TFCVD600AB = class(TFPaiRotinaModal)
    MSql: TcxMemo;
    BTestar: TButton;
    ADOAux: TADOQuery;
    procedure BTestarClick(Sender: TObject);
    procedure MSqlPropertiesChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FCVD600AB: TFCVD600AB;

implementation
uses UProced;

{$R *.dfm}

procedure TFCVD600AB.BTestarClick(Sender: TObject);
begin
  inherited;
   AdoAux.SQL.Text := MSql.Text;
   try
      AdoAux.Close;
      Screen.Cursor := crSQLWait;
      AdoAux.Open;
      Screen.Cursor := crDefault;

      Mensagem('Instrução SQL executada com sucesso', tmInforma);
   except on e:Exception do begin
         Screen.Cursor := crDefault;
         raise Exception.Create(E.Message);
      end;
   end;
end;

procedure TFCVD600AB.MSqlPropertiesChange(Sender: TObject);
begin
  inherited;
   BTestar.Enabled     := MSql.Text<>'';
   BtConfirmar.Enabled := True;
end;

initialization RegisterClass(TFCVD600AB);

end.

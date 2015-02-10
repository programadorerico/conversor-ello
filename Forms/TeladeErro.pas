unit TeladeErro;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons, ExtCtrls, dxGDIPlusClasses,
  cxControls, cxContainer, cxEdit, cxLabel;

type
  TFTeladeErro = class(TForm)
    Panel3: TPanel;
    REErro: TRichEdit;                                       
    REPrograma: TRichEdit;
    BtFechar: TButton;
    Bevel1: TBevel;
    Image2: TImage;
    Bevel2: TBevel;
    LErro: TcxLabel;
    LPrograma: TcxLabel;
    Bevel3: TBevel;
    cxLabel2: TcxLabel;
    procedure BtFecharClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FTeladeErro: TFTeladeErro;

implementation

{$R *.DFM}

procedure TFTeladeErro.BtFecharClick(Sender: TObject);
begin
  inherited;
   FTeladeErro.Close;
end;

procedure TFTeladeErro.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
   if KEY = VK_ESCAPE then FTeladeErro.Close;
end;

procedure TFTeladeErro.FormShow(Sender: TObject);
begin
  inherited;
   LPrograma.Caption := REPrograma.Text;
   LErro.Caption     := REErro.Text;
end;

end.


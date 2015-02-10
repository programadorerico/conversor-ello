unit PaiRotinaEll;

interface

uses
  Windows, Classes, Controls, Forms,
  StdCtrls, ExtCtrls, EllBox, Buttons, 
  
  SqlExpr, ComCtrls,
  ADODB, FMTBcd, DB, ToolWin, Graphics;

type
  TFPaiRotinaEll = class(TForm)
    EllBox1: TEllBox;
    EllBox3: TEllBox;
    LTitulo: TLabel;
    PanelPrincipal: TEllBox;
    EllBox5: TEllBox;
    btConfirmar: TButton;
    btCancelar: TButton;
    btSair: TButton;
    QueryTrabalho: TSQLQuery;
    ImageTitulo: TImage;
    ToolBar1: TToolBar;
    SBBotao1: TSpeedButton;
    CDSDados: TADOQuery;
    procedure btSairClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
    procedure ConfereEdicao(Sender: TObject); virtual;
    procedure btConfirmarClick(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  protected
    function  Verificacoes: Boolean; virtual;
  public
    { Public declarations }
  end;

var
  FPaiRotinaEll: TFPaiRotinaEll;

implementation

{$R *.dfm}
uses UDataModule, EllTypes;
var  BuscandoDados :Boolean;

procedure TFPaiRotinaEll.btSairClick(Sender: TObject);
begin
  inherited;
   if BtCancelar.Enabled and BtCancelar.Visible then begin
      if not MensagemEllo('Deseja abandonar os dados digitados ?', tmPergunta) then exit;
   end;
   Self.Close;
end;

procedure TFPaiRotinaEll.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   inherited;
   if Key=VK_Escape then btSairClick(BtSair);
{   if KEY = VK_ESCAPE then begin
      if BtCancelar.Enabled and BtCancelar.Visible then begin
         if Mensagem('Dados digitados serão perdidos, confirma ? ', tmConfirma) then exit;
      end;
      Self.Close;
   end;}
end;

procedure TFPaiRotinaEll.ConfereEdicao(Sender: TObject);
begin
   if BuscandoDados then exit;
   BtConfirmar.Enabled := True;
   BtCancelar.Enabled  := True;
   BtSair.Enabled      := False;
end;

function TFPaiRotinaEll.Verificacoes:Boolean;
begin
   Result := False;
   ActiveControl := nil;
   Result := True;
end;

procedure TFPaiRotinaEll.btConfirmarClick(Sender: TObject);
begin
   BtCancelarClick(BtCancelar);
end;


procedure TFPaiRotinaEll.btCancelarClick(Sender: TObject);
begin
  inherited;
//   LimpaCampo(Self);
   ActiveControl := nil;

   BtConfirmar.Enabled := False;
   BtCancelar.Enabled  := False;
   BtSair.Enabled      := True;

   SelectNext(PanelPrincipal as TWinControl, True, True );
end;

procedure TFPaiRotinaEll.FormShow(Sender: TObject);
begin
  inherited;
   ActiveControl := nil;
   BtConfirmar.Enabled := False;
   BtCancelar.Enabled  := False;
   BtSair.Enabled      := True;

   SelectNext(PanelPrincipal as TWinControl, True, True );
end;

procedure TFPaiRotinaEll.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := caFree;
end;

end.

unit dfMensagem;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ComCtrls, jpeg, dxGDIPlusClasses, 
  cxControls, cxContainer, cxEdit, cxLabel, EllTypes;

type
  TfdtMensagem = class(TForm)
    BtSim: TButton;
    BtOK: TButton;
    BtNao: TButton;
    Bevel2: TBevel;
    BitMapError: TImage;
    BitMapInterrog: TImage;
    BitmapAlerta: TImage;
    cxLabel1: TcxLabel;
    BitMapConfirm: TImage;
    BitMapCancel: TImage;
    BtEsc: TButton;
    Panel1: TPanel;
    BitMapBloqueioCliente: TImage;
    procedure btOKClick(Sender: TObject);
    procedure btSimClick(Sender: TObject);
    procedure btNaoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    TipoMsg  : TTipoMensagem;
    Mensagem : string;
  end;

var
  fdtMensagem : TfdtMensagem;

implementation
uses Utils;

{$R *.DFM}

procedure TfdtMensagem.btOKClick(Sender: TObject);
begin
  tag := 0;
  close;
end;

procedure TfdtMensagem.btSimClick(Sender: TObject);
begin
  tag := 1;
  close;
end;

procedure TfdtMensagem.btNaoClick(Sender: TObject);
begin
  tag := 0;
  close;
end;

procedure TfdtMensagem.FormShow(Sender: TObject);
var Fator1 : Real;
    Fator2 : Real;
begin
  Fator1              := (BtSim.Left / fdtMensagem.Width);
  Fator2              := ((BtNao.Left + BtNao.Width) / fdtMensagem.Width);
  cxLabel1.Caption    := Mensagem;
  fdtMensagem.Height  := cxLabel1.Height + fdtMensagem.Height;
  fdtMensagem.Width   := iif((cxLabel1.Width + BitmapAlerta.Width)>fdtMensagem.Width, (cxLabel1.Width + BitmapAlerta.Width), fdtMensagem.Width) + 10;
  cxLabel1.Align      := alClient;

  BitMapError.Visible             := False;
  BitMapAlerta.Visible            := False;
  BitMapInterrog.Visible          := False;
  BitMapConfirm.Visible           := False;
  BitMapCancel.Visible            := False;
  BitMapBloqueioCliente.Visible   := False;

  btSim.Visible := False;
  btNao.Visible := False;
  btOk.Visible  := False;

  btSim.Left    := Trunc(Self.Width * Fator1);
  btNao.Left    := Trunc(Self.Width * Fator2) - btNao.Width;

  case TipoMsg of
     tmErro : begin
                caption := 'Aviso';
                BitMapError.Visible := true;
                btOk.Visible        := True;
                btOK.SetFocus;
              end;
     tmInforma : begin
                Caption := 'Aviso';
                BitmapAlerta.Visible := true;
                btOk.Visible         := True;
                btOK.SetFocus;
              end;
     tmConfirma : begin
                Caption := 'Ação';
                BitMapConfirm.Visible  := true;
                BtSim.Visible          := true;
                btNao.Visible          := true;
                btSim.SetFocus;
              end;
     tmPergunta : begin
                Caption := 'Ação';
                BitMapInterrog.Visible := true;
                BtSim.Visible          := true;
                btNao.Visible          := true;
                btSim.SetFocus;
              end;
     tmConfirmaN : begin
                Caption := 'Ação';
                BitMapInterrog.Visible := true;
                BtSim.Visible          := true;
                btNao.Visible          := true;
                btNao.SetFocus;
              end;
     tmCancela  : begin
                Caption := 'Ação';
                BitMapCancel.Visible   := true;
                BtSim.Visible          := true;
                btNao.Visible          := true;
                btSim.SetFocus;
              end;
     tmCancelaN : begin
                Caption := 'Cancelamento';
                BitMapCancel.Visible   := true;
                BtSim.Visible          := true;
                btNao.Visible          := true;
                btNao.SetFocus;
              end;
     tmNada : begin
                caption := '';
                btOk.Visible := true;
                btOK.SetFocus;
              end;
     tmEsc  : begin
                Caption := 'Aviso';
                BitMapError.Visible := true;
                btEsc.Visible       := true;
                btEsc.SetFocus;
              end;
     tmBloqueioCliente: begin
                Caption := 'Aviso de bloqueio';
                BitMapBloqueioCliente.Visible := true;
                btOk.Visible         := True;
                btOK.SetFocus;
              end;
   end;
end;

procedure TfdtMensagem.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
   if KEY = VK_ESCAPE then begin
      Tag := 0;
      Close;
   end;
end;

end.


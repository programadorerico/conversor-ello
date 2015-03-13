unit UPrincipal;

interface

uses
  Classes, Controls, Forms, ComCtrls, ExtCtrls, StdCtrls, SqlExpr, dxBarExtItems, dxStatusBar, dxRibbonStatusBar,
  dxRibbon, dxBar, dxRibbonGallery, cxGraphics, FMTBcd, DB, ImgList,
  cxClasses, cxControls;

type
  TFPrincipal = class(TForm)
    ImageList1: TImageList;
    QueryPesquisa: TSQLQuery;
    QueryAux: TSQLQuery;
    IMG48x48: TImageList;
    BarManager: TdxBarManager;
    dxRibbonPopupMenu1: TdxRibbonPopupMenu;
    dxRibbonDropDownGallery1: TdxRibbonDropDownGallery;
    dxBarPopupMenu1: TdxBarPopupMenu;
    ApplicationMenu: TdxBarApplicationMenu;
    FRibbon: TdxRibbon;
    StatusBar1: TdxRibbonStatusBar;
    BarManagerBar1: TdxBar;
    ilSmall: TcxImageList;
    ilLarge: TcxImageList;
    dxBarGroup1: TdxBarGroup;
    dxBarGroup2: TdxBarGroup;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton1: TdxBarButton;
    CustomdxBarCombo1: TCustomdxBarCombo;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    FRibbonTab1: TdxRibbonTab;
    FRibbonTab2: TdxRibbonTab;
    BarManagerBar3: TdxBar;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    dxBarSubItem2: TdxBarSubItem;
    dxBarButton6: TdxBarButton;
    dxBarLargeButton3: TdxBarLargeButton;
    BarManagerBar5: TdxBar;
    dxBarLargeButton4: TdxBarLargeButton;
    dxBarLargeButton5: TdxBarLargeButton;
    dxBarLargeButton6: TdxBarLargeButton;
    dxBarLargeButton7: TdxBarLargeButton;
    dxBarLargeButton8: TdxBarLargeButton;
    dxBarLargeButton9: TdxBarLargeButton;
    dxBarLargeButton10: TdxBarLargeButton;
    dxBarLargeButton11: TdxBarLargeButton;
    dxBarSubItem3: TdxBarSubItem;
    dxBarEdit1: TdxBarEdit;
    BarManagerBar2: TdxBar;
    Label1: TLabel;
    LAviso: TLabel;
    dxBarLargeButton12: TdxBarLargeButton;
    dxBarButton7: TdxBarButton;
    dxBarLargeButton13: TdxBarLargeButton;
    dxBarLargeButton14: TdxBarLargeButton;
    dxBarLargeButton15: TdxBarLargeButton;
    FRibbonTab3: TdxRibbonTab;
    BarManagerBar4: TdxBar;
    dxBarLargeButton16: TdxBarLargeButton;
    dxBarLargeButton17: TdxBarLargeButton;
    dxBarLargeButton18: TdxBarLargeButton;
    dxBarButton8: TdxBarButton;
    dxBarSubItem4: TdxBarSubItem;
    dxBarButton9: TdxBarButton;
    dxBarButton10: TdxBarButton;
    dxBarLargeButton19: TdxBarLargeButton;
    dxBarLargeButton20: TdxBarLargeButton;
    dxBarLargeButton21: TdxBarLargeButton;
    dxBarLargeButton22: TdxBarLargeButton;
    dxBarLargeButton23: TdxBarLargeButton;
    dxBarButton11: TdxBarButton;
    dxBarButton12: TdxBarButton;
    dxBarLargeButton24: TdxBarLargeButton;
    dxBarButton13: TdxBarButton;
    btnMarcas: TdxBarButton;
    dxRibbonGalleryItem1: TdxRibbonGalleryItem;
    dxBarButton15: TdxBarButton;
    dxBarButton16: TdxBarButton;
    dxBarSubItem5: TdxBarSubItem;
    dxBarButton17: TdxBarButton;
    dxBarLargeButton25: TdxBarLargeButton;
    dxBarLargeButton26: TdxBarLargeButton;
    dxBarLargeButton27: TdxBarLargeButton;
    dxBarLargeButton28: TdxBarLargeButton;
    dxBarLargeButton29: TdxBarLargeButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SBSairClick(Sender: TObject);
    procedure BtBaseClick(Sender: TObject);
    procedure BtBotaoClick(Sender: TObject);
    procedure TreeView1Expanding(Sender: TObject; Node: TTreeNode; var AllowExpansion: Boolean);
    procedure ApplicationMenuExtraPaneItemClick(Sender: TObject; AIndex: Integer);
    procedure dxBarLargeButton4Click(Sender: TObject);
  private
    { Private declarations }
    function  ChamaPrograma(Programa: String): Boolean;
  public
    { Public declarations }
    procedure SetColorScheme(const AName: string);
  end;

var
  FPrincipal       :TFPrincipal;
  VALOR            :INTEGER;
  Paulo            :String;
  Valor1           :integer;
  sUsuario         :String;
  Usuario          :String;
  LicenciadoPara   :String;
  ServidorArquivos :String;
  ServidorImagem   :String;
  SkinFile         :String;
  DataBase         :TDateTime;
  MenuAtivo        :Boolean;
  MenuVisible      :Boolean;
  StylePrograma    :TFormBorderStyle;

implementation

uses Utils, UDataModule;

var
    TamanhoMenu: Integer = 280;

{$R *.DFM}

procedure TFPrincipal.FormShow(Sender: TObject);
begin
   with Datam1.ADOQuery do begin
{      Sql.Clear;
      Sql.Add('Select * From Empresa ');
      Open;
      StatusBar1.Panels.Items[1].Text := FieldByName('Nome').AsString;
      StatusBar1.Panels.Items[2].Text := 'Desc';
      StatusBar1.Panels.Items[3].Text := FieldByName('Telefone').AsString;
}      
      StatusBar1.Panels.Items[5].Text := Datam1.sConnection.Params.Values['DataBase'];
   end;
end;

procedure TFPrincipal.FormCreate(Sender: TObject);
begin
   sUsuario := 'PAULO TRIBURTINI';
   Usuario  := 'TRIBURTINI';
end;

procedure TFPrincipal.BtBaseClick(Sender: TObject);
begin
  inherited;
   if assigned(TdxBarLargeButton(Sender).Data) then
//   ProgramaSelecionado(TMenuItem(TdxBarLargeButton(Sender).Data).Programa);
end;


procedure TFPrincipal.SBSairClick(Sender: TObject);
begin
  inherited;
   Application.Terminate;
end;

procedure TFPrincipal.TreeView1Expanding(Sender: TObject; Node: TTreeNode;  var AllowExpansion: Boolean);
begin
  inherited;
   if not Node.Selected then Node.Selected := True;
end;

procedure TFPrincipal.SetColorScheme(const AName: string);
begin
  fRibbon.ColorSchemeName := AName;
  StatusBar1.Invalidate;
end;

procedure TFPrincipal.BtBotaoClick(Sender: TObject);
begin
   SetColorScheme(TdxBarLargeButton(Sender).Hint);
end;

procedure TFPrincipal.ApplicationMenuExtraPaneItemClick(Sender: TObject;  AIndex: Integer);
var fItem: TdxBarExtraPaneItem;
//    fPrograma: TPrograma;
begin
  inherited;
   fItem := ApplicationMenu.ExtraPaneItems[AIndex];
   if fItem.Data>0 then begin
{      fPrograma := fUsuarioLogado.GetPrograma(fItem.Data);
      if Assigned(fPrograma) then
         ProgramaSelecionado(fPrograma);}
   end;
end;

procedure TFPrincipal.dxBarLargeButton4Click(Sender: TObject);
begin
   inherited;
   ChamaPrograma(TdxBarButton(Sender).Description);
end;

function TFPrincipal.ChamaPrograma(Programa: String): Boolean;
var Classe :TFormClass;
    Form   :TForm;

    function UnicaCopia(Classe :TComponentClass) :Boolean;
    var Contador :Integer;
    begin
       UnicaCopia := True;
       for Contador := 0 to (Screen.FormCount - 1) do begin
           if Screen.Forms[Contador] is Classe then begin
              UnicaCopia := False;
              Screen.Forms[Contador].BringToFront;  // mostra programa ja ativo
           end;
       end;
    end;

begin
   Result := False;
   if Programa='' then exit;

   Classe := TFormClass(FindClass('T' + Programa));
   Form   := TForm(Programa);
   if UnicaCopia(Classe) then begin

      Application.CreateForm(Classe, Form);
      Form.Left := Form.Left - 10;

      Form.Top := ((Application.MainForm.Height-Form.height) div 2)-96;
      Form.Top := iif(Form.Top<0,0,Form.Top);

      if Form.BorderStyle in [bsDialog] then begin
         Result := (Form.ShowModal = mrOK);
         Form.Free;
      end else begin
         Form.Show;
         Result := (Form.ModalResult = mrOK);
      end;

   end;

end;


end.



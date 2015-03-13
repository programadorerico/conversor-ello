unit PaiConversor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, Forms,
  PaiRotinaEll, Provider, DB, ComCtrls, UnSql,
  cxMemo, Grids, DBGrids, 
  ExlDBGrid, PtlBox1, SqlExpr, StdCtrls, EllBox, FMTBcd, cxControls,
  cxContainer, cxEdit, cxTextEdit, ADODB, Buttons, ToolWin, Graphics,
  ExtCtrls;

type
  TFPaiConversor = class(TFPaiRotinaEll)
    DataSource: TDataSource;
    EBProdutos: TEllBox;
    PtlBox14: TPtlBox1;
    BtAbrir: TButton;
    Label1: TLabel;
    DBDados: TExlDBGrid;
    BLimpar: TButton;
    BImportar: TButton;
    MError: TcxMemo;
    PtlBox11: TPtlBox1;
    ProgressBar1: TProgressBar;
    EBTampa: TEllBox;
    Label12: TLabel;
    Label11: TLabel;
    BEdita: TButton;
    QueryPesquisa: TSQLQuery;
    QueryPesquisaECO: TSQLQuery;
    DataSetProvider2: TDataSetProvider;
    procedure BtAbrirClick(Sender: TObject);
    procedure BImportarClick(Sender: TObject);
    procedure BLimparClick(Sender: TObject);
    procedure BIniciaClick(Sender: TObject);
    procedure BEditaClick(Sender: TObject);
    procedure ClientDataSetAfterScroll(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure Inicia; virtual;
  protected
    FIdRegistro: Integer;
  public
    { Public declarations }
    Cancelar: Boolean;
    SqlGrava: TQueryGrava;
    procedure AppException(Sender: TObject; E: Exception);
    procedure AntesDeImportar; virtual;
    procedure DepoisDeImportar; virtual;
    procedure LimpaRegistros; virtual;
    procedure ImportaRegistros; virtual;
    procedure Importa; virtual;
    procedure GravaLog(fMsg: String);
    procedure GravaRegistro; virtual; abstract;
    procedure LimpaSngpc;
    procedure Open; virtual;
  end;

var
  FPaiConversor: TFPaiConversor;

implementation

uses Dialogs, UDataModule, EllTypes, Utils, TeladeErro, UPrincipal;

{$R *.dfm}
{$R MenuEll.res}
{$R ExlGridPesquisa.res}

procedure TFPaiConversor.BtAbrirClick(Sender: TObject);
begin
   inherited;
   Open;
end;

procedure TFPaiConversor.BImportarClick(Sender: TObject);
begin
  inherited;
   {if (not CDSDados.Active) or  CDSDados.isEmpty then begin
      MensagemEllo('Não á registros para importação', tmInforma);
      Exit;
   end;}
   Cancelar := False;
   ImportaRegistros;
end;

procedure TFPaiConversor.ImportaRegistros;
begin
   AntesDeImportar;
   try

     {1} Importa;

   except on e:Exception do GravaLog(E.Message);
   end;

   DepoisDeImportar;
end;

procedure TFPaiConversor.GravaLog(fMsg: String);
begin
   MError.Lines.Add(fMsg);
   MError.Refresh;
end;

procedure TFPaiConversor.LimpaRegistros;
begin
   inherited;
   Screen.Cursor := crDefault;
   ShowMessage('Terminou!');
end;

procedure TFPaiConversor.BLimparClick(Sender: TObject);
begin
   inherited;
   Screen.Cursor := crHourGlass;
   Application.ProcessMessages;
   LimpaRegistros;
   Screen.Cursor := crDefault;
end;

procedure TFPaiConversor.BIniciaClick(Sender: TObject);
begin
   Inicia;
end;

procedure TFPaiConversor.Inicia;
begin
   inherited;
   LimpaRegistros;
end;

procedure TFPaiConversor.Importa;
begin
   FIdRegistro := 1;
   CDSDados.First;
   while (not CDSDados.eof) and (not Cancelar) do begin
      try
         GravaRegistro;
      except
      end;
      CDSDados.Next;
      Inc(FIdRegistro);
   end;
end;

procedure TFPaiConversor.DepoisDeImportar;
begin
   DBDAdos.Visible      := True;
   EBTampa.Visible      := False;
   ProgressBar1.Visible := False;
   if MError.Lines.Count>0 then begin
      MensagemEllo('Houve erro na importação dos dados, Verique o Log !!!', tmErro);
   end else begin
      MensagemEllo('Importação concluída com exito !', tmErro);
      CDSDados.Close;
      Application.ProcessMessages;
      Self.Close;
   end;
end;

procedure TFPaiConversor.AntesDeImportar;
begin
   MError.Lines.Clear;
   EBTampa.Left         := 7;
   EBTampa.Top          := 28;
   DBDAdos.Visible      := False;
   EBTampa.Visible      := True;
   ProgressBar1.Visible := True;

   Label11.Caption       := 'Importando registros';
   Label11.Refresh;
end;

procedure TFPaiConversor.BEditaClick(Sender: TObject);
begin
  inherited;
{   try
      Application.CreateForm(TFCVD600AB, FCVD600AB);
      FCVD600AB.MSql.Text := Ado.Sql.Text;
      FCVD600AB.AdoDataSet.ConnectionString := ADO.ConnectionString;
      if FCVD600AB.ShowModal=mrOK then begin
         Ado.Sql.Text := FCVD600AB.MSql.Text;
         ClientDataSet.Close;
      end;
   finally
      FCVD600AB.Free;
   end;}
end;

procedure TFPaiConversor.ClientDataSetAfterScroll(DataSet: TDataSet);
begin
  inherited;
   ProgressBar1.Position := ProgressBar1.Position + 1;
   Label12.Caption       := StrZero(ProgressBar1.Position,6)+ ' / ' + StrZero(ProgressBar1.Max,6);
   Application.ProcessMessages;
end;

procedure TFPaiConversor.LimpaSngpc;
begin
   with QueryTrabalho do begin
      Sql.Clear;
      Sql.Add('Delete From TSngpc');
      ExecSql;

      Sql.Clear;
      Sql.Add('Delete From TEstProdutoMovimento Mvt                             ' +
              'Where Exists (Select IdInventario                                ' +
              '              From   TEstInventario A                            ' +
              '              Where  A.IdInventario = Mvt.IdInventario AND       ' +
              '                     A.Usuario      = ''SNGPC_INVENTARIO'')      ');
      ExecSql;

      Sql.Clear;
      Sql.Add('Delete From TEstInventario Where Usuario = ''SNGPC_INVENTARIO''  ');
      ExecSql;

      Sql.Clear;
      Sql.Add('Delete From TEstProdutoMovimento Mvt                             ' +
              'Where Exists (Select IdInventario                                ' +
              '              From   TEstInventario A                            ' +
              '              Where  A.IdInventario = Mvt.IdInventario AND       ' +
              '                     A.Usuario      = ''SNGPC_ENTRADA'')         ');
      ExecSql;

      Sql.Clear;
      Sql.Add('Delete From TEstInventario Where Usuario = ''SNGPC_ENTRADA''     ');
      ExecSql;

      Sql.Clear;
      Sql.Add('Delete From TEstProdutoLote');
      ExecSql;
   end;
end;

procedure TFPaiConversor.FormCreate(Sender: TObject);
begin
  inherited;
   Application.onException := AppException;
   SqlGrava := TQueryGrava.Create;
end;

procedure TFPaiConversor.AppException(Sender: TObject; E: Exception);
var Arquivo: String;
    Linha: String;
    Texto: TextFile;

    function ExtraiTabela(Texto:String):String;
    var Tabela:String;
    begin
       Tabela := Copy(Texto, Pos('on table',Texto) + 10, 60);
       Tabela := Copy(Tabela, 0, Pos('"', Tabela)-1);
       Result := Tabela;
       with Datam1.QueryPesquisa do begin
          Sql.Clear;
          Sql.Add(Format('Select * From TGerTabelas Where Tabela = %s',[QuotedStr(Tabela)]));
          if QueryOpen(Datam1.QueryPesquisa) then begin
             Result := FieldByName('Descricao').AsString;
          end;
       end;
    end;

    function TrataErro:Boolean;
    begin
       FTeladeErro.REPrograma.Lines.Clear;
       FTeladeErro.REPrograma.Text := E.Message;

       if Pos('FOREIGN KEY', E.Message)>0 then begin
          MensagemEllo('Ação cancelada !!!'+#13#13#10+'Registro relacionado com a tabela de '+ ExtraiTabela(FTeladeErro.REPrograma.Text)+#13#10#10+E.Message,tmErro);
          Result := True;
       end else begin
          Result := False;
       end;
    end;


begin
   with Datam1.sConnection do begin
      if inTransaction then RollBack(TD);
   end;
   Arquivo := 'ERROS.TXT';
   if not FileExists(Arquivo) then begin
      try
         AssignFile(Texto, Arquivo);
         ReWrite(Texto);
      finally
         CloseFile(Texto);
      end;
   end;

   if (E.HelpContext<>0) or (Copy(E.Message,1,4)='VLDT') or (Copy(E.Message,1,6)='VLDNIL') then begin
      Case E.HelpContext of
         1: MensagemEllo(E.Message, tmInforma);
         2: MensagemEllo(E.Message, tmErro);
      else begin
            if (Copy(E.Message,1,4)='VLDT') then begin
               MensagemEllo(Copy(E.Message,5,Length(e.message)), tmInforma);
            end else if (Copy(E.Message,1,6)='VLDNIL') then begin
               // Não mostra mensagem
            end else begin
               MensagemEllo(E.Message, tmInforma);
            end;
         end;
      end;
      Exit;
   end else begin
      AssignFile(Texto, Arquivo);
      Append(Texto);
      Linha := 'Data: ' + DateToStr(Date) + ' ' + TimeToStr(Time) + ' Sistema: ' + Application.MainForm.Name + ' Programa: ' + Screen.ActiveForm.Name + ' Usuário: ' + Usuario;
      try
         WriteLn(Texto, '');
         WriteLn(Texto, Linha);
         WriteLn(Texto, 'Erro: ' +  E.Message);
         Flush(Texto);
      finally
         CloseFile(Texto);
      end;

      Linha := ' Ocorreu uma exceção: ' + Screen.ActiveForm.Name;
      try
         Application.CreateForm(TFTeladeErro, FTeladeErro);
         if not TrataErro then begin
            FTeladeErro.REPrograma.Lines.Clear;
            FTeladeErro.REPrograma.Lines.Add('');
            FTeladeErro.REPrograma.Lines.Add(' Entre em contato com o suporte técnico ');
            FTeladeErro.REPrograma.Lines.Add(' Telefone (66) 3521-2951 ');
            FTeladeErro.REPrograma.Lines.Add('');

            FTeladeErro.REErro.Lines.Clear;
            FTeladeErro.REErro.Lines.Add('');
            FTeladeErro.REErro.Lines.Add('Programa: '+Screen.ActiveForm.Name);
            FTeladeErro.REErro.Lines.Add('');
            FTeladeErro.REErro.Lines.Add(E.Message);

            FTeladeErro.ShowModal;
         end else begin
            FTeladeErro.Free;
         end;
      except
         FTeladeErro.Free;
      end;
   end;
end;

procedure TFPaiConversor.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var Component : TClass;

    function AnalizaComponente(fActiveControl: TWinControl):Boolean;
    begin
       Result := False;
       if Assigned(fActiveControl) then begin
          if TWinControl(fActiveControl).Tag in [10,20] then Result := True;

          if (fActiveControl.ClassType=TcxCustomInnerMemo) then begin
             if (fActiveControl.Parent.ClassType=TcxMemo) then Result := TcxMemo(fActiveControl.Parent).Tag in [10, 20];
          end;
       end;
    end;

begin
   inherited;

   Component := Screen.ActiveControl.ClassType;
   if Key = VK_Return then begin
      if Screen.ActiveControl.Tag IN [10, 20]               then exit;

      if (Component = TDBGrid) or (Component = TExlDBGrid) then begin
         if Screen.ActiveControl.Tag=0 then Exit;
         Perform(Wm_NextDlgCtl, 0, 0);
      end else if (Component = TStringGrid) then begin

         if (Screen.ActiveControl.Tag = 0) then begin
            with TStringGrid(Screen.ActiveControl) do begin
               EditorMode := False;
               if (Col < (ColCount-1)) then begin
                  Col := (Col + 1);
               end else begin
                  if (Row < (RowCount-1)) then begin
                     Row := (Row + 1);
                  end else begin
                     Self.Perform(Wm_NextDlgCtl, 0, 0);
                     Exit;
                  end;
                  Col := FixedCols;
               end;
            end;
         end;

      end  else begin
         Key := 0;
         Perform(Wm_NextDlgCtl, 0, 0);
      end;
   end;

   if Key=VK_ESCAPE then begin
      Self.Close;
   end;
   if (UpperCase(Char(Key)) = 'P') and (ssCtrl in Shift) and (ssShift in Shift) then begin
      MensagemEllo('Programa ativo = ' +  Copy(Screen.ActiveForm.Name, 2, 50), tmInforma);
   end;

   if (Key = VK_LEFT) and (ssCtrl in Shift) and (ssShift in Shift) then begin
       if (Screen.FormCount - 1) > 0 then fPrincipal.Next;
   end;

   if (Key = VK_RIGHT) and (ssCtrl in Shift) and (ssShift in Shift) then begin
       if (Screen.FormCount - 1) > 0 then fPrincipal.Previous;
   end;

   if (UpperCase(Char(Key)) = 'F') and (ssCtrl in Shift) and (ssShift in Shift) then begin
      if Assigned(fPrincipal) then begin
         Screen.ActiveForm.SetFocus;
      end;
   end;
end;

procedure TFPaiConversor.btSairClick(Sender: TObject);
begin
   if Cancelar=False then begin
      Cancelar := True;
   end else begin
      inherited;
   end;
end;

procedure TFPaiConversor.FormShow(Sender: TObject);
begin
  inherited;
   Cancelar := True;
end;

procedure TFPaiConversor.Open;
begin
   ADOOpen(CDSDados);
   Label1.Caption        := 'Registros '+StrZero(CDSDados.RecordCount,6);
   Label1.Visible        := True;
   ProgressBar1.Max      := CDSDados.RecordCount;
   ProgressBar1.Position := 0;
   BImportar.Enabled     := CDSDados.RecordCount>0;
end;

procedure TFPaiConversor.FormDestroy(Sender: TObject);
begin
   FreeAndNil(SqlGrava);
  inherited;
end;

initialization RegisterClass(TFPaiConversor);

end.





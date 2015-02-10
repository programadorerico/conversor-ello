inherited FCVD605AA: TFCVD605AA
  Left = 316
  Top = 98
  Width = 1028
  Height = 449
  Caption = 'Convers'#227'o'
  PixelsPerInch = 96
  TextHeight = 13
  inherited EllBox1: TEllBox
    Width = 1012
    Height = 411
    inherited EllBox3: TEllBox
      Width = 1004
      inherited ImageTitulo: TImage
        Width = 1004
      end
      inherited LTitulo: TLabel
        Width = 936
        Caption = 'Grupos'
      end
    end
    inherited PanelPrincipal: TEllBox
      Width = 1004
      Height = 326
      inherited Label1: TLabel
        Left = 754
      end
      inherited EBProdutos: TEllBox
        Width = 744
        Height = 326
        inherited PtlBox14: TPtlBox1
          Width = 743
          LabelText = 'Grupos'
        end
        inherited DBDados: TExlDBGrid
          Width = 730
          Height = 162
        end
        inherited MError: TcxMemo
          Top = 216
          Width = 732
        end
        inherited PtlBox11: TPtlBox1
          Top = 196
          Width = 730
        end
        inherited EBTampa: TEllBox
          Left = 7
          Top = 24
          Width = 728
          Height = 160
          inherited Label12: TLabel
            Top = 65
            Width = 715
          end
          inherited Label11: TLabel
            Top = 52
            Width = 715
          end
        end
      end
      inherited BtAbrir: TButton
        Left = 751
      end
      inherited BImportar: TButton
        Left = 751
        Top = 288
        Enabled = True
      end
      inherited BEdita: TButton
        Left = 751
      end
    end
    inherited EllBox5: TEllBox
      Top = 364
      Width = 1004
      inherited btConfirmar: TButton
        Left = 903
      end
      inherited btSair: TButton
        Left = 903
      end
      inherited btCancelar: TButton
        Left = 903
      end
      inherited ToolBar1: TToolBar
        Width = 707
      end
      inherited ProgressBar1: TProgressBar
        Width = 885
      end
    end
    inherited BLimpar: TButton
      Left = 755
      Top = 293
    end
  end
end

inherited FCVD601AA: TFCVD601AA
  Width = 1028
  Height = 449
  Caption = 'Unidades de medida'
  PixelsPerInch = 96
  TextHeight = 13
  inherited EllBox1: TEllBox
    Width = 1012
    Height = 410
    inherited EllBox3: TEllBox
      Width = 1004
      inherited ImageTitulo: TImage
        Width = 1004
      end
      inherited LTitulo: TLabel
        Width = 936
        Caption = 'Unidades de Medidas'
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
        inherited DBDados: TExlDBGrid [0]
          Width = 730
          Height = 162
        end
        inherited EBTampa: TEllBox [1]
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
        inherited PtlBox14: TPtlBox1 [2]
          Width = 743
          LabelText = 'Unidades de Medidas'
        end
        inherited MError: TcxMemo [3]
          Top = 216
          Width = 732
        end
        inherited PtlBox11: TPtlBox1 [4]
          Top = 196
          Width = 730
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
      inherited btCancelar: TButton
        Left = 903
      end
      inherited btSair: TButton
        Left = 903
      end
      inherited btConfirmar: TButton
        Left = 903
      end
      inherited ToolBar1: TToolBar
        Top = -1
        Width = 707
      end
      inherited ProgressBar1: TProgressBar
        Width = 885
      end
    end
    inherited BLimpar: TButton
      Left = 755
    end
  end
  inherited CDSDados: TADOQuery
    Top = 272
  end
end

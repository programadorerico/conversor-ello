inherited FCVD602AA: TFCVD602AA
  Left = 312
  Top = 138
  Width = 1028
  Height = 449
  Caption = 'Grupos'
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
          Width = 729
          Height = 161
          inherited Label12: TLabel
            Top = 28
            Width = 716
          end
          inherited Label11: TLabel
            Top = 66
            Width = 716
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
  inherited CDSDados: TADOQuery
    SQL.Strings = (
      'select distinct grupo from produtos'
      'where grupo<>'#39#39
      'order by grupo')
  end
end

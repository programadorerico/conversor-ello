inherited FCVD603AA: TFCVD603AA
  Left = 381
  Top = 147
  Width = 1028
  Height = 449
  Caption = 'Sub-grupos'
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
        Caption = 'Sub-Grupos'
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
          LabelText = 'Sub-Grupos'
        end
        inherited MError: TcxMemo [1]
          Top = 216
          Width = 732
        end
        inherited DBDados: TExlDBGrid [2]
          Top = 27
          Width = 730
          Height = 162
        end
        inherited PtlBox11: TPtlBox1
          Top = 196
          Width = 730
        end
        inherited EBTampa: TEllBox
          Left = 719
          Top = -116
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
      Top = 290
    end
  end
  inherited CDSDados: TADOQuery
    SQL.Strings = (
      'select subgrp as subgrupo, max(grupo) as grupo'
      'from produtos'
      'where '
      #9'subgrp<>'#39#39
      #9'and grupo<>'#39#39
      'group by subgrp'
      'order by subgrp')
  end
end

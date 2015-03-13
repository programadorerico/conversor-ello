inherited FCVD602AA: TFCVD602AA
  Left = 432
  Top = 140
  Height = 449
  Caption = 'Grupos'
  PixelsPerInch = 96
  TextHeight = 13
  inherited EllBox1: TEllBox
    Height = 410
    inherited EllBox3: TEllBox
      inherited LTitulo: TLabel
        Caption = 'Grupos'
      end
    end
    inherited PanelPrincipal: TEllBox
      Height = 326
      inherited EBProdutos: TEllBox
        Height = 326
        inherited PtlBox14: TPtlBox1
          LabelText = 'Grupos'
        end
        inherited DBDados: TExlDBGrid
          Height = 162
        end
        inherited MError: TcxMemo
          Top = 216
        end
        inherited PtlBox11: TPtlBox1
          Top = 196
        end
        inherited EBTampa: TEllBox
          Width = 501
          Height = 161
          inherited Label12: TLabel
            Top = 28
            Width = 488
          end
          inherited Label11: TLabel
            Top = 66
            Width = 488
          end
        end
      end
      inherited BImportar: TButton
        Top = 288
        Enabled = True
      end
    end
    inherited EllBox5: TEllBox
      Top = 364
      inherited btConfirmar: TButton
        Left = 675
      end
      inherited ProgressBar1: TProgressBar
        Width = 657
      end
    end
    inherited BLimpar: TButton
      Top = 293
    end
  end
  inherited ADOQueryOrigem: TADOQuery
    SQL.Strings = (
      'select distinct grupo from estoque')
  end
end

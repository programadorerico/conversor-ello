inherited FCVD200AA: TFCVD200AA
  Left = 298
  Top = 204
  Width = 964
  Height = 494
  Caption = 'Fornecedores'
  PixelsPerInch = 96
  TextHeight = 13
  inherited EllBox1: TEllBox
    Width = 948
    Height = 455
    inherited EllBox3: TEllBox
      Width = 940
      inherited ImageTitulo: TImage
        Width = 940
      end
      inherited LTitulo: TLabel
        Width = 872
        Caption = 'Fornecedores'
      end
    end
    inherited PanelPrincipal: TEllBox
      Width = 940
      Height = 371
      inherited Label1: TLabel
        Left = 690
      end
      inherited EBProdutos: TEllBox
        Width = 680
        Height = 371
        inherited PtlBox14: TPtlBox1
          Width = 679
          Caption = ''
          Color = clGray
          LabelText = 'Fornecedores'
        end
        inherited DBDados: TExlDBGrid
          Width = 666
          Height = 207
        end
        inherited MError: TcxMemo
          Top = 261
          Width = 668
        end
        inherited PtlBox11: TPtlBox1
          Top = 241
          Width = 666
          Color = clGray
        end
        inherited EBTampa: TEllBox
          Left = 646
          Top = -177
          Width = 664
          Height = 205
          inherited Label12: TLabel
            Top = 111
            Width = 651
          end
          inherited Label11: TLabel
            Top = 87
            Width = 651
          end
        end
      end
      inherited BtAbrir: TButton
        Left = 687
      end
      inherited BImportar: TButton
        Left = 687
        Top = 333
      end
      inherited BEdita: TButton
        Left = 687
      end
    end
    inherited EllBox5: TEllBox
      Top = 409
      Width = 940
      inherited btConfirmar: TButton
        Left = 839
      end
      inherited btSair: TButton
        Left = 839
      end
      inherited btCancelar: TButton
        Left = 839
      end
      inherited ToolBar1: TToolBar
        Width = 643
      end
      inherited ProgressBar1: TProgressBar
        Width = 821
      end
    end
    inherited BLimpar: TButton
      Left = 691
      Top = 271
    end
  end
  inherited DataSource: TDataSource
    DataSet = CDSDadosOrigem
    Left = 579
    Top = 84
  end
  inherited QueryOrigem: TSQLQuery
    Left = 547
    Top = 194
  end
  inherited DataSetProvider2: TDataSetProvider
    DataSet = ADOQueryOrigem
    Left = 573
    Top = 124
  end
  inherited ADOQueryOrigem: TADOQuery
    BeforeScroll = nil
    SQL.Strings = (
      'select distinct fornecedor from estoque'
      'where fornecedor<>'#39#39)
    Left = 341
    Top = 312
  end
  inherited CDSDadosOrigem: TClientDataSet
    ProviderName = 'DataSetProvider2'
    AfterScroll = ClientDataSetAfterScroll
    Left = 515
    Top = 123
  end
end

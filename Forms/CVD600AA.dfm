inherited FCVD600AA: TFCVD600AA
  Left = 395
  Top = 123
  Height = 494
  Caption = 'Produtos'
  PixelsPerInch = 96
  TextHeight = 13
  inherited EllBox1: TEllBox
    Height = 455
    inherited EllBox3: TEllBox
      inherited LTitulo: TLabel
        Caption = 'PRODUTOS'
      end
    end
    inherited PanelPrincipal: TEllBox
      Height = 371
      object CBEstoque1: TCheckBox [1]
        Left = 525
        Top = 108
        Width = 244
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Importar estoque negativo'
        TabOrder = 4
      end
      object CBEstoque: TCheckBox [2]
        Left = 525
        Top = 92
        Width = 245
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Importar estoque atual dos produtos'
        Checked = True
        State = cbChecked
        TabOrder = 5
        OnClick = CBEstoqueClick
      end
      inherited EBProdutos: TEllBox
        Height = 371
        inherited DBDados: TExlDBGrid
          Top = 27
          Height = 207
        end
        inherited MError: TcxMemo
          Top = 261
        end
        inherited EBTampa: TEllBox [3]
          Left = 639
          Top = -172
          Width = 500
          Height = 205
          inherited Label12: TLabel
            Top = 111
            Width = 487
          end
          inherited Label11: TLabel
            Top = 87
            Width = 487
          end
        end
        inherited PtlBox11: TPtlBox1 [4]
          Top = 241
        end
      end
      inherited BtAbrir: TButton
        Top = 3
      end
      inherited BImportar: TButton
        Top = 333
      end
    end
    inherited EllBox5: TEllBox
      Top = 409
      inherited btConfirmar: TButton
        Left = 651
      end
      inherited ProgressBar1: TProgressBar
        Width = 657
      end
    end
    inherited BLimpar: TButton
      Top = 339
    end
  end
  inherited QueryTrabalho: TSQLQuery
    Left = 51
    Top = 202
  end
  inherited DataSource: TDataSource
    DataSet = CDSDadosOrigem
    Left = 467
    Top = 76
  end
  inherited QueryPesquisa: TSQLQuery
    SQL.Strings = (
      'Select * From Produtos')
    Left = 147
    Top = 298
  end
  inherited QueryOrigem: TSQLQuery
    Left = 419
    Top = 330
  end
  inherited DataSetProvider2: TDataSetProvider
    DataSet = ADOQueryOrigem
    Constraints = False
    Left = 366
    Top = 132
  end
  inherited ADOQueryOrigem: TADOQuery
    Connection = Datam1.ProdutosConnection
    SQL.Strings = (
      'select empresa, codigo, um, descri'#231#227'o from produtos')
    Top = 188
  end
  object ADOTable1: TADOTable [7]
    Connection = Datam1.ADOConnection
    CursorType = ctStatic
    TableName = 'produto'
    Left = 488
    Top = 160
  end
  inherited CDSDadosOrigem: TClientDataSet
    ProviderName = 'DataSetProvider2'
    Left = 363
    Top = 91
  end
end

inherited FCVD600AA: TFCVD600AA
  Left = 214
  Top = 200
  Width = 964
  Height = 494
  Caption = 'Produtos'
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
        Caption = 'PRODUTOS'
      end
    end
    inherited PanelPrincipal: TEllBox
      Width = 940
      Height = 371
      inherited Label1: TLabel
        Left = 690
      end
      object CBEstoque: TCheckBox [1]
        Left = 689
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
      object CBEstoque1: TCheckBox [2]
        Left = 689
        Top = 108
        Width = 244
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Importar estoque negativo'
        TabOrder = 4
      end
      inherited EBProdutos: TEllBox
        Width = 680
        Height = 371
        inherited PtlBox11: TPtlBox1 [0]
          Top = 241
          Width = 666
        end
        inherited EBTampa: TEllBox [1]
          Left = 639
          Top = -172
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
        inherited PtlBox14: TPtlBox1 [2]
          Width = 679
        end
        inherited DBDados: TExlDBGrid [3]
          Top = 27
          Width = 666
          Height = 207
        end
        inherited MError: TcxMemo [4]
          Top = 261
          Width = 668
        end
      end
      inherited BtAbrir: TButton
        Left = 687
        Top = 3
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
      inherited btCancelar: TButton
        Left = 839
      end
      inherited btSair: TButton
        Left = 839
      end
      inherited btConfirmar: TButton
        Left = 815
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
      Top = 339
    end
  end
  inherited QueryTrabalho: TSQLQuery
    Left = 51
    Top = 202
  end
  inherited DataSource: TDataSource
    Left = 467
    Top = 300
  end
  inherited QueryPesquisa: TSQLQuery
    SQL.Strings = (
      'Select * From Produtos')
    Left = 147
    Top = 298
  end
  inherited DataSetProvider2: TDataSetProvider
    DataSet = CDSDados
    Left = 246
    Top = 300
  end
  inherited CDSDados: TADOQuery
    SQL.Strings = (
      'select '
      '   pro.* ,'
      '   est.saldoatual'
      'from produto pro'
      'left join saldoestoque est on (pro.codproduto=est.codproduto)'
      '')
    Left = 405
    Top = 228
  end
  object ADOTable1: TADOTable
    Connection = Datam1.ADOConnection
    CursorType = ctStatic
    TableName = 'produto'
    Left = 488
    Top = 160
  end
  object CDSProdutos: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DataSetProvider2'
    AfterOpen = CDSProdutosAfterOpen
    BeforeScroll = CDSProdutosBeforeScroll
    Left = 342
    Top = 300
  end
end

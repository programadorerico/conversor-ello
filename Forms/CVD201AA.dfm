inherited FCVD201AA: TFCVD201AA
  Left = 312
  Top = 153
  Width = 964
  Height = 494
  Caption = 'Contas a pagar'
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
        Caption = 'Documentos a Pagar'
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
          Color = clGray
          LabelText = 'Documentos'
        end
        inherited MError: TcxMemo [1]
          Top = 261
          Width = 668
        end
        inherited DBDados: TExlDBGrid [2]
          Top = 24
          Width = 666
          Height = 207
        end
        inherited PtlBox11: TPtlBox1
          Top = 241
          Width = 666
          Color = clGray
        end
        inherited EBTampa: TEllBox
          Left = 646
          Top = -185
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
      inherited btCancelar: TButton
        Left = 839
      end
      inherited btSair: TButton
        Left = 839
      end
      inherited btConfirmar: TButton
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
    Left = 595
    Top = 76
  end
  inherited DataSetProvider2: TDataSetProvider
    DataSet = ADOQueryOrigem
    Left = 597
    Top = 156
  end
  inherited ADOQueryOrigem: TADOQuery
    SQL.Strings = (
      'SELECT '
      '    a.J_XAV,'
      '    a.J_TIT as numero_documento,'
      '    a.J_FOR as fornecedor_codigo,'
      '    a.J_NFO as fornecedor_nome,'
      '    a.J_END as fornecedor_endereco,'
      '    a.J_BAI as fornecedor_bairro,'
      '    a.J_CEP as fornecedor_cep,'
      '    a.J_CID as fornecedor_cidade,'
      '    a.J_EST as fornecedor_uf,'
      '    a.J_CGC as fornecedor_cnpj,'
      '    a.J_EMI as data_emissao,'
      '    a.J_VEN as data_venda,'
      '    a.J_VLR as valor,'
      '    a.J_VPA as valor_parcela,'
      '    a.J_VPG as valor_pago,'
      '    a.J_JRS as juros,'
      '    a.J_DES as desconto,'
      '    a.J_DCD,'
      '    a.J_VCD,'
      '    -- ?? a.J_DIA,'
      '    a.J_DPA as data_pagamento,'
      '    a.J_FLA,'
      '    a.J_CBA,'
      '    a.J_NBA,'
      '    a.J_CCO,'
      '    a.J_NCO,'
      '    a.J_OBS as obs,'
      '    -- ?? a.J_DCA,'
      '    -- ?? a.J_CHE,'
      '    -- ?? a.J_DCH,'
      '    -- ?? a.J_USU,'
      '    -- ?? a.J_LOC,'
      '    -- ?? a.J_UPA,'
      '    a.J_BAS'
      'FROM TITULO a')
    Left = 597
    Top = 208
  end
  inherited CDSDadosOrigem: TClientDataSet
    ProviderName = 'DataSetProvider2'
    Left = 595
    Top = 115
  end
end

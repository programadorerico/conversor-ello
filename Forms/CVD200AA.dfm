inherited FCVD200AA: TFCVD200AA
  Left = 359
  Top = 143
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
    Left = 419
    Top = 316
  end
  inherited CDSDados: TADOQuery
    SQL.Strings = (
      'SELECT'
      '    cast(a.F_COD as integer) as codigo,'
      '    a.F_NOM as nome,'
      '    a.F_END as endereco,'
      '    a.F_BAI as bairro, '
      '    a.F_CEP as cep, '
      '    a.F_CID as cidade, '
      '    a.F_EST as uf, '
      '    '#39'('#39' || a.F_DDD || '#39') '#39' || a.F_TEL as fone, '
      '    '#39'('#39' || a.F_DDD || '#39') '#39' || a.F_TE1 as fax,'
      '    '#39'('#39' || a.F_DDD || '#39') '#39' || a.F_TE2 as contatofone,'
      '    a.F_MAI as email,'
      '    a.F_SIT as homepage,'
      '    a.F_INE as InsEstadual, '
      '    a.F_CGC as CNPJ, '
      '    a.F_CPF as cpf, '
      '    a.F_CON as contato,'
      '    -- ?? a.F_DPC,'
      '    -- ?? a.F_DUC, '
      '    a.F_DCA as DtaCadastro,'
      '    a.F_MUN as CodCidade'
      '    -- ?? a.F_CNA, '
      '    -- ?? a.F_IMU'
      'FROM FORNECEDOR a'
      'order by cast(a.f_cod as integer)')
    Left = 341
    Top = 312
  end
end

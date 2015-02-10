inherited FCVD102AA: TFCVD102AA
  Left = 353
  Top = 171
  Width = 964
  Height = 494
  Caption = 'Contas a Receber'
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
        Caption = 'Documentos a receber'
      end
    end
    inherited PanelPrincipal: TEllBox
      Width = 940
      Height = 371
      object Label2: TLabel [0]
        Left = 690
        Top = 89
        Width = 86
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Cliente Espec'#237'fico'
        Visible = False
      end
      inherited Label1: TLabel
        Left = 690
      end
      inherited EBProdutos: TEllBox
        Width = 680
        Height = 371
        inherited PtlBox14: TPtlBox1
          Width = 679
          LabelText = 'Documentos a receber'
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
        end
        inherited EBTampa: TEllBox
          Left = 622
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
      object Edit1: TEdit
        Left = 688
        Top = 104
        Width = 121
        Height = 21
        TabOrder = 4
        Text = '224'
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
    Left = 433
    Top = 312
  end
  object ADOComissao: TADOQuery [4]
    Connection = Datam1.ADOConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'Select prCodi,'
      '       CodCli,'
      '       Ticket,'
      '       BaCodi,'
      '       Tot_Comis'
      'From   Moviment'
      'Where Tipo='#39'F'#39' '
      'and Cancelado is null'
      'and Quitado is null'
      'order by ticket')
    Left = 212
    Top = 312
    object ADOComissaoprCodi: TStringField
      FieldName = 'prCodi'
      Size = 6
    end
    object ADOComissaoCodCli: TStringField
      FieldName = 'CodCli'
      Size = 8
    end
    object ADOComissaoTicket: TStringField
      FieldName = 'Ticket'
      Size = 6
    end
    object ADOComissaoBaCodi: TStringField
      FieldName = 'BaCodi'
      Size = 6
    end
    object ADOComissaoTot_Comis: TFloatField
      FieldName = 'Tot_Comis'
    end
  end
  inherited CDSDados: TADOQuery
    SQL.Strings = (
      'SELECT '
      '    a.F_NNF as numero_fatura,'
      '    a.F_CLI as cliente_codigo,'
      '    a.F_NCL as cliente_nome,'
      '    a.F_END as cliente_endereco,'
      '    a.F_BAI as cliente_bairro,'
      '    a.F_CEP as cliente_cep,'
      '    a.F_MUN as codigo_ibge,'
      '    a.F_CID as cliente_cidade,'
      '    a.F_EST as cliente_uf,'
      '    a.F_DDD,'
      '    a.F_TEL,'
      '    a.F_INS,'
      '    a.F_CGC,'
      '    a.F_VDE as valor,'
      '    -- ?? a.F_ISS,'
      '    a.F_VCO,'
      '    a.F_VRE as valor_recebido,'
      '    a.F_DFA as data_fatura,'
      '    -- ?? a.F_FIM (C, P),'
      '    a.F_DRE as data_recebimento,'
      '    a.F_TIP as forma_recebimento,'
      '    a.F_DES as desconto,'
      '    -- ?? a.F_PLA,'
      '    -- ?? a.F_VEI,'
      '    -- ?? a.F_NVE,'
      '    -- a.F_FPA,'
      '    a.F_NFP as forma_parcelamento'
      'FROM FATURA a'
      'where a.f_dfa>'#39'01.01.2013'#39
      'order by a.f_dfa desc')
    Left = 357
    Top = 312
  end
end

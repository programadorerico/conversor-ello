inherited FCVD800AA: TFCVD800AA
  Left = 474
  Top = 154
  Width = 964
  Height = 494
  Caption = 'Empreendimentos'
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
        Caption = 'Empreendimentos'
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
          LabelText = 'Empreemdimentos'
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
          Left = 7
          Top = 25
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
end

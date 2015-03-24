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
    Left = 433
    Top = 312
  end
  inherited ADOQueryOrigem: TADOQuery
    SQL.Strings = (
      'select * from contareceber')
    Left = 357
    Top = 312
  end
end

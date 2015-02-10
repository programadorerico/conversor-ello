inherited FCVD101AA: TFCVD101AA
  Left = 350
  Top = 258
  Width = 827
  Height = 439
  Caption = 'Clientes'
  PixelsPerInch = 96
  TextHeight = 13
  inherited EllBox1: TEllBox
    Width = 811
    Height = 400
    OnKeyDown = FormKeyDown
    DesignSize = (
      811
      400)
    inherited EllBox3: TEllBox
      Width = 809
      DesignSize = (
        809
        29)
      inherited ImageTitulo: TImage
        Width = 809
      end
      inherited LTitulo: TLabel
        Width = 741
        Caption = 'Clientes'
      end
    end
    inherited PanelPrincipal: TEllBox
      Width = 809
      Height = 316
      DesignSize = (
        809
        316)
      inherited Label1: TLabel
        Left = 559
      end
      inherited EBProdutos: TEllBox
        Width = 549
        Height = 316
        DesignSize = (
          549
          316)
        inherited PtlBox14: TPtlBox1
          Width = 548
          LabelText = 'Clientes'
        end
        inherited DBDados: TExlDBGrid
          Top = 27
          Width = 535
          Height = 152
        end
        inherited MError: TcxMemo
          Top = 206
          Width = 537
        end
        inherited PtlBox11: TPtlBox1
          Top = 186
          Width = 535
        end
        inherited EBTampa: TEllBox
          Left = 510
          Top = -125
          Width = 535
          Height = 152
          DesignSize = (
            535
            152)
          inherited Label12: TLabel
            Top = 78
            Width = 522
          end
          inherited Label11: TLabel
            Top = 63
            Width = 522
          end
        end
      end
      inherited BtAbrir: TButton
        Left = 556
      end
      inherited BImportar: TButton
        Left = 556
        Top = 278
      end
      inherited BEdita: TButton
        Left = 556
      end
    end
    inherited EllBox5: TEllBox
      Top = 354
      Width = 809
      DesignSize = (
        809
        43)
      inherited btCancelar: TButton
        Left = 708
      end
      inherited btSair: TButton
        Left = 708
      end
      inherited btConfirmar: TButton
        Left = 612
      end
      inherited ToolBar1: TToolBar
        Width = 512
      end
      inherited ProgressBar1: TProgressBar
        Width = 690
      end
    end
    inherited BLimpar: TButton
      Left = 554
      Top = 216
    end
  end
  inherited DataSource: TDataSource
    Left = 427
  end
  inherited QueryPesquisa: TSQLQuery
    Left = 75
    Top = 138
  end
  inherited DataSetProvider2: TDataSetProvider
    Left = 181
    Top = 268
  end
  inherited CDSDados: TADOQuery
    SQL.Strings = (
      'select * from cliente')
    Left = 349
  end
  object ADOTable1: TADOTable
    Connection = Datam1.ADOConnection
    CursorType = ctStatic
    TableName = 'fabricante'
    Left = 448
    Top = 144
  end
end

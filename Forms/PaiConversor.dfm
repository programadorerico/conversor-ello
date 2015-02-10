inherited FPaiConversor: TFPaiConversor
  Left = 310
  Top = 81
  Width = 953
  BorderStyle = bsSizeable
  Caption = 'Conversao'
  Constraints.MinHeight = 356
  Constraints.MinWidth = 553
  Position = poMainFormCenter
  PrintScale = poNone
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited EllBox1: TEllBox
    Width = 937
    DesignSize = (
      937
      407)
    inherited EllBox3: TEllBox
      Width = 929
      DesignSize = (
        929
        29)
      inherited ImageTitulo: TImage
        Width = 929
      end
      inherited LTitulo: TLabel
        Width = 861
        Caption = 'TABELA'
      end
    end
    inherited PanelPrincipal: TEllBox
      Width = 929
      Height = 323
      DesignSize = (
        929
        323)
      object Label1: TLabel
        Left = 679
        Top = 72
        Width = 65
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Qtde registros'
        Visible = False
      end
      object EBProdutos: TEllBox
        Left = 1
        Top = 0
        Width = 669
        Height = 323
        Colors.Enabled = 16776176
        Colors.Disabled = 16776176
        Colors.Focused = 16776176
        Enabled = True
        CaptionPosition = lpTopLeft
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        DesignSize = (
          669
          323)
        object PtlBox14: TPtlBox1
          Tag = 2
          Left = 0
          Top = 0
          Width = 668
          Height = 21
          Caption = ' '
          Color = 15658734
          BevelOuter = bvNone
          Anchors = [akLeft, akTop, akRight]
          Enabled = False
          TabOrder = 0
          ColorEnabled = clGray
          ColorDisabled = clGray
          LabelAlign = LaCenter
          LabelText = 'Produtos'
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWhite
          LabelFont.Height = -11
          LabelFont.Name = 'MS Sans Serif'
          LabelFont.Style = [fsBold]
          BorderWidth = 1
        end
        object DBDados: TExlDBGrid
          Left = 6
          Top = 23
          Width = 655
          Height = 159
          Anchors = [akLeft, akTop, akRight, akBottom]
          Ctl3D = False
          DataSource = DataSource
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgConfirmDelete, dgCancelOnExit]
          ParentCtl3D = False
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clBlack
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
        end
        object MError: TcxMemo
          Left = 5
          Top = 213
          Anchors = [akLeft, akRight, akBottom]
          Lines.Strings = (
            'MError')
          Properties.ScrollBars = ssBoth
          TabOrder = 2
          Height = 105
          Width = 657
        end
        object PtlBox11: TPtlBox1
          Tag = 2
          Left = 6
          Top = 193
          Width = 655
          Height = 21
          Caption = ' '
          Color = 15658734
          BevelOuter = bvNone
          Anchors = [akLeft, akRight, akBottom]
          Enabled = False
          TabOrder = 3
          ColorEnabled = clGray
          ColorDisabled = clGray
          LabelAlign = LaCenter
          LabelText = 'Log Erros'
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWhite
          LabelFont.Height = -11
          LabelFont.Name = 'MS Sans Serif'
          LabelFont.Style = [fsBold]
          BorderWidth = 1
        end
        object EBTampa: TEllBox
          Left = 6
          Top = 23
          Width = 655
          Height = 159
          Colors.Enabled = 15527920
          Colors.Disabled = 15527920
          Colors.Focused = 15527920
          Enabled = True
          CaptionPosition = lpCenterCenter
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 4
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Visible = False
          DesignSize = (
            655
            159)
          object Label12: TLabel
            Left = 23
            Top = 27
            Width = 642
            Height = 29
            Alignment = taCenter
            Anchors = [akLeft, akRight]
            AutoSize = False
            Caption = 'Progress'#227'o'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -24
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label11: TLabel
            Left = 7
            Top = 65
            Width = 642
            Height = 16
            Alignment = taCenter
            Anchors = [akLeft, akRight]
            AutoSize = False
            Caption = 'Tipo a'#231#227'o'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
      end
      object BtAbrir: TButton
        Left = 676
        Top = 2
        Width = 247
        Height = 30
        Anchors = [akTop, akRight]
        Caption = 'Abrir'
        ModalResult = 1
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = BtAbrirClick
      end
      object BImportar: TButton
        Left = 676
        Top = 285
        Width = 247
        Height = 30
        Anchors = [akRight, akBottom]
        Caption = 'Importar'
        Enabled = False
        ModalResult = 1
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = BImportarClick
      end
      object BEdita: TButton
        Left = 676
        Top = 34
        Width = 247
        Height = 30
        Anchors = [akTop, akRight]
        Caption = 'Editar SQL'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = BEditaClick
      end
    end
    inherited EllBox5: TEllBox
      Top = 361
      Width = 929
      DesignSize = (
        929
        43)
      inherited btCancelar: TButton [0]
        Left = 828
        Visible = False
      end
      inherited btSair: TButton [1]
        Left = 828
      end
      inherited btConfirmar: TButton [2]
        Left = 732
        Visible = False
      end
      inherited ToolBar1: TToolBar
        Width = 632
      end
      object ProgressBar1: TProgressBar
        Left = 8
        Top = 10
        Width = 811
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 4
        Visible = False
      end
    end
    object BLimpar: TButton
      Left = 680
      Top = 288
      Width = 247
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Limpar registros'
      ModalResult = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = BLimparClick
    end
  end
  inherited QueryTrabalho: TSQLQuery
    Left = 59
  end
  object DataSource: TDataSource [2]
    DataSet = CDSDados
    Left = 451
    Top = 268
  end
  object QueryPesquisa: TSQLQuery [3]
    MaxBlobSize = -1
    Params = <>
    SQLConnection = Datam1.sConnection
    Left = 83
    Top = 170
  end
  object QueryPesquisaECO: TSQLQuery [4]
    MaxBlobSize = -1
    Params = <>
    SQLConnection = Datam1.ConnectionOrigem
    Left = 179
    Top = 162
  end
  object DataSetProvider2: TDataSetProvider [5]
    Left = 157
    Top = 276
  end
  inherited CDSDados: TADOQuery
    BeforeScroll = ClientDataSetAfterScroll
    SQL.Strings = (
      'select distinct '
      '    cast(c_cod as integer) as codigo,'
      '    c_nom as nome_grupo'
      'from grupo')
    Left = 373
    Top = 264
  end
end

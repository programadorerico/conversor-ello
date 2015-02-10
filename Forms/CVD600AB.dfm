inherited FCVD600AB: TFCVD600AB
  Left = 621
  Top = 421
  Width = 753
  Height = 360
  BorderStyle = bsSizeable
  Caption = 'SQL'
  PixelsPerInch = 96
  TextHeight = 13
  inherited EllBox1: TEllBox
    Width = 737
    Height = 322
    inherited ImageTitulo: TImage
      Width = 729
    end
    inherited LTitulo: TLabel
      Width = 522
      Caption = 'Instru'#231#227'o SQL'
    end
    inherited PanelPrincipal: TEllBox
      Width = 729
      Height = 240
      object MSql: TcxMemo
        Left = -1
        Top = -1
        Anchors = [akLeft, akTop, akRight, akBottom]
        Lines.Strings = (
          'MError')
        Properties.ScrollBars = ssBoth
        Properties.OnChange = MSqlPropertiesChange
        TabOrder = 0
        Height = 241
        Width = 574
      end
      object BTestar: TButton
        Left = 576
        Top = 3
        Width = 149
        Height = 30
        Anchors = [akTop, akRight]
        Caption = '&Testar'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = BTestarClick
      end
    end
    inherited EllBox5: TEllBox
      Top = 278
      Width = 729
      inherited btCancelar: TButton [0]
        Left = 532
        Visible = False
      end
      inherited btConfirmar: TButton [1]
        Left = 532
      end
      inherited btSair: TButton
        Left = 628
      end
      inherited ToolBar1: TToolBar
        Width = 422
      end
    end
  end
  object ADOAux: TADOQuery
    ConnectionString = 'FILE NAME=D:\Triburtini\Financas\Dados\SuperPao.udl'
    CursorType = ctStatic
    Parameters = <>
    Left = 424
    Top = 120
  end
end

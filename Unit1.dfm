object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Snake Game'
  ClientHeight = 400
  ClientWidth = 335
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 15
  object PanelControl: TPanel
    Left = 0
    Top = 0
    Width = 335
    Height = 60
    Align = alTop
    Caption = 'PanelControl'
    Color = clBlack
    ParentBackground = False
    TabOrder = 0
    object ScoreLabel2: TLabel
      Left = 56
      Top = 16
      Width = 9
      Height = 21
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object ScoreLabel: TLabel
      Left = 8
      Top = 16
      Width = 42
      Height = 21
      Caption = 'Score:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object HighScoreLabel: TLabel
      Left = 112
      Top = 16
      Width = 79
      Height = 21
      Caption = 'High Score:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object HighScoreLabel2: TLabel
      Left = 197
      Top = 16
      Width = 9
      Height = 21
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
  end
  object PanelPlace: TPanel
    Left = 0
    Top = 60
    Width = 335
    Height = 340
    Align = alClient
    Caption = 'PanelPlace'
    Color = clBlack
    ParentBackground = False
    TabOrder = 1
    ExplicitTop = 66
    object SnakeHead: TShape
      Left = 80
      Top = 120
      Width = 20
      Height = 20
    end
    object Apple: TShape
      Left = 240
      Top = 120
      Width = 20
      Height = 20
      Brush.Color = clRed
      Shape = stCircle
    end
  end
  object Timer: TTimer
    Interval = 120
    OnTimer = TimerTimer
    Left = 304
    Top = 8
  end
  object Timer2: TTimer
    Interval = 1
    OnTimer = Timer2Timer
    Left = 256
    Top = 8
  end
end

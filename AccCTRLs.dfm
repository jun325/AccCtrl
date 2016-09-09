object JColorPickFrm2: TJColorPickFrm2
  Left = 343
  Top = 273
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 206
  ClientWidth = 176
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS UI Gothic'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 12
  object Shape1: TShape
    Left = 0
    Top = 0
    Width = 176
    Height = 206
    Align = alClient
    Brush.Style = bsClear
    Pen.Color = clBtnShadow
  end
  object BtnOther: TButton
    Left = 115
    Top = 176
    Width = 57
    Height = 25
    Caption = '&Others...'
    TabOrder = 0
    OnClick = BtnOtherClick
  end
  object ColorDialog1: TColorDialog
    Left = 80
    Top = 144
  end
end

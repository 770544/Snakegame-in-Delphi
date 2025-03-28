unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.Generics.Collections,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, dxSkinsCore, dxSkinBasic, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkroom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinOffice2019Black, dxSkinOffice2019Colorful, dxSkinOffice2019DarkGray,
  dxSkinOffice2019White, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringtime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinTheBezier,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, cxLabel, Vcl.Menus, ShellAPI, System.IOUtils;

type
  TForm1 = class(TForm)
    PanelControl: TPanel;
    ScoreLabel2: TLabel;
    ScoreLabel: TLabel;
    PanelPlace: TPanel;
    Timer: TTimer;
    SnakeHead: TShape;
    Apple: TShape;
    Timer2: TTimer;
    HighScoreLabel: TLabel;
    HighScoreLabel2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Timer2Timer(Sender: TObject);
    procedure MoveSnake(X : integer; Y : integer);
    procedure CopySnake(SourceShape: TShape; Parent: TWinControl);
    procedure ChangeAppleLocation;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  SnakeBody : TList<integer>; // 뱀의 몸통을 제어
  SnakeLength : integer;
  Score : integer;
  Direction : String; // 방향- R(우), L(좌), U(상), D(하)
  GameOver : boolean;
  AppleLeft : integer;
  AppleTop : integer;
  // Speed : Double;
  arrX : Array [0..1000] of Integer;
  arrY : Array [0..1000] of Integer;
  arrS : Array [0..1000] of TShape;
  BX : integer;
  BY : integer;
  Turn : Boolean;
  Ranking : TStringList;
  DocumentsPath : string;
  FileName : string;
  FilePath : string;
implementation

{$R *.dfm}

procedure TForm1.ChangeAppleLocation;
var
  i : integer;
begin
  Randomize;
  AppleLeft := (Random(15)) * 20; // 0부터 14까지의 값, 20의 배수, 최대 280
  Randomize;
  AppleTop := (Random(13)) * 20; // 0부터 12까지의 값, 20의 배수, 최대 240

  for I := 1 to SnakeLength do
  begin
    if ((arrS[i].Left = AppleLeft) and (arrS[i].Top = AppleTop)) or ((SnakeHead.Left = AppleLeft) and (SnakeHead.Top = AppleTop)) then
      ChangeAppleLocation;
  end;

end;

procedure TForm1.CopySnake(SourceShape: TShape; Parent: TWinControl);
var
  NewBody : TShape;
begin
  NewBody := TShape.Create(Parent);
  NewBody.Parent := Parent;  // Parent가 TWinControl이어야 합니다.
  NewBody.Left := BX;
  Newbody.Top := BY;
  Newbody.Brush.Color := clWhite;
  arrS[SnakeLength] := NewBody;
  arrS[SnakeLength].Shape := SnakeHead.Shape;
  arrS[SnakeLength].Height := 20;
  arrS[SnakeLength].Width	:= 20;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SnakeLength := 0;
  Score := 0;
  Direction := 'R';
  Turn := False;
  GameOver := False;
  BorderStyle := bsDialog;
  AppleLeft := 21;
  AppleTop := 21;

  SnakeHead.Left := 80;
  SnakeHead.Top := 120;
  Apple.Left := 200;
  Apple.Top := 120;

  DocumentsPath := TPath.Combine(GetEnvironmentVariable('USERPROFILE'), 'Documents');
  FileName := 'Ranking.txt';
  FilePath := TPath.Combine(DocumentsPath, 'Ranking.txt');
  Ranking := TStringList.Create;

  if not FileExists(FilePath) then
  begin
    Ranking.Add('1');
    Ranking.SaveToFile(FilePath)
  end;

  Ranking.LoadFromFile(FilePath);
  HighScoreLabel2.Caption :=  Ranking[0];

  SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I: Integer;
  ExeFileName: string;
begin
  if Key = VK_Left then
  begin
    if (Direction <> 'R') and (Turn = False) then
    begin
      Direction := 'L';
      Turn := True;
    end;
  end;

  if Key = VK_Right then
  begin
    if (Direction <> 'L') and (Turn = False) then
    begin
      Direction := 'R';
      Turn := True;
    end;
  end;

  if Key = VK_Up then
  begin
    if (Direction <> 'D') and (Turn = False) then
    begin
      Direction := 'U';
      Turn := True;
    end;
  end;

  if Key = VK_Down then
  begin
    if (Direction <> 'U') and (Turn = False) then
    begin
      Direction := 'D';
      Turn := True;
    end;
  end;

  if Key = Ord('R') then  // 리셋
  begin
    ExeFileName := ParamStr(0);  // 현재 실행 중인 실행 파일 이름을 가져옴
    ShellExecute(0, 'open', PChar(ExeFileName), nil, nil, SW_SHOWNORMAL);
    Application.Terminate;  // 현재 프로그램 종료
  end;

end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Form1.Width := 335;
  Form1.Height := 360;

  sleep(100);
  PostMessage(Self.Handle, WM_SETFOCUS, 0, 0);
  Application.ProcessMessages;
end;

procedure TForm1.MoveSnake(X: integer; Y: integer);
var
  i : integer;
begin

    for I := (SnakeLength) downto 1 do
    begin
      arrX[i] := arrX[i-1];
      arrY[i] := arrY[i-1];
      arrS[i].Left := arrX[i];
      arrS[i].Top	:= arrY[i];
    end;

    arrX[0] := arrX[0] + (X);
    arrY[0] := arrY[0] + (Y);
    SnakeHead.Left := arrX[0];
    SnakeHead.Top := arrY[0];

end;

procedure TForm1.Timer2Timer(Sender: TObject);
// 판정용 타이머
begin
  if GameOver = False then
  begin
    if (SnakeHead.Left < 0) or (SnakeHead.Left > 300) or (SnakeHead.Top < 0) or (SnakeHead.Top > 240) then
    // 벽에 닿았다면
    begin
      GameOver := True;
    end;
  end;

  if GameOver = True then
  begin
    Timer.Enabled	:= False;
    Timer2.Enabled := False;

    if StrToInt(Ranking[0]) < Score then
    begin
      Ranking[0] := IntToStr(Score);
      Ranking.SaveToFile(FilePath);
      HighScoreLabel2.Caption :=  Ranking[0];
    end;
  end;
end;

procedure TForm1.TimerTimer(Sender: TObject);
var
  i : integer;
begin
    arrX[0] := SnakeHead.Left;
    arrY[0] := SnakeHead.Top;

    if (GameOver = False) then
    begin
      if Direction = 'R'then
      begin
        if (SnakeLength = 0) then
        begin
          BX := arrX[SnakeLength];
          SnakeHead.Left := SnakeHead.Left + 20;
          Turn := False;
        end else
          begin
            BX := arrX[SnakeLength];
            MoveSnake(20, 0);
            Turn := False;
        end;
      end;

      if (Direction = 'L') then
      begin
        if (SnakeLength = 0) then
        begin
          BX := arrX[SnakeLength];
          SnakeHead.Left := SnakeHead.Left -20;
          Turn := False;
        end else
        begin
          BX := arrX[SnakeLength];
          MoveSnake(-20, 0);
          Turn := False;
        end;
        end;

      if (Direction = 'U')  then
      begin
          if (SnakeLength = 0) then
          begin
            BY := arrY[SnakeLength];
            SnakeHead.Top := SnakeHead.Top - 20;
            Turn := False;
          end else
          begin
            BY := arrY[SnakeLength];
            MoveSnake(0, -20);
            Turn := False;
          end;
        end;

      if (Direction = 'D') then
      begin
        if (SnakeLength = 0) then
        begin
          BY := arrY[SnakeLength];
          SnakeHead.Top := SnakeHead.Top + 20;
          Turn := False;
        end else
        begin
          BY := arrY[SnakeLength];
          MoveSnake(0, 20);
          Turn := False;
        end;
      end;
    end;

    if SnakeLength <> 0 then
    begin
      for I := 1 to SnakeLength do
      begin
        if (SnakeHead.Left = arrS[i].Left) and (SnakeHead.Top = arrS[i].Top) then
          GameOver := True;
      end;
    end;

    if (SnakeHead.Left = Apple.Left) and (SnakeHead.Top = Apple.Top) then // 사과에 닿았다면
    begin
      Score := Score + 1;
      ScoreLabel2.Caption := IntToStr(Score);

      ChangeAppleLocation;
      Apple.Left := AppleLeft;
      Apple.Top := AppleTop;
      SnakeLength := SnakeLength + 1;
      CopySnake(SnakeHead, PanelPlace);
    end;
end;
end.

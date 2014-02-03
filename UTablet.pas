unit UTablet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FileCtrl, StdCtrls, ExtCtrls, MMSystem, ShellApi, Menus;

type
  TFTablet = class(TForm)
    FileListBox: TFileListBox;
    DirectoryListBox: TDirectoryListBox;
    ImgNext: TImage;
    imgPrior: TImage;
    imgLimpa: TImage;
    imgUp: TImage;
    PanColor: TPanel;
    ColorBox: TColorBox;
    PopupMenuColor: TPopupMenu;
    MISelecionarCor: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ImgNextClick(Sender: TObject);
    procedure imgLimpaClick(Sender: TObject);
    procedure imgPriorClick(Sender: TObject);
    procedure imgUpClick(Sender: TObject);
    procedure MISelecionarCorClick(Sender: TObject);
    procedure ColorBoxClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    procedure pCor;
    procedure pNext;
    procedure pPrior;
    procedure pLimpa;
    procedure pResize(i: byte);
  public
    { Public declarations }
  end;

var
  FTablet: TFTablet;
  Imgs : Array of TImage;
const
  Pasta = String('img');
  Lin = Integer(2);
  Col = Integer(3);
  Num = Integer(Lin * Col);
  Up = String('_Up.bmp');
  Som = String('C:\Windows\System32\SoundRecorder.exe');
  Ext = String('.wav');
  Cor = String('Cor.ini');

implementation

{$R *.dfm}

procedure TFTablet.pLimpa;
var i : byte;
begin
    for i := 0 to Num - 1 do
    begin
        Imgs[i].Picture := imgLimpa.Picture;
        Imgs[i].OnClick := imgLimpa.OnClick;
        Imgs[i].Hint := '';
    end;
end;

procedure TFTablet.pNext;
var i, j : byte;
begin
    pCor;
    pLimpa;
    if FileListBox.items.Count > 0 then
    begin
        j := FileListBox.ItemIndex;
        if FileListBox.ItemIndex >= Num - 2 Then
        begin
            Imgs[0].Picture := ImgPrior.Picture;
            Imgs[0].OnClick := imgPrior.OnClick;
            i := 1;
        end
        else
            i := 0;
        repeat
            FileListBox.ItemIndex := FileListBox.ItemIndex + 1;
            if (FileListBox.Items.Strings[FileListBox.ItemIndex] = UP) and (not (FileExists(FileListBox.Items.Strings[FileListBox.ItemIndex]))) then
            begin
                Imgs[i].Picture := imgUp.Picture;
                Imgs[i].Hint := imgUp.Hint;
                Imgs[i].OnClick := imgUp.OnClick;
            end
            else
            begin
                if FileListBox.Items.Strings[FileListBox.ItemIndex] = UP then
                    Imgs[i].OnClick := imgUp.OnClick;
                Imgs[i].Picture.LoadFromFile(FileListBox.Items.Strings[FileListBox.ItemIndex]);
                Imgs[i].Hint := FileListBox.Items.Strings[FileListBox.ItemIndex];
            end;
            Inc(j);
            Inc(i);
        until (i = Num) or (FileListBox.ItemIndex = FileListBox.Items.Count - 1);

        if (FileListBox.ItemIndex < FileListBox.Items.Count - 1) and (i <= num) then
        begin
           FileListBox.ItemIndex := FileListBox.ItemIndex - 1;
           Imgs[Num - 1].Picture := ImgNext.Picture;
           Imgs[Num - 1].OnClick := ImgNext.OnClick;
        end;
    end;
end;

procedure TFTablet.pPrior;
var i, j : byte;
    tem : boolean;
begin
    pCor;
    if FileListBox.items.Count > 0 then
    begin
        for i := Num  - 1 downto 0 do
            if Imgs[i].Hint <> '' then
                FileListBox.ItemIndex := FileListBox.ItemIndex - 1;
        j := FileListBox.ItemIndex;
        tem := false;
        if FileListBox.Items.Count >= Num Then
        begin
            Imgs[5].Picture := ImgNext.Picture;
            Imgs[5].OnClick := ImgNext.OnClick;
            i := 4;
            FileListBox.ItemIndex := FileListBox.ItemIndex + 1;
            tem := true;
        end
        else
            i := 5;

        repeat
            FileListBox.ItemIndex := FileListBox.ItemIndex - 1;
            Imgs[i].Picture.LoadFromFile(FileListBox.Items.Strings[FileListBox.ItemIndex]);
            Imgs[i].Hint := FileListBox.Items.Strings[FileListBox.ItemIndex];
            Imgs[i].OnClick := imgLimpa.OnClick;
            Dec(j);
            Dec(i);
        until (i = -1) or (FileListBox.ItemIndex =  0);

        if tem then
            FileListBox.ItemIndex := 4;
        {if (FileListBox.ItemIndex < FileListBox.Items.Count - 1) and (i <= num) then
        begin
           FileListBox.ItemIndex := FileListBox.ItemIndex - 1;
           Imgs[Num - 1].Picture := ImgNext.Picture;
           Imgs[Num - 1].OnClick := ImgNext.OnClick;
        end;}
    end;
end;

procedure TFTablet.FormCreate(Sender: TObject);
var Dir : String;
begin
   Dir := ExtractFilePath(Application.ExeName) + '\' + Pasta;
   if not DirectoryExists(Dir) then
       CreateDir(Dir);
   DirectoryListBox.Directory := Dir;
end;

procedure TFTablet.FormShow(Sender: TObject);
var i : byte;
begin
    SetLength(Imgs, Num);
    for i := 0 to Num - 1 do
    begin
        Imgs[i] := TImage.Create(Self);
        with Imgs[i] do
        begin
            Imgs[i].Parent := Self;
            Imgs[i].Visible := True;
            Imgs[i].Stretch := true;
            Imgs[i].Name :=  'Img' + IntToStr(i + 1);

            {Imgs[i].Height := Trunc(Self.Height / Lin) - 30;
            Imgs[i].Width := Trunc(Self.Width / Col) - 39;
            if i < Num / Lin then
                Imgs[i].Top := 10
            else
                Imgs[i].Top := Imgs[0].Height + 20;

            if i <= Num / Col then
                Imgs[i].Left := i * Imgs[i].Width + (i * 10) + 10
            else
                Imgs[i].Left := Imgs[i - Col].Left;}
            pResize(i);

            Imgs[i].OnClick := imgLimpa.OnClick;
        end;
    end;
    imgUp.Picture := imgPrior.Picture;
    FileListBox.ItemIndex := -1;
    pNext;
end;

procedure TFTablet.ImgNextClick(Sender: TObject);
begin
    pNext;
end;


procedure TFTablet.imgLimpaClick(Sender: TObject);
const Tmp = Byte(3);
var fW : string;
 errorcode: integer;
begin
//   showmessage((Sender as TImage).Hint);
   if (Sender as TImage).Hint <> '' then
   begin
       fW := DirectoryListBox.Directory + '\' + ExtractFileName((Sender as TImage).Hint) + Ext;
       showmessage(fW);
       if FileExists(fW) then
            PlaySound(PChar(fW), 1, SND_ASYNC)
       else
       begin
           //C:\Windows\System32>SoundRecorder.exe /FILE d:\a.wav /FILETYPE WAVE /DURATION 0000:00:10
           //showmessage(Som + ' /FILE "' + fW + '" /FILETYPE WAVE /DURATION 0000:00:0' + IntToStr(Tmp));
           //"C:\Windows\System32\SoundRecorder.exe" /FILE "D:\Delphi\Tablet\img\brincar.bmp.wav" /FILETYPE WAVE /DURATION 0000:00:03
           //errorcode :=
           ShellExecute(0, 'open', pchar(PChar(Som + ' /FILE ' + fW + ' /FILETYPE WAVE /DURATION 0000:00:0' + IntToStr(Tmp))), nil, nil, SW_NORMAL);
           //errorcode :=  ShellExecute(0, 'open', (Som), nil, nil, SW_NORMAL);
           {case errorcode of
            2:showmessage('file not found');
            3:showmessage('path not found');
            5:showmessage('access denied');
            8:showmessage('not enough memory');
            32:showmessage('dynamic-link library not found');
            26:showmessage('sharing violation');
            27:showmessage('filename association incomplete or invalid');
            28:showmessage('DDE request timed out');
            29:showmessage('DDE transaction failed');
            30:showmessage('DDE busy');
            31:showmessage('no application associated with the given filename extension');
           end;}
           Sleep((Tmp + 1) * 1000);
           PlaySound(PChar(fW), 1, SND_ASYNC)
       end;
       if DirectoryExists(DirectoryListBox.Directory + '\' + Copy((Sender as TImage).Hint, 0, Length((Sender as TImage).Hint) - 4) + '\') then
       begin
            DirectoryListBox.Directory := DirectoryListBox.Directory + '\' + Copy((Sender as TImage).Hint, 0, Length((Sender as TImage).Hint) - 4) + '\';
            if FileListBox.Items.Strings[0] <> Up then
                FileListBox.Items.Insert(0, Up);
            if not FileExists(DirectoryListBox.Directory + '\' + Up) then
            begin
                imgUp.Picture.SaveToFile(DirectoryListBox.Directory + '\' + Up);
            end;
            pNext;
       end;
   end;
end;

procedure TFTablet.imgPriorClick(Sender: TObject);
begin
    pPrior;
end;

procedure TFTablet.imgUpClick(Sender: TObject);
begin
    DirectoryListBox.ItemIndex := DirectoryListBox.ItemIndex - 1;
    DirectoryListBox.OpenCurrent;
    pNext;
end;

procedure TFTablet.pCor;
var i : Integer;
begin
    Self.Color := clWhite; 
    for i := 0 to ColorBox.Items.Count - 1 do
        if FileExists(DirectoryListBox.Directory + '\cl' + ColorBox.Items.Strings[i]) then
            Self.Color := StringToColor('cl' + Colorbox.Items[i]);
end;

procedure TFTablet.MISelecionarCorClick(Sender: TObject);
begin
    PanColor.Visible := not PanColor.Visible;
end;

procedure TFTablet.ColorBoxClick(Sender: TObject);
var f : PChar;
begin
    f := pChar(DirectoryListBox.Directory + '\' + ColorToString(FTablet.Color));
    if FileExists(f) then
        DeleteFile(f);
    FTablet.Color := ColorBox.Selected;
    f := pChar(DirectoryListBox.Directory + '\' + ColorToString(FTablet.Color));
    if not FileExists(f) then
        Windows.CreateFile(f, GENERIC_WRITE, 0, 0, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
    PanColor.Visible := False;
end;

procedure TFTablet.FormResize(Sender: TObject);
var i: byte;
begin
    for i := 0 to Num - 1 do
        pResize(i);
end;

procedure TFTablet.pResize(i: byte);
begin
    with Imgs[i] do
    begin
        Imgs[i].Height := Trunc(Self.Height / Lin) - 30;
        Imgs[i].Width := Trunc(Self.Width / Col) - 39;

        if i < Num / Lin then
            Imgs[i].Top := 10
        else
            Imgs[i].Top := Imgs[0].Height + 20;

        if i <= Num / Col then
            Imgs[i].Left := i * Imgs[i].Width + (i * 10) + 10
        else
            Imgs[i].Left := Imgs[i - Col].Left;
    end;
end;

end.

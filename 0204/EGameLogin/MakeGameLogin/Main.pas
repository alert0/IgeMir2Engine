unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, bsSkinData, BusinessSkinForm,
  bsSkinCtrls, RzTabs, ComCtrls, ExtCtrls, RzPanel, RzLabel,
  Mask, bsSkinBoxCtrls, RzEdit, RzListVw, Inifiles, bsMessages,
  RzRadGrp, bsSkinShellCtrls, CommDlg, DBTables, RzButton, 
  bsDialogs, Menus, bsSkinMenus, RzBHints;

type
  TMainFrm = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    bsSkinData1: TbsSkinData;
    bsCompressedStoredSkin1: TbsCompressedStoredSkin;
    RzPageControl1: TRzPageControl;
    TabSheet1: TRzTabSheet;
    TabSheet2: TRzTabSheet;
    TabSheet3: TRzTabSheet;
    TabSheet4: TRzTabSheet;
    RzGroupBox1: TRzGroupBox;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    RzLabel3: TRzLabel;
    bsSkinButton1: TbsSkinButton;
    bsSkinButton2: TbsSkinButton;
    LnkEdt: TRzEdit;
    GameListURLEdt: TRzEdit;
    PatchListURLEdt: TRzEdit;
    RzGroupBox2: TRzGroupBox;
    RzGroupBox3: TRzGroupBox;
    RzGroupBox4: TRzGroupBox;
    RzLabel4: TRzLabel;
    ComboBox1: TbsSkinComboBox;
    AddArrayBtn: TbsSkinButton;
    DelArrayBtn: TbsSkinButton;
    ListView1: TbsSkinListView;
    RzPanel1: TRzPanel;
    AddGameList: TbsSkinButton;
    ChangeGameList: TbsSkinButton;
    DelGameList: TbsSkinButton;
    bsSkinButton8: TbsSkinButton;
    bsSkinButton9: TbsSkinButton;
    Memo1: TbsSkinMemo;
    FileTypeRadioGroup: TRzRadioGroup;
    RzLabel5: TRzLabel;
    DirComBox: TbsSkinComboBox;
    RzLabel6: TRzLabel;
    FileNameEdt: TRzEdit;
    RzLabel7: TRzLabel;
    DownAddressEdt: TRzEdit;
    bsSkinOpenDialog1: TbsSkinOpenDialog;
    RzLabel8: TRzLabel;
    Md5Edt: TRzEdit;
    OpenFileBtn: TbsSkinButton;
    SavePatchListBtn: TbsSkinButton;
    bsSkinButton5: TbsSkinButton;
    LoadPatchListBtn: TbsSkinButton;
    RzLabel9: TRzLabel;
    LoadPatchFileOpenDialog: TbsSkinOpenDialog;
    RzLabel10: TRzLabel;
    ClientFileEdt: TRzEdit;
    TabSheet5: TRzTabSheet;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ListBoxitemList: TbsSkinListBox;
    bsSkinButtonAddDisallow: TbsSkinButton;
    ButtonSdoDel: TbsSkinButton;
    bsSkinButtonAllAdd: TbsSkinButton;
    ButtonSdoAllDel: TbsSkinButton;
    bsSkinButton3: TbsSkinButton;
    Label1: TLabel;
    ListViewDisallow: TRzListView;
    Memo2: TMemo;
    bsSkinButton4: TbsSkinButton;
    RzLabel11: TRzLabel;
    ClientLocalFileEdt: TRzEdit;
    bsSkinButton6: TbsSkinButton;
    Mes: TbsSkinMessage;
    bsSkinInputDialog1: TbsSkinInputDialog;
    SaveTxtBtn: TbsSkinButton;
    bsSkinGroupBox1: TbsSkinGroupBox;
    bsSkinGroupBox2: TbsSkinGroupBox;
    bsSkinStdLabel6: TbsSkinStdLabel;
    Label2: TLabel;
    EditProductName: TEdit;
    EditVersion: TEdit;
    EditUpDateTime: TEdit;
    EditProgram: TEdit;
    EditWebSite: TEdit;
    EditBbsSite: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    TabSheet6: TRzTabSheet;
    RzGroupBox5: TRzGroupBox;
    BtnGameMonAdd: TRzButton;
    EditGameMon: TRzEdit;
    RzLabel13: TRzLabel;
    RzLabel14: TRzLabel;
    RzGroupBox6: TRzGroupBox;
    BtnGameMonDel: TRzButton;
    BtnChangeGameMon: TRzButton;
    BtnSaveGameMon: TRzButton;
    RzLabel12: TRzLabel;
    ListViewGameMon: TRzListView;
    GameMonTypeRadioGroup: TRzRadioGroup;
    RzLabel15: TRzLabel;
    GameMonListURLEdt: TRzEdit;
    RzGroupBox7: TRzGroupBox;
    bsSkinCheckRadioBoxSdoFilter: TbsSkinCheckRadioBox;
    bsSkinCheckRadioBoxGameMon: TbsSkinCheckRadioBox;
    bsSkinPopupMenu1: TbsSkinPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    RzLabel16: TRzLabel;
    GameESystemEdt: TRzEdit;
    RzBalloonHints1: TRzBalloonHints;
    RzRadioGroupMainImages: TRzRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure AddArrayBtnClick(Sender: TObject);
    procedure DelArrayBtnClick(Sender: TObject);
    procedure AddGameListClick(Sender: TObject);
    procedure DelGameListClick(Sender: TObject);
    procedure ChangeGameListClick(Sender: TObject);
    procedure bsSkinButton8Click(Sender: TObject);
    procedure OpenFileBtnClick(Sender: TObject);
    procedure bsSkinButton5Click(Sender: TObject);
    procedure SavePatchListBtnClick(Sender: TObject);
    procedure LoadPatchListBtnClick(Sender: TObject);
    procedure bsSkinButton1Click(Sender: TObject);
    procedure bsSkinButton2Click(Sender: TObject);
    procedure bsSkinButton9Click(Sender: TObject);
    procedure bsSkinButtonAddDisallowClick(Sender: TObject);
    procedure ButtonSdoDelClick(Sender: TObject);
    procedure bsSkinButtonAllAddClick(Sender: TObject);
    procedure ButtonSdoAllDelClick(Sender: TObject);
    procedure bsSkinButton3Click(Sender: TObject);
    procedure bsSkinButton4Click(Sender: TObject);
    procedure bsSkinButton6Click(Sender: TObject);
    procedure SaveTxtBtnClick(Sender: TObject);
    procedure BtnGameMonAddClick(Sender: TObject);
    procedure BtnGameMonDelClick(Sender: TObject);
    procedure BtnChangeGameMonClick(Sender: TObject);
    procedure ListViewGameMonClick(Sender: TObject);
    procedure BtnSaveGameMonClick(Sender: TObject);
    procedure ListViewDisallowMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
  private
    function InGameMonList(sFilterMsg: string): Boolean;
    function InListBoxitemList(sItemName: string): Boolean;
  public
    { Public declarations }
    procedure LoadConfig();
    procedure AddListView(ServerArray,ServerName,ServerIp,ServerPort,ServerNoticeURL,ServerHomeURL:String);
    procedure ChangeListView(ServerArray,ServerName,ServerIp,ServerPort,ServerNoticeURL,ServerHomeURL:String);
    procedure ListBoxLoadItemDB();
    function  LoadGameFilterItemNameList(): Boolean; //游戏盛大挂过滤物品名
 end;
const ConfigFile = '.\QKConfig.ini';
var
  MainFrm: TMainFrm;

implementation

uses AddGameList, MD5, MakeGameLoginShare, HUtil32, EDcodeUnit;
{$R *.dfm}
//从路径得到文件名
function ExtractFileName(const Str: string): string;
var L, i, flag: integer;
begin
  flag := 0;
  L := Length(Str);
  for i := 1 to L do if Str[i] = '\' then flag := i;
  result := copy(Str, flag + 1, L - flag);
end;

function AppPath: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

procedure TMainFrm.LoadConfig();
var
  IniFile: TIniFile;
  I,IEnd:Integer;
  II,IIEnd:Integer;
  ListItem: TListItem;
begin
  if not FileExists(ConfigFile) then begin
    ComboBox1.Items.Add('电信服务器');
    ComboBox1.Items.Add('网通服务器');

    LnkEdt.Text := '传奇登陆器';
    ClientFileEdt.Text := RandomGetName()+'.THG';
    ClientLocalFileEdt.Text := RandomGetName()+'.Lis';
    GameListURLEdt.Text := 'Http://127.0.0.1/QKServerList.txt';
    PatchListURLEdt.Text := 'Http://127.0.0.1/QKPatchList.txt';
    GameMonListURLEdt.Text := 'Http://127.0.0.1/QKGameMonList.txt';
    GameESystemEdt.Text := 'Http://127.0.0.1/rdxt.htm';

  end else begin
    IniFile := TIniFile.Create(ConfigFile);
    IEnd:=IniFile.ReadInteger('ServerList','GroupCount',0);
    IIEnd:=IniFile.ReadInteger('ServerList','ListCount',0);
    ComboBox1.Items.Clear;
    for I:=1 to IEnd do begin
       ComboBox1.Items.Add(IniFile.ReadString('ServerList','Group'+InttoStr(I),''));
    end;
    LnkEdt.Text := IniFile.ReadString('LoginInfo','LnkName','');
    ClientFileEdt.Text := IniFile.ReadString('LoginInfo','ClientFileName','');
    ClientLocalFileEdt.Text := IniFile.ReadString('LoginInfo','ClientLocalFileName','');
    GameListURLEdt.Text := IniFile.ReadString('LoginInfo','GameListURL','');
    PatchListURLEdt.Text := IniFile.ReadString('LoginInfo','PatchListURL','');
    GameMonListURLEdt.Text := IniFile.ReadString('LoginInfo','GameMonListUrl','');
    bsSkinCheckRadioBoxSdoFilter.Checked := IniFile.ReadBool('LoginInfo','SdoFilter',False);
    bsSkinCheckRadioBoxGameMon.Checked := IniFile.ReadBool('LoginInfo','GameMon',False);
    GameESystemEdt.Text := IniFile.ReadString('LoginInfo','GameESystem','');
    RzRadioGroupMainImages.ItemIndex := Inifile.ReadInteger('LoginInfo','MainJpg',0);
    for II:=1 to IIEnd do begin
      ListView1.Items.BeginUpdate;
      try
        ListItem := ListView1.Items.Add;
        ListItem.Caption:=IniFile.ReadString('ServerList','ServerArray'+InttoStr(II),'');
        ListItem.SubItems.Add(IniFile.ReadString('ServerList','ServerName'+InttoStr(II),''));
        ListItem.SubItems.Add(IniFile.ReadString('ServerList','ServerIP'+InttoStr(II),''));
        ListItem.SubItems.Add(IniFile.ReadString('ServerList','ServerPort'+InttoStr(II),''));
        ListItem.SubItems.Add(IniFile.ReadString('ServerList','ServerNoticeURL'+InttoStr(II),''));
        ListItem.SubItems.Add(IniFile.ReadString('ServerList','ServerHomeURL'+InttoStr(II),''));
      finally
          ListView1.Items.EndUpdate;
      end;
    end;
  end;
  ComboBox1.ItemIndex := 0;
  IniFile.Free;
end;

procedure TMainFrm.AddListView(ServerArray,ServerName,ServerIp,ServerPort,ServerNoticeURL,ServerHomeURL:String);
var
ListItem: TListItem;
begin
  ListView1.Items.BeginUpdate;
  try
    ListItem := ListView1.Items.Add;
    ListItem.Caption := ServerArray;
    ListItem.SubItems.Add(ServerName);
    ListItem.SubItems.Add(ServerIp);
    ListItem.SubItems.Add(ServerPort);
    ListItem.SubItems.Add(ServerNoticeURL);
    ListItem.SubItems.Add(ServerHomeURL);
  finally
    ListView1.Items.EndUpdate;
  end;
end;

procedure TMainFrm.ChangeListView(ServerArray,ServerName,ServerIp,ServerPort,ServerNoticeURL,ServerHomeURL:String);
var
  nItemIndex: Integer;
  ListItem: TListItem;
begin
  try
    nItemIndex := ListView1.ItemIndex;
    ListItem := ListView1.Items.Item[nItemIndex];
    ListItem.Caption := ServerArray;
    ListItem.SubItems.Strings[0] := ServerName;
    ListItem.SubItems.Strings[1] := ServerIp;
    ListItem.SubItems.Strings[2] := ServerPort;
    ListItem.SubItems.Strings[3] := ServerNoticeURL;
    ListItem.SubItems.Strings[4] := ServerHomeURL;
  except
  end;
end;

procedure TMainFrm.FormCreate(Sender: TObject);
var
  sProductName: string;
  sVersion: string;
  sUpDateTime: string;
  sProgram: string;
  sWebSite: string;
  sBbsSite: string;
begin
  Decode(g_sProductName, sProductName);
  Decode(g_sVersion, sVersion);
  Decode(g_sUpDateTime, sUpDateTime);
  Decode(g_sProgram, sProgram);
  Decode(g_sWebSite, sWebSite);
  Decode(g_sBbsSite, sBbsSite);
  EditProductName.Text := sProductName;
  EditVersion.Text := sVersion;
  EditUpDateTime.Text := sUpDateTime;
  EditProgram.Text := sProgram;
  EditWebSite.Text := sWebSite;
  EditBbsSite.Text := sBbsSite;
  
  LoadConfig();
  StdItemList := TList.Create;
  Query := TQuery.Create(nil);
  Query.DatabaseName := 'HeroDb';
  try
  LoadItemsDB();
  except
    Mes.MessageDlg('你机器没有设置DBE库或库名错误，请设为HeroDB！！！'+#13+'如果不设置那么配置不了盛大过滤文件！！！',mtError,[mbOK],0);
  end;
  Query.Free;
  ListBoxLoadItemDB();
  LoadGameFilterItemNameList(); //读取过滤listview列表
end;

procedure TMainFrm.AddArrayBtnClick(Sender: TObject);
var
  str: string;
  I: Integer;
begin
  str:= bsSkinInputDialog1.InputBox('增加','请输入你要增加的服务器分组：','');
  if str <> '' then begin
    for I:=0 to ComBoBox1.Items.Count-1 do begin
      if ComBoBox1.Items.Strings[I] = str then begin
        Mes.MessageDlg('此服务器分组已在列表中！！！',mtError,[mbOK],0);
        Exit;
      end;
    end;
  ComBoBox1.Items.Add(str);
  ComBoBox1.ItemIndex := ComBoBox1.Items.Count-1;
  end;
end;

procedure TMainFrm.DelArrayBtnClick(Sender: TObject);
begin
  if Mes.MessageDlg(Pchar('是否确定删除分组 ['+ComBoBox1.items[ComBoBox1.ItemIndex]+'] 信息？'),mtConfirmation,[mbYes,mbNo],0) = IDYES then begin
  ComBoBox1.Items.Delete(ComBoBox1.ItemIndex);
  ComBoBox1.ItemIndex:=ComBoBox1.ItemIndex-1;
  end;
end;

procedure TMainFrm.AddGameListClick(Sender: TObject);
begin
  AddGameListFrm := TAddGameListFrm.Create(Owner);
  AddGameListFrm.Add;
  AddGameListFrm.Free;
end;

procedure TMainFrm.DelGameListClick(Sender: TObject);
begin
   ListView1.Items.BeginUpdate;
  try
    if ListView1.Selected <> nil then
      ListView1.DeleteSelected
      else Mes.MessageDlg('请选择你要删除的信息！',mtError,[mbOK],0);
  finally
    ListView1.Items.EndUpdate;
  end;
end;

procedure TMainFrm.ChangeGameListClick(Sender: TObject);
var
  ListItem: TListItem;
begin
  ListItem := ListView1.Selected;
  if ListItem <> nil then begin
    if AddGameListFrm = nil then AddGameListFrm := TAddGameListFrm.Create(Owner);
    AddGameListFrm.Change(ListItem.Caption,ListItem.SubItems.Strings[0],ListItem.SubItems.Strings[1],ListItem.SubItems.Strings[2],ListItem.SubItems.Strings[3],ListItem.SubItems.Strings[4]);
    AddGameListFrm.Free;
  end else Mes.MessageDlg('请选择你要修改的信息！',mtError,[mbOK],0);
end;

procedure TMainFrm.bsSkinButton8Click(Sender: TObject);
var
  I: Integer;
  ListItem: TListItem;
  SaveList: Classes.TStringList;
  sServerArray, sServerName, sServerIP, sServerPort, sServerNoticeURL, sServerHomeURL: String;
  sFileName, sLineText: String;
begin
  if ListView1.Items.Count <> 0 then begin
    sFileName := 'QKServerList.txt';
    SaveList := Classes.TStringList.Create();
    SaveList.Add(';服务器分组'#9'游戏名称'#9'游戏IP地址'#9'端口'#9'公告地址'#9'网站主页');
    ListView1.Items.BeginUpdate;
    try
      for I := 0 to ListView1.Items.Count - 1 do begin
        ListItem := ListView1.Items.Item[I];
        sServerArray     := ListItem.Caption;
        sServerName      := ListItem.SubItems.Strings[0];
        sServerIP        := ListItem.SubItems.Strings[1];
        sServerPort      := ListItem.SubItems.Strings[2];
        sServerNoticeURL := ListItem.SubItems.Strings[3];
        sServerHomeURL   := ListItem.SubItems.Strings[4];
        sLineText := sServerArray + '|' + sServerName + '|' + sServerIP + '|' + sServerPort + '|' + sServerNoticeURL + '|' + sServerHomeURL;
        SaveList.Add(sLineText);
      end;
    finally
      ListView1.Items.EndUpdate;
    end;
    SaveList.Text := encrypt(Trim(SaveList.Text),CertKey('?-W'));
    SaveList.SaveToFile(AppPath+sFileName);
    SaveList.Free;
    Mes.MessageDlg('游戏列表生成成功'+#13+'请复制目录下的'+' QKServerList.txt '+'传到你的网站目录下即可',mtInformation,[mbOK],0);
  end else Mes.MessageDlg('你还没有添加游戏哦！',mtError,[mbOK],0);
end;

procedure TMainFrm.OpenFileBtnClick(Sender: TObject);
begin
  if bsSkinOpenDialog1.Execute then begin
    FileNameEdt.Text := ExtractFileName(bsSkinOpenDialog1.FileName);
    Md5Edt.Text := RivestFile(bsSkinOpenDialog1.FileName);
  end;
end;

procedure TMainFrm.bsSkinButton5Click(Sender: TObject);
var
  Dir: String;
begin
  case DirComBox.ItemIndex of
    0:Dir := 'Data/';
    1:Dir := 'Map/';
    2:Dir := 'Wav/';
    3:Dir := './';
  end;
  if DirComBox.Text = '' then
    begin
      Mes.MessageDlg('请选择客户端更新目录',mtInformation,[mbOK],0);
      DirComBox.SetFocus;
      exit;
    end;
  if FileNameEdt.Text = '' then
    begin
      Mes.MessageDlg('请选择文件来获取文件名',mtInformation,[mbOK],0);
      FileNameEdt.SetFocus;
      exit;
    end;
  if DownAddressEdt.Text = '' then
    begin
      Mes.MessageDlg('下载地址怎么能空？',mtInformation,[mbOK],0);
      DownAddressEdt.SetFocus;
      exit;
    end;
  if Md5Edt.Text = '' then
    begin
      Mes.MessageDlg('请选择文件来获取文件MD5值',mtInformation,[mbOK],0);
      Md5Edt.SetFocus;
      exit;
    end;
  Memo1.Lines.Add(Inttostr(FileTypeRadioGroup.ItemIndex) +#9+ Dir +#9+ FileNameEdt.Text +#9+ Md5Edt.Text +#9+ DownAddressEdt.Text)
end;

procedure TMainFrm.SavePatchListBtnClick(Sender: TObject);
var
  sPatchFile: String;
  SaveList: Classes.TStringList;
begin
  sPatchFile := 'QKPatchList.txt';
  SaveList := Classes.TStringList.Create();
  SaveList.Text := (encrypt(Memo1.Lines.Text,CertKey('?-W')));
  SaveList.SaveToFile(AppPath+sPatchFile);
  SaveList.Free;
  Mes.MessageDlg('游戏更新列表生成成功'+#13+'请复制目录下的'+' QKPatchList.txt '+'传到你的网站目录下即可',mtInformation,[mbOK],0);
end;

procedure TMainFrm.SaveTxtBtnClick(Sender: TObject);
var
  sPatchFile: String;
begin
  sPatchFile := '更新补丁记录.txt';
  Memo1.Lines.SaveToFile(AppPath+sPatchFile);
  Mes.MessageDlg('游戏更新列表保存成功'+#13+'请保管好 更新补丁记录.txt文件 '+'以后编辑升级补丁文件编辑就靠他了！',mtInformation,[mbOK],0);
end;

procedure TMainFrm.LoadPatchListBtnClick(Sender: TObject);
begin
  if LoadPatchFileOpenDialog.Execute then begin
     Memo1.Lines.LoadFromFile(LoadPatchFileOpenDialog.FileName);
     Mes.MessageDlg('读取更新列表文件 '+LoadPatchFileOpenDialog.FileName+' 成功！',mtInformation,[mbOK],0);
  end;
end;

//保存文件   uses CommDlg;
function SaveFileName(const OldName: string): string;
var
  ofn: tagOFNA;
  szFile: Pchar;
begin
  GetMem(szFile, 1024); //申请内存
  ZeroMemory(szFile, 1024);
  ZeroMemory(@ofn, sizeof(tagOFNA));
  ofn.lStructSize := sizeof(tagOFNA) - SizeOf(DWORD) * 3;
  ofn.hwndOwner := Application.Handle;
  ofn.lpstrFile := szFile;
  ofn.nMaxFile := 1024;
  ofn.lpstrFilter := pchar('exe文件 (*.exe)'#0'*.exe'#0'全部文件'#0'*.*'#0);
  ofn.nFilterIndex := 1;
  ofn.lpstrFileTitle := nil;
  ofn.nMaxFileTitle := 0;
  ofn.lpstrInitialDir := nil;
  ofn.lpstrDefExt := '.exe';
  ofn.Flags := OFN_PATHMUSTEXIST or OFN_FILEMUSTEXIST;
  if (GetSaveFileName(ofn)) then
    Result := szFile
  else
    Result := OldName;
  FreeMem(szFile);
end;



procedure TMainFrm.bsSkinButton1Click(Sender: TObject);
var
  FilePath: string;
  MyRecInfo: TRecinfo;
  s: string;
begin
  if LnkEdt.Text = '' then
    begin
      Mes.MessageDlg('要写你的登陆器生成桌面图标时候的名称也称快捷方式',mtInformation,[mbOK],0);
      LnkEdt.SetFocus;
      exit;
    end;
  if ClientFileEdt.Text = '' then
    begin
      Mes.MessageDlg('客户端文件不能为空',mtInformation,[mbOK],0);
      ClientFileEdt.SetFocus;
      exit;
    end;
  if GameListURLEdt.Text = '' then
    begin
      Mes.MessageDlg('游戏列表网址不能为空',mtInformation,[mbOK],0);
      GameListURLEdt.SetFocus;
      exit;
    end;
  if GameMonListURLEdt.Text = '' then
    begin
      Mes.MessageDlg('反外挂列表网址不能为空',mtInformation,[mbOK],0);
      GameMonListURLEdt.SetFocus;
      exit;
    end;
  if PatchListURLEdt.Text = '' then
    begin
      Mes.MessageDlg('游戏更新列表网址不能为空',mtInformation,[mbOK],0);
      PatchListURLEdt.SetFocus;
      exit;
    end;
  if bsSkinCheckRadioBoxSdoFilter.Checked then begin
    if FileExists(FilterFileName) then begin
      Memo2.Lines.LoadFromFile(FilterFileName);
    end else begin
      Mes.MessageDlg('生成失败！'+#13+'盛大内挂过滤文件不存在！请先生成过滤文件',mtError,[mbOK],0);
      Exit;
    end;
  end;

  FilePath := SaveFileName(FilePath);
  if FilePath = '' then Exit;
  case RzRadioGroupMainImages.ItemIndex of
    0: ReleaseRes('GameLogin', 'exefile', PChar(FilePath));
    1: ReleaseRes('GameLogin', 'exefile1', PChar(FilePath));
  end;

  MyRecInfo.lnkName := Trim(LnkEdt.Text);
  MyRecInfo.GameListURL := Trim(GameListURLEdt.Text);
  MyRecInfo.boGameMon := bsSkinCheckRadioBoxGameMon.Checked;
  if bsSkinCheckRadioBoxGameMon.Checked then
    MyRecInfo.GameMonListURL := Trim(GameMonListURLEdt.Text)
  else
    MyRecInfo.GameMonListURL := '';
  MyRecInfo.PatchListURL := Trim(PatchListURLEdt.Text);
  MyRecInfo.ClientFileName := Trim(ClientFileEdt.Text);
  MyRecInfo.ClientLocalFileName := Trim(ClientlocalFileEdt.Text);
  MyRecInfo.GameESystemUrl := Trim(GameESystemEdt.Text);
  s:= Memo2.Lines.Text;
  strpcopy(pchar(@MyRecInfo.GameSdoFilter),s); //将S  赋给MyRecInfo.GameSdoFilter数组   怎么显示出来参考登陆器 

  if WriteInfo(FilePath, MyRecInfo) then
  Mes.MessageDlg(PChar(FilePath + '已生成完毕!'),mtInformation,[mbOK],0);
end;

procedure TMainFrm.bsSkinButton2Click(Sender: TObject);
var
  Inifile: TInifile;
begin
  Inifile:=TIniFile.Create(AppPath+'QKConfig.ini');
  Inifile.WriteString('LoginInfo','LnkName',LnkEdt.Text);
  Inifile.WriteString('LoginInfo','ClientFileName',ClientFileEdt.Text);
  Inifile.WriteString('LoginInfo','ClientLocalFileName',ClientLocalFileEdt.Text);
  Inifile.WriteString('LoginInfo','GameListURL',GameListURLEdt.Text);
  Inifile.WriteString('LoginInfo','PatchListURL',PatchListURLEdt.Text);
  Inifile.WriteString('LoginInfo','GameMonListURL', GameMonListURLEdt.Text);
  Inifile.WriteBool('LoginInfo','SdoFilter',bsSkinCheckRadioBoxSdoFilter.Checked);
  Inifile.WriteBool('LoginInfo','GameMon',bsSkinCheckRadioBoxGameMon.Checked);
  Inifile.WriteString('LoginInfo','GameESystem',GameESystemEdt.Text);
  Inifile.WriteInteger('LoginInfo','MainJpg',RzRadioGroupMainImages.ItemIndex);
  Inifile.Free;
  Mes.MessageDlg('登陆器配置信息已保存！',mtInformation,[mbOK],0);
end;

procedure TMainFrm.bsSkinButton9Click(Sender: TObject);
var
  Inifile: TInifile;
  I,II: Integer;
begin
  Inifile:=TIniFile.Create(AppPath+'QKConfig.ini');
  Inifile.WriteInteger('ServerList','GroupCount',ComboBox1.Items.Count);
  for I:=0 to ComboBox1.Items.Count -1 do
  begin
   Inifile.WriteString('ServerList','Group'+inttostr(I+1),ComboBox1.Items[I]);
  end;
  Inifile.WriteInteger('ServerList','ListCount',ListView1.Items.Count);
  for II:=0 to ListView1.Items.Count -1 do
  begin
   Inifile.WriteString('ServerList','ServerArray'+Inttostr(II+1),ListView1.Items.Item[II].Caption);
   Inifile.WriteString('ServerList','ServerName'+Inttostr(II+1),ListView1.Items.Item[II].SubItems.Strings[0]);
   Inifile.WriteString('ServerList','ServerIP'+Inttostr(II+1),ListView1.Items.Item[II].SubItems.Strings[1]);
   Inifile.WriteString('ServerList','ServerPort'+Inttostr(II+1),ListView1.Items.Item[II].SubItems.Strings[2]);
   Inifile.WriteString('ServerList','ServerNoticeURL'+Inttostr(II+1),ListView1.Items.Item[II].SubItems.Strings[3]);
   Inifile.WriteString('ServerList','ServerHomeURL'+Inttostr(II+1),ListView1.Items.Item[II].SubItems.Strings[4]);
  end;
   Inifile.Free;
   Mes.MessageDlg('游戏列表配置信息已保存！',mtInformation,[mbOK],0);
end;

procedure TMainFrm.ListBoxLoadItemDB();
var
  List: Classes.TList;
  I: Integer;
  StdItem: pTStdItem;
begin
  ListBoxitemList.Items.Clear;
  if StdItemList <> nil then begin
    List := Classes.TList(TObject(StdItemList));
    for I := 0 to List.Count - 1 do begin
        StdItem := List.Items[I];
        ListBoxitemList.Items.AddObject(StdItem.Name, TObject(StdItem));
    end;
    List.Free;
  end;
end;

function TMainFrm.InListBoxitemList(sItemName: string): Boolean;
var
  I: Integer;
  ListItem: TListItem;
begin
  Result := False;
  ListViewDisallow.Items.BeginUpdate;
  try
    for I := 0 to ListViewDisallow.Items.Count - 1 do begin
      ListItem := ListViewDisallow.Items.Item[I];
      if CompareText(sItemName, ListItem.Caption) = 0 then begin
        Result := TRUE;
        break;
      end;
    end;
  finally
    ListViewDisallow.Items.EndUpdate;
  end;
end;

procedure TMainFrm.bsSkinButtonAddDisallowClick(Sender: TObject);
var
  ListItem: TListItem;
  sItemName: string;
  I: Integer;
begin
  if ListBoxitemList.ItemIndex=-1 then exit;

  for i:=0 to (ListBoxitemList.Items.Count-1) do
    if ListBoxitemList.Selected[i] then
    begin
        sItemName := ListBoxitemList.items.Strings[i];
        if (sItemName <> '') then begin
          if InListBoxitemList(sItemName) then begin
            Mes.MessageDlg('你要选择的物品已经在过滤物品列表中，请选择其他物品！！！',mtInformation,[mbOK],0);
            Exit;
          end;
          ListViewDisallow.Items.BeginUpdate;
          try
            ListItem := ListViewDisallow.Items.Add;
            ListItem.Caption := sItemName;
            ListItem.SubItems.Add('1');
            ListItem.SubItems.Add('1');
            if not ButtonSdoDel.Enabled then ButtonSdoDel.Enabled := True;
            if not ButtonSdoAllDel.Enabled then ButtonSdoAllDel.Enabled := True;
          finally
            ListViewDisallow.Items.EndUpdate;
          end;
        end;

    end;
end;

procedure TMainFrm.ButtonSdoDelClick(Sender: TObject);
begin
  try
    ListViewDisallow.DeleteSelected;
  except
  end;
end;

procedure TMainFrm.bsSkinButtonAllAddClick(Sender: TObject);
var
  ListItem: TListItem;
  I: Integer;
begin
  ListViewDisallow.Items.Clear;
  ListViewDisallow.Items.BeginUpdate;
  try
  for I := 0 to ListBoxitemList.Items.Count - 1 do begin
    ListItem := ListViewDisallow.Items.Add;
    ListItem.Caption := ListBoxitemList.Items.Strings[I];
    ListItem.SubItems.Add('1');
    ListItem.SubItems.Add('1');
  end;
  if not ButtonSdoDel.Enabled then ButtonSdoDel.Enabled := True;
  if not ButtonSdoAllDel.Enabled then ButtonSdoAllDel.Enabled := True;
  //ModValue();
  finally
      ListViewDisallow.Items.EndUpdate;
  end;
end;

procedure TMainFrm.ButtonSdoAllDelClick(Sender: TObject);
begin
  ListViewDisallow.Items.Clear;
  ButtonSdoDel.Enabled := False;
  ButtonSdoAllDel.Enabled := False;
  //ModValue();
end;

procedure TMainFrm.bsSkinButton3Click(Sender: TObject);
var
  I: Integer;
  ListItem: TListItem;
  SaveList: TStringList;
  sFileName, sLineText: string;
  sItemName: string;
  sCanPick, sCanShow: String;
begin
  if ListViewDisallow.Items.Count = 0 then
  begin
    Mes.MessageDlg('过滤物品列表是空的哦！',mtError,[mbOK],0);
    Exit;
  end;

  sFileName := FilterFileName;
  SaveList := Classes.TStringList.Create();
  SaveList.Add(';蓝月引擎盛大挂过滤配置文件');
  SaveList.Add(';物品名称'#9'是否过滤自动捡取'#9'是否过滤显示物品'#9'1为允许 0为禁止');
  ListViewDisallow.Items.BeginUpdate;
  try
    for I := 0 to ListViewDisallow.Items.Count - 1 do begin
      ListItem := ListViewDisallow.Items.Item[I];
      sItemName := ListItem.Caption;
      sCanPick := ListItem.SubItems.Strings[0];
      sCanShow := ListItem.SubItems.Strings[1];
      sLineText := sItemName + #9 + sCanPick + #9 + sCanShow;
      SaveList.Add(sLineText);
    end;
  finally
    ListViewDisallow.Items.EndUpdate;
  end;
  SaveList.SaveToFile(AppPath+sFileName);
  Mes.MessageDlg('盛大内挂过滤文件生成成功'+#13+'如果是盛大挂请不要忘记生成登陆器的时候钩选中[集成盛大过滤文件]复选框。',mtInformation,[mbOK],0);
  SaveList.Free;
end;
//读取过滤listview列表
function TMainFrm.LoadGameFilterItemNameList(): Boolean; //读取过滤listview列表
var
  I: Integer;
  sFileName: string;
  LoadList: Classes.TStringList;
  sLineText: string;
  sItemName: string;
  sCanPick: string;
  sCanShow: string;
  ListItem: TListItem;
begin
  Result := False;
  sFileName := FilterFileName;
  if not FileExists(sFileName) then begin
    Exit;
  end;
  LoadList := Classes.TStringList.Create();
  LoadList.LoadFromFile(sFileName);
  for I := 0 to LoadList.Count - 1 do begin
    sLineText := LoadList.Strings[I];
    if (sLineText <> '') and (sLineText[1] <> ';') then begin
      sLineText := GetValidStr3(sLineText, sItemName, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sCanPick, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sCanShow, [' ', #9]);
      ListViewDisallow.Items.BeginUpdate;
      try
        ListItem := ListViewDisallow.Items.Add;
        ListItem.Caption := sItemName;
        ListItem.SubItems.Add(sCanPick);
        ListItem.SubItems.Add(sCanShow);
      finally
        ListViewDisallow.Items.EndUpdate;
      end;
    end;
  end;
  Result := True;
  LoadList.Free;
end;
procedure TMainFrm.bsSkinButton4Click(Sender: TObject);
begin
  ClientFileEdt.Text := RandomGetName()+'.THG';
end;

procedure TMainFrm.bsSkinButton6Click(Sender: TObject);
begin
  ClientLocalFileEdt.Text := RandomGetName()+'.Lis';
end;


{******************************************************************************}
//反外挂配置
function TMainFrm.InGameMonList(sFilterMsg: string): Boolean;
var
  I: Integer;
  ListItem: TListItem;
begin
  Result := False;
  ListViewGameMon.Items.BeginUpdate;
  try
    for I := 0 to ListViewGameMon.Items.Count - 1 do begin
      ListItem := ListViewGameMon.Items.Item[I];
      if CompareText(sFilterMsg, ListItem.SubItems.Strings[0]) = 0 then begin
        Result := TRUE;
        break;
      end;
    end;
  finally
    ListViewGameMon.Items.EndUpdate;
  end;
end;

procedure TMainFrm.BtnGameMonAddClick(Sender: TObject);
var
  sGameMonName: string;
  ListItem: TListItem;
  sGameTyep: string;
begin
  sGameMonName := Trim(EditGameMon.Text);
  if sGameMonName = '' then begin
    Mes.MessageDlg('请输入外挂特征名称！',mtError,[mbOK],0);
    Exit;
  end;
  if InGameMonList(sGameMonName) then begin
    Mes.MessageDlg('你输入的外挂特征名称已经存在！！！',mtError,[mbOK],0);
    Exit;
  end;
  case GameMonTypeRadioGroup.ItemIndex of
    0: sGameTyep := '标题特征';
    1: sGameTyep := '进程特征';
    2: sGameTyep := '模块特征';
  end;
  ListViewGameMon.Items.BeginUpdate;
  try
    ListItem := ListViewGameMon.Items.Add;
    ListItem.Caption := sGameTyep;
    ListItem.SubItems.Add(sGameMonName);
  finally
    ListViewGameMon.Items.EndUpdate;
  end;
end;

procedure TMainFrm.BtnGameMonDelClick(Sender: TObject);
begin
  try
    ListViewGameMon.DeleteSelected;
  except
  end;
end;

procedure TMainFrm.BtnChangeGameMonClick(Sender: TObject);
var
  sGameMonName: string;
  ListItem: TListItem;
  sGameTyep: string;
begin
  sGameMonName := Trim(EditGameMon.Text);
  if sGameMonName = '' then begin
    Mes.MessageDlg('请输入外挂特征名称！',mtError,[mbOK],0);
    Exit;
  end;
  if InGameMonList(sGameMonName) then begin
    Mes.MessageDlg('你输入的外挂特征名称已经存在！！！',mtError,[mbOK],0);
    Exit;
  end;
  case GameMonTypeRadioGroup.ItemIndex of
    0: sGameTyep := '标题特征';
    1: sGameTyep := '进程特征';
    2: sGameTyep := '模块特征';
  end;
  ListViewGameMon.Items.BeginUpdate;
  try
    ListItem := ListViewGameMon.Items.Item[ListViewGameMon.ItemIndex];
    ListItem.Caption := sGameTyep;
    ListItem.SubItems.Strings[0] := (sGameMonName);
  finally
    ListViewGameMon.Items.EndUpdate;
  end;
end;

procedure TMainFrm.ListViewGameMonClick(Sender: TObject);
var
  ListItem: TListItem;
  nItemIndex: Integer;
  nGameMonType :Byte;
begin
  try
    nItemIndex := ListViewGameMon.ItemIndex;
    ListItem := ListViewGameMon.Items.Item[nItemIndex];
    EditGameMon.Text := ListItem.SubItems.Strings[0];
    if ListItem.Caption = '标题特征' then nGameMonType := 0;
    if ListItem.Caption = '进程特征' then nGameMonType := 1;
    if ListItem.Caption = '模块特征' then nGameMonType := 2;
    GameMonTypeRadioGroup.ItemIndex := nGameMonType;
    BtnChangeGameMon.Enabled := TRUE;
    BtnGameMonDel.Enabled := TRUE;
  except
    EditGameMon.Text := '';
    BtnChangeGameMon.Enabled := False;
    BtnGameMonDel.Enabled := False;
  end;
end;

procedure TMainFrm.BtnSaveGameMonClick(Sender: TObject);
var
  I: Integer;
  ListItem: TListItem;
  SaveList: TStringList;
  sGameMonName: string;
  sGameTyepName: string;
begin
  SaveList := TStringList.Create;
  SaveList.Add(';特征分类'#9'外挂特征');
  ListViewGameMon.Items.BeginUpdate;
  try
    for I := 0 to ListViewGameMon.Items.Count - 1 do begin
      ListItem := ListViewGameMon.Items.Item[I];
      sGameTyepName := ListItem.Caption;
      sGameMonName := ListItem.SubItems.Strings[0];
      SaveList.Add(sGameTyepName + #9 + sGameMonName);
    end;
  finally
    ListViewGameMon.Items.EndUpdate;
  end;
  SaveList.SaveToFile(AppPath+GameMonName);
  SaveList.Free;
  Mes.MessageDlg('反外挂列表生成成功'+#13+'请复制目录下的'+' QKGameMonList.txt '+'传到你的网站目录下即可',mtInformation,[mbOK],0);
end;

procedure TMainFrm.ListViewDisallowMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if   Button   =   mbLeft   then
  begin
      bsSkinPopupMenu1.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
  end
end;

procedure TMainFrm.N1Click(Sender: TObject);
var
  ListItem: TListItem;
begin
  ListItem := ListViewDisallow.Selected;
  while(ListItem <> nil) do begin
      ListItem.SubItems.Strings[0] := '1';
      ListItem := ListViewDisallow.GetNextItem(ListItem,   sdAll,   [isSelected]);
  end;
end;

procedure TMainFrm.N3Click(Sender: TObject);
var
  ListItem: TListItem;
begin
  ListItem := ListViewDisallow.Selected;
  while(ListItem <> nil) do begin
      ListItem.SubItems.Strings[0] := '0';
      ListItem := ListViewDisallow.GetNextItem(ListItem,   sdAll,   [isSelected]);
  end;
end;

procedure TMainFrm.N2Click(Sender: TObject);
var
  ListItem: TListItem;
begin
  ListItem := ListViewDisallow.Selected;
  while(ListItem <> nil) do begin
      ListItem.SubItems.Strings[1] := '1';
      ListItem := ListViewDisallow.GetNextItem(ListItem,   sdAll,   [isSelected]);
  end;
end;

procedure TMainFrm.N4Click(Sender: TObject);
var
  ListItem: TListItem;
begin
  ListItem := ListViewDisallow.Selected;
  while(ListItem <> nil) do begin
      ListItem.SubItems.Strings[1] := '0';
      ListItem := ListViewDisallow.GetNextItem(ListItem,   sdAll,   [isSelected]);
  end;
end;

end.

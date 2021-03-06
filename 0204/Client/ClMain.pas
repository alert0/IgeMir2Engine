unit ClMain;

interface

uses                  
  Windows, Messages, SysUtils, Graphics, Controls, Forms, Dialogs,
  JSocket, DxDraws, DirectX, DXClass, DrawScrn,             
  IntroScn, PlayScn, MapUnit, WIL, Grobal2,
  Actor, DIB, StdCtrls, CliUtil, HUtil32, EdCode,
  DWinCtl, ClFunc, magiceff, SoundUtil, DXSounds, clEvent,  IniFiles,
  Mpeg, MShare, Share, ExtCtrls,QuickSearchMap, ActnList, Classes, EDcodeUnit;

const
   NEARESTPALETTEINDEXFILE = 'Data\npal.idx';
   UiImageDir     = '.\Data\Ui\';
   BookImageDir   = '.\Data\Books\';
   MinimapImageDir= '.\Data\Minimap\';
type
  TKornetWorld = record
    CPIPcode:  string;
    SVCcode:   string;
    LoginID:   string;
    CheckSum:  string;
  end;

  TOneClickMode = (toNone, toKornetWorld);

  TfrmMain = class(TDxForm)
    CSocket: TClientSocket;
    Timer1: TTimer;
    MouseTimer: TTimer;
    WaitMsgTimer: TTimer;
    SelChrWaitTimer: TTimer;
    CmdTimer: TTimer;
    MinTimer: TTimer;
    DXDraw: TDXDraw;
    UiDXImageList: TDXImageList;
    CloseTimer: TTimer;
    TimerBrowserUpdate: TTimer;
    Timer2: TTimer;
    ActionList: TActionList;
    ActCallHeroKey: TAction;
    ActHeroAttackTargetKey: TAction;
    ActHeroGotethKey: TAction;
    ActHeroStateKey: TAction;
    ActHeroGuardKey: TAction;
    ActAttackModeKey: TAction;
    ActMinMapKey: TAction;
    CountDownTimer: TTimer;
    
    procedure DXDrawInitialize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DXDrawMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DXDrawMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure CSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure Timer1Timer(Sender: TObject);
    procedure DXDrawMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MouseTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DXDrawDblClick(Sender: TObject);
    procedure WaitMsgTimerTimer(Sender: TObject);
    procedure SelChrWaitTimerTimer(Sender: TObject);
    procedure DXDrawClick(Sender: TObject);
    procedure CmdTimerTimer(Sender: TObject);
    procedure MinTimerTimer(Sender: TObject);
//    procedure SpeedHackTimerTimer(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    //procedure LoadUib; //20080104  英雄带忠字图标(加载uib后缀文件)
    procedure CloseTimerTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TimerBrowserUpdateTimer(Sender: TObject);
    procedure SendHeroMagicKeyChange (magid: integer; keych: char);
    procedure GetCheckNum();
    procedure SendCheckNum (num: string);
    procedure SendChangeCheckNum();
    procedure Timer2Timer(Sender: TObject);
    procedure Autorun;
    function FindPath(Startx, Starty, end_x, end_y: Integer;boHint: Boolean):Boolean;
    procedure ClearRoad;
    function  GetMagicByID (Id: Byte): Boolean;
    procedure SendMakeWineItems();
    procedure ActCallHeroKeyExecute(Sender: TObject);
    procedure OpenSdoAssistant();
    procedure SendChallenge;
    procedure SendAddChallengeItem (ci: TClientItem);
    procedure SendCancelChallenge;
    procedure SendDelChallengeItem (ci: TClientItem);
    procedure ClientGetChallengeRemoteAddItem (body: string);
    procedure ClientGetChallengeRemoteDelItem (body: string);
    procedure SendChallengeEnd;
    procedure SendChangeChallengeGold (gold: integer);
    procedure SendChangeChallengeDiamond (Diamond: integer);
    procedure SendHeroAutoOpenDefence (Mode: integer);
    procedure ClientGetReceiveDelChrs (body: string;DelChrCount: Integer);
    procedure SendQueryDelChr();
    procedure SendResDelChr(Name: string);
    procedure CountDownTimerTimer(Sender: TObject);
  private
    SocStr, BufferStr: string;
    TimerCmd: TTimerCommand;
    MakeNewId: string;

    ActionLockTime: LongWord;
    LastHitTick: LongWord;
    ActionFailLock: Boolean;
    ActionFailLockTime:LongWord;
    FailAction, FailDir: integer;
    ActionKey: word;

    MouseDownTime: longword;
    WaitingMsg: TDefaultMessage;
    WaitingStr: string;
    WhisperName: string;
    procedure AutoPickUpItem();
    procedure ProcessKeyMessages;
    procedure ProcessActionMessages;
    //procedure CheckSpeedHack (rtime: Longword);
    procedure DecodeMessagePacket (datablock: string);
    procedure ActionFailed;
    function  GetMagicByKey (Key: char): PTClientMagic;
    procedure UseMagic (tx, ty: integer; pcm: PTClientMagic);
    procedure UseMagicSpell (who, effnum, targetx, targety, magic_id: integer);
    procedure UseMagicFire (who, efftype, effnum, targetx, targety, target: integer);
    procedure UseMagicFireFail (who: integer);
    procedure CloseAllWindows;
    procedure ClearDropItems;
    procedure ResetGameVariables;
    procedure ChangeServerClearGameVariables;
    procedure ShowHeroLoginOrLogOut(Actor: TActor);
    procedure _DXDrawMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure AttackTarget (target: TActor);
    function AutoLieHuo: Boolean; //自动烈火
    function AutoZhuri: Boolean;
    function NearActor : Boolean; //自动隐身，自动魔法盾    //自动抗拒
    procedure AutoEatItem;//保护
    function  CheckDoorAction (dx, dy: integer): Boolean;
    procedure ClientGetPasswdSuccess (body: string);
    procedure ClientGetNeedUpdateAccount (body: string);
    procedure ClientGetSelectServer;
    procedure ClientGetPasswordOK(Msg:TDefaultMessage;sBody:String);
    procedure ClientGetReceiveChrs (body: string);
    procedure ClientGetStartPlay (body: string);
    procedure ClientGetReconnect (body: string);
    procedure ClientGetServerConfig(Msg:TDefaultMessage;sBody:String);
    procedure ClientGetServerUnBind(Body:String);
    procedure ClientGetMapDescription (Msg:TDefaultMessage;sBody:String);
    procedure ClientGetGameGoldName (Msg:TDefaultMessage;sBody:String);
    procedure ClientGetAdjustBonus (bonus: integer; body: string);
    procedure ClientGetAddItem (body: string);
    procedure ClientGetUpdateItem (body: string);
    procedure ClientGetDelItem (body: string); 
    procedure ClientGetDelItems (body: string);
    procedure ClientGetBagItmes (body: string);
    procedure ClientGetDropItemFail (iname: string; sindex: integer);
    procedure ClientGetShowItem (itemid, x, y, looks: integer; itmname: string);
    procedure ClientGetHideItem (itemid, x, y: integer);
    procedure ClientGetSenduseItems (body: string);
    procedure ClientGetHeroDelItem (body: string);
    procedure ClientGetUserOrder (body: string);
    procedure ClientGetHeroDelItems (body: string);
    procedure ClientGetHeroAddMagic (body: string);
    procedure ClientGetHeroDelMagic (magid: integer);
    procedure ClientGetHeroMagicLvExp (magid, maglv, magtrain: integer);
    procedure ClientGetHeroDropItemFail (iname: string; sindex: integer);
    procedure ClientHeroGetBagItmes (body: string);
    procedure ClientGetSendHeroItems (body: string); //从服务端获取英雄物品ID     清清$001
    procedure ClientGetHeroMagics (body: string);
    procedure ClientGetHeroUpdateItem (body: string);
    procedure ClientGetHeroAddItem (body: string);
    procedure ClientGetHeroDuraChange (uidx, newdura, newduramax: integer);  //英雄持久
    procedure ClientGetExpTimeItemChange (uidx, NewTime: integer);  //聚灵珠时间改变 20080307
    procedure ClientGetAddMagic (body: string);
    procedure ClientGetDelMagic (magid: integer);
    procedure ClientGetMyShopSpecially (body: string); //商铺奇珍 清清 2007.11.14
    procedure ClientGetMyShop (body: string); //商铺 清清 2007.11.14
    procedure ClientGetMyBoxsItem (body: string); //接收宝箱物品 清清 2008.01.16
    procedure ClientGetMyMagics (body: string);
    procedure ClientGetMagicLvExp (magid, maglv, magtrain: integer);
    procedure ClientGetDuraChange (uidx, newdura, newduramax: integer);
    procedure ClientGetMerchantSay (merchant, face: integer; saying: string);
    procedure ClientGetSendGoodsList (merchant, count: integer; body: string);
    procedure ClientGetSendMakeDrugList (merchant: integer; body: string);
    procedure ClientGetSendUserSell (merchant: integer);
    procedure ClientGetSendUserSellOff (merchant: integer); //元宝寄售显示窗口 20080316
    procedure ClientGetSellOffMyItem (body: string); //客户端寄售查询购买物品 20080317
    procedure ClientGetSellOffSellItem (body: string); //客户端寄售查询出售物品 20080317
    procedure ClientGetSendUserRepair (merchant: integer);
    procedure ClientGetSendUserStorage (merchant: integer);
    procedure ClientGetSendUserPlayDrink(merchant: integer);
    procedure ClientGetSaveItemList (merchant: integer; bodystr: string);
    procedure ClientGetSendDetailGoodsList (merchant, count, topline: integer; bodystr: string);
    procedure ClientGetSendNotice (body: string);
    procedure ClientGetGroupMembers (bodystr: string);
    procedure ClientGetOpenGuildDlg (bodystr: string);
    procedure ClientGetSendGuildMemberList (body: string);
    procedure ClientGetDealRemoteAddItem (body: string);
    procedure ClientGetDealRemoteDelItem (body: string);
    procedure ClientGetReadMiniMap (mapindex: integer);
    procedure ClientGetChangeGuildName (body: string);
    procedure ClientGetSendUserState (body: string);
    procedure DrawEffectHum(nType,nX,nY:Integer);
    procedure ClientGetNeedPassword(Body:String);
    procedure SetInputStatus();
{    procedure CmdShowHumanMsg(sParam1, sParam2, sParam3, sParam4,    20080723注释
      sParam5: String);  }
   // procedure ShowHumanMsg(Msg: pTDefaultMessage);  20080723注释
    procedure LoadFriendList();
    procedure SaveFriendList();
    procedure SaveHeiMingDanList();
    procedure LoadHeiMingDanList();
    function InHeiMingDanListOfName(sUserName: string): Boolean;
    procedure FreeTree();  //自动寻路释放内存
{******************************************************************************}
//拦截TAB键 消息  20080314
    procedure CMDialogKey(var msg: TCMDialogKey);
    message CM_DIALOGKEY;

  //  procedure hotkeypress(var msg:TWMHotKey);message wm_hotkey;
{******************************************************************************}
  public
    LoginId, LoginPasswd, CharName: string;
    Certification: integer;
    ActionLock: Boolean;
    function UiImages(Index: Integer): TDirectDrawSurface;
    procedure ShowMyShow(Actor: TActor; TypeShow:Integer);  //显示自身动画
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
    procedure ProcOnIdle;
    procedure AppOnIdle (Sender: TObject; var Done: Boolean);
    procedure AppLogout;
    procedure AppExit;
    procedure PrintScreenNow;
    procedure EatItem (idx: integer);
    procedure HeroEatItem (idx: integer);  //英雄在包裹双击物品
    procedure SendClientMessage (msg, Recog, param, tag, series: integer);
    procedure SendLogin (uid, passwd: string);
    procedure SendNewAccount (ue: TUserEntry; ua: TUserEntryAdd);
    procedure SendUpdateAccount (ue: TUserEntry; ua: TUserEntryAdd);
    procedure SendSelectServer (svname: string);
    procedure SendChgPw (id, passwd, newpasswd: string);
    procedure SendNewChr (uid, uname, shair, sjob, ssex: string);
    procedure SendQueryChr(Code:Byte); //Code为1则查询验证码  为0则不查询
    procedure SendDelChr (chrname: string);
    procedure SendSelChr (chrname: string);
    procedure SendRunLogin;
    procedure SendSay (str: string);
    procedure SendActMsg (ident, x, y, dir: integer);
    procedure SendSpellMsg (ident, x, y, dir, target: integer);
    procedure SendQueryUserName (targetid, x, y: integer);
    procedure SendDropItem (name: string; itemserverindex: integer);
    procedure SendPickup;
    procedure SendTakeOnItem (where: byte; itmindex: integer; itmname: string);
    procedure SendTakeOffItem (where: byte; itmindex: integer; itmname: string);
    procedure SendItemUpOK(); //淬炼点确定发消息 20080507
    procedure ClientGetUpDateUpItem (body: string); //更新粹练物品! 20080507
    procedure ClientGetHeroInfo (body: string);
    procedure SendSelHeroName(btType: Byte; SelHeroName: string);
    procedure SendHeroDropItem (name: string; itemserverindex: integer);//英雄往地上扔东西
    procedure SendHeroEat (itmindex: integer; itmname: string);
    procedure SendItemToMasterBag (where: byte; itmindex: integer; itmname: string);
    procedure SendItemToHeroBag (where: byte; itmindex: integer; itmname: string); //主人到英雄包裹
    procedure SendTakeOnHeroItem (where: byte; itmindex: integer; itmname: string);//穿到英雄身上相应位置   清清 2007.10.23
    procedure SendTakeOffHeroItem (where: byte; itmindex: integer; itmname: string);
    procedure SendEat (itmindex: integer; itmname: string);
    procedure SendButchAnimal (x, y, dir, actorid: integer);
    procedure SendMagicKeyChange (magid: integer; keych: char);
    procedure SendMerchantDlgSelect (merchant: integer; rstr: string);
    procedure SendQueryPrice (merchant, itemindex: integer; itemname: string);
    procedure SendQueryRepairCost (merchant, itemindex: integer; itemname: string);
    procedure SendSellItem (merchant, itemindex: integer; itemname: string);
    procedure SendRepairItem (merchant, itemindex: integer; itemname: string);
    procedure SendStorageItem (merchant, itemindex: integer; itemname: string);
    procedure SendPlayDrinkItem (merchant, itemindex: integer; itemname: string);
    procedure SendGetDetailItem (merchant, menuindex: integer; itemname: string);
    procedure SendBuyItem (merchant, itemserverindex: integer; itemname: string);
    procedure SendTakeBackStorageItem (merchant, itemserverindex: integer; itemname: string);
    procedure SendMakeDrugItem (merchant: integer; itemname: string);
    procedure SendDropGold (dropgold: integer);
    procedure SendGroupMode (onoff: Boolean);
    procedure SendCreateGroup (withwho: string);
    procedure SendWantMiniMap;
    procedure SendDealTry;
    procedure SendGuildDlg;
    procedure SendCancelDeal;
    procedure SendAddDealItem (ci: TClientItem);
    procedure SendDelDealItem (ci: TClientItem);
    procedure SendAddSellOffItem (ci: TClientItem); //往寄售窗口加物品 发送到M2 20080316
    procedure SendDelSellOffItem (ci: TClientItem); //往包裹里返回物品 发送到M2 20080316
    procedure SendCancelSellOffItem;   //取消寄售 发送到M2 20080316
    procedure SendSellOffEnd;  //发送寄售信息 发送到M2 20080316
    procedure SendCancelMySellOffIteming; //取消正在寄售的物品 发送到M2 20080316
    procedure SendSellOffBuyCancel; //取消寄售物品 收购 发送到M2 20080318
    procedure SendSellOffBuy; //寄售物品 确定购买 发送到M2 20080318
    procedure SendChangeDealGold (gold: integer);
    procedure SendDealEnd;
    procedure SendAddGroupMember (withwho: string);
    procedure SendDelGroupMember (withwho: string);
    procedure SendGuildHome;
    procedure SendGuildMemberList;
    procedure SendGuildAddMem (who: string);
    procedure SendGuildDelMem (who: string);
    procedure SendBuyGameGird(GameGirdNum: Integer);  //商铺兑换灵符功能  20080302
    procedure SendGuildUpdateNotice (notices: string);
    procedure SendGuildUpdateGrade (rankinfo: string);
    procedure SendAdjustBonus (remain: integer; babil: TNakedAbility);
    procedure SendPassword(sPassword:String;nIdent:Integer);
    
    function  TargetInSwordLongAttackRange (ndir: integer): Boolean;
    function  TargetInSwordWideAttackRange (ndir: integer): Boolean;
    function  TargetInCanQTwnAttackRange(sx, sy, dx, dy: Integer): Boolean;
    function  TargetInCanTwnAttackRange(sx, sy, dx, dy: Integer): Boolean;
    function  TargetInSwordCrsAttackRange(ndir: integer): Boolean;
    procedure OnProgramException (Sender: TObject; E: Exception);
    procedure SendSocket (sendstr: string);
    function  ServerAcceptNextAction: Boolean;
    function  CanNextAction: Boolean;
    function  CanNextHit: Boolean;
    function  IsUnLockAction (action, adir: integer): Boolean;
    procedure ActiveCmdTimer (cmd: TTimerCommand);
    function  IsGroupMember (uname: string): Boolean;
    procedure SelectChr(sChrName:String);

    function  GetWStateImg(Idx:Integer): TDirectDrawSurface;overload;
    function  GetWStateImg(Idx:Integer;var ax,ay:integer): TDirectDrawSurface;overload;
    function  GetWWeaponImg(Weapon,m_btSex,nFrame:Integer;var ax,ay:integer): TDirectDrawSurface;
    function  GetWHumImg(Dress,m_btSex,nFrame:Integer;var ax,ay:integer): TDirectDrawSurface;
//    procedure ProcessCommand(sData:String);   20080723注释
    procedure TurnDuFu(pcm: PTClientMagic);  //自动换毒  20080315
    procedure SendPlayDrinkDlgSelect (merchant: integer; rstr: string);
    procedure SendPlayDrinkGame (nParam1,GameNum: integer);//发送猜拳码数
    procedure ClientGetPlayDrinkSay (merchant, who: integer; saying: string); //接收斗酒说的话
    procedure SendDrinkUpdateValue(nParam1: Integer; nPlayNum,nCode: Byte);
    procedure SendDrinkDrinkOK();
  end;
  procedure PomiTextOut (dsurface: TDirectDrawSurface; x, y: integer; str: string);
  procedure WaitAndPass (msec: longword);
  function  GetRGB (c256: byte): integer;
  procedure DebugOutStr (msg: string);

var
  //g_boShowMemoLog  :Boolean = False;   20080723注释
  frmMain          :TfrmMain;
  DScreen          :TDrawScreen;
  IntroScene       :TIntroScene;
  LoginScene       :TLoginScene;
  SelectChrScene   :TSelectChrScene;
  PlayScene        :TPlayScene;
  LoginNoticeScene :TLoginNotice;
  LocalLanguage    :TImeMode =imChinese {imSHanguel//这个是韩文}; //语言 2007.10.17 清清
  MP3              :TMPEG;
  BGMusicList      :TStringList;
  EventMan         :TClEventManager;
  KornetWorld      :TKornetWorld;
  Map              :TMap;
  BoOneClick       :Boolean;
  OneClickMode     :TOneClickMode;
  m_boPasswordIntputStatus:Boolean = False;

implementation

uses Browser, FState;

{$R *.DFM}
{  20080723注释
var
  ShowMsgActor:TActor;
}
(*function  CheckMirProgram: Boolean;
var
   pstr, cstr: array[0..255] of char;
   mirapphandle: HWnd;
begin
   Result := FALSE;
   StrPCopy (pstr, 'legend of mir');
   mirapphandle := FindWindow (nil, pstr);
   if (mirapphandle <> 0) and (mirapphandle <> Application.Handle) then begin
{$IFNDEF COMPILE}
      SetActiveWindow(mirapphandle);
      Result := TRUE;
{$ENDIF}
      exit;
   end;
end; *)

procedure PomiTextOut (dsurface: TDirectDrawSurface; x, y: integer; str: string);
var
   i, n: integer;
   d: TDirectDrawSurface;
begin
   if Length(str)<=0 then Exit;    //20080629
   for i:=1 to Length(str) do begin
      n := byte(str[i]) - byte('0');
      if (n >= 0) and (n <= 9) then begin
      //if n in [0..9] then begin 20080823
         d := g_WMainImages.Images[30 + n];
         if d <> nil then
            dsurface.Draw (x + i*8, y, d.ClientRect, d, TRUE);
      end else begin
         if str[i] = '-' then begin
            d := g_WMainImages.Images[40];
            if d <> nil then
               dsurface.Draw (x + i*8, y, d.ClientRect, d, TRUE);
         end;
      end;
   end;
end;

procedure WaitAndPass (msec: longword);
var
   start: longword;
begin
   start := GetTickCount;
   while GetTickCount - start < msec do begin
      Application.ProcessMessages;
   end;
end;


function  GetRGB (c256: byte): integer;
begin
  with frmMain.DxDraw do
    Result:=RGB(DefColorTable[c256].rgbRed,
                DefColorTable[c256].rgbGreen,
                DefColorTable[c256].rgbBlue);
end;

procedure DebugOutStr (msg: string);
var
   flname: string;
   fhandle: TextFile;
begin
   flname := BugFile;
   if FileExists(flname) then begin
      AssignFile (fhandle, flname);
      Append (fhandle);
   end else begin
      AssignFile (fhandle, flname);
      Rewrite (fhandle);
   end;
   WriteLn (fhandle, TimeToStr(Time) + ' ' + msg);
   CloseFile (fhandle);
end;

function KeyboardHookProc (Code: Integer; WParam: Longint; var Msg: TMsg): Longint; stdcall;
begin
   Result:=0;//jacky
   if ((WParam = 9){ or (WParam = 13)}) and (g_nLastHookKey = 18) and (GetTickCount - g_dwLastHookKeyTime < 500) then begin
      if FrmMain.WindowState <> wsMinimized then begin
         FrmMain.WindowState := wsMinimized;
      end else
         Result := CallNextHookEx(g_ToolMenuHook, Code, WParam, Longint(@Msg));
      exit;
   end;
   g_nLastHookKey := WParam;
   g_dwLastHookKeyTime := GetTickCount;

   Result := CallNextHookEx(g_ToolMenuHook, Code, WParam, Longint(@Msg));
end;

//--------------------------------------------------------
//20080104  英雄带忠字图标(加载uib后缀文件)         20080805注释
{procedure TfrmMain.LoadUib;
begin
  try
   UiDxImageList.Items[0].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'HeroStatusWindow.uib'));
   UiDxImageList.Items[1].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'BookBkgnd.uib'));
   UiDxImageList.Items[2].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'BookCloseDown.uib'));
   UiDxImageList.Items[3].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'BookCloseNormal.uib'));
   UiDxImageList.Items[4].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'BookNextPageDown.uib'));
   UiDxImageList.Items[5].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'BookNextPageNormal.uib'));
   UiDxImageList.Items[6].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'BookPrevPageDown.uib'));
   UiDxImageList.Items[7].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'BookPrevPageNormal.uib'));
   UiDxImageList.Items[8].Picture.Bitmap.LoadFromFile(Pchar(BookImageDir+'1\'+'1.uib'));
   UiDxImageList.Items[9].Picture.Bitmap.LoadFromFile(Pchar(BookImageDir+'1\'+'2.uib'));
   UiDxImageList.Items[10].Picture.Bitmap.LoadFromFile(Pchar(BookImageDir+'1\'+'3.uib'));
   UiDxImageList.Items[11].Picture.Bitmap.LoadFromFile(Pchar(BookImageDir+'1\'+'4.uib'));
   UiDxImageList.Items[12].Picture.Bitmap.LoadFromFile(Pchar(BookImageDir+'1\'+'5.uib'));
   UiDxImageList.Items[13].Picture.Bitmap.LoadFromFile(Pchar(BookImageDir+'1\'+'CommandDown.uib'));
   UiDxImageList.Items[14].Picture.Bitmap.LoadFromFile(Pchar(BookImageDir+'1\'+'CommandNormal.uib'));
   UiDxImageList.Items[15].Picture.Bitmap.LoadFromFile(Pchar(BookImageDir+'2\'+'1.uib'));
   UiDxImageList.Items[16].Picture.Bitmap.LoadFromFile(Pchar(BookImageDir+'3\'+'1.uib'));
   UiDxImageList.Items[17].Picture.Bitmap.LoadFromFile(Pchar(BookImageDir+'4\'+'1.uib'));
   UiDxImageList.Items[18].Picture.Bitmap.LoadFromFile(Pchar(BookImageDir+'5\'+'1.uib'));
   UiDxImageList.Items[19].Picture.Bitmap.LoadFromFile(Pchar(BookImageDir+'6\'+'1.uib'));
   UiDxImageList.Items[20].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'301.mmap'));
   UiDxImageList.Items[21].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'vigourbar1.uib'));
   UiDxImageList.Items[22].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'vigourbar2.uib'));
   UiDxImageList.Items[23].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'BuyLingfuDown.uib'));
   UiDxImageList.Items[24].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'BuyLingfuNormal.uib'));
   UiDxImageList.Items[25].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'302.mmap'));
   UiDxImageList.Items[26].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'303.mmap'));
   UiDxImageList.Items[27].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'304.mmap'));
   UiDxImageList.Items[28].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'306.mmap'));
   UiDxImageList.Items[29].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'StateWindowHuman.uib'));
   UiDxImageList.Items[30].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'StateWindowHero.uib'));
   UiDxImageList.Items[33].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'GloryButton.uib'));
  except
    //showmessage('没找到'); //临时
  end;
end;   }
//--------------------------------------------------------

procedure TfrmMain.FormCreate(Sender: TObject);
var
  flname: string;
  ini: TIniFile;
begin
   g_DWinMan:=TDWinManager.Create(Self);
   g_DXDraw:=DXDraw;
   g_sGameESystem := '';
   Randomize;
   ini := TIniFile.Create (decrypt('26546A647D6D717D6D26616661',CertKey('?-W')));  //.\blueyue.ini
   if ini <> nil then begin
      g_sServerAddr := ini.ReadString ('Setup', 'ServerAddr', g_sServerAddr);
      g_sServerAddr := decrypt(g_sServerAddr,CertKey('?-W'));
      g_sServerPort := ini.ReadString ('Setup','ServerPort', g_SServerPort);
      g_sServerPort := decrypt(g_sServerPort,CertKey('?-W'));
      g_nServerPort :=  StrToInt(g_sServerPort);
      LocalLanguage := imOpen;
      g_sMainParam1:=Ini.ReadString('Setup', 'Param1', '');
      g_sMainParam2:=Ini.ReadString('Setup', 'Param2', '');
   end;
   ini.Free;
   ini:=TIniFile.Create(decrypt('26546A647D6D717D6D26616661',CertKey('?-W'))); //.\blueyue.ini
      if ini <> nil then begin
     g_sLogoText:=Ini.ReadString('Server', 'Server1Caption',g_sLogoText);
     g_sLogoText:=decrypt(g_sLogoText, CertKey('?-W'));
     g_sGameESystem := ini.ReadString ('Server', 'GameESystem', g_sGameESystem);
     g_sGameESystem:=decrypt(g_sGameESystem, CertKey('?-W'));
   end;
   ini.Free;

   Caption:=g_sLogoText;
   //g_boFullScreen := False;
   if g_boFullScreen then
   begin
     DXDraw.Options:=DXDraw.Options + [doFullScreen];
   end
   else  FrmMain.BorderStyle := bsSingle;
   LoadWMImagesLib(nil);
   m_dwUiMemChecktTick := GetTickCount;
   //NpcImageList:=TList.Create;
   //ItemImageList:=TList.Create;
   //WeaponImageList:=TList.Create;
   //HumImageList:=TList.Create;
   g_RoadList := TList.Create; //20080617 自动寻路列表
   try
     g_DXSound:=TDXSound.Create(Self);
     g_DXSound.Initialize;
   except
     //ShowMessage('没有检测到你机器的声卡驱动，请安装声卡驱动!');
   end;

   DXDraw.Display.Width:=SCREENWIDTH;
   DXDraw.Display.Height:=SCREENHEIGHT;
   //
    if g_DXSound.Initialized then begin
      g_Sound:= TSoundEngine.Create (g_DXSound.DSound);
      MP3:=TMPEG.Create(nil);
    end else begin
      g_Sound:= nil;
      MP3:=nil;
    end;
    
   g_ToolMenuHook := SetWindowsHookEx(WH_KEYBOARD, @KeyboardHookProc, 0, GetCurrentThreadID);
   g_SoundList := TStringList.Create;
   BGMusicList:=TStringList.Create;
   flname := '.\wav\sound.lst';  //清清   声音修复 2007.10.16
   LoadSoundList (flname);
   flname := '.\wav\BGList.lst'; //背景音乐  清清 2007.10.16
   LoadBGMusicList(flname);
   DScreen := TDrawScreen.Create;
   IntroScene := TIntroScene.Create;
   LoginScene := TLoginScene.Create;
   SelectChrScene := TSelectChrScene.Create;
   PlayScene := TPlayScene.Create;
   LoginNoticeScene := TLoginNotice.Create;
   Map              := TMap.Create;
   g_DropedItemList := TList.Create;
   g_MagicList      := TList.Create;
   g_InternalForceMagicList := TList.Create;
   g_HeroInternalForceMagicList := TList.Create;
   g_HeroMagicList := TList.Create;//2007.10.25增加英雄技能表初始化
   g_ShopItemList := TList.Create;//商铺物品列表初始化 清清 2007.11.14
   g_BoxsItemList := TList.Create;//宝箱物品列表初始化 2008.01.16
   g_NpcRandomDrinkList := TList.Create; //初始化酒馆NPC随机选酒 20080518
   g_AutoPickupList :=TList.Create;
   g_ShopSpeciallyItemList := TList.Create;
   g_UnBindList := TList.Create;
   m_PlayObjectLevelList:=TList.Create;  //人物等级排行
   m_WarrorObjectLevelList:=Tlist.Create; //战士等级排行
   m_WizardObjectLevelList:=Tlist.Create; //法师等级排行
   m_TaoistObjectLevelList:=Tlist.Create; //道士等级排行
   m_PlayObjectMasterList:=Tlist.Create; //徒弟数排行
   m_HeroObjectLevelList:=Tlist.Create; //英雄等级排行
   m_WarrorHeroObjectLevelList:=Tlist.Create; //英雄战士等级排行
   m_WizardHeroObjectLevelList:=Tlist.Create; //英雄法师等级排行
   m_TaoistHeroObjectLevelList:=Tlist.Create; //英雄道士等级排行
{******************************************************************************}
//关系系统
   g_FriendList := TStringList.Create;
   g_HeiMingDanList := TStringList.Create;
{******************************************************************************}
   g_FreeActorList    := TList.Create;
   EventMan := TClEventManager.Create;
   g_ChangeFaceReadyList := TList.Create;
   g_ServerList:=TStringList.Create;
   g_MySelf := nil;
{******************************************************************************}
   FillChar (g_SellOffItems, SizeOf(TClientItem)*9, #0); //初始化寄售物品
   FillChar (g_UseItems, sizeof(TClientItem)*14, #0);
   FillChar (g_BoxsItems, sizeof(TClientItem)*9, #0); //释放宝箱物品
   FillChar (g_SellOffItems, sizeof(TClientItem)*9, #0); //释放寄售窗口物品 20080318
   FillChar (g_SellOffInfo, sizeof(TClientDealOffInfo), #0); //清空寄售列表物品 20080318
   FillChar (g_ItemArr, sizeof(TClientItem)*MAXBAGITEMCL, #0);
   FillChar (g_DealItems, sizeof(TClientItem)*10, #0);
   FillChar (g_DealRemoteItems, sizeof(TClientItem)*20, #0);
   FillChar (g_ChallengeItems, sizeof(TClientItem)*4, #0);
   FillChar (g_ChallengeRemoteItems, sizeof(TClientItem)*4, #0);
   g_SaveItemList := TList.Create;
   g_MenuItemList := TList.Create;
   g_WaitingUseItem.Item.S.Name := ''; 
   g_EatingItem.S.Name := '';
   g_nTargetX := -1;
   g_nTargetY := -1;
   g_TargetCret := nil;
   g_FocusCret := nil;
   g_FocusItem := nil;
   g_MagicTarget := nil;
   g_boServerChanging := FALSE;
   g_boBagLoaded := FALSE;
   g_boAutoDig := FALSE;
   g_boPutBoxsKey := False; //宝箱钥匙 2008.01.16
   g_boBoxsFlash  := False; //宝箱物品闪烁 2008.01.16
   g_nDayBright := 3; //广
   g_nAreaStateValue := 0;
   g_ConnectionStep := cnsLogin;
   g_boSendLogin:=False;
   g_boServerConnected := FALSE;
   SocStr := '';
   ActionFailLock := FALSE;
   g_boMapMoving := FALSE;
   g_boMapMovingWait := FALSE;
   //g_boCheckSpeedHackDisplay := FALSE;
   g_boViewMiniMap := FALSE;
   g_boTransparentMiniMap := False;
   FailDir := 0;
   FailAction := 0;
   g_nDupSelection := 0;
   g_dwLastAttackTick := GetTickCount;
   g_dwLastMoveTick := GetTickCount;
   g_dwLatestSpellTick := GetTickCount;

   g_dwAutoPickupTick := GetTickCount;
   g_boFirstTime := TRUE;
   g_boItemMoving := FALSE;
   g_boHeroItemMoving := FALSE;//英雄移动物品
   g_HeroSelf := nil;
   g_boDoFadeIn := FALSE;
   g_boDoFadeOut := FALSE;
   g_boDoFastFadeOut := FALSE;
   //g_boAttackSlow := FALSE;   //20080816 注释 腕力不足
   g_boNextTimePowerHit := FALSE;
   g_boCanLongHit := FALSE;
   g_boCanWideHit := FALSE;
   g_boCanCrsHit   := False;
   g_boCanTwnHit   := False; //开天斩
   g_boCanQTwnHit  := False; //轻击开天斩 2008.02.12
   g_boCanCIDHit   := False;//龙影剑法
   //g_boMoveSlow := False; 20080816注释掉起步负重
   g_boNextTimeFireHit := FALSE; //关闭烈火
   g_boNextTime4FireHit := FALSE; //关闭4级烈火 20080112
   g_boNextItemDAILYHit := False; //关闭逐日剑法 20080511

   g_boNoDarkness := FALSE;
   g_SoftClosed := FALSE;
   g_boQueryPrice := FALSE;
   g_sSellPriceStr := '';

   g_boAllowGroup := FALSE;
   g_GroupMembers := TStringList.Create;

   MainWinHandle := DxDraw.Handle;

   //盔努腐, 内齿岿靛 殿..
   BoOneClick := False;
   OneClickMode := toNone;

   g_boSound:=True;
   g_boBGSound:=True;

   if g_sMainParam1 = '' then begin
     CSocket.Address:=g_sServerAddr;
     CSocket.Port:=g_nServerPort;
   end else begin
      if (g_sMainParam1 <> '') and (g_sMainParam2 = '') then
         CSocket.Address := g_sMainParam1;
      if (g_sMainParam2 <> '') and (g_sMainParam3 = '') then begin
         CSocket.Address := g_sMainParam1;
         CSocket.Port := Str_ToInt (g_sMainParam2, 0);
      end;
      if (g_sMainParam3 <> '') then begin
         if CompareText (g_sMainParam1, '/KWG') = 0 then begin
         end else begin
            CSocket.Address := g_sMainParam2;
            CSocket.Port := Str_ToInt (g_sMainParam3, 0);
            BoOneClick := TRUE;
         end;
      end;
   end;
   CSocket.Active:=True;
   //DebugOutStr ('----------------------- started ------------------------');

   Application.OnException := OnProgramException;
   Application.OnIdle := AppOnIdle;  //程序空闲的时候执行此过
end;

procedure TfrmMain.OnProgramException (Sender: TObject; E: Exception);
begin
   DebugOutStr (E.Message);
end;

procedure TfrmMain.WMSysCommand(var Message: TWMSysCommand);
begin
   inherited;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  g_AutoPickupList.Free;
  g_AutoPickupList:=nil;
   if g_ToolMenuHook <> 0 then UnhookWindowsHookEx(g_ToolMenuHook);
   Timer1.Enabled := FALSE;
   MinTimer.Enabled := FALSE;
   UnLoadWMImagesLib();
   DScreen.Finalize;
   PlayScene.Finalize;
   LoginNoticeScene.Finalize;
   DScreen.Free;
   IntroScene.Free;
   LoginScene.Free;
   SelectChrScene.Free;
   PlayScene.Free;
   LoginNoticeScene.Free;
   g_SaveItemList.Free;
   g_MenuItemList.Free;
   g_RoadList.Free; //20080718释放内存
   //DebugOutStr ('----------------------- closed -------------------------');
   Map.Free;
   MP3.Free; //20080319
   for i:=0 to g_DropedItemList.Count - 1  do begin  //20080718释放内存
    if PTDropItem(g_DropedItemList.Items[i]) <> nil then
      Dispose(PTDropItem(g_DropedItemList.Items[i]));
   end;
   FreeAndNil(g_DropedItemList);

   for i:=0 to g_MagicList.Count - 1  do begin
    if pTClientMagic(g_MagicList.Items[i]) <> nil then
      Dispose(pTClientMagic(g_MagicList.Items[i]));
   end;
   FreeAndNil(g_MagicList);

   if g_InternalForceMagicList.Count > 0 then begin
     for I:=0 to g_InternalForceMagicList.Count - 1 do begin
       if pTClientMagic(g_InternalForceMagicList.Items[I]) <> nil then
        Dispose(pTClientMagic(g_InternalForceMagicList.Items[I]));
     end;
   end;
   FreeAndNil(g_InternalForceMagicList);

   if g_HeroInternalForceMagicList.Count > 0 then begin
     for I:=0 to g_HeroInternalForceMagicList.Count - 1 do begin
       if pTClientMagic(g_HeroInternalForceMagicList.Items[I]) <> nil then
        Dispose(pTClientMagic(g_HeroInternalForceMagicList.Items[I]));
     end;
   end;
   FreeAndNil(g_HeroInternalForceMagicList);

   if g_FilterItemNameList <> nil then begin
     if g_FilterItemNameList.Count > 0 then begin//20080629
        for I := 0 to g_FilterItemNameList.Count - 1 do
          if pTShowItem(g_FilterItemNameList.Items[I]) <> nil then
            DisPose(pTShowItem(g_FilterItemNameList.Items[I]));
     end;
   end;
   FreeAndNil(g_FilterItemNameList);
   if g_UnBindList <> nil then begin
     for I:=0 to g_UnBindList.Count -1 do
       if pTUnbindInfo(g_UnBindList.Items[I]) <> nil then Dispose(pTUnbindInfo(g_UnBindList.Items[I]));
   end;
   FreeAndNil(g_UnBindList);

   for i:=0 to g_HeroMagicList.Count - 1  do begin
    if pTClientMagic(g_HeroMagicList.Items[i]) <> nil then
      Dispose(pTClientMagic(g_HeroMagicList.Items[i]));
   end;
   FreeAndNil(g_HeroMagicList);

   for i:=0 to g_ShopItemList.Count - 1  do begin
    if pTShopInfo(g_ShopItemList.Items[i]) <> nil then
      Dispose(pTShopInfo(g_ShopItemList.Items[i]));
   end;
   FreeAndNil(g_ShopItemList);
   for i:=0 to g_BoxsItemList.Count - 1  do begin
    if pTBoxsInfo(g_BoxsItemList.Items[i]) <> nil then
      Dispose(pTBoxsInfo(g_BoxsItemList.Items[i]));
   end;
   FreeAndNil(g_BoxsItemList);
   //g_BoxsItemList.Free; //宝箱物品列表释放 2008.01.16
   g_NpcRandomDrinkList.Free;
   for i:=0 to g_ShopSpeciallyItemList.Count - 1  do begin
    if pTBoxsInfo(g_ShopSpeciallyItemList.Items[i]) <> nil then
      Dispose(pTBoxsInfo(g_ShopSpeciallyItemList.Items[i]));
   end;
   FreeAndNil(g_ShopSpeciallyItemList);

   for I:=0 to m_PlayObjectLevelList.Count - 1 do begin
     if pTUserLevelSort(m_PlayObjectLevelList[I]) <> nil then
      Dispose(pTUserLevelSort(m_PlayObjectLevelList[I]));
   end;
   FreeAndNil(m_PlayObjectLevelList);

   for I:=0 to m_WarrorObjectLevelList.Count - 1 do begin //战士等级排行
     if pTUserLevelSort(m_WarrorObjectLevelList[I]) <> nil then
      Dispose(pTUserLevelSort(m_WarrorObjectLevelList[I]));
   end;
   FreeAndNil(m_WarrorObjectLevelList);

   for I:=0 to m_WizardObjectLevelList.Count - 1 do begin //法师等级排行
     if pTUserLevelSort(m_WizardObjectLevelList[I]) <> nil then
      Dispose(pTUserLevelSort(m_WizardObjectLevelList[I]));
   end;
   FreeAndNil(m_WizardObjectLevelList);

   for I:=0 to m_TaoistObjectLevelList.Count - 1 do begin //道士等级排行
     if pTUserLevelSort(m_TaoistObjectLevelList[I]) <> nil then
      Dispose(pTUserLevelSort(m_TaoistObjectLevelList[I]));
   end;
   FreeAndNil(m_TaoistObjectLevelList);


   for I:=0 to m_PlayObjectMasterList.Count - 1 do begin //徒弟数排行
     if pTUserMasterSort(m_PlayObjectMasterList[I]) <> nil then
      Dispose(pTUserMasterSort(m_PlayObjectMasterList[I]));
   end;
   FreeAndNil(m_PlayObjectMasterList);
   //m_WizardObjectLevelList.Free; //法师等级排行
  // m_TaoistObjectLevelList.Free; //道士等级排行
   //m_PlayObjectMasterList.Free; //徒弟数排行
   for I:=0 to m_HeroObjectLevelList.Count - 1 do begin //英雄等级排行
     if pTHeroLevelSort(m_HeroObjectLevelList[I]) <> nil then
      Dispose(pTHeroLevelSort(m_HeroObjectLevelList[I]));
   end;
   FreeAndNil(m_HeroObjectLevelList);

   for I:=0 to m_WarrorHeroObjectLevelList.Count - 1 do begin //英雄战士等级排行
     if pTHeroLevelSort(m_WarrorHeroObjectLevelList[I]) <> nil then
      Dispose(pTHeroLevelSort(m_WarrorHeroObjectLevelList[I]));
   end;
   FreeAndNil(m_WarrorHeroObjectLevelList);

   for I:=0 to m_WizardHeroObjectLevelList.Count - 1 do begin //英雄法师等级排行
     if pTHeroLevelSort(m_WizardHeroObjectLevelList[I]) <> nil then
      Dispose(pTHeroLevelSort(m_WizardHeroObjectLevelList[I]));
   end;
   FreeAndNil(m_WizardHeroObjectLevelList);

   for I:=0 to m_TaoistHeroObjectLevelList.Count - 1 do begin //英雄法师等级排行
     if pTHeroLevelSort(m_TaoistHeroObjectLevelList[I]) <> nil then
      Dispose(pTHeroLevelSort(m_TaoistHeroObjectLevelList[I]));
   end;
   FreeAndNil(m_TaoistHeroObjectLevelList);
   //m_HeroObjectLevelList.Free; //英雄等级排行
   //m_WarrorHeroObjectLevelList.Free; //英雄战士等级排行
   //m_WizardHeroObjectLevelList.Free; //英雄法师等级排行
   //m_TaoistHeroObjectLevelList.Free; //英雄道士等级排行


  if g_FreeActorList.Count > 0 then begin   //释放主类 20080718
    for I := 0 to g_FreeActorList.Count - 1 do
      if TActor(g_FreeActorList[I]) <> nil then TActor(g_FreeActorList[I]).Free;
  end;
  FreeAndNil(g_FreeActorList);
   g_ChangeFaceReadyList.Free;

   g_ServerList.Free;
   g_GroupMembers.Free; //20080528
   g_FriendList.Free;
   g_HeiMingDanList.Free;


   FreeAndNil(g_Sound);
   g_SoundList.Free;
   BGMusicList.Free;
   EventMan.Free;
   //NpcImageList.Free;
   //ItemImageList.Free;
   //WeaponImageList.Free;
   //HumImageList.Free;
   //g_MySelf.Free;
   g_DXSound.Finalize;  //20080718注释释放内存
   FreeAndNil(g_DXSound);
   g_DWinMan.Free;
   //Application.Terminate;
end;

{function ComposeColor(Dest, Src: TRGBQuad; Percent: Integer): TRGBQuad;
begin
  with Result do
  begin
    rgbRed := Src.rgbRed+((Dest.rgbRed-Src.rgbRed)*Percent div 256);
    rgbGreen := Src.rgbGreen+((Dest.rgbGreen-Src.rgbGreen)*Percent div 256);
    rgbBlue := Src.rgbBlue+((Dest.rgbBlue-Src.rgbBlue)*Percent div 256);
    rgbReserved := 0;
  end;
end;   }

procedure TfrmMain.DXDrawInitialize(Sender: TObject);
begin
   if g_boFirstTime then begin

      g_boFirstTime := FALSE;
      DxDraw.SurfaceWidth := SCREENWIDTH;
      DxDraw.SurfaceHeight := SCREENHEIGHT;
(*{$IF USECURSOR = DEFAULTCURSOR}
      DxDraw.Cursor:=crHourGlass;
      showmessage('crHourGlass');
{$ELSE}
      DxDraw.Cursor:=crNone;
{$IFEND} *)

      DxDraw.Surface.Canvas.Font.Assign (FrmMain.Font);
      FrmMain.Font.Name := g_sCurFontName;
      FrmMain.Canvas.Font.Name := g_sCurFontName;
      DxDraw.Surface.Canvas.Font.Name := g_sCurFontName;
      PlayScene.EdChat.Font.Name := g_sCurFontName;
      //MainSurface := TDirectDrawSurface.Create (frmMain.DxDraw.DDraw);
      //MainSurface.SystemMemory := TRUE;
      //MainSurface.SetSize (SCREENWIDTH, SCREENHEIGHT);
      InitWMImagesLib(DxDraw);
      InitMonImg();
      InitObjectImg();
      DxDraw.DefColorTable := g_WMainImages.MainPalette;
      DxDraw.ColorTable := DxDraw.DefColorTable;
      DxDraw.UpdatePalette;

      //256 Blend utility
      if not LoadNearestIndex (NEARESTPALETTEINDEXFILE) then begin
         BuildNearestIndex (DxDraw.ColorTable);
         SaveNearestIndex (NEARESTPALETTEINDEXFILE);
      end;

      BuildColorLevels (DxDraw.ColorTable);
      BuildRealRGB(DxDraw.ColorTable);//解决火龙教主引起程序崩溃问题  20080608
      DScreen.Initialize;
      PlayScene.Initialize;
      FrmDlg.Initialize;   //这地方占时间
     if doFullScreen in DxDraw.Options then begin
      end else begin
         FrmMain.ClientWidth := SCREENWIDTH;
         FrmMain.ClientHeight := SCREENHEIGHT;
         g_boNoDarkness := TRUE;
         g_boUseDIBSurface := TRUE;
      end;
      g_ImgMixSurface := TDirectDrawSurface.Create (frmMain.DxDraw.DDraw);
      g_ImgMixSurface.SystemMemory := TRUE;
      g_ImgMixSurface.SetSize (300, 350);
   end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   //Savebags ('.\Data\' + ServerName + '.' + CharName + '.itm', @ItemArr);
   //DxTimer.Enabled := FALSE;
   //SaveUserConfig(CharName);
   SaveFriendList();
   SaveHeiMingDanList();
   //application.Terminate;
end;


{------------------------------------------------------------}

procedure TfrmMain.ProcOnIdle;
var
   done: Boolean;
begin
   AppOnIdle (self, done);
end;

procedure TfrmMain.AppOnIdle (Sender: TObject; var Done: Boolean);
var
   p: TPoint;
   d: TDirectDrawSurface;
begin
   Done := TRUE;
   if not DxDraw.CanDraw then Exit;
   ProcessKeyMessages;
   ProcessActionMessages;
   DScreen.DrawScreen (DxDraw.Surface);
   g_DWinMan.DirectPaint (DxDraw.Surface);
   DScreen.DrawScreenTop (DxDraw.Surface);
   DScreen.DrawHint (DxDraw.Surface);
{$IF USECURSOR = IMAGECURSOR}
   {Draw cursor}
   //=========================================
   //显示光标
   CursorSurface := g_WMainImages.Images[0];
   if CursorSurface <> nil then begin
      GetCursorPos (p);
      DxDraw.Surface.Draw (p.x, p.y, CursorSurface.ClientRect, CursorSurface, TRUE);
   end;
   //==========================
{$IFEND}

//显示英雄的物品拿起时的外形
   if g_boHeroItemMoving then begin
      if (g_MovingHeroItem.Item.S.Name <> g_sGoldName{'金币'}) then
         d := g_WBagItemImages.Images[g_MovingHeroItem.Item.S.Looks]
      else d := g_WBagItemImages.Images[115]; //金币外形
      if d <> nil then begin
         GetCursorPos (p);
         P := ScreenToClient(p);
         DxDraw.Surface.Draw (p.x-(d.ClientRect.Right div 2),
                              p.y-(d.ClientRect.Bottom div 2),
                              d.ClientRect,
                              d,
                              TRUE);
      end;
   end;
   
   if g_boItemMoving then begin
      if (g_MovingItem.Item.S.Name <> g_sGoldName{'金币'}) then
         d := g_WBagItemImages.Images[g_MovingItem.Item.S.Looks]
      else d := g_WBagItemImages.Images[115]; //金币外形
      if d <> nil then begin
         GetCursorPos (p);
         P := ScreenToClient(P);
         DxDraw.Surface.Draw (p.x-(d.ClientRect.Right div 2),
                              p.y-(d.ClientRect.Bottom div 2),
                              d.ClientRect,
                              d,
                              TRUE);
      end;
   end;

   if g_boDoFadeOut then begin
      if g_nFadeIndex < 1 then g_nFadeIndex := 1;
      MakeDark (DxDraw.Surface, g_nFadeIndex);
      if g_nFadeIndex <= 1 then g_boDoFadeOut := FALSE
      else Dec (g_nFadeIndex, 2);
   end else
   if g_boDoFadeIn then begin
      if g_nFadeIndex > 29 then g_nFadeIndex := 29;
      MakeDark (DxDraw.Surface, g_nFadeIndex);
      if g_nFadeIndex >= 29 then g_boDoFadeIn := FALSE
      else Inc (g_nFadeIndex, 2);
   end else
   if g_boDoFastFadeOut then begin
      if g_nFadeIndex < 1 then g_nFadeIndex := 1;
      MakeDark (DxDraw.Surface, g_nFadeIndex);
      if g_nFadeIndex > 1 then Dec (g_nFadeIndex, 4);
   end;
   //登录的时候显示矩形LOGO
   if not FrmDlg.DLOGO.Visible then begin
     if g_ConnectionStep = cnsLogin then begin
       with DxDraw.Surface.Canvas do begin
         {$if Version = 1}
         SetBkMode (Handle, TRANSPARENT);
         Font.Color := $0093F4F2;
         TextOut (360, 535,'健康游戏公告');  //显示出logo文字
         TextOut (190, 553,'抵制不良游戏，拒绝盗版游戏。注意自我保护，谨防受骗上当。适度游戏益脑，');  //显示出logo文字
         TextOut (190, 571,'沉迷游戏伤身。合理安排游戏，享受健康生活。严厉打击赌博，营造和谐环境。');  //显示出logo文字
         Font.Color := clSilver;
         TextOut (690, 585,g_sVersion);
         Release;
         {$ELSE}
         ClFunc.TextOut (DxDraw.Surface, 360, 535, $0093F4F2, '健康游戏公告');
         ClFunc.TextOut (DxDraw.Surface, 190, 553, $0093F4F2, '抵制不良游戏，拒绝盗版游戏。注意自我保护，谨防受骗上当。适度游戏益脑，');  //显示出logo文字
         ClFunc.TextOut (DxDraw.Surface, 190, 571, $0093F4F2, '沉迷游戏伤身。合理安排游戏，享受健康生活。严厉打击赌博，营造和谐环境。');  //显示出logo文字
         ClFunc.TextOut (DxDraw.Surface, 690, 585, clSilver, g_sVersion);
         {$IFEND}
       end;
     end;
   end;
      // DF WindowModeFix 3
   DxDraw.Primary.Draw (0, 0, DxDraw.Surface.ClientRect, DxDraw.Surface, FALSE);
   // Needed for Drawing on monitors that are not the Primary Monitor (IE Dual Screen Systems)
end;

procedure TfrmMain.AppLogout;
begin
   if mrOk = FrmDlg.DMessageDlg ('是否确认退出？', [mbOk, mbCancel]) then begin
      SendClientMessage (CM_SOFTCLOSE, 0, 0, 0, 0);
      PlayScene.ClearActors;
      CloseAllWindows;
      if not BoOneClick then begin
         g_SoftClosed := TRUE;
         ActiveCmdTimer (tcSoftClose);
      end else begin
         ActiveCmdTimer (tcReSelConnect);
      end;
      if g_boBagLoaded then
         Savebags ('.\Config\' + '56' + g_sServerName + '.' + CharName + '.itm', @g_ItemArr);
      g_boBagLoaded := FALSE;
      g_boLoadSdoAssistantConfig := False;
      SaveFriendList();
      SaveHeiMingDanList();
   end;
end;

procedure TfrmMain.AppExit;
begin
   if mrOk = FrmDlg.DMessageDlg ('是否确认退出游戏？', [mbOk, mbCancel]) then begin
      if g_boBagLoaded then  //保存装备
         Savebags ('.\Config\' + '56' + g_sServerName + '.' + CharName + '.itm', @g_ItemArr);
      g_boBagLoaded := FALSE;
      FrmMain.Close;
   end;
end;

//拷贝屏幕
procedure TfrmMain.PrintScreenNow;
   function IntToStr2(n: integer): string;
   begin
      if n < 10 then Result := '0' + IntToStr(n)
      else Result := IntToStr(n);
   end;
var
   i,n: integer;
   flname: string;
   dib: TDIB;
   ddsd: TDDSurfaceDesc;
   sptr, dptr: PByte;
begin
   if not DxDraw.CanDraw then Exit;
   if not DirectoryExists('Images') then  CreateDir('Images'); 
   while TRUE do begin
      flname := 'Images\Images' + IntToStr2(g_nCaptureSerial) + '.bmp';
      if not FileExists (flname) then break;
      Inc (g_nCaptureSerial);
   end;
   dib := TDIB.Create;
   dib.BitCount := 8;
   dib.Width := SCREENWIDTH;
   dib.Height := SCREENHEIGHT;
   dib.ColorTable := g_WMainImages.MainPalette;
   dib.UpdatePalette;

   ddsd.dwSize := SizeOf(ddsd);
   try
      {$if Version = 1}
      SetBkMode (DxDraw.Primary.Canvas.Handle, TRANSPARENT);
      {$IFEND}
      n := 0;
      if g_MySelf <> nil then begin
         BoldTextOut (DxDraw.Primary, 0, 0, clWhite, clBlack, g_sServerName + ' ' + g_MySelf.m_sUserName);
         Inc(n, 1);
      end;
      BoldTextOut (DxDraw.Primary, 0, n*14, clWhite, clBlack, DateToStr(Date) + ' ' + TimeToStr(Time));
      DxDraw.Primary.Canvas.Release;
      DxDraw.Primary.Lock (TRect(nil^), ddsd);
      if dib.Height > 0 then //20080629
      for i := 0 to dib.Height-1 do begin
         sptr := PBYTE(integer(ddsd.lpSurface) + (dib.Height - 1 - i)*ddsd.lPitch);
         dptr := PBYTE(integer(dib.PBits) + i * SCREENWIDTH);
         Move (sptr^, dptr^, SCREENWIDTH);
      end;
   finally
      DxDraw.Primary.Unlock();
   end;
   dib.SaveToFile (flname);
   dib.Clear;
   dib.Free;
   DScreen.AddChatBoardString('[屏幕载图：Images' + IntToStr2(g_nCaptureSerial) + '.bmp]',GetRGB(219), clWhite);
end;


{------------------------------------------------------------}

procedure TfrmMain.ProcessKeyMessages;
begin
   case ActionKey of
     VK_F1, VK_F2, VK_F3, VK_F4, VK_F5, VK_F6, VK_F7, VK_F8: begin
       UseMagic (g_nMouseX, g_nMouseY, GetMagicByKey (char ((ActionKey-VK_F1) + byte('1')) ));
       ActionKey := 0;
       g_nTargetX := -1;
       exit;
     end;
     12..19: begin
       UseMagic (g_nMouseX, g_nMouseY, GetMagicByKey (char ((ActionKey-12) + byte('1') + byte($14)) ));
       ActionKey := 0;
       g_nTargetX := -1;
       exit;
     end;
   end;
end;

procedure TfrmMain.ProcessActionMessages;
var
   mx, my, dx, dy, crun: integer;
   ndir, adir, mdir: byte;
   bowalk, bostop: Boolean;
label
   LB_WALK,TTTT;
begin
   if g_MySelf = nil then Exit;

   //Move
   if (g_nTargetX >= 0) and CanNextAction and ServerAcceptNextAction then begin //ActionLock捞 钱府搁, ActionLock篮 悼累捞 场唱扁 傈俊 钱赴促.
      //需要更新坐标位置
      if (g_nTargetX <> g_MySelf.m_nCurrX) or (g_nTargetY <> g_MySelf.m_nCurrY) then begin
         TTTT:
         mx := g_MySelf.m_nCurrX;
         my := g_MySelf.m_nCurrY;
         dx := g_nTargetX;
         dy := g_nTargetY;
         ndir := GetNextDirection (mx, my, dx, dy);
         //当前动作
         case g_ChrAction of
            caWalk: begin
               LB_WALK:
               crun := g_MySelf.CanWalk;
               if IsUnLockAction (CM_WALK, ndir) and (crun > 0) then begin
                  GetNextPosXY (ndir, mx, my);
                  //bowalk := TRUE;
                  bostop := FALSE;
                  if not PlayScene.CanWalk (mx, my) then begin
                     bowalk := FALSE;
                     adir := 0;
                     if not bowalk then begin  //涝备 八荤
                        mx := g_MySelf.m_nCurrX;
                        my := g_MySelf.m_nCurrY;
                        GetNextPosXY (ndir, mx, my);
                        if CheckDoorAction (mx, my) then
                           bostop := TRUE;
                     end;
                     if not bostop and not PlayScene.CrashMan(mx,my) then begin //荤恩篮 磊悼栏肺 乔窍瘤 臼澜..
                        mx := g_MySelf.m_nCurrX;
                        my := g_MySelf.m_nCurrY;
                        adir := PrivDir(ndir);
                        GetNextPosXY (adir, mx, my);
                        if not Map.CanMove(mx,my) then begin
                           mx := g_MySelf.m_nCurrX;
                           my := g_MySelf.m_nCurrY;
                           adir := NextDir (ndir);
                           GetNextPosXY (adir, mx, my);
                           if Map.CanMove(mx,my) then
                              bowalk := TRUE;
                        end else
                           bowalk := TRUE;
                     end;
                     if bowalk then begin
                        g_MySelf.UpdateMsg (CM_WALK, mx, my, adir, 0, 0, '', 0);
                        g_dwLastMoveTick := GetTickCount;
                     end else begin
                        mdir := GetNextDirection (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, dx, dy);
                        if mdir <> g_MySelf.m_btDir then
                           g_MySelf.SendMsg (CM_TURN, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, 0, 0, '', 0);
                        g_nTargetX := -1;
                     end;
                  end else begin
                     g_MySelf.UpdateMsg (CM_WALK, mx, my, ndir, 0, 0, '', 0);  //亲惑 付瘤阜 疙飞父 扁撅
                     g_dwLastMoveTick := GetTickCount;
                  end;
               end else begin
                  g_nTargetX := -1;
               end;
            end;
            caRun: begin
               //免助跑
               if g_boCanStartRun or (g_nRunReadyCount >= 1) then begin
                  crun := g_MySelf.CanRun;
{
20080721 注释骑马
//骑马开始
                  if (g_MySelf.m_btHorse <> 0)
                     and (GetDistance (mx, my, dx, dy) >= 3)
                     and (crun > 0)
                     and IsUnLockAction (CM_HORSERUN, ndir) then begin
                    GetNextHorseRunXY (ndir, mx, my);
                    if PlayScene.CanRun (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mx, my) then begin
                      g_MySelf.UpdateMsg (CM_HORSERUN, mx, my, ndir, 0, 0, '', 0);
                      g_dwLastMoveTick := GetTickCount;
                     end else begin  //如果跑失败则跳回去走
                        g_ChrAction:=caWalk;
                        goto TTTT;
                     end;
                  end else begin
//骑马结束  }
                    if (GetDistance (mx, my, dx, dy) >= 2) and (crun > 0) then begin
                       if IsUnLockAction (CM_RUN, ndir) then begin
                          GetNextRunXY (ndir, mx, my);
                          if PlayScene.CanRun (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mx, my) then begin
                             g_MySelf.UpdateMsg (CM_RUN, mx, my, ndir, 0, 0, '', 0);
                             g_dwLastMoveTick := GetTickCount;
                          end else begin  //如果跑失败则跳回去走
                            g_ChrAction:=caWalk;
                            goto TTTT;
                          end;
                       end else
                          g_nTargetX := -1;
                    end else begin
                      mdir := GetNextDirection (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, dx, dy);
                      if mdir <> g_MySelf.m_btDir then
                         g_MySelf.SendMsg (CM_TURN, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, 0, 0, '', 0);
                      g_nTargetX := -1;
                       goto LB_WALK;
                    end;
                  //end;  //骑马结束 20080721 注释骑马
               end else begin
                  Inc (g_nRunReadyCount);
                  goto LB_WALK;
               end;
            end;
         end;
      end;
   end;
   g_nTargetX := -1; //茄锅俊 茄沫究..
   if g_MySelf.RealActionMsg.Ident > 0 then begin
      FailAction := g_MySelf.RealActionMsg.Ident; //角菩且锭 措厚
      FailDir := g_MySelf.RealActionMsg.Dir;
      if g_MySelf.RealActionMsg.Ident = CM_SPELL then begin
         SendSpellMsg (g_MySelf.RealActionMsg.Ident,
                       g_MySelf.RealActionMsg.X,
                       g_MySelf.RealActionMsg.Y,
                       g_MySelf.RealActionMsg.Dir,
                       g_MySelf.RealActionMsg.State);
      end else
         SendActMsg (g_MySelf.RealActionMsg.Ident,
                  g_MySelf.RealActionMsg.X,
                  g_MySelf.RealActionMsg.Y,
                  g_MySelf.RealActionMsg.Dir);
      g_MySelf.RealActionMsg.Ident := 0;

      //玩家离NPC远了 关闭NPC窗口
      if g_nMDlgX <> -1 then
         if (abs(g_nMDlgX-g_MySelf.m_nCurrX) >= 8) or (abs(g_nMDlgY-g_MySelf.m_nCurrY) >= 8) then begin
            FrmDlg.CloseMDlg;
            g_nMDlgX := -1;
         end;
   end;
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  sel: Integer;
  msgs:TDefaultMessage;
  target: TActor;
begin
  if FrmDlg.DLOGO.Visible then begin
     FrmDlg.DLOGOClick(FrmDlg.DLOGO, 0, 0);
  end;
  case Key of
    VK_PAUSE: begin// 拷贝屏幕
      Key:=0;
      PrintScreenNow();
    end;
  end;
  //g_DWinMan.KeyDown (Key, Shift);
  if g_DWinMan.KeyDown (Key, Shift) then exit;
  if (g_MySelf = nil) or (DScreen.CurrentScene <> PlayScene) then exit;
  case Key of
    VK_F1, VK_F2, VK_F3, VK_F4,
    VK_F5, VK_F6, VK_F7, VK_F8: begin

        if g_boAutoMagic and (g_nAutoMagicKey = Key) then begin
          g_nAutoMagicKey := 0;
          g_boAutoMagic := False;
          FrmDlg.DCheckSdoAutoMagic.Checked := False;
          DScreen.AddChatBoardString('自动练功结束！', clGreen, clWhite);
        end;


      if (GetTickCount - g_dwLatestSpellTick > (g_dwSpellTime + g_dwMagicDelayTime)) then begin
        if ssCtrl in Shift then begin
          ActionKey:=Key - 100;
        end else begin
          ActionKey:=Key;
        end;
      end;

      Key:=0;
    end;
    VK_F9: begin
      FrmDlg.OpenItemBag;
    end;
    VK_F10: begin
      FrmDlg.StatePage := 0;
      FrmDlg.StateTab := 0;
      FrmDlg.OpenMyStatus;
    end;
    VK_F11: begin
      FrmDlg.StateTab := 0;
      FrmDlg.StatePage := 3;
      FrmDlg.OpenMyStatus;
    end;

    VK_F12: begin
        OpenSdoAssistant();
    end;
    VK_ESCAPE: begin//ESC      20080314
      if g_boDownEsc then Exit;
      g_boDownEsc := True; //按下了ESC键
      g_boTempShowItem := g_boShowAllItem;
      g_boTempFilterItemShow := g_boFilterAutoItemShow;
      g_boShowAllItem := True;
      g_boFilterAutoItemShow := False;
    end;
    VK_TAB: begin     //切换小地图
         if not g_boViewMiniMap then begin
            if GetTickCount > g_dwQueryMsgTick then begin
               g_dwQueryMsgTick := GetTickCount + 3000;
               FrmMain.SendWantMiniMap;
               g_nViewMinMapLv:=1;
               FrmDlg.DWMiniMap.Left := SCREENWIDTH - 120; //20080323
               FrmDlg.DWMiniMap.Width := 120; //20080323
               FrmDlg.DWMiniMap.Height:= 120; //20080323
            end;
         end else begin
           if g_nViewMinMapLv >= 2 then begin
             g_nViewMinMapLv:=0;
             g_boViewMiniMap := FALSE;
             FrmDlg.DWMiniMap.Visible := False; //20080323
           end else begin
             Inc(g_nViewMinMapLv);
             FrmDlg.DWMiniMap.Left := SCREENWIDTH - 160; //20080323
             FrmDlg.DWMiniMap.Width := 160; //20080323
             FrmDlg.DWMiniMap.Height:= 160; //20080323
           end;
         end;
    end;

    word('H'): begin
      if ssCtrl in Shift then begin
        SendSay ('@AttackMode');
      end;
    end;

    word('E'): begin       //英雄攻击模式 清清$014  2007.10.23
      if ssCtrl in Shift then begin
        msgs:=MakeDefaultMsg (CM_HEROCHGSTATUS, 0, 0, 0, 0, Certification);
        FrmMain.SendSocket (EncodeMessage (msgs));
      end;
      if ssAlt in Shift then begin  //删除队员 20080424
        if g_FocusCret <> nil then
          SendDelGroupMember(g_FocusCret.m_sUserName)
      end;
    end;
    word('B'): begin //打开商铺
      if ssCtrl in Shift then begin
        if FrmDlg.DShop.Visible then
          FrmDlg.DShop.Visible := False
        else
          FrmDlg.DBotMemoClick(FrmDlg.DBotMemo,0,0);
      end;
    end;
    word('W'): begin       //英雄锁定攻击 清清$015  2007.10.23
      if ssCtrl in Shift then begin
        target := PlayScene.GetAttackFocusCharacter (g_nMouseX, g_nMouseY, 0,sel,FALSE); //取指定坐标上的角色
        if target <> nil then begin
          msgs:=MakeDefaultMsg (CM_HEROATTACKTARGET, target.m_nRecogId, target.m_nCurrX, target.m_nCurrY, 0, Certification);
          FrmMain.SendSocket (EncodeMessage (msgs));
        end;
      end;
      if ssAlt in Shift then begin  //添加遍组  20080424
        if g_FocusCret <> nil then
           if g_GroupMembers.Count = 0 then
              SendCreateGroup(g_FocusCret.m_sUserName)
           else SendAddGroupMember(g_FocusCret.m_sUserName);
      end;
    end;
    word('S'): begin       //英雄合击 清清$014  2007.10.26
      if ssCtrl in Shift then begin
        {g_dwMagicDelayTime := 3000;
        msgs:=MakeDefaultMsg (CM_HEROGOTETHERUSESPELL, 0, 0, 0, 0, Certification);
        FrmMain.SendSocket (EncodeMessage (msgs));   }
        UseMagic(5000,5000,nil);
      end;
      if ssAlt in Shift then begin
        if (g_FocusCret.m_sUserName <> '') and (g_FocusCret.m_btRace = 0) then begin
          if InHeiMingDanListOfName(g_FocusCret.m_sUserName) then begin
            g_HeiMingDanList.Delete(g_HeiMingDanList.IndexOf(g_FocusCret.m_sUserName));
            DScreen.AddChatBoardString('您已经将'+g_FocusCret.m_sUserName+'从黑名单中清除', clGreen, clWhite);
          end else begin
            g_HeiMingDanList.Add(g_FocusCret.m_sUserName);
            DScreen.AddChatBoardString('您已经将'+g_FocusCret.m_sUserName+'放入黑名单', clGreen, clWhite);
          end;
        end;
      end;
    end;
    word('Q'): begin       //英雄守护位置 2007.11.8
      if ssCtrl in Shift then begin
      msgs:=MakeDefaultMsg (CM_HEROPROTECT, 0, g_nMouseCurrX, g_nMouseCurry, 0, Certification);
      FrmMain.SendSocket (EncodeMessage (msgs));
      end;
      
      if g_MySelf = nil then exit;
      if ssAlt in Shift then begin
         //强行退出
         g_dwLatestStruckTick:=GetTickCount() + 10001;
         g_dwLatestMagicTick:=GetTickCount() + 10001;
         g_dwLatestHitTick:=GetTickCount() + 10001;
         //
         if (GetTickCount - g_dwLatestStruckTick > 10000) and
            (GetTickCount - g_dwLatestMagicTick > 10000) and
            (GetTickCount - g_dwLatestHitTick > 10000) or
            (g_MySelf.m_boDeath) then
         begin
            AppExit;
         end else
            DScreen.AddChatBoardString ('你不能在战斗状态结束游戏.', clYellow, clRed);
      end;
    end;
    word('A'): begin
      if ssCtrl in Shift then begin
        SendSay ('@Rest');
      end;
    end;

    word(192): begin   //快速拣取物品 ~键  20080308
      if not PlayScene.EdChat.Visible then begin
        if CanNextAction and ServerAcceptNextAction then
          SendPickup; //捡物品
      end;
    end;
      word('X'):
         begin
            if g_MySelf = nil then exit;
            if ssAlt in Shift then begin
               //强行退出
               g_dwLatestStruckTick:=GetTickCount() + 10001;
               g_dwLatestMagicTick:=GetTickCount() + 10001;
               g_dwLatestHitTick:=GetTickCount() + 10001;
               //
               if (GetTickCount - g_dwLatestStruckTick > 10000) and
                  (GetTickCount - g_dwLatestMagicTick > 10000) and
                  (GetTickCount - g_dwLatestHitTick > 10000) or
                  (g_MySelf.m_boDeath) then
               begin
                  AppLogOut;
               end else
                  DScreen.AddChatBoardString ('你不能在战斗状态结束游戏.', clYellow, clRed);
            end;
         end;
      word('R'):begin    //刷新人物和英雄包裹 20080222
         if ssAlt in Shift then begin
           if (GetTickCount - g_dwQueryItems > 5000) and (not g_MySelf.m_boDeath) then begin
              g_dwQueryItems := GetTickCount();
              if FrmDlg.DItemBag.Visible then begin
                  msgs:=MakeDefaultMsg (CM_QUERYBAGITEMS, 0, 0, 0, 0, Certification);
                  FrmMain.SendSocket (EncodeMessage (msgs));
              end;
              if FrmDlg.DHeroItemBag.Visible then begin
                  msgs:=MakeDefaultMsg (CM_QUERYHEROBAGITEMS, 0, 0, 0, 0, Certification);
                  FrmMain.SendSocket (EncodeMessage (msgs));
              end;
           end;
         end;
      end;
      {word('V'): begin
        if not PlayScene.EdChat.Visible then begin
          if not g_boViewMiniMap then begin
            if GetTickCount > g_dwQueryMsgTick then begin
              g_dwQueryMsgTick := GetTickCount + 3000;
              FrmMain.SendWantMiniMap;
              g_nViewMinMapLv:=1;
            end;
          end else begin
            if g_nViewMinMapLv >= 2 then begin
              g_nViewMinMapLv:=0;
              g_boViewMiniMap := FALSE;
            end else Inc(g_nViewMinMapLv);
          end;
        end;
      end;
      word('T'): begin
        if not PlayScene.EdChat.Visible then begin
          if GetTickCount > g_dwQueryMsgTick then begin
            g_dwQueryMsgTick := GetTickCount + 3000;
            FrmMain.SendDealTry;
          end;
        end;
      end;
      word('G'): begin
         if ssCtrl in Shift then begin
           if g_FocusCret <> nil then
             if g_GroupMembers.Count = 0 then
               SendCreateGroup(g_FocusCret.m_sUserName)
             else SendAddGroupMember(g_FocusCret.m_sUserName);
             PlayScene.EdChat.Text:=g_FocusCret.m_sUserName;
         end else begin
           if ssAlt in Shift then begin
             if g_FocusCret <> nil then
               SendDelGroupMember(g_FocusCret.m_sUserName)
           end else begin
             if not PlayScene.EdChat.Visible then begin
               if FrmDlg.DGuildDlg.Visible then begin
                 FrmDlg.DGuildDlg.Visible := FALSE;
               end else
                if GetTickCount > g_dwQueryMsgTick then begin
                  g_dwQueryMsgTick := GetTickCount + 3000;
                  FrmMain.SendGuildDlg;
               end;
             end;
           end;
         end;

      end;

      word('P'): begin
        if not PlayScene.EdChat.Visible then
          FrmDlg.ToggleShowGroupDlg;
      end;

      word('C'): begin
        if not PlayScene.EdChat.Visible then begin
          FrmDlg.StatePage := 0;
          FrmDlg.OpenMyStatus;
        end;
      end;

      word('I'): begin
        if not PlayScene.EdChat.Visible then
          FrmDlg.OpenItemBag;
      end;

      word('M'): begin
        if not PlayScene.EdChat.Visible then
          FrmDlg.OpenAdjustAbility;
      end; }
   end;
   
   case Key of
      VK_UP:
         with DScreen do begin
            if ChatBoardTop > 0 then Dec (ChatBoardTop);
         end;
      VK_DOWN:
         with DScreen do begin
            if ChatBoardTop < ChatStrs.Count-1 then
               Inc (ChatBoardTop);
         end;
      VK_PRIOR:
         with DScreen do begin
            if ChatBoardTop > VIEWCHATLINE then
               ChatBoardTop := ChatBoardTop - VIEWCHATLINE
            else ChatBoardTop := 0;
         end;
      VK_NEXT:
         with DScreen do begin
            if ChatBoardTop + VIEWCHATLINE < ChatStrs.Count-1 then
               ChatBoardTop := ChatBoardTop + VIEWCHATLINE
            else ChatBoardTop := ChatStrs.Count-1;
            if ChatBoardTop < 0 then ChatBoardTop := 0;
         end;
   end;
end;

procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
   if g_DWinMan.KeyPress (Key) then exit;
   if DScreen.CurrentScene = PlayScene then begin
      if PlayScene.EdChat.Visible then begin
         //若聊天信息输入框可见，则不处理，而由系统自动处理(作为输入信息)
         Exit;
      end;
      case byte(key) of
         byte('1')..byte('6'):
            begin
               EatItem (byte(key) - byte('1')); //使用快捷栏物品
            end;
         27: //ESC
            begin
            end;
         byte(' '), 13: //进入聊天信息输入状态
            begin
              if not FrmDlg.DWNewSdoAssistant.Visible then begin
                PlayScene.EdChat.Visible := TRUE;
                PlayScene.EdChat.SetFocus;
                SetImeMode (PlayScene.EdChat.Handle, LocalLanguage);
                if FrmDlg.BoGuildChat then begin
                  PlayScene.EdChat.Text := '!~';
                  PlayScene.EdChat.SelStart := Length(PlayScene.EdChat.Text);
                  PlayScene.EdChat.SelLength := 0;
                end else begin
                  PlayScene.EdChat.Text := '';
                end;
              end;
            end;
         byte('@'),
         byte('!'),
         byte('/'):
            begin
              if not FrmDlg.DWNewSdoAssistant.Visible then begin
                 PlayScene.EdChat.Visible := TRUE;
                 PlayScene.EdChat.SetFocus;
                 SetImeMode (PlayScene.EdChat.Handle, LocalLanguage);
                 if key = '/' then begin
                    if WhisperName = '' then PlayScene.EdChat.Text := key
                    else if Length(WhisperName) > 2 then PlayScene.EdChat.Text := '/' + WhisperName + ' '
                    else PlayScene.EdChat.Text := key;
                    PlayScene.EdChat.SelStart := Length(PlayScene.EdChat.Text);
                    PlayScene.EdChat.SelLength := 0;
                 end else begin
                    PlayScene.EdChat.Text := key;
                    PlayScene.EdChat.SelStart := 1;
                    PlayScene.EdChat.SelLength := 0;
                 end;
               end;
            end;
      end;
      key := #0;
   end;
end;
//根据快捷键，查找对应的魔法
function  TfrmMain.GetMagicByKey (Key: char): PTClientMagic;
var
   i: integer;
   pm: PTClientMagic;
begin
   Result := nil;
   if g_MagicList.Count > 0 then begin//20080629
     for i:=0 to g_MagicList.Count-1 do begin
        pm := PTClientMagic (g_MagicList[i]);
        if pm.Key = Key then begin
           Result := pm;
           break;
        end;
     end;
   end;
end;

procedure TfrmMain.UseMagic (tx, ty: integer; pcm: PTClientMagic); //tx, ty: 胶农赴 谅钎烙.
var
   tdir, targx, targy, targid: integer;
   pmag: PTUseMagicInfo;

   msgs:TDefaultMessage;
begin
   if (tx <> 5000) and (tx <> 5000) and (pcm = nil) then exit;
   if (tx = 5000) and (ty = 5000) then begin //放合击
    g_dwMagicDelayTime := 450;               //修正放合击同时放技能会卡住
    g_dwLatestSpellTick := GetTickCount;
    msgs:=MakeDefaultMsg (CM_HEROGOTETHERUSESPELL, 0, 0, 0, 0, Certification);
    FrmMain.SendSocket (EncodeMessage (msgs));
   end else begin
   if (pcm.Def.wSpell + pcm.Def.btDefSpell <= g_MySelf.m_Abil.MP) or (pcm.Def.btEffectType = 0) then begin
      case pcm.Def.wMagicId of
        3:Exit;//基本剑术
        4:Exit;//精神力战法
        7:Exit;//攻杀
       67:Exit;//先天元力
      end;
      if pcm.Def.btEffectType = 0 then begin //八过,瓤苞绝澜
         if pcm.Def.wMagicId = 26 then begin //烈火剑法
            if GetTickCount - g_dwLatestFireHitTick < 10 * 1000 then begin
               exit;
            end;
         end;
         if pcm.Def.wMagicId = 74 then begin //逐日剑法 20080511
         end;
         if pcm.Def.wMagicId = 27 then begin //野蛮冲撞
            if GetTickCount - g_dwLatestRushRushTick < 3 * 1000 then begin
               exit;
            end;
         end;

         //其他基本魔法500ms用一次
         if GetTickCount - g_dwLatestSpellTick > g_dwSpellTime{500} then begin
            g_dwLatestSpellTick := GetTickCount;
            g_dwMagicDelayTime := 0;
            SendSpellMsg (CM_SPELL, g_MySelf.m_btDir{x}, 0, pcm.Def.wMagicId, 0);
         end;
      end else begin
         tdir := GetFlyDirection (390, 175, tx, ty); //计算魔法攻击的方向
         TurnDuFu(pcm);  //自动换毒  20080315
//         MagicTarget := FocusCret;    //攻击对象
//魔法锁定
         if (pcm.Def.wMagicId in [2,14,15,19,9,10,22,23,29,31,33,46,49,40,52,56,58]) then
           g_MagicTarget:=g_FocusCret
         else begin
           if not g_boMagicLock or (PlayScene.IsValidActor (g_FocusCret) and (not g_FocusCret.m_boDeath)) and (g_FocusCret.m_btRace <> 50) then begin
              g_MagicLockActor:=g_FocusCret;
           end;
           //if (not g_MagicLockActor.m_boDeath)then  //2008024
              g_MagicTarget:=g_MagicLockActor
           //else g_MagicTarget:=g_FocusCret;
         end;
         
         if not PlayScene.IsValidActor (g_MagicTarget) or (g_MagicTarget.m_boDeath) then
            g_MagicTarget := nil;

         if g_MagicTarget = nil then begin
            PlayScene.CXYfromMouseXY (tx, ty, targx, targy);
            targid := 0;
         end else begin
            targx := g_MagicTarget.m_nCurrX;
            targy := g_MagicTarget.m_nCurrY;
            targid := g_MagicTarget.m_nRecogId;
         end;
         if CanNextAction and ServerAcceptNextAction then begin
            g_dwLatestSpellTick := GetTickCount;
            new (pmag);
            FillChar (pmag^, sizeof(TUseMagicInfo), #0);
            pmag.EffectNumber := pcm.Def.btEffect;
            pmag.MagicSerial := pcm.Def.wMagicId;
            pmag.ServerMagicCode := 0;
            g_dwMagicDelayTime := 200 + pcm.Def.dwDelayTime; //魔法延迟时间

            case pmag.MagicSerial of
               //0, 2, 11, 12, 15, 16, 17, 13, 23, 24, 26, 27, 28, 29: ;
               2, 14, 15, 16, 17, 18, 19, 21, //厚傍拜 付过 力寇
               12, 25, 26, 28, 29, 30, 31: ;
               else g_dwLatestMagicTick := GetTickCount;
            end;

            //PK时使用魔法
            g_dwMagicPKDelayTime := 0;
            if g_MagicTarget <> nil then
               if (g_MagicTarget.m_btRace = 0) or (g_MagicTarget.m_btRace = 1) or (g_MagicTarget.m_btRace = 150) then//人类,英雄,人型20080629
                  g_dwMagicPKDelayTime := 300 + Random(1100); //(600+200 + MagicDelayTime div 5);
            // 特别注意：Integer(pmag),该值将保存到 msg.feature,仅当actor=myself时
            g_MySelf.SendMsg (CM_SPELL, targx, targy, tdir, Integer(pmag), targid, '', 0);
         end;// else
            //Dscreen.AddSysMsg ('泪矫饶俊 荤侩且 荐 乐嚼聪促.');
         //Inc (SpellCount);
      end;
   end else
      Dscreen.AddSysMsg ('魔法值不够！！！');
  end;
end;

procedure TfrmMain.UseMagicSpell (who, effnum, targetx, targety, magic_id: integer);
var
   Actor: TActor;
   adir: integer;
   UseMagic: PTUseMagicInfo;
begin
   Actor := PlayScene.FindActor (who);
   if Actor <> nil then begin
      adir := GetFlyDirection (actor.m_nCurrX, actor.m_nCurrY, targetx, targety);
      New (UseMagic);
      FillChar (UseMagic^, sizeof(TUseMagicInfo), #0);
      UseMagic.EffectNumber := effnum; //magnum;
      UseMagic.ServerMagicCode := 0; //烙矫
      UseMagic.MagicSerial := magic_id;
      Actor.SendMsg(SM_SPELL, 0, 0, adir, Integer(UseMagic), 0, '', 0);
      Inc (g_nSpellCount);
   end else
      Inc (g_nSpellFailCount);
end;

procedure TfrmMain.UseMagicFire (who, efftype, effnum, targetx, targety, target: integer);
var
   actor: TActor;
   sound: integer;
begin
   sound:=0;//jacky
   actor := PlayScene.FindActor (who);
  if actor <> nil then begin
      //actor.SendMsg (SM_MAGICFIRE, target{111magid}, efftype, effnum, targetx, targety, '', sound);
      actor.UpdateMsg (SM_MAGICFIRE, target{111magid}, efftype, effnum, targetx, targety, '', sound);
      if g_nFireCount < g_nSpellCount then
         Inc (g_nFireCount);
   end;
   g_MagicTarget := nil;
end;

procedure TfrmMain.UseMagicFireFail (who: integer);
var
   actor: TActor;
begin
   actor := PlayScene.FindActor (who);
   if actor <> nil then begin
      actor.UpdateMsg (SM_MAGICFIRE_FAIL, 0, 0, 0, 0, 0, '', 0);
      //actor.SendMsg (SM_MAGICFIRE_FAIL, 0, 0, 0, 0, 0, '', 0);
   end;
   g_MagicTarget := nil;
end;

procedure TfrmMain.EatItem (idx: integer);
var
  i, Acount,code: Integer;
  autoop: Boolean;
  pcm: pTUnbindInfo;
  bcount : Integer;
  a208: Boolean;  //查看包裹里是否有解包物品 20080403
  a209: Boolean;  //查看包裹里是否有解包物品 20080403
  d: TDirectDrawSurface;
begin
   if idx in [0..MAXBAGITEMCL-1] then begin

      if (g_EatingItem.S.Name <> '') and (GetTickCount - g_dwEatTime > 5000) then begin
         g_EatingItem.S.Name := '';
      end;
      if (g_EatingItem.S.Name = '') and (g_ItemArr[idx].S.Name <> '') and ((g_ItemArr[idx].S.StdMode <= 3) or (g_ItemArr[idx].S.StdMode = 60){酒}) then begin
         g_EatingItem := g_ItemArr[idx];
         g_ItemArr[idx].S.Name := '';
         //学习书籍.
         if (g_ItemArr[idx].S.StdMode = 4) and (g_ItemArr[idx].S.Shape < 100) then begin
            //shape <50
            if g_ItemArr[idx].S.Shape < 50 then begin
               if mrYes <> FrmDlg.DMessageDlg ('[' + g_ItemArr[idx].S.Name + '] 你想要开始训练吗？'{'是否开始修炼 "' + g_ItemArr[idx].S.Name + '"?'}, [mbYes, mbNo]) then begin
                  g_ItemArr[idx] := g_EatingItem;
                  exit;
               end;
            end else begin
                //shape > 50
               if mrYes <> FrmDlg.DMessageDlg ('[' + g_ItemArr[idx].S.Name + '] 你想要开始训练吗？', [mbYes, mbNo]) then begin
                  g_ItemArr[idx] := g_EatingItem;
                  exit;
               end;
            end;
         end;
         g_dwEatTime := GetTickCount;
         SendEat (g_ItemArr[idx].MakeIndex, g_ItemArr[idx].S.Name );
         ItemUseSound (g_ItemArr[idx].S.StdMode, g_ItemArr[idx].s.Shape);
      end;
   end else begin
      if (idx = -1) and g_boItemMoving and not (FrmDlg.DBoxs.Visible) then begin
         g_boItemMoving := False;
         g_EatingItem := g_MovingItem.Item;
         g_MovingItem.Item.S.Name := '';

         //宝箱 2008.01.15
         if (g_EatingItem.s.StdMode = 48) then begin
           FillChar (g_BoxsItems, sizeof(TClientItem)*9, #0); //清空宝箱物品
           FrmDlg.DBoxsTautology.Visible := False;

           d := g_WMain3Images.Images[520];
           if d <> nil then begin
              FrmDlg.DBoxs.Left := SCREENWIDTH div 2 - 185;
              FrmDlg.DBoxs.Top  := (SCREENHEIGHT - d.Height) div 2 - 6;
              FrmDlg.DBoxs.SetImgIndex(g_WMain3Images,520);
           end;

           FrmDlg.DBoxs.Visible := True;
           Exit;
         end;

         //氓阑 佬绰 巴... 劳鳃 巴牢 瘤 拱绢夯促.
         if (g_EatingItem.S.StdMode = 4) and (g_EatingItem.S.Shape < 100) then begin
            //shape > 100捞搁 弓澜 酒捞袍 烙..
            if g_EatingItem.S.Shape < 50 then begin
               if mrYes <> FrmDlg.DMessageDlg ('[' + g_EatingItem.S.Name + '] 你想要开始训练吗？', [mbYes, mbNo]) then begin
                  AddItemBag (g_EatingItem);
                  Exit;
               end;
            end else begin
                //shape > 50捞搁 林巩 辑 辆幅...
               if mrYes <> FrmDlg.DMessageDlg ('[' + g_EatingItem.S.Name + '] 你想要开始训练吗？', [mbYes, mbNo]) then begin
                  AddItemBag (g_EatingItem);
                  Exit;
               end;
            end;
         end;
         g_dwEatTime := GetTickCount;
         SendEat (g_EatingItem.MakeIndex, g_EatingItem.S.Name );
         ItemUseSound (g_EatingItem.S.StdMode, g_EatingItem.s.Shape);
      end;
   end;
      //双击自动放药
      if (g_EatingItem.s.Name <> '') and (idx = -1) and (g_EatingItem.s.StdMode < 4) and (g_BeltIdx <> 50){包裹双击为50   20080305} then begin
        for i := 6 to MAXBAGITEMCL - 1 do begin
          if g_EatingItem.s.Name = g_ItemArr[i].s.Name then begin
            g_TempIdx := g_BeltIdx;
            g_TempItemArr := g_ItemArr[i];
            //g_ItemArr[i].s.Name := '';  修正吃药快了 药品消失  20080713
            g_ItemArr[idx].s.Name := '';
            break;
          end;
        end;
      end;

//自动放药
      if (g_EatingItem.s.Name<>'') and (idx>-1) and (idx < 6) then begin
        for i := 6 to MAXBAGITEMCL - 1 do begin
          if g_EatingItem.s.Name = g_ItemArr[i].s.Name then
          begin
            g_TempIdx := idx;
            g_TempItemArr := g_ItemArr[i];
            //g_ItemArr[i].s.Name := ''; 修正吃药快了 药品消失  20080713
            g_ItemArr[idx].s.Name := '';
            break;
          end;
        end;
      end;

      bcount:=0;
      a208 := False;// 查看包裹里是否有解包物品
      a209 := False;// 是否查寻到代码
      if ((g_EatingItem.s.StdMode = 0) or ((g_EatingItem.s.StdMode = 3) and (g_EatingItem.s.Shape <> 4{祝福油}))) then begin  //检查药品数量 不够则解包
        for i := 0 to MAXBAGITEMCL - 1 do
        if g_ItemArr[i].s.Name = g_EatingItem.s.Name then Inc(bCount);
        if bCount = 0 then autoop := True else autoop := False;
      end;

     if ((g_EatingItem.s.StdMode = 0) or ((g_EatingItem.s.StdMode = 3) and (g_EatingItem.s.Shape <> 4{祝福油}))) and autoop then begin   //查询解包代码
          if g_UnBindList.Count > 0 then
          for I:=0 to g_UnBindList.Count -1 do begin
              pcm := pTUnbindInfo (g_UnBindList[i]);
              if g_EatingItem.s.Name = pcm.sItemName then begin
                 code := pcm.nUnbindCode;
                 a209 := True; //查到代码
              end;
          end;
        end;
   if (i = MAXBAGITEMCL) or (bCount = 0) then  begin   //查询空位
        Acount:=0;
        for I := 0 to 46 do begin
          if g_ItemArr[i].s.Name = '' then Inc(ACount);
        end;
     for I := 0 to MAXBAGITEMCL - 1 do
       if (g_ItemArr[i].s.Shape = code) and (autoop) and (g_ItemArr[i].S.Name <> '') then
        a208 := True;  //有解包文件

     if (((g_EatingItem.s.StdMode = 0) and (g_EatingItem.s.Shape <> 3)) or (g_EatingItem.s.StdMode = 3)) and (ACount > 5) and  (bCount = 0) and g_AutoPut then  begin
      for i:=0 to MAXBAGITEMCL - 1 do begin
       if (g_ItemArr[i].s.Shape = code) and (autoop) and (g_ItemArr[i].S.Name <> '') and (g_ItemArr[i].s.StdMode=31){20080623} then  begin

          SendEat (g_ItemArr[i].MakeIndex, g_ItemArr[i].S.Name );
          g_ItemArr[i].s.Name := '';
          autoop := FALSE;
       end;
      end;
     end;
     if (Acount <= 5) and (a208) and (a209) and (Bcount = 0) then DScreen.AddChatBoardString('包裹空间不够，无法解包！', clWhite, clBlue);
   end;

end;
procedure TfrmMain.HeroEatItem (idx: integer);
begin
   if idx in [0..MAXBAGITEMCL-1] then begin
      if (g_HeroEatingItem.S.Name <> '') and (GetTickCount - g_dwEatTime > 5 * 1000) then begin
         g_EatingItem.S.Name := '';
      end;
      if (g_HeroEatingItem.S.Name = '') and (g_HeroItemArr[idx].S.Name <> '') and ((g_HeroItemArr[idx].S.StdMode <= 3) or (g_HeroItemArr[idx].S.StdMode = 60){酒}) then begin
         g_HeroEatingItem := g_HeroItemArr[idx];
         g_HeroItemArr[idx].S.Name := '';
         //氓阑 佬绰 巴... 劳鳃 巴牢 瘤 拱绢夯促.
         if (g_HeroItemArr[idx].S.StdMode = 4) and (g_HeroItemArr[idx].S.Shape < 100) then begin
            //shape > 100捞搁 弓澜 酒捞袍 烙..
            if g_HeroItemArr[idx].S.Shape < 50 then begin
               if mrYes <> FrmDlg.DMessageDlg ('是否开始修炼“' + g_HeroItemArr[idx].S.Name + '”？', [mbYes, mbNo]) then begin
                  g_HeroItemArr[idx] := g_HeroEatingItem;
                  exit;
               end;
            end else begin
                //shape > 50捞搁 林巩 辑 辆幅...
               if mrYes <> FrmDlg.DMessageDlg ('是否开始修炼“' + g_HeroItemArr[idx].S.Name + '”？', [mbYes, mbNo]) then begin
                  g_HeroItemArr[idx] := g_HeroEatingItem;
                  exit;
               end;
            end;
         end;
         g_dwEatTime := GetTickCount;
         SendHeroEat (g_HeroItemArr[idx].MakeIndex, g_HeroItemArr[idx].S.Name );
         ItemUseSound (g_HeroItemArr[idx].S.StdMode, g_HeroItemArr[idx].S.Shape);
      end;
   end else begin
      if (idx = -1) and g_boHeroItemMoving then begin
         g_boHeroItemMoving := FALSE;
         g_HeroEatingItem := g_MovingHeroItem.Item;
         g_MovingHeroItem.Item.S.Name := '';
         //氓阑 佬绰 巴... 劳鳃 巴牢 瘤 拱绢夯促.
         if (g_HeroEatingItem.S.StdMode = 4) and (g_HeroEatingItem.S.Shape < 100) then begin
            //shape > 100捞搁 弓澜 酒捞袍 烙..
            if g_HeroEatingItem.S.Shape < 50 then begin
               if mrYes <> FrmDlg.DMessageDlg ('是否开始修炼“' + g_HeroEatingItem.S.Name + '”？', [mbYes, mbNo]) then begin
                  AddHeroItemBag (g_HeroEatingItem);
                  exit;
               end;
            end else begin
                //shape > 50捞搁 林巩 辑 辆幅...
               if mrYes <> FrmDlg.DMessageDlg ('是否开始修炼“' + g_HeroEatingItem.S.Name + '”？', [mbYes, mbNo]) then begin
                  AddHeroItemBag (g_HeroEatingItem);
                  exit;
               end;
            end;
         end;
         g_dwEatTime := GetTickCount;
         SendHeroEat (g_HeroEatingItem.MakeIndex, g_HeroEatingItem.S.Name );
         ItemUseSound (g_HeroEatingItem.S.StdMode,g_HeroEatingItem.S.Shape);
      end;
   end;
end;

//判断在2格范围内是否可以小开天
function TfrmMain.TargetInCanQTwnAttackRange(sx, sy, dx,
  dy: Integer): Boolean;
begin
   Result:=False;
   if (Abs(Sx-dx)=2)and(Abs(sy-dy)=0) then begin
       Result:=True;
       Exit;
   end;
   if (Abs(Sx-dx)=0)and(Abs(sy-dy)=2) then begin
       Result:=True;
       Exit;
   end;
   if (Abs(Sx-dx)=2)and(Abs(sy-dy)=2) then begin
       Result:=True;
       Exit;
   end;
end;

//判断在4格范围内是否可以大开天、逐日剑法
function TfrmMain.TargetInCanTwnAttackRange(sx, sy, dx,
  dy: Integer): Boolean;
begin
   Result:=False;
   if (Abs(Sx-dx)<=4)and(Abs(sy-dy)=0) then begin
       Result:=True;
       Exit;
   end;
   if (Abs(Sx-dx)=0)and(Abs(sy-dy)<=4) then begin
       Result:=True;
       Exit;
   end;
   if ((Abs(Sx-dx)=2)and(Abs(sy-dy)=2)) or ((Abs(Sx-dx)=3)and(Abs(sy-dy)=3))
      or ((Abs(Sx-dx)=4)and(Abs(sy-dy)=4)) then begin
       Result:=True;
       Exit;
   end;
end;

//判断在2格范围内是否有目标可以刺杀
function  TfrmMain.TargetInSwordLongAttackRange (ndir: integer): Boolean;
var
   nx, ny: integer;
   actor: TActor;
begin
   Result := FALSE;
   GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, ndir, nx, ny);
   GetFrontPosition (nx, ny, ndir, nx, ny);
   if (abs(g_MySelf.m_nCurrX - nx) = 2) or (abs(g_MySelf.m_nCurrY-ny) = 2) then begin
      actor := PlayScene.FindActorXY (nx, ny);
      if actor <> nil then
         if not actor.m_boDeath then
            Result := TRUE;
   end;
end;

//判断是否有目标在半月攻击范围内
function  TfrmMain.TargetInSwordWideAttackRange (ndir: integer): Boolean;
var
   nx, ny, rx, ry, mdir: integer;
   actor, ractor: TActor;
begin
   Result := FALSE;
   GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, ndir, nx, ny);
   actor := PlayScene.FindActorXY (nx, ny);

   mdir := (ndir + 1) mod 8;
   GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
   ractor := PlayScene.FindActorXY (rx, ry);
   if ractor = nil then begin
      mdir := (ndir + 2) mod 8;
      GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
      ractor := PlayScene.FindActorXY (rx, ry);
   end;
   if ractor = nil then begin
      mdir := (ndir + 7) mod 8;
      GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
      ractor := PlayScene.FindActorXY (rx, ry);
   end;

   //if (actor <> nil) and (ractor <> nil) then
   if ((actor <> nil) and (actor.m_btRace<>1)) and ((ractor <> nil) and (ractor.m_btRace <>1)) then
      if not actor.m_boDeath and not ractor.m_boDeath then
         Result := TRUE;
end;
function  TfrmMain.TargetInSwordCrsAttackRange (ndir: integer): Boolean;
var
   nx, ny, rx, ry, mdir: integer;
   actor, ractor: TActor;
begin
   Result := FALSE;
   GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, ndir, nx, ny);
   actor := PlayScene.FindActorXY (nx, ny);

   mdir := (ndir + 1) mod 8;
   GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
   ractor := PlayScene.FindActorXY (rx, ry);
   if ractor = nil then begin
      mdir := (ndir + 2) mod 8;
      GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
      ractor := PlayScene.FindActorXY (rx, ry);
   end;
   if ractor = nil then begin
      mdir := (ndir + 7) mod 8;
      GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
      ractor := PlayScene.FindActorXY (rx, ry);
   end;

   if (actor <> nil) and (ractor <> nil) then
      if not actor.m_boDeath and not ractor.m_boDeath then
         Result := TRUE;
end;

{--------------------- Mouse Interface ----------------------}

procedure TfrmMain.DXDrawMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
   mx, my, sel: integer;
   target: TActor;
   itemnames: string;
begin

   if g_DWinMan.MouseMove (Shift, X, Y) then Exit;


   if (g_MySelf = nil) or (DScreen.CurrentScene <> PlayScene) then exit;
   g_boSelectMyself := PlayScene.IsSelectMyself (X, Y);

   target := PlayScene.GetAttackFocusCharacter (X, Y, g_nDupSelection, sel, FALSE);
   if g_nDupSelection <> sel then g_nDupSelection := 0;
   if target <> nil then begin
      if (target.m_sUserName = '') and (GetTickCount - target.m_dwSendQueryUserNameTime > 10 * 1000) then begin
         target.m_dwSendQueryUserNameTime := GetTickCount;
         SendQueryUserName (target.m_nRecogId, target.m_nCurrX, target.m_nCurrY);
      end;
      g_FocusCret := Target;
   end else
      g_FocusCret := nil;

   g_FocusItem := PlayScene.GetDropItems (X, Y, itemnames);
   if g_FocusItem <> nil then begin
      PlayScene.ScreenXYfromMCXY (g_FocusItem.X, g_FocusItem.Y, mx, my);
      DScreen.ShowHint (mx-20,
                        my-10,
                        itemnames, //PTDropItem(ilist[i]).Name,
                        clWhite,
                        TRUE);
   end else
      DScreen.ClearHint;

   PlayScene.CXYfromMouseXY (X, Y, g_nMouseCurrX, g_nMouseCurrY);
   g_nMouseX := X;
   g_nMouseY := Y;
   g_MouseItem.S.Name := '';
   g_HeroMouseItem.s.Name := ''; //20080222
   g_HeroMouseStateItem.s.Name := ''; //20080222
   g_MouseStateItem.S.Name := '';
   g_MouseUserStateItem.S.Name := '';

   g_nMouseMinMapX := 0; //20080323
   g_nMouseMinMapY := 0; //20080323
   
   if ((ssLeft in Shift) or (ssRight in Shift)) and (GetTickCount - mousedowntime > 300) then
      _DXDrawMouseDown(self, mbLeft, Shift, X, Y);

end;

procedure TfrmMain.DXDrawMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   MouseDownTime := GetTickCount;
   g_nRunReadyCount := 0;
   _DXDrawMouseDown (Sender, Button, Shift, X, Y);
end;

procedure TfrmMain.AttackTarget (target: TActor);
var
   tdir, dx, dy, nHitMsg: integer;
begin
   nHitMsg := CM_HIT;
   if g_UseItems[U_WEAPON].S.StdMode = 6 then nHitMsg := CM_HEAVYHIT;   //魔杖、偃月、裁决之杖等
   tdir := GetNextDirection (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, target.m_nCurrX, target.m_nCurrY);//取得方向

   if (abs(g_MySelf.m_nCurrX - target.m_nCurrX) <= 1) and (abs(g_MySelf.m_nCurrY-target.m_nCurrY) <= 1) and (not target.m_boDeath) then begin
      if CanNextAction and ServerAcceptNextAction and CanNextHit then begin
         //烈火
         if g_boNextTimeFireHit and (g_MySelf.m_Abil.MP >= 7) then begin
            g_boNextTimeFireHit := FALSE;
            nHitMsg := CM_FIREHIT;
         end else
         //4级烈火  20080112
         if g_boNextTime4FireHit and (g_MySelf.m_Abil.Mp >= 7) then begin
            g_boNextTime4FireHit := FALSE;
            nHitMsg := CM_4FIREHIT;
         end else
         if g_boNextItemDAILYHit and (g_MySelf.m_Abil.MP >= 10) then begin
         //逐日剑法 20080511
            g_boNextItemDAILYHit := False;
            nHitMsg := CM_DAILY;
         end else
         //攻杀
         if g_boNextTimePowerHit then begin  
            g_boNextTimePowerHit := FALSE;
            nHitMsg := CM_POWERHIT;
         end else
         //开天斩 重击
         if g_boCanTwnHit and (g_MySelf.m_Abil.MP >= 10) then begin
            g_boCanTwnHit := FALSE;
            nHitMsg := CM_TWINHIT;
         end else
         //开天斩 轻击
         if g_boCanQTwnHit and (g_MySelf.m_Abil.MP >= 10) then begin
            g_boCanQTwnHit := FALSE;
            nHitMsg := CM_QTWINHIT;
         end else
         //龙影剑法
         if g_boCanCIDHit and (g_MySelf.m_Abil.MP >= 10) then begin
            g_boCanCIDHit := False;   //20080202
            nHitMsg :=  CM_CIDHIT;
         end else
         { 原代码
         if g_boCanWideHit and (g_MySelf.m_Abil.MP >= 3) then begin
            //智能半月
            if g_boAutoWideHit and (g_MySelf.m_btJob = 0) then begin
               if (TargetInSwordWideAttackRange (tdir)) then
                 nHitMsg := CM_WIDEHIT
               else
                 if g_boLongHit then nHitMsg := CM_LONGHIT;
            end else
            nHitMsg := CM_WIDEHIT;
         end else  }
        //智能半月
        if g_boAutoWideHit and (g_MySelf.m_btJob = 0) and (TargetInSwordWideAttackRange (tdir)) and (g_MySelf.m_Abil.MP >= 3) then begin
             nHitMsg := CM_WIDEHIT;
        end else
        if g_boCanWideHit and (g_MySelf.m_Abil.MP >= 3) then begin
          nHitMsg := CM_WIDEHIT;
        end else
        if g_boCanCrsHit and (g_MySelf.m_Abil.MP >= 6) then begin
          nHitMsg := CM_CRSHIT;
        end else
        if g_boLongHit and (g_MySelf.m_btJob = 0) then begin
          nHitMsg := CM_LONGHIT; 
        end else
        if g_boCanLongHit and (TargetInSwordLongAttackRange (tdir)) then begin
          nHitMsg := CM_LONGHIT;
        end;
         (* 原代码
         if g_boCanLongHit and ((g_boLongHit{刀刀刺杀} and (g_Myself.m_btJob=0) ) or TargetInSwordLongAttackRange (tdir)) then begin
            nHitMsg := CM_LONGHIT;
         end;*)

         if g_boAutoFireHit then AutoLieHuo;
         if g_boAutoZhuRiHit then AutoZhuri;

         //if ((target.m_btRace <> RCC_USERHUMAN) and (target.m_btRace <> RCC_GUARD)) or (ssShift in Shift) then //荤恩阑 角荐肺 傍拜窍绰 巴阑 阜澜
         g_MySelf.SendMsg (nHitMsg, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0);
         g_dwLatestHitTick := GetTickCount;
      end;
      g_dwLastAttackTick := GetTickCount;
   end else begin
      if (abs(g_MySelf.m_nCurrX - target.m_nCurrX) <= 2) and (abs(g_MySelf.m_nCurrY-target.m_nCurrY) <= 2) and (not target.m_boDeath) then begin
         if g_boCanQTwnHit and (g_MySelf.m_Abil.MP >= 10) and (TargetInCanQTwnAttackRange(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, Target.m_nCurrX, Target.m_nCurrY)) then begin  //小开天 20080223
            if CanNextAction and ServerAcceptNextAction and CanNextHit then begin
               g_boCanQTwnHit := FALSE;
               nHitMsg := CM_QTWINHIT;
               g_MySelf.SendMsg (nHitMsg, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0);
               g_dwLatestHitTick := GetTickCount;
               g_dwLastAttackTick := GetTickCount;
            end;
         end else
         if g_boNextItemDAILYHit and (g_MySelf.m_Abil.MP >= 10) and (TargetInCanTwnAttackRange(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, Target.m_nCurrX, Target.m_nCurrY)) then begin
            if CanNextAction and ServerAcceptNextAction and CanNextHit then begin
               g_boNextItemDAILYHit := FALSE;
               nHitMsg := CM_DAILY;
               g_MySelf.SendMsg (nHitMsg, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0);
               g_dwLatestHitTick := GetTickCount;
               g_dwLastAttackTick := GetTickCount;
            end;
         end else g_ChrAction := caRun;//跑步砍
      end else
      if (abs(g_MySelf.m_nCurrX - target.m_nCurrX) <= 4) and (abs(g_MySelf.m_nCurrY-target.m_nCurrY) <= 4) and (not target.m_boDeath) then begin
         if g_boCanTwnHit and (g_MySelf.m_Abil.MP >= 10) and (TargetInCanTwnAttackRange(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, Target.m_nCurrX, Target.m_nCurrY)) then begin  //大开天 20080223
            if CanNextAction and ServerAcceptNextAction and CanNextHit then begin
               g_boCanTwnHit := FALSE;
               nHitMsg := CM_TWINHIT;
               g_MySelf.SendMsg (nHitMsg, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0);
               g_dwLatestHitTick := GetTickCount;
               g_dwLastAttackTick := GetTickCount;
            end;
         end else
         if g_boNextItemDAILYHit and (g_MySelf.m_Abil.MP >= 10) and (TargetInCanTwnAttackRange(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, Target.m_nCurrX, Target.m_nCurrY)) then begin
            if CanNextAction and ServerAcceptNextAction and CanNextHit then begin
               g_boNextItemDAILYHit := FALSE;
               nHitMsg := CM_DAILY;
               g_MySelf.SendMsg (nHitMsg, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0);
               g_dwLatestHitTick := GetTickCount;
               g_dwLastAttackTick := GetTickCount;
            end;
         end else g_ChrAction := caRun;//跑步砍
      end else g_ChrAction := caRun;//跑步砍
      GetBackPosition (target.m_nCurrX, target.m_nCurrY, tdir, dx, dy);
      g_nTargetX := dx;
      g_nTargetY := dy;
   end;
end;

//自动烈火
function TfrmMain.AutoLieHuo: Boolean;
var
  i: Integer;
  pm: PTClientMagic;
begin
  Result := False;
  if g_MySelf = nil then Exit;
  if ((GetTickCount - g_dwAutoLieHuo) > 7000) and(g_MySelf.m_btJob = 0) then begin
   if g_MagicList.Count > 0 then //20080629
   for i:=0 to g_MagicList.Count-1 do begin
      pm := PTClientMagic (g_MagicList[i]);
      if pm.Def.wMagicID = 26 then
      begin
        SendSpellMsg(CM_SPELL, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, 26, 0);
        g_dwAutoLieHuo := GetTickCount;
      end;
    end;
  end;
end;

//自动逐日
function TfrmMain.AutoZhuri: Boolean;
var

  i: Integer;
  pm: PTClientMagic;
begin
  Result := False;
  if g_MySelf = nil then Exit;
  if ((GetTickCount - g_dwAutoZhuRi) > 10000) and(g_MySelf.m_btJob = 0) then begin
   if g_MagicList.Count > 0 then //20080629
   for i:=0 to g_MagicList.Count-1 do begin
      pm := PTClientMagic (g_MagicList[i]);
      if pm.Def.wMagicID = 74 then begin
        SendSpellMsg(CM_SPELL, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, 74, 0);
        g_dwAutoZhuRi := GetTickCount;
      end;
    end;
  end;
end;

//自动魔法盾，自动抗拒，自动隐身过程
function TfrmMain.NearActor: Boolean;
  {var
  i: Integer;
  pm: PTClientMagic;
  function isNear(Step:Integer):Boolean;
  var
    i:Integer;
    Actor:TActor;
  begin
   Result:=False;
   with PlayScene do begin
      if m_ActorList.Count > 0 then //20080629
      for i:=0 to m_ActorList.Count-1 do begin
         Actor:=TActor(m_ActorList[i]);
         if Actor <> nil then begin
           if (g_MySelf = Actor) or (Actor.m_btRace = 50) or (Actor.m_boDeath) then Continue;
           if (Abs(Actor.m_nCurrX-g_MySelf.m_nCurrX) < Step) and (Abs(Actor.m_nCurrY-g_MySelf.m_nCurrY) < Step) then begin
              Result:=True;
              Exit;
           end;
         end;
      end;
   end;
  end;}
var
  boIs66: Boolean;
  i: Integer;
  pm: PTClientMagic;
begin
  Result := False;
  if g_MySelf = nil then Exit;
  if g_MySelf.m_boDeath then Exit;
    // 自动魔盾
  if (g_MySelf.m_btJob=1) and  ((GetTickCount-g_nAutoMagic) > 500) and g_boAutoShield then begin
    if (g_MySelf.m_nState and $00100000 <> 0) then Exit;
    boIs66 := False;
    if g_MagicList.Count > 0 then //20080629
    for i:=0 to g_MagicList.Count-1 do begin
      pm := PTClientMagic (g_MagicList[i]);
      if pm <> nil then begin
        if Pm.Def.wMagicId = 66 then begin //四级魔法盾
          UseMagic(g_nMouseX, g_nMouseY,Pm);
          g_nAutoMagic:=GetTickCount;
          Break;
          boIs66 := True;
        end;
      end;
    end;
    if not boIs66 then begin
      if g_MagicList.Count > 0 then //20080629
      for i:=0 to g_MagicList.Count-1 do begin
        pm := PTClientMagic (g_MagicList[i]);
        if pm <> nil then begin
          if Pm.Def.wMagicId = 31 then begin //魔法盾
            UseMagic(g_nMouseX, g_nMouseY,Pm);
            g_nAutoMagic:=GetTickCount;
            Break;
          end;
        end;
      end;
    end;
  end;
  //自动隐身
  if (g_MySelf.m_btJob = 2) and ((GetTickCount - g_nAutoMAgic) > 500)  and g_boAutoHide then begin
    if (g_MySelf.m_nState and $00800000 <> 0) then Exit;
    if g_MagicList.Count > 0 then //20080629
    for i := 0 to g_MagicList.Count - 1 do begin
      pm := PTClientMagic(g_MagicList[i]);
      if pm <> nil then begin
        if pm.Def.wMagicId = 18 then begin
          UseMagic(g_nMouseX, g_nMouseY,Pm);
          g_nAutoMAgic := GetTickCount;
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.AutoEatItem;
var
  I: Integer;
  bo: boolean;
begin
  if g_MySelf = nil then Exit;
  if g_MySelf.m_boDeath then Exit;
  //普通hp保护
  if g_boCommonHp and (g_MySelf.m_Abil.HP < g_nEditCommonHp) and ((GetTickCount - g_dwCommonHpTick) > g_nEditCommonHpTimer * 1000) then begin
    g_dwCommonHpTick := GetTickCount;
    bo:=False;
    for i := 0 to MAXBAGITEMCL - 1 do begin
      if g_ItemArr[i].s.Name = '强效金创药' then begin
        EatItem (i);
        bo:=True;
        break;
      end else if g_ItemArr[i].s.Name = '金创药(中量)' then begin
        EatItem (i);
        bo:=True;
        break;
      end else if g_ItemArr[i].s.Name = '金创药(小量)' then begin
        EatItem (i);
        bo:=True;
        break;
      end;
    end;
    if not bo then DScreen.AddChatBoardString('提示:您的['+'金创药'+']没了,请及时补充!',ClRed, ClWhite);
  end;
  //普通MP保护
  if g_boCommonMp and (g_MySelf.m_Abil.MP < g_nEditCommonMp) and ((GetTickCount - g_dwCommonMpTick) > g_nEditCommonMpTimer * 1000) then begin
    g_dwCommonMpTick := GetTickCount;
    bo:=False;
    for i := 0 to MAXBAGITEMCL - 1 do begin
      if g_ItemArr[i].s.Name = '强效魔法药' then begin
        EatItem (i);
        bo:=True;
        break;
      end else if g_ItemArr[i].s.Name = '魔法药(中量)' then begin
        EatItem (i);
        bo:=True;
        break;
      end else if g_ItemArr[i].s.Name = '魔法药(小量)' then begin
        EatItem (i);
        bo:=True;
        break;
      end;
    end;
    if not bo then DScreen.AddChatBoardString('提示:您的['+'魔法药'+']没了,请及时补充!',ClRed, ClWhite);
  end;
  //特殊HP保护
  if g_boSpecialHp and (g_MySelf.m_Abil.HP < g_nEditSpecialHp) and ((GetTickCount - g_dwSpecialHpTick) > g_nEditSpecialHpTimer * 1000) then begin
    g_dwSpecialHpTick := GetTickCount;
    bo:=False;
    for i := 0 to MAXBAGITEMCL - 1 do begin
      if g_ItemArr[i].s.Name = '万年雪霜' then begin
        EatItem (i);
        bo:=True;
        break;
      end else if g_ItemArr[i].s.Name = '疗伤药' then begin
        EatItem (i);
        bo:=True;
        break;
      end else if g_ItemArr[i].s.Name = '强效太阳水' then begin
        EatItem (i);
        bo:=True;
        break;
      end else if g_ItemArr[i].s.Name = '太阳水' then begin
        EatItem (i);
        bo:=True;
        break;
      end;
    end;
    if not bo then DScreen.AddChatBoardString('提示:您的['+'特殊药品'+']没了,请及时补充!',ClRed, ClWhite);
  end;
  //随机HP保护
  if g_boRandomHp and (g_MySelf.m_Abil.HP < g_nEditRandomHp) and ((GetTickCount - g_dwRandomHpTick) > g_nEditRandomHpTimer * 1000) then begin
    g_dwRandomHpTick := GetTickCount;
    bo:=False;
    for i := 0 to MAXBAGITEMCL - 1 do begin
      if g_ItemArr[i].s.Name = g_sRandomName then begin
        EatItem (i);
        bo:=True;
        break;
      end;
    end;
    if not bo then DScreen.AddChatBoardString('提示:您的['+g_sRandomName+']没了,请及时补充!',ClRed, ClWhite);
  end;
  //人物自动喝普通酒
  if g_boAutoEatWine and ((100 * g_MySelf.m_Abil.WineDrinkValue div g_MySelf.m_Abil.MaxAlcohol) <= g_btEditWine) and ((GetTickCount - g_dwAutoEatWineTick) > 5000) then begin
    g_dwAutoEatWineTick := GetTickCount;
    bo:=False;
    for i := 0 to MAXBAGITEMCL - 1 do begin
      if (g_ItemArr[i].s.StdMode = 60) and (g_ItemArr[i].s.AniCount = 1) then begin
        EatItem (i);
        bo:=True;
        break;
      end;
    end;
    if not bo then DScreen.AddChatBoardString('提示:您的[普通酒]没了,请及时补充!',ClRed, ClWhite);
  end;
  //英雄自动喝普通酒
  if g_HeroSelf <> nil then begin
    if (g_HeroSelf.m_Abil.MaxAlcohol > 0) and (g_HeroSelf.m_Abil.WineDrinkValue > 0) then begin
      if g_boAutoEatHeroWine and ((100 * g_HeroSelf.m_Abil.WineDrinkValue div g_HeroSelf.m_Abil.MaxAlcohol) <= g_btEditHeroWine) and ((GetTickCount - g_dwAutoEatHeroWineTick) > 5000) then begin
        g_dwAutoEatHeroWineTick := GetTickCount;
        bo:=False;
        for i:=0 to g_HeroBagCount - 1 do begin
          if (g_HeroItemArr[I].s.StdMode = 60) and (g_HeroItemArr[I].s.AniCount = 1) then begin
            HeroEatItem(I);
            bo:=True;
            Break;
          end;
        end;
        if not bo then DScreen.AddChatBoardString('提示:你英雄的[普通酒]没了,请及时补充!',clRed, clWhite);
      end;
    end;
  end;
  //人物自动喝药酒
  if g_boAutoEatDrugWine and ((GetTickCount - g_dwAutoEatDrugWineTick) >= g_btEditDrugWine * 1000 * 60) then begin
    g_dwAutoEatDrugWineTick := GetTickCount;
    bo := False;
    for i := 0 to MAXBAGITEMCL - 1 do begin
      if (g_ItemArr[i].s.StdMode = 60) and (g_ItemArr[i].s.AniCount = 2) then begin
        EatItem (i);
        bo:=True;
        break;
      end;
    end;
    if not bo then DScreen.AddChatBoardString('提示:您的[药酒]没了,请及时补充!',ClRed, ClWhite);
  end;
  //英雄自动喝药酒
  if g_HeroSelf <> nil then begin
    if g_boAutoEatHeroDrugWine and ((GetTickCount - g_dwAutoEatHeroDrugWineTick) >= g_btEditHeroDrugWine * 1000 * 60) then begin
      g_dwAutoEatHeroDrugWineTick := GetTickCount;
      bo:=False;
      for i:=0 to g_HeroBagCount - 1 do begin
        if (g_HeroItemArr[I].s.StdMode = 60) and (g_HeroItemArr[I].s.AniCount = 2) then begin
          HeroEatItem(I);
          bo:=True;
          Break;
        end;
      end;
      if not bo then DScreen.AddChatBoardString('提示:你英雄的[普通酒]没了,请及时补充!',clRed, clWhite);
    end;
  end;
end;

//显示自身动画  通用类
procedure TfrmMain.ShowMyShow(Actor: TActor; TypeShow:Integer);
                      {用户}        {开始桢}  {往后播放桢数}   {播放间隔时间}         {图象库}
  procedure MyShow(Actor: TActor; StartFrame, ExplosionFrame, NextFrameTime: Integer; wimg: TWMImages);
  begin
    actor.g_boIsMyShow := True;
    actor.m_nMyShowStartFrame := StartFrame; //开始
    actor.m_nMyShowExplosionFrame := ExplosionFrame; //往后播放
    actor.m_nMyShowNextFrameTime := NextFrameTime;
    actor.m_nMyShowTime := GetTickCount;
    actor.m_nMyShowFrame := 0;
    actor.g_MagicBase := wimg;
  end;
begin
  actor.m_boNoChangeIsMyShow := False; //初始化 自身效果 是变化的 20080306
  case TypeShow of
    ET_PROTECTION_PIP: begin
      MyShow(actor, 470, 5, 140, g_WMagic6Images);  //破盾效果
      MyPlaySound (heroshield_ground); //护体神盾声音
    end;
    ET_PROTECTION_STRUCK: begin
      MyShow(actor, 790, 10, 140, g_WMagic5Images);  //受攻击效果
      MyPlaySound (heroshield_ground); //护体神盾声音
    end;
    ET_OBJECTLEVELUP: begin
      MyShow(actor, 110, 14, 80, g_WMain2Images);  //升级效果 20080222
      MyPlaySound(powerup_ground);
    end;
    ET_OBJECTBUTCHMON: begin
      MyShow(actor, 30, 24, 140, g_WMain2Images); //卧龙挖到东西效果图 20080326
      MyPlaySound(darewin_ground);
    end;
    ET_DRINKDECDRAGON: begin
      MyShow(actor, 710, 18, 80, g_WMain2Images); //喝酒抵御合击，显示自身效果 20090105
    end;
    1: begin //龙影剑法  后9个动画效果 20080202
      actor.m_boWarMode := TRUE;
      MyShow(actor, actor.m_btDir * 20 + 746, 9, 50, g_WMagic2Images);
      actor.m_boNoChangeIsMyShow := True; //龙影的动画不随着人物变化而动 设为真 20080306
      actor.m_nNoChangeX := actor.m_nCurrX;  //20080306
      actor.m_nNoChangeY := actor.m_nCurrY;  //20080306
    end;
    2: begin //开天斩重击碎冰效果
      MyShow(actor, actor.m_btDir * 10 + 555, 5, 150, g_WMagic5Images);
      actor.m_boWarMode := TRUE;
      actor.m_boNoChangeIsMyShow := True; //开天斩重击碎冰的动画不随着人物变化而动 设为真 20080306
      actor.m_nNoChangeX := actor.m_nCurrX;  //20080306
      actor.m_nNoChangeY := actor.m_nCurrY;  //20080306
    end;
    3: begin //开天斩轻击碎冰效果
      MyShow(actor, actor.m_btDir * 10 + 715, 5, 150, g_WMagic5Images);
      actor.m_boWarMode := TRUE;
      actor.m_boNoChangeIsMyShow := True; //开天斩轻击碎冰的动画不随着人物变化而动 设为真 20080306
      actor.m_nNoChangeX := actor.m_nCurrX;  //20080306
      actor.m_nNoChangeY := actor.m_nCurrY;  //20080306
    end;
    4: MyShow(actor, 170, 4, 150, g_WMagic4Images);//破魂斩  攻击前 怪物自身动画
    5: MyShow(actor, 460, 10, 80, g_WMagic4Images); //劈星战士效果 20080611  //战士攻击自身效果
    6: MyShow(actor, 420, 16, 120, g_WMagic4Images); //雷霆一击战士效果 20080611
    7: MyShow(actor, 630, 5, 80, g_WMain2Images); //人物喝酒动画 20080623
    8: MyShow(actor, 640, 9, 80, g_WMain2Images); //人物酒量提升进度释放动画 20080623
    9: MyShow(actor, 650, 14, 80, g_WMain2Images); //人物醉酒动画 20080623
   10: begin
      MyShow(actor, 670, 17, 80, g_WMain2Images); //采集到泉水动画  20080624
      PlaySound (s_click_drug);
   end;
   11: begin //噬血术 人物自身动画显示
      MyShow(actor, 1090, 9, 50, g_WMagic2Images); 
      PlaySound(10485);
   end;
  end;
end;

//英雄召唤或退出动画显示
procedure TfrmMain.ShowHeroLoginOrLogOut(Actor: TActor);
begin
  actor.g_HeroLoginOrLogOut:=True;
  actor.HeroLoginStartFrame:=800; //开始
  actor.HeroLoginExplosionFrame:=10; //往后播放
  actor.HeroLoginNextFrameTime:=100;
  actor.HeroTime:=GetTickCount;
  actor.HeroFrame:=0;
end;

procedure TfrmMain._DXDrawMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   tdir, nx, ny, nHitMsg, sel: integer;
   target: TActor;
begin
   ActionKey := 0;
   g_nMouseX := X;
   g_nMouseY := Y;
   g_boAutoDig := FALSE; //取消挖矿
   //右键取消物品的移动
   if (Button = mbRight) and (g_boItemMoving) then begin
      FrmDlg.CancelItemMoving;
      Exit;
   end;
   //右键取消英雄物品的移动
   if (Button = mbRight) and (g_boHeroItemMoving{20080320}) then begin
      FrmDlg.CancelHeroItemMoving;
      Exit;
   end;
   if g_DWinMan.MouseDown (Button, Shift, X, Y) then Exit; //鼠标移到窗口上了则跳过
   if (g_MySelf = nil) or (DScreen.CurrentScene <> PlayScene) then Exit;  //如果人物退出则跳过

   if Timer2.Enabled then begin     //停止自由移动
      Timer2.Enabled := False;
      FreeTree();
      ClearRoad;
      DScreen.AddChatBoardString('停止自由移动',GetRGB(178), ClWhite);
   end;
   if ssRight in Shift then begin//鼠标右键
      if Shift = [ssRight] then Inc (g_nDupSelection);  //多选
      target := PlayScene.GetAttackFocusCharacter (X, Y, g_nDupSelection, sel, FALSE); //取指定坐标上的角色
      if g_nDupSelection <> sel then g_nDupSelection := 0;

      if target <> nil then begin
         if ssCtrl in Shift then begin  //Ctrl+鼠标右键 = 显示角色的信息
            if GetTickCount - g_dwLastMoveTick > 1000 then begin   //指向一个玩家，一秒后才可以查看其装备
               if (target.m_btRace in [0,1,150]{人类,英雄,人型20080629}) {and (not target.m_boDeath)} then begin
                  //取得人物信息
                  SendClientMessage (CM_QUERYUSERSTATE, target.m_nRecogId, target.m_nCurrX, target.m_nCurrY, 0);
                  Exit;
               end;
            end;
         end;
         if ssAlt in Shift then begin //Alt+鼠标右键 = 密人  20080701
           if (target.m_btRace in [0,1,150]) {and (not target.m_boDeath)} then begin
              PlayScene.EdChat.Visible := TRUE;
              PlayScene.EdChat.Text := '/'+ target.m_sUserName+' ';
              PlayScene.EdChat.SetFocus;
              SetImeMode (PlayScene.EdChat.Handle, LocalLanguage);
              PlayScene.EdChat.SelStart := Length(PlayScene.EdChat.Text);
              Exit;
           end;
         end;
      end else
         g_nDupSelection := 0;
      //按鼠标右键，并且鼠标指向空位置
      PlayScene.CXYfromMouseXY (X, Y, g_nMouseCurrX, g_nMouseCurrY);

      if (abs(g_MySelf.m_nCurrX - g_nMouseCurrX) <= 1) and (abs(g_MySelf.m_nCurrY - g_nMouseCurrY) <= 1) then begin //目标座标  //两格范围内
         tdir := GetNextDirection (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_nMouseCurrX, g_nMouseCurrY);
         if CanNextAction and ServerAcceptNextAction then begin
            g_MySelf.SendMsg (CM_TURN, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0);
         end;
      end else begin //跑
         g_ChrAction := caRun;
         g_nTargetX := g_nMouseCurrX;
         g_nTargetY := g_nMouseCurrY;
         Exit;
      end;
   end;

   if ssLeft in Shift {Button = mbLeft} then begin  //鼠标左键
      //傍拜... 承篮 裹困肺 急琶凳
      target := PlayScene.GetAttackFocusCharacter (X, Y, g_nDupSelection, sel, TRUE); //混酒乐绰 仇父..
      PlayScene.CXYfromMouseXY (X, Y, g_nMouseCurrX, g_nMouseCurrY);
      g_TargetCret := nil;
      if (g_UseItems[U_WEAPON].S.Name <> '') and (target = nil)
{//骑马状态不可以操作    20080721 注释骑马
        and (g_MySelf.m_btHorse = 0)} then begin
         //挖矿
         if g_UseItems[U_WEAPON].S.Shape = 19 then begin //鹤嘴锄
            tdir := GetNextDirection (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_nMouseCurrX, g_nMouseCurrY);
            //根据当前位置和方向获得前进一步的坐标
            GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, nx, ny);
            if not Map.CanMove(nx, ny) or (ssShift in Shift) then begin  //不能移动或强行挖矿
               if CanNextAction and ServerAcceptNextAction and CanNextHit then begin
                  g_MySelf.SendMsg (CM_HIT+1, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0);
               end;
               g_boAutoDig := TRUE;  //自动锄矿
               Exit;
            end;
         end;
      end;

      if (ssAlt in Shift)
{//骑马状态不可以操作
        and (g_MySelf.m_btHorse = 0)20080721 注释骑马} then begin
         //挖物品
         tdir := GetNextDirection (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_nMouseCurrX, g_nMouseCurrY);
         if CanNextAction and ServerAcceptNextAction then begin
            target := PlayScene.ButchAnimal (g_nMouseCurrX, g_nMouseCurrY);
            if target <> nil then begin
               SendButchAnimal (g_nMouseCurrX, g_nMouseCurrY, tdir, target.m_nRecogId);
               g_MySelf.SendMsg (CM_SITDOWN, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0); //磊技绰 鞍澜
               exit;
            end;
            g_MySelf.SendMsg (CM_SITDOWN, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0);//蹲下
         end;
         g_nTargetX := -1;
      end else begin
         if (target <> nil) or (ssShift in Shift) then begin  //对象不为nil 或 Shift+左键
            g_nTargetX := -1;
            if target <> nil then begin
               //if GetTickCount - g_dwLastMoveTick > 1500 then begin  //20080229  修正NPC还是不怎么点的动
                  if target.m_btRace = RCC_MERCHANT then begin //点的目标商人
                     SendClientMessage (CM_CLICKNPC, target.m_nRecogId, 0, 0, 0);
                     Exit;
                //  end;
               end;

               if (not target.m_boDeath) (* and (g_MySelf.m_btHorse = 0{骑马不允许操作})20080721 注释骑马*) then begin
                  g_TargetCret := target;
                  if ((target.m_btRace <> RCC_USERHUMAN) and
                      (target.m_btRace <> 1) and //英雄 20080629
                      (target.m_btRace <> 150) and //人型 20080629
                      (target.m_btRace <> RCC_GUARD) and
                      (target.m_btRace <> RCC_MERCHANT) and
                      (pos('(', target.m_sUserName) = 0) //包括'('的角色名称为召唤的宝宝
                     )
                     or (ssShift in Shift) //SHIFT + 鼠标左键
                     or (target.m_nNameColor = ENEMYCOLOR)
                  then begin
                     AttackTarget (target);
                     g_dwLatestHitTick := GetTickCount;
                  end;
               end;
            end else begin
{//骑马不允许操作  20080721 注释骑马
               if (g_MySelf.m_btHorse = 0) then begin  }
               tdir := GetNextDirection (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_nMouseCurrX, g_nMouseCurrY);
               if CanNextAction and ServerAcceptNextAction and CanNextHit then begin
                  nHitMsg := CM_HIT+Random(3);
                  if g_boCanLongHit  and (TargetInSwordLongAttackRange (tdir)) then begin  //是否可以使用刺杀
                     nHitMsg := CM_LONGHIT;
                  end;
                  if g_boCanWideHit and (g_MySelf.m_Abil.MP >= 3) and (TargetInSwordWideAttackRange (tdir)) then begin  //是否可以使用半月
                     nHitMsg := CM_WIDEHIT;
                  end;
                  if g_boCanCrsHit and (g_MySelf.m_Abil.MP >= 6) and (TargetInSwordCrsAttackRange (tdir)) then begin  //是否可以使用半月
                     nHitMsg := CM_CRSHIT;
                  end;
                  g_MySelf.SendMsg (nHitMsg, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0);
               end;
               g_dwLastAttackTick := GetTickCount;
              // end;
            end;
         end else begin
//            if (MCX = Myself.XX) and (MCY = Myself.m_nCurrY) then begin
            if (g_nMouseCurrX = (g_MySelf.m_nCurrX)) and (g_nMouseCurrY = (g_MySelf.m_nCurrY)) then begin
               //tdir := GetNextDirection (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_nMouseCurrX, g_nMouseCurrY);
               if CanNextAction and ServerAcceptNextAction then begin
                  SendPickup; //捡物品
               end;
            end else
               if GetTickCount - g_dwLastAttackTick > 1000 then begin //最后攻击操作停留指定时间才能移动
                  if ssCtrl in Shift then begin
                     g_ChrAction := caRun;
                  end else begin
                     g_ChrAction := caWalk;
                  end;
                  g_nTargetX := g_nMouseCurrX;
                  g_nTargetY := g_nMouseCurrY;
               end;
         end;
      end;
   end;
end;

procedure TfrmMain.DXDrawDblClick(Sender: TObject);
var
   pt: TPoint;
begin
   GetCursorPos (pt);
   pt:= ScreenToClient(pt);
   if g_DWinMan.DblClick (pt.X, pt.Y) then exit;
end;

function  TfrmMain.CheckDoorAction (dx, dy: integer): Boolean;
var
   door: integer;
begin
   Result := FALSE;
   door := Map.GetDoor (dx, dy);
   if door > 0 then begin
      if not Map.IsDoorOpen (dx, dy) then begin
         SendClientMessage (CM_OPENDOOR, door, dx, dy, 0);
         Result := TRUE;
      end;
   end;
end;

procedure TfrmMain.DXDrawMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   if g_DWinMan.MouseUp (Button, Shift, X, Y) then exit;
   g_nTargetX := -1;
end;

procedure TfrmMain.DXDrawClick(Sender: TObject);
var
   pt: TPoint;
begin
   GetCursorPos (pt);
   pt:= ScreenToClient(pt);
   if g_DWinMan.Click (pt.X, pt.Y) then Exit;
end;

//鼠标事件:当选择了魔法等攻击前，显示一个选择被攻击对象的鼠标
procedure TfrmMain.MouseTimerTimer(Sender: TObject);
var
   I: Integer;
   pt: TPoint;
   keyvalue: TKeyBoardState;
   shift: TShiftState;
begin
   GetCursorPos (pt);
   SetCursorPos (pt.X, pt.Y);
   if g_TargetCret <> nil then begin
      if ActionKey > 0 then begin
         ProcessKeyMessages;
      end else begin
         if not g_TargetCret.m_boDeath and PlayScene.IsValidActor(g_TargetCret) then begin
            FillChar(keyvalue, sizeof(TKeyboardState), #0);
            if GetKeyboardState (keyvalue) then begin
               shift := [];
               if ((keyvalue[VK_SHIFT] and $80) <> 0) then shift := shift + [ssShift];
               if ((g_TargetCret.m_btRace <> RCC_USERHUMAN) and
                   (g_TargetCret.m_btRace <> 1) and //英雄 20080629
                   (g_TargetCret.m_btRace <> 150) and //人型 20080629
                   (g_TargetCret.m_btRace <> RCC_GUARD) and
                   (g_TargetCret.m_btRace <> RCC_MERCHANT) and
                   (pos('(', g_TargetCret.m_sUserName) = 0) //宝宝
                  )
                  or (g_TargetCret.m_nNameColor = ENEMYCOLOR)   //利篮 磊悼 傍拜捞 凳
                  or ((ssShift in Shift) and (not PlayScene.EdChat.Visible))
                  or g_boNoShift  //免Shift
                  then begin //荤恩阑 角荐肺 傍拜窍绰 巴阑 阜澜
                  AttackTarget (g_TargetCret);
               end; //else begin
                  //TargetCret := nil;
               //end
            end;
         end else
            g_TargetCret := nil;
      end;
   end;
   if g_boAutoDig then begin  //自动挖矿
      if CanNextAction and ServerAcceptNextAction and CanNextHit then begin
         g_MySelf.SendMsg (CM_HIT+1, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_MySelf.m_btDir, 0, 0, '', 0);
      end;
   end;
   //自动捡取
   if g_boAutoPuckUpItem and (g_MySelf <> nil) and ((GetTickCount() - g_dwAutoPickupTick) > 200) then begin
     g_dwAutoPickupTick:=GetTickCount();
     AutoPickUpItem();
   end;
   NearActor;
   AutoEatItem;
   //持久力警告
  if ((GetTickCount - g_SHowWarningDura) > 1000 * 60) and g_boDuraWarning then begin
    for i := 13 downto 0 do begin
      if (g_UseItems[i].s.Name <> '') then begin
        if (i = 5) and (g_UseItems[5].s.StdMode = 25) then continue;
        if i = U_BUJUK then continue;
        if Round((g_UseItems[i].Dura / g_UseItems[i].DuraMax) * 100) < 30 then begin
          if (I = U_CHARM) and (g_UseItems[I].s.Shape in [1..3]) then  //气血石
            DScreen.AddChatBoardString('提示:您的['+g_UseItems[i].s.Name +']持久力低于30%,建议重新在商铺购买!',ClRed, ClWhite)
          else
            DScreen.AddChatBoardString('提示:您的['+g_UseItems[i].s.Name +']持久力低于30%,请及时进行修理!',ClRed, ClWhite);
        end;
      end;
    end;
    for i := 13 downto 0 do begin
      if (g_HeroItems[i].s.Name <> '') then begin
        if i = U_BUJUK then continue;
        if Round((g_HeroItems[i].Dura / g_HeroItems[i].DuraMax) * 100) < 30 then begin
          if (I = U_CHARM) and (g_HeroItems[I].s.Shape in [1..3]) then  //气血石
            DScreen.AddChatBoardString('提示:英雄的['+g_HeroItems[i].s.Name +']持久力低于30%,建议重新在商铺购买!',ClRed, ClWhite)
          else
            DScreen.AddChatBoardString('提示:英雄的['+g_HeroItems[i].s.Name +']持久力低于30%,请及时进行修理!',ClRed, ClWhite);
        end;
      end;
    end;
    g_SHowWarningDura:= GetTickCount;
  end;

  if g_boAutoMagic and (g_nAutoMagicKey >= 112) then begin
    if g_MySelf.m_boDeath then Exit;
    if g_nAutoMagicTime < 2 then g_nAutoMagicTime := 2;
    if (GetTickCount - g_nAutoMagicTimeKick > (g_nAutoMagicTime * 1000)) then begin
      ActionKey := g_nAutoMAgicKey;
      g_nAutoMagicTimeKick := GetTickCount;
    end;
  end; 
end;

procedure TfrmMain.AutoPickUpItem;
var
  I: Integer;
  DropItem:pTDropItem;
  ShowItem:pTShowItem;
begin
  if CanNextAction and ServerAcceptNextAction then begin
    if g_AutoPickupList = nil then Exit;
    g_AutoPickupList.Clear;
    PlayScene.GetXYDropItemsList(g_MySelf.m_nCurrX,g_MySelf.m_nCurrY,g_AutoPickupList);

    if g_AutoPickupList.Count > 0 then //20080629
    for I := 0 to g_AutoPickupList.Count - 1 do begin
      DropItem:=g_AutoPickupList.Items[I];
      if g_boAutoPuckUpItem then begin
        ShowItem:=GetShowItem(DropItem.Name);
        if g_boFilterAutoItemUp then begin
          if ((ShowItem = nil) or (ShowItem.boAutoPickup)) then begin
            if (DropItem <> nil) and (DropItem.Name<>'') then
            SendPickup;
          end else Exit;
        end else begin
          if (DropItem <> nil) and (DropItem.Name<>'') then
          SendPickup;
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.WaitMsgTimerTimer(Sender: TObject);
begin
   if g_MySelf = nil then exit;
   if g_MySelf.ActionFinished then begin
      WaitMsgTimer.Enabled := FALSE;
      if WaitingMsg.Ident = SM_CHANGEMAP then begin
             g_boMapMovingWait := FALSE;
             g_boMapMoving := FALSE;
             if g_nMDlgX <> -1 then begin
                FrmDlg.CloseMDlg;
                g_nMDlgX := -1;
             end;
             ClearDropItems;
             //PlayScene.CleanObjects; 消息重复 20080820
             g_sMapTitle := '';
             FrmDlg.DSighIcon.Visible := False; //换地图清除感叹号图标
             g_MySelf.CleanCharMapSetting (WaitingMsg.Param, WaitingMsg.Tag);
             PlayScene.SendMsg (SM_CHANGEMAP, 0,
                                  WaitingMsg.Param{x},
                                  WaitingMsg.tag{y},
                                  WaitingMsg.Series{darkness},
                                  0, 0,
                                  WaitingStr{mapname});
             g_nTargetX := -1;
             //g_TargetCret := nil;  消息重复 20080820
             //g_FocusCret := nil;
      end;
   end;
end;



{----------------------- Socket -----------------------}
//在选择服务器后开启，等待一段时间后进入选择角色状态（等待“开门”的动画完成）
procedure TfrmMain.SelChrWaitTimerTimer(Sender: TObject);
begin
   SelChrWaitTimer.Enabled := FALSE;
   SendQueryChr(1);
end;

procedure TfrmMain.ActiveCmdTimer (cmd: TTimerCommand);
begin
   CmdTimer.Enabled := TRUE;
   TimerCmd := cmd;
end;
//处理跟网络连接有关的几个事件
procedure TfrmMain.CmdTimerTimer(Sender: TObject);
begin
   CmdTimer.Enabled := FALSE;
   //CmdTimer.Interval := 2000;
   CmdTimer.Interval := 500; //20080331
   case TimerCmd of
      tcSoftClose: begin //断开连接
          CmdTimer.Enabled := FALSE;
          CSocket.Socket.Close;
      end;
      tcReSelConnect: begin
        ResetGameVariables;  //清除所有对象
        DScreen.ChangeScene (stSelectChr); //返回到选择角色状态
        g_ConnectionStep := cnsReSelChr;   //重新连接服务器
      //            if ConnectionStep = cnsReSelChr then
        if not BoOneClick then begin
           with CSocket do begin
              Active := FALSE;
              Address := g_sSelChrAddr;
              Port := g_nSelChrPort;
              Active := TRUE;
           end;
        end else begin
           if CSocket.Socket.Connected then
              CSocket.Socket.SendText ('$S' + g_sSelChrAddr + '/' + IntToStr(g_nSelChrPort) + '%');
           CmdTimer.Interval := 1;
           ActiveCmdTimer (tcFastQueryChr);
        end;
      end;
      tcFastQueryChr: begin//查询角色
        SendQueryChr(0);
      end;
   end;
end;

procedure TfrmMain.CloseAllWindows;
var
  i: Integer;
  d: TDirectDrawSurface;
begin
   DScreen.m_boCountDown := False;
   with FrmDlg do begin
      DItemBag.Visible := FALSE;
      DMsgDlg.Visible := FALSE;
      DStateWin.Visible := FALSE;  //人物信息栏
      DMerchantDlg.Visible := FALSE;
      DSellDlg.Visible := FALSE;
      DMenuDlg.Visible := FALSE;
      DKeySelDlg.Visible := FALSE;
      DGroupDlg.Visible := FALSE;
      DDealDlg.Visible := FALSE;
      DWChallenge.Visible := False;
      DDealRemoteDlg.Visible := FALSE;
      DGuildDlg.Visible := FALSE;
      DGuildEditNotice.Visible := FALSE;
      DUserState1.Visible := FALSE;
      DAdjustAbility.Visible := FALSE;
      DBoxs.Visible := FALSE;
      DLieDragon.Visible := FALSE;
      DLieDragonNpc.Visible := FALSE;
      DWMiniMap.Visible := False;
      FillChar (g_BoxsItems, sizeof(TClientItem)*9, #0); //清空宝箱格里的物品
      FillChar (g_SellOffItems, sizeof(TClientItem)*9, #0); //释放寄售窗口物品 20080318
      FillChar (g_GetHeroData, sizeof(THeroDataInfo) *2,#0);  //20080514
      DWiGetHero.Visible := False;
      DPlayDrink.Visible := False;
      DWPleaseDrink.Visible := False;
      DStateTab.Visible := False;
      DHeroStateTab.Visible := False;
      DWSellOff.Visible := False;
      //DBotMemo.Visible := False;
      DWNewSdoAssistant.Visible := False;
      DShop.Visible := False;
      DItemsUp.Visible := False;
      DFriendDlg.Visible := False;
      DWMakeWineDesk.Visible := False;
      DDrunkScale.Visible := False;
      DLevelOrder.Visible := False;
      DSighIcon.Visible := False; //隐藏感叹号图标
      DWExpCrystal.Visible := False;
      FillChar (g_ItemsUpItem, sizeof(TClientItem)*3, #0); //清空淬炼格里的物品
      FillChar (g_PDrinkItem, sizeof(TClientItem)*2, #0);
      FillChar (g_WineItem, sizeof(TClientItem)*7, #0);
      FillChar (g_DrugWineItem, sizeof(TClientItem)*3, #0);
      ShowBoxsGird(False); //隐藏宝箱格
      g_BoxsShowPosition := -1;
      g_boIsInternalForce := False;
      g_boIsHeroInternalForce := False;
      g_btInternalForceLevel := 0;
      g_btHeroInternalForceLevel := 0;

      if g_InternalForceMagicList.Count > 0 then
      for I:=0 to g_InternalForceMagicList.Count-1 do
      Dispose (PTClientMagic (g_InternalForceMagicList[i]));
      g_InternalForceMagicList.Clear;

      if g_HeroInternalForceMagicList.Count > 0 then
      for I:=0 to g_HeroInternalForceMagicList.Count-1 do
      Dispose (PTClientMagic (g_HeroInternalForceMagicList[i]));
      g_HeroInternalForceMagicList.Clear;

      d := g_WMain3Images.Images[207];
      if d <> nil then
      DStateWin.SetImgIndex (g_WMain3Images, 207); //人物状态  4格图

      d := g_WMain3Images.Images[384];
      if d <> nil then
      DStateHero.SetImgIndex (g_WMain3Images, 384); //人物状态  4格图

      g_HeroSelf           :=nil;
      if g_HeroSelf = nil then begin
        DStateHero.Visible := FALSE; //英雄信息栏
        DHeroSpleen.Visible := FALSE; //英雄怒气
        DHeroItemBag.Visible := FALSE; //英雄包裹
        DHeroIcon.Visible := FALSE; //英雄图标
        HeroStatePage := 0;
        FillChar (g_HeroItems, sizeof(TClientItem)*14, #0);
        FillChar (g_GetHeroData, sizeof(THeroDataInfo) *2,#0);  //20080514
        FillChar (g_HeroItemArr, sizeof(TClientItem)*MAXBAGITEMCL, #0);
        //清空英雄魔法

        if g_HeroMagicList.Count > 0 then //20080629
        for i:=0 to g_HeroMagicList.Count-1 do
        Dispose (PTClientMagic (g_HeroMagicList[i]));
        g_HeroMagicList.Clear;

        FrmDlg.CallHero.ShowHint := True; //模式变为英雄退出
      end;
   end;
   if g_nMDlgX <> -1 then begin
      FrmDlg.CloseMDlg;
      g_nMDlgX := -1;
   end;
   g_boItemMoving := FALSE;  //
   g_boHeroItemMoving :=FALSE;
end;

procedure TfrmMain.ClearDropItems;
var
  I:Integer;
begin
  if g_DropedItemList.Count > 0 then begin//20080629
    for I:=0 to g_DropedItemList.Count - 1 do begin
      Dispose (PTDropItem(g_DropedItemList[I]));
    end;
    g_DropedItemList.Clear;
  end;
end;

procedure TfrmMain.ResetGameVariables;
var
   i: integer;
begin
try
   CloseAllWindows;
   ClearDropItems;
   if g_MagicList.Count > 0 then begin//20080629
     for i:=0 to g_MagicList.Count - 1  do begin
      if pTClientMagic(g_MagicList[i]) <> nil then
        Dispose(pTClientMagic(g_MagicList[i]));
     end;
     g_MagicList.Clear;
   end;

   g_boItemMoving := FALSE;
   g_WaitingUseItem.Item.S.Name := '';
   g_EatingItem.S.name := '';
   g_nTargetX := -1;
   g_TargetCret := nil;
   g_FocusCret := nil;
   g_MagicTarget := nil;
   ActionLock := FALSE;
   g_GroupMembers.Clear;
   g_sGuildRankName := '';
   g_sGuildName := '';
   g_FriendList.Clear;
   g_HeiMingDanList.Clear;
   g_boMapMoving := FALSE;
   WaitMsgTimer.Enabled := FALSE;
   g_boMapMovingWait := FALSE;
   DScreen.ChatBoardTop := 0;
   g_boNextTimePowerHit := FALSE;
   g_boCanLongHit := FALSE;
   g_boCanWideHit := FALSE;
   g_boCanCrsHit   := False;
   g_boCanTwnHit   := False; //关闭开天斩重击
   g_boCanQTwnHit  := False; //关闭开天斩轻击
   g_boCanCIDHit   := False; //关闭龙影剑法

   g_boNextTimeFireHit := FALSE; //关闭烈火
   g_boNextTime4FireHit := FALSE; //关闭4级烈火

   FillChar (g_UseItems, sizeof(TClientItem)*14, #0);  //2008.01.16 修正  原为9

   FillChar (g_BoxsItems, sizeof(TClientItem)*9, #0);  //宝箱物品释放 2008.01.16
   FillChar (g_SellOffItems, sizeof(TClientItem)*9, #0); //释放寄售窗口物品 20080318
   FillChar (g_ItemArr, sizeof(TClientItem)*MAXBAGITEMCL, #0);

   with SelectChrScene do begin
      FillChar (ChrArr, sizeof(TSelChar)*2, #0);
      ChrArr[0].FreezeState := TRUE; //扁夯捞 倔绢 乐绰 惑怕
      ChrArr[1].FreezeState := TRUE;
   end;
   PlayScene.ClearActors;
   ClearDropItems;
   EventMan.ClearEvents;
   PlayScene.CleanObjects;
   //DxDrawRestoreSurface (self);
   g_MySelf := nil;
   g_HeroSelf := nil;
except
end;
end;

procedure TfrmMain.ChangeServerClearGameVariables;
var
   i: integer;
begin
   CloseAllWindows;
   ClearDropItems;
   if g_MagicList.Count > 0 then //20080629
   for i:=0 to g_MagicList.Count-1 do
      Dispose (PTClientMagic (g_MagicList[i]));
   g_MagicList.Clear;
   g_boItemMoving := FALSE;
   g_WaitingUseItem.Item.S.Name := '';
   g_EatingItem.S.name := '';
   g_nTargetX := -1;
   g_TargetCret := nil;
   g_FocusCret := nil;
   g_MagicTarget := nil;
   ActionLock := FALSE;
   g_GroupMembers.Clear;
   g_sGuildRankName := '';
   g_sGuildName := '';
   g_FriendList.Clear;
   g_HeiMingDanList.Clear;

   g_boMapMoving := FALSE;
   WaitMsgTimer.Enabled := FALSE;
   g_boMapMovingWait := FALSE;
   g_boNextTimePowerHit := FALSE;
   g_boCanLongHit := FALSE;
   g_boCanWideHit := FALSE;
   g_boCanCrsHit   := False;
   g_boCanTwnHit   := False; //关闭开天斩 重击
   g_boCanQTwnHit  := False; //关闭开天斩 轻击  2008.02.12
   g_boCanCIDHit   := False;

   ClearDropItems;
   EventMan.ClearEvents;
   PlayScene.CleanObjects;
end;

procedure TfrmMain.CSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
   packet: array[0..255] of char;
   strbuf: array[0..255] of char;
   str: string;
begin
   g_boServerConnected := TRUE;
   if g_ConnectionStep = cnsLogin then begin
      if OneClickMode = toKornetWorld then begin  //内齿岿靛甫 版蜡秦辑 霸烙俊 立加
         FillChar (packet, 256, #0);
         str := 'KwGwMGS';             StrPCopy (strbuf, str);  Move (strbuf, (@packet[0])^, Length(str));
         str := 'CONNECT';             StrPCopy (strbuf, str);  Move (strbuf, (@packet[8])^, Length(str));
         str := KornetWorld.CPIPcode;  StrPCopy (strbuf, str);  Move (strbuf, (@packet[16])^, Length(str));
         str := KornetWorld.SVCcode;   StrPCopy (strbuf, str);  Move (strbuf, (@packet[32])^, Length(str));
         str := KornetWorld.LoginID;   StrPCopy (strbuf, str);  Move (strbuf, (@packet[48])^, Length(str));
         str := KornetWorld.CheckSum;  StrPCopy (strbuf, str);  Move (strbuf, (@packet[64])^, Length(str));
         Socket.SendBuf (packet, 256);
      end;
      DScreen.ChangeScene (stLogin);
{$IF USECURSOR = DEFAULTCURSOR}
      DxDraw.Cursor:=crDefault;
{$IFEND}
      if ParamStr(3) <> '' then 
      CSocket.Socket.SendText ('<56m2>' + ParamStr(3));
   end;
   if g_ConnectionStep = cnsSelChr then begin
      LoginScene.OpenLoginDoor;
      SelChrWaitTimer.Enabled := TRUE;
   end;
   if g_ConnectionStep = cnsReSelChr then begin
      CmdTimer.Interval := 1;
      ActiveCmdTimer (tcFastQueryChr);
   end;
   if g_ConnectionStep = cnsPlay then begin
      if not g_boServerChanging then begin
         ClearBag;  //清理包裹
         DScreen.ClearChatBoard; //清理聊天信息
         DScreen.ChangeScene (stLoginNotice);
      end else begin
         ChangeServerClearGameVariables;        
      end;
      SendRunLogin;
   end;
   SocStr := '';
   BufferStr := '';
end;

procedure TfrmMain.CSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   g_boServerConnected := FALSE;
   {if (g_ConnectionStep = cnsLogin) and not g_boSendLogin then begin
     FrmDlg.DMessageDlg ('服务器关闭或网络不稳定,请联系官方客服人员!!', [mbOk]);
     Close;
   end; }
   FrmDlg.DLOGO.Visible := False;
   CloseTimer.Enabled := True;
   if g_SoftClosed then begin
      g_SoftClosed := FALSE;
      ActiveCmdTimer (tcReSelConnect);
   end;
end;

procedure TfrmMain.CSocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
   ErrorCode := 0;
   Socket.Close;
end;

procedure TfrmMain.CSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
   n: integer;
   data, data2: string;
begin
   data := Socket.ReceiveText;
   n := pos('*', data);
   if n > 0 then begin //去掉*号
      data2 := Copy (data, 1, n-1);
      data := data2 + Copy (data, n+1, Length(data));
      CSocket.Socket.SendText ('*');
   end;
   SocStr := SocStr + data;
end;

{-------------------------------------------------------------}

procedure TfrmMain.SendSocket (sendstr: string);
const
   code: byte = 1;
begin
   if CSocket.Socket.Connected then begin
      CSocket.Socket.SendText ('#' + IntToStr(code) + sendstr + '!');
     Inc (code);
     if code >= 10 then code := 1;
   end;
end;


procedure TfrmMain.SendClientMessage (msg, Recog, param, tag, series: integer);
var
   dmsg: TDefaultMessage;
begin
   dmsg := MakeDefaultMsg (msg, Recog, param, tag, series, Certification);
   SendSocket (EncodeMessage (dmsg));
end;

procedure TfrmMain.SendLogin (uid, passwd: string);
var
   msg: TDefaultMessage;
begin
   LoginId := uid;
   LoginPasswd := passwd;
   msg := MakeDefaultMsg (CM_IDPASSWORD, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString(uid + '/' + passwd));
   g_boSendLogin:=True;
end;

procedure TfrmMain.SendNewAccount (ue: TUserEntry; ua: TUserEntryAdd);
var
   msg: TDefaultMessage;
begin
   MakeNewId := ue.sAccount;
   msg := MakeDefaultMsg (CM_ADDNEWUSER, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeBuffer(@ue, sizeof(TUserEntry)) + EncodeBuffer(@ua, sizeof(TUserEntryAdd)));
end;

procedure TfrmMain.SendUpdateAccount (ue: TUserEntry; ua: TUserEntryAdd);
var
   msg: TDefaultMessage;
begin
   MakeNewId := ue.sAccount;
   msg := MakeDefaultMsg (CM_UPDATEUSER, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeBuffer(@ue, sizeof(TUserEntry)) + EncodeBuffer(@ua, sizeof(TUserEntryAdd)));
end;

procedure TfrmMain.SendSelectServer (svname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_SELECTSERVER, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString(svname));
end;

procedure TfrmMain.SendChgPw (id, passwd, newpasswd: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_CHANGEPASSWORD, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (id + #9 + passwd + #9 + newpasswd));
end;

procedure TfrmMain.SendNewChr (uid, uname, shair, sjob, ssex: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_NEWCHR, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (uid + '/' + uname + '/' + shair + '/' + sjob + '/' + ssex));
end;

procedure TfrmMain.SendQueryChr(Code:Byte); //Code为1则查询验证码  为0则不查询
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_QUERYCHR, 0, 0, 0, Code, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString(LoginId + '/' + IntToStr(Certification)));
end;

procedure TfrmMain.SendDelChr (chrname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_DELCHR, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString(chrname));
end;

procedure TfrmMain.SendSelChr (chrname: string);
var
   msg: TDefaultMessage;
begin
   CharName := chrname;
   msg := MakeDefaultMsg (CM_SELCHR, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString(LoginId + '/' + chrname));
   PlayScene.EdAccountt.Visible:=False;//2004/05/17
   PlayScene.EdChrNamet.Visible:=False;//2004/05/17
   FrmDlg.btnRecvChrCloseClick (self, 0, 0);
end;

procedure TfrmMain.SendRunLogin;
var
   sSendMsg:String;
begin
   sSendMsg:=format('**%s/%s/%d/%d/%d',[LoginId,CharName,Certification,CLIENT_VERSION_NUMBER,RUNLOGINCODE]);
   SendSocket (EncodeString (sSendMsg));
end;

procedure TfrmMain.SendSay (str: string);
var
   msg: TDefaultMessage;
begin
   if str <> '' then begin
     if m_boPasswordIntputStatus then begin
       m_boPasswordIntputStatus      := False;
       PlayScene.EdChat.PasswordChar := #0;
       PlayScene.EdChat.Visible      := False;
       SendPassword(str,1);
       exit;
     end;


     {$if Version = 0}
     if str = ' ' then begin
        //g_boShowMemoLog:=not g_boShowMemoLog;
        PlayScene.MemoLog.Clear;
        PlayScene.MemoLog.Visible:=not PlayScene.MemoLog.Visible;
        Exit;
      end;
      {$IFEND}
      {if str = '/check speedhack' then begin
         g_boCheckSpeedHackDisplay := not g_boCheckSpeedHackDisplay;
         exit;
      end;
      if str = '/hungry' then begin
         Inc(g_nMyHungryState);
         if g_nMyHungryState > 4 then g_nMyHungryState:=1;
           
         exit;
      end;    }

      if str = '@password' then begin
         if PlayScene.EdChat.PasswordChar = #0 then
            PlayScene.EdChat.PasswordChar := '*'
         else PlayScene.EdChat.PasswordChar := #0;
         exit;   
      end;
      if PlayScene.EdChat.PasswordChar = '*' then
        PlayScene.EdChat.PasswordChar:= #0;

      msg := MakeDefaultMsg (CM_SAY, 0, 0, 0, 0, Certification);
      SendSocket (EncodeMessage (msg) + EncodeString(str));
      if str[1] = '/' then begin
         DScreen.AddChatBoardString (str, GetRGB(180), clWhite);
         GetValidStr3 (Copy(str,2,Length(str)-1), WhisperName, [' ']);
      end;
   end;
end;

procedure TfrmMain.SendActMsg (ident, x, y, dir: integer);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (ident, MakeLong(x,y), 0, dir, 0, Certification);
   SendSocket (EncodeMessage (msg));
   ActionLock := TRUE; //辑滚俊辑 #+FAIL! 捞唱 #+GOOD!捞 棵锭鳖瘤 扁促覆
   ActionLockTime := GetTickCount;
   Inc (g_nSendCount);
end;

procedure TfrmMain.SendSpellMsg (ident, x, y, dir, target: integer);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (ident, MakeLong(x,y), Loword(target), dir, Hiword(target), Certification);
   SendSocket (EncodeMessage (msg));
   ActionLock := TRUE; //辑滚俊辑 #+FAIL! 捞唱 #+GOOD!捞 棵锭鳖瘤 扁促覆
   ActionLockTime := GetTickCount;
   Inc (g_nSendCount);
end;

procedure TfrmMain.SendQueryUserName (targetid, x, y: integer);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_QUERYUSERNAME, targetid, x, y, 0, Certification);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendHeroDropItem (name: string; itemserverindex: integer);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_HERODROPITEM, itemserverindex, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (name));
end;

procedure TfrmMain.SendDropItem (name: string; itemserverindex: integer);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_DROPITEM, itemserverindex, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (name));
end;

procedure TfrmMain.SendPickup;
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_PICKUP, 0, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, 0, Certification);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendTakeOnHeroItem (where: byte; itmindex: integer; itmname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_HEROTAKEONITEM, itmindex, where, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (itmname));
end;

procedure TfrmMain.SendTakeOnItem (where: byte; itmindex: integer; itmname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_TAKEONITEM, itmindex, where, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (itmname));
end;

procedure TfrmMain.SendItemToMasterBag (where: byte; itmindex: integer; itmname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_SENDITEMTOMASTERBAG, itmindex, where, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (itmname));
end;

procedure TfrmMain.SendItemToHeroBag (where: byte; itmindex: integer; itmname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_SENDITEMTOHEROBAG, itmindex, where, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (itmname));
end;

procedure TfrmMain.SendTakeOffHeroItem (where: byte; itmindex: integer; itmname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_HEROTAKEOFFITEM, itmindex, where, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (itmname));
end;

procedure TfrmMain.SendTakeOffItem (where: byte; itmindex: integer; itmname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_TAKEOFFITEM, itmindex, where, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (itmname));
end;

procedure TfrmMain.SendHeroEat (itmindex: integer; itmname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_HEROEAT, itmindex, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (itmname));
end;

procedure TfrmMain.SendEat (itmindex: integer; itmname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_EAT, itmindex, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (itmname));
end;
//挖动物尸体
procedure TfrmMain.SendButchAnimal (x, y, dir, actorid: integer);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_BUTCH, actorid, x, y, dir, Certification);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendMagicKeyChange (magid: integer; keych: char);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_MAGICKEYCHANGE, magid, byte(keych), 0, 0, Certification);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendMerchantDlgSelect (merchant: integer; rstr: string);
var
   msg: TDefaultMessage;
   param: string;
   I: Integer;
begin
   param := '';
   if Length(rstr) >= 2 then begin  //颇扼皋鸥啊 鞘夸茄 版快啊 乐澜.
      if (rstr[1] = '@') and (rstr[2] = '@') then begin
         if rstr = '@@buildguildnow' then begin
            FrmDlg.DMessageDlg ('请输入建立这个行会名称.', [mbOk, mbAbort]);
         end else
         if Pos('@@InPutString',rstr) > 0 then begin
            FrmDlg.DMessageDlg ('输入信息', [mbOk, mbAbort]);
            if (Trim (FrmDlg.DlgEditText) = '') then begin
               FrmDlg.DMessageDlg ('信息不能为空！', [mbOk]);
               Exit;
            end;
            for I:=1 to length(FrmDlg.DlgEditText) do begin
              if FrmDlg.DlgEditText[i] in ['/','\'] then begin
                FrmDlg.DMessageDlg ('输入数据中包含了非法符号，请重新输入！', [mbOk]);
                Exit;
              end;
            end;
         end else
         if Pos('@@InPutInteger',rstr) > 0 then begin
            FrmDlg.DMessageDlg ('输入信息', [mbOk, mbAbort]);
            if (Trim (FrmDlg.DlgEditText) = '') then begin
               FrmDlg.DMessageDlg ('信息不能为空！', [mbOk]);
               Exit;
            end;
            for I:=1 to length(FrmDlg.DlgEditText) do begin
              if not (FrmDlg.DlgEditText[i] in ['0'..'9']) then begin
               FrmDlg.DMessageDlg ('输入数据中包含了非法符号，请重新输入！', [mbOk]);
               Exit;
              end;
            end;
            if (StrToInt(FrmDlg.DlgEditText) > 2147483646) then begin
             FrmDlg.DMessageDlg ('输入数字范围必须在0到21亿之间，请重新输入！', [mbOk]);
             Exit;
            end;
         end else  FrmDlg.DMessageDlg ('输入信息', [mbOk, mbAbort]);
         param := Trim (FrmDlg.DlgEditText);
         rstr := rstr + #13 + param;
      end;
   end;
   //if Trim(param) <> '' then begin
     msg := MakeDefaultMsg (CM_MERCHANTDLGSELECT, merchant, 0, 0, 0, Certification);
     SendSocket (EncodeMessage (msg) + EncodeString (rstr));
   //end;
end;
//询问物品价格
procedure TfrmMain.SendQueryPrice (merchant, itemindex: integer; itemname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_MERCHANTQUERYSELLPRICE, merchant, Loword(itemindex), Hiword(itemindex), 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (itemname));
end;
//询问修理价格
procedure TfrmMain.SendQueryRepairCost (merchant, itemindex: integer; itemname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_MERCHANTQUERYREPAIRCOST, merchant, Loword(itemindex), Hiword(itemindex), 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (itemname));
end;
//发送要出售的物品
procedure TfrmMain.SendSellItem (merchant, itemindex: integer; itemname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_USERSELLITEM, merchant, Loword(itemindex), Hiword(itemindex), 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (itemname));
end;
//发送要修理的物品
procedure TfrmMain.SendRepairItem (merchant, itemindex: integer; itemname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_USERREPAIRITEM, merchant, Loword(itemindex), Hiword(itemindex), 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (itemname));
end;
//发送要存放的物品
procedure TfrmMain.SendStorageItem (merchant, itemindex: integer; itemname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_USERSTORAGEITEM, merchant, Loword(itemindex), Hiword(itemindex), 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (itemname));
end;

procedure TfrmMain.SendGetDetailItem (merchant, menuindex: integer; itemname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_USERGETDETAILITEM, merchant, menuindex, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (itemname));
end;

procedure TfrmMain.SendBuyItem (merchant, itemserverindex: integer; itemname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_USERBUYITEM, merchant, Loword(itemserverindex), Hiword(itemserverindex), 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (itemname));
end;

procedure TfrmMain.SendTakeBackStorageItem (merchant, itemserverindex: integer; itemname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_USERTAKEBACKSTORAGEITEM, merchant, Loword(itemserverindex), Hiword(itemserverindex), 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (itemname));
end;

procedure TfrmMain.SendMakeDrugItem (merchant: integer; itemname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_USERMAKEDRUGITEM, merchant, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (itemname));
end;

procedure TfrmMain.SendDropGold (dropgold: integer);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_DROPGOLD, dropgold, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendGroupMode (onoff: Boolean);
var
   msg: TDefaultMessage;
begin
   if onoff then
      msg := MakeDefaultMsg (CM_GROUPMODE, 0, 1, 0, 0, Certification)   //on
   else msg := MakeDefaultMsg (CM_GROUPMODE, 0, 0, 0, 0, Certification);  //off
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendCreateGroup (withwho: string);
var
   msg: TDefaultMessage;
begin
   if withwho <> '' then begin
      msg := MakeDefaultMsg (CM_CREATEGROUP, 0, 0, 0, 0, Certification);
      SendSocket (EncodeMessage (msg) + EncodeString (withwho));
   end;
end;

procedure TfrmMain.SendWantMiniMap;
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_WANTMINIMAP, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendDealTry;
var
   msg: TDefaultMessage;
begin
    msg := MakeDefaultMsg (CM_DEALTRY, 0, 0, 0, 0, Certification);
    SendSocket (EncodeMessage (msg) + EncodeString (''));
end;

procedure TfrmMain.SendGuildDlg;
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_OPENGUILDDLG, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendCancelDeal;
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_DEALCANCEL, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendAddDealItem (ci: TClientItem);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_DEALADDITEM, ci.MakeIndex, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (ci.S.Name));
end;

procedure TfrmMain.SendDelDealItem (ci: TClientItem);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_DEALDELITEM, ci.MakeIndex, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (ci.S.Name));
end;
{******************************************************************************}
//往寄售窗口加物品 发送到M2 20080316
procedure TfrmMain.SendAddSellOffItem (ci: TClientItem);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg (CM_SELLOFFADDITEM, ci.MakeIndex, 0, 0, 0, Certification);
  SendSocket (EncodeMessage (msg) + EncodeString (ci.S.Name));
end;
//往包裹里返回物品 发送到M2 20080316
procedure TfrmMain.SendDelSellOffItem (ci: TClientItem);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_SELLOFFDELITEM, ci.MakeIndex, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (ci.S.Name));
end;
//取消寄售 发送到M2 20080316
procedure TfrmMain.SendCancelSellOffItem;
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_SELLOFFCANCEL, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg));
end;
//发送寄售信息 发送到M2 20080316
procedure TfrmMain.SendSellOffEnd;
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_SELLOFFEND, g_SellOffGameGold, g_SellOffGameDiaMond, High(Word), 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString(g_SellOffName));
end;
//取消正在寄售的物品 发送到M2 20080316
procedure TfrmMain.SendCancelMySellOffIteming;
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_CANCELSELLOFFITEMING, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg));
end;
//取消寄售物品 收购 发送到M2 20080318
procedure TfrmMain.SendSellOffBuyCancel;
var
  msg: TdefaultMessage;
begin
  msg := MakeDefaultMsg (CM_SELLOFFBUYCANCEL, 0, 0, 0, 0, Certification);
  SendSocket (EncodeMessage (msg) + EncodeString(g_SellOffInfo.sDealCharName));
end;
//寄售物品 确定购买 发送到M2 20080318
procedure TfrmMain.SendSellOffBuy;
var
  msg: TdefaultMessage;
begin
  msg := MakeDefaultMsg (CM_SELLOFFBUY, 0, 0, 0, 0, Certification);
  SendSocket (EncodeMessage (msg) + EncodeString(g_SellOffInfo.sDealCharName));
end;
{******************************************************************************}
procedure TfrmMain.SendChangeDealGold (gold: integer);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_DEALCHGGOLD, gold, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendDealEnd;
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_DEALEND, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendAddGroupMember (withwho: string);
var
   msg: TDefaultMessage;
begin
   if withwho <> '' then begin
      msg := MakeDefaultMsg (CM_ADDGROUPMEMBER, 0, 0, 0, 0, Certification);
      SendSocket (EncodeMessage (msg) + EncodeString (withwho));
   end;
end;

procedure TfrmMain.SendDelGroupMember (withwho: string);
var
   msg: TDefaultMessage;
begin
   if withwho <> '' then begin
      msg := MakeDefaultMsg (CM_DELGROUPMEMBER, 0, 0, 0, 0, Certification);
      SendSocket (EncodeMessage (msg) + EncodeString (withwho));
   end;
end;

procedure TfrmMain.SendGuildHome;
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_GUILDHOME, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendGuildMemberList;
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_GUILDMEMBERLIST, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendGuildAddMem (who: string);
var
   msg: TDefaultMessage;
begin
   if Trim(who) <> '' then begin
      msg := MakeDefaultMsg (CM_GUILDADDMEMBER, 0, 0, 0, 0, Certification);
      SendSocket (EncodeMessage (msg) + EncodeString (who));
   end;
end;

procedure TfrmMain.SendGuildDelMem (who: string);
var
   msg: TDefaultMessage;
begin
   if Trim(who) <> '' then begin
      msg := MakeDefaultMsg (CM_GUILDDELMEMBER, 0, 0, 0, 0, Certification);
      SendSocket (EncodeMessage (msg) + EncodeString (who));
   end;
end;
//商铺兑换灵符功能  20080302
procedure TfrmMain.SendBuyGameGird(GameGirdNum: Integer);
var
   msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg (CM_EXCHANGEGAMEGIRD, 0, GameGirdNum, 0, 0, Certification);
  SendSocket (EncodeMessage (msg));
end;
//发送行会公告信息更新
procedure TfrmMain.SendGuildUpdateNotice (notices: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_GUILDUPDATENOTICE, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (notices));
end;

procedure TfrmMain.SendGuildUpdateGrade (rankinfo: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_GUILDUPDATERANKINFO, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (rankinfo));
end;

{procedure TfrmMain.SendSpeedHackUser;
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_SPEEDHACKUSER, 0, 0, 0, 0);
   SendSocket (EncodeMessage (msg));
end;  }

procedure TfrmMain.SendAdjustBonus (remain: integer; babil: TNakedAbility);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_ADJUST_BONUS, remain, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeBuffer (@babil, sizeof(TNakedAbility)));
end;

{---------------------------------------------------------------}


function  TfrmMain.ServerAcceptNextAction: Boolean;
begin
   Result := TRUE;
   //若服务器未响应动作命令，则10秒后自动解锁
   if ActionLock then begin
      if GetTickCount - ActionLockTime > 10 * 1000 then begin
         ActionLock := FALSE;
      end;
      Result := FALSE;
   end;
end;

function  TfrmMain.CanNextAction: Boolean;
begin
   if (g_MySelf.IsIdle) and
      (g_MySelf.m_nState and $04000000 = 0) and
      (GetTickCount - g_dwDizzyDelayStart > g_dwDizzyDelayTime)
   then begin
      Result := TRUE;
   end else
      Result := FALSE;
end;
//是否可以攻击，控制攻击速度
function  TfrmMain.CanNextHit: Boolean;
var
   NextHitTime, LevelFastTime:Integer;
begin
   LevelFastTime:= _MIN (370, (g_MySelf.m_Abil.Level * 14));
   LevelFastTime:= _MIN (800, LevelFastTime + g_MySelf.m_nHitSpeed * g_nItemSpeed{60});

   (* //20080816 注释 腕力不足
   if g_boAttackSlow then
      NextHitTime:= g_nHitTime{1400} - LevelFastTime + 1500 //腕力超过时，减慢攻击速度
   else*) NextHitTime:= g_nHitTime{1400} - LevelFastTime;

   if NextHitTime < 0 then NextHitTime:= 0;

   if GetTickCount - LastHitTick > LongWord(NextHitTime) then begin
      LastHitTick:=GetTickCount;
      Result:=True;
   end else Result:=False;
end;

procedure TfrmMain.ActionFailed;
begin
   g_nTargetX := -1;
   g_nTargetY := -1;
   ActionFailLock := TRUE; //鞍篮 规氢栏肺 楷加捞悼角菩甫 阜扁困秦辑, FailDir苞 窃膊 荤侩
   ActionFailLockTime :=GetTickCount();//Jacky
   g_MySelf.MoveFail;
end;

function  TfrmMain.IsUnLockAction (action, adir: integer): Boolean;
begin
   if ActionFailLock then begin //如果操作被锁定，则在指定时间后解锁
     if GetTickCount() - ActionFailLockTime > 1000 then ActionFailLock:=False;
   end;
   if (ActionFailLock) or (g_boMapMoving) or (g_boServerChanging) then begin
      Result := FALSE;
   end else Result := TRUE;
end;

function TfrmMain.IsGroupMember (uname: string): Boolean;
var
   I: integer;
begin
   Result := FALSE;
   if g_GroupMembers.Count > 0 then //20080629
   for i:=0 to g_GroupMembers.Count-1 do
      if g_GroupMembers[i] = uname then begin
         Result := TRUE;
         break;
      end;
end;

{-------------------------------------------------------------}

procedure TfrmMain.Timer1Timer(Sender: TObject);
var
   data: string;
const
   busy: Boolean = FALSE;
begin
   if busy then exit;
   busy := TRUE;
   try
      BufferStr := BufferStr + SocStr;
      SocStr := '';
      if BufferStr <> '' then begin
         while Length(BufferStr) >= 2 do begin
            if g_boMapMovingWait then break; // 措扁..
            if Pos('!', BufferStr) <= 0 then break;
            BufferStr := ArrestStringEx (BufferStr, '#', '!', data);
            if data = '' then break;
            DecodeMessagePacket (data);
            if Pos('!', BufferStr) <= 0 then break;
         end;
      end;
   finally
      busy := FALSE;
   end;
   if g_boQueryPrice then begin
      if GetTickCount - g_dwQueryPriceTime > 500 then begin
         g_boQueryPrice := FALSE;
         case FrmDlg.SpotDlgMode of
            dmSell: SendQueryPrice (g_nCurMerchant, g_SellDlgItem.MakeIndex, g_SellDlgItem.S.Name);
            dmRepair: SendQueryRepairCost (g_nCurMerchant, g_SellDlgItem.MakeIndex, g_SellDlgItem.S.Name);
         end;
      end;
   end;
   if FrmDlg <> nil then begin
     if FrmDlg.DBotPlusAbil <> nil then begin
       if g_nBonusPoint > 0 then begin
          FrmDlg.DBotPlusAbil.Visible := TRUE;
       end else begin
          FrmDlg.DBotPlusAbil.Visible := FALSE;
       end;
     end;
   end;
end;
(*//速度作弊检测时钟事件(每秒4次）
//主要是检查系统时钟和CPU之间之间的差别
//若在一秒内连续四次修改系统中间，将可能出现速度作弊嫌疑
procedure TfrmMain.SpeedHackTimerTimer(Sender: TObject);
{var
   gcount, timer: longword;
   ahour, amin, asec, amsec: word;  }
begin
   //DecodeTime (Time, ahour, amin, asec, amsec);
   //timer := ahour * 1000 * 60 * 60 + amin * 1000 * 60 + asec * 1000 + amsec;
   //gcount := GetTickCount;
   {if g_dwSHGetTime > 0 then begin
      if abs((gcount - g_dwSHGetTime) - (timer - g_dwSHTimerTime)) > 70 then begin
         Inc (g_nSHFakeCount);
      end else
         g_nSHFakeCount := 0;
      if g_nSHFakeCount > 4 then begin
         FrmDlg.DMessageDlg ('网络出现不稳定情况，游戏中断\' +
                             '如有问题请咨询游戏的官方网站.',
                             [mbOk]);
         FrmMain.Close;
      end;
      {if g_boCheckSpeedHackDisplay then begin
         DScreen.AddSysMsg ('->' + IntToStr(gcount - g_dwSHGetTime) + ' - ' +
                                   IntToStr(timer - g_dwSHTimerTime) + ' = ' +
                                   IntToStr(abs((gcount - g_dwSHGetTime) - (timer - g_dwSHTimerTime))) + ' (' +
                                   IntToStr(g_nSHFakeCount) + ')');
      end; 
   end; }
  // g_dwSHGetTime := gcount;
  // g_dwSHTimerTime := timer;
end;  *)

(*
20080719注释    
procedure TfrmMain.CheckSpeedHack (rtime: Longword);
var
   cltime, svtime: integer;
   str: string;
begin
   if g_dwFirstServerTime > 0 then begin
      if (GetTickCount - g_dwFirstClientTime) > 1 * 60 * 60 * 1000 then begin  //1矫埃 付促 檬扁拳
         g_dwFirstServerTime := rtime; //檬扁拳
         g_dwFirstClientTime := GetTickCount;
         //ServerTimeGap := rtime - int64(GetTickCount);
      end;
      cltime := GetTickCount - g_dwFirstClientTime;
      svtime := rtime - g_dwFirstServerTime + 3000;

      if cltime > svtime then begin
        { Inc (g_nTimeFakeDetectCount);
         if g_nTimeFakeDetectCount > 6 then begin
            //矫埃炼累...
            str := 'Bad';
            //SendSpeedHackUser;
            FrmDlg.DMessageDlg ('网络速度极差或系统不稳定，游戏中断\' +
                                '如有问题请咨询游戏的官方网站\' ,
                                [mbOk]);
            FrmMain.Close;
         end;    }
      end else begin
         str := 'Good';
         //g_nTimeFakeDetectCount := 0;
      end;
      {if g_boCheckSpeedHackDisplay then begin
         DScreen.AddSysMsg (IntToStr(svtime) + ' - ' +
                            IntToStr(cltime) + ' = ' +
                            IntToStr(svtime-cltime) +
                            ' ' + str);
      end;   }
   end else begin
      g_dwFirstServerTime := rtime;
      g_dwFirstClientTime := GetTickCount;
      //ServerTimeGap := int64(GetTickCount) - longword(msg.Recog);
   end;
end; *)

{********************监听服务端发来的消息 清清 2007.10.21**********************}
procedure TfrmMain.DecodeMessagePacket (datablock: string);
var
   head, body, body2, tagstr, data, str: String;
   msg : TDefaultMessage;
   smsg: TShortMessage;
   mbw: TMessageBodyW;
   desc, CharDesc{英雄}: TCharDesc;
   wl: TMessageBodyWL;
   I, n, param: integer;
   actor: TActor;
   Event: TClEvent;
   str2,str3:string; //接收酒气护体用的变量
   str4,str5: string; //人物,英雄：酒2相关属性接收用的变量
   sLoginKey: string;
   d: TDirectDrawSurface;
   str6: String;//(M2)MESSAGEBOX命令发来的触发参数
begin
   if datablock[1] = '+' then begin  //checkcode
      data := Copy (datablock, 2, Length(datablock)-1);
      data := GetValidStr3 (data, tagstr, ['/']);
      if tagstr = 'PWR'  then g_boNextTimePowerHit := True;  //打开攻杀
      if tagstr = 'LNG'  then g_boCanLongHit := True;        //打开刺杀
      if tagstr = 'ULNG' then g_boCanLongHit := False;       //关闭刺杀
      if tagstr = 'WID'  then g_boCanWideHit := True;        //打开半月
      if tagstr = 'UWID' then g_boCanWideHit := False;       //关闭半月
      if tagstr = 'CRS'  then g_boCanCrsHit := True;    //打开抱月
      if tagstr = 'UCRS' then g_boCanCrsHit := False;   //关闭抱月
      if tagstr = 'CID'  then g_boCanCIDHit := True;   //打开龙影剑法
      if tagstr = 'UCID' then g_boCanCIDHit := False;  //关闭龙影剑法

      if tagstr = 'STN'  then g_boCanStnHit := True;
      if tagstr = 'USTN' then g_boCanStnHit := False;

      if tagstr = 'TWN'  then begin
        g_boCanTwnHit := True;    //打开 重击开天斩
        g_dwLatestTwnHitTick := GetTickCount;
      end;
      if tagstr = 'UTWN' then g_boCanTwnHit := False;   //关闭 重击开天斩

      if tagstr = 'QTWN' then begin  //打开 轻击开天斩    2008.02.12
        g_boCanQTwnHit := True;
        g_dwLatestTwnHitTick := GetTickCount;
      end;
      if tagstr = 'UQTWN' then g_boCanQTwnHit := False;   //关闭 轻击开天斩 2008.02.12



      if tagstr = 'FIR'  then begin
         g_boNextTimeFireHit := TRUE;  //打开烈火
         g_dwLatestFireHitTick := GetTickCount;
      end;
      if tagstr = 'UFIR' then g_boNextTimeFireHit := False; //关闭烈火

      if tagstr = 'DAILY' then begin   //逐日剑法 20080511
         g_boNextItemDAILYHit := True;
         g_dwLatestDAILYHitTick := GetTickCount;
      end;

      if tagstr = 'UDAILY' then g_boNextItemDAILYHit := False;

      if tagstr = '4FIR' then begin
         g_boNextTime4FireHit := TRUE;  //打开4级烈火 20080112
         g_dwLatestFireHitTick := GetTickCount;
      end;
      if tagstr = 'U4FIR' then g_boNextTime4FireHit := FALSE; //关闭4级烈火
      if tagstr = 'GOOD' then begin    //行动命令被接受（走、攻击等）
         ActionLock := FALSE;
         //Inc(g_nReceiveCount);
      end;
      if tagstr = 'FAIL' then begin   //行动失败
         ActionFailed;
         ActionLock := FALSE;
         //Inc(g_nReceiveCount);
      end;
     { if data <> '' then begin
         CheckSpeedHack (Str_ToInt(data, 0));
      end; }
      exit;
   end;
   if Length(datablock) < DEFBLOCKSIZE then begin
      if datablock[1] = '=' then begin
         data := Copy (datablock, 2, Length(datablock)-1);
         if data = 'DIG' then begin   //挖矿效果
            g_MySelf.m_boDigFragment := TRUE;
         end;
      end;
      exit;
   end;

   head := Copy (datablock, 1, DEFBLOCKSIZE);
   body := Copy (datablock, DEFBLOCKSIZE+1, Length(datablock)-DEFBLOCKSIZE);
  // body := Copy (datablock, DEFBLOCKSIZE+7, Length(datablock)-DEFBLOCKSIZE);//20081210 修改释通讯方式
   msg  := DecodeMessage (head);


   {if (msg.Ident <> SM_HEALTHSPELLCHANGED) and
      (msg.Ident <> SM_HEALTHSPELLCHANGED)
      then begin

     if g_boShowMemoLog then begin
       ShowHumanMsg(@Msg);
     end;
   end;}
   if g_MySelf = nil then begin
   
      case msg.Ident of
         SM_GATEPASS_FAIL: begin
           FrmDlg.DMessageDlg ('和网关密码不匹配!!', [mbOk]);
           LoginScene.PassWdFail;
         end;
         SM_SENDLOGINKEY: begin
          if body <> '' then begin
            sLoginKey := DecodeString(body);
            sLoginKey := DecodeString_3des(sLoginKey, CertKey('>侲錵?8V'));
            if sLoginKey <> ParamStr(2) then begin
              FrmDlg.DMessageDlg ('网关和登陆器不配套!!', [mbOk]);
              Close;
            end;
          end;
         end;
         SM_NEWID_SUCCESS:
            begin
               FrmDlg.DMessageDlg ('帐号已创建成功,请保管好您的帐号和密码.\' +
                                   '如有问题请咨询游戏的官方网站.\',
                                   [mbOk]);

            end;
         SM_NEWID_FAIL:
            begin
               case msg.Recog of
                  0: begin
                        FrmDlg.DMessageDlg ('"' + MakeNewId + '"这个帐号已注册.\',
                                            [mbOk]);
                        LoginScene.NewIdRetry (FALSE);
                     end;
                  -2: FrmDlg.DMessageDlg ('此帐号名被禁止使用！', [mbOk]);
                  else FrmDlg.DMessageDlg ('帐号无法创建，请不要用空格及非法字符注册 :  ' + IntToStr(msg.Recog), [mbOk]);
               end;
            end;
         SM_PASSWD_FAIL:
            begin
               case msg.Recog of
                  -1: FrmDlg.DMessageDlg ('密码输入错误。', [mbOk]);
                  -2: FrmDlg.DMessageDlg ('密码输入错误超过3次，此帐号被暂时锁定，请稍候再登录。', [mbOk]);
                  -3: FrmDlg.DMessageDlg ('此帐号已经登录或被异常锁定，请稍候再登录！', [mbOk]);
                  -4: FrmDlg.DMessageDlg ('这个帐号访问失败。', [mbOk]);
                  -5: FrmDlg.DMessageDlg ('这个帐号被锁定。', [mbOk]);
                  else  FrmDlg.DMessageDlg ('帐号不存在，请检查你的帐号。', [mbOk]);
               end;
               LoginScene.PassWdFail;
            end;
         SM_NEEDUPDATE_ACCOUNT:
            begin
               ClientGetNeedUpdateAccount (body);
            end;
         SM_UPDATEID_SUCCESS:
            begin
               FrmDlg.DMessageDlg ('帐号信息更新成功。\', [mbOk]);
               ClientGetSelectServer;
            end;
         SM_UPDATEID_FAIL:
            begin
               FrmDlg.DMessageDlg ('更新帐号失败。', [mbOk]);
               ClientGetSelectServer;
            end;
         SM_PASSOK_SELECTSERVER: begin
           ClientGetPasswordOK(msg,body);
         end;
         SM_SELECTSERVER_OK: begin
           ClientGetPasswdSuccess (body);
         end;
         SM_QUERYCHR: begin
           ClientGetReceiveChrs (body);
         end;
         SM_QUERYDELCHR: begin //返回已删除的角色 20080706
            ClientGetReceiveDelChrs(body,msg.Recog);
         end;
         SM_QUERYDELCHR_FAIL: begin //返回已删除的角色失败 20080706
            FrmDlg.DMessageDlg ('[失败] 没有找到被删除的角色', [mbOk]);
         end;
         SM_RESDELCHR_SUCCESS: begin
            SendQueryChr(0);
         end;
         SM_RESDELCHR_FAIL: begin
            FrmDlg.DMessageDlg ('[失败] 你最多只能为一个帐号设置两个角色。', [mbOk]);
         end;
         SM_NOCANRESDELCHR: begin
            FrmDlg.DMessageDlg ('[失败] 服务器上设置禁止恢复人物。', [mbOk]);
         end;
//============================================================
//获取验证码
        SM_RANDOMCODE: begin//20080612
             if DecodeString (body) <> '' then begin
                g_pwdimgstr := DecodeString (body);
                GetCheckNum();
                if not FrmDlg.DWCheckNum.Visible then begin
                    FrmDlg.DWCheckNum.ShowModal;
                    FrmDlg.DEditCheckNum.SetFocus;
                end;
             end;
        end;
        SM_CHECKNUM_OK: begin
           FrmDlg.DWCheckNum.Visible := False;
           UiDXImageList.Items[35].Picture.Assign(nil);
        end;
         SM_QUERYCHR_FAIL: begin
           if msg.Series = 1 then //验证码 20080612
            FrmDlg.DWCheckNum.Visible := False;
           g_boDoFastFadeOut := FALSE;
           g_boDoFadeIn := FALSE;
           g_boDoFadeOut := FALSE;
           FrmDlg.DMessageDlg ('服务器验证失败。', [mbOk]);
           Close;
         end;

         SM_NEWCHR_SUCCESS: begin
           SendQueryChr(0);
         end;
         SM_NEWCHR_FAIL: begin
           case msg.Recog of
             0: FrmDlg.DMessageDlg ('[错误] 输入的名称包含非法字符！', [mbOk]);
             2: FrmDlg.DMessageDlg ('[错误] 创建的名称服务器已有', [mbOk]);
             3: FrmDlg.DMessageDlg ('[错误] 服务器只能创建两个游戏人物', [mbOk]);
             4: FrmDlg.DMessageDlg ('[错误] 创建游戏人物时出现错误。', [mbOk]);
             else FrmDlg.DMessageDlg ('[错误] 创建游戏人物时出现未知错误', [mbOk]);
           end;
         end;
         SM_CHGPASSWD_SUCCESS: begin
           FrmDlg.DMessageDlg ('密码已修改成功。', [mbOk]);
         end;
         SM_CHGPASSWD_FAIL: begin
           case msg.Recog of
             -1: FrmDlg.DMessageDlg ('输入的原始密码不正确。', [mbOk]);
             -2: FrmDlg.DMessageDlg ('此帐号被服务器锁定。', [mbOk]);
             else FrmDlg.DMessageDlg ('输入的新密码长度小于四位。', [mbOk]);
           end;
         end;
         SM_DELCHR_SUCCESS: begin
           SendQueryChr(0);
         end;
         SM_DELCHR_FAIL: begin
           FrmDlg.DMessageDlg ('[错误] 删除游戏人物时出现错误', [mbOk]);
         end;
         SM_STARTPLAY: begin
           ClientGetStartPlay (body);
           exit;
         end;
         SM_STARTFAIL: begin
           FrmDlg.DMessageDlg ('此服务器满员！', [mbOk]);
           ClientGetSelectServer();
           exit;
         end;
         SM_VERSION_FAIL: begin
           FrmDlg.DMessageDlg ('游戏程序版本不正确，请下载最新版本游戏程序. ('+ decrypt(g_sUnKnowName,CertKey('?-W')) +')', [mbOk]);
           exit;
         end;
         SM_OUTOFCONNECTION,
         SM_NEWMAP,
         SM_LOGON,
         SM_RECONNECT,
         SM_SENDNOTICE: ; 
         else
            Exit; //当人物还没有创建时，只允许上面这些消息。
      end;
   end;
   if g_boMapMoving then begin
      if msg.Ident = SM_CHANGEMAP then begin
         WaitingMsg := msg;
         WaitingStr := DecodeString (body);
         g_boMapMovingWait := TRUE;
         WaitMsgTimer.Enabled := TRUE;
      end;
      Exit;
   end;
//判断消息  清清 2007.10.20
  case msg.Ident of
//============================================================
      SM_OPENEXPCRYSTAL: begin   //Recog参数为1时为关闭、2为开启
        with FrmDlg do begin
          case msg.Recog of
            1: DWExpCrystal.Visible := False;
            2:begin
              //清空经验和内功经验，清空等级、上限
              g_btCrystalLevel:= 1;   //天地结晶等级 20090201
              g_dwCrystalExp:= 0; //天地结晶当前经验 20090201
              g_dwCrystalMaxExp:= 0; //天地结晶升级经验 20090201
              g_dwCrystalNGExp:= 0;//天地结晶当前内功经验 20090201
              g_dwCrystalNGMaxExp:=0;//天地结晶内功升级经验 20090201
              //天地结晶
              d := g_WMainImages.Images[464];
              if d <> nil then begin
                DWExpCrystal.SetImgIndex(g_WMainImages, 464);
                DWExpCrystal.Left := 0;
                DWExpCrystal.Top := 95;
                DCrystalExp.SetImgIndex(g_WMainImages, 484);
                DCrystalNGExp.SetImgIndex(g_WMainImages, 485);
              end;
              DWExpCrystal.Visible := True;
            end;
          end;
        end;
      end;
      SM_SENDCRYSTALNGEXP: begin //接收天地结晶内功经验
        str2 := DecodeString (body);
        if str2 <> '' then begin
          str2 := GetValidStr3(str2, str3,  ['/']);
          str2 := GetValidStr3(str2, tagstr,  ['/']);
          if str3 <> '' then g_dwCrystalNGExp := StrToInt64(Str3);//天地结晶当前内功经验 20090201
          if tagstr <> '' then g_dwCrystalMaxExp := StrToInt64(tagstr);//天地结晶升级经验 20090201
          if str2 <> '' then g_dwCrystalNGMaxExp := StrToInt64(Str2);//天地结晶内功升级经验 20090201
        end;
      end;
      SM_SENDCRYSTALEXP: begin //接收天地结晶经验
        str2 := DecodeString (body);
        if str2 <> '' then begin
          str2 := GetValidStr3(str2, str3,  ['/']);
          str2 := GetValidStr3(str2, tagstr,  ['/']);
          if str3 <> '' then g_dwCrystalExp := StrToInt64(Str3);//天地结晶当前经验 20090201
          if tagstr <> '' then g_dwCrystalMaxExp := StrToInt64(tagstr);//天地结晶升级经验 20090201
          if str2 <> '' then g_dwCrystalNGMaxExp := StrToInt64(Str2);//天地结晶内功升级经验 20090201
        end;
      end;
      SM_SENDCRYSTALLEVEL: begin//接收天地结晶等级
        g_btCrystalLevel := msg.Recog;
        if g_btCrystalLevel <= 5 then begin
          with FrmDlg do begin
            d := g_WMainImages.Images[464+g_btCrystalLevel-1];
            if d <> nil then begin
              DWExpCrystal.SetImgIndex(g_WMainImages, 464+g_btCrystalLevel-1);
              case g_btCrystalLevel-1 of
                0: begin
                  DCrystalExp.SetImgIndex(g_WMainImages, 484);
                  DCrystalNGExp.SetImgIndex(g_WMainImages, 485);
                end;
                1: begin
                  DCrystalExp.SetImgIndex(g_WMainImages, 486);
                  DCrystalNGExp.SetImgIndex(g_WMainImages, 487);
                  DExpCrystalTop.SetImgIndex(g_WMainImages, 468);
                end;
                2: begin
                  DCrystalExp.SetImgIndex(g_WMainImages, 488);
                  DCrystalNGExp.SetImgIndex(g_WMainImages, 489);
                  DExpCrystalTop.SetImgIndex(g_WMainImages, 470);
                end;
                3: begin
                  DCrystalExp.SetImgIndex(g_WMainImages, 490);
                  DCrystalNGExp.SetImgIndex(g_WMainImages, 491);
                  DExpCrystalTop.SetImgIndex(g_WMainImages, 472);
                end;
                4: begin
                  DCrystalExp.SetImgIndex(g_WMainImages, 490);
                  DCrystalNGExp.SetImgIndex(g_WMainImages, 491);
                  DExpCrystalTop.SetImgIndex(g_WMainImages, 474);
                  d := g_WMainImages.Images[464+g_btCrystalLevel-2];
                  if d <> nil then
                    DWExpCrystal.SetImgIndex(g_WMainImages, 464+g_btCrystalLevel-2);
                end;
              end;
            end;
          end;
        end;
      end;
//天地结晶
//============================================================
//感叹号 20090126
      SM_SHOWSIGHICON: begin
        g_sSighIcon := '';
        if body <> '' then begin
          FrmDlg.DSighIcon.Visible := True;
          g_sSighIcon := DecodeString(body);
        end;
      end;
      SM_HIDESIGHICON: begin
        FrmDlg.DSighIcon.Visible := False;
      end;
      SM_UPDATETIME: begin//统一与M2的时间 20090129
        if (msg.Recog > 0) and (Dscreen.m_boCountDown) then begin
          Dscreen.m_dwCountDownTimer := msg.Recog;
          Dscreen.m_dwCountDownTimeTick := GetTickCount;
          Dscreen.m_dwCountDownTimeTick1 := GetTickCount;
        end;
      end;
//============================================================
//内功
      SM_MAGIC69SKILLEXP: begin   //人物的内功
        g_btInternalForceLevel := msg.Series; //内功等级
        if DecodeString (body) <> '' then begin  //内功当前经验/内功升级经验
          str2 := GetValidStr3(DecodeString (body), str3,  ['/']);
          if str3 <> '' then g_dwExp69 := StrToInt64(Str3);
          if str2 <> '' then g_dwMaxExp69 := StrToInt64(Str2);
        end;
        d := g_WMain2Images.Images[740];
        if d <> nil then
          FrmDlg.DStateWin.SetImgIndex (g_WMain2Images, 740); //人物状态  4格图
        g_boIsInternalForce := True;
        FrmDlg.DStateTab.Visible := True;
      end;
      SM_HEROMAGIC69SKILLEXP: begin  //英雄的内功
        g_btHeroInternalForceLevel := msg.Series; //内功等级
        if DecodeString (body) <> '' then begin  //内功当前经验/内功升级经验
          str2 := GetValidStr3(DecodeString (body), str3,  ['/']);
          if str3 <> '' then g_dwHeroExp69 := StrToInt64(Str3);
          if str2 <> '' then g_dwHeroMaxExp69 := StrToInt64(Str2);
        end;
        d := g_WMain2Images.Images[748];
        if d <> nil then
          FrmDlg.DStateHero.SetImgIndex (g_WMain2Images, 748); //人物状态  4格图
        g_boIsHeroInternalForce := True;
        FrmDlg.DHeroStateTab.Visible := True;
      end;
      SM_MAGIC69SKILLNH: begin
        PlayScene.SendMsg (SM_MAGIC69SKILLNH, msg.Recog,
                   msg.Param,
                   msg.Tag,
                   0{darkness},
                   0, 0,
                   '');
      end;
      SM_WINNHEXP: begin
        DScreen.AddBottomSysMsg (IntToStr(LongWord(MakeLong(msg.Param,msg.Tag)))+' 点内功经验增加');
      end;
      SM_HEROWINNHEXP: begin
        DScreen.AddBottomSysMsg ('(英雄)'+IntToStr(LongWord(MakeLong(msg.Param,msg.Tag)))+' 点内功经验增加');
      end;
//============================================================
//可探索
      SM_CANEXPLORATION: begin
        Actor := PlayScene.FindActor (msg.Recog);
        if actor <> nil then begin
          actor.m_sUserName := '(可探索)\'+actor.m_sUserName;
        end;
      end;
//============================================================
//挑战
      SM_CHALLENGE_FAIL: begin 
        g_dwQueryMsgTick := GetTickCount;
        FrmDlg.DMessageDlg ('挑战被取消，你必须和挑战的对象面对面', [mbOk]);
      end;
      SM_CHALLENGEMENU: begin //打开挑战窗口
        g_dwQueryMsgTick := GetTickCount;
        g_sChallengeWho := DecodeString (body);
        FrmDlg.OpenChallengeDlg;
      end;
      SM_CLOSECHALLENGE: begin
        FrmDlg.DWChallenge.Visible := False;
      end;
      SM_CHALLENGECANCEL: begin  //取消挑战
        MoveChallengeItemToBag;
        if g_ChallengeDlgItem.S.Name <> '' then begin
          AddItemBag (g_ChallengeDlgItem);  //啊规俊 眠啊
          g_ChallengeDlgItem.S.Name := '';
        end;
        if g_nDealGold > 0 then begin
          g_MySelf.m_nGold := g_MySelf.m_nGold + g_nChallengeGold;
          g_nChallengeGold := 0;
        end;
        FrmDlg.CloseChallengeDlg;
      end;
      SM_CHALLENGEADDITEM_OK: begin
        g_dwChallengeActionTick := GetTickCount;
        if g_ChallengeDlgItem.S.Name <> '' then begin
           AddChallengeItem (g_ChallengeDlgItem);
           g_ChallengeDlgItem.S.Name := '';
        end;
      end;
      SM_CHALLENGEADDITEM_FAIL: begin
        g_dwChallengeActionTick:=GetTickCount;
        if g_ChallengeDlgItem.S.Name <> '' then begin
          AddItemBag(g_ChallengeDlgItem);  
          g_ChallengeDlgItem.S.Name:= '';
        end;
      end;
      SM_CHALLENGEDELITEM_OK: begin
        g_dwChallengeActionTick := GetTickCount;
        if g_ChallengeDlgItem.S.Name <> '' then begin
          g_ChallengeDlgItem.S.Name := '';
        end;
      end;
      SM_CHALLENGEDELITEM_FAIL: begin
        g_dwChallengeActionTick := GetTickCount;
        if g_ChallengeDlgItem.S.Name <> '' then begin
          DelItemBag (g_ChallengeDlgItem.S.Name, g_ChallengeDlgItem.MakeIndex);
          AddChallengeItem (g_ChallengeDlgItem);
          g_ChallengeDlgItem.S.Name := '';
        end;
      end;
      SM_CHALLENGEREMOTEADDITEM: ClientGetChallengeRemoteAddItem (body);
      SM_CHALLENGEREMOTEDELITEM: ClientGetChallengeRemoteDelItem (body);
      //金币
      SM_CHALLENCHGGOLD_OK: begin
        g_nChallengeGold:=msg.Recog;
        g_MySelf.m_nGold:=MakeLong(msg.param, msg.tag);
        g_dwChallengeActionTick:=GetTickCount;
      end;
      SM_CHALLENCHGGOLD_FAIL: begin
        g_nChallengeGold:=msg.Recog;
        g_MySelf.m_nGold:=MakeLong(msg.param, msg.tag);
        g_dwChallengeActionTick:=GetTickCount;
      end;
      SM_CHALLENREMOTECHGGOLD: begin
        g_nChallengeRemoteGold:=msg.Recog;
        SoundUtil.PlaySound(s_money); 
      end;
      //金刚石
      SM_CHALLENCHGDIAMOND_OK: begin
        g_nChallengeDiamond:=msg.Recog;
        g_MySelf.m_nGameDiaMond:=MakeLong(msg.param, msg.tag);
        g_dwChallengeActionTick:=GetTickCount;
      end;
      SM_CHALLENCHGDIAMOND_FAIL: begin
        g_nChallengeDiamond:=msg.Recog;
        g_MySelf.m_nGameDiaMond:=MakeLong(msg.param, msg.tag);
        g_dwChallengeActionTick:=GetTickCount;
      end;
      SM_CHALLENREMOTECHGDIAMOND: begin
        g_nChallengeRemoteDiamond:=msg.Recog;
        SoundUtil.PlaySound(s_money); 
      end;
//============================================================
//自动寻路
     SM_AUTOGOTOXY: begin
        if g_SearchMap = nil then begin
           g_SearchMap := TQuickSearchMap.Create;
           g_SearchMap.CurrentMap := Map.m_sCurrentMap;
           g_SearchMap.MapBase := Map.m_sMapBase;
           g_SearchMap.UpdateMapPos(0,0);
        end else begin
          if Map.m_sCurrentMap <> g_SearchMap.CurrentMap then begin
           g_SearchMap.CurrentMap := Map.m_sCurrentMap;
           g_SearchMap.MapBase := Map.m_sMapBase;
           g_SearchMap.UpdateMapPos(0,0);
          end;
        end;
        Findpath(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, msg.Param, msg.Tag,True);
        Timer2.Enabled := True;
        if not g_boViewMiniMap then begin   //显示小地图
          if GetTickCount > g_dwQueryMsgTick then begin
             g_dwQueryMsgTick := GetTickCount + 3000;
             FrmMain.SendWantMiniMap;
             g_nViewMinMapLv:=1;
             FrmDlg.DWMiniMap.Left := SCREENWIDTH - 120; //20080323
             FrmDlg.DWMiniMap.Width := 120; //20080323
             FrmDlg.DWMiniMap.Height:= 120; //20080323
          end;
        end;
     end;
//============================================================
//E系统
      SM_Browser: begin
        if body <> '' then begin
          frmBrowser.Open(body);
        end;
      end;
{******************************************************************************}
//酒馆 20080514
      SM_GETHEROINFO: begin //获得仓库英雄
        ClientGetHeroInfo (body);
        FrmDlg.DWiGetHero.Visible := True;
      end;
      SM_SENDUSERPLAYDRINK: begin //请酒
        ClientGetSendUserPlayDrink (msg.Recog);
      end;
      SM_USERPLAYDRINK_OK:
         begin
            FrmDlg.LastestClickTime := GetTickCount;
            FrmDlg.CloseMDlg;//关闭NPC界面
            FrmDlg.DItemBag.Visible := False;
            //FrmDlg.DPlayDrink.Visible := True; //斗酒界面出现
         end;
      SM_USERPLAYDRINK_FAIL:
         begin
            FrmDlg.LastestClickTime := GetTickCount;
            AddItemBag (g_SellDlgItemSellWait);
            g_SellDlgItemSellWait.S.Name := '';
            FrmDlg.DMessageDlg ('你给我的酒在哪呢？', [mbOk]);
         end;
      SM_PLAYDRINKSAY: begin
         ClientGetPlayDrinkSay(msg.Recog,msg.Param, DecodeString(body));
      end;
      SM_OPENPLAYDRINK: begin
         FrmDlg.CloseMDlg;//关闭NPC界面
         g_btShowPlayDrinkFlash := 0; //不显示动画
         if msg.Tag = 1 then begin
            FrmDlg.DPlayDrink.Visible := True;//打开斗酒界面
            FrmDlg.DDrink1.Visible := True;
            FrmDlg.DDrink2.Visible := True;
            FrmDlg.DDrink3.Visible := True;
            FrmDlg.DDrink4.Visible := True;
            FrmDlg.DDrink5.Visible := True;
            FrmDlg.DDrink6.Visible := True;
            FrmDlg.DPlayDrinkFist.Visible := True;
            FrmDlg.DPlayDrinkScissors.Visible := True;
            FrmDlg.DPlayDrinkCloth.Visible := True;
            FrmDlg.DPlayDrinkWhoWin.Visible := False;
            FrmDlg.DPlayDrinkNpcNum.Visible := False;
            FrmDlg.DPlayDrinkPlayNum.Visible := False;
            g_boStopPlayDrinkGame := False;
            g_boPlayDrink := False;
            g_boPermitSelDrink := False;
            g_btDrinkValue[0] := 0;
            g_btDrinkValue[1] := 0;
            g_btTempDrinkValue[0] := 0;
            g_btTempDrinkValue[1] := 0;
            g_btWhoWin := 3; //20080614
            FrmDlg.DPlayFist.Visible := False;
            g_btPlayDrinkGameNum := 4;
            //---以下跟NPC随机选酒有关
            g_NpcRandomDrinkList.Clear;
            for I:=0 to 5 do g_NpcRandomDrinkList.Add(Pointer(I));//得到顺序排列的酒
            //---
         end;
         if msg.Tag = 2 then begin
            FrmDlg.DWPleaseDrink.Visible := True; //打开请酒界面
            FrmDlg.DWPleaseDrink.Left := 0;
            FrmDlg.DWPleaseDrink.Top  := 0;
            FrmDlg.DItemBag.Left := 425;
            FrmDlg.DItemBag.Top  := 20;
            FrmDlg.DItemBag.Visible := True;
         end;

         g_btNpcIcon := msg.Series;
         g_nShowPlayDrinkFlashImg := 0;
         g_sNpcName := '';
         if Body <> '' then g_sNpcName := Body;
      end;
      SM_PlayDrinkToDrink: begin //引擎发来猜拳码 谁输谁赢
         g_btPlayNum := msg.Recog; //玩家的码
         g_btNpcNum  := msg.Tag;   //NPC的码
         g_btWhoWin := msg.Series; //0-赢  1-输  2-平
         if g_btWhoWin = 2 then g_boPermitSelDrink := False;
         if g_btWhoWin = 0 then g_boHumWinDrink := False; //20080614 玩家赢，是否喝了酒
         g_nImgLeft := 0;
         g_nPlayDrinkDelay := 0;
         g_boPlayDrink := True;
         FrmDlg.ShowPlayDrinkImg(True);
      end;
      SM_DrinkUpdateValue: begin
         if g_btWhoWin = 0 then g_boHumWinDrink := True; //20080614 玩家赢，是否喝了酒
         if msg.Param = 1 then begin  //参数0-可以继续喝 1-斗酒结束
           g_boStopPlayDrinkGame := True;
         end;
         g_btTempDrinkValue[0] := msg.Tag;
         g_btTempDrinkValue[1] := msg.Series;
         if msg.Recog = 0 then //玩家喝酒
          g_btShowPlayDrinkFlash := 2
         else g_btShowPlayDrinkFlash := 1;
         g_nShowPlayDrinkFlashImg := 0;
         g_boPermitSelDrink := False;
      end;
      SM_CLOSEDRINK: begin
         FrmDlg.DPlayDrink.Visible := False;
         FrmDlg.DWPleaseDrink.Visible := False;
      end;
      SM_USERPLAYDRINKITEM_OK: begin
         FillChar (g_PDrinkItem, sizeof(TClientItem)*2, #0);
         g_btShowPlayDrinkFlash := 1;
      end;
      SM_USERPLAYDRINKITEM_FAIL: begin
         AddItemBag (g_PDrinkItem[0]);
         AddItemBag (g_PDrinkItem[1]);
      end;
//酒馆2卷
      SM_OPENMAKEWINE: begin
        if (msg.Param in [0,1]) and (body <> '') then begin
          g_MakeTypeWine := msg.Param;
          g_sNpcName := body;
          if g_MakeTypeWine = 0 then begin //普通酒
            with FrmDlg do begin
              DMakeWineHelp.Hint := '如何酿酒';
              DMaterialMemo.Hint := '材料说明';
            end;
          end else begin  //药酒
            with FrmDlg do begin
              DMakeWineHelp.Hint := '如何配置';
              DMaterialMemo.Hint := '药效说明';
            end;
          end;
          with FrmDlg do begin
            DMakeWineHelp.ShowHint := False;
            DMaterialMemo.ShowHint := False;
            ShowMakeWine(True);
            DWMakeWineDesk.Left := 380;
            DWMakeWineDesk.Top  := 50;
            DWMakeWineDesk.Visible := True;
            CloseMDlg;//关闭NPC界面
            DItemBag.Left := 20;
            DItemBag.Top  := 34;
            DItemBag.Visible := True;
          end;
        end;
      end;
      SM_MAKEWINE_OK: begin //酿酒成功
        if (msg.Param in [0,1]) then begin
          if msg.Param = 1 then //药酒
            FillChar (g_DrugWineItem, sizeof(TClientItem)*3, #0)
          else  //普通酒
            FillChar (g_WineItem, sizeof(TClientItem)*7, #0);
          FrmDlg.DWMakeWineDesk.Visible := False;
          FrmDlg.DItemBag.Visible := False;
        end;
      end;
      SM_MAKEWINE_FAIL: begin//酿酒失败
        if (msg.Param in [0,1]) then begin
          if msg.Param = 1 then begin//药酒
            for I:=Low(g_DrugWineItem) to High(g_DrugWineItem) do begin
              if g_DrugWineItem[I].s.Name <> '' then begin  //药酒
                AddItemBag(g_DrugWineItem[I]);
                g_DrugWineItem[I].s.Name := '';
              end;
            end;
          end else begin  //普通酒
            for I:=Low(g_WineItem) to High(g_WineItem) do begin
              if g_WineItem[I].s.Name <> '' then begin
                AddItemBag(g_WineItem[I]);
                g_WineItem[I].s.Name := '';
              end;
            end;
          end;
          FrmDlg.DWMakeWineDesk.Visible := False;
          FrmDlg.DItemBag.Visible := False;
        end;
      end;
      SM_MAGIC68SKILLEXP: begin
        if DecodeString (body) <> '' then begin
          str2 := GetValidStr3(DecodeString (body), str3,  ['/']);
          if str3 <> '' then g_dwExp68 := StrToInt64(Str3);
          if str2 <> '' then g_dwMaxExp68 := StrToInt64(Str2);
        end;
      end;
      SM_HEROMAGIC68SKILLEXP: begin //英雄酒气护体接收经验
        if DecodeString (body) <> '' then begin
          str2 := GetValidStr3(DecodeString (body), str3,  ['/']);
          if str3 <> '' then g_dwHeroExp68 := StrToInt64(Str3);
          if str2 <> '' then g_dwHeroMaxExp68 := StrToInt64(Str2);
        end;
      end;
      SM_PLAYMAKEWINEABILITY: begin //人物酒2相关属性 20080804
        str4 := '';
        if msg.Recog >= 0 then
          g_MySelf.m_Abil.Alcohol := msg.Recog;
        g_MySelf.m_Abil.MaxAlcohol := msg.Param;
        g_MySelf.m_Abil.WineDrinkValue := msg.Tag;
        g_MySelf.m_Abil.MedicineValue := msg.Series;
        str4 := DecodeString (body);
        if str4 <> '' then begin
          if StrToInt(str4) >= 0 then begin
            g_MySelf.m_Abil.MaxMedicineValue := StrToInt(str4);
          end;
        end;
      end;
      SM_HEROMAKEWINEABILITY: begin //英雄酒2相关属性 20080804
        str5 := '';
        if msg.Recog >= 0 then
          g_HeroSelf.m_Abil.Alcohol := msg.Recog;
        g_HeroSelf.m_Abil.MaxAlcohol := msg.Param;
        g_HeroSelf.m_Abil.WineDrinkValue := msg.Tag;
        g_HeroSelf.m_Abil.MedicineValue := msg.Series;
        str5 := DecodeString (body);
        if str5 <> '' then begin     
          if StrToInt(str5) >= 0 then begin
            g_HeroSelf.m_Abil.MaxMedicineValue := StrToInt(str5);
          end;
        end;
      end;
{******************************************************************************}
      SM_GLORY: begin  //荣誉
        g_btGameGlory := Max(0,msg.Recog);
      end;
{******************************************************************************}
//粹练
      SM_QUERYREFINEITEM: begin//NPC打开粹练窗口 20080506
        if not FrmDlg.DItemsUp.Visible then begin
           FrmDlg.DItemsUp.Visible := True;
        end;
      end;
      SM_UPDATERYREFINEITEM: begin //更新淬炼物品 20080507
         ClientGetUpDateUpItem (body);
      end;
      SM_REPAIRFINEITEM_OK:begin //修补火云石成功  20080507
         g_boItemMoving := false;
         g_MovingItem.Item.S.Name := '';
         g_WaitingUseItem.Item.s.Name := '';
      end;
      SM_REPAIRFINEITEM_FAIL:begin //修补火云石失败  20080507
        AddItemBag (g_WaitingUseItem.Item);
        g_WaitingUseItem.Item.S.Name := '';
      end;
{******************************************************************************}

      SM_SELLOFFBUY_OK: begin  //寄售买方收购成功 20080318
        ArrangeItembag;   //整理包裹
        FrmDlg.DWSellOffList.Visible := False; //列表信息栏不可见
        FillChar (g_SellOffInfo, sizeof(TClientDealOffInfo), #0); //清空寄售列表物品 20080318
      end;
      SM_SELLOFFEND_OK: begin   //寄售成功
        FrmDlg.DWSellOff.Visible := False;
        FillChar (g_SellOffItems, sizeof(TClientItem)*9, #0); //释放寄售窗口物品 20080318
      end;
      SM_SELLOFFEND_FAIL: begin
        MoveSellOffItemToBag;
        if g_SellOffDlgItem.S.Name <> '' then begin
          AddItemBag (g_SellOffDlgItem);
          g_SellOffDlgItem.S.Name := '';
        end;
        FillChar (g_SellOffItems, sizeof(TClientItem)*9, #0); //释放寄售窗口物品 20080318
        g_SellOffName := '';
        g_SellOffGameGold := 0;
        g_SellOffGameDiaMond := 0;
      end;
      SM_QUERYYBSELL: begin  //查询元宝寄售正在出售的物品  20080317
        ClientGetSellOffSellItem (body);
      end;
      SM_QUERYYBDEAL: begin  //查询元宝寄售可以购买的物品 20080317
        ClientGetSellOffMyItem (body);
      end;
      SM_SENDDEALOFFFORM: begin //打开寄售出售物品窗口 20080316
        ClientGetSendUserSellOff(msg.Recog);
      end;
      SM_SELLOFFADDITEM_OK: begin //往出元宝寄售售物品窗口里加物品 成功 20080316
        if g_SellOffDlgItem.S.Name <> '' then begin
           AddSellOffItem (g_SellOffDlgItem);
           g_SellOffDlgItem.S.Name := '';
        end;
      end;
      SM_SellOffADDITEM_FAIL: begin  //往元宝寄售出售物品窗口里加物品 失败  20080316
        if g_SellOffDlgItem.S.Name <> '' then begin
          AddItemBag(g_SellOffDlgItem);
          g_SellOffDlgItem.S.Name:= '';
        end;
      end;
      SM_SELLOFFDELITEM_OK: begin    //寄售物品返回包裹成功
        //g_dwDealActionTick:=GetTickCount;
        if g_SellOffDlgItem.S.Name <> '' then begin
          g_SellOffDlgItem.S.Name := '';
        end;
      end;
      SM_SELLOFFDELITEM_FAIL: begin  //寄售物品返回包裹失败
        //g_dwDealActionTick := GetTickCount;
        if g_SellOffDlgItem.S.Name <> '' then begin
          DelItemBag (g_SellOffDlgItem.S.Name, g_SellOffDlgItem.MakeIndex);
          AddSellOffItem (g_SellOffDlgItem);
          g_SellOffDlgItem.S.Name := '';
        end;
      end;
      SM_SellOffCANCEL: begin   //取消寄售窗口
        MoveSellOffItemToBag;
        if g_SellOffDlgItem.S.Name <> '' then begin
          AddItemBag (g_SellOffDlgItem);
          g_SellOffDlgItem.S.Name := '';
        end;
      end;
      SM_CHANGEATTATCKMODE: begin  //改变攻击模式
        g_sAttackMode := DecodeString (body);
      end;
      SM_OPENBOOKS: begin //打开卧龙
      g_nCurMerchant := msg.Recog;
         if msg.Param = 0 then begin
            g_LieDragonPage := 0; //初始化 卧龙笔记页数
            FrmDlg.DLieDragonPrevPage.Visible := False;
            FrmDlg.DLieDragonNextPage.Visible := True;
            FrmDlg.DGoToLieDragon.Visible := False;
            FrmDlg.DLieDragon.Visible := True;
         end;
         if msg.Param in [1..5] then begin
            g_LieDragonNpcIndex := msg.Param;
            FrmDlg.DLieDragonNpc.Visible := True;
         end;
      end;
      SM_OPENBOXS: begin    //接收宝箱物品
        ClientGetMyBoxsItem (body);
      end;
      SM_OPENBOXS_FAIL: begin //返回打开宝箱失败  20080306
       g_boPutBoxsKey := False;  //20080616
       FrmDlg.DBoxs.Visible := False;
       FrmDlg.ShowBoxsGird(False); //显示宝箱格
       g_nBoxsImg := 0; //20080616
       g_BoxsShowPosition := -1;
       AddItemBag(g_BoxsTempKeyItems); //返回包裹 钥匙
       AddItemBag(g_EatingItem); //返回包裹 宝箱
       g_EatingItem.s.Name := '';
      end;
      SM_OPENDRAGONBOXS: begin //卧龙开宝箱 20080306
        FrmDlg.DBoxs.Visible := True;  //宝箱显示界面
        FrmDlg.DBoxs.SetImgIndex(g_WMain3Images, 510);
        FrmDlg.DBoxsTautology.Visible := True;  //点击多次转动按钮显示
        g_BoxsCircleNum := 0;  //初始化转动圈数
        g_boBoxsMiddleItems := True; //初始化物品为中间
        g_BoxsShowPosition := 8;
        g_BoxsFirstMove := False; //初始化第1次转动
        g_BoxsMoveDegree := 0;  //初始化 转盘次数
        FrmDlg.ShowBoxsGird(True); //显示宝箱格
        FrmDlg.BoxsRandomImg;
      end;
      SM_MOVEBOXS: begin
        g_BoxsMakeIndex := msg.Recog;
        g_BoxsGold := msg.Param;
        g_BoxsGameGold := msg.tag;
      end;
      SM_SENGSHOPITEMS: begin      //打开商铺的界面
        g_ShopReturnPage := msg.Param;
        ClientGetMyShop (body);
      end;
      SM_BUYSHOPITEM_SUCCESS: begin
        if body <> '' then
        FrmDlg.DMessageDlg (DeCodeString(body), [mbOk]);
      end;
      SM_BUYSHOPITEMGIVE_SUCCESS: begin
        if body <> '' then
        FrmDlg.DMessageDlg (DeCodeString(body), [mbOk]);
      end;
      SM_BUYSHOPITEMGIVE_FAIL: begin
        if body <> '' then
        FrmDlg.DMessageDlg (DeCodeString(body), [mbOk]);
      end;
      SM_EXCHANGEGAMEGIRD_SUCCESS: begin //兑换灵符成功 20080302
        if body <> '' then
        FrmDlg.DMessageDlg (DeCodeString(body), [mbOk]);
      end;
      SM_EXCHANGEGAMEGIRD_FAIL: begin //兑换灵符失败 20080302
        if body <> '' then
        FrmDlg.DMessageDlg (DeCodeString(body), [mbOk]);
      end;
      SM_BUYSHOPITEM_FAIL: begin
        if body <> '' then
        FrmDlg.DMessageDlg (DeCodeString(body), [mbOk]);
      end;
      SM_SENGSHOPSPECIALLYITEMS: begin
        ClientGetMyShopSpecially (body);   //奇珍类型
      end;
      //20080102
      SM_REPAIRDRAGON_OK:begin //祝福罐.魔令包功能
          g_WaitingUseItem.Item.s.Name := '';
      end;
      SM_REPAIRDRAGON_FAIL:begin //祝福罐.魔令包功能
        AddItemBag (g_WaitingUseItem.Item);
        g_WaitingUseItem.Item.s.Name := '';
      end;
      
      SM_MYSHOW: begin    //msg.Param 为 类型
          Actor := PlayScene.FindActor (msg.Recog);
          if Actor <> nil then begin
            ShowMyShow(actor, msg.Param);
          end;
      end;
//-----------------------------------------------------------
      SM_QUERYUSERLEVELSORT: begin  //排行榜
        nLevelOrderSortType := msg.Recog;
        nLevelOrderType := msg.Tag;
        nLevelOrderTypePageCount := msg.Series;
        if msg.Param = 65535 then //如果点我的排行 那么 page是65535
        nLevelOrderPage := 0
        else nLevelOrderPage := msg.Param;

        if body <> '' then
        ClientGetUserOrder (body);
      end;
      SM_RECALLHERO: begin    //召唤英雄资料，是私有的  别人不可以
          PlayScene.SendMsg (SM_RECALLHERO, msg.Recog,
                             msg.Param{x},
                             msg.tag{y},
                             msg.Series{dir},
                             CharDesc.feature, //desc.Feature,
                             CharDesc.Status, //desc.Status,
                             '');
        FrmDlg.CallHero.ShowHint := False;
        if g_HeroSelf <> nil then begin
          FrmDlg.DHeroIcon.Visible:=TRUE;
          //g_dwFirstServerTime := 0;
          //g_dwFirstClientTime := 0;
          SendClientMessage (CM_QUERYHEROBAGITEMS, 0, 0, 0, 0);
          if g_boHeroAutoDEfence then SendHeroAutoOpenDefence(1);
        end;
      end;
      SM_CREATEHERO: begin  //创建英雄到客户端、 是共有  别人可以看得到  比如 召唤动画
          with msg do begin
          DecodeBuffer (body, @CharDesc, sizeof(TCharDesc));
          PlayScene.SendMsg (SM_CREATEHERO, msg.Recog,
                             msg.Param{x},
                             msg.tag{y},
                             msg.Series{dir},
                             CharDesc.feature, //desc.Feature,
                             CharDesc.Status, //desc.Status,
                             '');
        end;


          Actor := PlayScene.FindActor (msg.Recog);
          if Actor <> nil then begin
        //召唤动画  清清 2007.11.10
            if msg.Recog>0 then
              ShowHeroLoginOrLogOut(Actor);
              MyPlaySound (HeroLogin_ground);
          end;

          //g_boServerChanging := FALSE;

    end;
    
      SM_DESTROYHERO: begin
        Actor := PlayScene.FindActor (msg.Recog);
        if (Actor <> nil) and (Actor = g_HeroSelf) then begin
          PlayScene.DeleteActor(msg.Recog);
          g_HeroSelf           :=nil;
          if g_HeroSelf = nil then begin
            with FrmDlg do begin
              DHeroIcon.Visible    := FALSE;
              DStateHero.Visible   := FALSE;
              DHeroItemBag.Visible := FALSE;
              DHeroSpleen.Visible  := FALSE;
              FrmDlg.CallHero.ShowHint := True;
              //内功--------------------------------
              g_btHeroInternalForceLevel := 0;
              HeroStateTab := 0;
              g_dwHeroExp69 := 0;
              g_dwHeroMaxExp69 := 0;
              g_boIsHeroInternalForce := FALSE;
              FrmDlg.DHeroStateTab.Visible := FALSE; 
            end;
            FrmDlg.DHeroIcon.Visible:=False;
            FrmDlg.HeroStatePage := 0;
            FillChar (g_HeroItems, sizeof(TClientItem)*14, #0);
            FillChar (g_HeroItemArr, sizeof(TClientItem)*MAXBAGITEMCL, #0);

            //清空英雄魔法
            if g_HeroMagicList.Count > 0 then //20080629
            for i:=0 to g_HeroMagicList.Count-1 do
            Dispose (PTClientMagic (g_HeroMagicList[i]));
            g_HeroMagicList.Clear;
          end;
        end;
      end;

      SM_HERODEATH: begin  //英雄死亡
        with FrmDlg do begin
          DHeroIcon.Visible    := FALSE;
          DStateHero.Visible   := FALSE;
          DHeroItemBag.Visible := FALSE;
          DHeroSpleen.Visible  := FALSE;
          g_HeroSelf           :=nil;
          FrmDlg.CallHero.ShowHint := True;
          //MyPlaySound (HeroHeroLogout_ground);
          if g_HeroSelf = nil then begin
            FrmDlg.DHeroIcon.Visible:=False;
          end;
        end;
      end;
      SM_REPAIRFIRDRAGON_OK:begin //20071231 修补火龙之心成功
         g_boHeroItemMoving := false;
         g_MovingHeroItem.Item.S.Name := '';
      end;
      SM_REPAIRFIRDRAGON_FAIL:begin //20071231 修补火龙之心失败
        AddHeroItemBag (g_MovingHeroItem.Item);
        g_MovingHeroItem.Item.S.Name := '';
      end;

      SM_QUERYHEROBAGCOUNT: begin     //从M2返回英雄包裹总数   清清 2007.11.5
        g_HeroBagCount:=msg.Recog;
      end;
      SM_GOTETHERUSESPELL: begin  //从M2反回来的英雄合击  清清 2007.11.1
        Actor := PlayScene.FindActor (msg.Recog);
        FrmMain.ShowMyShow(Actor,4);
      end;
      {SM_DRAGONPOINT: begin //龙影怒气值   20080619
        nMaxDragonPoint := msg.Param;
        m_nDragonPoint  :=msg.Recog;
        FrmDlg.DCIDSpleen.Visible:=True;
      end;}
      {SM_CLOSEDRAGONPOINT: begin
        FrmDlg.DCIDSpleen.Visible := False;
      end;  }
      SM_FIRDRAGONPOINT: begin     //英雄怒气值
        nMaxFirDragonPoint:= msg.Param;
        m_nFirDragonPoint:=msg.Recog;
        if (g_HeroItems[U_BUJUK].s.Shape=9) and (g_HeroItems[U_BUJUK].s.StdMode=25) then
          FrmDlg.DHeroSpleen.Visible := True
        else FrmDlg.DHeroSpleen.Visible := False;
      end;
      SM_HEROBAGITEMS: begin      //接收英雄包裹物品
        if g_boHeroItemMoving then FrmDlg.CancelHeroItemMoving;
        ClientHeroGetBagItmes (body);
      end;
      SM_HEROSENDMYMAGIC: begin               //20071025  清清$002
       ClientGetHeroMagics(body);
      end;
      SM_SENDHEROUSEITEMS: begin //接收英雄身上装备   清清$002
        ClientGetSendHeroItems (body);
      end;
      SM_HEROABILITY://接收 英雄属性1   清清$012
        begin
        g_HeroSelf.m_btSex:=msg.Recog;
        g_HeroSelf.m_btJob := msg.Tag;
        g_HeroSelf.m_nLoyal := msg.Series;
        DecodeBuffer (body, @g_HeroSelf.m_Abil, sizeof(TAbility));;
      end;
      SM_HEROSUBABILITY: begin  //接收 英雄属性2   清清$013
        g_nHeroHitPoint      := Lobyte(Msg.Param);
        g_nHeroSpeedPoint    := Hibyte(Msg.Param);
        g_nHeroAntiPoison    := Lobyte(Msg.Tag);
        g_nHeroPoisonRecover := Hibyte(Msg.Tag);
        g_nHeroHealthRecover := Lobyte(Msg.Series);
        g_nHeroSpellRecover  := Hibyte(Msg.Series);
        g_nHeroAntiMagic     := LoByte(LongWord(Msg.Recog));
      end;
      SM_SENDITEMTOHEROBAG_OK: begin    //返回从主人包裹到英雄包裹成功 清清 2007.10.24
            //if g_WaitingHeroUseItem.Index in [0..12] then
            AddHeroItemBag (g_WaitingHeroUseItem.Item);
            g_WaitingHeroUseItem.Item.S.Name := '';
      end;
      SM_SENDITEMTOHEROBAG_FAIL: begin  //返回从主人包裹到英雄包裹失败 清清 2007.10.24
            AddItemBag (g_WaitingHeroUseItem.Item);
            g_WaitingHeroUseItem.Item.S.Name := '';
      end;
      SM_SENDITEMTOMASTERBAG_OK: begin  //返回从英雄包裹到主人包裹成功 清清 2007.10.24
            //if g_WaitingUseItem.Index in [0..12] then
            AddItemBag (g_WaitingUseItem.Item);
            g_WaitingUseItem.Item.S.Name := '';
      end;
      SM_SENDITEMTOMASTERBAG_FAIL: begin //返回英雄从包裹到装备失败  清清 2007.10.24
           AddHeroItemBag (g_WaitingHeroUseItem.Item);
           g_WaitingHeroUseItem.Item.S.Name := '';
      end;
      SM_HEROTAKEON_OK: begin    //返回英雄从包裹到装备成功  清清 2007.10.24
            g_HeroSelf.m_nFeature := msg.Recog;
            g_HeroSelf.FeatureChanged;
            if g_WaitingHeroUseItem.Index in [0..13] then
               g_HeroItems[g_WaitingHeroUseItem.Index] := g_WaitingHeroUseItem.Item;
            g_WaitingHeroUseItem.Item.S.Name := '';
            {g_HeroItemArr[g_nRightTempIdx].S.Name := ''; //20080229 解决英雄右键穿装备消失问题
            g_MovingHeroItem.Item.s.Name := '';   //20080229 解决英雄右键穿装备消失问题
            g_boHeroRightItem := FALSE;{右键穿戴装备}
      end;
      SM_HEROTAKEON_FAIL: begin  //返回英雄从包裹到装备失败  清清 2007.10.24
            AddHeroItemBag (g_WaitingHeroUseItem.Item);
            g_WaitingHeroUseItem.Item.S.Name := '';
            {g_boHeroRightItem := FALSE;{右键穿戴装备}
      end;
      SM_HEROTAKEOFF_OK: begin   //返回英雄从装备到包裹成功  清清 2007.10.24
            g_HeroSelf.m_nFeature := msg.Recog;
            g_HeroSelf.FeatureChanged;
            g_WaitingHeroUseItem.Item.S.Name := '';
      end;
      SM_HEROTAKEOFF_FAIL: begin  //返回英雄从装备到包裹失败  清清 2007.10.24
            if g_WaitingHeroUseItem.Index < 0 then begin
               n := -(g_WaitingHeroUseItem.Index+1);
               g_HeroItems[n] := g_WaitingHeroUseItem.Item;
            end;
            g_WaitingHeroUseItem.Item.S.Name := '';
      end;
      SM_HEROEAT_OK: begin    //主人双击英雄包裹吃东西成功   清清 2007.10.24
            g_HeroEatingItem.S.Name := '';
            ArrangeHeroItembag;
      end;
      SM_HEROEAT_FAIL: begin //主人双击英雄包裹吃东西失败   清清 2007.10.24
            AddHeroItemBag (g_HeroEatingItem);
            g_HeroEatingItem.S.Name := '';
      end;
      SM_HEROWINEXP: begin //英雄经验
          if g_HeroSelf <> nil then begin
            g_HeroSelf.m_Abil.Exp := msg.Recog;
            if g_boExpFiltrate then begin
              if LongWord(MakeLong(msg.Param,msg.Tag)) > 2000 then
                DScreen.AddChatBoardString (IntToStr(LongWord(MakeLong(msg.Param,msg.Tag))) + ' 英雄经验值增加.',clWhite, clRed);
            end else begin
              DScreen.AddChatBoardString (IntToStr(LongWord(MakeLong(msg.Param,msg.Tag))) + ' 英雄经验值增加.',clWhite, clRed);
            end;
          end;
      end;
      SM_HEROLEVELUP: begin
            g_HeroSelf.m_Abil.Level:=msg.Param;
            DScreen.AddSysMsg ('英雄升级!');
      end;
      SM_HEROUPDATEITEM: begin//更新英雄包裹
        ClientGetHeroUpdateItem (body);
      end;
      SM_HEROADDITEM: begin   //英雄加物品到包裹里
        ClientGetHeroAddItem (body);
      end;
      SM_HERODROPITEM_SUCCESS: begin //英雄成功的把物品扔在地上了
        DelDropItem (DecodeString(body), msg.Recog);
      end;
      SM_HERODROPITEM_FAIL: begin    //英雄没把物品扔在地上没成功
        ClientGetHeroDropItemFail (DecodeString(body), msg.Recog);
      end;
      SM_HEROADDMAGIC: begin
        if body <> '' then ClientGetHeroAddMagic (body);
      end;
      SM_HERODELMAGIC:begin
        ClientGetHeroDelMagic (msg.Recog);
      end;
      SM_HEROWEIGHTCHANGED: begin
        if g_HeroSelf <> nil then begin
          g_HeroSelf.m_Abil.Weight := msg.Recog;
          g_HeroSelf.m_Abil.WearWeight := msg.Param;
          g_HeroSelf.m_Abil.HandWeight := msg.Tag;
        end;
      end;
      SM_HEROMAGIC_LVEXP: begin
        ClientGetHeroMagicLvExp (msg.Recog{magid}, msg.Param{lv}, MakeLong(msg.Tag, msg.Series));
      end;
      SM_HERODURACHANGE: begin  //英雄持久改变
        ClientGetHeroDuraChange (msg.Param{useitem index}, msg.Recog, MakeLong(msg.Tag, msg.Series));
      end;
      SM_EXPTIMEITEMS: begin //聚灵珠时间改变 20080307
        ClientGetExpTimeItemChange (msg.Recog{物品MakeIndex},msg.Tag );
      end;
      SM_HERODELITEMS: begin
        if body <> '' then ClientGetHeroDelItems (body);
      end;
      SM_HERODELITEM: begin
        ClientGetHeroDelItem (body);
      end;
    SM_VERSION_FAIL: begin
//      i := MakeLong(msg.Param,msg.Tag);
   //   DecodeBuffer (body, @j, sizeof(Integer));
      {--------------------客户端版本错误2007.10.16清清--------------------------}
     (* if (msg.Recog <> g_nThisCRC) and
         (i <> g_nThisCRC) and
         (j <> g_nThisCRC) then begin

        FrmDlg.DMessageDlg ('版本错误.请下载最新的版本.', [mbOk]);
        DScreen.AddChatBoardString ('版本错误.建议下载最新的版本.', clYellow, clRed);
        CSocket.Close;
//        FrmMain.Close;
//        frmSelMain.Close;
        exit;
        {FrmDlg.DMessageDlg ('Wrong version. Please download latest version. (http://www.legendofmir.net)', [mbOk]);
        Close;
        exit;}
      end; *)
    end;
      SM_NEWMAP: begin
        g_sMapTitle := '';
        str := DecodeString (body); //mapname
        PlayScene.SendMsg (SM_NEWMAP, 0,
                           msg.Param{x},
                           msg.tag{y},
                           msg.Series{darkness},
                           0, 0,
                           str{mapname});
      end;


      SM_LOGON: begin
        //g_dwFirstServerTime := 0;
        //g_dwFirstClientTime := 0;
        with msg do begin
          DecodeBuffer (body, @wl, sizeof(TMessageBodyWL));
          PlayScene.SendMsg (SM_LOGON, msg.Recog,
                             msg.Param{x},
                             msg.tag{y},
                             msg.Series{dir},
                             wl.lParam1, //desc.Feature,
                             wl.lParam2, //desc.Status,
                             '');
          DScreen.ChangeScene (stPlayGame);
          SendClientMessage (CM_QUERYBAGITEMS, 0, 0, 0, 0);
          if Lobyte(Loword(wl.lTag1)) = 1 then g_boAllowGroup := TRUE
          else g_boAllowGroup := FALSE;
          g_boServerChanging := FALSE;
        end;
        if g_wAvailIDDay > 0 then begin
          DScreen.AddChatBoardString ('您当前通过包月帐号充值.', clGreen, clWhite)
        end else if g_wAvailIPDay > 0 then begin
          DScreen.AddChatBoardString ('您当前通过包月IP 充值.', clGreen, clWhite)
        end else if g_wAvailIPHour > 0 then begin
          DScreen.AddChatBoardString ('您当前通过计时IP 充值.', clGreen, clWhite)
        end else if g_wAvailIDHour > 0 then begin
          DScreen.AddChatBoardString ('您当前通过计时帐号充值.', clGreen, clWhite)
        end;
         LoadFriendList();
         LoadHeiMingDanList();
         FrmDlg.DDrunkScale.Visible := True; //20080623 
        //LoadUserConfig(CharName);
        //DScreen.AddChatBoardString ('当前服务器信息: ' + g_sRunServerAddr + ':' + IntToStr(g_nRunServerPort), clGreen, clWhite)
      end;
      SM_SERVERCONFIG: ClientGetServerConfig(Msg,Body);

      SM_SERVERUNBIND: ClientGetServerUnBind(Body); //解包消息

      SM_RECONNECT: begin
        ClientGetReconnect (body);
      end;
      {SM_TIMECHECK_MSG:
         begin
            CheckSpeedHack (msg.Recog);
         end;   }

      SM_AREASTATE:
         begin
            g_nAreaStateValue := msg.Recog;
         end;

      SM_MAPDESCRIPTION: begin
        ClientGetMapDescription(Msg,body);
      end;
      SM_GAMEGOLDNAME: begin
        ClientGetGameGoldName(msg,body);
      end;
      SM_ADJUST_BONUS: begin
        ClientGetAdjustBonus (msg.Recog, body);
      end;
      SM_MYSTATUS: begin
        g_nMyHungryState:=msg.Param;
      end;

      SM_TURN:
         begin
            if Length(body) > GetCodeMsgSize(sizeof(TCharDesc)*4/3) then begin
               Body2 := Copy (Body, GetCodeMsgSize(sizeof(TCharDesc)*4/3)+1, Length(body));
               data := DecodeString (body2); //某腐 捞抚
               str := GetValidStr3 (data, data, ['/']);
               //data = 捞抚
               //str = 祸哎
            end else data := '';
            DecodeBuffer (body, @desc, sizeof(TCharDesc));
            PlayScene.SendMsg (SM_TURN, msg.Recog,
                                 msg.Param{x},
                                 msg.tag{y},
                                 msg.Series{dir + light},
                                 desc.Feature,
                                 desc.Status,
                                 ''); //捞抚
            if data <> '' then begin
               actor := PlayScene.FindActor (msg.Recog);
               if actor <> nil then begin
                  actor.m_sDescUserName := GetValidStr3(data, actor.m_sUserName, ['\']);
                  actor.m_nNameColor := GetRGB(Str_ToInt(str, 0));
                  actor.m_btMiniMapHeroColor := Str_ToInt(str, 0);
               end;
            end;
         end;

      SM_BACKSTEP:
         begin
            if Length(body) > GetCodeMsgSize(sizeof(TCharDesc)*4/3) then begin
               Body2 := Copy (Body, GetCodeMsgSize(sizeof(TCharDesc)*4/3)+1, Length(body));
               data := DecodeString (body2); //某腐 捞抚
               str := GetValidStr3 (data, data, ['/']);
               //data = 捞抚
               //str = 祸哎
            end else data := '';
            DecodeBuffer (body, @desc, sizeof(TCharDesc));
            PlayScene.SendMsg (SM_BACKSTEP, msg.Recog,
                                 msg.Param{x},
                                 msg.tag{y},
                                 msg.Series{dir + light},
                                 desc.Feature,
                                 desc.Status,
                                 ''); //捞抚
            if data <> '' then begin
               actor := PlayScene.FindActor (msg.Recog);
               if actor <> nil then begin
                  actor.m_sDescUserName := GetValidStr3(data, actor.m_sUserName, ['\']);
                  actor.m_nNameColor := GetRGB(Str_ToInt(str, 0));
                  actor.m_btMiniMapHeroColor := Str_ToInt(str, 0);
               end;
            end;
         end;

      SM_SPACEMOVE_HIDE,
      SM_SPACEMOVE_HIDE2:
         begin
            if msg.Recog <> g_MySelf.m_nRecogId then begin
               PlayScene.SendMsg (msg.Ident, msg.Recog, msg.Param{x}, msg.tag{y}, 0, 0, 0, '')
            end;
         end;

      SM_SPACEMOVE_SHOW,
      SM_SPACEMOVE_SHOW2:
         begin
            if Length(body) > GetCodeMsgSize(sizeof(TCharDesc)*4/3) then begin
               Body2 := Copy (Body, GetCodeMsgSize(sizeof(TCharDesc)*4/3)+1, Length(body));
               data := DecodeString (body2); //某腐 捞抚
               str := GetValidStr3 (data, data, ['/']);
            end else data := '';
            DecodeBuffer (body, @desc, sizeof(TCharDesc));
            if msg.Recog <> g_MySelf.m_nRecogId then begin //促弗 某腐磐牢 版快
              PlayScene.NewActor (msg.Recog, msg.Param, msg.tag, msg.Series, desc.feature, desc.Status);
            end;
            PlayScene.SendMsg (msg.Ident, msg.Recog,
                                 msg.Param{x},
                                 msg.tag{y},
                                 msg.Series{dir + light},
                                 desc.Feature,
                                 desc.Status,
                                 ''); //捞抚
            if data <> '' then begin
               actor := PlayScene.FindActor (msg.Recog);
               if actor <> nil then begin
                  actor.m_sDescUserName := GetValidStr3(data, actor.m_sUserName, ['\']);
                  actor.m_nNameColor := GetRGB(Str_ToInt(str, 0));
                  actor.m_btMiniMapHeroColor := Str_ToInt(str, 0);
               end;
            end;
         end;

      SM_NPCWALK, SM_WALK, SM_RUSH, SM_RUSHKUNG:
         begin
            DecodeBuffer (body, @desc, sizeof(TCharDesc));
            if (msg.Recog <> g_MySelf.m_nRecogId) or (msg.Ident = SM_RUSH) or (msg.Ident = SM_RUSHKUNG) then begin
               PlayScene.SendMsg (msg.Ident, msg.Recog,
                                 msg.Param{x},
                                 msg.tag{y},
                                 msg.Series{dir+light},
                                 desc.Feature,
                                 desc.Status, '');
            end;
            if msg.Ident = SM_RUSH then
               g_dwLatestRushRushTick := GetTickCount;                      
         end;

      SM_RUN{,SM_HORSERUN 20080803注释骑马消息}:
         begin
            DecodeBuffer (body, @desc, sizeof(TCharDesc));
            if msg.Recog <> g_MySelf.m_nRecogId then
               PlayScene.SendMsg (msg.Ident, msg.Recog,
                                    msg.Param{x},
                                    msg.tag{y},
                                    msg.Series{dir+light},
                                    desc.Feature,
                                    desc.Status, '');
         end;

      SM_CHANGELIGHT://游戏亮度
         begin
            actor := PlayScene.FindActor (msg.Recog);
            if actor <> nil then begin
               actor.m_nChrLight := msg.Param;
            end;
         end;

      SM_LAMPCHANGEDURA:
         begin
            if g_UseItems[U_RIGHTHAND].S.Name <> '' then begin
               g_UseItems[U_RIGHTHAND].Dura := msg.Recog;
            end;
         end;

      SM_MOVEFAIL: begin
        ActionFailed;
        DecodeBuffer (body, @desc, sizeof(TCharDesc));
        PlayScene.SendMsg (SM_TURN, msg.Recog,
                                 msg.Param{x},
                                 msg.tag{y},
                                 msg.Series{dir},
                                 desc.Feature,
                                 desc.Status, '');
      end;
      SM_BUTCH:
         begin
            DecodeBuffer (body, @desc, sizeof(TCharDesc));
            if msg.Recog <> g_MySelf.m_nRecogId then begin
               actor := PlayScene.FindActor (msg.Recog);
               if actor <> nil then
                  actor.SendMsg (SM_SITDOWN,
                                    msg.Param{x},
                                    msg.tag{y},
                                    msg.Series{dir},
                                    0, 0, '', 0);
            end;
         end;
      SM_SITDOWN:
         begin
            DecodeBuffer (body, @desc, sizeof(TCharDesc));
            if msg.Recog <> g_MySelf.m_nRecogId then begin
               actor := PlayScene.FindActor (msg.Recog);
               if actor <> nil then
                  actor.SendMsg (SM_SITDOWN,
                                    msg.Param{x},
                                    msg.tag{y},
                                    msg.Series{dir},
                                    0, 0, '', 0);
            end;
         end;

      SM_HIT,           //14
      SM_HEAVYHIT,      //15
      SM_POWERHIT,      //18
      SM_LONGHIT,       //19
      SM_WIDEHIT,       //24
      SM_BIGHIT,        //16
      SM_FIREHIT,{烈火}       //8
      SM_4FIREHIT,{4级烈火}
      SM_DAILY, //逐日剑法 20080511
      SM_CRSHIT,
      SM_CIDHIT, {龙影剑法}
      SM_TWINHIT, {开天斩重击}
      SM_QTWINHIT {开天斩轻击 20080212}:
         begin
            if msg.Recog <> g_MySelf.m_nRecogId then begin
               actor := PlayScene.FindActor (msg.Recog);
               if actor <> nil then begin
                  actor.SendMsg (msg.Ident,
                                    msg.Param{x},
                                    msg.tag{y},
                                    msg.Series{dir},
                                    0, 0, '',
                                    0);
                  if msg.ident = SM_HEAVYHIT then begin
                     if body <> '' then
                        actor.m_boDigFragment := TRUE;
                  end;
               end;
            end;
         end;
      SM_LEITINGHIT:
         begin
           actor := PlayScene.FindActor (msg.Recog);
           if actor <> nil then begin
              actor.SendMsg (msg.Ident,
                                msg.Param{x},
                                msg.tag{y},
                                msg.Series{dir},
                                0, 0, '',
                                0);
              if msg.ident = SM_HEAVYHIT then begin
                 if body <> '' then
                    actor.m_boDigFragment := TRUE;
              end;
           end;
         end;
      SM_PIXINGHIT: //20080611劈星
         begin
               actor := PlayScene.FindActor (msg.Recog);
               if actor <> nil then begin
                  actor.SendMsg (SM_HIT,
                                    msg.Param{x},
                                    msg.tag{y},
                                    msg.Series{dir},
                                    0, 0, '',
                                    0);
                  if msg.ident = SM_HEAVYHIT then begin
                     if body <> '' then
                        actor.m_boDigFragment := TRUE;
                  end;
            end;
         end;
      SM_FLYAXE:
         begin
            DecodeBuffer (body, @mbw, sizeof(TMessageBodyW));
            actor := PlayScene.FindActor (msg.Recog);
            if actor <> nil then begin
               actor.SendMsg (msg.Ident,
                                 msg.Param{x},
                                 msg.tag{y},
                                 msg.Series{dir},
                                 0, 0, '',
                                 0);
               actor.m_nTargetX := mbw.Param1;  //x 带瘤绰 格钎
               actor.m_nTargetY := mbw.Param2;    //y
               actor.m_nTargetRecog := MakeLong(mbw.Tag1, mbw.Tag2);
            end;
         end;
      SM_FAIRYATTACKRATE,//月灵重击 2007.12.14
      SM_LIGHTING:
         begin
            DecodeBuffer (body, @wl, sizeof(TMessageBodyWL));
            actor := PlayScene.FindActor (msg.Recog);
            if actor <> nil then begin
               actor.SendMsg (msg.Ident,
                                 msg.Param{x},
                                 msg.tag{y},
                                 msg.Series{dir},
                                 0, 0, '',
                                 0);
               actor.m_nTargetX := wl.lParam1;  //x 带瘤绰 格钎
               actor.m_nTargetY := wl.lParam2;    //y
               actor.m_nTargetRecog := wl.lTag1;
               actor.m_nMagicNum := wl.lTag2;   //付过 锅龋
            end;
         end;

      SM_SPELL: begin
        UseMagicSpell (msg.Recog{who}, msg.Series{effectnum}, msg.Param{tx}, msg.Tag{y}, Str_ToInt(body,0));
      end;
      SM_MAGICFIRE: begin
        DecodeBuffer (body, @param, sizeof(integer));
        UseMagicFire (msg.Recog{who}, Lobyte(msg.Series){efftype}, Hibyte(msg.Series){effnum}, msg.Param{tx}, msg.Tag{y}, param);
      end;
      SM_MAGICFIRE_FAIL:
         begin
            UseMagicFireFail (msg.Recog{who});
         end;


      SM_OUTOFCONNECTION:
         begin
            g_boDoFastFadeOut := FALSE;
            g_boDoFadeIn := FALSE;
            g_boDoFadeOut := FALSE;
            FrmDlg.DMessageDlg ('服务器连接被强行中断。\连接时间可能超过限制。', [mbOk]);
            Close;
         end;

      SM_DEATH,
      SM_NOWDEATH:
         begin
            DecodeBuffer (body, @desc, sizeof(TCharDesc));
            actor := PlayScene.FindActor (msg.Recog);
            if actor <> nil then begin
               actor.SendMsg (msg.Ident,
                              msg.param{x}, msg.Tag{y}, msg.Series{damage},
                              desc.Feature, desc.Status, '',
                              0);
               actor.m_Abil.HP := 0;
            end else begin
               PlayScene.SendMsg (SM_DEATH, msg.Recog, msg.param{x}, msg.Tag{y}, msg.Series{damage}, desc.Feature, desc.Status, '');
            end;
         end;
      SM_SKELETON:
         begin
            DecodeBuffer (body, @desc, sizeof(TCharDesc));
            PlayScene.SendMsg (SM_SKELETON, msg.Recog, msg.param{HP}, msg.Tag{maxHP}, msg.Series{damage}, desc.Feature, desc.Status, '');
         end;
      SM_ALIVE:
         begin
            DecodeBuffer (body, @desc, sizeof(TCharDesc));
            PlayScene.SendMsg (SM_ALIVE, msg.Recog, msg.param{HP}, msg.Tag{maxHP}, msg.Series{damage}, desc.Feature, desc.Status, '');
         end;

      SM_ABILITY:
         begin
            g_MySelf.m_nGold := msg.Recog;
            g_MySelf.m_btJob := msg.Param;
            g_MySelf.m_nGameGold:=MakeLong(msg.Tag,msg.Series);
            DecodeBuffer (body, @g_MySelf.m_Abil, sizeof(TAbility));
         end;

      SM_SUBABILITY: begin
        g_nMyHitPoint      := Lobyte(Msg.Param);
        g_nMySpeedPoint    := Hibyte(Msg.Param);
        g_nMyAntiPoison    := Lobyte(Msg.Tag);
        g_nMyPoisonRecover := Hibyte(Msg.Tag);
        g_nMyHealthRecover := Lobyte(Msg.Series);
        g_nMySpellRecover  := Hibyte(Msg.Series);
        g_nMyAntiMagic     := LoByte(LongWord(Msg.Recog));
      end;

      SM_DAYCHANGING:
         begin
            g_nDayBright := msg.Param;
            { 20080816注释显示黑暗
            DarkLevel := msg.Tag;
            if DarkLevel = 0 then g_boViewFog := FALSE
            else g_boViewFog := TRUE;   }
         end;

      SM_WINEXP:
         begin
            g_MySelf.m_Abil.Exp := msg.Recog; //坷弗 版氰摹
            if g_boExpFiltrate then begin
              if LongWord(MakeLong(msg.Param,msg.Tag)) > 2000 then
                DScreen.AddChatBoardString (IntToStr(LongWord(MakeLong(msg.Param,msg.Tag))) + ' 经验值增加.',clWhite, clRed);
            end else begin
              DScreen.AddChatBoardString (IntToStr(LongWord(MakeLong(msg.Param,msg.Tag))) + ' 经验值增加.',clWhite, clRed);
            end;
         end;

      SM_LEVELUP:
         begin
            g_MySelf.m_Abil.Level:=msg.Param;
            DScreen.AddSysMsg ('升级!');
         end;

      SM_HEALTHSPELLCHANGED: begin
        Actor := PlayScene.FindActor (msg.Recog);
        if Actor <> nil then begin
          Actor.m_Abil.HP    := msg.Param;
          Actor.m_Abil.MP    := msg.Tag;
          Actor.m_Abil.MaxHP := msg.Series;
        end;
      end;
      SM_STRUCK:
         begin
            case msg.Ident of
              SM_STRUCK: begin
              //wl: TMessageBodyWL;
                  DecodeBuffer (body, @wl, sizeof(TMessageBodyWL));
                  Actor := PlayScene.FindActor (msg.Recog);
                  if Actor <> nil then begin
                     if Actor = g_MySelf then begin
                        if g_MySelf.m_nNameColor = 249 then //红名
                           g_dwLatestStruckTick := GetTickCount;
                     end else begin
                        if Actor.CanCancelAction then
                           Actor.CancelAction;
                     end;
                     //稳如泰山
                    if Actor <> g_MySelf then
                     Actor.UpdateMsg (SM_STRUCK, wl.lTag2, 0,
                                 msg.Series{damage}, wl.lParam1, wl.lParam2,
                                 '', wl.lTag1{锭赴仇酒捞叼});
                     Actor.m_Abil.HP := msg.param;
                     Actor.m_Abil.MaxHP := msg.Tag;
                  end;
                end;
          end; //case 
         end;

      SM_CHANGEFACE:
         begin
            actor := PlayScene.FindActor (msg.Recog);
            if actor <> nil then begin
               DecodeBuffer (body, @desc, sizeof(TCharDesc));
               actor.m_nWaitForRecogId := MakeLong(msg.Param, msg.Tag);
               actor.m_nWaitForFeature := desc.Feature;
               actor.m_nWaitForStatus := desc.Status;
               AddChangeFace (actor.m_nWaitForRecogId);
            end;
         end;
      SM_PASSWORD: SetInputStatus();
      SM_OPENHEALTH:
         begin
            actor := PlayScene.FindActor (msg.Recog);
            if actor <> nil then begin
               if actor <> g_MySelf then begin
                  actor.m_Abil.HP := msg.Param;
                  actor.m_Abil.MaxHP := msg.Tag;
               end;
               actor.m_boOpenHealth := TRUE;
               //actor.OpenHealthTime := 999999999;
               //actor.OpenHealthStart := GetTickCount;
            end;
         end;
      SM_CLOSEHEALTH:
         begin
            actor := PlayScene.FindActor (msg.Recog);
            if actor <> nil then begin
               actor.m_boOpenHealth := FALSE;
            end;
         end;
      SM_INSTANCEHEALGUAGE:
         begin
            actor := PlayScene.FindActor (msg.Recog);
            if actor <> nil then begin
               actor.m_Abil.HP := msg.param;
               actor.m_Abil.MaxHP := msg.Tag;
               actor.m_noInstanceOpenHealth := TRUE;
               actor.m_dwOpenHealthTime := 2 * 1000;
               actor.m_dwOpenHealthStart := GetTickCount;
            end;
         end;

      SM_BREAKWEAPON: //武器破碎
         begin
            actor := PlayScene.FindActor (msg.Recog);
            if actor <> nil then begin
               if actor is THumActor then
                  THumActor(actor).DoWeaponBreakEffect;
            end;
         end;

      SM_CRY,         //喊话消息
      SM_GROUPMESSAGE,//组队消息
      SM_GUILDMESSAGE,//行会消息
      SM_WHISPER,     //私聊消息
      SM_MOVEMESSAGE, //滚动消息
      SM_SYSMESSAGE:  //系统消息
         begin
            str := DecodeString (body);
            actor := PlayScene.FindActor (msg.Recog);
            if not InHeiMingDanListOfName(actor.m_sUserName) then begin
              if msg.Ident = SM_MOVEMESSAGE then begin
                 case msg.Series of
                  0: Dscreen.AddSysBoard(str,Lobyte(Msg.Param),Hibyte(msg.Param), 50); //滚动公告
                  1: Dscreen.AddCenterLetter(Lobyte(Msg.Param),Hibyte(msg.Param),msg.Tag,str); //居中显示
                  2: Dscreen.AddCountDown(Lobyte(Msg.Param),msg.Tag,str); //聊天栏上面倒记时
                 end;
              end else
              DScreen.AddChatBoardString (str, GetRGB(Lobyte(msg.Param)), GetRGB(Hibyte(msg.Param)));
              if msg.Ident = SM_GUILDMESSAGE then FrmDlg.AddGuildChat (str);
            end;
         end;

      SM_HEAR:
         begin
            str := DecodeString (body);
            actor := PlayScene.FindActor (msg.Recog);
            if actor <> nil then begin
               if not InHeiMingDanListOfName(actor.m_sUserName) then 
               actor.Say (str);
            end;
            if not g_boOwnerMsg then  //拒绝公聊 2008.02.11
              if actor <> nil then begin
                if not InHeiMingDanListOfName(actor.m_sUserName) then
                  DScreen.AddChatBoardString (str, GetRGB(Lobyte(msg.Param)), GetRGB(Hibyte(msg.Param)));
              end else begin
                  DScreen.AddChatBoardString (str, GetRGB(Lobyte(msg.Param)), GetRGB(Hibyte(msg.Param)));
              end;

         end;

      SM_USERNAME:
         begin
            str := DecodeString (body);
            actor := PlayScene.FindActor (msg.Recog);
            if actor <> nil then begin
               actor.m_sDescUserName := GetValidStr3(str, actor.m_sUserName, ['\']);
               actor.m_nNameColor := GetRGB (msg.Param);
               actor.m_btMiniMapHeroColor := msg.Param;
               {if msg.Tag = 1 then actor.m_boCityMember := True//精英团 20080330
               else if msg.Tag = 2 then actor.m_boCityMaster := True;//城主 20080330   }
            end;
         end;
      SM_CHANGENAMECOLOR:
         begin
            actor := PlayScene.FindActor (msg.Recog);
            if actor <> nil then begin
               actor.m_nNameColor := GetRGB (msg.Param);
               actor.m_btMiniMapHeroColor := msg.Param;
            end;
         end;

      SM_HIDE,
      SM_GHOST,  //儡惑..
      SM_DISAPPEAR:
         begin
            if g_MySelf.m_nRecogId <> msg.Recog then
               PlayScene.SendMsg (SM_HIDE, msg.Recog, msg.Param{x}, msg.tag{y}, 0, 0, 0, '');
         end;

      SM_DIGUP:
         begin
            DecodeBuffer (body, @wl, sizeof(TMessageBodyWL));
            actor := PlayScene.FindActor (msg.Recog);
            if actor = nil then
               actor := PlayScene.NewActor (msg.Recog, msg.Param, msg.tag, msg.Series, wl.lParam1, wl.lParam2);
            actor.m_nCurrentEvent := wl.lTag1;
            actor.SendMsg (SM_DIGUP,
                           msg.Param{x},
                           msg.tag{y},
                           msg.Series{dir + light},
                           wl.lParam1,
                           wl.lParam2, '', 0);
         end;
      SM_DIGDOWN:
         begin
            PlayScene.SendMsg (SM_DIGDOWN, msg.Recog, msg.Param{x}, msg.tag{y}, 0, 0, 0, '');
         end;
      SM_SHOWEVENT:
         begin
            DecodeBuffer (body, @smsg, sizeof(TShortMessage));
            event := TClEvent.Create (msg.Recog, Loword(msg.Tag){x}, msg.Series{y}, msg.Param{e-type});
            event.m_nDir := 0;
            event.m_nEventParam := smsg.Ident;
            EventMan.AddEvent (event);
            case msg.Param of
              ET_FIREFLOWER_1,ET_FIREFLOWER_2,ET_FIREFLOWER_3,ET_FIREFLOWER_4,ET_FIREFLOWER_5,ET_FIREFLOWER_6,ET_FIREFLOWER_7,ET_FIREFLOWER_8 : MyPlaySound(Protechny_ground); //烟花声音
              SM_HEROLOGOUT: MyPlaySound (HeroHeroLogout_ground);
              ET_FOUNTAIN: MyPlaySound (spring_ground);
              ET_DIEEVENT: MyPlaySound(powerup_ground); //人形庄主死亡动画
            end;
         end;
      SM_HIDEEVENT:
         begin
            EventMan.DelEventById (msg.Recog);
         end;

      //Item ??
      SM_ADDITEM:
         begin
            ClientGetAddItem (body);
         end;
      SM_BAGITEMS:
         begin
           if g_boItemMoving then FrmDlg.CancelItemMoving;
            ClientGetBagItmes (body);
         end;
      SM_UPDATEITEM:
         begin
            ClientGetUpdateItem (body);
         end;
      SM_DELITEM:
         begin
            ClientGetDelItem (body);
         end;
      SM_DELITEMS:
         begin
            ClientGetDelItems (body);
         end;

      SM_DROPITEM_SUCCESS:
         begin
            DelDropItem (DecodeString(body), msg.Recog);
         end;
      SM_DROPITEM_FAIL:
         begin
            ClientGetDropItemFail (DecodeString(body), msg.Recog);
         end;

      SM_ITEMSHOW       :ClientGetShowItem (msg.Recog, msg.param{x}, msg.Tag{y}, msg.Series{looks}, DecodeString(body));
      SM_ITEMHIDE       :ClientGetHideItem (msg.Recog, msg.param, msg.Tag);
      SM_OPENDOOR_OK    :Map.OpenDoor (msg.param, msg.tag);
      SM_OPENDOOR_LOCK  :DScreen.AddSysMsg ('此门被锁定.');
      SM_CLOSEDOOR      :Map.CloseDoor (msg.param, msg.tag);

      SM_TAKEON_OK:
         begin
            g_MySelf.m_nFeature := msg.Recog;
            g_MySelf.FeatureChanged;
            if g_WaitingUseItem.Index in [0..13] then
               g_UseItems[g_WaitingUseItem.Index] := g_WaitingUseItem.Item;
            g_WaitingUseItem.Item.S.Name := '';
         end;
      SM_TAKEON_FAIL:
         begin
            AddItemBag (g_WaitingUseItem.Item);
            g_WaitingUseItem.Item.S.Name := '';
            {g_boRightItem := FALSE;{右键穿戴装备}
         end;
      SM_TAKEOFF_OK:
         begin
            g_MySelf.m_nFeature := msg.Recog;
            g_MySelf.FeatureChanged;
            g_WaitingUseItem.Item.S.Name := '';
         end;
      SM_TAKEOFF_FAIL:
         begin
            if g_WaitingUseItem.Index < 0 then begin
               n := -(g_WaitingUseItem.Index+1);
               g_UseItems[n] := g_WaitingUseItem.Item;
            end;
            g_WaitingUseItem.Item.S.Name := '';
         end;
      SM_SENDUSEITEMS:
         begin
            ClientGetSenduseItems (body);
         end;
      SM_WEIGHTCHANGED:
         begin
            g_MySelf.m_Abil.Weight := msg.Recog;
            g_MySelf.m_Abil.WearWeight := msg.Param;
            g_MySelf.m_Abil.HandWeight := msg.Tag;
         end;
      SM_GOLDCHANGED: //金币改变
         begin
            SoundUtil.PlaySound (s_money); //钱的声音
            if msg.Recog > g_MySelf.m_nGold then begin
              DScreen.AddSysMsg (IntToStr(msg.Recog-g_MySelf.m_nGold) +' '+ g_sGoldName{'金币。'}+'增加.');
            end;
            g_MySelf.m_nGold := msg.Recog;
            g_MySelf.m_nGameGold:=MakeLong(msg.Param,msg.Tag);
         end;
      SM_FEATURECHANGED: begin
        PlayScene.SendMsg (msg.Ident, msg.Recog, 0, 0, 0, MakeLong(msg.Param, msg.Tag), MakeLong(msg.Series,0), '');
      end;
      SM_CHARSTATUSCHANGED: begin

        PlayScene.SendMsg (msg.Ident, msg.Recog, 0, 0, 0, MakeLong(msg.Param, msg.Tag), msg.Series, '');
        //PlayScene.SendMsg (msg.Ident, msg.Recog, 0, 0, 0, MakeLong(msg.Param, msg.Tag), msg.Series, DecodeString(Body));
      end;
      SM_CLEAROBJECTS:
         begin
            PlayScene.CleanObjects;
            g_boMapMoving := TRUE; //
         end;

      SM_EAT_OK:
         begin
            g_EatingItem.S.Name := '';

            //自动放药 闪的效果
            if (g_TempIdx <> 200) and (g_TempItemArr.s.Name <> '') then begin
                g_ItemArr[g_TempIdx] := g_TempItemArr;
                g_TempItemArr.s.Name := '';
                g_TempIdx := 200;
            end;
            ArrangeItembag;
         end;
      SM_EAT_FAIL:
         begin
            AddItemBag (g_EatingItem);
            g_EatingItem.S.Name := '';
         end;

      SM_ADDMAGIC:
         begin
            if body <> '' then
               ClientGetAddMagic (body);
         end;
      SM_SENDMYMAGIC: if body <> '' then ClientGetMyMagics (body);
      SM_DELMAGIC:
         begin
            ClientGetDelMagic (msg.Recog);
         end;
      SM_MAGIC_LVEXP:
         begin
            ClientGetMagicLvExp (msg.Recog{magid}, msg.Param{lv}, MakeLong(msg.Tag, msg.Series));
         end;
      SM_DURACHANGE:
         begin
            ClientGetDuraChange (msg.Param{useitem index}, msg.Recog, MakeLong(msg.Tag, msg.Series));
            if DecodeString(body) <> '' then begin
              if StrToInt(DecodeString(body)) > 0 then g_nBeadWinExp := StrToInt(DecodeString(body));
            end;
         end;

      SM_MERCHANTSAY:
         begin
            ClientGetMerchantSay (msg.Recog, msg.Param, DecodeString (body));
         end;
      SM_MERCHANTDLGCLOSE:
         begin
            FrmDlg.CloseMDlg;
         end;
      SM_SENDGOODSLIST:
         begin
            ClientGetSendGoodsList (msg.Recog, msg.Param, body);
         end;
      SM_SENDUSERMAKEDRUGITEMLIST:
         begin
            ClientGetSendMakeDrugList (msg.Recog, body);
         end;
      SM_SENDUSERSELL:
         begin
            ClientGetSendUserSell (msg.Recog);
         end;
      SM_SENDUSERREPAIR:
         begin
            ClientGetSendUserRepair (msg.Recog);
         end;
      SM_SENDBUYPRICE:
         begin
            if g_SellDlgItem.S.Name <> '' then begin
               if msg.Recog > 0 then
                  g_sSellPriceStr := IntToStr(msg.Recog) + ' ' + g_sGoldName{金币'}
               else g_sSellPriceStr := '???? ' + g_sGoldName{金币'};
            end;
         end;
      SM_USERSELLITEM_OK:
         begin
            FrmDlg.LastestClickTime := GetTickCount;
            g_MySelf.m_nGold := msg.Recog;
            g_SellDlgItemSellWait.S.Name := '';
         end;

      SM_USERSELLITEM_FAIL:
         begin
            FrmDlg.LastestClickTime := GetTickCount;
            AddItemBag (g_SellDlgItemSellWait);
            g_SellDlgItemSellWait.S.Name := '';
            FrmDlg.DMessageDlg ('您不能出售此物品.', [mbOk]);
         end;

      SM_SENDREPAIRCOST:
         begin
            if g_SellDlgItem.S.Name <> '' then begin
               if msg.Recog >= 0 then
                  g_sSellPriceStr := IntToStr(msg.Recog) + ' ' + g_sGoldName{金币}
               else g_sSellPriceStr := '???? ' + g_sGoldName{金币};
            end;
         end;
      SM_USERREPAIRITEM_OK:
         begin
            if g_SellDlgItemSellWait.S.Name <> '' then begin
               FrmDlg.LastestClickTime := GetTickCount;
               g_MySelf.m_nGold := msg.Recog;
               g_SellDlgItemSellWait.Dura := msg.Param;
               g_SellDlgItemSellWait.DuraMax := msg.Tag;
               AddItemBag (g_SellDlgItemSellWait);
               g_SellDlgItemSellWait.S.Name := '';
            end;
         end;
      SM_USERREPAIRITEM_FAIL:
         begin
            FrmDlg.LastestClickTime := GetTickCount;
            AddItemBag (g_SellDlgItemSellWait);
            g_SellDlgItemSellWait.S.Name := '';
            FrmDlg.DMessageDlg ('您不能修理此物品.', [mbOk]);
         end;
      SM_STORAGE_OK,
      SM_STORAGE_FULL,
      SM_STORAGE_FAIL:
         begin
            FrmDlg.LastestClickTime := GetTickCount;
            if msg.Ident <> SM_STORAGE_OK then begin
               if msg.Ident = SM_STORAGE_FULL then
                  FrmDlg.DMessageDlg ('您的仓库已经满了，不能再保管任何东西了.', [mbOk])
               else
                  FrmDlg.DMessageDlg ('您不能寄存物品.', [mbOk]);
               AddItemBag (g_SellDlgItemSellWait);
            end;
            g_SellDlgItemSellWait.S.Name := '';
         end;
      SM_SAVEITEMLIST:
         begin
            ClientGetSaveItemList (msg.Recog, body);
         end;
      SM_TAKEBACKSTORAGEITEM_OK,
      SM_TAKEBACKSTORAGEITEM_FAIL,
      SM_TAKEBACKSTORAGEITEM_FULLBAG:
         begin
            FrmDlg.LastestClickTime := GetTickCount;
            if msg.Ident <> SM_TAKEBACKSTORAGEITEM_OK then begin
               if msg.Ident = SM_TAKEBACKSTORAGEITEM_FULLBAG then
                  FrmDlg.DMessageDlg ('您无法携带更多物品了.', [mbOk])
               else
                  FrmDlg.DMessageDlg ('您无法取回物品.', [mbOk]);
            end else
               FrmDlg.DelStorageItem (msg.Recog); //itemserverindex
         end;

      SM_BUYITEM_SUCCESS:
         begin
            FrmDlg.LastestClickTime := GetTickCount;
            g_MySelf.m_nGold := msg.Recog;
            FrmDlg.SoldOutGoods (MakeLong(msg.Param, msg.Tag)); //迫赴 酒捞袍 皋春俊辑 画
         end;
      SM_BUYITEM_FAIL:
         begin
            FrmDlg.LastestClickTime := GetTickCount;
            case msg.Recog of
               1: FrmDlg.DMessageDlg ('此物品被卖出.', [mbOk]);
               2: FrmDlg.DMessageDlg ('您无法携带更多物品了.', [mbOk]);
               3: FrmDlg.DMessageDlg ('您没有足够的钱来购买此物品.', [mbOk]);
            end;
         end;
      SM_MAKEDRUG_SUCCESS:
         begin
            FrmDlg.LastestClickTime := GetTickCount;
            g_MySelf.m_nGold := msg.Recog;
            FrmDlg.DMessageDlg ('您要的物品已经搞好了', [mbOk]);
         end;
      SM_MAKEDRUG_FAIL: begin
        FrmDlg.LastestClickTime := GetTickCount;
        case msg.Recog of
          1: FrmDlg.DMessageDlg ('物品不存在.', [mbOk]);
          2: FrmDlg.DMessageDlg ('您无法携带更多物品了.', [mbOk]);
          3: FrmDlg.DMessageDlg (g_sGoldName{'金币'} + '不足.', [mbOk]);
          4: FrmDlg.DMessageDlg ('你缺乏所必需的物品。', [mbOk]);
        end;
      end;
      SM_716: begin
        DrawEffectHum(Msg.Series{type},Msg.Param{x},Msg.Tag{y});
      end;
      SM_SENDDETAILGOODSLIST: begin
        ClientGetSendDetailGoodsList (msg.Recog, msg.Param, msg.Tag, body);
      end;

      SM_SENDNOTICE: begin
        ClientGetSendNotice (body);
      end;
      SM_GROUPMODECHANGED: //辑滚俊辑 唱狼 弊缝 汲沥捞 函版登菌澜.
         begin
            if msg.Param > 0 then g_boAllowGroup := TRUE
            else g_boAllowGroup := FALSE;
            g_dwChangeGroupModeTick := GetTickCount;
         end;
      SM_CREATEGROUP_OK:
         begin
            g_dwChangeGroupModeTick := GetTickCount;
            g_boAllowGroup := TRUE;
            {GroupMembers.Add (Myself.UserName);
            GroupMembers.Add (DecodeString(body));}
         end;
      SM_CREATEGROUP_FAIL:
         begin
            g_dwChangeGroupModeTick := GetTickCount;
            case msg.Recog of
               -1: FrmDlg.DMessageDlg ('编组还未成立.', [mbOk]);
               -2: FrmDlg.DMessageDlg ('输入的人物名称不正确.', [mbOk]);
               -3: FrmDlg.DMessageDlg ('您想邀请加入编组的人已经加入了其它组.', [mbOk]);
               -4: FrmDlg.DMessageDlg ('对方不允许编组.', [mbOk]);
            end;
         end;
      SM_GROUPADDMEM_OK:
         begin
            g_dwChangeGroupModeTick := GetTickCount;
            //GroupMembers.Add (DecodeString(body));
         end;
      SM_GROUPADDMEM_FAIL:
         begin
            g_dwChangeGroupModeTick := GetTickCount;
            case msg.Recog of
               -1: FrmDlg.DMessageDlg ('编组还未成立.', [mbOk]);
               -2: FrmDlg.DMessageDlg ('输入的人物名称不正确.', [mbOk]);
               -3: FrmDlg.DMessageDlg ('已经加入编组.', [mbOk]);
               -4: FrmDlg.DMessageDlg ('对方不允许编组.', [mbOk]);
               -5: FrmDlg.DMessageDlg ('您想邀请加入编组的人已经加入了其它组！', [mbOk]);
            end;
         end;
      SM_GROUPDELMEM_OK:
         begin
            g_dwChangeGroupModeTick := GetTickCount;
            {data := DecodeString (body);
            for i:=0 to GroupMembers.Count-1 do begin
               if GroupMembers[i] = data then begin
                  GroupMembers.Delete (i);
                  break;
               end;
            end; }
         end;
      SM_GROUPDELMEM_FAIL:
         begin
            g_dwChangeGroupModeTick := GetTickCount;
            case msg.Recog of
               -1: FrmDlg.DMessageDlg ('编组还未成立.', [mbOk]);
               -2: FrmDlg.DMessageDlg ('输入的人物名称不正确.', [mbOk]);
               -3: FrmDlg.DMessageDlg ('此人不在本组中.', [mbOk]);
            end;
         end;
      SM_GROUPCANCEL: begin
        g_GroupMembers.Clear;
      end;
      SM_GROUPMEMBERS:
         begin
            ClientGetGroupMembers (DecodeString(Body));
         end;

      SM_OPENGUILDDLG:
         begin
            g_dwQueryMsgTick := GetTickCount;
            ClientGetOpenGuildDlg (body);
         end;

      SM_SENDGUILDMEMBERLIST:
         begin
            g_dwQueryMsgTick := GetTickCount;
            ClientGetSendGuildMemberList (body);
         end;

      SM_OPENGUILDDLG_FAIL:
         begin
            g_dwQueryMsgTick := GetTickCount;
            FrmDlg.DMessageDlg ('您还没有加入行会.', [mbOk]);
         end;

      SM_DEALTRY_FAIL: begin
        g_dwQueryMsgTick := GetTickCount;
        FrmDlg.DMessageDlg ('两个玩家面对面才能进行相关交易.', [mbOk]);
      end;
      SM_DEALMENU:
         begin
            g_dwQueryMsgTick := GetTickCount;
            g_sDealWho := DecodeString (body);
            FrmDlg.OpenDealDlg;
         end;
      SM_DEALCANCEL: begin
        MoveDealItemToBag;
        if g_DealDlgItem.S.Name <> '' then begin
          AddItemBag (g_DealDlgItem);  //啊规俊 眠啊
          g_DealDlgItem.S.Name := '';
        end;
        if g_nDealGold > 0 then begin
          g_MySelf.m_nGold := g_MySelf.m_nGold + g_nDealGold;
          g_nDealGold := 0;
        end;
        FrmDlg.CloseDealDlg;
      end;
      SM_DEALADDITEM_OK:
         begin
            g_dwDealActionTick := GetTickCount;
            if g_DealDlgItem.S.Name <> '' then begin
               AddDealItem (g_DealDlgItem);  //Deal Dlg俊 眠啊
               g_DealDlgItem.S.Name := '';
            end;
         end;
      SM_DEALADDITEM_FAIL: begin
        g_dwDealActionTick:=GetTickCount;
        if g_DealDlgItem.S.Name <> '' then begin
          AddItemBag(g_DealDlgItem);  //啊规俊 眠啊
          g_DealDlgItem.S.Name:= '';
        end;
      end;
      SM_DEALDELITEM_OK: begin
        g_dwDealActionTick:=GetTickCount;
        if g_DealDlgItem.S.Name <> '' then begin
               //AddItemBag (DealDlgItem);  //啊规俊 眠啊
          g_DealDlgItem.S.Name := '';
        end;
      end;
      SM_DEALDELITEM_FAIL: begin
        g_dwDealActionTick := GetTickCount;
        if g_DealDlgItem.S.Name <> '' then begin
          DelItemBag (g_DealDlgItem.S.Name, g_DealDlgItem.MakeIndex);
          AddDealItem (g_DealDlgItem);
          g_DealDlgItem.S.Name := '';
        end;
      end;
      SM_DEALREMOTEADDITEM: ClientGetDealRemoteAddItem (body);
      SM_DEALREMOTEDELITEM: ClientGetDealRemoteDelItem (body);
      SM_DEALCHGGOLD_OK: begin
        g_nDealGold:=msg.Recog;
        g_MySelf.m_nGold:=MakeLong(msg.param, msg.tag);
        g_dwDealActionTick:=GetTickCount;
      end;
      SM_DEALCHGGOLD_FAIL: begin
        g_nDealGold:=msg.Recog;
        g_MySelf.m_nGold:=MakeLong(msg.param, msg.tag);
        g_dwDealActionTick:=GetTickCount;
      end;
      SM_DEALREMOTECHGGOLD: begin
        g_nDealRemoteGold:=msg.Recog;
        SoundUtil.PlaySound(s_money); 
      end;
      SM_DEALSUCCESS: begin
        FrmDlg.CloseDealDlg;
      end;
      SM_SENDUSERSTORAGEITEM: begin
        ClientGetSendUserStorage(msg.Recog);
      end;
      SM_READMINIMAP_OK: begin
        g_dwQueryMsgTick:=GetTickCount;
        ClientGetReadMiniMap(msg.Param);
      end;
      SM_READMINIMAP_FAIL: begin
        g_dwQueryMsgTick := GetTickCount;
        DScreen.AddChatBoardString ('没有可用的地图.', clWhite, clRed);
        g_nMiniMapIndex:= -1;
      end;
      SM_CHANGEGUILDNAME: begin
        ClientGetChangeGuildName(DecodeString (body));
      end;
      SM_SENDUSERSTATE: begin     //查看别人装备
        g_boUserIsWho := msg.Recog;
        ClientGetSendUserState(body);
      end;
      SM_GUILDADDMEMBER_OK: begin
        SendGuildMemberList;
      end;
      SM_GUILDADDMEMBER_FAIL: begin
        case msg.Recog of
          1: FrmDlg.DMessageDlg ('你没有权利使用这个命令.', [mbOk]);
          2: FrmDlg.DMessageDlg ('想加入行会的应该来面对行会掌门人.', [mbOk]);
          3: FrmDlg.DMessageDlg ('对方已经加入行会.', [mbOk]);
          4: FrmDlg.DMessageDlg ('对方已经加入其他行会.', [mbOk]);
          5: FrmDlg.DMessageDlg ('对方不想加入行会.', [mbOk]);
        end;
      end;
      SM_GUILDDELMEMBER_OK: begin
        SendGuildMemberList;
      end;
      SM_GUILDDELMEMBER_FAIL: begin
        case msg.Recog of
          1: FrmDlg.DMessageDlg('不能使用命令！', [mbOk]);
          2: FrmDlg.DMessageDlg('此人非本行会成员！', [mbOk]);
          3: FrmDlg.DMessageDlg('行会掌门人不能开除自己！', [mbOk]);
          4: FrmDlg.DMessageDlg('不能使用命令Z！', [mbOk]);
        end;
      end;
      SM_GUILDRANKUPDATE_FAIL: begin
        case msg.Recog of
          -2: FrmDlg.DMessageDlg('[提示信息] 掌门人位置不能为空。', [mbOk]);
          -3: FrmDlg.DMessageDlg('[提示信息] 新的行会掌门人已经被传位。', [mbOk]);
          -4: FrmDlg.DMessageDlg('[提示信息] 一个行会最多只能有二个掌门人。', [mbOk]);
          -5: FrmDlg.DMessageDlg('[提示信息] 掌门人位置不能为空。', [mbOk]);
          -6: FrmDlg.DMessageDlg('[提示信息] 不能添加成员/删除成员。', [mbOk]);
          -7: FrmDlg.DMessageDlg('[提示信息] 职位重复或者出错。', [mbOk]);
        end;
      end;
      SM_GUILDMAKEALLY_OK,
      SM_GUILDMAKEALLY_FAIL: begin
        case msg.Recog of
          -1: FrmDlg.DMessageDlg ('您无此权限！', [mbOk]);
          -2: FrmDlg.DMessageDlg ('结盟失败！', [mbOk]);
          -3: FrmDlg.DMessageDlg ('行会结盟必须双方掌门人面对面！', [mbOk]);
          -4: FrmDlg.DMessageDlg ('对方行会掌门人不允许结盟！', [mbOk]);
        end;
      end;
      SM_GUILDBREAKALLY_OK,
      SM_GUILDBREAKALLY_FAIL: begin
        case msg.Recog of
          -1: FrmDlg.DMessageDlg ('解除结盟！', [mbOk]);
          -2: FrmDlg.DMessageDlg ('此行会不是您行会的结盟行会！', [mbOk]);
          -3: FrmDlg.DMessageDlg ('没有此行会！', [mbOk]);
        end;
      end;
      SM_BUILDGUILD_OK: begin
        FrmDlg.LastestClickTime := GetTickCount;
        FrmDlg.DMessageDlg ('行会建立成功.', [mbOk]);
      end;
      SM_BUILDGUILD_FAIL: begin
        FrmDlg.LastestClickTime := GetTickCount;
        case msg.Recog of
          -1: FrmDlg.DMessageDlg('您已经加入其它行会。', [mbOk]);
          -2: FrmDlg.DMessageDlg('缺少创建费用。', [mbOk]);
          -3: FrmDlg.DMessageDlg('你没有准备好需要的全部物品。', [mbOk]);
          else FrmDlg.DMessageDlg('创建行会失败！！！', [mbOk]);
        end;
      end;
      SM_MENU_OK: begin
        {FrmDlg.LastestClickTime:=GetTickCount;
        if body <> '' then
          FrmDlg.DMessageDlg(DecodeString(body), [mbOk]);}

         FrmDlg.LastestClickTime:=GetTickCount;
        if body <> '' then begin
          data:= DecodeString(body);
          if Pos('/@', data) > 0 then begin
            data := GetValidStr3 (data, tagstr, ['/']);//显示的信息
            data := GetValidStr3 (data, str6, ['/']);//Str6触发参数1，data触发参数2
            if mrOk = FrmDlg.DMessageDlg(tagstr, [mbOk,mbCancel]) then begin
              if str6 <> '' then begin
                msg := MakeDefaultMsg (CM_CLICKSIGHICON, 0, 0, 0, 0, frmMain.Certification);
                SendSocket (EncodeMessage (msg) + EncodeString(str6));
              end;
            end else begin
              if data <> '' then begin
                msg := MakeDefaultMsg (CM_CLICKSIGHICON, 0, 0, 0, 0, frmMain.Certification);
                SendSocket (EncodeMessage (msg) + EncodeString(data));
              end;
            end;
          end else
            FrmDlg.DMessageDlg(data, [mbOk]);
        end;
      end;
      SM_DLGMSG: begin
        if body <> '' then
          FrmDlg.DMessageDlg(DecodeString(body), [mbOk]);
      end;
      SM_DONATE_OK: begin
        FrmDlg.LastestClickTime:=GetTickCount;
      end;
      SM_DONATE_FAIL: begin
        FrmDlg.LastestClickTime:=GetTickCount;
      end;

      SM_PLAYDICE: begin
        Body2:=Copy(Body,GetCodeMsgSize(sizeof(TMessageBodyWL)*4/3) + 1, Length(body));
        DecodeBuffer(body,@wl,SizeOf(TMessageBodyWL));
        data:=DecodeString(Body2);
        FrmDlg.m_nDiceCount:=Msg.Param;       //QuestActionInfo.nParam1
        FrmDlg.m_Dice[0].nDicePoint:=LoByte(LoWord(Wl.lParam1)); //UserHuman.m_DyVal[0]
        FrmDlg.m_Dice[1].nDicePoint:=HiByte(LoWord(Wl.lParam1)); //UserHuman.m_DyVal[0]
        FrmDlg.m_Dice[2].nDicePoint:=LoByte(HiWord(Wl.lParam1)); //UserHuman.m_DyVal[0]
        FrmDlg.m_Dice[3].nDicePoint:=HiByte(HiWord(Wl.lParam1)); //UserHuman.m_DyVal[0]

        FrmDlg.m_Dice[4].nDicePoint:=LoByte(LoWord(Wl.lParam2)); //UserHuman.m_DyVal[0]
        FrmDlg.m_Dice[5].nDicePoint:=HiByte(LoWord(Wl.lParam2)); //UserHuman.m_DyVal[0]
        FrmDlg.m_Dice[6].nDicePoint:=LoByte(HiWord(Wl.lParam2)); //UserHuman.m_DyVal[0]
        FrmDlg.m_Dice[7].nDicePoint:=HiByte(HiWord(Wl.lParam2)); //UserHuman.m_DyVal[0]

        FrmDlg.m_Dice[8].nDicePoint:=LoByte(LoWord(Wl.lTag1)); //UserHuman.m_DyVal[0]
        FrmDlg.m_Dice[9].nDicePoint:=HiByte(LoWord(Wl.lTag1)); //UserHuman.m_DyVal[0]
        FrmDlg.DialogSize:=0;
        FrmDlg.DMessageDlg('',[]);
        SendMerchantDlgSelect(Msg.Recog,data);
      end;
      SM_NEEDPASSWORD: begin
        ClientGetNeedPassword(Body);
      end;
      SM_PASSWORDSTATUS: begin
        //ClientGetPasswordStatus(@Msg,Body);
      end;
      else begin
        if g_MySelf = nil then exit;     //Jacky 在未进入游戏时不处理下面
        DebugOutStr('未处理消息');
        DebugOutStr('Ident: ' + IntToStr(msg.Ident));
        DebugOutStr('Recog: ' + IntToStr(msg.Recog));
        DebugOutStr('Param: ' + IntToStr(msg.Param));
        DebugOutStr('Tag: ' + IntToStr(msg.Tag));
        DebugOutStr('Series: ' + IntToStr(msg.Series));
      end;
   end;

   {if Pos('#', datablock) > 0 then
      DScreen.AddSysMsg (datablock);  }
end;


procedure TfrmMain.ClientGetPasswdSuccess (body: string);
var
   str, runaddr, runport, certifystr: string;
begin
   str := DecodeString (body);
   str := GetValidStr3 (str, runaddr, ['/']);
   str := GetValidStr3 (str, runport, ['/']);
   str := GetValidStr3 (str, certifystr, ['/']);
   Certification := Str_ToInt(certifystr, 0);

   if not BoOneClick then begin
      CSocket.Active:=False;
      CSocket.Host:='';
      CSocket.Port:=0;
      FrmDlg.DSelServerDlg.Visible := FALSE;
      WaitAndPass (500); //0.5檬悼救 扁促覆
      g_ConnectionStep := cnsSelChr;
      with CSocket do begin
         g_sSelChrAddr := runaddr;
         g_nSelChrPort := Str_ToInt (runport, 0);
         Address := g_sSelChrAddr;
         Port := g_nSelChrPort;
         Active := TRUE;
      end;
   end else begin
      FrmDlg.DSelServerDlg.Visible := FALSE;
      g_sSelChrAddr := runaddr;
      g_nSelChrPort := Str_ToInt (runport, 0);
      if CSocket.Socket.Connected then
         CSocket.Socket.SendText ('$S' + runaddr + '/' + runport + '%');
      WaitAndPass (500); //0.5檬悼救 扁促覆
      g_ConnectionStep := cnsSelChr;
      LoginScene.OpenLoginDoor;
      SelChrWaitTimer.Enabled := TRUE;
   end;
end;
procedure TfrmMain.ClientGetPasswordOK(Msg: TDefaultMessage;
  sBody: String);
var
  I: Integer;
  sServerName:String;
  sServerStatus:String;
  nCount:Integer;
begin
  sBody:=DeCodeString(sBody);
//  FrmDlg.DMessageDlg (sBody + '/' + IntToStr(Msg.Series), [mbOk]);
  nCount:=_MIN(6,msg.Series);
  g_ServerList.Clear;
  if nCount > 0 then //20080629
  for I := 0 to nCount - 1 do begin
    sBody:=GetValidStr3(sBody,sServerName,['/']);
    sBody:=GetValidStr3(sBody,sServerStatus,['/']);
    g_ServerList.AddObject(sServerName,TObject(Str_ToInt(sServerStatus,0)));
  end;

   g_wAvailIDDay := Loword(msg.Recog);
   g_wAvailIDHour := Hiword(msg.Recog);
   g_wAvailIPDay := msg.Param;
   g_wAvailIPHour := msg.Tag;

   if g_wAvailIDDay > 0 then begin
      if g_wAvailIDDay = 1 then
         FrmDlg.DMessageDlg ('您当前ID费用到今天为止。', [mbOk])
      else if g_wAvailIDDay <= 3 then
         FrmDlg.DMessageDlg ('您当前IP费用还剩 ' + IntToStr(g_wAvailIDDay) + ' 天。', [mbOk]);
   end else if g_wAvailIPDay > 0 then begin
      if g_wAvailIPDay = 1 then
         FrmDlg.DMessageDlg ('您当前IP费用到今天为止。', [mbOk])
      else if g_wAvailIPDay <= 3 then
         FrmDlg.DMessageDlg ('您当前IP费用还剩 ' + IntToStr(g_wAvailIPDay) + ' 天。', [mbOk]);
   end else if g_wAvailIPHour > 0 then begin
      if g_wAvailIPHour <= 100 then
         FrmDlg.DMessageDlg ('您当前IP费用还剩 ' + IntToStr(g_wAvailIPHour) + ' 小时。', [mbOk]);
   end else if g_wAvailIDHour > 0 then begin
      FrmDlg.DMessageDlg ('您当前ID费用还剩 ' + IntToStr(g_wAvailIDHour) + ' 小时。', [mbOk]);;
   end;

   if not LoginScene.m_boUpdateAccountMode then
      ClientGetSelectServer;
end;

procedure TfrmMain.ClientGetSelectServer;
begin
  LoginScene.HideLoginBox;
  FrmDlg.ShowSelectServerDlg;
end;

procedure TfrmMain.ClientGetNeedUpdateAccount (body: string);
var
   ue: TUserEntry;
begin
   DecodeBuffer (body, @ue, sizeof(TUserEntry));
   LoginScene.UpdateAccountInfos (ue);
end;

procedure TfrmMain.ClientGetReceiveChrs (body: string);
var
   i, select: integer;
   str, uname, sjob, shair, slevel, ssex: string;
begin
   SelectChrScene.ClearChrs;
   str := DecodeString (body);
   for i:=0 to 1 do begin
      str := GetValidStr3 (str, uname, ['/']);
      str := GetValidStr3 (str, sjob, ['/']);
      str := GetValidStr3 (str, shair, ['/']);
      str := GetValidStr3 (str, slevel, ['/']);
      str := GetValidStr3 (str, ssex, ['/']);
      select := 0;
      if (uname <> '') and (slevel <> '') and (ssex <> '') then begin
         if uname[1] = '*' then begin
            select := i;
            uname := Copy (uname, 2, Length(uname)-1);
         end;
         SelectChrScene.AddChr (uname, Str_ToInt(sjob, 0), Str_ToInt(shair, 0), Str_ToInt(slevel, 0), Str_ToInt(ssex, 0));
      end;
      with SelectChrScene do begin
         if select = 0 then begin
            ChrArr[0].FreezeState := FALSE;
            ChrArr[0].Selected := TRUE;
            ChrArr[1].FreezeState := TRUE;
            ChrArr[1].Selected := FALSE;
         end else begin
            ChrArr[0].FreezeState := TRUE;
            ChrArr[0].Selected := FALSE;
            ChrArr[1].FreezeState := FALSE;
            ChrArr[1].Selected := TRUE;
         end;
      end;
   end;
   PlayScene.EdAccountt.Text:=LoginId;
   //2004/05/17  强行登录
   {
   if SelectChrScene.ChrArr[0].Valid and SelectChrScene.ChrArr[0].Selected then PlayScene.EdChrNamet.Text := SelectChrScene.ChrArr[0].UserChr.Name;
   if SelectChrScene.ChrArr[1].Valid and SelectChrScene.ChrArr[1].Selected then PlayScene.EdChrNamet.Text := SelectChrScene.ChrArr[1].UserChr.Name;
   PlayScene.EdAccountt.Visible:=True;
   PlayScene.EdChrNamet.Visible:=True;
   }
   //2004/05/17
end;
//玩家点击开始游戏
procedure TfrmMain.ClientGetStartPlay (body: string);
var
   str, addr, sport: string;
begin
   str := DecodeString (body);
   sport := GetValidStr3 (str, g_sRunServerAddr, ['/']);
   g_nRunServerPort:=Str_ToInt (sport, 0);

   if not BoOneClick then begin
      CSocket.Active := FALSE;  //肺弊牢俊 楷搬等 家南 摧澜
      CSocket.Host:='';
      CSocket.Port:=0;
      //WaitAndPass (1); //暂停0.001 秒   20080331

      g_ConnectionStep := cnsPlay;
      with CSocket do begin
         Address := g_sRunServerAddr;
         Port := g_nRunServerPort;
         Active := TRUE;
      end;
   end else begin
      SocStr := '';
      BufferStr := '';
      if CSocket.Socket.Connected then
         CSocket.Socket.SendText ('$R' + addr + '/' + sport + '%');

      g_ConnectionStep := cnsPlay;
      ClearBag;  //啊规 檬扁拳
      DScreen.ClearChatBoard; //盲泼芒 檬扁拳
      DScreen.ChangeScene (stLoginNotice);
      SendRunLogin;
   end;
end;

procedure TfrmMain.ClientGetReconnect (body: string);
var
   str, addr, sport: string;
begin
   str := DecodeString (body);
   sport := GetValidStr3 (str, addr, ['/']);

   if not BoOneClick then begin
      if g_boBagLoaded then
         Savebags ('.\Config\' + '56' + g_sServerName + '.' + CharName + '.itm', @g_ItemArr);
      g_boBagLoaded := FALSE;

      g_boServerChanging := TRUE;
      CSocket.Active := FALSE;  //肺弊牢俊 楷搬等 家南 摧澜
      CSocket.Host:='';
      CSocket.Port:=0;

      WaitAndPass (1); //0.5檬悼救 扁促覆

      g_ConnectionStep := cnsPlay;
      with CSocket do begin
         Address := addr;
         Port := Str_ToInt (sport, 0);
         Active := TRUE;
      end;

   end else begin
      if g_boBagLoaded then
         Savebags ('.\Config\' + '56' + g_sServerName + '.' + CharName + '.itm', @g_ItemArr);
      g_boBagLoaded := FALSE;

      SocStr := '';
      BufferStr := '';
      g_boServerChanging := TRUE;

      if CSocket.Socket.Connected then   //立加 辆丰 脚龋 焊辰促.
         CSocket.Socket.SendText ('$C' + addr + '/' + sport + '%');

      WaitAndPass (1); //0.5檬悼救 扁促覆
      if CSocket.Socket.Connected then   //犁立..
         CSocket.Socket.SendText ('$R' + addr + '/' + sport + '%');

      g_ConnectionStep := cnsPlay;
      ClearBag;  //啊规 檬扁拳
      DScreen.ClearChatBoard; //盲泼芒 檬扁拳
      DScreen.ChangeScene (stLoginNotice);

      WaitAndPass (1); //0.5檬悼救 扁促覆
      ChangeServerClearGameVariables;

      SendRunLogin;
   end;
end;
//取地图音乐背景
procedure TfrmMain.ClientGetMapDescription(Msg:TDefaultMessage;sBody:String);
var
  sTitle:String;
begin
  sBody:=DecodeString(sBody);
  //sBody:=GetValidStr3(sBody, sTitle, [#13]);//原来的代码
  g_sMapMusic:=GetValidStr3(sBody, sTitle, [#13]);//自己加的变量,保存文件路径  20080402
  g_sMapTitle:=sTitle;
  g_nMapMusic:=Msg.Recog;
  PlayMapMusic(True);
end;


procedure TfrmMain.ClientGetGameGoldName(Msg:TDefaultMessage;sBody: String);
var
  sData, sData1, sData2, sData3:String;
begin
  if sBody <> '' then begin
    sBody:=DecodeString(sBody);
    sBody:=GetValidStr3(sBody, sData, [#13]);
    sBody:=GetValidStr3(sBody, sData1, [#13]);
    sBody:=GetValidStr3(sBody, sData2, [#13]);
    sBody:=GetValidStr3(sBody, sData3, [#13]);

    g_sGameGoldName:=sData;
    g_sGamePointName:=sData1;
    g_sGameDiaMond:=sData2;
    g_sGameGird:=sData3;
  end;
  g_MySelf.m_nGameGold:=Msg.Recog;
  g_MySelf.m_nGamePoint:=Msg.Param;
  g_MySelf.m_nGameDiaMond:=Msg.Tag; //接收金刚石数量 2008.02.11
  g_MySelf.m_nGameGird:=Msg.Series; //接收灵符数量 2008.02.11
end;

procedure TfrmMain.ClientGetAdjustBonus (bonus: integer; body: string);
var
   str1, str2, str3: string;
begin
   g_nBonusPoint := bonus;
   body := GetValidStr3 (body, str1, ['/']);
   str3 := GetValidStr3 (body, str2, ['/']);
   DecodeBuffer (str1, @g_BonusTick, sizeof(TNakedAbility));
   DecodeBuffer (str2, @g_BonusAbil, sizeof(TNakedAbility));
   DecodeBuffer (str3, @g_NakedAbil, sizeof(TNakedAbility));
   FillChar (g_BonusAbilChg, sizeof(TNakedAbility), #0);
end;

procedure TfrmMain.ClientGetAddItem (body: string);
var
   cu: TClientItem;
begin
   if body <> '' then begin
      DecodeBuffer (body, @cu, sizeof(TClientItem));
      AddItemBag (cu);
      DScreen.AddSysMsg (cu.S.Name + ' 被发现.');
   end;
end;

procedure TfrmMain.ClientGetHeroAddItem (body: string);
var
   cu: TClientItem;
begin
   if body <> '' then begin
      DecodeBuffer (body, @cu, sizeof(TClientItem));
      AddHeroItemBag (cu);
      DScreen.AddSysMsg ('英雄 '+cu.S.Name + ' 被发现.');
   end;
end;

procedure TfrmMain.ClientGetHeroUpdateItem (body: string);
var
   i: integer;
   cu: TClientItem;
begin
   if body <> '' then begin
      DecodeBuffer (body, @cu, sizeof(TClientItem));
      HeroUpdateItemBag (cu);
      for i:=0 to 12 do begin
         if (g_HeroItems[i].S.Name = cu.S.Name) and (g_HeroItems[i].MakeIndex = cu.MakeIndex) then begin
            g_HeroItems[i] := cu;
         end;
      end;
   end;
end;

procedure TfrmMain.ClientGetHeroDelItems (body: string);
var
   i, iindex: integer;
   str, iname: string;
begin
   body := DecodeString (body);
   while body <> '' do begin
      body := GetValidStr3 (body, iname, ['/']);
      body := GetValidStr3 (body, str, ['/']);
      if (iname <> '') and (str <> '') then begin
         iindex := Str_ToInt(str, 0);
         DelHeroItemBag (iname, iindex);
         for i:=0 to 12 do begin
            if (g_HeroItems[i].S.Name = iname) and (g_HeroItems[i].MakeIndex = iindex) then begin
               g_HeroItems[i].S.Name := '';
            end;
         end;
      end else
         break;
   end;
end;

procedure TfrmMain.ClientGetHeroDelItem (body: string);
var
   i: integer;
   cu: TClientItem;
begin
   if body <> '' then begin
      DecodeBuffer (body, @cu, sizeof(TClientItem));
      DelHeroItemBag (cu.S.Name, cu.MakeIndex);
      for i:=0 to 12 do begin
         if (g_HeroItems[i].S.Name = cu.S.Name) and (g_HeroItems[i].MakeIndex = cu.MakeIndex) then begin
            g_HeroItems[i].S.Name := '';
         end;
      end;
   end;
end;
//接收排行榜
procedure TfrmMain.ClientGetUserOrder (body: string);
  function GetSortList: TList;
  begin
    Result := nil;
    case nLevelOrderSortType of
      0: begin
          case nLevelOrderType of
            1: Result := m_PlayObjectLevelList;
            2: Result := m_WarrorObjectLevelList;
            3: Result := m_WizardObjectLevelList;
            4: Result := m_TaoistObjectLevelList;
          end;
        end;
      1: begin
          case nLevelOrderType of
            1: Result := m_HeroObjectLevelList;
            2: Result := m_WarrorHeroObjectLevelList;
            3: Result := m_WizardHeroObjectLevelList;
            4: Result := m_TaoistHeroObjectLevelList;
          end;
        end;
      2: begin
          Result := m_PlayObjectMasterList;
        end;
    end;
  end;
var
   i: integer;
   data: string;
   UserLevelSort: pTUserLevelSort;
   HeroLevelSort: pTHeroLevelSort;
   UserMasterSort: pTUserMasterSort;
   List: TList;
begin
   List := GetSortList;
   if List.Count > 0 then //20080629
   for i:=0 to List.Count-1 do Dispose (pTUserLevelSort(List[i]));
   List.Clear;
   while TRUE do begin
      if body = '' then break;
      body := GetValidStr3 (body, data, ['/']);
      if data <> '' then begin
         case nLevelOrderSortType of
           0: begin
             new (UserLevelSort);
             DecodeBuffer (data, @(UserLevelSort^), sizeof(TUserLevelSort));
             List.Add (UserLevelSort);
           end;
           1: begin
             new (HeroLevelSort);
             DecodeBuffer (data, @(HeroLevelSort^), sizeof(THeroLevelSort));
             List.Add (HeroLevelSort);
           end;
           2: begin
             new (UserMasterSort);
             DecodeBuffer (data, @(UserMasterSort^), sizeof(TUserMasterSort));
             List.Add (UserMasterSort);
           end;
         end;
      end else
         break;
   end;
end;
procedure TfrmMain.ClientGetUpdateItem (body: string);
var
   i: integer;
   cu: TClientItem;
begin
   if body <> '' then begin
      DecodeBuffer (body, @cu, sizeof(TClientItem));
      UpdateItemBag (cu);
      for i:=0 to 12 do begin
         if (g_UseItems[i].S.Name = cu.S.Name) and (g_UseItems[i].MakeIndex = cu.MakeIndex) then begin
            g_UseItems[i] := cu;
         end;
      end;
   end;
end;

procedure TfrmMain.ClientGetDelItem (body: string);
var
   i: integer;
   cu: TClientItem;
begin
   if body <> '' then begin
      DecodeBuffer (body, @cu, sizeof(TClientItem));
      DelItemBag (cu.S.Name, cu.MakeIndex);
      for i:=0 to 12 do begin
         if (g_UseItems[i].S.Name = cu.S.Name) and (g_UseItems[i].MakeIndex = cu.MakeIndex) then begin
            g_UseItems[i].S.Name := '';
         end;
      end;
   end;
end;

procedure TfrmMain.ClientGetDelItems (body: string);
var
   i, iindex: integer;
   str, iname: string;
begin
   body := DecodeString (body);
   while body <> '' do begin
      body := GetValidStr3 (body, iname, ['/']);
      body := GetValidStr3 (body, str, ['/']);
      if (iname <> '') and (str <> '') then begin
         iindex := Str_ToInt(str, 0);
         DelItemBag (iname, iindex);
         for i:=0 to 12 do begin
            if (g_UseItems[i].S.Name = iname) and (g_UseItems[i].MakeIndex = iindex) then begin
               g_UseItems[i].S.Name := '';
            end;
         end;
      end else
         break;
   end;
end;

procedure TfrmMain.ClientGetBagItmes (body: string);
var
   str: string;
   cu: TClientItem;
   ItemSaveArr: array[0..MAXBAGITEMCL-1] of TClientItem;

   function CompareItemArr: Boolean;
   var
      i, j: integer;
      flag: Boolean;
   begin
      flag := TRUE;
      for i:=0 to MAXBAGITEMCL-1 do begin
         if ItemSaveArr[i].S.Name <> '' then begin
            flag := FALSE;
            for j:=0 to MAXBAGITEMCL-1 do begin
               if (g_ItemArr[j].S.Name = ItemSaveArr[i].S.Name) and
                  (g_ItemArr[j].MakeIndex = ItemSaveArr[i].MakeIndex) then begin
                  if (g_ItemArr[j].Dura = ItemSaveArr[i].Dura) and
                     (g_ItemArr[j].DuraMax = ItemSaveArr[i].DuraMax) then begin
                     flag := TRUE;
                  end;
                  break;
               end;
            end;
            if not flag then break;
         end;
      end;
      if flag then begin
         for i:=0 to MAXBAGITEMCL-1 do begin
            if g_ItemArr[i].S.Name <> '' then begin
               flag := FALSE;
               for j:=0 to MAXBAGITEMCL-1 do begin
                  if (g_ItemArr[i].S.Name = ItemSaveArr[j].S.Name) and
                     (g_ItemArr[i].MakeIndex = ItemSaveArr[j].MakeIndex) then begin
                     if (g_ItemArr[i].Dura = ItemSaveArr[j].Dura) and
                        (g_ItemArr[i].DuraMax = ItemSaveArr[j].DuraMax) then begin
                        flag := TRUE;
                     end;
                     break;
                  end;
               end;
               if not flag then break;
            end;
         end;
      end;
      Result := flag;
   end;
begin
   //ClearBag;
   FillChar (g_ItemArr, sizeof(TClientItem)*MAXBAGITEMCL, #0);
   while TRUE do begin
      if body = '' then break;
      body := GetValidStr3 (body, str, ['/']);
      DecodeBuffer (str, @cu, sizeof(TClientItem));
      AddItemBag (cu);
   end;

   FillChar (ItemSaveArr, sizeof(TClientItem)*MAXBAGITEMCL, #0);
   Loadbags ('.\Config\' + '56' + g_sServerName + '.' + CharName + '.itm', @ItemSaveArr);
   if CompareItemArr then begin
      Move (ItemSaveArr, g_ItemArr, sizeof(TClientItem) * MAXBAGITEMCL);
   end;

   ArrangeItembag;
   g_boBagLoaded := TRUE;
end;

procedure TfrmMain.ClientGetDropItemFail (iname: string; sindex: integer);
var
   pc: PTClientItem;
begin
   pc := GetDropItem (iname, sindex);
   if pc <> nil then begin
      AddItemBag (pc^);
      DelDropItem (iname, sindex);
   end;
end;

procedure TfrmMain.ClientGetHeroDropItemFail (iname: string; sindex: integer);
var
   pc: PTClientItem;
begin
   pc := GetDropItem (iname, sindex);
   if pc <> nil then begin
      AddHeroItemBag (pc^);
      DelDropItem (iname, sindex);
   end;
end;
procedure TfrmMain.ClientGetShowItem (itemid, x, y, looks: integer; itmname: string);
var
  I:Integer;
  DropItem:PTDropItem;
begin
  if g_DropedItemList.Count > 0 then begin//20080629
    for i:=0 to g_DropedItemList.Count-1 do begin
      if PTDropItem(g_DropedItemList[i]).Id = itemid then
        Exit;
    end;
  end;
  New(DropItem);
  DropItem.Id := itemid;
  DropItem.X := x;
  DropItem.Y := y;
  DropItem.Looks := looks;
  DropItem.Name := itmname;
  DropItem.FlashTime := GetTickCount - LongWord(Random(3000));
  DropItem.BoFlash := FALSE;
  g_DropedItemList.Add(DropItem);
end;

procedure TfrmMain.ClientGetHideItem (itemid, x, y: integer);
var
  I:Integer;
  DropItem:PTDropItem;
begin
  if g_DropedItemList.Count > 0 then //20080629
  for I:=0 to g_DropedItemList.Count - 1 do begin
    DropItem:=g_DropedItemList[I];
    if DropItem.Id = itemid then begin
      Dispose (DropItem);
      g_DropedItemList.Delete(I);
      break;
    end;
  end;
end;
procedure TfrmMain.ClientGetSenduseItems (body: string);
var
   index: integer;
   str, data: string;
   cu: TClientItem;
begin
   FillChar (g_UseItems, sizeof(TClientItem)*14, #0);
//   FillChar (UseItems, sizeof(TClientItem)*9, #0);
   while TRUE do begin
      if body = '' then break;
      body := GetValidStr3 (body, str, ['/']);
      body := GetValidStr3 (body, data, ['/']);
      index := Str_ToInt (str, -1);
      if index in [0..13] then begin
         DecodeBuffer (data, @cu, sizeof(TClientItem));
         g_UseItems[index] := cu;
      end;
   end;
end;

procedure TfrmMain.ClientHeroGetBagItmes(body: string);
var
   str: string;
   cu: TClientItem;
   ItemSaveArr: array[0..MAXBAGITEMCL-1] of TClientItem;

   function CompareItemArr: Boolean;
   var
      i, j: integer;
      flag: Boolean;
   begin
      flag := TRUE;
      for i:=0 to MAXBAGITEMCL-1 do begin
         if ItemSaveArr[i].S.Name <> '' then begin
            flag := FALSE;
            for j:=0 to MAXBAGITEMCL-1 do begin
               if (g_HeroItemArr[j].S.Name = ItemSaveArr[i].S.Name) and
                  (g_HeroItemArr[j].MakeIndex = ItemSaveArr[i].MakeIndex) then begin
                  if (g_HeroItemArr[j].Dura = ItemSaveArr[i].Dura) and
                     (g_HeroItemArr[j].DuraMax = ItemSaveArr[i].DuraMax) then begin
                     flag := TRUE;
                  end;
                  break;
               end;
            end;
            if not flag then break;
         end;
      end;
      if flag then begin
         for i:=0 to MAXBAGITEMCL-1 do begin
            if g_HeroItemArr[i].S.Name <> '' then begin
               flag := FALSE;
               for j:=0 to MAXBAGITEMCL-1 do begin
                  if (g_HeroItemArr[i].S.Name = ItemSaveArr[j].S.Name) and
                     (g_HeroItemArr[i].MakeIndex = ItemSaveArr[j].MakeIndex) then begin
                     if (g_HeroItemArr[i].Dura = ItemSaveArr[j].Dura) and
                        (g_HeroItemArr[i].DuraMax = ItemSaveArr[j].DuraMax) then begin
                        flag := TRUE;
                     end;
                     break;
                  end;
               end;
               if not flag then break;
            end;
         end;
      end;
      Result := flag;
   end;
begin
   //ClearBag;
   FillChar (g_HeroItemArr, sizeof(TClientItem)*MAXBAGITEMCL, #0);
   while TRUE do begin
      if body = '' then break;
      body := GetValidStr3 (body, str, ['/']);
      DecodeBuffer (str, @cu, sizeof(TClientItem));
      AddHeroItemBag (cu);
   end;

   FillChar (ItemSaveArr, sizeof(TClientItem)*MAXBAGITEMCL, #0);
   if CompareItemArr then begin
      Move (ItemSaveArr, g_HeroItemArr, sizeof(TClientItem) * MAXBAGITEMCL);
   end;

   ArrangeHeroItembag;
   g_boHeroBagLoaded := TRUE;
end;
//从服务端获取英雄身上物品
procedure TfrmMain.ClientGetSendHeroItems (body: string);   //清清$003
var
   index: integer;
   str, data: string;
   cu: TClientItem;
begin
   FillChar (g_HeroItems, sizeof(TClientItem)*14, #0);
   while TRUE do begin
      if body = '' then break;
      body := GetValidStr3 (body, str, ['/']);
      body := GetValidStr3 (body, data, ['/']);
      index := Str_ToInt (str, -1);
      if index in [0..13] then begin
         DecodeBuffer (data, @cu, sizeof(TClientItem));
         g_HeroItems[index] := cu;
      end;
   end;
end;

procedure TfrmMain.ClientGetHeroMagics (body: string);
var
   i: integer;
   data: string;
   pcm: PTClientMagic;
begin
   if g_HeroMagicList.Count > 0 then //20080629
   for i:=0 to g_HeroMagicList.Count-1 do
      Dispose (PTClientMagic (g_HeroMagicList[i]));
   g_HeroMagicList.Clear;
   if g_HeroInternalForceMagicList.Count > 0 then
   for I:=0 to g_HeroInternalForceMagicList.Count-1 do
      Dispose (PTClientMagic (g_HeroInternalForceMagicList[i]));
   g_HeroInternalForceMagicList.Clear;

   while TRUE do begin
      if body = '' then break;
      body := GetValidStr3 (body, data, ['/']);
      if data <> '' then begin
         new (pcm);
         DecodeBuffer (data, @(pcm^), sizeof(TClientMagic));
         if pcm.Def.sDescr = '内功' then
           g_HeroInternalForceMagicList.Add (pcm)
         else
           g_HeroMagicList.Add (pcm);
      end else
         break;
   end;
end;

procedure TfrmMain.ClientGetHeroAddMagic (body: string);
var
   pcm: PTClientMagic;
begin
   new (pcm);
   DecodeBuffer (body, @(pcm^), sizeof(TClientMagic));
   if pcm.Def.sDescr = '内功' then
     g_HeroInternalForceMagicList.Add (pcm)
   else
     g_HeroMagicList.Add (pcm);
end;

procedure TfrmMain.ClientGetHeroDelMagic (magid: integer);
var
   i: integer;
   bo123: Boolean;
begin
   bo123 := False;
   if g_HeroMagicList.Count > 0 then //20080629
   for i:=g_HeroMagicList.Count-1 downto 0 do begin
      if PTClientMagic(g_HeroMagicList[i]).Def.wMagicId = magid then begin
         Dispose (PTClientMagic(g_HeroMagicList[i]));
         g_HeroMagicList.Delete (i);
         bo123 := True;
         break;
      end;
   end;
   
   if not bo123 then begin
     if g_HeroInternalForceMagicList.Count > 0 then begin
       for i:=g_HeroInternalForceMagicList.Count-1 downto 0 do begin
          if PTClientMagic(g_HeroInternalForceMagicList[i]).Def.wMagicId = magid then begin
             Dispose (PTClientMagic(g_HeroInternalForceMagicList[i]));
             g_HeroInternalForceMagicList.Delete (i);
             break;
          end;
       end;
     end;
   end;
end;
procedure TfrmMain.ClientGetHeroMagicLvExp (magid, maglv, magtrain: integer);
var
   i: integer;
   bo123: Boolean;
begin
   bo123 := False;
   if g_HeroMagicList.Count > 0 then //20080629
   for i:=g_HeroMagicList.Count-1 downto 0 do begin
      if PTClientMagic(g_HeroMagicList[i]).Def.wMagicId = magid then begin
         PTClientMagic(g_HeroMagicList[i]).Level := maglv;
         PTClientMagic(g_HeroMagicList[i]).CurTrain := magtrain;
         bo123 := True;
         break;
      end;
   end;
   if not bo123 then begin
     if g_HeroInternalForceMagicList.Count > 0 then
     for I:=g_HeroInternalForceMagicList.Count-1 downto 0 do begin
        if PTClientMagic(g_HeroInternalForceMagicList[i]).Def.wMagicId = magid then begin
           PTClientMagic(g_HeroInternalForceMagicList[i]).Level := maglv;
           PTClientMagic(g_HeroInternalForceMagicList[i]).CurTrain := magtrain;
           break;
        end;
     end;
   end;
end;

procedure TfrmMain.ClientGetHeroDuraChange (uidx, newdura, newduramax: integer);
begin
   if uidx in [0..13] then begin
      if g_HeroItems[uidx].S.Name <> '' then begin
         g_HeroItems[uidx].Dura := newdura;
         g_HeroItems[uidx].DuraMax := newduramax;
      end;
   end;
end;

//聚灵珠时间改变 20080307
procedure TfrmMain.ClientGetExpTimeItemChange(uidx, NewTime: integer);
var
  I:  Integer;
  IsYes: Boolean; //人物包裹里是否有 20080427
begin
  IsYes := False;
  for i:=5 to MAXBAGITEMCL - 1 do begin
     if (g_ItemArr[i].MakeIndex = uidx) then  begin
       if g_ItemArr[i].S.Name <> '' then begin
          g_ItemArr[i].s.Need := NewTime;
          IsYes := True;
       end;
     end;
  end;
  if IsYes then Exit;
  if g_HeroBagCount > 0 then //20080629
  for I:=0 to g_HeroBagCount - 1 do begin
    if (g_HeroItemArr[i].MakeIndex = uidx) then  begin
       if g_HeroItemArr[i].S.Name <> '' then
          g_HeroItemArr[i].s.Need := NewTime;
    end;
  end;
end;

procedure TfrmMain.ClientGetAddMagic (body: string);
var
   pcm: PTClientMagic;
begin
   new (pcm);
   DecodeBuffer (body, @(pcm^), sizeof(TClientMagic));
   if pcm.Def.sDescr = '内功' then
     g_InternalForceMagicList.Add (pcm)
   else
     g_MagicList.Add (pcm);
end;

procedure TfrmMain.ClientGetDelMagic (magid: integer);
var
   i: integer;
   bo123: Boolean;
begin
   bo123 := False;
   if g_MagicList.Count > 0 then //20080629
   for i:=g_MagicList.Count-1 downto 0 do begin
      if PTClientMagic(g_MagicList[i]).Def.wMagicId = magid then begin
         Dispose (PTClientMagic(g_MagicList[i]));
         g_MagicList.Delete (i);
         bo123 := True;
         break;
      end;
   end;
   if not bo123 then begin
     if g_InternalForceMagicList.Count > 0 then begin   //内功
       for i:=g_InternalForceMagicList.Count-1 downto 0 do begin
         if PTClientMagic(g_InternalForceMagicList[I]).Def.wMagicId = magid then begin
           Dispose (PTClientMagic(g_InternalForceMagicList[i]));
           g_InternalForceMagicList.Delete (i);
           break;
         end;
       end;
     end;
   end;
end;
procedure TfrmMain.ClientGetMyShopSpecially (body: string); //商铺奇珍 清清 2007.11.14
var
   i: integer;
   data: string;
   pcm: pTShopInfo;
begin
   if g_ShopSpeciallyItemList.Count > 0 then //20080629
   for i:=0 to g_ShopSpeciallyItemList.Count-1 do
      Dispose (pTShopInfo(g_ShopSpeciallyItemList[i]));
   g_ShopSpeciallyItemList.Clear;
   while TRUE do begin
      if body = '' then break;
      body := GetValidStr3 (body, data, ['/']);
      if data <> '' then begin
         new (pcm);
         DecodeBuffer (data, @(pcm^), sizeof(TShopInfo));
         g_ShopSpeciallyItemList.Add (pcm);
      end else
         break;
   end;
end;
//商铺 清清 2007.11.14
procedure TfrmMain.ClientGetMyShop (body: string);
var
   i: integer;
   data: string;
   pcm: pTShopInfo;
begin
   if g_ShopItemList.Count > 0 then //20080629
   for i:=0 to g_ShopItemList.Count-1 do
      if pTShopInfo(g_ShopItemList[i]) <> nil then
       Dispose (pTShopInfo(g_ShopItemList[i]));
   g_ShopItemList.Clear;
   while TRUE do begin
      if body = '' then break;
      body := GetValidStr3 (body, data, ['/']);
      if data <> '' then begin
         new (pcm);
         DecodeBuffer (data, @(pcm^), sizeof(TShopInfo));
         g_ShopItemList.Add (pcm);
      end else
         break;
   end;
end;
//接收宝箱物品 2008.01.16
procedure TfrmMain.ClientGetMyBoxsItem (body: string);
var
   I: integer;
   data: string;
   pcm: pTBoxsInfo;
   List: TList;
begin
   if g_BoxsItemList.Count > 0 then //20080629
   for i:=0 to g_BoxsItemList.Count-1 do
      Dispose (pTBoxsInfo(g_BoxsItemList[i]));
   g_BoxsItemList.Clear;
   while TRUE do begin
      if body = '' then break;
      body := GetValidStr3 (body, data, ['/']);
      if data <> '' then begin
         new (pcm);
         DecodeBuffer (data, @(pcm^), sizeof(TBoxsInfo));
         g_BoxsItemList.Add (pcm);
      end else
         break;
   end;

  List:=TList.Create;
  try
    if g_BoxsItemList.Count > 0 then //20080629
    for I:=0 to g_BoxsItemList.Count-1 do begin
      pcm := pTBoxsInfo (g_BoxsItemList[i]);
      if pcm.nItemType <> 2 then begin
        List.add(pcm);
      end else begin
        g_BoxsItems[8] := pcm.StdItem;
      end;
    end;
    if List.Count > 0 then //20080629
    for I:=0 to List.Count-1 do begin
      pcm := pTBoxsInfo (g_BoxsItemList[i]);
      g_BoxSItems[I] := pcm.StdItem;
    end;
  finally
    List.Free;
  end;
end;

procedure TfrmMain.ClientGetMyMagics (body: string);
var
   i: integer;
   data: string;
   pcm: PTClientMagic;
begin
   if g_MagicList.Count > 0 then //20080629
   for i:=0 to g_MagicList.Count-1 do
     if PTClientMagic (g_MagicList[i]) <> nil then
      Dispose (PTClientMagic (g_MagicList[i]));
   g_MagicList.Clear;
   
   if g_InternalForceMagicList.Count > 0 then
   for i:=0 to g_InternalForceMagicList.Count-1 do
     if PTClientMagic (g_InternalForceMagicList[i]) <> nil then
      Dispose (PTClientMagic (g_InternalForceMagicList[i]));
   g_InternalForceMagicList.Clear;

   while TRUE do begin
      if body = '' then break;
      body := GetValidStr3 (body, data, ['/']);
      if data <> '' then begin
         New (pcm);
         DecodeBuffer (data, @(pcm^), sizeof(TClientMagic));
         if pcm.Def.sDescr = '内功' then
           g_InternalForceMagicList.Add (pcm)
         else
           g_MagicList.Add (pcm);
      end else
         break;
   end;
end;

procedure TfrmMain.ClientGetMagicLvExp (magid, maglv, magtrain: integer);
var
   i: integer;
   bo123: Boolean;
begin
   bo123 := False;
   if g_MagicList.Count > 0 then //20080629
   for i:=g_MagicList.Count-1 downto 0 do begin
      if PTClientMagic(g_MagicList[i]).Def.wMagicId = magid then begin
         PTClientMagic(g_MagicList[i]).Level := maglv;
         PTClientMagic(g_MagicList[i]).CurTrain := magtrain;
         bo123 := True;
         break;
      end;
   end;
   if not bo123 then begin
     if g_InternalForceMagicList.Count > 0 then //20080629
     for i:=g_InternalForceMagicList.Count-1 downto 0 do begin
        if PTClientMagic(g_InternalForceMagicList[i]).Def.wMagicId = magid then begin
           PTClientMagic(g_InternalForceMagicList[i]).Level := maglv;
           PTClientMagic(g_InternalForceMagicList[i]).CurTrain := magtrain;
           break;
        end;
     end;
   end;
end;

procedure TfrmMain.ClientGetDuraChange (uidx, newdura, newduramax: integer);
begin
   if uidx in [0..13] then begin
      if g_UseItems[uidx].S.Name <> '' then begin
         g_UseItems[uidx].Dura := newdura;
         g_UseItems[uidx].DuraMax := newduramax;
      end;
   end;
end;

//接收到的商人说的话
procedure TfrmMain.ClientGetMerchantSay (merchant, face: integer; saying: string);
var
   npcname: string;
begin
   g_nMDlgX := g_MySelf.m_nCurrX;
   g_nMDlgY := g_MySelf.m_nCurrY;

   if g_nCurMerchant <> merchant then begin
      g_nCurMerchant := merchant;
      FrmDlg.ResetMenuDlg;
      FrmDlg.CloseMDlg;
   end;
   saying := GetValidStr3 (saying, npcname, ['/']);
   FrmDlg.ShowMDlg (face, npcname, saying);
end;

//接收到的商人出售商品的列表
procedure TfrmMain.ClientGetSendGoodsList (merchant, count: integer; body: string);
var
   gname, gsub, gprice, gstock: string;
   pcg: PTClientGoods;
begin
   FrmDlg.ResetMenuDlg;
   g_nCurMerchant := merchant;
   with FrmDlg do begin
      body := DecodeString (body);
      while body <> '' do begin
         body := GetValidStr3 (body, gname, ['/']);
         body := GetValidStr3 (body, gsub, ['/']);
         body := GetValidStr3 (body, gprice, ['/']);
         body := GetValidStr3 (body, gstock, ['/']);
         if (gname <> '') and (gprice <> '') and (gstock <> '') then begin
            new (pcg);
            pcg.Name := gname;                      //商品名称
            pcg.SubMenu := Str_ToInt (gsub, 0);     //子菜单
            pcg.Price := Str_ToInt (gprice, 0);     //价格
            pcg.Stock := Str_ToInt (gstock, 0);     //数量
            pcg.Grade := -1;                        //等级
            MenuList.Add (pcg);
         end else
            break;
      end;
      FrmDlg.ShowShopMenuDlg;
      FrmDlg.CurDetailItem := '';
   end;
end;

procedure TfrmMain.ClientGetSendMakeDrugList (merchant: integer; body: string);
var
   gname, gsub, gprice, gstock: string;
   pcg: PTClientGoods;
begin
   FrmDlg.ResetMenuDlg;

   g_nCurMerchant := merchant;
   with FrmDlg do begin
      body := DecodeString (body);
      while body <> '' do begin
         body := GetValidStr3 (body, gname, ['/']);
         body := GetValidStr3 (body, gsub, ['/']);
         body := GetValidStr3 (body, gprice, ['/']);
         body := GetValidStr3 (body, gstock, ['/']);
         if (gname <> '') and (gprice <> '') and (gstock <> '') then begin
            new (pcg);
            pcg.Name := gname;
            pcg.SubMenu := Str_ToInt (gsub, 0);
            pcg.Price := Str_ToInt (gprice, 0);
            pcg.Stock := Str_ToInt (gstock, 0);
            pcg.Grade := -1;
            MenuList.Add (pcg);
         end else
            break;
      end;
      FrmDlg.ShowShopMenuDlg;
      FrmDlg.CurDetailItem := '';
      FrmDlg.BoMakeDrugMenu := TRUE;
   end;
end;


procedure TfrmMain.ClientGetSendUserSell (merchant: integer);
begin
   FrmDlg.CloseDSellDlg;
   g_nCurMerchant := merchant;
   FrmDlg.SpotDlgMode := dmSell;
   FrmDlg.ShowShopSellDlg;
end;

procedure TfrmMain.ClientGetSendUserRepair (merchant: integer);
begin
   FrmDlg.CloseDSellDlg;
   g_nCurMerchant := merchant;
   FrmDlg.SpotDlgMode := dmRepair;
   FrmDlg.ShowShopSellDlg;
end;

procedure TfrmMain.ClientGetSendUserStorage (merchant: integer);
begin
   FrmDlg.CloseDSellDlg;
   g_nCurMerchant := merchant;
   FrmDlg.SpotDlgMode := dmStorage;
   FrmDlg.ShowShopSellDlg;
end;


procedure TfrmMain.ClientGetSaveItemList (merchant: integer; bodystr: string);
var
   i: integer;
   data: string;
   pc: PTClientItem;
   pcg: PTClientGoods;
begin
   FrmDlg.ResetMenuDlg;
   if g_SaveItemList.Count > 0 then //20080629
   for i:=0 to g_SaveItemList.Count-1 do
      Dispose(PTClientItem(g_SaveItemList[i]));
   g_SaveItemList.Clear;
   while TRUE do begin
      if bodystr = '' then break;
      bodystr := GetValidStr3 (bodystr, data, ['/']);
      if data <> '' then begin
         new (pc);
         DecodeBuffer (data, @(pc^), sizeof(TClientItem));
         g_SaveItemList.Add (pc);
      end else
         break;
   end;
   g_nCurMerchant := merchant;
   with FrmDlg do begin
      //deocde body received from server
      if g_SaveItemList.Count > 0 then //20080629
      for i:=0 to g_SaveItemList.Count-1 do begin
         new (pcg);
         pcg.Name := PTClientItem(g_SaveItemList[i]).S.Name;
         pcg.SubMenu := 0;
         pcg.Price := PTClientItem(g_SaveItemList[i]).MakeIndex;
         pcg.Stock := Round(PTClientItem(g_SaveItemList[i]).Dura / 1000);
         pcg.Grade := Round(PTClientItem(g_SaveItemList[i]).DuraMax / 1000);
         MenuList.Add (pcg);
      end;
      FrmDlg.ShowShopMenuDlg;
      FrmDlg.BoStorageMenu := TRUE;
   end;
end;

procedure TfrmMain.ClientGetSendDetailGoodsList (merchant, count, topline: integer; bodystr: string);
var
   i: integer;
   data: string;
   pcg: PTClientGoods;
   pc: PTClientItem;
begin
   FrmDlg.ResetMenuDlg;
   g_nCurMerchant := merchant;
   bodystr := DecodeString(bodystr);
   while TRUE do begin
      if bodystr = '' then break;
      bodystr := GetValidStr3 (bodystr, data, ['/']);
      if data <> '' then begin
         new (pc);
         DecodeBuffer (data, @(pc^), sizeof(TClientItem));
         g_MenuItemList.Add (pc);
      end else
         break;
   end;
   with FrmDlg do begin
      if g_MenuItemList.Count > 0 then //20080629
      for i:=0 to g_MenuItemList.Count-1 do begin
         new (pcg);
         pcg.Name := PTClientItem(g_MenuItemList[i]).S.Name;
         pcg.SubMenu := 0;
         pcg.Price := PTClientItem(g_MenuItemList[i]).DuraMax;
         pcg.Stock := PTClientItem(g_MenuItemList[i]).MakeIndex;
         pcg.Grade := Round(PTClientItem(g_MenuItemList[i]).Dura/1000);
         MenuList.Add (pcg);
      end;
      FrmDlg.ShowShopMenuDlg;
      FrmDlg.BoDetailMenu := TRUE;
      FrmDlg.MenuTopLine := topline;
   end;
end;

procedure TfrmMain.ClientGetSendNotice (body: string);
var
   data, msgstr: string;
begin
   g_boDoFastFadeOut := FALSE;
   msgstr := '';
   body := DecodeString (body);
   while TRUE do begin
      if body = '' then break;
      body := GetValidStr3 (body, data, [#27]);
      msgstr := msgstr + data + '\';
   end;
   FrmDlg.DialogSize := 2;
   if FrmDlg.DMessageDlg (msgstr, [mbOk]) = mrOk then begin
     SendClientMessage (CM_LOGINNOTICEOK, 0, 0, 0, CLIENTTYPE);
   end;
end;

procedure TfrmMain.ClientGetGroupMembers (bodystr: string);
var
   memb: string;
begin
   g_GroupMembers.Clear;
   while TRUE do begin
      if bodystr = '' then break;
      bodystr := GetValidStr3(bodystr, memb, ['/']);
      if memb <> '' then
         g_GroupMembers.Add (memb)
      else
         break;
   end;
end;

procedure TfrmMain.ClientGetOpenGuildDlg (bodystr: string);
var
   str, data, linestr, s1: string;
   pstep: integer;
begin
   str := DecodeString (bodystr);
   str := GetValidStr3 (str, FrmDlg.Guild, [#13]);
   str := GetValidStr3 (str, FrmDlg.GuildFlag, [#13]);
   str := GetValidStr3 (str, data, [#13]);
   if data = '1' then FrmDlg.GuildCommanderMode := TRUE
   else FrmDlg.GuildCommanderMode := FALSE;

   FrmDlg.GuildStrs.Clear;
   FrmDlg.GuildNotice.Clear;
   pstep := 0;
   while TRUE do begin
      if str = '' then break;
      str := GetValidStr3 (str, data, [#13]);
      if data = '<Notice>' then begin
         FrmDlg.GuildStrs.AddObject (char(7) + '公告', TObject(clWhite));
         FrmDlg.GuildStrs.Add (' ');
         pstep := 1;
         continue;
      end;
      if data = '<KillGuilds>' then begin
         FrmDlg.GuildStrs.Add (' ');
         FrmDlg.GuildStrs.AddObject (char(7) + '敌对行会', TObject(clWhite));
         FrmDlg.GuildStrs.Add (' ');
         pstep := 2;
         linestr := '';
         continue;
      end;
      if data = '<AllyGuilds>' then begin
         if linestr <> '' then FrmDlg.GuildStrs.Add (linestr);
         linestr := '';
         FrmDlg.GuildStrs.Add (' ');
         FrmDlg.GuildStrs.AddObject (char(7) + '联盟行会', TObject(clWhite));
         FrmDlg.GuildStrs.Add (' ');
         pstep := 3;
         continue;
      end;
      if pstep = 1 then
         FrmDlg.GuildNotice.Add (data);
      if data <> '' then begin
         if data[1] = '<' then begin
            ArrestStringEx (data, '<', '>', s1);
            if s1 <> '' then begin
               FrmDlg.GuildStrs.Add (' ');
               FrmDlg.GuildStrs.AddObject (char(7) + s1, TObject(clWhite));
               FrmDlg.GuildStrs.Add (' ');
               continue;
            end;
         end;
      end;
      if (pstep = 2) or (pstep = 3) then begin
         if Length(linestr) > 80 then begin
            FrmDlg.GuildStrs.Add (linestr);
            linestr := '';
         end else
            linestr := linestr + fmstr (data, 18);
         continue;
      end;
      FrmDlg.GuildStrs.Add (data);
   end;
   if linestr <> '' then FrmDlg.GuildStrs.Add (linestr);
   FrmDlg.ShowGuildDlg;
end;

procedure TfrmMain.ClientGetSendGuildMemberList (body: string);
var
   str, data, rankname, members: string;
   rank: integer;
begin
   str := DecodeString (body);
   FrmDlg.GuildStrs.Clear;
   FrmDlg.GuildMembers.Clear;
   rank := 0;
   while TRUE do begin
      if str = '' then break;
      str := GetValidStr3 (str, data, ['/']);
      if data <> '' then begin
         if data[1] = '#' then begin
            rank := Str_ToInt (Copy(data, 2, Length(data)-1), 0);
            continue;
         end;
         if data[1] = '*' then begin
            if members <> '' then FrmDlg.GuildStrs.Add (members);
            rankname := Copy(data, 2, Length(data)-1);
            members := '';
            FrmDlg.GuildStrs.Add (' ');
            if FrmDlg.GuildCommanderMode then
               FrmDlg.GuildStrs.AddObject (fmStr('(' + IntToStr(rank) + ')', 3) + '<' + rankname + '>', TObject(clWhite))
            else
               FrmDlg.GuildStrs.AddObject ('<' + rankname + '>', TObject(clWhite));
            FrmDlg.GuildMembers.Add ('#' + IntToStr(rank) + ' <' + rankname + '>');
            continue;
         end;
         if Length (members) > 80 then begin
            FrmDlg.GuildStrs.Add (members);
            members := '';
         end;
         members := members + FmStr(data, 18);
         FrmDlg.GuildMembers.Add (data);
      end;
   end;
   if members <> '' then
      FrmDlg.GuildStrs.Add (members);
end;

procedure TfrmMain.MinTimerTimer(Sender: TObject);
var
   i: integer;
begin
  {$if Version <> 0}
  if FindWindow('TFrmMain','传奇登陆器 bY 56M2'){查找是否有此类的窗体} = 0 then begin{不为0则程序已运行}
    //Close;
  end;
  {$IFEND}
//自动喊话
 if g_boAutoTalk then begin
   if (GetTickCount - g_nAutoTalkTimer ) > 10000 then begin
     SendSay(g_sAutoTalkStr);
     g_nAutoTalkTimer := GetTickCount;
   end;
 end;

//自动喊话结束
   //检查所有玩家看是否和本玩家是一组
  { 20080820注释  上线已经自动关组了 
   with PlayScene do begin
      if m_ActorList = nil then Exit;  //20080528 防止机器没装声卡报错问题
      if m_ActorList.Count > 0 then //20080629
      for i:=0 to m_ActorList.Count-1 do begin
         if IsGroupMember (TActor (m_ActorList[i]).m_sUserName) then begin
            TActor (m_ActorList[i]).m_boGrouped := TRUE;
         end else
            TActor (m_ActorList[i]).m_boGrouped := FALSE;
      end;
   end; }
   if g_FreeActorList <> nil then begin
     if g_FreeActorList.Count > 0 then begin//20080629
       for i:=g_FreeActorList.Count-1 downto 0 do begin
          if GetTickCount - TActor(g_FreeActorList[i]).m_dwDeleteTime > 60000 then begin
             TActor(g_FreeActorList[i]).Free;
             g_FreeActorList.Delete (i);
          end;
       end;
     end;
   end;
end;

procedure TfrmMain.ClientGetDealRemoteAddItem (body: string);
var
   ci: TClientItem;
begin
   if body <> '' then begin
      DecodeBuffer (body, @ci, sizeof(TClientItem));
      AddDealRemoteItem (ci);
   end;
end;

procedure TfrmMain.ClientGetDealRemoteDelItem (body: string);
var
   ci: TClientItem;
begin
   if body <> '' then begin
      DecodeBuffer (body, @ci, sizeof(TClientItem));
      DelDealRemoteItem (ci);
   end;
end;

procedure TfrmMain.ClientGetReadMiniMap (mapindex: integer);
begin
  if mapindex >= 1 then begin
    g_boViewMiniMap := TRUE;
    FrmDlg.DWMiniMap.Visible := True; //20080323
    g_nMiniMapIndex := mapindex - 1;
  end;
end;

procedure TfrmMain.ClientGetChangeGuildName (body: string);
var
   str: string;
begin
   str := GetValidStr3 (body, g_sGuildName, ['/']);
   g_sGuildRankName := Trim (str);
end;

procedure TfrmMain.ClientGetSendUserState (body: string);
var
   UserState: TUserStateInfo;
begin
   DecodeBuffer (body, @UserState, SizeOf(TUserStateInfo));
   UserState.NameColor := GetRGB(UserState.NameColor);
   FrmDlg.OpenUserState(UserState);
end;

procedure TfrmMain.DrawEffectHum(nType, nX, nY: Integer);
var
  Effect :TNormalDrawEffect;
  bo15   :Boolean;
begin
  Effect:=nil;
  case nType of
    0: begin
    end;
    1: Effect:=TNormalDrawEffect.Create(nX,nY,{WMon14Img20080720注释}g_WMonImagesArr[13],410,6,120,False);
    2: Effect:=TNormalDrawEffect.Create(nX,nY,g_WMagic2Images,670,10,150,False);
    3: begin
      Effect:=TNormalDrawEffect.Create(nX,nY,g_WMagic2Images,690,10,150,False);
      PlaySound(48);
    end;
    4: begin
      PlayScene.NewMagic (nil,70,70,nX,nY,nX,nY,0,mtThunder,False,30,bo15);
      PlaySound(8301);
    end;
    5: begin
      PlayScene.NewMagic (nil,71,71,nX,nY,nX,nY,0,mtThunder,False,30,bo15);
      PlayScene.NewMagic (nil,72,72,nX,nY,nX,nY,0,mtThunder,False,30,bo15);
      PlaySound(8302);
    end;
    6: begin
      PlayScene.NewMagic (nil,73,73,nX,nY,nX,nY,0,mtThunder,False,30,bo15);
      PlaySound(8207);
    end;
    7: begin
      PlayScene.NewMagic (nil,74,74,nX,nY,nX,nY,0,mtThunder,False,30,bo15);
      PlaySound(8226);
    end;
    10: begin  //红闪电
      PlayScene.NewMagic (nil,80,80,nx,ny,nx,ny,0,mtRedThunder,False,30,bo15);
      PlaySound(8301);
    end;
    11: begin  //岩浆
      PlayScene.NewMagic (nil,91,91,nx,ny,nx,ny,0,mtLava,False,30,bo15);
      PlaySound(8302);
    end;
    12: begin  //火龙守护兽发出的魔法效果
      PlayScene.NewMagic (nil,92,92,nx,ny,nx,ny,0,mtLava,False,30,bo15);
    end;
  end;

  if Effect <> nil then begin
    Effect.MagOwner:=g_MySelf;
    PlayScene.m_EffectList.Add(Effect);
  end;
end;
//2004/05/17
procedure TfrmMain.SelectChr(sChrName: String);
begin
  PlayScene.EdChrNamet.Text:=sChrName;
end; 
//2004/05/17


function TfrmMain.GetWStateImg(Idx:Integer;var ax,ay:integer): TDirectDrawSurface;
begin
  Result:=nil;
  if Idx < 10000 then begin
    Result:=g_WStateItemImages.GetCachedImage(idx,ax,ay);
    exit;
  end;
 { if ItemImageList.Count > 0 then //20080629
  for I := 0 to ItemImageList.Count - 1 do begin
    WMImage:=TWMImages(ItemImageList.Items[I]);
    if WMImage.Appr = FileIdx then begin
      Result:=WMImage.GetCachedImage(Idx - FileIdx * 10000,ax,ay);
      exit;
    end;
  end;
  //20080910注释  没地方用到
 { FileName:=ItemImageDir + 'St' + IntToStr(FileIdx) + '.wil';
  if FileExists(FileName) then begin
    WMImage:=TWMImages.Create(nil);
    WMImage.FileName:=FileName;
    WMImage.LibType:=ltUseCache;
    WMImage.DDraw:=DXDraw.DDraw;
    WMImage.Appr:=FileIdx;
    WMImage.Initialize;
    ItemImageList.Add(WMImage);
    Result:=WMImage.GetCachedImage(Idx - FileIdx * 10000,ax,ay);
  end;  }
end;

function TfrmMain.GetWStateImg(Idx: Integer): TDirectDrawSurface;
begin
  Result:=nil;
  if Idx < 10000 then begin
    Result:=g_WStateItemImages.Images[idx];
    exit;
  end;
  //FileIdx:=Idx div 10000;
  {if ItemImageList.Count > 0 then //20080629
  for I := 0 to ItemImageList.Count - 1 do begin
    WMImage:=TWMImages(ItemImageList.Items[I]);
    if WMImage.Appr = FileIdx then begin
      Result:=WMImage.Images[Idx - FileIdx * 10000]; //取物品所在IDX位置
      exit;
    end;      
  end;
  //20080910注释  没地方用到
  {FileName:=ItemImageDir + 'St' + IntToStr(FileIdx) + '.wil';
  if FileExists(FileName) then begin
    WMImage:=TWMImages.Create(nil);
    WMImage.FileName:=FileName;
    WMImage.LibType:=ltUseCache;
    WMImage.DDraw:=DXDraw.DDraw;
    WMImage.Appr:=FileIdx;
    WMImage.Initialize;
    ItemImageList.Add(WMImage);
    Result:=WMImage.Images[Idx - FileIdx * 10000]; //取物品所在IDX位置
  end;  }
end;
function TfrmMain.GetWWeaponImg(Weapon,m_btSex,nFrame:Integer;var ax,ay:integer): TDirectDrawSurface;
var
  FileIdx:Integer;
begin
  Result:=nil;
  //FileIdx:=(Weapon - m_btSex) div 2;

  if Weapon > 199 then begin
    FileIdx:=(Weapon - 200 - m_btSex) div 2;
    if (FileIdx < 100) then begin
      Result:=g_WWeapon2Images.GetCachedImage(HUMANFRAME * (Weapon - 202) + nFrame,ax,ay);
      exit;
    end;
  end else begin
    FileIdx:=(Weapon - m_btSex) div 2;
    if (FileIdx < 100) then begin
      Result:=g_WWeaponImages.GetCachedImage(HUMANFRAME * Weapon + nFrame,ax,ay);
      exit;
    end;
  end;
  {
  if (FileIdx < 100) then begin
    Result:=g_WWeaponImages.GetCachedImage(HUMANFRAME * Weapon + nFrame,ax,ay);
    exit;
  end; }

  {if WeaponImageList.Count > 0 then //20080629
  for I := 0 to WeaponImageList.Count - 1 do begin
    WMImage:=TWMImages(WeaponImageList.Items[I]);
    if WMImage.Appr = FileIdx then begin
      Result:=WMImage.GetCachedImage(HUMANFRAME * m_btSex + nFrame,ax,ay);
      exit;
    end;
  end;
  //20080910注释  没地方用到
  {FileName:=WeaponImageDir + IntToStr(FileIdx) + '.wil';
  if FileExists(FileName) then begin
    WMImage:=TWMImages.Create(nil);
    WMImage.FileName:=FileName;
    WMImage.LibType:=ltUseCache;
    WMImage.DDraw:=DXDraw.DDraw;
    WMImage.Appr:=FileIdx;
    WMImage.Initialize;
    WeaponImageList.Add(WMImage);
    Result:=WMImage.GetCachedImage(HUMANFRAME * m_btSex + nFrame,ax,ay);
  end; }
end;

function TfrmMain.GetWHumImg(Dress,m_btSex,nFrame:Integer;var ax,ay:integer): TDirectDrawSurface;
var
  FileIdx:Integer;
begin
  Result:=nil;

  //if (FileIdx > 50) then begin
  if Dress > 99 then begin
    FileIdx:=(Dress - 100 - m_btSex) div 2;
    if (FileIdx < 50) then begin
      Result:=g_WHum2ImgImages.GetCachedImage(HUMANFRAME * (Dress - 102) + nFrame,ax,ay);
      exit;
    end;
  end else begin
    FileIdx:=(Dress - m_btSex) div 2;
    if (FileIdx < 50) then begin
      Result:=g_WHumImgImages.GetCachedImage(HUMANFRAME * Dress + nFrame,ax,ay);
      exit;
    end;
  end;
end;

procedure TfrmMain.ClientGetNeedPassword(Body: String);
begin
  FrmDlg.DChgGamePwd.Visible:=True;
end;

procedure TfrmMain.SendPassword(sPassword: String;nIdent:Integer);
var
  DefMsg:TDefaultMessage;
begin
   DefMsg:=MakeDefaultMsg (CM_PASSWORD,0,nIdent,0,0, Certification);
   SendSocket (EncodeMessage(DefMsg) + EncodeString(sPassword));
end;

procedure TfrmMain.SetInputStatus;
begin
  if m_boPasswordIntputStatus then begin
    m_boPasswordIntputStatus:=False;
    PlayScene.EdChat.PasswordChar:=#0;
    PlayScene.EdChat.Visible:=False;
  end else begin
    m_boPasswordIntputStatus:=True;
    PlayScene.EdChat.PasswordChar:='*';
    PlayScene.EdChat.Visible:=True;
    PlayScene.EdChat.SetFocus;
  end;
end;

procedure TfrmMain.ClientGetServerConfig(Msg: TDefaultMessage;sBody: String);
var
  sBody1: string;
begin
  g_DeathColorEffect:=TColorEffect( _MIN(LoByte(msg.Param),8) );  //屏幕死亡颜色
  
  //g_boCanRunHuman:=LoByte(LoWord(msg.Recog)) = 1;
  //g_boCanRunMon:=HiByte(LoWord(msg.Recog)) = 1;
  //g_boCanRunNpc:=LoByte(HiWord(msg.Recog)) = 1;
  //g_boCanRunAllInWarZone:=HiByte(HiWord(msg.Recog)) = 1;
  sBody1:=DecodeString(sBody);
  DecodeBuffer(sBody1,@ClientConf,SizeOf(ClientConf));
  {g_boCanRunHuman        :=ClientConf.boRunHuman; //穿人
  g_boCanRunMon          :=ClientConf.boRunMon; //穿怪
  g_boCanRunNpc          :=ClientConf.boRunNpc; //穿NPC }
  g_boCanRunAllInWarZone :=ClientConf.boWarRunAll;//攻城区域是否传人穿怪穿NPC

  //g_DeathColorEffect     :=TColorEffect(_MIN(8,ClientConf.btDieColor));
  g_nHitTime             :=ClientConf.wHitIime;
  g_dwSpellTime          :=ClientConf.wSpellTime;
  //g_nItemSpeed           :=ClientConf.btItemSpeed;
  //g_boCanStartRun        :=ClientConf.boCanStartRun;
  //g_boParalyCanRun       :=ClientConf.boParalyCanRun;
  //g_boParalyCanWalk      :=ClientConf.boParalyCanWalk;
  //g_boParalyCanHit       :=ClientConf.boParalyCanHit;
  //g_boParalyCanSpell     :=ClientConf.boParalyCanSpell;
  //g_boShowRedHPLable     :=ClientConf.boShowRedHPLable;
  //g_boShowHPNumber       :=ClientConf.boShowHPNumber;
  //g_boShowJobLevel       :=ClientConf.boShowJobLevel;
  //g_boDuraAlert          :=ClientConf.boDuraAlert;
  //g_boMagicLock          :=ClientConf.boMagicLock;
  //g_boAutoPuckUpItem     :=ClientConf.boAutoPuckUpItem;
  //case ClientConf.nClientWgInfo of
    //1:begin//盛大挂
      //g_boCanRunHuman:=LoByte(LoWord(msg.Recog)) = 1;
      //g_boCanRunMon:=HiByte(LoWord(msg.Recog)) = 1;
      //g_boCanRunNpc:=LoByte(HiWord(msg.Recog)) = 1;
      //g_boCanRunAllInWarZone:=HiByte(HiWord(msg.Recog)) = 1;
      if ClientConf.boSkill31Effect then g_boSkill31Effect := True else g_boSkill31Effect := False;
      if ClientConf.boRUNHUMAN then g_boCanRunHuman := True else g_boCanRunHuman := False;
      if ClientConf.boRUNMON then g_boCanRunMon := True else g_boCanRunMon := False;
      if ClientConf.boRunNpc then g_boCanRunNpc := True else g_boCanRunNpc := False;
      //g_boForceNotViewFog := False; 20080816注释免蜡
      {if ClientConf.boMagicLock theboForceNotViewFogn }g_boMagicLock := True;// else g_boMagicLock := False;
      if not g_boLoadSdoAssistantConfig then begin
        LoadSdoAssistantConfig(CharName); //读取盛大挂配置
        LoadUserFilterConfig();  //读取盛大挂过滤文件
        CreateSdoAssistant();//初始化
      end;
    //end;
  //end;
end;

procedure TfrmMain.ClientGetServerUnBind(Body: String);
var
   i: integer;
   data: string;
   pcm: pTUnbindInfo;
begin
   if g_UnBindList.Count > 0 then //20080629
   for i:=0 to g_UnBindList.Count-1 do
     if pTUnbindInfo(g_UnBindList[i]) <> nil then
      Dispose (pTUnbindInfo(g_UnBindList[i]));
   g_UnBindList.Clear;
   while TRUE do begin
      if body = '' then break;
      body := GetValidStr3 (body, data, ['/']);
      if data <> '' then begin
         new (pcm);
         DecodeBuffer (data, @(pcm^), sizeof(TUnbindInfo));
         g_UnBindList.Add (pcm);
      end else
         break;
   end;
end;



{ 20080723注释
procedure TfrmMain.ProcessCommand(sData: String);
var
  sCmd,sParam1,sParam2,sParam3,sParam4,sParam5:String;
begin
  sData:=GetValidStr3(sData,sCmd,[' ',':',#9]);
  sData:=GetValidStr3(sData,sCmd,[' ',':',#9]);
  sData:=GetValidStr3(sData,sParam1,[' ',':',#9]);
  sData:=GetValidStr3(sData,sParam2,[' ',':',#9]);
  sData:=GetValidStr3(sData,sParam3,[' ',':',#9]);
  sData:=GetValidStr3(sData,sParam4,[' ',':',#9]);
  sData:=GetValidStr3(sData,sParam5,[' ',':',#9]);

  if CompareText(sCmd,'ShowHumanMsg') = 0 then begin
    CmdShowHumanMsg(sParam1,sParam2,sParam3,sParam4,sParam5);
    exit;
  end;
end; }
{ 20080723注释
procedure TfrmMain.CmdShowHumanMsg(sParam1,sParam2,sParam3,sParam4,sParam5: String);
var
  sHumanName:String;
begin
  sHumanName:=sParam1;
  if (sHumanName <> '') and (sHumanName[1] = 'C') then begin
    PlayScene.MemoLog.Clear;
    exit;
  end;

  if sHumanName <> '' then begin
    ShowMsgActor:=PlayScene.FindActor(sHumanName);  
    if ShowMsgActor = nil then begin
      DScreen.AddChatBoardString(format('%s没找到！！！',[sHumanName]),clWhite,clRed);
      exit;
    end;
  end;
  g_boShowMemoLog:=not g_boShowMemoLog;
  PlayScene.MemoLog.Clear;
  PlayScene.MemoLog.Visible:=g_boShowMemoLog;
end;  }

(*
20080723注释
procedure TfrmMain.ShowHumanMsg(Msg:pTDefaultMessage);
  function GetIdent(nIdent:Integer):String;
  begin
    case nIdent of  
      SM_RUSH       : Result:='SM_RUSH';
      SM_RUSHKUNG   : Result:='SM_RUSHKUNG';
      SM_FIREHIT    : Result:='SM_FIREHIT';
      SM_4FIREHIT   : Result:='SM_4FIREHIT';
      SM_DAILY      : Result:='SM_DAILY'; //20080511
      SM_BACKSTEP   : Result:='SM_BACKSTEP';
      SM_TURN       : Result:='SM_TURN';
      SM_WALK       : Result:='SM_WALK';
      SM_SITDOWN    : Result:='SM_SITDOWN';
      SM_RUN        : Result:='SM_RUN';
      SM_HIT        : Result:='SM_HIT';
      SM_PIXINGHIT  : Result:='SM_PIXINGHIT';//劈星 20080611
      SM_LEITINGHIT : Result:='SM_LEITINGHIT'; //雷霆一击战士效果 20080611
      SM_HEAVYHIT   : Result:='SM_HEAVYHIT';
      SM_BIGHIT     : Result:='SM_BIGHIT';
      SM_SPELL      : Result:='SM_SPELL';
      SM_POWERHIT   : Result:='SM_POWERHIT';
      SM_LONGHIT    : Result:='SM_LONGHIT';
      SM_DIGUP      : Result:='SM_DIGUP';
      SM_DIGDOWN    : Result:='SM_DIGDOWN';
      SM_FLYAXE     : Result:='SM_FLYAXE';
      SM_LIGHTING   : Result:='SM_LIGHTING';
      SM_WIDEHIT    : Result:='SM_WIDEHIT';
      SM_ALIVE      : Result:='SM_ALIVE';
      SM_MOVEFAIL   : Result:='SM_MOVEFAIL';
      SM_HIDE       : Result:='SM_HIDE';
      SM_DISAPPEAR  : Result:='SM_DISAPPEAR';
      SM_STRUCK     : Result:='SM_STRUCK';
      SM_DEATH      : Result:='SM_DEATH';
      SM_SKELETON   : Result:='SM_SKELETON';
      SM_NOWDEATH   : Result:='SM_NOWDEATH';
      SM_CRSHIT     : Result:='SM_CRSHIT';
      SM_TWINHIT    : Result:='SM_TWINHIT';//开天斩重击
      SM_QTWINHIT   : Result:='SM_QTWINHIT';//开天斩轻击
      SM_CIDHIT     : Result:='SM_CIDHIT';//龙影剑法
      SM_HEAR           : Result:='SM_HEAR';
      SM_FEATURECHANGED : Result:='SM_FEATURECHANGED';
      SM_USERNAME          : Result:='SM_USERNAME';
      SM_WINEXP            : Result:='SM_WINEXP';
      SM_LEVELUP           : Result:='SM_LEVELUP';
      SM_DAYCHANGING       : Result:='SM_DAYCHANGING';
      SM_ITEMSHOW          : Result:='SM_ITEMSHOW';
      SM_ITEMHIDE          : Result:='SM_ITEMHIDE';
      SM_MAGICFIRE         : Result:='SM_MAGICFIRE';
      SM_CHANGENAMECOLOR   : Result:='SM_CHANGENAMECOLOR';
      SM_CHARSTATUSCHANGED : Result:='SM_CHARSTATUSCHANGED';

      SM_SPACEMOVE_HIDE    : Result:='SM_SPACEMOVE_HIDE';
      SM_SPACEMOVE_SHOW    : Result:='SM_SPACEMOVE_SHOW';
      SM_SHOWEVENT         : Result:='SM_SHOWEVENT';
      SM_HIDEEVENT         : Result:='SM_HIDEEVENT';
      else Result:=IntToStr(nIdent);
    end;
  end;
begin
  {if (ShowMsgActor = nil) or (ShowMsgActor <> nil) and (ShowMsgActor.m_nRecogId = Msg.Recog) then begin
    sLineText:=format('ID:%d Ident:%s',[Msg.Recog,GetIdent(Msg.Ident)]);
    PlayScene.MemoLog.Lines.Add(sLineText);

  end;}

end;
*)
procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  pm: PTClientMagic;
begin
  case Key of
      VK_ESCAPE: begin//ESC        20080314
      g_boDownEsc := False;    //松开ESC键
      g_boShowAllItem := g_boTempShowItem;
      g_boFilterAutoItemShow := g_boTempFilterItemShow;
    end;
  end;

  if (Key >= 112) and (Key < 119) and g_boAutoMagic then begin
      pm:=GetMagicByKey(char(key-Vk_F1 + byte('1')));
      //自动练功
      if pm.Def.wMagicId in [12,25] then Exit;
      g_nAutoMAgicKey := Key;
      DScreen.AddChatBoardString('自动练功开始 (再按一下这个魔法的快捷健停止自动练功)', clGreen, clWhite);
    //end;
    //AutoMagicTimeup := False;
  end;
end;
{******************************************************************************}
//自动换毒  20080315
procedure TFrmMain.TurnDuFu(pcm: PTClientMagic);
var
  s: TClientItem;
  Str,str1: string;
  i,index: Integer;
begin
//自动毒符
if g_WaitingUseItem.Item.s.Name<>'' then exit;
  index:=U_BUJUK;
  s := g_UseItems[Index];
    if pcm.Def.wMagicId = 6 then begin
      Str := '药';
      if g_nDuwhich=0 then begin
        str1:='黄';
        g_nDuwhich:=1;
      end else begin
        str1:='灰';
        g_nDuwhich:=0;
      end
    end else Exit;
  if (s.s.StdMode = 25) and (Pos(Str1, s.s.Name) > 0) then Exit; //如果是相同的毒或符就退出
  if (g_UseItems[U_ARMRINGL].s.StdMode = 25) and (Pos(Str, g_UseItems[U_ARMRINGL].s.Name) > 0) then begin
    SendTakeOffItem (U_ARMRINGL, g_UseItems[U_ARMRINGL].MakeIndex, g_UseItems[U_ARMRINGL].S.Name);
    g_WaitingUseItem.Item := g_UseItems[U_ARMRINGL];
    g_UseItems[U_ARMRINGL].s.Name := '';
    ArrangeItembag;
  end;
    g_WaitingUseItem.Index := index;

  for i := 6 to MAXBAGITEMCL - 1 do begin
    if (g_ItemArr[i].s.StdMode = 25) and (Pos(Str, g_ItemArr[i].s.Name) > 0)and (Pos(Str1, g_ItemArr[i].s.Name) > 0) then
    begin
      SendTakeOnItem(g_WaitingUseItem.Index ,g_ItemArr[i].MakeIndex, g_ItemArr[i].s.Name);
      g_WaitingUseItem.Item := g_ItemArr[i];
      g_ItemArr[i].s.Name := '';
      ArrangeItembag;
      Exit;
    end;
  end;
end;
{******************************************************************************}
//拦截TAB键 消息  20080314
procedure TfrmMain.CMDialogKey(var msg: TCMDialogKey);
begin
    if g_MySelf = nil then inherited
    else
    if msg.Charcode <> VK_TAB then
    inherited;
end;

//元宝寄售显示窗口 20080316
procedure TfrmMain.ClientGetSendUserSellOff (merchant: integer);
begin
   FrmDlg.CloseMDlg;
   g_nCurMerchant := merchant;
   FrmDlg.ShowShopSellOffDlg;
end;
//客户端寄售查询购买物品 20080317
procedure TfrmMain.ClientGetSellOffMyItem (body: string);
begin
  FillChar (g_SellOffInfo, sizeof(TClientDealOffInfo), #0); //清空寄售列表物品 20080318
  DecodeBuffer (body, @g_SellOffInfo, sizeof(TClientDealOffInfo));
  FrmDlg.ShowSellOffListDlg;
  FrmDlg.DSellOffBuyCancel.Visible := True;
  FrmDlg.DSellOffBuy.Visible := True;
end;
//客户端寄售查询出售物品 20080317
procedure TfrmMain.ClientGetSellOffSellItem (body: string);
begin
  FillChar (g_SellOffInfo, sizeof(TClientDealOffInfo), #0); //清空寄售列表物品 20080318
  DecodeBuffer (body, @g_SellOffInfo, sizeof(TClientDealOffInfo));
  FrmDlg.ShowSellOffListDlg;
  FrmDlg.DSellOffListCancel.Visible := True;
end;
{******************************************************************************}

procedure TfrmMain.SendItemUpOK();
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_REFINEITEM, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (IntToStr(g_ItemsUpItem[0].MakeIndex) + '/' + IntToStr(g_ItemsUpItem[1].MakeIndex) + '/' + IntToStr(g_ItemsUpItem[2].MakeIndex)));
end;
//更新粹练物品! 20080507
procedure TfrmMain.ClientGetUpDateUpItem (body: string);
var
  cu: TClientItem;
  I: Integer;
  str: string;
begin
  FillChar (g_ItemsUpItem, sizeof(TClientItem)*3, #0); //清空淬炼格里的物品
  while TRUE do begin
    if body = '' then break;
    for I:=Low(g_ItemsUpItem) to High(g_ItemsUpItem) do begin
      body := GetValidStr3 (body, str, ['/']);
      DecodeBuffer (str, @cu, sizeof(TClientItem));
      g_ItemsUpItem[I] := cu;
    end;
  end;
end;
{******************************************************************************}
procedure TfrmMain.ClientGetHeroInfo(body: string);
var
  cu: THeroDataInfo;
  I: Integer;
  str: string;
begin
  FillChar (g_GetHeroData, sizeof(THeroDataInfo)*2,#0);  //20080514
  while TRUE do begin
    if body = '' then break;
    for I:=Low(g_GetHeroData) to High(g_GetHeroData) do begin
      body := GetValidStr3 (body, str, ['/']);
      DecodeBuffer (str, @cu, sizeof(THeroDataInfo));
      g_GetHeroData[I] := cu;
    end;
  end;
end;
//发送取回英雄信息 发送到M2 20080514
procedure TfrmMain.SendSelHeroName(btType: Byte;SelHeroName: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_SELGETHERO, btType, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString(SelHeroName));
end;
//请酒
procedure TfrmMain.ClientGetSendUserPlayDrink(merchant: integer);
begin
   FrmDlg.CloseDSellDlg;
   g_nCurMerchant := merchant;
   FrmDlg.SpotDlgMode := dmPlayDrink;
   FrmDlg.ShowShopSellDlg;
end;

//发送要存放的物品
procedure TfrmMain.SendPlayDrinkItem (merchant, itemindex: integer; itemname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_USERPLAYDRINKITEM, merchant, Loword(itemindex), Hiword(itemindex), 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (itemname));
end;

//接收斗酒说的话
procedure TfrmMain.ClientGetPlayDrinkSay (merchant, Who: integer; saying: string);
begin
   if g_nCurMerchant <> merchant then begin
      g_nCurMerchant := merchant;
   end;

   FrmDlg.ShowPlayDrink (Who, saying);
end;

procedure TfrmMain.SendPlayDrinkDlgSelect (merchant: integer; rstr: string);
var
   msg: TDefaultMessage;
   I: Integer;
begin
   if Length(rstr) >= 2 then begin
      if (rstr[1] = '@') and (rstr[2] = '@') and (rstr[3] = '@') then begin
          FrmMain.ClientGetPlayDrinkSay(g_nCurMerchant,2,'这坛酒给谁喝好呢？');
         if rstr = '@@@对方' then
            SendDrinkUpdateValue(g_nCurMerchant, 1, 1);
         if rstr = '@@@自己' then
            SendDrinkUpdateValue(g_nCurMerchant, 0, 1);
         if g_btPlaySelDrink = 0 then begin
            FrmDlg.DDrink1.Visible := False;
         end;
         if g_btPlaySelDrink = 1 then begin
            FrmDlg.DDrink2.Visible := False;
         end;
         if g_btPlaySelDrink = 2 then begin
            FrmDlg.DDrink4.Visible := False;
         end;
         if g_btPlaySelDrink = 3 then begin
            FrmDlg.DDrink6.Visible := False;
         end;
         if g_btPlaySelDrink = 4 then begin
            FrmDlg.DDrink5.Visible := False;
         end;
         if g_btPlaySelDrink = 5 then begin
            FrmDlg.DDrink3.Visible := False;
         end;
            if g_NpcRandomDrinkList.Count > 0 then //20080629
            for I:= 0 to g_NpcRandomDrinkList.Count - 1 do begin
                if Integer(g_NpcRandomDrinkList[I]) = g_btPlaySelDrink then begin
                  g_NpcRandomDrinkList.Delete(I);
                  Break;
                end;
            end;
      end else begin
         msg := MakeDefaultMsg (CM_PlAYDRINKDLGSELECT, merchant, 0, 0, 0, Certification);
         SendSocket (EncodeMessage (msg) + EncodeString (rstr));
      end;
   end;
end;

//发送猜拳码数
procedure TfrmMain.SendPlayDrinkGame (nParam1,GameNum: integer);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_PlAYDRINKGAME, nParam1, GameNum, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + '');
end;
//喝酒并增加醉酒值 20080517
//参数:nPlayNum--谁喝酒(0-玩家喝 1-NPC喝)  nCode--谁赢(0-NPC 1-玩家)
//参数:nParam1--为NPC ID号
procedure TFrmMain.SendDrinkUpdateValue(nParam1: Integer; nPlayNum,nCode: Byte);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_DrinkUpdateValue, nParam1, nPlayNum, nCode, 0, Certification);
   SendSocket (EncodeMessage (msg) + '');
end;

procedure TfrmMain.SendDrinkDrinkOK();
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_USERPLAYDRINK, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (IntToStr(g_nCurMerchant) + '/' + IntToStr(g_PDrinkItem[0].MakeIndex) + '/' + IntToStr(g_PDrinkItem[1].MakeIndex)));
end;
procedure TfrmMain.CloseTimerTimer(Sender: TObject);
begin
  CloseTimer.Enabled := False;
  if (g_ConnectionStep = cnsLogin) and not g_boSendLogin then begin
     FrmDlg.DMessageDlg ('服务器关闭或网络不稳定,请联系官方客服人员!!', [mbOk]);
     Close;
   end; 
end;
{******************************************************************************}
//关系系统
procedure TfrmMain.LoadFriendList();
var
  I: Integer;
  LoadList: TStringList;
  sFileName: string;
  sDir: string;
begin
  try
    if CharName = '' then Exit;
    if not DirectoryExists('config') then  CreateDir('config');
    sDir := format('config\Ly%s_%s',[g_sServerName,CharName]);
    if not DirectoryExists(sDir) then
      CreateDir(sDir);

    sFileName := sDir+'\Friend.txt';
    LoadList := TStringList.Create;
    if FileExists(sFileName) then begin
        g_FriendList.Clear;
        LoadList.LoadFromFile(sFileName);
        if LoadList.Count > 0 then //20080629
        for I := 0 to LoadList.Count - 1 do begin
          g_FriendList.Add(Trim(LoadList.Strings[I]));
        end;
    end else begin
      LoadList.SaveToFile(sFileName);
    end;
    LoadList.Free;
  except
    DebugOutStr ('TfrmMain.LoadFriendList');
  end;
end;

procedure TfrmMain.LoadHeiMingDanList();
var
  I: Integer;
  LoadList: TStringList;
  sFileName: string;
  sDir: string;
begin
  try
    if CharName = '' then Exit;
    if not DirectoryExists('config') then  CreateDir('config');
    sDir := format('config\Ly%s_%s',[g_sServerName,CharName]);
    if not DirectoryExists(sDir) then
      CreateDir(sDir);

    sFileName := sDir+'\HeiMingDan.txt';
    LoadList := TStringList.Create;
    if FileExists(sFileName) then begin
        g_HeiMingDanList.Clear;
        LoadList.LoadFromFile(sFileName);
        if LoadList.Count > 0 then //20080629
        for I := 0 to LoadList.Count - 1 do begin
          g_HeiMingDanList.Add(Trim(LoadList.Strings[I]));
        end;
    end else begin
      LoadList.SaveToFile(sFileName);
    end;
    LoadList.Free;
  except
    DebugOutStr ('TfrmMain.LoadHeiMingDanList');
  end;
end;
//储存好友名单
procedure TfrmMain.SaveFriendList();
var
  I: Integer;
  SaveList: TStringList;
  sFileName: string;
  sDir: string;
begin
  try
    if CharName = '' then Exit;
    if not DirectoryExists('config') then  CreateDir('config');
    sDir := format('config\Ly%s_%s',[g_sServerName,CharName]);
    if not DirectoryExists(sDir) then CreateDir(sDir);
    //Result := False;
    sFileName := sDir+'\Friend.txt';
    SaveList := TStringList.Create;
    if g_FriendList.Count > 0 then //20080629
    for I := 0 to g_FriendList.Count - 1 do begin
      SaveList.Add(g_FriendList.Strings[I]);
    end;
    SaveList.SaveToFile(sFileName);
    SaveList.Free;
    //Result := True;
  except
    DebugOutStr ('TfrmMain.SaveFriendList');
  end;
end;
//储存黑名单
procedure TfrmMain.SaveHeiMingDanList();
var
  I: Integer;
  SaveList: TStringList;
  sFileName: string;
  sDir: string;
begin
  try
    if CharName = '' then Exit;
    if not DirectoryExists('config') then  CreateDir('config');
    sDir := format('config\Ly%s_%s',[g_sServerName,CharName]);
    if not DirectoryExists(sDir) then CreateDir(sDir);
    //Result := False;
    sFileName := sDir+'\HeiMingDan.txt';
    SaveList := TStringList.Create;
    if g_HeiMingDanList.Count > 0 then //20080629
    for I := 0 to g_HeiMingDanList.Count - 1 do begin
      SaveList.Add(g_HeiMingDanList.Strings[I]);
    end;
    SaveList.SaveToFile(sFileName);
    SaveList.Free;
    //Result := True;
  except
    DebugOutStr ('TfrmMain.SaveHeiMingDanList');
  end;
end;
//检查黑名单里是否存在这个人的名字
function TfrmMain.InHeiMingDanListOfName(sUserName: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  if g_HeiMingDanList.Count > 0 then //20080629
  for I := 0 to g_HeiMingDanList.Count - 1 do begin
    if CompareText(sUserName, g_HeiMingDanList.Strings[I]) = 0 then begin
      Result := TRUE;
      break;
    end;
  end;
end;
{******************************************************************************}
//解决 由于切换问题导致 热点系统 变色
procedure TfrmMain.FormActivate(Sender: TObject);
begin
  TimerBrowserUpdate.Enabled := True;
end;

procedure TfrmMain.TimerBrowserUpdateTimer(Sender: TObject);
begin
  TimerBrowserUpdate.Enabled := False;
  if frmBrowser.Showing then begin
    FrmBrowser.Visible := False;
    FrmBrowser.Visible := True;
    FrmBrowser.SetFocus;
  end;
end;
{******************************************************************************}
//英雄技能开关
procedure TfrmMain.SendHeroMagicKeyChange (magid: integer; keych: char);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_HEROMAGICKEYCHANGE, magid, byte(keych), 0, 0, Certification);
   SendSocket (EncodeMessage (msg));
end;
{******************************************************************************}
//验证码相关
procedure TfrmMain.GetCheckNum();
var
  I,o,p:   Integer;
  vPoint:   TPoint;
  vLeft:   Integer;
  img: Timage; //20080612
begin
  try
    img := Timage.Create(FrmMain.Owner);
    try
    img.Width := 80;
    img.Height := 40;
    with img.Canvas do begin
      vLeft:=10;
      for o := 0 to 80 -1 do begin
        for p := 0 to 40 - 1 do begin
          Pixels[ o, p] := $00ADC6D6{RGB(Random(256) and $C0,
          Random(256) and $C0,Random(256) and $C0)};
        end;
      end;
      for I:= 1 to Length(g_pwdimgstr) do begin
        Font.Size := Random(10)+ 10;
        Font.Color := clBlack;
        case Random(3) of//随机字体
          0: Font.Style := [fsBold];
          1: Font.Style := [fsBold,fsUnderline];
          2: Font.Style := [fsBold,fsUnderline,fsUnderline];
        end;
        vPoint.X := Random(4)+ vLeft;
        vPoint.Y := Random(5)+2;
        //Canvas.Font.Name := Screen.Fonts[10];
        SetBkMode (Handle, TRANSPARENT);
        TextOut(vPoint.X, vPoint.Y,g_pwdimgstr[I]);
        vLeft := vPoint.X + Canvas.TextWidth(g_pwdimgstr[I])+8;
      end;

      Font.Size := 9;
      Font.Style := [];  //字体去掉粗体
    end;
       //img.Picture.Bitmap.PixelFormat := pf8bit;
    if img.Picture.Bitmap <> nil then begin
     UiDxImageList.Items[35].Picture.Bitmap := img.Picture.Bitmap;
     UiDxImageList.Items[35].Restore;
    end;
    finally
     img.Free;
    end;
  except
    DebugOutStr ('TfrmMain.GetCheckNum');
  end;
end;

procedure TfrmMain.SendCheckNum (num: string);
var
   msg: TDefaultMessage;
begin
   if num = '' then Exit;
   msg := MakeDefaultMsg (CM_CHECKNUM, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString(num));
end;

procedure TfrmMain.SendChangeCheckNum();
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_CHANGECHECKNUM, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg));
end;
{******************************************************************************}
//自动寻路相关
procedure Init_Queue();
var
  i: Integer;
begin
  try
    if g_Queue <> nil then begin
       if g_Queue.Next <> nil then DisPose(g_Queue.Next);
       if g_Queue.Node <> nil then DisPose(g_Queue.Node);
       DisPose(g_Queue);
    end;
    New(g_Queue);
    g_Queue.Node := nil;
    g_Queue.F := -1;
    New(g_Queue.Next);
    g_Queue.Next.F := $FFFFFFF;
    g_Queue.Next.Node := nil;
    g_Queue.Next.Next := nil;
    if g_RoadList.Count > 0 then begin//20080629
      for i := g_RoadList.Count - 1 downto 0 do begin
        Dispose(PFindNOde(g_RoadList[i]));
        g_RoadList.Delete(i);
      end;
    end;
    g_RoadList.Clear;
  except
    DebugOutStr ('TfrmMain.Init_Queue');
  end;
end;

// 待处理节点入队列, 依靠对目的地估价距离插入排序
procedure Enter_Queue(Node: PTree; F: Integer);
var
  p, Father, q: PLink;
begin
  try
    p := g_Queue;
    Father := p;
    while (F > p.F) do begin
      Father := p;
      p := p.Next;
      if p = nil then Break;
    end;
    New(q);
    q.F := F;
    q.Node := Node;
    q.Next := p;
    Father.Next := q;
  except
    DebugOutStr ('TfrmMain.Enter_Queue');
  end;
end;

// 将离目的地估计最近的方案出队列
function Get_From_Queue: PTree;
var
  bestchoice: PTree;
  Next: PLink;
begin
  try
    bestchoice := g_Queue.Next.Node;
    Next := g_Queue.Next.Next;
    Dispose(g_Queue.Next);
    g_Queue.Next := Next;
    Result := bestchoice;
  except
    DebugOutStr ('TfrmMain.Get_From_Queue');
  end;
end;

// 释放申请过的所有节点
procedure TfrmMain.FreeTree();
var
  p: PLink;
begin
  try
    while (g_Queue <> nil) do begin
      p := g_Queue;
      if P.Node<>nil then Dispose(p.Node);
      g_Queue := g_Queue.Next;
      Dispose(p);
    end;
  except
    DebugOutStr('TfrmMain.FreeTree');
  end;
end;
//释放自动寻路类
procedure TfrmMain.ClearRoad;
var
  T: PFindNOde;
  I: Integer;
begin
  try
    if g_RoadList.Count > 0 then //20080629
    for i:=g_RoadList.Count-1 downto 0 do begin
      T := PFindNOde(g_RoadList[i]);
      Dispose(T);
      g_RoadList.Delete(I);
    end;
    SetLength(g_SearchMap.pass,0);
    FreeAndNil(g_SearchMap);
  except
    DebugOutStr('TfrmMain.ClearRoad');
  end;
end;
// 估价函数,估价 x,y 到目的地的距离,估计值必须保证比实际值小
function Judge(X, Y, end_x, end_y: Integer): Integer;
begin
  try
    Result := abs(end_x - X) + abs(end_y - Y);
  except
    DebugOutStr('TfrmMain.Judge');
  end;
end;

// 尝试下一步移动到 x,y 可行否
function TryTile(X, Y, end_x, end_y: Integer; Father: PTree; Dir: Byte): Boolean;
var
  p: PTree;
  H: Integer;
begin
  try
    Result := False;
    if not  g_SearchMap.CanMove(X, Y) or
       not PlayScene.CanWalk(x, y) then //20080728增加 修正前面有怪 人物过不去问题
      Exit;
    p := Father;
    while (p <> nil) do begin
      if (X = p.X) and (Y = p.Y) then Exit; //如果 (x,y) 曾经经过,失败
      p := p.Father;
    end;
    H := Father.H + 1;
    if (H >= g_SearchMap.pass[X * Map.m_nMapHeight + Y]) then Exit; // 如果曾经有更好的方案移动到 (x,y) 失败
    g_SearchMap.pass[X * g_SearchMap.MapHeight + Y] := H; // 记录这次到 (x,y) 的距离为历史最佳距离
    New(p);
    p.Father := Father;
    p.H := Father.H + 1;
    p.X := X;
    p.Y := Y;
    p.Dir := Dir;
    enter_queue(p, p.H + judge(X, Y, end_x, end_y));
    Result := True;
  except
    DebugOutStr('TfrmMain.TryTile');
  end;
end;

// 路径寻找主函数            人物现在坐标   M2发来的目标坐标
function TFrmMain.FindPath(Startx, Starty, end_x, end_y: Integer;boHint: Boolean): Boolean;
var
  Root, p: PTree;
  X, Y, Dir: Integer;
  //ii: array[0..0] of Integer;
  ii: Integer;
  Temp: PFindNOde;
begin
  try
    Result := False;
    if boHint then
    DScreen.AddChatBoardString(Format('自由移动至坐标(%d:%d)，点击鼠标任意键停止……',[end_x,end_y]),GetRGB(178), ClWhite);
    if not g_SearchMap.CanMove(end_x, end_y) then begin
      DScreen.AddChatBoardString(Format('无法移动到(%d:%d)',[end_x,end_y]),GetRGB(178), ClWhite);
      Exit;
    end;
    SetLength(g_SearchMap.pass,g_SearchMap.MapHeight * g_SearchMap.Mapwidth);
    Fillchar(g_SearchMap.pass[0], g_SearchMap.MapHeight * g_SearchMap.Mapwidth * 4, $FF);
    Init_Queue();
    New(Root);
    Root.X := Startx;
    Root.Y := Starty;
    Root.H := 0;
    Root.Father := nil;
    enter_queue(Root, judge(Startx, Starty, end_x, end_y));
    //ii[0] := 0;
    ii := 0;
    while (True) do begin
      Root := get_from_queue(); //将第一个弹出
      //Inc(ii[0]);
      Inc(II);
      //if ii[0] = 86610 then ii[0] := 0;
      if ii = 86610 then II := 0;
      if (Root = nil) then Break;
      X := Root.X;
      Y := Root.Y;
      if (X = end_x) and (Y = end_y) then Break; //到达终点
      Trytile(X, Y - 1, end_x, end_y, Root, 0); //尝试向上移动
      Trytile(X + 1, Y - 1, end_x, end_y, Root, 1); //尝试向右上移动
      Trytile(X + 1, Y, end_x, end_y, Root, 2); //尝试向右移动
      Trytile(X + 1, Y + 1, end_x, end_y, Root, 3); //尝试向右下移动
      Trytile(X, Y + 1, end_x, end_y, Root, 4);  //尝试向下移动
      Trytile(X - 1, Y + 1, end_x, end_y, Root, 5); //尝试向左下移动
      Trytile(X - 1, Y, end_x, end_y, Root, 6); //尝试向左移动
      Trytile(X - 1, Y - 1, end_x, end_y, Root, 7); //尝试向左上移动
    end;
    if Root = nil then begin
      DScreen.AddChatBoardString(Format('无法移动到(%d:%d)',[end_x,end_y]),GetRGB(178), ClWhite);
      FreeTree();
      ClearRoad;
      if Timer2.Enabled then Timer2.Enabled := False;
      Exit;
    end;
    g_RoadList.Clear;
    New(Temp);
    Temp.X := Root.X;
    Temp.Y := Root.Y;
    g_RoadList.Add(Temp);
    Dir := Root.Dir;
    p := Root;
    Root := Root.Father;
    while (Root <> nil) do begin
      if Dir <> Root.Dir then begin
        New(Temp);
        Temp.X := p.X;
        Temp.Y := p.Y;
        g_RoadList.Insert(0, Temp);
        Dir := Root.Dir;
      end;
      p := Root;
      Root := Root.Father;
    end;
    FreeTree();
    SetLength(g_SearchMap.pass,0);
    Result := True;
  except
    DebugOutStr('TfrmMain.FindPath');
  end;
end;

procedure TfrmMain.Autorun();
var
  mx, my, mx1, my1, dx, dy,crun: Integer;
  ndir: Byte;
  RunStep: Byte;
  T: PFindNOde;
label
  LB_WALK;
begin
  try
    if (g_nAutoRunx <> g_MySelf.m_nCurrX) or (g_nAutoRuny <> g_MySelf.m_nCurrY) then begin
      mx := g_MySelf.m_nCurrX;
      my := g_MySelf.m_nCurrY;

      dx := g_nAutoRunx;
      dy := g_nAutoRuny;
      ndir := GetNextDirection(mx, my, dx, dy);
      case g_ChrAction of
        caWalk: begin
          LB_WALK: crun := g_MySelf.CanWalk;
          if IsUnLockAction(CM_WALK, ndir) and (crun > 0) then begin
            GetNextPosXY(ndir, mx, my);
            if not PlayScene.CanWalk(mx, my) then begin //如果不能走
              if g_RoadList.Count>0 then begin
                  T:=PFindNOde(g_RoadList[g_RoadList.Count-1]);
                  Dscreen.AddSysMsg('重新查找路径');
                  findpath(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY,T.X,T.y,false);
                  Exit;
              end;
            end else begin
              g_MySelf.UpdateMsg(CM_WALK, mx, my, ndir, 0, 0, '', 0);
             //   //                  Dscreen.AddSysMsg('走');
              g_dwLastAttackTick := GetTickCount;
            end;
          end else g_nAutoRunx := -1;
        end;
        caRun: begin
          if (g_nRunReadyCount >= 1){ or (neigua.Base.NoRunReady > 0) }then begin //免助跑
            crun := g_MySelf.CanRun;
            RunStep := 2;
            if (GetDistance(mx, my, dx, dy) >= RunStep) and (crun > 0) then begin
              if IsUnLockAction(CM_RUN, ndir) then begin
                mx1 := mx;
                my1 := my;
                  {if (g_MySelf.Horse>0) then
                    GetNextHorseRunXY(ndir, mx, my)
                  else }
                GetNextRunXY(ndir, mx, my);
                if PlayScene.CanRun(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mx, my) then begin
                  g_MySelf.UpdateMsg(CM_RUN, mx, my, ndir, 0, 0, '', 0);
                  g_dwLastAttackTick := GetTickCount;
                end else begin
                  mx := mx1;
                  my := my1;
                  goto LB_WALK;
                end;
              end else begin
                g_nAutoRunx := -1;
                goto LB_WALK;
              end;
            end else begin
              //if crun = -1 then begin
              //DScreen.AddSysMsg ('瘤陛篮 钝 荐 绝嚼聪促.');
              g_nAutoRunx := -1;
              //end;
              goto LB_WALK; //眉仿捞 绝绰版快.
                  {if crun = -2 then begin
                     DScreen.AddSysMsg ('泪矫饶俊 钝 荐 乐嚼聪促.');
                     AutoRunX := -1;
                  end; }
            end;
          end else begin
            Inc(g_nRunReadyCount);
            goto LB_WALK;
          end;
        end;
      end;
    end;
  except
    DebugOutStr('TfrmMain.Autorun');
  end;
end;
procedure TfrmMain.Timer2Timer(Sender: TObject);
var
  T: PFindNOde;
begin
  try
    if ServerAcceptNextAction then begin
      g_ChrAction := caRun;
      if g_RoadList.Count = 0 then begin
        Timer2.Enabled := False;
        Exit;
      end;

      T := PFindNOde(g_RoadList[0]);
      if (g_MySelf.m_nCurrX = T.X) and (g_MySelf.m_nCurrY = T.Y) then begin
        Dispose(T);
        g_RoadList.Delete(0);
      end;
      if g_RoadList.Count = 0 then begin
        Timer2.Enabled := False;
        DScreen.AddChatBoardString('到达目标',GetRGB(178), ClWhite);
        Exit;
      end;
      T := PFindNOde(g_RoadList[0]);
      g_nAutoRunx := T.X;
      if g_nAutoRunx=-1 then
         g_nAutoRunx:=-1;
      g_nAutoRuny := T.Y;
      AutoRun;
    end;
  except
    DebugOutStr('TfrmMain.Timer2Timer');
  end;
end;
{******************************************************************************}
//内挂检查是否有这魔法
//根据快捷键，查找对应的魔法
function  TfrmMain.GetMagicByID (Id: Byte): Boolean;
var
   i: integer;
   pm: PTClientMagic;
begin
   Result := False;
   if g_MagicList.Count > 0 then //20080629
   for i:=0 to g_MagicList.Count-1 do begin
      pm := PTClientMagic (g_MagicList[i]);
      if pm.Def.wMagicId = Id then begin
         Result := True;
         break;
      end;
   end;
end;
{******************************************************************************}
//酒馆2卷                            //0为普通酒，1为药酒
procedure TfrmMain.SendMakeWineItems();
var
   msg: TDefaultMessage;
   sstr: string;
   TypeWine: Byte;
begin
   sstr := '';
   if g_MakeTypeWine = 0 then begin //普通酒
     if (g_WineItem[0].s.Name = '') or (g_WineItem[2].s.Name = '') or (g_WineItem[3].s.Name = '')
        or (g_WineItem[4].s.Name = '') or (g_WineItem[5].s.Name = '') or (g_WineItem[6].s.Name = '') then Exit;
       if g_WineItem[1].s.Name = '' then //判断酒曲是否为空
          sstr := IntToStr(g_WineItem[0].MakeIndex) + '/' + '0/' + IntToStr(g_WineItem[2].MakeIndex) + '/' + IntToStr(g_WineItem[3].MakeIndex) + '/' +
          IntToStr(g_WineItem[4].MakeIndex) + '/' + IntToStr(g_WineItem[5].MakeIndex) + '/' + IntToStr(g_WineItem[6].MakeIndex)
       else
          sstr := IntToStr(g_WineItem[0].MakeIndex) + '/' + IntToStr(g_WineItem[1].MakeIndex) + '/' + IntToStr(g_WineItem[2].MakeIndex) + '/' + IntToStr(g_WineItem[3].MakeIndex) + '/' +
          IntToStr(g_WineItem[4].MakeIndex) + '/' + IntToStr(g_WineItem[5].MakeIndex) + '/' + IntToStr(g_WineItem[6].MakeIndex);
     TypeWine := 0;
   end else begin
      if (g_DrugWineItem[0].s.Name = '') or (g_DrugWineItem[1].s.Name = '') or (g_DrugWineItem[2].s.Name = '') then Exit;
      sstr := IntToStr(g_DrugWineItem[0].MakeIndex) + '/' + IntToStr(g_DrugWineItem[1].MakeIndex) + '/' + IntToStr(g_DrugWineItem[2].MakeIndex);
      TypeWine := 1;
   end;
   msg := MakeDefaultMsg (CM_BEGINMAKEWINE, 0, 0, 0, TypeWine, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (sstr));
end;

procedure TfrmMain.OpenSdoAssistant;
begin
  FrmDlg.DWNewSdoAssistant.Visible:= not FrmDlg.DWNewSdoAssistant.Visible;
  if not FrmDlg.DWNewSdoAssistant.Visible then begin
    SaveSdoAssistantConfig(CharName);
    ReleaseDFocus;
  end else begin
     PlayScene.EdChat.Visible := False;
  end;
end;

procedure TfrmMain.ActCallHeroKeyExecute(Sender: TObject);
var
 msgs: TDefaultMessage;
 target: TActor;
 sel: Integer;
begin
  if Sender = ActCallHeroKey then begin
    if FrmDlg.CallHero.ShowHint then
      msgs := MakeDefaultMsg (CM_RECALLHERO, 0, 0, 0, 0, Certification) //召唤英雄
    else
      msgs := MakeDefaultMsg (CM_HEROLOGOUT, 0, 0, 0, 0, Certification); //英雄退出
    SendSocket (EncodeMessage (msgs));
  end;
  if Sender = ActHeroAttackTargetKey then begin
    target := PlayScene.GetAttackFocusCharacter (g_nMouseX, g_nMouseY, 0,sel,FALSE); //取指定坐标上的角色
    if target <> nil then begin
      msgs:=MakeDefaultMsg (CM_HEROATTACKTARGET, target.m_nRecogId, target.m_nCurrX, target.m_nCurrY, 0, Certification);
      FrmMain.SendSocket (EncodeMessage (msgs));
    end;
  end;
  if Sender = ActHeroGotethKey then begin
    msgs:=MakeDefaultMsg (CM_HEROGOTETHERUSESPELL, 0, 0, 0, 0, Certification);
    SendSocket (EncodeMessage (msgs));
  end;
  if Sender = ActHeroStateKey then begin
    msgs:=MakeDefaultMsg (CM_HEROCHGSTATUS, 0, 0, 0, 0, Certification);
    SendSocket (EncodeMessage (msgs));
  end;
  if Sender = ActHeroGuardKey then begin
    msgs:=MakeDefaultMsg (CM_HEROPROTECT, 0, g_nMouseCurrX, g_nMouseCurry, 0, Certification);
    SendSocket (EncodeMessage (msgs));
  end;
  if Sender = ActAttackModeKey then begin
    SendSay ('@AttackMode');
  end;
  if Sender = ActMinMapKey then begin
   if not g_boViewMiniMap then begin
      if GetTickCount > g_dwQueryMsgTick then begin
         g_dwQueryMsgTick := GetTickCount + 3000;
         FrmMain.SendWantMiniMap;
         g_nViewMinMapLv:=1;
         FrmDlg.DWMiniMap.Left := SCREENWIDTH - 120; //20080323
         FrmDlg.DWMiniMap.Width := 120; //20080323
         FrmDlg.DWMiniMap.Height:= 120; //20080323
      end;
   end else begin
     if g_nViewMinMapLv >= 2 then begin
       g_nViewMinMapLv:=0;
       g_boViewMiniMap := FALSE;
       FrmDlg.DWMiniMap.Visible := False; //20080323
     end else begin
       Inc(g_nViewMinMapLv);
       FrmDlg.DWMiniMap.Left := SCREENWIDTH - 160; //20080323
       FrmDlg.DWMiniMap.Width := 160; //20080323
       FrmDlg.DWMiniMap.Height:= 160; //20080323
     end;
   end;
  end;
end;
{******************************************************************************}
//挑战
procedure TfrmMain.SendChallenge;
var
   msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg (CM_CHALLENGETRY, 0, 0, 0, 0, Certification);
  SendSocket (EncodeMessage (msg) + '');
end;

procedure TfrmMain.SendAddChallengeItem (ci: TClientItem);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_CHALLENGEADDITEM, ci.MakeIndex, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (ci.S.Name));
end;

procedure TfrmMain.SendCancelChallenge;
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_CHALLENGECANCEL, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendDelChallengeItem (ci: TClientItem);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_CHALLENGEDELITEM, ci.MakeIndex, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString (ci.S.Name));
end;

procedure TfrmMain.ClientGetChallengeRemoteAddItem (body: string);
var
   ci: TClientItem;
begin
   if body <> '' then begin
      DecodeBuffer (body, @ci, sizeof(TClientItem));
      AddChallengeRemoteItem (ci);
   end;
end;

procedure TfrmMain.ClientGetChallengeRemoteDelItem (body: string);
var
   ci: TClientItem;
begin
   if body <> '' then begin
      DecodeBuffer (body, @ci, sizeof(TClientItem));
      DelChallengeRemoteItem (ci);
   end;
end;

procedure TfrmMain.SendChallengeEnd;
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_CHALLENGEEND, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendChangeChallengeGold (gold: integer);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_CHALLENGECHGGOLD, gold, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendChangeChallengeDiamond (Diamond: integer);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_CHALLENGECHGDIAMOND, Diamond, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg));
end;

//Mode 0为关 1为开
procedure TfrmMain.SendHeroAutoOpenDefence (Mode: integer);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_HEROAUTOOPENDEFENCE, Mode, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg));
end;
{******************************************************************************}
//恢复角色
procedure TfrmMain.ClientGetReceiveDelChrs (body: string; DelChrCount: Integer);
var
   i: integer;
   str, uname, sjob, shair, slevel, ssex: string;
   DelChr: pTDelChr;
begin
   str := DecodeString (body);
   if DelChrCount > 0 then begin
     g_DelChrList := TList.Create;
     for i:=0 to DelChrCount-1 do begin
        str := GetValidStr3 (str, uname, ['/']);
        str := GetValidStr3 (str, sjob, ['/']);
        str := GetValidStr3 (str, shair, ['/']);
        str := GetValidStr3 (str, slevel, ['/']);
        str := GetValidStr3 (str, ssex, ['/']);
        if (uname <> '') and (slevel <> '') and (ssex <> '') then begin
           New(DelChr);
           DelChr.ChrInfo.Name := uname;
           DelChr.ChrInfo.Job := Str_ToInt(sjob, 0);
           DelChr.ChrInfo.HAIR := Str_ToInt(shair, 0);
           DelChr.ChrInfo.Level := Str_ToInt(slevel, 0);
           DelChr.ChrInfo.sex := Str_ToInt(ssex, 0);
           g_DelChrList.Add(DelChr);
           //SelectChrScene.AddChr (uname, Str_ToInt(sjob, 0), Str_ToInt(shair, 0), Str_ToInt(slevel, 0), Str_ToInt(ssex, 0));
        end;
     end;
   end;
   if g_DelChrList.Count > 0 then
   FrmDlg.dwRecoverChr.Visible := True;
   //PlayScene.EdAccountt.Text:=LoginId;
end;

procedure TfrmMain.SendQueryDelChr();
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_QUERYDELCHR, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString(LoginId + '/' + IntToStr(Certification)));
end;

procedure TfrmMain.SendResDelChr(Name: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_RESDELCHR, 0, 0, 0, 0, Certification);
   SendSocket (EncodeMessage (msg) + EncodeString(LoginId + '/' + Name));
end;

function TfrmMain.UiImages(Index: Integer): TDirectDrawSurface;
  procedure FreeUiOldMemorys;
  var
     i: integer;
  begin
     if UiDXImageList.Items.Count > 0 then //20080629
     for i:=0 to UiDXImageList.Items.Count-1 do begin
        if i in [31..32,34,36] then Continue;  //为里面本来就有图的  不是外部加载的
        if UiDXImageList.Items[i].Picture.Graphic <> nil then begin
           if GetTickCount - UiDXImageList.Items[i].dwLatestTime > 10 * 60 * 1000 then begin
              UiDXImageList.Items[i].Picture.Assign(nil);
              UiDxImageList.Items[Index].Restore;
           end;
        end;
     end;
  end;
  procedure LoadUi(Num: Integer);
  begin
    try
      case Num of
         0:  UiDxImageList.Items[0].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'HeroStatusWindow.uib'));
         1:  UiDxImageList.Items[1].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'BookBkgnd.uib'));
         2:  UiDxImageList.Items[2].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'BookCloseDown.uib'));
         3:  UiDxImageList.Items[3].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'BookCloseNormal.uib'));
         4:  UiDxImageList.Items[4].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'BookNextPageDown.uib'));
         5:  UiDxImageList.Items[5].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'BookNextPageNormal.uib'));
         6:  UiDxImageList.Items[6].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'BookPrevPageDown.uib'));
         7:  UiDxImageList.Items[7].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'BookPrevPageNormal.uib'));
         8:  UiDxImageList.Items[8].Picture.Bitmap.LoadFromFile(Pchar(BookImageDir+'1\'+'1.uib'));
         9:  UiDxImageList.Items[9].Picture.Bitmap.LoadFromFile(Pchar(BookImageDir+'1\'+'2.uib'));
         10: UiDxImageList.Items[10].Picture.Bitmap.LoadFromFile(Pchar(BookImageDir+'1\'+'3.uib'));
         11: UiDxImageList.Items[11].Picture.Bitmap.LoadFromFile(Pchar(BookImageDir+'1\'+'4.uib'));
         12: UiDxImageList.Items[12].Picture.Bitmap.LoadFromFile(Pchar(BookImageDir+'1\'+'5.uib'));
         13: UiDxImageList.Items[13].Picture.Bitmap.LoadFromFile(Pchar(BookImageDir+'1\'+'CommandDown.uib'));
         14: UiDxImageList.Items[14].Picture.Bitmap.LoadFromFile(Pchar(BookImageDir+'1\'+'CommandNormal.uib'));
         15: UiDxImageList.Items[15].Picture.Bitmap.LoadFromFile(Pchar(BookImageDir+'2\'+'1.uib'));
         16: UiDxImageList.Items[16].Picture.Bitmap.LoadFromFile(Pchar(BookImageDir+'3\'+'1.uib'));
         17: UiDxImageList.Items[17].Picture.Bitmap.LoadFromFile(Pchar(BookImageDir+'4\'+'1.uib'));
         18: UiDxImageList.Items[18].Picture.Bitmap.LoadFromFile(Pchar(BookImageDir+'5\'+'1.uib'));
         19: UiDxImageList.Items[19].Picture.Bitmap.LoadFromFile(Pchar(BookImageDir+'6\'+'1.uib'));
         20: UiDxImageList.Items[20].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'301.mmap'));
         21: UiDxImageList.Items[21].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'vigourbar1.uib'));
         22: UiDxImageList.Items[22].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'vigourbar2.uib'));
         23: UiDxImageList.Items[23].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'BuyLingfuDown.uib'));
         24: UiDxImageList.Items[24].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'BuyLingfuNormal.uib'));
         25: UiDxImageList.Items[25].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'302.mmap'));
         26: UiDxImageList.Items[26].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'303.mmap'));
         27: UiDxImageList.Items[27].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'304.mmap'));
         28: UiDxImageList.Items[28].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'306.mmap'));
         29: UiDxImageList.Items[29].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'StateWindowHuman.uib'));
         30: UiDxImageList.Items[30].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'StateWindowHero.uib'));
         33: UiDxImageList.Items[33].Picture.Bitmap.LoadFromFile(Pchar(UiImageDir+'GloryButton.uib'));
         37: UiDxImageList.Items[37].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'307.mmap'));
         38: UiDxImageList.Items[38].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'308.mmap'));
         39: UiDxImageList.Items[39].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'309.mmap'));
         40: UiDxImageList.Items[40].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'310.mmap'));
         41: UiDxImageList.Items[41].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'311.mmap'));
         42: UiDxImageList.Items[42].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'312.mmap'));
         43: UiDxImageList.Items[43].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'313.mmap'));
         44: UiDxImageList.Items[44].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'314.mmap'));
         45: UiDxImageList.Items[45].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'315.mmap'));
         46: UiDxImageList.Items[46].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'316.mmap'));
         47: UiDxImageList.Items[47].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'317.mmap'));
         48: UiDxImageList.Items[48].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'318.mmap'));
         49: UiDxImageList.Items[49].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'319.mmap'));
         50: UiDxImageList.Items[50].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'320.mmap'));
         51: UiDxImageList.Items[51].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'321.mmap'));
         52: UiDxImageList.Items[52].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'322.mmap'));
         53: UiDxImageList.Items[53].Picture.Bitmap.LoadFromFile(Pchar(MinimapImageDir+'323.mmap'));
      end;
      UiDxImageList.Items[Index].Restore;
    except
      //showmessage('没找到'); //临时
    end;
  end;
begin
  Result := nil;
  try
    if (Index < 0) or (Index >= UiDXImageList.Items.Count) then Exit;
    if GetTickCount - m_dwUiMemChecktTick > 10000 then begin
      m_dwUiMemChecktTick := GetTickCount;
      FreeUiOldMemorys;
    end;
    if UiDXImageList.Items[index].Picture.Graphic = nil then begin 
      if index < UiDXImageList.Items.Count then begin
        LoadUi(Index);
        UiDXImageList.Items[Index].dwLatestTime := GetTickCount;
        Result := UiDXImageList.Items[Index].PatternSurfaces[0];
      end;
    end else begin
      UiDXImageList.Items[index].dwLatestTime := GetTickCount;
      Result := UiDXImageList.Items[Index].PatternSurfaces[0];
    end;
  except
    DebugOutStr ('UiImages');
  end;
end;
procedure TfrmMain.CountDownTimerTimer(Sender: TObject);
begin
  if DScreen <> nil then begin
    if DScreen.m_boCountDown then begin
      if GetTickCount - DScreen.m_dwCountDownTimeTick1 > 256 then begin//20090127
        DScreen.m_dwCountDownTimeTick1 := GetTickCount;
        if GetTickCount - DScreen.m_dwCountDownTimeTick > 1000 then begin
          DScreen.m_dwCountDownTimeTick := GetTickCount;
          if DScreen.m_dwCountDownTimer > 0 then begin
            Dec(DScreen.m_dwCountDownTimer);
            if DScreen.m_dwCountDownTimer = 0 then begin
              DScreen.m_boCountDown := False;
              CountDownTimer.Enabled := False;
            end;
          end;
        end;
      end;
    end;
  end;
end;

end.

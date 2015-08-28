#define platform GetEnv("platform")

#define platform "x64"
#ifndef platform
  #define platform "x32"
#endif

#if platform == "x64"
  #define platformdir = "win64-x86_64"
#else
  #define platformdir = "win32-i386"
#endif

#define AppVersion "1.5.7.1600"


[Setup]
AppName=AFUDF for FireBird {#platform} 
AppVerName=AFUDF for FireBird {#platform} {#AppVersion} 
AppVersion={#AppVersion}
DefaultDirName={code:GetDefFBPath}
DefaultGroupName=AFUDF
Compression=lzma/max

OutputBaseFilename=af-udf-{#platformdir}-{#AppVersion}
OutputDir="output\af-udf-{#AppVersion}\"
DisableDirPage=yes
Uninstallable=yes
UsePreviousAppDir=no
SourceDir=..
PrivilegesRequired=admin

#if platform == "x64"
ArchitecturesInstallIn64BitMode=x64
#endif

[Components]
Name: "udfdll"; Description: "UDF Libraries"; Types: full fullreg custom; Flags: fixed; Languages:en
Name: "udfregsql"; Description: "Sql scripts registration UDF";  Types:full  custom; Languages:en
Name: "udfregsql\regdb"; Description: "Run registration UDF in the database";  Types: fullreg custom; Flags: dontinheritcheck;Languages:en


Name: "udfdll"; Description: "UDF библиотеки"; Types: full custom; Flags: fixed; Languages:ru
Name: "udfregsql"; Description: "Sql скрипты регистрации UDF";  Types:full  custom; Languages:ru
Name: "udfregsql\regdb"; Description: "Зарегистрировать UDF в базе данных";  Types: fullreg custom; Flags: dontinheritcheck;Languages:ru

[Types]
Name: "full"; Description: "Full installation"; Languages:en
Name: "fullreg"; Description: "Full installation with registration"; Languages:en
Name: "custom"; Description: "Select components"; Flags: iscustom; Languages:en ru

Name: "full"; Description: "Полная установка"; Languages:ru
Name: "fullreg"; Description: "Полная установка с регистрацией"; Languages:ru


[Dirs]
Name: "{app}\AFUDF"
Name: "{app}\AFUDF\help"
Name: "{app}\AFUDF\SQL"

[Files]
Source: "build\{#platformdir}\af*.dll"; DestDir: "{app}";Components:udfdll; Flags: ignoreversion

Source: "resource\iconv.dll"; DestDir: "{sys}";Components:udfdll; Flags: ignoreversion
Source: "build\{#platformdir}\afmmngr.dll"; DestDir: "{sys}";Components:udfdll; Flags: ignoreversion

Source: "sql\reg\af*.sql"; DestDir: "{app}\AFUDF\SQL"; Components: udfregsql;  Flags: ignoreversion
Source: "sql\reg\Drop.*.sql"; DestDir: "{app}\AFUDF\SQL"; Components: udfregsql;  Flags: ignoreversion


Source: "help\bugs"; DestDir: "{app}\AFUDF\help";  Flags: ignoreversion
Source: "help\authors.txt"; DestDir: "{app}\AFUDF\help";   Flags: ignoreversion
Source: "help\install.txt"; DestDir: "{app}\AFUDF\help";   Flags: ignoreversion




Source: "Resource\ibescript.exe"; DestDir: "{app}\AFUDF\SQL"; Components:udfregsql\regdb ;Flags:deleteafterinstall ignoreversion;

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl";InfoBeforeFile : "Install\infobefore-En.txt"
Name: "ru"; MessagesFile: "compiler:Languages\Russian.isl";InfoBeforeFile : "install\infobefore-Ru.txt"

[Code]

function GetDefFBPath(Param:string):string;
begin
  result := '';
  if RegValueExists(HKEY_LOCAL_MACHINE, 'SOFTWARE\Firebird Project\Firebird Server\Instances','DefaultInstance') then
    RegQueryStringValue(HKEY_LOCAL_MACHINE, 'SOFTWARE\Firebird Project\Firebird Server\Instances','DefaultInstance', result);
  if ((result='') or (not  DirExists(result+'\UDF')) ) then
  begin
     MsgBox('It is not possible to define a folder in which the installed FireBird..'#13#10'Specify the folder by yourself.',  mbError, MB_OK);

     if BrowseForFolder('Select a folder with FireBird:',result,false) then
     begin
       if not  DirExists(result+'\UDF') then
       begin
         MsgBox('Not right contains the folder in which the installed FireBird.'#13#10'Povtorite installation.',  mbError, MB_OK);
         Abort;
       end;
     end
     Else
     begin
       MsgBox('Attention. Installation canceled!',  mbError, MB_OK)
       Abort;
     end
  end;       
  result := result+'\UDF';  
end;



var
  PageInputDataBase : TWizardPage;
  SelFBComboBox     : TComboBox;
  SelFBStaticText1  : TNewStaticText;
  SelFBButtonScan   : TButton;
  SelFBStaticText2  : TNewStaticText;
  SelFBStaticText3  : TNewStaticText;
  SelFBButtonBrowse : TButton;
  SelFBLogin        : TEdit;
  SelFBPwd          : TEdit;
  SelFBAllDB        : TCheckBox;
  ScriptWasExec     : Boolean;
  FilesFound        : Integer;

  SelFBScanStop     : Boolean;
  SelFBScanSkip     : Boolean;
  SelFBScanFrom     : String;

  FBScan            : TForm;
  FBScanSt          : TNewStaticText;
  FBScanStcnt       : TNewStaticText;
  FBScanSthdr       : TNewStaticText;

  
Const 
  ScriptParams='"%s" -S -T -N  -vScriptLog.txt -CWIN1251 -U%s -D"%s" -P%s';
  //ScriptParams='-i "%s" -o ScriptLog.txt';

  PM_REMOVE           = $01;
  WM_QUIT             = $0012;

Type TMsg=record
    hwnd:HWND;
    message:UINT;
    wParam:Longint;
    lParam:Longint;
    time:DWORD;
    pt:TPOINT;
   end;

function PeekMessage(var Msg:TMsg;hWnd:HWND;wMsgFilterMin,wMsgFilterMax,wRemoveMsg:UINT):Bool;
external 'PeekMessageA@user32.dll stdcall';

function TranslateMessage(const lpMsg: TMsg): BOOL;
external 'TranslateMessage@user32.dll stdcall';

function DispatchMessage(const lpMsg: TMsg): Longint;
external 'DispatchMessageA@user32.dll stdcall';

Function ProcessMessage(var Msg: TMsg): Boolean;
var
  Handled: Boolean;
begin
  Result := False;
  if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then
  begin
    Result := True;
    if Msg.Message <> WM_QUIT then
    begin
      Handled := False;
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end;
  end;
end;
procedure ProcessMessages;
var Msg:TMsg;
begin
  while ProcessMessage(Msg) do
  {loop};
end;


procedure FindFileInDir(Dir:String;AddToComboBox:TComboBox;InfoStaticText,CntStaticText:TNewStaticText);
var
     FindRec: TFindRec;
begin
  if FindFirst(Dir+'\*.*', FindRec) then begin
    try
      InfoStaticText.Caption := 'Folder: ' + Dir;
      InfoStaticText.Update;
      repeat
        if (FindRec.Attributes and FILE_ATTRIBUTE_DIRECTORY = 0) then
        begin
          if ( (UpperCase(ExtractFileExt(FindRec.Name))='.GDB') or
               (UpperCase(ExtractFileExt(FindRec.Name))='.FDB') or
               (UpperCase(ExtractFileExt(FindRec.Name))='.IB')) then
          begin
            AddToComboBox.Items.Add(Dir+'\'+FindRec.Name);
            FilesFound := FilesFound + 1;
            CntStaticText.Caption :=
            Format('Find: %d [Last: %s . %8.2fКб]' ,[FilesFound,FindRec.Name,double((FindRec.SizeHigh shr 32 + FindRec.SizeLow)/1024)]);
            CntStaticText.Update;

          end;
        end
        else
        begin
          if ((FindRec.Name<>'.') and (FindRec.Name<>'..')) then
            FindFileInDir(Dir+'\'+FindRec.Name,AddToComboBox,InfoStaticText,CntStaticText);
        end;
      ProcessMessages;
      if SelFBScanStop or SelFBScanSkip then Exit;
      until not FindNext(FindRec);
    finally
      FindClose(FindRec);
    end;
  end;
end;


procedure FormScanCancelOnClick(Sender:Tobject);
begin
  SelFBScanStop := True;
  FBScan.Close();
end;

procedure FormScanSkipOnClick(Sender:Tobject);
begin
 SelFBScanSkip := True;
 ProcessMessages;
end;

Procedure ScanDisksFBDataBase(Sender: TObject);
var
    bc     : TButton;
    bcSkip : TButton;
    ch:integer;
begin
  if (MsgBox('Find FireBird database on local disks?',mbConfirmation, MB_YESNO)<>IDYES) then exit;
  SelFBComboBox.Items.Clear;
  FBScan := TForm.Create(nil);
  try
    FBScan.Position := poScreenCenter;
    FBScan.BorderStyle := bsDialog;
    FBScan.Width := ScaleX(450);
    FBScan.Height := ScaleY(150);
    FBScan.Caption := 'Scan';
    
    bc := TButton.Create(FBScan);
    bc.Width := ScaleY(75);
    bc.Height := ScaleY(25);
    bc.Top := FBScan.ClientHeight - bc.Height - ScaleY(8);
    bc.Left:= FBScan.ClientWidth - bc.Width - ScaleX(8);
    bc.Caption := 'Cancel';
    bc.Parent := FBScan;
    bc.OnClick := @FormScanCancelOnClick;

    bcSkip := TButton.Create(FBScan);
    bcSkip.Width := ScaleY(96);
    bcSkip.Height := ScaleY(25);
    bcSkip.Top := FBScan.ClientHeight - bc.Height - ScaleY(8);
    bcSkip.Left:=  ScaleX(8);
    bcSkip.Caption := 'Skip...';
    bcSkip.Parent := FBScan;
    bcSkip.OnClick := @FormScanSkipOnClick;
    
    FBScansthdr:=TNewStaticText.Create(FBScan);
    FBScanSthdr.Top := ScaleY(8);
    FBScanSthdr.Left := ScaleX(8);
    FBScanSthdr.Caption := 'Prepare...';
    FBScanSthdr.Parent := FBScan;
    
    FBScanst:=TNewStaticText.Create(FBScan);
    FBScanSt.Top := FBScanSthdr.Top + FBScanSthdr.Height + ScaleY(1);
    FBScanSt.Left := FBScanSthdr.Left;
    FBScanSt.Caption := '';
    FBScanSt.Parent := FBScan;
    
    FBScanstcnt:=TNewStaticText.Create(FBScan);
    FBScanstcnt.Top := FBScanSt.Top + FBScanst.Height + ScaleY(1);
    FBScanstcnt.Left := FBScanst.Left;
    FBScanstcnt.Caption := 'Found: 0';
    FBScanstcnt.Parent := FBScan;

    FilesFound := 0;

    SelFBScanStop := False;

    WizardForm.Enabled := false;
    SelFBAllDB.Checked := false;
    SelFBAllDB.Enabled := false;
    FBScan.Show;
    try
     if SelFBScanFrom<>'' then
     begin
        if DirExists(SelFBScanFrom)then
        begin
          FBScanSthdr.Caption := 'Scan: ' + SelFBScanFrom;
          FBScanSthdr.Update;
          SelFBScanSkip := False;
          FindFileInDir( SelFBScanFrom,SelFBComboBox,FBScanSt,FBScanstcnt);
         if SelFBScanStop then exit;
        end;
     end
     else
     For ch := ord('a') to ord('z')do
      begin
        if DirExists(chr(ch)+':\')then
        begin
          FBScanSthdr.Caption := 'Scan: ' + UpperCase(chr(ch))+':';
          FBScanSthdr.Update;
          SelFBScanSkip := False;
          FindFileInDir( UpperCase(chr(ch))+':',SelFBComboBox,FBScanSt,FBScanstcnt);
         if SelFBScanStop then exit;
        end;
      end;

    finally
      if SelFBComboBox.Items.Count>0 then SelFBComboBox.ItemIndex:=0;
    end;


  finally
    WizardForm.Enabled := true;
    WizardForm.BringToFront;
    SelFBAllDB.Enabled :=  SelFBComboBox.Items.Count>0;
    FBScan.Free;
    FBScan := nil;
  end;
end;

Procedure SelFBButtonBrowseOnClick(Sender: TObject);
begin
  if not BrowseForFolder('Select search folder',SelFBScanFrom,false) then
    SelFBScanFrom := ''
  else ScanDisksFBDataBase(SelFBButtonBrowse);
end;


procedure CreateSelectFBDataBase;
begin
  PageInputDataBase := CreateCustomPage(wpSelectComponents, 'Register UDF in the database FireBird', 'Select an option and a database');
  SelFBStaticText1 :=  TNewStaticText.Create(PageInputDataBase);
  SelFBStaticText1.Top := ScaleY(8);
  SelFBStaticText1.Width := PageInputDataBase.SurfaceWidth;
  SelFBStaticText1.Caption := 'Database:';
  SelFBStaticText1.Parent := PageInputDataBase.Surface;
  
  SelFBComboBox := TComboBox.Create(PageInputDataBase);
  SelFBComboBox.Top := SelFBStaticText1.Top + SelFBStaticText1.Height + ScaleY(2);
  SelFBComboBox.Width := PageInputDataBase.SurfaceWidth - ScaleX(110);
  SelFBComboBox.Height := ScaleY(24);
  SelFBComboBox.Parent := PageInputDataBase.Surface;
  SelFBComboBox.Text := GetPreviousData('FBDataBase', '');

  
  SelFBButtonScan := TButton.Create(PageInputDataBase);
  SelFBButtonScan.Top := SelFBStaticText1.Top + SelFBStaticText1.Height + ScaleY(1);
  SelFBButtonScan.Left := SelFBComboBox.Left+SelFBComboBox.Width + ScaleX(8);
  SelFBButtonScan.Height := ScaleY(24);
  SelFBButtonScan.Width := ScaleX(96);
  SelFBButtonScan.Parent := PageInputDataBase.Surface;
  SelFBButtonScan.Caption := 'Scan...'
  SelFBButtonScan.OnClick := @ScanDisksFBDataBase;
  
  SelFBButtonBrowse := TButton.Create(PageInputDataBase);
  SelFBButtonBrowse.Top := SelFBButtonScan.Top + SelFBButtonScan.Height + ScaleY(2);
  SelFBButtonBrowse.Left := SelFBComboBox.Left+SelFBComboBox.Width + ScaleX(8);
  SelFBButtonBrowse.Height := ScaleY(24);
  SelFBButtonBrowse.Width := ScaleX(96);
  SelFBButtonBrowse.Parent := PageInputDataBase.Surface;
  SelFBButtonBrowse.Caption := 'Scan from...'
  SelFBButtonBrowse.OnClick := @SelFBButtonBrowseOnClick;
  
  SelFBStaticText2 := TNewStaticText.Create(PageInputDataBase);
  SelFBStaticText2.Top := SelFBComboBox.Top + SelFBComboBox.Height + ScaleY(8);
  SelFBStaticText2.Width := PageInputDataBase.SurfaceWidth;
  SelFBStaticText2.Caption := 'Username:';
  SelFBStaticText2.Parent := PageInputDataBase.Surface;
  
  SelFBLogin := TEdit.Create(PageInputDataBase);
  SelFBLogin.Top := SelFBStaticText2.Top + SelFBStaticText2.Height + ScaleY(2);
  SelFBLogin.Width := ScaleX(200);
  SelFBLogin.Text := GetPreviousData('FBLogin', 'SYSDBA');
  SelFBLogin.Parent := PageInputDataBase.Surface;
  
  SelFBStaticText3 := TNewStaticText.Create(PageInputDataBase);
  SelFBStaticText3.Top := SelFBLogin.Top + SelFBLogin.Height + ScaleY(8);
  SelFBStaticText3.Width := PageInputDataBase.SurfaceWidth;
  SelFBStaticText3.Caption := 'Password:';
  SelFBStaticText3.Parent := PageInputDataBase.Surface;

  SelFBPwd := TEdit.Create(PageInputDataBase);
  SelFBPwd.Top := SelFBStaticText3.Top + SelFBStaticText3.Height + ScaleY(2);
  SelFBPwd.Width := ScaleX(200);
  SelFBPwd.Text := 'masterkey';
  SelFBPwd.PasswordChar := '*';
  SelFBPwd.Parent := PageInputDataBase.Surface;
  
  SelFBAllDB := TCheckBox.Create(PageInputDataBase);
  SelFBAllDB.Top := SelFBPwd.Top + SelFBPwd.Height + ScaleY(8);
  SelFBAllDB.Width :=  PageInputDataBase.SurfaceWidth;
  SelFBAllDB.Caption := 'Run for all databases (not recommended)';
  SelFBAllDB.Parent := PageInputDataBase.Surface;
  SelFBAllDB.Enabled := False;
  SelFBAllDB.Visible := False;

end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  I: Integer;
begin
  Result := True;
  if (CurPageID =  PageInputDataBase.ID) then
  begin
    if (SelFBComboBox.Text='') then
    begin
      Result := False;
      MsgBox('Select or enter a database connection string.',mbInformation,MB_OK);
      exit;
    end;
    if (SelFBLogin.Text='') then
    begin
      Result := False;
      MsgBox('Enter login DBA',mbInformation,MB_OK);
      exit;
    end;
    if (SelFBPwd.Text='') then
    begin
      Result := False;
      MsgBox('Enter password DBA',mbInformation,MB_OK);
      exit;
    end;
  end;
end;


procedure ExecuteScripts();
var prog:TOutputProgressWizardPage;
    cntScript:integer;
    cntExceScript:integer;
    ScritpFiles:TStringList;
    i:integer;
    FileIbeScript:string;
    ResultCode:integer;

    UseexecScript:Boolean;
    Params:String;
    WasError:Boolean;
    TempDir:String;
    DataBase:String;
    PWD         : String;
    Login       : String;
begin
  ScriptWasExec := true;
  if (not IsComponentSelected('udfregsql\regdb')) then exit;


  ScritpFiles:=TStringList.Create();
  ScritpFiles.Add('afcommon.sql');
  ScritpFiles.Add('afucrypt.sql');
  ScritpFiles.Add('afudbf.sql');
  ScritpFiles.Add('afuZip.sql');
  ScritpFiles.Add('afutextfile.sql');
  ScritpFiles.Add('afufile.sql');
  ScritpFiles.Add('afuxml.sql');
  ScritpFiles.Add('afumisc.sql');

  DataBase := SelFBComboBox.Text;

  Login := SelFBLogin.Text;
  PWD := SelFBPwd.Text;
 begin
   {Выполнение скриптов}
   cntScript:=0;
   cntExceScript:=0;
   WasError:=false;
   TempDir := ExpandConstant('{app}');
   FileIbeScript:= TempDir+'\AFUDF\SQL\ibescript.exe';

   //FileIbeScript:= ExtractFileDir( ExpandConstant('{app}')) +'\bin\isql.exe';

   log(FileIbeScript);

   DeleteFile(TempDir+'\AFUDF\SQL\ScriptLog.txt');
   prog:=CreateOutputProgressPage( 'Running scripts', 'Please wait...');

   try
     prog.Show;
     prog.SetProgress(0,ScritpFiles.Count);
     prog.SetText('Running script:','');
     Sleep(500);
     for i:=0 to ScritpFiles.Count-1 do
     begin
        prog.Msg2Label.Caption:=ScritpFiles[i];
        prog.ProgressBar.Position:=i+1;
        ResultCode:=0;

        Params:= Format(ScriptParams,[{GetExecPathScript(}ScritpFiles[i]{)},Login,PWD,DataBase]);
        log(Params);
        if not Exec(FileIbeScript,Params, ExpandConstant('{app}')+'\AFUDF\SQL',SW_HIDE,ewWaitUntilTerminated,ResultCode)then
        begin
          WasError:=True;
        end
        else
        if ResultCode<>0 then
        begin
          WasError:=True;
        end;
     end;
     if WasError and(MsgBox('When you run the script(s) error!'#13#10
                      +'Perhaps the program will work properly.'#13#10#13#10
                      +'The file is stored results:'+TempDir+'\AFUDF\SQL\ScriptLog.txt'+#13#10
                      +'Open the log file?', mbError, MB_YESNO)=IDYES) then
                      ShellExec('open',TempDir+'\AFUDF\SQL\ScriptLog.txt','', '', SW_SHOW, ewNoWait, ResultCode);

     if not WasError then
     begin
       DeleteFile(TempDir+'\AFUDF\SQL\ScriptLog.txt');
     end;
   finally
     prog.Hide;
     prog.Free;
     ScritpFiles.Free;
   end;

 end;
end;

procedure RegisterPreviousData(PreviousDataKey: Integer);
begin
  SetPreviousData(PreviousDataKey, 'FBDataBase',SelFBComboBox.Text);
  SetPreviousData(PreviousDataKey, 'FBLogin',SelFBLogin.Text);
end;

procedure CurPageChanged(CurPageID: Integer);
begin
 if  not WizardSilent and  (CurPageID = wpFinished) and not ScriptWasExec then
      ExecuteScripts;
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := false;
  if (PageID = PageInputDataBase.ID ) then
  begin
    Result := (not IsComponentSelected('udfregsql\regdb')) or WizardSilent ;
  end;
end;

procedure InitializeWizard;
begin
  CreateSelectFBDataBase;

end;



procedure DeinitializeSetup();
begin
end;



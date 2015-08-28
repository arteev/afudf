#define platform GetEnv("platform")

#ifndef platform
  #define platform "x32"
#endif

#if platform == "x64"
  #define platformdir = "win64-x86_64"
#else
  #define platformdir = "win32-i386"
#endif

#define AppVersion "1.5.7.1060"


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
Name: "udfdll"; Description: "UDF Libraries"; Types: full custom; Flags: fixed; Languages:en
Name: "udfregsql"; Description: "Sql scripts registration UDF";  Types:full  custom; Languages:en

Name: "udfdll"; Description: "UDF библиотеки"; Types: full custom; Flags: fixed; Languages:ru
Name: "udfregsql"; Description: "Sql скрипты регистрации UDF";  Types:full  custom; Languages:ru


[Types]
Name: "full"; Description: "Full installation"; Languages:en
Name: "custom"; Description: "Select components"; Flags: iscustom; Languages:en ru

Name: "full"; Description: "Полная установка"; Languages:ru
Name: "fullreg"; Description: "Полная установка с регистрацией"; Languages:ru


[Dirs]
Name: "{app}\AFUDF"
Name: "{app}\AFUDF\help"
Name: "{app}\AFUDF\SQL"

[Files]
Source: "build\{#platformdir}\af*.dll"; DestDir: "{app}";Components:udfdll; Flags: ignoreversion
Source: "resource\{#platformdir}\iconv.dll"; DestDir: "{sys}";Components:udfdll; Flags: ignoreversion
Source: "build\{#platformdir}\afmmngr.dll"; DestDir: "{sys}";Components:udfdll; Flags: ignoreversion
Source: "sql\reg\af*.sql"; DestDir: "{app}\AFUDF\SQL"; Components: udfregsql;  Flags: ignoreversion
Source: "sql\reg\Drop.*.sql"; DestDir: "{app}\AFUDF\SQL"; Components: udfregsql;  Flags: ignoreversion
Source: "help\authors.txt"; DestDir: "{app}\AFUDF\help";   Flags: ignoreversion
Source: "help\install-ru.txt"; DestDir: "{app}\AFUDF\help";   Flags: ignoreversion;Languages:ru

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
         MsgBox('Not right contains the folder in which the installed FireBird.'#13#10'Please repeat installation.',  mbError, MB_OK);
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





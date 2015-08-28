{
    This file is part of the AF UDF library for Firebird 1.0 or high.
    Copyright (c) 2007-2009 by Arteev Alexei, OAO Pharmacy Tyumen.

    See the file COPYING.TXT, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    email: alarteev@yandex.ru, arteev@pharm-tmn.ru, support@pharm-tmn.ru

 **********************************************************************}
unit uafudfs;

{$MODE objfpc}
{$H+}

interface
uses SysUtils;

Const
  TrueInt = integer(True);
  FalseInt = integer(False);

Type
  TTypeAFObj=(taoUnknow,taoObject,taoMem);
  {$IfDef UsePtrInt}  // use PtrInt
  PtrUdf = PtrInt;
    {$IfDef CPU32}
    {$Warning  Build mode UsePtrInt - Handle <=> 32bit }
    {$EndIf}
  {$Else}
  PtrUdf = PtrUInt;
  {$EndIf}

  { TAFObj }
  TAFObj = class
  private
    FObj: TObject;
    PFObj:Pointer;
    FSizeMem:Cardinal;
    FTypeAFObj:TTypeAFObj;
    FLastError: Cardinal;
    FLastErrorMessageException:String;
    FLastErrorIsException:Boolean;
    function GetObj: TObject;
    function GetHandle: PtrUdf;
    function GetMessageLastError: string;
    function GetMemory: Pointer;
  protected
  public
    class function FindObj(AHandle:PtrUdf;ATypeAFObj:TTypeAFObj):TAFObj;

    constructor Create(AObj:TObject);overload;
    constructor Create(AObj:Pointer;SizeMem:Cardinal);overload;
    destructor Destroy;override;
    procedure NilMemory;
    procedure FixedError;overload;
    procedure FixedError(E:Exception);overload;
    procedure ClearError;
    function WasError:boolean;
    property Obj:TObject read GetObj;
    property Memory:Pointer read GetMemory;
    property TypeAFObj:TTypeAFObj read FTypeAFObj;
    property Handle:PtrUdf read GetHandle;
    property LastError:Cardinal read FLastError;
    property MessageLastError:string read GetMessageLastError;
    property LastErrorIsException:Boolean read FLastErrorIsException;
  end;

  function HandleToObj(Handle:PtrUdf):TObject; inline;
  function HandleToAfObj(Handle:PtrUdf;AType:TTypeAFObj=taoObject):TAFObj;
  Function ObjToHandle(Obj:TObject):PtrUdf;

implementation
{$IFDEF WINDOWS}
  uses Windows;
{$ENDIF}
{not used?}
(*procedure _FreeObj(Handle:PtrUdf);

*)
function GetMessageError(MessageID:DWORD):String;
{$IFDEF WINDOWS}
  var MessError:DWORD;
  res:DWORD;
{$ENDIF}
begin
  {$IFDEF Unix}
  Result :=  'Error ID:' + IntToStr(MessageID);
  {$ELSE}
  result := 'Unknow error.';
  MessError :=  LocalAlloc(LMEM_MOVEABLE,4096);
  res := FormatMessage({FORMAT_MESSAGE_ALLOCATE_BUFFER OR}
              FORMAT_MESSAGE_FROM_SYSTEM  OR
              FORMAT_MESSAGE_IGNORE_INSERTS,nil,MessageID,
              {MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT)}
              LANG_SYSTEM_DEFAULT,{%H-}Pointer(MessError),4096,nil);
  if res > 0 then
  result := Copy({%H-}Pchar(MessError),0,res * sizeof(char));
  LocalFree(MessError);
  {$ENDIF}
end;


procedure _FreeObj(Handle:PtrUdf);
var afobj:TAFObj;
begin
  afobj := TAFObj.FindObj(Handle,taoUnknow);
  if afobj = nil then exit;
  afobj.Free;
end;

Function ObjToHandle(Obj:TObject):PtrUdf;
begin
  try
   Result :=  {%H-}PtrUdf(Pointer(Obj));
  except
  end;
end;

Function HandleToObj(Handle:PtrUdf):TObject;
begin
  try
   Result :=  TObject ({%H-}Pointer(Handle));
  except
  end;
end;

function HandleToAfObj(Handle: PtrUdf;AType:TTypeAFObj): TAFObj;
begin
  result := TAFObj.FindObj(Handle,AType);
  result.ClearError;
end;


{ TAFObj }
procedure TAFObj.ClearError;
begin
  FLastError:=0;
  FLastErrorIsException := false;
  FLastErrorMessageException := '';
end;

constructor TAFObj.Create(AObj: TObject);
begin
  FTypeAFObj := taoObject;
  FObj := AObj;
  ClearError;
end;

constructor TAFObj.Create(AObj:Pointer;SizeMem:Cardinal);
begin
  FTypeAFObj := taoMem;
  PFObj := AObj;
  FSizeMem := SizeMem;
  ClearError;
end;

destructor TAFObj.Destroy;
begin
  case FTypeAFObj of
   taoObject: if FObj<>nil then
                 FObj.Free;
   taoMem : if PFObj<>nil then
              Freemem(PFObj,FSizeMem);
  end;
  inherited Destroy;
end;

class function TAFObj.FindObj(AHandle: PtrUdf;
  ATypeAFObj: TTypeAFObj): TAFObj;
begin
  result := nil;
  try
    Result := TAFObj({%H-}Pointer(AHandle));
    if (taoUnknow<>ATypeAFObj) and (Result.TypeAFObj <> ATypeAFObj) then
      result := nil;
  except
  end;
end;

procedure TAFObj.NilMemory;
begin
  PFObj:=nil;
end;

procedure TAFObj.FixedError;
begin
  {$IFDEF LINUX}
  //todo: errno
  FLastError:= 1;
  {$ELSE}
  FLastError:=GetLastError;
  {$ENDIF}
  FLastErrorIsException:=False;
end;

procedure TAFObj.FixedError(E: Exception);
begin
  FLastError := 0;
  FLastErrorIsException := true;
  FLastErrorMessageException:=e.Message;
end;

function TAFObj.GetHandle: PtrUdf;
begin
  result := {%H-}PtrUdf (Pointer(Self));
end;

function TAFObj.GetMemory: Pointer;
begin
  result := nil;
  if FTypeAFObj = taoMem then
    result := PFObj;
end;

function TAFObj.GetMessageLastError: string;
begin
  if FLastErrorIsException then
    result := FLastErrorMessageException
  else
  begin
    result := GetMessageError(FLastError);
  end;
end;

function TAFObj.GetObj: TObject;
begin
  result := nil;
  if FTypeAFObj = taoObject then
    result := FObj;
end;

function TAFObj.WasError: boolean;
begin
 result :=  (FLastErrorIsException)
            or
            (FLastError>0);
end;

end.

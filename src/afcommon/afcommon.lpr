 {
    This file is part of the AF UDF library for Firebird 1.0 or high.
    Copyright (c) 2007-2009 by Arteev Alexei, OAO Pharmacy Tyumen.

    See the file COPYING.TXT, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    email: alarteev@yandex.ru, arteev@pharm-tmn.ru, support@pharm-tmn.ru

 **********************************************************************
    Library management of objects created in other modules AFUDF
 **********************************************************************}


library afcommon;
{$MODE Delphi}

uses
  smudfstatic,
  {$IfDef DEBUG}
  heaptrc,
  {$EndIf}
  SysUtils,
  Classes,
  uafudfs in '../common/uafudfs.pas',
  ib_util,
  ufbblob in '../cmnunits/ufbblob.pas';

{IFDEF WINDOWS}{R afcommon.rc}{ENDIF}
const
  sVersion = {$I verafudf.inc};
  sVersionEx = {$I verexafudf.inc};

{ Returns the last error code of the operating system for an object }
function GetLastErrorObj(var Handle:PtrUdf):integer;cdecl;
begin
  result := 0;
  try
    Result := TAFObj.FindObj(Handle,taoUnknow).LastError;
  except
  end;
end;

{ Returns the last error text object }
function MsgLastErrorObj(var Handle:PtrUdf):Pchar;cdecl;
var
    s : string;
begin
  try
    s:=TAFObj.FindObj(Handle,taoUnknow).MessageLastError;
    result := ib_util_malloc(Length(s)+1);
    strcopy(result,Pchar(s));
  except
  end;
end;

{ Returns whether there was a mistake at the last operation with the object }
function WasErrorObj(var Handle:PtrUdf):integer;cdecl;
begin
  try
    result := Integer(TAFObj.FindObj(Handle,taoUnknow).WasError);
  except
    result := FalseInt;
  end;
end;

{ Returns whether an error exception if the last operation with the object }
function WasErrorIsExceptionObj(var Handle:PtrUdf):integer;cdecl;
begin
  result := FalseInt;
  try
    result := Integer(TAFObj.FindObj(Handle,taoUnknow).LastErrorIsException);
  except
  end;
end;


{ Sets the text of the error object }
function SetMsgErrorExceptionObj(var Handle:PtrUdf;Msg:Pchar):integer;cdecl;
var obj:TAFObj;
begin
  result := TrueInt;
  try
    try
      raise exception.Create(string(Msg));
    except
      on e:Exception do
      begin
        obj := TAFObj.FindObj(Handle,taoUnknow);
        if Assigned(obj) then obj.FixedError(e);
      end;
    end;
  except
  end;
end;



{ It frees the memory occupied by objects created by another module }
function FreeAFObject(var Handle:PtrUdf):integer;cdecl;
var
  obj:TObject;
  vmt:PVmt;
  curclass: String;
begin
  result := FalseInt;
  try
    obj := HandleToObj(Handle);
    if not Assigned(obj) then exit(FalseInt);
    {check class}
    Vmt := PVmt(Obj.ClassType);
    curclass := vmt^.vClassName^;
    if SameText(curclass,'TAFObj') or
       SameText(curclass,'TXPathNodeSetVariable') then
    begin
      Obj.Free;
      result := TrueInt;
    end
    else
      result := FalseInt;
  except
    result := FalseInt;
  end;
end;

{ Returns the version of the libraries in the short format 1.0.0 }
function VersionAFUDF():Pchar;cdecl;
begin
  result := ib_util_malloc(Length(sVersionEx)+1);
  strcopy(result,Pchar(sVersion));
end;

{ Returns the version of the libraries in the long format 1.0.0.build release }
function VersionExAFUDF():PChar;cdecl;
begin
  result := ib_util_malloc(Length(sVersionEx)+1);
  strcopy(result,Pchar(sVersionEx));
end;


function Version():Pchar;cdecl;
begin
  Result := VersionAFUDF();
end;

function VersionEx():PChar;cdecl;
begin
  Result := VersionAFUDF;
end;

{ Returns the type of operating system windows / linux and CPU architecture}
function GetTypeOS():Pchar;cdecl;
var
    s : string;
begin
  s:=
     {$IFDEF linux}
             'linux'
             {$IFDEF CPUX86_64}
             +'-x86_64'
             {$ELSE}
             +'-i386'
             {$ENDIF}
     {$ENDIF}
     {$IFDEF windows}
             'win'
             {$IFDEF CPUX86_64}
             +'64'
             {$ELSE}
             +'32'
             {$ENDIF}
     {$ENDIF};
  result := ib_util_malloc(Length(s)+1);
  StrPCopy(result,s);
end;

exports
  GetLastErrorObj,
  MsgLastErrorObj,
  WasErrorObj,
  WasErrorIsExceptionObj,
  SetMsgErrorExceptionObj,
  FreeAFObject,
  VersionAFUDF,
  VersionExAFUDF,
  GetTypeOS,

  {aliases}
  Version,
  VersionEx;


{$R afcommon.res}

begin
  {$IfDef DEBUG}
  SetHeapTraceOutput(GetEnvironmentVariable('TEMP')+DirectorySeparator+'afudf.'+{$I %FILE%}+'.heap.trc');
  {$EndIf}
end.

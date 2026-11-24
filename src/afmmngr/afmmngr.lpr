library afmmngr;
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

{
   Shared memory dispatcher
   For all udf-libraries must be declared module
   ShareMemUDF, who gets out of this memory manager
   library (afmmngr.so, afmmngr.dll)
}

{$mode objfpc}{$H+}

{IFDEF WINDOWS}
  {R afmmngr.rc}
{ENDIF}
{$R afmmngr.res}

uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  Classes, syncobjs;

var
  currentMemoryManager : TMemoryManager ;
  ObjRegistry   : TList;
  RegistryLock  : TCriticalSection;

  { The function returns the memory manager for the remaining libraries }
function GetUdfMemoryManager:TMemoryManager;cdecl;
begin
  result := currentMemoryManager;
end;

{ Shared object registry: handles returned to SQL are validated here,
  so a garbage handle can no longer be dereferenced as an object }
procedure RegisterUdfObj(Obj: Pointer); cdecl;
begin
  RegistryLock.Enter;
  try
    if ObjRegistry.IndexOf(Obj) < 0 then
      ObjRegistry.Add(Obj);
  finally
    RegistryLock.Leave;
  end;
end;

procedure UnregisterUdfObj(Obj: Pointer); cdecl;
begin
  RegistryLock.Enter;
  try
    ObjRegistry.Remove(Obj);
  finally
    RegistryLock.Leave;
  end;
end;

function FindUdfObj(Handle: Pointer): Pointer; cdecl;
begin
  RegistryLock.Enter;
  try
    if ObjRegistry.IndexOf(Handle) >= 0 then
      Result := Handle
    else
      Result := nil;
  finally
    RegistryLock.Leave;
  end;
end;

exports
   GetUdfMemoryManager name 'GetUdfMemoryManager',
   RegisterUdfObj name 'RegisterUdfObj',
   UnregisterUdfObj name 'UnregisterUdfObj',
   FindUdfObj name 'FindUdfObj';
initialization
  GetMemoryManager(currentMemoryManager);
  RegistryLock := TCriticalSection.Create;
  ObjRegistry := TList.Create;
finalization
  ObjRegistry.Free;
  RegistryLock.Free;
end.

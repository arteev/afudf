
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
unit sharememudf;
{
  Shared Memory Manager
}
{$mode objfpc}{$H+}
{$SMARTLINK OFF}
interface
uses
  dynlibs;

Type
  TFuncMemUDF      = function :TMemoryManager;cdecl;

implementation
var
  GetUdfMemoryManager : TFuncMemUDF;
  OldMemMng           : TMemoryManager;
  hmmgr               : TLibHandle = 0;

procedure InitMmmgr;
begin
   GetMemoryManager(OldMemMng);
   {$IFDEF UNIX}
   hmmgr:=LoadLibrary('afmmngr.so');
   {$ELSE}
   hmmgr:=LoadLibrary('afmmngr.dll');
   {$ENDIF}
   if hmmgr>0 then
   begin
     GetUdfMemoryManager := TFuncMemUDF(GetProcAddress(hmmgr,'GetUdfMemoryManager'));
     if @GetUdfMemoryManager<>nil then
     begin
       SetMemoryManager(GetUdfMemoryManager());
     end
     else
     begin
       FreeLibrary(hmmgr);
       hmmgr := 0;
     end;
   end;
end;


initialization
  InitMmmgr;
finalization
  SetMemoryManager(OldMemMng);
  if hmmgr>0 then
    FreeLibrary(hmmgr);
end.


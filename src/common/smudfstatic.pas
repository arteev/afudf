Unit smudfstatic;
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
    Shared memory manager
 **********************************************************************}

{$mode objfpc}
{$H+}
Interface

function GetUdfMemoryManager:TMemoryManager;cdecl;external 'afmmngr' name 'GetUdfMemoryManager';

implementation
var
  OldMemoryManager : TMemoryManager;

procedure InitMemoryManager;
begin
   GetMemoryManager(OldMemoryManager);
   SetMemoryManager(GetUdfMemoryManager());
end;

initialization
  InitMemoryManager;
finalization
  SetMemoryManager(OldMemoryManager);
End.


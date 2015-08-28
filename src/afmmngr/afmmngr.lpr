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
var
  currentMemoryManager : TMemoryManager ;

  { The function returns the memory manager for the remaining libraries }
function GetUdfMemoryManager:TMemoryManager;cdecl;
begin
  result := currentMemoryManager;
end;

exports
   GetUdfMemoryManager name 'GetUdfMemoryManager';
initialization
  GetMemoryManager(currentMemoryManager);
finalization
end.




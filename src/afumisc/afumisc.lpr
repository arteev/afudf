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
library afumisc;

{$mode objfpc}{$H+}

uses
  sharememudf,
  {$IfDef DEBUG}
  heaptrc,
  {$EndIf}
  Classes, sysutils, uafmisc, ib_util;

{$R afumisc.res}
{IFDEF WINDOWS}{R afumisc.rc}{ENDIF}

exports
  GenGuid,
  DelCharsFromBlob;
begin
  {$IfDef DEBUG}
  SetHeapTraceOutput(GetEnvironmentVariable('TEMP')+DirectorySeparator+'afudf.'+{$I %FILE%}+'.heap.trc');
  {$EndIf}
end.


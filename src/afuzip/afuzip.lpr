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
library afuzip;

{$MODE objfpc}

uses
  smudfstatic,
  {$IfDef DEBUG}
  heaptrc,
  {$EndIf}
  SysUtils,
  Classes,
  uafudfs in '../common/uafudfs.pas', ib_util,
  uafzip in 'uafzip.pas',
  ufbblob in '../cmnunits/ufbblob.pas';

{R *.res}
exports
  CreateZIP,
  SetArhiveFileZIP,
  AddSpecZIP,
  ClearSpecZIP,
  CompressZIP,
  CreateUnZIP,
  SetExtractDirZIP,
  ExtractZIP;

{$R afuzip.res}
{IFDEF WINDOWS}{R afuzip.rc}{ENDIF}
begin
  {$IfDef DEBUG}
  SetHeapTraceOutput(GetEnvironmentVariable('TEMP')+DirectorySeparator+'afudf.'+{$I %FILE%}+'.heap.trc');
  {$EndIf}
end.

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
library afucrypt;

{$MODE objfpc}
uses
  smudfstatic,
  {$IfDef DEBUG}
  heaptrc,
  {$EndIf}
  sysutils,
  uafcrypt in 'uafcrypt.pas',
  uafudfs in '../common/uafudfs.pas',
  ufbblob in '../cmnUnits/ufbblob.pas';


{IFDEF WINDOWS}{R afucrypt.rc}{ENDIF}

exports
  CryptSha1String,
  CryptSha1BLOB,
  CryptSha1File,

  CryptMD5,
  CryptMD5Blob,
  CryptMD5File,

  CryptCRC32,
  CryptCRC32Blob,
  CryptCRC32File;

{$R afucrypt.res}

begin
  {$IfDef DEBUG}
  SetHeapTraceOutput(GetEnvironmentVariable('TEMP')+DirectorySeparator+'afudf.'+{$I %FILE%}+'.heap.trc');
  {$EndIf}
end.

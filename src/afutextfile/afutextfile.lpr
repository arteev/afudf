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

{ Library access to text files }

library afutextfile;

{$mode objfpc}{$H+}

uses
  smudfstatic,
  {$IfDef DEBUG}
  heaptrc,
  {$EndIf}
  SysUtils,
  uafudfs in '../common/uafudfs.pas',
  uaftextfile in 'uaftextfile.pas', ioresdecode, ib_util;

exports
  CreateTextFile,
  ResetTextFile,
  CloseTextFile,
  WriteToTextFile,
  WriteLnToTextFile,
  RewriteTextFile,
  ReadLnFromTextFile,
  EofTextFile,
  FlushTextFile,
  AppendTextFile,

  ReadCharFromTextFile,
  ReadInt32FromTextFile,
  ReadInt64FromTextFile,

  WriteInt32ToTextFile,
  WriteInt64ToTextFile;

{IFDEF WINDOWS}{R afutextfile.rc}{ENDIF}

{$R afutextfile.res}

begin
  {$IfDef DEBUG}
  SetHeapTraceOutput(GetEnvironmentVariable('TEMP')+DirectorySeparator+'afudf.'+{$I %FILE%}+'.heap.trc');
  {$EndIf}
  DefaultFormatSettings.DecimalSeparator := '.';
  DefaultFormatSettings.ShortDateFormat :=  'yyyy/mm/dd';
  DefaultFormatSettings.LongDateFormat :=  'yyyy/mm/dd';
  DefaultFormatSettings.DateSeparator	:= '-';
end.


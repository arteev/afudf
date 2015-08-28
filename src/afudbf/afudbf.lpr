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
library afudbf;

{$MODE Delphi}

uses
  smudfstatic,
  {$IfDef DEBUG}
  heaptrc,
  {$EndIf}
  SysUtils,
  uafdbf in 'uafdbf.pas',
  uafudfs in '../common/uafudfs.pas', ib_util, ucodestr, udbfwrap;

{IFDEF WINDOWS}{R afudbf.rc}{ENDIF}
exports
   CreateDBF,
   CreateTableDBF,
   OpenDBF,
   CloseDBF,
   StateDBF,
   RecNoDBF,
   RecordCountDBF,
   SetRecNoDBF,
   SetValueDBFFieldByName,
   NextInDBF,
   PrevInDBF,
   FirstInDBF,
   LastInDBF,
   EofInDBF,
   EditDBF,
   PostDBF,
   AppendDBF,
   DeleteDBF,
   CancelDBF,
   PackDBF,
   FieldCountDBF,
   FieldExistsDBF,
   GetFieldNameDBFByIndex,
   GetValueDBFFieldByName,
   AddFieldDBF,
   ValueIsNullDBF,
   SetFormatDBF,
   GetFormatDBF;

{$R afudbf.res}

begin
  {$IfDef DEBUG}
  SetHeapTraceOutput(GetEnvironmentVariable('TEMP')+DirectorySeparator+'afudf.'+{$I %FILE%}+'.heap.trc');
  {$EndIf}
  DefaultFormatSettings.DecimalSeparator := '.';
  DefaultFormatSettings.ShortDateFormat :=  'YYYY/MM/DD';
  DefaultFormatSettings.LongDateFormat :=  'YYYY/MM/DD';
  DefaultFormatSettings.DateSeparator	:= '-';
end.

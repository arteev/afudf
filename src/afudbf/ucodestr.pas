
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
unit ucodestr;

{$mode objfpc}{$H+}
interface
uses
  sysutils;
const
  rus_chars: pChar = #197#210#211#206#208#192#205#202#213#209
  + #194#204#229#243#232#238#240#224#234#245#241#236
    ;
  lat_chars: pChar = 'ETYOPAHKXCBMeyuopakxcm';
  small_chars: pChar =
  #113#119#101#114#116#121#117#105#111#112#97#115#100#102#103
    + #104#106#107#108#122#120#99#118#98#110#109#233#246#243#234
    + #229#237#227#248#249#231#245#250#244#251#226#224#239#240#238
    + #235#228#230#253#255#247#241#236#232#242#252#225#254#184
    ;
  cap_chars: pChar =
  #81#87#69#82#84#89#85#73#79#80#65#83#68#70#71#72#74#75#76#90
    + #88#67#86#66#78#77#201#214#211#202#197#205#195#216#217#199
    + #213#218#212#219#194#192#207#208#206#203#196#198#221#223#215
    + #209#204#200#210#220#193#222#168
    ;
  cp1251: pChar =
  #233#246#243#234#229#237#227#248#249#231#245#250#244#251#226
    + #224#239#240#238#235#228#230#253#255#247#241#236#232#242#252
    + #225#254#184#201#214#211#202#197#205#195#216#217#199#213#218
    + #212#219#194#192#207#208#206#203#196#198#221#223#215#209#204
    + #200#210#220#193#222#168#185
    ;
  (* arteev.av: changed cp866: -> 185 на 252 *)
  cp866: pChar =
  #169#230#227#170#165#173#163#232#233#167#229#234#228#235#162
    + #160#175#224#174#171#164#166#237#239#231#225#172#168#226#236
    + #161#238#241#137#150#147#138#133#141#131#152#153#135#149#154
    + #148#155#130#128#143#144#142#139#132#134#157#159#151#145#140
    + #136#146#156#129#158#240#252
    ;
  koi8: pChar =
  #202#195#213#203#197#206#199#219#221#218#200#223#198#217#215#193
    + #208#210#207#204#196#214#220#209#222#211#205#201#212#216#194#192
    + #163
    + #234#227#245#235#229#238#231#251#253#250#232#255#230#249#247#225
    + #240#242#239#236#228#246#252#241#254#243#237#233#244#248#226#224
    + #179
    ;


function replace_it(CString: PChar; scr: PChar; dest: PChar): PChar;
function latrus(CString: PChar): PChar; stdcall;
function rupper(CString: PChar): PChar; stdcall;
function rlower(CString: PChar): PChar; stdcall;
function dos2win(CString: PChar): PChar; stdcall;
function win2dos(CString: PChar): PChar; stdcall;
function koi82win(CString: PChar): PChar; stdcall;
function koi82dos(CString: PChar): PChar; stdcall;
function dos2koi8(CString: PChar): PChar; stdcall;
function win2koi8(CString: PChar): PChar; stdcall;
function UDF_strcat(dest, source: pchar): pchar; stdcall;


implementation

function replace_it(CString: PChar; scr: PChar; dest: PChar): PChar;

var
  i, j: integer;
begin
  i := 0;
  while (CString[i] <> #0) do
  begin
    j := 0;
    while (scr[j] <> #0) do
    begin
      if CString[i] = scr[j] then
      begin
        CString[i] := dest[j];
        Break;
      end;
      inc(j);
    end;
    inc(i);
  end;

  result := CString;
end;

function latrus(CString: PChar): PChar; stdcall;
begin
  result := replace_it(CString, lat_chars, rus_chars);
end;

function rupper(CString: PChar): PChar; stdcall;
begin
  result := replace_it(CString, small_chars, cap_chars);
end;

function rlower(CString: PChar): PChar; stdcall;
begin
  result := replace_it(CString, cap_chars, small_chars);
end;

function dos2win(CString: PChar): PChar; stdcall;
begin
  result := replace_it(CString, cp866, cp1251);
end;

function win2dos(CString: PChar): PChar; stdcall;
begin
  result := replace_it(CString, cp1251, cp866);
end;

function koi82win(CString: PChar): PChar; stdcall;
begin
  result := replace_it(CString, koi8, cp1251);
end;

function koi82dos(CString: PChar): PChar; stdcall;
begin
  result := replace_it(CString, koi8, cp866);
end;

function dos2koi8(CString: PChar): PChar; stdcall;
begin
  result := replace_it(CString, cp866, koi8);
end;

function win2koi8(CString: PChar): PChar; stdcall;
begin
  result := replace_it(CString, cp1251, koi8);
end;

function UDF_strcat(dest, source: pchar): pchar; stdcall;
begin
  result := strcat(dest, source);
end;

end.

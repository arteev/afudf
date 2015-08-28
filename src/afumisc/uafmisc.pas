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
unit uafmisc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,ufbblob;
  { New GUID }
  function GenGuid():PChar;cdecl;

  { Delete symbols from BLOB }
  procedure DelCharsFromBlob(Var BLobIn:TFBBlob;var Ch:Integer;Var BLobOut:TFBBlob);cdecl;


implementation
uses
  ib_util;

function GenGuid():PChar;cdecl;
var
  g : TGuid;
  s : string;
begin
  if CreateGUID(g)<> 0 then exit(nil);
  s:=GUIDToString(g);
  result := ib_util_malloc(Length(s)+1);
  StrPCopy(result, s);
end;

{ Delete symbols from BLOB }
procedure DelCharsFromBlob(Var BLobIn:TFBBlob;var Ch:Integer;Var BLobOut:TFBBlob);cdecl;
var s       : PChar;
    rl      : Integer;
    sRep    : String;
    blen    : LongInt;
begin
  blen:=BLobIn.TotalLength;
  s := nil;
  if not Assigned(BLobIn.Handle) then Exit;
  GetMem(s,blen+1);
  try
    s[blen]:=#0;
    rl := 0;
    FillBuffer(BLobIn,S,blen,rl);
    if rl>0 then
    begin
      sRep:=StringReplace(s,chr(ch),'',[rfReplaceAll]);
      PCharToBlob(PChar(sRep),BLobOut);
    end;
  finally
    FreeMem(S,blen+1);
  end;
end;

end.


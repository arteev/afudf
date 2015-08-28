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
unit iconvwin;
interface

{$mode objfpc}{$H+}
const
    ESysEILSEQ      = 84;
    ESysE2BIG       = 7;

type
  Piconv_t = ^iconv_t;
  iconv_t  = pointer;

  size_t  = longword;
  pSize   = ^size_t;
  psize_t = pSize;




function iconv_open(__tocode: PChar; __fromcode: PChar): iconv_t; cdecl;
  external 'iconv' Name 'libiconv_open';
function iconv(__cd: iconv_t; __inbuf: PPchar; __inbytesleft: Psize_t;
  __outbuf: PPchar; __outbytesleft: Psize_t): size_t; cdecl;
  external 'iconv' Name 'libiconv';
function iconv_close(__cd: iconv_t): longint; cdecl;
  external 'iconv' Name 'libiconv_close';


function errno_location: PInteger; cdecl; external 'msvcrt.dll' name '_errno';

function Iconvert(S: string; var res: string; FromEncoding, ToEncoding: string): longint;


implementation

function Iconvert(S: string; var res: string; FromEncoding, ToEncoding: string): longint;
var
  InLen, OutLen, Offset: longint;
  Src, Dst: PChar;
  H:    iconv_t;
  lerr: plongint;
  iconvres: longint;
begin
  H := iconv_open(PChar(ToEncoding), PChar(FromEncoding));
  if H=nil then
  begin
    Res := S;
    Exit(-1);
  end;
  try
    SetLength(Res, Length(S));
    InLen  := Length(S);
    OutLen := Length(Res);
    Src    := PChar(S);
    Dst    := PChar(Res);
    while InLen > 0 do
    begin
      iconvres := iconv(H, @Src, @InLen, @Dst, @OutLen);
      if iconvres = longint(-1) then
      begin

        lerr:=errno_location;

        if lerr^=ESysEILSEQ then // unknown char, skip
         begin
           Dst^:=Src^;
           Inc(Src);
           Inc(Dst);
           Dec(InLen);
           Dec(OutLen);
         end
        else
          if lerr^=ESysE2BIG then
          begin
              Offset := Dst - PChar(Res);
              SetLength(Res, Length(Res) + InLen * 2 + 5); // 5 is minimally one utf-8 char
              Dst    := PChar(Res) + Offset;
              OutLen := Length(Res) - Offset;
          end
          else
            exit(-1)
      end;
    end;
    // iconv has a buffer that needs flushing, specially if the last char is not #0
    iconvres := iconv(H, nil, nil, @Dst, @Outlen);
    SetLength(Res, Length(Res) - outlen);
  finally
      iconv_close(H);
  end;
  Result := 0;
end;

end.


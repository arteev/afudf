unit uafcrypt;
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

{$MODE objfpc}
{$H+}
interface


uses Classes,ufbblob, SysUtils;

{Computes the hash value for the buffer Buf in accordance with the algorithm SHA1}
function CryptSha1String (Buf: PChar): PChar; cdecl;
{Computes the hash value for the BLOB in accordance with the algorithm SHA1}
function CryptSha1BLOB (var Blob: TFBBlob): PChar; cdecl;
{Calculate the hash value for the file in accordance with the algorithm SHA1}
function CryptSha1File (FileName: Pchar): PChar; cdecl;
{Calculation CRC32 checksum for the string}
function CryptCRC32 (Buf: PChar): PChar; cdecl;
{Calculation CRC32 checksum for blob}
function CryptCRC32Blob (var Blob: TFBBlob): PChar; cdecl;
{Calculation CRC32 checksum file}
function CryptCRC32File (FileName: Pchar): PChar; cdecl;
{Calculate MD5 for a string}
function CryptMD5 (Buf: PChar): PChar; cdecl;
{Calculating the MD5 blob}
function CryptMD5Blob (var Blob: TFBBlob): PChar; cdecl;
{Calculate MD5 file}
function CryptMD5File (FileName: Pchar): PChar; cdecl;

implementation

uses sha1, md5, ib_util, crc;

Const
  max_len_declare    = 40;
  max_len_declareCrc = 8;
  max_len_declareMd5 = 32;

function GetSizeAllocSmart(s:String;max: Integer):integer;
var
   l : Integer;
begin
  l := Length(s);
  if l >= max then
    result := max
  else
    result := l;
end;

function CryptSha1String(Buf:PChar):PChar;cdecl;
var
   S:String;
begin

  if strlen(Buf)=0 then
    exit(nil);
  try
    s:= SHA1Print(SHA1String(StrPas(Buf)));
    result := ib_util_malloc(GetSizeAllocSmart(s,max_len_declare)+1);
    StrPLCopy(result,s,max_len_declare);
  except
    result := nil;
  end;
end;


function CryptSha1BLOB(var Blob:TFBBlob):PChar;cdecl;
var B:PChar;
    ReadLength:Integer;
    s: string;
    blen: LongInt;
begin
   try
     if not Assigned(Blob.Handle) then Exit(nil);
     blen:=Blob.TotalLength;
     Getmem(B,blen+1);
     try
       ReadLength:=0;
       FillBuffer(Blob,B,blen,ReadLength);
       if ReadLength>0 then
       begin
         s:= SHA1Print(SHA1Buffer(Pointer(B)^,blen));
         result := ib_util_malloc(GetSizeAllocSmart(s,max_len_declare)+1);
         StrPLCopy(result,s,max_len_declare);
       end
       else
         result := nil;
     finally
       Freemem(B,blen+1);
     end;
   except
     result := nil;
   end;
end;

function CryptSha1File(FileName:Pchar):PChar;cdecl;
var
   S:String;
begin
  try
    if (strlen(FileName)=0) or (not FileExists(FileName)) then
    begin
      exit(nil);
    end;
    s:= SHA1Print(SHA1File(StrPas(FileName)));
    Result := ib_util_malloc(GetSizeAllocSmart(s,max_len_declare)+1);
    StrPLCopy(Result,s,max_len_declare);
  except
    Result := nil;
  end;

end;

function CryptCRC32s(Buf:PChar):string;
var
  len: LongInt;
  res:dword;
Begin
  len:=strlen(Buf);
  if (Buf = nil) then
    exit('');
  res := crc32(Cardinal($FFFFFFFF), nil, 0);
  res := crc32(res, Pbyte(@Buf[0]), len);
  try
    if res<>0 then
      Result:= IntToHex(res,8)
    else
      result := '';
  except
    result := '';
  end;
end;

function CryptCRC32(Buf:PChar):PChar;cdecl;
var
  s: String;
Begin
  try
    s:= CryptCRC32s(Buf);
    if (s='') then
      exit(nil);
    Result := ib_util_malloc(GetSizeAllocSmart(s,max_len_declareCrc)+1);
    StrPLCopy(Result,s,max_len_declareCrc);
  except
    result := nil;
  end;
end;

function CryptCRC32Blob(var Blob:TFBBlob):PChar;cdecl;
var B:PChar;
    ReadLength:Integer;
    blen: LongInt;
    s : string;
begin
   try
     if not Assigned(Blob.Handle) then Exit(nil);
     blen:=Blob.TotalLength;
     Getmem(B,blen+1);
     try
       ReadLength:=0;
       FillBuffer(Blob,B,blen,ReadLength);
       if ReadLength>0 then
       begin
         s := CryptCRC32s(B);
         if (s='') then
           exit(nil);
         Result := ib_util_malloc(GetSizeAllocSmart(s,max_len_declareCrc)+1);
         StrPLCopy(Result,s,max_len_declareCrc);
       end
       else
         Result := nil;
     finally
       Freemem(B,blen+1);
     end;
   except
     result := nil;
   end;
end;

function CryptCRC32File(FileName:Pchar):PChar;cdecl;
var B:array [0..4095] of byte;
    s: AnsiString;
    fs:TFileStream;
    res: LongWord;
    leng: LongInt;
begin
  try
    if (strlen(FileName)=0) or (not FileExists(FileName)) then
      exit(nil);
    fs:=TFileStream.Create(FileName,fmOpenRead);
    try
      res := crc32(Cardinal($FFFFFFFF), nil, 0);
      while fs.Position<fs.Size do
      begin
        leng := fs.Read(B,4096);
        if leng >0 then
          res := crc32(res, PByte(@B[0]), leng);
      End;
      s:= IntToHex(res,8);
      Result := ib_util_malloc(GetSizeAllocSmart(s,max_len_declareCrc)+1);
      StrPLCopy(Result,s,max_len_declareCrc);
    Finally
      fs.Free;
    End;
   except
     Result := nil;
   end;
end;

function CryptMD5(Buf:PChar):PChar;cdecl;
var
   S:String;
begin
  try
    if strlen(Buf)=0 then
      exit(nil);
    s:= MD5Print(MD5String(StrPas(Buf)));
    Result := ib_util_malloc(GetSizeAllocSmart(s,max_len_declareMd5)+1);
    StrPLCopy(Result,s,max_len_declareMd5);
  except
    Result := nil;
  end;
end;

function CryptMD5Blob(var Blob:TFBBlob):PChar;cdecl;
var B:PChar;
    ReadLength:Integer;
    s: AnsiString;
    blen: LongInt;
begin
  try
   if not Assigned(Blob.Handle) then Exit(nil);
   blen:=Blob.TotalLength;
   Getmem(B,blen+1);
   try
     ReadLength:=0;
     FillBuffer(Blob,B,Blob.TotalLength,ReadLength);
     if ReadLength>0 then
     begin
       s:= MD5Print(MD5Buffer(B^,Blob.TotalLength));
       Result := ib_util_malloc(GetSizeAllocSmart(s,max_len_declareMd5)+1);
       StrPLCopy(Result,PChar(s),max_len_declareMd5);
     end
     else
       Result := nil;
   finally
     Freemem(B,blen+1);
   end;
  except
    Result := nil;
  End;
end;

function CryptMD5File(FileName:Pchar):PChar;cdecl;
var
   S:String;
begin
  try
    if (strlen(FileName)=0) or (not FileExists(FileName)) then
      exit(nil);
    s:= MD5Print(MD5File(StrPas(FileName)));
    Result := ib_util_malloc(GetSizeAllocSmart(s,max_len_declareMd5)+1);
    StrPLCopy(Result,s,max_len_declareMd5);
  except
    Result := nil;
  end;
end;

end.

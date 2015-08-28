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


unit ufbblob;


{$MODE objfpc}
{$H+}

interface
  uses Classes;

Type
 // FireBird/Interbase BLOB structure
 PFBBlob=^TFBBlob;
 TFBBlob = record
    GetSegment : function(Handle : Pointer; Buffer : PChar;
     MaxLength : Longint; var ReadLength : Longint) : WordBool; cdecl;
    Handle : Pointer;               // BLOb handle
    SegCount,                       // Number of BLOb segments
    MaxSegLength,                   // Max length of BLOb segment
    TotalLength : Longint;             // Total BLOb length
    PutSegment : procedure(Handle : Pointer; Buffer : PChar;
      Length : Longint); cdecl;
    // Seek : function : Long; cdecl; // I don'n know input parameters
  end;

Type

  { TFBBlobStream }

  TFBBlobStream=class(TStream)
    private
      FBlob:PFBBlob;
      FPos:Int64;
    protected

      function  GetPosition: Int64; override;
      procedure SetPosition(const {%H-}Pos: Int64); override;
      function  GetSize: Int64; override;
      procedure SetSize64(const {%H-}NewSize: Int64);override;
      procedure SetSize({%H-}NewSize: Longint); override;overload;
      procedure SetSize(const {%H-}NewSize: Int64); override;overload;

      procedure NotSupportedSize;
      procedure NotSupportedSeek;
    public
      constructor Create(Blob:PFBBlob);
      function Read(var Buffer; Count: Longint): Longint; override;
      function Write(const Buffer; Count: Longint): Longint; override;
      function Seek({%H-}Offset: Longint; {%H-}Origin: Word): Longint; override; overload;
      function Seek(const {%H-}Offset: Int64; {%H-}Origin: TSeekOrigin): Int64; override; overload;


    end;

{ Copy from Blob into Buffer }
function FillBuffer(var BLOb : TFBBlob; Buf : PChar; FreeBufLen : Integer;
  var ReadLen : Integer) : Boolean;

{ Fill Blob from Pchar }
procedure PCharToBlob(S:PChar;var BLob:TFBBlob);

const
  MaxBLObPutLength = 80;
  MaxVarCharLength = 32766;

implementation
uses SysUtils;


procedure PCharToBlob(S:PChar;var BLob:TFBBlob);
var  len, PutLength: LongInt;
begin
    len := StrLen(S);
    if len = 0 then Exit; // Is it possible to set BLOb = null when
                                    // StrLen(CString) = 0 ?
    with BLOb do
      if not Assigned(Handle) then Exit;

    while len > 0 do begin
      if len > MaxBLObPutLength then PutLength := MaxBLObPutLength
      else PutLength := len;

      with BLOb do
        PutSegment(Handle, S,PutLength);

      Dec(len, PutLength);
      Inc(S, PutLength);
    end;
end;

function FillBuffer(var BLOb : TFBBlob; Buf : PChar; FreeBufLen : Integer;
  var ReadLen : Integer) : Boolean;
var
  EndOfBLOb : Boolean;
  FreeBufLenX, GotLength : LongInt;
begin
  try
    ReadLen := 0;
    repeat
      GotLength := 0; { !?! }

      if FreeBufLen > MaxBLObPutLength then FreeBufLenX := MaxBLObPutLength
      else FreeBufLenX := FreeBufLen;

      with BLOb do
        EndOfBLOb := not GetSegment(Handle, Buf + ReadLen, FreeBufLenX, GotLength);

      Inc(ReadLen, GotLength);
      Dec(FreeBufLen, GotLength);
    until EndOfBLOb or (FreeBufLen = 0);
  except
  end;
  Buf[ReadLen] := #0;
  Result := EndOfBLOb;
end;

{ TFBBlobStream }

function TFBBlobStream.GetPosition: Int64;
begin
  Exit(FPos);
end;

procedure TFBBlobStream.SetPosition(const Pos: Int64);
begin
  NotSupportedSeek;
end;

function TFBBlobStream.GetSize: Int64;
begin
  if (FBlob<>nil) and Assigned(FBlob^.Handle) then
    result := FBlob^.TotalLength
  else
    result := 0;
end;

procedure TFBBlobStream.SetSize64(const NewSize: Int64);
begin
  NotSupportedSize;
end;

procedure TFBBlobStream.SetSize(NewSize: Longint);
begin
  NotSupportedSize;
end;

procedure TFBBlobStream.SetSize(const NewSize: Int64);
begin
  NotSupportedSize;
end;

procedure TFBBlobStream.NotSupportedSize;
begin
  raise EStreamError.CreateFmt('Change size %s is not supported', [ClassName]) at get_caller_addr(get_frame);
end;

procedure TFBBlobStream.NotSupportedSeek;
begin
    raise EStreamError.CreateFmt('Change position %s is not supported', [ClassName]) at get_caller_addr(get_frame);
end;

constructor TFBBlobStream.Create(Blob: PFBBlob);
begin
  FPos:=0;
  FBlob:=Blob;
end;

function TFBBlobStream.Read(var Buffer; Count: Longint): Longint;
var
  EndOfBLOb : Boolean;
  FreeBufLenX, GotLength : LongInt;
  ReadLen: LongInt;
begin
  try
    ReadLen := 0;
    repeat
      GotLength := 0;
      if Count > MaxBLObPutLength then
        FreeBufLenX := MaxBLObPutLength
      else
        FreeBufLenX := Count;

      with FBLOb^ do
        EndOfBLOb := not GetSegment(Handle, @Buffer + ReadLen, FreeBufLenX, GotLength);

      Inc(ReadLen, GotLength);
      Dec(Count, GotLength);
    until EndOfBLOb or (Count = 0);
  except
  end;
  Result := ReadLen;
end;

function TFBBlobStream.Write(const Buffer; Count: Longint): Longint;
var
  PutAll,
  PutLength: LongInt;
begin

  with FBLOb^ do
    if not Assigned(Handle) then Exit(0);
  PutAll := 0 ;
  while Count > 0 do begin
    if Count > MaxBLObPutLength then
      PutLength := MaxBLObPutLength
    else
      PutLength := Count;
    with FBlob^ do
      PutSegment(Handle, @Buffer+PutAll ,PutLength);
    Dec(Count, PutLength);
    Inc(PutAll, PutLength);
  end;
end;

function TFBBlobStream.{%H-}Seek(Offset: Longint; Origin: Word): Longint;
begin
  NotSupportedSeek;
end;

function TFBBlobStream.{%H-}Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  NotSupportedSeek;
end;

end.

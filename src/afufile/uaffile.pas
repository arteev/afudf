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
unit uaffile;

{$mode objfpc}
{$H+}

interface

uses ufbblob, uafudfs, ib_util;

{ Возвращает существует ли файл }
function FSFileExists(FileName:Pchar):integer; cdecl;

{ Удаляет файл FileName }
function FSFileDelete(FileName:Pchar):integer; cdecl;

{ копирует файл FileNameSource в файл FileNameDest }
function FSFileCopy(FileNameSource,FileNameDest:Pchar;var FailIfExists:integer):integer; cdecl;

{ Создает все директории указанные в пути  FolderName}
function FSForceDirectories(FolderName:PChar):integer;cdecl;

{ Загружает данные из File в Blob }
procedure FSFileToBLob(FileName:PChar;var Blob:TFBBlob); cdecl;
{ Сохраняет данные из Blob в File }
function FSBlobToFile(var Blob:TFBBlob;FileName:PChar):integer; cdecl;

{ Начинает поиск файлов по маске }
function FSFindFirst(Path:PChar;var Attr:Integer):PtrUdf; cdecl;
{ Находит следующий файл }
function FSFindNext(var Handle:PtrUdf):integer; cdecl;
{ Закрывает поиск }
function FSFindClose(var Handle:PtrUdf):integer; cdecl;
{ Возвращает имя последненго найденного файла }
function FSFindRecName(var Handle:PtrUdf):Pchar; cdecl;
{ Возвращает аттрибуты последненго найденного файла }
function FSFindRecAttr(var Handle:PtrUdf):Integer; cdecl;
{ Проверяет аттрибут последненго найденного файла по Attr}
function FSFindRecCheckAttr(var Handle:PtrUdf;var Attr:Integer):Integer; cdecl;



implementation

Uses
  SysUtils,Classes;


Const
  errFile  = THandle(-1);
  TrueInt  = 1;
  FalseInt = 0;

function FSFileExists(FileName:Pchar):integer; cdecl;
begin
  result := Integer(FileExists(FileName));
end;

procedure FSFileToBLob(FileName:PChar;var Blob:TFBBlob); cdecl;
var
   Fs:TFileStream;
   FSize : Int64;
begin
  try
    Fs:=TFileStream.Create(FileName,fmOpenRead);
    try
      FSize := Fs.Size;
      if FSize = 0 then exit;
      if not Assigned(Blob.Handle) then Exit;
      with TFBBlobStream.Create(@Blob) do
      try
        CopyFrom(Fs,FSize);
      finally
        free;
      end;
    finally
      Fs.Free;
    end;
  except
  end;
end;

function FSBlobToFile(var Blob:TFBBlob;FileName:PChar):integer; cdecl;
var
  Fs        : TFileStream;
  bs: TFBBlobStream;
begin
  Result := FalseInt;
  try
    Fs := TFileStream.Create(FileName,fmCreate or fmOpenWrite);
    try
      bs := TFBBlobStream.Create(@Blob);
      try
        Fs.CopyFrom(bs,bs.Size);
        Result := TrueInt;
      finally
        bs.free;
      end;
    finally
      Fs.Free;
    end;
  except
  end;
end;

function FSFileDelete(FileName:Pchar):integer; cdecl;
begin
  result := FalseInt;
  try
    if DeleteFile(FileName) then
     result := TrueInt;
  except
  end;
end;

function FSForceDirectories(FolderName:PChar):integer;cdecl;
begin
   Result := Integer(ForceDirectories(FolderName));
end;

function FSFindFirst(Path:PChar;var Attr:Integer):PtrUdf; cdecl;
var
  pRec :^TSearchRec;
begin
  Result := 0;
  pRec := nil;
  try
    Getmem(pRec,SizeOf(TSearchRec));
    FillByte(pRec^,SizeOf(TSearchRec),0);
    if FindFirst(Path,Attr,pRec^)<>0 then
    begin
      Freemem(pRec,SizeOf(TSearchRec));
      Finalize(pRec^);
      pRec:=nil;
      exit;
    end;
  except
    if pRec<>nil then
    begin
       Finalize(pRec^);
       Freemem(pRec,SizeOf(TSearchRec));
    end;
    exit;
  end;
  with TAFObj.Create(pRec,SizeOf(TSearchRec)) do
  begin
    ClearError;
    result := Handle;
  end;
end;

function FSFindRecName(var Handle:PtrUdf):Pchar; cdecl;
var
  afobj:TAFObj;
  pRec :^TSearchRec;
begin
  try
    afobj := HandleToAfObj(Handle,taoMem);
    pRec := afobj.Memory;
    Result := ib_util_malloc(Length(pRec^.Name)+1);
    StrPLCopy(Result,Pchar(Utf8ToAnsi(pRec^.Name)),1023);
  except
    on e:Exception do
       if Assigned(afobj) then afobj.FixedError(e);
  end;
end;

function FSFindNext(var Handle:PtrUdf):integer; cdecl;
var afobj:TAFObj;
    pRec :^TSearchRec;
begin
  try
    afobj := HandleToAfObj(Handle,taoMem);
    pRec := afobj.Memory;
    result := FindNext(pRec^);
  except
    on e:Exception do
       if Assigned(afobj) then afobj.FixedError(e);
  end;
end;

function FSFindRecAttr(var Handle:PtrUdf):Integer;cdecl;
var afobj:TAFObj;
    pRec :^TSearchRec;
begin
  result := 0;
  try
    afobj := HandleToAfObj(Handle,taoMem);
    pRec := afobj.Memory;
    result := pRec^.Attr;
  except
    on e:Exception do
       if Assigned(afobj) then afobj.FixedError(e);
  end;
end;

function FSFindRecCheckAttr(var Handle:PtrUdf;var Attr:Integer):Integer; cdecl;
var afobj:TAFObj;
    pRec :^TSearchRec;
begin
  result := 0;
  try
    afobj := HandleToAfObj(Handle,taoMem);
    pRec := afobj.Memory;
    result := Integer((pRec^.Attr and Attr)=Attr);
  except
    on e:Exception do
       if Assigned(afobj) then afobj.FixedError(e);
  end;
end;

function FSFindClose(var Handle:PtrUdf):integer;cdecl;
var afobj:TAFObj;
    pRec :^TSearchRec;
begin
  result := FalseInt;
  try
    afobj := HandleToAfObj(Handle,taoMem);
    pRec :=  afobj.Memory;
    if pRec<>nil then
    begin
      FindClose(pRec^);
      Finalize(pRec^);
      Freemem(pRec,SizeOf(TSearchRec));
    end;
    afobj.NilMemory;
    result := TrueInt;
  except
    on e:Exception do
       if Assigned(afobj) then afobj.FixedError(e);
  end;
end;

function FSFileCopy(FileNameSource,FileNameDest:Pchar;
  var FailIfExists:integer):integer; cdecl;
const
  BUFFER_SIZE = 4096;
var
  Buf  : array [0..BUFFER_SIZE-1] of char;
  hSrc : THandle;
  hDest : THandle;
  iCntRead : LongInt;
  iCntWrite : LongInt;
  isEx      : boolean;
begin
  result := FalseInt;
  iCntRead := 0;
  isEx := FileExists(FileNameDest);
  if isEx and (FailIfExists=1) then exit;
  hSrc := FileOpen(FileNameSource,fmOpenRead);
  if hSrc=errFile then exit;
  try
    if isEx  then DeleteFile(FileNameDest);
    hDest := FileCreate(FileNameDest,fmOpenReadWrite);
    if hDest=errFile then exit;
    while true do
    begin
      iCntRead:=FileRead(hSrc,Buf,BUFFER_SIZE);
      if iCntRead=0 then exit(TrueInt);
      if iCntRead=-1 then exit;
      iCntWrite:= FileWrite(hDest,Buf,iCntRead);

      if iCntWrite<>iCntRead then
      begin
        iCntWrite:=-1;
        exit;
      end;
    end;

  finally
    if hDest<>errFile then
      FileClose(hDest);
    FileClose(hSrc);
    if (iCntRead=-1) or (iCntWrite=-1) then DeleteFile(FileNameDest);
  end;
end;


end.

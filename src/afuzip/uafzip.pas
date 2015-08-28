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
unit uafzip;

{$mode objfpc}
{$H+}

interface

Uses
  ufbblob,zipper,uafudfs;

{ Creates an object for packing }
function CreateZIP: PtrUdf; cdecl;

{ Specify the file for packing / unpacking }
function SetArhiveFileZIP (var Handle: PtrUdf; FileName: Pchar): integer; cdecl;

{ Specify which files to pack / unpack }
function AddSpecZIP (var Handle: PtrUdf; FileName: Pchar): integer; cdecl;

{ Create Archive }
function CompressZIP (var Handle: PtrUdf): Integer; cdecl;

{ Clear the list of files packing / unpacking }
function ClearSpecZIP (var Handle: PtrUdf): integer; cdecl;

{ Creates an object for packing }
function CreateUnZIP: PtrUdf; cdecl;

{ Specify the destination folder for unpacking }
function SetExtractDirZIP (var Handle: PtrUdf; FolderName: Pchar): integer; cdecl;

{ Unpack archives }
function ExtractZIP (var Handle: PtrUdf): integer; cdecl;

implementation

uses
  SysUtils,Classes;

function CreateZIP:PtrUdf;cdecl;
var
    Zip  : TZipper;
begin
  Result := 0;
  try
    Zip := TZipper.Create;
  except
    if Assigned(Zip) then Zip.Free;
    exit;
  end;
  result := TAFObj.Create(Zip).Handle;
end;

function SetArhiveFileZIP(var Handle:PtrUdf;FileName:Pchar):integer;cdecl;
var afobj:TAFObj;
begin
  result := 0;
  try
    afobj :=HandleToAfObj(Handle);
    if (afobj.Obj is TZipper) then
    begin
      if FileExists(FileName) then
         DeleteFile(FileName);
      TZipper(afobj.Obj).FileName := FileName;
    end
    else
      TUnZipper(afobj.Obj).FileName := FileName;
    result := 1;
  except
    on e:Exception do
       if Assigned(afobj) then afobj.FixedError(e);
  end;
end;

function AddSpecZIP(var Handle:PtrUdf;FileName:Pchar):integer;cdecl;
var afobj:TAFObj;
begin
  result := 0;
  try
    afobj :=HandleToAfObj(Handle);
    if (afobj.Obj is TZipper) then
    begin
      TZipper(afobj.Obj).Entries.AddFileEntry(FileName,ExtractFileName(FileName));
    end
    else
      TUnZipper(afobj.Obj).Files.Add(FileName);
    result := 1;
  except
    on e:Exception do
       if Assigned(afobj) then afobj.FixedError(e);
  end;
end;

function CompressZIP(var Handle:PtrUdf):Integer;cdecl;
var afobj:TAFObj;
begin
  result := 0;
  try
    afobj :=HandleToAfObj(Handle);
    TZipper(afobj.Obj).ZipAllFiles;
    result := 1;
  except
    on e:Exception do
       if Assigned(afobj) then afobj.FixedError(e);
  end;
end;


function ClearSpecZIP(var Handle:PtrUdf):integer;cdecl;
var afobj:TAFObj;
begin
  result := 0;
  try
    afobj :=HandleToAfObj(Handle);
    if (afobj.Obj is TZipper) then
      TZipper(afobj.Obj).Entries.Clear
    else
      TUnZipper(afobj.Obj).Files.Clear;
    result := 1;
  except
    on e:Exception do
           if Assigned(afobj) then afobj.FixedError(e);
  end;
end;

function CreateUnZIP:PtrUdf;cdecl;
var
    Zip :TUnZipper;
begin
  Result := 0;
  try
    Zip := TUnZipper.Create;
  except
    if Assigned(Zip) then Zip.Free;
    exit;
  end;
  result := TAFObj.Create(Zip).Handle;
end;


function SetExtractDirZIP(var Handle:PtrUdf;FolderName:Pchar):integer;cdecl;
var afobj:TAFObj;
begin
  result := 0;
  try
    afobj :=HandleToAfObj(Handle);
    TUnZipper(afobj.Obj).OutputPath := FolderName;
    result := 1;
  except
    on e:Exception do
           if Assigned(afobj) then afobj.FixedError(e);
  end;
end;

function ExtractZIP(var Handle:PtrUdf):integer;cdecl;
var afobj:TAFObj;
begin
  result := 0;
  try
    afobj :=HandleToAfObj(Handle);
    TUnZipper(afobj.Obj).UnZipAllFiles;
    result := 1;
  except
    on e:Exception do
       if Assigned(afobj) then afobj.FixedError(e);
  end;
end;

end.

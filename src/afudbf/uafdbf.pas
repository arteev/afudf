
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
unit uafdbf;
{$mode objfpc}
{$H+}

interface

uses dbf,dbf_dbffile, uafudfs, ib_util;

{Creates an object to work with DBF}
function CreateDBF (FileName: PChar; var AnsiOrOem: Integer; var Mode: integer;
                   var Share: integer; var Overwrite: integer): PtrUDF; cdecl;

{Creates a DBF file on disk}
function CreateTableDBF (var Handle: PtrUDF): integer; cdecl;

{Closes DBF}
function CloseDBF (var Handle: PtrUDF): integer; cdecl;

{Opens DBF}
function OpenDBF (var Handle: PtrUDF): integer; cdecl;

{Sets the format for creating file DBF}
function SetFormatDBF (var Handle: PtrUDF; var FormatDBF: integer): integer; cdecl;

function GetFormatDBF (var Handle: PtrUDF): integer; cdecl;
//------------------------------------------------------------------------------

(*** Navigation on the table ***)

{Move the cursor in the table ahead 1}
function NextInDBF (var Handle: PtrUDF): integer; cdecl;

{Move the cursor in the table back to 1}
function PrevInDBF (var Handle: PtrUDF): integer; cdecl;

{Move the cursor to the top of the table}
function FirstInDBF (var Handle: PtrUDF): integer; cdecl;

{Move the cursor to the end of the table}
function LastInDBF (var Handle: PtrUDF): integer; cdecl;

{Returns for the end of the table table}
function EofInDBF (var Handle: PtrUDF): integer; cdecl;

{Current line number in the open table}
function RecNoDBF (var Handle: PtrUDF): integer; cdecl;

{Number of rows in the table otrutoy}
function RecordCountDBF (var Handle: PtrUDF): integer; cdecl;

{Move the cursor to an open position at the table from the beginning NewRecNO table}
function SetRecNoDBF (var Handle: PtrUDF; var NewRecNO: integer): integer; cdecl;

//------------------------------------------------------------------------------
(*** Editing entries ***)

function StateDBF (var Handle: PtrUDF): integer; cdecl;

{ Saves the record }
function PostDBF (var Handle: PtrUDF): integer; cdecl;

{ Adds an entry }
function AppendDBF (var Handle: PtrUDF): integer; cdecl;

{Edit current record}
function EditDBF (var Handle: PtrUDF): integer; cdecl;

{Deletes a record from DBF}
function DeleteDBF (var Handle: PtrUDF): integer; cdecl;

{ Cancels editing entries }
function CancelDBF (var Handle: PtrUDF): integer; cdecl;

{Compress table permanently removing deleted records}
function PackDBF (var Handle: PtrUDF): integer; cdecl;

//------------------------------------------------------------------------------
(***  Working with Fields ***)

{Creates a field in a closed table}
function AddFieldDBF (var Handle: PtrUDF; FieldName: Pchar; TypeField: Pchar; var ALen, ADecLen: integer): integer; cdecl;

{Returns kolichetvo fields in the table}
function FieldCountDBF (var Handle: PtrUDF): integer; cdecl;

{Returns whether there is a box}
function FieldExistsDBF (var Handle: PtrUDF; FieldName: Pchar): integer; cdecl;

{Returns the name of the field by index}
function GetFieldNameDBFByIndex (var Handle: PtrUDF; var Index: Integer): Pchar; cdecl;

// ------------------------------------------------ ------------------------------
(*** Work with field values ​​***)

{Set value of the field for the current edited line}
function SetValueDBFFieldByName (var Handle: PtrUDF; FieldName: Pchar; Value: Pchar): integer; cdecl;

{Returns the value of the field for the current edited line}
function GetValueDBFFieldByName (var Handle: PtrUDF; FieldName: Pchar): Pchar; cdecl;

{Returns 1 if the field current line Null, otherwise 0}
function ValueIsNullDBF (var Handle: PtrUDF; FieldName: Pchar): integer; cdecl;

//------------------------------------------------------------------------------

implementation

uses DB, SysUtils, udbfwrap;

{******************************************************************}
{ Function: SetFormatDBF                                           }
{ Purpose: Sets the format DBF                                     }
{ Entrance:                                                        }
{ Handle - The handle of the object                                }
{                    FormatDBF format compatibility DBF            }
{                          3 - dBASE III+                          }
{                          4 - dBASE IV (default)                  }
{                          7 - Visual dBASE VII                    }
{                         25 - FoxPro                              }
{                                                                  }
{  Result:        0-fail 1-successfully                            }
{                                                                  }
{  Description:                                                    }
{                                                                  }
{******************************************************************}
function SetFormatDBF(var Handle:PtrUDF;var FormatDBF:integer):integer;cdecl;
var afobj:TAFObj;
begin
   result := 0;
  try
    afobj := HandleToAfObj(Handle);

    TDbfWrap(afobj.Obj).ADbf.TableLevel:= FormatDBF;
    Result := 1;
  except
    on e:Exception do
       if Assigned(afobj) then afobj.FixedError(e);
  end;
end;


function GetFormatDBF(var Handle:PtrUDF):integer;cdecl;
var afobj:TAFObj;
begin
   result := 0;
  try
    afobj := HandleToAfObj(Handle);

    result := TDbfWrap(afobj.Obj).ADbf.TableLevel;
  except
    on e:Exception do
       if Assigned(afobj) then afobj.FixedError(e);
  end;
end;

{******************************************************************}
{  Function:     CreateDBF                                         }
{  Purpose:      Create or Open DBF                                }
{  Entrance:                                                       }
{                FileName                                          }
{                AnsiOrOem 0=OEM 1=ANSI                            }
{                Mode      0=ReadOnly 1=Read/Write                 }
{                Share 0-Exclusive 1=Share                         }
{  Result:       0-fail or handle                                  }
{                                                                  }
{  Description:                                                    }
{                                                                  }
{******************************************************************}
function CreateDBF(FileName:PChar;var AnsiOrOem:Integer; var Mode:integer;
                   var Share:integer;var Overwrite:integer):PtrUDF;cdecl;
var
    adbfwp:TDbfWrap;
begin
  Result := 0;
  try
    adbfwp:=TDbfWrap.Create(AnsiOrOem=0);
    with adbfwp.adbf do begin
      FilePathFull:= ExtractFileDir(FileName);
      TableName:= ExtractFileName(FileName);
      Exclusive:= Share=0;
      ReadOnly:= Mode=0;
      ShowDeleted:= False;
      StoreDefs:=true;
    end;
    if (Overwrite=1) and (FileExists(FileName)) then
      DeleteFile(FileName);
  except
    if Assigned(adbfwp) then adbfwp.Free;
    exit;
  end;
  result := TAFObj.Create(adbfwp).Handle;
end;

Type
  TCommonFuncDBFInt = function(var afobj:TAFObj):integer;

function ExecCommonFuncDbfInt(var Handle:PtrUdf;func:TCommonFuncDBFInt;DefaultResult:integer=0):integer;
var afobj:TAFObj;
begin
  result := DefaultResult;
  try
    afobj := HandleToAfObj(Handle);
    result := func(afobj);
  except
    on e:Exception do
       if Assigned(afobj) then afobj.FixedError(e);
  end;
end;

{ CreateTableDBF }
function DoCreateTableDBF(var afobj:TAFObj):integer;
begin
  TDbfWrap(afobj.Obj).ADbf.CreateTable;
  result := 1;
end;
function CreateTableDBF(var Handle:PtrUDF):integer;cdecl;
begin
  result := ExecCommonFuncDbfInt(Handle,@DoCreateTableDBF);
end;

{ CloseDBF }
function DoCloseDBF(var afobj:TAFObj):integer;
begin
  TDbfWrap(afobj.Obj).ADbf.Active := false;
  result := 1;
end;
function CloseDBF(var Handle:PtrUDF):integer;cdecl;
begin
  result := ExecCommonFuncDbfInt(Handle,@DoCloseDBF);
end;

{ OpenDBF }
function DoOpenDBF(var afobj:TAFObj):integer;
begin
  TDbfWrap(afobj.Obj).ADbf.Active := true;
  result := 1;
end;
function OpenDBF(var Handle:PtrUDF):integer;cdecl;
begin
  result := ExecCommonFuncDbfInt(Handle,@DoOpenDBF);
end;

{ StateDBF }
function DoStateDBF(var afobj:TAFObj):integer;
begin
  result := Integer(TDbfWrap(afobj.Obj).ADbf.State);
end;
function StateDBF(var Handle:PtrUDF):integer;cdecl;
begin
  result := ExecCommonFuncDbfInt(Handle,@DoStateDBF,-1);
end;

{ RecNoDBF }
function DoRecNoDBF(var afobj:TAFObj):integer;
begin
  result := TDbfWrap(afobj.Obj).ADbf.RecNo;
end;
function RecNoDBF(var Handle:PtrUDF):integer;cdecl;
begin
  result := ExecCommonFuncDbfInt(Handle,@DoRecNoDBF,-1);
end;

{ RecordCountDBF }
function DoRecordCountDBF(var afobj:TAFObj):integer;
begin
  result := TDbfWrap(afobj.Obj).ADbf.RecordCount;
end;
function RecordCountDBF(var Handle:PtrUDF):integer;cdecl;
begin
  result := ExecCommonFuncDbfInt(Handle,@DoRecordCountDBF,-1);
end;

{ PostDBF }
function DoPostDBF(var afobj:TAFObj):integer;
begin
  TDbfWrap(afobj.Obj).ADbf.Post;
  result := 1;
end;
function PostDBF(var Handle:PtrUDF):integer;cdecl;
begin
   result := ExecCommonFuncDbfInt(Handle,@DoPostDBF);
end;

{ AppendDBF }
function DoAppendDBF(var afobj:TAFObj):integer;
begin
  TDbfWrap(afobj.Obj).ADbf.Append;
  result := 1;
end;
function AppendDBF(var Handle:PtrUDF):integer;cdecl;
begin
  result := ExecCommonFuncDbfInt(Handle,@DoAppendDBF);
end;

{ NextInDBF }
function DoNextInDBF(var afobj:TAFObj):integer;
begin
  TDbfWrap(afobj.Obj).ADbf.Next;
  result := 1;
end;
function NextInDBF(var Handle:PtrUDF):integer;cdecl;
begin
  result := ExecCommonFuncDbfInt(Handle,@DoNextInDBF);
end;

{ PrevInDBF }
function DoPrevInDBF(var afobj:TAFObj):integer;
begin
  TDbfWrap(afobj.Obj).ADbf.Prior;
  result := 1;
end;
function PrevInDBF(var Handle:PtrUDF):integer;cdecl;
begin
  result := ExecCommonFuncDbfInt(Handle,@DoPrevInDBF);
end;

{ FirstInDBF }
function DoFirstInDBF(var afobj:TAFObj):integer;
begin
  TDbfWrap(afobj.Obj).ADbf.First;
  result := 1;
end;
function FirstInDBF(var Handle:PtrUDF):integer;cdecl;
begin
  result := ExecCommonFuncDbfInt(Handle,@DoFirstInDBF);
end;

{ LastInDBF }
function DoLastInDBF(var afobj:TAFObj):integer;
begin
  TDbfWrap(afobj.Obj).ADbf.Last;
  result := 1;
end;
function LastInDBF(var Handle:PtrUDF):integer;cdecl;
begin
  result := ExecCommonFuncDbfInt(Handle,@DoLastInDBF);
end;

{ EditDBF }
function DoEditDBF(var afobj:TAFObj):integer;
begin
  TDbfWrap(afobj.Obj).ADbf.Edit;
  result := 1;
end;
function EditDBF(var Handle:PtrUDF):integer;cdecl;
begin
  result := ExecCommonFuncDbfInt(Handle,@DoEditDBF);
end;

{ DeleteDBF }
function DoDeleteDBF(var afobj:TAFObj):integer;
begin
  TDbfWrap(afobj.Obj).ADbf.Delete;
  result := 1;
end;
function DeleteDBF(var Handle:PtrUDF):integer;cdecl;
begin
  result := ExecCommonFuncDbfInt(Handle,@DoDeleteDBF);
end;

{ CancelDBF }
function DoCancelDBF(var afobj:TAFObj):integer;
begin
  TDbfWrap(afobj.Obj).ADbf.Cancel;
  result := 1;
end;
function CancelDBF(var Handle:PtrUDF):integer;cdecl;
begin
  result := ExecCommonFuncDbfInt(Handle,@DoCancelDBF);
end;

{ PackDBF }
function DoPackDBF(var afobj:TAFObj):integer;
begin
  TDbfWrap(afobj.Obj).ADbf.PackTable;
  result := 1;
end;
function PackDBF(var Handle:PtrUDF):integer;cdecl;
begin
  result := ExecCommonFuncDbfInt(Handle,@DoPackDBF);
end;

{ FieldCountDBF }
function DoFieldCountDBF(var afobj:TAFObj):integer;
begin
  result := TDbfWrap(afobj.Obj).ADbf.FieldCount;
end;
function FieldCountDBF(var Handle:PtrUDF):integer;cdecl;
begin
  result := ExecCommonFuncDbfInt(Handle,@DoFieldCountDBF);
end;

{ EofInDBF }
function DoEofInDBF(var afobj:TAFObj):integer;
begin
  result := Integer(TDbfWrap(afobj.Obj).ADbf.Eof);
end;
function EofInDBF(var Handle:PtrUDF):integer;cdecl;
begin
  result := ExecCommonFuncDbfInt(Handle,@DoEofInDBF,1);
end;

function SetRecNoDBF(var Handle:PtrUDF;var NewRecNO:integer):integer;cdecl;
var afobj:TAFObj;
begin
   result := 0;
  try
    afobj := HandleToAfObj(Handle);
    TDbfWrap(afobj.Obj).ADbf.RecNo :=  NewRecNO;
    Result := TDbfWrap(afobj.Obj).ADbf.RecNo;
  except
    on e:Exception do
       if Assigned(afobj) then afobj.FixedError(e);
  end;
end;

function FieldExistsDBF(var Handle:PtrUDF;FieldName:Pchar):integer;cdecl;
var afobj:TAFObj;
begin
  result := 0;
  try
    afobj := HandleToAfObj(Handle);

     if TDbfWrap(afobj.Obj).ADbf.FindField(FieldName)<>nil then
      result := 1;
  except
    on e:Exception do
       if Assigned(afobj) then afobj.FixedError(e);
  end;
end;

function SetValueDBFFieldByName(var Handle:PtrUDF;FieldName:Pchar;Value:Pchar):integer;cdecl;
var
    afobj:TAFObj;
begin
  result := 0;
  try
    afobj := HandleToAfObj(Handle);
    if Value= nil then
      TDbfWrap(afobj.Obj).ADbf.FieldByName(FieldName).Clear
    else
      case TDbfWrap(afobj.Obj).ADbf.FieldByName(FieldName).DataType of
         ftDateTime:TDbfWrap(afobj.Obj).ADbf.FieldByName(FieldName).AsDateTime := StrToDateTime(Value);
         ftFloat, ftCurrency:TDbfWrap(afobj.Obj).ADbf.FieldByName(FieldName).AsFloat := StrToFloat(Value);
      else
         TDbfWrap(afobj.Obj).ADbf.FieldByName(FieldName).AsString := TDbfWrap(afobj.Obj).Convert(Value);
      end;
    result := 1;
  except
    on e:Exception do
       if Assigned(afobj) then afobj.FixedError(e);
  end;
end;

function GetFieldNameDBFByIndex(var Handle:PtrUDF;var Index:Integer):Pchar;cdecl;
var afobj:TAFObj;
   F:TField;
begin
  try
    afobj := HandleToAfObj(Handle);

    f:=TDbfWrap(afobj.Obj).ADbf.Fields[index];
    if f<>nil then
    begin
      Result := ib_util_malloc(Length(f.FieldName)+1);
      StrPCopy(Result, f.FieldName);
    end
    else
      Result := nil;
  except
    on e:Exception do
    begin
       if Assigned(afobj) then afobj.FixedError(e);
       Result := nil;
    end;
  end;
end;

function GetValueDBFFieldByName(var Handle:PtrUDF;FieldName:Pchar):Pchar;cdecl;
var afobj:TAFObj;
  s: String;
begin
  try
    afobj := HandleToAfObj(Handle);
    with  TDbfWrap(afobj.Obj) do
    begin
      s := Convert(ADbf.FieldByName(FieldName).AsString,False);
      Result := ib_util_malloc(Length(s)+1);
      StrPLCopy(Result,s,32765);
    end;
  except
    on e:Exception do
    begin
       if Assigned(afobj) then afobj.FixedError(e);
       Result := nil;
    end;
  end;
end;

function ValueIsNullDBF(var Handle:PtrUDF;FieldName:Pchar):integer;cdecl;
var afobj:TAFObj;
begin
  result := -1;
  try
    afobj := HandleToAfObj(Handle);
    Result := Integer(TDbfWrap(afobj.Obj).ADbf.FieldByName(FieldName).IsNull);
  except
    on e:Exception do
       if Assigned(afobj) then afobj.FixedError(e);
  end;
end;

function AddFieldDBF(var Handle:PtrUDF;FieldName:Pchar;TypeField:Pchar;var ALen,ADecLen:integer):integer;cdecl;
var
    afobj:TAFObj;
begin
  result := 0;
  try
    afobj := HandleToAfObj(Handle);
    if TDbfWrap(afobj.Obj).ADbf.FieldDefs.IndexOf(FieldName)<>-1 then
     raise Exception.CreateFmt('Field %s is exists.',[FieldName]);

    with TDbfWrap(afobj.Obj).ADbf.FieldDefs.AddFieldDef do
    begin
      Name:= FieldName;
      if TypeField='N' then
        DataType := ftFloat
      else
      if TypeField='C' then
        DataType := ftString
      else
      if TypeField='D' then
        DataType := ftDate
      else
        raise exception.CreateFmt('Field %s: Unknow DataType:%s',[FieldName,TypeField]);
      Size:= Word(ALen);
      Precision := Word(ADeclen);
    end;
    result := 1;
  except
    on e:Exception do
       if Assigned(afobj) then afobj.FixedError(e);
  end;
end;

end.








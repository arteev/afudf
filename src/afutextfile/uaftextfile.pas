unit uaftextfile;
{$mode delphi}
{$H+}
interface
uses
  uafudfs;
{Creates descriptor to work with a text file FileName}
function CreateTextFile (FileName: PChar): PtrUdf; cdecl;

{Opens for reading text file}
function ResetTextFile (var Handle: PtrUdf): integer; cdecl;

{Opens a text file for writing}
function RewriteTextFile (var Handle: PtrUdf): integer; cdecl;

{Close the handle to work with the file Attention }
function CloseTextFile (var Handle: PtrUdf): integer; cdecl;

{Writes a text string in a file}
function WriteToTextFile (var Handle: PtrUdf; S: Pchar): integer; cdecl;

{Writes a text string in a file with a carriage return}
function WriteLnToTextFile (var Handle: PtrUdf; S: Pchar): integer; cdecl;

{Gets line from the textual version of the file}
function ReadLnFromTextFile (var Handle: PtrUdf): Pchar; cdecl;

{Checks for the end of file when reading}
function EofTextFile (var Handle: PtrUdf): integer; cdecl;

{Flush buffer contents to a file Handle recording}
function FlushTextFile (var Handle: PtrUdf): integer; cdecl;

{Opens a text file for writing at end of file}
function AppendTextFile (var Handle: PtrUdf): integer; cdecl;

{Gets char from the textfile}
function ReadCharFromTextFile (var Handle: PtrUdf): Pchar; cdecl;

{Gets int32 from the textfile}
function ReadInt32FromTextFile (var Handle: PtrUdf): Integer; cdecl;

{Gets int64 from the textfile}
function ReadInt64FromTextFile (var Handle: PtrUdf): Int64; cdecl;

{Writes a integer in a file}
function WriteInt32ToTextFile (var Handle: PtrUdf; var Num: Integer): integer; cdecl;

{Writes a integer 64bit in a file}
function WriteInt64ToTextFile (var Handle: PtrUdf; var Num: Int64): integer; cdecl;

implementation
uses
  SysUtils,ioresdecode, ib_util;




procedure CheckIOResult;
var
  lastio: Word;
begin
  lastio:=IOResult;
  if lastio<>0 then
    raise Exception.Create(IOResultDecode(lastio));
end;

function CreateTextFile(FileName:PChar):PtrUdf;cdecl;
var
  F:^TextFile;
begin
  Result := 0;
  try
    Getmem(F,Sizeof(TextFile));
    AssignFile(F^,string(FileName));
  except
    if F<>nil then Dispose(F);
    exit;
  end;
  result :=TAFObj.Create(F,SizeOf(F^)).Handle;
end;


Type
  TExecCommonTextFile=Procedure(var t:Text);
function ExecuteCommon(var Handle:PtrUdf;func:TExecCommonTextFile):integer;
var
  afobj:TAFObj;
begin
  result := 0;
  try
    afobj := HandleToAfObj(Handle,taoMem);
    {$I-}
    func(TextFile(afobj.Memory^));
    {$I+}
    CheckIOResult;
    Result := 1;
  except
    on e:Exception do
       if Assigned(afobj) then afobj.FixedError(e);
  end;
end;

{ ResetTextFile }
procedure DoReset(var t:text);
begin
   Reset(t);
end;
function ResetTextFile(var Handle:PtrUdf):integer;cdecl;
begin
  result := ExecuteCommon(Handle,@DoReset);
end;

{ CloseTextFile }
procedure DoCloseFile(var t:text);
begin
   CloseFile(t);
end;
function CloseTextFile(var Handle:PtrUdf):integer;cdecl;
begin
  result := ExecuteCommon(Handle,@DoCloseFile);
end;

{ RewriteTextFile }
procedure DoRewriteTextFile(var t:text);
begin
   Rewrite(t);
end;
function RewriteTextFile(var Handle:PtrUdf):integer;cdecl;
begin
  result := ExecuteCommon(Handle,@DoRewriteTextFile);
end;

{ AppendTextFile }
procedure DoAppendTextFile(var t:text);
begin
   Append(t);
end;
function AppendTextFile(var Handle:PtrUdf):integer;cdecl;
begin
  result := ExecuteCommon(Handle,@DoAppendTextFile);
end;

{ FlushTextFile }
procedure DoFlushTextFile(var t:text);
begin
   Flush(t);
end;
function FlushTextFile(var Handle:PtrUdf):integer;cdecl;
begin
  result := ExecuteCommon(Handle,@DoFlushTextFile);
end;

Type TWriteToFunc=procedure(var t:text;s:Pointer);
function WriteToCommon(var Handle:PtrUdf;S:Pointer;fn:TWriteToFunc):integer;cdecl;
var
  afobj:TAFObj;
begin
  result := 0;
  try
    afobj := HandleToAfObj(Handle,taoMem);
    {$I-}
    fn(TextFile(afobj.Memory^),S);
    {$I+}
    CheckIOResult;
    Result := 1;
  except
    on e:Exception do
    begin
       if Assigned(afobj) then afobj.FixedError(e);
    end
  end;
end;

{ WriteToTextFile }
procedure DoWriteToTextFile(var t:text;s:Pchar);
begin
  Write(t,s);
end;
function WriteToTextFile(var Handle:PtrUdf;S:Pchar):integer;cdecl;
begin
  result := WriteToCommon(Handle,S,@DoWriteToTextFile);
end;

{WriteLnToTextFile}
procedure DoWriteLnToTextFile(var t:text;s:Pchar);
begin
  WriteLn(t,s);
end;
function WriteLnToTextFile(var Handle:PtrUdf;S:Pchar):integer;cdecl;
begin
  result := WriteToCommon(Handle,S,@DoWriteLnToTextFile);
end;

{WriteInt32ToTextFile}
procedure DoWriteInt32ToTextFile(var t:text;s:PInteger);
begin
  Write(t, s^);
end;
function WriteInt32ToTextFile (var Handle: PtrUdf; var Num: Integer): integer; cdecl;
begin
  result := WriteToCommon(Handle,@Num,@DoWriteInt32ToTextFile);
end;

{WriteInt64ToTextFile}
procedure DoWriteInt64ToTextFile(var t:text;s:PInt64);
begin
  Write(t, s^);
end;
function WriteInt64ToTextFile (var Handle: PtrUdf; var Num: Int64): integer; cdecl;
begin
  result := WriteToCommon(Handle,@Num,@DoWriteInt64ToTextFile);
end;

function ReadLnFromTextFile(var Handle:PtrUdf):Pchar;cdecl;
var
  afobj:TAFObj;
  s:string;
begin
  result := nil;
  try
    afobj := HandleToAfObj(Handle,taoMem);
    {$I-}
    ReadLn(TextFile(afobj.Memory^),s);
    {$I+}
    CheckIOResult;
    result := ib_util.ib_util_malloc(Length(s)+1);
    StrPCopy(result,s);
  except
    on e:Exception do
       if Assigned(afobj) then afobj.FixedError(e);
  end;
end;

{Gets char from the textual version of the file}
function ReadCharFromTextFile (var Handle: PtrUdf): Pchar; cdecl;
var
  afobj:TAFObj;
  ch:Char;
begin
  result := nil;
  try
    afobj := HandleToAfObj(Handle,taoMem);
    {$I-}
    Read(TextFile(afobj.Memory^),ch);
    {$I+}
    CheckIOResult;
    result := ib_util.ib_util_malloc(Length(ch)+1);
    StrPCopy(result,ch);
  except
    on e:Exception do
       if Assigned(afobj) then afobj.FixedError(e);
  end;
end;

function ReadInt32FromTextFile (var Handle: PtrUdf): Integer; cdecl;
var
  afobj:TAFObj;
begin
  result := 0;
  try
    afobj := HandleToAfObj(Handle,taoMem);
    {$I-}
    Read(TextFile(afobj.Memory^),result);
    {$I+}
    CheckIOResult;
  except
    on e:Exception do
       if Assigned(afobj) then afobj.FixedError(e);
  end;
end;

function ReadInt64FromTextFile (var Handle: PtrUdf): Int64; cdecl;
var
  afobj:TAFObj;
begin
  result := 0;
  try
    afobj := HandleToAfObj(Handle,taoMem);
    {$I-}
    Read(TextFile(afobj.Memory^),Result);
    {$I+}
    CheckIOResult;
  except
    on e:Exception do
       if Assigned(afobj) then afobj.FixedError(e);
  end;
end;

function EofTextFile(var Handle:PtrUdf):integer;cdecl;
var
  afobj:TAFObj;
begin
  result := 0;
  try
    afobj := HandleToAfObj(Handle,taoMem);
    {$I-}
    Result := Integer(Eof(TextFile(afobj.Memory^)));
    {$I+}
    CheckIOResult;
  except
    on e:Exception do
       if Assigned(afobj) then afobj.FixedError(e);
  end;
end;

end.

unit usha;

{$MODE objfpc}
{$H+}


{(C) Coban (alex@ritlabs.com)}
interface
uses SHA,CryptoUtils;

const
  HASH_INITIAL     = $100;              //Initial constant

  HASH_SHA1         = HASH_INITIAL + $D;


 {Errors}
  HASH_NOERROR     = 0;
  HASH_UNK_TYPE    = HASH_NOERROR + $1;  //Unknown hash type
  HASH_NIL_CONTEXT = HASH_NOERROR + $2;  //Context unallocated
  HASH_INV_CONTEXT = HASH_NOERROR + $3;  //Invalid hash context
  HASH_FR_ERROR    = HASH_NOERROR + $4;  //File read error
  HASH_FO_ERROR    = HASH_NOERROR + $5;  //File open error
  HASH_TEST_FAILED = HASH_NOERROR + $6;  //Hash test error

  {Current ammount of hash algorithms}
  HASH_MAX_TYPES   = + 4 ;

type
  {Hash context}
  PHashContext = ^THashContext;
  THashContext = record
    IntData: Pointer;      {Reserved for internal use}
    HashType: LongWord;    {Hash type}
    lParam: LongWord;      {First Param}
    wParam: LongWord;      {Second Param}
  end;

  {Low-level hash functions}
  function HashInit(Context: PHashContext; HashType: LongWord): LongWord;
  function HashUpdate(Context: PHashContext; SrcBuf: Pointer; BufLen: LongWord): LongWord;
  function HashFinal(Context: PHashContext; var DestHash: String): LongWord;

  {High-level hash functions}
  function HashStr(HashType: LongWord; SrcStr: String; var DestHash: String): LongWord;
  function HashBuf(HashType: LongWord; SrcBuf: Pointer; BufLen: LongWord; var DestHash: String): LongWord;


  {Misc. functions}
  function HashErrorToStr(Error: LongWord): String;
  function EnumHashTypes(StoreToArr: Pointer; MaxItems: LongWord): LongWord;



implementation

function HashInit(Context: PHashContext; HashType: LongWord): LongWord;
begin
  if Context = nil then
  begin
    Result := HASH_NIL_CONTEXT;
    Exit;
  end;
  Context^.HashType := HashType;
  Result := HASH_NOERROR;
  case HashType of
    HASH_SHA1:
    begin
      GetMem(Context^.IntData, SizeOf(TSHA256Ctx));
      if HashType = HASH_SHA1 then
        SHA1Init(PSHA256Ctx(Context^.IntData)^)
      else
        SHA256Init(PSHA256Ctx(Context^.IntData)^);
    end;
    else
      Result := HASH_UNK_TYPE;
  end;
end;


function HashUpdate(Context: PHashContext; SrcBuf: Pointer; BufLen: LongWord): LongWord;
begin
  Result := HASH_NOERROR;
  if Context = nil then
  begin
    Result := HASH_NIL_CONTEXT;
    Exit;
  end;
  if Context^.IntData = nil then
  begin
    Result := HASH_INV_CONTEXT;
    Exit;
  end;
  case Context^.HashType of
    HASH_SHA1: SHA256Update(PSHA256Ctx(Context^.IntData)^, SrcBuf, BufLen, 1);
    else
      Result := HASH_UNK_TYPE;
  end;
end;

function HashFinal(Context: PHashContext; var DestHash: String): LongWord;
begin
  if Context = nil then
  begin
    Result := HASH_NIL_CONTEXT;
    Exit;
  end;
  Result := HASH_NOERROR;
  case Context^.HashType of


    HASH_SHA1:
    begin
      if Context^.HashType = HASH_SHA1 then
        DestHash := SHA256Final(PSHA256Ctx(Context^.IntData)^, 1)
      else
        DestHash := SHA256Final(PSHA256Ctx(Context^.IntData)^, 256);
      FreeMem(Context^.IntData, SizeOf(TSHA256Ctx));
      Context^.IntData := nil;
    end;

    else
      Result := HASH_UNK_TYPE;
  end;
end;

function HashStr(HashType: LongWord; SrcStr: String; var DestHash: String): LongWord;
var
  ctx: THashContext;
begin
  Result := HashInit(@ctx, HashType);
  if Result = HASH_NOERROR then
    Result := HashUpdate(@ctx, PChar(SrcStr), Length(SrcStr));
  if Result = HASH_NOERROR then
    Result := HashFinal(@ctx, DestHash);
end;

function HashBuf(HashType: LongWord; SrcBuf: Pointer; BufLen: LongWord; var DestHash: String): LongWord;
var
  ctx: THashContext;
begin
  Result := HashInit(@ctx, HashType);
  if Result = HASH_NOERROR then
    Result := HashUpdate(@ctx, SrcBuf, BufLen);
  if Result = HASH_NOERROR then
    Result := HashFinal(@ctx, DestHash);
end;

function EnumHashTypes(StoreToArr: Pointer; MaxItems: LongWord): LongWord;
  procedure AddToEnum(Value: LongWord; var Count: LongWord);
  begin
    if Count >= MaxItems then Exit;
    PDWordArray(StoreToArr)^[Count] := Value;
    Inc(Count);
  end;
begin
  Result := 0;
  if MaxItems = 0 then
    Exit;
  if MaxItems > HASH_MAX_TYPES then
    MaxItems := HASH_MAX_TYPES;
  AddToEnum(HASH_SHA1, Result);
end;

function HashErrorToStr(Error: LongWord): String;
begin
  case Error of
    HASH_NOERROR: Result := 'No error';
    HASH_UNK_TYPE: Result := 'Unknown hash type';
    HASH_NIL_CONTEXT: Result := 'Hash context is null';
    HASH_INV_CONTEXT: Result := 'Invalid hash context';
    HASH_FR_ERROR: Result := 'Could not read file';
    HASH_FO_ERROR: Result := 'Could not open file';
    HASH_TEST_FAILED: Result := 'Hash test failed';    
  else
    Result := 'Unknown error';
  end;
end;


end.
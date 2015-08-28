
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
unit udbfwrap;

{$mode objfpc}

interface

uses
  Classes, SysUtils,dbf,dbf_dbffile;

{ TDbfWrap }
{ Wrapper TDBF }
Type TDbfWrap = class
private
  FADbf: TDbf;
  FOem: Boolean;
public
  constructor Create(const AOem:boolean);
  Destructor Destroy;override;
  { dos <-> win }
  function Convert(AValue : String;const IsOut2DBf:boolean=true):string;
  property ADbf : TDbf read FADbf;
  property Oem:Boolean read FOem;
end;


implementation
uses
  ucodestr;


{ TDbfWrap }
constructor TDbfWrap.Create(const AOem: boolean);
begin
  FOem:=AOem;
  FADbf := TDBf.Create(nil);
  FADbf.ShowDeleted:=false;
  FADbf.StoreDefs:=true;
end;

destructor TDbfWrap.Destroy;
begin
  FADbf.Free;
  inherited Destroy;
end;

function TDbfWrap.Convert(AValue: String; const IsOut2DBf: boolean): string;
begin
  if not FOem then
   result := AValue
  else
  begin
    if IsOut2DBf then
      result := win2dos(PChar(AnsiString(AValue)))
    else
      result := dos2win(PChar(AnsiString(AValue)));
  end;
end;

end.


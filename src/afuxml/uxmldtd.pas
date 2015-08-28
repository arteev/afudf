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
unit uxmldtd;

{$mode objfpc}
{$H+}

interface

uses
  Classes, SysUtils, DOM,XMLRead;

Type

  { TXmlDTD }

  TXmlDTD = class
  private
    FWasError  : Boolean;
    FTextError : String;
    procedure ErrorHandler(E: EXMLReadError);
  public
    function CreateXmlDocFromStreamDTD(AStream:TStream; Out XmlDoc:TXMLDocument;
      Out Error: string):Boolean;

  end;

implementation

{ TXmlDTD }

procedure TXmlDTD.ErrorHandler(E: EXMLReadError);
begin
  if E.Severity = esError then
  begin
    FWasError:=true;
    if FTextError<>'' then
      FTextError:=FTextError+LineEnding
    else
      FTextError:='ERROR:';
    FTextError:=FTextError+E.Message;
  end;
end;

function TXmlDTD.CreateXmlDocFromStreamDTD(AStream: TStream; out
  XmlDoc: TXMLDocument; out Error: string): Boolean;
var
  Parser: TDOMParser;
  Src: TXMLInputSource;
begin
  Parser := TDOMParser.Create;
  FWasError:=false;
  FTextError:='';
  try
    Src := TXMLInputSource.Create(AStream);
    Parser.Options.Validate := True;
    Parser.OnError := @ErrorHandler;
    Parser.Parse(Src, XmlDoc);
    if FWasError then
    begin
      Error:= FTextError;
      if XmlDoc<> nil then
        XmlDoc.Free;
      exit(false);
    end;
    Error := '';
    exit(true);
  finally
    if Assigned(Src) then
      Src.Free;
    Parser.Free;
  end;
end;

end.


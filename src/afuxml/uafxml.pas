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
unit uafxml;


{$ifdef fpc}
  {$MODE objfpc}
  {$H+}
{$endif}

interface

uses Classes, SysUtils, ufbblob, DOM, ib_util, uafudfs,XMLRead, XPath,uxmldtd
     {$IFDEF linux}
       ,iconvenc
       ,xmliconv
      {$IFDEF DEBUG},BaseUnix{$ENDIF}
     {$else}
       ,iconvwin
       ,xmliconv_windows
     {$ENDIF}
     ;

Type

  { TUDFXMLDocument }

  TUDFXMLDocument=class
  private
    FEncoding: string;
    FInputOutputEncoding: string;
    FDocument:TXMLDocument;
  public
    constructor Create(AutoCreate:boolean);
    destructor Destroy;override;
    property Encoding: string read FEncoding write FEncoding;

    property InputOutputEncoding:string read FInputOutputEncoding write FInputOutputEncoding;

    property Document:TXMLDocument read FDocument write FDocument;
  end;


 (*** Document XML ***)

{Creates an XML (empty)}
function CreateXmlDocument: PtrUdf; cdecl;

{Creates an XML object from a string by converting from the encoding specified in XML}
function CreateXmlDocFromString (S: PChar): PtrUdf; cdecl;

{Creates XML object stored in BLOB encoded in UTF-8}
function CreateXmlDocFromBLOB (var BLOB: TFBBlob): PtrUdf; cdecl;

{Produces an XML file in UTF-8}
function CreateXmlDocFromFile (FileName: PChar): PtrUdf; cdecl;

{Setting version xml file}
function XMLSetVersion (var Handle: PtrUdf; Ver: PChar): integer; cdecl;

{Specifies the encoding in which the data read / write database Encoding}
function XMLEncoding (var Handle: PtrUdf; Encoding: PChar): integer; cdecl;

{File encoding destination}
function XMLEncodingXML (var Handle: PtrUdf; Encoding: PChar): integer; cdecl;

{Returns current encoding parameter in vtorroy}
function XMLGetEncodingXML (var Handle: PtrUdf): PChar; cdecl;

{Returns an XML document to a string encoding purposes.
  substituted attribute encoding
  Warning limit 32KB !!!}
function XMLToString (var Handle: PtrUdf): PChar; cdecl;

{Returns an XML document into a BLOB encoded destination
  substituted attribute encoding}
procedure XMLToBlob (var Handle: PtrUdf; var Blob: TFBBlob); cdecl;

{XML node encoding "Encoding"
   substituted encoding attribute that clause is used for the database}
function XMLXmlNode (var Handle: PtrUdf; var Node: PtrUdf): PChar; cdecl;

{Store XML file}
function XmlToFile (var Handle: PtrUdf; filename: PChar): integer; cdecl;


{------------------------------------------------------------------------------}
(*** Tags ***)
{Creates a tag to tag Parent (Index - not used TagName, Value encoding Encoding)}
function XMLAddNode (var Handle: PtrUdf;var Parent: PtrUdf; TagName: PChar;
  var Index: integer): PtrUdf; cdecl;

{Set the text node of encoding Encoding}
function XMLNodeSetText (var Handle: PtrUdf; var Node: PtrUdf; Value: PChar): integer; cdecl;

{Returns the text (value) of the node encoding Encoding}
function XMLTextNode (var Handle: PtrUdf; var Node: PtrUdf): PChar; cdecl;

{Returns the host name or attribute encoding Encoding}
function XmlNodeName (var Handle: PtrUdf; var Node: PtrUdf): PChar; cdecl;

{Returns whether the node child nodes}
function XmlNodeHasChildNodes (var Handle: PtrUdf; var Node: PtrUdf): integer; cdecl;

{Returns the number of child nodes of node Node}
function XmlNodeCountNodes (var Handle: PtrUdf; var Node: PtrUdf): integer; cdecl;

{Returns the child node for Node at index Index}
function XmlNodeByIndex (var Handle: PtrUdf; var Node: PtrUdf;
  var Index: integer): PtrUdf; cdecl;

{Search node name in Node}
function XmlNodeByName (var Handle: PtrUdf; var Node: PtrUdf; NameNode: PChar): PtrUdf; cdecl;

{Returns the text node for simple tag and attribute for an XML tag to tag}
procedure XMLTextNodeBlob (var Handle: PtrUdf; var Node: PtrUdf; var Blob: TFBBlob); cdecl;

{Store XML node in the Blob. The encoded database}
procedure XMLXmlNodeBlob (var Handle: PtrUdf; var Node: PtrUdf; var Blob: TFBBlob); cdecl;
{------------------------------------------------------------------------------}

(***  Attributes ***)
{Creates a tag attribute Parent (Index - not used AttName, Value encoding Encoding)}
function XMLAddAtt (var Handle: PtrUdf;
  var Parent: PtrUdf; AttName: PChar; Value: PChar;
  var {%H-}Index: integer): PtrUdf; cdecl;

{Returns whether the node attributes}
function XmlNodeHasAttribute (var Handle: PtrUdf;
  var Node: PtrUdf; Attribute: PChar): integer; cdecl;

{Number attributes of a node}
function XmlNodeCountAtt (var Handle: PtrUdf; var Node: PtrUdf): integer; cdecl;

{Gets attribute by index}
function XmlNodeAttByIndex (var Handle: PtrUdf; var Node: PtrUdf;
  var Index: integer): PtrUdf; cdecl;

{Returns the attribute name encoding Encoding}
function XmlNodeAttByName (var Handle: PtrUdf;
  var Node: PtrUdf; NameAtt: PChar): PtrUdf; cdecl;

{Returns the text attribute Value name attribute NameAtt encoding Encoding}
function XmlNodeAttByNameVal (var Handle: PtrUdf;
  var Node: PtrUdf; NameAtt: PChar): PChar; cdecl;
{------------------------------------------------------------------------------}


(*** XPath ***)
 {
  XmlXPathEval: Evaluates an expression AExpressionString xpath
                AExpressionString: XPath expression
                AContextNode: The context in which the search (XMLDocument, XMLNode)
                Result: Returns a pointer to the list, or zero TDOMNode
                                      if an error occurred.
  Note: Do not use Free !!!
}
function XmlXPathEval (var Handle: PtrUdf; AExpressionString: PChar;
  var AContextNode: PtrUdf): PtrUdf; cdecl;
{
  XmlXPathEvalValueStr: Evaluates an expression AExpressionString xpath
                Handle: A pointer to the XML object
                AExpressionString: XPath expression
                AContextNode: The context in which the search (XMLDocument, XMLNode)
                Result: Returns the text nodes satisfying expression
}
function XmlXPathEvalValueStr (var Handle: PtrUdf; AExpressionString: PChar;
  var AContextNode: PtrUdf): PChar; cdecl;

{
  XmlXPathEvalValueNum: Evaluates an expression AExpressionString xpath
                Handle: A pointer to the XML object
                AExpressionString: XPath expression
                AContextNode: The context in which the search (XMLDocument, XMLNode)
                Result: Returns the number of (znachnie_ satisfying expression
}
function XmlXPathEvalValueNum (var Handle: PtrUdf; AExpressionString: PChar;
  var AContextNode: PtrUdf): Double; cdecl;
{
  XmlXPathNodeSetItem: Evaluates an expression AExpressionString xpath
                Handle: A pointer to the XML object
                HandleNodeSet: A pointer to the list of TDOMNode XmlXPathEval
                Index: The index of starting from scratch
                Result: Returns a pointer to TXMLNode
}
function XmlXPathNodeSetItem (var Handle: PtrUdf; var HandleNodeSet: PtrUdf; var Index: integer): PtrUdf; cdecl;

{
  XmlXPathNodeSetCount: The number in the set when prompted XmlXPathEval
                Handle: A pointer to the XML object
                HandleNodeSet: A pointer to the list of TDOMNode XmlXPathEval
                Result: Returns the number in the set when prompted XmlXPathEval
}
function XmlXPathNodeSetCount (var Handle: PtrUdf; var HandleNodeSet: PtrUdf): Integer; cdecl;
{------------------------------------------------------------------------------}




(*** XML DTD 1.5 ***)
function CreateXmlFromStream (AStream: TStream): Pchar;

{Creates an XML object from a string using a validation document}
function CreateXmlDocFromStringDTD (S: PChar): PChar; cdecl;
{Creates a BLOB using XML from the validation document}
function CreateXmlDocFromBLOBDTD (var BLOB: TFBBlob): PChar; cdecl;
{Produces an XML file using a validation document}
function CreateXmlDocFromFileDTD (FileName: PChar): PChar; cdecl;
{------------------------------------------------- -----------------------------}

(*** Auxiliary functions ***)

{Return XML document encoded in UTF-8}
function inGetXML (doc: TUDFXMLDocument): DOMString; overload;

{Any returns XML in UTF-8}
function inGetXML (Element: TDOMNode): DOMString; overload;

{Conversion of encoding Encoding in UTF-8 encoding of the database}
function inConvStrToDOM (const Encoding, AStr: ansistring): DOMString;
{Converting from UTF-8 encoding in the Encoding charset for the database}
function inConvDOMToStr (const Encoding, AStr: DOMString): ansistring;

{Returns the encoding Encoding database that is used to communicate with the database}
function inGetEncoding (AObject: TObject): string; inline;

{Determines whether to convert to a different encoding different from UTF8}
function isNeedConvert (AObject: TObject): boolean; inline;


function _getXmlNodeText (XmlNode: TDOMNode): DOMString;

(*** Processing attribute encoding ***)

{Returns Encoding}
function encEncoding (const AXml: AnsiString): AnsiString;

{Adds the value of the tag encoding}
procedure encAddEncoding (var AXml: String; const Encoding: AnsiString);

{Deletes the information about the encoding}
procedure encDelEncoding (var AXml: DOMString);

{XmlXPathEvalHelper not exported}
function XmlXPathEvalHelper (Handle: PtrUdf; AExpressionString: PChar;
  var AContextNode: PtrUdf): TXPathVariable;

implementation

uses XMLWrite;
const
  DOMDefaultEncode = 'utf-8';

function CreateXmlDocument: PtrUdf; cdecl;
var
  afobj:  TAFObj;
  XmlDoc: TUDFXMLDocument;
begin
  Result := 0;
  try
    XmlDoc := TUDFXMLDocument.Create(true);
  except
    if Assigned(XmlDoc) then
      XmlDoc.Free;
    exit;
  end;
  afobj  := TAFObj.Create(XmlDoc);
  Result := afobj.Handle;
end;

function CreateXmlDocFromString(S: PChar): PtrUdf; cdecl;
var
    bs:TStringStream;
    DocOut: TXMLDocument;
    XmlDoc: TUDFXMLDocument;
begin
  bs:=TStringStream.Create(S);
  try
    try
    ReadXMLFile(DocOut,bs);
    XmlDoc := TUDFXMLDocument.Create(false);
    XmlDoc.Document := DocOut;
    Result := TAFObj.Create(XmlDoc).Handle;
    except
      result := 0;
    end;
  finally
    bs.free;
  end;
end;

function CreateXmlDocFromBLOB(var BLOB: TFBBlob):PtrUdf;cdecl;
var
    bs:TFBBlobStream;
    DocOut: TXMLDocument;
    XmlDoc: TUDFXMLDocument;
begin
  bs:=TFBBlobStream.Create(@BLOB);
  try
    try
    ReadXMLFile(DocOut,bs);
    XmlDoc := TUDFXMLDocument.Create(false);
    XmlDoc.Document := DocOut;
    Result := TAFObj.Create(XmlDoc).Handle;
    except
      result := 0;
    end;
  finally
    bs.free;
  end;
end;

function CreateXmlDocFromFile(FileName:PChar):PtrUdf;cdecl;
var
    DocOut: TXMLDocument;
    XmlDoc: TUDFXMLDocument;
begin
  Result := 0;
  try
    ReadXMLFile(DocOut,FileName);
    XmlDoc := TUDFXMLDocument.Create(false);
    XmlDoc.Document := DocOut;
    Result := TAFObj.Create(XmlDoc).Handle;
  except
    exit(0);
  end;
end;

function XMLSetVersion(var Handle: PtrUdf; Ver: PChar): integer; cdecl;
var
  afobj: TAFObj;
begin
  Result := 0;
  try
    afobj := HandleToAfObj(Handle);
    TUDFXMLDocument(afobj.Obj).Document.XMLVersion := Ver;
    Result := 1;
  except
    on e: Exception do
      if Assigned(afobj) then
        afobj.FixedError(e);
  end;
end;

function XMLEncoding(var Handle: PtrUdf; Encoding: PChar): integer; cdecl;
var
  afobj: TAFObj;
begin
  Result := 0;
  try
    afobj := HandleToAfObj(Handle);
    TUDFXMLDocument(afobj.Obj).InputOutputEncoding := Encoding;
    Result := 1;
  except
    on e: Exception do
      if Assigned(afobj) then
        afobj.FixedError(e);
  end;
end;


function XMLEncodingXML(var Handle: PtrUdf; Encoding: PChar): integer; cdecl;
var
  afobj: TAFObj;
begin
  Result := 0;
  try
    afobj := HandleToAfObj(Handle);
    TUDFXMLDocument(afobj.Obj).Encoding := Encoding;
    Result := 1;
  except
    on e: Exception do
      if Assigned(afobj) then
        afobj.FixedError(e);
  end;
end;



function XMLAddNode(var Handle: PtrUdf;
  var Parent: PtrUdf; TagName: PChar; var Index: integer): PtrUdf; cdecl;
var
  afobj:      TAFObj;
  XmlParent:  TDOMElement;
  XmlNode:    TDOMElement;
  XmlBefore   : TDOMNode;
  XmlTagName: DOMString;
begin
  Result := 0;
  try
    afobj := HandleToAfObj(Handle);
    XmlParent := TDOMElement({%H-}Pointer( PtrUdf(Parent)));
    XmlTagName := inConvStrToDOM(inGetEncoding(afobj.Obj), TagName);
    if XmlParent = nil{Parent=0} then
    begin
      XmlNode := TUDFXMLDocument(afobj.Obj).Document.CreateElement(XmlTagName);
      if TUDFXMLDocument(afobj.Obj).Document.HasChildNodes then
          raise Exception.Create('Only one tag can be root.');
      TUDFXMLDocument(afobj.Obj).Document.AppendChild(XmlNode);
    end
    else
    begin
      XmlParent := TDOMElement({%H-}Pointer(PtrUdf(Parent)));
      XmlNode   := TUDFXMLDocument(afobj.Obj).Document.CreateElement(XmlTagName);
      with  XmlParent.ChildNodes do
      begin
        if  (Index>=0)and (Index<Integer(Count)) then
        begin
          XmlBefore:= Item[Index];
          XmlParent.InsertBefore(XmlNode,XmlBefore);
        end
        else
          XmlParent.AppendChild(XmlNode);
      end;

    end;
    Result := ObjToHandle(XmlNode);
  except
    on e: Exception do
      if Assigned(afobj) then
        afobj.FixedError(e);
  end;
end;

function XMLGetEncodingXML(var Handle: PtrUdf): PChar; cdecl;
var
  afobj: TAFObj;
  sXML:  String;
begin
  try
    afobj := HandleToAfObj(Handle);
    sXml := UTF8Encode(TUDFXMLDocument(afobj.Obj).Encoding);
    if sXml = '' then sXml := 'utf-8';
    Result := ib_util_malloc(Length(sXML)+1);
    StrPLCopy(Result, sXML, MaxVarCharLength - 1);
  except
    on e: Exception do
    begin
      if Assigned(afobj) then
        afobj.FixedError(e);
      Result := nil;
    end;
  end;
end;

function XMLToString(var Handle: PtrUdf): PChar; cdecl;
var
  afobj: TAFObj;
  sXML:  string;
  sXMLDom:  DOMString;
begin
  try
    afobj := HandleToAfObj(Handle);
    sXMLDom := inGetXML(TUDFXMLDocument(afobj.Obj));
    if isNeedConvert(afobj.Obj) then
    begin
      with TUDFXMLDocument(afobj.Obj) do
      begin
        sXml := inConvDOMToStr(Encoding,sXMLDom);
        encAddEncoding(sXml,Encoding);
      end;
    end
    else
    begin
       sXML := UTF8Encode(sXMLDom);
    end;
    Result := ib_util_malloc(Length(sXML)+1);
    StrPLCopy(Result, sXML , MaxVarCharLength - 1);
  except
    on e: Exception do
    begin
      if Assigned(afobj) then
        afobj.FixedError(e);
      result := nil;
    end;
  end;
end;

procedure XMLToBlob(var Handle: PtrUdf; var Blob: TFBBlob); cdecl;
var
  afobj: TAFObj;
  sXML:  string;
  sXMLDom:  DOMString;
begin
  try
    afobj := HandleToAfObj(Handle);
    sXMLDom := inGetXML(TUDFXMLDocument(afobj.Obj));
    if isNeedConvert(afobj.Obj) then
    with TUDFXMLDocument(afobj.Obj) do
    begin
       sXml := inConvDOMToStr(Encoding,sXMLDom);
       encAddEncoding(sXml,Encoding);
    end
    else
    begin
       sXML := UTF8Encode(sXMLDom);
    end;
    with TFBBlobStream.Create(@Blob) do
    try
      Write(Pchar(AnsiString(sXML))^,Length(sXML));
    finally
      free;
    end;
  except
    on e: Exception do
      if Assigned(afobj) then
        afobj.FixedError(e);
  end;
end;



function XMLNodeSetText(var Handle: PtrUdf; var Node: PtrUdf; Value: PChar): integer; cdecl;
var
  afobj:   TAFObj;
  XmlNode: TDOMNode;
begin
  Result := 0;
  try
    afobj := HandleToAfObj(Handle);
    XmlNode := HandleToObj(Node) as TDOMNode;
    if XmlNode <> nil then
    begin
      XmlNode.TextContent := inConvStrToDOM(inGetEncoding(afobj.Obj), Value);
    end
    else
      raise Exception.Create('Node is not found.');
    Result := 1;
  except
    on e: Exception do
      if Assigned(afobj) then
        afobj.FixedError(e);
  end;
end;


function XMLXmlNode(var Handle: PtrUdf; var Node: PtrUdf): PChar; cdecl;
var
  afobj:   TAFObj;
  XmlNode: TDOMNode;
  s: String;
begin
  try
    afobj := HandleToAfObj(Handle);
    XmlNode := HandleToObj(Node) as TDOMNode;
    if XmlNode = nil then
      raise Exception.Create('Node not found.');
    s := inConvDOMToStr(inGetEncoding(afobj.Obj), inGetXML(XmlNode));
    Result := ib_util_malloc(Length(s)+1);
    StrPLCopy(Result, s , MaxVarCharLength - 1);
  except
    on e: Exception do
      if Assigned(afobj) then
        afobj.FixedError(e);
  end;
end;

function  XmlToFile(var Handle: PtrUdf; filename: PChar):integer; cdecl;
var
  afobj  : TAFObj;
  sXML   :  string;
  sXMLDom:  DOMString;
  fst    :  TFileStream;
  p      : ^Pchar;
begin
  result := 0;
  try
    afobj := HandleToAfObj(Handle);

    sXMLDom := inGetXML(TUDFXMLDocument(afobj.Obj));
    if isNeedConvert(afobj.Obj) then
    with TUDFXMLDocument(afobj.Obj) do
    begin
       sXml := inConvDOMToStr(Encoding,sXMLDom);
       encAddEncoding(sXml,Encoding);
    end
    else
    begin
       sXML := UTF8Encode(sXMLDom);
    end;
    if FileExists(filename) then DeleteFile(filename);
    fst := TFileStream.Create(filename,fmCreate or fmOpenWrite);
    try
       p := @sXml[1];
       fst.WriteBuffer(p^,length(sXml));
    finally
      fst.Free;
    end;
    result := 1;

  except
    on e: Exception do
      if Assigned(afobj) then
        afobj.FixedError(e);
  end;
end;

function XMLTextNode(var Handle: PtrUdf; var Node: PtrUdf): PChar; cdecl;
var
  afobj:   TAFObj;
  XmlNode: TDOMNode;
  s: String;
begin
  try
    afobj := HandleToAfObj(Handle);
    XmlNode := HandleToObj(Node) as TDOMNode;
    if XmlNode = nil then
      raise Exception.Create('Node not found.');
    s := inConvDOMToStr(inGetEncoding(afobj.Obj), XmlNode.TextContent);
    Result := ib_util_malloc(Length(s)+1);
    StrPLCopy(Result,s,MaxVarCharLength - 1);
  except
    on e: Exception do
    begin
      if Assigned(afobj) then
        afobj.FixedError(e);
      Result := nil;
    end;
  end;
end;

function XmlNodeName(var Handle: PtrUdf; var Node: PtrUdf): PChar; cdecl;
var
  afobj:    TAFObj;
  XmlNode:  TDOMNode;
  sTagName: DOMString;
  s: String;
begin
  try
    afobj := HandleToAfObj(Handle);
    XmlNode := HandleToObj(Node) as TDOMNode;
    if XmlNode = nil then
      raise Exception.Create('Node not found.');
    if XmlNode is TDOMElement then
      sTagName := TDOMElement(XmlNode).TagName
    else
    if XmlNode is TDOMAttr then
      sTagName := TDOMAttr(XmlNode).Name;
    s := inConvDOMToStr(inGetEncoding(afobj.Obj), sTagName);
    Result := ib_util_malloc(Length(s)+1);
    StrPLCopy(Result,s,MaxVarCharLength - 1);
  except
    on e: Exception do
    begin
      if Assigned(afobj) then
        afobj.FixedError(e);
      Result := nil;
    end;
  end;
end;

function XmlNodeHasChildNodes(var Handle: PtrUdf; var Node: PtrUdf): integer; cdecl;
var
  afobj:   TAFObj;
  XmlNode: TDOMNode;
begin
  Result := 0;
  try
    afobj := HandleToAfObj(Handle);

    XmlNode := HandleToObj(Node) as TDOMNode;
    if (XmlNode <> nil) then
      if XmlNode.HasChildNodes then result := 1;
  except
    on e: Exception do
      if Assigned(afobj) then
        afobj.FixedError(e);
  end;
end;

function XmlNodeHasAttribute(var Handle: PtrUdf;
  var Node: PtrUdf; Attribute: PChar): integer; cdecl;
var
  afobj:   TAFObj;
  XmlNode: TDOMNode;
begin
  Result := 0;
  try
    afobj := HandleToAfObj(Handle);
    XmlNode := HandleToObj(Node) as TDOMNode;
    if XmlNode <> nil then
      Result := integer(XmlNode.Attributes.GetNamedItem(Attribute) <> nil)
  except
    on e: Exception do
      if Assigned(afobj) then
        afobj.FixedError(e);
  end;
end;

function XmlNodeCountNodes(var Handle: PtrUdf; var Node: PtrUdf): integer; cdecl;
var
  afobj:   TAFObj;
  XmlNode: TDOMNode;
  cld: TDOMNodeList;
begin
  Result := 0;
  try
    afobj := HandleToAfObj(Handle);

    XmlNode := HandleToObj(Node) as TDOMNode;

    if XmlNode <> nil then
      cld := XmlNode.ChildNodes
    else
      cld := TUDFXMLDocument(afobj.Obj).Document.ChildNodes;
    Result := cld.Count;
  except
    on e: Exception do
      if Assigned(afobj) then
        afobj.FixedError(e);
  end;
end;

function XmlNodeByIndex(var Handle: PtrUdf; var Node: PtrUdf;
  var Index: integer): PtrUdf; cdecl;
var
  afobj:     TAFObj;
  XmlParent: TDOMNode;
  XmlFind:   TDOMNode;
  chld     : TDOMNodeList;
begin
  Result := 0;
  try
    afobj := HandleToAfObj(Handle);
    XmlParent := HandleToObj(Node) as TDOMNode;
    try
      if XmlParent = nil then
        chld  := TUDFXMLDocument(afobj.Obj).Document.ChildNodes
      else
        chld  := XmlParent.ChildNodes;
        XmlFind := chld.Item[Index];
    finally
    end;
    if XmlFind = nil then
      raise Exception.Create('Node #' + IntToStr(Index) + ' not found.');
    Result := ObjToHandle(XmlFind);
  except
    on e: Exception do
      if Assigned(afobj) then
        afobj.FixedError(e);
  end;
end;

function XmlNodeByName(var Handle: PtrUdf; var Node: PtrUdf; NameNode: PChar): PtrUdf; cdecl;
var
  afobj:     TAFObj;
  XmlParent: TDOMNode;
  XmlFind:   TDOMNode;
  sNameNode: DOMString;
begin
  Result := 0;
  try
    afobj := HandleToAfObj(Handle);
    XmlParent := TDOMNode(HandleToObj(Node));
    sNameNode := inConvStrToDOM(inGetEncoding(afobj.Obj), NameNode);
    try
      if XmlParent = nil then
        XmlFind := TUDFXMLDocument(afobj.Obj).Document.FindNode(sNameNode)
      else
        XmlFind := XmlParent.FindNode(sNameNode);
      if XmlFind = nil then
        raise Exception.Create('Node "' + NameNode + '" not found.');
      Result := ObjToHandle(XmlFind);
    finally
    end;
  except
    on e: Exception do
      if Assigned(afobj) then
        afobj.FixedError(e);
  end;
end;

function XmlNodeCountAtt(var Handle: PtrUdf; var Node: PtrUdf): integer; cdecl;
var
  afobj:   TAFObj;
  XmlNode: TDOMNode;
begin
  Result := 0;
  try
    afobj := HandleToAfObj(Handle);

    XmlNode := HandleToObj(Node) as TDOMNode;
    if XmlNode = nil then
      raise Exception.Create('Node not found.');
      Result := XmlNode.Attributes.Length;
  except
    on e: Exception do
      if Assigned(afobj) then
        afobj.FixedError(e);
  end;
end;

function XmlNodeAttByIndex(var Handle: PtrUdf; var Node: PtrUdf;
  var Index: integer): PtrUdf; cdecl;
var
  afobj:     TAFObj;
  XmlParent: TDOMNode;
  XmlFind:   TDOMNode;
begin
  Result := 0;
  try
    afobj := HandleToAfObj(Handle);
    XmlParent := HandleToObj(Node) as TDOMNode;
    if XmlParent <> nil then
    begin
      XmlFind := XmlParent.Attributes.Item[Index];
      if XmlFind = nil then
        raise Exception.Create('Node #' + IntToStr(Index) + ' not found.');
      Result := ObjToHandle(XmlFind);
    end
    else
      raise Exception.Create('Node not found.');
  except
    on e: Exception do
      if Assigned(afobj) then
        afobj.FixedError(e);
  end;
end;

function XmlNodeAttByName(var Handle: PtrUdf;
  var Node: PtrUdf; NameAtt: PChar): PtrUdf; cdecl;
var
  afobj:     TAFObj;
  XmlParent: TDOMNode;
  XmlFind:   TDOMNode;
  sNameNode: DOMString;
begin
  Result := 0;
  try
    afobj := HandleToAfObj(Handle);
    XmlParent := HandleToObj(Node) as TDOMNode;
    sNameNode := inConvStrToDOM(inGetEncoding(afobj.Obj), NameAtt);
    if XmlParent = nil then
     raise Exception.Create('Node not found.');
      try
        XmlFind := XmlParent.Attributes.GetNamedItem(sNameNode);
        if XmlFind = nil then
        begin
          raise Exception.Create('Node "' + NameAtt + '" not found.');
        End;
        Result := ObjToHandle(XmlFind);
      finally
        //SetLength(sNameNode,0);
      end;
  except
    on e: Exception do
      if Assigned(afobj) then
        afobj.FixedError(e);
  end;
end;

function XMLAddAtt(var Handle: PtrUdf;
  var Parent: PtrUdf; AttName: PChar; Value: PChar;
  var Index: integer): PtrUdf; cdecl;
var
  afobj:     TAFObj;
  XmlParent: TDOMElement;
  XmlNode:   TDOMNode;
  sNameAttr: DOMString;
begin
  {Index - не используется}
  Result := 0;
  try
    afobj := HandleToAfObj(Handle);
    if HandleToObj(Parent) is TUDFXMLDocument then
      XmlParent := TUDFXMLDocument(afobj.Obj).Document.DocumentElement
    else
      XmlParent := HandleToObj(Parent) as TDOMElement;
    if XmlParent <> nil then
    begin
      sNameAttr := inConvStrToDOM(inGetEncoding(afobj.Obj), AttName);
      if XmlParent.Attributes.GetNamedItem(sNameAttr)<>nil then
        raise Exception.CreateFmt('Attribute %s already exists',[AttName]);
      XmlParent.AttribStrings[sNameAttr] :=
        inConvStrToDOM(inGetEncoding(afobj.Obj), Value);
      XmlNode := XmlParent.GetAttributeNode(sNameAttr);
    end
    else
      raise Exception.Create('Parent Node not found.');

    Result := ObjToHandle(XmlNode);
  except
    on e: Exception do
      if Assigned(afobj) then
        afobj.FixedError(e);
  end;
end;

function XmlNodeAttByNameVal(var Handle: PtrUdf;
  var Node: PtrUdf; NameAtt: PChar): PChar; cdecl;
var
  afobj: TAFObj;

  XmlParent: TDOMElement;
  XmlFind:   TDOMNode;
  sNameAttr: DOMString;
  s: String;
begin
  try
    afobj := HandleToAfObj(Handle);
    if HandleToObj(Node) is TUDFXMLDocument then
      XmlParent := TUDFXMLDocument(afobj.Obj).Document.DocumentElement
    else
      XmlParent := HandleToObj(Node) as TDOMElement;
    if XmlParent <> nil then
    begin
      sNameAttr := inConvStrToDOM(inGetEncoding(afobj.Obj), NameAtt);
      XmlFind   := XmlParent.Attributes.GetNamedItem(sNameAttr);
      if XmlFind = nil then
        raise Exception.Create('Attribute "' + NameAtt + '" not found.');
      s := inConvDOMToStr(inGetEncoding(afobj.Obj),XmlFind.TextContent);
      Result:= ib_util_malloc(Length(s)+1);
      StrPLCopy(Result, s,MaxVarCharLength - 1);
    end
    else
      raise Exception.Create('Node not found.');
  except
    on e: Exception do
    begin
      if Assigned(afobj) then
        afobj.FixedError(e);
      Result := nil;
    end;
  end;
end;

function XmlXPathEval(var Handle: PtrUdf; AExpressionString: PChar;
  var AContextNode: PtrUdf): PtrUdf; cdecl;
var
  pv: TXPathVariable;
begin
  pv := XmlXPathEvalHelper(handle,AExpressionString,AContextNode);
  if pv=nil then
    Result := 0
  else
    Result := ObjToHandle(pv);
  // Must be later --> FreeAFObject(TXPathVariable)
end;

function XmlXPathEvalValueStr(var Handle: PtrUdf; AExpressionString: PChar;
  var AContextNode: PtrUdf): PChar; cdecl;
var
  pv: TXPathVariable;
  s: String;
  udfxml: TUDFXMLDocument;
begin
  try
    pv := XmlXPathEvalHelper(handle,AExpressionString,AContextNode);
    try
      if pv=nil then exit(nil);
      udfxml := TUDFXMLDocument(TAFObj.FindObj(Handle, taoObject).Obj);
      s := inConvDOMToStr(inGetEncoding(udfxml),pv.AsText);
      Result := ib_util_malloc(Length(s)+1);
      StrPLCopy(Result,s,MaxVarCharLength - 1);
    finally
      pv.Free;
    end;
  except
    result := nil;
  end;
end;

function XmlXPathEvalHelper(Handle: PtrUdf; AExpressionString: PChar;
  var AContextNode: PtrUdf): TXPathVariable;
var
  sExpressionString: DOMString;
  obj : TObject;
  afobj: TAFObj;
  xpathVar: TXPathVariable;
begin
  try
    afobj := HandleToAfObj(Handle);
    if AContextNode=0 then
      Exception.Create('XmlXPathEval: ContextNode must be set');
    obj := HandleToObj(AContextNode);
    if obj is TAFObj then
      obj := TUDFXMLDocument(afobj.Obj).Document
    else
      if (not (obj is TDOMNode)) and (not (obj is TXMLDocument)) then
        raise Exception.Create('XmlXPathEval: ContextNode must be XmlDocument or XmlNode');
    sExpressionString := inConvStrToDOM(inGetEncoding(afobj.Obj),AExpressionString);
    xpathVar := EvaluateXPathExpression(sExpressionString, TDOMNode(obj));
    result := xpathVar;
  except
   on e: Exception do
    begin
      if Assigned(afobj) then
        afobj.FixedError(e);
      Result := nil;
    end;
  end;
end;

function XmlXPathEvalValueNum(var Handle: PtrUdf; AExpressionString: PChar;
  var AContextNode: PtrUdf): Double; cdecl;
var
  pv: TXPathVariable;
begin
  try
    try
      pv := XmlXPathEvalHelper(handle,AExpressionString,AContextNode);
      if pv=nil then exit(0);
      result := pv.AsNumber;
    finally
      pv.free;
    end;
  except
    result := 0;
  end;
end;

function XmlXPathNodeSetItem(var Handle:PtrUdf; var HandleNodeSet: PtrUdf; var Index: integer
  ): PtrUdf; cdecl;
var
  afobj: TAFObj;
  ns: TNodeSet;
  obj: TObject;
begin
  try
    result := 0;
    afobj := HandleToAfObj(Handle);
    if HandleNodeSet=0 then
      Exception.Create('XmlXPathNodeSetItem: ContextNode must be set');
    obj := HandleToObj(HandleNodeSet);
    if (not(obj is TXPathVariable)) then
      raise Exception.CreateFmt('HandleNodeSet: Bad type %s',[obj.ClassName]);
    if TXPathVariable(obj).TypeName <> SNodeSet then
      exit(0);
    ns := TXPathNodeSetVariable(obj).Value;
    if (Index<0) or (Index>=ns.Count) then
        raise Exception.CreateFmt('XmlXPathNodeSetItem: Index %d of bounds',[Index]);
    try
      Result:={%H-}PtrUdf(TXPathNodeSetVariable(obj).Value.Items[Index]);
    finally
      //     --> not: ns.free;
    end;
  except
   on e: Exception do
    begin
      if Assigned(afobj) then
        afobj.FixedError(e);
      Result := 0;
    end;
  end;
end;

function XmlXPathNodeSetCount(var Handle: PtrUdf; var HandleNodeSet: PtrUdf
  ): Integer; cdecl;
var
  afobj: TAFObj;
  obj: TObject;
begin
  try
    afobj := HandleToAfObj(Handle);
    if HandleNodeSet=0 then
      Exception.Create('XmlXPathEval: ContextNode must be set');
    obj := HandleToObj(HandleNodeSet);
    if not (obj is TXPathVariable) then
        raise Exception.CreateFmt('HandleNodeSet: Bad type %s',[obj.ClassName]);
    if TXPathVariable(obj).TypeName <> SNodeSet then
      exit(0);
    try
      Result:=TXPathNodeSetVariable(obj).Value.Count;
    finally
     // not -> ns.Free;
    end;
  except
   on e: Exception do
    begin
      if Assigned(afobj) then
        afobj.FixedError(e);
      Result := 0;
    end;
  end;
end;

procedure XMLTextNodeBlob(var Handle: PtrUdf; var Node: PtrUdf; var Blob: TFBBlob); cdecl;
var
  afobj: TAFObj;
  XmlNode: TDOMNode;
  s: ansistring;
begin
  try
    afobj := HandleToAfObj(Handle);
    XmlNode := HandleToObj(Node) as TDOMNode;
    if XmlNode <> nil then
    begin
      s := inConvDOMToStr(inGetEncoding(afobj.Obj), _getXmlNodeText(XmlNode));
    end
    else
      raise Exception.Create('Node not found');
    with TFBBlobStream.Create(@Blob) do
    try
      Write(Pchar(s)^,Length(s));
    finally
      free;
    end;
  except
    on e: Exception do
      if Assigned(afobj) then
        afobj.FixedError(e);
  end;
end;

function isNeedConvert(AObject: TObject): boolean; inline;
begin
  result :=   (not SameText(TUDFXMLDocument(AObject).Encoding,'utf-8')) or (Length(TUDFXMLDocument(AObject).Encoding)=0);
end;

function _getXmlNodeText(XmlNode: TDOMNode): DOMString;
var
  s: DOMString;
  i: integer;
  cld: TDOMNodeList;
begin
  if not (XmlNode is TDOMElement) then
    Result := inGetXML(XmlNode)
  else
  begin
    s := '';
    cld := XmlNode.ChildNodes;
    try
      for i := 0 to cld.Count - 1 do
      begin
        s := s + inGetXML(cld[i]);
      end;
    finally
   //   cld.Release; // ChildNodes
    end;
    Result := s;
  end;
end;

function encEncoding(const AXml: AnsiString): AnsiString;
var
  i: LongInt;
  P : ^char;
  Pst : ^char;
  k: LongInt;
begin
  i:=Pos('?>',AXml);
  if i=0 then exit;
  k := Pos('encoding="',AXml);
  if (k=0) or (k>i) then exit;
  p:=  @AXml[k+ length('encoding="')];
  Pst := p;
  while not (p^ in [#0,#13,#10,'"']) do
  begin
    inc(p);
  end;
  result :=  copy(Pchar(Pst),1,p-pst);
end;

procedure encAddEncoding(var AXml: String; const Encoding: AnsiString);
var
  i: LongInt;
begin
  AXml := StringReplace(AXml,'encoding="utf-8"','',[]);
  i:=Pos('?>',AXml);
  if i<>0 then
    insert(' encoding="'+Encoding+'" ',AXml,i);
end;

procedure encDelEncoding(var AXml: DOMString);
var
  i: LongInt;
  P : ^WChar;
  Pst : ^WChar;
  k: LongInt;
begin
  i:=Pos('?>',AXml);
  if i=0 then exit;
  k := Pos('encoding="',AXml);
  if (k=0) or (k>i) or (k+1>length(AXml)) then exit;
  p:=  @AXml[k+ length('encoding="')*2+1];
  Pst := @AXml[k];
  while not (p^ in [#0,'"']) do
  begin
    inc(p);
  end;
  Delete(AXml,k,p-pst + 1);
end;

procedure XMLXmlNodeBlob(var Handle: PtrUdf; var Node: PtrUdf; var Blob: TFBBlob); cdecl;
var
  afobj:   TAFObj;
  sXML:    ansistring;
  XmlNode: TDOMNode;
begin
  try
    afobj := HandleToAfObj(Handle);
    XmlNode := HandleToObj(Node) as TDOMNode;
    if XmlNode = nil then
      raise Exception.Create('Node not found.');
    sXML := inConvDOMToStr(inGetEncoding(afobj.Obj), inGetXML(XmlNode));
    PCharToBlob(PChar(sXML), Blob);
  except
    on e: Exception do
      if Assigned(afobj) then
        afobj.FixedError(e);
  end;
end;


function CreateXmlDocFromStringDTD(S: PChar): PChar; cdecl;
var
  Stream: TStream;
begin
  try
    Stream := TStringStream.Create(s);
    try
      Result := CreateXmlFromStream(Stream);
    finally
      Stream.Free;
    end;
  except
    on e:Exception do
    begin
      Result := ib_util_malloc(Length('ERROR:'+e.Message)+1);
      StrPLCopy(Result,'ERROR:'+e.Message,MaxVarCharLength-1);
    end;
  end;
end;

function CreateXmlDocFromBLOBDTD(var BLOB: TFBBlob): PChar; cdecl;
var
  Stream: TFBBlobStream;
begin
  try
    Stream := TFBBlobStream.Create(@BLOB);
    try
      Result := CreateXmlFromStream(Stream);
    finally
      Stream.Free;
    end;
  except
    on e:Exception do
    begin
      Result := ib_util_malloc(Length('ERROR:'+e.Message)+1);
      StrPLCopy(Result,'ERROR:'+e.Message,MaxVarCharLength-1);
    end;
  end;
end;

function CreateXmlFromStream(AStream:TStream):Pchar;
var
  dtd    : TXmlDTD;
  DocOut : TXMLDocument;
  XmlDoc : TUDFXMLDocument;
  sError : string;
  s      : string;
begin
  dtd := TXmlDTD.Create;
  try
    try
      if dtd.CreateXmlDocFromStreamDTD(AStream,DocOut,sError) then
      begin
        XmlDoc := TUDFXMLDocument.Create(false);
        XmlDoc.Document := DocOut;
        s :=  IntToStr(TAFObj.Create(XmlDoc).Handle);
        Result := ib_util_malloc(Length(s)+1);
        StrPLCopy(Result, s,MaxVarCharLength - 1);
      end
      else
      begin
        Result:= ib_util_malloc(Length(sError)+1);
        StrPLCopy(Result, sError,MaxVarCharLength - 1);
      end;
    finally
      dtd.Free;
    end;
  except
    on e:Exception do
    begin
      s :=  'ERROR:'+ e.Message;
      Result := ib_util_malloc(Length(s)+1);
      StrPLCopy(Result, s,MaxVarCharLength - 1);
    end;
  end;
end;

function CreateXmlDocFromFileDTD(FileName: PChar): PChar; cdecl;
var
  Stream: TFileStream;
begin
  try
    Stream := TFileStream.Create(FileName,fmOpenRead);
    try
      Result := CreateXmlFromStream(Stream);
    finally
      Stream.Free;
    end;
  except
    on e:Exception do
    begin
      Result := ib_util_malloc(Length('ERROR:'+e.Message)+1);
      StrPLCopy(Result,'ERROR:'+e.Message,MaxVarCharLength-1);
    end;
  end;
end;

function inGetXML(doc: TUDFXMLDocument): DOMString;
var
  MemSt: TMemoryStream;
  s:ansistring;
begin
  Result := '';
  MemSt  := TMemoryStream.Create;
  try
    WriteXML(doc.Document, MemSt);
    SetLength(s,MemSt.Size);
    MemSt.Position:=0;
    MemSt.Read (Pointer(s)^,MemSt.Size);
    result:=UTF8Decode(s);
  finally
    MemSt.Free;
  end;
end;

function inGetXML2(doc: TUDFXMLDocument): string;
var
  MemSt: TMemoryStream;
  s:string;
begin
  Result := '';
  MemSt  := TMemoryStream.Create;
  try
    WriteXML(doc.Document, MemSt);
    SetLength(s,MemSt.Size);
    MemSt.Position:=0;
    MemSt.Read(Pointer(s)^,MemSt.Size);
    result:=s;
  finally
    MemSt.Free;
  end;
end;


function inGetXML(Element: TDOMNode): DOMString;
var
  MemSt: TMemoryStream;
begin
  Result := '';
  MemSt  := TMemoryStream.Create;
  try
    WriteXML(Element, MemSt);
    Result := UTF8Decode(Copy(PChar(MemSt.Memory), 1, MemSt.Size));
  finally
    MemSt.Free;
  end;
end;

function inConvStrToDOM(const Encoding, AStr: ansistring): DOMString;
var
  res: ansistring;
begin
  res := '';
  Iconvert(AStr, res, Encoding, DOMDefaultEncode);
  Result := UTF8Decode(res);
end;

function inConvDOMToStr(const Encoding, AStr: DOMString): ansistring;
var
  res: ansistring;
begin
  res := '';
  Iconvert(UTF8Encode(AStr), res, DOMDefaultEncode, Encoding);
  Result := res;
end;

function inGetEncoding(AObject: TObject): string; inline;
begin
  Result := TUDFXMLDocument(AObject).InputOutputEncoding;
  if Result = '' then
    Result := DOMDefaultEncode;
end;

{ TUDFXMLDocument }
constructor TUDFXMLDocument.Create(AutoCreate:boolean);
begin
  FInputOutputEncoding:= 'utf-8';
  FEncoding:='utf-8';
  if AutoCreate then
    FDocument := TXMLDocument.Create;

end;

destructor TUDFXMLDocument.Destroy;
begin
  if Assigned(FDocument) then
    FDocument.Free;
  inherited Destroy;
end;

initialization

end.


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
library afuxml;

{$mode objfpc}

uses
  smudfstatic,
  {$IfDef DEBUG}heaptrc,{$EndIf}
  uafxml,
  sysutils,
  uafudfs in '../common/uafudfs.pas', ib_util,
  ufbblob in '../cmnunits/ufbblob.pas', uxmldtd;


exports
  {1.5}
  CreateXmlDocFromFileDTD,
  CreateXmlDocFromBLOBDTD,
  CreateXmlDocFromStringDTD,

  {1.4}
  XmlXPathEval,
  XmlXPathNodeSetCount,
  XmlXPathEvalValueStr,
  XmlXPathEvalValueNum,
  XmlXPathNodeSetItem,
  {1.3}
  CreateXmlDocument,
  XMLSetVersion,
  XMLEncoding,
  XMLAddNode,
  XMLToString,
  XMLNodeSetText,
  XMLToBlob,
  XMLTextNode,
  XMLXmlNode,
  XmlNodeName,
  XmlNodeHasChildNodes,
  XmlNodeHasAttribute,
  XmlNodeCountNodes,
  XmlNodeByIndex,
  XmlNodeByName,
  XmlNodeCountAtt,
  XmlNodeAttByIndex,
  XmlNodeAttByName,
  XmlNodeAttByNameVal,
  XMLAddAtt,

  CreateXmlDocFromString,
  CreateXmlDocFromBLOB,
  CreateXmlDocFromFile,
  XMLXmlNodeBlob,
  XMLTextNodeBlob,

  XMLEncodingXML,
  XMLGetEncodingXML,
  XmlToFile;
{IFDEF WINDOWS}{R afuxml.rc}{ENDIF}
{$R afuxml.res}

begin
  {$IfDef DEBUG}
  SetHeapTraceOutput(GetEnvironmentVariable('TEMP')+DirectorySeparator+'afudf.'+{$I %FILE%}+'.heap.trc');
  {$EndIf}
end.


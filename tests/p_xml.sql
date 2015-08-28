/*{
    This file is part of the AF UDF library for Firebird 1.0 or high.
    Copyright (c) 2007-2009 by Arteev Alexei, OAO Pharmacy Tyumen.

    See the file COPYING.TXT, included in this distribution,
    for details about the copyright.ss

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    email: alarteev@yandex.ru, arteev@pharm-tmn.ru, support@pharm-tmn.ru

 ***********************************************************************/

create or alter EXCEPTION UDF_TESTUNIT_EXP 'Исключение для тестов AFUDF';

SET TERM ^ ;

create or alter procedure udf_testunit_check_exception(obj1 bigint,tstfuncion varchar(100), mustexcept integer)
as
BEGIN
  -- данная функция проверяет должна быть ошибка  в объекте или нет

   if (obj1 = 0 ) then exit;
   if (trim(tstfuncion)='') then tstfuncion='Не известная функция';

   if (mustexcept=1 and  WASERROROBJ(obj1)=0)  then
      EXCEPTION UDF_TESTUNIT_EXP 'Для функции '||tstfuncion||' не  зафиксирована ошибка, хотя должна была быть';

   if (mustexcept<>1 and  WASERROROBJ(obj1)=1)  then
      EXCEPTION UDF_TESTUNIT_EXP 'Для функции '||tstfuncion||' зафиксирована ошибка, хотя НЕ должна была быть' || MSGLASTERROROBJ(obj1);

end ^

create or alter procedure UDF_TESTUNIT_XML_1 (
    SFOLDERNAME varchar(255) character set WIN1251)
returns (
    RESINFO varchar(1024) character set WIN1251)
as
declare variable MESS varchar(1024);
declare variable RES bigint;
declare variable OBJ bigint;
declare variable HROOT bigint;
declare variable HCHILD1 bigint;
declare variable HCHILD2 bigint;
declare variable HCHILD3 bigint;
declare variable BL blob sub_type 1 segment size 80;
declare variable FILENAME varchar(2000) = 'xml_test1.xml';
declare variable HXPATH bigint;
declare variable HXPATHNODE bigint;
declare variable I integer;
declare variable CNT integer;
declare variable S varchar(32765);
BEGIN
  /*  Данная процедура является тестом для модуля afuxml
     Для проверки запустите  запрос:
       select * from UDF_TESTUNIT_XML_1('/home/user/');
    тест успешен, если нет исключения
  */
  obj = CreateXmlDocument();
  if (obj=0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка создания XML объекта';
  -- ТЕСТ №1 --
  resinfo=' 1.Тест  работы на создание XML';SUSPEND;

   if (XMLSetVersion(obj,'1.0')<>1) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLSetVersion  должно быть 1';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLSetVersion',0);

  if (XMLEncoding(obj,'utf-8')<>1) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLEncoding  должно быть 1';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLEncoding',0);

  if (XMLEncodingXML(obj,'utf-8')<>1) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLEncodingXML  должно быть 1';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLEncodingXML',0);


  if (XMLGetEncodingXML(obj)<>'utf-8') then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLGetEncodingXML  должно быть utf-8';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLGetEncodingXML',0);




  resinfo='1.Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №1 КОНЕЦ --



  -- ТЕСТ №2 --
  resinfo=' 2.Тест  на теги';SUSPEND;

  hRoot = XMLAddNode(obj,0,'root_tag',-1);
  if (hRoot=0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLAddNode  должно быть не 0' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLAddNode',0);




  if (XMLAddNode(obj,0,'root_tag',-1)<>0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLAddNode  должно быть 0' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLAddNode',1);

  if (XMLAddNode(obj,hRoot,'',-1)<>0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLAddNode  должно быть 0'  ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLAddNode',1);


  hchild1 = XMLAddNode(obj,hRoot,'child_tag',-1);
  if (hchild1=0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLAddNode  должно быть не 0' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLAddNode',0);


  hchild2 = XMLAddNode(obj,hRoot,'child_tag2',-1);
  if (hchild2=0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLAddNode  должно быть не 0' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLAddNode',0);

   if (XMLNodeSetText(obj,hchild1,'')<>1) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLNodeSetText  должно быть не 0' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLNodeSetText',0);

     if (XMLNodeSetText(obj,hchild1,'string 1')<>1) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLNodeSetText  должно быть не 0' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLNodeSetText',0);

   /*if (XMLNodeSetText(obj,hRoot,'string root')<>0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLNodeSetText  должно быть 0!' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLNodeSetText',1);  */


  if (XMLTextNode(obj,hchild1)<>'string 1') then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLTextNode  должно быть string 1' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLTextNode',0);

  if (XmlNodeName(obj,hchild1)<>'child_tag') then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeName  должно быть child_tag' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeName',0);


  if (XMLNodeSetText(obj,0,'')<>0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLNodeSetText  должно быть пусто' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLNodeSetText',1);

  if (XMLTextNode(obj,0)<>'') then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLTextNode  должно быть пусто' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLTextNode',1);

  if (XmlNodeName(obj,0)<>'') then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeName  должно быть пусто' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeName',1);



  if (XmlNodeHasChildNodes(obj,hRoot)<>1) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeHasChildNodes  должно быть 1' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeHasChildNodes',0);


  if (XmlNodeHasChildNodes(obj,hChild1)<>1) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeHasChildNodes  должно быть 1' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeHasChildNodes',0);

    if (XmlNodeHasChildNodes(obj,hChild2)<>0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeHasChildNodes  должно быть 0' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeHasChildNodes',0);



    if (XmlNodeByIndex(obj,hRoot,0) <>hChild1) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeByIndex  должно быть '||hChild1||', а фактически '||cast(XmlNodeByIndex(obj,hRoot,0) as bigint);
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeByIndex',0);

      if (XmlNodeByIndex(obj,0,0)<>hRoot) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeByIndex  должно быть '||hRoot ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeByIndex',0);


    if (XmlNodeByIndex(obj,hRoot,222)<>0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeByIndex  должно быть 0' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeByIndex',1);


   if (XmlNodeByName(obj,hRoot,'child_tag')<>hChild1) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeByName  должно быть '||hChild1 ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeByName',0);

   if (XmlNodeByName(obj,hRoot,'child_tag2')<>hChild2) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeByName  должно быть '||hChild2 ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeByName',0);

   if (XmlNodeByName(obj,hRoot,'child_tag3')<>0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeByName  должно быть 0' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeByName',1);

     if (XmlNodeByName(obj,0,'root_tag')<>hRoot) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeByName  должно быть '||hRoot ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeByName',0);

     if (XmlNodeByName(obj,0,'root_tag2')<>0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeByName  должно быть 0 ' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeByName',1);

    bl = XMLTextNodeBlob(obj,hRoot);
    EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLTextNodeBlob 1',0);
    bl = XMLTextNodeBlob(obj,hChild1);
    EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLTextNodeBlob 2',0);
    bl = XMLTextNodeBlob(obj,hChild2);
    EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLTextNodeBlob 3',0);
     bl = XMLTextNodeBlob(obj,0);
    EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLTextNodeBlob 4',1);



    bl = XMLXmlNodeBlob(obj,hRoot);
    EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLXmlNodeBlob 1',0);
    bl = XMLXmlNodeBlob(obj,hChild1);
    EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLXmlNodeBlob 2',0);
    bl = XMLXmlNodeBlob(obj,hChild2);
    EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLXmlNodeBlob 3',0);
     bl = XMLXmlNodeBlob(obj,0);
    EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLXmlNodeBlob 4',1);


  resinfo='2.Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №2 КОНЕЦ --

  -- ТЕСТ №3 --
  resinfo='3.Тест пройден успешно!';SUSPEND;

  if (XMLAddAtt(obj,0,'id','test',0)<>0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLAddAtt  должно быть 0 ' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLAddAtt',1);


    if (XMLAddAtt(obj,hRoot,'id','test',0)=0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLAddAtt  должно быть не 0 ' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLAddAtt',0);

  if (XMLAddAtt(obj,hRoot,'id','test',0)<>0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLAddAtt  должно быть 0 ' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLAddAtt',1);

  if (XMLAddAtt(obj,hRoot,'name','isroot',0)=0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLAddAtt  должно быть не 0 ' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLAddAtt',0);

  if (XmlNodeHasAttribute(obj,hRoot,'name')=0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeHasAttribute  должно быть не 0 ' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeHasAttribute',0);


  if (XMLAddAtt(obj,hChild1,'name2','cool',0)=0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLAddAtt  должно быть не 0 ' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLAddAtt',0);

  if (XmlNodeHasAttribute(obj,hChild1,'name')<>0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeHasAttribute  должно быть  0 ' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeHasAttribute',0);

  if  (XmlNodeCountAtt(obj,hChild1)<>1) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeCountAtt  должно быть  1 ' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeCountAtt',0);

  if  (XmlNodeCountAtt(obj,hChild2)<>0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeCountAtt  должно быть  0 ' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeCountAtt',0);

if  (XmlNodeCountAtt(obj,hRoot)<>2) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeCountAtt  должно быть  2 ' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeCountAtt',0);

  if  (XmlNodeCountAtt(obj,0)<>0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeCountAtt  должно быть  0 ' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeCountAtt',1);

    if  (XmlNodeAttByIndex(obj,hRoot,0)=0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeAttByIndex  должно быть   не 0 ' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeAttByIndex',0);

      if  (XmlNodeAttByIndex(obj,hRoot,1)=0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeAttByIndex  должно быть   не 0 ' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeAttByIndex',0);

    if  (XmlNodeAttByIndex(obj,hRoot,2)<>0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeAttByIndex  должно быть    0 ' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeAttByIndex',1);


    if  (XmlNodeAttByIndex(obj,0,2)<>0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeAttByIndex  должно быть    0 ' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeAttByIndex',1);



    if  (XmlNodeAttByName(obj,0,'name')<>0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeAttByName  должно быть    0 ' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeAttByName',1);


    if  (XmlNodeAttByName(obj,hRoot,'name')=0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeAttByName  должно быть  не  0 ' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeAttByName',0);


    if  (XmlNodeAttByName(obj,hChild1,'name2')=0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeAttByName  должно быть  не  0 ' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeAttByName',0);



    if  (XmlNodeAttByNameVal(obj,hRoot,'id')<>'test') then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeAttByName  должно быть  test';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeAttByName',0);

    if  (XmlNodeAttByNameVal(obj,0,'id')<>'') then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeAttByName  должно быть  test';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeAttByName',1);


   res=XmlNodeAttByName(obj,hChild1,'name2');


    if  (XMLNodeSetText(obj,res,'cool2')<>1) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLNodeSetText  должно быть  1';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLNodeSetText',0);

    if  (XMLTextNode(obj,res)<>'cool2') then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLTextNode  должно быть  cool2';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLTextNode',0);

      if  (XmlNodeName(obj,res)<>'name2') then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeName  должно быть  name2';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlNodeName',0);


      if  (XMLTextNodeBlob(obj,res)<>' name2="cool2"') then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLTextNodeBlob  должно быть  cool2';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLTextNodeBlob',0);


  resinfo='3.Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №3 КОНЕЦ --



  hChild3=XMLAddNode(obj,hRoot,'child_3',-1);

  res=XMLNODESETTEXT(obj,hChild3,'Это тест!!!This is test!!!');

  res=XMLAddNode(obj,hRoot,'child_after_index_0',1);





  -- ТЕСТ №4 --
  resinfo='4.Тест на сохранение в файл!';SUSPEND;
  res = XMLENCODINGXML(obj,'utf-8');
  if (XmlToFile(obj,sFolderName||FileName)<>1) then
     EXCEPTION UDF_TESTUNIT_EXP 'Error XmlToFile  must be 1, but' || MSGLASTERROROBJ(obj);
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlToFile',0);
  resinfo='4.Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №4 КОНЕЦ --
  res=FREEAFOBJECT(obj); obj = 0;


  -- ТЕСТ №5 --
  resinfo='5.Тест на  создание XML из разных источников!';SUSPEND;
  obj = CreateXmlDocFromString('<?xml version="1.0" encoding="windows-1251" ?><root_tag id="test" name="isroot">'||
                                                '<child_tag name2="cool2">string 1</child_tag><child_tag2/><child_3>GHG</child_3></root_tag>');

  if (obj=0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка CreateXmlDocFromString  должно быть  не 0' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'CreateXmlDocFromString',0);

  res=XMLENCODING(obj,'windows-1251');
   resinfo=XMLGETENCODINGXML(obj);suspend;

  --после парсинга всегда будет UTF-8
  if (XMLGETENCODINGXML(obj)<>'utf-8') then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLGETENCODINGXML  должно быть utf-8' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLGETENCODINGXML',0);

  bl = XMLTOBLOB(obj); -- кодировка 1251

  res=FREEAFOBJECT(obj); obj = 0;

  -- Создаем из блоба
  resinfo = bl; suspend;
  obj = CreateXmlDocFromBlob(bl);

    if (obj=0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка CreateXmlDocFromBlob  должно быть  не 0' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'CreateXmlDocFromBlob',0);

/*
  данный тест отклюючен т.к. из blob file то всегда будет utf-8, т.к. кодировка не
  определяется принудительно

  if (XMLGETENCODINGXML(obj)<>'windows-1251') then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLGETENCODINGXML  должно быть windows-1251  ' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLGETENCODINGXML',0);
  */

  res=FREEAFOBJECT(obj); obj = 0;


  -- Из файла
  obj = CREATEXMLDOCFROMFILE(sFolderName||Filename);
    if (obj=0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка CREATEXMLDOCFROMFILE  должно быть  не 0' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'CREATEXMLDOCFROMFILE',0);

  resinfo ='кодировка:'||XMLGETENCODINGXML(obj);SUSPEND;
      if (XMLGETENCODINGXML(obj)<>'utf-8') then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLGETENCODINGXML  должно быть windows-1251  ' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLGETENCODINGXML',0);





   resinfo='5.Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №5 КОНЕЦ --

  res=FREEAFOBJECT(obj);
  obj = 0;


  resinfo='6.XPath test';SUSPEND;
  obj = CREATEXMLDOCFROMSTRING('<?xml version="1.0" encoding="windows-1251"?>
<root>
    <library id="1">
        <book isbn="5645690">
            <price>200.67</price>
            <name>Kill Bill</name>
        </book>
    </library>
    <library id="2">
        <book isbn="5645324690">
            <price>12.67</price>
            <name>Мурзилка №1</name>
        </book>
        <book isbn="56453324690">
            <price>12.69</price>
            <name>Мурзилка №2</name>
        </book>
    </library>
    <library id="3" />
</root>');
   if (obj=0) then
     exception UDF_TESTUNIT_EXP 'xml failed CREATEXMLDOCFROMSTRING';
   XMLENCODINGXML(obj,'windows-1251');
   XMLENCODING(obj,'windows-1251');
   hXPath = XmlXPathEval(obj,'//*',obj);
   if (hXPath<=0) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlXPathEval не должно быть ноль' ;
    cnt = XmlXPathNodeSetCount(obj, hXPath);
    if (cnt<>13) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlXPathNodeSetCount должно быть 13' ;
    i = 0;
    while (i<cnt) do
    begin
      hXPathNode = XMLXPATHNODESETITEM(obj,hXPath,i);
      if (hXPathNode<=0) then
        EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLXPATHNODESETITEM не должно быть ноль' || hXPathNode;
      if (i=0) then
      begin
        if (XMLNODENAME(obj,hXPathNode)<>'root') then
          EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLNODENAME  должно быть root';
        if (XMLNODECOUNTNODES(obj,hXPathNode)<>3)  then
          EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLNODECOUNTNODES  должно быть 3 для <root>' ;
        if (trim(XMLTEXTNODE(obj,hXPathNode))<>'200.67Kill Bill12.67Мурзилка №112.69Мурзилка №2') then
        begin
          resinfo = 'Факт: '||XMLTEXTNODE(obj,hXPathNode);suspend;
          EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLTEXTNODE  должно быть 200.67Kill Bil...';
        end
      end
        i = i + 1;
    end

    freeafobject(hXPath);

    if (XMLXPATHEVALVALUESTR(obj,'//library/book',obj)<>'200.67Kill Bill') then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLXPATHEVALVALUESTR  должно быть 200.67Kill Bill';
    if (XMLXPATHEVALVALUESTR(obj,'//library[@id=2]/book[last()]/name',obj)<>'Мурзилка №2') then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLXPATHEVALVALUESTR  должно быть Мурзилка №2';
    if (XMLXPATHEVALVALUENUM(obj,'//library[@id=2]/book[last()]/price',obj)<>12.69000000000000) then
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLXPATHEVALVALUENUM  должно быть 12.69000000000000 факт:'||XMLXPATHEVALVALUENUM(obj,'//library[@id=2]/book[last()]/price',obj);
    FREEAFOBJECT(obj);
    resinfo='6.XPath test has passed!';SUSPEND;

    obj = 0;
    resinfo='7.XML DTD';SUSPEND;
    res = FSFileDelete(sFolderName||FileName);
    bl = '<?xml version=''1.0''?>
<!DOCTYPE root [
<!ELEMENT root (child)+ >
<!ELEMENT child (#PCDATA)>
]>
<root>
<child>This is a first child.</child>
<child>And this is the second one.</child>
</root>';

    fsblobtofile(bl,sFolderName||FileName);

    s = createxmldocfromblobdtd(bl);
    if (s like '%ERROR:%') then
      EXCEPTION UDF_TESTUNIT_EXP 'Createxmldocfromblobdtd Error:' || s;
    else
    begin
      obj = cast(s as bigint);
      resinfo = 'createxmldocfromblobdtd - handle = '|| obj; suspend;
      if (obj>0) then freeafobject(obj);
    end


    bl = '<?xml version=''1.0''?>
<!DOCTYPE root [
<!ELEMENT root (child)+ >
<!ELEMENT child (#PCDATA)>
]>
<root>
<child>This is a first child.</child>
<child>And this is the second one.</child>
<test />
</root>';
    s = createxmldocfromblobdtd(bl);
    if (not (s like '%ERROR:%')) then
    begin
      obj = cast(s as bigint);
      resinfo = 'createxmldocfromblobdtd - handle = '|| obj; suspend;
      if (obj>0) then freeafobject(obj);
      obj = 0;
      EXCEPTION UDF_TESTUNIT_EXP 'Createxmldocfromblobdtd must error, but return:' || s;
    end
    resinfo = 'createxmldocfromblobdtd - OK!'; suspend;

    s = CreateXmlDocFromStringDTD('<?xml version=''1.0''?>
<!DOCTYPE root [
<!ELEMENT root (child)+ >
<!ELEMENT child (#PCDATA)>
]>
<root><child>This is a first child.</child><child>And this is the second one.</child></root>');
    if (s like '%ERROR:%') then
      EXCEPTION UDF_TESTUNIT_EXP 'CreateXmlDocFromStringDTD Error:' || s;
    else
    begin
      obj = cast(s as bigint);
      resinfo = ' CreateXmlDocFromStringDTD - handle = '|| obj; suspend;
      if (obj>0) then freeafobject(obj);
      obj = 0;
    end
    resinfo = 'CreateXmlDocFromStringDTD - OK!'; suspend;


    s = createxmldocfromfiledtd(sFolderName||FileName);
    if (s like '%ERROR:%') then
      EXCEPTION UDF_TESTUNIT_EXP 'Createxmldocfromfiledtd Error:' || s;
    else
    begin
      obj = cast(s as bigint);
      resinfo = 'Createxmldocfromfiledtd - handle = '|| obj; suspend;
      if (obj>0) then freeafobject(obj);
      obj = 0;
    end
    resinfo = 'createxmldocfromfiledtd - OK!'; suspend;

   resinfo='7.XML DTD has passed.';SUSPEND;


  WHEN ANY DO
   BEGIN
    if (obj>0) then
    begin
         res=FREEAFOBJECT(obj);
    end
     exception;
   end
END^

SET TERM ; ^

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

CREATE OR ALTER PROCEDURE UDF_TESTUNIT_ZIP_1
(
  sFolderName varchar(255)
  )

RETURNS
 ( resinfo varchar(1024) )
AS


 DECLARE VARIABLE mess varchar(1024);
 DECLARE VARIABLE res integer;
 DECLARE VARIABLE obj BIGINT;



  DECLARE VARIABLE bl blob SUB_TYPE 1;

  DECLARE VARIABLE FileName VARCHAR(2000) = 'udf_test1.zip';

BEGIN
  /*  Данная процедура является тестом для модуля afuzip
     Для проверки запустите  запрос:
       select * from UDF_TESTUNIT_ZIP_1('/home/user/');
    тест успешен, если нет исключения
  */

  bl = 'File is created for unittest.You can delete this file';
  res=FSBLOBTOFILE(bl,sFolderName||'test_zip1.txt');

  -- ТЕСТ №1 --
  resinfo=' 1.Тест создание архива ZIP';SUSPEND;
  obj = CreateZIP();
  if (obj=0) then
   EXCEPTION UDF_TESTUNIT_EXP  'Ошибка создания объекта ZIP' ;

  if (SetArhiveFileZIP(obj, sFolderName||FileName)=0) then
    EXCEPTION UDF_TESTUNIT_EXP 'Ошибка SetArhiveFileZIP';


  if (ClearSpecZIP(obj)=0) then
    EXCEPTION UDF_TESTUNIT_EXP 'Ошибка ClearSpecZIP';

  if (AddSpecZIP(obj,   sFolderName||'test_zip1.txt' )=0) then
    EXCEPTION UDF_TESTUNIT_EXP 'Ошибка AddSpecZIP';

  if (CompressZIP(obj)=0) then
    EXCEPTION UDF_TESTUNIT_EXP 'Ошибка CompressZIP';



  resinfo='1.Тест пройден успешно!';SUSPEND;
  res=FREEAFOBJECT(obj);
  obj = 0;
  -- ТЕСТ №1 КОНЕЦ --

  res=FSFileDelete(sFolderName||'test_zip1.txt');

  -- ТЕСТ №2 --
  resinfo=' 2.Тест распаковки архива ZIP';SUSPEND;
  obj = CreateUnZIP();
  if (obj=0) then
   EXCEPTION UDF_TESTUNIT_EXP  'Ошибка создания объекта UnZIP' ;

  if (SetArhiveFileZIP(obj, sFolderName||FileName)=0) then
    EXCEPTION UDF_TESTUNIT_EXP 'Ошибка SetArhiveFileZIP';

   if (ClearSpecZIP(obj)=0) then
    EXCEPTION UDF_TESTUNIT_EXP 'Ошибка ClearSpecZIP';

 if (AddSpecZIP(obj,   'test_zip1.txt' )=0) then
    EXCEPTION UDF_TESTUNIT_EXP 'Ошибка AddSpecZIP';

 if (SetExtractDirZIP(obj, sFolderName  )=0) then
    EXCEPTION UDF_TESTUNIT_EXP 'Ошибка AddSpecZIP';

  if (ExtractZIP(obj)=0) then
    EXCEPTION UDF_TESTUNIT_EXP 'Ошибка ExtractZIP';

  resinfo='2.Тест пройден успешно!';SUSPEND;
  res=FREEAFOBJECT(obj);
  obj = 0;
  -- ТЕСТ №2 КОНЕЦ --



  res=FSFileDelete(sFolderName||'test_zip1.txt');
  res=FSFileDelete(sFolderName||FileName);

  WHEN ANY DO
  BEGIN
    if (obj>0) then
     res=FREEAFOBJECT(obj);
     exception;
  END
END^

SET TERM ; ^

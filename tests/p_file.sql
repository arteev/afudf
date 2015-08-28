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

CREATE OR ALTER PROCEDURE UDF_TESTUNIT_FILE_1
(
  sFolderName varchar(255)
  )

RETURNS
 ( resinfo varchar(1024) )
AS


 DECLARE VARIABLE mess varchar(1024);
 DECLARE VARIABLE res integer;
 DECLARE VARIABLE k integer;
 DECLARE VARIABLE obj BIGINT;



  DECLARE VARIABLE bl blob SUB_TYPE 1;

  DECLARE VARIABLE FileName VARCHAR(2000) = 'tstfile_unit.tmp';

BEGIN
  /*  Данная процедура является тестом для модуля afucrypt
     Для проверки запустите  запрос:
       select * from UDF_TESTUNIT_FILE_1('/home/user/');
    тест успешен, если нет исключения
  */



  FileName  =sFolderName || FileName;
  resinfo='Удаляем '||FileName;SUSPEND;
  res=FSFILEDELETE(FileName);

  -- ТЕСТ №1 --
  resinfo=' 1.Тест операций с файлами';SUSPEND;
  if (FSFileExists(FileName)=1) then
     exception  UDF_TESTUNIT_EXP 'ошибка функции FSFileExists';

  bl  = 'File is created for unittest.You can delete this file';
  res=FSBLOBTOFILE(bl,FileName);
  if (res=0) then
   exception  UDF_TESTUNIT_EXP 'ошибка функции FSBLOBTOFILE';

   if (FSFileExists(FileName)=0) then
     exception  UDF_TESTUNIT_EXP 'ошибка функции FSFileExists';

    if (FSForceDirectories(sFolderName||'123')=0) then
      exception  UDF_TESTUNIT_EXP 'ошибка создания директории  пом. FSForceDirectories';

  if (FSFileCopy(FileName,FileName||'_1',0)=0) then
     exception  UDF_TESTUNIT_EXP 'ошибка копирования с помощью функции FSFileCopy';

  if (FSFILEDELETE(FileName||'_1')=0) then
     exception  UDF_TESTUNIT_EXP 'ошибка копирования с помощью функции FSFILEDELETE';

    bl = FSFILETOBLOB(FileName);
    if (bl<>'File is created for unittest.You can delete this file') then
    exception  UDF_TESTUNIT_EXP 'ошибка чтения из блоб с помощью функции FSFILETOBLOB';
  resinfo='1.Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №1 КОНЕЦ --

    -- ТЕСТ №2 --
  resinfo='2.Тест операций с поиск файлов';SUSPEND;

  res=FSFileCopy(FileName,FileName||'_1',0);
  res=FSFileCopy(FileName,FileName||'_2',0);
  res=FSFileCopy(FileName,FileName||'_3',0);

  obj=FSFindFirst(sFolderName||'*.*',63 );
  if (obj=0) then
   exception  UDF_TESTUNIT_EXP 'ошибка функции FSFindFirst';
   k=0;
    resinfo = 'File:'||FSFindRecName(obj)||' Аттрибуты: '||FSFindRecAttr(obj);
    suspend;
   while (k=0) do
   begin
     k = FSFINDNEXT(obj);
     if (k=0) then
     begin
       if (FSFindRecCheckAttr(obj,16)=1) then
       resinfo = 'Directory:'||FSFindRecName(obj) || ' Аттрибуты: '||FSFindRecAttr(obj);
       else
        resinfo = 'File:'||FSFindRecName(obj) || ' Аттрибуты: '||FSFindRecAttr(obj);
        suspend;
     end
   end
   res=FSFindClose(obj);
   res=FREEAFOBJECT(obj);
  resinfo=' 2.Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №2 КОНЕЦ --
  
  res=FSFILEDELETE(FileName);
  res=FSFILEDELETE(FileName||'_1');
  res=FSFILEDELETE(FileName||'_2');
  res=FSFILEDELETE(FileName||'_3');
  WHEN ANY DO
   BEGIN
    if (obj>0) then
    begin
      res=FSFindClose(obj);
      res=FREEAFOBJECT(obj);
    end
     exception;
   end
END^

SET TERM ; ^

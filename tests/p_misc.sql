/*{
    This file is part of the AF UDF library for Firebird 1.0 or high.
    Copyright (c) 2007-2009 by Arteev Alexei, OAO Pharmacy Tyumen.

    See the file COPYING.TXT, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    email: alarteev@yandex.ru, arteev@pharm-tmn.ru, support@pharm-tmn.ru

 ***********************************************************************/

create or alter EXCEPTION UDF_TESTUNIT_EXP 'Исключение для тестов AFUDF';

SET TERM ^ ;

CREATE OR ALTER PROCEDURE UDF_TESTUNIT_MISC_1

RETURNS
 ( resinfo varchar(1024) )
AS
 DECLARE VARIABLE mess varchar(32000);
 DECLARE VARIABLE res integer;
 DECLARE VARIABLE bl BLOB;
BEGIN
  /*  Данная процедура является тестом для модуля afumisc
     Для проверки запустите  запрос:
       select * from UDF_TESTUNIT_MISC_1;
    тест успешен, если нет исключения
  */
  -- ТЕСТ №1 --
  resinfo='1. Тест на получения генерацию GUID';SUSPEND;
  mess=GENGUID();
  if ((mess is null) or (mess=''))  then
    EXCEPTION UDF_TESTUNIT_EXP 'Ошибка GENGUID';

  if ((not mess  like '%{%') or  (not mess  like '%}%') or  (not mess  like '%-%')) then
    EXCEPTION UDF_TESTUNIT_EXP 'Ошибка GENGUID';
  resinfo = mess;suspend;
  resinfo='1. Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №1 КОНЕЦ --

  -- ТЕСТ №2 --
  resinfo='1. Тест на DelCharsFromBlob';SUSPEND;
  bl = '        AAAAAAA AAAAAAAAAAAAAAAAAAAA AAAA  AAAAAAAA                              B';
  resinfo=bl;SUSPEND;
  bl=DELCHARSFROMBLOB(bl,32);
  resinfo=bl;SUSPEND;
  bl=DELCHARSFROMBLOB(bl,65);
  resinfo=bl;SUSPEND;
  if (bl<>'B') then
   EXCEPTION UDF_TESTUNIT_EXP 'Функция DELCHARSFROMBLOB работает не верно';
  resinfo='2. Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №2 КОНЕЦ --

END^

SET TERM ; ^

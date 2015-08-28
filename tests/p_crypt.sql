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

CREATE OR ALTER PROCEDURE UDF_TESTUNIT_CRYPT_1

RETURNS
 ( resinfo varchar(1024) )
AS


 DECLARE VARIABLE mess varchar(1024);
 DECLARE VARIABLE res integer;

  DECLARE VARIABLE sSHA1Etalon varchar(200)  = 'c56c9c93756575a2958ec02e0ba988bea45f3f2a';
  DECLARE VARIABLE sMD5Etalon varchar(200)  = '4058dbe9c8469eb73dbccff2769db044';
  DECLARE VARIABLE sCRC32Etalon varchar(200)  = 'A14CF3F7';

  DECLARE VARIABLE sEtalon varchar(200)  = 'String test!';
  DECLARE VARIABLE bl blob SUB_TYPE 1;



BEGIN
  /*  Данная процедура является тестом для модуля afucrypt
     Для проверки запустите  запрос:
       	select * from UDF_TESTUNIT_CRYPT_1;
    тест успешен, если нет исключения
  */


  -- Тест SHA1
  resinfo='1. Тест на  SHA1';SUSPEND;
  -- ТЕСТ №1 --
  resinfo='1.1 Тест на получения хеш-значения эталонной строки';SUSPEND;
  mess=CRYPTSHA1STRING(trim(sEtalon));
  resinfo = 'Хеш  для "'||sEtalon|| '" = '|| mess;  SUSPEND;
  if (trim(sSHA1Etalon )<>trim(mess)) then
   EXCEPTION UDF_TESTUNIT_EXP 'Не верно хеш значение.'||mess;
  resinfo='1. Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №1.1 КОНЕЦ --

  -- ТЕСТ №1.2 --
  bl = sEtalon;
  resinfo='1.2. Тест на получения хеш-значения  блоба';SUSPEND;
  mess=CryptSha1Blob(bl);
  if (trim(sSHA1Etalon )<>trim(mess)) then
   EXCEPTION UDF_TESTUNIT_EXP 'CryptSha1Blob.Не верно хеш значение.'||mess;
  resinfo = 'Хеш  для "'||sEtalon|| '" = '|| mess;  SUSPEND;
  resinfo='1.2. Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №1.2 КОНЕЦ --

  -- ТЕСТ №1.3 --
  bl = null;
  resinfo='1.3. Тест на получения хеш-значения  блоба  и строки от NULL';SUSPEND;
  if (trim(CryptSha1String(null))<>trim(CryptSha1Blob(bl))) then
   EXCEPTION UDF_TESTUNIT_EXP 'Не верно хеш значение.';
  resinfo='1.3. Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №3 КОНЕЦ --

    -- ТЕСТ №1.4 --
  resinfo='1.4 Тест на получения хеш-значения пустой строки и null';SUSPEND;
  if (CRYPTSHA1STRING('')<>'') then
    EXCEPTION UDF_TESTUNIT_EXP 'Не верно хеш значение для пустой строки';
  if (CRYPTSHA1STRING(null)<>'') then
    EXCEPTION UDF_TESTUNIT_EXP 'Не верно хеш значение для null';
  resinfo='1.4 Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №1.4 КОНЕЦ --

    -- ТЕСТ №1.5 --
  resinfo='1.5 Тест на получения хеш-значения не существующего файла';SUSPEND;
  if (CRYPTSHA1FILE('3424 2rw erw r2 3r2r 2rw rwsfs')<>'') then
    EXCEPTION UDF_TESTUNIT_EXP 'Не верно хеш значение для  не существующего файла';
  resinfo='1.5 Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №1.5 КОНЕЦ --

  -- Конец:Тест SHA1
  resinfo='1. Конец: Тест на  SHA1';SUSPEND;
  -------------------------------------------------------------------------------------------------------------------------------------------------

  -- Тест md5
  resinfo='2 Тест на  MD5';SUSPEND;
  -- ТЕСТ №2.1 --
  resinfo='2.1 Тест на получения хеш-значения эталонной строки';SUSPEND;
  mess=CRYPTMD5(sEtalon);
  resinfo = 'Хеш  для "'||sEtalon|| '" = '|| mess;  SUSPEND;
  if (trim(sMd5Etalon )<>trim(mess)) then
   EXCEPTION UDF_TESTUNIT_EXP 'Не верно хеш значение MD5.'|| mess;
  resinfo='2.1 Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №2.1 КОНЕЦ --

  -- ТЕСТ №2.2 --
  bl = sEtalon;
  resinfo='2.2. Тест на получения хеш-значения  блоба';SUSPEND;
  mess=CRYPTMD5BLOB(bl);
  resinfo = 'Хеш  для "'||sEtalon|| '" = '|| mess;  SUSPEND;
  if (trim(sMd5Etalon )<>trim(mess)) then
    EXCEPTION UDF_TESTUNIT_EXP 'CRYPTMD5BLOB.Не верно хеш значение. ';
  resinfo='2.2. Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №2.2 КОНЕЦ -

  -- ТЕСТ №2.3 --
  bl = null;
  resinfo='2.3. Тест на получения хеш-значения  блоба  и строки от NULL';SUSPEND;
  if (trim(CRYPTMD5(null))<>trim(CRYPTMD5BLOB(bl))) then
   EXCEPTION UDF_TESTUNIT_EXP 'CRYPTMD.Не верно хеш значение от (null).';
  resinfo='2.3. Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №2.3 КОНЕЦ --

    -- ТЕСТ №2.4 --
  resinfo='2.4 Тест на получения хеш-значения пустой строки и null';SUSPEND;
  if (CRYPTMD5('')<>'') then
    EXCEPTION UDF_TESTUNIT_EXP 'Не верно хеш значение для пустой строки';
  if (CRYPTMD5(null)<>'') then
    EXCEPTION UDF_TESTUNIT_EXP 'Не верно хеш значение для null';
  resinfo='2.4 Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №2.4 КОНЕЦ --

  -- ТЕСТ №2.5 --
  resinfo='2.5 Тест на получения хеш-значения не существующего файла';SUSPEND;
  if (CRYPTMD5FILE('3424 rw erw r2 3r2r 2rw rwsfs')<>'') then
    EXCEPTION UDF_TESTUNIT_EXP 'Не верно хеш значение для  не существующего файла';
  resinfo='2.5 Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №2.5 КОНЕЦ --
  -- Конец:Тест SHA1
  resinfo='2. Конец: Тест на  MD5';SUSPEND;


   -- Тест CRC32
  resinfo='3 Тест на  CRC32';SUSPEND;
  -- ТЕСТ №3.1 --
  resinfo='3.1 Тест на получения хеш-значения эталонной строки';SUSPEND;
  mess=CRYPTCRC32(sEtalon);
  resinfo = 'Хеш  для "'||sEtalon|| '" = '|| mess;  SUSPEND;
  if (trim(sCRC32Etalon )<>trim(mess)) then
   EXCEPTION UDF_TESTUNIT_EXP 'CRYPTCRC32.Не верно хеш значение.'||mess;
  resinfo='3.1 Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №2.1 КОНЕЦ --

    -- ТЕСТ №3.2 --
  bl = sEtalon;
  resinfo='3.2. Тест на получения хеш-значения  блоба';SUSPEND;
  mess=CRYPTCRC32BLOB(bl);
  resinfo = 'Хеш  для "'||sEtalon|| '" = '|| mess;  SUSPEND;
  if (trim(sCRC32Etalon )<>trim(mess)) then
    EXCEPTION UDF_TESTUNIT_EXP 'CRYPTCRC32BLOB.Не верно хеш значение.'||mess;
  resinfo='3.2. Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №3.2 КОНЕЦ -

    -- ТЕСТ №3.3 --
  bl = null;
  resinfo='3.3. Тест на получения хеш-значения  блоба  и строки от NULL';SUSPEND;
  if (trim(CRYPTCRC32(null))<>trim(CRYPTCRC32BLOB(bl))) then
   EXCEPTION UDF_TESTUNIT_EXP 'Не верно хеш значение.';
  resinfo='3.3. Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №3.3 КОНЕЦ -

    -- ТЕСТ №3.4 --
  resinfo='3.4 Тест на получения хеш-значения пустой строки и null';SUSPEND;
  if ((CRYPTCRC32('')<>'') ) then
    EXCEPTION UDF_TESTUNIT_EXP 'Не верно хеш значение для пустой строки'||CRYPTCRC32('');
  if (CRYPTCRC32(null)<>'') then
    EXCEPTION UDF_TESTUNIT_EXP 'Не верно хеш значение для null';
  resinfo='3.4 Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №3.4 КОНЕЦ --

  -- ТЕСТ №3.5 --
  resinfo='3.5 Тест на получения хеш-значения не существующего файла';SUSPEND;
  if (CRYPTCRC32FILE('3424 2rw erw r2 3r2r 2rw rwsfs')<>'') then
    EXCEPTION UDF_TESTUNIT_EXP 'Не верно хеш значение для  не существующего файла';
  resinfo='3.5 Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №3.5 КОНЕЦ --
  -- Конец:Тест SHA1
  resinfo='3. Конец: Тест на  CRC32';SUSPEND;

  resinfo='Все тесты прошли успешно!';SUSPEND;
END^

SET TERM ; ^

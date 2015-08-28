/*{
    This file is part of the AF UDF library for Firebird 1.0 or high.
    Copyright (c) 2007-2009 by Arteev Alexei, OAO Pharmacy Tyumen.

    See the file COPYING.TXT, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    email: alarteev@yandex.ru, arteev@pharm-tmn.ru, support@pharm-tmn.ru
    web  : www.pharm-tmn.ru
    tel  : +7(3452)473130

 ***********************************************************************/

create or alter EXCEPTION UDF_TESTUNIT_EXP 'Исключение для тестов AFUDF';

SET TERM ^ ;

create or alter procedure udf_testunit_check_exception(obj integer,tstfuncion varchar(100), mustexcept integer)
as
BEGIN
  -- данная функция проверяет должна быть ошибка  в объекте или нет
    
   if (obj = 0 ) then exit;
   if (trim(tstfuncion)='') then tstfuncion='Не известная функция';
   
   if (mustexcept=1 and  WASERROROBJ(obj)=0)  then 
      EXCEPTION UDF_TESTUNIT_EXP 'Для функции '||tstfuncion||' не  зафиксирована ошибка, хотя должна была быть';
  
   if (mustexcept<>1 and  WASERROROBJ(obj)=1)  then 
      EXCEPTION UDF_TESTUNIT_EXP 'Для функции '||tstfuncion||' зафиксирована ошибка, хотя НЕ должна была быть' || MSGLASTERROROBJ(obj);      
      
end ^

CREATE OR ALTER PROCEDURE UDF_TESTUNIT_COMMON_1 
 
RETURNS 
 ( resinfo varchar(1024) )
AS 

 
 DECLARE VARIABLE mess varchar(1024); 
 DECLARE VARIABLE res integer; 
 DECLARE VARIABLE obj integer; 

  
  DECLARE VARIABLE sEtalon varchar(200)  = 'String test!'; 
  DECLARE VARIABLE bl blob SUB_TYPE 1;
  
  

BEGIN
  /*  Данная процедура является тестом для модуля afucrypt
     Для проверки запустите  запрос:
       select * from UDF_TESTUNIT_COMMON_1;
    тест успешен, если нет исключения
  */ 
    
    
  -- ТЕСТ №1 --
  resinfo='1. Тест на DelCharsFromBlob';SUSPEND;
  bl = '        AAAAAAA AAAAAAAAAAAAAAAAAAAA AAAA  AAAAAAAA                              B';
  resinfo=bl;SUSPEND;
  bl=DELCHARSFROMBLOB(bl,32);
  resinfo=bl;SUSPEND;
  bl=DELCHARSFROMBLOB(bl,65); 
  resinfo=bl;SUSPEND;
  if (bl<>'B') then
   EXCEPTION UDF_TESTUNIT_EXP 'Функция DELCHARSFROMBLOB работает не верно';
  resinfo='1. Тест пройден успешно!';SUSPEND;   
  -- ТЕСТ №1 КОНЕЦ --
  
  -- ТЕСТ №2--
  resinfo='2. Тест на обработки ошибок';SUSPEND;
  obj = CreateTextFile('VY://');
  -- попытка отрыть не сущ. файл
  
  res = ResetTextFile(obj);
  if (WasErrorObj(obj)<>1) then 
    EXCEPTION UDF_TESTUNIT_EXP 'Не верно работает функция:WasErrorObj';
  
  if (WasErrorIsExceptionObj(obj)<>1) then 
    EXCEPTION UDF_TESTUNIT_EXP 'Не верно работает функция:WasErrorIsExceptionObj';
  
  
  resinfo='Была ошибка: '||MsgLastErrorObj(obj);suspend;  
  if (MsgLastErrorObj(obj)='Unknow error.') then 
    EXCEPTION UDF_TESTUNIT_EXP 'Не верно работает функция:MsgLastErrorObj ';
  
  
  if (GetLastErrorObj(obj)<>0) then 
    EXCEPTION UDF_TESTUNIT_EXP 'Не верно работает функцияGetLastErrorObj ';
  
  res=SetMsgErrorExceptionObj(obj,'ErrTest');
  if (MsgLastErrorObj(obj)<>'ErrTest') then 
    EXCEPTION UDF_TESTUNIT_EXP 'Не верно работает функция:SetMsgErrorExceptionObj ';
  
  if (FreeAFObject(0)=1  or FREEAFOBJECT(obj)<>1 ) then 
    EXCEPTION UDF_TESTUNIT_EXP 'Не верно работает функция:FreeAFObject ';
  
  obj = 0;
  resinfo='2. Тест пройден успешно!';SUSPEND;   
  -- ТЕСТ №2 КОНЕЦ --
    -- ТЕСТ №3--
  resinfo='3. Тест на тип операционной системы';SUSPEND;
  mess=GetTypeOs();
  resinfo='ОС: '||mess; suspend;
    if (mess<>'linux' and mess<>'windows' ) then 
      EXCEPTION UDF_TESTUNIT_EXP 'Не  тип операционной системы: '||mess; 
  resinfo='3. Тест пройден успешно!';SUSPEND;   
  -- ТЕСТ №3 КОНЕЦ --  
  
  mess=versionafudf();
  resinfo='Версия библиотек AFUDF: '||mess; suspend;
  if (mess='') then
      EXCEPTION UDF_TESTUNIT_EXP 'Не удалось определить версию UDF'||mess;

    
  mess=versionexafudf();
  resinfo='Версия библиотек AFUDF: '||mess; suspend;
  if (mess='') then
      EXCEPTION UDF_TESTUNIT_EXP 'Не удалось определить версию UDF(расширенную)'||mess;

  resinfo='Все тесты пройдены успешно!!!';SUSPEND;   
  when any DO
  BEGIN
     if (obj >0) then res= FREEAFOBJECT(obj);
     EXCEPTION;
  end
  
      
END^

SET TERM ; ^
/*{
    This file is part of the AF UDF library for Firebird 1.0 or high.
    Copyright (c) 2007-2009 by Arteev Alexei, OAO Pharmacy Tyumen.

    See the file COPYING.TXT, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    email: alarteev@yandex.ru, arteev@pharm-tmn.ru, support@pharm-tmn.ru
    web  : www.pharm-tmn.ru
    tel  : +7(3452)473130

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
   EXCEPTION UDF_TESTUNIT_EXP 'Не верно хеш значение.';  
  resinfo='1. Тест пройден успешно!';SUSPEND; 
  -- ТЕСТ №1.1 КОНЕЦ --
  
  -- ТЕСТ №1.2 --
  bl = sEtalon;  
  resinfo='1.2. Тест на получения хеш-значения  блоба';SUSPEND;
  mess=CryptSha1Blob(bl);
  if (trim(sSHA1Etalon )<>trim(mess)) then
   EXCEPTION UDF_TESTUNIT_EXP 'Не верно хеш значение.';
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
  if (CRYPTSHA1FILE('3424 /\\//2rw erw r2 3r2r 2rw rwsfs')<>'') then
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
   EXCEPTION UDF_TESTUNIT_EXP 'Не верно хеш значение.';  
  resinfo='2.1 Тест пройден успешно!';SUSPEND; 
  -- ТЕСТ №2.1 КОНЕЦ --
  
  -- ТЕСТ №2.2 --
  bl = sEtalon;  
  resinfo='2.2. Тест на получения хеш-значения  блоба';SUSPEND;
  mess=CRYPTMD5BLOB(bl);
  resinfo = 'Хеш  для "'||sEtalon|| '" = '|| mess;  SUSPEND;
  if (trim(sMd5Etalon )<>trim(mess)) then
    EXCEPTION UDF_TESTUNIT_EXP 'Не верно хеш значение.';  
  resinfo='2.2. Тест пройден успешно!';SUSPEND; 
  -- ТЕСТ №2.2 КОНЕЦ -
  
  -- ТЕСТ №2.3 --
  bl = null;    
  resinfo='2.3. Тест на получения хеш-значения  блоба  и строки от NULL';SUSPEND;  
  if (trim(CRYPTMD5(null))<>trim(CRYPTMD5BLOB(bl))) then
   EXCEPTION UDF_TESTUNIT_EXP 'Не верно хеш значение.';  
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
  if (CRYPTMD5FILE('3424 /\\//2rw erw r2 3r2r 2rw rwsfs')<>'') then
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
   EXCEPTION UDF_TESTUNIT_EXP 'Не верно хеш значение.';  
  resinfo='3.1 Тест пройден успешно!';SUSPEND; 
  -- ТЕСТ №2.1 КОНЕЦ --
  
    -- ТЕСТ №3.2 --
  bl = sEtalon;  
  resinfo='3.2. Тест на получения хеш-значения  блоба';SUSPEND;
  mess=CRYPTCRC32BLOB(bl);
  resinfo = 'Хеш  для "'||sEtalon|| '" = '|| mess;  SUSPEND;
  if (trim(sCRC32Etalon )<>trim(mess)) then
    EXCEPTION UDF_TESTUNIT_EXP 'Не верно хеш значение.';  
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
  if (CRYPTCRC32('')<>'') then
    EXCEPTION UDF_TESTUNIT_EXP 'Не верно хеш значение для пустой строки';  
  if (CRYPTCRC32(null)<>'') then
    EXCEPTION UDF_TESTUNIT_EXP 'Не верно хеш значение для null';      
  resinfo='3.4 Тест пройден успешно!';SUSPEND; 
  -- ТЕСТ №3.4 КОНЕЦ --
      
  -- ТЕСТ №3.5 --
  resinfo='3.5 Тест на получения хеш-значения не существующего файла';SUSPEND;
  if (CRYPTCRC32FILE('3424 /\\//2rw erw r2 3r2r 2rw rwsfs')<>'') then
    EXCEPTION UDF_TESTUNIT_EXP 'Не верно хеш значение для  не существующего файла';  
  resinfo='3.5 Тест пройден успешно!';SUSPEND; 
  -- ТЕСТ №3.5 КОНЕЦ --   
  -- Конец:Тест SHA1
  resinfo='3. Конец: Тест на  CRC32';SUSPEND; 

  resinfo='Все тесты прошли успешно!';SUSPEND;  

      
END^

SET TERM ; ^
/*{
    This file is part of the AF UDF library for Firebird 1.0 or high.
    Copyright (c) 2007-2009 by Arteev Alexei, OAO Pharmacy Tyumen.

    See the file COPYING.TXT, included in this distribution,
    for details about the copyright.ss

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    email: alarteev@yandex.ru, arteev@pharm-tmn.ru, support@pharm-tmn.ru
    web  : www.pharm-tmn.ru
    tel  : +7(3452)473130

 ***********************************************************************/

create or alter EXCEPTION UDF_TESTUNIT_EXP 'Исключение для тестов AFUDF';

SET TERM ^ ;

create or alter procedure udf_testunit_check_exception(obj1 integer,tstfuncion varchar(100), mustexcept integer)
as
BEGIN
  -- данная функция проверяет должна быть ошибка  в объекте или нет
    
   if (obj1 = 0 ) then exit;
   if (trim(tstfuncion)='') then tstfuncion='Не известная функция';
   
   if (mustexcept=1 and  WASERROROBJ(obj1)=0)  then 
      EXCEPTION UDF_TESTUNIT_EXP 'Для функции '||tstfuncion||' не  зафиксирована ошибка, хотя должна была быть';
  
   if (mustexcept<>1 and  WASERROROBJ(obj1)=1)  then 
      EXCEPTION UDF_TESTUNIT_EXP 'Для функции '||tstfuncion||' зафиксирована ошибка, хотя НЕ должна была быть' || MSGLASTERROROBJ(obj1);      
end^

CREATE OR ALTER PROCEDURE UDF_TESTUNIT_DBF_1 
(
  sFolderName varchar(255)
  )
 
RETURNS 
 ( resinfo varchar(1024) )
AS 

 
 DECLARE VARIABLE mess varchar(1024); 
 DECLARE VARIABLE res integer; 
 DECLARE VARIABLE obj integer; 

  
  
  DECLARE VARIABLE bl blob SUB_TYPE 1;
  
  DECLARE VARIABLE FileName VARCHAR(2000) = 'dbf_test1.dbf';

BEGIN
  /*  Данная процедура является тестом для модуля afuzip
     Для проверки запустите  запрос:
       select * from UDF_TESTUNIT_DBF_1('/home/user/');
    тест успешен, если нет исключения
  */ 
    


  
  obj = CreateDBF(sFolderName||FileName,1,1,0,1);
  if (obj=0) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка создания DBF';
  -- ТЕСТ №1 --
  resinfo=' 1.Тест  работы с полями';SUSPEND;   
   
  if (FieldCountDBF(obj)<>0) then 
   EXCEPTION UDF_TESTUNIT_EXP 'Ошибка FieldCountDBF  должно быть 0';
     EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'FieldCountDBF',0);
   
  if (FieldExistsDBF(obj,'Field1')<>0)  then 
  EXCEPTION UDF_TESTUNIT_EXP 'Ошибка FieldExistsDBF для Field1 должно быть 0';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'FieldCountDBF',0);
  
  if (GetFieldNameDBFByIndex(obj,0)<>'') then 
   EXCEPTION UDF_TESTUNIT_EXP 'Ошибка GetFieldNameDBFByIndex  значение  имени поля для не сущ поля';
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'GetFieldNameDBFByIndex',1);
   
   
  if (AddFieldDBF(obj,'Field1','C',10,0) =0) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка для AddFieldDBF добавления поля Field1(C,10) '|| MSGLASTERROROBJ(obj);   
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'AddFieldDBF',0);
     
  
  if (AddFieldDBF(obj,'Field2','N',5,1) =0) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка для AddFieldDBF добавления поля Field2(N,5.1) ';   
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'AddFieldDBF',0);     

  if (AddFieldDBF(obj,'Field3','D',8,0) =0) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка для AddFieldDBF добавления поля Field3(D) ';   
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'AddFieldDBF',0);
  
  if (AddFieldDBF(obj,'Field1','C',10,0) =1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка для AddFieldDBF поле Field1(C,10) не должно быть добавлено ';   
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'AddFieldDBF',1);     
  
  

  
  resinfo='1.Тест пройден успешно!';SUSPEND;     
  -- ТЕСТ №1 КОНЕЦ --
  
  
  
  -- ТЕСТ №2 --
  resinfo=' 2.Тест  работы с DBF Файлом';SUSPEND;  
  
  if (OpenDBF(obj)=1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка OpenDBF  не должно быть 1';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'OpenDBF',1);
  
  if (CloseDBF(obj)=0) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка CloseDBF  не должно быть 0';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'CloseDBF',0);  
   
  if (not GetFormatDBF(obj) in (3,4,7,25) ) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка GetFormatDBF   должно быть 3,4,7,25';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'GetFormatDBF',0);
   
  if (SetFormatDBF(obj,7) =0 ) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка SetFormatDBF  не должно быть 0';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'SetFormatDBF',0);   
  
   if (SetFormatDBF(obj,1111) =1 and GetFormatDBF(obj)<>7 ) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка SetFormatDBF  не должно быть формата 1111';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'SetFormatDBF',0);   
  
  res=SetFormatDBF(obj,4) ; 
  
     
  if (CreateTableDBF(obj) =0 ) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка CreateTableDBF  создания DBF ' || MSGLASTERROROBJ(obj);
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'CreateTableDBF',0);   
  
    
  
  if (OpenDBF(obj)=0) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка OpenDBF  не должно быть 0';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'OpenDBF',0);
  
    if (CreateTableDBF(obj) =1 ) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка CreateTableDBF  должна была вернуть 0 ';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'CreateTableDBF',1);   
  
  if (GetFieldNameDBFByIndex(obj,0)='') then 
   EXCEPTION UDF_TESTUNIT_EXP 'Ошибка GetFieldNameDBFByIndex  значение  имени поля для  сущ поля не найдено';
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'GetFieldNameDBFByIndex',0);
   
   
  if (FieldCountDBF(obj)<>3) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка FieldCountDBF   должно быть 3';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'FieldCountDBF',0);
   
  if (FieldExistsDBF(obj,'Field1')=0)  then 
  EXCEPTION UDF_TESTUNIT_EXP 'Ошибка FieldExistsDBF для Field1 должно быть 1';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'FieldCountDBF',0);  
   
  
   if (SetFormatDBF(obj,7) =1 ) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка SetFormatDBF   должно быть 0';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'SetFormatDBF',1);   

  
    if (CloseDBF(obj)=0) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка CloseDBF должно быть 1';
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'CloseDBF',0);    
  
  resinfo='2.Тест пройден успешно!';SUSPEND;     
  -- ТЕСТ №2 КОНЕЦ --
  
  
  
  -- ТЕСТ №3 --
  resinfo=' 3.Тест  работы со редактиро записей ';SUSPEND;  
  
    if (StateDBF(obj)<>0) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка OpenDBF  должно быть 0';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'StateDBF',0);
  
 if (OpenDBF(obj)<>1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка OpenDBF   должно быть 1';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'OpenDBF',0);
  
   
   if (StateDBF(obj)<>1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'ОшибкаStateDBF  должно быть 1';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'StateDBF',0);
  
  
  if (PostDBF(obj)=1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка PostDBF  должно быть 0';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'PostDBF',1);
  
  
    if (AppendDBF(obj)<>1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка AppendDBF  должно быть 1';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'AppendDBF',0);
  
  if (CancelDBF(obj)<>1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка CancelDBF  должно быть 1';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'CancelDBF',0);
  
    if (AppendDBF(obj)<>1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка AppendDBF  должно быть 1';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'AppendDBF',0);
  
   if (PostDBF(obj)<>1) then 
      EXCEPTION UDF_TESTUNIT_EXP 'Ошибка PostDBF  должно быть 1';
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'PostDBF',0
   );
  
  
  if (EditDBF(obj)<>1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка EditDBF  должно быть 1';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'EditDBF',0);
  
  
   if (StateDBF(obj)<>2) then 
     EXCEPTION UDF_TESTUNIT_EXP 'ОшибкаStateDBF  должно быть 2';
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'StateDBF',0  );
  
    res=PostDBF(obj);
    
  if (DeleteDBF(obj)<>1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка DeleteDBF  должно быть 1';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'DeleteDBF',0);
  
    if (DeleteDBF(obj)<>0) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка DeleteDBF  должно быть 0';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'DeleteDBF',1);
  
  if (PackDBF(obj)<>1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка PackDBF  должно быть 1';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'PackDBF',0);
   resinfo='3.Тест пройден успешно!';SUSPEND;     
 -- ТЕСТ №3 КОНЕЦ --
  
  
   -- ТЕСТ №4 --
   resinfo=' 4.Тест  работы со редактиро записей ';SUSPEND;
   res=AppendDBF(obj);
  
    if (SetValueDBFFieldByName(obj,'FieldNO','test')=1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка SetValueDBFFieldByName  должно быть 0';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'SetValueDBFFieldByName',1);
  
  
  
  if (SetValueDBFFieldByName(obj,'Field1','test')<>1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка SetValueDBFFieldByName  должно быть 1';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'SetValueDBFFieldByName',0);   
   res=PostDBF(obj);
   --+1
   
   res=AppendDBF(obj);
   if (SetValueDBFFieldByName(obj,'Field2',10.99)<>1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка SetValueDBFFieldByName  должно быть 1';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'SetValueDBFFieldByName',0);   
   res=PostDBF(obj);
   --+2
   
    res=AppendDBF(obj);
   if (SetValueDBFFieldByName(obj,'Field2','err')<>0) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка SetValueDBFFieldByName  должно быть 0';
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'SetValueDBFFieldByName',1);   
   res=PostDBF(obj);
   --+3
   
    res=AppendDBF(obj);
   if (SetValueDBFFieldByName(obj,'Field3','2009-03-01')<>1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка SetValueDBFFieldByName   должно быть 1';
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'SetValueDBFFieldByName',0);   
   
     if (SetValueDBFFieldByName(obj,'Field1',null)<>1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка SetValueDBFFieldByName должно быть 1' ;
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'SetValueDBFFieldByName',0);   
   

   if (SetValueDBFFieldByName(obj,'Field3','2009- 2009-2009')<>0) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка SetValueDBFFieldByName  должно быть 0';
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'SetValueDBFFieldByName',1);   
   res=PostDBF(obj);   
   --+4
   
      
     if (ValueIsNullDBF(obj,'Field1')<>1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка ValueIsNullDBF должно быть 1' ;
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'ValueIsNullDBF',0);   
   
         
     if (ValueIsNullDBF(obj,'Field3')<>0) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка ValueIsNullDBF должно быть 0' ;
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'ValueIsNullDBF',0);
      
   
    if (RECORDCOUNTDBF(obj)<>4) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка RECORDCOUNTDBF должно быть 4' ;
   
   
           
     if (GetValueDBFFieldByName(obj,'Field3')<>'2009-03-01') then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка GetValueDBFFieldByName должно быть 2009-03-01' ;
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'GetValueDBFFieldByName',0);
   
           
     if (GetValueDBFFieldByName(obj,'Field1')<>'') then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка GetValueDBFFieldByName должно быть пусто' ;
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'GetValueDBFFieldByName',0);
      
      
   if (GetValueDBFFieldByName(obj,'FieldNo')<>'') then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка GetValueDBFFieldByName должно быть пусто' ;
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'GetValueDBFFieldByName',1);
   
   resinfo='4.Тест пройден успешно!';SUSPEND;     
   -- ТЕСТ №4 КОНЕЦ --
   
   -- ТЕСТ №5 --
   resinfo='5.Тест  на навигацию в файле!';SUSPEND;     
   res=CloseDBF(obj);
   
   if (NextInDBF(obj)<>0) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка NextInDBF должно быть 0' ;
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'NextInDBF',1);
   
   if (PrevInDBF(obj)<>0) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка PrevInDBF должно быть 0' ;
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'PrevInDBF',1);   

   if (FirstInDBF(obj)<>0) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка FirstInDBF должно быть 0' ;
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'FirstInDBF',1);
   
   if (LastInDBF(obj)<>0) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка LastInDBF должно быть 0' ;
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'LastInDBF',1);
   
   if (EofInDBF(obj)<>1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка EofInDBF должно быть 1' ;
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'EofInDBF',0);   
   
   if (RecNoDBF(obj)<>0) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка RecNoDBF должно быть 0' ;
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'RecNoDBF',0);     

   
   if (RecordCountDBF(obj)<>0) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка RecordCountDBF должно быть 0' ;
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'RecordCountDBF',0);      
   
   if (SetRecNoDBF(obj,100)<>0) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка SetRecNoDBF должно быть 0' ;
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'SetRecNoDBF',1);      
  
   res = OPENDBF(obj);
      
   if (RecNoDBF(obj)<>1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка RecNoDBF должно быть 1' ; 
     
    if (NextInDBF(obj)<>1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка NextInDBF должно быть 1' ;
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'NextInDBF',0);
   
   if (PrevInDBF(obj)<>1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка PrevInDBF должно быть 1' ;
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'PrevInDBF',0);   

   if (FirstInDBF(obj)<>1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка FirstInDBF должно быть 1' ;
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'FirstInDBF',0);
   
   if (LastInDBF(obj)<>1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка LastInDBF должно быть 1' ;
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'LastInDBF',0);
   
   res = PrevInDBF(obj);
   if (EofInDBF(obj)<>0) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка EofInDBF должно быть 0' ;
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'EofInDBF',0);   
   
   
   if (RecordCountDBF(obj)<>4) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка RecordCountDBF должно быть 4' ;
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'RecordCountDBF',0);      
   
   if (SetRecNoDBF(obj,2)<>2) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка SetRecNoDBF должно быть 2';
   EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'SetRecNoDBF',0);     
   
   
   resinfo='5.Тест пройден успешно!';SUSPEND;     
   -- ТЕСТ №5 КОНЕЦ --
   
    res=CloseDBF(obj);
  
  
  
  res=FREEAFOBJECT(obj);
  obj = 0;
  

  -- res = FSFileDelete(sFolderName||FileName);
  
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
/*{
    This file is part of the AF UDF library for Firebird 1.0 or high.
    Copyright (c) 2007-2009 by Arteev Alexei, OAO Pharmacy Tyumen.

    See the file COPYING.TXT, included in this distribution,
    for details about the copyright.ss

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    email: alarteev@yandex.ru, arteev@pharm-tmn.ru, support@pharm-tmn.ru
    web  : www.pharm-tmn.ru
    tel  : +7(3452)473130

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
 DECLARE VARIABLE obj integer; 

  
  
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
/*{
    This file is part of the AF UDF library for Firebird 1.0 or high.
    Copyright (c) 2007-2009 by Arteev Alexei, OAO Pharmacy Tyumen.

    See the file COPYING.TXT, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    email: alarteev@yandex.ru, arteev@pharm-tmn.ru, support@pharm-tmn.ru
    web  : www.pharm-tmn.ru
    tel  : +7(3452)473130

 ***********************************************************************/

create or alter EXCEPTION UDF_TESTUNIT_EXP 'Исключение для тестов AFUDF';

SET TERM ^ ;

CREATE OR ALTER PROCEDURE UDF_TESTUNIT_MISC_1 
 
RETURNS 
 ( resinfo varchar(1024) )
AS 

 
 DECLARE VARIABLE mess varchar(1024); 
 DECLARE VARIABLE res integer; 

  
  

BEGIN
  /*  Данная процедура является тестом для модуля afumisc
     Для проверки запустите  запрос:
       select * from UDF_TESTUNIT_MISC_1;
    тест успешен, если нет исключения
  */ 
    
    
  -- ТЕСТ №1 --
  resinfo='1. Тест на получения генерацию GUID';SUSPEND;
  mess=GENGUID();   
  if(not mess  like '%{%' or  not mess  like '%}%' or  not mess  like '%-%' ) then 
    EXCEPTION UDF_TESTUNIT_EXP 'Ошибка GENGUID';
  resinfo = mess;suspend;
  resinfo='1. Тест пройден успешно!';SUSPEND; 
  -- ТЕСТ №1 КОНЕЦ --
  
  -- ТЕСТ №2 --    
  resinfo='2. Тест на получения GETNAMEPREP';SUSPEND;  
  if(GETNAMEPREP('test 1')<>'test' or GETNAMEPREP('яблоко груша')<>'яблоко ' 
     or GETNAMEPREP('')<>'') then    
    EXCEPTION UDF_TESTUNIT_EXP 'Ошибка GETNAMEPREP';
  resinfo='2. Тест пройден успешно!';SUSPEND; 
  -- ТЕСТ №2 КОНЕЦ --
  
END^

SET TERM ; ^/*{
    This file is part of the AF UDF library for Firebird 1.0 or high.
    Copyright (c) 2007-2009 by Arteev Alexei, OAO Pharmacy Tyumen.

    See the file COPYING.TXT, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    email: alarteev@yandex.ru, arteev@pharm-tmn.ru, support@pharm-tmn.ru
    web  : www.pharm-tmn.ru
    tel  : +7(3452)473130

 ***********************************************************************/

create or alter EXCEPTION UDF_TESTUNIT_EXP 'Исключение для тестов AFUDF';

SET TERM ^ ;

CREATE OR ALTER PROCEDURE UDF_TESTUNIT_TEXTFILE_1 
 ( sFolderTest varchar(255)) 
RETURNS 
 ( resinfo varchar(1024) )
AS 

 DECLARE VARIABLE FileName varchar(1024); 
 DECLARE VARIABLE messerr varchar(1024); 
 DECLARE VARIABLE obj integer; 
 DECLARE VARIABLE res integer; 
 DECLARE VARIABLE sOut VARCHAR(1024); 
 DECLARE VARIABLE i integer; 
 DECLARE VARIABLE k integer; 
 
BEGIN
  /*  Данная процедура является тестом для модуля afutextfile.
     Для проверки запустите  запрос:
       select * from UDF_TESTUNIT_TEXTFILE_1('/home/user/');
  */ 
  
  FileName = sFolderTest || 'myfile.txt';
   
   -- Создание объкта 
   obj = CreateTextFile(FileName);
   if (obj=0) then 
       EXCEPTION UDF_TESTUNIT_EXP;
    
  -- ТЕСТ №1 --
  resinfo='1. Тест на запись в файл';SUSPEND;
  resinfo='Дискриптор созданного файла'||FileName||' '||obj;SUSPEND;
  resinfo='Открываем файл на запись: - '||RewriteTextFile(obj);SUSPEND;  
  
  resinfo='Запись  возврата каретки:'||WRITETOTEXTFILE(Obj,'Тестовая строка1');SUSPEND;
   resinfo='Запись данных в файл';SUSPEND;
  k = 0;
  for 
    select RDB$PROCEDURE_NAME from RDB$PROCEDURES 
    order by 1
    into :sOut
  do
  BEGIN
    if (WRITELNTOTEXTFILE(Obj,:sOut)<>1) then 
       EXCEPTION UDF_TESTUNIT_EXP 'Тест 1. Запись строки';
    k = k + 1;
  end
  resinfo='Записано строк: '||k;SUSPEND;
  
  
  resinfo = 'Сбрасываем буфер в файл (FlushTextFile) - '||FlushTextFile(obj);SUSPEND; 
  resinfo = 'Закрываем файл - '||CloseTextFile(obj);SUSPEND; 
  resinfo = 'Освобождаем объект'||obj||'- '||FREEAFOBJECT(obj);SUSPEND; 
  resinfo='1. Тест пройден успешно!';SUSPEND; 
  -- ТЕСТ №1 КОНЕЦ --
  
  -- ТЕСТ №2 --
  -- Чтение из файла
   resinfo='1. Тест на чтение из файла';SUSPEND;
   -- Создание объкта 
   obj = CreateTextFile(FileName);
   if (obj=0) then 
       EXCEPTION UDF_TESTUNIT_EXP;
   resinfo='Дискриптор созданного файла'||FileName||' '||obj;SUSPEND;
   resinfo='Открываем файл на чтение: - '||RESETTEXTFILE(obj);SUSPEND; 
   i = 0;
   while (EOFTEXTFILE(obj)=0) do
   BEGIN
     sOut = READLNFROMTEXTFILE(obj);
     resinfo = 'Считанная строка #'||(i+1)||' : '||  sOut ;SUSPEND;
     i = i + 1;
   end   
   resinfo = 'Закрываем файл - '||CloseTextFile(obj);SUSPEND; 
   resinfo = 'Освобождаем объект'||obj||'- '||FREEAFOBJECT(obj);SUSPEND; 
   obj = 0;
   
   if (i<>k) then 
      EXCEPTION UDF_TESTUNIT_EXP 'Где то  ошибка при чтении или записи';   
   resinfo='2. Тест пройден успешно!';SUSPEND;     
  -- ТЕСТ №2 КОНЕЦ --
  
  -- ТЕСТ №3 --
  -- Проверка на  возврат значений из функции
  resinfo='3. Тест. Проверка на  возврат значений из функции'; suspend;
  
  
  obj = CreateTextFile('XY:/');
   if (obj=0) then 
       EXCEPTION UDF_TESTUNIT_EXP;
 
  res=RESETTEXTFILE(obj);  
  if (WasErrorObj(obj)<>1 or res<>0) then 
    EXCEPTION UDF_TESTUNIT_EXP 'не верный результат:  RESETTEXTFILE ';
  
  res=REWRITETEXTFILE(obj);
  if (WASERROROBJ(obj)<>1 or res<>0) then 
    EXCEPTION UDF_TESTUNIT_EXP 'не верный результат:  REWRITETEXTFILE1';
    
  res=WRITELNTOTEXTFILE(obj,'');
  if (WASERROROBJ(obj)<>1 or res<>0) then 
    EXCEPTION UDF_TESTUNIT_EXP 'не верный результат:  WRITELNTOTEXTFILE';    
  
  res=WRITETOTEXTFILE(obj,'');
  if (WASERROROBJ(obj)<>1 or res<>0) then 
    EXCEPTION UDF_TESTUNIT_EXP 'не верный результат:  WRITETOTEXTFILE';    
    
    sOut = READLNFROMTEXTFILE(obj);
    if (WASERROROBJ(obj)<>1 or sOut<>'')  then 
      EXCEPTION UDF_TESTUNIT_EXP 'не верный результат:  READLNFROMTEXTFILE';
  
  res=EOFTEXTFILE(obj);
  if (res=0) then 
     EXCEPTION UDF_TESTUNIT_EXP 'не верный результат:  EOFTEXTFILE' ;
  
  res=FlushTextFile(obj);
  if (WASERROROBJ(obj)<>1 or res<>0) then 
     EXCEPTION UDF_TESTUNIT_EXP 'не верный результат:  FlushTextFile';
          
   resinfo = 'Освобождаем объект'||obj||'- '||FREEAFOBJECT(obj);SUSPEND; 
   resinfo='3. Тест пройден успешно!';SUSPEND;        
   obj = 0;
  
  -- ТЕСТ №3 Конец--
  
  --  обработка ошибок
  WHEN EXCEPTION UDF_TESTUNIT_EXP DO
    BEGIN
      messerr = '';
      IF ((obj>0) AND (WasErrorIsExceptionObj(obj)=1)) THEN
        messerr=MsgLastErrorObj(obj);

      IF (obj>0) THEN res=FreeAFObject(obj);
      
      IF (messerr <>'') THEN
        EXCEPTION UDF_TESTUNIT_EXP '12'||messerr;
      ELSE
        EXCEPTION;
        
    END

    
END^

SET TERM ; ^
/*{
    This file is part of the AF UDF library for Firebird 1.0 or high.
    Copyright (c) 2007-2009 by Arteev Alexei, OAO Pharmacy Tyumen.

    See the file COPYING.TXT, included in this distribution,
    for details about the copyright.ss

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    email: alarteev@yandex.ru, arteev@pharm-tmn.ru, support@pharm-tmn.ru
    web  : www.pharm-tmn.ru
    tel  : +7(3452)473130

 ***********************************************************************/

create or alter EXCEPTION UDF_TESTUNIT_EXP 'Исключение для тестов AFUDF';

SET TERM ^ ;

create or alter procedure udf_testunit_check_exception(obj1 integer,tstfuncion varchar(100), mustexcept integer)
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

CREATE OR ALTER PROCEDURE UDF_TESTUNIT_XML_1 
(
  sFolderName varchar(255)
  )
 
RETURNS 
 ( resinfo varchar(1024) )
AS 

 
 DECLARE VARIABLE mess varchar(1024); 
 DECLARE VARIABLE res integer; 
 DECLARE VARIABLE obj integer; 
 DECLARE VARIABLE hRoot integer; 
 DECLARE VARIABLE hChild1 integer; 
 DECLARE VARIABLE hChild2 integer; 
 DECLARE VARIABLE hChild3 integer; 

  
  
  DECLARE VARIABLE bl blob SUB_TYPE 1;
  
  DECLARE VARIABLE FileName VARCHAR(2000) = 'xml_test1.xml';

BEGIN
  /*  Данная процедура является тестом для модуля afuzip
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
  
  if (XMLEncoding(obj,'windows-1251')<>1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLEncoding  должно быть 1';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLEncoding',0);
  
  if (XMLEncodingXML(obj,'windows-1251')<>1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLEncodingXML  должно быть 1';
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLEncodingXML',0);
    
      
  if (XMLGetEncodingXML(obj)<>'windows-1251') then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLGetEncodingXML  должно быть windows-1251';
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
  
  
  
    if (XmlNodeByIndex(obj,hRoot,0)<>hChild1) then 
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlNodeByIndex  должно быть '||hChild1 ;
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
  res = XMLENCODINGXML(obj,'UTF-8');
  if (XmlToFile(obj,sFolderName||FileName)<>1) then   
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XmlToFile  должно быть  1' || MSGLASTERROROBJ(obj);
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XmlToFile',0);    
  resinfo='4.Тест пройден успешно!';SUSPEND;       
  -- ТЕСТ №4 КОНЕЦ --
  
  
  
  res=FREEAFOBJECT(obj); obj = 0;
  
  
  
  
  -- ТЕСТ №5 --
  resinfo='5.Тест на  создание XML из разных источников!';SUSPEND; 
  obj = CreateXmlDocFromString('<?xml version="1.0" encoding="windows-1251" ?><root_tag id="test" name="isroot">'||
                                                '<child_tag name2="cool2">string 1</child_tag><child_tag2/><child_3>GHGПРЮВЕТ</child_3></root_tag>');

  if (obj=0) then   
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка CreateXmlDocFromString  должно быть  не 0' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'CreateXmlDocFromString',0);    
  
  res=XMLENCODING(obj,'windows-1251');
   resinfo=XMLGETENCODINGXML(obj);suspend;
   
   
    if (XMLGETENCODINGXML(obj)<>'windows-1251') then   
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLGETENCODINGXML  должно быть windows-1251  ' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLGETENCODINGXML',0); 
  
  bl = XMLTOBLOB(obj); -- кодировка 1251
  
  res=FREEAFOBJECT(obj); obj = 0;
  -- Создаем из блоба 
   
  obj = CreateXmlDocFromBlob(bl);
    if (obj=0) then   
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка CreateXmlDocFromBlob  должно быть  не 0' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'CreateXmlDocFromBlob',0);    
    if (XMLGETENCODINGXML(obj)<>'windows-1251') then   
     EXCEPTION UDF_TESTUNIT_EXP 'Ошибка XMLGETENCODINGXML  должно быть windows-1251  ' ;
  EXECUTE PROCEDURE udf_testunit_check_exception(:obj,'XMLGETENCODINGXML',0); 
    
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
  -- resinfo = XMLTOSTRING(obj);SUSPEND;    


  
  
  
  res=FREEAFOBJECT(obj);
  obj = 0;
  

  -- res = FSFileDelete(sFolderName||FileName);
  
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
/*{
    This file is part of the AF UDF library for Firebird 1.0 or high.
    Copyright (c) 2007-2009 by Arteev Alexei, OAO Pharmacy Tyumen.

    See the file COPYING.TXT, included in this distribution,
    for details about the copyright.ss

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    email: alarteev@yandex.ru, arteev@pharm-tmn.ru, support@pharm-tmn.ru
    web  : www.pharm-tmn.ru
    tel  : +7(3452)473130

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
 DECLARE VARIABLE obj integer; 

  
  
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
    begin 
         res=FREEAFOBJECT(obj);  
    end    
     exception;
   end
   
   

  
   
END^

SET TERM ; ^

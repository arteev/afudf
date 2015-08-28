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

create or alter PROCEDURE UDF_TESTUNIT_COMMON_1
RETURNS
 (resinfo varchar(1024) )
as
 DECLARE VARIABLE mess varchar(1024);
 DECLARE VARIABLE res integer;
 DECLARE VARIABLE obj bigint;
 DECLARE VARIABLE sEtalon varchar(200)  = 'String test!';
 DECLARE VARIABLE bl blob SUB_TYPE 1;
begin
  /*  Данная процедура является тестом для модуля afucrypt
     Для проверки запустите  запрос:
       select * from UDF_TESTUNIT_COMMON_1;
    тест успешен, если нет исключения
  */


  -- ТЕСТ №2--
  resinfo='2. Тест на обработки ошибок';SUSPEND;
  obj = CreateTextFile('VY://');
  resinfo='CreateTextFile Handle=' || obj;SUSPEND;

  -- попытка отрыть не сущ. файл
  res = ResetTextFile(obj);
  if (WasErrorObj(obj)<>1) then
    EXCEPTION UDF_TESTUNIT_EXP 'Не верно работает функция:WasErrorObj';

  if (WasErrorIsExceptionObj(obj)<>1) then
    EXCEPTION UDF_TESTUNIT_EXP 'Не верно работает функция:WasErrorIsExceptionObj';


  resinfo='Была ошибка: '||MsgLastErrorObj(obj);suspend;
  if (not (MsgLastErrorObj(obj) in ('File not found.', 'Unknow error code 123'))) then
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
    if (mess<>'linux-i386' and mess<>'linux-x86_64' and mess<>'win32'and mess<>'win64' ) then
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
  begin
     if (obj >0) then res= FREEAFOBJECT(obj);
     EXCEPTION;
  end
end^

SET TERM ; ^

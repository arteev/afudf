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

create or alter procedure UDF_TESTUNIT_TEXTFILE_1 (
    SFOLDERTEST varchar(255))
returns (
    RESINFO varchar(350))
as
declare variable FILENAME varchar(1024);
declare variable MESSERR varchar(1024);
declare variable OBJ bigint;
declare variable RES integer;
declare variable SOUT varchar(32000);
declare variable I integer;
declare variable K integer;
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

  res = RewriteTextFile(obj);
  if (res=0) then
    EXCEPTION UDF_TESTUNIT_EXP 'Не удалось открыть файл на запись ' || FileName;
  resinfo='Открытие файла на запись - OK';SUSPEND;


  res = WRITETOTEXTFILE(Obj,'Тестовая строка1');
  if (res=0) then
    EXCEPTION UDF_TESTUNIT_EXP 'Ошибка записи в ' || FileName;
  resinfo='Запись без возврата каретки - OK';SUSPEND;


   resinfo='Запись данных в файл';SUSPEND;
  k = 0;
  for
    select RDB$FUNCTION_NAME from RDB$FUNCTIONS
    order by 1
    into :sOut
  do
  BEGIN
    if (WRITELNTOTEXTFILE(Obj,:sOut)<>1) then
       EXCEPTION UDF_TESTUNIT_EXP 'Ошибка записи строки в файл '|| FileName;
    k = k + 1;
  end
  resinfo='Записано строк: '||k;SUSPEND;


  res = FlushTextFile(obj);
  if (res=0) then
    EXCEPTION UDF_TESTUNIT_EXP 'Не удалось FlushTextFile файл ' || FileName;
  resinfo = 'Сбрасываем буфер в файл (FlushTextFile) OK';SUSPEND;

  res = CloseTextFile(obj);
  if (res=0) then
    EXCEPTION UDF_TESTUNIT_EXP 'Не удалось закрыть файл ' || FileName;
  resinfo = 'Закрываем файл OK';SUSPEND;


  resinfo = 'Освобождаем объект'||obj||'- '||FREEAFOBJECT(obj);SUSPEND;
  resinfo='1. Тест пройден успешно!';SUSPEND;
  obj = 0;
  -- ТЕСТ №1 КОНЕЦ --

  -- ТЕСТ №1.1 КОНЕЦ --
  resinfo='1.1 Запись в конец файла';SUSPEND;
  obj = CreateTextFile(FileName);
   if (obj=0) then
       EXCEPTION UDF_TESTUNIT_EXP;
  res = AppendTextFile(obj);
  if (res=0) then
    EXCEPTION UDF_TESTUNIT_EXP 'Не удалось AppendTextFile открыть на запись в конец файла ' || FileName;
  resinfo='Открытие на запись в конец файла - OK';SUSPEND;
   k = k + 1;

  if (WRITELNTOTEXTFILE(Obj,'Дописано в конец файла')<>1) then
       EXCEPTION UDF_TESTUNIT_EXP 'Ошибка записи строки в файл '|| FileName;

  res = FlushTextFile(obj);
  res = CloseTextFile(obj);
  resinfo = 'Освобождаем объект'||obj||'- '||FREEAFOBJECT(obj);SUSPEND;
  resinfo='1.1 Тест пройден успешно!';SUSPEND;
  obj = 0;
  -- ТЕСТ №1.1 КОНЕЦ --

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

   resinfo = 'Закрываем файл';SUSPEND;
   resinfo = 'CloseTextFile = '||CloseTextFile(obj);SUSPEND;
   resinfo = 'Освобождаем объект'||obj||'- '||FREEAFOBJECT(obj);SUSPEND;
   obj = 0;



   if (i<>k) then
      resinfo = 'Где то  ошибка при чтении или записи, должно быть '||k||' строк, считано'||i;SUSPEND;

   if (i<>k) then
      EXCEPTION UDF_TESTUNIT_EXP 'Где то  ошибка при чтении или записи, должно быть '||k||' строк, считано'||i;

   resinfo='2. Тест пройден успешно!';SUSPEND;
  -- ТЕСТ №2 КОНЕЦ --

  -- 2.1 Types Read/Write
  resinfo='2.1 Запись типов';SUSPEND;
  obj = CreateTextFile(FileName);
   if (obj=0) then
       EXCEPTION UDF_TESTUNIT_EXP;
  res = REWRITETEXTFILE(obj);
  if (res=0) then
    EXCEPTION UDF_TESTUNIT_EXP 'Не удалось REWRITETEXTFILE открыть на запись ' || FileName;

  if (WriteCharToTextFile(Obj,'R')<>1) then
       EXCEPTION UDF_TESTUNIT_EXP 'Ошибка записи char в файл ';

  WriteLnToTextFile(obj,null);
  if (WriteInt32ToTextFile(Obj,1900011)<>1) then
            EXCEPTION UDF_TESTUNIT_EXP 'Ошибка записи Integer в файл ';

  WriteLnToTextFile(obj,null);
  if (WriteInt64ToTextFile(Obj,1000012030003100)<>1) then
                      EXCEPTION UDF_TESTUNIT_EXP 'Ошибка записи BigInt в файл ';

  CloseTextFile(obj);

  -- проверяем что записали
  obj = CreateTextFile(FileName);
   if (obj=0) then
       EXCEPTION UDF_TESTUNIT_EXP;
  res = ResetTextFile(obj);
  if (res=0) then
    EXCEPTION UDF_TESTUNIT_EXP 'Не удалось ResetTextFile открыть на чтение ' || FileName;

  sout=ReadCharFromTextFile(obj);
  if (sout<>'R') then
    EXCEPTION UDF_TESTUNIT_EXP 'Must be: R,'||sout;
  ReadLnFromTextFile(obj);
  sout=ReadInt32FromTextFile(obj);
  if (sout<>1900011) then
    EXCEPTION UDF_TESTUNIT_EXP 'Must be: 1900011,'||sout;

  ReadLnFromTextFile(obj);
  sout=ReadInt64FromTextFile(obj);
  if (sout<>1000012030003100) then
    EXCEPTION UDF_TESTUNIT_EXP 'Must be: 1000012030003100,'||sout;

  CloseTextFile(obj);
  resinfo = 'Освобождаем объект'||obj||'- '||FREEAFOBJECT(obj);SUSPEND;
  resinfo='Запись/чтение типов - OK';SUSPEND;
  --

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

  res=AppendTextFile(obj);
  if (WASERROROBJ(obj)<>1 or res<>0) then
     EXCEPTION UDF_TESTUNIT_EXP 'не верный результат:  AppendTextFile';

   resinfo = 'Освобождаем объект'||obj||'- '||FREEAFOBJECT(obj);SUSPEND;
   resinfo='3. Тест пройден успешно!';SUSPEND;
   obj = 0;

  -- ТЕСТ №3 Конец--

  --  обработка ошибок
  WHEN EXCEPTION UDF_TESTUNIT_EXP DO
    BEGIN
      messerr = '';
      IF ((obj>0) AND ((WasErrorIsExceptionObj(obj)=1) or WasErrorObj(obj)=1)) THEN
      begin
        messerr=MsgLastErrorObj(obj);
  resinfo = 'Ошибка: '||messerr;SUSPEND;
      end
      IF (obj>0) THEN begin
        closetextfile(obj);
        res=FreeAFObject(obj);
      end
      EXCEPTION;
    END


END^

SET TERM ; ^

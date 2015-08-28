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
 DECLARE VARIABLE obj BIGINT;



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

  res=SetFormatDBF(obj,3) ;


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

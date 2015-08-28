SET SQL DIALECT 3;

SET HEADING OFF;
SET LIST OFF;

CREATE DATABASE 'localhost:c:\temp\afudf_test.fdb'  user 'SYSDBA' password 'masterkey' page_size 8192  DEFAULT CHARACTER SET WIN1251;
commit;

CONNECT 'localhost:c:\temp\afudf_test.fdb' user 'SYSDBA' password 'masterkey';

-- Подключаем библиотеки
select 'sql afcommon' from RDB$DATABASE;
IN sql\reg\afcommon.sql;

select 'sql afudbf' from RDB$DATABASE;
IN sql\reg\afudbf.sql;

select 'sql afumisc' from RDB$DATABASE;
IN sql\reg\afumisc.sql;

select 'sql afuxml' from RDB$DATABASE;
IN sql\reg\afuxml.sql;

select 'sql afucrypt' from RDB$DATABASE;
IN sql\reg\afucrypt.sql;  

select 'sql afufile' from RDB$DATABASE;
IN sql\reg\afufile.sql;

select 'sql afutextfile' from RDB$DATABASE;
IN sql\reg\afutextfile.sql;

select 'sql afuzip' from RDB$DATABASE;
IN sql\reg\afuzip.sql;

commit;

-- Накатываем тесты

select 'Prepare test common' from RDB$DATABASE;
IN tests/p_common.sql;

select 'Prepare test textfile' from RDB$DATABASE;
IN tests/p_textfile.sql;

select 'Prepare test misc' from RDB$DATABASE;
IN tests/p_misc.sql;

select 'Prepare test crypt' from RDB$DATABASE;
IN tests/p_crypt.sql;

select 'Prepare test file' from RDB$DATABASE;
IN tests/p_file.sql;

select 'Prepare test dbf' from RDB$DATABASE;
IN tests/p_dbf.sql;

select 'Prepare test dbf' from RDB$DATABASE;
IN tests/p_zip.sql;

select 'Prepare test xml' from RDB$DATABASE;
IN tests/p_xml.sql;


-- Запуск тестов

-- тест модуля common
commit;

select 'Test common' from RDB$DATABASE;
select * from UDF_TESTUNIT_COMMON_1;
commit;

select 'Test textfile' from RDB$DATABASE;
select * from UDF_TESTUNIT_TEXTFILE_1('c:\temp\');
commit;

select 'Test misc' from RDB$DATABASE;
select * from UDF_TESTUNIT_MISC_1; 


select 'Test crypt' from RDB$DATABASE;
select * from UDF_TESTUNIT_CRYPT_1;

select 'Test file' from RDB$DATABASE;
select * from UDF_TESTUNIT_FILE_1('c:\temp\');


select 'Test DBF' from RDB$DATABASE;
select * from UDF_TESTUNIT_DBF_1('c:\temp\');


select 'Test Zip' from RDB$DATABASE;
select * from UDF_TESTUNIT_ZIP_1('c:\temp\');


select 'Test Xml' from RDB$DATABASE;
select * from UDF_TESTUNIT_XML_1('c:\temp\');

commit;
-- забыть про БД
CONNECT 'localhost:c:\temp\afudf_test.fdb' user 'SYSDBA' password 'masterkey';
--DROP DATABASE;

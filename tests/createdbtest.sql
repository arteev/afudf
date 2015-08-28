SET SQL DIALECT 3;

SET HEADING OFF;
SET LIST OFF;

CREATE DATABASE 'localhost:/tmp/firebird/afudf_test.fdb'  user 'SYSDBA' password 'masterkey' page_size 8192  DEFAULT CHARACTER SET WIN1251;
commit;

CONNECT 'localhost:/tmp/firebird/afudf_test.fdb' user 'SYSDBA' password 'masterkey';

-- Подключаем библиотеки
select 'sql afcommon-linux' from RDB$DATABASE;
IN sql/reg/afcommon.sql;

select 'sql afudbf-linux' from RDB$DATABASE;
IN sql/reg/afudbf.sql;

select 'sql afumisc-linux' from RDB$DATABASE;
IN sql/reg/afumisc.sql;

select 'sql afuxml-linux' from RDB$DATABASE;
IN sql/reg/afuxml.sql;

select 'sql afucrypt-linux' from RDB$DATABASE;
IN sql/reg/afucrypt.sql;  

select 'sql afufile-linux' from RDB$DATABASE;
IN sql/reg/afufile.sql;

select 'sql afutextfile-linux' from RDB$DATABASE;
IN sql/reg/afutextfile.sql;

select 'sql afuzip-linux' from RDB$DATABASE;
IN sql/reg/afuzip.sql;

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
select * from UDF_TESTUNIT_TEXTFILE_1('/tmp/firebird/');
commit;

select 'Test misc' from RDB$DATABASE;
select * from UDF_TESTUNIT_MISC_1; 


select 'Test crypt' from RDB$DATABASE;
select * from UDF_TESTUNIT_CRYPT_1;

select 'Test file' from RDB$DATABASE;
select * from UDF_TESTUNIT_FILE_1('/tmp/firebird/');


select 'Test DBF' from RDB$DATABASE;
select * from UDF_TESTUNIT_DBF_1('/tmp/firebird/');


select 'Test Zip' from RDB$DATABASE;
select * from UDF_TESTUNIT_ZIP_1('/tmp/firebird/');


select 'Test Xml' from RDB$DATABASE;
select * from UDF_TESTUNIT_XML_1('/tmp/firebird/');

commit;
-- забыть про БД
CONNECT 'localhost:/tmp/firebird/afudf_test.fdb' user 'SYSDBA' password 'masterkey';
--DROP DATABASE;

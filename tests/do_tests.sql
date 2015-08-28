-- тест модуля common
select * from UDF_TESTUNIT_COMMON_1;
commit;

-- модуль шифрования
select count(*) from UDF_TESTUNIT_CRYPT_1;
commit;

-- DBF
select * from UDF_TESTUNIT_DBF_1('/tmp/');
commit;

-- Работа с файлами
select * from UDF_TESTUNIT_FILE_1('/tmp/');
commit;

-- Прочее
select * from UDF_TESTUNIT_MISC_1;
commit;

-- Текстовые файлы
select * from UDF_TESTUNIT_TEXTFILE_1('/tmp/');
commit;

-- XML
select * from UDF_TESTUNIT_XML_1('/tmp/');
commit;

select * from UDF_TESTUNIT_ZIP_1('/tmp/');
commit;


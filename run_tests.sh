#!/bin/sh

/opt/firebird/bin/isql -u SYSDBA -p masterkey -s 3 -ch win1251 -q -i `pwd`/tests/do_tests.sql 127.0.0.1:`pwd`/tests/test_udf.fdb

#! /bin/sh
# This script converts all SQL files from UTF8 to windows-1251
# In the current directory and stores them in a folder win1251
#
	FldDest=./win1251
	if [ ! -e  $FldDest ]
	then
	  mkdir $FldDest
	fi
	for filename in *.sql
	do
           echo 'Converting:'$filename
           iconv -f UTF8 -t CP1251 $filename > $FldDest/$filename
	done

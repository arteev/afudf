#! /bin/sh
#  Arteev Alexei 1.04.2009
#  Скрипт обединяет все файлы SQL скриптов в один
#
#= main ======================
	
	if [ $# -eq 0 ] 
	then	  
	  fldest=p_all_test.sql
	  fldsrch=p_*.sql
	else	
	  
	  if [ ! -e $1 ] 
	  then
	    echo Directory no found:$1
	    exit 1;
	  fi
	  
	  fldest=$1p_all_test.sql
	  fldsrch=$1p_*.sql	  
	fi

	if [ -e  $fldest ]  
	then
	  rm -f $fldest
	fi	
	
	for filename in $fldsrch
	do           
	   if [ $filename != $fldest ] && [ $filename != "droptest.sql" ]
	   then	
	       cat $filename >> $fldest
	   fi
	done
	
	exit 0;

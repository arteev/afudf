#!/bin/sh

#######################################################################
#  версия 1.0 
#  от 07.04.2009
#  компиляция проекта lazarus/fpc с помощью утилиты lazbuid 
#  
#  Артеев Алексей 2009 г. ОАО Фармация
#  alarteev@yandex.ru, arteev@pharm-tmn.ru,support@pharm-tmn.ru
#
#######################################################################

  #laz_dir=/usr/bin
  targetos=linux
  ws=gtk2
  tcpu=i386
  compiler=/usr/bin/ppc
  
  
  if [ -z "$1" ] 
  then
    echo "Usage: `basename $0` project compiler [targetos [widgetset [cpu]]]"    
    exit 1
  fi
  
  echo "Compiling: $1"
  
  
  if [ -z "$2" ]
  then 
   echo "Compiler path is empty!"
   exit 1
  fi
  
  compiler=$2
  
  if [ ! -z "$3" ]
  then 
   targetos=$3  
  fi
  
  if [ ! -z "$4" ]
  then 
   ws=$4  
  fi
  
  if [ ! -z "$5" ]
  then 
   tcpu=$5
  fi
  
  
  #echo "$laz_dir/lazbuild -B --ws=$ws --os=$targetos --cpu=$tcpu --compiler=$compiler $1"
  lazbuild -B --ws=$ws --os=$targetos --cpu=$tcpu --compiler=$compiler $1 
	
  if [ "$?" -eq "0" ] 
  then
    echo "Compiling: `basename $1`. Done."
    exit 0
  else
    echo "Compiling: `basename $1`...failed!!!"
    exit 1
  fi
#!/bin/sh
#clean.sh
  
  filter="$1/*.compiled $1/*.o $1/*.a $1/*.ppu $1/*.res $1/*.or $1/*.~dpr $1/*.~dsk $1/*.bak $1/*.dcu $1/*.~pas $1/*.old $1/*.err"
  
  if [ -z "$1" ] 
  then
    echo "Usage: `basename $0` folder_clean"    
    exit 1
  fi
  
  if [ ! -d "$1" ] 
  then 
    echo "$1 is not directory"
    exit 1
  fi
  
  rm  -f $filter
  exit 0

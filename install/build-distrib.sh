#!/bin/bash

version=`cat version | grep version | cut -c9-`.`cat version | grep build | cut -c7-`
#`cat version | grep release | cut -c9-`


flddest=../output
product=af-udf
  
flddesthelp=$flddest/$product-$version/help
  
fldbin=../build
fldSQLReg=../sql/reg
  
fldSQL=../sql/reg
fldResource=../resource
fldHelp=../help
  
srcHelp=(authors.txt install.txt)
  
  
  
  
  platform=(linux-i386 linux-x86_64)
  
  cpu_target=(i386 x86_64)
  os_target=(linux linux)
  pl_bin_ext=(so so)
  pl_enc=(UTF-8 UTF-8)
  
  ppc=($FPCDIR/ppcross386 $FPCDIR/ppcx64)
      
  
  if [ ! -d $flddest ] 
  then
     mkdir $flddest > /dev/null
  fi
  
  
  if [ ! -d $flddest/$product-$version ] 
  then
    mkdir $flddest/$product-$version > /dev/null
  fi 
   
  if [ ! -d $flddesthelp ] 
  then
    mkdir $flddesthelp > /dev/null
  fi 
  
  
  
  #Manual
  echo -n Building archive with help files...
  for sHlp in "${srcHelp[@]}"
  do    
    zip -9 -j $flddesthelp/$product-$version-manual.zip $fldHelp/$sHlp > /dev/null       
  done
  echo done.
  #ENDManual

    
     
  iplat=0
  for curplat in "${platform[@]}"
   do             
     
     
     echo -n "Make  [$curplat]:  CPU:${cpu_target[iplat]} OS:${os_target[iplat]} " 
     
     make CPU_TARGET=${cpu_target[iplat]} OS_TARGET=${os_target[iplat]} --directory=`readlink -f ..`  PP=${ppc[iplat]}  all

     echo "OK!"
     
     echo -n "Building installer for platform: [$curplat]..."
     
     
     
     if [ ! -d $flddest/$product-$version/${platform[iplat]} ] 
     then
       mkdir $flddest/$product-$version/${platform[iplat]} > /dev/null
     fi
     

     dstzip=$flddest/$product-$version/${platform[iplat]}/$product-$version-${platform[iplat]}-bin.zip
     dstzipfull=$flddest/$product-$version/${platform[iplat]}/$product-$version-${platform[iplat]}.zip  
     
     dstsql=$flddest/$product-$version/${platform[iplat]}/$product-$version-${platform[iplat]}-sqlreg.zip
     
     #Просто ZIP c библиотеками      
     zip -9 -j $dstzip $fldbin/${platform[iplat]}/af*.${pl_bin_ext[iplat]} > /dev/null
     zip -9 -j $dstzipfull $fldbin/${platform[iplat]}/af*.${pl_bin_ext[iplat]} > /dev/null
    
     # цепляем iconv.dll
     if [ "${platform[iplat]}" == "win32-i386" ]
     then
       zip -9 -j $dstzip $fldResource/iconv.dll > /dev/null
       zip -9 -j $dstzipfull $fldResource/iconv.dll > /dev/null
     fi
     #Конец Просто ZIP c библиотеками
     
     
     #SQL Регистрации
     mkdir ./tmpsqlconv > /dev/null
     rm -f ./tmpsqlconv/*.* > /dev/null     
           
     # конвертация
     	for filename in $fldSQLReg/*.sql
	do           
	     iconv -f UTF-8 -t ${pl_enc[iplat]} $filename > ./tmpsqlconv/`basename $filename`
	done
	
	for filename in $fldSQLReg/cngmodname/*.sql
	do           	
	     iconv -f UTF-8 -t ${pl_enc[iplat]} $filename > ./tmpsqlconv/`basename $filename`
	done
	
	
     zip -9 -j $dstsql ./tmpsqlconv/*.sql > /dev/null
     zip -9 -j $dstzipfull ./tmpsqlconv/*.sql > /dev/null     
     
     
     
     
          
     rm -f ./tmpsqlconv/*.* > /dev/null
     rmdir ./tmpsqlconv > /dev/null     
     #END SQL Регистрации
     
     
     
     #мануал
     for sHlp in "${srcHelp[@]}"
     do
       zip -9 -j $dstzipfull $fldHelp/$sHlp > /dev/null   
     done
 
     let "iplat = $iplat + 1"
     echo done.
   done
   
   
   
   #rpm
   echo -n "Building rpm: "
   rpmbuild -bb afudf.spec --target i386 --quiet
   echo -n "Building rpm: "
   rpmbuild -bb afudf.spec --target x86_64 --quiet

   echo done.
#!/bin/sh
#
# Компиляция всех проектов

  cpl=0
  cplerr=0
  
  
  # Список проектов под пладформы linux, win32
  #
  src=(afmmngr afcommon afutextfile  afucrypt afufile afuzip afudbf afumisc afuxml)
  
  pathcompilers=/usr/bin/
  
  # Для фиксации ошибок
  platform=(linux386 linux64 win32)
  pl_error=(0 0 0);

fixed_err()
{  
  if [ $1 -eq 0 ]
     then      
       let "cpl = $cpl + 1"
      
     else
       let "cplerr = $cplerr + 1"       
       let "k = ${pl_error[$2]} + 1"
       pl_error[$2]=$k
  fi
}

# создаем папки 
mkdir build/linux-i386
mkdir build/linux-x86_64


# Compile for linux-x86_64    
   for s in "${src[@]}"
    do     
     ./make.linux.sh src/$s/$s.lpi $pathcompilers/ppcx64 linux gtk2 x86_64     
     fixed_err $? 0
   done   



# Compile for linux-i386  
   for s in "${src[@]}"
    do     
     ./make.linux.sh src/$s/$s.lpi $pathcompilers/ppc386 linux gtk2 i386     
     fixed_err $? 0
   done
     
exit 0
echo 
echo -----------------------------------------------
echo 

# Compile for win32-i386
   for s in "${src[@]}"
    do	     
     ./make.linux.sh src/$s/$s.lpi win32 win32 i386  
     fixed_err $? 1
   done


echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
echo "Result           : Count errors"
echo "Compilied normal : $cpl"
echo "Compilied error  : $cplerr"

 # Выводим информацию об ошибках по платформам
 echo -n "Platform Compiled errors..."
 iplat=0
 if [ ! $cplerr -eq 0 ] 
 then
   echo 
   for s in "${platform[@]}"
   do             
     echo -n "Platform: $s errors: "
     if [ ${pl_error[iplat]} -eq 0 ] 
     then 
       echo "no errors" 
     else 
       echo "${pl_error[iplat]}" 
     fi
 
     let "iplat = $iplat + 1"
   done
 else
   echo  "no errors."
 fi
 
 iplat=0
 for s in "${platform[@]}"
 do    
   echo -n "Clearing dest folder Build/$s..."  
   if [ ${pl_error[iplat]} -eq 0 ] 
   then     
     ./clean.sh Build/$s
      echo "done."
   else
     echo "skip, was error(s)"
   fi 
   let "iplat = $iplat + 1"
 done

if [ ! $cplerr -eq 0 ] 
then
  exit 1  
fi
@echo off
rem Build AFUDF for windows
rem v 1.0
rem set FPCDIR="c:\utils\lazarus1.4.x64\fpc\2.6.4"
rem set ISC=C:\Program Files (x86)\Inno Setup 5
rem
rem

set makesOk=Failed
set build32Ok=Failed
set build64Ok=Failed
set dist32=Failed
set dist64=Failed

set TARGETS=i386-win32,x86_64-win64

if "%FPCDIR%"=="" (
  echo Error: FPCDIR is not defined!
  goto end
)

if "%ISC%"=="" (
  echo "Error: ISC (Inno Setup Compiler) is not defined!"
  goto end
)
set FPCBIN=%FPCDIR%\bin\i386-win32
echo FPC: "%FPCDIR%"
echo FPC binary: %FPCBIN%
echo ISC: "%ISC%"

echo Generating Makefiles...
%FPCBIN%\fpcmake.exe -r -w -T%TARGETS%
set makes=%ERRORLEVEL%
if "%makes%" NEQ "0" (
  set makesOk=Failed
  goto error
) else (
  set makesOk=OK
)

echo Build x32
%FPCBIN%\make.exe OS_TARGET=win32 CPU_TARGET=i386 -B
set build32=%ERRORLEVEL%
if "%build32%" NEQ "0" (
  set build32Ok=Failed
  goto error
) else (
  set build32Ok=OK

  set platform=x32
  "%ISC%\ISCC.exe" install\afudf.iss
  if "%ERRORLEVEL%" NEQ "0" goto error
  set dist32=OK

)
echo Build x64
%FPCBIN%\make.exe OS_TARGET=win64 CPU_TARGET=x86_64 -B
set build64=%ERRORLEVEL%

if "%build64%" NEQ "0" (
  set build64Ok=Failed
  goto error
) else (
  set build64Ok=OK

  set platform=x64
  "%ISC%\ISCC.exe" install\afudf.iss
  if "%ERRORLEVEL%" NEQ "0" goto error
  set dist64=OK
)

goto end
:error
echo Error!

:end
echo -n
echo Results:
echo Makefiles     : [%makesOk%]
echo Build x32     : [%build32Ok%]
echo Build x64     : [%build64Ok%]
echo Installer x32 : [%dist32%]
echo Installer x64 : [%dist64%]

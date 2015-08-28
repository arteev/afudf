@ECHO OFF
FOR /F "delims='" %%F IN (%~dps0\..\src\common\verafudf.inc) DO set AFUDFVERSION=%%F

echo %AFUDFVERSION%
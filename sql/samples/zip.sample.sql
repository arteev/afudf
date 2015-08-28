create or alter procedure test (
    SFOLDERNAME varchar(255))
as
declare variable MESS varchar(1024);
declare variable RES integer;
declare variable OBJ bigint;
BEGIN
  obj = CreateZIP();
  if (obj=0) then
     EXCEPTION MYERROR 'ERROR CreateZIP';
  SetArhiveFileZIP(obj,'c:\somefile.zip');
  AddSpecZIP(obj,'c:\somefile.zip' );
  if (CompressZIP(obj)=0) then
    EXCEPTION MYERROR 'ERROR CompressZIP';
  FREEAFOBJECT(obj);
  obj = 0;
  WHEN ANY DO
  BEGIN
    if (obj>0) then
     res=FREEAFOBJECT(obj);
    exception;
  END
END

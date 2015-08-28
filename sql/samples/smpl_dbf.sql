-- for FireBird
CREATE OR ALTER EXCEPTION EXCEPTION_AFUDF 'EXCEPTION_AFUDF';

SET TERM ^ ;
ALTER PROCEDURE AFUDF_SAMPLE_DBF (
    SFOLDER Varchar(255) )
 RETURNS
 ( 
  resinfo varchar(1024)
 ) 
AS
DECLARE VARIABLE dbf  INTEGER; 
DECLARE VARIABLE sFileName varchar(255); 

DECLARE VARIABLE res INTEGER; 

BEGIN
  sFileName = SFOLDER || 'sample.dbf';
  /* создаем dbf */
  dbf=CreateDBF(sFileName,
                         1, --в кодировке ANSI, точнее кодировки БД 
                         1, -- режим чтения и записи
                         1, -- монопольный доступ
                         1  -- файл будет перезаписан
                         );  
  if (dbf=0) then 
    exception EXCEPTION_AFUDF 'Не могу создать объект DBF';
  res=SetFormatDBF(dbf,4); -- dBASE IV
  
  
  
  res=AddFieldDBF(dbf,'FUNCNAME','C',31,0);
  
       
  if (CreateTableDBF(obj) =0 ) then 
     EXCEPTION EXCEPTION_AFUDF 'Ошибка CreateTableDBF  создания DBF';
     
  -- Открываем DBF и в этот момент  таблица будет создана
  if (OPENDBF(dbf)=0) then 
    exception EXCEPTION_AFUDF 'Не могу открыть таблицу';
  
  
  res=CloseDBF(dbf);     
  
  resinfo = 'Создан файл:'||sFileName;
  suspend;
  when any do
  BEGIN
    -- подчищаем пямять
    if (dbf>0) then FREEAFOBJECT(dbf);
    EXCEPTION;    
  END
END^
SET TERM ; ^


GRANT EXECUTE
 ON PROCEDURE AFUDF_SAMPLE_DBF TO  SYSDBA;
 
 --execute PROCEDURE AFUDF_SAMPLE_DBF('/home/inferno/logs/');


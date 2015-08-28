
select FSFileExists('c:\Temp\file.txt'),
       FSFILETOBLOB('c:\Temp\file.txt') from rdb$database

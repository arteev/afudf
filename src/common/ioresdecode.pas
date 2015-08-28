unit ioresdecode;

{$mode objfpc}
{$H+}

interface

uses
  Classes, SysUtils;

function IOResultDecode(AIOResult:Word):string;

implementation

Type
  TIOResultValue = record
    code  : word;
    value : string;
  end;

const
  CountIOResultValue = 30;
var
  IOResultValueArray: array [0..CountIOResultValue-1] of TIOResultValue =
    (
      (code:0;value:'Success.'),
      (code:2;value:'File not found.'),
      (code:3;value:'Path not found.'),
      (code:4;value:'Too many open files.'),
      (code:5;value:'Access denied.'),
      (code:6;value:'Invalid file handle.'),
      (code:12;value:'Invalid file-access mode.'),
      (code:15;value:'Invalid disk number.'),
      (code:16;value:'Cannot remove current directory.'),
      (code:17;value:'Cannot rename across volumes.'),
      (code:100;value:'Error when reading from disk.'),
      (code:101;value:'Error when writing to disk.'),
      (code:102;value:'File not assigned.'),
      (code:103;value:'File not open.'),
      (code:104;value:'File not opened for input.'),
      (code:105;value:'File not opened for output.'),
      (code:106;value:'Invalid number.'),
      (code:150;value:'Disk is write protected.'),
      (code:151;value:'Unknown device.'),
      (code:152;value:'Drive not ready.'),
      (code:153;value:'Unknown command.'),
      (code:154;value:'CRC check failed.'),
      (code:155;value:'Invalid drive specified..'),
      (code:156;value:'Seek error on disk.'),
      (code:157;value:'Invalid media type.'),
      (code:158;value:'Sector not found.'),
      (code:159;value:'Printer out of paper.'),
      (code:160;value:'Error when writing to device.'),
      (code:161;value:'Error when reading from device.'),
      (code:162;value:'Hardware failure.')
    );



function IOResultDecode(AIOResult:Word):string;
var
  i: Integer;
begin
  for i:=0 to CountIOResultValue-1 do
    if IOResultValueArray[i].code = AIOResult then
      exit(IOResultValueArray[i].value);
  result := Format('Unknow error code %d',[AIOResult]);
end;

end.


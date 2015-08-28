CREATE EXCEPTION UDF_TESTUNIT_EXP '';

--Record the names of the procedures in the file
execute block (
    FILENAME varchar(255) = :file)
as
declare variable OBJ bigint;
declare variable SOUT varchar(255);
begin
  OBJ = CREATETEXTFILE(FILENAME);
  if (OBJ = 0) then
    exception UDF_TESTUNIT_EXP 'Failed create object textfile';
  if (REWRITETEXTFILE(OBJ) = 0) then
    exception UDF_TESTUNIT_EXP 'Could not open file for writing ' || FILENAME;
  for select RDB$FUNCTION_NAME
      from RDB$FUNCTIONS
      order by 1
      into :SOUT
  do
  begin
    if (WRITELNTOTEXTFILE(OBJ, :SOUT) <> 1) then
      exception UDF_TESTUNIT_EXP 'Error writing file string';
  end
  if (FLUSHTEXTFILE(OBJ) = 0) then
    exception UDF_TESTUNIT_EXP 'Failed FlushTextFile';
  if (CLOSETEXTFILE(OBJ) = 0) then
    exception UDF_TESTUNIT_EXP 'Failed to close the file ';

  if (FREEAFOBJECT(OBJ) = 0) then
    exception UDF_TESTUNIT_EXP 'Error release memory';
  OBJ = 0;

  when exception UDF_TESTUNIT_EXP do
  begin
    if ((OBJ > 0) and
        ((WASERRORISEXCEPTIONOBJ(OBJ) = 1) or WASERROROBJ(OBJ) = 1)) then
    begin
      CLOSETEXTFILE(OBJ);
      FREEAFOBJECT(OBJ);
      exception UDF_TESTUNIT_EXP MSGLASTERROROBJ(OBJ);
    end
    if (OBJ > 0) then
    begin
      CLOSETEXTFILE(OBJ);
      FREEAFOBJECT(OBJ);
    end
    exception;
  end
end

--Reading from a file
--CREATE EXCEPTION UDF_TESTUNIT_EXP '';
execute block (
    FILENAME varchar(255) = :file)
returns (
    RES varchar(255))
as
declare variable OBJ bigint;
declare variable SOUT varchar(255);
declare variable NTRUE integer = 1;
declare variable NFALSE integer = 0;
begin
  OBJ = CREATETEXTFILE(FILENAME);
  if (OBJ = 0) then
    exception UDF_TESTUNIT_EXP 'Failed create object textfile';
  if (RESETTEXTFILE(OBJ) = 0) then
    exception UDF_TESTUNIT_EXP 'Could not open file ' || FILENAME;

  while (EOFTEXTFILE(OBJ) <> NTRUE) do
  begin
    RES = READLNFROMTEXTFILE(OBJ);
    suspend;
  end

  if (CLOSETEXTFILE(OBJ) = 0) then
    exception UDF_TESTUNIT_EXP 'Failed to close the file ';

  if (FREEAFOBJECT(OBJ) = 0) then
    exception UDF_TESTUNIT_EXP 'Error release memory';
  OBJ = 0;

  when exception UDF_TESTUNIT_EXP do
  begin
    if ((OBJ > 0) and
        ((WASERRORISEXCEPTIONOBJ(OBJ) = 1) or WASERROROBJ(OBJ) = 1)) then
    begin
      CLOSETEXTFILE(OBJ);
      FREEAFOBJECT(OBJ);
      exception UDF_TESTUNIT_EXP MSGLASTERROROBJ(OBJ);
    end
    if (OBJ > 0) then
    begin
      CLOSETEXTFILE(OBJ);
      FREEAFOBJECT(OBJ);
    end
    exception;
  end
end

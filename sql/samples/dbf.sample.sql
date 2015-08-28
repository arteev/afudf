
create or alter procedure test
as
declare variable HDBF integer;
declare variable RESOPER integer;
declare variable PARTYRN numeric(17,0);
declare variable PREPR_NAME varchar(321);
declare variable path varchar(1024);
declare variable DATE_INT date;
begin
  /* PARTY_RN|FULLNAME|DATEDOC */
   path='e:\sample.dbf';
   hDBF = createdbf(path,0,1,0,0);
   if (hDBF=0) then
   begin
     // error
     exit;
   end
   resoper = FirstInDBF(HDBF);
   resoper = OpenDBF(HDBF);
   while (EOFINDBF(HDBF) <> 1) do
   begin
     partyrn = GetValueDBFFieldByName(hDBF,'PARTY_RN');
     prepr_name = GetValueDBFFieldByName(hDBF,'FULLNAME');
     date_int = GetValueDBFFieldByName(hDBF,'DATEDOC');
     insert into
       sampletable(rn_party,prep_name,date_int)
     values
       (:partyrn,:prepr_name,:date_int);
     resoper = NEXTINDBF(HDBF);
   end
     closedbf(hDBF);
     FreeAFObject(hDBF);
     hDBF = 0 ;
  when ANY DO
  begin
      if (hDBF>0) then
         FreeAFObject(hDBF);
      EXCEPTION;
  end
end

 select GENGUID() from rdb$database
 -- this is equal  select  '{'||uuid_to_char(GEN_UUID ())||'}' from rdb$database

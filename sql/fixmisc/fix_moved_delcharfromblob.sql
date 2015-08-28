-- отдать в патч АФ
update rdb$functions f set f.rdb$module_name='afumisc' where  f.rdb$function_name='DELCHARSFROMBLOB';
commit;

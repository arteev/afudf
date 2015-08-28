/*
Attention!!!
This query changes the type of BigInt input and output parameters for the UDF to Integer Conformity Dialect 1.
This method can be used for FireBird, 32 bit version.
Caution !!! Do not use if there is a request depending on the updated UDF.

Внимание!!!
Этот запрос изменяет тип BigInt входных и выходных параметров UDF на Integer для соотвествия Dialect 1.
Данный способ можно использовать на FireBird 32-битной версии.
Осторожно!!! Не используйте запрос, если есть зависимости от обновляемых UDF.

*/

update
 rdb$function_arguments ar
set
 ar.rdb$field_type=8
where
     ar.rdb$field_type=16
     and exists(select 1 from rdb$functions f where
                 ar.rdb$function_name = f.rdb$function_name
                  and f.rdb$module_name like '%af%');
commit;                  

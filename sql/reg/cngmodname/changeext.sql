
/*{
    This file is part of the AF UDF library for Firebird 1.0 or high.
    Copyright (c) 2007-2014 by Arteev Aleksey, OAO Pharmacy Tyumen.

    See the file COPYING.TXT, included in this distribution,
    for details about the copyright.ss

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    email: arteev@pharm-tmn.ru, support@pharm-tmn.ru

 ***********************************************************************/

update  RDB$FUNCTIONS f 
set f.RDB$MODULE_NAME = 'afcommon'
where f.RDB$MODULE_NAME like '%afcommon%';

update  RDB$FUNCTIONS f
set f.RDB$MODULE_NAME = 'afucrypt'
where f.RDB$MODULE_NAME like '%afucrypt%';

update  RDB$FUNCTIONS f
set f.RDB$MODULE_NAME = 'afudbf'
where f.RDB$MODULE_NAME like '%afudbf%';

update  RDB$FUNCTIONS f
set f.RDB$MODULE_NAME = 'afufile'
where f.RDB$MODULE_NAME like '%afufile%';

update  RDB$FUNCTIONS f
set f.RDB$MODULE_NAME = 'afutextfile'
where f.RDB$MODULE_NAME like '%afutextfile%';

update  RDB$FUNCTIONS f
set f.RDB$MODULE_NAME = 'afuxml'
where f.RDB$MODULE_NAME like '%afuxml%';

update  RDB$FUNCTIONS f
set f.RDB$MODULE_NAME = 'afuzip'
where f.RDB$MODULE_NAME like '%afuzip%';

update  RDB$FUNCTIONS f
set f.RDB$MODULE_NAME = 'afumisc'
where f.RDB$MODULE_NAME like '%afumisc%';

commit;

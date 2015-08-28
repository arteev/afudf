select cryptcrc32('Hello world!'),
       cryptmd5('Hello world!'),
       cryptsha1string('Hello world!')
 from rdb$database
 --Result : 1B851995	86fb269d190d2c85f6e0468ceca42a20	d3486ae9136e7856bc42212385ea797094475802

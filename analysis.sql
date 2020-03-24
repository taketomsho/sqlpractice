/*
list.csv作成後流すSQL
300000Byte以上のファイル一覧、
フォルダごとの容量一覧を出力する
*/
drop table if exists filelist;
drop view if exists foldersizes;
.mode csv
.import ./list.csv filelist
create view foldersizes as
with directories as (
    select distinct directory from filelist
)
select 
directories.directory
,sum(filelist.length) foldersize
from directories
left join filelist
on filelist.directory like (directories.directory || '%')
group by directories.directory
;
.headers on
.output ./largefiles.csv
select * from filelist where length > 3000;
.output ./foldersizes.csv
select * from foldersizes where foldersize > 300000 and directory like '%k%';
.exit

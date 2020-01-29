SELECT A.id AS id, A.name, B.name
  FROM Class_A A LEFT OUTER JOIN Class_B B
    ON A.id = B.id
UNION
SELECT B.id AS id, A.name, B.name
  FROM Class_B B left OUTER JOIN Class_A A
    ON A.id = B.id;
create table zenkai (id num,name num);
create table saishin (id num,name num);

INSERT into zenkai
WITH RECURSIVE seq(i,j) AS (
    SELECT 2,3
    UNION ALL
    SELECT i + 2,j + 3 FROM seq WHERE i < 10000000
)
SELECT * FROM seq;

INSERT into saishin
WITH RECURSIVE seq(i,j) AS (
    SELECT 2,3
    UNION ALL
    SELECT i + 3,j + 4 FROM seq WHERE i < 10000000
)
SELECT * FROM seq;

create table kekka (zid num,zname num,sid num,sname num);

--kekkaテーブルにleft joinの結果を挿入：
--Run Time: real 9.940 user 8.296875 sys 1.437500
insert into kekka
select zenkai.id,zenkai.name,saishin.name
from zenkai left join saishin
on zenkai.id = saishin.id;

--kekkaテーブルにinner joinの結果を挿入：
--Run Time: real 7.724 user 6.968750 sys 0.656250
insert into kekka
select zenkai.id,zenkai.name,saishin.id,saishin.name
from zenkai inner join saishin
on zenkai.id = saishin.id;

--kekkaテーブルにleft join + unionの結果を挿入：
--Run Time: real 28.371 user 25.109375 sys 2.921875
insert into kekka
select zenkai.id,zenkai.name,saishin.name
from zenkai left join saishin
on zenkai.id = saishin.id
union
select saishin.id,zenkai.name,saishin.name
from  saishin left join zenkai 
on zenkai.id = saishin.id;

--kekkaテーブルにleft join + union all + left join の結果を挿入：
--Run Time: real 28.371 user 25.109375 sys 2.921875
insert into kekka
select zenkai.id id,zenkai.name,saishin.name
from zenkai left join saishin
on zenkai.id = saishin.id
union all
select saishin.id id,zenkai.name,saishin.name
from  saishin left join zenkai 
on zenkai.id = saishin.id
where zenkai.id is null
order by id;


delete from kekka;

create table kekka (id num,zname num,sname num);

alter table kekka drop column sid;


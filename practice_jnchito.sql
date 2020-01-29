/*
https://qiita.com/jnchito/items/29e22cc5a73da29f65a3

# 現在の部署に所属する社員の一覧を取得するSQLを書いて下さい

## 要件
- 社員と所属履歴という二つのモデルがある。
- 社員は1件以上の所属履歴を持つ。
- 所属履歴にはその社員がこれまでに所属してきた部署の履歴が保存される。
- 所属履歴には開始日が設定されている。
- 所属履歴が複数ある場合、開始日が最新の履歴が現在の部署を表す。 
- **現在IT部門に所属している社員の一覧を取得するにはどうすれば良いか。**

## 期待する出力結果
| employee_id | name | section_name | start_date |
| :---------- | :--- | :----------- | :--------- |
| 1           | John | IT           | 2014/01/01 |
| 3           | Tom  | IT           | 2013/01/01 |
*/
-- SCHEMA
CREATE TABLE employees (
  id integer PRIMARY KEY
  ,name varchar(50)
);

INSERT INTO employees VALUES (1,'John');
INSERT INTO employees VALUES (2,'Mary');
INSERT INTO employees VALUES (3,'Tom');

CREATE TABLE section_histories (
  id integer PRIMARY KEY
  ,employee_id integer
  ,start_date date
  ,section_name varchar(50)
);

INSERT INTO section_histories VALUES (1,1,'2013/01/01', 'Sales');
INSERT INTO section_histories VALUES (2,2,'2013/01/01', 'IT');
INSERT INTO section_histories VALUES (3,3,'2013/01/01', 'IT');
INSERT INTO section_histories VALUES (4,1,'2014/01/01', 'IT');
INSERT INTO section_histories VALUES (5,2,'2014/01/01', 'Sales');

--answer
--相関サブクエリを使用
select
a.employee_id
,employees.name
,a.section_name
,a.start_date
from section_histories a
left outer join employees
on employees.id = a.employee_id
where a.start_date = 
(
  select max(b.start_date)
  from section_histories b
  where b.employee_id = a.employee_id
)
and a.section_name = 'IT'
; 

--Window関数を使用
with a as(
  select employee_id
  ,section_name
  ,start_date
  ,rank() over(
    partition by employee_id 
    order by start_date 
    desc) as ranking
  from section_histories
)
select a.employee_id
,employees.name
,a.section_name
,a.start_date
from a
left outer join employees
on employees.id = a.employee_id
where ranking = 1
and section_name = 'IT'
;

/*
https://qiita.com/jnchito/items/1d21fa3970b3c76bee43
# 入会者数と退会者数を日付ごとに集計するSQLを書いてください
##要件
- ユーザーテーブル(users)は入会日(joined_on)と退会日(left_on)を持っている
- 退会していないユーザーの場合、退会日にはNULLが入る
- **ユーザー数の増減を確認するために、日付単位で入会したユーザーの人数と退会したユーザーの人数を一覧化したい。どうすれば取得できるか？**

## 期待する出力結果
| date       | joined_count | left_count |
| :--------- | -----------: | ---------: |
| 2014-08-01 |            2 |          0 |
| 2014-08-03 |            2 |          0 |
| 2014-08-05 |            0 |          1 |
| 2014-08-10 |            1 |          2 |
*/
--SCHEMA
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  joined_on DATE NOT NULL,
  left_on DATE NULL
);

INSERT INTO users VALUES (1, '2014-08-01', '2014-08-10');
INSERT INTO users VALUES (2, '2014-08-01', '2014-08-05');
INSERT INTO users VALUES (3, '2014-08-03', NULL);
INSERT INTO users VALUES (4, '2014-08-03', '2014-08-10');
INSERT INTO users VALUES (5, '2014-08-10', NULL);

--ANSWER

/*
https://qiita.com/jnchito/items/7d5d7e829690ea3c4d6f
# 締め切り日が近いイベントの一覧の取得するSQLを書いて下さい
## 要件
- イベントとスケジュールという二つのモデル(テーブル)がある。
- イベントは複数のスケジュールを持つことができる。
- スケジュールを一件も持たないイベントもある（スケジュール未定のイベント）。
- スケジュールには締め切り日が設定されている。
 - イベント単位で同じ締め切り日は複数存在しないものとする。
- 次のような条件でイベントとスケジュールの一覧を出したい。
 - システム日付以降に締め切り日がある、またはスケジュール未定のイベントのみを表示する。
 - スケジュールが複数あるイベントはシステム日付に最も近い締め切り日のスケジュールのみを表示する。
 - 締め切り日順に並び替える（締め切り日が近いほど上）。ただしスケジュール未定であれば一番下に表示する。
 - 締め切り日が同じであればイベントID順に並び替える（IDが小さいものほど上）。

## 期待する出力結果
| event_id | name              | schedule_id | due_date   |
| :------- | :---------------- | :---------- | :--------- |
| 4        | Future event 1    | 5           | 2014/01/24 |
| 5        | Future event 2    | 7           | 2014/01/24 |
| 3        | Continuing event  | 3           | 2014/02/01 |
| 2        | No schedule event |             |            |
*/
--SCHEMA
CREATE TABLE events (
  id integer PRIMARY KEY
  ,name varchar(50)
);

INSERT INTO events VALUES (1,'Completed event');
INSERT INTO events VALUES (2,'No schedule event');
INSERT INTO events VALUES (3,'Continuing event');
INSERT INTO events VALUES (4,'Future event 1');
INSERT INTO events VALUES (5,'Future event 2');

CREATE TABLE schedules (
  id integer PRIMARY KEY
  ,event_id integer
  ,due_date date
);

INSERT INTO schedules VALUES (1,1,'2014/01/23');
INSERT INTO schedules VALUES (2,3,'2014/01/01');
INSERT INTO schedules VALUES (3,3,'2014/02/01');
INSERT INTO schedules VALUES (4,3,'2014/03/01');
INSERT INTO schedules VALUES (5,4,'2014/01/24');
INSERT INTO schedules VALUES (6,4,'2014/01/25');
INSERT INTO schedules VALUES (7,5,'2014/01/24');

CREATE TABLE sysdate_dummy (
  id integer PRIMARY KEY
  ,sysdate date
);

INSERT INTO sysdate_dummy VALUES (1,'2014/01/24');



Create table If Not Exists Logs (id int, num int);
Truncate table Logs;
insert into Logs (id, num) values ('1', '1');
insert into Logs (id, num) values ('2', '1');
insert into Logs (id, num) values ('3', '1');
insert into Logs (id, num) values ('4', '2');
insert into Logs (id, num) values ('5', '1');
insert into Logs (id, num) values ('6', '2');
insert into Logs (id, num) values ('7', '2');


select * from logs l ;


select id, num, row_number () over(order by id), row_number () over(partition by num order by id) 
from logs l ;


WITH grps AS (
  SELECT
    Num,
    ROW_NUMBER() OVER (
      ORDER BY
        Id
    ) - ROW_NUMBER() OVER (
      PARTITION BY Num
      ORDER BY
        Id
    ) AS grp
  FROM
    Logs
)
SELECT
  DISTINCT Num AS ConsecutiveNums
FROM
  grps
GROUP BY
  grp,
  Num
HAVING
  COUNT(grp) >= 3
ORDER BY
  Num;
  
 
 
 with cte as (
	 select 
	 	num,
	 	id - row_number() over(partition by num order by id) gcn
	from logs l
 )
 select distinct num AS ConsecutiveNums
 from cte
 group by num, gcn
 having count(gcn) >= 3;
 
 
 
 
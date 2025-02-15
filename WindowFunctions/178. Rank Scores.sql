Create table If Not Exists Scores (id int, score DECIMAL(3,2));
Truncate table Scores;
insert into Scores (id, score) values ('1', '3.5');
insert into Scores (id, score) values ('2', '3.65');
insert into Scores (id, score) values ('3', '4.0');
insert into Scores (id, score) values ('4', '3.85');
insert into Scores (id, score) values ('5', '4.0');
insert into Scores (id, score) values ('6', '3.65');


select 
	score,
	dense_rank () over( order by score desc) as rank
from scores
;


select *
from scores s1
join scores s2
on s1.score <= s2.score ;

SELECT s1.score, 
       COUNT(DISTINCT s2.score) AS rank
FROM Scores s1
JOIN Scores s2 
    ON s1.score <= s2.score
GROUP BY s1.score
ORDER BY s1.score DESC;


SELECT s1.score, 
       (SELECT COUNT(DISTINCT s2.score) 
        FROM Scores s2 
        WHERE s2.score >= s1.score) AS rank
FROM Scores s1
ORDER BY s1.score DESC;
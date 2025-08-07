DROP TABLE IF EXISTS Logs;
CREATE TABLE Logs (
    Id INT PRIMARY KEY,
    Num INT
);
INSERT INTO Logs (Id, Num) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 1),
(6, 2),
(7, 2);

SELECT * FROM logs;


WITH cte AS (
	SELECT
		num,
		LAG (num, 1) over(ORDER BY id ASC) AS prev,
		LEAD (num, 1) over(ORDER BY id ASC) next
	FROM 
		logs
)
SELECT DISTINCT num ConsecutiveNums
FROM cte
WHERE num = prev AND num = next;

SELECT DISTINCT 
	curr.num ConsecutiveNums
FROM
	logs curr
JOIN logs next ON next.id - curr.id = 1 
JOIN logs prev ON curr.id - prev.id  = 1
WHERE 
	curr.num = prev.num AND curr.num = next.num;
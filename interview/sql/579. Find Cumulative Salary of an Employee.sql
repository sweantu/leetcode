DROP TABLE IF EXISTS Employee;

CREATE TABLE Employee (
    id INT NOT NULL,
    month INT NOT NULL,
    salary INT NOT NULL,
    PRIMARY KEY (id, month)
);

-- Insert sample data
INSERT INTO Employee (id, month, salary) VALUES
(1, 1, 20),
(2, 1, 20),
(1, 2, 30),
(2, 2, 30),
(3, 2, 40),
(1, 3, 40),
(3, 3, 60),
(1, 4, 60),
(3, 4, 70),
(1, 7, 90),
(1, 8, 90);

SELECT * FROM employee e ;





WITH cumulative_salary AS (
	SELECT 
		e1.id,
		e1.MONTH,
		(e1.salary + COALESCE(e2.salary, 0) + COALESCE (e3.salary , 0)) AS salary,
		ROW_NUMBER() OVER (PARTITION BY e1.id ORDER BY e1.MONTH desc) as rn
	FROM 
		employee e1
		LEFT JOIN employee e2 ON e1.id = e2.id AND e1.MONTH = e2.MONTH + 1 
		LEFT JOIN employee e3 ON e1.id = e3.id AND e1.month = e3.MONTH + 2 
) 
SELECT 
	id,
	MONTH,
	salary
FROM cumulative_salary
WHERE
	rn != 1
ORDER BY
	id ASC,
	MONTH DESC;
	

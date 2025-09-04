-- Drop tables in correct order (child first due to FK constraints)
DROP TABLE IF EXISTS Salary;
DROP TABLE IF EXISTS Employee;

-- Employee table (parent)
CREATE TABLE Employee (
    employee_id   INT PRIMARY KEY,
    department_id INT NOT NULL
);

-- Salary table (child)
CREATE TABLE Salary (
    id           INT PRIMARY KEY,
    employee_id  INT NOT NULL,
    amount       INT NOT NULL,
    pay_date     DATE NOT NULL,
    CONSTRAINT fk_employee
        FOREIGN KEY (employee_id) 
        REFERENCES Employee(employee_id)
        ON DELETE CASCADE
);

-- Optional: Insert sample data
INSERT INTO Employee (employee_id, department_id) VALUES
(1, 1),
(2, 2),
(3, 2);

INSERT INTO Salary (id, employee_id, amount, pay_date) VALUES
(1, 1, 9000, '2017-03-31'),
(2, 2, 6000, '2017-03-31'),
(3, 3, 10000, '2017-03-31'),
(4, 1, 7000, '2017-02-28'),
(5, 2, 6000, '2017-02-28'),
(6, 3, 8000, '2017-02-28');


SELECT * FROM employee e ;
SELECT * FROM salary;

WITH avg_salary_company as (
	SELECT 
		to_char(s.pay_date, 'YYYY-MM') AS pay_month,
		AVG(s.amount) AS avg_salary
	FROM
		salary s
	GROUP BY pay_month
)
, avg_salary_department AS (
	SELECT 
		to_char(s.pay_date, 'YYYY-MM') AS pay_month,
		e.department_id,
		AVG(s.amount) AS avg_salary
	FROM
		salary s
		JOIN employee e ON s.employee_id = e.employee_id
	GROUP BY pay_month, department_id
)
SELECT 
	ad.pay_month,
	ad.department_id,
	CASE 
		WHEN ad.avg_salary > ac.avg_salary THEN 'higher'
		WHEN ad.avg_salary < ac.avg_salary THEN 'lower'
		ELSE 'same'
	END AS comparison
FROM avg_salary_company ac
	JOIN avg_salary_department ad ON ac.pay_month = ad.pay_month;



	


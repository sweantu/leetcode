-- Drop existing tables in the correct order to avoid foreign key errors
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Department;

-- Create Department table
CREATE TABLE Department (
    id   INT PRIMARY KEY,
    name VARCHAR NOT NULL
);

-- Create Employee table
CREATE TABLE Employee (
    id           INT PRIMARY KEY,
    name         VARCHAR,
    salary       INT,
    departmentId INT,
    CONSTRAINT fk_department
        FOREIGN KEY (departmentId)
        REFERENCES Department(id)
        ON DELETE SET NULL
);

-- Insert Department data
INSERT INTO Department (id, name) VALUES
(1, 'IT'),
(2, 'Sales');

-- Insert Employee data
INSERT INTO Employee (id, name, salary, departmentId) VALUES
(1, 'Joe',   70000, 1),
(2, 'Jim',   90000, 1),
(3, 'Henry', 80000, 2),
(4, 'Sam',   60000, 2),
(5, 'Max',   90000, 1);

SELECT * FROM department d ;

SELECT * FROM employee e ;

WITH ranked_employee AS (
	SELECT
		name,
		salary,
		departmentid,
		RANK() OVER (PARTITION BY departmentid ORDER BY salary DESC) rk
	FROM
		employee
)
SELECT 
	d.name department,
	e.name employee,
	e.salary salary
FROM
	ranked_employee e
	JOIN department d ON d.id = e.departmentid
WHERE
	e.rk = 1;
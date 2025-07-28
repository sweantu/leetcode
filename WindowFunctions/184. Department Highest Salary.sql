Create table If Not Exists Employee (id int, name varchar(255), salary int, departmentId int);
Create table If Not Exists Department (id int, name varchar(255));
Truncate table Employee;
insert into Employee (id, name, salary, departmentId) values ('1', 'Joe', '70000', '1');
insert into Employee (id, name, salary, departmentId) values ('2', 'Jim', '90000', '1');
insert into Employee (id, name, salary, departmentId) values ('3', 'Henry', '80000', '2');
insert into Employee (id, name, salary, departmentId) values ('4', 'Sam', '60000', '2');
insert into Employee (id, name, salary, departmentId) values ('5', 'Max', '90000', '1');
Truncate table Department;
insert into Department (id, name) values ('1', 'IT');
insert into Department (id, name) values ('2', 'Sales');


select 
	e.id ,
	e."name" ,
	e.salary ,
	e.departmentid ,
	dense_rank () over(partition by departmentid order by salary desc) as salary_rank
from employee e ;


WITH ranked_salary_employees AS (
    SELECT 
        e.name AS employee,
        e.salary,
        e.departmentId,
        DENSE_RANK() OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC) AS salary_rank
    FROM employee e
)
SELECT 
    d.name AS department, 
    rse.employee, 
    rse.salary
FROM ranked_salary_employees rse
JOIN department d 
    ON rse.departmentId = d.id
WHERE rse.salary_rank = 1;


select 
	e.id,
	e.name,
	e.salary,
	temp.departmentid,
	temp.max_salary,
	temp.name
from employee e
join (
	select e.departmentid , max(e.salary) as max_salary, d.name
	from employee e
	join department d on e.departmentid = d.id
	group by departmentid, d.name
) temp
on e.departmentid = temp.departmentid
where e.salary = temp.max_salary;


-- Write your PostgreSQL query statement below
select 
    temp.name as department,
	e.name as employee,
	e.salary
from employee e
join (
	select e.departmentid , max(e.salary) as max_salary, d.name
	from employee e
	join department d on e.departmentid = d.id
	group by departmentid, d.name
) temp
on e.departmentid = temp.departmentid
where e.salary = temp.max_salary;



SELECT d.name AS department, e.name AS employee, e.salary
FROM employee e
JOIN department d ON e.departmentId = d.id
WHERE e.salary = (
    SELECT MAX(salary) 
    FROM employee 
    WHERE departmentId = e.departmentId
);

SELECT * FROM employee e ;

WITH rank_salary AS (
	SELECT 
		*,
		RANK() OVER (PARTITION BY departmentid ORDER BY salary DESC) AS rk
	FROM 
		employee
)
SELECT
	d.name AS Department,
	r.name AS Employee,
	r.salary AS Salary
FROM
	rank_salary r
	JOIN department d ON r.departmentid = d.id
WHERE
	r.rk = 1
;
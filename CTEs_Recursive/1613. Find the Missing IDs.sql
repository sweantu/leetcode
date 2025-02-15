/*
1613. Find the Missing IDs
SQL Schema 
Table: Customers

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| customer_name | varchar |
+---------------+---------+
customer_id is the primary key for this table.
Each row of this table contains the name and the id customer.
 

Write an SQL query to find the missing customer IDs. The missing IDs are ones that are not in the Customers table but are in the range between 1 and the maximum customer_id present in the table.

Notice that the maximum customer_id will not exceed 100.

Return the result table ordered by ids in ascending order.

The query result format is in the following example.

 

Customer table:
+-------------+---------------+
| customer_id | customer_name |
+-------------+---------------+
| 1           | Alice         |
| 4           | Bob           |
| 5           | Charlie       |
+-------------+---------------+

Result table:
+-----+
| ids |
+-----+
| 2   |
| 3   |
+-----+
The maximum customer_id present in the table is 5, so in the range [1,5], IDs 2 and 3 are missing from the table.
Difficulty:
Medium
Lock:
Prime

*/

-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255)
);

-- Insert sample data
INSERT INTO Customers (customer_id, customer_name) VALUES
(1, 'Alice'),
(4, 'Bob'),
(5, 'Charlie'),
(8, 'Sweantu');


select * from customers c ;

WITH RECURSIVE numbers AS (
    -- Generate numbers starting from 1
    SELECT 1 AS id
    UNION ALL
    -- Recursively generate numbers up to the max customer_id
    SELECT id + 1 FROM numbers WHERE id < (SELECT MAX(customer_id) FROM Customers)
)
SELECT id AS ids
FROM numbers
WHERE id NOT IN (SELECT customer_id FROM Customers);

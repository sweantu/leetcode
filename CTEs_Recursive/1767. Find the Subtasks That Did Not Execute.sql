/*
1767. Find the Subtasks That Did Not Execute
SQL Schema
Table: Tasks

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| task_id        | int     |
| subtasks_count | int     |
+----------------+---------+
task_id is the primary key for this table.
Each row in this table indicates that task_id was divided into subtasks_count subtasks labelled from 1 to subtasks_count.
It is guaranteed that 2 <= subtasks_count <= 20.
 

Table: Executed

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| task_id       | int     |
| subtask_id    | int     |
+---------------+---------+
(task_id, subtask_id) is the primary key for this table.
Each row in this table indicates that for the task task_id, the subtask with ID subtask_id was executed successfully.
It is guaranteed that subtask_id <= subtasks_count for each task_id.
 

Write an SQL query to report the IDs of the missing subtasks for each task_id.

Return the result table in any order.

The query result format is in the following example:

 

Tasks table:
+---------+----------------+
| task_id | subtasks_count |
+---------+----------------+
| 1       | 3              |
| 2       | 2              |
| 3       | 4              |
+---------+----------------+

Executed table:
+---------+------------+
| task_id | subtask_id |
+---------+------------+
| 1       | 2          |
| 3       | 1          |
| 3       | 2          |
| 3       | 3          |
| 3       | 4          |
+---------+------------+

Result table:
+---------+------------+
| task_id | subtask_id |
+---------+------------+
| 1       | 1          |
| 1       | 3          |
| 2       | 1          |
| 2       | 2          |
+---------+------------+
Task 1 was divided into 3 subtasks (1, 2, 3). Only subtask 2 was executed successfully, so we include (1, 1) and (1, 3) in the answer.
Task 2 was divided into 2 subtasks (1, 2). No subtask was executed successfully, so we include (2, 1) and (2, 2) in the answer.
Task 3 was divided into 4 subtasks (1, 2, 3, 4). All of the subtasks were executed successfully.
Difficulty:
Hard
Lock:
Prime
Company:
Google

*/

-- Drop tables if they exist
DROP TABLE IF EXISTS Executed;
DROP TABLE IF EXISTS Tasks;

-- Create the Tasks table
CREATE TABLE Tasks (
    task_id INT PRIMARY KEY,
    subtasks_count INT CHECK (subtasks_count BETWEEN 2 AND 20)
);

-- Create the Executed table
CREATE TABLE Executed (
    task_id INT,
    subtask_id INT,
    PRIMARY KEY (task_id, subtask_id),
    FOREIGN KEY (task_id) REFERENCES Tasks(task_id)
);

-- Insert data into Tasks table
INSERT INTO Tasks (task_id, subtasks_count) VALUES
(1, 3),
(2, 2),
(3, 4);

-- Insert data into Executed table
INSERT INTO Executed (task_id, subtask_id) VALUES
(1, 2),
(3, 1),
(3, 2),
(3, 3),
(3, 4);


WITH RECURSIVE all_subtasks AS (
    -- Base case: Start with subtask 1 for each task
    SELECT task_id, 1 AS subtask_id  
    FROM tasks

    UNION ALL

    -- Recursive case: Increment subtask_id up to subtasks_count
    SELECT a.task_id, a.subtask_id + 1 
    FROM all_subtasks a
    JOIN tasks t ON a.task_id = t.task_id  -- Ensure valid limit per task
    WHERE a.subtask_id < t.subtasks_count
)

-- Find missing subtasks
SELECT a.task_id, a.subtask_id 
FROM all_subtasks a
LEFT JOIN executed e ON a.task_id = e.task_id AND a.subtask_id = e.subtask_id
WHERE e.task_id IS NULL
ORDER BY a.task_id, a.subtask_id;

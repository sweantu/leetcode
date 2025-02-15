/*
SQL Schema
Table: Accounts

+----------------+------+
| Column Name    | Type |
+----------------+------+
| account_id     | int  |
| max_income     | int  |
+----------------+------+
account_id is the primary key for this table.
Each row contains information about the maximum monthly income for one bank account.
 

Table: Transactions

+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| transaction_id | int      |
| account_id     | int      |
| type           | ENUM     |
| amount         | int      |
| day            | datetime |
+----------------+----------+
transaction_id is the primary key for this table.
Each row contains information about one transaction.
type is ENUM ('Creditor','Debtor') where 'Creditor' means the user deposited money into their account and 'Debtor' means the user withdrew money from their account.
amount is the amount of money depositied/withdrawn during the transaction.
 

Write an SQL query to report the IDs of all suspicious bank accounts.

A bank account is suspicious if the total income exceeds the max_income for this account for two or more consecutive months. The total income of an account in some month is the sum of all its deposits in that month (i.e., transactions of the type 'Creditor').

Return the result table in ascending order by transaction_id.

The query result format is in the following example:

 

Accounts table:
+------------+------------+
| account_id | max_income |
+------------+------------+
| 3          | 21000      |
| 4          | 10400      |
+------------+------------+

Transactions table:
+----------------+------------+----------+--------+---------------------+
| transaction_id | account_id | type     | amount | day                 |
+----------------+------------+----------+--------+---------------------+
| 2              | 3          | Creditor | 107100 | 2021-06-02 11:38:14 |
| 4              | 4          | Creditor | 10400  | 2021-06-20 12:39:18 |
| 11             | 4          | Debtor   | 58800  | 2021-07-23 12:41:55 |
| 1              | 4          | Creditor | 49300  | 2021-05-03 16:11:04 |
| 15             | 3          | Debtor   | 75500  | 2021-05-23 14:40:20 |
| 10             | 3          | Creditor | 102100 | 2021-06-15 10:37:16 |
| 14             | 4          | Creditor | 56300  | 2021-07-21 12:12:25 |
| 19             | 4          | Debtor   | 101100 | 2021-05-09 15:21:49 |
| 8              | 3          | Creditor | 64900  | 2021-07-26 15:09:56 |
| 7              | 3          | Creditor | 90900  | 2021-06-14 11:23:07 |
+----------------+------------+----------+--------+---------------------+

Result table:
+------------+
| account_id |
+------------+
| 3          |
+------------+

For account 3:
- In 6-2021, the user had an income of 107100 + 102100 + 90900 = 300100.
- In 7-2021, the user had an income of 64900.
We can see that the income exceeded the max income of 21000 for two consecutive months, so we include 3 in the result table.

For account 4:
- In 5-2021, the user had an income of 49300.
- In 6-2021, the user had an income of 10400.
- In 7-2021, the user had an income of 56300.
We can see that the income exceeded the max income in May and July, but not in June. Since the account did not exceed the max income for two consecutive months, we do not include it in the result table.
Difficulty:
Medium
Lock:
Prime
*/

CREATE TABLE Accounts (
    account_id INT PRIMARY KEY,
    max_income INT
);

INSERT INTO Accounts (account_id, max_income) VALUES 
(3, 21000),
(4, 10400);

CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT REFERENCES Accounts(account_id),
    type VARCHAR(10) CHECK (type IN ('Creditor', 'Debtor')),
    amount INT,
    day TIMESTAMP
);

INSERT INTO Transactions (transaction_id, account_id, type, amount, day) VALUES 
(2, 3, 'Creditor', 107100, '2021-06-02 11:38:14'),
(4, 4, 'Creditor', 10400, '2021-06-20 12:39:18'),
(11, 4, 'Debtor', 58800, '2021-07-23 12:41:55'),
(1, 4, 'Creditor', 49300, '2021-05-03 16:11:04'),
(15, 3, 'Debtor', 75500, '2021-05-23 14:40:20'),
(10, 3, 'Creditor', 102100, '2021-06-15 10:37:16'),
(14, 4, 'Creditor', 56300, '2021-07-21 12:12:25'),
(19, 4, 'Debtor', 101100, '2021-05-09 15:21:49'),
(8, 3, 'Creditor', 64900, '2021-07-26 15:09:56'),
(7, 3, 'Creditor', 90900, '2021-06-14 11:23:07');

select * from accounts a ;
select * from transactions t ;


select *
from transactions t 
group by account_id, type, 
;

with cte as (
	SELECT DATE_TRUNC('month', day) AS month, SUM(amount), account_id, type FROM transactions GROUP BY month, account_id , type having type = 'Creditor' order by account_id
)
select 
	c.*, a.max_income,
	row_number () over(partition by a.account_id order by month asc) as rn
from cte c
join accounts a on c.account_id = a.account_id ;


WITH MonthlyIncome AS (
    SELECT 
        account_id, 
        DATE_TRUNC('month', day) AS month, 
        SUM(amount) AS total_income
    FROM Transactions
    WHERE type = 'Creditor'
    GROUP BY account_id, month
),
FlaggedAccounts AS (
    SELECT 
        m1.account_id
    FROM MonthlyIncome m1
    JOIN MonthlyIncome m2 
        ON m1.account_id = m2.account_id 
        AND m1.month = m2.month - INTERVAL '1 month'
    JOIN Accounts a ON m1.account_id = a.account_id
    WHERE m1.total_income > a.max_income 
      AND m2.total_income > a.max_income
)
SELECT DISTINCT account_id
FROM FlaggedAccounts
ORDER BY account_id;


WITH MonthlyIncome AS (
    SELECT 
        account_id, 
        DATE_TRUNC('month', day) AS month, 
        SUM(amount) AS total_income
    FROM Transactions
    WHERE type = 'Creditor'
    GROUP BY account_id, month
),
ExceedingMonths AS (
    SELECT 
        mi.account_id, 
        mi.month, 
        COUNT(*) OVER (
            PARTITION BY mi.account_id 
            ORDER BY mi.month 
            RANGE BETWEEN INTERVAL '99 months' PRECEDING AND CURRENT ROW
        ) AS consecutive_count
    FROM MonthlyIncome mi
    JOIN Accounts a ON mi.account_id = a.account_id
    WHERE mi.total_income > a.max_income
)
SELECT DISTINCT account_id
FROM ExceedingMonths
WHERE consecutive_count >= 100
ORDER BY account_id;

WITH RECURSIVE MonthlyIncome AS (
    -- Step 1: Aggregate total income per account per month
    SELECT 
        account_id, 
        DATE_TRUNC('month', day) AS month, 
        SUM(amount) AS total_income
    FROM Transactions
    WHERE type = 'Creditor'
    GROUP BY account_id, month
),
RecursiveCheck AS (
    -- Base Case: Start with all months where income exceeded max_income
    SELECT 
        mi.account_id, 
        mi.month, 
        1 AS consecutive_months
    FROM MonthlyIncome mi
    JOIN Accounts a ON mi.account_id = a.account_id
    WHERE mi.total_income > a.max_income

    UNION ALL

    -- Recursive Step: Check if the next month also exceeds max_income
    SELECT 
        mi.account_id, 
        mi.month, 
        rc.consecutive_months + 1
    FROM RecursiveCheck rc
    JOIN MonthlyIncome mi 
        ON rc.account_id = mi.account_id 
        AND rc.month = mi.month - INTERVAL '1 month'
    JOIN Accounts a ON mi.account_id = a.account_id
    WHERE mi.total_income > a.max_income
)
-- Step 3: Find accounts where there are at least 2 consecutive months
SELECT DISTINCT account_id 
FROM RecursiveCheck
WHERE consecutive_months >= 2
ORDER BY account_id;


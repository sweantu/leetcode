/*
1205. Monthly Transactions II
Table: Transactions

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| id             | int     |
| country        | varchar |
| state          | enum    |
| amount         | int     |
| trans_date     | date    |
+----------------+---------+
id is the primary key of this table.
The table has information about incoming transactions.
The state column is an enum of type ["approved", "declined"].
Table: Chargebacks

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| trans_id       | int     |
| charge_date    | date    |
+----------------+---------+
Chargebacks contains basic information regarding incoming chargebacks from some transactions placed in Transactions table.
trans_id is a foreign key to the id column of Transactions table.
Each chargeback corresponds to a transaction made previously even if they were not approved.
 

Write an SQL query to find for each month and country, the number of approved transactions and their total amount, the number of chargebacks and their total amount.

Note: In your query, given the month and country, ignore rows with all zeros.

The query result format is in the following example:

Transactions table:
+------+---------+----------+--------+------------+
| id   | country | state    | amount | trans_date |
+------+---------+----------+--------+------------+
| 101  | US      | approved | 1000   | 2019-05-18 |
| 102  | US      | declined | 2000   | 2019-05-19 |
| 103  | US      | approved | 3000   | 2019-06-10 |
| 104  | US      | approved | 4000   | 2019-06-13 |
| 105  | US      | approved | 5000   | 2019-06-15 |
+------+---------+----------+--------+------------+

Chargebacks table:
+------------+------------+
| trans_id   | trans_date |
+------------+------------+
| 102        | 2019-05-29 |
| 101        | 2019-06-30 |
| 105        | 2019-09-18 |
+------------+------------+

Result table:
+----------+---------+----------------+-----------------+-------------------+--------------------+
| month    | country | approved_count | approved_amount | chargeback_count  | chargeback_amount  |
+----------+---------+----------------+-----------------+-------------------+--------------------+
| 2019-05  | US      | 1              | 1000            | 1                 | 2000               |
| 2019-06  | US      | 3              | 12000           | 1                 | 1000               |
| 2019-09  | US      | 0              | 0               | 1                 | 5000               |
+----------+---------+----------------+-----------------+-------------------+--------------------+
Difficulty:
Medium
Lock:
Prime
Company:
Wish
*/
CREATE TABLE Transactions (
    id SERIAL PRIMARY KEY,
    country VARCHAR(255) NOT NULL,
    state VARCHAR(10) CHECK (state IN ('approved', 'declined')),
    amount INT NOT NULL CHECK (amount >= 0),
    trans_date DATE NOT NULL
);

CREATE TABLE Chargebacks (
    trans_id INT PRIMARY KEY,
    charge_date DATE NOT NULL,
    FOREIGN KEY (trans_id) REFERENCES Transactions(id) ON DELETE CASCADE
);

-- Insert data into Transactions table
INSERT INTO Transactions (id, country, state, amount, trans_date) VALUES
(101, 'US', 'approved', 1000, '2019-05-18'),
(102, 'US', 'declined', 2000, '2019-05-19'),
(103, 'US', 'approved', 3000, '2019-06-10'),
(104, 'US', 'approved', 4000, '2019-06-13'),
(105, 'US', 'approved', 5000, '2019-06-15');

-- Insert data into Chargebacks table
INSERT INTO Chargebacks (trans_id, charge_date) VALUES
(102, '2019-05-29'),
(101, '2019-06-30'),
(105, '2019-09-18');



with cte1 as (
	SELECT 
        to_char(c.charge_date, 'YYYY-MM') AS month, 
        t.country,
        COUNT(*) AS chargeback_count,
        SUM(t.amount) AS chargeback_amount
    FROM transactions t
    JOIN chargebacks c ON t.id = c.trans_id
    GROUP BY month, t.country
)
, cte2 as (
	SELECT 
        to_char(t.trans_date, 'YYYY-MM') AS month, 
        t.country,
        COUNT(*) AS approved_count,
        SUM(t.amount) AS approved_amount
    FROM transactions t
    WHERE t.state = 'approved'
    GROUP BY month, t.country
)
select 
	month, country,
	coalesce(approved_count, 0) as approved_count, 
	coalesce(approved_amount,0) as approved_amount, 
	coalesce(chargeback_count,0) as chargeback_count,
	coalesce(chargeback_amount, 0) as chargeback_amount
from cte1 full join cte2 using(month, country);
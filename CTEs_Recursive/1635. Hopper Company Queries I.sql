/*
1635. Hopper Company Queries I
SQL Schema 
Table: Drivers

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| driver_id   | int     |
| join_date   | date    |
+-------------+---------+
driver_id is the primary key for this table.
Each row of this table contains the driver's ID and the date they joined the Hopper company.
 

Table: Rides

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| ride_id      | int     |
| user_id      | int     |
| requested_at | date    |
+--------------+---------+
ride_id is the primary key for this table.
Each row of this table contains the ID of a ride, the user's ID that requested it, and the day they requested it.
There may be some ride requests in this table that were not accepted.
 

Table: AcceptedRides

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| ride_id       | int     |
| driver_id     | int     |
| ride_distance | int     |
| ride_duration | int     |
+---------------+---------+
ride_id is the primary key for this table.
Each row of this table contains some information about an accepted ride.
It is guaranteed that each accepted ride exists in the Rides table.
 

Write an SQL query to report the following statistics for each month of 2020:

The number of drivers currently with the Hopper company by the end of the month (active_drivers).
The number of accepted rides in that month (accepted_rides).
Return the result table ordered by month in ascending order, where month is the month's number (January is 1, February is 2, etc.).

The query result format is in the following example.

 

Drivers table:
+-----------+------------+
| driver_id | join_date  |
+-----------+------------+
| 10        | 2019-12-10 |
| 8         | 2020-1-13  |
| 5         | 2020-2-16  |
| 7         | 2020-3-8   |
| 4         | 2020-5-17  |
| 1         | 2020-10-24 |
| 6         | 2021-1-5   |
+-----------+------------+

Rides table:
+---------+---------+--------------+
| ride_id | user_id | requested_at |
+---------+---------+--------------+
| 6       | 75      | 2019-12-9    |
| 1       | 54      | 2020-2-9     |
| 10      | 63      | 2020-3-4     |
| 19      | 39      | 2020-4-6     |
| 3       | 41      | 2020-6-3     |
| 13      | 52      | 2020-6-22    |
| 7       | 69      | 2020-7-16    |
| 17      | 70      | 2020-8-25    |
| 20      | 81      | 2020-11-2    |
| 5       | 57      | 2020-11-9    |
| 2       | 42      | 2020-12-9    |
| 11      | 68      | 2021-1-11    |
| 15      | 32      | 2021-1-17    |
| 12      | 11      | 2021-1-19    |
| 14      | 18      | 2021-1-27    |
+---------+---------+--------------+

AcceptedRides table:
+---------+-----------+---------------+---------------+
| ride_id | driver_id | ride_distance | ride_duration |
+---------+-----------+---------------+---------------+
| 10      | 10        | 63            | 38            |
| 13      | 10        | 73            | 96            |
| 7       | 8         | 100           | 28            |
| 17      | 7         | 119           | 68            |
| 20      | 1         | 121           | 92            |
| 5       | 7         | 42            | 101           |
| 2       | 4         | 6             | 38            |
| 11      | 8         | 37            | 43            |
| 15      | 8         | 108           | 82            |
| 12      | 8         | 38            | 34            |
| 14      | 1         | 90            | 74            |
+---------+-----------+---------------+---------------+

Result table:
+-------+----------------+----------------+
| month | active_drivers | accepted_rides |
+-------+----------------+----------------+
| 1     | 2              | 0              |
| 2     | 3              | 0              |
| 3     | 4              | 1              |
| 4     | 4              | 0              |
| 5     | 5              | 0              |
| 6     | 5              | 1              |
| 7     | 5              | 1              |
| 8     | 5              | 1              |
| 9     | 5              | 0              |
| 10    | 6              | 0              |
| 11    | 6              | 2              |
| 12    | 6              | 1              |
+-------+----------------+----------------+

By the end of January --> two active drivers (10, 8) and no accepted rides.
By the end of February --> three active drivers (10, 8, 5) and no accepted rides.
By the end of March --> four active drivers (10, 8, 5, 7) and one accepted ride (10).
By the end of April --> four active drivers (10, 8, 5, 7) and no accepted rides.
By the end of May --> five active drivers (10, 8, 5, 7, 4) and no accepted rides.
By the end of June --> five active drivers (10, 8, 5, 7, 4) and one accepted ride (13).
By the end of July --> five active drivers (10, 8, 5, 7, 4) and one accepted ride (7).
By the end of August --> five active drivers (10, 8, 5, 7, 4) and one accepted ride (17).
By the end of Septemeber --> five active drivers (10, 8, 5, 7, 4) and no accepted rides.
By the end of October --> six active drivers (10, 8, 5, 7, 4, 1) and no accepted rides.
By the end of November --> six active drivers (10, 8, 5, 7, 4, 1) and two accepted rides (20, 5).
By the end of December --> six active drivers (10, 8, 5, 7, 4, 1) and one accepted ride (2).
Difficulty:
Hard
Lock:
Prime
Company:
Uber

I'll help you solve the Hopper Company Queries problem. We'll need to:
Generate all months of 2020
Count active drivers for each month
Count accepted rides for each month
Here's the solution:

Let's break down how this solution works:
months CTE:
Creates a recursive CTE that generates numbers 1-12 representing each month
active_drivers_count CTE:
For each month, counts drivers who joined before or during that month in 2020
Uses date arithmetic to check against the end of each month
Excludes drivers who joined in 2021
3. accepted_rides_count CTE:
Counts accepted rides for each month in 2020
Uses EXTRACT to get the month from requested_at
Joins with AcceptedRides to only count accepted rides
Final SELECT:
Joins all the CTEs together
Uses COALESCE to handle months with no drivers or rides
Orders by month as required
This will produce the exact output format shown in the example, with:
month (1-12)
active_drivers (count of drivers active by end of month)
accepted_rides (count of rides accepted in that month)

*/

-- Table: Drivers
CREATE TABLE Drivers (
    driver_id INT PRIMARY KEY,
    join_date DATE NOT NULL
);

-- Table: Rides
CREATE TABLE Rides (
    ride_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    requested_at DATE NOT NULL
);

-- Table: AcceptedRides
CREATE TABLE AcceptedRides (
    ride_id INT PRIMARY KEY,
    driver_id INT NOT NULL,
    ride_distance INT NOT NULL,
    ride_duration INT NOT NULL,
    FOREIGN KEY (ride_id) REFERENCES Rides(ride_id),
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id)
);

-- Insert data into Drivers
INSERT INTO Drivers (driver_id, join_date) VALUES
(10, '2019-12-10'),
(8, '2020-01-13'),
(5, '2020-02-16'),
(7, '2020-03-08'),
(4, '2020-05-17'),
(1, '2020-10-24'),
(6, '2021-01-05');

-- Insert data into Rides
INSERT INTO Rides (ride_id, user_id, requested_at) VALUES
(6, 75, '2019-12-09'),
(1, 54, '2020-02-09'),
(10, 63, '2020-03-04'),
(19, 39, '2020-04-06'),
(3, 41, '2020-06-03'),
(13, 52, '2020-06-22'),
(7, 69, '2020-07-16'),
(17, 70, '2020-08-25'),
(20, 81, '2020-11-02'),
(5, 57, '2020-11-09'),
(2, 42, '2020-12-09'),
(11, 68, '2021-01-11'),
(15, 32, '2021-01-17'),
(12, 11, '2021-01-19'),
(14, 18, '2021-01-27');

-- Insert data into AcceptedRides
INSERT INTO AcceptedRides (ride_id, driver_id, ride_distance, ride_duration) VALUES
(10, 10, 63, 38),
(13, 10, 73, 96),
(7, 8, 100, 28),
(17, 7, 119, 68),
(20, 1, 121, 92),
(5, 7, 42, 101),
(2, 4, 6, 38),
(11, 8, 37, 43),
(15, 8, 108, 82),
(12, 8, 38, 34),
(14, 1, 90, 74);

WITH RECURSIVE months AS (
    SELECT 1 as month
    UNION ALL
    SELECT month + 1
    FROM months
    WHERE month < 12
),
active_drivers_count AS (
    SELECT 
        m.month,
        COUNT(DISTINCT d.driver_id) as active_drivers
    FROM months m
    LEFT JOIN drivers d ON d.join_date <= (DATE '2020-12-31' - INTERVAL '1 month' * (12 - m.month))
    WHERE d.join_date < '2021-01-01'
    GROUP BY m.month
),
accepted_rides_count AS (
    SELECT 
        EXTRACT(MONTH FROM r.requested_at) as month,
        COUNT(ar.ride_id) as accepted_rides
    FROM rides r
    LEFT JOIN acceptedrides ar ON r.ride_id = ar.ride_id
    WHERE EXTRACT(YEAR FROM r.requested_at) = 2020
    GROUP BY EXTRACT(MONTH FROM r.requested_at)
)
SELECT 
    m.month,
    COALESCE(adc.active_drivers, 0) as active_drivers,
    COALESCE(arc.accepted_rides, 0) as accepted_rides
FROM months m
LEFT JOIN active_drivers_count adc ON m.month = adc.month
LEFT JOIN accepted_rides_count arc ON m.month = arc.month
ORDER BY m.month;


/*


select * from drivers d 
order by join_date ;
select * from rides r ;
select * from acceptedrides a ;


WITH RECURSIVE drivers_in_2020 AS (
    SELECT 
        COUNT(driver_id) AS count, 
        DATE_PART('month', 
            CASE 
                WHEN join_date < '2020-01-01' THEN '2020-01-01' 
                ELSE join_date 
            END) AS month
    FROM drivers d 
    WHERE join_date < '2021-01-01'
    GROUP BY month
    ORDER BY month
), 
gen_months AS (
    SELECT 0 AS count, 1 AS month
    UNION ALL
    SELECT count, month + 1 FROM gen_months WHERE month < 12
),
group_months AS (
    SELECT * FROM drivers_in_2020
    UNION ALL
    SELECT * FROM gen_months
)
SELECT 
    SUM(count) OVER (ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS consecutive_sum,
    month
FROM group_months
ORDER BY month;





WITH active_drivers AS (
    SELECT
        driver_id,
        EXTRACT(MONTH FROM join_date) AS join_month,
        EXTRACT(YEAR FROM join_date) AS join_year
    FROM
        Drivers
    WHERE
        join_date <= '2020-12-31'
),
accepted_rides AS (
    SELECT
        EXTRACT(MONTH FROM requested_at) AS ride_month,
        ar.ride_id
    FROM
        Rides r
    JOIN AcceptedRides ar
        ON r.ride_id = ar.ride_id
    WHERE
        r.requested_at BETWEEN '2020-01-01' AND '2020-12-31'
)
SELECT
    gs.month,
    COUNT(DISTINCT ad.driver_id) AS active_drivers,
    COUNT(ar.ride_id) AS accepted_rides
FROM
    generate_series(1, 12) AS gs(month)  -- Aliased the generate_series column as "month"
LEFT JOIN active_drivers ad
    ON (ad.join_year < 2020 OR (ad.join_year = 2020 AND ad.join_month <= gs.month))  -- Referencing gs.month
LEFT JOIN accepted_rides ar
    ON ar.ride_month = gs.month  -- Referencing ar.ride_month
GROUP BY
    gs.month  -- Referencing gs.month
ORDER BY
    gs.month;  -- Referencing gs.month


WITH RECURSIVE months AS (
    -- Generate all months of the year 2020
    SELECT 1 AS month, '2020-01-01'::date AS month_date
    UNION ALL
    SELECT month + 1, (month_date + INTERVAL '1 month')::date
    FROM months
    WHERE month < 12
),
active_drivers AS (
    -- Get drivers who are active by the end of each month
    SELECT
        driver_id,
        join_date
    FROM Drivers
    WHERE join_date <= '2020-12-31'
),
accepted_rides AS (
    -- Get accepted rides by month
    SELECT
        ar.ride_id,
        EXTRACT(MONTH FROM r.requested_at) AS ride_month,
        EXTRACT(YEAR FROM r.requested_at) AS ride_year
    FROM AcceptedRides ar
    JOIN Rides r ON ar.ride_id = r.ride_id
    WHERE r.requested_at BETWEEN '2020-01-01' AND '2020-12-31'
)
SELECT
    m.month,
    -- Count active drivers by the end of the month (drivers who joined before or during the month)
    COUNT(DISTINCT ad.driver_id) AS active_drivers,
    -- Count accepted rides for the month
    COUNT(ar.ride_id) AS accepted_rides
FROM
    months m
LEFT JOIN active_drivers ad
    ON ad.join_date <= (m.month_date + INTERVAL '1 month' - INTERVAL '1 day')
LEFT JOIN accepted_rides ar
    ON ar.ride_month = m.month AND ar.ride_year = 2020
GROUP BY
    m.month
ORDER BY
    m.month;



   

WITH RECURSIVE months AS (
  SELECT 1 AS month, '2020-01-31'::DATE AS month_end
  UNION ALL
  SELECT month + 1, (DATE_TRUNC('MONTH', month_end + INTERVAL '1 month') - INTERVAL '1 day')::DATE
  FROM months 
  WHERE month < 12
),
active_drivers_by_month AS (
  SELECT
    m.month,
    COUNT(d.driver_id) AS num_drivers
  FROM
    months m
    LEFT JOIN Drivers d ON d.join_date <= m.month_end
  GROUP BY
    m.month
),
accepted_rides_by_month AS (
  SELECT
    EXTRACT(MONTH FROM r.requested_at) AS month,
    COUNT(r.requested_at) AS accepted_rides
  FROM
    Rides r
    INNER JOIN AcceptedRides ar ON ar.ride_id = r.ride_id
  WHERE
    EXTRACT(YEAR FROM r.requested_at) = 2020
  GROUP BY
    month
)
SELECT
  m.month,
  ad.num_drivers AS active_drivers,
  COALESCE(ar.accepted_rides, 0) AS accepted_rides
FROM
  months m
  LEFT JOIN active_drivers_by_month ad ON m.month = ad.month
  LEFT JOIN accepted_rides_by_month ar ON m.month = ar.month
ORDER BY
  m.month;
*/
/*
1127. User Purchase Platform
Table: Spending

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| spend_date  | date    |
| platform    | enum    |
| amount      | int     |
+-------------+---------+
The table logs the spendings history of users that make purchases from an online shopping website which has a desktop and a mobile application.
(user_id, spend_date, platform) is the primary key of this table.
The platform column is an ENUM type of ('desktop', 'mobile').
Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only and both mobile and desktop together for each date.

The query result format is in the following example:

Spending table:
+---------+------------+----------+--------+
| user_id | spend_date | platform | amount |
+---------+------------+----------+--------+
| 1       | 2019-07-01 | mobile   | 100    |
| 1       | 2019-07-01 | desktop  | 100    |
| 2       | 2019-07-01 | mobile   | 100    |
| 2       | 2019-07-02 | mobile   | 100    |
| 3       | 2019-07-01 | desktop  | 100    |
| 3       | 2019-07-02 | desktop  | 100    |
+---------+------------+----------+--------+

Result table:
+------------+----------+--------------+-------------+
| spend_date | platform | total_amount | total_users |
+------------+----------+--------------+-------------+
| 2019-07-01 | desktop  | 100          | 1           |
| 2019-07-01 | mobile   | 100          | 1           |
| 2019-07-01 | both     | 200          | 1           |
| 2019-07-02 | desktop  | 100          | 1           |
| 2019-07-02 | mobile   | 100          | 1           |
| 2019-07-02 | both     | 0            | 0           |
+------------+----------+--------------+-------------+
On 2019-07-01, user 1 purchased using both desktop and mobile, user 2 purchased using mobile only and user 3 purchased using desktop only.
On 2019-07-02, user 2 purchased using mobile only, user 3 purchased using desktop only and no one purchased using both platforms.
Difficulty:
Hard
Lock:
Prime
Company:
LinkedIn

*/
-- Create the Spending table
CREATE TABLE spending (
    user_id INT NOT NULL,
    spend_date DATE NOT NULL,
    platform VARCHAR(10) CHECK (platform IN ('desktop', 'mobile')),
    amount INT NOT NULL,
    PRIMARY KEY (user_id, spend_date, platform)
);

-- Insert sample data
INSERT INTO spending (user_id, spend_date, platform, amount) VALUES
(1, '2019-07-01', 'mobile', 100),
(1, '2019-07-01', 'desktop', 100),
(2, '2019-07-01', 'mobile', 100),
(2, '2019-07-02', 'mobile', 100),
(3, '2019-07-01', 'desktop', 100),
(3, '2019-07-02', 'desktop', 100);


select * from spending s ;

with cte1 as (
	select distinct spend_date 
	from spending s
)
, cte2 as (
	select distinct platform 
	from spending s
	union
	select 'both'
)
select * 
from cte1 cross join cte2;

-- my solution
with cte as (
select
	spend_date,
	user_id,
	case 
		when count(*) = 2 then 'both'
		else max(s.platform)
	end as platform,
	sum(amount) as total_amounts 
from spending s 
group by user_id, spend_date
order by spend_date , user_id 
), cte2 as (
select spend_date, platform,
	count(*)  as total_users,
	sum(total_amounts) as total_amounts
from cte
group by spend_date, platform),
cte3 as (
select *
from (
	select platform 
	from spending s
	union select 'both'
) 
cross join (
	select distinct spend_date 
	from spending s
))
select cte3.spend_date, cte3.platform, coalesce (cte2.total_users, 0), coalesce ( cte2.total_amounts, 0)
from cte3
left join cte2
on cte3.spend_date = cte2.spend_date and cte3.platform = cte2.platform
order by cte3.spend_date, cte3.platform;



WITH user_spending AS (
    -- Identify each user's spending pattern per day
    SELECT 
        spend_date,
        user_id,
        SUM(amount) AS total_amount,
        CASE 
            WHEN COUNT(DISTINCT platform) = 2 THEN 'both'
            ELSE MAX(platform)  -- If only one platform, take its name ('desktop' or 'mobile')
        END AS platform
    FROM Spending
    GROUP BY spend_date, user_id
)
SELECT 
	    spend_date,
	    platform,
	    SUM(total_amount) AS total_amount,
	    COUNT(user_id) AS total_users
	FROM user_spending
	GROUP BY spend_date, platform
	ORDER BY spend_date, 
	         CASE platform 
	             WHEN 'desktop' THEN 1 
	             WHEN 'mobile' THEN 2 
	             WHEN 'both' THEN 3 
	         end;

	        
WITH user_spending AS (
    -- Identify each user's spending pattern per day
    SELECT 
        spend_date,
        user_id,
        SUM(amount) AS total_amount,
        CASE 
            WHEN COUNT(DISTINCT platform) = 2 THEN 'both'
            ELSE MAX(platform)  -- If only one platform, take its name ('desktop' or 'mobile')
        END AS platform
    FROM Spending
    GROUP BY spend_date, user_id
), aggregated AS (
    -- Aggregate total amount and user count per date and platform
    SELECT 
        spend_date,
        platform,
        SUM(total_amount) AS total_amount,
        COUNT(user_id) AS total_users
    FROM user_spending
    GROUP BY spend_date, platform
), all_dates AS (
    -- Get all unique spend dates
    SELECT DISTINCT spend_date FROM Spending
), all_platforms AS (
    -- Define platform types manually
    SELECT unnest(ARRAY['desktop', 'mobile', 'both']) AS platform
), date_platform_combinations AS (
    -- Generate all combinations of spend_date and platform
    SELECT spend_date, platform
    FROM all_dates CROSS JOIN all_platforms
)
-- Join with aggregated data to ensure missing rows are included
SELECT 
    dpc.spend_date,
    dpc.platform,
    COALESCE(a.total_amount, 0) AS total_amount,
    COALESCE(a.total_users, 0) AS total_users
FROM date_platform_combinations dpc
LEFT JOIN aggregated a 
ON dpc.spend_date = a.spend_date AND dpc.platform = a.platform
ORDER BY dpc.spend_date, 
         CASE dpc.platform 
             WHEN 'desktop' THEN 1 
             WHEN 'mobile' THEN 2 
             WHEN 'both' THEN 3 
         END;

        
 
        

SELECT 
    s.spend_date,
    p.platform,
    COALESCE(SUM(amount), 0) AS total_amount,
    COALESCE(COUNT(DISTINCT user_id), 0) AS total_users
FROM (
    -- Generate all platform categories for each spend_date
    SELECT DISTINCT spend_date, 'desktop' AS platform FROM Spending
    UNION ALL
    SELECT DISTINCT spend_date, 'mobile' FROM Spending
    UNION ALL
    SELECT DISTINCT spend_date, 'both' FROM Spending
) p
LEFT JOIN (
    -- Identify users who used only one platform or both
    SELECT 
        spend_date,
        user_id,
        SUM(amount) AS amount,
        CASE 
            WHEN COUNT(DISTINCT platform) = 2 THEN 'both'
            ELSE MAX(platform)  -- Either 'desktop' or 'mobile'
        END AS platform
    FROM Spending
    GROUP BY spend_date, user_id
) s
ON p.spend_date = s.spend_date AND p.platform = s.platform
GROUP BY s.spend_date, p.platform
ORDER BY s.spend_date, 
         CASE p.platform 
             WHEN 'desktop' THEN 1 
             WHEN 'mobile' THEN 2 
             WHEN 'both' THEN 3 
         END;



WITH cte AS (
    SELECT 
        spend_date,
        user_id,
        CASE 
            WHEN COUNT(DISTINCT platform) = 2 THEN 'both'
            ELSE MAX(platform) 
        END AS platform,
        SUM(amount) AS total_amounts
    FROM spending
    GROUP BY spend_date, user_id
), 
cte2 AS (
    SELECT 
        spend_date, 
        platform,
        COUNT(*) AS total_users,
        SUM(total_amounts) AS total_amounts
    FROM cte
    GROUP BY spend_date, platform
),
cte3 AS (
    SELECT DISTINCT spend_date, 'desktop' AS platform FROM spending
    UNION ALL
    SELECT DISTINCT spend_date, 'mobile' FROM spending
    UNION ALL
    SELECT DISTINCT spend_date, 'both' FROM spending
)
SELECT 
    cte3.spend_date, 
    cte3.platform, 
    COALESCE(cte2.total_users, 0) AS total_users, 
    COALESCE(cte2.total_amounts, 0) AS total_amounts
FROM cte3
LEFT JOIN cte2 
    ON cte3.spend_date = cte2.spend_date AND cte3.platform = cte2.platform
ORDER BY cte3.spend_date, cte3.platform;

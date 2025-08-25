-- 1. Drop table if exists
DROP TABLE IF EXISTS Activity;

-- 2. Create table
CREATE TABLE Activity (
    player_id    INT NOT NULL,
    device_id    INT NOT NULL,
    event_date   DATE NOT NULL,
    games_played INT NOT NULL,
    PRIMARY KEY (player_id, event_date)
);

-- 3. Insert sample data
INSERT INTO Activity (player_id, device_id, event_date, games_played) VALUES
(1, 2, '2016-03-01', 5),
(1, 2, '2016-05-02', 6),
(1, 3, '2017-06-25', 1),
(3, 1, '2016-03-02', 0),
(3, 4, '2018-07-03', 5);

SELECT * FROM Activity;


SELECT
	player_id,
	event_date,
	SUM(games_played) OVER(
		PARTITION BY player_id ORDER BY event_date ASC
	) games_played_so_far
FROM activity;
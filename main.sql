BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "events" (
	"id"	INTEGER,
	"cid"	INTEGER NOT NULL,
	"type"	TEXT NOT NULL,
	"date"	DATETIME NOT NULL,
	PRIMARY KEY("id")
);
INSERT INTO "events" ("id","cid","type","date") VALUES (1,0,'start','2021-01-01 00:00:00'),
 (2,2,'start','2021-01-01 02:00:00'),
 (3,1,'start','2021-01-01 03:00:00'),
 (4,0,'end','2021-01-01 06:00:00'),
 (5,1,'end','2021-01-01 07:00:00'),
 (6,3,'start','2021-01-01 08:00:00'),
 (7,3,'end','2021-01-01 08:30:00'),
 (8,4,'start','2021-01-01 08:45:00'),
 (9,2,'end','2021-01-01 09:00:00'),
 (10,5,'start','2021-01-01 10:00:00'),
 (11,6,'start','2021-01-01 11:00:00'),
 (12,4,'end','2021-01-01 12:00:00'),
 (13,5,'end','2021-01-01 13:00:00'),
 (14,7,'start','2021-01-01 14:00:00'),
 (15,7,'end','2021-01-01 15:00:00'),
 (16,6,'end','2021-01-01 16:00:00'),
 (17,8,'start','2021-01-01 15:30:00'),
 (18,9,'start','2021-01-01 16:30:00'),
 (19,10,'start','2021-01-01 17:00:00'),
 (20,8,'end','2021-01-01 18:00:00'),
 (21,10,'end','2021-01-01 19:00:00'),
 (22,11,'start','2021-01-01 19:30:00'),
 (23,11,'end','2021-01-01 19:45:00'),
 (24,9,'end','2021-01-01 19:59:00');
COMMIT;

WITH counted_ranges AS (
    SELECT
        date AS start_date,
        LEAD(date) OVER (ORDER BY date) AS end_date,
        COUNT(*) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS simultaneous_processes
    FROM events
)
SELECT start_date AS start, end_date AS end, MAX(simultaneous_processes) AS count
FROM counted_ranges
WHERE simultaneous_processes = (SELECT MAX(simultaneous_processes) FROM counted_ranges)
LIMIT 1;

WITH counted_ranges AS (
    SELECT
        date AS start_date,
        LEAD(date) OVER (ORDER BY date) AS end_date,
        COUNT(*) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS simultaneous_processes
    FROM events
)
SELECT start_date AS start, end_date AS end, simultaneous_processes AS count
FROM counted_ranges
WHERE simultaneous_processes = (SELECT MAX(simultaneous_processes) FROM counted_ranges)
ORDER BY start_date DESC
LIMIT 1;

WITH counted_ranges AS (
    SELECT
        date AS start_date,
        LEAD(date) OVER (ORDER BY date) AS end_date,
        COUNT(*) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS simultaneous_processes
    FROM events
)
SELECT MIN(start_date) AS first_start, MAX(end_date) AS last_end
FROM counted_ranges
WHERE simultaneous_processes = (SELECT MAX(simultaneous_processes) FROM counted_ranges);


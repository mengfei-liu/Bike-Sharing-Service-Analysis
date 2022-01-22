/* 
	Bike Sharing Service
*/

/*	Question 1	*/
-- 1.1 The total number of trips for the years of 2016.
-- Look at the total count of trips grouped by year 2016
SELECT 
    YEAR(start_date), COUNT(*) AS total_num
FROM
    trips
WHERE
    YEAR(start_date) = 2016
GROUP BY YEAR(start_date);
-- Get total number: 3917401 from running the query.

-- works without group by
SELECT 
    YEAR(start_date), COUNT(*) AS total_num
FROM
    trips
WHERE
    YEAR(start_date) = 2016;
    
-- Using Having instead of where
SELECT 
    YEAR(start_date) AS myyear, COUNT(*) AS total_num
FROM
    trips
GROUP BY YEAR(start_date)
HAVING myyear = 2016;


-- 1.2 The total number of trips for the years of 2017.
-- Look at the total count of trips grouped by year 2017
SELECT 
    YEAR(start_date), COUNT(*)
FROM
    trips
WHERE
    YEAR(start_date) = 2017
GROUP BY YEAR(start_date);
-- Get total number: 4666765 from running the query.

-- 1.3 The total number of trips for the years of 2016 broken-down by month.
-- Assume that the count is based on the start date.
SELECT 
    YEAR(start_date), 
    MONTH(start_date), 
    COUNT(*) AS Trips_num
FROM
    trips
WHERE
    YEAR(start_date) = 2016
GROUP BY MONTH(start_date);

SELECT 
	YEAR(start_date) AS myYear,
	MONTH(start_date) AS myMonth,
	COUNT(*) AS Trip_Counts
FROM
	trips
GROUP BY myYear , myMonth
having myYear = 2016;


-- Get the table from running the query:
/*
	# YEAR(start_date)	MONTH(start_date)	trips_num
				2016		4				189923
				2016		5				561077
				2016		6				631503
				2016		7				699248
				2016		8				672778
				2016		9				620263
				2016		10				392480
				2016		11				150129

*/

-- 1.4 The total number of trips for the years of 2017 broken-down by month.
-- Assume that the count is based on the start date.
SELECT 
    YEAR(start_date), 
    MONTH(start_date), 
    COUNT(*) AS Trips_num
FROM
    trips
WHERE
    YEAR(start_date) = 2017
GROUP BY YEAR(start_date) , MONTH(start_date);
-- Get the table from running the query:
/*
	# YEAR(start_date)	MONTH(start_date)	trips_num
				2017		4				195662
				2017		5				587447
				2017		6				741835
				2017		7				860732
				2017		8				839938
				2017		9				731851
				2017		10				559506
				2017		11				149794

*/

-- 1.5 The average number of trips a day for each year-month combination in the dataset.
-- Assume that only those days have records of trip can be counted. 
-- The reason for those without records is that bixi could be under maintenance or not open to the public, etc.
/* 
SELECT 
	DATE(start_date) AS Each_Day, COUNT(*) AS Total_Trips_EachDay	-- trips for each day
FROM
	trips
GROUP BY Each_Day;
*/

SELECT 
    DATE_FORMAT(temp_Table.Each_Day, '%Y-%m') AS Each_Year_Month,
    SUM(temp_Table.Total_Trips_EachDay) AS Total_Trips_PerMonth,
    AVG(temp_Table.Total_Trips_EachDay) AS Avg_Trips_PerDay	-- Averger Trips per Day
FROM
    (
		SELECT 
			DATE(start_date) AS Each_Day, COUNT(*) AS Total_Trips_EachDay	-- trips for each day
		FROM
			trips
		GROUP BY Each_Day
    ) AS temp_Table
GROUP BY Each_Year_Month;
-- Get the table from running the query:
/*
	# Each_Year_Month	Total_Trips_PerMonth	Avg_Trips_PerDay
		2016-04				189923					11870.1875
		2016-05				561077					18099.2581
		2016-06				631503					21050.1000
		2016-07				699248					22556.3871
		2016-08				672778					21702.5161
		2016-09				620263					20675.4333
		2016-10				392480					12660.6452
		2016-11				150129					10008.6000
		2017-04				195662					12228.8750
		2017-05				587447					18949.9032
		2017-06				741835					24727.8333
		2017-07				860732					27765.5484
		2017-08				839938					27094.7742
		2017-09				731851					24395.0333
		2017-10				559506					18048.5806
		2017-11				149794					9986.2667
*/

-- 1.6 Save your query results from the previous question (Q1.5) by creating a table called.
DROP TABLE IF EXISTS working_table1;
CREATE TABLE working_table1 AS
(
	SELECT 
		DATE_FORMAT(temp_Table.Each_Day, '%Y-%m') AS Each_Year_Month,
		SUM(temp_Table.Total_Trips_EachDay) AS Total_Trips_PerMonth, 
		AVG(temp_Table.Total_Trips_EachDay) AS Avg_Trips_PerDay	-- Averger Trips per Day
	FROM
		(
			SELECT 
				DATE(start_date) AS Each_Day, COUNT(*) AS Total_Trips_EachDay	-- trips for each day
			FROM
				trips
			GROUP BY Each_Day
		) AS temp_Table
	GROUP BY Each_Year_Month
);

SELECT * 
FROM working_table1;
-- Queried from 'working_table1' get:
/*
	# Each_Year_Month	Total_Trips_PerMonth	Avg_Trips_PerDay
		2016-04				189923					11870.1875
		2016-05				561077					18099.2581
		2016-06				631503					21050.1000
		2016-07				699248					22556.3871
		2016-08				672778					21702.5161
		2016-09				620263					20675.4333
		2016-10				392480					12660.6452
		2016-11				150129					10008.6000
		2017-04				195662					12228.8750
		2017-05				587447					18949.9032
		2017-06				741835					24727.8333
		2017-07				860732					27765.5484
		2017-08				839938					27094.7742
		2017-09				731851					24395.0333
		2017-10				559506					18048.5806
		2017-11				149794					9986.2667
*/

/**********************************************************/

/*	Question 2	*/
-- 2.1 The total number of trips in the year 2017 broken-down by membership status (member/non-member).
SELECT 
	is_member, 
    IF(is_member = 1, 'Member','Not Member') AS Member_Status,
	COUNT(*) AS Trips_num
FROM trips  
WHERE year(start_date) = 2017 
GROUP BY is_member;

SELECT 
	temp_table.Member_Status AS Member_Status, 
    temp_table.Trip_Counts AS Trip_Counts
FROM
(
SELECT 
	YEAR(trips.start_date) AS myYear,
	IF(is_member = 1, 'Member', 'Non-Member') AS Member_Status,
    COUNT(*) AS Trip_Counts
FROM trips
GROUP BY myYear, is_member
HAVING myYear = 2017) AS temp_table;

-- Get the table from running the query:
/*
	# is_member	Member_Status	Trips_num
			1		Member		3784682
			0		Not Member	882083
*/

-- 2.2 The fraction of total trips that were done by members for the year of 2017 broken-down by month.
SELECT 
	Members.MyMonth AS The_Month, Members.Member_Amount, Total.Total_Amount, (Members.Member_Amount / Total.Total_Amount) AS Fraction
FROM
(
	-- Get the total trip count made by members
	SELECT month(start_date) AS MyMonth, COUNT(*) as Member_Amount
	FROM trips  
	WHERE year(start_date) = 2017 AND is_member = 1 
    GROUP BY month(start_date)
) Members 
INNER JOIN 
(
	-- Get the total trip count
	SELECT month(start_date) AS MyMonth, COUNT(*) as Total_Amount
	FROM trips  
	WHERE year(start_date) = 2017 
    GROUP BY month(start_date)
) Total 
ON Members.MyMonth = Total.MyMonth;
-- Get the table from running the query:
/*
# The_Month	Member_Amount	Total_Amount	Fraction
		4		163417			195662		0.8352
		5		481540			587447		0.8197
		6		599509			741835		0.8081
		7		657865			860732		0.7643
		8		656049			839938		0.7811
		9		604358			731851		0.8258
		10		483445			559506		0.8641
		11		138499			149794		0.9246
*/

/**********************************************************/

/*	Question 3	*/
-- 3.1 Which time of the year the demand for Bixi bikes is at its peak?
SELECT 
	Members.MyMonth AS The_Month, Members.Member_Amount, Total.Total_Amount, (Members.Member_Amount / Total.Total_Amount) AS Fraction
FROM
(
	-- Get the total trip count made by members
	SELECT month(start_date) AS MyMonth, COUNT(*) as Member_Amount
	FROM trips  
	WHERE year(start_date) = 2017 AND is_member = 1 
    GROUP BY month(start_date)
) Members 
INNER JOIN 
(
	-- Get the total trip count
	SELECT month(start_date) AS MyMonth, COUNT(*) as Total_Amount
	FROM trips  
	WHERE year(start_date) = 2017 
    GROUP BY month(start_date)
) Total 
ON Members.MyMonth = Total.MyMonth
ORDER BY Total.Total_Amount DESC;
-- Get the table from running the query:
/*
# The_Month	Member_Amount	Total_Amount	Fraction
		7		657865			860732		0.7643
		8		656049			839938		0.7811
		6		599509			741835		0.8081
		9		604358			731851		0.8258
		5		481540			587447		0.8197
		10		483445			559506		0.8641
		4		163417			195662		0.8352
		11		138499			149794		0.9246
*/
-- From the table we can see the demand for Bixi bikes reached the peak at July

-- 3.2 If you were to offer non-members a special promotion in an attempt to convert them to members, when would you do it?
SELECT 
	Members.MyMonth AS The_Month, Members.Member_Amount, Total.Total_Amount, (Members.Member_Amount / Total.Total_Amount) AS Fraction
FROM
(
	-- Get the total trip count made by members
	SELECT month(start_date) AS MyMonth, COUNT(*) as Member_Amount
	FROM trips  
	WHERE year(start_date) = 2017 AND is_member = 1 
    GROUP BY month(start_date)
) Members 
INNER JOIN 
(
	-- Get the total trip count
	SELECT month(start_date) AS MyMonth, COUNT(*) as Total_Amount
	FROM trips  
	WHERE year(start_date) = 2017 
    GROUP BY month(start_date)
) Total 
ON Members.MyMonth = Total.MyMonth
ORDER BY Fraction;
-- Get the table from running the query:
/*
# The_Month	Member_Amount	Total_Amount	Fraction
	7			657865			860732		0.7643
	8			656049			839938		0.7811
	6			599509			741835		0.8081
	5			481540			587447		0.8197
	9			604358			731851		0.8258
	4			163417			195662		0.8352
	10			483445			559506		0.8641
	11			138499			149794		0.9246
*/
-- From the table we can see in July the Bixi bikes have the highest usage. However, the bikes used by members is the lowest.
-- It shows that more nonmembers are interested in the Bixi bikes. Therefore, July is a good month to offer non-members a special promotion.

/**********************************************************/

/*	Question 4	*/
-- 4.1 What are the names of the 5 most popular starting stations? Solve this problem without using a subquery.
SELECT 
	stations.name AS Station_Name, 
	start_station_code AS Station_Code, 
	COUNT(*) AS Count
FROM trips 
INNER JOIN stations 
ON trips.start_station_code = stations.code
GROUP BY start_station_code, stations.name
ORDER BY COUNT(*) DESC 
LIMIT 5;
-- Get the table from running the query:
/*
	# Station_Name										Station_Code	Count
	Mackay / de Maisonneuve									6100		97150
	Métro Mont-Royal (Rivard / du Mont-Royal)				6184		81279
	Métro Place-des-Arts (de Maisonneuve / de Bleury)		6078		78848
	Métro Laurier (Rivard / Laurier)						6136		76813
	Métro Peel (de Maisonneuve / Stanley)					6064		72298
*/
-- Duration: 7.454 sec / 0.000 sec

-- 4.2 Solve the same question as Q4.1, but now use a subquery. Is there a difference in query run time between 4.1 and 4.2?
SELECT 
	stations.name AS Station_Name, 
    stations.code AS Station_Code, 
    A.Count AS Count
FROM
(
	SELECT 
		start_station_code, 
		COUNT(*) AS Count 
    FROM trips 
    GROUP BY start_station_code 
    ORDER BY Count DESC LIMIT 5
)  A
JOIN stations 
ON A.start_station_code = stations.code;
-- Get the table from running the query:
/*
	# Station_Name										Station_Code	Count
	Mackay / de Maisonneuve									6100		97150
	Métro Mont-Royal (Rivard / du Mont-Royal)				6184		81279
	Métro Place-des-Arts (de Maisonneuve / de Bleury)		6078		78848
	Métro Laurier (Rivard / Laurier)						6136		76813
	Métro Peel (de Maisonneuve / Stanley)					6064		72298
*/
-- Duration: 3.359 sec / 0.000 sec

/**********************************************************/

/*	Question 5	*/
-- 5.1 How is the number of starts and ends distributed for the station Mackay / de Maisonneuve throughout the day?
SELECT 
	startTable.Station_Name,
    startTable.Station_Code,
    startTable.time_of_day,
    startTable.Start_Count,
    endTable.End_Count
FROM
(
	-- Get start trip count
	SELECT 
		stations.name AS Station_Name, 
        stations.code AS Station_Code,
        COUNT(*) AS Start_Count, 
		CASE
			WHEN HOUR(start_date) BETWEEN 7 AND 11 THEN "morning"
			WHEN HOUR(start_date) BETWEEN 12 AND 16 THEN "afternoon"
			WHEN HOUR(start_date) BETWEEN 17 AND 21 THEN "evening"
			ELSE "night"
		END AS "time_of_day"
	FROM trips
	LEFT JOIN stations
	ON stations.code = trips.start_station_code
	WHERE stations.name = 'Mackay / de Maisonneuve'
	GROUP BY time_of_day
) AS startTable
INNER JOIN
(
	-- Get End trip count
	SELECT COUNT(*) AS End_Count, 
		CASE
		WHEN HOUR(start_date) BETWEEN 7 AND 11 THEN "morning"
		WHEN HOUR(start_date) BETWEEN 12 AND 16 THEN "afternoon"
		WHEN HOUR(start_date) BETWEEN 17 AND 21 THEN "evening"
		ELSE "night"
		END AS "time_of_day" 
	FROM trips
	LEFT JOIN stations
	ON stations.code = trips.end_station_code
	WHERE stations.name = 'Mackay / de Maisonneuve'
	GROUP BY time_of_day
) AS endTable
ON startTable.time_of_day = endTable.time_of_day;
-- Get the table from running the query:
/*
# Station_Name				Station_Code	time_of_day		Start_Count		End_Count
Mackay / de Maisonneuve			6100		evening				36781		31011
Mackay / de Maisonneuve			6100		afternoon			30718		30817
Mackay / de Maisonneuve			6100		night				12267		9949
Mackay / de Maisonneuve			6100		morning				17384		27351
*/

-- 5.2 Explain the differences you see and discuss why the numbers are the way they are.


/**********************************************************/

/*	Question 6	*/
-- 1st, write a query that counts the number of starting trips per station.
SELECT 
	start_station_code, 
	COUNT(*)
FROM trips
GROUP BY trips.start_station_code;

-- 2nd, write a query that counts, for each station, the number of round trips.
SELECT start_station_code, COUNT(*) from trips
where start_station_code = end_station_code
GROUP BY start_station_code;

-- 3rd, Combine the above queries and calculate the fraction of round trips to the total number of starting trips for each station.
SELECT 
	stations.name,
    amt_startingTrips.start_station_code, 
    amt_roundTrips.count AS Total_Round_Trips,
    amt_startingTrips.count  AS Total_trips,  
    (amt_roundTrips.count / amt_startingTrips.count) * 100 AS fraction_roundTrip
FROM
(
	SELECT start_station_code, COUNT(*) AS count
	FROM trips
	GROUP BY start_station_code
)	AS amt_startingTrips
LEFT JOIN
(
	SELECT start_station_code, COUNT(*) AS count
    from trips
	where start_station_code = end_station_code
	GROUP BY start_station_code
) AS amt_roundTrips
ON amt_roundTrips.start_station_code = amt_startingTrips.start_station_code
LEFT JOIN stations
ON amt_roundTrips.start_station_code = stations.code
ORDER BY fraction_roundTrip DESC;

-- 4th, Filter down to stations with at least 500 trips originating from them and having at least 10% of their trips as round trips.
SELECT 
	stations.name, 
	Starting_Trips.start_station_code, 
	Round_Trips.count AS Total_Round_Trips, 
	Starting_Trips.count AS Total_trips, 
	(Round_Trips.count / Starting_Trips.count) * 100 AS fraction_roundTrip -- 3rd, calculate the fraction of round trips to the total number of starting trips for each station
FROM
(
	SELECT 										-- 1st, a query that counts the number of starting trips per station.
		start_station_code, 
        COUNT(*) AS count
	FROM trips
	GROUP BY start_station_code
)	AS Starting_Trips
LEFT JOIN										-- 3rd, Combine 2 querys together 
(
	SELECT 										-- 2nd, a query that counts, for each station, the number of round trips.
		start_station_code, 
        COUNT(*) AS count
    from trips
	WHERE start_station_code = end_station_code
	GROUP BY start_station_code
) AS Round_Trips
ON Round_Trips.start_station_code = Starting_Trips.start_station_code
LEFT JOIN stations
ON Round_Trips.start_station_code = stations.code
WHERE Starting_Trips.count >= 500 AND (Round_Trips.count / Starting_Trips.count) * 100 >= 10 -- 4th, Filter down to stations with at least 500 trips originating from them and having at least 10% of their trips as round trips
ORDER BY (Round_Trips.count / Starting_Trips.count) * 100 DESC; 
-- Get the table from running the query:
/*
	# name										start_station_code	Total_Round_Trips	Total_trips		fraction_roundTrip
Métro Jean-Drapeau										6501			8658				28672			30.1967
Métro Angrignon											7048			559					2398			23.3111
Berlioz / de l'Île des Soeurs							6428			1072				5246			20.4346
LaSalle / 4e avenue										7015			600					2991			20.0602
Basile-Routhier / Gouin									6736			330					1708			19.3208
Parc Plage												6359			1145				6201			18.4648
Gare Canora												7007			437					2439			17.9172
LaSalle / Sénécal										6714			464					3151			14.7255
Casino de Montréal										6502			882					6138			14.3695
Quai de la navette fluviale								6109			883					6417			13.7603
CHSLD Éloria-Lepage (de la Pépinière / de Marseille)	7075			60					475				12.6316
de la Commune / Place Jacques-Cartier					6026			5622				50822			11.0621
Jacques-Le Ber / de la Pointe Nord						6016			300					2719			11.0335
Place du Commerce										6429			927					8569			10.8181
Collège Édouard-Montpetit								5006			144					1439			10.0069
28e avenue / Rosemont									6731			426					4385			9.7149
Fleury / Lajeunesse										6422			334					3551			9.4058
LaSalle / Crawford										6712			273					2917			9.3589
...														...				...					...				...
*/

/*****************************************/
/*	alternative way	*/
/*
	1st, count the stations with at least 500 starting trips
    2nd, filter down to the sation with at least 500 starting trips
    3rd, filter down to only having round trips
    4th, count the amount of round trips
    5th, calculate the fraction of round trips to the total number of starting trips for each station
    6th, combine with station table, filter down to at least 10% of their trips as round trip
*/
SELECT 													
	stations.name, 
    B.start_code, 
    B.Total_RoundTrip_Count, 
    B.Total_Count,
    B.Fraction
FROM
(
	SELECT 
        COUNT(*) AS Total_RoundTrip_Count,  					-- 4th, count the amount of round trips
        A.Total_Trips_Count AS Total_Count,	
		(COUNT(*) / A.Total_Trips_Count) * 100 AS Fraction,  	-- 5th, calculate the fraction of round trips to the total number of starting trips for each station
        trips.start_station_code AS start_code
	FROM trips
	INNER JOIN 													-- 2nd, filter down to the sation with at least 500 starting trips
	(
		SELECT *												-- 1st, count the stations with at least 500 starting trips
		FROM
		(
			
			SELECT 
			start_station_code, 
			COUNT(*) AS Total_Trips_Count,
			end_station_code
			FROM trips
			GROUP BY trips.start_station_code
		) AS Total_Trips
		WHERE Total_Trips.Total_Trips_Count >= 500
	) A
	ON trips.start_station_code = A.start_station_code
	WHERE trips.start_station_code = trips.end_station_code 	-- 3rd, filter down to only having round trips
	GROUP BY trips.start_station_code
) B
INNER JOIN stations
ON B.start_code = stations.code						
WHERE (B.Total_RoundTrip_Count / B.Total_Count) * 100 >= 10		-- 6th, combine with station table, filter down to at least 10% of their trips as round trip
ORDER BY Fraction DESC;

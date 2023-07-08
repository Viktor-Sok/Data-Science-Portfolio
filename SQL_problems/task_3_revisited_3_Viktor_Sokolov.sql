SELECT SUBSTR(yearmonth, 1,4) AS year, SUBSTR(yearmonth,5,2) AS month, day_diff, CAST(comebacks/total_by_month * 100 AS SIGNED) AS retention_percent FROM 
( SELECT EXTRACT(year_month FROM installed_at) AS yearmonth, COUNT(user_id) AS total_by_month FROM user GROUP BY 1 ) AS X1
INNER JOIN 
( SELECT EXTRACT(year_month FROM installed_at) AS yearmonth, created_at - installed_at AS  day_diff, COUNT( DISTINCT user_id) AS comebacks FROM  user INNER JOIN client_session USING (user_id) WHERE created_at - installed_at  IN (1,3,7) group by 1,2 ) AS X2
USING (yearmonth) ORDER BY 1,2,3;



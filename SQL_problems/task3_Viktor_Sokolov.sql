-- User retention
/* 
Предположения о структуре таблиц (используется DBMS MySQL):
Таблица user: 
	Столбец user_id содержит не повторяющиеся значения и нет пропущенных значений
	Столбец installed_at содержит дату формата DATETIME, пропусков нет. 

Таблица client_session:
	Столбец user_id может содержать одинаковые значения (пользователь использовал преложения более одного раза) и не все user_id
	из таблицы user могут быть в данном столюце,т.к. некоторые пользователи использовали приложения 0 раз, пропусков значений нет.
	Столбец created_at содержит дату в формате DATETIME, пропусков значений нет.
*/
/*
Расчёт ведётся для среднего Retention 1,3,7 дня за прошедший месяц от NOW()-37 до NOW()-7
Retention измеряем от 0 до 1 (что соответствуйет 0 и 100% соответственно)
*/

SELECT comebacks_table.time_diff AS day_difference,
       AVG(comebacks_table.comebacks) / AVG(total_installation_per_day.total_number_of_users_installing_per_day)  AS retention_rate

FROM

------subquery_1
  (SELECT DATE(installed_at) AS installation_date, -- DATE() is used to extract only date without time from DATETIME format
          COUNT( DISTINCT user_id) AS total_number_of_users_installing_per_day
   FROM user
   WHERE installed_at >= date_sub(now(), INTERVAL 37 DAY)
     AND installed_at <= date_sub(now(), INTERVAL 7 DAT)
   GROUP BY 1) AS total_installation_per_day -- table which shows how many users installed an App per each day in a month.
------subquery_1

LEFT JOIN -- some users mighnt not use an App at all, LEFT JOIN keeps those users

------subquery_2
( SELECT DATE(installed_at) AS installation_date,
          TIMESTAMPDIFF(DAY, cs.created_at, user.installed_at)) AS time_diff, 
          COUNT( DISTINCT user_id) AS comebacks --counting people who used App  again (retention rate  = comebacks /total_number_of_users_installing_per_day)
     FROM USER
     LEFT JOIN client_session AS cs ON cs.user_id=user.user_id
     WHERE 1=1 -- matching by installation_date
     AND TIMESTAMPDIFF(DAY, cs.created_at, user.installed_at)) IN (1,3,7) -- we are interested in time_diff =1,3,7 days
     AND installed_at >= date_sub(now(), INTERVAL 37 DAY)
     AND installed_at <= date_sub(now(), INTERVAL 7 DAT)
   GROUP BY 1, 2) AS comebacks_table 
------subquery_2

ON total_installation_per_day.installation_date = comebacks_table.installation_date
GROUP BY 1 --matching by comebacks_table.time_diff = 1,3,7 and averaging
ORDER BY 1 --ordering by comebacks_table.time_diff

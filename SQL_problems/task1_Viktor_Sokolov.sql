-- The least populated city 

--AT LEAST TWO SOLUTIONS POSSIBLE
 
--(using subquery + aggregate function MIN())
SELECT city FROM city_population WHERE 
population = ( SELECT MIN(population) FROM city_population);

--(using ascending ordering and showingonly first row)
SELECT city FROM city_population ORDER BY population LIMIT 1;

 

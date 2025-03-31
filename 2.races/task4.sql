-- Задание 4

SELECT 
    c.name AS car_name,
    c.class AS car_class,
    AVG(r.position) AS average_position,
    COUNT(r.race) AS race_count,
    cl.country AS car_country
FROM Cars c
JOIN Classes cl ON c.class = cl.class
JOIN Results r ON c.name = r.car
GROUP BY c.name, c.class, cl.country
HAVING AVG(r.position) < (
    SELECT AVG(r2.position)
    FROM Results r2
    JOIN Cars c2 ON r2.car = c2.name
    WHERE c2.class = c.class
)
AND (
    SELECT COUNT(DISTINCT c3.name)
    FROM Cars c3
    WHERE c3.class = c.class
) > 1
ORDER BY car_class, average_position;
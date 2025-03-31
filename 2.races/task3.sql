-- Запрос задачи 3

-- Создаем временную таблицу со всеми необходимыми колонками
-- Колонки количество гонок по классам и ранк средних позиций в классе создается с помощью оконных функций

WITH ranked_classes AS (
    SELECT 
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count,
        cl.country AS car_country,
        COUNT(*) OVER (PARTITION BY c.class) AS total_races,
        RANK() OVER (ORDER BY AVG(r.position)) AS class_rank
    FROM Cars c
    JOIN Classes cl ON c.class = cl.class
    JOIN Results r ON c.name = r.car
    GROUP BY c.name, c.class, cl.country
)
SELECT 
    car_name,
    car_class,
    average_position,
    race_count,
    car_country,
    total_races
FROM ranked_classes
WHERE class_rank = 1
ORDER BY car_class;
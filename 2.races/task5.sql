-- Задание 5

-- Сначала вычисляем средние позиции автомобилей и отмечаем те, у которых позиция > 3.0
-- Затем ранжируем по количеству "плохих" автомобилей и выбираем классы с максимальным числом
-- Используя оконные функции RANK и SUM обходимся без сложных подзапросов

WITH car_stats AS (
    SELECT 
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS race_count,
        cl.country AS car_country,
        CASE WHEN AVG(r.position) > 3.0 THEN 1 ELSE 0 END AS is_low_position
    FROM Cars c
    JOIN Classes cl ON c.class = cl.class
    JOIN Results r ON c.name = r.car
    GROUP BY c.name, c.class, cl.country
),
class_stats AS (
    SELECT 
        car_class,
        SUM(is_low_position) AS low_position_count,
        SUM(race_count) AS total_races,
        RANK() OVER (ORDER BY SUM(is_low_position) DESC) AS rank_by_low_pos
    FROM car_stats
    GROUP BY car_class
)
SELECT 
    cs.car_name,
    cs.car_class,
    cs.avg_position,
    cs.race_count,
    cs.car_country,
    cls.total_races,
    cls.low_position_count
FROM car_stats cs
JOIN class_stats cls ON cs.car_class = cls.car_class
WHERE cls.rank_by_low_pos = 1 AND cs.avg_position > 3.0
ORDER BY cls.low_position_count DESC;
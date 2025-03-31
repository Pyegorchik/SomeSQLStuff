-- Запрос для задачи 2

-- Создаем CTE где объединяем несколько таблицы, вычисляем необходимые показатели, такие как средняя позиция и количество гонок и добавляем остальные колонки нужные по заданию
-- В основном запросе из созданной таблицы выбираем автомобили с наименьшей средней позицией, сортируем по имени и выводим топ 1 

WITH CarStats AS (
    SELECT 
        c.name AS car_name,
        cl.class AS car_class,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count,
        cl.country AS car_country
    FROM Cars c
    JOIN Classes cl ON c.class = cl.class
    JOIN Results r ON c.name = r.car
    GROUP BY c.name, cl.class, cl.country
)
SELECT *
FROM CarStats
WHERE average_position = (SELECT MIN(average_position) FROM CarStats)
ORDER BY car_name
LIMIT 1;
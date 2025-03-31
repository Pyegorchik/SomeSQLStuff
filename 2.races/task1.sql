-- Запрос для задачи 1.
-- Создаем запрос c CTE, в котором вычисляем среднюю позицию и количество гонок для каждого автомобиля.
-- Из CTE находим минимальную среднюю позицию для каждого класса
-- В основном запросе объединяем таблицы, получаем автомобили с наименьшей средней позицией в своем классе и сортируем согласно этим позициям

WITH CarResults AS (
    SELECT 
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count
    FROM Cars c
    JOIN Results r ON c.name = r.car
    GROUP BY c.name, c.class
),
MinAvgPositions AS (
    SELECT 
        car_class,
        MIN(average_position) AS min_avg_position
    FROM CarResults
    GROUP BY car_class
)
SELECT 
    cr.car_name,
    cr.car_class,
    cr.average_position,
    cr.race_count
FROM CarResults cr
JOIN MinAvgPositions map ON cr.car_class = map.car_class AND cr.average_position = map.min_avg_position
ORDER BY cr.average_position;
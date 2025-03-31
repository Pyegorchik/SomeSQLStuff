-- Задание 3
-- Создаем СTE для категоризации отелей, затем другое для связи клиентов с отелями и агрегации предпочтений
-- Часто повторяется CASE, можно было бы сделать отдельную колонку для названий и для их ранга

WITH HotelCategories AS (
    SELECT 
        H.ID_hotel,
        H.Name,
        CASE 
            WHEN AVG(R.Price) < 175 THEN 'Дешевый'
            WHEN AVG(R.Price) BETWEEN 175 AND 300 THEN 'Средний'
            ELSE 'Дорогой'
        END AS Category
    FROM Hotel H
    JOIN Room R ON H.ID_hotel = R.ID_hotel
    GROUP BY H.ID_hotel, H.Name
),
CustomerHotelTypes AS (
    SELECT 
        C.ID_customer,
        C.Name,
        MAX(CASE WHEN HC.Category = 'Дорогой' THEN 3 
                 WHEN HC.Category = 'Средний' THEN 2 
                 ELSE 1 END) AS HotelTypePriority,
        GROUP_CONCAT(DISTINCT HC.Name ORDER BY HC.Name SEPARATOR ', ') AS VisitedHotels
    FROM Customer C
    JOIN Booking B ON C.ID_customer = B.ID_customer
    JOIN Room R ON B.ID_room = R.ID_room
    JOIN HotelCategories HC ON R.ID_hotel = HC.ID_hotel
    GROUP BY C.ID_customer, C.Name
)
SELECT 
    CHT.ID_customer,
    CHT.Name,
    CASE 
        WHEN CHT.HotelTypePriority = 3 THEN 'Дорогой'
        WHEN CHT.HotelTypePriority = 2 THEN 'Средний'
        ELSE 'Дешевый'
    END AS Preferred_hotel_type,
    CHT.VisitedHotels
FROM CustomerHotelTypes CHT
ORDER BY CHT.HotelTypePriority;
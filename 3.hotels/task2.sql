-- Задание 2

-- Сделали 2 таблички используя WITH, в основном запросе соединили. Можно эффективнее, но так читать приятнее

WITH MultiHotelCustomers AS (
    SELECT 
        C.ID_customer,
        C.Name,
        COUNT(B.ID_booking) AS TotalBookings,
        COUNT(DISTINCT R.ID_hotel) AS UniqueHotels,
        SUM(R.Price * DATEDIFF(B.Check_out_date, B.Check_in_date)) AS TotalSpent
    FROM Customer C
    JOIN Booking B ON C.ID_customer = B.ID_customer
    JOIN Room R ON B.ID_room = R.ID_room
    GROUP BY C.ID_customer, C.Name
    HAVING COUNT(DISTINCT R.ID_hotel) > 1 AND COUNT(B.ID_booking) > 2
),
BigSpenders AS (
    SELECT 
        C.ID_customer,
        C.Name,
        SUM(R.Price * DATEDIFF(B.Check_out_date, B.Check_in_date)) AS TotalSpent,
        COUNT(B.ID_booking) AS TotalBookings
    FROM Customer C
    JOIN Booking B ON C.ID_customer = B.ID_customer
    JOIN Room R ON B.ID_room = R.ID_room
    GROUP BY C.ID_customer, C.Name
    HAVING SUM(R.Price * DATEDIFF(B.Check_out_date, B.Check_in_date)) > 500
)
SELECT 
    m.ID_customer,
    m.Name,
    m.TotalBookings,
    m.TotalSpent,
    m.UniqueHotels
FROM MultiHotelCustomers m
JOIN BigSpenders b ON m.ID_customer = b.ID_customer
ORDER BY m.TotalSpent ASC;
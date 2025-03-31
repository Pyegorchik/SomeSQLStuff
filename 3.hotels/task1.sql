-- Задание 1

-- Запрос понятный без дополнительных объяснений, можно было вместо GROUP_CONCAT использовать STRING_AGG

SELECT 
    C.Name,
    C.Email,
    C.Phone,
    COUNT(B.ID_booking) AS TotalBookings,
    GROUP_CONCAT(DISTINCT H.Name ORDER BY H.Name SEPARATOR ', ') AS HotelsList,
    AVG(DATEDIFF(B.Check_out_date, B.Check_in_date)) AS AvgStayDuration
FROM Customer C
JOIN Booking B ON C.ID_customer = B.ID_customer
JOIN Room R ON B.ID_room = R.ID_room
JOIN Hotel H ON R.ID_hotel = H.ID_hotel
GROUP BY C.ID_customer, C.Name, C.Email, C.Phone
HAVING COUNT(DISTINCT H.ID_hotel) > 1
    AND COUNT(B.ID_booking) > 2
ORDER BY TotalBookings DESC;
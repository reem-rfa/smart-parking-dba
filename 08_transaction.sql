USE smart_parking;
GO

SELECT spot_id, spot_number, status
FROM dbo.parking_spots
ORDER BY spot_id;

SELECT driver_id, full_name
FROM dbo.drivers
ORDER BY driver_id;

SELECT spot_id, driver_id, start_time, end_time, reservation_status
FROM dbo.reservations
ORDER BY start_time DESC;
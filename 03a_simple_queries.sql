USE smart_parking;
GO

-- Q1: EV-Charging spots that are available
SELECT s.spot_id, s.spot_number, l.lot_name
FROM parking_spots s JOIN parking_lots l ON l.lot_id = s.lot_id
WHERE s.spot_type = 'EV-Charging' AND s.status = 'Available';

-- Q2: lots ordered by hourly rate
SELECT lot_name, district, hourly_rate FROM parking_lots ORDER BY hourly_rate DESC;

-- Q3: active reservations today
SELECT reservation_id, spot_id, driver_id, start_time, end_time
FROM reservations
WHERE reservation_status = 'Active'
  AND start_time <  DATEADD(DAY, 1, CAST(GETDATE() AS DATE))
  AND end_time   >= CAST(GETDATE() AS DATE);

USE smart_parking;
GO

SELECT r.reservation_id, r.driver_id, r.spot_id
FROM reservations r
LEFT JOIN drivers       d ON d.driver_id = r.driver_id
LEFT JOIN parking_spots s ON s.spot_id   = r.spot_id
WHERE d.driver_id IS NULL OR s.spot_id IS NULL;
GO

SELECT d.full_name,
       d.license_plate,
       s.spot_number,
       l.lot_name
FROM reservations r
JOIN drivers       d ON d.driver_id = r.driver_id
JOIN parking_spots s ON s.spot_id   = r.spot_id
JOIN parking_lots  l ON l.lot_id    = s.lot_id
ORDER BY r.reservation_id;
GO

SELECT p.payment_id,
       p.total_amount,
       p.is_paid,
       r.start_time,
       r.end_time,
       s.spot_type,
       d.full_name
FROM payments p
JOIN reservations  r ON r.reservation_id = p.reservation_id
JOIN parking_spots s ON s.spot_id        = r.spot_id
JOIN drivers       d ON d.driver_id      = r.driver_id
ORDER BY p.payment_id;
GO

SELECT l.lot_name,
       COUNT(DISTINCT r.reservation_id) AS total_reservations,
       COUNT(DISTINCT CASE WHEN s.status = 'Occupied' THEN s.spot_id END) AS occupied_now
FROM parking_lots l
JOIN parking_spots s      ON s.lot_id  = l.lot_id
LEFT JOIN reservations r  ON r.spot_id = s.spot_id
GROUP BY l.lot_id, l.lot_name
ORDER BY total_reservations DESC;
GO

SELECT d.full_name,
       d.license_plate,
       COUNT(r.reservation_id)        AS total_reservations,
       COUNT(DISTINCT l.lot_id)       AS lots_visited,
       MAX(r.start_time)              AS last_reservation
FROM drivers d
LEFT JOIN reservations  r ON r.driver_id = d.driver_id
LEFT JOIN parking_spots s ON s.spot_id   = r.spot_id
LEFT JOIN parking_lots  l ON l.lot_id    = s.lot_id
GROUP BY d.driver_id, d.full_name, d.license_plate
ORDER BY total_reservations DESC, d.full_name;
GO

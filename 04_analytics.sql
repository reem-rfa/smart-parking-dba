USE smart_parking;
GO

SELECT
    l.lot_name,
    COUNT(DISTINCT r.reservation_id) AS reservations_count,
    COALESCE(
        SUM(CASE WHEN p.is_paid = 1 THEN p.total_amount ELSE 0 END),
        0
    ) AS paid_revenue
FROM dbo.parking_lots AS l
LEFT JOIN dbo.parking_spots AS s
    ON s.lot_id = l.lot_id
LEFT JOIN dbo.reservations AS r
    ON r.spot_id = s.spot_id
LEFT JOIN dbo.payments AS p
    ON p.reservation_id = r.reservation_id
GROUP BY l.lot_id, l.lot_name
ORDER BY paid_revenue DESC;

GO

-- Average parking duration in hours by spot type
SELECT
    s.spot_type,
    CAST(
        AVG(DATEDIFF(MINUTE, r.start_time, r.end_time) / 60.0)
        AS DECIMAL(10, 2)
    ) AS avg_parking_hours
FROM dbo.reservations AS r
JOIN dbo.parking_spots AS s
    ON s.spot_id = r.spot_id
WHERE r.reservation_status IN ('Active', 'Completed')
GROUP BY s.spot_type;
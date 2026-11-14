USE smart_parking;
GO

DECLARE @now DATETIME2(0) = SYSDATETIME();

INSERT INTO parking_lots (lot_name, district, city, hourly_rate) VALUES
(N'موقف العليا',           N'العليا',    N'الرياض',      10.00),
(N'موقف الملقا',           N'الملقا',    N'الرياض',       8.00),
(N'موقف حطين',             N'حطين',      N'الرياض',      12.00),
(N'موقف الكورنيش',         N'الشاطئ',    N'جدة',          9.00),
(N'موقف البلد',            N'البلد',     N'جدة',          6.00),
(N'موقف الروضة',           N'الروضة',    N'جدة',          7.50),
(N'موقف الكورنيش الشرقي',  N'الكورنيش',  N'الدمام',       5.00),
(N'موقف الراكة',           N'الراكة',    N'الخبر',        6.50),
(N'موقف العزيزية',         N'العزيزية',  N'مكة المكرمة', 15.00),
(N'موقف المروج',           N'المروج',    N'تبوك',         4.00);

INSERT INTO parking_spots (lot_id, spot_number, spot_type, status) VALUES
(1,  'A-101', 'Standard',    'Occupied'),
(1,  'A-102', 'EV-Charging', 'Available'),
(1,  'A-103', 'Handicapped', 'Available'),
(2,  'B-101', 'Standard',    'Reserved'),
(2,  'B-102', 'EV-Charging', 'Occupied'),
(3,  'C-101', 'Standard',    'Available'),
(3,  'C-102', 'EV-Charging', 'Available'),
(4,  'D-101', 'Standard',    'Occupied'),
(4,  'D-102', 'Handicapped', 'Available'),
(5,  'E-101', 'Standard',    'Available'),
(6,  'F-101', 'EV-Charging', 'Reserved'),
(7,  'G-101', 'Standard',    'Available'),
(8,  'H-101', 'Standard',    'Available'),
(9,  'J-101', 'Handicapped', 'Available'),
(10, 'K-101', 'Standard',    'Available');

INSERT INTO drivers (full_name, license_plate, phone, email) VALUES
(N'نورة العتيبي',   'ABC 1234', '0501112233', 'noura@example.com'),
(N'سارة القحطاني',  'BDR 5521', '0502223344', 'sarah@example.com'),
(N'خالد الشمري',    'KSA 7788', '0503334455', 'khalid@example.com'),
(N'ريم الحربي',     'RMH 4410', '0504445566', 'reem@example.com'),
(N'فهد الدوسري',    'FHD 9032', '0505556677', 'fahad@example.com'),
(N'لمى الزهراني',   'LMZ 2675', '0506667788', 'lama@example.com'),
(N'عبدالله المطيري', 'ABM 8146', '0507778899', 'abdullah@example.com'),
(N'هيفاء الغامدي',  'HFG 3359', '0508889900', 'haifa@example.com'),
(N'ماجد العنزي',    'MJD 6207', '0509990011', 'majed@example.com'),
(N'جود البلوي',     'JUD 1593', '0500001122', 'joud@example.com');

INSERT INTO reservations (spot_id, driver_id, start_time, end_time, reservation_status) VALUES
(1,  1,  '2026-11-01 08:00', '2026-11-01 11:00', 'Completed'),
(2,  2,  '2026-11-01 09:00', '2026-11-01 13:00', 'Completed'),
(4,  3,  '2026-11-02 10:00', '2026-11-02 12:00', 'Completed'),
(6,  4,  '2026-11-03 14:00', '2026-11-03 19:00', 'Completed'),
(8,  5,  '2026-11-04 16:00', '2026-11-04 18:00', 'Completed'),
(10, 6,  '2026-11-05 07:00', '2026-11-05 13:00', 'Completed'),
(12, 7,  '2026-11-06 12:00', '2026-11-06 15:00', 'Completed'),
(14, 8,  '2026-11-07 18:00', '2026-11-07 20:00', 'Completed'),
(7,  9,  '2026-11-08 09:00', '2026-11-08 11:00', 'Cancelled'),
(1,  10, DATEADD(HOUR, -1, @now), DATEADD(HOUR, 2, @now), 'Active'),
(5,  2,  DATEADD(HOUR, -2, @now), DATEADD(HOUR, 1, @now), 'Active'),
(8,  1,  DATEADD(HOUR, -1, @now), DATEADD(HOUR, 3, @now), 'Active'),
(4,  3,  DATEADD(HOUR, 3, @now),  DATEADD(HOUR, 5, @now), 'Confirmed'),
(11, 6,  DATEADD(HOUR, 4, @now),  DATEADD(HOUR, 7, @now), 'Confirmed');

INSERT INTO payments (reservation_id, total_amount, payment_method, payment_time, is_paid) VALUES
(1,  30.00, 'Mada',       '2026-11-01 11:05', 1),
(2,  40.00, 'ApplePay',   '2026-11-01 13:02', 1),
(3,  16.00, 'CreditCard', '2026-11-02 12:10', 1),
(4,  60.00, 'Mada',       '2026-11-03 19:03', 1),
(5,  18.00, 'ApplePay',   '2026-11-04 18:01', 1),
(6,  36.00, 'Mada',       '2026-11-05 13:07', 1),
(7,  15.00, 'CreditCard', '2026-11-06 15:04', 1),
(8,  30.00, 'ApplePay',   '2026-11-07 20:02', 1),
(10, 30.00, 'Mada',       DATEADD(HOUR, -1, @now), 1),
(11, 24.00, 'ApplePay',   DATEADD(HOUR, -2, @now), 1),
(12, 36.00, 'CreditCard', DATEADD(HOUR, -1, @now), 1),
(13, 16.00, 'Mada',       NULL, 0),
(14, 22.50, 'ApplePay',   NULL, 0);
GO

SELECT 'parking_lots'  AS table_name, COUNT(*) AS row_count FROM parking_lots
UNION ALL SELECT 'parking_spots', COUNT(*) FROM parking_spots
UNION ALL SELECT 'drivers',       COUNT(*) FROM drivers
UNION ALL SELECT 'reservations',  COUNT(*) FROM reservations
UNION ALL SELECT 'payments',      COUNT(*) FROM payments;
GO

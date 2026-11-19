USE smart_parking;
GO

-- 1) إنشاء الفهرس (يتجاهله لو موجود)
IF NOT EXISTS (SELECT 1 FROM sys.indexes
               WHERE name = 'idx_spots_status' AND object_id = OBJECT_ID('dbo.parking_spots'))
    CREATE INDEX idx_spots_status ON parking_spots (status);
GO

-- 2) فعّلي Ctrl+M (Include Actual Execution Plan) ثم شغّلي السطر التالي
SET STATISTICS IO ON;

-- 3) بدون الفهرس: مسح كامل للجدول  (حددي السطر ثم F5، وصوّري Execution Plan + Messages)
SELECT spot_id FROM parking_spots WITH (INDEX(0)) WHERE status = 'Available';

-- 4) باستخدام الفهرس  (حددي السطر ثم F5، وصوّري Execution Plan + Messages)
SELECT spot_id FROM parking_spots WITH (INDEX(idx_spots_status)) WHERE status = 'Available';
GO

-- ===== بعد تصوير المقارنة فقط =====

-- 5) تحسين اختياري: فهرس مغطّي لـ Q1
IF NOT EXISTS (SELECT 1 FROM sys.indexes
               WHERE name = 'idx_spots_type_status' AND object_id = OBJECT_ID('dbo.parking_spots'))
    CREATE INDEX idx_spots_type_status ON parking_spots (spot_type, status)
    INCLUDE (spot_number, lot_id);

-- 6) فهارس المفاتيح الأجنبية في reservations
IF NOT EXISTS (SELECT 1 FROM sys.indexes
               WHERE name = 'idx_res_spot_id' AND object_id = OBJECT_ID('dbo.reservations'))
    CREATE INDEX idx_res_spot_id ON reservations (spot_id);
IF NOT EXISTS (SELECT 1 FROM sys.indexes
               WHERE name = 'idx_res_driver_id' AND object_id = OBJECT_ID('dbo.reservations'))
    CREATE INDEX idx_res_driver_id ON reservations (driver_id);
GO

-- 7) عرض الفهارس
EXEC sp_helpindex 'parking_spots';
EXEC sp_helpindex 'reservations';

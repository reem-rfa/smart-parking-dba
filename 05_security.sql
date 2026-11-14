USE master;
GO
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'gate_operator')
    CREATE LOGIN gate_operator   WITH PASSWORD = 'Gate#Park2026!';
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'finance_auditor')
    CREATE LOGIN finance_auditor WITH PASSWORD = 'Fin#Audit2026!';
GO

USE smart_parking;
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'gate_operator')
    CREATE USER gate_operator   FOR LOGIN gate_operator;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'finance_auditor')
    CREATE USER finance_auditor FOR LOGIN finance_auditor;
GO

GRANT SELECT          ON dbo.parking_spots TO gate_operator;
GRANT UPDATE (status) ON dbo.parking_spots TO gate_operator;

GRANT SELECT ON dbo.payments     TO finance_auditor;
GRANT SELECT ON dbo.reservations TO finance_auditor;
GO

SELECT pr.name AS principal,
       pe.permission_name,
       pe.state_desc,
       OBJECT_NAME(pe.major_id) AS object_name
FROM sys.database_permissions pe
JOIN sys.database_principals  pr ON pr.principal_id = pe.grantee_principal_id
WHERE pr.name IN ('gate_operator', 'finance_auditor')
ORDER BY pr.name, object_name;
GO

EXECUTE AS USER = 'gate_operator';
SELECT spot_number, status FROM parking_spots WHERE spot_id = 1;
UPDATE parking_spots SET status = 'Occupied' WHERE spot_id = 1;
UPDATE parking_spots SET spot_type = 'Standard' WHERE spot_id = 1;
SELECT * FROM payments;
SELECT phone FROM drivers;
REVERT;
GO

EXECUTE AS USER = 'finance_auditor';
SELECT payment_id, total_amount, is_paid FROM payments;
UPDATE payments SET total_amount = 0 WHERE payment_id = 1;
DELETE FROM payments WHERE payment_id = 1;
SELECT full_name FROM drivers;
REVERT;
GO

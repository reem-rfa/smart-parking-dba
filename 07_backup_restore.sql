USE smart_parking;
GO

SELECT COUNT(*) AS payments_before_backup
FROM dbo.payments;

SELECT SERVERPROPERTY('InstanceDefaultBackupPath') AS backup_folder;
GO

USE master;
GO

BACKUP DATABASE smart_parking
TO DISK = N'D:\SQLServer\MSSQL17.MSSQLSERVER\MSSQL\Backup\smart_parking_C.bak'
WITH COPY_ONLY, INIT, CHECKSUM, STATS = 10;
GO

RESTORE VERIFYONLY
FROM DISK = N'D:\SQLServer\MSSQL17.MSSQLSERVER\MSSQL\Backup\smart_parking_C.bak'
WITH FILE = 1, CHECKSUM;
GO

USE smart_parking;
GO

DROP TABLE dbo.payments;
GO

SELECT
    CASE
        WHEN OBJECT_ID(N'dbo.payments', N'U') IS NULL
            THEN N'تم حذف جدول المدفوعات'
        ELSE N'الجدول ما زال موجودًا'
    END AS deletion_check;
GO

USE master;
GO

BEGIN TRY
    ALTER DATABASE smart_parking
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    RESTORE DATABASE smart_parking
    FROM DISK = N'D:\SQLServer\MSSQL17.MSSQLSERVER\MSSQL\Backup\smart_parking_C.bak'
    WITH FILE = 1, REPLACE, CHECKSUM;

    ALTER DATABASE smart_parking
    SET MULTI_USER;
END TRY
BEGIN CATCH
    ALTER DATABASE smart_parking
    SET MULTI_USER;

    THROW;
END CATCH;
GO

USE smart_parking;
GO

SELECT COUNT(*) AS payments_after_restore
FROM dbo.payments;
GO
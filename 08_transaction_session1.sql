USE smart_parking;
GO
SET XACT_ABORT ON;

DECLARE @spot INT = 2,
        @driver INT = 1,
        @start DATETIME2(0) = '2026-12-01T14:00:00',
        @end DATETIME2(0) = '2026-12-01T16:00:00';

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @locked_id INT;

    SELECT @locked_id = spot_id
    FROM dbo.parking_spots WITH (UPDLOCK, HOLDLOCK)
    WHERE spot_id = @spot;

    IF @@ROWCOUNT = 0
        THROW 50001, 'Spot does not exist.', 1;

    SELECT @locked_id = driver_id
    FROM dbo.drivers WITH (UPDLOCK, HOLDLOCK)
    WHERE driver_id = @driver;

    IF @@ROWCOUNT = 0
        THROW 50002, 'Driver does not exist.', 1;

    IF EXISTS (
        SELECT 1
        FROM dbo.reservations WITH (UPDLOCK, HOLDLOCK)
        WHERE reservation_status IN ('Confirmed', 'Active')
          AND start_time < @end
          AND end_time > @start
          AND (spot_id = @spot OR driver_id = @driver)
    )
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'Rejected: overlapping reservation';
    END
    ELSE
    BEGIN
        -- Keep the lock for 20 seconds for the demo.
        WAITFOR DELAY '00:00:20';

        INSERT INTO dbo.reservations
            (spot_id, driver_id, start_time, end_time,
             reservation_status)
        VALUES
            (@spot, @driver, @start, @end, 'Confirmed');

        COMMIT TRANSACTION;
        PRINT 'Reservation created';
    END;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
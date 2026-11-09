IF DB_ID('smart_parking') IS NULL CREATE DATABASE smart_parking;
GO
USE smart_parking;
GO

CREATE TABLE parking_lots (
  lot_id       INT IDENTITY(1,1) PRIMARY KEY,
  lot_name     NVARCHAR(100) NOT NULL,
  district     NVARCHAR(80)  NOT NULL,
  city         NVARCHAR(80)  NOT NULL,
  hourly_rate  DECIMAL(6,2)  NOT NULL,
  CONSTRAINT chk_lot_rate CHECK (hourly_rate > 0)
);

CREATE TABLE parking_spots (
  spot_id      INT IDENTITY(1,1) PRIMARY KEY,
  lot_id       INT NOT NULL,
  spot_number  VARCHAR(10) NOT NULL,
  spot_type    VARCHAR(15) NOT NULL DEFAULT 'Standard',
  status       VARCHAR(10) NOT NULL DEFAULT 'Available',
  CONSTRAINT fk_spot_lot     FOREIGN KEY (lot_id) REFERENCES parking_lots(lot_id),
  CONSTRAINT uq_spot         UNIQUE (lot_id, spot_number),
  CONSTRAINT chk_spot_type   CHECK (spot_type IN ('Standard','EV-Charging','Handicapped')),
  CONSTRAINT chk_spot_status CHECK (status IN ('Available','Occupied','Reserved'))
);

CREATE TABLE drivers (
  driver_id      INT IDENTITY(1,1) PRIMARY KEY,
  full_name      NVARCHAR(100) NOT NULL,
  license_plate  VARCHAR(15)   NOT NULL UNIQUE,
  phone          VARCHAR(15)   NOT NULL UNIQUE,
  email          VARCHAR(120)  NOT NULL UNIQUE
);

CREATE TABLE reservations (
  reservation_id      INT IDENTITY(1,1) PRIMARY KEY,
  spot_id             INT NOT NULL,
  driver_id           INT NOT NULL,
  start_time          DATETIME2(0) NOT NULL,
  end_time            DATETIME2(0) NOT NULL,
  reservation_status  VARCHAR(10) NOT NULL DEFAULT 'Confirmed',
  CONSTRAINT fk_res_spot   FOREIGN KEY (spot_id)   REFERENCES parking_spots(spot_id),
  CONSTRAINT fk_res_driver FOREIGN KEY (driver_id) REFERENCES drivers(driver_id),
  CONSTRAINT chk_res_time  CHECK (end_time > start_time),
  CONSTRAINT chk_res_status CHECK (reservation_status IN ('Confirmed','Active','Completed','Cancelled'))
);

CREATE TABLE payments (
  payment_id      INT IDENTITY(1,1) PRIMARY KEY,
  reservation_id  INT NOT NULL UNIQUE,            -- UNIQUE = 1:1 relationship
  total_amount    DECIMAL(8,2) NOT NULL,
  payment_method  VARCHAR(12) NOT NULL,
  payment_time    DATETIME2(0) NULL,
  is_paid         BIT NOT NULL DEFAULT 0,
  CONSTRAINT fk_pay_res  FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id),
  CONSTRAINT chk_pay_amt CHECK (total_amount >= 0),
  CONSTRAINT chk_pay_method CHECK (payment_method IN ('Mada','ApplePay','CreditCard'))
);
GO

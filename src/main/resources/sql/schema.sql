-- Car Rental Management - Schema MVC
-- Chạy script này trong MySQL để tạo database và bảng.

CREATE DATABASE IF NOT EXISTS car_rental_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE car_rental_db;

-- Bảng người dùng
CREATE TABLE IF NOT EXISTS users (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    username     VARCHAR(50)  NOT NULL UNIQUE,
    password     VARCHAR(255) NOT NULL,
    full_name    VARCHAR(100),
    email        VARCHAR(100),
    phone        VARCHAR(20),
    role         VARCHAR(20)  NOT NULL DEFAULT 'CUSTOMER',  -- ADMIN, CUSTOMER, STAFF
    active       TINYINT(1)   NOT NULL DEFAULT 1,
    created_at   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Bảng xe
CREATE TABLE IF NOT EXISTS cars (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20)  NOT NULL UNIQUE,
    brand         VARCHAR(50),
    model         VARCHAR(50),
    year          INT,
    color         VARCHAR(30),
    price_per_day DECIMAL(12,2) NOT NULL DEFAULT 0,
    status        VARCHAR(20)  NOT NULL DEFAULT 'AVAILABLE',  -- AVAILABLE, RENTED, MAINTENANCE
    image_url     VARCHAR(500),
    created_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Dữ liệu mẫu (tùy chọn)
INSERT INTO users (username, password, full_name, email, phone, role, active)
VALUES ('admin', 'admin123', 'Quản trị viên', 'admin@carrental.com', '0900000000', 'ADMIN', 1);

INSERT INTO cars (name, license_plate, brand, model, year, color, price_per_day, status)
VALUES
    ('Toyota Vios', '30A-12345', 'Toyota', 'Vios', 2023, 'Trắng', 500000, 'AVAILABLE'),
    ('Honda City', '51B-67890', 'Honda', 'City', 2022, 'Đen', 550000, 'AVAILABLE');

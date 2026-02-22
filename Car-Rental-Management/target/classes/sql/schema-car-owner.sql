-- Migration: Add Car Owner, Car Availability, Car Images
-- Chạy script này nếu DB đã tạo trước khi có owner_id, car_availability, car_images
-- Nếu lỗi "duplicate column/table" thì bỏ qua lệnh đó

USE car_rental_db;

-- 1. Thêm owner_id vào cars (bỏ qua nếu đã có)
ALTER TABLE cars ADD COLUMN owner_id INT NULL;

-- Cập nhật role: thêm OWNER nếu chưa có
-- INSERT INTO users (username, password, full_name, email, phone, role, active)
-- VALUES ('owner1', 'owner123', 'Chủ xe mẫu', 'owner@carrental.com', '0900111222', 'OWNER', 1);

-- Bảng lịch sẵn có của xe (car availability)
CREATE TABLE IF NOT EXISTS car_availability (
    id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_available TINYINT(1) NOT NULL DEFAULT 1,
    note VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_availability_car FOREIGN KEY (car_id) REFERENCES cars(id) ON DELETE CASCADE,
    CONSTRAINT chk_dates CHECK (end_date >= start_date)
);

-- Bảng ảnh xe (nhiều ảnh cho mỗi xe)
CREATE TABLE IF NOT EXISTS car_images (
    id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    is_primary TINYINT(1) NOT NULL DEFAULT 0,
    sort_order INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_images_car FOREIGN KEY (car_id) REFERENCES cars(id) ON DELETE CASCADE
);

-- Chỉnh schema cho MySQL 5.7 (không có ADD COLUMN IF NOT EXISTS)
-- Nếu lỗi, chạy từng lệnh sau thủ công:
-- ALTER TABLE cars ADD COLUMN owner_id INT NULL;
-- ALTER TABLE cars ADD CONSTRAINT fk_cars_owner FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE SET NULL;

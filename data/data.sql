DROP DATABASE IF EXISTS car_rental_db;
CREATE DATABASE car_rental_db;
USE car_rental_db;

-- =============================================
-- 1. Roles (Giữ nguyên 4 quyền cơ bản)
-- =============================================
CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(20) NOT NULL UNIQUE
);

INSERT INTO roles (role_name) VALUES
('GUEST'), ('CUSTOMER'), ('OWNER'), ('ADMIN');

-- =============================================
-- 2. Users (Đã thêm cột USERNAME, tạo 15 users)
-- =============================================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE, -- Cột mới thêm
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    status ENUM('ACTIVE','BLOCKED') DEFAULT 'ACTIVE',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (username, full_name, email, password, phone, status) VALUES
-- 1 Admin
('admin_main', 'Nguyễn Quản Trị', 'admin@rental.com', 'pass123', '0900000001', 'ACTIVE'),
-- 4 Owners (Chủ xe)
('owner_hung', 'Trần Văn Hùng', 'hung@owner.com', 'pass123', '0900000002', 'ACTIVE'),
('owner_lan', 'Lê Thị Lan', 'lan@owner.com', 'pass123', '0900000003', 'ACTIVE'),
('owner_minh', 'Phạm Nhật Minh', 'minh@owner.com', 'pass123', '0900000004', 'ACTIVE'),
('owner_tuan', 'Hoàng Anh Tuấn', 'tuan@owner.com', 'pass123', '0900000005', 'ACTIVE'),
-- 10 Customers (Khách thuê)
('cust_an', 'Nguyễn Văn An', 'an@cust.com', 'pass123', '0900000006', 'ACTIVE'),
('cust_binh', 'Trần Thanh Bình', 'binh@cust.com', 'pass123', '0900000007', 'ACTIVE'),
('cust_cuong', 'Lý Quốc Cường', 'cuong@cust.com', 'pass123', '0900000008', 'ACTIVE'),
('cust_dung', 'Phạm Tiến Dũng', 'dung@cust.com', 'pass123', '0900000009', 'ACTIVE'),
('cust_hanh', 'Lê Mỹ Hạnh', 'hanh@cust.com', 'pass123', '0900000010', 'ACTIVE'),
('cust_hoa', 'Vũ Thị Hoa', 'hoa@cust.com', 'pass123', '0900000011', 'ACTIVE'),
('cust_khoi', 'Đặng Đăng Khôi', 'khoi@cust.com', 'pass123', '0900000012', 'ACTIVE'),
('cust_linh', 'Ngô Thùy Linh', 'linh@cust.com', 'pass123', '0900000013', 'ACTIVE'),
('cust_nam', 'Bùi Phương Nam', 'nam@cust.com', 'pass123', '0900000014', 'ACTIVE'),
('cust_phuc', 'Đỗ Hoàng Phúc', 'phuc@cust.com', 'pass123', '0900000015', 'ACTIVE');

-- =============================================
-- 3. User Roles (Phân quyền cho 15 users)
-- =============================================
CREATE TABLE user_roles (
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE
);

INSERT INTO user_roles (user_id, role_id) VALUES
(1, 4), -- Admin
(2, 3), (3, 3), (4, 3), (5, 3), -- Owners
(6, 2), (7, 2), (8, 2), (9, 2), (10, 2), -- Customers
(11, 2), (12, 2), (13, 2), (14, 2), (15, 2);

-- =============================================
-- 4. Cars (15 xe, thuộc về các owner id 2,3,4,5)
-- =============================================
CREATE TABLE cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id INT NOT NULL,
    car_name VARCHAR(100) NOT NULL,
    brand VARCHAR(50),
    model VARCHAR(50),
    price_per_day DECIMAL(10,2) NOT NULL,
    location VARCHAR(100),
    status ENUM('AVAILABLE','UNAVAILABLE') DEFAULT 'AVAILABLE',
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(user_id)
);

INSERT INTO cars (owner_id, car_name, brand, model, price_per_day, location, status) VALUES
(2, 'Toyota Vios E', 'Toyota', 'Vios', 600000, 'Hà Nội', 'AVAILABLE'),
(2, 'Hyundai Accent', 'Hyundai', 'Accent', 650000, 'Hà Nội', 'AVAILABLE'),
(2, 'Kia Cerato', 'Kia', 'Cerato', 700000, 'Hà Nội', 'UNAVAILABLE'),
(2, 'Mazda 3 Luxury', 'Mazda', '3', 800000, 'Hà Nội', 'AVAILABLE'),
(3, 'Honda City RS', 'Honda', 'City', 700000, 'TP.HCM', 'AVAILABLE'),
(3, 'VinFast Lux A', 'VinFast', 'Lux A', 1100000, 'TP.HCM', 'AVAILABLE'),
(3, 'Mercedes C200', 'Mercedes', 'C-Class', 2500000, 'TP.HCM', 'AVAILABLE'),
(3, 'Toyota Camry', 'Toyota', 'Camry', 1500000, 'TP.HCM', 'AVAILABLE'),
(4, 'Ford Ranger XLS', 'Ford', 'Ranger', 900000, 'Đà Nẵng', 'AVAILABLE'),
(4, 'Mitsubishi Xpander', 'Mitsubishi', 'Xpander', 800000, 'Đà Nẵng', 'AVAILABLE'),
(4, 'Toyota Fortuner', 'Toyota', 'Fortuner', 1200000, 'Đà Nẵng', 'UNAVAILABLE'),
(4, 'Kia Sedona', 'Kia', 'Sedona', 1400000, 'Đà Nẵng', 'AVAILABLE'),
(5, 'VinFast VF8', 'VinFast', 'VF8', 1200000, 'Cần Thơ', 'AVAILABLE'),
(5, 'Hyundai SantaFe', 'Hyundai', 'SantaFe', 1300000, 'Cần Thơ', 'AVAILABLE'),
(5, 'Mazda CX-5', 'Mazda', 'CX-5', 1000000, 'Cần Thơ', 'AVAILABLE');

-- =============================================
-- 5. Car Images (15 ảnh tương ứng 15 xe)
-- =============================================
CREATE TABLE car_images (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    FOREIGN KEY (car_id) REFERENCES cars(car_id) ON DELETE CASCADE
);

INSERT INTO car_images (car_id, image_url) VALUES
(1, 'img/vios.jpg'), (2, 'img/accent.jpg'), (3, 'img/cerato.jpg'), (4, 'img/mazda3.jpg'),
(5, 'img/city.jpg'), (6, 'img/luxa.jpg'), (7, 'img/c200.jpg'), (8, 'img/camry.jpg'),
(9, 'img/ranger.jpg'), (10, 'img/xpander.jpg'), (11, 'img/fortuner.jpg'), (12, 'img/sedona.jpg'),
(13, 'img/vf8.jpg'), (14, 'img/santafe.jpg'), (15, 'img/cx5.jpg');

-- =============================================
-- 6. Car Availability (Lịch trống cho 15 xe)
-- =============================================
CREATE TABLE car_availability (
    availability_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('AVAILABLE','BOOKED') DEFAULT 'AVAILABLE',
    FOREIGN KEY (car_id) REFERENCES cars(car_id) ON DELETE CASCADE
);

INSERT INTO car_availability (car_id, start_date, end_date, status) VALUES
(1, '2023-11-01', '2023-11-30', 'AVAILABLE'),
(2, '2023-11-01', '2023-11-30', 'AVAILABLE'),
(3, '2023-11-01', '2023-11-05', 'BOOKED'),
(4, '2023-12-01', '2023-12-31', 'AVAILABLE'),
(5, '2023-11-10', '2023-11-20', 'AVAILABLE'),
(6, '2023-11-01', '2023-11-30', 'AVAILABLE'),
(7, '2023-12-24', '2023-12-26', 'BOOKED'),
(8, '2023-11-01', '2023-11-30', 'AVAILABLE'),
(9, '2023-11-01', '2023-11-30', 'AVAILABLE'),
(10, '2023-11-15', '2023-11-18', 'BOOKED'),
(11, '2023-11-01', '2023-11-30', 'BOOKED'),
(12, '2023-11-01', '2023-11-30', 'AVAILABLE'),
(13, '2023-11-01', '2023-11-30', 'AVAILABLE'),
(14, '2023-11-01', '2023-11-30', 'AVAILABLE'),
(15, '2023-11-01', '2023-11-30', 'AVAILABLE');

-- =============================================
-- 7. Bookings (15 đơn đặt xe)
-- =============================================
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    customer_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    booking_status ENUM('PENDING','APPROVED','CANCELLED','COMPLETED') DEFAULT 'PENDING',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES cars(car_id),
    FOREIGN KEY (customer_id) REFERENCES users(user_id)
);

INSERT INTO bookings (car_id, customer_id, start_date, end_date, total_price, booking_status) VALUES
(1, 6, '2023-10-01', '2023-10-03', 1200000, 'COMPLETED'),
(2, 7, '2023-10-05', '2023-10-06', 650000, 'COMPLETED'),
(3, 8, '2023-11-01', '2023-11-05', 3500000, 'APPROVED'),
(4, 9, '2023-11-10', '2023-11-12', 1600000, 'PENDING'),
(5, 10, '2023-11-20', '2023-11-21', 700000, 'CANCELLED'),
(6, 11, '2023-12-01', '2023-12-05', 5500000, 'APPROVED'),
(7, 12, '2023-12-24', '2023-12-26', 5000000, 'APPROVED'),
(8, 13, '2023-10-15', '2023-10-17', 3000000, 'COMPLETED'),
(9, 14, '2023-11-15', '2023-11-16', 900000, 'PENDING'),
(10, 15, '2023-11-15', '2023-11-18', 2400000, 'APPROVED'),
(11, 6, '2023-11-01', '2023-11-05', 6000000, 'APPROVED'), -- Xe 11 giá cao
(12, 7, '2023-11-22', '2023-11-23', 1400000, 'PENDING'),
(13, 8, '2023-12-30', '2024-01-01', 3600000, 'PENDING'),
(14, 9, '2023-10-20', '2023-10-22', 2600000, 'COMPLETED'),
(15, 10, '2023-11-28', '2023-11-30', 2000000, 'PENDING');

-- =============================================
-- 8. Booking History (15 dòng lịch sử)
-- =============================================
CREATE TABLE booking_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    status VARCHAR(30),
    note TEXT,
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE
);

INSERT INTO booking_history (booking_id, status, note) VALUES
(1, 'COMPLETED', 'Khách trả xe đúng hạn'),
(2, 'COMPLETED', 'Xe hơi bẩn khi trả'),
(3, 'APPROVED', 'Đã nhận cọc 50%'),
(4, 'PENDING', 'Khách hẹn xem xe trước'),
(5, 'CANCELLED', 'Khách bận việc đột xuất'),
(6, 'APPROVED', 'Chủ xe đã xác nhận'),
(7, 'APPROVED', 'Đặt lịch Noel'),
(8, 'COMPLETED', 'Hài lòng'),
(9, 'PENDING', 'Chờ chuyển khoản'),
(10, 'APPROVED', 'Đã xác nhận lịch'),
(11, 'APPROVED', 'Thuê dài ngày'),
(12, 'PENDING', 'Đang thương lượng giá'),
(13, 'PENDING', 'Đặt lịch Tết Dương'),
(14, 'COMPLETED', 'Không có vấn đề gì'),
(15, 'PENDING', 'Mới tạo yêu cầu');

-- =============================================
-- 9. Payments (15 giao dịch)
-- =============================================
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('CASH','MOMO','VNPAY','PAYPAL'),
    payment_status ENUM('PAID','UNPAID','REFUNDED') DEFAULT 'UNPAID',
    paid_at DATETIME,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

INSERT INTO payments (booking_id, amount, payment_method, payment_status, paid_at) VALUES
(1, 1200000, 'CASH', 'PAID', '2023-10-03 12:00:00'),
(2, 650000, 'MOMO', 'PAID', '2023-10-06 14:00:00'),
(3, 1750000, 'VNPAY', 'PAID', '2023-10-31 09:00:00'), -- Cọc 50%
(4, 0, 'CASH', 'UNPAID', NULL),
(5, 0, 'MOMO', 'REFUNDED', '2023-11-20 08:00:00'),
(6, 5500000, 'PAYPAL', 'PAID', '2023-11-30 20:00:00'),
(7, 5000000, 'VNPAY', 'PAID', '2023-12-20 10:00:00'),
(8, 3000000, 'CASH', 'PAID', '2023-10-17 16:00:00'),
(9, 0, 'MOMO', 'UNPAID', NULL),
(10, 2400000, 'VNPAY', 'PAID', '2023-11-14 11:00:00'),
(11, 3000000, 'CASH', 'PAID', '2023-11-01 07:00:00'), -- Cọc trước
(12, 0, 'CASH', 'UNPAID', NULL),
(13, 1000000, 'MOMO', 'PAID', '2023-12-29 18:00:00'), -- Cọc
(14, 2600000, 'PAYPAL', 'PAID', '2023-10-22 13:00:00'),
(15, 0, 'VNPAY', 'UNPAID', NULL);

-- =============================================
-- 10. Indexes & Views (Giữ nguyên View doanh thu)
-- =============================================
CREATE INDEX idx_booking_car ON bookings(car_id);
CREATE INDEX idx_booking_customer ON bookings(customer_id);
CREATE INDEX idx_car_owner ON cars(owner_id);

CREATE VIEW revenue_report AS
SELECT 
    c.car_id,
    c.car_name,
    SUM(p.amount) AS total_revenue
FROM payments p
JOIN bookings b ON p.booking_id = b.booking_id
JOIN cars c ON b.car_id = c.car_id
WHERE p.payment_status = 'PAID'
GROUP BY c.car_id, c.car_name;
-- ============================================================
-- CAR RENTAL DB - Schema khớp với code Java (CarDAO, UserDAO, CarAvailabilityDAO, CarImageDAO)
-- ============================================================
DROP DATABASE IF EXISTS car_rental_db;
CREATE DATABASE car_rental_db;
USE car_rental_db;

-- =============================
-- ROLES
-- =============================
CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(20) UNIQUE NOT NULL
);

INSERT INTO roles (role_name)
VALUES ('ADMIN'), ('OWNER'), ('CUSTOMER');

-- =============================
-- USERS (code dùng user_id, map sang User.id)
-- =============================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    status ENUM('ACTIVE','BLOCKED') DEFAULT 'ACTIVE',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO users (username, full_name, email, password, phone) VALUES
('admin','System Admin','admin@mail.com','123456','0900000000'),
('owner1','Owner One','owner1@mail.com','123456','0900000001'),
('owner2','Owner Two','owner2@mail.com','123456','0900000002'),
('cust1','Customer 1','cust1@mail.com','123456','0900000011'),
('cust2','Customer 2','cust2@mail.com','123456','0900000012'),
('cust3','Customer 3','cust3@mail.com','123456','0900000013'),
('cust4','Customer 4','cust4@mail.com','123456','0900000014'),
('cust5','Customer 5','cust5@mail.com','123456','0900000015'),
('cust6','Customer 6','cust6@mail.com','123456','0900000016'),
('cust7','Customer 7','cust7@mail.com','123456','0900000017'),
('cust8','Customer 8','cust8@mail.com','123456','0900000018'),
('cust9','Customer 9','cust9@mail.com','123456','0900000019'),
('cust10','Customer 10','cust10@mail.com','123456','0900000020'),
('cust11','Customer 11','cust11@mail.com','123456','0900000021'),
('cust12','Customer 12','cust12@mail.com','123456','0900000022');

-- =============================
-- USER ROLES
-- =============================
CREATE TABLE user_roles (
    user_id INT,
    role_id INT,
    PRIMARY KEY(user_id, role_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY(role_id) REFERENCES roles(role_id) ON DELETE CASCADE
);

INSERT INTO user_roles VALUES (1,1);
INSERT INTO user_roles VALUES (2,2),(3,2);
INSERT INTO user_roles VALUES
(4,3),(5,3),(6,3),(7,3),(8,3),(9,3),
(10,3),(11,3),(12,3),(13,3),(14,3),(15,3);

-- =============================
-- CARS (code: id, owner_id, name, license_plate, brand, model, year, color, seats, transmission, fuel_type, price_per_day, status, image_url, description, created_at, updated_at)
-- =============================
CREATE TABLE cars (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL,
    brand VARCHAR(50),
    model VARCHAR(50),
    year INT,
    color VARCHAR(30),
    seats INT DEFAULT 4,
    transmission ENUM('AUTO','MANUAL'),
    fuel_type ENUM('PETROL','DIESEL','ELECTRIC'),
    price_per_day DECIMAL(12,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE' COMMENT 'AVAILABLE, RENTED, MAINTENANCE',
    image_url VARCHAR(500) NULL,
    description TEXT NULL COMMENT 'Mô tả chi tiết xe',
    created_at DATETIME NULL,
    updated_at DATETIME NULL,
    FOREIGN KEY(owner_id) REFERENCES users(user_id)
);

INSERT INTO cars
(owner_id, name, license_plate, brand, model, year, color, seats, transmission, fuel_type, price_per_day, status)
VALUES
(2,'Toyota Altis','30A-11111','Toyota','Altis',2023,'White',5,'AUTO','PETROL',900000,'AVAILABLE'),
(2,'Kia K3','30A-22222','Kia','K3',2023,'Red',5,'AUTO','PETROL',950000,'AVAILABLE'),
(2,'Mazda 6','30A-33333','Mazda','6',2022,'Black',5,'AUTO','PETROL',1200000,'AVAILABLE'),
(2,'Hyundai Tucson','30A-44444','Hyundai','Tucson',2022,'White',5,'AUTO','PETROL',1300000,'AVAILABLE'),
(2,'Honda CRV','30A-55555','Honda','CRV',2023,'Blue',5,'AUTO','PETROL',1500000,'AVAILABLE'),
(3,'Ford Everest','30B-11111','Ford','Everest',2023,'Grey',7,'AUTO','DIESEL',1800000,'AVAILABLE'),
(3,'Vinfast VF9','30B-22222','Vinfast','VF9',2024,'Black',7,'AUTO','ELECTRIC',2000000,'AVAILABLE'),
(3,'Toyota Hilux','30B-33333','Toyota','Hilux',2022,'Silver',5,'MANUAL','DIESEL',1400000,'AVAILABLE'),
(3,'Mitsubishi Attrage','30B-44444','Mitsubishi','Attrage',2021,'White',5,'AUTO','PETROL',600000,'AVAILABLE'),
(3,'BMW 320i','30B-55555','BMW','320i',2023,'Black',5,'AUTO','PETROL',3000000,'AVAILABLE'),
(2,'Mercedes GLC','30C-11111','Mercedes','GLC',2023,'White',5,'AUTO','PETROL',3500000,'AVAILABLE'),
(2,'Audi A6','30C-22222','Audi','A6',2023,'Black',5,'AUTO','PETROL',3200000,'AVAILABLE'),
(2,'Suzuki XL7','30C-33333','Suzuki','XL7',2022,'Orange',7,'AUTO','PETROL',900000,'AVAILABLE'),
(3,'Toyota Innova','30C-44444','Toyota','Innova',2022,'Silver',7,'MANUAL','PETROL',1000000,'AVAILABLE'),
(3,'Hyundai i10','30C-55555','Hyundai','i10',2021,'White',5,'AUTO','PETROL',500000,'AVAILABLE');

-- =============================
-- CAR_AVAILABILITY (code: CarAvailabilityDAO)
-- =============================
CREATE TABLE car_availability (
    id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_available TINYINT(1) NOT NULL DEFAULT 1,
    note VARCHAR(255),
    FOREIGN KEY(car_id) REFERENCES cars(id) ON DELETE CASCADE
);

-- =============================
-- CAR_IMAGES (code: CarImageDAO)
-- =============================
CREATE TABLE car_images (
    id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    is_primary TINYINT(1) NOT NULL DEFAULT 0,
    sort_order INT NOT NULL DEFAULT 0,
    FOREIGN KEY(car_id) REFERENCES cars(id) ON DELETE CASCADE
);

-- =============================
-- BOOKINGS (tham chiếu cars(id))
-- =============================
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    customer_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_days INT NOT NULL,
    total_price DECIMAL(12,2) NOT NULL,
    booking_status ENUM('PENDING','APPROVED','REJECTED','CANCELLED','COMPLETED') DEFAULT 'PENDING',
    FOREIGN KEY(car_id) REFERENCES cars(id),
    FOREIGN KEY(customer_id) REFERENCES users(user_id),
    CHECK (end_date >= start_date)
);

INSERT INTO bookings
(car_id, customer_id, start_date, end_date, total_days, total_price, booking_status)
VALUES
(1,4,'2025-01-01','2025-01-03',3,2700000,'APPROVED'),
(2,5,'2025-01-05','2025-01-07',3,2850000,'COMPLETED'),
(3,6,'2025-01-10','2025-01-12',3,3600000,'APPROVED'),
(4,7,'2025-01-15','2025-01-17',3,3900000,'PENDING'),
(5,8,'2025-01-20','2025-01-22',3,4500000,'APPROVED'),
(6,9,'2025-02-01','2025-02-03',3,5400000,'APPROVED'),
(7,10,'2025-02-05','2025-02-07',3,6000000,'APPROVED'),
(8,11,'2025-02-10','2025-02-12',3,4200000,'PENDING'),
(9,12,'2025-02-15','2025-02-17',3,1800000,'APPROVED'),
(10,13,'2025-02-20','2025-02-22',3,9000000,'COMPLETED'),
(11,14,'2025-03-01','2025-03-03',3,10500000,'APPROVED'),
(12,15,'2025-03-05','2025-03-07',3,9600000,'APPROVED'),
(13,4,'2025-03-10','2025-03-12',3,2700000,'PENDING'),
(14,5,'2025-03-15','2025-03-17',3,3000000,'APPROVED'),
(15,6,'2025-03-20','2025-03-22',3,1500000,'COMPLETED'),

-- Bookings sắp tới (thời gian trong tương lai - 2026)
(1,7,'2026-01-05','2026-01-08',3,2700000,'APPROVED'),
(2,8,'2026-01-12','2026-01-15',3,2850000,'PENDING'),
(3,9,'2026-01-20','2026-01-23',3,3600000,'APPROVED'),
(4,10,'2026-02-01','2026-02-04',3,3900000,'APPROVED'),
(5,11,'2026-02-10','2026-02-13',3,4500000,'PENDING'),
(6,12,'2026-02-15','2026-02-18',3,5400000,'APPROVED'),
(7,13,'2026-02-20','2026-02-23',3,6000000,'PENDING'),
(8,14,'2026-03-01','2026-03-04',3,4200000,'APPROVED'),
(9,15,'2026-03-05','2026-03-08',3,1800000,'PENDING'),
(10,4,'2026-03-10','2026-03-13',3,9000000,'APPROVED'),
(11,5,'2026-03-15','2026-03-18',3,10500000,'PENDING'),
(12,6,'2026-03-20','2026-03-23',3,9600000,'APPROVED'),
(13,7,'2026-04-01','2026-04-05',4,3600000,'APPROVED'),
(14,8,'2026-04-10','2026-04-12',2,2000000,'PENDING'),
(15,9,'2026-04-15','2026-04-18',3,1500000,'APPROVED');

-- =============================
-- PAYMENTS
-- =============================
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    payment_method ENUM('CASH','MOMO','VNPAY','PAYPAL'),
    payment_status ENUM('UNPAID','PAID','REFUNDED') DEFAULT 'UNPAID',
    paid_at DATETIME,
    FOREIGN KEY(booking_id) REFERENCES bookings(booking_id)
);

INSERT INTO payments
(booking_id, amount, payment_method, payment_status, paid_at)
VALUES
(1,2700000,'VNPAY','PAID','2024-12-30 10:00:00'),
(2,2850000,'MOMO','PAID','2025-01-07 15:00:00'),
(3,3600000,'PAYPAL','PAID','2025-01-09 09:00:00'),
(4,0,'CASH','UNPAID',NULL),
(5,4500000,'VNPAY','PAID','2025-01-19 11:00:00'),
(6,5400000,'PAYPAL','PAID','2025-01-30 18:00:00'),
(7,6000000,'MOMO','PAID','2025-02-07 20:00:00'),
(8,0,'CASH','UNPAID',NULL),
(9,1800000,'CASH','PAID','2025-02-14 10:00:00'),
(10,9000000,'MOMO','PAID','2025-02-22 19:00:00'),
(11,10500000,'PAYPAL','PAID','2025-02-28 21:00:00'),
(12,9600000,'VNPAY','PAID','2025-03-04 14:00:00'),
(13,0,'CASH','UNPAID',NULL),
(14,3000000,'MOMO','PAID','2025-03-14 16:00:00'),
(15,1500000,'CASH','PAID','2025-03-22 19:00:00'),
-- Thanh toán cho các booking sắp tới (16-30, phần lớn UNPAID)
(16,2700000,'VNPAY','PAID',NULL),
(17,0,'CASH','UNPAID',NULL),
(18,3600000,'MOMO','PAID',NULL),
(19,3900000,'VNPAY','PAID',NULL),
(20,0,'CASH','UNPAID',NULL),
(21,5400000,'MOMO','PAID',NULL),
(22,0,'CASH','UNPAID',NULL),
(23,0,'CASH','UNPAID',NULL),
(24,1800000,'VNPAY','PAID',NULL),
(25,0,'CASH','UNPAID',NULL),
(26,10500000,'MOMO','PAID',NULL),
(27,0,'CASH','UNPAID',NULL),
(28,3600000,'VNPAY','PAID',NULL),
(29,0,'CASH','UNPAID',NULL),
(30,1500000,'CASH','PAID',NULL);

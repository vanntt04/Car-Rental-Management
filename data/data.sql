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
    status VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE' COMMENT 'AVAILABLE, RENTED, MAINTENANCE,INACTIVE',
    image_url VARCHAR(500) NULL,
    description TEXT NULL COMMENT 'Mô tả chi tiết xe',
    created_at DATETIME NULL,
    updated_at DATETIME NULL,
    FOREIGN KEY(owner_id) REFERENCES users(user_id)
);

INSERT INTO cars (owner_id, name, license_plate, brand, model, year, color, seats, transmission, fuel_type, price_per_day, status, image_url, description, created_at, updated_at)
VALUES
(1,'Toyota Vios 1','43A-10001','Toyota','Vios',2022,'White',5,'AUTO','PETROL',500000,'AVAILABLE','img/1.jpg','Xe tốt',NOW(),NOW()),
(2,'Toyota Vios 2','43A-10002','Toyota','Vios',2021,'Black',5,'AUTO','PETROL',520000,'AVAILABLE','img/2.jpg','Xe đẹp',NOW(),NOW()),
(1,'Honda Civic 1','43A-10003','Honda','Civic',2020,'Red',5,'AUTO','PETROL',700000,'AVAILABLE','img/3.jpg','Xe mạnh',NOW(),NOW()),
(2,'Honda Civic 2','43A-10004','Honda','Civic',2022,'Blue',5,'AUTO','PETROL',720000,'AVAILABLE','img/4.jpg','Xe mới',NOW(),NOW()),
(1,'Hyundai Accent 1','43A-10005','Hyundai','Accent',2019,'White',5,'MANUAL','PETROL',400000,'AVAILABLE','img/5.jpg','Tiết kiệm',NOW(),NOW()),
(2,'Hyundai Accent 2','43A-10006','Hyundai','Accent',2020,'Gray',5,'MANUAL','PETROL',420000,'AVAILABLE','img/6.jpg','Ổn định',NOW(),NOW()),
(1,'Mazda 3 1','43A-10007','Mazda','3',2021,'Black',5,'AUTO','PETROL',650000,'AVAILABLE','img/7.jpg','Sang trọng',NOW(),NOW()),
(2,'Mazda 3 2','43A-10008','Mazda','3',2022,'Red',5,'AUTO','PETROL',680000,'AVAILABLE','img/8.jpg','Đẹp',NOW(),NOW()),
(1,'Kia Cerato 1','43A-10009','Kia','Cerato',2020,'Blue',5,'AUTO','PETROL',600000,'AVAILABLE','img/9.jpg','Bền',NOW(),NOW()),
(2,'Kia Cerato 2','43A-10010','Kia','Cerato',2021,'White',5,'AUTO','PETROL',620000,'AVAILABLE','img/10.jpg','Ngon',NOW(),NOW()),
(1,'Ford Ranger 1','43A-10011','Ford','Ranger',2022,'Black',5,'AUTO','DIESEL',900000,'AVAILABLE','img/11.jpg','Bán tải',NOW(),NOW()),
(2,'Ford Ranger 2','43A-10012','Ford','Ranger',2021,'Gray',5,'AUTO','DIESEL',880000,'AVAILABLE','img/12.jpg','Mạnh',NOW(),NOW()),
(1,'VinFast VF e34 1','43A-10013','VinFast','VF e34',2023,'Blue',5,'AUTO','ELECTRIC',800000,'AVAILABLE','img/13.jpg','Xe điện',NOW(),NOW()),
(2,'VinFast VF e34 2','43A-10014','VinFast','VF e34',2023,'White',5,'AUTO','ELECTRIC',820000,'AVAILABLE','img/14.jpg','Hiện đại',NOW(),NOW()),
(1,'Toyota Fortuner','43A-10015','Toyota','Fortuner',2022,'Black',7,'AUTO','DIESEL',1000000,'AVAILABLE','img/15.jpg','SUV',NOW(),NOW());

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
INSERT INTO car_availability (car_id, start_date, end_date, is_available, note)
VALUES
(1,'2026-03-25','2026-03-30',1,'OK'),
(2,'2026-03-25','2026-03-30',1,'OK'),
(3,'2026-03-25','2026-03-30',0,'Booked'),
(4,'2026-03-25','2026-03-30',1,'OK'),
(5,'2026-03-25','2026-03-30',1,'OK'),
(6,'2026-03-25','2026-03-30',0,'Busy'),
(7,'2026-03-25','2026-03-30',1,'OK'),
(8,'2026-03-25','2026-03-30',1,'OK'),
(9,'2026-03-25','2026-03-30',1,'OK'),
(10,'2026-03-25','2026-03-30',0,'Booked'),
(11,'2026-03-25','2026-03-30',1,'OK'),
(12,'2026-03-25','2026-03-30',1,'OK'),
(13,'2026-03-25','2026-03-30',1,'OK'),
(14,'2026-03-25','2026-03-30',0,'Busy'),
(15,'2026-03-25','2026-03-30',1,'OK');
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


CREATE TABLE bank_accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id INT NOT NULL,
    bank_code VARCHAR(20) NOT NULL,
    account_number VARCHAR(50) NOT NULL,
    account_name VARCHAR(100) NOT NULL,
    branch VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_bank_user
        FOREIGN KEY (owner_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    customer_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_days INT NOT NULL,
    total_price DECIMAL(12,2) NOT NULL,
    booking_status ENUM('PENDING', 'APPROVED', 'PICKED_UP', 'RETURN', 'COMPLETED', 'CANCELLED', 'REJECTED') DEFAULT 'PENDING',
    FOREIGN KEY(car_id) REFERENCES cars(id),
    FOREIGN KEY(customer_id) REFERENCES users(user_id),
    CHECK (end_date >= start_date)
);

INSERT INTO bookings (car_id, customer_id, start_date, end_date, total_days, total_price, booking_status)
VALUES
(1,3,'2026-03-25','2026-03-27',3,1500000,'PENDING'),
(2,4,'2026-03-25','2026-03-27',3,1600000,'APPROVED'),
(3,5,'2026-03-25','2026-03-27',3,2100000,'COMPLETED'),
(4,3,'2026-03-25','2026-03-26',2,1400000,'PENDING'),
(5,4,'2026-03-25','2026-03-28',4,1600000,'APPROVED'),
(6,5,'2026-03-25','2026-03-27',3,1260000,'COMPLETED'),
(7,3,'2026-03-25','2026-03-27',3,1950000,'PENDING'),
(8,4,'2026-03-25','2026-03-27',3,2040000,'APPROVED'),
(9,5,'2026-03-25','2026-03-27',3,1800000,'COMPLETED'),
(10,3,'2026-03-25','2026-03-27',3,1860000,'PENDING'),
(11,4,'2026-03-25','2026-03-27',3,2700000,'APPROVED'),
(12,5,'2026-03-25','2026-03-27',3,2640000,'COMPLETED'),
(13,3,'2026-03-25','2026-03-27',3,2400000,'PENDING'),
(14,4,'2026-03-25','2026-03-27',3,2460000,'APPROVED'),
(15,5,'2026-03-25','2026-03-27',3,3000000,'COMPLETED');



-- =============================
-- PAYMENTS
-- =============================
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    payment_method ENUM('CASH','BANK_TRANSFER','MOMO','VNPAY','PAYPAL'),
    payment_status ENUM('UNPAID','PAID','REFUNDED') DEFAULT 'UNPAID',
    paid_at DATETIME,
    FOREIGN KEY(booking_id) REFERENCES bookings(booking_id)
);

INSERT INTO payments (booking_id, amount, payment_method, payment_status, paid_at)
VALUES
(1,1500000,'CASH','UNPAID',NULL),
(2,1600000,'BANK_TRANSFER','PAID',NOW()),
(3,2100000,'CASH','PAID',NOW()),
(4,1400000,'CASH','UNPAID',NULL),
(5,1600000,'BANK_TRANSFER','PAID',NOW()),
(6,1260000,'CASH','PAID',NOW()),
(7,1950000,'CASH','UNPAID',NULL),
(8,2040000,'BANK_TRANSFER','PAID',NOW()),
(9,1800000,'CASH','PAID',NOW()),
(10,1860000,'CASH','UNPAID',NULL),
(11,2700000,'BANK_TRANSFER','PAID',NOW()),
(12,2640000,'CASH','PAID',NOW()),
(13,2400000,'CASH','UNPAID',NULL),
(14,2460000,'BANK_TRANSFER','PAID',NOW()),
(15,3000000,'CASH','PAID',NOW());
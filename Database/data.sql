CREATE DATABASE car_rental_db;
USE car_rental_db;




-- 2. Roles
CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(20) NOT NULL UNIQUE
);

INSERT INTO roles (role_name) VALUES
('CUSTOMER'), ('OWNER'), ('ADMIN');

-- 3. Users
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    status ENUM('ACTIVE','BLOCKED') DEFAULT 'ACTIVE',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 4. User Roles
CREATE TABLE user_roles (
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE
);

-- 5. Cars
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

-- 6. Car Images
CREATE TABLE car_images (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    FOREIGN KEY (car_id) REFERENCES cars(car_id) ON DELETE CASCADE
);

-- 7. Car Availability
CREATE TABLE car_availability (
    availability_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('AVAILABLE','BOOKED') DEFAULT 'AVAILABLE',
    FOREIGN KEY (car_id) REFERENCES cars(car_id) ON DELETE CASCADE
);

-- 8. Bookings
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

-- 9. Booking History
CREATE TABLE booking_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    status VARCHAR(30),
    note TEXT,
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE
);

-- 10. Payments
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('CASH','MOMO','VNPAY','PAYPAL'),
    payment_status ENUM('PAID','UNPAID','REFUNDED') DEFAULT 'UNPAID',
    paid_at DATETIME,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);



-- 12. Indexes
CREATE INDEX idx_booking_car ON bookings(car_id);
CREATE INDEX idx_booking_customer ON bookings(customer_id);
CREATE INDEX idx_car_owner ON cars(owner_id);

-- 13. Revenue View (Admin)
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

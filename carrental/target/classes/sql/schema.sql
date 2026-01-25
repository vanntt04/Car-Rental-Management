-- Create database
CREATE DATABASE IF NOT EXISTS car_rental_db;
USE car_rental_db;

-- Create cars table
CREATE TABLE IF NOT EXISTS cars (
    id INT AUTO_INCREMENT PRIMARY KEY,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    license_plate VARCHAR(20) NOT NULL UNIQUE,
    color VARCHAR(30),
    price_per_day DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Available',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO cars (brand, model, license_plate, color, price_per_day, status) VALUES
('Toyota', 'Camry', 'ABC-1234', 'White', 50.00, 'Available'),
('Honda', 'Civic', 'XYZ-5678', 'Black', 45.00, 'Available'),
('Ford', 'Focus', 'DEF-9012', 'Red', 40.00, 'Rented'),
('BMW', '320i', 'GHI-3456', 'Blue', 80.00, 'Available'),
('Mercedes', 'C-Class', 'JKL-7890', 'Silver', 90.00, 'Maintenance');

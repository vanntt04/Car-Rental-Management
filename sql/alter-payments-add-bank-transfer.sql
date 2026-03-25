-- Chạy 1 lần trên DB đã tạo từ bản data.sql cũ (ENUM thiếu BANK_TRANSFER).
-- Sau đó chọn "Chuyển khoản" sẽ INSERT/UPDATE payment_method được.

USE car_rental_db;

ALTER TABLE payments
MODIFY COLUMN payment_method ENUM('CASH','BANK_TRANSFER','MOMO','VNPAY','PAYPAL');

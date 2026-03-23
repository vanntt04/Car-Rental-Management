-- Chạy script này trong MySQL để bảng cars có đủ cột cho ứng dụng.
-- Nếu cột đã tồn tại, bỏ qua lệnh tương ứng hoặc chạy từng lệnh một.

-- Cột ảnh chính của xe (đường dẫn file sau khi upload)
ALTER TABLE cars ADD COLUMN image_url VARCHAR(500) NULL COMMENT 'Đường dẫn ảnh chính, VD: /uploads/cars/xxx.jpg';

-- Cột thời gian tạo/cập nhật (dùng cho sắp xếp theo ngày)
ALTER TABLE cars ADD COLUMN created_at DATETIME NULL;
ALTER TABLE cars ADD COLUMN updated_at DATETIME NULL;

-- Mô tả xe (tùy chọn)
ALTER TABLE cars ADD COLUMN description TEXT NULL;

-- Trạng thái hoạt động: 1=còn hoạt động, 0=ngừng hoạt động (không xóa xe, chỉ ẩn)
ALTER TABLE cars ADD COLUMN is_active TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1=còn hoạt động, 0=không còn hoạt động';

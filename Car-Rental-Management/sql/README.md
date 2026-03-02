# Script SQL

## schema-car-rental.sql (khuyến nghị)

**Schema đầy đủ khớp với code Java:** roles, users, user_roles, **cars** (cột `id`, `image_url`, `status` AVAILABLE/RENTED/MAINTENANCE), **car_availability**, **car_images**, bookings, payments.

Chạy để tạo lại database từ đầu (sẽ xóa dữ liệu cũ):

```bash
mysql -u root -p < sql/schema-car-rental.sql
```

Hoặc trong MySQL Workbench: mở file `schema-car-rental.sql` và Execute.

---

## alter-cars-add-columns.sql

Chỉ dùng khi **đã có database cũ** và không muốn tạo lại. Thêm cột thiếu vào bảng `cars`:

- **"Unknown column 'image_url' in 'field list'"** khi thêm/sửa xe

Chạy từng lệnh `ALTER TABLE` trong file. Nếu báo cột đã tồn tại thì bỏ qua.  
Lưu ý: bảng `cars` trong schema cũ dùng `car_id` thì code đang mong `id` — nên dùng `schema-car-rental.sql` để tạo lại DB cho đúng.

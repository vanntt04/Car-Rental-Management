# Hướng dẫn khắc phục lỗi - Car Rental Management

## 1. Lỗi "context failed to start" khi deploy

**Xem log chi tiết:**
- Trong NetBeans: tab **Output** → chọn **Apache Tomcat or TomEE**
- Hoặc mở file log Tomcat: `[thư mục Tomcat]/logs/catalina.out` hoặc `localhost.*.log`
- Tìm dòng có `SEVERE`, `Exception`, hoặc `Caused by` để biết lỗi cụ thể

**Các nguyên nhân thường gặp:**

**Nguyên nhân thường gặp:**
- Dự án dùng **Jakarta EE** (jakarta.servlet) → cần **Tomcat 10 trở lên**
- Nếu NetBeans dùng Tomcat 9 hoặc cũ hơn → sẽ lỗi vì Tomcat 9 dùng `javax.*`

**Cách xử lý:**
- **Option A (Khuyến nghị):** Chạy bằng Maven, không cần cấu hình server:
  ```
  mvn clean package org.codehaus.cargo:cargo-maven3-plugin:run
  ```
  Hoặc dùng file `run.bat` (double-click hoặc `run.bat` trong CMD)

- **Option B:** Cấu hình NetBeans dùng **Tomcat 10**:
  1. Tải Tomcat 10: https://tomcat.apache.org/download-10.cgi
  2. Tools → Servers → Add Server → Apache Tomcat
  3. Chọn thư mục Tomcat 10
  4. Trong Project Properties → Run → chọn Tomcat 10

---

## 2. Lỗi "port 8080 is already in use"

**Cách 1 – Tắt tiến trình đang chiếm port:**
```cmd
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

**Cách 2 – Chạy app ở port khác (ví dụ 8081):**
```cmd
mvn cargo:run -Dcargo.servlet.port=8081
```
Sau đó truy cập: http://localhost:8081/Car-Rental-Management/

Hoặc với `run.bat`: `run.bat 8081`

---

## 3. Chạy bằng Maven Cargo (bỏ qua NetBeans)

Nếu vẫn lỗi khi deploy qua NetBeans, chạy trực tiếp:

```cmd
cd D:\SWP391_SP26\Car-Rental-Management\Car-Rental-Management
run.bat
```

Hoặc:
```cmd
mvn clean package org.codehaus.cargo:cargo-maven3-plugin:run
```

Sau đó mở: http://localhost:8080/Car-Rental-Management/

---

## 4. Lỗi kết nối database

Đảm bảo:
1. **MySQL đang chạy**
2. Đã tạo database: `CREATE DATABASE car_rental_db;`
3. Đã chạy script SQL: `sql/schema-car-rental.sql`
4. Sửa `src/main/resources/db.properties` nếu cần:
   - `db.user` – user MySQL
   - `db.password` – mật khẩu MySQL

---

## 5. NetBeans không thấy Server

1. Tools → Servers → Add Server
2. Chọn Apache Tomcat (hoặc TomEE)
3. Trỏ đến thư mục Tomcat 10 đã cài
4. Chuột phải project → Properties → Run → chọn server vừa thêm

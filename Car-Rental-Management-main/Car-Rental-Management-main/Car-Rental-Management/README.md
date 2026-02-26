# Car Rental Management System

Hệ thống quản lý thuê xe được xây dựng theo mô hình **MVC (Model-View-Controller)**.

## Cấu trúc dự án

```
Car-Rental-Management/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/example/carrental/
│   │   │       ├── controller/          # Controller Layer (MVC)
│   │   │       │   ├── HomeServlet.java
│   │   │       │   ├── CarServlet.java
│   │   │       │   └── UserServlet.java
│   │   │       └── model/                # Model Layer (MVC)
│   │   │           ├── entity/           # Entities
│   │   │           │   ├── Car.java
│   │   │           │   └── User.java
│   │   │           ├── dao/              # Data Access Objects
│   │   │           │   ├── CarDAO.java
│   │   │           │   └── UserDAO.java
│   │   │           └── util/            # Utilities
│   │   │               └── DBConnection.java
│   │   ├── webapp/                       # View Layer (MVC)
│   │   │   ├── index.jsp
│   │   │   └── WEB-INF/
│   │   │       ├── web.xml
│   │   │       └── views/
│   │   │           ├── home.jsp
│   │   │           ├── car/
│   │   │           │   ├── list.jsp
│   │   │           │   └── detail.jsp
│   │   │           └── user/
│   │   │               └── list.jsp
│   │   └── resources/
│   │       └── sql/
│   │           └── schema.sql
│   └── test/
└── pom.xml
```

## Mô hình MVC

### Model Layer
- **Entities**: `Car.java`, `User.java` - Đại diện cho các đối tượng dữ liệu
- **DAO (Data Access Object)**: `CarDAO.java`, `UserDAO.java` - Xử lý truy cập database
- **Utilities**: `DBConnection.java` - Quản lý kết nối database

### View Layer
- **JSP Files**: Các file JSP trong `webapp/WEB-INF/views/` hiển thị giao diện người dùng
  - `home.jsp` - Trang chủ
  - `car/list.jsp` - Danh sách xe
  - `car/detail.jsp` - Chi tiết xe
  - `user/list.jsp` - Danh sách người dùng

### Controller Layer
- **Servlets**: Xử lý các request từ client và điều phối giữa Model và View
  - `HomeServlet.java` - Xử lý trang chủ
  - `CarServlet.java` - Xử lý các thao tác với xe (CRUD)
  - `UserServlet.java` - Xử lý các thao tác với người dùng (CRUD)

## Công nghệ sử dụng

- **Java 17**
- **Jakarta Servlet API 6.0**
- **JSP (Jakarta Server Pages)**
- **JSTL (Jakarta Standard Tag Library)**
- **MySQL 8.0**
- **Maven** - Quản lý dependencies

## Cài đặt và chạy

### Yêu cầu
- JDK 17+
- Maven 3.6+
- MySQL 8.0+
- Apache Tomcat 10+ (hoặc server tương thích Jakarta EE)

### Các bước

1. **Tạo database:**
   ```sql
   -- Chạy script trong file src/main/resources/sql/schema.sql
   ```

2. **Cấu hình database:**
   - Mở file `src/main/java/com/example/carrental/model/util/DBConnection.java`
   - Cập nhật thông tin kết nối:
     - `DB_URL`: URL database
     - `DB_USER`: Username
     - `DB_PASSWORD`: Password

3. **Build project:**
   ```bash
   mvn clean compile
   ```

4. **Package WAR:**
   ```bash
   mvn package
   ```

5. **Deploy:**
   - Copy file `target/Car-Rental-Management-1.0-SNAPSHOT.war` vào thư mục `webapps` của Tomcat
   - Hoặc chạy trực tiếp với Maven Tomcat plugin

## Cấu trúc URL

- `/` hoặc `/home` - Trang chủ
- `/cars` - Danh sách xe
- `/cars?id={id}` - Chi tiết xe
- `/users` - Danh sách người dùng

## Tính năng

- ✅ Quản lý xe (Xem danh sách, chi tiết)
- ✅ Quản lý người dùng (Xem danh sách)
- ✅ Giao diện responsive
- ✅ Kiến trúc MVC rõ ràng, dễ bảo trì

## Mở rộng

Có thể mở rộng thêm các tính năng:
- Thêm/Sửa/Xóa xe và người dùng (form)
- Đăng nhập/Đăng xuất
- Quản lý đơn thuê xe
- Tìm kiếm và lọc
- Phân trang

## Tác giả

Dự án được xây dựng theo mô hình MVC chuẩn.

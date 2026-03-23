package com.example.carrental.model.dao;

import com.example.carrental.model.entity.Car;
import com.example.carrental.model.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.TimeZone;

/**
 * Data Access Object cho Car entity Model layer - DAO pattern
 */
public class CarDAO {

    private DBConnection dbConnection;

    public CarDAO() {
        this.dbConnection = DBConnection.getInstance();
    }

    /**
     * Sort: date_desc (mới nhất), date_asc (cũ nhất). Status: null/empty = tất
     * cả. activeFilter: null/empty = tất cả, "1" = còn hoạt động, "0" = ngừng
     * hoạt động
     */
    public List<Car> getCarsByOwnerId(int ownerId, int offset, int limit, String statusFilter, String activeFilter, String sortBy) {
        List<Car> cars = new ArrayList<>();
        String order = "date_asc".equalsIgnoreCase(sortBy) ? "id ASC" : "id DESC";
        String sql = "SELECT * FROM cars WHERE owner_id = ? ";
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql += "AND status = ? ";
        }
        if (activeFilter != null && !activeFilter.isEmpty()) {
            sql += "AND is_active = ? ";
        }
        sql += "ORDER BY " + order + " LIMIT ? OFFSET ?";
        try (Connection conn = dbConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setInt(idx++, ownerId);
            if (statusFilter != null && !statusFilter.isEmpty()) {
                ps.setString(idx++, statusFilter);
            }
            if (activeFilter != null && !activeFilter.isEmpty()) {
                ps.setInt(idx++, "1".equals(activeFilter) ? 1 : 0);
            }
            ps.setInt(idx++, limit);
            ps.setInt(idx++, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    cars.add(mapResultSetToCar(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting cars by owner: " + e.getMessage());
        }
        return cars;
    }

    /**
     * Đếm số xe của owner (có thể lọc theo status và active)
     */
    public int countCarsByOwnerId(int ownerId, String statusFilter, String activeFilter) {
        String sql = "SELECT COUNT(*) FROM cars WHERE owner_id = ?";
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql += " AND status = ?";
        }
        if (activeFilter != null && !activeFilter.isEmpty()) {
            sql += " AND is_active = ?";
        }
        try (Connection conn = dbConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setInt(idx++, ownerId);
            if (statusFilter != null && !statusFilter.isEmpty()) {
                ps.setString(idx++, statusFilter);
            }
            if (activeFilter != null && !activeFilter.isEmpty()) {
                ps.setInt(idx++, "1".equals(activeFilter) ? 1 : 0);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            rs.close();
        } catch (SQLException e) {
            System.err.println("Error count cars by owner: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Lấy xe theo chủ sở hữu (owner) - không phân trang (giữ cho tương thích)
     */
    public List<Car> getCarsByOwnerId(int ownerId) {
        return getCarsByOwnerId(ownerId, 0, Integer.MAX_VALUE, null, null, "date_desc");
    }

    /**
     * Lấy tất cả các xe (dùng nội bộ, không lọc active)
     */
    public List<Car> getAllCars() {
        List<Car> cars = new ArrayList<>();
        String sql = "SELECT * FROM cars ORDER BY id DESC";
        try (Connection conn = dbConnection.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                cars.add(mapResultSetToCar(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting all cars: " + e.getMessage());
            e.printStackTrace();
        }
        return cars;
    }
    public List<Car> getAllSelectCars(int user_id) {
        String sql = "SELECT cars.* FROM cars join car_select on cars.id = car_select.car_id WHERE user_id = ? ";
        List<Car> cars = new ArrayList<>();

        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, user_id);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                cars.add(mapResultSetToCar(rs));
            }

            rs.close();
        } catch (SQLException e) {
            System.err.println("Error getting car by id: " + e.getMessage());
            e.printStackTrace();
        }

        return cars;
    }

    /**
     * Lấy danh sách xe còn hoạt động (cho khách xem danh sách công khai)
     */
    public List<Car> getActiveCars() {
        List<Car> cars = new ArrayList<>();
        String sql = "SELECT * FROM cars WHERE is_active = 1 ORDER BY id DESC";
        try (Connection conn = dbConnection.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                cars.add(mapResultSetToCar(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting active cars: " + e.getMessage());
        }
        return cars;
    }

    public boolean setCarOnHold(int carId, int userId, LocalDateTime holdStart, int minutes) {
        String insertHold = "INSERT INTO car_select (car_id, user_id, hold_start, hold_until) VALUES (?, ?, ?, ?)";
        String updateCar = "UPDATE cars SET status = 'RENTED' WHERE id = ?";

        try (Connection conn = dbConnection.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement(insertHold); PreparedStatement ps2 = conn.prepareStatement(updateCar)) {

                // Chuyển LocalDateTime sang Timestamp
                Timestamp tsStart = Timestamp.valueOf(holdStart);
                Timestamp tsEnd = Timestamp.valueOf(holdStart.plusMinutes(minutes));

                // Lưu hold vào bảng car_select
                ps1.setInt(1, carId);
                ps1.setInt(2, userId);
                ps1.setTimestamp(3, tsStart);
                ps1.setTimestamp(4, tsEnd);
                ps1.executeUpdate();

                // Cập nhật trạng thái xe thành RENTED
                ps2.setInt(1, carId);
                ps2.executeUpdate();

                conn.commit();
                return true;

            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public void releaseExpiredHolds() {
        String selectHolds = "SELECT car_id, hold_until FROM car_select";
        String updateCar = "UPDATE cars SET status = 'AVAILABLE' WHERE id = ?";
        String deleteHold = "DELETE FROM car_select WHERE car_id = ?";

        try (Connection conn = dbConnection.getConnection()) {
            conn.setAutoCommit(false);

            // 1. Giờ hiện tại chuẩn UTC
            LocalDateTime nowUtc = LocalDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh"));

            // 2. Lấy danh sách hold
            try (PreparedStatement psSelect = conn.prepareStatement(selectHolds)) {
                ResultSet rs = psSelect.executeQuery();
                while (rs.next()) {
                    // Lấy hold_until chuẩn UTC
                    Timestamp ts = rs.getTimestamp("hold_until");
                    LocalDateTime holdUntilUtc = ts.toLocalDateTime();

                    int carId = rs.getInt("car_id");

                    // 3. Nếu hold đã hết hạn → update status và xóa hold
                    if (holdUntilUtc.isBefore(nowUtc)) {
                        // Update status xe
                        try (PreparedStatement psUpdate = conn.prepareStatement(updateCar)) {
                            psUpdate.setInt(1, carId);
                            psUpdate.executeUpdate();
                        }

                        // Xóa hold
                        try (PreparedStatement psDelete = conn.prepareStatement(deleteHold)) {
                            psDelete.setInt(1, carId);
                            psDelete.executeUpdate();
                        }

                        System.out.println("Released hold for Car ID: " + carId);
                    }
                }
            }

            conn.commit();
            System.out.println("Expired holds released successfully.");

        } catch (SQLException e) {

        }
    }

    /**
     * Lấy xe theo ID
     * @param id
     * @return 
     */
    public Car getCarById(int id) {
        String sql = "SELECT * FROM cars WHERE id = ?";
        Car car = null;

        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    car = mapResultSetToCar(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting car by id: " + e.getMessage());
            e.printStackTrace();
        }

        return car;
    }

    /**
     * Thêm xe mới
     */
    public boolean addCar(Car car) throws SQLException {
        String sql = "INSERT INTO cars (owner_id, name, license_plate, brand, model, year, color, price_per_day, status, is_active, image_url, description) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setObject(1, car.getOwnerId(), Types.INTEGER);
            pstmt.setString(2, car.getName());
            pstmt.setString(3, car.getLicensePlate());
            pstmt.setString(4, car.getBrand());
            pstmt.setString(5, car.getModel());
            pstmt.setObject(6, car.getYear(), Types.INTEGER);
            pstmt.setString(7, car.getColor());
            pstmt.setBigDecimal(8, car.getPricePerDay());
            pstmt.setString(9, car.getStatus());
            pstmt.setInt(10, car.isActive() ? 1 : 0);
            pstmt.setString(11, car.getImageUrl());
            pstmt.setString(12, car.getDescription());
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Cập nhật thông tin xe
     */
    public boolean updateCar(Car car) throws SQLException {
        String sql = "UPDATE cars SET owner_id = ?, name = ?, license_plate = ?, brand = ?, model = ?, "
                + "year = ?, color = ?, price_per_day = ?, status = ?, is_active = ?, image_url = ?, description = ? "
                + "WHERE id = ?";
        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setObject(1, car.getOwnerId(), Types.INTEGER);
            pstmt.setString(2, car.getName());
            pstmt.setString(3, car.getLicensePlate());
            pstmt.setString(4, car.getBrand());
            pstmt.setString(5, car.getModel());
            pstmt.setObject(6, car.getYear(), Types.INTEGER);
            pstmt.setString(7, car.getColor());
            pstmt.setBigDecimal(8, car.getPricePerDay());
            pstmt.setString(9, car.getStatus());
            pstmt.setInt(10, car.isActive() ? 1 : 0);
            pstmt.setString(11, car.getImageUrl());
            pstmt.setString(12, car.getDescription());
            pstmt.setInt(13, car.getId());
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Xóa xe
     */
    public boolean deleteCar(int id) {
        String sql = "DELETE FROM cars WHERE id = ?";

        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting car: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Map ResultSet thành Car object
     */
    private Car mapResultSetToCar(ResultSet rs) throws SQLException {
        Car car = new Car();
        car.setId(rs.getInt("id"));
        try {
            int ownerId = rs.getInt("owner_id");
            car.setOwnerId(rs.wasNull() ? null : ownerId);
        } catch (SQLException e) {
            car.setOwnerId(null);
        }
        car.setName(rs.getString("name"));
        car.setLicensePlate(rs.getString("license_plate"));
        car.setBrand(rs.getString("brand"));
        car.setModel(rs.getString("model"));
        car
                .setYear(rs.getObject("year", Integer.class
                ));
        car.setColor(rs.getString("color"));

        try {
            car.setSeats(rs.getObject("seats", Integer.class
            ));
        } catch (SQLException e) {
            car.setSeats(null);
        }
        try {
            car.setTransmission(rs.getString("transmission"));
        } catch (SQLException e) {
            car.setTransmission(null);
        }
        try {
            car.setFuelType(rs.getString("fuel_type"));
        } catch (SQLException e) {
            car.setFuelType(null);
        }
        car.setPricePerDay(rs.getBigDecimal("price_per_day"));
        car.setStatus(rs.getString("status"));
        try {
            car.setActive(rs.getInt("is_active") == 1);
        } catch (SQLException e) {
            car.setActive(true);
        }
        try {
            car.setImageUrl(rs.getString("image_url"));
        } catch (SQLException e) {
            car.setImageUrl(null);
        }
        try {
            car.setDescription(rs.getString("description"));
        } catch (SQLException e) {
            car.setDescription(null);
        }
        try {
            Timestamp createdAt = rs.getTimestamp("created_at");
            if (createdAt != null) {
                car.setCreatedAt(createdAt.toLocalDateTime());
            }
        } catch (SQLException e) {
        }
        try {
            Timestamp updatedAt = rs.getTimestamp("updated_at");
            if (updatedAt != null) {
                car.setUpdatedAt(updatedAt.toLocalDateTime());
            }
        } catch (SQLException e) {
        }
        return car;
    }
}

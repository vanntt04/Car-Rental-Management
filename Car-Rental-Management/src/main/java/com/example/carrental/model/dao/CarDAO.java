package com.example.carrental.model.dao;

import com.example.carrental.model.entity.Car;
import com.example.carrental.model.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object cho Car entity
 * Model layer - DAO pattern
 */
public class CarDAO {
    private DBConnection dbConnection;

    public CarDAO() {
        this.dbConnection = DBConnection.getInstance();
    }

    /** Sort: date_desc (mới nhất), date_asc (cũ nhất). Status: null/empty = tất cả, AVAILABLE, RENTED, MAINTENANCE */
    public List<Car> getCarsByOwnerId(int ownerId, int offset, int limit, String statusFilter, String sortBy) {
        List<Car> cars = new ArrayList<>();
        String order = "date_asc".equalsIgnoreCase(sortBy) ? "COALESCE(created_at, updated_at) ASC, id ASC" : "COALESCE(created_at, updated_at) DESC, id DESC";
        String sql = "SELECT * FROM cars WHERE owner_id = ? ";
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql += "AND status = ? ";
        }
        sql += "ORDER BY " + order + " LIMIT ? OFFSET ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setInt(idx++, ownerId);
            if (statusFilter != null && !statusFilter.isEmpty()) {
                ps.setString(idx++, statusFilter);
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

    /** Đếm số xe của owner (có thể lọc theo status) */
    public int countCarsByOwnerId(int ownerId, String statusFilter) {
        String sql = "SELECT COUNT(*) FROM cars WHERE owner_id = ?";
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql += " AND status = ?";
        }
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            if (statusFilter != null && !statusFilter.isEmpty()) {
                ps.setString(2, statusFilter);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
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
        return getCarsByOwnerId(ownerId, 0, Integer.MAX_VALUE, null, "date_desc");
    }

    /**
     * Lấy tất cả các xe
     */
    public List<Car> getAllCars() {
        List<Car> cars = new ArrayList<>();
        String sql = "SELECT * FROM cars ORDER BY id DESC";
        
        try (Connection conn = dbConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                cars.add(mapResultSetToCar(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting all cars: " + e.getMessage());
            e.printStackTrace();
        }
        
        return cars;
    }

    /**
     * Lấy xe theo ID
     */
    public Car getCarById(int id) {
        String sql = "SELECT * FROM cars WHERE id = ?";
        Car car = null;
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                car = mapResultSetToCar(rs);
            }
            
            rs.close();
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
        String sql = "INSERT INTO cars (owner_id, name, license_plate, brand, model, year, color, price_per_day, status, image_url) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setObject(1, car.getOwnerId(), Types.INTEGER);
            pstmt.setString(2, car.getName());
            pstmt.setString(3, car.getLicensePlate());
            pstmt.setString(4, car.getBrand());
            pstmt.setString(5, car.getModel());
            pstmt.setObject(6, car.getYear(), Types.INTEGER);
            pstmt.setString(7, car.getColor());
            pstmt.setBigDecimal(8, car.getPricePerDay());
            pstmt.setString(9, car.getStatus());
            pstmt.setString(10, car.getImageUrl());
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Cập nhật thông tin xe
     */
    public boolean updateCar(Car car) throws SQLException {
        String sql = "UPDATE cars SET owner_id = ?, name = ?, license_plate = ?, brand = ?, model = ?, " +
                     "year = ?, color = ?, price_per_day = ?, status = ?, image_url = ? " +
                     "WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setObject(1, car.getOwnerId(), Types.INTEGER);
            pstmt.setString(2, car.getName());
            pstmt.setString(3, car.getLicensePlate());
            pstmt.setString(4, car.getBrand());
            pstmt.setString(5, car.getModel());
            pstmt.setObject(6, car.getYear(), Types.INTEGER);
            pstmt.setString(7, car.getColor());
            pstmt.setBigDecimal(8, car.getPricePerDay());
            pstmt.setString(9, car.getStatus());
            pstmt.setString(10, car.getImageUrl());
            pstmt.setInt(11, car.getId());
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Xóa xe
     */
    public boolean deleteCar(int id) {
        String sql = "DELETE FROM cars WHERE id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
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
        car.setYear(rs.getObject("year", Integer.class));
        car.setColor(rs.getString("color"));
        car.setPricePerDay(rs.getBigDecimal("price_per_day"));
        car.setStatus(rs.getString("status"));
        car.setImageUrl(rs.getString("image_url"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            car.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            car.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        return car;
    }
}

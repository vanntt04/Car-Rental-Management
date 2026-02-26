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
    public boolean addCar(Car car) {
        String sql = "INSERT INTO cars (name, license_plate, brand, model, year, color, price_per_day, status, image_url) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, car.getName());
            pstmt.setString(2, car.getLicensePlate());
            pstmt.setString(3, car.getBrand());
            pstmt.setString(4, car.getModel());
            pstmt.setObject(5, car.getYear(), Types.INTEGER);
            pstmt.setString(6, car.getColor());
            pstmt.setBigDecimal(7, car.getPricePerDay());
            pstmt.setString(8, car.getStatus());
            pstmt.setString(9, car.getImageUrl());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error adding car: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cập nhật thông tin xe
     */
    public boolean updateCar(Car car) {
        String sql = "UPDATE cars SET name = ?, license_plate = ?, brand = ?, model = ?, " +
                     "year = ?, color = ?, price_per_day = ?, status = ?, image_url = ? " +
                     "WHERE id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, car.getName());
            pstmt.setString(2, car.getLicensePlate());
            pstmt.setString(3, car.getBrand());
            pstmt.setString(4, car.getModel());
            pstmt.setObject(5, car.getYear(), Types.INTEGER);
            pstmt.setString(6, car.getColor());
            pstmt.setBigDecimal(7, car.getPricePerDay());
            pstmt.setString(8, car.getStatus());
            pstmt.setString(9, car.getImageUrl());
            pstmt.setInt(10, car.getId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating car: " + e.getMessage());
            e.printStackTrace();
            return false;
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

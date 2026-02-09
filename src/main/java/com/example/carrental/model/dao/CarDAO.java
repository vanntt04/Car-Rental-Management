package com.example.carrental.model.dao;

import com.example.carrental.model.entity.Car;
import com.example.carrental.model.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object cho Car entity Model layer - DAO pattern
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
        String sql = "SELECT c.* , i.image_url FROM cars c join car_images  i  on c.car_id = i.car_id ";

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

    public List<String> getAllBrandCars() {
        List<String> brands = new ArrayList<>();
        String sql = "SELECT DISTINCT brand FROM cars ORDER BY brand";

        try (Connection conn = dbConnection.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                brands.add(rs.getString("brand"));
            }
        } catch (SQLException e) {
            System.err.println("Error getting all brands: " + e.getMessage());
            e.printStackTrace();
        }

        return brands;
    }
    /**
     * Lấy xe theo ID
     */
    public Car getCarById(int id) {
        String sql = "SELECT c.*, i.image_url FROM cars c LEFT JOIN car_images i ON c.car_id = i.car_id WHERE c.car_id = ?";
        Car car = null;

        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

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
        String sql = "INSERT INTO cars (car_name, brand, model, location, description, price_per_day, status, owner_id, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, car.getName());
            pstmt.setString(2, car.getBrand());
            pstmt.setString(3, car.getModel());
            pstmt.setString(4, car.getLocal());
            pstmt.setString(5, car.getDes());
            pstmt.setBigDecimal(6, car.getPricePerDay());
            pstmt.setString(7, car.getStatus());
            pstmt.setInt(8, car.getOwner_id());

            if (car.getCreatedAt() != null) {
                pstmt.setTimestamp(9, Timestamp.valueOf(car.getCreatedAt()));
            } else {
                pstmt.setTimestamp(9, new Timestamp(System.currentTimeMillis()));
            }

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
        String sql = "UPDATE cars SET car_name = ?, brand = ?, model = ?, price_per_day = ?, status = ? WHERE car_id = ?";

        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, car.getName());
            pstmt.setString(2, car.getBrand());
            pstmt.setString(3, car.getModel());
            pstmt.setBigDecimal(4, car.getPricePerDay());
            pstmt.setString(5, car.getStatus());
            pstmt.setInt(6, car.getId());

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
        String sql = "DELETE FROM cars WHERE car_id = ?";

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
        car.setId(rs.getInt("car_id"));
        car.setName(rs.getString("car_name"));
        car.setBrand(rs.getString("brand"));
        car.setModel(rs.getString("model"));
        car.setPricePerDay(rs.getBigDecimal("price_per_day"));
        car.setImg(rs.getString("image_url"));
        car.setStatus(rs.getString("status"));
        car.setLocal(rs.getString("location"));
        car.setDes(rs.getString("description"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            car.setCreatedAt(createdAt.toLocalDateTime());
        }
        return car;
    }
}

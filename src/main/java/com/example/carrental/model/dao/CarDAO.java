package com.example.carrental.model.dao;

import com.example.carrental.model.entity.Car;
import com.example.carrental.model.util.DBConnection;
import java.math.BigDecimal;

import java.sql.*;
import java.time.LocalDate;
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
     *
     * @return
     */
    public List<Car> getAllCars() {
        List<Car> cars = new ArrayList<>();
        String sql = "SELECT c.*, i.image_url "
                + "FROM cars c "
                + "LEFT JOIN car_images i ON c.id = i.car_id AND i.is_primary = 1";

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

    public List<Integer> getAllSeat() {
        List<Integer> Seat = new ArrayList<>();
        String sql = "SELECT DISTINCT seats FROM cars ORDER BY seats";

        try (Connection conn = dbConnection.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Seat.add(rs.getInt("seats"));
            }
        } catch (SQLException e) {
            System.err.println("Error getting all brands: " + e.getMessage());
            e.printStackTrace();
        }

        return Seat;
    }

    /**
     * Lấy xe theo ID
     */
    public Car getCarById(int id) {
        String sql = "SELECT c.*, i.image_url FROM cars c LEFT JOIN car_images i ON c.id = i.car_id WHERE c.id = ?";
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

    public List<Car> getCarByBrand(String brand) {

        String sql = "SELECT c.*, i.image_url "
                + "FROM cars c "
                + "LEFT JOIN car_images i ON c.car_id = i.car_id "
                + "WHERE c.brand = ?";

        List<Car> cars = new ArrayList<>();

        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, brand);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Car car = mapResultSetToCar(rs);
                cars.add(car);
            }

            rs.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cars;
    }

    public List<Car> filterCar(String brand, BigDecimal minPrice, BigDecimal maxPrice, List<Car> list) {
        List<Car> result = new ArrayList<>();

        for (Car car : list) {
            BigDecimal price = car.getPricePerDay();
            if (car.getBrand().equalsIgnoreCase(brand) && price.compareTo(minPrice) >= 0 && price.compareTo(maxPrice) <= 0) {
                result.add(car);
            }
        }

        return result;
    }

    public List<Car> filterCarByBrand(String brand, List<Car> list) {
        List<Car> result = new ArrayList<>();

        for (Car car : list) {
            if (car.getBrand().equalsIgnoreCase(brand)) {
                result.add(car);
            }
        }

        return result;
    }

    public List<Car> filterCarByPrice(BigDecimal minPrice, BigDecimal maxPrice, List<Car> list) {
        List<Car> result = new ArrayList<>();
        for (Car car : list) {
            BigDecimal price = car.getPricePerDay();
            if (price.compareTo(minPrice) >= 0 && price.compareTo(maxPrice) <= 0) {
                result.add(car);
            }
        }

        return result;
    }

    public List<Car> getCarByDate(Integer seat, LocalDate pickTime, LocalDate returnTime) {
        String sql = "SELECT  c.id, c.name, c.brand, c.model, "
                + "c.price_per_day, c.status, c.seats, r.image_url , c.description , c.created_at "
                + "FROM cars c "
                + "LEFT JOIN car_images r ON c.id = r.car_id AND r.is_primary = 1 "
                + "WHERE c.seats = ? "
                + "AND EXISTS ( "
                + "   SELECT 1 FROM car_availability i "
                + "   WHERE i.car_id = c.id "
                + "   AND (? <= i.end_date AND ? >= i.start_date) "
                + ")";

        List<Car> cars = new ArrayList<>();

        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, seat);
            pstmt.setDate(2, Date.valueOf(pickTime));
            pstmt.setDate(3, Date.valueOf(returnTime));

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    cars.add(mapResultSetToCar(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cars;
    }

    public boolean addCar(Car car) {
        String sql = "INSERT INTO cars (car_name, brand, model, location, description, price_per_day, status, owner_id, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, car.getName());
            pstmt.setString(2, car.getBrand());
            pstmt.setString(3, car.getModel());
            pstmt.setString(5, car.getDescription());
            pstmt.setBigDecimal(6, car.getPricePerDay());
            pstmt.setString(7, car.getStatus());
            pstmt.setInt(8, car.getOwnerId());

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

    /**
     * Map ResultSet thành Car object
     */
    private Car mapResultSetToCar(ResultSet rs) throws SQLException {
        Car car = new Car();
        car.setId(rs.getInt("id"));
        car.setSeats(rs.getInt("seats"));
        car.setName(rs.getString("name"));
        car.setBrand(rs.getString("brand"));
        car.setModel(rs.getString("model"));
        car.setPricePerDay(rs.getBigDecimal("price_per_day"));
        car.setImageUrl(rs.getString("image_url"));
        car.setStatus(rs.getString("status"));
        car.setDescription(rs.getString("description"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            car.setCreatedAt(createdAt.toLocalDateTime());
        }
        return car;
    }

    public static void main(String[] args) {
        // Khởi tạo DAO
        CarDAO carDAO = new CarDAO();
        // ===== Test getCarByDate =====
        int seat = 5; // số chỗ
        LocalDate pickTime = LocalDate.of(2026, 12, 6);
        LocalDate returnTime = LocalDate.of(2026, 12, 7);

        List<Car> carsByDate = carDAO.getCarByDate(seat, pickTime, returnTime);

        System.out.println("\n==== Danh sách xe theo số chỗ " + seat + " từ " + pickTime + " đến " + returnTime + " ====");
        for (Car car : carsByDate) {
            System.out.println("ID: " + car.getId());
            System.out.println("Tên xe: " + car.getName());
            System.out.println("Hãng: " + car.getBrand());
            System.out.println("Model: " + car.getModel());
            System.out.println("Giá/ngày: " + car.getPricePerDay());
            System.out.println("Trạng thái: " + car.getStatus());
            System.out.println("Ảnh chính: " + car.getImageUrl());
            System.out.println("Số chỗ: " + car.getSeats());
            System.out.println("-----------------------------");
        }
        System.out.println("Tổng số xe theo ngày và số chỗ: " + carsByDate.size());
    }

}

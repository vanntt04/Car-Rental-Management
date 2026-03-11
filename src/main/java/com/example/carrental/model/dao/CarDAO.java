package com.example.carrental.model.dao;

import com.example.carrental.model.entity.Car;
import com.example.carrental.model.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * CarDAO theo schema mới (cars.id, cars.owner_id, ...).
 */
public class CarDAO {

    private final DBConnection dbConnection;

    public CarDAO() {
        this.dbConnection = DBConnection.getInstance();
    }

    public List<Car> getAllCars() {
        List<Car> cars = new ArrayList<>();
        String sql = "SELECT c.* FROM cars c ORDER BY c.created_at DESC, c.id DESC";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                cars.add(mapResultSetToCar(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getAllCars: " + e.getMessage());
        }
        return cars;
    }

    public List<Car> getActiveCars() {
        List<Car> cars = new ArrayList<>();
        String sql = "SELECT c.* FROM cars c WHERE c.is_active = 1 AND c.status = 'AVAILABLE' ORDER BY c.created_at DESC, c.id DESC";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                cars.add(mapResultSetToCar(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getActiveCars: " + e.getMessage());
        }
        return cars;
    }

    public Car getCarById(int id) {
        String sql = "SELECT c.* FROM cars c WHERE c.id = ?";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToCar(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error getCarById: " + e.getMessage());
        }
        return null;
    }

    public boolean addCar(Car car) throws SQLException {
        String sql = "INSERT INTO cars (owner_id, name, license_plate, brand, model, year, color, seats, fuel_type, price_per_day, status, is_active, image_url, description, created_at, updated_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            bindCarForUpsert(ps, car, false);
            int affected = ps.executeUpdate();

            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) car.setId(keys.getInt(1));
                }
                return true;
            }
            return false;
        }
    }

    public boolean updateCar(Car car) throws SQLException {
        String sql = "UPDATE cars SET name=?, license_plate=?, brand=?, model=?, year=?, color=?, seats=?, fuel_type=?, price_per_day=?, status=?, is_active=?, image_url=?, description=?, updated_at=NOW() " +
                "WHERE id=? AND owner_id=?";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            bindCarForUpsert(ps, car, true);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteCar(int id) {
        String sql = "DELETE FROM cars WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleteCar: " + e.getMessage());
            return false;
        }
    }

    public int countCarsByOwnerId(int ownerId, String statusFilter, String activeFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM cars WHERE owner_id = ?");
        List<Object> params = new ArrayList<>();
        params.add(ownerId);

        if (statusFilter != null && !statusFilter.isBlank()) {
            sql.append(" AND status = ?");
            params.add(statusFilter.trim());
        }
        if (activeFilter != null && !activeFilter.isBlank()) {
            sql.append(" AND is_active = ?");
            params.add("1".equals(activeFilter) || "true".equalsIgnoreCase(activeFilter) ? 1 : 0);
        }

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            bindParams(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error countCarsByOwnerId: " + e.getMessage());
        }
        return 0;
    }

    public List<Car> getCarsByOwnerId(int ownerId, int offset, int pageSize,
                                      String statusFilter, String activeFilter, String sortBy) {
        List<Car> cars = new ArrayList<>();

        String orderBy = " ORDER BY created_at DESC, id DESC ";
        if ("price_asc".equalsIgnoreCase(sortBy)) orderBy = " ORDER BY price_per_day ASC, id DESC ";
        if ("price_desc".equalsIgnoreCase(sortBy)) orderBy = " ORDER BY price_per_day DESC, id DESC ";

        StringBuilder sql = new StringBuilder("SELECT * FROM cars WHERE owner_id = ?");
        List<Object> params = new ArrayList<>();
        params.add(ownerId);

        if (statusFilter != null && !statusFilter.isBlank()) {
            sql.append(" AND status = ?");
            params.add(statusFilter.trim());
        }
        if (activeFilter != null && !activeFilter.isBlank()) {
            sql.append(" AND is_active = ?");
            params.add("1".equals(activeFilter) || "true".equalsIgnoreCase(activeFilter) ? 1 : 0);
        }

        sql.append(orderBy).append(" LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add(offset);

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            bindParams(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    cars.add(mapResultSetToCar(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getCarsByOwnerId: " + e.getMessage());
        }
        return cars;
    }

    public List<String> getAllBrandCars() {
        List<String> brands = new ArrayList<>();
        String sql = "SELECT DISTINCT brand FROM cars WHERE brand IS NOT NULL AND brand <> '' ORDER BY brand";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                brands.add(rs.getString("brand"));
            }
        } catch (SQLException e) {
            System.err.println("Error getAllBrandCars: " + e.getMessage());
        }
        return brands;
    }

    // Schema không có cột location -> trả list rỗng để tương thích các màn cũ
    public List<String> getAllLocalCars() {
        return new ArrayList<>();
    }

    // Không dùng CarAvailabilityDAO: lọc xe còn trống theo bookings
    public List<Car> getCarByDate(String location, LocalDate pickTime, LocalDate returnTime) {
        List<Car> cars = new ArrayList<>();
        String sql = "SELECT c.* FROM cars c " +
                "WHERE c.is_active = 1 AND c.status = 'AVAILABLE' " +
                "AND NOT EXISTS (" +
                "    SELECT 1 FROM bookings b " +
                "    WHERE b.car_id = c.id " +
                "      AND b.booking_status IN ('PENDING','APPROVED') " +
                "      AND NOT (b.end_date < ? OR b.start_date > ?)" +
                ") " +
                "ORDER BY c.created_at DESC, c.id DESC";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(pickTime));
            ps.setDate(2, Date.valueOf(returnTime));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    cars.add(mapResultSetToCar(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getCarByDate: " + e.getMessage());
        }
        return cars;
    }

    public List<Car> filterCar(String brand, int minPrice, int maxPrice, List<Car> list) {
        List<Car> result = new ArrayList<>();
        for (Car car : list) {
            if ((brand == null || brand.isBlank() || (car.getBrand() != null && car.getBrand().equalsIgnoreCase(brand)))
                    && car.getPricePerDay() >= minPrice
                    && car.getPricePerDay() <= maxPrice) {
                result.add(car);
            }
        }
        return result;
    }

    public List<Car> filterCarByBrand(String brand, List<Car> list) {
        List<Car> result = new ArrayList<>();
        for (Car car : list) {
            if (brand != null && car.getBrand() != null && car.getBrand().equalsIgnoreCase(brand)) {
                result.add(car);
            }
        }
        return result;
    }

    public List<Car> filterCarByPrice(int minPrice, int maxPrice, List<Car> list) {
        List<Car> result = new ArrayList<>();
        for (Car car : list) {
            if (car.getPricePerDay() >= minPrice && car.getPricePerDay() <= maxPrice) {
                result.add(car);
            }
        }
        return result;
    }

    private void bindCarForUpsert(PreparedStatement ps, Car car, boolean isUpdate) throws SQLException {
        int idx = 1;
        if (!isUpdate) ps.setInt(idx++, car.getOwner_id());

        ps.setString(idx++, car.getName());
        ps.setString(idx++, car.getLicensePlate());
        ps.setString(idx++, car.getBrand());
        ps.setString(idx++, car.getModel());
        if (car.getYear() == null) ps.setNull(idx++, Types.INTEGER); else ps.setInt(idx++, car.getYear());
        ps.setString(idx++, car.getColor());
        ps.setInt(idx++, 4); // seats mặc định
        ps.setString(idx++, "PETROL"); // fuel_type mặc định nếu UI chưa hỗ trợ
        ps.setInt(idx++, car.getPricePerDay());
        ps.setString(idx++, car.getStatus() == null ? "AVAILABLE" : car.getStatus());
        ps.setInt(idx++, car.isActive() ? 1 : 0);
        ps.setString(idx++, car.getImageUrl());
        ps.setString(idx++, car.getDescription());

        if (isUpdate) {
            ps.setInt(idx++, car.getId());
            ps.setInt(idx, car.getOwner_id());
        }
    }

    private void bindParams(PreparedStatement ps, List<Object> params) throws SQLException {
        for (int i = 0; i < params.size(); i++) {
            Object p = params.get(i);
            if (p instanceof Integer) ps.setInt(i + 1, (Integer) p);
            else ps.setString(i + 1, String.valueOf(p));
        }
    }

    private Car mapResultSetToCar(ResultSet rs) throws SQLException {
        Car car = new Car();
        car.setId(rs.getInt("id"));
        car.setOwner_id(rs.getInt("owner_id"));
        car.setName(rs.getString("name"));
        car.setLicensePlate(rs.getString("license_plate"));
        car.setBrand(rs.getString("brand"));
        car.setModel(rs.getString("model"));

        int y = rs.getInt("year");
        car.setYear(rs.wasNull() ? null : y);

        car.setColor(rs.getString("color"));
        car.setPricePerDay(rs.getInt("price_per_day"));
        car.setStatus(rs.getString("status"));
        car.setActive(rs.getInt("is_active") == 1);
        car.setImageUrl(rs.getString("image_url"));
        car.setDescription(rs.getString("description"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) car.setCreatedAt(createdAt.toLocalDateTime());

        return car;
    }
}

package com.example.carrental.model.dao;

import com.example.carrental.model.entity.CarAvailability;
import com.example.carrental.model.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class CarAvailabilityDAO {

    private final DBConnection dbConnection = DBConnection.getInstance();

    public List<CarAvailability> getByCarId(int carId) {
        List<CarAvailability> list = new ArrayList<>();
        String sql = "SELECT * FROM car_availability WHERE car_id = ? ORDER BY start_date ASC";
        try (Connection conn = dbConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, carId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRs(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public CarAvailability getById(int id) {
        String sql = "SELECT * FROM car_availability WHERE id = ?";
        try (Connection conn = dbConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRs(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean add(CarAvailability av) {
        String sql = "INSERT INTO car_availability (car_id, start_date, end_date, is_available, note) VALUES (?,?,?,?,?)";
        try (Connection conn = dbConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, av.getCarId());
            ps.setDate(2, Date.valueOf(av.getStartDate()));
            ps.setDate(3, Date.valueOf(av.getEndDate()));
            ps.setInt(4, av.isAvailable() ? 1 : 0);
            ps.setString(5, av.getNote());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(CarAvailability av) {
        String sql = "UPDATE car_availability SET start_date=?, end_date=?, is_available=?, note=? WHERE id=?";
        try (Connection conn = dbConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(av.getStartDate()));
            ps.setDate(2, Date.valueOf(av.getEndDate()));
            ps.setInt(3, av.isAvailable() ? 1 : 0);
            ps.setString(4, av.getNote());
            ps.setInt(5, av.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM car_availability WHERE id = ?";
        try (Connection conn = dbConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteByCarId(int carId) {
        String sql = "DELETE FROM car_availability WHERE car_id = ?";
        try (Connection conn = dbConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, carId);
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private CarAvailability mapRs(ResultSet rs) throws SQLException {
        CarAvailability av = new CarAvailability();
        av.setId(rs.getInt("id"));
        av.setCarId(rs.getInt("car_id"));
        av.setStartDate(rs.getDate("start_date").toLocalDate());
        av.setEndDate(rs.getDate("end_date").toLocalDate());
        av.setAvailable(rs.getInt("is_available") == 1);
        av.setNote(rs.getString("note"));
        return av;
    }

    public static void main(String[] args) {

        CarAvailabilityDAO dao = new CarAvailabilityDAO();

        int carId = 1; // id xe muốn kiểm tra

        List<CarAvailability> list = dao.getByCarId(carId);

        if (list.isEmpty()) {
            System.out.println("Không có dữ liệu cho car_id = " + carId);
        } else {
            for (CarAvailability av : list) {
                System.out.println("ID: " + av.getId());
                System.out.println("Car ID: " + av.getCarId());
                System.out.println("Start Date: " + av.getStartDate());
                System.out.println("End Date: " + av.getEndDate());
                System.out.println("Available: " + av.isAvailable());
                System.out.println("Note: " + av.getNote());
                System.out.println("-------------------------");
            }
        }
    }
}

package com.example.carrental.model.dao;

import com.example.carrental.model.entity.CarImage;
import com.example.carrental.model.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CarImageDAO {
    private final DBConnection dbConnection = DBConnection.getInstance();

    public List<CarImage> getByCarId(int carId) {
        List<CarImage> list = new ArrayList<>();
        String sql = "SELECT * FROM car_images WHERE car_id = ? ORDER BY is_primary DESC, sort_order ASC";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
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

    public CarImage getById(int id) {
        String sql = "SELECT * FROM car_images WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRs(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean add(CarImage img) {
        String sql = "INSERT INTO car_images (car_id, image_url, is_primary, sort_order) VALUES (?,?,?,?)";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, img.getCarId());
            ps.setString(2, img.getImageUrl());
            ps.setInt(3, img.isPrimary() ? 1 : 0);
            ps.setInt(4, img.getSortOrder());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(CarImage img) {
        String sql = "UPDATE car_images SET image_url=?, is_primary=?, sort_order=? WHERE id=?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, img.getImageUrl());
            ps.setInt(2, img.isPrimary() ? 1 : 0);
            ps.setInt(3, img.getSortOrder());
            ps.setInt(4, img.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean setPrimary(int carId, int imageId) {
        try (Connection conn = dbConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps0 = conn.prepareStatement("UPDATE car_images SET is_primary=0 WHERE car_id=?")) {
                ps0.setInt(1, carId);
                ps0.executeUpdate();
            }
            try (PreparedStatement ps1 = conn.prepareStatement("UPDATE car_images SET is_primary=1 WHERE id=?")) {
                ps1.setInt(1, imageId);
                ps1.executeUpdate();
            }
            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM car_images WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private CarImage mapRs(ResultSet rs) throws SQLException {
        CarImage img = new CarImage();
        img.setId(rs.getInt("id"));
        img.setCarId(rs.getInt("car_id"));
        img.setImageUrl(rs.getString("image_url"));
        img.setPrimary(rs.getInt("is_primary") == 1);
        img.setSortOrder(rs.getInt("sort_order"));
        return img;
    }
}

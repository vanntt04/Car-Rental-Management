package com.example.carrental.model.dao;

import com.example.carrental.model.entity.Booking;
import com.example.carrental.model.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO cho bảng bookings.
 * filter: "all" | "completed" (đã hoàn thành) | "upcoming" (sắp tới)
 */
public class BookingDAO {
    private final DBConnection dbConnection = DBConnection.getInstance();

    /**
     * Lấy danh sách đặt xe theo car_id, có thể lọc theo trạng thái thời gian.
     * @param filter "all" = tất cả, "completed" = đã hoàn thành (qua ngày hoặc COMPLETED), "upcoming" = sắp tới (chưa kết thúc, PENDING/APPROVED)
     */
    public List<Booking> getByCarId(int carId, String filter) {
        List<Booking> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT b.booking_id, b.car_id, b.customer_id, u.full_name AS customer_name, " +
            "b.start_date, b.end_date, b.total_days, b.total_price, b.booking_status " +
            "FROM bookings b " +
            "LEFT JOIN users u ON b.customer_id = u.user_id " +
            "WHERE b.car_id = ? ");
        if ("completed".equalsIgnoreCase(filter)) {
            sql.append("AND (b.end_date < CURDATE() OR b.booking_status = 'COMPLETED') ");
        } else if ("upcoming".equalsIgnoreCase(filter)) {
            sql.append("AND b.end_date >= CURDATE() AND b.booking_status IN ('PENDING','APPROVED') ");
        }
        sql.append("ORDER BY b.start_date DESC");
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, carId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRs(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getByCarId bookings: " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy booking theo ID.
     */
    public Booking getById(int bookingId) {
        String sql = "SELECT b.booking_id, b.car_id, b.customer_id, u.full_name AS customer_name, " +
                "b.start_date, b.end_date, b.total_days, b.total_price, b.booking_status " +
                "FROM bookings b LEFT JOIN users u ON b.customer_id = u.user_id WHERE b.booking_id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRs(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error getById booking: " + e.getMessage());
        }
        return null;
    }

    /**
     * Đếm số booking theo owner_id với lọc trạng thái.
     * @param statusFilter null/empty = tất cả, PENDING, APPROVED, REJECTED, CANCELLED, COMPLETED
     */
    public int countByOwnerId(int ownerId, String statusFilter) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM bookings b " +
            "LEFT JOIN cars c ON b.car_id = c.id " +
            "WHERE c.owner_id = ?");
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND b.booking_status = ?");
        }
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, ownerId);
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                ps.setString(2, statusFilter.trim());
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error countByOwnerId: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Lấy danh sách booking theo owner_id (xe của chủ) có phân trang và lọc trạng thái.
     * Trả về List<Map> với các key: booking_id, carName, customerName, start_date, end_date, total_price, booking_status.
     * @param statusFilter null/empty = tất cả
     */
    public List<java.util.Map<String, Object>> getByOwnerId(int ownerId, String statusFilter, int page, int pageSize) {
        List<java.util.Map<String, Object>> result = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT b.booking_id, b.car_id, b.customer_id, u.full_name AS customer_name, " +
            "b.start_date, b.end_date, b.total_days, b.total_price, b.booking_status, c.name AS car_name " +
            "FROM bookings b " +
            "LEFT JOIN users u ON b.customer_id = u.user_id " +
            "LEFT JOIN cars c ON b.car_id = c.id " +
            "WHERE c.owner_id = ?");
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND b.booking_status = ?");
        }
        sql.append(" ORDER BY b.start_date DESC LIMIT ? OFFSET ?");
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, ownerId);
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                ps.setString(idx++, statusFilter.trim());
            }
            ps.setInt(idx++, pageSize);
            ps.setInt(idx, (page - 1) * pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    java.util.Map<String, Object> row = new java.util.HashMap<>();
                    Booking booking = mapRs(rs);
                    row.put("booking", booking);
                    row.put("booking_id", booking.getId());
                    row.put("carName", rs.getString("car_name"));
                    row.put("customerName", booking.getCustomerName());
                    row.put("start_date", booking.getStart_date());
                    row.put("end_date", booking.getEnd_date());
                    row.put("total_price", booking.getTotalPrice());
                    row.put("booking_status", booking.getBookingStatus());
                    result.add(row);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getByOwnerId: " + e.getMessage());
        }
        return result;
    }

    /** @deprecated Dùng getByOwnerId(ownerId, statusFilter, page, pageSize) */
    public List<java.util.Map<String, Object>> getByOwnerId(int ownerId) {
        return getByOwnerId(ownerId, null, 1, Integer.MAX_VALUE);
    }

    /**
     * Lấy danh sách booking theo customer_id.
     */
    public List<Booking> getByCustomerId(int customerId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.booking_id, b.car_id, b.customer_id, u.full_name AS customer_name, " +
                "b.start_date, b.end_date, b.total_days, b.total_price, b.booking_status " +
                "FROM bookings b LEFT JOIN users u ON b.customer_id = u.user_id " +
                "WHERE b.customer_id = ? ORDER BY b.start_date DESC";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRs(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getByCustomerId: " + e.getMessage());
        }
        return list;
    }

    /**
     * Cập nhật trạng thái booking (CANCELLED, APPROVED, etc.)
     */
    public boolean updateStatus(int bookingId, String status) {
        String sql = "UPDATE bookings SET booking_status = ? WHERE booking_id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updateStatus: " + e.getMessage());
            return false;
        }
    }

    /**
     * Thêm booking mới, trả về ID được tạo.
     */
    public int insertBooking(Booking b) throws SQLException {
        String sql = "INSERT INTO bookings (car_id, customer_id, start_date, end_date, total_days, total_price, booking_status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, b.getCarId());
            ps.setInt(2, b.getCustomerId());
            ps.setDate(3, Date.valueOf(b.getStartDate()));
            ps.setDate(4, Date.valueOf(b.getEndDate()));
            ps.setInt(5, b.getTotalDays());
            ps.setBigDecimal(6, b.getTotalPrice());
            ps.setString(7, b.getBookingStatus());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        throw new SQLException("Could not get generated booking id");
    }

    private Booking mapRs(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setId(rs.getInt("booking_id"));
        b.setCarId(rs.getInt("car_id"));
        b.setCustomerId(rs.getInt("customer_id"));
        b.setCustomerName(rs.getString("customer_name"));
        Date sd = rs.getDate("start_date");
        if (sd != null) b.setStartDate(sd.toLocalDate());
        Date ed = rs.getDate("end_date");
        if (ed != null) b.setEndDate(ed.toLocalDate());
        b.setTotalDays(rs.getInt("total_days"));
        BigDecimal price = rs.getBigDecimal("total_price");
        b.setTotalPrice(price);
        b.setBookingStatus(rs.getString("booking_status"));
        return b;
    }
}

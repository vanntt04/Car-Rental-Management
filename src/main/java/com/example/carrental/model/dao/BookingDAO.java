package com.example.carrental.model.dao;

import com.example.carrental.model.entity.Booking;
import com.example.carrental.model.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object cho bảng bookings.
 */
public class BookingDAO {
    private final DBConnection dbConnection;

    public BookingDAO() {
        this.dbConnection = DBConnection.getInstance();
    }

    /**
     * Thêm mới một đơn đặt xe.
     * Trả về ID tự tăng nếu thành công, ngược lại trả về -1.
     */
    public int insertBooking(Booking booking) {
        String sql = "INSERT INTO bookings (car_id, customer_id, start_date, end_date, total_days, total_price, booking_status, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = dbConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, booking.getCarId());
            ps.setInt(2, booking.getCustomerId());
            ps.setObject(3, booking.getStartDate());
            ps.setObject(4, booking.getEndDate());
            ps.setInt(5, booking.getTotalDays());
            ps.setBigDecimal(6, booking.getTotalPrice());
            ps.setString(7, booking.getBookingStatus() != null ? booking.getBookingStatus() : "PENDING");
            ps.setTimestamp(8, Timestamp.valueOf(booking.getCreatedAt() != null ? booking.getCreatedAt() : LocalDateTime.now()));

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error inserting booking: " + e.getMessage());
        }
        return -1;
    }

    /**
     * Lấy danh sách đặt xe theo car_id với bộ lọc thời gian.
     */
    public List<Booking> getByCarId(int carId, String filter) {
        List<Booking> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT b.*, u.full_name AS customer_name " +
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
                    list.add(mapResultSetToBooking(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getByCarId: " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy danh sách đặt xe cho chủ xe (Owner).
     */
    public List<Booking> getBookingsByOwner(int ownerId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, u.full_name AS customer_name " +
                     "FROM bookings b " +
                     "JOIN cars c ON b.car_id = c.car_id " +
                     "LEFT JOIN users u ON b.customer_id = u.user_id " +
                     "WHERE c.owner_id = ? ORDER BY b.created_at DESC";

        try (Connection conn = dbConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToBooking(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Cập nhật trạng thái đơn hàng (Duyệt/Từ chối/Hoàn thành).
     */
    public boolean updateBookingStatus(int bookingId, String status) {
        String sql = "UPDATE bookings SET booking_status = ? WHERE booking_id = ?";
        try (Connection conn = dbConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Map dữ liệu từ ResultSet sang Object Booking.
     */
    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setId(rs.getInt("booking_id"));
        b.setCarId(rs.getInt("car_id"));
        b.setCustomerId(rs.getInt("customer_id"));
        
        // Thử lấy customer_name nếu có (từ lệnh JOIN)
        try {
            b.setCustomerName(rs.getString("customer_name"));
        } catch (SQLException ignored) {}

        b.setStartDate(rs.getObject("start_date", LocalDate.class));
        b.setEndDate(rs.getObject("end_date", LocalDate.class));
        
        // Kiểm tra tồn tại cột total_days (tùy thuộc schema)
        try {
            b.setTotalDays(rs.getInt("total_days"));
        } catch (SQLException ignored) {}

        b.setTotalPrice(rs.getBigDecimal("total_price"));
        b.setBookingStatus(rs.getString("booking_status"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            b.setCreatedAt(createdAt.toLocalDateTime());
        }
        return b;
    }
}
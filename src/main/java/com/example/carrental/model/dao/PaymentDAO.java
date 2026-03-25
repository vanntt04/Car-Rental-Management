package com.example.carrental.model.dao;

import com.example.carrental.model.entity.Payment;
import com.example.carrental.model.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;

public class PaymentDAO {
    private final DBConnection dbConnection = DBConnection.getInstance();

    public Payment getByBookingId(int bookingId) {
        String sql = "SELECT payment_id, booking_id, amount, payment_method, payment_status, paid_at FROM payments WHERE booking_id = ? LIMIT 1";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
            rs.close();
        } catch (SQLException e) {
            System.err.println("PaymentDAO.getByBookingId: " + e.getMessage());
        }
        return null;
    }

    /** Tạo hoặc cập nhật payment method, giữ status hiện tại nếu đã có. */
    public boolean upsertMethod(int bookingId, java.math.BigDecimal amount, String method) throws SQLException {
        Payment existing = getByBookingId(bookingId);
        if (existing == null) {
            String sql = "INSERT INTO payments (booking_id, amount, payment_method, payment_status, paid_at) VALUES (?,?,?, 'UNPAID', NULL)";
            try (Connection conn = dbConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, bookingId);
                ps.setBigDecimal(2, amount);
                ps.setString(3, method);
                return ps.executeUpdate() > 0;
            }
        } else {
            String sql = "UPDATE payments SET amount = ?, payment_method = ? WHERE booking_id = ?";
            try (Connection conn = dbConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setBigDecimal(1, amount);
                ps.setString(2, method);
                ps.setInt(3, bookingId);
                return ps.executeUpdate() > 0;
            }
        }
    }

    public boolean markPaid(int bookingId) throws SQLException {
        String sql = "UPDATE payments SET payment_status='PAID', paid_at=? WHERE booking_id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        }
    }

    private Payment map(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setId(rs.getInt("payment_id"));
        p.setBookingId(rs.getInt("booking_id"));
        p.setAmount(rs.getBigDecimal("amount"));
        p.setPaymentMethod(rs.getString("payment_method"));
        p.setPaymentStatus(rs.getString("payment_status"));
        Timestamp ts = rs.getTimestamp("paid_at");
        if (ts != null) p.setPaidAt(ts.toLocalDateTime());
        return p;
    }
}


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

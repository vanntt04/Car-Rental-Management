/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.example.carrental.model.dao;

import com.example.carrental.model.entity.Booking;
import com.example.carrental.model.entity.User;
import com.example.carrental.model.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    private DBConnection dbConnection;

    public BookingDAO() {
        this.dbConnection = DBConnection.getInstance();
    }

    public int insertBooking(Booking booking) {
        String sql = "INSERT INTO bookings (booking_id ,car_id, customer_id, start_time, end_time, total_price,booking_status,created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = dbConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, booking.getBooking_id());
            ps.setInt(2, booking.getCar_id());
            ps.setInt(3, booking.getCustomer_id());
            ps.setObject(4, (LocalDate) booking.getStart_date());
            ps.setObject(5, (LocalDate) booking.getEnd_date());
            ps.setDouble(6, booking.getTotal_price());
            ps.setString(7, "PENDING");
            ps.setTimestamp(8, Timestamp.valueOf(booking.getCreated_at()));
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }
}

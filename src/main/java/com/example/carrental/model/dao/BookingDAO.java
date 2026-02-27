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
        String sql = "INSERT INTO bookings (booking_id ,car_id, customer_id, start_date, end_date, total_price,booking_status,created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

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

    public List<Booking> getAllBookCars() {
        List<Booking> book = new ArrayList<>();
        String sql = "SELECT c.*  FROM booking c ";

        try (Connection conn = dbConnection.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                book.add(mapResultSetToBook(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting all cars: " + e.getMessage());
            e.printStackTrace();
        }

        return book;
    }

    public void updateBookingStatus(int bookingId, String status) {
        String sql = "UPDATE bookings SET booking_status = ? WHERE booking_id = ?";
        try (Connection conn = dbConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Booking> getBookCarByOwen(int owen_id) {

        String sql = "SELECT i.* "
                + "FROM bookings i "
                + "JOIN cars c ON c.car_id = i.car_id "
                + "WHERE c.owner_id = ?";

        List<Booking> cars = new ArrayList<>();

        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, owen_id);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Booking book = mapResultSetToBook(rs);
                cars.add(book);
            }

            rs.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cars;
    }

    private Booking mapResultSetToBook(ResultSet rs) throws SQLException {
        Booking book = new Booking();
        book.setBooking_id(rs.getInt("booking_id"));
        book.setBooking_status(rs.getString("booking_status"));
        book.setCar_id(rs.getInt("car_id"));
        book.setCustomer_id(rs.getInt("customer_id"));
        book.setStart_date(rs.getObject("start_date", LocalDate.class));
        book.setTotal_price(rs.getInt("total_price"));
        book.setEnd_date(rs.getObject("end_date", LocalDate.class));
        book.setCreated_at(LocalDateTime.now());

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            book.setCreated_at(createdAt.toLocalDateTime());
        }
        return book;
    }

}


/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.example.carrental.model.dao;

import com.example.carrental.model.entity.Booking;
import com.example.carrental.model.entity.Car;
import com.example.carrental.model.util.DBConnection;
import java.math.BigDecimal;

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
        String sql = "INSERT INTO bookings (booking_id ,car_id, customer_id, start_date, end_date,total_days, total_price,booking_status) VALUES (?, ?, ?, ?, ?, ?, ?,?)";

        try (Connection conn = dbConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, booking.getBooking_id());
            ps.setInt(2, booking.getCar_id());
            ps.setInt(3, booking.getCustomer_id());
            ps.setObject(4, (LocalDate) booking.getStart_date());
            ps.setObject(5, (LocalDate) booking.getEnd_date());
            ps.setInt(6, booking.getTotal_days());
            ps.setBigDecimal(7, booking.getTotal_price());
            ps.setString(8, "PENDING");
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

    public List<Booking> getAllBookCars(int user_id) {
        String sql = "SELECT bookings.* FROM bookings WHERE customer_id = ? ";
        List<Booking> book = new ArrayList<>();

        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, user_id);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                book.add(mapResultSetToBook(rs));
            }

            rs.close();
        } catch (SQLException e) {
            System.err.println("Error getting car by id: " + e.getMessage());
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
                + "JOIN cars c ON c.id = i.car_id "
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

    public Booking getBookCarByID(int customer_id, int car_id) {

        String sql = "SELECT i.* "
                + "FROM bookings i "
                + "WHERE i.car_id = ? AND  i.customer_id = ?";
        Booking book = null;
        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, car_id);
            pstmt.setInt(2, customer_id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                book = mapResultSetToBook(rs);
            }

            rs.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return book;
    }

    public List<Booking> getByCarId(int carId, String filter) {
        List<Booking> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT b.booking_id, b.car_id, b.customer_id, u.full_name AS customer_name, "
                + "b.start_date, b.end_date, b.total_days, b.total_price, b.booking_status "
                + "FROM bookings b "
                + "LEFT JOIN users u ON b.customer_id = u.user_id "
                + "WHERE b.car_id = ? ");
        if ("completed".equalsIgnoreCase(filter)) {
            sql.append("AND (b.end_date < CURDATE() OR b.booking_status = 'COMPLETED') ");
        } else if ("upcoming".equalsIgnoreCase(filter)) {
            sql.append("AND b.end_date >= CURDATE() AND b.booking_status IN ('PENDING','APPROVED') ");
        }
        sql.append("ORDER BY b.start_date DESC");
        try (Connection conn = dbConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, carId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToBook(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getByCarId bookings: " + e.getMessage());
        }
        return list;
    }

    private Booking mapResultSetToBook(ResultSet rs) throws SQLException {
        Booking book = new Booking();
        book.setBooking_id(rs.getInt("booking_id"));
        book.setBooking_status(rs.getString("booking_status"));
        book.setCar_id(rs.getInt("car_id"));
        book.setCustomer_id(rs.getInt("customer_id"));
        book.setStart_date(rs.getObject("start_date", LocalDate.class));
        book.setTotal_price(rs.getBigDecimal("total_price"));
        book.setEnd_date(rs.getObject("end_date", LocalDate.class));
        book.setTotal_days(rs.getInt("total_days"));
        return book;
    }
    public static void main(String[] args) {
    BookingDAO bookingDAO = new BookingDAO();

    int customerId = 4;
    int carId = 1;

    Booking booking = bookingDAO.getBookCarByID(customerId, carId);

    if (booking == null) {
        System.out.println("No booking found for customer_id = " + customerId + " and car_id = " + carId);
    } else {
        System.out.println("Booking found:");
        System.out.println("Booking ID: " + booking.getBooking_id());
        System.out.println("Car ID: " + booking.getCar_id());
        System.out.println("Customer ID: " + booking.getCustomer_id());
        System.out.println("Status: " + booking.getBooking_status());
        System.out.println("Start Date: " + booking.getStart_date());
        System.out.println("End Date: " + booking.getEnd_date());
    }
}
}

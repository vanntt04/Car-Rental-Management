package com.example.carrental.controller;

import com.example.carrental.model.dao.BookingDAO;
import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.entity.Booking;
import com.example.carrental.model.entity.Car;
import com.example.carrental.model.entity.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

/**
 * Xử lý luồng booking xe cho CUSTOMER.
 */
public class BookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;

        if (user == null || user.getRole() == null || !"customer".equalsIgnoreCase(user.getRole())) {
            if (session != null) {
                session.setAttribute("error", "Vui lòng đăng nhập bằng tài khoản customer để booking");
            }
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String carIdParam = request.getParameter("carId");
        if (carIdParam == null || carIdParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/searchcar");
            return;
        }

        int carId;
        try {
            carId = Integer.parseInt(carIdParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "carId không hợp lệ");
            return;
        }

        CarDAO carDAO = new CarDAO();
        Car selectedCar = carDAO.getCarById(carId);
        if (selectedCar == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy xe");
            return;
        }

        session.setAttribute("BookCar", selectedCar);
        request.getRequestDispatcher("/WEB-INF/views/car/Booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("reject".equals(action)) {
            response.sendRedirect(request.getContextPath() + "/searchcar");
            return;
        }

        if (!"accept".equals(action)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action không hợp lệ");
            return;
        }

        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        Car car = session != null ? (Car) session.getAttribute("BookCar") : null;

        if (user == null || car == null) {
            response.sendRedirect(request.getContextPath() + "/searchcar");
            return;
        }

        LocalDate startDate;
        LocalDate endDate;
        try {
            startDate = LocalDate.parse(request.getParameter("pickupTime"));
            endDate = LocalDate.parse(request.getParameter("returnTime"));
        } catch (Exception e) {
            request.setAttribute("error", "Ngày nhận/trả xe không hợp lệ");
            request.getRequestDispatcher("/WEB-INF/views/car/Booking.jsp").forward(request, response);
            return;
        }

        long days = ChronoUnit.DAYS.between(startDate, endDate);
        if (days <= 0) {
            request.setAttribute("error", "Ngày trả xe phải sau ngày nhận xe");
            request.getRequestDispatcher("/WEB-INF/views/car/Booking.jsp").forward(request, response);
            return;
        }

        BigDecimal totalPrice = BigDecimal.valueOf(car.getPricePerDay()).multiply(BigDecimal.valueOf(days));

        Booking booking = new Booking();
        booking.setCarId(car.getId());
        booking.setCustomerId(user.getId());
        booking.setStartDate(startDate);
        booking.setEndDate(endDate);
        booking.setTotalDays((int) days);
        booking.setTotalPrice(totalPrice);
        booking.setBookingStatus("PENDING");
        booking.setCreatedAt(LocalDateTime.now());

        BookingDAO bookingDAO = new BookingDAO();
        int bookingId = bookingDAO.insertBooking(booking);
        if (bookingId <= 0) {
            request.setAttribute("error", "Không thể tạo booking. Vui lòng thử lại.");
            request.getRequestDispatcher("/WEB-INF/views/car/Booking.jsp").forward(request, response);
            return;
        }

        booking.setId(bookingId);
        session.setAttribute("note", request.getParameter("returnLocation"));
        session.setAttribute("invoice", booking);
        request.setAttribute("total_price", totalPrice);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/car/Invoice.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Booking servlet";
    }
}

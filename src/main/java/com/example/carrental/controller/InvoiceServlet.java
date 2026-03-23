package com.example.carrental.controller;

import com.example.carrental.model.dao.BookingDAO;
import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.dao.PaymentDAO;
import com.example.carrental.model.entity.Booking;
import com.example.carrental.model.entity.Car;
import com.example.carrental.model.entity.Payment;
import com.example.carrental.model.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Hiển thị hóa đơn thuê xe.
 * URL: /invoice?book_id=123&id=456 (id = car_id)
 */
@WebServlet(name = "InvoiceServlet", urlPatterns = "/invoice")
public class InvoiceServlet extends HttpServlet {

    private BookingDAO bookingDAO;
    private CarDAO carDAO;
    private PaymentDAO paymentDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
        carDAO = new CarDAO();
        paymentDAO = new PaymentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" +
                    java.net.URLEncoder.encode(request.getRequestURI() + "?" + (request.getQueryString() != null ? request.getQueryString() : ""), "UTF-8"));
            return;
        }

        String bookIdParam = request.getParameter("book_id");
        String carIdParam = request.getParameter("id");
        if (bookIdParam == null || carIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        int bookingId;
        int carId;
        try {
            bookingId = Integer.parseInt(bookIdParam);
            carId = Integer.parseInt(carIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        Booking booking = bookingDAO.getById(bookingId);
        if (booking == null || booking.getCustomer_id() != user.getId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không tìm thấy hoặc không có quyền xem hóa đơn");
            return;
        }

        Car car = carDAO.getCarById(carId);
        if (car == null || car.getId() != booking.getCar_id()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy thông tin xe");
            return;
        }

        Payment payment = paymentDAO.getByBookingId(bookingId);

        request.setAttribute("invoice", booking);
        request.setAttribute("BookCar", car);
        request.setAttribute("payment", payment);
        Object note = request.getSession().getAttribute("note");
        request.setAttribute("note", note != null ? note : "");

        request.getRequestDispatcher("/WEB-INF/views/car/Invoice.jsp").forward(request, response);
    }
}

package com.example.carrental.controller;

import com.example.carrental.model.dao.BookingDAO;
import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.entity.Booking;
import com.example.carrental.model.entity.Car;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class MyBookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            session.setAttribute("error", "Vui lòng đăng nhập để xem đơn đặt xe");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int userId = userIdObj instanceof Number ? ((Number) userIdObj).intValue() : Integer.parseInt(userIdObj.toString());
        BookingDAO bookingDAO = new BookingDAO();
        CarDAO carDAO = new CarDAO();
        List<Booking> listBook = bookingDAO.getByCustomerId(userId);
        List<Car> bookCars = new ArrayList<>();
        for (Booking b : listBook) {
            Car c = carDAO.getCarById(b.getCarId());
            bookCars.add(c != null ? c : new Car());
        }
        request.setAttribute("bookList", listBook);
        request.setAttribute("bookCars", bookCars);
        request.getRequestDispatcher("/WEB-INF/views/car/MyBooking.jsp").forward(request, response);
    }
}

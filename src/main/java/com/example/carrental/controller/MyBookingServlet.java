/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.example.carrental.controller;

import com.example.carrental.model.dao.BookingDAO;
import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.dao.PaymentDAO;
import com.example.carrental.model.entity.Booking;
import com.example.carrental.model.entity.Car;
import com.example.carrental.model.entity.Payment;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.annotation.WebServlet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Trang hiển thị danh sách booking của customer.
 * URL: /mybooking
 *
 * @author PC
 */
@WebServlet(name = "MyBookingServlet", urlPatterns = "/mybooking")
public class MyBookingServlet extends HttpServlet {

    /**
     * Bước 1–6 (0 = hủy/từ chối). Luồng: thanh toán → chủ duyệt → giao xe → trả xe → hoàn thành.
     */
    static int progressStep(Booking b, Payment p) {
        if (b == null || b.getBooking_status() == null) return 1;
        String s = b.getBooking_status();
        switch (s) {
            case "COMPLETED":
                return 6;
            case "RETURN":
                return 5;
            case "PICKED_UP":
                return 4;
            case "APPROVED":
                return 3;
            case "PENDING":
                if (p != null && "PAID".equals(p.getPaymentStatus())) return 2;
                return 1;
            case "REJECTED":
            case "CANCELLED":
                return 0;
            default:
                return 1;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CarDAO car = new CarDAO();
        BookingDAO book = new BookingDAO();
        PaymentDAO paymentDAO = new PaymentDAO();
        HttpSession session = request.getSession();
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int userId = (int) userIdObj;
        List<Car> list_select = car.getAllSelectCars(userId);
        List<Booking> list_book = book.getAllBookCars(userId);
        List<Car> book_car = new ArrayList<>();
        List<Map<String, Object>> bookingRows = new ArrayList<>();
        for (Booking bk : list_book) {
            Car c = car.getCarById(bk.getCar_id());
            book_car.add(c);
            Payment p = paymentDAO.getByBookingId(bk.getBooking_id());
            Map<String, Object> row = new HashMap<>();
            row.put("booking", bk);
            row.put("car", c);
            row.put("payment", p);
            row.put("progressStep", progressStep(bk, p));
            row.put("totalPrice", bk.getTotal_price());
            bookingRows.add(row);
        }
        request.setAttribute("Select-List", list_select);
        request.setAttribute("Book-List", list_book);
        request.setAttribute("Book-Car", book_car);
        request.setAttribute("bookingRows", bookingRows);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/car/MyBooking.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int userId = (int) userIdObj;

        String action = request.getParameter("action");
        if (!"return-car".equals(action)) {
            response.sendRedirect(request.getContextPath() + "/mybooking");
            return;
        }
        String bookingIdParam = request.getParameter("bookingId");
        if (bookingIdParam == null || bookingIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/mybooking");
            return;
        }
        int bookingId;
        try {
            bookingId = Integer.parseInt(bookingIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/mybooking");
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        Booking b = bookingDAO.getById(bookingId);
        if (b == null || b.getCustomer_id() != userId) {
            response.sendRedirect(request.getContextPath() + "/mybooking");
            return;
        }
        if (!"PICKED_UP".equalsIgnoreCase(b.getBooking_status())) {
            response.sendRedirect(request.getContextPath() + "/mybooking");
            return;
        }
        bookingDAO.updateStatus(bookingId, "RETURN");
        response.sendRedirect(request.getContextPath() + "/mybooking?success=returned");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Customer booking list";
    }

}

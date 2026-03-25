/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.example.carrental.controller;

import com.example.carrental.model.dao.BookingDAO;
import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.dao.UserDAO;
import com.example.carrental.model.entity.Booking;
import com.example.carrental.model.entity.Car;
import com.example.carrental.model.entity.User;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

/**
 * Servlet xử lý đặt xe.
 * URL: /booking?carId={id}
 */
@WebServlet(name = "BookingServlet", urlPatterns = "/booking")
public class BookingServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet BookingServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BookingServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User cus = (User) session.getAttribute("user");
        if (cus == null) {
            String redirect = request.getRequestURI();
            if (request.getQueryString() != null) redirect += "?" + request.getQueryString();
            response.sendRedirect(request.getContextPath() + "/login?redirect=" +
                    java.net.URLEncoder.encode(redirect, "UTF-8"));
            return;
        }
        if (!"customer".equalsIgnoreCase(cus.getRole())) {
            session.setAttribute("error", "Đăng nhập với tài khoản khách hàng để đặt xe");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String carID = request.getParameter("carId");
        if (carID == null || carID.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/searchcar");
            return;
        }
        try {
            int c = Integer.parseInt(carID);
            CarDAO carDAO = new CarDAO();
            Car BookCar = carDAO.getCarById(c);
            if (BookCar == null) {
                response.sendRedirect(request.getContextPath() + "/searchcar");
                return;
            }
            session.setAttribute("BookCar", BookCar);
            request.getRequestDispatcher("/WEB-INF/views/car/Booking.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/searchcar");
        }
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
        String action = request.getParameter("action");
        if ("accept".equals(action)) {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String note = request.getParameter("returnLocation");
            BookingDAO book = new BookingDAO();
            Car car = (Car) session.getAttribute("BookCar");
            if (car == null) {
                response.sendRedirect(request.getContextPath() + "/searchcar");
                return;
            }

            LocalDate start_date;
            LocalDate end_date;
            try {
                start_date = LocalDate.parse(request.getParameter("pickupTime"));
                end_date = LocalDate.parse(request.getParameter("returnTime"));
            } catch (DateTimeParseException | NullPointerException ex) {
                request.setAttribute("error", "Vui lòng nhập đúng định dạng ngày lấy và ngày trả xe.");
                request.getRequestDispatcher("/WEB-INF/views/car/Booking.jsp").forward(request, response);
                return;
            }

            LocalDate today = LocalDate.now();
            if (start_date.isBefore(today)) {
                request.setAttribute("error", "Ngày lấy xe phải sau hoặc bằng ngày đặt (hôm nay).");
                request.getRequestDispatcher("/WEB-INF/views/car/Booking.jsp").forward(request, response);
                return;
            }
            if (end_date.isBefore(start_date)) {
                request.setAttribute("error", "Ngày trả xe không được trước ngày lấy xe.");
                request.getRequestDispatcher("/WEB-INF/views/car/Booking.jsp").forward(request, response);
                return;
            }

            // Cập nhật thông tin khách (họ tên + SĐT) nếu user nhập
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            if (fullName != null && !fullName.trim().isEmpty()) user.setFullName(fullName.trim());
            if (phone != null && !phone.trim().isEmpty()) user.setPhone(phone.trim());
            try {
                UserDAO userDAO = new UserDAO();
                userDAO.updateUser(user);
            } catch (Exception ignored) {
                // Nếu update lỗi thì vẫn cho tạo booking theo user hiện tại trong session
            }

            long days = java.time.temporal.ChronoUnit.DAYS.between(start_date, end_date);
            if (days <= 0) days = 1; // tối thiểu 1 ngày

            BigDecimal pricePerDay = car.getPricePerDay();
            BigDecimal totalPrice = pricePerDay.multiply(BigDecimal.valueOf(days));

            Booking bookcar = new Booking(0, car.getId(), user.getId(), start_date, (int) days, end_date, totalPrice, "PENDING");
            int bookingId = book.insertBooking(bookcar);
            if (bookingId > 0) {
                bookcar.setBooking_id(bookingId);
            }
            session.setAttribute("note", note);
            request.setAttribute("total_price", totalPrice);
            session.setAttribute("invoice", bookcar);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/car/Invoice.jsp");
            dispatcher.forward(request, response);
        } else if ("reject".equals(action)) {
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/car/SearchCar.jsp");
            dispatcher.forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.example.carrental.controller;

import com.example.carrental.model.dao.BookingDAO;
import com.example.carrental.model.dao.PaymentDAO;
import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.dao.BankAccountDAO;
import com.example.carrental.model.entity.Booking;
import com.example.carrental.model.entity.Car;
import com.example.carrental.model.entity.BankAccount;
import com.example.carrental.model.entity.User;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.time.LocalDate;

/**
 *
 * @author PC
 */
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
            String error = "Vui lòng đăng nhập để đặt xe";
            session.setAttribute("error", error);
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!cus.getRole().equalsIgnoreCase("customer")) {
            String error = "Đăng nhập với tài khoản khách hàng để đặt xe";
            session.setAttribute("error", error);
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String bookIdParam = request.getParameter("book_id");
        if (bookIdParam != null && !bookIdParam.trim().isEmpty()) {
            try {
                int bookId = Integer.parseInt(bookIdParam.trim());
                String carIdParam = request.getParameter("carId");
                if (carIdParam == null || carIdParam.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/mybooking");
                    return;
                }
                int carId = Integer.parseInt(carIdParam.trim());
                BookingDAO bookingDAO = new BookingDAO();
                Booking invoice = bookingDAO.getById(bookId);
                if (invoice == null || invoice.getCarId() != carId) {
                    response.sendRedirect(request.getContextPath() + "/mybooking");
                    return;
                }
                CarDAO carDAO = new CarDAO();
                Car car = carDAO.getCarById(carId);
                if (car == null) {
                    response.sendRedirect(request.getContextPath() + "/mybooking");
                    return;
                }
                session.setAttribute("invoice", invoice);
                session.setAttribute("BookCar", car);
                request.getRequestDispatcher("/WEB-INF/views/car/Invoice.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/mybooking");
            }
            return;
        }
        String carID = request.getParameter("carId");
        if (carID == null || carID.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/searchcar");
            return;
        }
        try {
            int c = Integer.parseInt(carID.trim());
            CarDAO carDao = new CarDAO();
            Car BookCar = carDao.getCarById(c);
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
            String note = request.getParameter("returnLocation");
            LocalDate start_date = LocalDate.parse(request.getParameter("pickupTime"));
            LocalDate end_date = LocalDate.parse(request.getParameter("returnTime"));
            BookingDAO book = new BookingDAO();
            Car car = (Car) session.getAttribute("BookCar");
            User user = (User) session.getAttribute("user");
            long days = java.time.temporal.ChronoUnit.DAYS.between(start_date, end_date);
            if (days <= 0) days = 1;
            BigDecimal totalPrice = car.getPricePerDay().multiply(BigDecimal.valueOf(days));

            Booking bookcar = new Booking();
            bookcar.setCarId(car.getId());
            bookcar.setCustomerId(user.getId());
            bookcar.setStartDate(start_date);
            bookcar.setEndDate(end_date);
            bookcar.setTotalDays((int) days);
            bookcar.setTotalPrice(totalPrice);
            bookcar.setBookingStatus("PENDING");

            try {
                int bookingId = book.insertBooking(bookcar);
                bookcar.setId(bookingId);
            } catch (Exception e) {
                throw new ServletException(e);
            }
            session.setAttribute("note", note);
            request.setAttribute("total_price", totalPrice);
            session.setAttribute("invoice", bookcar);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/car/Invoice.jsp");
            dispatcher.forward(request, response);
        } else if ("setPaymentMethod".equals(action)) {
            HttpSession session = request.getSession();
            Booking invoice = (Booking) session.getAttribute("invoice");
            Car car = (Car) session.getAttribute("BookCar");
            if (invoice == null || car == null) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            String method = request.getParameter("paymentMethod");
            if (method == null) method = "";

            BookingDAO bookingDAO = new BookingDAO();
            Booking latest = bookingDAO.getById(invoice.getId());
            if (latest == null) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            // Chỉ cho chọn phương thức thanh toán sau khi OWNER duyệt
            if (!"APPROVED".equalsIgnoreCase(latest.getBookingStatus())) {
                request.setAttribute("error", "Đơn đang chờ chủ xe xác nhận. Bạn chỉ có thể thanh toán sau khi được duyệt.");
                session.setAttribute("invoice", latest);
                request.getRequestDispatcher("/WEB-INF/views/car/Invoice.jsp").forward(request, response);
                return;
            }

            PaymentDAO paymentDAO = new PaymentDAO();
            try {
                paymentDAO.upsertMethod(latest.getId(), latest.getTotalPrice(), method);
            } catch (Exception e) {
                throw new ServletException(e);
            }

            // Nếu chuyển khoản: load bank account của owner để hiện QR
            if ("BANK_TRANSFER".equals(method)) {
                BankAccountDAO bankDAO = new BankAccountDAO();
                BankAccount bank = bankDAO.getByOwnerId(car.getOwnerId() != null ? car.getOwnerId() : 0);
                request.setAttribute("bankAccount", bank);
            }
            request.setAttribute("selectedPaymentMethod", method);
            session.setAttribute("invoice", latest);
            request.getRequestDispatcher("/WEB-INF/views/car/Invoice.jsp").forward(request, response);
        } else if ("reject".equals(action)) {
            response.sendRedirect(request.getContextPath() + "/searchcar");
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

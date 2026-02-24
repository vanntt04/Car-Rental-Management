/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.example.carrental.controller;

import com.example.carrental.model.dao.BookingDAO;
import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.entity.Booking;
import com.example.carrental.model.entity.Car;
import com.example.carrental.model.entity.User;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

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
        if (cus.getRole().equalsIgnoreCase("customer")) {
            String carID = request.getParameter("carId");
            int c = Integer.parseInt(carID);
            CarDAO car = new CarDAO();
            Car BookCar = car.getCarById(c);
            session.setAttribute("BookCar", BookCar);
            request.getRequestDispatcher(
                    "/WEB-INF/views/car/Booking.jsp"
            ).forward(request, response);
        } else {
            String error = "Đăng nhập với customer để booking";
            session.setAttribute("error", error);
            request.getRequestDispatcher(
                    "/WEB-INF/views/auth/login.jsp"
            ).forward(request, response);
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
        HttpSession session = request.getSession();
        String note = request.getParameter("returnLocation");
        LocalDate start_date = LocalDate.parse(request.getParameter("pickupTime"));
        LocalDate end_date = LocalDate.parse(request.getParameter("returnTime"));
        BookingDAO book = new BookingDAO();
        Car car = (Car) session.getAttribute("BookCar");
        User user = (User) session.getAttribute("user");
        Booking bookcar = new Booking(123, car.getId(), user.getId(), start_date, end_date, car.getPricePerDay(), "PENDING", LocalDateTime.now());
        book.insertBooking(bookcar);
        session.setAttribute("note", note);
        long days = java.time.temporal.ChronoUnit.DAYS.between(start_date, end_date);
        int pricePerDay = car.getPricePerDay();
        int totalPrice = (int) (days * pricePerDay);
        request.setAttribute("total_price", totalPrice);
        session.setAttribute("invoice", bookcar);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/car/Invoice.jsp");
        dispatcher.forward(request, response);

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

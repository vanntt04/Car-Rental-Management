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
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author PC
 */
public class ListBookingRequestServlet extends HttpServlet {

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
            out.println("<title>Servlet ListBookingRequestServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ListBookingRequestServlet at " + request.getContextPath() + "</h1>");
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
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        BookingDAO bookDAO = new BookingDAO();
        List<Booking> bookingList = bookDAO.getBookCarByOwen(currentUser.getId());
        if (bookingList == null || bookingList.isEmpty()) {
            request.setAttribute("error", "Chưa có yêu cầu booking nào");
        } else {
            for (Booking b : bookingList) {
                CarDAO carDao = new CarDAO();
                UserDAO userDao = new UserDAO();
                Car car = carDao.getCarById(b.getCar_id());
                User cus = userDao.getUserById(b.getCustomer_id());
                b.setCar(car);
                b.setCus(cus);
            }
            request.setAttribute("bookingList", bookingList);
        }
        request.getRequestDispatcher("/WEB-INF/views/user/ManageBookingRequest.jsp")
                .forward(request, response);
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
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        String bookIdStr = request.getParameter("bookingId");
        if (bookIdStr == null || bookIdStr.isEmpty()) {
            request.setAttribute("error", "Booking ID không hợp lệ");
            doGet(request, response);
            return;
        }

        int book_id = Integer.parseInt(bookIdStr);
        BookingDAO bookDAO = new BookingDAO();

        if ("accept".equals(action)) {
            bookDAO.updateBookingStatus(book_id, "APPROVED");
        } else if ("reject".equals(action)) {
            bookDAO.updateBookingStatus(book_id, "CANCELLED");
        }
        List<Booking> bookingList = bookDAO.getBookCarByOwen(currentUser.getId());
        CarDAO carDao = new CarDAO();
        UserDAO userDao = new UserDAO();
        for (Booking b : bookingList) {
            b.setCar(carDao.getCarById(b.getCar_id()));
            b.setCus(userDao.getUserById(b.getCustomer_id()));
        }

        request.setAttribute("bookingList", bookingList);
        request.getRequestDispatcher("/WEB-INF/views/user/ManageBookingRequest.jsp")
                .forward(request, response);
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

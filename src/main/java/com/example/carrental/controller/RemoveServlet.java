package com.example.carrental.controller;

import com.example.carrental.model.dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class RemoveServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String bookIdParam = request.getParameter("book_id");
        if (bookIdParam != null && !bookIdParam.trim().isEmpty()) {
            try {
                int bookId = Integer.parseInt(bookIdParam.trim());
                BookingDAO bookingDAO = new BookingDAO();
                bookingDAO.updateStatus(bookId, "CANCELLED");
            } catch (NumberFormatException ignored) { }
        }
        response.sendRedirect(request.getContextPath() + "/mybooking");
    }
}

package com.example.carrental.controller;

import com.example.carrental.model.dao.BookingDAO;
import com.example.carrental.model.dao.PaymentDAO;
import com.example.carrental.model.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;

/**
 * Servlet quản lý yêu cầu đặt xe của chủ xe (owner).
 * URL: /owner/bookings
 */
@WebServlet(name = "OwnerBookingManageServlet", urlPatterns = "/owner/bookings")
public class OwnerBookingManageServlet extends HttpServlet {

    private BookingDAO bookingDAO;
    private PaymentDAO paymentDAO;

    private static final int PAGE_SIZE = 8;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
        paymentDAO = new PaymentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        showBookings(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handlePost(request, response);
    }

    private void showBookings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String statusFilter = request.getParameter("status");
        if (statusFilter != null && statusFilter.trim().isEmpty()) statusFilter = null;
        String keyword = request.getParameter("keyword");
        if (keyword != null && keyword.trim().isEmpty()) keyword = null;
        int page = 1;
        try {
            String p = request.getParameter("page");
            if (p != null && !p.isEmpty()) page = Math.max(1, Integer.parseInt(p));
        } catch (NumberFormatException ignored) {}

        int totalCount = bookingDAO.countByOwnerId(user.getId(), statusFilter, keyword);
        int totalPages = totalCount <= 0 ? 1 : (int) Math.ceil((double) totalCount / PAGE_SIZE);

        var rows = bookingDAO.getByOwnerId(user.getId(), statusFilter, keyword, page, PAGE_SIZE);
        for (var row : rows) {
            var pay = paymentDAO.getByBookingId((Integer) row.get("booking_id"));
            row.put("paymentMethod", pay != null ? pay.getPaymentMethod() : null);
            row.put("paymentStatus", pay != null ? pay.getPaymentStatus() : null);
        }
        request.setAttribute("bookings", rows);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/WEB-INF/views/owner/bookings.jsp").forward(request, response);
    }

    private void handlePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String action = request.getParameter("action");
        String bookingIdParam = request.getParameter("bookingId");
        if (bookingIdParam == null) {
            showBookings(request, response);
            return;
        }
        int bookingId = Integer.parseInt(bookingIdParam);
        String pageParam = request.getParameter("page");
        String statusParam = request.getParameter("status");
        String keywordParam = request.getParameter("keyword");
        StringBuilder redirect = new StringBuilder(request.getContextPath()).append("/owner/bookings?");
        if ("approve-booking".equals(action)) {
            bookingDAO.updateStatus(bookingId, "APPROVED");
            redirect.append("success=approved");
        } else if ("reject-booking".equals(action)) {
            bookingDAO.updateStatus(bookingId, "REJECTED");
            redirect.append("success=rejected");
        } else if ("confirm-handover".equals(action)) {
            bookingDAO.updateStatus(bookingId, "COMPLETED");
            redirect.append("success=handover");
        } else if ("confirm-transfer".equals(action)) {
            try {
                paymentDAO.markPaid(bookingId);
                redirect.append("success=paid");
            } catch (SQLException e) {
                request.setAttribute("error", "Lỗi: " + e.getMessage());
                showBookings(request, response);
                return;
            }
        } else {
            showBookings(request, response);
            return;
        }
        if (pageParam != null && !pageParam.isEmpty()) redirect.append("&page=").append(pageParam);
        if (statusParam != null && !statusParam.isEmpty()) {
            redirect.append("&status=").append(URLEncoder.encode(statusParam, StandardCharsets.UTF_8));
        }
        if (keywordParam != null && !keywordParam.isEmpty()) {
            redirect.append("&keyword=").append(URLEncoder.encode(keywordParam, StandardCharsets.UTF_8));
        }
        response.sendRedirect(redirect.toString());
    }
}

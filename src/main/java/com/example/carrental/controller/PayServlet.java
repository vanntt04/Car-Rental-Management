package com.example.carrental.controller;

import com.example.carrental.model.dao.BankAccountDAO;
import com.example.carrental.model.dao.BookingDAO;
import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.dao.PaymentDAO;
import com.example.carrental.model.entity.BankAccount;
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
import java.math.BigDecimal;

/**
 * Trang thanh toán cho khách hàng.
 * URL: /pay?bookingId=123
 * - Chọn phương thức thanh toán (BANK_TRANSFER, CASH, MOMO, VNPAY, PAYPAL)
 * - Theo dõi trạng thái thanh toán
 * - Hiển thị QR cho chuyển khoản ngân hàng
 */
@WebServlet(name = "PayServlet", urlPatterns = "/pay")
public class PayServlet extends HttpServlet {

    private BookingDAO bookingDAO;
    private CarDAO carDAO;
    private BankAccountDAO bankAccountDAO;
    private PaymentDAO paymentDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
        carDAO = new CarDAO();
        bankAccountDAO = new BankAccountDAO();
        paymentDAO = new PaymentDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("select-method".equals(action)) {
            selectPaymentMethod(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void selectPaymentMethod(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String bookingIdParam = request.getParameter("bookingId");
        String method = request.getParameter("paymentMethod");
        if (method == null || method.trim().isEmpty()) {
            // Fallback nếu hidden paymentMethod không được set kịp
            method = request.getParameter("pm");
        }
        if (bookingIdParam == null || method == null || method.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        int bookingId;
        try {
            bookingId = Integer.parseInt(bookingIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        Booking booking = bookingDAO.getById(bookingId);
        if (booking == null || booking.getCustomer_id() != user.getId()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        try {
            String methodNorm = method.trim().toUpperCase();
            paymentDAO.upsertMethod(bookingId, booking.getTotal_price(), methodNorm);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi lưu phương thức thanh toán.");
        }
        response.sendRedirect(request.getContextPath() + "/pay?bookingId=" + bookingId);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" +
                    java.net.URLEncoder.encode("/pay?bookingId=" + request.getParameter("bookingId"), "UTF-8"));
            return;
        }

        String bookingIdParam = request.getParameter("bookingId");
        if (bookingIdParam == null || bookingIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        int bookingId;
        try {
            bookingId = Integer.parseInt(bookingIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        Booking booking = bookingDAO.getById(bookingId);
        if (booking == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đơn đặt xe");
            return;
        }

        if (booking.getCustomer_id() != user.getId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền thanh toán đơn này");
            return;
        }

        Car car = carDAO.getCarById(booking.getCar_id());
        if (car == null || car.getOwnerId() == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy thông tin xe");
            return;
        }

        BigDecimal amount = booking.getTotal_price();
        Payment payment = paymentDAO.getByBookingId(bookingId);
        if (payment != null && payment.getAmount() != null && payment.getAmount().compareTo(BigDecimal.ZERO) > 0) {
            amount = payment.getAmount();
        }

        request.setAttribute("booking", booking);
        request.setAttribute("car", car);
        request.setAttribute("payment", payment);
        request.setAttribute("amount", amount);

        String method = payment != null ? payment.getPaymentMethod() : null;
        if (method != null) method = method.trim().toUpperCase();

        if (method == null || method.trim().isEmpty()) {
            request.getRequestDispatcher("/WEB-INF/views/car/pay-select.jsp").forward(request, response);
            return;
        }

        if ("BANK_TRANSFER".equals(method)) {
            BankAccount bank = bankAccountDAO.getByOwnerId(car.getOwnerId());
            if (bank == null || bank.getBankCode() == null || bank.getAccountNumber() == null || bank.getAccountNumber().isEmpty()) {
                request.setAttribute("error", "Chủ xe chưa thiết lập tài khoản ngân hàng. Vui lòng chọn phương thức khác hoặc liên hệ chủ xe.");
                request.getRequestDispatcher("/WEB-INF/views/car/pay-select.jsp").forward(request, response);
                return;
            }
            request.setAttribute("bankAccount", bank);
            request.getRequestDispatcher("/WEB-INF/views/car/pay-bank-qr.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/WEB-INF/views/car/pay-other.jsp").forward(request, response);
        }
    }
}

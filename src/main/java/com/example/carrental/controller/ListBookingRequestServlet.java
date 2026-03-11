package com.example.carrental.controller;

import com.example.carrental.model.dao.BookingDAO;
import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.dao.UserDAO;
import com.example.carrental.model.entity.Booking;
import com.example.carrental.model.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ListBookingRequestServlet", urlPatterns = {"/manage-bookings"})
public class ListBookingRequestServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();
    private final CarDAO carDAO = new CarDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // 1. Kiểm tra đăng nhập
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 2. Lấy danh sách booking và nạp thông tin chi tiết (Car, Customer)
        loadBookingsForOwner(request, currentUser.getId());

        // 3. Chuyển hướng tới trang hiển thị
        request.getRequestDispatcher("/WEB-INF/views/user/ManageBookingRequest.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String bookIdStr = request.getParameter("bookingId");

        if (bookIdStr != null && !bookIdStr.isEmpty()) {
            try {
                int bookingId = Integer.parseInt(bookIdStr);

                if ("accept".equals(action)) {
                    bookingDAO.updateBookingStatus(bookingId, "APPROVED");
                    // Có thể thêm logic: carDAO.updateCarStatus(carId, "BUSY");
                } else if ("reject".equals(action)) {
                    bookingDAO.updateBookingStatus(bookingId, "CANCELLED");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID đơn đặt hàng không hợp lệ");
            }
        }

        // Sau khi xử lý xong, chuyển hướng về trang GET để cập nhật dữ liệu mới nhất
        response.sendRedirect(request.getContextPath() + "/manage-bookings");
    }

    /**
     * Helper method để nạp danh sách booking kèm thông tin Car và User liên quan
     */
    private void loadBookingsForOwner(HttpServletRequest request, int ownerId) {
        List<Booking> bookingList = bookingDAO.getBookingsByOwner(ownerId);

        if (bookingList == null || bookingList.isEmpty()) {
            request.setAttribute("message", "Chưa có yêu cầu đặt xe nào.");
        } else {
            // Nạp dữ liệu bổ sung cho mỗi booking object
            for (Booking b : bookingList) {
                b.setCar(carDAO.getCarById(b.getCarId()));
                b.setCustomer(userDAO.getUserById(b.getCustomerId()));
            }
            request.setAttribute("bookingList", bookingList);
        }
    }

    @Override
    public String getServletInfo() {
        return "Controller xử lý danh sách yêu cầu thuê xe dành cho chủ xe";
    }
}
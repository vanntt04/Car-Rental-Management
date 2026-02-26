package com.example.carrental.controller;

import com.example.carrental.model.dao.UserDAO;
import com.example.carrental.model.entity.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Xử lý đường dẫn xác nhận email: /verify?email=...
 * Đơn giản kích hoạt user theo email nếu tồn tại.
 */
@WebServlet(name = "VerifyEmailServlet", urlPatterns = {"/verify"})
public class VerifyEmailServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String message;

        if (email == null || email.trim().isEmpty()) {
            message = "Liên kết xác nhận không hợp lệ.";
        } else {
            User user = userDAO.getUserByEmail(email.trim());
            if (user == null) {
                message = "Tài khoản không tồn tại hoặc đã bị xóa.";
            } else {
                boolean ok = userDAO.activateUserByEmail(email.trim());
                if (ok) {
                    message = "Tài khoản của bạn đã được kích hoạt. Bây giờ bạn có thể đăng nhập.";
                } else {
                    message = "Không thể kích hoạt tài khoản. Vui lòng thử lại sau.";
                }
            }
        }

        request.setAttribute("verifyMessage", message);
        // Forward về trang đăng nhập để hiển thị thông báo
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/auth/login.jsp");
        dispatcher.forward(request, response);
    }
}


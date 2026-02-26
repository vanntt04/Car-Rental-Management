package com.example.carrental.controller;

import com.example.carrental.model.dao.UserDAO;
import com.example.carrental.model.entity.User;
import com.example.carrental.model.util.EmailUtil;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet xử lý đăng ký tài khoản người dùng
 * Đảm bảo đúng mô hình MVC: Controller gọi Model (UserDAO, User) và forward tới View (JSP).
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Hiển thị form đăng ký
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/auth/register.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy dữ liệu từ form
        String username = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        String errorMessage = null;

        // Validate đơn giản phía server
        if (username == null || username.trim().isEmpty()) {
            errorMessage = "Vui lòng nhập tên đăng nhập.";
        } else if (fullName == null || fullName.trim().isEmpty()) {
            errorMessage = "Vui lòng nhập họ tên.";
        } else if (email == null || email.trim().isEmpty()) {
            errorMessage = "Vui lòng nhập email.";
        } else if (password == null || password.trim().isEmpty()) {
            errorMessage = "Vui lòng nhập mật khẩu.";
        } else if (confirmPassword == null || !confirmPassword.equals(password)) {
            errorMessage = "Mật khẩu xác nhận không khớp.";
        }

        // Nếu có lỗi, trả lại form cùng dữ liệu đã nhập
        if (errorMessage != null) {
            request.setAttribute("error", errorMessage);
            request.setAttribute("username", username);
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/auth/register.jsp");
            dispatcher.forward(request, response);
            return;
        }

        try {
            // Kiểm tra username đã tồn tại chưa
            if (userDAO.getUserByUsername(username) != null) {
                request.setAttribute("error", "Tên đăng nhập đã được sử dụng. Vui lòng chọn tên khác.");
                request.setAttribute("username", username);
                request.setAttribute("fullName", fullName);
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/views/auth/register.jsp");
                dispatcher.forward(request, response);
                return;
            }

            // Kiểm tra email đã tồn tại chưa
            if (userDAO.getUserByEmail(email) != null) {
                request.setAttribute("error", "Email đã được sử dụng. Vui lòng chọn email khác.");
                request.setAttribute("username", username);
                request.setAttribute("fullName", fullName);
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/views/auth/register.jsp");
                dispatcher.forward(request, response);
                return;
            }

            // Tạo đối tượng User (Model)
            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            // Mặc định vai trò CUSTOMER
            user.setRole("CUSTOMER");
            // Chưa kích hoạt email -> status = BLOCKED
            user.setActive(false);

            boolean created = userDAO.addUser(user);
            if (created) {
                // Gửi email xác thực
                try {
                    String baseUrl = request.getRequestURL().toString()
                            .replace(request.getRequestURI(), request.getContextPath());
                    String verifyLink = baseUrl + "/verify?email=" +
                            java.net.URLEncoder.encode(email, java.nio.charset.StandardCharsets.UTF_8);

                    EmailUtil.sendVerificationEmail(email, fullName, verifyLink);
                } catch (Exception mailEx) {
                    mailEx.printStackTrace();
                    System.err.println("Failed to send verification email: " + mailEx.getMessage());
                }

                // Đăng ký thành công -> chuyển sang trang đăng nhập với thông báo chờ xác thực
                response.sendRedirect(request.getContextPath() + "/login?success=registered");
            } else {
                request.setAttribute("error", "Không thể tạo tài khoản. Vui lòng thử lại.");
                request.setAttribute("fullName", fullName);
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/views/auth/register.jsp");
                dispatcher.forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi đăng ký. Vui lòng thử lại sau.");
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/auth/register.jsp");
            dispatcher.forward(request, response);
        }
    }
}


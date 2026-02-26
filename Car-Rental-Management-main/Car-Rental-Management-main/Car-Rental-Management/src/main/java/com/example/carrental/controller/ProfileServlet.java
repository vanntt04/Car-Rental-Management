package com.example.carrental.controller;

import com.example.carrental.model.dao.UserDAO;
import com.example.carrental.model.entity.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Cho phép CUSTOMER, OWNER, ADMIN xem và cập nhật thông tin cá nhân.
 */
@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        User user = userDAO.getUserById(userId);

        if (user == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
            return;
        }

        request.setAttribute("user", user);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/user/profile.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        User user = userDAO.getUserById(userId);
        if (user == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
            return;
        }

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        String error = null;
        if (fullName == null || fullName.trim().isEmpty()) {
            error = "Họ tên không được để trống.";
        } else if (newPassword != null && !newPassword.isEmpty()
                && (confirmPassword == null || !newPassword.equals(confirmPassword))) {
            error = "Mật khẩu mới và xác nhận mật khẩu không khớp.";
        }

        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("user", user);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/user/profile.jsp");
            dispatcher.forward(request, response);
            return;
        }

        user.setFullName(fullName);
        user.setPhone(phone);
        if (newPassword != null && !newPassword.isEmpty()) {
            user.setPassword(newPassword);
        }

        boolean ok = userDAO.updateUser(user);
        if (ok) {
            // Cập nhật lại user trong session
            session.setAttribute("user", user);
            session.setAttribute("fullName", user.getFullName());
            session.setAttribute("username", user.getUsername());

            request.setAttribute("user", user);
            request.setAttribute("success", "Cập nhật thông tin cá nhân thành công.");
        } else {
            request.setAttribute("user", user);
            request.setAttribute("error", "Không thể cập nhật thông tin. Vui lòng thử lại sau.");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/user/profile.jsp");
        dispatcher.forward(request, response);
    }
}


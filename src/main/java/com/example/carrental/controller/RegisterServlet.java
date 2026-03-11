package com.example.carrental.controller;

import com.example.carrental.model.dao.UserDAO;
import com.example.carrental.model.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = safe(request.getParameter("fullName"));
        String username = safe(request.getParameter("username"));
        String email = safe(request.getParameter("email"));
        String phone = safe(request.getParameter("phone"));
        String password = safe(request.getParameter("password"));

        if (fullName.isBlank() || username.isBlank() || email.isBlank() || password.isBlank()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin bắt buộc");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        User existed = userDAO.getUserByUsernameOrEmail(username);
        if (existed == null) {
            existed = userDAO.getUserByEmail(email);
        }
        if (existed != null) {
            request.setAttribute("error", "Username hoặc email đã tồn tại");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setFullName(fullName);
        user.setUsername(username);
        user.setEmail(email);
        user.setPhone(phone);
        user.setPassword(password);
        user.setRole("CUSTOMER");
        user.setActive(true);

        boolean ok = userDAO.addUser(user);
        if (!ok) {
            request.setAttribute("error", "Đăng ký thất bại, vui lòng thử lại");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/login");
    }

    private String safe(String v) {
        return v == null ? "" : v.trim();
    }
}

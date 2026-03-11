package com.example.carrental.controller;

import com.example.carrental.model.dao.UserDAO;
import com.example.carrental.model.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "AuthServlet", urlPatterns = {"/login", "/logout"})
public class AuthServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        if ("/logout".equals(servletPath)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String emailOrUsername = trim(request.getParameter("emailOrUsername"));
        String password = trim(request.getParameter("password"));

        if (emailOrUsername.isEmpty() || password.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin đăng nhập");
            request.setAttribute("emailOrUsername", emailOrUsername);
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        // Hiện tại DB/DAO đang hỗ trợ đăng nhập theo email.
        User user = userDAO.login(emailOrUsername, password);

        if (user == null) {
            request.setAttribute("error", "Email hoặc mật khẩu không đúng");
            request.setAttribute("emailOrUsername", emailOrUsername);
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);
        session.setAttribute("role", user.getRole());
        session.setAttribute("fullName", user.getFullName());

        Object redirect = session.getAttribute("redirectAfterLogin");
        if (redirect instanceof String redirectUrl && !redirectUrl.isBlank()) {
            session.removeAttribute("redirectAfterLogin");
            response.sendRedirect(redirectUrl);
            return;
        }

        if ("OWNER".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/owner");
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}

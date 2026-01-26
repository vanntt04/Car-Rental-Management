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
 * Controller xử lý đăng nhập và đăng xuất
 * Controller trong mô hình MVC
 */
@WebServlet(name = "AuthServlet", urlPatterns = {"/login", "/logout"})
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        
        if ("/logout".equals(path)) {
            // Xử lý đăng xuất
            logout(request, response);
        } else {
            // Hiển thị trang đăng nhập
            showLoginPage(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        
        if ("/login".equals(path)) {
            // Xử lý đăng nhập
            processLogin(request, response);
        } else {
            doGet(request, response);
        }
    }

    /**
     * Hiển thị trang đăng nhập
     */
    private void showLoginPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Nếu đã đăng nhập, chuyển về trang chủ
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Xử lý đăng nhập
     */
    private void processLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String emailOrUsername = request.getParameter("emailOrUsername");
        String password = request.getParameter("password");
        
        String errorMessage = null;
        
        // Validate input
        if (emailOrUsername == null || emailOrUsername.trim().isEmpty()) {
            errorMessage = "Vui lòng nhập email hoặc tên đăng nhập";
        } else if (password == null || password.trim().isEmpty()) {
            errorMessage = "Vui lòng nhập mật khẩu";
        } else {
            // Thực hiện đăng nhập
            User user = userDAO.login(emailOrUsername.trim(), password);
            
            if (user != null) {
                // Đăng nhập thành công - tạo session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("fullName", user.getFullName());
                session.setAttribute("role", user.getRole());
                
                // Chuyển hướng về trang chủ hoặc trang được yêu cầu trước đó
                String redirectUrl = request.getParameter("redirect");
                if (redirectUrl != null && !redirectUrl.isEmpty()) {
                    response.sendRedirect(redirectUrl);
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }
                return;
            } else {
                errorMessage = "Email/tên đăng nhập hoặc mật khẩu không đúng";
            }
        }
        
        // Đăng nhập thất bại - hiển thị lại form với thông báo lỗi
        request.setAttribute("error", errorMessage);
        request.setAttribute("emailOrUsername", emailOrUsername);
        showLoginPage(request, response);
    }

    /**
     * Xử lý đăng xuất
     */
    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        // Chuyển về trang chủ
        response.sendRedirect(request.getContextPath() + "/home");
    }
}

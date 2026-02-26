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
            
            logout(request, response);
        } else {
        
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

   
    private void showLoginPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Nếu đã đăng nhập, chuyển về trang chủ
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/auth/login.jsp");
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
        
        // Log để debug
        System.out.println("=== Login Attempt ===");
        System.out.println("Email/Username: " + emailOrUsername);
        System.out.println("Password length: " + (password != null ? password.length() : 0));
        
        // Validate input
        if (emailOrUsername == null || emailOrUsername.trim().isEmpty()) {
            errorMessage = "Vui lòng nhập email hoặc tên đăng nhập";
        } else if (password == null || password.trim().isEmpty()) {
            errorMessage = "Vui lòng nhập mật khẩu";
        } else {
            try {
                // Thực hiện đăng nhập
                User user = userDAO.login(emailOrUsername.trim(), password);
                
                System.out.println("Login result - User found: " + (user != null));
                
                if (user != null) {
                    System.out.println("Login successful for user: " + user.getUsername());
                    
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
                    System.out.println("Login failed: Invalid credentials");
                }
            } catch (Exception e) {
                System.err.println("Error during login: " + e.getMessage());
                e.printStackTrace();
                errorMessage = "Có lỗi xảy ra khi đăng nhập. Vui lòng thử lại sau.";
            }
        }
        
        
        request.setAttribute("error", errorMessage);
        request.setAttribute("emailOrUsername", emailOrUsername);
        showLoginPage(request, response);
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        response.sendRedirect(request.getContextPath() + "/home");
    }
}

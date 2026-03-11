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
import java.util.List;

/**
 * Controller xử lý các request liên quan đến người dùng
 * Controller trong mô hình MVC
 */
@WebServlet(name = "UserServlet", urlPatterns = "/users")
public class UserServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        try {
            if (idParam != null && !idParam.isEmpty()) {
                // Hiển thị chi tiết người dùng (có thể mở rộng sau)
                showUserList(request, response);
            } else if ("new".equals(action)) {
                // Hiển thị form thêm người dùng mới (có thể mở rộng sau)
                showUserList(request, response);
            } else {
                // Hiển thị danh sách người dùng
                showUserList(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            showUserList(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

      
    }

    /**
     * Hiển thị danh sách người dùng
     */
    private void showUserList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/list.jsp");
        dispatcher.forward(request, response);
    }

   
}

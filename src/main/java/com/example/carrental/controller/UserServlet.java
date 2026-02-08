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

        if ("create".equals(action)) {
            createUser(request, response);
        } else if ("update".equals(action)) {
            updateUser(request, response);
        } else if ("delete".equals(action)) {
            deleteUser(request, response);
        } else {
            doGet(request, response);
        }
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

    /**
     * Tạo người dùng mới
     */
    private void createUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            User user = new User();
            user.setUsername(request.getParameter("username"));
            user.setPassword(request.getParameter("password"));
            user.setFullName(request.getParameter("fullName"));
            user.setEmail(request.getParameter("email"));
            user.setPhone(request.getParameter("phone"));
            user.setRole(request.getParameter("role") != null ? 
                        request.getParameter("role") : "CUSTOMER");
            
            if (userDAO.addUser(user)) {
                response.sendRedirect(request.getContextPath() + "/users?success=created");
            } else {
                request.setAttribute("error", "Không thể thêm người dùng mới");
                showUserList(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            showUserList(request, response);
        }
    }

    /**
     * Cập nhật thông tin người dùng
     */
    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            User user = userDAO.getUserById(userId);
            
            if (user != null) {
                user.setUsername(request.getParameter("username"));
                user.setPassword(request.getParameter("password"));
                user.setFullName(request.getParameter("fullName"));
                user.setEmail(request.getParameter("email"));
                user.setPhone(request.getParameter("phone"));
                user.setRole(request.getParameter("role"));
                
                String activeStr = request.getParameter("active");
                user.setActive(activeStr != null && "true".equals(activeStr));
                
                if (userDAO.updateUser(user)) {
                    response.sendRedirect(request.getContextPath() + "/users?success=updated");
                } else {
                    request.setAttribute("error", "Không thể cập nhật thông tin người dùng");
                    showUserList(request, response);
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            showUserList(request, response);
        }
    }

    /**
     * Xóa người dùng
     */
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            
            if (userDAO.deleteUser(userId)) {
                response.sendRedirect(request.getContextPath() + "/users?success=deleted");
            } else {
                request.setAttribute("error", "Không thể xóa người dùng");
                showUserList(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            showUserList(request, response);
        }
    }
}

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
        if (!requireAdmin(request, response)) {
            return;
        }
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        try {
            if ("new".equals(action)) {
                request.setAttribute("user", null);
                request.getRequestDispatcher("/views/user/form.jsp").forward(request, response);
                return;
            }
            if ("edit".equals(action) && idParam != null && !idParam.isEmpty()) {
                int id = Integer.parseInt(idParam);
                User user = userDAO.getUserById(id);
                if (user != null) {
                    request.setAttribute("user", user);
                    request.getRequestDispatcher("/views/user/form.jsp").forward(request, response);
                    return;
                }
            }
            showUserList(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            showUserList(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!requireAdmin(request, response)) {
            return;
        }
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            createUser(request, response);
        } else if ("update".equals(action)) {
            updateUser(request, response);
        } else if ("delete".equals(action)) {
            deleteUser(request, response);
        } else if ("toggleStatus".equals(action)) {
            toggleStatus(request, response);
        } else if ("assignRole".equals(action)) {
            assignRole(request, response);
        } else {
            doGet(request, response);
        }
    }

    /** Chỉ ADMIN mới được truy cập; nếu không thì redirect về home với error. */
    private boolean requireAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        Object role = session != null ? session.getAttribute("role") : null;
        if (!"ADMIN".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/home?error=forbidden");
            return false;
        }
        return true;
    }

    private void toggleStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String status = request.getParameter("status");
            Integer currentUserId = (Integer) request.getSession(false).getAttribute("userId");
            if (currentUserId != null && currentUserId == userId && "BLOCKED".equals(status)) {
                request.setAttribute("error", "Bạn không thể vô hiệu hóa chính tài khoản của mình.");
                showUserList(request, response);
                return;
            }
            if ("ACTIVE".equals(status) || "BLOCKED".equals(status)) {
                if (userDAO.updateUserStatus(userId, status)) {
                    response.sendRedirect(request.getContextPath() + "/users?success=status");
                } else {
                    request.setAttribute("error", "Không thể cập nhật trạng thái.");
                    showUserList(request, response);
                }
            } else {
                request.setAttribute("error", "Trạng thái không hợp lệ.");
                showUserList(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            showUserList(request, response);
        }
    }

    private void assignRole(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String role = request.getParameter("role");
            if (role == null || role.isEmpty()) {
                request.setAttribute("error", "Vui lòng chọn vai trò.");
                showUserList(request, response);
                return;
            }
            if (userDAO.setUserRole(userId, role)) {
                response.sendRedirect(request.getContextPath() + "/users?success=role");
            } else {
                request.setAttribute("error", "Không thể đổi vai trò.");
                showUserList(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            showUserList(request, response);
        }
    }

    /**
     * Hiển thị danh sách người dùng (có thể lọc theo từ khóa search)
     */
    private void showUserList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String q = request.getParameter("q");
        List<User> users = (q != null && !q.trim().isEmpty())
                ? userDAO.searchUsers(q)
                : userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.setAttribute("searchKeyword", q != null ? q : "");

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/user/list.jsp");
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
     * Cập nhật thông tin người dùng (và vai trò trong user_roles)
     */
    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            User user = userDAO.getUserById(userId);
            if (user == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
                return;
            }
            user.setUsername(request.getParameter("username"));
            String password = request.getParameter("password");
            if (password != null && !password.trim().isEmpty()) {
                user.setPassword(password.trim());
            }
            user.setFullName(request.getParameter("fullName"));
            user.setEmail(request.getParameter("email"));
            user.setPhone(request.getParameter("phone"));
            String role = request.getParameter("role");
            user.setRole(role != null && !role.isEmpty() ? role : "CUSTOMER");
            String activeStr = request.getParameter("active");
            user.setActive(activeStr != null && "true".equals(activeStr));

            if (userDAO.updateUser(user) && userDAO.setUserRole(userId, user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/users?success=updated");
            } else {
                request.setAttribute("error", "Không thể cập nhật thông tin người dùng");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/views/user/form.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            showUserList(request, response);
        }
    }

    /**
     * Xóa người dùng (không cho xóa chính mình)
     */
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            Integer currentUserId = (Integer) request.getSession(false).getAttribute("userId");
            if (currentUserId != null && currentUserId == userId) {
                request.setAttribute("error", "Bạn không thể xóa chính tài khoản của mình.");
                showUserList(request, response);
                return;
            }
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

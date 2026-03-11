package com.example.carrental.model.dao;

import com.example.carrental.model.entity.User;
import com.example.carrental.model.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * UserDAO tương thích với schema.sql hiện tại:
 * users(id, username, password, full_name, email, phone, role, active, created_at)
 */
public class UserDAO {

    private final DBConnection dbConnection;

    public UserDAO() {
        this.dbConnection = DBConnection.getInstance();
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT id, username, full_name, email, password, phone, role, active, created_at FROM users ORDER BY id DESC";

        try (Connection conn = dbConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public User getUserById(int id) {
        String sql = "SELECT id, username, full_name, email, password, phone, role, active, created_at FROM users WHERE id = ?";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public User getUserByEmail(String email) {
        String sql = "SELECT id, username, full_name, email, password, phone, role, active, created_at FROM users WHERE email = ?";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public User getUserByUsernameOrEmail(String value) {
        // Schema mới: id + active + role
        String sqlNew = "SELECT id, username, full_name, email, password, phone, role, active, created_at " +
                "FROM users WHERE username = ? OR email = ? LIMIT 1";

        // Schema cũ: user_id + status, role lấy từ user_roles/roles
        String sqlOld = "SELECT u.user_id, u.username, u.full_name, u.email, u.password, u.phone, " +
                "r.role_name AS role, u.status, u.created_at " +
                "FROM users u " +
                "LEFT JOIN user_roles ur ON ur.user_id = u.user_id " +
                "LEFT JOIN roles r ON r.role_id = ur.role_id " +
                "WHERE u.username = ? OR u.email = ? " +
                "LIMIT 1";

        User user = queryUserByUsernameOrEmail(sqlNew, value);
        if (user != null) return user;
        return queryUserByUsernameOrEmail(sqlOld, value);
    }

    public User login(String usernameOrEmail, String password) {
        User user = getUserByUsernameOrEmail(usernameOrEmail);
        if (user != null && user.isActive() && password.equals(user.getPassword())) {
            user.setPassword(null);
            return user;
        }
        return null;
    }

    private User queryUserByUsernameOrEmail(String sql, String value) {
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, value);
            pstmt.setString(2, value);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return mapResultSetToUser(rs);
            }
        } catch (SQLException ignored) {
            // thử schema còn lại
        }
        return null;
    }

    public boolean addUser(User user) {
        String sql = "INSERT INTO users (username, full_name, email, password, phone, role, active) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            String username = (user.getUsername() == null || user.getUsername().isBlank())
                    ? user.getEmail()
                    : user.getUsername();
            pstmt.setString(1, username);
            pstmt.setString(2, user.getFullName());
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getPassword());
            pstmt.setString(5, user.getPhone());
            pstmt.setString(6, user.getRole() == null ? "CUSTOMER" : user.getRole());
            pstmt.setInt(7, user.isActive() ? 1 : 0);

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateUser(User user) {
        String sql = "UPDATE users SET full_name = ?, email = ?, phone = ?, role = ?, active = ? WHERE id = ?";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user.getFullName());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPhone());
            pstmt.setString(4, user.getRole() == null ? "CUSTOMER" : user.getRole());
            pstmt.setInt(5, user.isActive() ? 1 : 0);
            pstmt.setInt(6, user.getId());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updatePassword(String email, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE email = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newPassword);
            pstmt.setString(2, email);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteUser(int id) {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();

        // Hỗ trợ cả schema mới (id, active) và schema cũ (user_id, status)
        int id;
        try {
            id = rs.getInt("id");
        } catch (SQLException e) {
            id = rs.getInt("user_id");
        }
        user.setId(id);

        user.setUsername(getOptionalString(rs, "username"));
        user.setFullName(getOptionalString(rs, "full_name"));
        user.setEmail(getOptionalString(rs, "email"));
        user.setPassword(getOptionalString(rs, "password"));
        user.setPhone(getOptionalString(rs, "phone"));

        String role = getOptionalString(rs, "role");
        if (role == null || role.isBlank()) {
            role = "CUSTOMER";
        }
        user.setRole(role);

        boolean isActive;
        try {
            isActive = rs.getInt("active") == 1;
        } catch (SQLException e) {
            String status = getOptionalString(rs, "status");
            isActive = "ACTIVE".equalsIgnoreCase(status) || "1".equals(status);
        }
        user.setActive(isActive);

        Timestamp createdAt = null;
        try {
            createdAt = rs.getTimestamp("created_at");
        } catch (SQLException ignored) {
        }
        if (createdAt != null) {
            user.setCreatedAt(createdAt.toLocalDateTime());
        }
        return user;
    }

    private String getOptionalString(ResultSet rs, String column) {
        try {
            return rs.getString(column);
        } catch (SQLException e) {
            return null;
        }
    }
}

package com.example.carrental.model.dao;

import com.example.carrental.model.entity.User;
import com.example.carrental.model.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    private DBConnection dbConnection;

    public UserDAO() {
        this.dbConnection = DBConnection.getInstance();
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();

        String sql = "SELECT user_id, username, full_name, email, password, phone, status, created_at "
                + "FROM users ORDER BY user_id DESC";

        try (Connection conn = dbConnection.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                User u = mapResultSetToUser(rs);
                try {
                    loadUserRole(conn, u);
                } catch (Exception ignored) {
                }
                users.add(u);
            }

        } catch (SQLException e) {
            System.err.println("Error getting all users: " + e.getMessage());
            e.printStackTrace();
        }

        return users;
    }

    public User getUserById(int id) {

        String sql = "SELECT user_id, username, full_name, email, password, phone, status, created_at "
                + "FROM users WHERE user_id = ?";

        User user = null;

        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                user = mapResultSetToUser(rs);
                try {
                    loadUserRole(conn, user);
                } catch (Exception ignored) {
                }
            }

            rs.close();

        } catch (SQLException e) {
            System.err.println("Error getting user by id: " + e.getMessage());
            e.printStackTrace();
        }

        return user;
    }

    public boolean updatePassword(String email, String newPassword) throws SQLException {

        String sql = "UPDATE users SET password = ? WHERE email = ?";

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConnection.getConnection();
            stmt = conn.prepareStatement(sql);

            stmt.setString(1, newPassword);
            stmt.setString(2, email);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } finally {
            if (stmt != null) {
                stmt.close();
            }
            dbConnection.closeConnection(conn);
        }
    }

    public User getUserByPhone(String phone) {

        String sql = "SELECT user_id, username, full_name, email, password, phone, status, created_at "
                + "FROM users WHERE phone = ?";

        User user = null;

        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, phone);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                user = mapResultSetToUser(rs);
                try {
                    loadUserRole(conn, user);
                } catch (Exception ignored) {
                }
            }

            rs.close();

        } catch (SQLException e) {
            System.err.println("Error getting user by phone: " + e.getMessage());
            e.printStackTrace();
        }

        return user;
    }

    public User getUserByEmail(String email) {

        String sql = "SELECT user_id, username, full_name, email, password, phone, status, created_at "
                + "FROM users WHERE email = ?";

        User user = null;

        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                user = mapResultSetToUser(rs);
                loadUserRole(conn, user);
            }

            rs.close();

        } catch (SQLException e) {
            System.err.println("Error getting user by email: " + e.getMessage());
            e.printStackTrace();
        }

        return user;
    }

    /**
     * Lấy role từ bảng user_roles + roles
     */
    private void loadUserRole(Connection conn, User user) {

        String sql = "SELECT r.role_name FROM user_roles ur "
                + "JOIN roles r ON ur.role_id = r.role_id "
                + "WHERE ur.user_id = ? LIMIT 1";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, user.getId());
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user.setRole(rs.getString("role_name"));
            }

            rs.close();

        } catch (SQLException e) {
            // Nếu lỗi thì giữ role mặc định từ mapResultSetToUser
        }
    }

    public User login(String emailOrUsername, String password) {

        User user = getUserByEmail(emailOrUsername);

        if (user == null) {
            return null;
        }
        if (!user.isActive()) {
            return null;
        }
        if (user.getPassword() == null) {
            return null;
        }

        if (user.getPassword().equals(password)) {
            user.setPassword(null);
            return user;
        }

        return null;
    }

    public boolean addUser(User user) {

        String sql = "INSERT INTO users (username, password, full_name, email, phone, status) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getFullName());
            pstmt.setString(4, user.getEmail());
            pstmt.setString(5, user.getPhone());
            pstmt.setString(6, user.isActive() ? "ACTIVE" : "BLOCKED");

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error adding user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateUser(User user) {

        String sql = "UPDATE users SET username = ?, password = ?, full_name = ?, email = ?, "
                + "phone = ?, status = ? WHERE user_id = ?";

        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getFullName());
            pstmt.setString(4, user.getEmail());
            pstmt.setString(5, user.getPhone());
            pstmt.setString(6, user.isActive() ? "ACTIVE" : "BLOCKED");
            pstmt.setInt(7, user.getId());

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteUser(int id) {

        String sql = "DELETE FROM users WHERE user_id = ?";

        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {

        User user = new User();

        user.setId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setFullName(rs.getString("full_name"));
        user.setPhone(rs.getString("phone"));

        String status = rs.getString("status");
        user.setActive("ACTIVE".equalsIgnoreCase(status));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            user.setCreatedAt(createdAt.toLocalDateTime());
        }

        return user;
    }
}

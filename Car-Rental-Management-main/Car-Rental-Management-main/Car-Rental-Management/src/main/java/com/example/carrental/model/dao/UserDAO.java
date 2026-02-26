package com.example.carrental.model.dao;

import com.example.carrental.model.entity.User;
import com.example.carrental.model.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object cho User entity
 * Model layer - DAO pattern
 */
public class UserDAO {
    private DBConnection dbConnection;

    public UserDAO() {
        this.dbConnection = DBConnection.getInstance();
    }

    
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT u.user_id, u.username, u.full_name, u.email, u.password, u.phone, u.status, u.created_at, r.role_name " +
                     "FROM users u LEFT JOIN user_roles ur ON u.user_id = ur.user_id LEFT JOIN roles r ON ur.role_id = r.role_id " +
                     "ORDER BY u.user_id DESC";
        
        try (Connection conn = dbConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting all users: " + e.getMessage());
            e.printStackTrace();
        }
        
        return users;
    }

    /**
     * Tìm kiếm user theo từ khóa (username, full_name, email, phone)
     */
    public List<User> searchUsers(String keyword) {
        List<User> users = new ArrayList<>();
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllUsers();
        }
        String q = "%" + keyword.trim() + "%";
        String sql = "SELECT u.user_id, u.username, u.full_name, u.email, u.password, u.phone, u.status, u.created_at, r.role_name " +
                     "FROM users u LEFT JOIN user_roles ur ON u.user_id = ur.user_id LEFT JOIN roles r ON ur.role_id = r.role_id " +
                     "WHERE u.username LIKE ? OR u.full_name LIKE ? OR u.email LIKE ? OR u.phone LIKE ? " +
                     "ORDER BY u.user_id DESC";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, q);
            pstmt.setString(2, q);
            pstmt.setString(3, q);
            pstmt.setString(4, q);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            rs.close();
        } catch (SQLException e) {
            System.err.println("Error searching users: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    public User getUserById(int id) {
        String sql = "SELECT u.user_id, u.username, u.full_name, u.email, u.password, u.phone, u.status, u.created_at, r.role_name " +
                     "FROM users u LEFT JOIN user_roles ur ON u.user_id = ur.user_id LEFT JOIN roles r ON ur.role_id = r.role_id " +
                     "WHERE u.user_id = ?";
        User user = null;
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                user = mapResultSetToUser(rs);
            }
            
            rs.close();
        } catch (SQLException e) {
            System.err.println("Error getting user by id: " + e.getMessage());
            e.printStackTrace();
        }
        
        return user;
    }

    
    /**
     * Lấy người dùng theo username (schema mới có cột username)
     */
    public User getUserByUsername(String username) {
        String sql = "SELECT u.user_id, u.username, u.full_name, u.email, u.password, u.phone, u.status, u.created_at, r.role_name " +
                     "FROM users u LEFT JOIN user_roles ur ON u.user_id = ur.user_id LEFT JOIN roles r ON ur.role_id = r.role_id " +
                     "WHERE u.username = ?";
        User user = null;

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                user = mapResultSetToUser(rs);
            }

            rs.close();
        } catch (SQLException e) {
            System.err.println("Error getting user by username: " + e.getMessage());
            e.printStackTrace();
        }

        return user;
    }

    
    public User getUserByPhone(String phone) {
        String sql = "SELECT u.user_id, u.username, u.full_name, u.email, u.password, u.phone, u.status, u.created_at, r.role_name " +
                     "FROM users u LEFT JOIN user_roles ur ON u.user_id = ur.user_id LEFT JOIN roles r ON ur.role_id = r.role_id " +
                     "WHERE u.phone = ?";
        User user = null;
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, phone);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                user = mapResultSetToUser(rs);
            }
            
            rs.close();
        } catch (SQLException e) {
            System.err.println("Error getting user by phone: " + e.getMessage());
            e.printStackTrace();
        }
        
        return user;
    }

    /**
     * Lấy người dùng theo email
     */
    public User getUserByEmail(String email) {
        String sql = "SELECT u.user_id, u.username, u.full_name, u.email, u.password, u.phone, u.status, u.created_at, r.role_name " +
                     "FROM users u LEFT JOIN user_roles ur ON u.user_id = ur.user_id LEFT JOIN roles r ON ur.role_id = r.role_id " +
                     "WHERE u.email = ?";
        User user = null;
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                user = mapResultSetToUser(rs);
            }
            
            rs.close();
        } catch (SQLException e) {
            System.err.println("Error getting user by email: " + e.getMessage());
            e.printStackTrace();
        }
        
        return user;
    }

    public User login(String emailOrUsername, String password) {
        System.out.println("UserDAO.login() called with: " + emailOrUsername);

        User user = getUserByEmail(emailOrUsername);
        System.out.println("User found by email: " + (user != null));

        // Nếu không tìm thấy theo email, thử tìm theo username
        if (user == null) {
            user = getUserByUsername(emailOrUsername);
            System.out.println("User found by username: " + (user != null));
        }

        if (user == null) {
            System.out.println("User not found in database");
            return null;
        }
        // Kiểm tra user có tồn tại, đang active và password đúng
        if (!user.isActive()) {
            System.out.println("Login failed: User is not active (status != ACTIVE)");
            return null;
        }
        
        if (user.getPassword() == null) {
            System.out.println("Login failed: Password is null in database");
            return null;
        }
        
        boolean passwordMatch = user.getPassword().equals(password);
        System.out.println("Password match: " + passwordMatch);
        
        if (passwordMatch) {
            // Không trả về password trong object để bảo mật
            user.setPassword(null);
            System.out.println("Login successful!");
            return user;
        } else {
            System.out.println("Login failed: Password does not match");
            return null;
        }
    }

    /**
     * Thêm người dùng mới
     */
    public boolean addUser(User user) {
        // Phù hợp với schema.sql mới:
        // users(user_id, username, full_name, email, password, phone, status, created_at)
        // Đồng thời thêm bản ghi vào bảng user_roles dựa trên roles.role_name
        String insertUserSql =
                "INSERT INTO users (username, full_name, email, password, phone, status) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        String insertUserRoleSql =
                "INSERT INTO user_roles (user_id, role_id) " +
                "VALUES (?, (SELECT role_id FROM roles WHERE role_name = ?))";

        Connection conn = null;
        PreparedStatement userStmt = null;
        PreparedStatement roleStmt = null;

        try {
            conn = dbConnection.getConnection();
            conn.setAutoCommit(false);

            userStmt = conn.prepareStatement(insertUserSql, Statement.RETURN_GENERATED_KEYS);
            userStmt.setString(1, user.getUsername());
            userStmt.setString(2, user.getFullName());
            userStmt.setString(3, user.getEmail());
            userStmt.setString(4, user.getPassword());
            userStmt.setString(5, user.getPhone());
            // Map active -> status
            userStmt.setString(6, user.isActive() ? "ACTIVE" : "BLOCKED");

            int affected = userStmt.executeUpdate();
            if (affected == 0) {
                conn.rollback();
                return false;
            }

            int userId;
            try (ResultSet rs = userStmt.getGeneratedKeys()) {
                if (rs.next()) {
                    userId = rs.getInt(1);
                } else {
                    conn.rollback();
                    return false;
                }
            }

            String roleName = user.getRole() != null ? user.getRole() : "CUSTOMER";
            roleStmt = conn.prepareStatement(insertUserRoleSql);
            roleStmt.setInt(1, userId);
            roleStmt.setString(2, roleName);

            int roleAffected = roleStmt.executeUpdate();
            if (roleAffected == 0) {
                conn.rollback();
                return false;
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            System.err.println("Error adding user: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            if (roleStmt != null) {
                try { roleStmt.close(); } catch (SQLException ignored) {}
            }
            if (userStmt != null) {
                try { userStmt.close(); } catch (SQLException ignored) {}
            }
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ignored) {}
            }
        }
    }

    /**
     * Cập nhật trạng thái tài khoản (ACTIVE / BLOCKED) – dùng cho admin
     */
    public boolean updateUserStatus(int userId, String status) {
        if (status == null || (!"ACTIVE".equals(status) && !"BLOCKED".equals(status))) {
            return false;
        }
        String sql = "UPDATE users SET status = ? WHERE user_id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setInt(2, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating user status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Gán vai trò cho user (cập nhật user_roles) – dùng cho admin
     */
    public boolean setUserRole(int userId, String roleName) {
        if (roleName == null || roleName.isEmpty()) return false;
        String[] allowed = { "GUEST", "CUSTOMER", "OWNER", "ADMIN" };
        boolean ok = false;
        for (String a : allowed) {
            if (a.equals(roleName)) { ok = true; break; }
        }
        if (!ok) return false;
        String deleteSql = "DELETE FROM user_roles WHERE user_id = ?";
        String insertSql = "INSERT INTO user_roles (user_id, role_id) VALUES (?, (SELECT role_id FROM roles WHERE role_name = ?))";
        try (Connection conn = dbConnection.getConnection()) {
            try (PreparedStatement del = conn.prepareStatement(deleteSql)) {
                del.setInt(1, userId);
                del.executeUpdate();
            }
            try (PreparedStatement ins = conn.prepareStatement(insertSql)) {
                ins.setInt(1, userId);
                ins.setString(2, roleName);
                return ins.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error setting user role: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Kích hoạt tài khoản (status = 'ACTIVE') theo email
     */
    public boolean activateUserByEmail(String email) {
        String sql = "UPDATE users SET status = 'ACTIVE' WHERE email = ?";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error activating user by email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cập nhật thông tin người dùng
     */
    public boolean updateUser(User user) {
        // Cập nhật để phù hợp với schema mới (không còn cột role, active, id)
        String sql = "UPDATE users SET username = ?, full_name = ?, email = ?, password = ?, " +
                     "phone = ?, status = ? WHERE user_id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getFullName());
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getPassword());
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

    /**
     * Xóa người dùng
     */
    public boolean deleteUser(int id) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

//    /**
//     * Map ResultSet thành User object
//     * Cập nhật để match với schema thực tế: user_id, status
//     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        
        // Map user_id -> id
        try {
            user.setId(rs.getInt("user_id"));
        } catch (SQLException e) {
            // Fallback nếu không có user_id, thử id
            try {
                user.setId(rs.getInt("id"));
            } catch (SQLException e2) {
                // Ignore
            }
        }
        
        // username (có trong schema mới)
        try {
            user.setUsername(rs.getString("username"));
        } catch (SQLException e) {
            // Fallback nếu không có cột username: dùng phần trước @ của email
        }

        String email = rs.getString("email");
        user.setEmail(email);

        if (user.getUsername() == null) {
            user.setUsername(email != null ? email.split("@")[0] : null);
        }

        user.setPassword(rs.getString("password"));
        user.setFullName(rs.getString("full_name"));
        user.setPhone(rs.getString("phone"));
        
        // Map status -> active (status = "ACTIVE" -> active = true)
        try {
            String status = rs.getString("status");
            user.setActive("ACTIVE".equalsIgnoreCase(status));
        } catch (SQLException e) {
            try {
                user.setActive(rs.getBoolean("active"));
            } catch (SQLException e2) {
                user.setActive(true);
            }
        }
        // Role: ưu tiên từ JOIN roles (role_name), fallback theo email hoặc CUSTOMER
        try {
            String roleName = rs.getString("role_name");
            if (roleName != null && !roleName.isEmpty()) {
                user.setRole(roleName);
            } else if (email != null) {
                if (email.contains("admin")) user.setRole("ADMIN");
                else if (email.contains("owner")) user.setRole("OWNER");
                else user.setRole("CUSTOMER");
            } else {
                user.setRole("CUSTOMER");
            }
        } catch (SQLException e) {
            user.setRole("CUSTOMER");
        }
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            user.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        return user;
    }
}

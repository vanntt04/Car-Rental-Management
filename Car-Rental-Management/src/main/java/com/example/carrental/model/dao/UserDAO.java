package com.example.carrental.model.dao;

import com.example.carrental.model.entity.User;
import com.example.carrental.model.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
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
        // Cập nhật để match với schema thực tế: user_id, status thay vì id, active
        String sql = "SELECT user_id, full_name, email, password, phone, status, created_at " +
                     "FROM users ORDER BY user_id DESC";
        
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

    public User getUserById(int id) {
        // Cập nhật để match với schema thực tế: user_id
        String sql = "SELECT user_id, full_name, email, password, phone, status, created_at " +
                     "FROM users WHERE user_id = ?";
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

    
    public User getUserByUsername(String username) {
        // Schema thực tế không có username, nên tìm theo email hoặc trả về null
        // Có thể dùng email làm username
        return getUserByEmail(username);
    }

    
    public User getUserByPhone(String phone) {
        String sql = "SELECT id, username, password, full_name, email, phone, role, active, created_at, updated_at " +
                     "FROM users WHERE phone = ?";
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
        // Cập nhật để match với schema thực tế
        String sql = "SELECT user_id, full_name, email, password, phone, status, created_at " +
                     "FROM users WHERE email = ?";
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
        String sql = "INSERT INTO users (username, password, full_name, email, phone, role, active) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getFullName());
            pstmt.setString(4, user.getEmail());
            pstmt.setString(5, user.getPhone());
            pstmt.setString(6, user.getRole());
            pstmt.setBoolean(7, user.isActive());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error adding user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cập nhật thông tin người dùng
     */
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET username = ?, password = ?, full_name = ?, email = ?, " +
                     "phone = ?, role = ?, active = ? WHERE id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getFullName());
            pstmt.setString(4, user.getEmail());
            pstmt.setString(5, user.getPhone());
            pstmt.setString(6, user.getRole());
            pstmt.setBoolean(7, user.isActive());
            pstmt.setInt(8, user.getId());
            
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
        String sql = "DELETE FROM users WHERE id = ?";
        
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
        
        // Username không có trong DB, dùng email làm username
        String email = rs.getString("email");
        user.setEmail(email);
        user.setUsername(email != null ? email.split("@")[0] : null); // Lấy phần trước @ làm username
        
        user.setPassword(rs.getString("password"));
        user.setFullName(rs.getString("full_name"));
        user.setPhone(rs.getString("phone"));
        
        // Map status -> active (status = "ACTIVE" -> active = true)
        try {
            String status = rs.getString("status");
            user.setActive("ACTIVE".equalsIgnoreCase(status));
            
            // Set role dựa trên email hoặc status
            if (email != null) {
                if (email.contains("admin")) {
                    user.setRole("ADMIN");
                } else if (email.contains("owner")) {
                    user.setRole("OWNER");
                } else {
                    user.setRole("CUSTOMER");
                }
            } else {
                user.setRole("CUSTOMER");
            }
        } catch (SQLException e) {
            // Fallback nếu không có status, thử active
            try {
                user.setActive(rs.getBoolean("active"));
                user.setRole(rs.getString("role"));
            } catch (SQLException e2) {
                // Default values
                user.setActive(true);
                user.setRole("CUSTOMER");
            }
        }
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            user.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        return user;
    }
}

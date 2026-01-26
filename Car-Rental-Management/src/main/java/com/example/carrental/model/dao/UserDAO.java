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

    /**
     * Lấy tất cả người dùng
     */
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT id, username, password, full_name, email, phone, role, active, created_at, updated_at " +
                     "FROM users ORDER BY id DESC";
        
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
     * Lấy người dùng theo ID
     */
    public User getUserById(int id) {
        String sql = "SELECT id, username, password, full_name, email, phone, role, active, created_at, updated_at " +
                     "FROM users WHERE id = ?";
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
     * Lấy người dùng theo username
     */
    public User getUserByUsername(String username) {
        String sql = "SELECT id, username, password, full_name, email, phone, role, active, created_at, updated_at " +
                     "FROM users WHERE username = ?";
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

    /**
     * Lấy người dùng theo số điện thoại
     */
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
        String sql = "SELECT id, username, password, full_name, email, phone, role, active, created_at, updated_at " +
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

    /**
     * Xác thực đăng nhập - tìm user theo email hoặc username và kiểm tra password
     * @param emailOrUsername Email hoặc username
     * @param password Mật khẩu
     * @return User nếu đăng nhập thành công, null nếu thất bại
     */
    public User login(String emailOrUsername, String password) {
        // Thử tìm theo email trước
        User user = getUserByEmail(emailOrUsername);
        
        // Nếu không tìm thấy, thử tìm theo username
        if (user == null) {
            user = getUserByUsername(emailOrUsername);
        }
        
        // Kiểm tra user có tồn tại, đang active và password đúng
        if (user != null && user.isActive() && user.getPassword() != null && user.getPassword().equals(password)) {
            // Không trả về password trong object để bảo mật
            user.setPassword(null);
            return user;
        }
        
        return null;
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

    /**
     * Map ResultSet thành User object
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setRole(rs.getString("role"));
        user.setActive(rs.getBoolean("active"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            user.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            user.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        return user;
    }
}

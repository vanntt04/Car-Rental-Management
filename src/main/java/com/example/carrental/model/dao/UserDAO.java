package com.example.carrental.model.dao;

import com.example.carrental.model.entity.User;
import com.example.carrental.model.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

<<<<<<< HEAD

=======
>>>>>>> vanntt
public class UserDAO {

    private DBConnection dbConnection;

    public UserDAO() {
        this.dbConnection = DBConnection.getInstance();
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
<<<<<<< HEAD
        // Cập nhật để match với schema thực tế: user_id, status thay vì id, active
        String sql = "SELECT user_id,username, full_name, email, password, phone, status, created_at " +
                     "FROM users ORDER BY user_id DESC";
        
        try (Connection conn = dbConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
=======

        String sql = "SELECT user_id, username, full_name, email, password, phone, status, created_at "
                + "FROM users ORDER BY user_id DESC";

        try (Connection conn = dbConnection.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {

>>>>>>> vanntt
            while (rs.next()) {
                User u = mapResultSetToUser(rs);
                try { loadUserRole(conn, u); } catch (Exception ignored) { }
                users.add(u);
            }
        } catch (SQLException e) {
            System.err.println("Error getting all users: " + e.getMessage());
            e.printStackTrace();
        }

        return users;
    }

    public User getUserById(int id) {
<<<<<<< HEAD
        // Cập nhật để match với schema thực tế: user_id
        String sql = "SELECT user_id, username, full_name, email, password, phone, status, created_at " +
                     "FROM users WHERE user_id = ?";
=======

        String sql = "SELECT user_id, username, full_name, email, password, phone, status, created_at "
                + "FROM users WHERE user_id = ?";

>>>>>>> vanntt
        User user = null;

        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                user = mapResultSetToUser(rs);
                try { loadUserRole(conn, user); } catch (Exception ignored) { }
            }

            rs.close();
        } catch (SQLException e) {
            System.err.println("Error getting user by id: " + e.getMessage());
            e.printStackTrace();
        }

        return user;
    }

<<<<<<< HEAD
    


    
    public User getUserByPhone(String phone) {
        String sql = "SELECT id, username, password, full_name, email, phone, role, active, created_at, updated_at " +
                     "FROM users WHERE phone = ?";
=======
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

>>>>>>> vanntt
        User user = null;

        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

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
<<<<<<< HEAD
        // Cập nhật để match với schema thực tế
        String sql = "SELECT user_id, full_name, email, password, phone, status, created_at " +
                     "FROM users WHERE email = ?";
=======

        String sql = "SELECT user_id, username, full_name, email, password, phone, status, created_at "
                + "FROM users WHERE email = ?";

>>>>>>> vanntt
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

<<<<<<< HEAD
    /** Lấy role từ bảng user_roles + roles theo user_id */
=======
    /**
     * Lấy role từ bảng user_roles + roles
     */
>>>>>>> vanntt
    private void loadUserRole(Connection conn, User user) {
        String sql = "SELECT r.role_name FROM user_roles ur JOIN roles r ON ur.role_id = r.role_id WHERE ur.user_id = ? LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, user.getId());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user.setRole(rs.getString("role_name"));
            }
            rs.close();
        } catch (SQLException e) {
<<<<<<< HEAD
            // Fallback: giữ role đã set trong mapResultSetToUser (từ email)
=======
            // Nếu lỗi thì giữ role mặc định từ mapResultSetToUser
>>>>>>> vanntt
        }
    }

    public User login(String emailOrUsername, String password) {
<<<<<<< HEAD
        System.out.println("UserDAO.login() called with: " + emailOrUsername);
        

        User user = getUserByEmail(emailOrUsername);
        System.out.println("User found by email: " + (user != null));
        

        
=======

        User user = getUserByEmail(emailOrUsername);

>>>>>>> vanntt
        if (user == null) {
            System.out.println("User not found in database");
            return null;
<<<<<<< HEAD
        }   
        // Kiểm tra user có tồn tại, đang active và password đúng
=======
        }
>>>>>>> vanntt
        if (!user.isActive()) {
            System.out.println("Login failed: User is not active (status != ACTIVE)");
            return null;
        }
<<<<<<< HEAD
        
=======
>>>>>>> vanntt
        if (user.getPassword() == null) {
            System.out.println("Login failed: Password is null in database");
            return null;
        }
<<<<<<< HEAD
        
        boolean passwordMatch = user.getPassword().equals(password);
        System.out.println("Password match: " + passwordMatch);
        
        if (passwordMatch) {
            // Không trả về password trong object để bảo mật
=======

        if (user.getPassword().equals(password)) {
>>>>>>> vanntt
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
<<<<<<< HEAD
        String sql = "INSERT INTO users (username, password, full_name, email, phone, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
=======

        String sql = "INSERT INTO users (username, password, full_name, email, phone, status) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

>>>>>>> vanntt
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getFullName());
            pstmt.setString(4, user.getEmail());
            pstmt.setString(5, user.getPhone());
            pstmt.setString(6, user.isActive() ? "ACTIVE" : "BLOCKED");
<<<<<<< HEAD
            
=======

>>>>>>> vanntt
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
<<<<<<< HEAD
        String sql = "UPDATE users SET username = ?, password = ?, full_name = ?, email = ?, " +
                     "phone = ?, status = ? WHERE user_id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
=======

        String sql = "UPDATE users SET username = ?, password = ?, full_name = ?, email = ?, "
                + "phone = ?, status = ? WHERE user_id = ?";

        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

>>>>>>> vanntt
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getFullName());
            pstmt.setString(4, user.getEmail());
            pstmt.setString(5, user.getPhone());
            pstmt.setString(6, user.isActive() ? "ACTIVE" : "BLOCKED");
            pstmt.setInt(7, user.getId());
<<<<<<< HEAD
            
=======

>>>>>>> vanntt
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
<<<<<<< HEAD
        String sql = "DELETE FROM users WHERE user_id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
=======

        String sql = "DELETE FROM users WHERE user_id = ?";

        try (Connection conn = dbConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

>>>>>>> vanntt
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
<<<<<<< HEAD
        
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
        
=======

        user.setId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setFullName(rs.getString("full_name"));
        user.setPhone(rs.getString("phone"));

        String status = rs.getString("status");
        user.setActive("ACTIVE".equalsIgnoreCase(status));

>>>>>>> vanntt
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            user.setCreatedAt(createdAt.toLocalDateTime());
        }

        return user;
    }
}

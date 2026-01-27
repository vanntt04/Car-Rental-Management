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
    
    public User getUserByUsername(String username) {
        return getUserByEmail(username);
    }

    public User getUserByEmail(String email) {
        // Cập nhật để match với schema thực tế
        String sql = "SELECT user_id, full_name, email, password, phone, status, created_at " +
                     "FROM users WHERE email = ?";
        User user = null;
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            
            
            
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

}
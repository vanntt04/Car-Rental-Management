package com.example.carrental.model.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Utility class để quản lý kết nối database
 * Model layer - Utilities
 */
public class DBConnection {
    private String dbUrl;
    private String dbUser;
    private String dbPassword;
    private String dbDriver;
    
    private static DBConnection instance;
    
    private DBConnection() {
        loadProperties();
        loadDriver();
    }
    
    /**
     * Load cấu hình database từ file properties
     */
    private void loadProperties() {
        Properties props = new Properties();
        InputStream input = null;
        
        try {
            // Thử load từ file properties
            input = getClass().getClassLoader().getResourceAsStream("db.properties");
            
            if (input != null) {
                props.load(input);
                dbUrl = props.getProperty("db.url");
                dbUser = props.getProperty("db.user");
                dbPassword = props.getProperty("db.password");
                dbDriver = props.getProperty("db.driver");
            } else {
                // Nếu không có file properties, dùng giá trị mặc định
                System.out.println("Warning: db.properties not found, using default values");
                setDefaultValues();
            }
        } catch (Exception e) {
            System.err.println("Error loading db.properties: " + e.getMessage());
            System.out.println("Using default database configuration");
            setDefaultValues();
        } finally {
            if (input != null) {
                try {
                    input.close();
                } catch (Exception e) {
                    // Ignore
                }
            }
        }
        
        // Nếu password rỗng trong properties, dùng giá trị mặc định
        if (dbPassword == null || dbPassword.trim().isEmpty()) {
            System.out.println("Warning: Password is empty in db.properties, using default");
            dbPassword = "vanh"; // Default password
        }
        
        // Kiểm tra và override bằng environment variables nếu có
        String envUrl = System.getenv("DB_URL");
        String envUser = System.getenv("DB_USER");
        String envPassword = System.getenv("DB_PASSWORD");
        
        if (envUrl != null && !envUrl.isEmpty()) {
            dbUrl = envUrl;
        }
        if (envUser != null && !envUser.isEmpty()) {
            dbUser = envUser;
        }
        if (envPassword != null && !envPassword.isEmpty()) {
            dbPassword = envPassword;
        }
        
        // Log cấu hình (không log password)
        System.out.println("Database Configuration:");
        System.out.println("  URL: " + dbUrl);
        System.out.println("  User: " + dbUser);
        System.out.println("  Driver: " + dbDriver);
    }
    
    /**
     * Set giá trị mặc định
     */
    private void setDefaultValues() {
        dbUrl = "jdbc:mysql://localhost:3306/car_rental_db?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8&allowPublicKeyRetrieval=true";
        dbUser = "root";
        dbPassword = "vanh"; 
        dbDriver = "com.mysql.cj.jdbc.Driver";
    }
    
    /**
     * Load JDBC Driver
     */
    private void loadDriver() {
        try {
            Class.forName(dbDriver);
            System.out.println("MySQL JDBC Driver loaded successfully");
        } catch (ClassNotFoundException e) {
            System.err.println("ERROR: MySQL JDBC Driver not found!");
            System.err.println("Please check if mysql-connector-j is in your classpath");
            throw new RuntimeException("MySQL JDBC Driver not found: " + e.getMessage(), e);
        }
    }
    
    public static DBConnection getInstance() {
        if (instance == null) {
            synchronized (DBConnection.class) {
                if (instance == null) {
                    instance = new DBConnection();
                }
            }
        }
        return instance;
    }
    
    /**
     * Lấy kết nối database
     * @return Connection object
     * @throws SQLException nếu không thể kết nối
     */
    public Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            System.out.println("Database connection established successfully");
            return conn;
        } catch (SQLException e) {
            System.err.println("ERROR: Cannot connect to database!");
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
            System.err.println("\nPlease check:");
            System.err.println("  1. MySQL server is running");
            System.err.println("  2. Database 'car_rental_db' exists");
            System.err.println("  3. Username and password are correct");
            System.err.println("  4. Database URL is correct: " + dbUrl);
            throw e;
        }
    }
    
    /**
     * Test kết nối database
     * @return true nếu kết nối thành công
     */
    public boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            return false;
        }
    }
    
    public void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                System.out.println("Database connection closed");
            } catch (SQLException e) {
                System.err.println("Error closing connection: " + e.getMessage());
            }
        }
    }
    
    // Getters để debug
    public String getDbUrl() {
        return dbUrl;
    }
    
    public String getDbUser() {
        return dbUser;
    }
}

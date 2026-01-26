package com.example.carrental.controller;

import com.example.carrental.model.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Servlet để test kết nối database
 * Chỉ dùng cho mục đích debug
 */
@WebServlet(name = "TestDBServlet", urlPatterns = "/test-db")
public class TestDBServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<title>Database Connection Test</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 20px; }");
        out.println(".success { color: green; padding: 10px; background: #e8f5e9; border-radius: 5px; }");
        out.println(".error { color: red; padding: 10px; background: #ffebee; border-radius: 5px; }");
        out.println(".info { padding: 10px; background: #e3f2fd; border-radius: 5px; margin: 10px 0; }");
        out.println("pre { background: #f5f5f5; padding: 10px; border-radius: 5px; overflow-x: auto; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1>Database Connection Test</h1>");
        
        DBConnection dbConnection = DBConnection.getInstance();
        
        // Hiển thị cấu hình
        out.println("<div class='info'>");
        out.println("<h3>Database Configuration:</h3>");
        out.println("<p><strong>URL:</strong> " + dbConnection.getDbUrl() + "</p>");
        out.println("<p><strong>User:</strong> " + dbConnection.getDbUser() + "</p>");
        out.println("</div>");
        
        // Test kết nối
        try {
            Connection conn = dbConnection.getConnection();
            
            if (conn != null && !conn.isClosed()) {
                out.println("<div class='success'>");
                out.println("<h3>✓ Connection Successful!</h3>");
                out.println("</div>");
                
                // Lấy thông tin database
                DatabaseMetaData metaData = conn.getMetaData();
                out.println("<div class='info'>");
                out.println("<h3>Database Information:</h3>");
                out.println("<p><strong>Database Product:</strong> " + metaData.getDatabaseProductName() + "</p>");
                out.println("<p><strong>Database Version:</strong> " + metaData.getDatabaseProductVersion() + "</p>");
                out.println("<p><strong>Driver Name:</strong> " + metaData.getDriverName() + "</p>");
                out.println("<p><strong>Driver Version:</strong> " + metaData.getDriverVersion() + "</p>");
                out.println("<p><strong>URL:</strong> " + metaData.getURL() + "</p>");
                out.println("</div>");
                
                // Kiểm tra các bảng
                out.println("<div class='info'>");
                out.println("<h3>Tables in Database:</h3>");
                ResultSet tables = metaData.getTables(null, null, "%", new String[]{"TABLE"});
                boolean hasTables = false;
                out.println("<ul>");
                while (tables.next()) {
                    hasTables = true;
                    String tableName = tables.getString("TABLE_NAME");
                    out.println("<li>" + tableName + "</li>");
                }
                if (!hasTables) {
                    out.println("<li style='color: orange;'>No tables found. Please run schema.sql to create tables.</li>");
                }
                out.println("</ul>");
                out.println("</div>");
                
                // Test query đơn giản
                try {
                    ResultSet rs = conn.createStatement().executeQuery("SELECT COUNT(*) as count FROM users");
                    if (rs.next()) {
                        int userCount = rs.getInt("count");
                        out.println("<div class='info'>");
                        out.println("<h3>Test Query:</h3>");
                        out.println("<p>Number of users in database: <strong>" + userCount + "</strong></p>");
                        out.println("</div>");
                    }
                    rs.close();
                } catch (SQLException e) {
                    out.println("<div class='error'>");
                    out.println("<h3>Query Test Failed:</h3>");
                    out.println("<p>" + e.getMessage() + "</p>");
                    out.println("<p>This might mean the tables don't exist. Please run schema.sql</p>");
                    out.println("</div>");
                }
                
                conn.close();
            }
            
        } catch (SQLException e) {
            out.println("<div class='error'>");
            out.println("<h3>✗ Connection Failed!</h3>");
            out.println("<p><strong>Error:</strong> " + e.getMessage() + "</p>");
            out.println("<p><strong>SQL State:</strong> " + e.getSQLState() + "</p>");
            out.println("<p><strong>Error Code:</strong> " + e.getErrorCode() + "</p>");
            out.println("</div>");
            
            out.println("<div class='info'>");
            out.println("<h3>Troubleshooting Steps:</h3>");
            out.println("<ol>");
            out.println("<li>Check if MySQL server is running</li>");
            out.println("<li>Verify database 'car_rental_db' exists</li>");
            out.println("<li>Check username and password in db.properties</li>");
            out.println("<li>Verify MySQL port (default: 3306)</li>");
            out.println("<li>Run schema.sql to create database and tables</li>");
            out.println("</ol>");
            out.println("</div>");
            
            out.println("<div class='info'>");
            out.println("<h3>How to fix:</h3>");
            out.println("<pre>");
            out.println("1. Edit: src/main/resources/db.properties");
            out.println("2. Update db.url, db.user, db.password");
            out.println("3. Or set environment variables:");
            out.println("   - DB_URL");
            out.println("   - DB_USER");
            out.println("   - DB_PASSWORD");
            out.println("</pre>");
            out.println("</div>");
        }
        
        out.println("<p><a href='" + request.getContextPath() + "/home'>← Back to Home</a></p>");
        out.println("</body>");
        out.println("</html>");
    }
}

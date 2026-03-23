package com.example.carrental.listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * Ghi log khi context khởi động/dừng. Giúp debug "context failed to start".
 */
@WebListener
public class StartupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("[CarRental] Context đang khởi động...");
        try {
            // Test DB connection khi start (không throw - chỉ log)
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("[CarRental] MySQL driver OK");
        } catch (ClassNotFoundException e) {
            System.err.println("[CarRental] CẢNH BÁO: MySQL driver không tìm thấy. Kiểm tra mysql-connector-j trong pom.xml");
        }
        System.out.println("[CarRental] Context khởi động thành công.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[CarRental] Context đã dừng.");
    }
}

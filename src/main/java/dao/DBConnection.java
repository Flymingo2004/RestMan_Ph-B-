package com.restman.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Thông tin kết nối MySQL
    private static final String URL = "jdbc:mysql://localhost:3306/restman?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "ptit2004"; // ⚠️ THAY ĐỔI PASSWORD CỦA BẠN

    // Load MySQL Driver
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✅ MySQL Driver loaded successfully!");
        } catch (ClassNotFoundException e) {
            System.err.println("❌ MySQL Driver not found!");
            e.printStackTrace();
            throw new RuntimeException("MySQL Driver not found", e);
        }
    }

    /**
     * Tạo kết nối mới đến database
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            System.out.println("✅ Connected to database successfully!");
            return conn;
        } catch (SQLException e) {
            System.err.println("❌ Failed to connect to database!");
            System.err.println("URL: " + URL);
            System.err.println("Username: " + USERNAME);
            throw e;
        }
    }

    /**
     * Đóng kết nối
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                System.out.println("✅ Connection closed successfully!");
            } catch (SQLException e) {
                System.err.println("❌ Failed to close connection!");
                e.printStackTrace();
            }
        }
    }

    /**
     * Test kết nối database
     */
    public static void main(String[] args) {
        try {
            Connection conn = getConnection();
            System.out.println("🎉 Database connection test successful!");
            closeConnection(conn);
        } catch (SQLException e) {
            System.err.println("❌ Database connection test failed!");
            e.printStackTrace();
        }
    }
}
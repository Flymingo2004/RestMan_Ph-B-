package com.restman.dao;

import com.restman.model.User;
import java.sql.*;

public class UserDAO {

    /**
     * Xác thực đăng nhập
     */
    public User validateUser(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        User user = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            stmt.setString(2, password);

            System.out.println("🔍 Validating user: " + username);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setFullName(rs.getString("full_name"));
                user.setRole(rs.getString("role"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setUpdatedAt(rs.getTimestamp("updated_at"));

                System.out.println("✅ User validated: " + user.getFullName() + " - Role: " + user.getRole());
            } else {
                System.out.println("❌ Invalid username or password!");
            }

            rs.close();

        } catch (SQLException e) {
            System.err.println("❌ Error validating user!");
            e.printStackTrace();
        }

        return user;
    }

    /**
     * Lấy thông tin user theo ID
     */
    public User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE id = ?";
        User user = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setFullName(rs.getString("full_name"));
                user.setRole(rs.getString("role"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setUpdatedAt(rs.getTimestamp("updated_at"));
            }

            rs.close();

        } catch (SQLException e) {
            System.err.println("❌ Error getting user by ID!");
            e.printStackTrace();
        }

        return user;
    }
}
package com.restman.dao;

import com.restman.model.MenuFood;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MenuFoodDAO {

    /**
     * Tìm kiếm món ăn theo tên
     */
    public List<MenuFood> searchFoodByName(String keyword) {
        String sql = "SELECT * FROM menu_food WHERE name LIKE ? AND is_available = TRUE ORDER BY type, name";
        List<MenuFood> foodList = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, "%" + keyword + "%");

            System.out.println("🔍 Searching food with keyword: " + keyword);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                foodList.add(extractMenuFood(rs));
            }

            System.out.println("✅ Found " + foodList.size() + " food items");
            rs.close();

        } catch (SQLException e) {
            System.err.println("❌ Error searching food!");
            e.printStackTrace();
        }

        return foodList;
    }

    /**
     * Lấy tất cả món ăn
     */
    public List<MenuFood> getAllFood() {
        String sql = "SELECT * FROM menu_food WHERE is_available = TRUE ORDER BY type, name";
        List<MenuFood> foodList = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            System.out.println("🔍 Getting all food items");

            while (rs.next()) {
                foodList.add(extractMenuFood(rs));
            }

            System.out.println("✅ Retrieved " + foodList.size() + " food items");

        } catch (SQLException e) {
            System.err.println("❌ Error getting all food!");
            e.printStackTrace();
        }

        return foodList;
    }

    /**
     * Lấy thông tin chi tiết món ăn theo ID
     */
    public MenuFood getFoodById(int id) {
        String sql = "SELECT * FROM menu_food WHERE id = ? AND is_available = TRUE";
        MenuFood food = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            System.out.println("🔍 Getting food by ID: " + id);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                food = extractMenuFood(rs);
                System.out.println("✅ Found food: " + food.getName());
            } else {
                System.out.println("❌ Food not found with ID: " + id);
            }

            rs.close();

        } catch (SQLException e) {
            System.err.println("❌ Error getting food by ID!");
            e.printStackTrace();
        }

        return food;
    }

    /**
     * Helper method để extract MenuFood từ ResultSet
     */
    private MenuFood extractMenuFood(ResultSet rs) throws SQLException {
        MenuFood food = new MenuFood();
        food.setId(rs.getInt("id"));
        food.setName(rs.getString("name"));
        food.setPrice(rs.getDouble("price"));
        food.setDescription(rs.getString("description"));
        food.setIngredients(rs.getString("ingredients"));
        food.setType(rs.getString("type"));
        food.setImageUrl(rs.getString("image_url"));
        food.setAvailable(rs.getBoolean("is_available"));
        food.setCreatedAt(rs.getTimestamp("created_at"));
        food.setUpdatedAt(rs.getTimestamp("updated_at"));
        return food;
    }
}
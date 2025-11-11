package com.restman.dao;

import com.restman.model.Table;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TableDAO {

    /**
     * Tìm bàn theo tên khách hàng
     */
    public List<Table> searchTableByCustomerName(String customerName) {
        String sql = "SELECT * FROM tables WHERE customer_name LIKE ? AND status = 'occupied' ORDER BY table_number";
        List<Table> tables = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, "%" + customerName + "%");

            System.out.println("🔍 Searching tables for customer: " + customerName);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                tables.add(extractTable(rs));
            }

            System.out.println("✅ Found " + tables.size() + " tables");
            rs.close();

        } catch (SQLException e) {
            System.err.println("❌ Error searching tables!");
            e.printStackTrace();
        }

        return tables;
    }

    /**
     * Lấy thông tin bàn theo ID
     */
    public Table getTableById(int id) {
        String sql = "SELECT * FROM tables WHERE id = ?";
        Table table = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            System.out.println("🔍 Getting table by ID: " + id);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                table = extractTable(rs);
                System.out.println("✅ Found table: " + table.getTableNumber());
            } else {
                System.out.println("❌ Table not found with ID: " + id);
            }

            rs.close();

        } catch (SQLException e) {
            System.err.println("❌ Error getting table by ID!");
            e.printStackTrace();
        }

        return table;
    }

    /**
     * Cập nhật trạng thái bàn
     */
    public boolean updateTableStatus(int tableId, String status) {
        String sql = "UPDATE tables SET status = ?, customer_name = NULL WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, tableId);

            System.out.println("🔄 Updating table " + tableId + " to status: " + status);

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                System.out.println("✅ Table status updated successfully!");
                return true;
            } else {
                System.out.println("❌ Failed to update table status!");
                return false;
            }

        } catch (SQLException e) {
            System.err.println("❌ Error updating table status!");
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Helper method để extract Table từ ResultSet
     */
    private Table extractTable(ResultSet rs) throws SQLException {
        Table table = new Table();
        table.setId(rs.getInt("id"));
        table.setTableNumber(rs.getString("table_number"));
        table.setCustomerName(rs.getString("customer_name"));
        table.setSeatCapacity(rs.getInt("seat_capacity"));
        table.setStatus(rs.getString("status"));
        table.setCreatedAt(rs.getTimestamp("created_at"));
        table.setUpdatedAt(rs.getTimestamp("updated_at"));
        return table;
    }
}
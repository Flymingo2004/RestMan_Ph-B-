package com.restman.dao;

import com.restman.model.Receipt;
import com.restman.model.ReceiptDetail;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReceiptDAO {

    /**
     * Lấy hóa đơn chưa thanh toán của bàn
     */
    public Receipt getPendingReceiptByTableId(int tableId) {
        String sql = "SELECT r.*, t.table_number, t.customer_name, u.full_name as staff_name " +
                "FROM receipts r " +
                "JOIN tables t ON r.table_id = t.id " +
                "JOIN users u ON r.staff_id = u.id " +
                "WHERE r.table_id = ? AND r.status = 'pending'";
        Receipt receipt = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, tableId);

            System.out.println("🔍 Getting pending receipt for table ID: " + tableId);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                receipt = extractReceipt(rs);
                System.out.println("✅ Found receipt ID: " + receipt.getId());
            } else {
                System.out.println("❌ No pending receipt found for table ID: " + tableId);
            }

            rs.close();

        } catch (SQLException e) {
            System.err.println("❌ Error getting pending receipt!");
            e.printStackTrace();
        }

        return receipt;
    }

    /**
     * Lấy chi tiết món ăn trong hóa đơn
     */
    public List<ReceiptDetail> getReceiptDetails(int receiptId) {
        String sql = "SELECT rd.*, mf.name as food_name, mf.type as food_type " +
                "FROM receipt_details rd " +
                "JOIN menu_food mf ON rd.food_id = mf.id " +
                "WHERE rd.receipt_id = ?";
        List<ReceiptDetail> details = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, receiptId);

            System.out.println("🔍 Getting details for receipt ID: " + receiptId);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                details.add(extractReceiptDetail(rs));
            }

            System.out.println("✅ Retrieved " + details.size() + " receipt details");
            rs.close();

        } catch (SQLException e) {
            System.err.println("❌ Error getting receipt details!");
            e.printStackTrace();
        }

        return details;
    }

    /**
     * Cập nhật trạng thái hóa đơn thành đã thanh toán
     */
    public boolean updateReceiptToPaid(int receiptId, String paymentMethod) {
        String sql = "UPDATE receipts SET status = 'paid', payment_method = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, paymentMethod);
            stmt.setInt(2, receiptId);

            System.out.println("🔄 Updating receipt " + receiptId + " to paid with method: " + paymentMethod);

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                System.out.println("✅ Receipt updated to paid successfully!");
                return true;
            } else {
                System.out.println("❌ Failed to update receipt!");
                return false;
            }

        } catch (SQLException e) {
            System.err.println("❌ Error updating receipt!");
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Helper method để extract Receipt từ ResultSet
     */
    private Receipt extractReceipt(ResultSet rs) throws SQLException {
        Receipt receipt = new Receipt();
        receipt.setId(rs.getInt("id"));
        receipt.setTableId(rs.getInt("table_id"));
        receipt.setTableNumber(rs.getString("table_number"));
        receipt.setCustomerName(rs.getString("customer_name"));

        // customerId có thể null
        int customerId = rs.getInt("customer_id");
        if (!rs.wasNull()) {
            receipt.setCustomerId(customerId);
        }

        receipt.setStaffId(rs.getInt("staff_id"));
        receipt.setStaffName(rs.getString("staff_name"));
        receipt.setReceiptDate(rs.getTimestamp("receipt_date"));
        receipt.setTotalAmount(rs.getDouble("total_amount"));
        receipt.setDiscountAmount(rs.getDouble("discount_amount"));
        receipt.setFinalAmount(rs.getDouble("final_amount"));
        receipt.setStatus(rs.getString("status"));
        receipt.setPaymentMethod(rs.getString("payment_method"));
        receipt.setNotes(rs.getString("notes"));
        receipt.setCreatedAt(rs.getTimestamp("created_at"));
        return receipt;
    }

    /**
     * Helper method để extract ReceiptDetail từ ResultSet
     */
    private ReceiptDetail extractReceiptDetail(ResultSet rs) throws SQLException {
        ReceiptDetail detail = new ReceiptDetail();
        detail.setId(rs.getInt("id"));
        detail.setReceiptId(rs.getInt("receipt_id"));
        detail.setFoodId(rs.getInt("food_id"));
        detail.setFoodName(rs.getString("food_name"));
        detail.setFoodType(rs.getString("food_type"));
        detail.setQuantity(rs.getInt("quantity"));
        detail.setUnitPrice(rs.getDouble("unit_price"));
        detail.setTotalPrice(rs.getDouble("total_price"));
        detail.setNotes(rs.getString("notes"));
        return detail;
    }
}
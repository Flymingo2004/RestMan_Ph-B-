package com.restman.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Receipt implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int tableId;
    private String tableNumber;
    private String customerName;
    private Integer customerId;
    private int staffId;
    private String staffName;
    private Timestamp receiptDate;
    private double totalAmount;
    private double discountAmount;
    private double finalAmount;
    private String status;
    private String paymentMethod;
    private String notes;
    private Timestamp createdAt;

    // Constructor mặc định
    public Receipt() {
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getTableId() {
        return tableId;
    }

    public void setTableId(int tableId) {
        this.tableId = tableId;
    }

    public String getTableNumber() {
        return tableNumber;
    }

    public void setTableNumber(String tableNumber) {
        this.tableNumber = tableNumber;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public Timestamp getReceiptDate() {
        return receiptDate;
    }

    public void setReceiptDate(Timestamp receiptDate) {
        this.receiptDate = receiptDate;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public double getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(double discountAmount) {
        this.discountAmount = discountAmount;
    }

    public double getFinalAmount() {
        return finalAmount;
    }

    public void setFinalAmount(double finalAmount) {
        this.finalAmount = finalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // Helper methods để format giá tiền
    public String getFormattedTotalAmount() {
        return String.format("%,.0f đ", totalAmount);
    }

    public String getFormattedDiscountAmount() {
        return String.format("%,.0f đ", discountAmount);
    }

    public String getFormattedFinalAmount() {
        return String.format("%,.0f đ", finalAmount);
    }

    @Override
    public String toString() {
        return "Receipt{" +
                "id=" + id +
                ", tableNumber='" + tableNumber + '\'' +
                ", finalAmount=" + finalAmount +
                ", status='" + status + '\'' +
                '}';
    }
}
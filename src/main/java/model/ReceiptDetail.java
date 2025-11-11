package com.restman.model;

import java.io.Serializable;

public class ReceiptDetail implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int receiptId;
    private int foodId;
    private String foodName;
    private String foodType;
    private int quantity;
    private double unitPrice;
    private double totalPrice;
    private String notes;

    // Constructor mặc định
    public ReceiptDetail() {
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getReceiptId() {
        return receiptId;
    }

    public void setReceiptId(int receiptId) {
        this.receiptId = receiptId;
    }

    public int getFoodId() {
        return foodId;
    }

    public void setFoodId(int foodId) {
        this.foodId = foodId;
    }

    public String getFoodName() {
        return foodName;
    }

    public void setFoodName(String foodName) {
        this.foodName = foodName;
    }

    public String getFoodType() {
        return foodType;
    }

    public void setFoodType(String foodType) {
        this.foodType = foodType;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    // Helper methods để format giá tiền
    public String getFormattedUnitPrice() {
        return String.format("%,.0f đ", unitPrice);
    }

    public String getFormattedTotalPrice() {
        return String.format("%,.0f đ", totalPrice);
    }

    @Override
    public String toString() {
        return "ReceiptDetail{" +
                "id=" + id +
                ", foodName='" + foodName + '\'' +
                ", quantity=" + quantity +
                ", totalPrice=" + totalPrice +
                '}';
    }
}
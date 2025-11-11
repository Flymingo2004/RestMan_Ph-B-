package com.restman.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Table implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String tableNumber;
    private String customerName;
    private int seatCapacity;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Constructor mặc định
    public Table() {
    }

    // Constructor đầy đủ
    public Table(int id, String tableNumber, String customerName,
                 int seatCapacity, String status) {
        this.id = id;
        this.tableNumber = tableNumber;
        this.customerName = customerName;
        this.seatCapacity = seatCapacity;
        this.status = status;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public int getSeatCapacity() {
        return seatCapacity;
    }

    public void setSeatCapacity(int seatCapacity) {
        this.seatCapacity = seatCapacity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "Table{" +
                "id=" + id +
                ", tableNumber='" + tableNumber + '\'' +
                ", customerName='" + customerName + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
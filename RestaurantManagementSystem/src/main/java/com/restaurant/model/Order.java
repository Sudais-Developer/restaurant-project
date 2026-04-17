package com.restaurant.model;

public class Order implements java.io.Serializable{
    private int orderId;
    private String customerName;
    private String dishName;
    private String tableNumber;
    private int quantity;
    private double totalPrice;
    private String status;
    private String waiterName; // Dashboard logs ke liye

    // Constructor
    public Order(int orderId, String customerName, String dishName, String tableNumber, int quantity, double totalPrice) {
        this.orderId = orderId;
        this.customerName = customerName;
        this.dishName = dishName;
        this.tableNumber = tableNumber;
        this.quantity = quantity;
        this.totalPrice = totalPrice;
        this.status = "Pending"; // Default status
        this.waiterName = "Not Assigned"; // Default value
    }
    
    // --- Getters and Setters ---

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getDishName() { return dishName; }
    public void setDishName(String dishName) { this.dishName = dishName; }

    public String getTableNumber() { return tableNumber; }
    public void setTableNumber(String tableNumber) { this.tableNumber = tableNumber; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getWaiterName() { return waiterName; }
    public void setWaiterName(String waiterName) { this.waiterName = waiterName; }
}
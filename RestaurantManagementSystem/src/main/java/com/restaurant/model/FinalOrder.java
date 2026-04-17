package com.restaurant.model;
import java.util.List;

public class FinalOrder {
    public String customerName;
    public String phone;
    public List<OrderItem> items;
    public double totalAmount;

    public FinalOrder(String name, String phone, List<OrderItem> items, double total) {
        this.customerName = name;
        this.phone = phone;
        this.items = items;
        this.totalAmount = total;
    }
}
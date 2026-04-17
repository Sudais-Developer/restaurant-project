package com.restaurant.model;

import java.io.Serializable;

public class OrderItem implements Serializable {
    // Fields ko private rakhna best practice hai (Encapsulation)
    private String name;
    private double price;
    private int quantity;

    // Default Constructor (Frameworks ke liye zaroori hota hai)
    public OrderItem() {}

    // Parameterized Constructor
    public OrderItem(String name, double price, int quantity) {
        this.name = name;
        this.price = price;
        this.quantity = quantity;
    }

    // --- Business Logic Method ---
    // JSP mein total calculation ke liye: <%= item.getTotalPrice() %>
    public double getTotalPrice() {
        return this.price * this.quantity;
    }

    // --- Getters and Setters ---
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}
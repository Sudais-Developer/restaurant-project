package com.restaurant.model;
public class MenuItem implements java.io.Serializable {
    private int id;
    private String itemName;
    private String price;
    private String description;
    private String session;

    // Constructor
    public MenuItem(int id, String itemName, String price, String description, String session) {
        this.id = id;
        this.itemName = itemName;
        this.price = price;
        this.description = description;
        this.session = session;
    }

    // --- GETTERS ---
    public int getId() { return id; }
    public String getItemName() { return itemName; }
    public String getPrice() { return price; }
    public String getSession() { return session; }
    public String getDescription() { return description; }

    // --- SETTERS ---
    public void setItemName(String itemName) { this.itemName = itemName; }
    public void setPrice(String price) { this.price = price; }
    public void setSession(String session) { this.session = session; }
    public void setDescription(String description) { this.description = description; }
}
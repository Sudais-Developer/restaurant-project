package com.restaurant.model;

public class Menu {
    private int id;
    private String itemName;
    private String price;
    private String description;
    private String session;

    public Menu(int id, String itemName, String price, String description, String session) {
        this.id = id;
        this.itemName = itemName;
        this.price = price;
        this.description = description;
        this.session = session;
    }

    // Getters and Setters
    public int getId() { return id; }
    public String getItemName() { return itemName; }
    public String getPrice() { return price; }
    public String getDescription() { return description; }
    public String getSession() { return session; }

    public void setItemName(String n) { this.itemName = n; }
    public void setPrice(String p) { this.price = p; }
    public void setDescription(String d) { this.description = d; }
    public void setSession(String s) { this.session = s; }
}
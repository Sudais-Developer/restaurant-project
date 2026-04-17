package com.restaurant.model;

public class Table implements java.io.Serializable{
    private int tableId;
    private String tableName;
    private int capacity;

    public Table() {}

    public Table(int id, String name, int cap) {
        this.tableId = id;
        this.tableName = name;
        this.capacity = cap;
    }

    // Getters
    public int getTableId() { return tableId; } 
    public String getTableName() { return tableName; } 
    public int getCapacity() { return capacity; } 

    // Setters (Zaroori for UpdateTableServlet)
    public void setTableId(int id) { this.tableId = id; }
    public void setTableName(String name) { this.tableName = name; }
    public void setCapacity(int cap) { this.capacity = cap; }
}
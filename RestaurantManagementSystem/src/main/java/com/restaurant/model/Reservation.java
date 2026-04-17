package com.restaurant.model;

public class Reservation {
    public String name, phone, tableNo;
    public Reservation(String n, String p, String t) {
        this.name = n; this.phone = p; this.tableNo = t;
    }
}
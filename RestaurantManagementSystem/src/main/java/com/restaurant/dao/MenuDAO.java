package com.restaurant.dao;

import com.restaurant.model.MenuItem;
import java.util.ArrayList;
import java.util.List;

public class MenuDAO {
    private List<MenuItem> menuItems = new ArrayList<>();

    public void addItem(MenuItem item) {
        if (item != null) {
            menuItems.add(item);
        }
    }

    public List<MenuItem> getAllMenuItems() {
        return new ArrayList<>(menuItems);
    }

    // Naam se price dhoondne ke liye
    public double getPriceByName(String name) {
        for (MenuItem item : menuItems) {
            // 🛑 FIXED LINE 25: Matching the method in MenuItem.java
            if (item.getItemName().equalsIgnoreCase(name)) {
                return Double.parseDouble(item.getPrice());
            }
        }
        return 0.0;
    }
}
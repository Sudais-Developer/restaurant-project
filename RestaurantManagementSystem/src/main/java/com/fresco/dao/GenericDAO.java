package com.fresco.dao;

import java.util.ArrayList;
import java.util.List;
import com.restaurant.model.MenuItem;

public class GenericDAO<T> {
    private List<T> list = new ArrayList<>();

    public void add(T item) {
        if (item != null) {
            list.add(item);
        }
    }

    public List<T> getAll() {
        return new ArrayList<>(this.list);
    }

    public void update(int id, T updatedItem) {
        for (int i = 0; i < list.size(); i++) {
            T current = list.get(i);
            if (current instanceof MenuItem) {
                if (((MenuItem) current).getId() == id) {
                    list.set(i, updatedItem); // Original list update ho rahi hai
                    return;
                }
            }
        }
    }
 // GenericDAO.java ke andar ye method add karein
    public void deleteById(int id) {
        java.util.Iterator<T> iterator = list.iterator();
        while (iterator.hasNext()) {
            T current = iterator.next();
            if (current instanceof MenuItem) {
                if (((MenuItem) current).getId() == id) {
                    iterator.remove(); // Asli list se item delete ho jayega
                    return;
                }
            }
        }
    }
}
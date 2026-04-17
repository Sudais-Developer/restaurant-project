package com.fresco.dao;

import com.restaurant.model.Order;
import java.util.*;

public class KitchenManager {
    private static List<Order> pendingOrders = new ArrayList<>();
    private static Stack<Order> readyStack = new Stack<>();

    public static void addOrder(Order order) {
        if (order != null) pendingOrders.add(order);
    }

    public static int pendingOrdersCount() {
        return pendingOrders.size();
    }

    public static Stack<Order> getReadyStack() {
        return readyStack;
    }

    public static List<Order> getPendingOrdersList() {
        return pendingOrders;
    }

    public static void markSpecificOrderReady(int id) {
        Iterator<Order> iterator = pendingOrders.iterator();
        while (iterator.hasNext()) {
            Order o = iterator.next();
            if (o.getOrderId() == id) {
                o.setStatus("Ready");
                readyStack.push(o);
                iterator.remove();
                break;
            }
        }
    }

    public static void markAsServed(int id) {
        // Find order in stack and update status to "Served"
        for (Order o : readyStack) {
            if (o.getOrderId() == id) {
                o.setStatus("Served");
                break;
            }
        }
    }
 // KitchenManager.java mein ye add karein
    public static List<Order> getCompletedOrders() {
        List<Order> completed = new ArrayList<>();
        // readyStack humne pehle define kiya tha
        if (readyStack != null) {
            for (Order o : readyStack) {
                if ("Served".equals(o.getStatus())) {
                    completed.add(o);
                }
            }
        }
        return completed;
    }
}
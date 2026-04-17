package com.fresco.dao;

import java.io.*;
import java.util.*; // Yeh line List aur ArrayList ke liye zaroori hai

public class FileDAO {
    private static final String FILE_NAME = "orders.txt";

    public synchronized void saveOrder(String orderId, String customerName, String phone, String items, double total) {
        try (PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(FILE_NAME, true)))) {
            // Humne OrderId bhi add kar di hai taake delete karne mein aasani ho
            out.println(orderId + "|" + customerName + "|" + phone + "|" + items + "|" + total);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Sab orders ko fetch karne ke liye (Ab yeh logic complete hai)
    public List<String[]> getAllOrders() {
        List<String[]> orders = new ArrayList<>();
        File file = new File(FILE_NAME);
        if (!file.exists()) return orders;

        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                orders.add(line.split("\\|")); // "|" ke zariye split karein
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return orders;
    }

    // DELETE karne ke liye mukammal logic
    public void deleteOrder(String id) {
        List<String[]> allOrders = getAllOrders();
        try (PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(FILE_NAME)))) {
            for (String[] row : allOrders) {
                // Agar ID match nahi karti, toh hi wapis file mein likhein
                if (!row[0].trim().equals(id.trim())) {
                    out.println(String.join("|", row));
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
package com.fresco.dao;

import com.restaurant.model.*;
import java.io.*;
import java.util.*;

public class StaffManager {
    private static List<MenuItem> menuList = new ArrayList<>();
    private static List<Table> tableList = new ArrayList<>();
    private static List<Chef> chefs = new ArrayList<>();
    private static List<Waiter> waiters = new ArrayList<>();
    private static Stack<Order> orderLogs = new Stack<>(); 
    private static Map<String, String> staffPasswords = new HashMap<>();

    private static final String FILE_NAME = "restaurant_data.dat";

    static {
        loadData();
        // Default Staff agar list khali hai
        if (waiters.isEmpty() && chefs.isEmpty()) {
            addWaiter(new Waiter(101, "sudais", "ali@fresco.com", 3), "sudais123");
            addChef(new Chef(201, "zukhruf", "ramzan@fresco.com", "Italian"), "zukhruf123");
        }
        
        if (menuList.isEmpty()) {
            addMenuItem(new MenuItem(1, "Velvet Beetroot Carpaccio", "1450", "Roasted beets with feta mousse", "Appetizer"));
            addMenuItem(new MenuItem(2, "Indigo Sea Scallops", "3100", "Pan-seared with cauliflower purée", "Appetizer"));
            addMenuItem(new MenuItem(3, "Truffle-Glazed Arancini", "1800", "Crispy rice balls with mozzarella", "Appetizer"));
            addMenuItem(new MenuItem(4, "Artisanal Burrata Bloom", "2600", "Burrata in crispy filo pastry", "Appetizer"));
            addMenuItem(new MenuItem(5, "Smoked Anardana Paneer", "1550", "Cottage cheese with pomegranate", "Starter"));
            addMenuItem(new MenuItem(6, "Charcoal Wagyu Sliders", "4900", "Mini wagyu patties with onion jam", "Starter"));
            addMenuItem(new MenuItem(7, "Saffron Tiger Prawns", "3400", "Jumbo prawns with Persian saffron", "Starter"));
            addMenuItem(new MenuItem(8, "Duck Confit Tartlets", "2950", "Duck leg with plum sauce", "Starter"));
            addMenuItem(new MenuItem(9, "Braised Short Ribs", "5800", "48-hour slow-cooked beef ribs", "Main Course"));
            addMenuItem(new MenuItem(10, "Wild Morel Risotto", "3600", "Rice with Himalayan Guchhi mushrooms", "Main Course"));
            addMenuItem(new MenuItem(11, "Pistachio Crusted Salmon", "4200", "Salmon with saffron foam", "Main Course"));
            addMenuItem(new MenuItem(12, "Kashmiri Rogan-Josh Shank", "4600", "Lamb shank in aromatic gravy", "Main Course"));
            addMenuItem(new MenuItem(13, "The Sapphire Fizz", "950", "Butterfly pea flower fizz", "Drinks"));
            addMenuItem(new MenuItem(14, "Smoked Cinnamon drink", "1200", "Applewood smoked spiced drink", "Drinks"));
            addMenuItem(new MenuItem(15, "Hibiscus Rose Sparkler", "850", "Tea with rose-water fizz", "Drinks"));
            addMenuItem(new MenuItem(16, "Golden Mango Lassi", "1100", "Mango pulp with green cardamom", "Drinks"));
        }

        if (tableList.isEmpty()) {
            addTable(new Table(1, "The Orchid Nook", 2));
            addTable(new Table(2, "Starlight Alcove", 2));
            addTable(new Table(3, "Urban Square", 4));
            addTable(new Table(4, "Metro Quadrant", 4));
            addTable(new Table(5, "Saffron Sanctuary", 6));
            addTable(new Table(6, "Cedar Hideaway", 6));
            addTable(new Table(7, "The Octave Round", 8));
            addTable(new Table(8, "Infinity Circle", 8));
            addTable(new Table(9, "Dynasty Lounge", 10));
            addTable(new Table(10, "Heritage Hall", 10));
            addTable(new Table(11, "Majestic Long-Table", 12));
            addTable(new Table(12, "Empire Grand-Suite", 12));
        }
    }

    private static synchronized void saveData() {
        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(FILE_NAME))) {
            Map<String, Object> allData = new HashMap<>();
            allData.put("menu", menuList);
            allData.put("tables", tableList);
            allData.put("chefs", chefs);
            allData.put("waiters", waiters);
            allData.put("orders", orderLogs);
            allData.put("pass", staffPasswords);
            oos.writeObject(allData);
        } catch (IOException e) { e.printStackTrace(); }
    }

    @SuppressWarnings("unchecked")
    private static void loadData() {
        File file = new File(FILE_NAME);
        if (!file.exists()) return;
        try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(file))) {
            Map<String, Object> allData = (Map<String, Object>) ois.readObject();
            menuList = (List<MenuItem>) allData.getOrDefault("menu", new ArrayList<>());
            tableList = (List<Table>) allData.getOrDefault("tables", new ArrayList<>());
            chefs = (List<Chef>) allData.getOrDefault("chefs", new ArrayList<>());
            waiters = (List<Waiter>) allData.getOrDefault("waiters", new ArrayList<>());
            
            // Fix: Safe conversion to Stack
            Object ordersObj = allData.get("orders");
            if (ordersObj instanceof Stack) {
                orderLogs = (Stack<Order>) ordersObj;
            } else if (ordersObj instanceof List) {
                orderLogs = new Stack<>();
                orderLogs.addAll((List<Order>) ordersObj);
            }
            
            staffPasswords = (Map<String, String>) allData.getOrDefault("pass", new HashMap<>());
        } catch (Exception e) { System.out.println("System initialized."); }
    }

    // --- GETTERS & FINDERS ---
    public static Waiter findWaiterById(int id) { return waiters.stream().filter(w -> w.getId() == id).findFirst().orElse(null); }
    public static Chef findChefById(int id) { return chefs.stream().filter(c -> c.getId() == id).findFirst().orElse(null); }
    public static MenuItem findMenuById(int id) { return menuList.stream().filter(m -> m.getId() == id).findFirst().orElse(null); }
    public static double getDailySales() { return orderLogs.stream().mapToDouble(Order::getTotalPrice).sum(); }
    public static List<Order> getOrderLogs() { return orderLogs; }
    public static List<MenuItem> getMenuList() { return menuList; }
    public static List<Table> getTables() { return tableList; }
    public static List<Waiter> getWaiters() { return waiters; }
    public static List<Chef> getChefs() { return chefs; }

    // --- ADD METHODS ---
    public static void addWaiter(Waiter w, String password) { 
        if (w != null) { 
            waiters.add(w); 
            // Normalize key: lowerCase and no spaces
            String key = "waiter_" + w.getName().toLowerCase().replaceAll("\\s+", "");
            staffPasswords.put(key, password); 
            saveData(); 
        }
    }
    public static void addChef(Chef c, String password) { 
        if (c != null) { 
            chefs.add(c); 
            String key = "chef_" + c.getName().toLowerCase().replaceAll("\\s+", "");
            staffPasswords.put(key, password); 
            saveData(); 
        }
    }
    public static void addMenuItem(MenuItem m) { if (m != null) { menuList.add(m); saveData(); } }
    public static void addTable(Table t) { if (t != null) { tableList.add(t); saveData(); } }
    public static void addOrderLog(Order o) { if (o != null) { orderLogs.push(o); saveData(); } }

    // --- UPDATE & DELETE ---
    public static void updateTable(int id, String name, int cap) {
        for (Table t : tableList) { if (t.getTableId() == id) { t.setTableName(name); t.setCapacity(cap); saveData(); return; } }
    }
    public static void updateMenu(int id, String name, String price, String desc, String session) {
        for (MenuItem m : menuList) { if (m.getId() == id) { m.setItemName(name); m.setPrice(price); m.setDescription(desc); m.setSession(session); saveData(); return; } }
    }
    public static void deleteWaiter(int id) { waiters.removeIf(w -> w.getId() == id); saveData(); }
    public static void deleteChef(int id) { chefs.removeIf(c -> c.getId() == id); saveData(); }
    public static void deleteTable(int id) { tableList.removeIf(t -> t.getTableId() == id); saveData(); }
    public static void deleteMenu(int id) { menuList.removeIf(m -> m.getId() == id); saveData(); }

    // --- AUTHENTICATION ---
    public static class StaffMember implements Serializable {
        public String name, role;
        public StaffMember(String n, String r) { this.name = n; this.role = r; }
    }

    public static StaffMember validate(String u, String p, String r) {
        if (u == null || p == null || r == null) return null;
        
        // Admin direct check
        if (r.equalsIgnoreCase("admin") && u.equalsIgnoreCase("Shazma Noor") && p.equals("Shazma123")) {
            return new StaffMember("Shazma Noor", "admin");
        }
        
        // Dynamic Key: Role_Name (e.g., chef_zukhruf)
        String cleanName = u.toLowerCase().replaceAll("\\s+", "");
        String key = r.toLowerCase() + "_" + cleanName;
        
        if (staffPasswords.containsKey(key) && staffPasswords.get(key).equals(p)) {
            return new StaffMember(u, r.toLowerCase());
        }
        return null; 
    }
}
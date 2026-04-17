package com.restaurant.model;
public class Waiter implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private String name, email, password;
    private int experience;

    public Waiter(int id, String name, String email, int experience) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.experience = experience;
    }

    // Getters & Setters
    public int getId() { return id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}
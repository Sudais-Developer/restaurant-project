package com.restaurant.model;

public class Chef implements java.io.Serializable{
    private int id;
    private String name;
    private String email;
    private String specialization;

    public Chef(int id, String name, String email, String specialization) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.specialization = specialization;
    }

    public int getId() { return id; }
    public String getName() { return name; }
    public String getEmail() { return email; }
    
 // Chef.java ke andar
    public void setName(String name) { this.name = name; }
    public void setEmail(String email) { this.email = email; }
    private String password;
 // Constructor update karein aur getter/setter add karein
 public String getPassword() { return password; }
 public void setPassword(String password) { this.password = password; }
}
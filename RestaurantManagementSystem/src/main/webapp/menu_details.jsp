<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.fresco.dao.StaffManager" %>
<%@ page import="com.restaurant.model.MenuItem" %>

<%
    // --- FIX: Frontend aur Servlet wala same attribute name use karein ---
    List<MenuItem> fullMenu = (List<MenuItem>) application.getAttribute("globalMenu");
    
    // Agar context khali hai, toh direct StaffManager se try karein
    if (fullMenu == null || fullMenu.isEmpty()) {
        fullMenu = StaffManager.getMenuList();
    }

    String search = request.getParameter("search");
    List<MenuItem> filteredMenu = new ArrayList<>();

    // DSA Logic: Linear Search
    if (fullMenu != null) {
        if (search != null && !search.trim().isEmpty()) {
            for (MenuItem m : fullMenu) {
                // Null safety check
                String name = (m.getItemName() != null) ? m.getItemName().toLowerCase() : "";
                String sessionType = (m.getSession() != null) ? m.getSession().toLowerCase() : "";
                String searchLower = search.toLowerCase();

                if (name.contains(searchLower) || sessionType.contains(searchLower)) {
                    filteredMenu.add(m);
                }
            }
        } else {
            filteredMenu = fullMenu;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Menu Management | Fresco</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; background: #050505; color: white; padding: 40px; 
               background-image: linear-gradient(rgba(0,0,0,0.9), rgba(0,0,0,0.9)), url('reservation.jpg'); background-size: cover;}
        .glass-card { background: rgba(255,255,255,0.03); border: 1px solid rgba(247, 148, 29, 0.2); border-radius: 15px; padding: 30px; backdrop-filter: blur(10px); }
        .gold { color: #f7941d; text-transform: uppercase; letter-spacing: 2px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { border-bottom: 2px solid #f7941d; padding: 15px; text-align: left; color: #f7941d; }
        td { padding: 15px; border-bottom: 1px solid #222; }
        .btn { padding: 8px 15px; border-radius: 5px; text-decoration: none; font-size: 13px; margin-right: 5px; transition: 0.3s; display: inline-block; }
        .btn-edit { background: #f7941d; color: black; font-weight: bold; }
        .btn-del { border: 1px solid #ff4757; color: #ff4757; }
        .btn-del:hover { background: #ff4757; color: white; }
        .search-bar { width: 100%; padding: 12px; background: rgba(255,255,255,0.05); border: 1px solid #333; color: white; border-radius: 8px; margin-bottom: 20px; outline: none; }
    </style>
</head>
<body>
    <div class="glass-card">
        <h1 class="gold">Menu Editor</h1>
        
        <form method="GET" action="menu_details.jsp">
            <input type="text" name="search" class="search-bar" placeholder="Search by name or category..." value="<%= (search != null) ? search : "" %>">
        </form>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Price</th>
                    <th>Session</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if(filteredMenu == null || filteredMenu.isEmpty()) { %>
                    <tr><td colspan="5" style="text-align:center; padding: 30px;">No items found in the menu.</td></tr>
                <% } else {
                    for(MenuItem m : filteredMenu) { %>
                    <tr>
                        <td>#<%= m.getId() %></td>
                        <td><strong><%= m.getItemName() %></strong></td>
                        <td>Rs. <%= m.getPrice() %></td>
                        <td><span style="color:#aaa;"><%= m.getSession() %></span></td>
                        <td>
                            <a href="edit_menu.jsp?id=<%= m.getId() %>" class="btn btn-edit">Edit</a>
                            <a href="delete_menu_handler.jsp?id=<%= m.getId() %>" 
                               class="btn btn-del" 
                               onclick="return confirm('Are you sure you want to delete this item?')">
                               Delete
                            </a>
                        </td>
                    </tr>
                <% } } %>
            </tbody>
        </table>
        
        <br>
        <div style="display: flex; gap: 15px; align-items: center;">
            <a href="add_menu.jsp" class="btn btn-edit">+ Add New Item</a>
            <a href="Admin.jsp" style="color:#888; text-decoration:none; font-size: 14px;">Back to Dashboard</a>
        </div>
    </div>
</body>
</html>
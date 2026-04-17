<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.fresco.dao.StaffManager" %>
<%@ page import="com.restaurant.model.*" %>

<%
    String type = request.getParameter("type");
    String idStr = request.getParameter("id");
    
    // Safety Check
    if (type == null || idStr == null || idStr.trim().isEmpty()) {
        response.sendRedirect("Admin.jsp");
        return;
    }

    int id = Integer.parseInt(idStr);
    String name = "", emailOrPrice = "", extra = "", title = "";
    
    try {
        if ("waiter".equalsIgnoreCase(type)) {
            Waiter w = StaffManager.findWaiterById(id);
            if (w != null) {
                name = w.getName();
                emailOrPrice = w.getEmail();
                title = "Edit Waiter";
            }
        } else if ("chef".equalsIgnoreCase(type)) {
            Chef c = StaffManager.findChefById(id);
            if (c != null) {
                name = c.getName();
                emailOrPrice = c.getEmail();
                title = "Edit Chef";
            }
        } else if ("menu".equalsIgnoreCase(type)) {
        	// Full package path ke sath call karein
        	com.restaurant.model.MenuItem m = com.fresco.dao.StaffManager.findMenuById(id);
            if (m != null) {
                name = m.getItemName();
                emailOrPrice = m.getPrice();
                extra = m.getSession();
                title = "Edit Menu Item";
            }
        }
    } catch (Exception e) {
        out.print("Error fetching data: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title><%= title %> | Fresco</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; background: #080808; color: white; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
        .edit-card { background: rgba(255,255,255,0.03); padding: 40px; border-radius: 15px; border: 1px solid #f7941d; width: 450px; box-shadow: 0 10px 30px rgba(0,0,0,0.5); }
        h2 { color: #f7941d; text-align: center; margin-bottom: 20px; }
        label { font-size: 0.9rem; color: #888; }
        .input-box { width: 100%; padding: 12px; margin: 8px 0 20px 0; background: #1a1a1a; border: 1px solid #333; color: white; border-radius: 8px; box-sizing: border-box; }
        .update-btn { width: 100%; padding: 12px; background: #f7941d; border: none; color: black; font-weight: bold; border-radius: 8px; cursor: pointer; transition: 0.3s; }
        .update-btn:hover { background: white; }
    </style>
</head>
<body>

<div class="edit-card">
    <h2><%= title %></h2>
    <form action="update_staff_handler.jsp" method="POST">
        <input type="hidden" name="type" value="<%= type %>">
        <input type="hidden" name="id" value="<%= id %>">
        
        <label>Name / Title:</label>
        <input type="text" name="name" value="<%= name %>" class="input-box" required>
        
        <label><%= type.equals("menu") ? "Price (Rs.)" : "Email Address" %>:</label>
        <input type="text" name="data" value="<%= emailOrPrice %>" class="input-box" required>
        
        <% if(type.equals("menu")) { %>
            <label>Category / Session:</label>
            <input type="text" name="extra" value="<%= extra %>" class="input-box">
        <% } %>
        
        <button type="submit" class="update-btn">Save Changes</button>
        <a href="Admin.jsp" style="display:block; text-align:center; color:#888; margin-top:15px; text-decoration:none;">Back</a>
    </form>
</div>

</body>
</html>
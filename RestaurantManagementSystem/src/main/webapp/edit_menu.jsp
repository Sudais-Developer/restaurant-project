<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.fresco.dao.StaffManager, com.restaurant.model.MenuItem" %>
<%
    String idStr = request.getParameter("id");
    MenuItem item = null;

    try {
        if (idStr != null && !idStr.trim().isEmpty()) {
            int id = Integer.parseInt(idStr);
            // StaffManager se item dhoondna
            item = StaffManager.getMenuList().stream()
                               .filter(m -> m.getId() == id)
                               .findFirst()
                               .orElse(null);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    if (item == null) {
        response.sendRedirect("menu_details.jsp");
        return; 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Menu Item | Fresco</title>
    <style>
        body { font-family: 'Poppins', sans-serif; background: #050505; color: white; padding: 50px; 
               background-image: linear-gradient(rgba(0,0,0,0.9), rgba(0,0,0,0.9)), url('reservation.jpg'); background-size: cover; }
        .form-card { background: rgba(20,20,20,0.9); border: 1px solid #f7941d; padding: 30px; border-radius: 15px; max-width: 500px; margin: auto; backdrop-filter: blur(10px); }
        label { color: #f7941d; font-size: 14px; display: block; margin-top: 10px; }
        input, textarea { width: 100%; padding: 12px; margin: 5px 0 15px 0; background: #111; border: 1px solid #333; color: white; border-radius: 8px; box-sizing: border-box; outline: none; }
        input:focus { border-color: #f7941d; }
        .btn-update { background: #f7941d; color: black; border: none; padding: 15px; width: 100%; cursor: pointer; font-weight: bold; border-radius: 8px; transition: 0.3s; text-transform: uppercase; }
        .btn-update:hover { background: #fff; }
    </style>
</head>
<body>
    <div class="form-card">
        <h2 style="color:#f7941d; text-align: center;">Update Menu Item</h2>
        
        <form action="UpdateMenuServlet" method="POST">
            <input type="hidden" name="id" value="<%= item.getId() %>">
            
            <label>Item Name</label>
            <input type="text" name="name" value="<%= item.getItemName() %>" required>
            
            <label>Price (Rs.)</label>
            <input type="text" name="price" value="<%= item.getPrice() %>" required>
            
            <label>Category (e.g. Appetizer, Drinks)</label>
            <input type="text" name="session" value="<%= item.getSession() %>" required>
            
            <label>Description</label>
            <textarea name="description" rows="4"><%= item.getDescription() != null ? item.getDescription() : "" %></textarea>
            
            <button type="submit" class="btn-update">Save Changes</button>
            <a href="menu_details.jsp" style="color:#888; display:block; text-align:center; margin-top:15px; text-decoration:none;">Cancel</a>
        </form>
    </div>
</body>
</html>
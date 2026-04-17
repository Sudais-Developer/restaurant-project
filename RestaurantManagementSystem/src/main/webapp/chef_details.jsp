<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.restaurant.model.Chef, com.fresco.dao.StaffManager" %>

<%
    // Session Security
    if (session.getAttribute("logged_in") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    // DSA: Fetching data from List
    List<Chef> chefList = StaffManager.getChefs();
    String search = request.getParameter("search");
    List<Chef> filteredChefs = new ArrayList<>();

    // DSA Logic: Linear Search for filtering
    if (search != null && !search.trim().isEmpty()) {
        for (Chef c : chefList) {
            if (c.getName().toLowerCase().contains(search.toLowerCase()) || 
                c.getEmail().toLowerCase().contains(search.toLowerCase())) {
                filteredChefs.add(c);
            }
        }
    } else {
        filteredChefs = chefList;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Chef Management | Fresco</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <style>
        body { font-family: 'Poppins', sans-serif; background: #080808; color: white; padding: 40px; 
               background-image: linear-gradient(rgba(0,0,0,0.9), rgba(0,0,0,0.9)), url('reservation.jpg'); background-size: cover; }
        .glass-panel { background: rgba(255,255,255,0.03); padding: 30px; border-radius: 15px; border: 1px solid rgba(247, 148, 29, 0.2); backdrop-filter: blur(10px); }
        .gold-text { color: #f7941d; text-transform: uppercase; letter-spacing: 2px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; background: rgba(0,0,0,0.3); }
        th { background: rgba(247, 148, 29, 0.1); color: #f7941d; padding: 15px; text-align: left; border-bottom: 2px solid #f7941d; }
        td { padding: 12px; border-bottom: 1px solid rgba(255,255,255,0.05); }
        .btn { padding: 8px 15px; border-radius: 5px; text-decoration: none; font-size: 0.8rem; transition: 0.3s; }
        .btn-edit { border: 1px solid #f7941d; color: #f7941d; }
        .btn-edit:hover { background: #f7941d; color: black; }
        .btn-delete { border: 1px solid #ff4757; color: #ff4757; }
        .btn-delete:hover { background: #ff4757; color: white; }
        .search-box { width: 100%; padding: 12px 20px; background: rgba(255,255,255,0.05); border: 1px solid #333; color: white; border-radius: 10px; margin-bottom: 20px; outline: none; }
        .search-box:focus { border-color: #f7941d; }
    </style>
</head>
<body>

<div class="glass-panel">
    <h1 class="gold-text"><i class="fas fa-hat-chef"></i> Kitchen Staff (Chefs)</h1>
    
    <form method="GET">
        <input type="text" name="search" class="search-box" placeholder="Search chef by name or email..." value="<%= (search != null) ? search : "" %>">
    </form>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Chef Name</th>
                <th>Email Address</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <% if(filteredChefs.isEmpty()) { %>
                <tr><td colspan="4" style="text-align:center; padding: 20px;">No Record Found.</td></tr>
            <% } else { 
                for(Chef c : filteredChefs) { %>
                <tr>
                    <td>#<%= c.getId() %></td>
                    <td><strong><%= c.getName() %></strong></td>
                    <td><%= c.getEmail() %></td>
                    <td>
                        <a href="edit_staff.jsp?id=<%= c.getId() %>&type=chef" class="btn btn-edit">Edit</a>
                        <a href="delete_handler.jsp?type=chef&id=<%= c.getId() %>" class="btn btn-delete" onclick="return confirm('Remove this chef?')">Delete</a>
                    </td>
                </tr>
            <% } } %>
        </tbody>
    </table>

    <div style="margin-top: 30px; display: flex; gap: 15px;">
        <a href="add_staff.jsp" class="btn" style="background: #f7941d; color: black; font-weight: bold;">+ ADD NEW CHEF</a>
        <a href="Admin.jsp" class="btn" style="border: 1px solid #888; color: #888;">BACK TO DASHBOARD</a>
    </div>
</div>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- Sahi packages confirm karein --%>
<%@ page import="java.util.*" %>
<%@ page import="com.restaurant.model.Waiter" %>
<%@ page import="com.fresco.dao.StaffManager" %>

<%
    // Session Security
    if (session.getAttribute("logged_in") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Waiter> filteredList = new ArrayList<>();
    String search = request.getParameter("search");

    try {
        // Method must be static in StaffManager
        List<Waiter> waiterList = StaffManager.getWaiters(); 

        if (waiterList != null) {
            if (search != null && !search.trim().isEmpty()) {
                String searchLower = search.toLowerCase().trim();
                for (Waiter w : waiterList) {
                    // Safety check for null name/email
                    String name = (w.getName() != null) ? w.getName().toLowerCase() : "";
                    String email = (w.getEmail() != null) ? w.getEmail().toLowerCase() : "";
                    
                    if (name.contains(searchLower) || email.contains(searchLower)) {
                        filteredList.add(w);
                    }
                }
            } else {
                filteredList = waiterList;
            }
        }
    } catch (Exception e) {
        filteredList = new ArrayList<>();
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Waiter Management | Fresco</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <style>
        /* Shared Theme from Admin/Chef Dashboard */
        body { font-family: 'Poppins', sans-serif; background: #080808; color: white; padding: 40px; }
        .glass-panel { background: rgba(255,255,255,0.03); padding: 30px; border-radius: 15px; border: 1px solid rgba(247, 148, 29, 0.2); }
        .gold-text { color: #f7941d; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background: rgba(247, 148, 29, 0.1); color: #f7941d; padding: 15px; text-align: left; }
        td { padding: 12px; border-bottom: 1px solid rgba(255,255,255,0.05); }
        .btn { padding: 8px 15px; border-radius: 5px; text-decoration: none; font-size: 0.8rem; margin-right: 5px; }
        .btn-edit { border: 1px solid #f7941d; color: #f7941d; }
        .btn-delete { border: 1px solid #ff4757; color: #ff4757; }
        .search-box { width: 100%; padding: 12px; background: #1a1a1a; border: 1px solid #333; color: white; border-radius: 8px; margin-bottom: 20px; }
    </style>
</head>
<body>

<div class="glass-panel">
    <h1 class="gold-text"><i class="fas fa-id-badge"></i> Waiter Management</h1>
    
    <form method="GET">
        <input type="text" name="search" class="search-box" placeholder="Search by name or email (Linear Search)..." value="<%= (search != null) ? search : "" %>">
    </form>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Full Name</th>
                <th>Email Address</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <% if(filteredList.isEmpty()) { %>
                <tr><td colspan="4" style="text-align:center;">No Waiters Found.</td></tr>
            <% } else { 
                for(Waiter w : filteredList) { %>
                <tr>
                    <td>#<%= w.getId() %></td>
                    <td><%= w.getName() %></td>
                    <td><%= w.getEmail() %></td>
                    <td>
                        <a href="edit_staff.jsp?id=<%= w.getId() %>&type=waiter" class="btn btn-edit">Edit</a>
                        <a href="delete_handler.jsp?type=waiter&id=<%= w.getId() %>" class="btn btn-delete" onclick="return confirm('Delete this waiter?')">Delete</a>
                    </td>
                </tr>
            <% } } %>
        </tbody>
    </table>

    <div style="margin-top: 30px;">
        <a href="add_staff.jsp" class="btn btn-edit" style="background: #f7941d; color: black;">+ Add New Waiter</a>
        <a href="Admin.jsp" class="btn" style="color: #888;">Back to Dashboard</a>
    </div>
</div>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.restaurant.model.Order" %>
<%@ page import="com.fresco.dao.StaffManager" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Logs | Fresco Fine Dining</title>
    <style>
        body { font-family: 'Poppins', sans-serif; background: #0c0c0c; color: white; padding: 40px; }
        .card { background: rgba(255,255,255,0.05); border-radius: 15px; padding: 30px; border: 1px solid #f7941d; }
        h1 { color: #f7941d; border-bottom: 2px solid #f7941d; padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid rgba(255,255,255,0.1); }
        th { color: #f7941d; text-transform: uppercase; font-size: 0.8rem; }
        .btn-back { display: inline-block; margin-top: 20px; color: #f7941d; text-decoration: none; border: 1px solid #f7941d; padding: 10px 20px; border-radius: 5px; }
        .btn-back:hover { background: #f7941d; color: black; }
    </style>
</head>
<body>

<div class="card">
    <h1><i class="fas fa-history"></i> Administrative Order Logs</h1>
    
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Customer</th>
                <th>Dish Name</th>
                <th>Table</th>
                <th>Qty</th>
                <th>Total Price</th>
                <th>Served By</th>
            </tr>
        </thead>
        <tbody>
    <% 
        List<Order> logs = StaffManager.getOrderLogs();
        if(logs != null && !logs.isEmpty()) {
            // Yahan se loop shuru hota hai
            for(Order log : logs) { 
    %>
    <tr>
        <td>#<%= log.getOrderId() %></td>
        <td><%= log.getCustomerName() %></td>
        <td><%= log.getDishName() %></td>
        <%-- Table Number check with safety --%>
        <td>T-<%= (log.getTableNumber() != null) ? log.getTableNumber() : "N/A" %></td>
        <td><%= log.getQuantity() %></td>
        <td style="color: #2ed573;">Rs. <%= log.getTotalPrice() %></td>
        <td><%= log.getWaiterName() %></td>
    </tr>
    <% 
            } // Loop ka closing bracket
        } else { 
    %>
    <tr>
        <td colspan="7" style="text-align: center; padding: 30px;">
            No records found. Orders will appear here after being served.
        </td>
    </tr>
    <% } %>
</tbody>
    </table>

    <a href="Waiter.jsp" class="btn-back">Return to Dashboard</a>
</div>

</body>
</html>
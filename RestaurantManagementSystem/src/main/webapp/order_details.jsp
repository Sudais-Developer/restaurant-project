<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.restaurant.model.Order" %>
<%@ page import="com.fresco.dao.StaffManager" %>

<%
    // Session Check
    if (session.getAttribute("logged_in") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Sales calculation
    double totalSale = StaffManager.getDailySales();
    
    // Yahan hum values assign kar rahe hain
    double dailySale = totalSale;
    double weeklySale = totalSale;
    double monthlySale = totalSale;
    double yearlySale = totalSale;

    // Order Logs ko Stack ke mutabiq display karna (LIFO)
    List<Order> rawOrders = StaffManager.getOrderLogs();
    List<Order> servedOrders = new ArrayList<Order>();
    
    if(rawOrders != null && !rawOrders.isEmpty()) {
        servedOrders = new ArrayList<Order>(rawOrders);
        // Stack ko reverse kar rahe hain taake naya order table mein TOP par dikhe
        Collections.reverse(servedOrders);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Business Analytics | Fresco Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <style>
        :root { --gold: #f7941d; --dark: #0c0c0c; --glass: rgba(255, 255, 255, 0.05); --success: #2ed573; --muted: #888; }
        body { 
            font-family: 'Poppins', sans-serif; background: var(--dark); color: white; margin: 0; padding: 40px;
            background-image: linear-gradient(rgba(0,0,0,0.95), rgba(0,0,0,0.9)), url('reservation.jpg');
            background-size: cover; background-attachment: fixed;
        }
        .container { max-width: 1300px; margin: 0 auto; }
        .header-box { display: flex; justify-content: space-between; align-items: center; background: var(--glass); padding: 20px 40px; border-radius: 15px; border-left: 5px solid var(--gold); margin-bottom: 30px; backdrop-filter: blur(10px); }
        .sales-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px; }
        .sale-card { background: var(--glass); padding: 25px; border-radius: 15px; text-align: center; border: 1px solid rgba(255,255,255,0.1); transition: 0.3s; cursor: pointer; }
        .sale-card:hover, .sale-card.active { transform: translateY(-10px); border-color: var(--gold); background: rgba(247, 148, 29, 0.1); }
        .sale-card i { color: var(--gold); font-size: 2rem; margin-bottom: 15px; }
        .sale-card .current-val { font-size: 1.8rem; font-weight: bold; margin: 10px 0; color: var(--success); }
        .log-section { background: var(--glass); padding: 30px; border-radius: 20px; border: 1px solid rgba(255,255,255,0.1); }
        table { width: 100%; border-collapse: separate; border-spacing: 0 8px; }
        th { text-align: left; padding: 15px; color: var(--gold); border-bottom: 2px solid var(--gold); font-size: 0.85rem; }
        td { padding: 15px; background: rgba(255, 255, 255, 0.03); font-size: 0.9rem; }
        .badge-success { background: rgba(46, 213, 115, 0.2); color: var(--success); border: 1px solid var(--success); padding: 4px 10px; border-radius: 4px; font-size: 0.7rem; }
        .btn-back { text-decoration: none; background: var(--gold); padding: 10px 25px; border-radius: 8px; font-weight: bold; color: black; }
        
        /* Animation for new orders */
        .order-row { transition: 0.4s; }
        .order-row:hover { background: rgba(255,255,255,0.08); }
    </style>
</head>
<body>

<div class="container">
    <div class="header-box">
        <div>
            <h1 style="margin:0;"><i class="fas fa-chart-pie"></i> Business Insights</h1>
            <p style="margin:5px 0 0; color: var(--muted);">Real-time transaction history (Stack Based)</p>
        </div>
        <a href="Admin.jsp" class="btn-back"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
    </div>

    <div class="sales-grid">
        <div class="sale-card">
            <i class="fas fa-calendar-day"></i>
            <h3>Last 7 Days</h3>
            <p class="current-val">Rs. <%= String.format("%.0f", dailySale) %></p>
        </div>
        <div class="sale-card">
            <i class="fas fa-calendar-week"></i>
            <h3>Last 4 Weeks</h3>
            <p class="current-val">Rs. <%= String.format("%.0f", weeklySale) %></p>
        </div>
        <div class="sale-card">
            <i class="fas fa-calendar-alt"></i>
            <h3>Last 12 Months</h3>
            <p class="current-val">Rs. <%= String.format("%.0f", monthlySale) %></p>
        </div>
        <div class="sale-card">
            <i class="fas fa-history"></i>
            <h3>All Time Record</h3>
            <p class="current-val">Rs. <%= String.format("%.0f", yearlySale) %></p>
        </div>
    </div>

    <div class="log-section">
        <table id="logsTable">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Customer</th>
                    <th>Dish Name</th>
                    <th>Table</th>
                    <th>Total Bill</th>
                    <th>Waiter</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <% if(servedOrders.isEmpty()) { %>
                    <tr><td colspan="7" style="text-align:center; padding: 40px;">No transaction records found in Stack.</td></tr>
                <% } else {
                    for(Order o : servedOrders) { %>
                    <tr class="order-row"> 
                        <td style="color: var(--gold); font-weight: bold;">#<%= o.getOrderId() %></td>
                        <td><%= o.getCustomerName() %></td>
                        <td><%= o.getDishName() %> <span style="color:var(--muted)">(x<%= o.getQuantity() %>)</span></td>
                        <td>T-<%= o.getTableNumber() %></td>
                        <td style="color: var(--success); font-weight: bold;">Rs. <%= o.getTotalPrice() %></td>
                        <td><%= o.getWaiterName() %></td>
                        <td><span class="badge-success">PAID</span></td>
                    </tr>
                <% } } %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
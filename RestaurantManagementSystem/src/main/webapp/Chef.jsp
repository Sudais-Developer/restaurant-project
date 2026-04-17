<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.restaurant.model.Order" %>
<%@ page import="com.fresco.dao.KitchenManager" %>

<%
    // 1. Session & Role Security
    if (session.getAttribute("logged_in") == null || !"chef".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. MODIFIED ACTION: Mark specific ID as ready
    String markId = request.getParameter("mark_ready_id");
    if (markId != null) {
        KitchenManager.markSpecificOrderReady(Integer.parseInt(markId)); 
        response.sendRedirect("Chef.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="refresh" content="30"> <title>Executive Chef Dashboard | Fresco</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <style>
        :root { --primary-gold: #f7941d; --dark-bg: #080808; --card-bg: rgba(255, 255, 255, 0.03); --danger: #ff4757; --success: #2ed573; --accent: #ff9f43; --info: #2196f3; }
        body { font-family: 'Poppins', sans-serif; margin: 0; background: var(--dark-bg); color: #f1f1f1; overflow-x: hidden; }
        .container { width: 95%; max-width: 1400px; margin: 0 auto; padding: 30px 0; }
        header { background: rgba(0, 0, 0, 0.6); backdrop-filter: blur(15px); padding: 20px 40px; border-radius: 15px; border: 1px solid rgba(247, 148, 29, 0.2); display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .header-left h1 { margin: 0; font-size: 1.8rem; color: var(--primary-gold); letter-spacing: 2px; }
        .metrics { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 20px; }
        .metric-card { background: var(--card-bg); border-radius: 12px; padding: 20px; border-left: 4px solid var(--primary-gold); }
        .metric-card p { margin: 10px 0 0; font-size: 1.5rem; font-weight: 700; color: var(--primary-gold); }
        .panel { background: rgba(0,0,0,0.4); border-radius: 15px; padding: 25px; border: 1px solid rgba(255,255,255,0.05); margin-bottom: 40px; }
        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; padding: 15px; color: var(--primary-gold); font-size: 0.8rem; text-transform: uppercase; border-bottom: 1px solid rgba(255,255,255,0.1); }
        td { padding: 15px; border-bottom: 1px solid rgba(255,255,255,0.05); }
        .qty-badge { background: #1e1e1e; border: 1px solid var(--accent); color: var(--accent); padding: 3px 10px; border-radius: 4px; font-weight: bold; }
        .table-no { font-weight: bold; color: #fff; background: #333; padding: 4px 8px; border-radius: 4px; }
        .logout-btn { color: #fff; text-decoration: none; font-weight: 600; border: 1px solid var(--danger); padding: 10px 20px; border-radius: 8px; }
        .status-pill { padding: 4px 12px; border-radius: 20px; font-size: 0.7rem; font-weight: bold; }
        .ready { background: rgba(46, 213, 115, 0.1); color: var(--success); border: 1px solid var(--success); }
        /* Added Served Style */
        .served { background: rgba(33, 150, 243, 0.1); color: var(--info); border: 1px solid var(--info); }
        .btn-ready-small { background: var(--primary-gold); color: black; border: none; padding: 5px 12px; border-radius: 5px; font-weight: 600; cursor: pointer; font-size: 0.8rem; }
    </style>
</head>
<body>
<div class="container">
    <header>
        <div class="header-left"><h1><i class="fas fa-utensils"></i> FRESCO KITCHEN</h1></div>
        <a href="login.jsp" class="logout-btn">SIGN OUT</a>
    </header>

    <div class="metrics">
        <div class="metric-card">
            <h3>Pending Tasks</h3>
            <p><%= KitchenManager.pendingOrdersCount() %></p>
        </div>
        <% 
            Stack<Order> readyStack = KitchenManager.getReadyStack();
            int readyCount = readyStack.size();
        %>
        <div class="metric-card" style="border-color: var(--success);">
            <h3>Ready for Pickup</h3>
            <p><%= readyCount %></p>
        </div>
    </div>

    <div class="panel">
        <div class="panel-header"><h2>Active Orders</h2></div>
        <table>
            <thead>
                <tr>
                    <th>ID</th><th>Customer Name</th><th>Table</th><th>Order Items</th><th>Qty</th><th>Price</th><th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    List<Order> activeList = KitchenManager.getPendingOrdersList();
                    if(activeList.isEmpty()) {
                %>
                    <tr><td colspan="7" style="text-align:center; padding:40px; color:#555;">No orders here</td></tr>
                <% 
                    } else {
                        for(Order o : activeList) {
                %>
                <tr>
                    <td style="font-weight: bold; color: var(--primary-gold);">#<%= o.getOrderId() %></td>
                    <td><%= o.getCustomerName() %></td>
                    <td><span class="table-no"><%= o.getTableNumber() %></span></td>
                    <td><%= o.getDishName() %></td>
                    <td><span class="qty-badge">x<%= o.getQuantity() %></span></td>
                    <td style="color: var(--success);">$<%= String.format("%.2f", o.getTotalPrice()) %></td>
                    <td>
                        <form method="POST" style="margin:0;">
                            <input type="hidden" name="mark_ready_id" value="<%= o.getOrderId() %>">
                            <button type="submit" class="btn-ready-small">Mark Ready</button>
                        </form>
                    </td>
                </tr>
                <% } } %>
            </tbody>
        </table>
    </div>

    <div class="panel">
        <div class="panel-header"><h2>Ready Orders</h2></div>
        <table>
            <thead>
                <th>ID</th><th>Customer Name</th><th>Table</th><th>Order Items</th><th>Qty</th><th>Price</th><th style="text-align:right;">Status</th>
            </thead>
            <tbody>
                <% 
                    // History ko display karne ke liye Stack se List bana kar reverse kiya (LIFO)
                    List<Order> history = new ArrayList<>(readyStack);
                    Collections.reverse(history); 
                    for(Order co : history) { 
                %>
                <tr style="opacity: <%= co.getStatus().equals("Served") ? "0.6" : "1.0" %>;">
                    <td>#<%= co.getOrderId() %></td>
                    <td><%= co.getCustomerName() %></td>
                    <td><%= co.getTableNumber() %></td>
                    <td><%= co.getDishName() %></td>
                    <td>x<%= co.getQuantity() %></td>
                    <td style="color: var(--success);">$<%= String.format("%.2f", co.getTotalPrice()) %></td>
                    
                    <td style="text-align:right;">
                        <%-- Logic check: Agar waiter ne status Served kar diya hai to wo dikhao --%>
                        <% if("Served".equals(co.getStatus())) { %>
                            <span class="status-pill served">DELIVERED</span>
                        <% } else { %>
                            <span class="status-pill ready">READY</span>
                        <% } %>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
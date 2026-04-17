<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.restaurant.model.Order" %>
<%@ page import="com.fresco.dao.KitchenManager" %>
<%@ page import="com.fresco.dao.StaffManager" %>

<%
    if (session.getAttribute("logged_in") == null || !"waiter".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("serve_next") != null) {
        Stack<Order> readyOrders = KitchenManager.getReadyStack(); 
        Order nextToServe = null;
        
        synchronized(readyOrders) {
            for(Order o : readyOrders) {
                if("Ready".equals(o.getStatus())) {
                    nextToServe = o;
                    break; 
                }
            }
            
            if(nextToServe != null) {
                String waiterName = (String) session.getAttribute("name");
                nextToServe.setWaiterName(waiterName);
                
                KitchenManager.markAsServed(nextToServe.getOrderId()); 
                // FIXED: Method name matched with StaffManager
                StaffManager.addOrderLog(nextToServe); 
            }
        }
        response.sendRedirect("Waiter.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="refresh" content="15"> 
    <title>Waiter Dashboard | Fresco Fine Dining</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    
    <style>
        :root {
            --primary-gold: #f7941d;
            --dark-bg: #0c0c0c;
            --glass-bg: rgba(255, 255, 255, 0.05);
            --danger: #ff4757;
            --success: #2ed573;
            --info: #2196f3;
        }

        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            background: var(--dark-bg);
            color: #fff;
            background-image: linear-gradient(rgba(0,0,0,0.9), rgba(0,0,0,0.8)), url('reservation.jpg');
            background-size: cover;
            background-attachment: fixed;
            min-height: 100vh;
        }

        .container { width: 95%; max-width: 1400px; margin: 0 auto; padding: 40px 0; }

        header {
            background: rgba(247, 148, 29, 0.1);
            backdrop-filter: blur(15px);
            padding: 25px 40px;
            border-radius: 20px;
            border: 1px solid rgba(247, 148, 29, 0.3);
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 40px;
        }

        .management {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 35px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 25px 50px rgba(0,0,0,0.5);
            margin-bottom: 50px;
        }

        .stats-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }

        /* Main Button Styling */
        .btn-serve-main {
            background: linear-gradient(45deg, #2ed573, #7bed9f);
            color: #000; border: none; padding: 15px 30px;
            border-radius: 10px; font-weight: 700; cursor: pointer;
            text-transform: uppercase; transition: 0.3s;
            display: flex; align-items: center; gap: 10px;
        }
        .btn-serve-main:hover:not(:disabled) { transform: scale(1.05); background: #fff; }
        .btn-serve-main:disabled { background: #333; color: #777; cursor: not-allowed; }

        table { width: 100%; border-collapse: separate; border-spacing: 0 12px; }
        th { 
            text-transform: uppercase; font-size: 0.8rem; letter-spacing: 1.5px;
            color: var(--primary-gold); padding: 15px; text-align: left;
            border-bottom: 2px solid rgba(247, 148, 29, 0.2);
        }

        td { padding: 18px 15px; background: rgba(255, 255, 255, 0.03); }

        .table-label { background: var(--primary-gold); color: #000; padding: 5px 12px; border-radius: 6px; font-weight: 800; }
        .qty-badge { background: rgba(255, 255, 255, 0.05); color: var(--primary-gold); padding: 4px 10px; border-radius: 4px; border: 1px solid var(--primary-gold); font-weight: bold; }
        .status-badge { padding: 6px 15px; border-radius: 6px; font-size: 0.75rem; font-weight: bold; text-transform: uppercase; }
        .status-served { background: rgba(33, 150, 243, 0.2); color: var(--info); border: 1px solid var(--info); }
        .empty-state { text-align: center; padding: 40px; color: #666; font-style: italic; }
        .logout-btn { color: var(--danger); text-decoration: none; font-weight: 600; border: 1px solid var(--danger); padding: 8px 15px; border-radius: 10px; transition: 0.3s; }
    </style>
</head>
<body>

<div class="container">
    <header>
        <div class="header-title">
            <h1 style="margin:0; color: var(--primary-gold); letter-spacing: 2px;">
                <i class="fas fa-concierge-bell"></i> FRESCO WAITER
            </h1>
        </div>
        <a href="login.jsp" class="logout-btn">Sign Out</a>
    </header>

    <div class="management">
        <div class="stats-bar">
            <h2 style="margin:0; font-weight: 600; color: var(--primary-gold);">🍽️ Pickup Counter (Ready Orders)</h2>
            
            <%-- MAIN SERVE ACTION BUTTON --%>
            <form method="POST" style="margin:0;">
                <button type="submit" name="serve_next" class="btn-serve-main">
                    <i class="fas fa-shipping-fast"></i> Serve Next Order
                </button>
            </form>
        </div>

        <table>
            <thead>
                <tr>
                    <th width="10%">Next Turn</th>
                    <th width="10%">ID</th>
                    <th width="15%">Customer</th>
                    <th width="15%">Table</th>
                    <th width="30%">Order Items</th>
                    <th width="10%">Qty</th>
                    <th width="10%">Total Bill</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    Stack<Order> readyOrders = KitchenManager.getReadyStack();
                    boolean hasReady = false;
                    int queuePos = 1;
                    
                    // Display ready orders from Stack (Oldest first for Pickup)
                    for(int i = 0; i < readyOrders.size(); i++) {
                        Order o = readyOrders.get(i);
                        if("Ready".equals(o.getStatus())) {
                            hasReady = true;
                %>
                <tr <%= (queuePos == 1) ? "style='border-left: 4px solid var(--success); background: rgba(46, 213, 115, 0.05);'" : "" %>>
                    <td style="font-weight: bold; color: <%= (queuePos == 1 ? "var(--success)" : "#555") %>;">
                        <%= (queuePos == 1 ? "NEXT →" : "#" + queuePos) %>
                    </td>
                    <td style="color: var(--primary-gold); font-weight: bold;">#<%= o.getOrderId() %></td>
                    <td style="text-transform: capitalize;"><%= o.getCustomerName() %></td>
                    <td><span class="table-label">T-<%= o.getTableNumber() %></span></td>
                    <td style="color: #ddd;"><%= o.getDishName() %></td>
                    <td><span class="qty-badge">x<%= o.getQuantity() %></span></td>
                    <td style="color: var(--success); font-weight: bold;">Rs. <%= o.getTotalPrice() %></td>
                </tr>
                <% queuePos++; } } if(!hasReady) { %>
                    <tr><td colspan="7" class="empty-state">All orders served. Good job!</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <div class="management">
        <div class="stats-bar">
            <h2 style="margin:0; font-weight: 600; color: var(--info);">✅ Served History</h2>
        </div>

        <table>
            <thead>
                <tr>
                    <th width="10%">ID</th>
                    <th width="15%">Customer</th>
                    <th width="15%">Table</th>
                    <th width="35%">Order Items</th>
                    <th width="10%">Qty</th>
                    <th width="10%">Total Bill</th>
                    <th width="15%" style="text-align: right;">Status</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    boolean hasServed = false;
                    // For history, show latest served at top (reverse loop on Stack)
                    for(int i = readyOrders.size() - 1; i >= 0; i--) {
                        Order co = readyOrders.get(i);
                        if("Served".equals(co.getStatus())) {
                            hasServed = true;
                %>
                <tr>
                    <td style="opacity: 0.7;">#<%= co.getOrderId() %></td>
                    <td style="opacity: 0.7;"><%= co.getCustomerName() %></td>
                    <td><span style="color: #fff; font-weight: bold;">T-<%= co.getTableNumber() %></span></td>
                    <td style="color: #aaa;"><%= co.getDishName() %></td>
                    <td><span class="qty-badge" style="opacity: 0.6;">x<%= co.getQuantity() %></span></td>
                    <td style="color: var(--success); font-weight: bold;">Rs. <%= co.getTotalPrice() %></td>
                
                    <td style="text-align: right;">
                        <span class="status-badge status-served">DELIVERED</span>
                    </td>
                </tr>
                <% } } if(!hasServed) { %>
                    <tr><td colspan="6" class="empty-state">No served orders in history yet.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
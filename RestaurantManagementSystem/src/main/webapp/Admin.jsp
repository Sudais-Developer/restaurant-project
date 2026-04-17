<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.fresco.dao.KitchenManager" %>

<%
    // Session Security
    if (session.getAttribute("logged_in") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    int pending = KitchenManager.pendingOrdersCount();
    int completed = KitchenManager.getCompletedOrders().size();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Master Admin Control | Fresco</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    
    <style>
        :root {
            --primary-gold: #f7941d;
            --dark-bg: #050505;
            --card-bg: rgba(255, 255, 255, 0.03);
            --danger: #ff4757;
            --success: #2ed573;
        }

        body {
            font-family: 'Poppins', sans-serif;
            margin: 0; background: var(--dark-bg); color: #fff;
            background-image: linear-gradient(rgba(0,0,0,0.9), rgba(0,0,0,0.9)), url('reservation.jpg');
            background-size: cover; background-attachment: fixed;
        }

        .container { width: 95%; max-width: 1300px; margin: 0 auto; padding: 20px 0; }

        header {
            background: rgba(255, 255, 255, 0.02);
            backdrop-filter: blur(15px); padding: 20px 40px;
            border-radius: 20px; border: 1px solid rgba(247, 148, 29, 0.1);
            display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;
        }

        /* Metrics Bar */
        .metrics-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px; margin-bottom: 40px;
        }
        .metric-card {
            background: var(--card-bg); border-radius: 15px; padding: 20px;
            border-bottom: 3px solid var(--primary-gold); text-align: center;
        }

        /* Clickable Box Styling */
        .management-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
        }

        /* 1. Yahan Button Issue Fix Kiya Hai */
        .admin-box {
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 20px;
            padding: 0; /* Padding 0 taake anchor poora cover kare */
            transition: all 0.3s ease;
            overflow: hidden;
            cursor: pointer;
        }

        .admin-box a {
            text-decoration: none;
            color: white;
            display: block; /* Poora box clickable banane ke liye */
            padding: 40px 25px;
            height: 100%;
            width: 100%;
        }

        .admin-box:hover {
            background: rgba(247, 148, 29, 0.15);
            border-color: var(--primary-gold);
            transform: translateY(-10px);
            box-shadow: 0 10px 30px rgba(247, 148, 29, 0.2);
        }

        .admin-box i { font-size: 3rem; color: var(--primary-gold); margin-bottom: 20px; transition: 0.3s; }
        .admin-box:hover i { transform: scale(1.2); color: #fff; }

        .admin-box h3 { margin: 10px 0; font-size: 1.4rem; }
        .admin-box p { color: #aaa; font-size: 0.85rem; padding: 0 10px; }

        .logout-btn { 
            color: var(--danger); text-decoration: none; font-weight: 600;
            padding: 10px 25px; border-radius: 10px; border: 2px solid var(--danger);
            transition: 0.3s;
        }
        .logout-btn:hover { background: var(--danger); color: white; }
    </style>
</head>
<body>

<div class="container">
    <header>
        <div style="display:flex; align-items:center; gap:15px;">
            <div style="width:50px; height:50px; background:var(--primary-gold); border-radius:50%; display:flex; align-items:center; justify-content:center; color:black; font-weight:bold;">SN</div>
            <h2>Welcome, SHAZMA NOOR</h2>
        </div>
        <a href="login.jsp" class="logout-btn">LOGOUT</a>
    </header>

    <div class="metrics-grid">
        <div class="metric-card"><h3>Orders Pending</h3><p><%= pending %></p></div>
        <div class="metric-card" style="border-color: var(--success);"><h3>Orders Served</h3><p><%= completed %></p></div>
        <div class="metric-card" style="border-color: #2196f3;"><h3>Role</h3><p>Administrator</p></div>
    </div>

    <div class="management-grid">
        
        <div class="admin-box">
            <a href="waiter_details.jsp">
                <i class="fas fa-user-friends"></i>
                <h3>Waiters List</h3>
            </a>
        </div>

        <div class="admin-box">
            <a href="chef_details.jsp">
                <i class="fas fa-hat-chef"></i>
                <h3>Chefs List</h3>
            </a>
        </div>

        <div class="admin-box">
            <a href="menu_details.jsp">
                <i class="fas fa-book-open"></i>
                <h3>Menu Details</h3>
            </a>
        </div>

        <div class="admin-box">
            <a href="order_details.jsp">
                <i class="fas fa-file-invoice-dollar"></i>
                <h3>Order Logs</h3>
            </a>
        </div>

        <div class="admin-box">
            <a href="manage_tables.jsp">
                <i class="fas fa-chair"></i>
                <h3>Table Status</h3>
            </a>
        </div>

        <div class="admin-box" style="border: 2px dashed var(--primary-gold);">
            <a href="add_staff.jsp">
                <i class="fas fa-plus-circle"></i>
                <h3 style="color: var(--primary-gold);">Add Staff</h3>
            </a>
        </div>

    </div>
</div>

</body>
</html>
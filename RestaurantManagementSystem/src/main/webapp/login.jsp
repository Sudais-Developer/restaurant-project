<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.fresco.dao.StaffManager" %>

<%
    String error = "";
    // Check if the form is submitted
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String role = request.getParameter("role");
        String name = request.getParameter("name") != null ? request.getParameter("name").trim() : "";
        String password = request.getParameter("password") != null ? request.getParameter("password").trim() : "";

        // Calling the updated validate method
        com.fresco.dao.StaffManager.StaffMember member = com.fresco.dao.StaffManager.validate(name, password, role);

        if (member != null) {
            session.setAttribute("name", member.name);
            session.setAttribute("role", member.role);
            session.setAttribute("logged_in", true);
            
            // Precise redirection logic
            if ("admin".equals(member.role)) {
                response.sendRedirect("Admin.jsp");
            } else if ("chef".equals(member.role)) {
                response.sendRedirect("Chef.jsp");
            } else if ("waiter".equals(member.role)) {
                response.sendRedirect("Waiter.jsp");
            }
            return; // Important: Stop processing after redirect
        } else {
            error = "❌ Invalid Username, Password, or Role.";
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Team Login | Fresco Fine Dining</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <style>
        :root { --primary-gold: #f7941d; --dark-bg: #0c0c0c; --input-bg: #1a1a1a; }
        body { margin: 0; background-color: var(--dark-bg); font-family: 'Poppins', sans-serif; color: white; background-image: linear-gradient(rgba(0,0,0,0.8), rgba(0,0,0,0.8)), url('reservation.jpg'); background-size: cover; background-attachment: fixed; min-height: 100vh; }
        .navbar { display: flex; justify-content: space-between; align-items: center; background: rgba(0,0,0,0.9); padding: 15px 50px; border-bottom: 2px solid var(--primary-gold); backdrop-filter: blur(10px); }
        .logo img { height: 50px; }
        .nav-links { list-style: none; display: flex; gap: 30px; margin: 0; }
        .nav-links a { text-decoration: none; color: #ddd; font-weight: 500; transition: 0.3s; }
        .nav-links a:hover { color: var(--primary-gold); }
        .login-wrapper { height: calc(100vh - 85px); display: flex; justify-content: center; align-items: center; }
        .login-box { background: rgba(20, 20, 20, 0.95); padding: 50px 40px; border-radius: 20px; width: 400px; box-shadow: 0 20px 50px rgba(0,0,0,0.5); border: 1px solid rgba(247, 148, 29, 0.3); text-align: center; }
        .login-box h2 { color: var(--primary-gold); margin-bottom: 35px; font-weight: 600; font-size: 2.2rem; letter-spacing: 2px; }
        .input-group { position: relative; margin-bottom: 25px; }
        .input-field { width: 100%; padding: 15px 15px 15px 45px; background: var(--input-bg); border: 1px solid #333; color: white; border-radius: 10px; box-sizing: border-box; outline: none; transition: 0.3s; font-size: 0.95rem; }
        .input-field:focus { border-color: var(--primary-gold); background: #222; }
        .input-group i { position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #666; font-size: 1.1rem; }
        .btn-login { width: 100%; padding: 15px; background: var(--primary-gold); border: none; color: black; font-weight: 700; border-radius: 10px; cursor: pointer; font-size: 1rem; text-transform: uppercase; letter-spacing: 1px; transition: 0.3s; margin-top: 10px; }
        .btn-login:hover { background: #fff; transform: translateY(-3px); box-shadow: 0 10px 20px rgba(247, 148, 29, 0.3); }
        .error-msg { background: rgba(255, 77, 77, 0.1); color: #ff4d4d; padding: 10px; border-radius: 8px; margin-bottom: 20px; font-size: 0.85rem; border: 1px solid rgba(255, 77, 77, 0.3); }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="logo"><img src="download.png" alt="Fresco Logo"></div>
    <ul class="nav-links">
        <li><a href="index.html">Home</a></li>
        <li><a href="menu.jsp">Menu</a></li>
        <li><a href="login.jsp" style="color:var(--primary-gold)">Team Access</a></li>
        <li><a href="reservation.jsp">Reservation</a></li>
    </ul>
</nav>
<div class="login-wrapper">
    <div class="login-box">
        <h2>STAFF LOGIN</h2>
        <% if (!error.isEmpty()) { %>
            <div class="error-msg"><i class="fas fa-exclamation-triangle"></i> <%= error %></div>
        <% } %>
        <form method="POST">
            <div class="input-group">
                <i class="fas fa-user-tag"></i>
                <select name="role" class="input-field" required>
                    <option value="" disabled selected>Select Role</option>
                    <option value="admin">Master Admin</option>
                    <option value="waiter">Service Staff (Waiter)</option>
                    <option value="chef">Kitchen Staff (Chef)</option>
                </select>
            </div>
            <div class="input-group">
                <i class="fas fa-user"></i>
                <input type="text" name="name" placeholder="Username" class="input-field" required>
            </div>
            <div class="input-group">
                <i class="fas fa-lock"></i>
                <input type="password" name="password" placeholder="Password" class="input-field" required>
            </div>
            <button type="submit" class="btn-login">SIGN IN TO DASHBOARD</button>
        </form>
    </div>
</div>
</body>
</html>
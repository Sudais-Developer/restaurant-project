<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- DSA CONCEPT: Sorted List implementation (A-Z Sorting) --%>
<%@ page import="com.fresco.dao.*, com.restaurant.model.*, java.util.*" %>

<%
    // --- 1. SECURITY & STATE CHECK ---
    if (session.getAttribute("customer_name") == null) {
        response.sendRedirect("reservation.jsp");
        return; 
    }

    String customerName = (String) session.getAttribute("customer_name");
    String customerPhone = (String) session.getAttribute("customer_phone");
    
    // Reservation info from session
    String tableUniqueName = (session.getAttribute("table_unique_name") != null) ? session.getAttribute("table_unique_name").toString() : "Not Selected"; 
    String numPersons = (session.getAttribute("num_persons") != null) ? session.getAttribute("num_persons").toString() : "0";
    
    List<OrderItem> cart = (List<OrderItem>) session.getAttribute("cart");
    
    // --- 2. AJAX: Quantity Update Logic ---
    if (request.getParameter("updateQty") != null) {
        String itemName = request.getParameter("name");
        int newQty = Integer.parseInt(request.getParameter("qty"));
        if (cart != null) {
            for (OrderItem item : cart) {
                if (item.getName().equals(itemName)) {
                    item.setQuantity(newQty);
                    break;
                }
            }
            session.setAttribute("cart", cart);
        }
        return; 
    }

    // --- 3. MENU SELECTION HANDLER ---
    String stackOrderStr = request.getParameter("stackOrder");
    if (stackOrderStr != null && !stackOrderStr.isEmpty()) {
        List<com.restaurant.model.MenuItem> allItems = StaffManager.getMenuList();
        
        if (allItems != null) {
            cart = new ArrayList<>();
            String[] ids = stackOrderStr.split(",");
            
            for (String idStr : ids) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    // Find item by ID (Linear Search)
                    for(com.restaurant.model.MenuItem mItem : allItems) {
                        if(mItem.getId() == id) {
                            double price = Double.parseDouble(mItem.getPrice());
                            cart.add(new OrderItem(mItem.getItemName(), price, 1));
                            break;
                        }
                    }
                } catch(Exception e) { e.printStackTrace(); }
            }
            // ✅ DSA CONCEPT: Alphabetical Sorting
            Collections.sort(cart, (a, b) -> a.getName().compareToIgnoreCase(b.getName()));
            session.setAttribute("cart", cart);
            session.removeAttribute("order_already_saved"); 
        }
    }

    // --- 4. FINAL ORDER SAVE ---
    if (request.getParameter("confirm_order") != null) {
        if (session.getAttribute("order_already_saved") == null && cart != null && !cart.isEmpty()) {
            double finalTotal = 0;
            StringBuilder itemNames = new StringBuilder(); 
            for (OrderItem item : cart) {
                itemNames.append(item.getName()).append(" (x").append(item.getQuantity()).append("), ");
                finalTotal += (item.getPrice() * item.getQuantity());
            }
            String itemsListString = itemNames.toString().replaceAll(", $", "");
            String orderId = "ORD-" + System.currentTimeMillis() % 10000;
            
            FileDAO dao = new FileDAO();
            dao.saveOrder(orderId, customerName, customerPhone, itemsListString, finalTotal);
            session.setAttribute("order_already_saved", "true");
        }
        response.sendRedirect("Receipt.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Review Your Order | Fresco</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family: 'Montserrat', sans-serif; background: linear-gradient(rgba(0,0,0,0.85), rgba(0,0,0,0.85)), url('fire.jpg'); background-size: cover; background-position: center; background-attachment: fixed; color: #fff; min-height: 100vh; }
        .navbar { display: flex; justify-content: space-between; align-items: center; background-color: rgba(0,0,0,0.95); padding: 15px 80px; position: fixed; top: 0; width: 100%; z-index: 1000; border-bottom: 1px solid #f7941d; }
        .logo img { height: 50px; }
        .nav-links { list-style: none; display: flex; gap: 40px; }
        .nav-links a { text-decoration: none; color: #fff; font-weight: 600; font-size: 14px; text-transform: uppercase; transition: 0.3s; }
        .nav-links a:hover { color: #f7941d; }
        h2 { text-align: center; margin-top: 130px; font-size: 2.8rem; color: #f7941d; text-transform: uppercase; letter-spacing: 3px; }
        .container { max-width: 900px; margin: 40px auto; background: rgba(15, 15, 15, 0.95); padding: 40px; border: 1px solid #333; box-shadow: 0 20px 50px rgba(0,0,0,0.8); border-radius: 15px; border-top: 5px solid #f7941d; }
        .res-info { display: flex; justify-content: space-between; background: #222; padding: 15px; border-radius: 8px; margin-bottom: 25px; border: 1px dashed #f7941d; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
        th { text-align: left; padding: 15px; background: #222; color: #f7941d; border-bottom: 2px solid #f7941d; }
        td { padding: 15px; border-bottom: 1px solid #333; font-size: 1.1rem; }
        .qty-box { display: flex; align-items: center; border: 1px solid #444; width: fit-content; border-radius: 4px; overflow: hidden; }
        .qty-btn { background: #222; color: #f7941d; border: none; width: 35px; height: 35px; cursor: pointer; font-size: 1.2rem; }
        .qty-val { width: 45px; text-align: center; font-weight: bold; background: transparent; color: white; }
        .total-row td { font-weight: bold; font-size: 1.8rem; color: #fff; border-top: 2px solid #f7941d; padding-top: 20px; }
        .btn { padding: 15px 40px; font-weight: bold; text-transform: uppercase; cursor: pointer; transition: 0.3s; border: none; font-size: 1rem; border-radius: 5px; text-decoration: none; display: inline-block; }
        .btn-confirm { background: #f7941d; color: #000; }
        .btn-edit { background: transparent; color: #ccc; border: 1px solid #555; }
        .btn-edit:hover { border-color: #f7941d; color: #f7941d; }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="logo"><img src="download.png" alt="Logo" /></div>
        <ul class="nav-links">
            <li><a href="index.html">Home</a></li>
            <li><a href="menu.jsp">Menu</a></li>
            <li><a href="reservation.jsp">Reservation</a></li>
            <li><a href="about.jsp">About Us</a></li>
        </ul>
    </nav>

    <h2 data-aos="fade-down">🧾 Review Order</h2>

    <div class="container" data-aos="zoom-in">
        <% if (cart != null && !cart.isEmpty()) { %>
            <div style="margin-bottom: 20px; color: #888; font-size: 0.9rem;">
                Customer: <span style="color: #f7941d;"><%= customerName %></span> | 
                Phone: <span style="color: #f7941d;"><%= customerPhone %></span>
            </div>

            <div class="res-info">
                <span>📍 Table: <b style="color:#f7941d;"><%= tableUniqueName %></b></span>
                <span>👥 Persons: <b style="color:#f7941d;"><%= numPersons %></b></span>
            </div>

            <table>
                <thead>
                    <tr><th>Item</th><th>Price</th><th>Qty</th><th style="text-align: right;">Subtotal</th></tr>
                </thead>
                <tbody>
                    <%
                    double grandTotal = 0;
                    for (OrderItem item : cart) {
                        double subtotal = item.getPrice() * item.getQuantity();
                        grandTotal += subtotal;
                    %>
                    <tr class="item-row" data-name="<%= item.getName() %>" data-price="<%= item.getPrice() %>">
                        <td><%= item.getName() %></td>
                        <td style="color: #f7941d;">Rs. <%= String.format("%.2f", item.getPrice()) %></td>
                        <td>
                            <div class="qty-box">
                                <button type="button" class="qty-btn minus">-</button>
                                <span class="qty-val"><%= item.getQuantity() %></span>
                                <button type="button" class="qty-btn plus">+</button>
                            </div>
                        </td>
                        <td style="text-align: right; font-weight: bold;">Rs. <span class="sub-val"><%= String.format("%.2f", subtotal) %></span></td>
                    </tr>
                    <% } %>
                    <tr class="total-row">
                        <td colspan="3">Grand Total</td>
                        <td style="text-align: right; color: #f7941d;">Rs. <span id="grand-total"><%= String.format("%.2f", grandTotal) %></span></td>
                    </tr>
                </tbody>
            </table>

            <div style="display: flex; justify-content: center; gap: 20px;">
                <a href="menu.jsp?newOrder=true&edit=true" class="btn btn-edit">Edit Order</a>
                
                <form action="Order.jsp" method="post" id="finalForm">
                    <input type="hidden" name="confirm_order" value="true">
                    <button type="submit" id="submitBtn" class="btn btn-confirm">Confirm & Save ➔</button>
                </form>
            </div>
        <% } else { %>
            <div style="text-align: center; padding: 50px;">
                <p style="font-size: 1.5rem; color: #888;">Your cart is empty.</p>
                <a href="menu.jsp" class="btn btn-confirm" style="margin-top:20px;">Go to Menu</a>
            </div>
        <% } %>
    </div>

    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
        AOS.init({ once: true, duration: 800 });

        $(document).ready(function() {
            $('#finalForm').on('submit', function() {
                $('#submitBtn').prop('disabled', true).text("Saving Order...");
            });

            $(".plus, .minus").click(function() {
                var row = $(this).closest(".item-row");
                var name = row.data("name");
                var price = parseFloat(row.data("price"));
                var qtyElem = row.find(".qty-val");
                var subValElem = row.find(".sub-val");
                var currentQty = parseInt(qtyElem.text());
                
                if ($(this).hasClass("plus")) { currentQty++; } 
                else if (currentQty > 1) { currentQty--; }
                
                qtyElem.text(currentQty);
                subValElem.text((currentQty * price).toFixed(2));
                
                var grand = 0;
                $(".sub-val").each(function() { grand += parseFloat($(this).text()); });
                $("#grand-total").text(grand.toFixed(2));
                
                // Update session via AJAX
                $.post("Order.jsp", { updateQty: "true", name: name, qty: currentQty });
            });
        });
    </script>
</body>
</html>
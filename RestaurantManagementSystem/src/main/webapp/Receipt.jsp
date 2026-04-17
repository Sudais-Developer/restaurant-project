<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.fresco.dao.*, com.restaurant.model.*, java.util.*, java.text.SimpleDateFormat" %>

<%
    // 1. Security Check
    if (session.getAttribute("customer_name") == null || session.getAttribute("cart") == null) {
        response.sendRedirect("menu.jsp");
        return;
    }

    // Session Data Retrieval
    String customerName = (String) session.getAttribute("customer_name");
    String customerPhone = (String) session.getAttribute("customer_phone");
    
    // Reservation Data from Session
    Object tableObj = session.getAttribute("table_unique_name");
    Object personsObj = session.getAttribute("num_persons");
    
    // Safety check for nulls
    String tableUniqueName = (tableObj != null) ? tableObj.toString() : "Online Order";
    String numPersons = (personsObj != null) ? personsObj.toString() : "0";
    
    // Date aur Time fetch karna (Jo Reservation page se session mein aaye thay)
    String selectedDate = (String) session.getAttribute("selected_date");
    String selectedTime = (String) session.getAttribute("selected_time");

    List<OrderItem> cart = (List<OrderItem>) session.getAttribute("cart");
    
    // Total Bill & Total Quantity Calculation
    double totalAmount = 0;
    int totalQuantity = 0; 
    StringBuilder itemsSummary = new StringBuilder();

    if (cart != null) {
        for (int i = 0; i < cart.size(); i++) {
            OrderItem item = cart.get(i);
            totalAmount += item.getTotalPrice();
            totalQuantity += item.getQuantity();
            
            itemsSummary.append(item.getName()).append(" (x").append(item.getQuantity()).append(")");
            if (i < cart.size() - 1) itemsSummary.append(", ");
        }
    }

    String todayDate = new SimpleDateFormat("dd/MM/yyyy").format(new Date());
    // Unique ID for saving
    String invoiceNo = "ORD-" + (System.currentTimeMillis() % 10000);

    // 2. AUTO-SAVE TO FILE (FIXED LINE 50)
    if (session.getAttribute("order_already_saved") == null) {
        try {
            FileDAO dao = new FileDAO();
            // Added invoiceNo as 1st argument to match FileDAO's expected signature
            dao.saveOrder(invoiceNo, customerName, customerPhone, itemsSummary.toString(), totalAmount);
            session.setAttribute("order_already_saved", true);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 3. SEND TO KITCHEN
    if (request.getParameter("complete_order") != null) {
        try {
            String chefDetails = itemsSummary.toString();

            Order kitchenOrder = new Order(
                (int)(System.currentTimeMillis() % 10000), 
                customerName,                              
                chefDetails,                               
                tableUniqueName,                             
                totalQuantity,                             
                totalAmount                                
            );
            
            KitchenManager.addOrder(kitchenOrder);

            // Clean up session after full completion
            session.removeAttribute("cart");
            session.removeAttribute("order_already_saved");

            out.println("<script>alert('Order successfully sent to Chef Dashboard!'); window.location='index.html';</script>");
        } catch (Exception e) {
            out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
        }
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoice - <%= invoiceNo %></title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #000; color: #e9a616; min-height: 100vh; }
        .invoice-container { 
            background: #0a0a0a; max-width: 850px; margin: 40px auto; padding: 60px; 
            border-radius: 8px; border: 1px solid rgba(247, 148, 29, 0.15);
        }
        .table-head { background: #2a2a2a; border-top: 2px solid #e9a616; border-bottom: 2px solid #e9a616; }
        .table-row:nth-child(even) { background-color: #1a1a1a; }
        
        @media print {
            .no-print { display: none !important; }
            body { background: white !important; }
            .invoice-container { border: none !important; width: 100% !important; background: white !important; color: black !important; padding: 20px; }
            * { color: black !important; }
        }
    </style>
</head>
<body class="p-4">

    <div class="invoice-container">
        <div class="flex justify-between items-start mb-8 border-b border-orange-900 pb-6">
            <div class="flex items-center space-x-4">
                <img src="download.png" alt="Fresco Logo" class="h-16 w-16"> 
                <div>
                    <h2 class="font-bold text-xl uppercase text-white">Fresco Fine Dining</h2>
                    <p class="text-sm italic" style="color: #e9a616;">"Taste the Excellence First"</p>
                </div>
            </div>
            <div class="text-right">
                <h1 class="text-5xl font-bold uppercase mb-2">Invoice</h1>
                <p class="text-lg font-semibold" style="color: #f7941d;"><%= invoiceNo %></p>
                <p class="text-sm text-gray-400">Bill Date: <%= todayDate %></p>
                
            </div>
        </div>

        <div class="grid grid-cols-2 gap-8 mb-10 bg-[#111] p-6 rounded-lg border border-gray-800">
            <div>
                <h3 class="text-xs uppercase tracking-widest text-gray-500 mb-2">Customer Info</h3>
                <p class="text-white font-semibold text-lg"><%= customerName %></p>
                <p class="text-sm text-gray-400"><%= customerPhone %></p>
            </div>
            <div class="text-right">
                <h3 class="text-xs uppercase tracking-widest text-gray-500 mb-2">Reservation Details</h3>
                <p class="text-white font-semibold">Table: <span style="color: #f7941d;"><%= tableUniqueName %></span></p>
                <p class="text-sm text-gray-400">Guests: <%= numPersons %> Persons</p>
                <% if(selectedDate != null) { %><p class="text-xs text-gray-500">Booking Date: <%= selectedDate %></p><% } %>
                <% if(selectedTime != null) { %><p class="text-xs text-gray-500">Booking Time: <%= selectedTime %></p><% } %>
            </div>
        </div>

        <table class="w-full mb-10 text-sm">
            <thead class="table-head">
                <tr>
                    <th class="py-4 px-4 text-left">Item Description</th>
                    <th class="py-4 px-4 text-center">QTY</th>
                    <th class="py-4 px-4 text-right">Unit Price</th>
                    <th class="py-4 px-4 text-right">Subtotal</th>
                </tr>
            </thead>
            <tbody>
                <% if (cart != null) { 
                    for (OrderItem item : cart) { %>
                <tr class="table-row">
                    <td class="py-5 px-4 text-white font-medium"><%= item.getName() %></td>
                    <td class="py-5 px-4 text-center"><%= item.getQuantity() %></td>
                    <td class="py-5 px-4 text-right">Rs. <%= String.format("%.2f", item.getPrice()) %></td>
                    <td class="py-5 px-4 text-right font-bold" style="color: #f7941d;">
                        Rs. <%= String.format("%.2f", item.getTotalPrice()) %>
                    </td>
                </tr>
                <% } 
                } %>
            </tbody>
        </table>

        <div class="flex justify-end">
            <div class="w-80 bg-[#2a2a2a] border border-[#e9a616] p-5 rounded-lg">
                <div class="flex justify-between items-center mb-2">
                    <span class="text-gray-400">Total Items:</span>
                    <span class="text-white font-bold"><%= totalQuantity %></span>
                </div>
                <div class="flex justify-between items-center border-t border-gray-600 pt-2">
                    <span class="text-lg font-bold">Grand Total</span>
                    <span class="text-2xl font-bold" style="color: #f7941d;">Rs. <%= String.format("%.2f", totalAmount) %></span>
                </div>
            </div>
        </div>
        
        <div class="mt-12 text-center border-t border-gray-900 pt-6">
            <p class="text-xs text-gray-500">Thank you for dining with Fresco. We hope to see you again!</p>
        </div>
    </div>

    <div class="max-w-[850px] mx-auto flex justify-center gap-6 no-print pb-10">
        <button onclick="window.print()" class="px-10 py-3 rounded-lg font-semibold bg-gray-800 text-white hover:bg-gray-700 transition">
            Print / Save PDF
        </button>
        <form method="post">
            <button type="submit" name="complete_order" value="true" class="px-10 py-3 rounded-lg font-semibold transition-all" style="background: linear-gradient(to right, #e9a616, #f7941d); color: black;">
                Confirm & Send to Kitchen ➔
            </button>
        </form>
    </div>

</body>
</html>
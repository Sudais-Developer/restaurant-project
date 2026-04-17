<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.fresco.dao.FileDAO, java.util.*" %>

<%
    FileDAO dao = new FileDAO();
    String currentPage = request.getRequestURI(); 

    // DELETE ACTION
    String deleteId = request.getParameter("deleteId");
    if (deleteId != null) {
        dao.deleteOrder(deleteId);
        response.sendRedirect("admin_logs.jsp"); // Apni file ka sahi naam check karlein
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Logs | Fresco Dining</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #0f172a; color: #f8fafc; }
        .glass-card { background: rgba(30, 41, 59, 0.7); backdrop-filter: blur(12px); border: 1px solid rgba(71, 85, 105, 0.5); }
    </style>
</head>
<body class="p-4 md:p-10">

    <div class="max-w-7xl mx-auto">
        <header class="mb-10 text-center">
            <h1 class="text-4xl font-black text-transparent bg-clip-text bg-gradient-to-r from-orange-400 to-red-500 uppercase tracking-tighter">
                Order Management System
            </h1>
            <p class="text-slate-400 mt-2 font-medium">Customer Orders | Admin Panel</p>
        </header>

        <div class="glass-card rounded-3xl shadow-2xl overflow-x-auto">
            <table class="w-full text-left border-collapse min-w-[1000px]">
                <thead class="bg-slate-800 text-orange-400 uppercase text-xs font-bold tracking-widest">
                    <tr>
                        <th class="p-6">Order ID</th>
                        <th class="p-6">Customer Name</th>
                        <th class="p-6">Contact</th>
                        <th class="p-6">Items Ordered</th>
                        <th class="p-6 text-right">Total Bill</th>
                        <th class="p-6 text-center">Actions</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-700">
                    <%
                        List<String[]> rawRecords = dao.getAllOrders();
                        
                        if(rawRecords == null || rawRecords.isEmpty()){
                    %>
                        <tr>
                            <td colspan="6" class="p-20 text-center text-slate-500 italic text-lg">
                                📂 No orders found in history.
                            </td>
                        </tr>
                    <%
                        } else {
                            Map<String, String[]> orderMap = new LinkedHashMap<>();

                            for(String[] row : rawRecords) {
                                if(row == null || row.length < 4) continue;
                                
                                String orderId = row[0].trim();
                                
                                if(orderMap.containsKey(orderId)) {
                                    String[] existing = orderMap.get(orderId);
                                    // Items ko merge karein agar multiple hain
                                    existing[3] = existing[3] + "<br>• " + row[3].trim();
                                } else {
                                    String[] newRow = new String[row.length];
                                    System.arraycopy(row, 0, newRow, 0, row.length);
                                    newRow[3] = "• " + row[3].trim();
                                    orderMap.put(orderId, newRow);
                                }
                            }

                            for(String[] row : orderMap.values()) {
                    %>
                    <tr class="hover:bg-slate-700/30 transition duration-200 group">
                        <td class="p-6 align-top">
                            <span class="bg-orange-500/10 text-orange-400 px-3 py-1 rounded-md border border-orange-500/30 font-mono text-xs font-bold">
                                <%= row[0].trim() %>
                            </span>
                        </td>
                        <td class="p-6 font-semibold text-white align-top"><%= row[1] %></td>
                        <td class="p-6 text-slate-400 text-sm align-top"><%= row[2] %></td>
                        <td class="p-6 text-slate-300 text-sm leading-relaxed">
                            <%= row[3] %>
                        </td>
                        <td class="p-6 text-right font-bold text-emerald-400 text-lg align-top">
                            PKR <%= row[4] %>
                        </td>
                        <td class="p-6 text-center align-top">
                            <a href="?deleteId=<%= row[0].trim() %>" 
                               onclick="return confirm('Are you sure?')"
                               class="bg-red-500/10 hover:bg-red-600 text-red-500 hover:text-white px-4 py-2 rounded-xl border border-red-500/50 transition-all text-xs font-bold inline-block">
                                DELETE 🗑️
                            </a>
                        </td>
                    </tr>
                    <%      } // Yeh values() loop ka end hai
                        } // Yeh else ka end hai
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
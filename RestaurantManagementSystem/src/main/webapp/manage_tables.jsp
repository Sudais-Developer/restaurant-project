<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.fresco.dao.StaffManager" %> 
<%@ page import="com.restaurant.model.Table" %>

<%
    // Global Context se tables uthana (Sync Fix)
    List<Table> tables = (List<Table>) application.getAttribute("globalTables");
    
    // Agar context null ho (server restart), toh StaffManager se recover karein
    if (tables == null) {
        tables = StaffManager.getTables();
        application.setAttribute("globalTables", tables);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Fresco | Manage Tables</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --primary-gold: #f7941d;
            --bg-dark: #0f0f0f;
            --card-bg: #1a1a1a;
            --text-gray: #b0b0b0;
            --danger: #ff4d4d;
            --success: #2ed573;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-dark);
            color: white;
            margin: 0;
            padding: 20px;
        }

        .container {
            max-width: 1000px;
            margin: 0 auto;
        }

        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            border-left: 5px solid var(--primary-gold);
            padding-left: 15px;
        }

        .log-section {
            background: var(--card-bg);
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
            border: 1px solid rgba(255,255,255,0.05);
        }

        /* Form Styling */
        .add-form {
            background: rgba(247, 148, 29, 0.05);
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            display: grid;
            grid-template-columns: 2fr 1fr 1fr;
            gap: 15px;
            align-items: end;
        }

        .form-group label {
            display: block;
            font-size: 0.8rem;
            color: var(--primary-gold);
            margin-bottom: 8px;
            text-transform: uppercase;
        }

        input {
            width: 100%;
            padding: 12px;
            background: #252525;
            border: 1px solid #333;
            border-radius: 8px;
            color: white;
            box-sizing: border-box;
            transition: 0.3s;
        }

        input:focus {
            outline: none;
            border-color: var(--primary-gold);
            box-shadow: 0 0 8px rgba(247, 148, 29, 0.2);
        }

        .btn-add {
            background: var(--primary-gold);
            color: black;
            border: none;
            padding: 13px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-add:hover { transform: translateY(-2px); opacity: 0.9; }

        /* Table Styling */
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 10px;
        }

        th {
            text-align: left;
            padding: 15px;
            color: var(--text-gray);
            font-weight: 500;
            border-bottom: 1px solid #333;
        }

        tr.table-row {
            background: #222;
            transition: 0.3s;
        }

        tr.table-row:hover { background: #282828; }

        td {
            padding: 15px;
        }

        td:first-child { border-radius: 10px 0 0 10px; }
        td:last-child { border-radius: 0 10px 10px 0; }

        .action-btns { display: flex; gap: 15px; }

        .btn-edit { color: var(--success); text-decoration: none; cursor: pointer; }
        .btn-delete { color: var(--danger); text-decoration: none; }

        /* Edit Modal Styling */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.8);
            backdrop-filter: blur(5px);
        }

        .modal-content {
            background: var(--card-bg);
            width: 400px;
            margin: 10% auto;
            padding: 30px;
            border-radius: 15px;
            border: 1px solid var(--primary-gold);
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header-section">
        <h1 style="margin:0;">Manage <span style="color:var(--primary-gold)">Tables</span></h1>
        <i class="fas fa-utensils fa-2x" style="color:var(--primary-gold)"></i>
    </div>

    <div class="log-section">
        <form action="AddTableServlet" method="POST" class="add-form">
            <div class="form-group">
                <label>Table Identity</label>
                <input type="text" name="tableName" placeholder="e.g. T-01" required>
            </div>
            <div class="form-group">
                <label>Seating Capacity</label>
                <input type="number" name="capacity" placeholder="4" required>
            </div>
            <button type="submit" class="btn-add"><i class="fas fa-plus"></i> Create Table</button>
        </form>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>TABLE NAME</th>
                    <th>CAPACITY</th>
                    <th>ACTIONS</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    if(tables != null && !tables.isEmpty()) {
                        for(Table t : tables) { 
                %>
                <tr class="table-row">
                    <td style="color: var(--primary-gold); font-weight: 600;">#<%= t.getTableId() %></td>
                    <td style="font-weight: 500;"><%= t.getTableName() %></td>
                    <td><i class="fas fa-users" style="margin-right:8px; color:#555"></i><%= t.getCapacity() %> Persons</td>
                    <td>
                        <div class="action-btns">
                            <a class="btn-edit" onclick="openEditModal('<%= t.getTableId() %>', '<%= t.getTableName() %>', '<%= t.getCapacity() %>')">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                            <a href="DeleteTableServlet?id=<%= t.getTableId() %>" class="btn-delete" 
                               onclick="return confirm('Archive this table permanently?')">
                                <i class="fas fa-trash-alt"></i> Delete
                            </a>
                        </div>
                    </td>
                </tr>
                <% 
                        } 
                    } else { 
                %>
                <tr><td colspan="4" style="text-align:center; padding:50px; color:#555;">No tables available in floor plan.</td></tr>
                <% } %>
            </tbody>
        </table>
        <div style="display: flex; gap: 15px; align-items: center; margin-top: 20px;">
            <a href="Admin.jsp" style="color:#888; text-decoration:none; font-size: 14px;"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
        </div>
    </div>
</div>

<div id="editModal" class="modal">
    <div class="modal-content">
        <h3 style="margin-top:0; color:var(--primary-gold)">Update Table Details</h3>
        <form action="UpdateTableServlet" method="POST">
            <input type="hidden" name="tableId" id="editId">
            <div class="form-group" style="margin-bottom:15px;">
                <label>Table Name</label>
                <input type="text" name="tableName" id="editName" required>
            </div>
            <div class="form-group" style="margin-bottom:20px;">
                <label>Capacity</label>
                <input type="number" name="capacity" id="editCapacity" required>
            </div>
            <div style="display:flex; gap:10px;">
                <button type="submit" class="btn-add" style="flex:1;">Save Changes</button>
                <button type="button" onclick="closeModal()" style="flex:1; background:#333; color:white; border:none; border-radius:8px; cursor:pointer;">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openEditModal(id, name, cap) {
        document.getElementById('editId').value = id;
        document.getElementById('editName').value = name;
        document.getElementById('editCapacity').value = cap;
        document.getElementById('editModal').style.display = 'block';
    }
    function closeModal() { document.getElementById('editModal').style.display = 'none'; }
</script>
</body>
</html>
package com.restaurant.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.fresco.dao.StaffManager;
import com.restaurant.model.Table;
import java.util.List;

@WebServlet("/UpdateTableServlet")
public class UpdateTableServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Check karein ke parameters null toh nahi
            String idStr = request.getParameter("tableId");
            String name = request.getParameter("tableName");
            String capStr = request.getParameter("capacity");

            if (idStr != null && name != null && capStr != null) {
                int id = Integer.parseInt(idStr);
                int capacity = Integer.parseInt(capStr);

                // 1. StaffManager (Permanent Storage) update
                StaffManager.updateTable(id, name, capacity);
                
                // 2. Global Context Refresh (Very Important for JSP Sync)
                List<Table> updatedTables = StaffManager.getTables();
                getServletContext().setAttribute("globalTables", updatedTables);
                
                response.sendRedirect("manage_tables.jsp?updated=true");
            } else {
                response.sendRedirect("manage_tables.jsp?error=missing_data");
            }
        } catch (NumberFormatException e) {
            // Agar ID ya Capacity number nahi hai
            response.sendRedirect("manage_tables.jsp?error=format");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage_tables.jsp?error=server");
        }
    }
}
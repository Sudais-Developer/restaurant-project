package com.restaurant.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.fresco.dao.StaffManager;
import com.restaurant.model.Table;

@WebServlet("/AddTableServlet")
public class AddTableServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String name = request.getParameter("tableName");
            String capacityStr = request.getParameter("capacity");

            if (name != null && capacityStr != null) {
                int cap = Integer.parseInt(capacityStr);
                int id = StaffManager.getTables().size() + 101; 
                Table newTable = new Table(id, name, cap);
                
                StaffManager.addTable(newTable); // Save to File/Memory
                
                // SYNC: Update Global Context
                getServletContext().setAttribute("globalTables", StaffManager.getTables());
            }
            response.sendRedirect("manage_tables.jsp?msg=success");
        } catch (Exception e) {
            response.sendRedirect("manage_tables.jsp?error=true");
        }
    }
}
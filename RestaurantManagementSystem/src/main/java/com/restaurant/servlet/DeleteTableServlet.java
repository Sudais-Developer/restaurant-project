package com.restaurant.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.fresco.dao.StaffManager;

@WebServlet("/DeleteTableServlet")
public class DeleteTableServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            StaffManager.deleteTable(Integer.parseInt(idStr)); // Remove from File/Memory
            
            // SYNC: Update Global Context
            getServletContext().setAttribute("globalTables", StaffManager.getTables());
        }
        response.sendRedirect("manage_tables.jsp?msg=deleted");
    }
}
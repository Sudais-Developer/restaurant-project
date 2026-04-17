<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.fresco.dao.StaffManager" %>

<%
    String type = request.getParameter("type"); // 'chef', 'waiter', ya 'menu'
    String idStr = request.getParameter("id");

    if (idStr != null && type != null) {
        try {
            int id = Integer.parseInt(idStr);
            String redirectPage = "Admin.jsp"; // Default redirect

            // Generic Logic based on type
            if (type.equalsIgnoreCase("chef")) {
                StaffManager.deleteChef(id);
                redirectPage = "chef_details.jsp?msg=deleted";
            } 
            else if (type.equalsIgnoreCase("waiter")) {
                StaffManager.deleteWaiter(id);
                redirectPage = "waiter_details.jsp?msg=deleted";
            } 
            else if (type.equalsIgnoreCase("menu")) {
                StaffManager.deleteMenu(id);
                redirectPage = "menu_details.jsp?msg=deleted";
            }

            response.sendRedirect(redirectPage);
            
        } catch (NumberFormatException e) {
            out.println("<script>alert('Invalid ID Format'); window.location='Admin.jsp';</script>");
        }
    } else {
        response.sendRedirect("Admin.jsp");
    }
%>
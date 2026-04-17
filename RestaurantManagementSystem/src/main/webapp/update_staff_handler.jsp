<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.fresco.dao.StaffManager" %>
<%@ page import="java.util.*" %>
<%@ page import="com.restaurant.model.*" %>
<%
    String type = request.getParameter("type"); 
    String idStr = request.getParameter("id");
    String newName = request.getParameter("name");
    String emailOrPrice = request.getParameter("data"); 
    String extra = request.getParameter("extra"); 

    if (type != null && idStr != null) {
        try {
            int id = Integer.parseInt(idStr);

            if ("waiter".equalsIgnoreCase(type)) {
                // Pehle purana record dhoondo taake oldName mil sake
                Waiter w = StaffManager.findWaiterById(id);
                if(w != null) {
                    // Update: Ab 4 parameters bhej rahe hain (id, oldName, newName, email)
                    StaffManager.updateWaiter(id, w.getName(), newName, emailOrPrice);
                    application.setAttribute("globalWaiters", StaffManager.getWaiters());
                }
                response.sendRedirect("waiter_details.jsp?msg=updated");
                return;

            } else if ("chef".equalsIgnoreCase(type)) {
                // Pehle purana record dhoondo
                Chef c = StaffManager.findChefById(id);
                if(c != null) {
                    // Update: Ab 4 parameters bhej rahe hain
                    StaffManager.updateChef(id, c.getName(), newName, emailOrPrice);
                    application.setAttribute("globalChefs", StaffManager.getChefs());
                }
                response.sendRedirect("chef_details.jsp?msg=updated");
                return;

            } else if ("menu".equalsIgnoreCase(type)) {
                // Menu ke liye StaffManager check karein: description missing tha aapke call mein
                // StaffManager.updateMenu(id, name, price, desc, session)
                StaffManager.updateMenu(id, newName, emailOrPrice, "Updated Description", extra);
                application.setAttribute("globalMenu", StaffManager.getMenuList());
                response.sendRedirect("manage_menu.jsp?msg=updated");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Admin.jsp?error=true");
        }
    }
%>
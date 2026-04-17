<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.fresco.dao.StaffManager, com.restaurant.model.MenuItem" %>

<%
    String idParam = request.getParameter("id");

    if (idParam != null) {
        try {
            int idToDelete = Integer.parseInt(idParam);

            // 1. StaffManager (Memory) se delete karein
            List<MenuItem> list = StaffManager.getMenuList();
            
            // DSA: ID ke basis par item dhoond kar remove karna
            list.removeIf(item -> item.getId() == idToDelete);

            // 2. SABSE ZAROORI: ServletContext (Global List) ko update karein
            // Taake Frontend aur Admin dono jagah se foran gayab ho jaye
            getServletContext().setAttribute("globalMenu", list);

            // 3. Wapis Admin page par bhej dein success message ke saath
            response.sendRedirect("menu_details.jsp?msg=deleted");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("menu_details.jsp?error=delete_failed");
        }
    } else {
        response.sendRedirect("menu_details.jsp");
    }
%>
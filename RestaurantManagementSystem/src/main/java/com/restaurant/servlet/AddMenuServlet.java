package com.restaurant.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.fresco.dao.StaffManager;
import com.restaurant.model.MenuItem;

@WebServlet("/AddMenuServlet")
public class AddMenuServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String name = request.getParameter("name");
            String price = request.getParameter("price"); // String hi rehne dein
            String description = request.getParameter("description");
            String sessionType = request.getParameter("session");

            // Naya ID generate karna
            int newId = StaffManager.getMenuList().size() + 1;
            
            // Ab ye aapke MenuItem(int, String, String, String, String) constructor se match karega
            MenuItem newItem = new MenuItem(newId, name, price, description, sessionType);
            
            StaffManager.addMenuItem(newItem);
            
            // Frontend sync ke liye
            getServletContext().setAttribute("globalMenu", StaffManager.getMenuList());

            response.sendRedirect("menu_details.jsp?msg=added");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("add_menu.jsp?error=true");
        }
    }
}
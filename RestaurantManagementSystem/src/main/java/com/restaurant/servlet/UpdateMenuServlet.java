package com.restaurant.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.fresco.dao.StaffManager;
import com.restaurant.model.MenuItem;

@WebServlet("/UpdateMenuServlet")
public class UpdateMenuServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String price = request.getParameter("price");
            String description = request.getParameter("description");
            String sessionType = request.getParameter("session");

            List<MenuItem> menuList = StaffManager.getMenuList();

            // DSA: O(n) Search to find and update the item
            for (MenuItem item : menuList) {
                if (item.getId() == id) {
                    item.setItemName(name);
                    item.setPrice(price);
                    item.setDescription(description);
                    item.setSession(sessionType);
                    break;
                }
            }

            // --- SABSE ZAROORI LINE ---
            // Global context ko nayi list se overwrite karein
            getServletContext().setAttribute("globalMenu", menuList);

            response.sendRedirect("menu_details.jsp?msg=updated");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("menu_details.jsp?error=update_failed");
        }
    }
}
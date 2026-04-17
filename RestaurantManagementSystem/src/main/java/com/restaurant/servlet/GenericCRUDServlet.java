package com.restaurant.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.fresco.dao.GenericDAO;
import com.restaurant.model.OrderItem;

@WebServlet("/GenericCRUDServlet")
public class GenericCRUDServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        // Context se DAO nikalna
        GenericDAO<OrderItem> dao = (GenericDAO<OrderItem>) getServletContext().getAttribute("menuDAO");

        if (dao == null) {
            dao = new GenericDAO<OrderItem>();
            getServletContext().setAttribute("menuDAO", dao);
        }

        if ("add".equals(action)) {
            String name = req.getParameter("name");
            String priceStr = req.getParameter("price");
            if (name != null && priceStr != null) {
                double price = Double.parseDouble(priceStr);
                // Model wala constructor use karein: name, price, quantity
                dao.add(new OrderItem(name, price, 1)); 
            }
        } 
        res.sendRedirect("menu.jsp"); 
    }
}
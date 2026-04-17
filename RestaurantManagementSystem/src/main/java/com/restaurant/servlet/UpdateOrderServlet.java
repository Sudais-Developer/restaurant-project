package com.restaurant.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.fresco.dao.KitchenManager;

@WebServlet("/UpdateOrderServlet")
public class UpdateOrderServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String orderIdStr = request.getParameter("orderId");
        String action = request.getParameter("action");

        if (orderIdStr != null && action != null) {
            try {
                int id = Integer.parseInt(orderIdStr);
                if ("ready".equals(action)) {
                    KitchenManager.markSpecificOrderReady(id);
                    response.sendRedirect("Chef.jsp"); // Chef dashboard par wapas
                } else if ("served".equals(action)) {
                    KitchenManager.markAsServed(id); // Waiter ke liye
                    response.sendRedirect("Waiter.jsp"); 
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("index.html");
            }
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}
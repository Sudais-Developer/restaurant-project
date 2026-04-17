package com.restaurant.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.fresco.dao.FileDAO;
import com.fresco.dao.GenericDAO;
import com.restaurant.model.MenuItem;
import com.restaurant.model.OrderItem;

@WebServlet("/PlaceOrderServlet")
public class PlaceOrderServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // 1. Context ya session se menuDAO lena
        GenericDAO<MenuItem> menuDAO = (GenericDAO<MenuItem>) getServletContext().getAttribute("menuDAO");
        String name = (String) session.getAttribute("customer_name");
        String phone = (String) session.getAttribute("customer_phone");

        // Agar customer info nahi hai toh wapis reservation par bhejein
        if (name == null) {
            response.sendRedirect("reservation.jsp");
            return;
        }

        String[] selectedIndices = request.getParameterValues("menu_items");
        List<OrderItem> cart = new ArrayList<>();
        double total = 0;
        StringBuilder itemsSummary = new StringBuilder(); // Items ke naam jama karne ke liye

        // 2. Cart aur Total Calculate karein
        if (selectedIndices != null && menuDAO != null) {
            List<MenuItem> allItems = menuDAO.getAll();
            for (String idx : selectedIndices) {
                try {
                    int index = Integer.parseInt(idx);
                    if (index < allItems.size()) {
                        MenuItem m = allItems.get(index);
                        
                        // String price ko double mein convert karna
                        double priceVal = Double.parseDouble(m.getPrice());
                        
                        OrderItem item = new OrderItem(m.getItemName(), priceVal, 1);
                        cart.add(item);
                        total += priceVal;
                        
                        // Items list banayein (e.g. "Pizza, Burger, Coke")
                        itemsSummary.append(m.getItemName()).append(", ");
                    }
                } catch (Exception e) {
                    System.out.println("Error parsing index or price: " + e.getMessage());
                }
            }
        }

        // 3. String se aakhri comma (,) hatayein
        String finalItems = itemsSummary.toString();
        if (finalItems.endsWith(", ")) {
            finalItems = finalItems.substring(0, finalItems.length() - 2);
        } else if (finalItems.isEmpty()) {
            finalItems = "No items selected";
        }

        // 4. Unique Order ID generate karein (FileDAO requirement)
        String orderId = "FRESCO-" + (int)(Math.random() * 9000 + 1000);

        // 5. FileDAO call (Ab ye bilkul sahi hai: 5 parameters)
        new FileDAO().saveOrder(orderId, name, phone, finalItems, total);

        // 6. Session set karein aur redirect karein
        session.setAttribute("cart", cart);
        session.setAttribute("total", total);
        response.sendRedirect("Order.jsp");
    }
}
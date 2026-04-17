package com.restaurant.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.restaurant.model.Chef;
import com.restaurant.model.Waiter;
import com.fresco.dao.StaffManager;

@WebServlet("/AddStaffServlet")
public class AddStaffServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String name = request.getParameter("name"); 
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        
        try {
            if ("chef".equalsIgnoreCase(role)) {
                int id = StaffManager.getChefs().size() + 201;
                Chef newChef = new Chef(id, name, email, "General");
                
                StaffManager.addChef(newChef, password); // File mein save hua
                
                // SYNC: Application context update karein
                getServletContext().setAttribute("globalChefs", StaffManager.getChefs());
                response.sendRedirect("chef_details.jsp?msg=added");

            } else if ("waiter".equalsIgnoreCase(role)) {
                int id = StaffManager.getWaiters().size() + 501;
                Waiter newWaiter = new Waiter(id, name, email, 0);
                
                StaffManager.addWaiter(newWaiter, password); // File mein save hua
                
                // SYNC: Application context update karein
                getServletContext().setAttribute("globalWaiters", StaffManager.getWaiters());
                response.sendRedirect("waiter_details.jsp?msg=added");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("add_staff.jsp?error=true");
        }
    }
}
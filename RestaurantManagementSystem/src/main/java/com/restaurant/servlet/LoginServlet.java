package com.restaurant.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.fresco.dao.StaffManager;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String role = request.getParameter("role");

        HttpSession session = request.getSession();

        // 1. Hardcoded Admin Check (Shazma Noor)
        if ("admin".equals(role) && "Shazma Noor".equalsIgnoreCase(user) && "Shazma123".equals(pass)) {
            session.setAttribute("logged_in", true);
            session.setAttribute("role", "admin");
            session.setAttribute("name", "Shazma Noor");
            response.sendRedirect("Admin.jsp");
            return;
        }

        // 2. StaffManager Validation (For other staff)
        StaffManager.StaffMember member = StaffManager.validate(user, pass, role);

        if (member != null) {
            session.setAttribute("logged_in", true);
            session.setAttribute("role", member.role);
            session.setAttribute("name", member.name);

            if ("admin".equals(member.role)) response.sendRedirect("Admin.jsp");
            else if ("chef".equals(member.role)) response.sendRedirect("Chef.jsp");
            else if ("waiter".equals(member.role)) response.sendRedirect("Waiter.jsp");
        } else {
            // Error hone par wapis login page par bhejein
            response.sendRedirect("login.jsp?error=1");
        }
    }
}
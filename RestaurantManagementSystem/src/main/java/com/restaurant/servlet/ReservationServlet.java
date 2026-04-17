package com.restaurant.servlet;

import java.io.IOException;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ReservationServlet")
public class ReservationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Form se data fetch karna
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String table = request.getParameter("table"); // Ye table ka ID ya Name hai
        String personCount = request.getParameter("person"); // Form se 'person' dropdown ki value
        String date = request.getParameter("date");
        String time = request.getParameter("time");
        
        // 2. Ek Unique Reservation ID generate karna
        String reservationId = "RES-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        
        // 3. Session Management
        HttpSession session = request.getSession();
        
        // Purani flags clear karein
        session.removeAttribute("order_already_saved");
        // session.removeAttribute("cart"); // Note: Agar aap chahte hain cart save rahe (localStorage wala kaam), toh is line ko comment rehne dein

        // 4. Data Formatting
        String resDetails = "Table " + table + " Reserved for " + date + " at " + time;
        
        // 5. SESSION DATA SET (Fixing the Null issue)
        session.setAttribute("reservation_id", reservationId);
        session.setAttribute("customer_name", name);
        session.setAttribute("customer_phone", phone);
        session.setAttribute("reservation_detail", resDetails);
        
        // --- ADDED THESE LINES TO FIX YOUR ORDER.JSP NULL ISSUE ---
        session.setAttribute("table_unique_name", table); // Ye wahi name hai jo Order.jsp mang raha hai
        
        try {
            // Persons ko Integer mein convert karke save karein
            int persons = Integer.parseInt(personCount);
            session.setAttribute("num_persons", persons);
        } catch (Exception e) {
            session.setAttribute("num_persons", 0);
        }
        
        // 6. Redirect to Menu
        response.sendRedirect("menu.jsp");
    }
}
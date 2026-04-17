package com.restaurant.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.fresco.dao.GenericDAO;
import com.restaurant.model.MenuItem;

@WebServlet("/MenuServlet")
public class MenuServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Context se menuDAO lena
        GenericDAO<MenuItem> menuDAO = (GenericDAO<MenuItem>) getServletContext().getAttribute("menuDAO");
        
        if (menuDAO != null) {
            List<MenuItem> menuList = menuDAO.getAll();
            request.setAttribute("menuList", menuList);
        }
        
        // Menu page par bhej dena
        request.getRequestDispatcher("menu.jsp").forward(request, response);
    }
}
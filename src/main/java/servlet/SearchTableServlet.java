package com.restman.servlet;

import com.restman.dao.TableDAO;
import com.restman.model.Table;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/searchTable")
public class SearchTableServlet extends HttpServlet {
    private TableDAO tableDAO;

    @Override
    public void init() {
        tableDAO = new TableDAO();
        System.out.println("✅ SearchTableServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Kiểm tra session và role
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("❌ Unauthorized access to searchTable");
            response.sendRedirect("login");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!"salestaff".equals(role) && !"manager".equals(role)) {
            System.out.println("❌ Access denied - Role: " + role);
            response.sendRedirect("login");
            return;
        }

        String customerName = request.getParameter("customerName");
        List<Table> tables = null;

        if (customerName != null && !customerName.trim().isEmpty()) {
            System.out.println("🔍 Searching tables for customer: " + customerName);
            tables = tableDAO.searchTableByCustomerName(customerName.trim());
            request.setAttribute("customerName", customerName.trim());
        }

        request.setAttribute("tables", tables);
        request.getRequestDispatcher("/staff/searchTable.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
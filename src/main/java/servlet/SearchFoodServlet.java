package com.restman.servlet;

import com.restman.dao.MenuFoodDAO;
import com.restman.model.MenuFood;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/searchFood")
public class SearchFoodServlet extends HttpServlet {
    private MenuFoodDAO menuFoodDAO;

    @Override
    public void init() {
        menuFoodDAO = new MenuFoodDAO();
        System.out.println("✅ SearchFoodServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Kiểm tra session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("❌ Unauthorized access to searchFood");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String keyword = request.getParameter("keyword");
        List<MenuFood> foodList;

        if (keyword != null && !keyword.trim().isEmpty()) {
            System.out.println("🔍 Searching food with keyword: " + keyword);
            foodList = menuFoodDAO.searchFoodByName(keyword.trim());
            request.setAttribute("keyword", keyword.trim());
        } else {
            System.out.println("📋 Getting all food items");
            foodList = menuFoodDAO.getAllFood();
        }

        System.out.println("✅ Found " + foodList.size() + " food items");
        request.setAttribute("foodList", foodList);

        // QUAN TRỌNG: Forward đến JSP
        request.getRequestDispatcher("/customer/searchFood.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
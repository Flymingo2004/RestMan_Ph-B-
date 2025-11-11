package com.restman.servlet;

import com.restman.dao.MenuFoodDAO;
import com.restman.model.MenuFood;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/foodDetail")
public class FoodDetailServlet extends HttpServlet {
    private MenuFoodDAO menuFoodDAO;

    @Override
    public void init() {
        menuFoodDAO = new MenuFoodDAO();
        System.out.println("✅ FoodDetailServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Kiểm tra session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("❌ Unauthorized access to foodDetail");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int foodId = Integer.parseInt(idParam.trim());
                System.out.println("🔍 Getting food detail for ID: " + foodId);

                MenuFood food = menuFoodDAO.getFoodById(foodId);

                if (food != null) {
                    request.setAttribute("food", food);
                    // QUAN TRỌNG: Đường dẫn đúng đến JSP
                    request.getRequestDispatcher("/customer/foodDetail.jsp").forward(request, response);
                } else {
                    System.out.println("❌ Food not found with ID: " + foodId);
                    response.sendRedirect(request.getContextPath() + "/searchFood");
                }
            } catch (NumberFormatException e) {
                System.out.println("❌ Invalid food ID format: " + idParam);
                response.sendRedirect(request.getContextPath() + "/searchFood");
            }
        } else {
            System.out.println("❌ Missing food ID parameter");
            response.sendRedirect(request.getContextPath() + "/searchFood");
        }
    }
}
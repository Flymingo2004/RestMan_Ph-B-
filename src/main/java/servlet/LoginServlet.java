package com.restman.servlet;

import com.restman.dao.UserDAO;
import com.restman.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
        System.out.println("✅ LoginServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra nếu đã đăng nhập thì chuyển về trang chủ
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            String role = (String) session.getAttribute("role");
            redirectToHome(response, role);
            return;
        }

        // Hiển thị trang login
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        System.out.println("📝 Login attempt - Username: " + username);

        // Validate input
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Validate user
        User user = userDAO.validateUser(username.trim(), password);

        if (user != null) {
            // Đăng nhập thành công - Tạo session
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("fullName", user.getFullName());
            session.setAttribute("role", user.getRole());
            session.setMaxInactiveInterval(30 * 60); // 30 phút

            System.out.println("✅ Login successful - User: " + user.getFullName() + " - Role: " + user.getRole());

            // Chuyển hướng theo role
            redirectToHome(response, user.getRole());
        } else {
            // Đăng nhập thất bại
            System.out.println("❌ Login failed - Invalid credentials");
            request.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không đúng!");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    /**
     * Chuyển hướng về trang chủ theo role
     */
    private void redirectToHome(HttpServletResponse response, String role) throws IOException {
        switch (role) {
            case "customer":
                response.sendRedirect("customer/home.jsp");
                break;
            case "salestaff":
                response.sendRedirect("staff/home.jsp");
                break;
            case "manager":
                response.sendRedirect("staff/home.jsp"); // Manager cũng dùng giao diện staff
                break;
            default:
                response.sendRedirect("login.jsp");
        }
    }
}
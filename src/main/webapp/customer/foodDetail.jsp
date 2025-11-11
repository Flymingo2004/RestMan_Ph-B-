<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.restman.model.MenuFood" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    MenuFood food = (MenuFood) request.getAttribute("food");
    if (food == null) {
        response.sendRedirect(request.getContextPath() + "/searchFood");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= food.getName() %> - RestMan</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f7fa;
        }

        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .navbar-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 24px;
            font-weight: 600;
            text-decoration: none;
            color: white;
        }

        .btn-back {
            background: rgba(255,255,255,0.2);
            color: white;
            border: 1px solid rgba(255,255,255,0.5);
            padding: 8px 20px;
            border-radius: 20px;
            text-decoration: none;
            transition: all 0.3s;
        }

        .btn-back:hover {
            background: rgba(255,255,255,0.3);
        }

        .container {
            max-width: 900px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .food-detail-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .food-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 60px 40px;
            text-align: center;
            color: white;
        }

        .food-icon {
            font-size: 120px;
            margin-bottom: 20px;
        }

        .food-header h1 {
            font-size: 36px;
            margin-bottom: 15px;
        }

        .food-price-large {
            font-size: 32px;
            font-weight: 700;
        }

        .food-content {
            padding: 40px;
        }

        .info-section {
            margin-bottom: 30px;
        }

        .info-section h3 {
            color: #333;
            font-size: 20px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .info-section p {
            color: #666;
            line-height: 1.8;
            font-size: 16px;
        }

        .badge-container {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .badge {
            display: inline-block;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
        }

        .badge-type {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .badge-available {
            background: #4caf50;
            color: white;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            flex: 1;
            padding: 16px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
            text-decoration: none;
            display: block;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: #f0f0f0;
            color: #333;
        }

        .btn-secondary:hover {
            background: #e0e0e0;
        }

        .divider {
            height: 1px;
            background: #e0e0e0;
            margin: 30px 0;
        }
    </style>
</head>
<body>
<div class="navbar">
    <a href="<%= request.getContextPath() %>/customer/home.jsp" class="navbar-brand">
        <span>🍽️</span>
        <span>RestMan - Nhà Hàng Phở Bò</span>
    </a>
    <a href="<%= request.getContextPath() %>/searchFood" class="btn-back">← Quay lại tìm kiếm</a>
</div>

<div class="container">
    <div class="food-detail-card">
        <div class="food-header">
            <div class="food-icon">
                <% if ("combo".equals(food.getType())) { %>
                🍱
                <% } else { %>
                🍽️
                <% } %>
            </div>
            <h1><%= food.getName() %></h1>
            <div class="food-price-large"><%= food.getFormattedPrice() %></div>
        </div>

        <div class="food-content">
            <div class="badge-container">
                    <span class="badge badge-type">
                        <%= "combo".equals(food.getType()) ? "🍱 Combo" : "🍽️ Món đơn" %>
                    </span>
                <% if (food.isAvailable()) { %>
                <span class="badge badge-available">✓ Còn hàng</span>
                <% } %>
            </div>

            <div class="divider"></div>

            <div class="info-section">
                <h3>📝 Mô tả món ăn</h3>
                <p><%= food.getDescription() != null ? food.getDescription() : "Món ăn đặc sắc, được chế biến từ nguyên liệu tươi ngon và công thức độc đáo của nhà hàng." %></p>
            </div>

            <% if (food.getIngredients() != null && !food.getIngredients().isEmpty()) { %>
            <div class="info-section">
                <h3>🥗 Nguyên liệu</h3>
                <p><%= food.getIngredients() %></p>
            </div>
            <% } %>

            <div class="action-buttons">
                <a href="<%= request.getContextPath() %>/searchFood" class="btn btn-secondary">
                    ← Tiếp tục tìm kiếm
                </a>
                <a href="#" class="btn btn-primary" onclick="alert('Chức năng đặt món đang phát triển'); return false;">
                    🛒 Đặt món này
                </a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
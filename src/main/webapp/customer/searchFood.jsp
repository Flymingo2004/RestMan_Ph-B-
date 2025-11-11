<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.restman.model.MenuFood" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<MenuFood> foodList = (List<MenuFood>) request.getAttribute("foodList");
    String keyword = (String) request.getAttribute("keyword");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm kiếm món ăn - RestMan</title>
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
            cursor: pointer;
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
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .search-section {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }

        .search-section h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 24px;
        }

        .search-form {
            display: flex;
            gap: 10px;
        }

        .search-input {
            flex: 1;
            padding: 14px 20px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s;
        }

        .search-input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .btn-search {
            padding: 14px 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s;
        }

        .btn-search:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .results-info {
            color: #666;
            margin-top: 15px;
            font-size: 14px;
        }

        .results-info strong {
            color: #667eea;
        }

        .food-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
        }

        .food-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: all 0.3s;
            cursor: pointer;
        }

        .food-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }

        .food-image {
            width: 100%;
            height: 200px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 72px;
        }

        .food-info {
            padding: 20px;
        }

        .food-name {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
            min-height: 48px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .food-price {
            color: #e91e63;
            font-size: 22px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .food-description {
            color: #666;
            font-size: 14px;
            line-height: 1.5;
            min-height: 60px;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            margin-bottom: 10px;
        }

        .food-type-badge {
            display: inline-block;
            background: #f0f0f0;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 12px;
            color: #666;
            font-weight: 500;
        }

        .food-type-badge.combo {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .no-results {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }

        .no-results .icon {
            font-size: 80px;
            margin-bottom: 20px;
        }

        .no-results h3 {
            color: #333;
            margin-bottom: 10px;
            font-size: 24px;
        }

        .no-results p {
            color: #999;
            font-size: 14px;
        }
    </style>
</head>
<body>
<div class="navbar">
    <a href="<%= request.getContextPath() %>/customer/home.jsp" class="navbar-brand">
        <span>🍽️</span>
        <span>RestMan - Nhà Hàng Phở Bò</span>
    </a>
    <a href="<%= request.getContextPath() %>/customer/home.jsp" class="btn-back">← Quay lại trang chủ</a>
</div>

<div class="container">
    <div class="search-section">
        <h2>🔍 Tìm kiếm món ăn</h2>
        <form action="<%= request.getContextPath() %>/searchFood" method="get" class="search-form">
            <input type="text"
                   name="keyword"
                   class="search-input"
                   placeholder="Nhập tên món ăn bạn muốn tìm..."
                   value="<%= keyword != null ? keyword : "" %>"
                   autofocus>
            <button type="submit" class="btn-search">Tìm kiếm</button>
        </form>

        <% if (foodList != null) { %>
        <div class="results-info">
            <% if (keyword != null && !keyword.isEmpty()) { %>
            Tìm thấy <strong><%= foodList.size() %></strong> món ăn với từ khóa "<strong><%= keyword %></strong>"
            <% } else { %>
            Hiển thị tất cả <strong><%= foodList.size() %></strong> món ăn có sẵn
            <% } %>
        </div>
        <% } %>
    </div>

    <% if (foodList != null && !foodList.isEmpty()) { %>
    <div class="food-grid">
        <% for (MenuFood food : foodList) { %>
        <div class="food-card" onclick="location.href='<%= request.getContextPath() %>/foodDetail?id=<%= food.getId() %>'">
            <div class="food-image">
                <% if ("combo".equals(food.getType())) { %>
                🍱
                <% } else { %>
                🍽️
                <% } %>
            </div>
            <div class="food-info">
                <div class="food-name"><%= food.getName() %></div>
                <div class="food-price"><%= food.getFormattedPrice() %></div>
                <div class="food-description">
                    <%= food.getDescription() != null ? food.getDescription() : "Món ăn ngon, chất lượng cao" %>
                </div>
                <span class="food-type-badge <%= food.getType() %>">
                                <%= "combo".equals(food.getType()) ? "Combo" : "Món đơn" %>
                            </span>
            </div>
        </div>
        <% } %>
    </div>
    <% } else { %>
    <div class="no-results">
        <div class="icon">😔</div>
        <h3>Không tìm thấy món ăn nào</h3>
        <p>Vui lòng thử tìm kiếm với từ khóa khác</p>
    </div>
    <% } %>
</div>
</body>
</html>
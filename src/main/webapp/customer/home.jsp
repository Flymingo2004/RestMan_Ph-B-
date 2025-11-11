<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Kiểm tra session
    if (session.getAttribute("user") == null) {
        response.sendRedirect("../login");
        return;
    }

    String role = (String) session.getAttribute("role");
    if (!"customer".equals(role)) {
        response.sendRedirect("../login");
        return;
    }

    String fullName = (String) session.getAttribute("fullName");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - RestMan</title>
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
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .role-badge {
            background: rgba(255,255,255,0.2);
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 12px;
        }

        .btn-logout {
            background: rgba(255,255,255,0.2);
            color: white;
            border: 1px solid rgba(255,255,255,0.5);
            padding: 8px 20px;
            border-radius: 20px;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s;
        }

        .btn-logout:hover {
            background: rgba(255,255,255,0.3);
        }

        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .welcome-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 50px 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-bottom: 40px;
            text-align: center;
        }

        .welcome-section h1 {
            font-size: 36px;
            margin-bottom: 15px;
        }

        .welcome-section p {
            font-size: 18px;
            opacity: 0.9;
        }

        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
        }

        .menu-card {
            background: white;
            padding: 40px 35px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            border: 2px solid transparent;
        }

        .menu-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            border-color: #667eea;
        }

        .menu-card .icon {
            font-size: 64px;
            margin-bottom: 20px;
            display: inline-block;
            transition: transform 0.3s;
        }

        .menu-card:hover .icon {
            transform: scale(1.15) rotate(5deg);
        }

        .menu-card h3 {
            color: #333;
            margin-bottom: 12px;
            font-size: 22px;
        }

        .menu-card p {
            color: #666;
            font-size: 14px;
            line-height: 1.6;
        }

        .featured-tag {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 11px;
            font-weight: 600;
            display: inline-block;
            margin-top: 12px;
        }
    </style>
</head>
<body>
<div class="navbar">
    <div class="navbar-brand">
        <span>🍽️</span>
        <span>RestMan - Nhà Hàng Phở Bò</span>
    </div>
    <div class="user-info">
        <span class="role-badge">KHÁCH HÀNG</span>
        <span>👤 <%= fullName %></span>
        <a href="../logout" class="btn-logout">Đăng xuất</a>
    </div>
</div>

<div class="container">
    <div class="welcome-section">
        <h1>Chào mừng <%= fullName %>!</h1>
        <p>Khám phá thực đơn và đặt món yêu thích của bạn</p>
    </div>

    <div class="menu-grid">
        <div class="menu-card" onclick="location.href='../searchFood'">
            <div class="icon">🔍</div>
            <h3>Tìm kiếm món ăn</h3>
            <p>Tìm kiếm và xem chi tiết các món ăn trong thực đơn</p>
            <span class="featured-tag">Chức năng chính</span>
        </div>

        </div>
    </div>
</div>
</body>
</html>
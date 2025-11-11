<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.restman.model.Table" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String role = (String) session.getAttribute("role");
    if (!"salestaff".equals(role) && !"manager".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<Table> tables = (List<Table>) request.getAttribute("tables");
    String customerName = (String) request.getAttribute("customerName");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm bàn thanh toán - RestMan</title>
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
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
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
            max-width: 1000px;
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
            display: flex;
            align-items: center;
            gap: 10px;
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
            border-color: #ff6b6b;
            box-shadow: 0 0 0 3px rgba(255, 107, 107, 0.1);
        }

        .btn-search {
            padding: 14px 30px;
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
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
            box-shadow: 0 5px 15px rgba(255, 107, 107, 0.4);
        }

        .results-info {
            color: #666;
            margin-top: 15px;
            font-size: 14px;
        }

        .results-info strong {
            color: #ff6b6b;
        }

        .instruction {
            background: #e3f2fd;
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            color: #1976d2;
            font-size: 14px;
            border-left: 4px solid #1976d2;
        }

        .table-list {
            display: grid;
            gap: 20px;
        }

        .table-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
            transition: all 0.3s;
            cursor: pointer;
            border: 2px solid transparent;
        }

        .table-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
            border-color: #ff6b6b;
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .table-number {
            font-size: 28px;
            font-weight: 700;
            color: #ff6b6b;
        }

        .table-status {
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .table-status.occupied {
            background: #fff3cd;
            color: #856404;
        }

        .table-info {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }

        .info-item {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .info-label {
            color: #999;
            font-size: 12px;
            text-transform: uppercase;
            font-weight: 600;
        }

        .info-value {
            color: #333;
            font-size: 16px;
            font-weight: 500;
        }

        .btn-view-receipt {
            margin-top: 15px;
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-view-receipt:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 107, 107, 0.4);
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
    <a href="<%= request.getContextPath() %>/staff/home.jsp" class="navbar-brand">
        <span>💼</span>
        <span>RestMan Staff</span>
    </a>
    <a href="<%= request.getContextPath() %>/staff/home.jsp" class="btn-back">← Quay lại trang chủ</a>
</div>

<div class="container">
    <div class="search-section">
        <h2>🔍 Tìm bàn thanh toán</h2>

        <div class="instruction">
            <strong>Hướng dẫn:</strong> Nhập tên khách hàng đã đặt để tìm bàn cần thanh toán
        </div>

        <form action="<%= request.getContextPath() %>/searchTable" method="get" class="search-form">
            <input type="text"
                   name="customerName"
                   class="search-input"
                   placeholder="Nhập tên khách hàng..."
                   value="<%= customerName != null ? customerName : "" %>"
                   required
                   autofocus>
            <button type="submit" class="btn-search">Tìm kiếm</button>
        </form>

        <% if (tables != null) { %>
        <div class="results-info">
            Tìm thấy <strong><%= tables.size() %></strong> bàn với tên khách hàng "<strong><%= customerName %></strong>"
        </div>
        <% } %>
    </div>

    <% if (tables != null) { %>
    <% if (!tables.isEmpty()) { %>
    <div class="table-list">
        <% for (Table table : tables) { %>
        <div class="table-card" onclick="location.href='<%= request.getContextPath() %>/viewReceipt?tableId=<%= table.getId() %>'">
            <div class="table-header">
                <div class="table-number">Bàn <%= table.getTableNumber() %></div>
                <div class="table-status occupied">Đang phục vụ</div>
            </div>

            <div class="table-info">
                <div class="info-item">
                    <div class="info-label">Tên khách hàng</div>
                    <div class="info-value">👤 <%= table.getCustomerName() %></div>
                </div>

                <div class="info-item">
                    <div class="info-label">Số chỗ ngồi</div>
                    <div class="info-value">🪑 <%= table.getSeatCapacity() %> người</div>
                </div>
            </div>

            <button class="btn-view-receipt" type="button">
                Xem hóa đơn và thanh toán →
            </button>
        </div>
        <% } %>
    </div>
    <% } else { %>
    <div class="no-results">
        <div class="icon">🔍</div>
        <h3>Không tìm thấy bàn nào</h3>
        <p>Không có bàn nào với tên khách hàng "<%= customerName %>"</p>
        <p style="margin-top: 5px;">Vui lòng kiểm tra lại tên khách hàng</p>
    </div>
    <% } %>
    <% } else { %>
    <div class="no-results">
        <div class="icon">💳</div>
        <h3>Tìm kiếm bàn thanh toán</h3>
        <p>Nhập tên khách hàng vào ô tìm kiếm bên trên để bắt đầu</p>
    </div>
    <% } %>
</div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.restman.model.Receipt" %>
<%@ page import="com.restman.model.ReceiptDetail" %>
<%@ page import="com.restman.model.Table" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    Receipt receipt = (Receipt) request.getAttribute("receipt");
    List<ReceiptDetail> details = (List<ReceiptDetail>) request.getAttribute("receiptDetails");
    Table table = (Table) request.getAttribute("table");

    if (receipt == null || details == null) {
        response.sendRedirect(request.getContextPath() + "/searchTable");
        return;
    }

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hóa đơn #<%= receipt.getId() %> - RestMan</title>
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

        .receipt-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .receipt-header {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }

        .receipt-header h1 {
            font-size: 28px;
            margin-bottom: 10px;
        }

        .receipt-header p {
            opacity: 0.9;
            font-size: 14px;
        }

        .receipt-info {
            padding: 30px;
            border-bottom: 2px dashed #e0e0e0;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
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

        .receipt-details {
            padding: 30px;
        }

        .details-title {
            color: #333;
            font-size: 20px;
            margin-bottom: 20px;
            font-weight: 600;
        }

        .details-table {
            width: 100%;
            border-collapse: collapse;
        }

        .details-table th {
            background: #f8f9fa;
            padding: 12px;
            text-align: left;
            font-size: 13px;
            color: #666;
            font-weight: 600;
            border-bottom: 2px solid #e0e0e0;
        }

        .details-table td {
            padding: 15px 12px;
            border-bottom: 1px solid #f0f0f0;
            color: #333;
        }

        .details-table tr:hover {
            background: #fafafa;
        }

        .food-name {
            font-weight: 500;
        }

        .food-type {
            display: inline-block;
            background: #e3f2fd;
            color: #1976d2;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 11px;
            margin-left: 5px;
        }

        .quantity {
            text-align: center;
            font-weight: 600;
            color: #ff6b6b;
        }

        .price {
            text-align: right;
            font-weight: 500;
        }

        .total-price {
            font-weight: 600;
            color: #ff6b6b;
        }

        .receipt-summary {
            padding: 30px;
            background: #f8f9fa;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            font-size: 16px;
        }

        .summary-row.subtotal {
            color: #666;
        }

        .summary-row.discount {
            color: #4caf50;
        }

        .summary-row.total {
            border-top: 2px solid #e0e0e0;
            margin-top: 10px;
            padding-top: 20px;
            font-size: 24px;
            font-weight: 700;
            color: #ff6b6b;
        }

        .payment-section {
            padding: 30px;
        }

        .payment-methods {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
            margin-bottom: 20px;
        }

        .payment-method {
            padding: 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }

        .payment-method:hover {
            border-color: #ff6b6b;
            background: #fff5f5;
        }

        .payment-method.selected {
            border-color: #ff6b6b;
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
            color: white;
        }

        .payment-method input[type="radio"] {
            display: none;
        }

        .payment-method .icon {
            font-size: 32px;
            margin-bottom: 8px;
        }

        .payment-method .label {
            font-size: 14px;
            font-weight: 600;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
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
        }

        .btn-confirm {
            background: linear-gradient(135deg, #4caf50 0%, #66bb6a 100%);
            color: white;
        }

        .btn-confirm:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(76, 175, 80, 0.4);
        }

        .btn-print {
            background: linear-gradient(135deg, #2196f3 0%, #42a5f5 100%);
            color: white;
        }

        .btn-print:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(33, 150, 243, 0.4);
        }

        @media print {
            .navbar, .payment-section, .btn-back {
                display: none !important;
            }

            .container {
                margin: 0;
                max-width: 100%;
            }

            .receipt-card {
                box-shadow: none;
            }
        }
    </style>
</head>
<body>
<div class="navbar">
    <a href="<%= request.getContextPath() %>/staff/home.jsp" class="navbar-brand">
        <span>💼</span>
        <span>RestMan Staff</span>
    </a>
    <a href="<%= request.getContextPath() %>/searchTable" class="btn-back">← Quay lại tìm kiếm</a>
</div>

<div class="container">
    <div class="receipt-card">
        <div class="receipt-header">
            <h1>🧾 HÓA ĐƠN #<%= receipt.getId() %></h1>
            <p>RestMan - Nhà Hàng Phở Bò</p>
        </div>

        <div class="receipt-info">
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Bàn số</div>
                    <div class="info-value">🪑 <%= receipt.getTableNumber() %></div>
                </div>

                <div class="info-item">
                    <div class="info-label">Khách hàng</div>
                    <div class="info-value">👤 <%= receipt.getCustomerName() != null ? receipt.getCustomerName() : "Khách lẻ" %></div>
                </div>

                <div class="info-item">
                    <div class="info-label">Ngày giờ</div>
                    <div class="info-value">📅 <%= sdf.format(receipt.getReceiptDate()) %></div>
                </div>

                <div class="info-item">
                    <div class="info-label">Nhân viên phục vụ</div>
                    <div class="info-value">💼 <%= receipt.getStaffName() %></div>
                </div>
            </div>
        </div>

        <div class="receipt-details">
            <h3 class="details-title">Chi tiết món ăn</h3>
            <table class="details-table">
                <thead>
                <tr>
                    <th style="width: 50%;">Tên món</th>
                    <th style="width: 15%; text-align: center;">SL</th>
                    <th style="width: 17%; text-align: right;">Đơn giá</th>
                    <th style="width: 18%; text-align: right;">Thành tiền</th>
                </tr>
                </thead>
                <tbody>
                <% for (ReceiptDetail detail : details) { %>
                <tr>
                    <td>
                        <span class="food-name"><%= detail.getFoodName() %></span>
                        <span class="food-type"><%= "combo".equals(detail.getFoodType()) ? "Combo" : "Món đơn" %></span>
                    </td>
                    <td class="quantity"><%= detail.getQuantity() %></td>
                    <td class="price"><%= detail.getFormattedUnitPrice() %></td>
                    <td class="price total-price"><%= detail.getFormattedTotalPrice() %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <div class="receipt-summary">
            <div class="summary-row subtotal">
                <span>Tổng cộng:</span>
                <span><%= receipt.getFormattedTotalAmount() %></span>
            </div>

            <% if (receipt.getDiscountAmount() > 0) { %>
            <div class="summary-row discount">
                <span>Giảm giá:</span>
                <span>- <%= receipt.getFormattedDiscountAmount() %></span>
            </div>
            <% } %>

            <div class="summary-row total">
                <span>TỔNG THANH TOÁN:</span>
                <span><%= receipt.getFormattedFinalAmount() %></span>
            </div>
        </div>

        <div class="payment-section">
            <h3 class="details-title">Phương thức thanh toán</h3>

            <form action="<%= request.getContextPath() %>/payment" method="post" id="paymentForm">
                <input type="hidden" name="receiptId" value="<%= receipt.getId() %>">
                <input type="hidden" name="tableId" value="<%= receipt.getTableId() %>">

                <div class="payment-methods">
                    <label class="payment-method selected">
                        <input type="radio" name="paymentMethod" value="cash" checked>
                        <div class="icon">💵</div>
                        <div class="label">Tiền mặt</div>
                    </label>

                    <label class="payment-method">
                        <input type="radio" name="paymentMethod" value="card">
                        <div class="icon">💳</div>
                        <div class="label">Thẻ</div>
                    </label>

                    <label class="payment-method">
                        <input type="radio" name="paymentMethod" value="transfer">
                        <div class="icon">📱</div>
                        <div class="label">Chuyển khoản</div>
                    </label>
                </div>

                <div class="action-buttons">
                    <button type="submit" class="btn btn-confirm">
                        ✓ Xác nhận thanh toán
                    </button>
                    <button type="button" class="btn btn-print" onclick="window.print()">
                        🖨️ In hóa đơn
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Xử lý chọn phương thức thanh toán
    document.querySelectorAll('.payment-method').forEach(method => {
        method.addEventListener('click', function() {
            document.querySelectorAll('.payment-method').forEach(m => m.classList.remove('selected'));
            this.classList.add('selected');
            this.querySelector('input[type="radio"]').checked = true;
        });
    });

    // Xác nhận trước khi thanh toán
    document.getElementById('paymentForm').addEventListener('submit', function(e) {
        if (!confirm('Xác nhận thanh toán hóa đơn này?')) {
            e.preventDefault();
        }
    });
</script>
</body>
</html>
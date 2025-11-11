package com.restman.servlet;

import com.restman.dao.ReceiptDAO;
import com.restman.dao.TableDAO;
import com.restman.model.Receipt;
import com.restman.model.ReceiptDetail;
import com.restman.model.Table;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/viewReceipt")
public class ViewReceiptServlet extends HttpServlet {
    private ReceiptDAO receiptDAO;
    private TableDAO tableDAO;

    @Override
    public void init() {
        receiptDAO = new ReceiptDAO();
        tableDAO = new TableDAO();
        System.out.println("✅ ViewReceiptServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Kiểm tra session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("❌ Unauthorized access to viewReceipt");
            response.sendRedirect("login");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!"salestaff".equals(role) && !"manager".equals(role)) {
            System.out.println("❌ Access denied - Role: " + role);
            response.sendRedirect("login");
            return;
        }

        String tableIdParam = request.getParameter("tableId");

        if (tableIdParam != null && !tableIdParam.trim().isEmpty()) {
            try {
                int tableId = Integer.parseInt(tableIdParam.trim());
                System.out.println("🔍 Viewing receipt for table ID: " + tableId);

                // Lấy thông tin bàn
                Table table = tableDAO.getTableById(tableId);

                // Lấy hóa đơn chưa thanh toán
                Receipt receipt = receiptDAO.getPendingReceiptByTableId(tableId);

                if (receipt != null) {
                    // Lấy chi tiết món ăn
                    List<ReceiptDetail> details = receiptDAO.getReceiptDetails(receipt.getId());

                    request.setAttribute("table", table);
                    request.setAttribute("receipt", receipt);
                    request.setAttribute("receiptDetails", details);
                    request.getRequestDispatcher("/staff/viewReceipt.jsp").forward(request, response);
                } else {
                    System.out.println("❌ No pending receipt found for table ID: " + tableId);
                    request.setAttribute("errorMessage", "Không tìm thấy hóa đơn cho bàn này");
                    request.getRequestDispatcher("searchTable").forward(request, response);
                }
            } catch (NumberFormatException e) {
                System.out.println("❌ Invalid table ID format: " + tableIdParam);
                response.sendRedirect("searchTable");
            }
        } else {
            System.out.println("❌ Missing table ID parameter");
            response.sendRedirect("searchTable");
        }
    }
}
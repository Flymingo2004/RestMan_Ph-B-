package servlet;

import com.restman.dao.ReceiptDAO;
import com.restman.dao.TableDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    private ReceiptDAO receiptDAO;
    private TableDAO tableDAO;

    @Override
    public void init() {
        receiptDAO = new ReceiptDAO();
        tableDAO = new TableDAO();
        System.out.println("✅ PaymentServlet initialized");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Kiểm tra session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("❌ Unauthorized access to payment");
            response.sendRedirect("login");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!"salestaff".equals(role) && !"manager".equals(role)) {
            System.out.println("❌ Access denied - Role: " + role);
            response.sendRedirect("login");
            return;
        }

        String receiptIdParam = request.getParameter("receiptId");
        String tableIdParam = request.getParameter("tableId");
        String paymentMethod = request.getParameter("paymentMethod");

        if (receiptIdParam != null && tableIdParam != null && paymentMethod != null) {
            try {
                int receiptId = Integer.parseInt(receiptIdParam.trim());
                int tableId = Integer.parseInt(tableIdParam.trim());

                System.out.println("💳 Processing payment - Receipt: " + receiptId + ", Table: " + tableId + ", Method: " + paymentMethod);

                // Cập nhật hóa đơn thành đã thanh toán
                boolean receiptUpdated = receiptDAO.updateReceiptToPaid(receiptId, paymentMethod);

                // Cập nhật trạng thái bàn thành trống
                boolean tableUpdated = tableDAO.updateTableStatus(tableId, "empty");

                if (receiptUpdated && tableUpdated) {
                    System.out.println("✅ Payment successful!");
                    request.setAttribute("successMessage", "Thanh toán thành công!");
                    request.setAttribute("receiptId", receiptId);
                    request.getRequestDispatcher("/staff/paymentSuccess.jsp").forward(request, response);
                } else {
                    System.out.println("❌ Payment failed!");
                    request.setAttribute("errorMessage", "Có lỗi xảy ra khi thanh toán");
                    response.sendRedirect("searchTable");
                }
            } catch (NumberFormatException e) {
                System.out.println("❌ Invalid ID format");
                response.sendRedirect("searchTable");
            }
        } else {
            System.out.println("❌ Missing payment parameters");
            response.sendRedirect("searchTable");
        }
    }
}
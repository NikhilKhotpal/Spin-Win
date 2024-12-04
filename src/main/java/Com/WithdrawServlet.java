package Com;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class WithdrawServlet
 */
@WebServlet("/WithdrawServlet")
public class WithdrawServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public WithdrawServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
		 String jdbcUrl = "jdbc:mysql://localhost:3306/spin";
	        String dbUser = "root";
	        String dbPassword = "";
	        
	        String amountParam = request.getParameter("amount");
	        double amountToWithdraw = 0;

	        // Check if the amount parameter is not null and is a valid number
	        if (amountParam != null && !amountParam.isEmpty()) {
	            try {
	                amountToWithdraw = Double.parseDouble(amountParam);
	            } catch (NumberFormatException e) {
	                response.setContentType("application/json");
	                PrintWriter out = response.getWriter();
	                out.print("{\"success\": false, \"message\": \"Invalid amount format.\"}");
	                return; // Exit the method if the amount is invalid
	            }
	        } else {
	            response.setContentType("application/json");
	            PrintWriter out = response.getWriter();
	            out.print("{\"success\": false, \"message\": \"Amount cannot be null or empty.\"}");
	            return; // Exit the method if amount is null
	        }

	        String userId = (String) request.getSession().getAttribute("userId"); // Assuming userId is stored in session

	        // Check user's current balance
	        try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword)) {
	            String checkBalanceSql = "SELECT withdraw_amount FROM users1 WHERE id = ?";
	            PreparedStatement checkStmt = conn.prepareStatement(checkBalanceSql);
	            checkStmt.setString(1, userId);
	            ResultSet rs = checkStmt.executeQuery();

	            if (rs.next()) {
	                double currentBalance = rs.getDouble("withdraw_amount");
	                if (currentBalance >= amountToWithdraw) {
	                    // Update the user's balance
	                    String updateSql = "UPDATE users1 SET withdraw_amount = withdraw_amount - ? WHERE id = ?";
	                    PreparedStatement updateStmt = conn.prepareStatement(updateSql);
	                    updateStmt.setDouble(1, amountToWithdraw);
	                    updateStmt.setString(2, userId);
	                    
	                    int rowsAffected = updateStmt.executeUpdate();
	                    response.setContentType("application/json");
	                    PrintWriter out = response.getWriter();

	                    if (rowsAffected > 0) {
	                        out.print("{\"success\": true}");
	                    } else {
	                        out.print("{\"success\": false, \"message\": \"Withdrawal failed.\"}");
	                    }
	                } else {
	                    response.setContentType("application/json");
	                    PrintWriter out = response.getWriter();
	                    out.print("{\"success\": false, \"message\": \"Insufficient balance.\"}");
	                }
	            } else {
	                response.setContentType("application/json");
	                PrintWriter out = response.getWriter();
	                out.print("{\"success\": false, \"message\": \"User not found.\"}");
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	            response.setContentType("application/json");
	            PrintWriter out = response.getWriter();
	            out.print("{\"success\": false, \"message\": \"An error occurred while processing your request.\"}");
	        }
	    }
	}

package Com;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class userservlet
 */
@WebServlet("/Spin")
public class userservlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public userservlet() {
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
		String phone = request.getParameter("phone");
	    int wonAmount = Integer.parseInt(request.getParameter("wonAmount"));
	    int bonusAmount = Integer.parseInt(request.getParameter("bonusAmount"));
	    int withdrawAmount = Integer.parseInt(request.getParameter("withdrawAmount"));

	    Connection con = null;
	    PreparedStatement stmt = null;
	    
	    try {
	        Class.forName("com.mysql.jdbc.Driver");
	        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/spin", "root", "");

	        // Update the user's bonus and withdraw amounts in the database
	        String updateSql = "UPDATE users1 SET bonus_amount = ?, withdraw_amount = ? WHERE phone = ?";
	        stmt = con.prepareStatement(updateSql);
	        stmt.setInt(1, bonusAmount);
	        stmt.setInt(2, withdrawAmount);
	        stmt.setString(3, phone);

	        int rowsUpdated = stmt.executeUpdate();
	        if (rowsUpdated > 0) {
	            response.getWriter().write("Success");
	        } else {
	            response.getWriter().write("Error: No rows affected");
	        }

	    } catch (Exception ex) {
	        ex.printStackTrace();
	        response.getWriter().write("Error: " + ex.getMessage());
	    } 
	}
}
	        


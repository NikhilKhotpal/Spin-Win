package Com;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;



/**
 * Servlet implementation class UpdateSpin
 */
@WebServlet("/UpdateSpin")
public class UpdateSpin extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateSpin() {
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
		String id = request.getParameter("id");
        String fname = request.getParameter("fname");
        String phone = request.getParameter("phone");

        // Validate that all required fields are provided
        if (id == null || fname == null || phone == null || id.isEmpty() || fname.isEmpty() || phone.isEmpty()) {
            response.getWriter().println("All fields are required!");
            return;
        }

        // Database connection details
        String dbURL = "jdbc:mysql://localhost:3306/spin";
        String dbUser = "root";
        String dbPass = "";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Load the MySQL driver
            Class.forName("com.mysql.jdbc.Driver");
            
            // Establish a connection
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            
            // SQL query to update the user's information
            String sql = "UPDATE reguser SET fname = ?, contact = ? WHERE id = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, fname);   // Set the fname
            pstmt.setString(2, phone);   // Set the phone
            pstmt.setString(3, id);      // Set the id

            // Execute the update
            int rowsUpdated = pstmt.executeUpdate();
            
            if (rowsUpdated > 0) {
                // Redirect or provide feedback to the user after successful update
                response.getWriter().println("Profile updated successfully!");
            } else {
                // If the update failed
                response.getWriter().println("Failed to update profile. Please try again.");
            }
            
        } catch (Exception ex) {
            // Handle any errors that occur
            ex.printStackTrace();
            response.getWriter().println("Error: " + ex.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
	}


